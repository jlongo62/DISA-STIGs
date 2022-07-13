$NESSUS_GROUPS = $env:SSM_NESSUS_GROUPS
$NESSUS_SERVER = $env:SSM_NESSUS_SERVER
$NESSUS_KEY    = $env:SSM_NESSUS_KEY

$service = Get-Service -Name "Tenable Nessus Agent" 
Stop-Service -InputObject $service

msiexec /i NessusAgent-10.0.1-x64.msi NESSUS_GROUPS=$NESSUS_GROUPS NESSUS_SERVER=$NESSUS_SERVER NESSUS_KEY=$NESSUS_KEY  /qn /L*v Nessus_install.log  

$service = Get-Service -Name "Tenable Nessus Agent" 
Start-Service -InputObject $service