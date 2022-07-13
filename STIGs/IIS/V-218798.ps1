#########################################################
# Source: https://github.com/Average-Bear/Configure-StigIIS/blob/master/Configure-StigIIS.ps1
###################################################################################

#Pre-Configuration MIME map collection
$PreMimeConfig = (Get-WebConfiguration //staticcontent).Collection

#Adjusted MIM map collection
$NewCollection = ($PreMimeConfig | where {$_.fileextension -ne '.exe' -and $_.fileextension -ne '.dll' -and $_.fileextension -ne '.com' -and $_.fileextension -ne '.bat' -and $_.fileextension -ne '.csh'})

#Set new configurations
Set-WebConfigurationProperty //staticContent -Name Collection -InputObject $NewCollection

$PostMimeConfig = (Get-WebConfiguration //staticcontent).Collection

[PSCustomObject] @{
           
    Vulnerability = 'V-76711, V-76797'
    Computername = $env:COMPUTERNAME
    PreConfigExtenstions = $PreMimeConfig.FileExtension
    PreConfigCount = $PreMimeConfig.Count
    PostConfigurationExtenstions = $PostMimeConfig.FileExtension
    PostConfigurationCount = $PostMimeConfig.Count
}

[PSCustomObject] @{
           
    Vulnerability = 'V-76711, V-76797'
    Computername = $env:COMPUTERNAME
    PreConfigExtenstions = $maps.FileExtension
    PreConfigCount = $maps.Count
    PostConfigurationExtenstions = $PostMimeConfig.FileExtension
    PostConfigurationCount = $PostMimeConfig.Count
}

#STIG CHECK
$output=(Get-WebConfiguration -Filter system.webServer/staticContent/mimeMap | Where-object {$_.fileExtension -eq '.dll' } | Select-object fileExtension | Format-Table -HideTableHeaders); foreach-object { if(!$output){ $result='No entries found' } else { $result=$output }; $result };
$output