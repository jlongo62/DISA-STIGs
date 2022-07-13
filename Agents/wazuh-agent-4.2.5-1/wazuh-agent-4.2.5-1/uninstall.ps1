$service = Get-Service -Name "Wazuh" 
Stop-Service -InputObject $service

msiexec.exe /x wazuh-agent-4.2.5-1.msi  /qn /L*v uninstall.log 
