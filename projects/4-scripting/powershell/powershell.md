<h2>Situation:</h2>
<p><strong>Situation:</strong> The development team has been building a .NET application that requires a streamlined and automated build process. The process involves various steps such as restoring NuGet packages, building the solution, running unit tests, and packaging the build files. All these steps need to be executed in sequence, and any failure in any step should halt the process and provide relevant error logs.</p>

<h2>Task:</h2>
<p><strong>Task:</strong> As the DevOps Engineer, my task is to automate this process with a PowerShell script that can be integrated into our continuous integration server, and thus automate the build, test, and package stages of the pipeline.</p>

<h2>Action:</h2>
<ol>
  <li>
    I defined variables for the paths of the solution, test project, output directory, and log file.
  </li>
  <li>
    I retrieved the version number from a version.txt file located in the solution directory.
  </li>
  <li>
    I used <code>nuget restore</code> command to restore the NuGet packages required for the solution.
  </li>
  <li>
    I ran the <code>msbuild</code> command to clean any existing build files and build the project with Release configuration.
  </li>
  <li>
    I wrote a condition to check for errors in the log file, halting the process if any were found.
  </li>
  <li>
    I ran the <code>vstest.console.exe</code> command to execute unit tests on the test project.
  </li>
  <li>
    I wrote a second condition to check for failures in the unit tests, again halting the process if any were found.
  </li>
  <li>
    I used the <code>Compress-Archive</code> command to create a ZIP package of the build files.
  </li>
  <li>
    I tagged the current commit in the Git repository with the version number from the version.txt file.
  </li>
</ol>

<h2>Issue:</h2>
<p>While the script generally runs without errors, there could be situations where the msbuild command might fail due to unresolved dependencies or compilation errors, or where the unit tests might fail due to bugs in the code or incorrectly written tests.</p>

<h2>Resolution:</h2>
<p>By implementing error checks after both the build and test stages in the script, I ensured that the script stops execution and displays an error message when the build or test stage fails. This allows the development team to get immediate feedback if there are any issues with their code, so they can quickly fix it before attempting to run the script again.</p>

<h2>Result:</h2>
<p>The PowerShell script effectively automated the build and test process, providing a consistent and error-free method of preparing the .NET application for deployment. By integrating this script into the continuous integration pipeline, we can ensure rapid feedback on the health of the codebase, making the development process more efficient and reliable.</p>


```ps
# Define the paths to the solution, test project, and output directory
$solutionPath = "C:\Projects\MySolution\MySolution.sln"
$testProjectPath = "C:\Projects\MySolution\MyTests\MyTests.csproj"
$outputPath = "C:\Projects\MySolution\MyOutput"
$logFilePath = "C:\Projects\MySolution\build.log"

# Read the version number from the version.txt file
$versionNumber = Get-Content "$solutionPath\version.txt"

# Restore the NuGet packages
nuget restore $solutionPath 2>&1 | Tee-Object -FilePath $logFilePath

# Clean the solution and build the project
msbuild $solutionPath /t:Clean,Build /p:Configuration=Release /p:Platform="Any CPU" /p:Version=$versionNumber 2>&1 | Tee-Object -FilePath $logFilePath

# Check for errors in the log file
if (Select-String -Path $logFilePath -Pattern "Error:") {
    Write-Error "Build failed. See $logFilePath for details."
    exit 1
}

# Run the unit tests
$vstest = "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\IDE\CommonExtensions\Microsoft\TestWindow\vstest.console.exe"
& $vstest $testProjectPath /logger:trx /platform:AnyCPU /framework:.NETCoreApp,Version=v3.1 /InIsolation 2>&1 | Tee-Object -FilePath $logFilePath

# Check for errors in the log file
if (Select-String -Path $logFilePath -Pattern "Failed:") {
    Write-Error "Unit tests failed. See $logFilePath for details."
    exit 1
}

# Create a deployment package
$package = "$outputPath\MyApplication_$versionNumber.zip"
$files = Get-ChildItem "$solutionPath\bin\Release\netcoreapp3.1" -Recurse
Compress-Archive $files.FullName $package

# Display the path to the deployment package
Write-Host "Deployment package created: $package"

# Tag the current commit with the version number
$tagName = "v$versionNumber"
git tag $(git describe --always) $tagName
```