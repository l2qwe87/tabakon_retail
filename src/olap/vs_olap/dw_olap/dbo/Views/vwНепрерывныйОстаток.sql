
CREATE VIEW [dbo].[vwНепрерывныйОстаток] WITH SCHEMABINDING as
SELECT    DISTINCT    c.date_[Период], nomen.[Номенклатура], nomen.[Склад], CAST(IIF(rem.КоличествоОборот IS NULL, 1, 0) AS bigint) AS [НепрерывныйОстаток]
FROM            (SELECT        [Номенклатура], [Склад]
                          FROM            [dbo].[ТоварыОбороты] nomen
                          GROUP BY [Номенклатура], [Склад]) AS nomen LEFT JOIN
                             (SELECT        MIN([Период]) dateBegin, MAX([Период]) dateEnd
                               FROM            [dbo].[ТоварыОбороты] period) AS period ON 1 = 1 INNER JOIN
                         [dbo].[Calendar] c ON c.date_ >= period.dateBegin AND c.date_ <= period.dateEnd LEFT JOIN
                         [dbo].[ТоварыОбороты] rem ON rem.[Период] = c.date_ AND rem.[Номенклатура] = nomen.[Номенклатура] AND rem.[Склад] = nomen.[Склад]
