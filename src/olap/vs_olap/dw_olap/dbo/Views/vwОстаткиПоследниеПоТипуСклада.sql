--SELECT * FROM [dbo].[Склады]
CREATE VIEW [dbo].[vwОстаткиПоследниеПоТипуСклада] as
SELECT T.[Номенклатура], SUM(T.[Оптовый]) [КоличествоОстатокОптовый], SUM(T.[Розничный]) [КоличествоОстатокРозничный] FROM
(
	SELECT 
		rem.[Номенклатура]
		,CASE 
			WHEN  stor.[ВидСклада] = 'Оптовый' THEN rem.[КоличествоОстаток]
			ELSE 0
		END [Оптовый]
		,CASE 
			WHEN  stor.[ВидСклада] = 'Розничный' THEN rem.[КоличествоОстаток]
			ELSE 0
		END [Розничный]
	FROM
		[dbo].[НоменклатураОстаткиПоследние] rem
		LEFT JOIN [dbo].[Склады] stor on stor.Ссылка = rem.[Склад]
)T GROUP BY T.[Номенклатура]
