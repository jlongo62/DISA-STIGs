$service = Get-Service -Name "Tenable Nessus Agent" 
Stop-Service -InputObject $service

msiexec.exe /x NessusAgent-10.0.1-x64.msi  /qn /L*v Nessus_uninstall.log 