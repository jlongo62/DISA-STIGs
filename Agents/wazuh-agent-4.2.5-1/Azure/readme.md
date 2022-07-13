See https://stackoverflow.com/questions/71119888/how-to-pass-arguments-to-azure-custom-script-extension-using-the-portal

Upload files
    wazuh-agent.azure.ps1
    wazuh-agent-4.2.5-1.msi
to 
    StorageAccount:    mghtstdeployments
    Container:         agents    

You will need a SAS Url for wazuh-agent-4.2.5-1.msi


WAZUH_MANAGER = "xuu0r7uqvxi7.cloud.wazuh.com"
WAZUH_REGISTRATION_SERVER = "xuu0r7uqvxi7.cloud.wazuh.com"
WAZUH_REGISTRATION_PASSWORD = "XgajLD6eA8CQg1H9C8CsPMZ2k20ystfB"
WAZUH_AGENT_GROUP = "MGHTEST"
URL=  "https://mghtstdeployments.blob.core.usgovcloudapi.net/agents/wazuh-agent-4.2.5-1.msi?sp=r&st=2022-02-14T22:09:45Z&se=2032-02-15T06:09:45Z&spr=https&sv=2020-08-04&sr=b&sig=e0Ihc83yck9sdgY%2BLwN%2BtOhLC7X29MjlQ6GWFDpwqgk%3D"

Arguments:
"xuu0r7uqvxi7.cloud.wazuh.com","xuu0r7uqvxi7.cloud.wazuh.com","XgajLD6eA8CQg1H9C8CsPMZ2k20ystfB","MGHTEST"

