CREATE TABLE [dbo].[Регистр_ТоварыНаСкладахОбороты_Основной] (
    [Дата]                       DATETIME2 (7)    NOT NULL,
    [Магазин]                    UNIQUEIDENTIFIER NOT NULL,
    [Номенклатура]               UNIQUEIDENTIFIER NOT NULL,
    [КоличествоНачальныйОстаток] DECIMAL (15, 5)  NULL,
    [КоличествоКонечныйОстаток]  DECIMAL (15, 5)  NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [PK_Main]
    ON [dbo].[Регистр_ТоварыНаСкладахОбороты_Основной]([Дата] ASC, [Магазин] ASC, [Номенклатура] ASC);

