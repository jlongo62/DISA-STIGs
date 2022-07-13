$SSM_CROWDSTRIKE_CID = $env:SSM_CROWDSTRIKE_CID

Write-Output "SSM_CROWDSTRIKE_CID:$SSM_CROWDSTRIKE_CID"

#Disable Windows Defender.
Set-MpPreference -DisableRealtimeMonitoring $true

Start-Process -FilePath "./WindowsSensor.GovLaggar.exe" `
              -ArgumentList "/install /quiet /norestart CID=$SSM_CROWDSTRIKE_CID  /log CrowdStrike_install.log" `
              -Wait  

#Enable Windows Defender.
Set-MpPreference -DisableRealtimeMonitoring $false

