------------------------------------------------------------------
-- List Problem Accounts
------------------------------------------------------------------

SELECT [name] FROM sys.sql_logins
WHERE is_policy_checked <> 1 or is_expiration_checked <> 1
AND (is_disabled <> 1 OR name NOT IN('sa', '##MS_PolicyTsqlExecutionLogin##', '##MS_PolicyEventProcessingLogin##'))


------------------------------------------------------------------
-- Caution: Fix ALL Accounts
------------------------------------------------------------------
DECLARE @name VARCHAR(50) 
DECLARE @sql VARCHAR(500) 
DECLARE db_cursor CURSOR FOR 
SELECT [name] FROM sys.sql_logins 
WHERE is_policy_checked <> 1 or is_expiration_checked <> 1 
AND (is_disabled <> 1 OR name NOT IN('sa', '##MS_PolicyTsqlExecutionLogin##', '##MS_PolicyEventProcessingLogin##'))

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @name 

WHILE @@FETCH_STATUS = 0  
BEGIN  
	
	SET  @sql = 'ALTER LOGIN [' + @name+ '] WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=ON, CHECK_POLICY=ON'
	PRINT @sql;
	EXEC(@sql);
	FETCH NEXT FROM db_cursor INTO @name 

END 

CLOSE db_cursor  
DEALLOCATE db_cursor 
