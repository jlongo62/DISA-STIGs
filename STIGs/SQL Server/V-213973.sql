/********************************************************************************
*
* V-213973; SQL6-D0-009600
* 
* Set a Password and Stoage path.
*
*********************************************************************************/

USE master;
GO
DECLARE @root AS VARCHAR(255);
SET @root = '\\management\share\SQL Scripts\SQLServers-ServiceKeyBackup_V-213973\'

DECLARE @password AS VARCHAR(30);
SET  @password = '....';

DECLARE @path AS VARCHAR(255);
SET @path =  @root +  REPLACE(@@SERVERNAME,'\','_') + '.key';

DECLARE @sql AS VARCHAR(2000);
SET @sql = 'BACKUP SERVICE MASTER KEY TO FILE = ''' + @path +  ''' ENCRYPTION BY PASSWORD = ''' +  @password + '''';
PRINT  @sql 
EXEC (@sql);


DECLARE @cmd AS VARCHAR(255)
SET @cmd = 'ECHO ''' +  @password +  ''' >> "' + @root +  REPLACE(@@SERVERNAME,'\','_') + 'password.txt"';
PRINT @cmd

/************************************
* WRITE PAssword file
************************************/
BEGIN TRY
	exec xp_cmdshell @cmd ;
END TRY

BEGIN CATCH

	EXECUTE sp_configure 'xp_cmdshell', 1;
	RECONFIGURE WITH OVERRIDE;

	exec xp_cmdshell @cmd ;

	EXECUTE sp_configure 'xp_cmdshell', 0;
	RECONFIGURE WITH OVERRIDE;

END CATCH
