<p>As a DevOps Engineer, my job was to automate the application testing, pre-production staging, and production environment deployments.</p>

<pre>
name: CI/CD Pipeline

on: [push]

jobs:

build-test-deploy:
  # specify the runner machine to use
  runs-on: ubuntu-latest
  # specify the steps to run

steps:
  # checkout the code from the repository
  <strong>- name: Checkout code</strong>
    <strong>uses: actions/checkout@v2</strong>

  # setup dotnet environment on the runner machine
  <strong>- name: Setup dotnet</strong>
    <strong>uses: actions/setup-dotnet@v1</strong>
    <strong>with:</strong>
      <strong>dotnet-version: '5.0.x'</strong>

  # build and publish the project using dotnet command
  <strong>- name: Build and publish</strong>
    <strong>run: dotnet publish -c Release -o output</strong>

  # upload the output folder as an artifact for later use
  <strong>- name: Upload artifact</strong>
    <strong>uses: actions/upload-artifact@v2</strong>
    <strong>with:</strong>
      <strong>name: output</strong>
      <strong>path: output</strong>

  # run unit tests using MSTest framework
  <strong>- name: Run tests</strong>
    <strong>run: dotnet test --logger "trx;LogFileName=test-results.xml"</strong>

  # upload test results file as an artifact for later use
  <strong>- name: Upload test results</strong>
    <strong>uses: actions/upload-artifact@v2</strong>
    <strong>with:</strong>
      <strong>name: test-results</strong>
      <strong>path: test-results.xml</strong>

  # display test results using dorny/test-reporter action
  <strong>- name: Display test results</strong>
    <strong>uses: dorny/test-reporter@v1</strong>
    <strong>with:</strong>
      <strong>name: Unit Tests</strong>
      <strong>path: test-results.xml</strong>
      <strong>reporter: dotnet-trx</strong>

steps:
  # install and configure NUnit console runner using dotnet tool command
  <strong>- name: Install NUnit console runner</strong>
    <strong>run: dotnet tool install --global nunit.consolerunner</strong>

  # run integration tests using NUnit console runner and generate test results file in XML format
  <strong>- name: Run integration tests</strong>
    <strong>run: nunit3-console --result=integration-test-results.xml MyProject.IntegrationTests.dll</strong>

  # upload integration test results file as an artifact for later use
  <strong>- name: Upload integration test results</strong>
    <strong>uses: actions/upload-artifact@v2</strong>
    <strong>with:</strong>
      <strong>name: integration-test-results</strong>
      <strong>path: integration-test-results.xml</strong>

  # display integration test results using dorny/test-reporter action
  <strong>- name: Display integration test results</strong>
    <strong>uses: dorny/test-reporter@v1</strong>
    <strong>with:</strong>
      <strong>name: Integration Tests</strong>
      <strong>path: integration-test-results.xml</strong>
      <strong>reporter: nunit</strong>

  # install and configure JMeter using setup-jmeter action
  <strong>- name: Install JMeter</strong>
    <strong>uses: jmeter-maven-plugin/setup-jmeter@v1</strong>

  # run performance tests using JMeter and generate test results file in CSV format
  <strong>- name: Run performance tests</strong>
    <strong>run: jmeter -n -t MyProject.PerformanceTests.jmx -l performance-test-results.csv</strong>

  # upload performance test results file as an artifact for later use
  <strong>- name: Upload performance test results</strong>
    <strong>uses: actions/upload-artifact@v2</strong>
    <strong>with:</strong>
      <strong>name: performance-test-results</strong>
      <strong>path: performance-test-results.csv</strong>

  # display performance test results using custom script (not shown here)
  <strong>- name: Display performance test results</strong>
    <strong>run: ./display-performance-test-results.sh</strong>

  # install and configure OWASP ZAP using zaproxy/action-full-scan action
  <strong>- name: Install OWASP ZAP</strong>
    <strong>uses: zaproxy/action-full-scan@v0.4.0</strong>

  # run security tests using OWASP ZAP and generate test results file in HTML format
  <strong>- name: Run security tests</strong>
    <strong>run: docker exec zap-full-scan zap-full-scan.py -t https://my-project-url.com -r security-test-results.html</strong>

  # upload security test results file as an artifact for later use
  <strong>- name: Upload security test results</strong>
    <strong>uses: actions/upload-artifact@v2</strong>
    <strong>with:</strong>
      <strong>name: security-test-results</strong>
      <strong>path: security-test-results.html</strong>

  # display security test results using custom script (not shown here)
  <strong>- name: Display security test results</strong>
    <strong>run: ./display-security-test-results.sh</strong>

steps:
  # scan your code with SonarQube using sonarsource/sonarqube-scan-action action
  <strong>- name: Scan with SonarQube</strong>
    <strong>uses: sonarsource/sonarqube-scan-action@v1.0.0</strong>
    <strong>with:</strong>
      # specify the host URL of your SonarQube instance as a secret
      <strong>host: ${{ secrets.SONARQUBE_HOST }}</strong>
      # specify the login token of your SonarQube instance as a secret
      <strong>login: ${{ secrets.SONARQUBE_TOKEN }}</strong>
      # specify any additional parameters for sonar-scanner command
      <strong>args: ></strong>
        <strong>-Dsonar.projectKey=my-project-key</strong>
        <strong>-Dsonar.sources=.</strong>

  # scan your code with CodeQL using github/codeql-action action
  <strong>- name: Scan with CodeQL</strong>
    <strong>uses: github/codeql-action/init@v1</strong>
    <strong>with:</strong>
      # specify the languages to analyze (csharp, cpp, go, java, javascript, python)
      <strong>languages: csharp</strong>

  # run codeql analysis after building your project
  <strong>- name: Analyze with CodeQL</strong>
    <strong>uses: github/codeql-action/analyze@v1. As a DevOps Engineer, my job was to automate the application testing, pre-production staging, and production environment deployments.

