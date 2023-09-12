/********************************************************************************
*
* V-213974; SQL6-D0-009700
* 
* Set a Password and Stoage path.
*
*********************************************************************************/

USE master;
GO
DECLARE @root AS VARCHAR(255);
SET @root = '\\management\share\SQL Scripts\SQLServers-MasterKeyBackup_V-213974\'

DECLARE @password AS VARCHAR(30);
SET  @password = '...';

DECLARE @path AS VARCHAR(255);
SET @path =  @root +  REPLACE(@@SERVERNAME,'\','_') + '.key';

DECLARE @sql AS VARCHAR(2000);
SET @sql = 'BACKUP MASTER KEY TO FILE = ''' + @path +  ''' ENCRYPTION BY PASSWORD = ''' +  @password + '''';
PRINT  @sql 

EXEC (@sql);


DECLARE @cmd AS VARCHAR(255)
SET @cmd = 'ECHO ''' +  @password +  ''' >> "' + @root +  REPLACE(@@SERVERNAME,'\','_') + 'password.txt"';
PRINT @cmd

