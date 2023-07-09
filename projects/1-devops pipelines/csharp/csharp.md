<!DOCTYPE html>
<html>

<head>
  <title>CI/CD Pipeline</title>
</head>

<body>
  <h1>As a DevOps Engineer, my job was to automate the application testing, pre-production staging, and production environment deployments.</h1>

  <h2>name: CI/CD Pipeline</h2>

  <h3>on: [push]</h3>

  <h3>jobs:</h3>

  <h4>build-test-deploy:</h4>

  <p># specify the runner machine to use</p>
  <p>runs-on: ubuntu-latest</p>
  <p># specify the steps to run</p>

  <h5>steps:</h5>

  <p># checkout the code from the repository</p>
  <p>- name: Checkout code</p>
  <p>uses: actions/checkout@v2</p>

  <p># setup dotnet environment on the runner machine</p>
  <p>- name: Setup dotnet</p>
  <p>uses: actions/setup-dotnet@v1</p>
  <p>with:</p>
  <p>dotnet-version: '5.0.x'</p>

  <p># build and publish the project using dotnet command</p>
  <p>- name: Build and publish</p>
  <p>run: dotnet publish -c Release -o output</p>

  <p># upload the output folder as an artifact for later use</p>
  <p>- name: Upload artifact</p>
  <p>uses: actions/upload-artifact@v2</p>
  <p>with:</p>
  <p>name: output</p>
  <p>path: output</p>

  <p># run unit tests using MSTest framework</p>
  <p>- name: Run tests</p>
  <p>run: dotnet test --logger "trx;LogFileName=test-results.xml"</p>

  <p># upload test results file as an artifact for later use</p>
  <p>- name: Upload test results</p>
  <p>uses: actions/upload-artifact@v2</p>
  <p>with:</p>
  <p>name: test-results</p>
  <p>path: test-results.xml</p>

  <p># display test results using dorny/test-reporter action</p>
  <p>- name: Display test results</p>
  <p>uses: dorny/test-reporter@v1</p>
  <p>with:</p>
  <p>name: Unit Tests</p>
  <p>path: test-results.xml</p>
  <p>reporter: dotnet-trx</p>

  <h5>steps:</h5>

  <p># install and configure NUnit console runner using dotnet tool command</p>
  <p>- name: Install NUnit console runner</p>
  <p>run: dotnet tool install --global nunit.consolerunner</p>

  <p># run integration tests using NUnit console runner and generate test results file in XML format</p>
  <p>- name: Run integration tests</p>
  <p>run: nunit3-console --result=integration-test-results.xml MyProject.IntegrationTests.dll</p>

  <p># upload integration test results file as an artifact for later use</p>
  <p>- name: Upload integration test results</p>
  <p>uses: actions/upload-artifact@v2</p>
  <p>with:</p>
  <p>name: integration-test-results</p>
  <p>path: integration-test-results.xml</p>

  <p># display integration test results using dorny/test-reporter action</p>
  <p>- name: Display integration test results</p>
  <p>uses: dorny/test-reporter@v1</p>
  <p>with:</p>
  <p>name: Integration Tests</p>
  <p>path: integration-test-results.xml</p>
  <p>reporter: nunit</p>

  <p># install and configure JMeter using setup-jmeter action</p>
  <p>- name: Install JMeter</p>
  <p>uses: jmeter-maven-plugin/setup-jmeter@v1</p>

  <p># run performance tests using JMeter and generate test results file in CSV format</p>
  <p>- name: Run performance tests</p>
  <p>run: jmeter -n -t MyProject.PerformanceTests.jmx -l performance-test-results.csv</p>

  <p># upload performance test results file as an artifact for later use</p>
  <p>- name: Upload performance test results</p>
  <p>uses: actions/upload-artifact@v2</p>
  <p>with:</p>
  <p>name: performance-test-results</p>
  <p>path: performance-test-results.csv</p>

  <p># display performance test results using custom script (not shown here)</p>
  <p>- name: Display performance test results</p>
  <p>run: ./display-performance-test-results.sh</p>

  <p># install and configure OWASP ZAP using zaproxy/action-full-scan action</p>
  <p>- name: Install OWASP ZAP</p>
  <p>uses: zaproxy/action-full-scan@v0.4.0</p>

  <p># run security tests using OWASP ZAP and generate test results file in HTML format</p>
  <p>- name: Run security tests</p>
  <p>run: docker exec zap-full-scan zap-full-scan.py -t https://my-project-url.com -r security-test-results.html</p>

  <p># upload security test results file as an artifact for later use</p>
  <p>- name: Upload security test results</p>
  <p>uses: actions/upload-artifact@v2</p>
  <p>with:</p>
  <p>name: security-test-results</p>
  <p>path: security-test-results.html</p>

  <p># display security test results using custom script (not shown here)</p>
  <p>- name: Display security test results</p>
  <p>run: ./display-security-test-results.sh</p>

  <h5>steps:</h5>

  <p># scan your code with SonarQube using sonarsource/sonarqube-scan-action action</p>
  <p>- name: Scan with SonarQube</p>
  <p>uses: sonarsource/sonarqube-scan-action@v1.0.0</p>
  <p>with:</p>
  <p># specify the host URL of your SonarQube instance as a secret</p>
  <p>host: ${{ secrets.SONARQUBE_HOST }}</p>
  <p># specify the login token of your SonarQube instance as a secret</p>
  <p>login: ${{ secrets.SON

ARQUBE_TOKEN }}</p>
  <p># specify any additional parameters for sonar-scanner command</p>
  <p>args: ></p>
  <p>-Dsonar.projectKey=my-project-key</p>
  <p>-Dsonar.sources=.</p>

  <p># scan your code with CodeQL using github/codeql-action action</p>
  <p>- name: Scan with CodeQL</p>
  <p>uses: github/codeql-action/init@v1</p>
  <p>with:</p>
  <p># specify the languages to analyze (csharp, cpp, go, java, javascript, python)</p>
  <p>languages: csharp</p>

  <p># run codeql analysis after building your project</p>
  <p>- name: Analyze with CodeQL</p>
  <p>uses: github/codeql-action/analyze@v1</p>

  <p># measure your code coverage with Coverlet using coverlet-coverage/coverlet-action action</p>
  <p>- name: Measure coverage with Coverlet</p>
  <p>uses: coverlet-coverage/coverlet-action@v1.0.2</p>
  <p>with:</p>
  <p># specify the path to your test project file (.csproj)</p>
  <p>test-project-path: MyProject.Tests.csproj</p>
  <p># specify any additional parameters for dotnet test command</p>
  <p>dotnet-test-params: --configuration Release --no-build --verbosity normal</p>

  <h5>steps:</h5>

  <p># format your code with dotnet format tool using dotnet/format action</p>
  <p>- name: Format code</p>
  <p>uses: dotnet/format@v1</p>
  <p>with:</p>
  <p># specify the path to your solution file (.sln)</p>
  <p>folder-or-solution: MyProject.sln</p>

  <p># analyze your code with Roslyn analyzers using dotnet/roslyn-analyzers action</p>
  <p>- name: Analyze code</p>
  <p>uses: dotnet/roslyn-analyzers@v1.0.0-rc1.21430.3</p>
  <p>with:</p>
  <p># specify any additional parameters for dotnet build command</p>
  <p>dotnet-build-params: --configuration Release</p>

  <p># check your code with PVS-Studio static analyzer using PVS-Studio-Team/PVS-Studio-action action</p>
  <p>- name: Check code</p>
  <p>uses: PVS-Studio-Team/PVS-Studio-action@v1.0.0-beta2</p>
  <p>with:</p>
  <p># specify the path to your solution file (.sln)</p>
  <p>solution-path: MyProject.sln</p>
  <p># specify any additional parameters for pvs-studio-analyzer command</p>
  <p>analyzer-options: --analysis-mode=4 --output-file=pvs-studio-report.log</p>

  <h5>steps:</h5>

  <p># cache NuGet packages using actions/cache</p>
  <p>- name: Cache NuGet packages</p>
  <p>uses: actions/cache@v2</p>
  <p>with:</p>
  <p># use packages.lock.json file or *.csproj files as cache key</p>
  <p>key: ${{ runner.os }}-nuget-${{ hashFiles('**/packages.lock.json') }}</p>
  <p>restore-keys: |</p>
  <p>${{ runner.os }}-nuget-</p>
  <p># specify the path to the NuGet packages folder</p>
  <p>path: |</p>
  <p>~\AppData\Local\NuGet\v3-cache</p>
  <p>~/.nuget/packages</p>

  <h5>steps:</h5>

  <p># ...</p>
  <p># deploy the new version of the software if all tests are successful</p>
  <p>- name: Deploy to Azure</p>
  <p>if: success()</p>
  <p># download the output folder from the previous steps</p>
  <p>- name: Download artifact</p>
  <p>uses: actions/download-artifact@v2</p>
  <p>with:</p>
  <p>name: output</p>
  <p>path: output</p>

  <p># deploy the output folder to an Azure Web App using azure/webapps-deploy action</p>
  <p>- name: Deploy to Azure Web App</p>
  <p>uses: azure/webapps-deploy@v2</p>
  <p>with:</p>
  <p>app-name: 'your-web-app-name'</p>
  <p>slot-name: 'production'</p>
  <p>publish-profile: ${{ secrets.AZURE_WEBAPP_PUBLISH_PROFILE }}</p>

  <h5>steps:</h5>

  <p># generate markdown documentation from shell scripts using vargiuscuola/generate-docs action</p>
  <p>- name: Generate docs</p>
  <p>uses: vargiuscuola/generate-docs@v1</p>
  <p>with:</p>
  <p># specify the input directory containing the shell scripts</p>
  <p>input_dir: scripts</p>
  <p># specify the output directory for the generated markdown files</p>
  <p>output_dir: docs</p>

  <p># publish documentation to GitHub Pages using peaceiris/actions-gh-pages action</p>
  <p>- name: Publish docs</p>
  <p>uses: peaceiris/actions-gh-pages@v3</p>
  <p>with:</p>
  <p># specify the personal access token with repo scope as a secret</p>
  <p>github_token: ${{ secrets.GITHUB_TOKEN }}</p>
  <p># specify the branch name for GitHub Pages</p>
  <p>publish_branch: gh-pages</p>
  <p># specify the directory containing the documentation files</p>
  <p>publish_dir: docs</p>

</body>

</html>