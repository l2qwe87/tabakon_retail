CREATE TABLE [dbo].[Регистр_ИсторияПокупокРозница_Основной] (
    [Дата]                       DATETIME2 (7)    NOT NULL,
    [Магазин]                    UNIQUEIDENTIFIER NOT NULL,
    [IDКлиента]                  VARCHAR (255)    NOT NULL,
    [ВидОперации]                VARCHAR (255)    NULL,
    [КоличествоБаллов]           DECIMAL (15, 5)  NULL,
    [ОтправленоСообщениеКлиенту] DECIMAL (15, 5)  NULL,
    [ОшибкаОтправки]             VARCHAR (255)    NULL,
    [Сумма]                      DECIMAL (15, 5)  NULL,
    [флОтправленВСС]             DECIMAL (15, 5)  NULL,
    [Чек]                        VARCHAR (255)    NOT NULL,
    [ЧекПродажа]                 VARCHAR (255)    NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [PK_Rem_Main]
    ON [dbo].[Регистр_ИсторияПокупокРозница_Основной]([Дата] ASC, [Магазин] ASC, [IDКлиента] ASC, [Чек] ASC);

