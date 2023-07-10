Import-Module WebAdministration
Clear-WebConfiguration "/system.webServer/httpProtocol/customHeaders" -PSPath "IIS:\Sites\Default Web Site" -Name "X-Powered-By"
