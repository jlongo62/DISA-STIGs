# PowerShell script to 
# - enable HSTS
# - set includeSubDomains to True
# - set max-age to a value greater than 0
# - set redirectHttpToHttps to True

Import-Module WebAdministration
Set-WebConfigurationProperty -Filter /system.webServer/httpProtocol/customHeaders/add[@name='Strict-Transport-Security'] -Name "value" -Value "max-age=31536000; includeSubDomains; preload" -PSPath "IIS:\Sites\Default Web Site"
