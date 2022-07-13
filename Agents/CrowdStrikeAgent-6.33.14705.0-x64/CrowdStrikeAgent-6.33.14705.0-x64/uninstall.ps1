#https://help.redcanary.com/hc/en-us/articles/360052302854-Installing-and-uninstalling-the-Crowdstrike-Falcon-sensor-on-Windows

#Tool Downloads:
#https://falcon.crowdstrike.com/support/tool-downloads
#Command Line
#CsUninstallTool.exe /quiet

#Disable Windows Defender.
Set-MpPreference -DisableRealtimeMonitoring $true

Start-Process -FilePath "./CsUninstallTool.exe" `
                        -ArgumentList "/quiet /norestart /log CrowdStrike_uninstall.log" `
                        -Wait  

#Enable Windows Defender.
Set-MpPreference -DisableRealtimeMonitoring $false