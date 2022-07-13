



Get-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -Filter "system.applicationHost/sites/siteDefaults" -Name "logfile" 

Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -Filter "system.applicationHost/sites/siteDefaults/logfile" -Name "directory" -Value '%SystemDrive%\inetpub\logs\LogFiles'
Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -Filter "system.applicationHost/sites/siteDefaults/logfile" -Name "period" -Value 'Daily'
Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -Filter "system.applicationHost/sites/siteDefaults/logfile" -Name "logTargetW3C" -Value 'File,ETW'
Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -Filter "system.applicationHost/sites/siteDefaults/logfile" -Name "logFormat" -Value 'W3C'
Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -Filter "system.applicationHost/sites/siteDefaults/logfile" -Name "localTimeRollover" -Value 'False'

Get-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -Filter "system.applicationHost/sites/siteDefaults" -Name "logfile" 