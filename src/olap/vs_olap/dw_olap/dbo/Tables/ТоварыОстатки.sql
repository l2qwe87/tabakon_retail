CREATE TABLE [dbo].[ТоварыОстатки] (
    [Период]                     DATETIME2 (7)    NULL,
    [Склад]                      UNIQUEIDENTIFIER NOT NULL,
    [Номенклатура]               NVARCHAR (255)   NULL,
    [КоличествоНачальныйОстаток] DECIMAL (15, 5)  NULL,
    [КоличествоКонечныйОстаток]  DECIMAL (15, 5)  NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_OLAP_2]
    ON [dbo].[ТоварыОстатки]([Период] ASC);