<h3>CI/CD Pipeline</h3>

<ol>
  <li>
    <h4>Build, Test, and Deploy</h4>
    <ul>
      <li><strong>Checkout code:</strong> uses actions/checkout@v2</li>
      <li><strong>Setup dotnet:</strong> uses actions/setup-dotnet@v1 with dotnet-version: '5.0.x'</li>
      <li><strong>Build and publish:</strong> run dotnet publish -c Release -o output</li>
      <li><strong>Upload artifact:</strong> uses actions/upload-artifact@v2 with name: output, path: output</li>
      <li><strong>Run tests:</strong> run dotnet test --logger "trx;LogFileName=test-results.xml"</li>
      <li><strong>Upload test results:</strong> uses actions/upload-artifact@v2 with name: test-results, path: test-results.xml</li>
      <li><strong>Display test results:</strong> uses dorny/test-reporter@v1 with name: Unit Tests, path: test-results.xml, reporter: dotnet-trx</li>
      <li><strong>Install NUnit console runner:</strong> run dotnet tool install --global nunit.consolerunner</li>
      <li><strong>Run integration tests:</strong> run nunit3-console --result=integration-test-results.xml MyProject.IntegrationTests.dll</li>
      <li><strong>Upload integration test results:</strong> uses actions/upload-artifact@v2 with name: integration-test-results, path: integration-test-results.xml</li>
      <li><strong>Display integration test results:</strong> uses dorny/test-reporter@v1 with name: Integration Tests, path: integration-test-results.xml, reporter: nunit</li>
      <li><strong>Install JMeter:</strong> uses jmeter-maven-plugin/setup-jmeter@v1</li>
      <li><strong>Run performance tests:</strong> run jmeter -n -t MyProject.PerformanceTests.jmx -l performance-test-results.csv</li>
      <li><strong>Upload performance test results:</strong> uses actions/upload-artifact@v2 with name: performance-test-results, path: performance-test-results.csv</li>
      <li><strong>Display performance test results:</strong> run ./display-performance-test-results.sh</li>
      <li><strong>Install OWASP ZAP:</strong> uses zaproxy/action-full-scan@v0.4.0</li>
      <li><strong>Run security tests:</strong> run docker exec zap-full-scan zap-full-scan.py -t https://my-project-url.com -r security-test-results.html</li>
      <li><strong>Upload security test results:</strong> uses actions/upload-artifact@v2 with name: security-test-results, path: security-test-results.html</li>
      <li><strong>Display security test results:</strong> run ./display-security-test-results.sh</li>
      <li><strong>Scan with SonarQube:</strong> uses sonarsource/sonarqube-scan-action@v1.0.0 with host: ${{ secrets.SONARQUBE_HOST }}, login: ${{ secrets.SONARQUBE_TOKEN }}, args: -Dsonar.projectKey=my-project-key, -Dsonar.sources=.</li>
      <li><strong>Scan with CodeQL:</strong> uses github/codeql-action/init@v1 with languages: csharp</li>
      <li><strong>Analyze with CodeQL:</strong> uses github/codeql-action/analyze@v</li>
      <li><strong>Measure coverage with Coverlet:</strong> uses coverlet-coverage/coverlet-action@v1.0.2 with test-project-path: MyProject.Tests.csproj, dotnet-test-params: --configuration Release --no-build --verbosity normal</li>
      <li><strong>Format code:</strong> uses dotnet/format@v1 with folder-or-solution: MyProject.sln</li>
      <li><strong>Analyze code:</strong> uses dotnet/roslyn-analyzers@v1.0.0-rc1.21430.3 with dotnet-build-params: --configuration Release</li>
      <li><strong>Check code:</strong> uses PVS-Studio-Team/PVS-Studio-action@v1.0.0-beta2 with solution-path: MyProject.sln, analyzer-options: --analysis-mode=4 --output-file=pvs-studio-report.log</li>
      <li><strong>Cache NuGet packages:</strong> uses actions/cache@v2 with key: ${{ runner.os }}-nuget-${{ hashFiles('**/packages.lock.json') }}, restore-keys: ${{ runner.os }}-nuget-, path: ~\AppData\Local\NuGet\v3-cache\n~/.nuget/packages</li>
      <li><strong>Deploy to Azure:</strong> if: success()
        <ul>
          <li><strong>Download artifact:</strong> uses actions/download-artifact@v2 with name: output, path: output</li>
          <li><strong>Deploy to Azure Web App:</strong> uses azure/webapps-deploy@v2 with app-name: 'your-web-app-name', slot-name: 'production', publish-profile: ${{ secrets.AZURE_WEBAPP_PUBLISH_PROFILE }}</li>
        </ul>
      </li>
      <li><strong>Generate docs:</strong> uses vargiuscuola/generate-docs@v1 with input_dir: scripts, output_dir: docs</li>
      <li><strong>Publish docs:</strong> uses peaceiris/actions-gh-pages@v3 with github_token: ${{ secrets.GITHUB_TOKEN }}, publish_branch: gh-pages, publish_dir: docs</li>
    </ul>
  </li>
</ol>
