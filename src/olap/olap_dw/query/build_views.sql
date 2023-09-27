SELECT 
';CREATE VIEW [dbo].[vw_'+name+']
	AS SELECT * FROM ['+name+']
GO
' FROM sys.tables
