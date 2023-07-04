  <!DOCTYPE html>
<html>
<head>
  <p>My task was to implement a continuous delivery pipeline for the application using Octopus Deploy and TeamCity. The pipeline had to support automated builds, deployments to different environments, and sign offs for production deployments.</p>
</head>
<body>
  <h1>Deployment Configuration</h1>

  <h2>Step 1:</h2>
  <p>In TeamCity, create a project for your application and add a build configuration. You can use the TeamCity Git plugin to connect to your Git repository and set up a VCS trigger to start a build whenever there is a code change. You can also use the TeamCity .NET plugin to run MSBuild and NUnit tasks to build the code and run unit tests. For example, you can have the following build steps:</p>
  <pre><code class="language-xml">
&lt;build&gt;
  &lt;build-runners&gt;
    &lt;runner name="MSBuild" type="MSBuild"&gt;
      &lt;parameters&gt;
        &lt;param name="build-file-path" value="MyApp.sln" /&gt;
        &lt;param name="targets" value="Clean;Build" /&gt;
        &lt;param name="toolsVersion" value="v4.0" /&gt;
      &lt;/parameters&gt;
    &lt;/runner&gt;
    &lt;runner name="NUnit" type="NUnit"&gt;
      &lt;parameters&gt;
        &lt;param name="dotNetCoverage.dotCover.home.path" value="%teamcity.tool.JetBrains.dotCover.CommandLineTools.DEFAULT%" /&gt;
        &lt;param name="dotNetCoverage.nunit.executable" value="%teamcity.tool.NUnit.Console.DEFAULT%\nunit3-console.exe" /&gt;
        &lt;param name="dotNetCoverage.nunit.path" value="**\bin\**\*.Tests.dll" /&gt;
      &lt;/parameters&gt;
    &lt;/runner&gt;
  &lt;/build-runners&gt;
&lt;/build&gt;
  </code></pre>

  <h2>Step 2:</h2>
  <p>In TeamCity, add a build feature to push the build artifacts to Octopus Deploy. You can use the TeamCity Octopus Deploy plugin to connect to your Octopus Deploy server and specify the package ID, version, and path. You can also use the TeamCity parameters to dynamically set the package version based on the build number. For example, you can have the following build feature:</p>
  <pre><code class="language-xml">
&lt;build-features&gt;
  &lt;feature type="octopus.push.package"&gt;
    &lt;parameters&gt;
      &lt;param name="octopus_host" value="https://octopus.example.com" /&gt;
      &lt;param name="octopus_apikey" value="%octopus_apikey%" /&gt;
      &lt;param name="package_id" value="MyApp" /&gt;
      &lt;param name="package_version" value="%build.number%" /&gt;
      &lt;param name="package_path" value="%teamcity.build.checkoutDir%\MyApp\bin\Release\*.zip" /&gt;
    &lt;/parameters&gt;
  &lt;/feature&gt;
&lt;/build-features&gt;
  </code></pre>

  <h2>Step 3:</h2>
  <p>In Octopus Deploy, create a project for your application and add a lifecycle. You can use the Octopus Deploy lifecycles to define the stages and environments for your deployment pipeline. You can also use the Octopus Deploy retention policies to control how long to keep the releases and deployments. For example, you can have the following lifecycle:</p>
  <pre><code class="language-json">
{
  "Id": "Lifecycles-1",
  "Name": "MyApp Lifecycle",
  "Description": "",
  "ReleaseRetentionPolicy": {
    "Unit": "Items",
    "QuantityToKeep": 10,
    "ShouldKeepForever": false
  },
  "TentacleRetentionPolicy": {
    "Unit": "Days",
    "QuantityToKeep": 30,
    "ShouldKeepForever": false
  },
  "Phases": [
    {
      "Id": "Phase-1",
      "Name": "Dev",
      "MinimumEnvironmentsBeforePromotion": 0,
      "AutomaticDeploymentTargets": [
        "Environments-1"
      ],
      "OptionalDeploymentTargets": [],
      "IsOptionalPhase": false
    },
    {
      "Id": "Phase-2",
      "Name": "Test",
      "MinimumEnvironmentsBeforePromotion": 1,
      "AutomaticDeploymentTargets": [],
      "OptionalDeploymentTargets": [
        "Environments-2"
      ],
      "IsOptionalPhase": false
    },
    {
      "Id": "Phase-3",
      "Name": "Production",
      "MinimumEnvironmentsBeforePromotion": 1,
      "AutomaticDeploymentTargets": [],
      "OptionalDeploymentTargets": [
        "Environments-3"
      ],
      "IsOptionalPhase": false
    }
  ]
}
  </code></pre>

  <h2>Step 4:</h2>
  <p>In Octopus Deploy, add a deployment process for your project. You can use the Octopus Deploy steps to define the actions and scripts for your deployment. You can also use the Octopus Deploy variables and scopes to customize the settings and values for different environments. For example, you can have the following steps:</p>
  <ol>
    <li>
      <p>A step that deploys the package to the target machines using the built-in <code>Deploy a package</code> step. You can specify the package ID, the target roles, and the extraction directory. You can also use the custom deployment scripts to perform any additional actions before or after the deployment. For example, you can have the following script to set the app settings in the web.config file:</p>
      <pre><code class="language-powershell">
