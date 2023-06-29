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