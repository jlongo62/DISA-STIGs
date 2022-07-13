



USE [master];
GO

--Set variables needed by setup script:
DECLARE @auditName varchar(50), @auditPath varchar(260), @auditGuid uniqueidentifier, @auditFileSize varchar(4), @auditFileCount varchar(4)

--Define the name of the audit:
SET @auditName = 'STIG_AUDIT'

--Define the directory in which audit log files reside:
SET @auditPath = 'L:\Audits'

--Define the unique identifier for the audit:
SET @auditGuid = NEWID()

--Define the maximum size for a single audit file (MB):
SET @auditFileSize = 200

--Define the number of files that should be kept online. Use -1 for unlimited:
SET @auditFileCount = 50

--Insert the variables into a temp table so they survive for the duration of the script:
DROP TABLE IF EXISTS #SetupVars
CREATE TABLE #SetupVars
(
 Variable varchar(50),
 Value  varchar(260)
)
INSERT INTO #SetupVars (Variable, Value)
  VALUES ('auditName', @auditName),
    ('auditPath', @auditPath),
    ('auditGuid', convert(varchar(40), @auditGuid)),
    ('auditFileSize', @auditFileSize),
    ('auditFileCount', @auditFileCount)
GO

--Delete the audit if it currently exists:

--Disable the Server Audit Specification:
DECLARE @auditName varchar(50), @dropSpecification nvarchar(max),  @alterSpecification  nvarchar(max)
SET  @auditName = (SELECT Value FROM #SetupVars WHERE Variable = 'auditName')
SET  @alterSpecification = '
IF EXISTS (SELECT 1 FROM sys.server_audit_specifications WHERE name = N''' + @auditName + '_applog_SERVER_SPECIFICATION'')
ALTER  SERVER AUDIT SPECIFICATION [' + @auditName + '_applog_SERVER_SPECIFICATION] WITH  (STATE=OFF);'
PRINT  @alterSpecification ;
EXEC(@alterSpecification);

SET  @dropSpecification = '
IF EXISTS (SELECT 1 FROM sys.server_audit_specifications WHERE name = N''' + @auditName + '_applog_SERVER_SPECIFICATION'')
DROP SERVER AUDIT SPECIFICATION [' + @auditName + '_applog_SERVER_SPECIFICATION];'
PRINT  @dropSpecification; 
EXEC(@dropSpecification);

SET  @alterSpecification = '
IF EXISTS (SELECT 1 FROM sys.server_audit_specifications WHERE name = N''' + @auditName + '_SERVER_SPECIFICATION'')
ALTER  SERVER AUDIT SPECIFICATION [' + @auditName + '_SERVER_SPECIFICATION] WITH  (STATE=OFF);'
PRINT  @alterSpecification ;
EXEC(@alterSpecification);

SET  @dropSpecification = '
IF EXISTS (SELECT 1 FROM sys.server_audit_specifications WHERE name = N''' + @auditName + '_SERVER_SPECIFICATION'')
DROP SERVER AUDIT SPECIFICATION [' + @auditName + '_SERVER_SPECIFICATION];'
PRINT  @dropSpecification; 
EXEC(@dropSpecification);

GO



--Disable the Server Audit:
DECLARE @auditName varchar(50), @disableAudit nvarchar(max)
SET  @auditName = (SELECT Value FROM #SetupVars WHERE Variable = 'auditName')
SET  @disableAudit = '
IF EXISTS (SELECT 1 FROM sys.server_audits WHERE name = N''' + @auditName + ''')
ALTER SERVER AUDIT [' + @auditName + '] WITH (STATE = OFF);'
PRINT  @disableAudit; 
EXEC(@disableAudit)
GO

--Drop the Server Audit:
DECLARE @auditName varchar(50), @dropAudit nvarchar(max)
SET  @auditName = (SELECT Value FROM #SetupVars WHERE Variable = 'auditName')
SET  @dropAudit = '
IF EXISTS (SELECT 1 FROM sys.server_audits WHERE name = N''' + @auditName + ''')
DROP SERVER AUDIT [' + @auditName + '];'
PRINT  @dropAudit; 
EXEC(@dropAudit)
GO

--Set up the SQL Server Audit:

USE [master];
GO

--Create the Server Audit:
DECLARE @auditName varchar(50), @auditPath varchar(260), @auditGuid varchar(40), @auditFileSize varchar(4), @auditFileCount varchar(5)

SELECT @auditName = Value FROM #SetupVars WHERE Variable = 'auditName'
SELECT @auditPath = Value FROM #SetupVars WHERE Variable = 'auditPath'
SELECT @auditGuid = Value FROM #SetupVars WHERE Variable = 'auditGuid'
SELECT @auditFileSize = Value FROM #SetupVars WHERE Variable = 'auditFileSize'
SELECT @auditFileCount = Value FROM #SetupVars WHERE Variable = 'auditFileCount'

DECLARE @createStatement nvarchar(max)
SET  @createStatement = '
CREATE SERVER AUDIT [' + @auditName + ']
TO FILE
(
 FILEPATH = ''' + @auditPath + '''
 , MAXSIZE = ' + @auditFileSize + ' MB
 , MAX_ROLLOVER_FILES = ' + CASE WHEN @auditFileCount = -1 THEN 'UNLIMITED' ELSE @auditFileCount END + '
 , RESERVE_DISK_SPACE = OFF
)
WITH
(
 QUEUE_DELAY = 1000
 , ON_FAILURE = SHUTDOWN
 , AUDIT_GUID = ''' + @auditGuid + '''
)
WHERE ([Schema_Name] = ''sys'' AND [Object_Name] = ''all_objects'')
OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''database_permissions'')
OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''database_principals'')
OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''database_role_members'')
OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''dm_column_store_object_pool'')
OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''dm_db_xtp_object_stats'')
OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''dm_os_memory_objects'')
OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''dm_xe_object_columns'')
OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''dm_xe_objects'')
OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''dm_xe_session_object_columns'')
OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''filetable_system_defined_objects'')
OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''linked_logins'')
OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''login_token'')
OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''objects'')
OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''remote_logins'')
OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''server_permissions'')
OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''server_principal_credentials'')
OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''server_principals'')
OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''server_role_members'')
OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''sql_logins'')
OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''syscacheobjects'')
OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''syslogins'')
OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''sysobjects'')
OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''sysoledbusers'')
OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''syspermissions'')
OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''sysremotelogins'')
OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''system_objects'')
OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''sysusers'')
OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''user_token'')
'
PRINT 'CREATE SERVER AUDIT [' + @auditName + ']'
EXEC(@createStatement);
GO

