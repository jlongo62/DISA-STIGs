#########################################################
# Source: https://github.com/Average-Bear/Configure-StigIIS/blob/master/Configure-StigIIS.ps1
###################################################################################
   
###############################################################
# V-218789
#################################################################

    $ConnectionServer =  @{
        logFieldName   = 'Connection'
        sourceName     = 'Connection'
        sourceType     = 'RequestHeader'
        }
    $WarningServer =   @{
            logFieldName   = 'Warning'
            sourceName     = 'Warning'
            sourceType     = 'RequestHeader'
        }
    $AuthorizationServer =   @{
            logFieldName   = 'Authorization'
            sourceName     = 'Authorization'
            sourceType     = 'RequestHeader'
        }
    $ContentTypeServer =   @{
            logFieldName   = 'Content-Type'
            sourceName     = 'Content-Type'
            sourceType     = 'ResponseHeader'
        }
    $CustomFields = @(
           
            $ConnectionServer,
            $WarningServer,
            $AuthorizationServer,
            $ContentTypeServer
        )

 
    Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -Filter "system.applicationHost/sites/siteDefaults/logfile" -Name "customFields" -Value $CustomFields
    EXIT

###############################################################
# "V-76687, V-76689, V-76789, V-76791"  -- these are probably in the Site Stig
#################################################################
    $Connection = [PSCustomObject] @{
           
        LogFieldName = 'Connection'
        SourceType = 'RequestHeader'
        SourceName = 'Connection'
    }

    $Warning = [PSCustomObject] @{
           
        LogFieldName = 'Warning'
        SourceType = 'RequestHeader'
        SourceName = 'Warning'
    }

    $HTTPConnection = [PSCustomObject] @{
           
        LogFieldName = 'HTTPConnection'
        SourceType = 'ServerVariable'
        SourceName = 'HTTPConnection'
    }

    $UserAgent = [PSCustomObject] @{
           
        LogFieldName = 'User-Agent'
        SourceType = 'RequestHeader'
        SourceName = 'User-Agent'
    }

    $ContentType = [PSCustomObject] @{
           
        LogFieldName = 'Content-Type'
        SourceType = 'RequestHeader'
        SourceName = 'Content-Type'
    }

    $HTTPUserAgent = [PSCustomObject] @{
           
        LogFieldName = 'HTTP_USER_AGENT'
        SourceType = 'ServerVariable'
        SourceName = 'HTTP_USER_AGENT'
    }
    $Authorization = [PSCustomObject]  @{
            logFieldName   = 'Authorization'
            sourceName     = 'Authorization'
            sourceType     = 'RequestHeader'
        }

    $CustomFields = @(
           
        $Connection,
        $Warning,
        $HTTPConnection,
        $UserAgent,
        $ContentType,
        $HTTPUserAgent,
        $Authorization
    )



    #All website names
    $WebNames = (Get-Website).Name

    foreach($Custom in $CustomFields) {

        foreach($WebName in $WebNames) {
           
            try {

                #Set custom logging fields
                New-ItemProperty "IIS:\Sites\$($WebName)" -Name "logfile.customFields.collection" -Value $Custom -ErrorAction Stop
            }

            catch {
               
                #Silence duplication errors
            }
        }
    }

    foreach($WebName in $WebNames) {

        #Post-Configuration custom fields
        $PostConfig = (Get-ItemProperty "IIS:\Sites\$($WebName)" -Name "logfile.customFields.collection")

        [PSCustomObject] @{
           
            Vulnerability = "V-76687, V-76689, V-76789, V-76791"
            SiteName = $WebName
            CustomFields = $($PostConfig.logFieldName)
            Compliant = if($PostConfig.logFieldName -contains "Connection" -and $PostConfig.logFieldName -contains "Warning" -and $PostConfig.logFieldName -contains "HTTPConnection" -and $PostConfig.logFieldName -contains "User-Agent" -and $PostConfig.logFieldName -contains "Content-Type" -and $PostConfig.logFieldName -contains "HTTP_USER_AGENT") {
               
                "Yes"
            }

            else {
               
                "No"
            }
        }
    }
