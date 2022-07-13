**Additional Arguments:**

```

{
    "SSM_WAZUH_MANAGER": "xxxxxxxxxxxxxx.cloud.wazuh.com",
    "SSM_WAZUH_REGISTRATION_SERVER": "xxxxxxxxxxx.cloud.wazuh.com",
    "SSM_WAZUH_REGISTRATION_PASSWORD": "xxxxxxxxxxxxxxxxxxxxxxxxxxxx",
    "SSM_WAZUH_AGENT_GROUP": "default"
}

```

**Hash for manifest:**

- SHA-256 Hash for NessusAgent-10.0.1-x64.zip
- use http://onlinemd5.com/ to get hash and update manifest file


**Upload Files to Bucket**

See terraform: aws_ssm_document.agents.tf

example: 

`
    s3://xxxxxxxxxxxxxxxxxxxxxxxx/wazuh-agent-4.2.5-1
`
- manifest.json
- wazuh-agent-4.2.5-1.zip


 **Create Distrutor**

See terraform: aws_ssm_document.agents.tf


**Updating Pacakge**
If there is a need to update the *.ps1 files or other zip contents, recalculate the SHA256 Hash, useing http://onlinemd5.com/ to get hash
- Update the manifest.json file with new hash
- Redeploy yaml with new Hash