--Disable the Server Audit:
DECLARE @auditName varchar(50), @disableAudit nvarchar(max)
SET  @auditName = (SELECT Value FROM #SetupVars WHERE Variable = 'auditName')
SET  @disableAudit = '
IF EXISTS (SELECT 1 FROM sys.server_audits WHERE name = N''' + @auditName + '_applog'')
ALTER SERVER AUDIT [' + @auditName + '_applog] WITH (STATE = OFF);'
PRINT @disableAudit;
EXEC(@disableAudit)
GO

--Drop the Server Audit:
DECLARE @auditName varchar(50), @dropAudit nvarchar(max)
SET  @auditName = (SELECT Value FROM #SetupVars WHERE Variable = 'auditName')
SET  @dropAudit = '
IF EXISTS (SELECT 1 FROM sys.server_audits WHERE name = N''' + @auditName + '_applog'')
DROP SERVER AUDIT [' + @auditName + '_applog];'
PRINT @dropAudit;
EXEC(@dropAudit)
GO


DECLARE  @auditName varchar(50), @createStatement2 nvarchar(max)
DECLARE @auditGuid2 uniqueidentifier
SET  @auditName = (SELECT Value FROM #SetupVars WHERE Variable = 'auditName')
SET @auditGuid2 = NEWID()

set @createStatement2 = '
CREATE SERVER AUDIT [' + @auditName + '_applog]
	TO APPLICATION_LOG 
	WITH
	(
	 QUEUE_DELAY = 1000
	 , ON_FAILURE = SHUTDOWN
	 , AUDIT_GUID = ''' + convert(nvarchar(36), @auditGuid2)  + '''
	)
	WHERE ([Schema_Name] = ''sys'' AND [Object_Name] = ''all_objects'')
	OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''database_permissions'')
	OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''database_principals'')
	OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''database_role_members'')
	OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''dm_column_store_object_pool'')
	OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''dm_db_xtp_object_stats'')
	OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''dm_os_memory_objects'')
	OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''dm_xe_object_columns'')
	OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''dm_xe_objects'')
	OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''dm_xe_session_object_columns'')
	OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''filetable_system_defined_objects'')
	OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''linked_logins'')
	OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''login_token'')
	OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''objects'')
	OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''remote_logins'')
	OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''server_permissions'')
	OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''server_principal_credentials'')
	OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''server_principals'')
	OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''server_role_members'')
	OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''sql_logins'')
	OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''syscacheobjects'')
	OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''syslogins'')
	OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''sysobjects'')
	OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''sysoledbusers'')
	OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''syspermissions'')
	OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''sysremotelogins'')
	OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''system_objects'')
	OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''sysusers'')
	OR ([Schema_Name] = ''sys'' AND [Object_Name] = ''user_token'')
