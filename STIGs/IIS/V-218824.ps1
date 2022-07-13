#########################################################
# Source: https://github.com/Average-Bear/Configure-StigIIS/blob/master/Configure-StigIIS.ps1
###################################################################################
                

    $Extensions = @(
        
        "notListedCgisAllowed",
        "notListedIsapisAllowed"
    ) 

    $FilterPath = 'system.webserver/security/isapiCgiRestriction'


    Write-Host "`nConfiguring STIG Settings for $($MyInvocation.MyCommand):`n"
    
    $PreConfigCGIExtension = Get-WebConfigurationProperty -Filter $FilterPath -Name "notListedCgisAllowed"
    $PreConfigISAPIExtension = Get-WebConfigurationProperty -Filter $FilterPath -Name "notListedIsapisAllowed"

   Set-WebConfigurationProperty -Filter $FilterPath -Name notListedCgisAllowed -Value "False" -Force
   Set-WebConfigurationProperty -Filter $FilterPath -Name notListedIsapisAllowed -Value "False" -Force

    $PostConfigurationCGIExtension = Get-WebConfigurationProperty -Filter $FilterPath -Name "notListedCgisAllowed"
    $PostConfigurationISAPIExtension = Get-WebConfigurationProperty -Filter $FilterPath -Name "notListedIsapisAllowed"

    
    [PSCustomObject] @{
                
        Vulnerability = "V-76769"
        Computername = $env:COMPUTERNAME
        PreConfigCGI = $PostConfigurationCGIExtension.Value
        PreConfigISAPI = $PostConfigurationISAPIExtension.Value
        PostConfigurationCGI = $PostConfigurationCGIExtension.Value
        PostConfigurationISAPI = $PostConfigurationISAPIExtension.Value
        Compliant = if($PostConfigurationCGIExtension.Value -eq $false -and $PostConfigurationISAPIExtension.Value -eq $false) {
                    
            "Yes"
        }

        else {
                    
            "No: If auto configuration failed, this section may be locked. Configure manually." 
        }
    }