$webConfig = "$OctopusParameters['Octopus.Action.Package.CustomInstallationDirectory']\MyApp\web.config"
$appSettings = [xml](Get-Content $webConfig).SelectSingleNode("//appSettings")
foreach ($variable in $OctopusParameters.Keys | Where-Object { $_ -like "AppSettings.*" }) {
  $key = $variable -replace "AppSettings.", ""
  $value = $OctopusParameters[$variable]
  $appSetting = $appSettings.SelectSingleNode("//add[@key='$key']")
  if ($appSetting -eq $null) {
    $appSetting = $appSettings.OwnerDocument.CreateElement("add")
    $appSetting.SetAttribute("key", $key)
    $appSetting.SetAttribute("value", $value)
    $appSettings.AppendChild($appSetting)
  }
  else {
    $appSetting.SetAttribute("value", $value)
  }
}
$appSettings.OwnerDocument.Save($webConfig)
      </code></pre>
    </li>
    <li>
      <p>A step that performs database migrations using the <code>Run a script</code> step. You can use the Octopus Deploy database tools to connect to your database and run the migration scripts. You can also use the Octopus Deploy variables

to specify the connection string and the script path. For example, you can have the following script to run the DbUp tool:</p>
<pre><code class="language-powershell">
Add-Type -Path "$env:TEMP\Octopus.Features.DatabaseMigrations.DbUp.dll"
$connectionString = $OctopusParameters["Database.ConnectionString"]
$scriptPath = "$OctopusParameters['Octopus.Action.Package.CustomInstallationDirectory']\MyApp\Database\Scripts"
$upgrader = [DbUp.DeployChanges]::To
.SqlDatabase($connectionString)
  .WithScriptsFromFileSystem($scriptPath)
.LogToConsole()
.Build()
$result = $upgrader.PerformUpgrade()
if (-not $result.Successful) {
  throw $result.Error
}
      </code></pre>
    </li>
    <li>
      <p>A step that runs smoke tests using the <code>Run a script</code> step. You can use any testing framework or tool to verify that your application is working as expected after the deployment. You can also use the Octopus Deploy variables to specify the test URL and the test results path. For example, you can have the following script to run the Selenium WebDriver tool:</p>
      <pre><code class="language-powershell">
Add-Type -Path "$env:TEMP\Octopus.Features.SeleniumWebDriver.Selenium.WebDriver.dll"
Add-Type -Path "$env:TEMP\Octopus.Features.SeleniumWebDriver.Selenium.WebDriver.ChromeDriver.dll"
$testUrl = $OctopusParameters["Test.Url"]
$testResultsPath = "$env:TEMP\test-results.xml"
$driver = New-Object OpenQA.Selenium.Chrome.ChromeDriver
$driver.Navigate().GoToUrl($testUrl)
$title = $driver.Title
if ($title -eq "MyApp") {
Write-Host "Test passed"
$testResult = @"
&lt;test-results&gt;
  &lt;test-case name="Smoke test" result="Success" /&gt;
&lt;/test-results&gt;
"@
}
else {
  Write-Host "Test failed"
  $testResult = @"
&lt;test-results&gt;
  &lt;test-case name="Smoke test" result="Failure"&gt;
    &lt;failure&gt;
      &lt;message&gt;Expected title to be 'MyApp' but was '$title'&lt;/message&gt;
&lt;/failure&gt;
&lt;/test-case&gt;
&lt;/test-results&gt;
"@
}
$driver.Quit()
Set-Content -Path $testResultsPath -Value $testResult
New-OctopusArtifact -Path $testResultsPath -Name "test-results.xml"
</code></pre>
</li>
<li>
<p>A step that sends email notifications using the built-in <code>Email</code> step. You can use the Octopus Deploy email templates to customize the subject and body of the email. You can also use the Octopus Deploy variables to specify the recipients, the sender, and the attachments. For example, you can have the following email template:</p>
<pre><code class="language-html">
&lt;html&gt;
&lt;head&gt;&lt;/head&gt;
&lt;body&gt;
&lt;p&gt;Hi,&lt;/p&gt;
&lt;p&gt;The #{Octopus.Project.Name} project has been deployed to the #{Octopus.Environment.Name} environment.&lt;/p&gt;
&lt;p&gt;You can view the deployment details here: #{Octopus.Web.DeploymentLink}&lt;/p&gt;
&lt;p&gt;Please review the deployment and sign off if you are satisfied.&lt;/p&gt;
&lt;p&gt;Regards,&lt;/p&gt;
&lt;p&gt;#{Octopus.Deployment.CreatedBy.DisplayName}&lt;/p&gt;
&lt;/body&gt;
&lt;/html&gt;
</code></pre>
</li>

  </ol>

  <h2>Step 5:</h2>
  <p>In Octopus Deploy, add some rules and permissions to control who can deploy and when. You can use the Octopus Deploy environments, roles, teams, and users to define the scope and access level for your deployments. You can also use the Octopus Deploy manual interventions, approvals, and schedules to add some checkpoints and constraints for your deployments. For example, you can have the following rules:</p>
  <ul>
    <li>A rule that allows only the developers team to deploy to the dev environment at any time.</li>
    <li>A rule that allows only the testers team to deploy to the test environment after a manual intervention from a developer.</li>
    <li>A rule that allows only the managers team to deploy to the production environment after an approval from a tester and a schedule that limits the deployment window to weekdays from 9 AM to 5 PM.</li>
  </ul>
</body>
</html>
