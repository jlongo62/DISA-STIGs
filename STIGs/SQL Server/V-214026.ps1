##################################################################
#
# STIG 31877: SQL6-D0-016000 - SQL Server must configure Customer Feedback and Error Reporting.
# VulnId: V-214026
#
##################################################################
cls

$items = Get-ChildItem -path "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\" -recurse -ErrorAction SilentlyContinue

#Disable CEIP - recursive, so it finds the Reg Values regardless on how SQL Server is configured

foreach($item in $items)
{
    $p = $null;

    $p =  Get-Itemproperty -path $item.PSPath -Name "CustomerFeedback"  -ErrorAction SilentlyContinue
    if ($p -ne $null)
    {
        Write-Output $item.PSPath
        $value =  (Get-ItemPropertyValue -path $item.PSPath -Name "CustomerFeedback")
        Write-Output "Old CustomerFeedback: $value" 
        Set-ItemProperty -path $item.PSPath -Name "CustomerFeedback" -value 0
        $value =  (Get-ItemPropertyValue -path $item.PSPath -Name "CustomerFeedback")
        Write-Output "New CustomerFeedback: $value" 
    }

    $p =  Get-Itemproperty -path $item.PSPath -Name "EnableErrorReporting"  -ErrorAction SilentlyContinue
    if ($p -ne $null)
    {
       Write-Output $item.PSPath
       $value =  (Get-ItemPropertyValue -path $item.PSPath -Name "EnableErrorReporting")
       Write-Output "Old EnableErrorReporting: $value" 
       Set-Itemproperty -path $item.PSPath -Name "EnableErrorReporting" -value 0
       $value =  (Get-ItemPropertyValue -path $item.PSPath -Name "EnableErrorReporting")
       Write-Output "New EnableErrorReporting: $value" 
    }

 
}

#Disable Telemtry Service (CEIP)
Stop-Service -Name SQLTELEMETRY -Force -Confirm
Set-Service SQLTELEMETRY -StartupType  Disabled

