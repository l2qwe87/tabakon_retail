CREATE TABLE [dbo].[ПоступлениеТоваровУслуг] (
    [Ссылка]                                   UNIQUEIDENTIFIER NOT NULL,
    [НомерСтроки]                              DECIMAL (15, 5)  NULL,
    [Номер]                                    NVARCHAR (255)   NULL,
    [Дата]                                     DATETIME2 (7)    NULL,
    [Склад]                                    NVARCHAR (255)   NULL,
    [Номенклатура]                             NVARCHAR (255)   NULL,
    [Цена]                                     DECIMAL (15, 5)  NULL,
    [Количество]                               DECIMAL (15, 5)  NULL,
    [Сумма]                                    DECIMAL (15, 5)  NULL,
    [ХарактеристикаНоменклатуры]               UNIQUEIDENTIFIER NULL,
    [Организация]                              NVARCHAR (255)   NULL,
    [Контрагент]                               NVARCHAR (255)   NULL,
    [КонтрагентНаименование]                   NVARCHAR (255)   NULL,
    [КонтрагентГоловнойКонтрагент]             UNIQUEIDENTIFIER NULL,
    [КонтрагентГоловнойКонтрагентНаименование] NVARCHAR (255)   NULL
);


GO
CREATE NONCLUSTERED INDEX [_IX_vwSupply_1]
    ON [dbo].[ПоступлениеТоваровУслуг]([Номенклатура] ASC)
    INCLUDE([НомерСтроки], [Номер], [Дата], [Склад], [Цена], [Количество], [Сумма], [Организация]);


GO
CREATE NONCLUSTERED INDEX [_IX_ПоступлениеТоваровУслуг_UPLOAD]
    ON [dbo].[ПоступлениеТоваровУслуг]([Склад] ASC, [Дата] ASC);


GO
CREATE NONCLUSTERED INDEX [zzz_IX_ПоступлениеТоваровУслуг_avgU_1165]
    ON [dbo].[ПоступлениеТоваровУслуг]([Дата] ASC)
    INCLUDE([НомерСтроки], [Номер], [Склад], [Номенклатура], [Цена], [Количество], [Сумма], [Организация]);

