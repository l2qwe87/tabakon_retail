







CREATE VIEW [dbo].[vwРегистратор] as

SELECT 
	[Ссылка]
    ,[СсылкаПредставление]
FROM [dbo].[ВозвратТоваровОтПокупателя] WITH (NOLOCK)
GROUP BY
	[Ссылка]
    ,[СсылкаПредставление]

UNION
--UNION ALL 

SELECT 
	[Ссылка]
    ,[СсылкаПредставление]
FROM [dbo].[ОтчетОРозничныхПродажах] WITH (NOLOCK)
GROUP BY
	[Ссылка]
    ,[СсылкаПредставление]

UNION
--UNION ALL 

SELECT
	Регистратор
	,РегистраторПредставление
FROM 
	[Себестоимость_АнализПродаж_УПР]
GROUP BY
	Регистратор
	,РегистраторПредставление

UNION
--UNION ALL

--SELECT 
--	[DocRef]
--    ,[CashierCheckReportFriendlyName]
--FROM [RetailDocCashierCheck_Ref]

SELECT 
	CAST([DocRef] as uniqueidentifier)
    ,[CashierCheckReportFriendlyName]
FROM [REAL_tabakon].[dbo].[RetailDocCashierCheck] WITH (NOLOCK)
GROUP BY
	CAST([DocRef] as uniqueidentifier)
    ,[CashierCheckReportFriendlyName]


