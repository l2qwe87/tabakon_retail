CREATE TABLE [dbo].[ПоступлениеТоваровУслуг] (
    [Ссылка]                                   UNIQUEIDENTIFIER NOT NULL,
    [НомерСтроки]                              DECIMAL (15, 5)  NULL,
    [Номер]                                    NVARCHAR (255)   NULL,
    [Дата]                                     DATETIME2 (7)    NULL,
    [Склад]                                    UNIQUEIDENTIFIER NOT NULL,
    [Номенклатура]                             UNIQUEIDENTIFIER NOT NULL,
    [Цена]                                     DECIMAL (15, 5)  NULL,
    [Количество]                               DECIMAL (15, 5)  NULL,
    [Сумма]                                    DECIMAL (15, 5)  NULL,
    [ХарактеристикаНоменклатуры]               UNIQUEIDENTIFIER NULL,
    [Организация]                              UNIQUEIDENTIFIER NULL,
    [Контрагент]                               UNIQUEIDENTIFIER NULL,
    [КонтрагентНаименование]                   NVARCHAR (255)   NULL,
    [КонтрагентГоловнойКонтрагент]             UNIQUEIDENTIFIER NULL,
    [КонтрагентГоловнойКонтрагентНаименование] NVARCHAR (255)   NULL
) ON [Olap_mdf2];




GO



GO



GO
CREATE UNIQUE CLUSTERED INDEX [PK_Main]
    ON [dbo].[ПоступлениеТоваровУслуг]([Дата] ASC, [Склад] ASC, [Номенклатура] ASC, [Ссылка] ASC, [НомерСтроки] ASC)
    ON [Olap_mdf2];

