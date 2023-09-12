#########################################################
# Source: https://github.com/Average-Bear/Configure-StigIIS/blob/master/Configure-StigIIS.ps1
###################################################################################

    $FilterPath = 'system.web/machineKey'

    Write-Host "Configuring STIG Settings for $($MyInvocation.MyCommand):"
   
    $PreConfigValidation = Get-WebConfigurationProperty -Filter $FilterPath -Name Validation
    $PreConfigEncryption = Get-WebConfigurationProperty -Filter $FilterPath -Name Decryption
    [System.Management.Automation.PSSerializer]::Serialize($PreConfigValidation)
    [System.Management.Automation.PSSerializer]::Serialize($PreConfigEncryption)

    Set-WebConfigurationProperty -PSPath 'MACHINE/WEBROOT' -Filter $FilterPath -Name "Validation" -Value "HMACSHA256"
    Set-WebConfigurationProperty -PSPath 'MACHINE/WEBROOT' -Filter $FilterPath -Name "Decryption" -Value "Auto"

    $PostConfigurationValidation = Get-WebConfigurationProperty -Filter $FilterPath -Name Validation
    $PostConfigurationEncryption = Get-WebConfigurationProperty -Filter $FilterPath -Name Decryption
    [System.Management.Automation.PSSerializer]::Serialize($PostConfigurationValidation)
    [System.Management.Automation.PSSerializer]::Serialize($PostConfigurationEncryption)
