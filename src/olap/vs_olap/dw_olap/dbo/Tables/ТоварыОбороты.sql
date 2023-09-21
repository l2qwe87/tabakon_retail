CREATE TABLE [dbo].[ТоварыОбороты] (
    [Период]           DATETIME2 (7)   NULL,
    [ТипДвижения]      NVARCHAR (255)  NULL,
    [Склад]            NVARCHAR (255)  NULL,
    [Номенклатура]     NVARCHAR (255)  NULL,
    [КоличествоОборот] DECIMAL (15, 5) NULL,
    [КоличествоПриход] DECIMAL (15, 5) NULL,
    [КоличествоРасход] DECIMAL (15, 5) NULL
);


GO
CREATE NONCLUSTERED INDEX [_IX_ТоварыОбороты_UPLOAD]
    ON [dbo].[ТоварыОбороты]([Склад] ASC, [Период] ASC);

