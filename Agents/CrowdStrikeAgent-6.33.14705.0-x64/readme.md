```
instructions for installing the CrowdStrike agent:

1.	Copy the following executable to the server.
a.	 WindowsSensor.GovLaggar.exe
2.	Disable Windows Defender.
a.	Set-MpPreference -DisableRealtimeMonitoring $true
3.	Launch the executable with the following command in command prompt.
a.	WindowsSensor.GovLaggar.exe /install /quiet /norestart CID=xxxxxxxxxxxxxxxxxxxxxxxxxxxx-yy
4.	Enable Windows Defender.
a.	Set-MpPreference -DisableRealtimeMonitoring $false
```



**Additional Arguments:**

```

{
    "SSM_CROWDSTRIKE_CID": "xxxxxxxxxxxxxxxxxxxxxxxxxxxx-yy"
}

```

**Hash for manifest:**

- SHA-256 Hash for CrowdStrikeAgent-6.33.zip
- use http://onlinemd5.com/ to get hash


**Upload Files to Bucket**

example: 

`
    s3://xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/CrowdStrikeAgent-6.33
`
- manifest.json
- CrowdStrikeAgent-6.33.zip


 **Create Distrutor**

Use CF File: aws_ssm_document.CrowdStrikeAgent-6.33.yaml
Update parameters:
- S3BucketURL
- WindowsHash


**Updating Pacakge**
If there is a need to update the *.ps1 files or other zip contents, recalculate the SHA256 Hash, useing http://onlinemd5.com/ to get hash
- Update the manifest.json file with new hash
- Redeploy yaml with new Hash
