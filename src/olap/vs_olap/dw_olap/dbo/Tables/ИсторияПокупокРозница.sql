CREATE TABLE [dbo].[ИсторияПокупокРозница] (
    [IDКлиента]                  NVARCHAR (255)  NULL,
    [Чек]                        NVARCHAR (255)  NULL,
    [Магазин]                    NVARCHAR (255)  NULL,
    [Дата]                       DATETIME2 (7)   NULL,
    [Товары]                     NVARCHAR (255)  NULL,
    [Сумма]                      DECIMAL (15, 5) NULL,
    [ВидОперации]                NVARCHAR (255)  NULL,
    [КоличествоБаллов]           DECIMAL (15, 5) NULL,
    [ЧекПродажа]                 NVARCHAR (255)  NULL,
    [флОтправленВСС]             DECIMAL (15, 5) NULL,
    [ОтправленоСообщениеКлиенту] DECIMAL (15, 5) NULL,
    [ОшибкаОтправки]             NVARCHAR (255)  NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_ИсторияПокупокРозница]
    ON [dbo].[ИсторияПокупокРозница]([Магазин] ASC, [Дата] ASC);

