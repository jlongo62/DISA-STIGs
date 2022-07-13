# DISA-STIGs
A collection of scripts to address DISA Stig Vulnerabilities

**STIGs**

Many of the various DISA STIGs can be addressed using scripts.
This repository is intended to capture these scripts.

These scripts were developed to support multiple environments containing many (approximately 50 VMs each).
Due to the VM volume, our organization decided to focus on STIGs that can be validated and remidied using automation.
Tennable/Nessus is used to scan the VMs and apply these scripts to address the vulnerabilities.
Keep in mind that many STIGs can be addressed with one script, therefore we use Tennable in an iterative fashion.

AWS System Manager or System Center can be used to apply the powershell scripts across the fleet.

Active Directory can be used to apply Registry based STIGs via Group Policy Objects (GPO)


***OS STIGs*** - <i>Coming soon</i>

OS STIGs are deployed as Active Directory Group Policy Objects



***SQL Server STIGs***

SQL Server Central Management Server is used to deploy SQL scripts across the fleet.
A good article on CMS is: https://www.sqlservercentral.com/articles/manage-your-environment-with-cms

- V-213930.sql
- V-213934.sql
- V-213938.sql
- V-213960.sql
- V-213964.sql
- V-213967.reg
- V-213975.sql
- V-213991.sql
- V-214028.sql
- V-214029.sql
- V-214037.sql



After applying these STIGs, will acheive a 80% Pass rate. Remaining CAT-I violations are all manual checks.





<i>This list is incomplete, more will be released as they are vetted.</i>

***IIS STIGs*** 
- V-218786.ps1
- V-218789.ps1
- V-218798.ps1
- V-218807.ps1
- V-218815.ps1
- V-218821.reg
- V-218824.ps1
- V-218825.ps1
- V-218819.reg


**Contributions**
If you have a script or scripts or other autmateable means to address certain STIGs please submit them as issues and we will attempt to incorporate them. Feel free to include attribution header information.


**Cloud Agents**

The Agents folder contains are AWS Documents for deploying various agents across a fleet using Systems Manager. Supported agents are
- Nessus (Tennable)
- WAZUH
- CrowdStrike

You will need to provide your own keys and buckets to the content provided.

<i>My hope is that AWS or the agent vendors will take this content and use the knowedge here to develop and maintain Agent distributions for AWS</i>






