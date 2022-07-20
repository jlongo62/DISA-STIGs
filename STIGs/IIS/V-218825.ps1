#########################################################
# Source: https://github.com/Average-Bear/Configure-StigIIS/blob/master/Configure-StigIIS.ps1
###################################################################################

<#
.SYNOPSIS 
    Configure and verify Authorization Rules settings for vulnerability 76771.
.DESCRIPTION
    Configure and verify Authorization Rules settings for vulnerability 76771.
.Impacted Files:
    C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Config\web.config
#>



[String]$FilterPath = 'system.web/authorization/allow'
   

$PreConfigUsers = Get-WebConfigurationProperty -Filter $FilterPath -Name Users
[System.Management.Automation.PSSerializer]::Serialize($PreConfigUsers)

Remove-WebConfigurationProperty -PSPath 'MACHINE/WEBROOT' -Filter "system.web/authorization" -Name "."

Add-WebConfigurationProperty -PSPath 'MACHINE/WEBROOT' -Filter "system.web/authorization" -Name "." -Value @{roles='Administrators'} -Type allow
Add-WebConfigurationProperty -PSPath 'MACHINE/WEBROOT' -Filter "system.web/authorization" -Name "." -Value @{groups='administrators'} -Type allow
Add-WebConfigurationProperty -PSPath 'MACHINE/WEBROOT' -Filter "system.web/authorization" -Name "." -Value @{users='?'} -Type deny

$PostConfigurationUsers = Get-WebConfigurationProperty -Filter $FilterPath -Name Users

[PSCustomObject] @{
                
    Vulnerability = "V-76771"
    Computername = $env:COMPUTERNAME
    PreConfigAuthorizedUsers = $PreConfigUsers.Value
    PostConfigurationAuthorizedUsers = $PostConfigurationUsers.Value
    Compliant = if($PostConfigurationUsers.Value -eq "Administrators") {
                    
        "Yes"
    }

    else {
                    
        "No" 
    }
}

