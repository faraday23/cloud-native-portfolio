<!DOCTYPE html>
<html>

<head>
  <title>PowerShell Script for Managing IIS Web Servers</title>
</head>

<body>
  <h1>PowerShell Script for Managing IIS Web Servers</h1>
  <p>My task was to automate the process of managing our IIS web servers, including creating and configuring websites,
    managing application pools, and handling SSL certificates, with a PowerShell script to reduce human error and
    streamline our operations.</p>

  <ol>
    <li>
      <p>
        To use the WebAdministration module, you need to import it first with the command
        <code>Import-Module WebAdministration</code>. This will load the cmdlets and functions that are used to manage
        IIS.
      </p>
    </li>
    <li>
      <p>
        To create a new website, you can use the cmdlet <code>New-Website</code>, which takes various parameters such as
        name, physical path, port, host header, etc. For example, to create a website called "MyApp" with the physical
        path "C:\inetpub\wwwroot\MyApp" on port 80, you can use the command
        <code>New-Website -Name MyApp -PhysicalPath C:\inetpub\wwwroot\MyApp -Port 80</code>.
      </p>
    </li>
    <li>
      <p>
        To configure application pools, you can use the cmdlet <code>Set-ItemProperty</code>, which allows you to modify
        the properties of an item in the IIS configuration. For example, to set the .NET framework version of the
        application pool "MyAppPool" to v4.0, you can use the command
        <code>Set-ItemProperty IIS:\AppPools\MyAppPool managedRuntimeVersion v4.0</code>. You can also use this cmdlet
        to change other properties such as identity, recycling settings, etc.
      </p>
    </li>
    <li>
      <p>
        To bind SSL certificates to the website, you can use the cmdlet <code>New-WebBinding</code>, which creates a new
        binding for a website. For example, to bind a certificate with the thumbprint "1234567890ABCDEF" to the website
        "MyApp" on port 443 with HTTPS protocol, you can use the command
        <code>New-WebBinding -Name MyApp -Protocol https -Port 443 -SslFlags 0 -CertificateThumbPrint 1234567890ABCDEF</code>.
        You can also use this cmdlet to create other types of bindings such as HTTP or FTP.
      </p>
    </li>
    <li>
      <p>
        To restart IIS, you can use the cmdlet <code>Restart-WebServer</code>, which stops and starts the IIS service.
        This is useful if you need to apply changes or refresh the configuration. You can use this command without any
        parameters to restart the entire IIS service, or you can specify a website name or an application pool name to
        restart only that part of IIS.
      </p>
    </li>
  </ol>

  <h2>PowerShell Script:</h2>

  <pre>
        <code>
            <b># Import the WebAdministration module</b>
            Import-Module WebAdministration

            <b># Define a function to create a new website with a specific configuration</b>
            function New-WebSiteWithConfig {
                param (
                    [string]$Name, # The name of the website
                    [string]$PhysicalPath, # The physical path of the website
                    [int]$Port, # The port number of the website
                    [string]$HostHeader, # The host header of the website
                    [string]$AppPool, # The application pool of the website
                    [string]$CertificateThumbPrint # The thumbprint of the SSL certificate to bind to the website
                )

                <b># Create a new website with the given parameters</b>
                New-Website -Name $Name -PhysicalPath $PhysicalPath -Port $Port -HostHeader $HostHeader -ApplicationPool $AppPool

                <b># Bind the SSL certificate to the website on port 443 with HTTPS protocol</b>
                New-WebBinding -Name $Name -Protocol https -Port 443 -SslFlags 0 -CertificateThumbPrint $CertificateThumbPrint
            }

            <b># Define a function to configure an application pool with a specific .NET framework version</b>
            function Set-AppPoolDotNetVersion {
                param (
                    [string]$Name, # The name of the application pool
                    [string]$DotNetVersion # The .NET framework version to set for the application pool
                )

                <b># Set the managed runtime version of the application pool to the given value</b>
                Set-ItemProperty IIS:\AppPools\$Name managedRuntimeVersion $DotNetVersion
            }

            <b># Define a function to restart IIS or a specific website or application pool</b>
            function Restart-IIS {
                param (
                    [string]$Website, # The name of the website to restart (optional)
                    [string]$AppPool # The name of the application pool to restart (optional)
                )

                <b># If both website and app pool are specified, restart both</b>
                if ($Website -and $AppPool) {
                    Restart-WebItem IIS:\Sites\$Website
                    Restart-WebItem IIS:\AppPools\$AppPool
                }
                <b># If only website is specified, restart only the website</b>
                elseif ($Website) {
                    Restart-WebItem IIS:\Sites\$Website
                }
                <b># If only app pool is specified, restart only the app pool</b>
                elseif ($AppPool) {
                    Restart-WebItem IIS:\AppPools\$AppPool
                }
                <b># If none are specified, restart the entire IIS service</b>
                else {
                    Restart-WebServer
                }
            }

            <b># Call the functions with some example parameters</b>

            <b># Create a new website called "MyApp" with the physical path "C:\inetpub\wwwroot\MyApp" on port 80 with host header "myapp.com" and application pool "MyAppPool"</b>
            New-WebSiteWithConfig -Name MyApp -PhysicalPath C:\inetpub\wwwroot\MyApp -Port 80 -HostHeader myapp.com -AppPool MyAppPool -CertificateThumbPrint 1234567890ABCDEF

            <b># Set the .NET framework version of the application pool "MyAppPool" to v4.0</b>
            Set-AppPoolDotNetVersion -Name MyAppPool -DotNetVersion v4.0

            <b># Restart IIS</b>
            Restart-IIS
        </code>
    </pre>

</body>

</html>