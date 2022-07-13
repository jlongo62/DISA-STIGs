#########################################################
# Source: https://github.com/Average-Bear/Configure-StigIIS/blob/master/Configure-StigIIS.ps1
###################################################################################

    $FilterPath = 'system.web/machineKey'

    Write-Host "`nConfiguring STIG Settings for $($MyInvocation.MyCommand):`n"
   
    $PreConfigValidation = Get-WebConfigurationProperty -Filter $FilterPath -Name Validation
    $PreConfigEncryption = Get-WebConfigurationProperty -Filter $FilterPath -Name Decryption

    Set-WebConfigurationProperty -PSPath 'MACHINE/WEBROOT' -Filter $FilterPath -Name "Validation" -Value "HMACSHA256"
    Set-WebConfigurationProperty -PSPath 'MACHINE/WEBROOT' -Filter $FilterPath -Name "Decryption" -Value "Auto"

    $PostConfigurationValidation = Get-WebConfigurationProperty -Filter $FilterPath -Name Validation
    $PostConfigurationEncryption = Get-WebConfigurationProperty -Filter $FilterPath -Name Decryption

    [PSCustomObject] @{
               
        Vulnerability = "V-76731"
        Computername = $env:COMPUTERNAME
        PreConfigValidation = $PreConfigValidation
        PreConfigEncryption = $PreConfigEncryption.Value
        PostConfigurationValidation = $PostConfigurationValidation
        PostConfigurationEncryption = $PostConfigurationEncryption.Value
        Compliant = if($PostConfigurationValidation -eq 'HMACSHA256' -and $PostConfigurationEncryption.Value -eq 'Auto') {
                   
            "Yes"
        }

        else {
                   
            "No"
        }
    }