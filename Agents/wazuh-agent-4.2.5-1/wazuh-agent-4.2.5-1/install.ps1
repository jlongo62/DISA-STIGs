$WAZUH_MANAGER = $env:SSM_WAZUH_MANAGER
$WAZUH_REGISTRATION_SERVER = $env:SSM_WAZUH_REGISTRATION_SERVER
$WAZUH_REGISTRATION_PASSWORD = $env:SSM_WAZUH_REGISTRATION_PASSWORD
$WAZUH_AGENT_GROUP = $env:SSM_WAZUH_AGENT_GROUP

Write-Output "WAZUH_MANAGER:$WAZUH_MANAGER"
Write-Output "WAZUH_REGISTRATION_SERVER:$WAZUH_REGISTRATION_SERVER"
Write-Output "WAZUH_REGISTRATION_PASSWORD:$WAZUH_REGISTRATION_PASSWORD"
Write-Output "WAZUH_AGENT_GROUP:$WAZUH_AGENT_GROUP"


msiexec /i wazuh-agent-4.2.5-1.msi WAZUH_MANAGER=$WAZUH_MANAGER WAZUH_REGISTRATION_SERVER=$WAZUH_REGISTRATION_SERVER WAZUH_REGISTRATION_PASSWORD=$WAZUH_REGISTRATION_PASSWORD WAZUH_AGENT_GROUP=$WAZUH_AGENT_GROUP /qn /L*v install.log  

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


