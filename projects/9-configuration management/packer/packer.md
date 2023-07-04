<!DOCTYPE html>
<html>
<head>
  <title>Packer AMI Configuration</title>
</head>
<body>
  <h1>Packer AMI Configuration</h1>
    <p>My task was to automate the process of creating and provisioning Windows Server instances while ensuring that the servers were set up in a consistent manner and properly configured to support our legacy .NET applications.</p>

  <h2>Step 1:</h2>
  <p>Configure the Packer template file with the necessary variables and builders:</p>

```json
{
"variables": {
    "aws_access_key": "{{env `AWS_ACCESS_KEY_ID`}}",
    "aws_secret_key": "{{env `AWS_SECRET_ACCESS_KEY`}}",
    "region": "us-west-2",
    "ami_name": "packer-example-{{timestamp}}"
},
"builders": [
    {
    "type": "amazon-ebs",
    "region": "{{user `region`}}",
    "source_ami_filter": {
        "filters": {
        "virtualization-type": "hvm",
        "name": "Windows_Server-2016-English-Full-Base-*",
        "root-device-type": "ebs"
        },
        "owners": ["amazon"],
        "most_recent": true
    },
    "instance_type": "t2.medium",
    "ssh_username": "Administrator",
    "ami_name": "{{user `ami_name`}}",
    "user_data_file": "./bootstrap_win.txt",
    "communicator": "winrm",
    "winrm_use_ssl": true,
    "winrm_insecure": true,
    "winrm_timeout": "10m",
    "winrm_username": "Administrator"
    }
]
}
```

  <h3>Note:</h3>
  <p>We require a <strong>bootstrap_win.txt</strong> file to configure WinRM.</p>

  <h2>Step 2:</h2>
  <p>Configure the user data script in PowerShell format:</p>

```powershell
write-output "Running User Data Script"
write-host "(host) Running User Data Script"

# Extend time the Windows will wait for sysprep to finish

Set-RegistryKey -Key "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AutoLogonChecked" -Name AutoAdminLogon -Value 1

# Let's log all the things

Set-PSDebug -Trace 1

# Don't set this before Set-PSDebug as it throws an error

$errorActionPreference = "Stop"

write-output "Configuring WinRM"
write-host "(host) setting up WinRM"
winrm quickconfig -q
winrm set winrm/config '@{MaxTimeoutms="1800000"}'
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="1024"}'
winrm set winrm/config/service '@{LogonTimeout="1800";AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'

# Create local user

write-output "Creating local user"
write-host "(host) Adding local user"
net user packer password /add
net localgroup administrators packer /add

# Add user to RDP group

write-output "Adding user to RDP group"
write-host "(host) Adding user to RDP group"
net localgroup "Remote Desktop Users" packer /add

shutdown /r /t 5 /c "Rebooting for final WinRM configuration"
```

  <h2>Step 3:</h2>
  <p>Add provisioners to the Packer template to run PowerShell scripts for Windows updates, .NET framework installation, and setting system settings:</p>

```json
"provisioners": [
{
    "type": "powershell",
    "inline": [
    "while ((Get-Service RdAgent).Status -ne 'Running') { Start-Sleep -s 5 }",
    "while ((Get-Service WindowsAzureTelemetryService).Status -ne 'Running') { Start-Sleep -s 5 }",
    "while ((Get-Service WindowsAzureGuestAgent).Status -ne 'Running') { Start-Sleep -s 5 }"
    ]
},
{
    "type": "

powershell",
"scripts": [
"./scripts/windows-updates.ps1",
"./scripts/dotnet-framework.ps1",
"./scripts/sys-settings.ps1"
]
},
{
"type": "windows-restart",
"restart_timeout": "15m"
}
]
```
  <h3>Note:</h3>
  <p>Adjust the script paths accordingly and provide your own system settings script.</p>

  <h2>Step 4:</h2>
  <p>Create a GitHub Actions workflow file to trigger an AMI rebuild with code changes:</p>
  
```yaml
name: 'Packer AMI Builder'
on:
push:
    branches:
    - '*', '!exclude-me'

jobs:
build:
runs-on: ubuntu-latest
steps: - name: Checkout code
uses: actions/checkout@v2

    - name: Validate Packer template
    uses: hashicorp/packer-github-actions@master
    with:
        working-directory: .
        template: windows-ami.json

    - name: Set up AWS credentials
    uses: aws-actions/configure-aws-credentials@v1
    with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: ap-southeast-2

    - name: Run Packer
    run: |
        packer build windows-ami.json
```

  <h3>Note:</h3>
  <p>Make sure to configure the necessary secrets for AWS access.</p>
</body>
</html>
