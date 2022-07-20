#########################################################
# Source: https://github.com/Average-Bear/Configure-StigIIS/blob/master/Configure-StigIIS.ps1
###################################################################################
                

    $FilterPath = 'system.webserver/security/isapiCgiRestriction'


    Write-Host "Configuring STIG Settings for $($MyInvocation.MyCommand):`n"
    
    $PreConfigCGIExtension = Get-WebConfigurationProperty -Filter $FilterPath -Name "notListedCgisAllowed"
    $PreConfigISAPIExtension = Get-WebConfigurationProperty -Filter $FilterPath -Name "notListedIsapisAllowed"


[System.Management.Automation.PSSerializer]::Serialize($PreConfigCGIExtension)
[System.Management.Automation.PSSerializer]::Serialize($PreConfigISAPIExtension)


   Set-WebConfigurationProperty -Filter $FilterPath -Name notListedCgisAllowed -Value "False" -Force
   Set-WebConfigurationProperty -Filter $FilterPath -Name notListedIsapisAllowed -Value "False" -Force

    $PostConfigurationCGIExtension = Get-WebConfigurationProperty -Filter $FilterPath -Name "notListedCgisAllowed"
    $PostConfigurationISAPIExtension = Get-WebConfigurationProperty -Filter $FilterPath -Name "notListedIsapisAllowed"
    
[System.Management.Automation.PSSerializer]::Serialize($PostConfigurationCGIExtension)
[System.Management.Automation.PSSerializer]::Serialize($PostConfigurationISAPIExtension)
