# WN19-00-000450

function domainSID() {
    $domainName = (Get-WmiObject Win32_ComputerSystem).Domain
    $domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetDomain((New-Object System.DirectoryServices.ActiveDirectory.DirectoryContext('Domain', $domainName)))
    $entry = $domain.GetDirectoryEntry()

    $domainSidBytes = $entry.Properties["objectSid"][0]   # Access the SID bytes
    $domainSid = New-Object System.Security.Principal.SecurityIdentifier($domainSidBytes, 0)   # Create a SecurityIdentifier object
    $domainSidString = $domainSid.Value   # Get the string representation of the SID

    return $domainSidString.ToString()

}

function rootDomainSID() {

# Get the current domain name
    $domainName = (Get-WmiObject Win32_ComputerSystem).Domain
    # Get the forest context
    $forestContext = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()
    # Find the root domain in the forest
    $rootDomain = $forestContext.Domains | Where-Object { $_.Name -eq $domainName }
    # Retrieve the root domain's directory entry
    $rootDomainEntry = $rootDomain.GetDirectoryEntry()
    # Retrieve the objectSid attribute
    $rootDomainSidBytes = $rootDomainEntry.Properties["objectSid"][0]
    # Convert the SID bytes to a SecurityIdentifier object
    $rootDomainSid = New-Object System.Security.Principal.SecurityIdentifier($rootDomainSidBytes, 0)
    # Get the string representation of the root domain SID
    $rootDomainSidString = $rootDomainSid.Value
    return $rootDomainSidString.ToString()
}


function Search-ADObjectBySID {
    param (
        [string]$TargetSid
    )
    $domainName = (Get-WmiObject Win32_ComputerSystem).Domain

    # Construct the LDAP query
    $query = "(&(objectClass=user)(objectSid=$targetSID))"

    # Create a directory searcher
    $searcher = New-Object DirectoryServices.DirectorySearcher
    $searcher.SearchRoot = [ADSI]""
    $searcher.Filter = $query

    # Perform the search
    $result = $searcher.FindOne()

    # Display the result
    if ($result) {
        Write-Host "Object with SID '$targetSID' found:"
        $result.GetDirectoryEntry()
    } else {
        Write-Host "Object with SID '$targetSID' not found in the domain."
    }
}

cls

$filename = "$env:TEMP\user_rights.cfg"

secedit /export /areas USER_RIGHTS /cfg $filename

$dSID = domainSID
$rootdSID  = rootDomainSID

#Known SIDs
$ids  = "S-1-5-11" `
,"S-1-5-113" `
,"S-1-5-114" `
,"S-1-5-19" `
,"S-1-5-20" `
,"S-1-5-32-544" `
,"S-1-5-32-546" `
,"S-1-5-6" `
,"S-1-5-9" `
,"S-1-5-21-960663293-2520708616-4291879677-512" `
,"S-1-5-21-960663293-2520708616-4291879677-519" `
,($dSID + "-512") `
,($rootdSID + "-519") `
,"S-1-5-80-3139157870-2983391045-3678747466-658725712-1809340420" `
,$rootdSID `
,"Unicode=yes" `
,"CHICAGO" `
,"""" `
,"\$" `
,"Revision=1" `
,"S-1-1-0" `
,"S-1-5-32-545" `
,"S-1-5-32-551" `
,"S-1-5-32-551" `
,"S-1-5-32-559" `
,"S-1-5-32-555" `
,"S-1-5-80-0" `
,"S-1-5-32-568" `
,"S-1-5-82-3006700770-424185619-1745488364-794895919-4004696415" `
,"S-1-5-80-.*(?:,|$)" `
,"SQLServer.*," `
,"ASPNET"

(Get-Content -Path $filename) -replace " ", "" | Set-Content -Path $filename
(Get-Content -Path $filename) -replace "\*", "" | Set-Content -Path $filename
foreach($id in $ids) {
    (Get-Content -Path $filename) -replace $id, "" | Set-Content -Path $filename
}

# Get-Content -Path $filename

$lines = Get-Content -Path $filename
foreach ($line in $lines)
{
    $a = $line -split "="
    if ($a.Length -gt 1)
    {
        $b = $a[1] -split ","

        foreach ($sid in $b)
        {
            if ($sid.Length -gt 0)
            {
                Search-ADObjectBySID -TargetSid $sid
            }
        }
    }
}

#Get-Content -Path $filename
Remove-Item -Path $filename
