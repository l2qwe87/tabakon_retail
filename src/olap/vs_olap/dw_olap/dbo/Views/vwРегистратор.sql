





CREATE VIEW [dbo].[vwРегистратор] as

SELECT 
	[Ссылка]
    ,[СсылкаПредставление]
FROM [dbo].[ВозвратТоваровОтПокупателя] WITH (NOLOCK)
GROUP BY
	[Ссылка]
    ,[СсылкаПредставление]
UNION ALL 
SELECT 
	[Ссылка]
    ,[СсылкаПредставление]
FROM [dbo].[ОтчетОРозничныхПродажах] WITH (NOLOCK)
GROUP BY
	[Ссылка]
    ,[СсылкаПредставление]

UNION ALL 

SELECT
	Регистратор
	,РегистраторПредставление
FROM 
	[Себестоимость_АнализПродаж_УПР]
GROUP BY
	Регистратор
	,РегистраторПредставление

UNION ALL

--SELECT 
--	[DocRef]
--    ,[CashierCheckReportFriendlyName]
--FROM [RetailDocCashierCheck_Ref]

SELECT 
	[DocRef]
    ,[CashierCheckReportFriendlyName]
FROM [REAL_tabakon].[dbo].[RetailDocCashierCheck] WITH (NOLOCK)
GROUP BY
	[DocRef]
    ,[CashierCheckReportFriendlyName]


