-- Note 'common criteria compliance enabled' does not exist on certain servers, ie SQL00

sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
sp_configure 'common criteria compliance enabled', 1;
GO
RECONFIGURE WITH OVERRIDE;
GO

