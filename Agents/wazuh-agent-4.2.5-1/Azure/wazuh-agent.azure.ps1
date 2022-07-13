############################################################
# Install WAZUH Agent on Windows
############################################################

$parm = $Args[0]
$parms = $parm.Split(",")

$WAZUH_MANAGER =                $parms[0]
$WAZUH_REGISTRATION_SERVER =    $parms[1]
$WAZUH_REGISTRATION_PASSWORD =  $parms[2]
$WAZUH_AGENT_GROUP =            $parms[3]
$SOURCE = 'https://xxxxxxxxx.blob.core.usgovcloudapi.net/agents/wazuh-agent-4.2.5-1.msi?sp=r&st=2022-02-14T22:09:45Z&se=2032-02-15T06:09:45Z&spr=https&sv=2020-08-04&sr=b&sig=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'


Write-Output "WAZUH_MANAGER:$WAZUH_MANAGER"
Write-Output "WAZUH_REGISTRATION_SERVER:$WAZUH_REGISTRATION_SERVER"
Write-Output "WAZUH_REGISTRATION_PASSWORD:$WAZUH_REGISTRATION_PASSWORD"
Write-Output "WAZUH_AGENT_GROUP:$WAZUH_AGENT_GROUP"
Write-Output "SOURCE:$SOURCE"

# Destination to save the file
$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
$destination = "$PSScriptRoot\wazuh-agent-4.2.5-1.msi"
#Download the file
Invoke-WebRequest -Uri $SOURCE -OutFile $destination

msiexec /i "$PSScriptRoot\wazuh-agent-4.2.5-1.msi" WAZUH_MANAGER=$WAZUH_MANAGER WAZUH_REGISTRATION_SERVER=$WAZUH_REGISTRATION_SERVER WAZUH_REGISTRATION_PASSWORD=$WAZUH_REGISTRATION_PASSWORD WAZUH_AGENT_GROUP=$WAZUH_AGENT_GROUP /qn /L*v install.log  

Start-Sleep -s 30


Write-Output "*********** Results ***********************"
# Verify the agent installation was successful
$AgentService = Get-Service -Name "Wazuh"

if ($AgentService.Status -eq "running") {
    Write-Output (Get-Date -Format "yyyy-MM-dd hh:mm:ss") "The agent install was successful!!!"
}
else {
    Write-Error  (Get-Date -Format "yyyy-MM-dd hh:mm:ss") "The agent install failed. Please review logs for additional information."    
}
