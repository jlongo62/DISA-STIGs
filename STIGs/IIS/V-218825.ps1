
<#

**************************************************************************
* Source: https://github.com/Average-Bear/Configure-StigIIS/blob/master/Configure-StigIIS.ps1
**************************************************************************

.SYNOPSIS 
    Configure and verify Authorization Rules settings for vulnerability 76771.
.DESCRIPTION
    Configure and verify Authorization Rules settings for vulnerability 76771.
.Impacted Files:
    C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Config\web.config


audit file entry:
     value_data  : '<allow .*groups="(\\\\.*\\\\)?[Aa]dministrators".*\\/>'
     appcmd_args : "list config /section:system.web/authorization"
See changes as tenable with command:
  c:\windows\system32\inetsrv/appcmd.exe list config /section:system.web/authorization
      
#>

[String]$FilterPath = 'system.web/authorization/allow'
   
$PreConfigUsers = Get-WebConfigurationProperty -Filter $FilterPath -Name Users
[System.Management.Automation.PSSerializer]::Serialize($PreConfigUsers)

Remove-WebConfigurationProperty -PSPath 'MACHINE/WEBROOT' -Filter "system.web/authorization" -Name "."

# groups is unsupported, but tenable is testing for that in audit v2r5
# ignored; I thhink the audit file is wrong 
Add-WebConfigurationProperty -PSPath 'MACHINE/WEBROOT' -Filter "system.web/authorization" -Name "." -Value @{groups='Administrators'} -Type allow

# works
Add-WebConfigurationProperty -PSPath 'MACHINE/WEBROOT' -Filter "system.web/authorization" -Name "." -Value @{roles='Administrators'} -Type allow
Add-WebConfigurationProperty -PSPath 'MACHINE/WEBROOT' -Filter "system.web/authorization" -Name "." -Value @{users='?'} -Type deny

$PostConfigurationUsers = Get-WebConfigurationProperty -Filter $FilterPath -Name Users
[System.Management.Automation.PSSerializer]::Serialize($PreConfigUsers)

