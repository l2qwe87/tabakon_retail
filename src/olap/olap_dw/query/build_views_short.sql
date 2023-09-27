SELECT 
';CREATE VIEW [dbo].[vw_'+t.name+']
	AS SELECT * FROM [olap_dw].[dbo].['+t.name+'] 
	'+IIF(cDate.column_id IS NULL,'', 'WHERE [Дата] > DATEADD(DAY,-120,GETDATE())')+'
GO
'
FROM sys.tables t
	LEFT JOIN sys.all_columns cDate ON cDate.object_id = t.object_id AND cDate.name = 'Дата'