'
PRINT 'CREATE SERVER AUDIT [' + @auditName + '_applog]'
EXEC(@createStatement2);

--Turn on the Audit:
DECLARE @enableAudit nvarchar(max)
SET @auditName = (SELECT Value FROM #SetupVars WHERE Variable = 'auditName')
SET @enableAudit = '
IF EXISTS (SELECT 1 FROM sys.server_audits WHERE name = N''' + @auditName + ''')
ALTER SERVER AUDIT [' + @auditName + '] WITH (STATE = ON);'
PRINT @enableAudit;
EXEC(@enableAudit);

SET @enableAudit = '
IF EXISTS (SELECT 1 FROM sys.server_audits WHERE name = N''' + @auditName + '_applog'')
ALTER SERVER AUDIT [' + @auditName + '_applog] WITH (STATE = ON);'
PRINT @enableAudit;
EXEC(@enableAudit);
GO

--Create the server audit specifications:
DECLARE @auditName varchar(50), @createSpecification nvarchar(max)
SET  @auditName = (SELECT Value FROM #SetupVars WHERE Variable = 'auditName')
SET  @createSpecification = '
CREATE SERVER AUDIT SPECIFICATION [' + @auditName + '_SERVER_SPECIFICATION]
FOR SERVER AUDIT [' + @auditName + ']
	ADD (APPLICATION_ROLE_CHANGE_PASSWORD_GROUP ),
	ADD (AUDIT_CHANGE_GROUP ),
	ADD (BACKUP_RESTORE_GROUP ),
	ADD (DATABASE_CHANGE_GROUP ),
	ADD (DATABASE_OBJECT_ACCESS_GROUP ),
	ADD (DATABASE_OBJECT_CHANGE_GROUP ),
	ADD (DATABASE_OBJECT_OWNERSHIP_CHANGE_GROUP ),
	ADD (DATABASE_OBJECT_PERMISSION_CHANGE_GROUP ),
	ADD (DATABASE_OWNERSHIP_CHANGE_GROUP ),
	ADD (DATABASE_OPERATION_GROUP ),
	ADD (DATABASE_PERMISSION_CHANGE_GROUP ),
	ADD (DATABASE_PRINCIPAL_CHANGE_GROUP ),
	ADD (DATABASE_PRINCIPAL_IMPERSONATION_GROUP ),
	ADD (DATABASE_ROLE_MEMBER_CHANGE_GROUP ),
	ADD (DBCC_GROUP ),
	ADD (FAILED_LOGIN_GROUP),
	ADD (LOGIN_CHANGE_PASSWORD_GROUP ),
	ADD (LOGOUT_GROUP),
	ADD (SCHEMA_OBJECT_ACCESS_GROUP),
	ADD (SCHEMA_OBJECT_CHANGE_GROUP ),
	ADD (SCHEMA_OBJECT_OWNERSHIP_CHANGE_GROUP ),
	ADD (SCHEMA_OBJECT_PERMISSION_CHANGE_GROUP ),
	ADD (SERVER_OBJECT_CHANGE_GROUP ),
	ADD (SERVER_OBJECT_OWNERSHIP_CHANGE_GROUP ),
	ADD (SERVER_OBJECT_PERMISSION_CHANGE_GROUP ),
	ADD (SERVER_OPERATION_GROUP ),
	ADD (SERVER_PERMISSION_CHANGE_GROUP ),
	ADD (SERVER_PRINCIPAL_IMPERSONATION_GROUP ),
	ADD (SERVER_PRINCIPAL_CHANGE_GROUP),
	ADD (SERVER_ROLE_MEMBER_CHANGE_GROUP ),
	ADD (SERVER_STATE_CHANGE_GROUP ),
	ADD (SUCCESSFUL_LOGIN_GROUP),	
	ADD (TRACE_CHANGE_GROUP ),
	ADD (USER_CHANGE_PASSWORD_GROUP)
WITH (STATE = ON);'
PRINT 'CREATE SERVER AUDIT SPECIFICATION [' + @auditName + '_SERVER_SPECIFICATION]'
EXEC(@createSpecification);


SET  @createSpecification = '
CREATE SERVER AUDIT SPECIFICATION [' + @auditName + '_applog_SERVER_SPECIFICATION]
FOR SERVER AUDIT [' + @auditName + '_applog]
	ADD (APPLICATION_ROLE_CHANGE_PASSWORD_GROUP ),
	ADD (AUDIT_CHANGE_GROUP ),
	ADD (BACKUP_RESTORE_GROUP ),
	ADD (DATABASE_CHANGE_GROUP ),
	ADD (DATABASE_OBJECT_ACCESS_GROUP ),
	ADD (DATABASE_OBJECT_CHANGE_GROUP ),
	ADD (DATABASE_OBJECT_OWNERSHIP_CHANGE_GROUP ),
	ADD (DATABASE_OBJECT_PERMISSION_CHANGE_GROUP ),
	ADD (DATABASE_OWNERSHIP_CHANGE_GROUP ),
	ADD (DATABASE_OPERATION_GROUP ),
	ADD (DATABASE_PERMISSION_CHANGE_GROUP ),
	ADD (DATABASE_PRINCIPAL_CHANGE_GROUP ),
	ADD (DATABASE_PRINCIPAL_IMPERSONATION_GROUP ),
	ADD (DATABASE_ROLE_MEMBER_CHANGE_GROUP ),
	ADD (DBCC_GROUP ),
	ADD (FAILED_LOGIN_GROUP),
	ADD (LOGIN_CHANGE_PASSWORD_GROUP ),
	ADD (LOGOUT_GROUP),
	ADD (SCHEMA_OBJECT_ACCESS_GROUP),
	ADD (SCHEMA_OBJECT_CHANGE_GROUP ),
	ADD (SCHEMA_OBJECT_OWNERSHIP_CHANGE_GROUP ),
	ADD (SCHEMA_OBJECT_PERMISSION_CHANGE_GROUP ),
	ADD (SERVER_OBJECT_CHANGE_GROUP ),
	ADD (SERVER_OBJECT_OWNERSHIP_CHANGE_GROUP ),
	ADD (SERVER_OBJECT_PERMISSION_CHANGE_GROUP ),
	ADD (SERVER_OPERATION_GROUP ),
	ADD (SERVER_PERMISSION_CHANGE_GROUP ),
	ADD (SERVER_PRINCIPAL_IMPERSONATION_GROUP ),
	ADD (SERVER_PRINCIPAL_CHANGE_GROUP),
	ADD (SERVER_ROLE_MEMBER_CHANGE_GROUP ),
	ADD (SERVER_STATE_CHANGE_GROUP ),
	ADD (SUCCESSFUL_LOGIN_GROUP),	
	ADD (TRACE_CHANGE_GROUP ),
	ADD (USER_CHANGE_PASSWORD_GROUP)
WITH (STATE = ON);'
PRINT 'CREATE SERVER AUDIT SPECIFICATION [' + @auditName + '_applog_SERVER_SPECIFICATION]'
EXEC(@createSpecification);



--Clean up:
DROP TABLE #SetupVars
