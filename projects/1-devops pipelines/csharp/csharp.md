 <p>As a DevOps Engineer, my job was to automate the application testing, pre-production staging, and production environment deployments.</p>

```yaml
name: CI/CD Pipeline

on: [push]

jobs:

build-test-deploy:
  # specify the runner machine to use
  runs-on: ubuntu-latest
  # specify the steps to run

steps:
  # checkout the code from the repository
  - name: Checkout code
    uses: actions/checkout@v2

  # setup dotnet environment on the runner machine
  - name: Setup dotnet
    uses: actions/setup-dotnet@v1
    with:
      dotnet-version: '5.0.x'

  # build and publish the project using dotnet command
  - name: Build and publish
    run: dotnet publish -c Release -o output

  # upload the output folder as an artifact for later use
  - name: Upload artifact
    uses: actions/upload-artifact@v2
    with:
      name: output
      path: output

  # run unit tests using MSTest framework
  - name: Run tests
    run: dotnet test --logger "trx;LogFileName=test-results.xml"

  # upload test results file as an artifact for later use
  - name: Upload test results
    uses: actions/upload-artifact@v2
    with:
      name: test-results
      path: test-results.xml

  # display test results using dorny/test-reporter action
  - name: Display test results
    uses: dorny/test-reporter@v1
    with:
      name: Unit Tests
      path: test-results.xml
      reporter: dotnet-trx

steps:
  # install and configure NUnit console runner using dotnet tool command
  - name: Install NUnit console runner
    run: dotnet tool install --global nunit.consolerunner

  # run integration tests using NUnit console runner and generate test results file in XML format
  - name: Run integration tests
    run: nunit3-console --result=integration-test-results.xml MyProject.IntegrationTests.dll

  # upload integration test results file as an artifact for later use
  - name: Upload integration test results
    uses: actions/upload-artifact@v2
    with:
      name: integration-test-results
      path: integration-test-results.xml

  # display integration test results using dorny/test-reporter action
  - name: Display integration test results
    uses: dorny/test-reporter@v1
    with:
      name: Integration Tests
      path: integration-test-results.xml
      reporter: nunit

  # install and configure JMeter using setup-jmeter action
  - name: Install JMeter
    uses: jmeter-maven-plugin/setup-jmeter@v1

  # run performance tests using JMeter and generate test results file in CSV format
  - name: Run performance tests
    run: jmeter -n -t MyProject.PerformanceTests.jmx -l performance-test-results.csv

  # upload performance test results file as an artifact for later use
  - name: Upload performance test results
    uses: actions/upload-artifact@v2
    with:
      name: performance-test-results
      path: performance-test-results.csv

  # display performance test results using custom script (not shown here)
  - name: Display performance test results
    run: ./display-performance-test-results.sh

  # install and configure OWASP ZAP using zaproxy/action-full-scan action
  - name: Install OWASP ZAP
    uses: zaproxy/action-full-scan@v0.4.0

  # run security tests using OWASP ZAP and generate test results file in HTML format
  - name: Run security tests
    run: docker exec zap-full-scan zap-full-scan.py -t https://my-project-url.com -r security-test-results.html

  # upload security test results file as an artifact for later use
  - name: Upload security test results
    uses: actions/upload-artifact@v2
    with:
      name: security-test-results
      path: security-test-results.html

  # display security test results using custom script (not shown here)
  - name: Display security test results
    run: ./display-security-test-results.sh

steps:
  # scan your code with SonarQube using sonarsource/sonarqube-scan-action action
  - name: Scan with SonarQube
    uses: sonarsource/sonarqube-scan-action@v1.0.0
    with:
      # specify the host URL of your SonarQube instance as a secret
      host: ${{ secrets.SONARQUBE_HOST }}
      # specify the login token of your SonarQube instance as a secret
      login: ${{ secrets.SONARQUBE_TOKEN }}
      # specify any additional parameters for sonar-scanner command
      args: >
        -Dsonar.projectKey=my-project-key
        -Dsonar.sources=.

  # scan your code with CodeQL using github/codeql-action action
  - name: Scan with CodeQL
    uses: github/codeql-action/init@v1
    with:
      # specify the languages to analyze (csharp, cpp, go, java, javascript, python)
      languages: csharp

  # run codeql analysis after building your project
  - name: Analyze with CodeQL
    uses: github/codeql-action/analyze@v1

  # measure your code coverage with Coverlet using coverlet-coverage/coverlet-action action
  - name: Measure coverage with Coverlet
    uses: coverlet-coverage/coverlet-action@v1.0.2
    with:
      # specify the path to your test project file (.csproj)
      test-project-path: MyProject.Tests.csproj
      # specify any additional parameters for dotnet test command
      dotnet-test-params: --configuration Release --no-build --verbosity normal

steps:
  # format your code with dotnet format tool using dotnet/format action
  - name: Format code
    uses: dotnet/format@v1
    with:
      # specify the path to your solution file (.sln)
      folder-or-solution: MyProject.sln

  # analyze your code with Roslyn analyzers using dotnet/roslyn-analyzers action
  - name: Analyze code
    uses: dotnet/roslyn-analyzers@v1.0.0-rc1.21430.3
    with:
      # specify any additional parameters for dotnet build command
      dotnet-build-params: --configuration Release

  # check your code with PVS-Studio static analyzer using PVS-Studio-Team/PVS-Studio-action action
  - name: Check code
    uses: PVS-Studio-Team/PVS-Studio-action@v1.0.0-beta2
    with:
      # specify the path to your solution file (.sln)
      solution-path: MyProject.sln
      # specify any additional parameters for pvs-studio-analyzer command
      analyzer-options: --analysis-mode=4 --output-file=pvs-studio-report.log

steps:
  # cache NuGet packages using actions/cache
  - name: Cache NuGet packages
    uses: actions/cache@v2
    with:
      # use packages.lock.json file or *.csproj files as cache key
      key: ${{ runner.os }}-nuget-${{ hashFiles('**/packages.lock.json') }}
      restore-keys: |
        ${{ runner.os }}-nuget-
      # specify the path to the NuGet packages folder
      path: |
        ~\AppData\Local\NuGet\v3-cache
        ~/.nuget/packages

steps:
  # ...
  # deploy the new version of the software if all tests are successful
  - name: Deploy to Azure
    if: success()
    # download the output folder from the previous steps
    - name: Download artifact
      uses: actions/download-artifact@v2
      with:
        name: output
        path: output

    # deploy the output folder to an Azure Web App using azure/webapps-deploy action
    - name: Deploy to Azure Web App
      uses: azure/webapps-deploy@v2
      with:
        app-name: 'your-web-app-name'
        slot-name: 'production'
        publish-profile: ${{ secrets.AZURE_WEBAPP_PUBLISH_PROFILE }}

steps:
  # generate markdown documentation from shell scripts using vargiuscuola/generate-docs action
  - name: Generate docs
    uses: vargiuscuola/generate-docs@v1
    with:
      # specify the input directory containing the shell scripts
      input_dir: scripts
      # specify the output directory for the generated markdown files
      output_dir: docs

  # publish documentation to GitHub Pages using peaceiris/actions-gh-pages action
  - name: Publish docs
    uses: peaceiris/ac*tions-gh-pages@v3
    with:
      # specify the personal access token with repo scope as a secret
      github_token: ${{ secrets.GITHUB_TOKEN }}
      # specify the branch name for GitHub Pages
      publish_branch: gh-pages
      # specify the directory containing the documentation files
      publish_dir: docs
```