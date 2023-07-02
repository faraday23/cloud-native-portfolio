  <h1>Task:</h1>
  <p>My task was to write a Dockerfile that would build, test, and run the .NET web application using the appropriate base images, dependencies, and settings.</p>

  ```yaml
- name: InstallCommonTools.sh
  id: install_common_tools
  shell: bash
  run: |
    # fix for locale being incorrect causing date/time default formatting
    # DKL-DI-0005 - Clear apt-get caches
    apt-get update && apt-get install -y locales tzdata && rm -rf /var/lib/apt/lists
    # Set the locale
    sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8

- name: ⛏️ Build / Run unit tests and check coverage
  id: testing
  shell: bash
  run: |
    # Sets build directory
    build_path="$GITHUB_WORKSPACE/app_test"
    # Makes Dotnet tools available to the system
    export PATH="$PATH:/github/home/.dotnet/tools"
    if [[ "${{ inputs.lifecycle_environment }}" =~ ^stage|ctcert|production|ctest|sandbox$ ]] && [ "${{ env.skip_testing }}" = "true" ]; then
      skipcoverlet=true
    fi
    # Installs the coverlet console library.
    if [ -z "$skipcoverlet" ]; then
      dotnet tool install --global coverlet.console --version ${{ inputs.coverlet_version }}
    fi
    dotnet new nugetconfig --force
    dotnet nuget add source ${{ env.NUGET_SERVER_URL }} --name JfrogNugetServer --configfile ./nuget.config -u ${{ inputs.jfrog_ro_username }} -p ${{ steps.vault.outputs.JFROG_RO_BEARER_TOKEN }}
    dotnet build -c Debug -o $build_path
    if [ -z "$skipcoverlet" ]; then
      # Enforce the minimum unit test coverage
      coverlet "$build_path/${{ needs.prepare.outputs.component_name }}.Test.dll" --target="dotnet" --targetargs="test --no-build --output $build_path" --threshold="${{ inputs.minimum_code_coverage }}" --threshold-type=line --threshold-type=method
    fi

- name: 🐋 Write Dockerfile
  id: write-dockerfile
  shell: bash
  run: |
    cat << EOF > Dockerfile
    
    FROM ${{ inputs.jfrog_server }}/${{ inputs.jfrog_tool_repository }}/dotnet-sdk:${{ inputs.dotnet_sdk_container_version }} AS build
    WORKDIR /src
    COPY *.sln .
    RUN dotnet new nugetconfig --force
    RUN dotnet nuget add source ${{ env.NUGET_SERVER_URL }} --name JfrogNugetServer --configfile ./nuget.config -u ${{ inputs.jfrog_ro_username }} -p ${{ steps.vault.outputs.JFROG_RO_BEARER_TOKEN }} --store-password-in-clear-text
    \$$(find . -name '*.csproj' | perl -ne 'chomp();print qq(COPY ["\$_", "\$_"]\\n)')
    RUN dotnet restore
    COPY . .
    RUN dotnet build -c Release -o /app --no-restore

    FROM build AS publish
    RUN dotnet publish -c Release -o /app --no-restore

    FROM ${{ inputs.jfrog_server }}/${{ inputs.jfrog_tool_repository }}/dotnet-runtime:${{ inputs.dotnet_runtime_container_version }} AS final
    WORKDIR /app
    RUN /bin/bash ../InstallCommonTools.sh
    ENV LANG en_US.UTF-8
    ENV LC_ALL en_US.UTF-8
    ${{ inputs.dockerfile_custom_commands }}
    COPY --from=publish /app .
    ENTRYPOINT ["dotnet", "${{ needs.prepare.outputs.component_name }}.dll"]
    EOF
    cat Dockerfile
```