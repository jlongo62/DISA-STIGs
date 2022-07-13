**Additional Arguments:**

```

{
    "SSM_NESSUS_GROUPS": "XXXXX",
    "SSM_NESSUS_SERVER": "cloud.tenable.com:443",
    "SSM_NESSUS_KEY":"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}

```

**Hash for manifest:**

- SHA-256 Hash for NessusAgent-10.0.1-x64.zip
- use http://onlinemd5.com/ to get hash


**Upload Files to Bucket**

example: 

`
    s3://xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/NessusAgent-10.0.1-x64
`
- manifest.json
- NessusAgent-10.0.1-x64.zip


 **Create Distrutor**

Use CF File: aws_ssm_document.NessusAgent-10-0-1-x64.yaml
Update parameters:
- S3BucketURL
- WindowsHash


**Updating Pacakge**
If there is a need to update the *.ps1 files or other zip contents, recalculate the SHA256 Hash, useing http://onlinemd5.com/ to get hash
- Update the manifest.json file with new hash
- Redeploy yaml with new Hash
