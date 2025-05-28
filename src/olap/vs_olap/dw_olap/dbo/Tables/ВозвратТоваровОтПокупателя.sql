CREATE TABLE [dbo].[ВозвратТоваровОтПокупателя] (
    [Ссылка]                     UNIQUEIDENTIFIER NOT NULL,
    [СсылкаПредставление]        NVARCHAR (255)   NULL,
    [НомерСтроки]                DECIMAL (15, 5)  NULL,
    [Номер]                      NVARCHAR (255)   NULL,
    [Дата]                       DATETIME2 (7)    NULL,
    [Магазин]                    UNIQUEIDENTIFIER NOT NULL,
    [Номенклатура]               UNIQUEIDENTIFIER NULL,
    [Цена]                       DECIMAL (15, 5)  NULL,
    [Количество]                 DECIMAL (15, 5)  NULL,
    [Сумма]                      DECIMAL (15, 5)  NULL,
    [ХарактеристикаНоменклатуры] UNIQUEIDENTIFIER NULL,
    [Организация]                UNIQUEIDENTIFIER NULL
);




GO
CREATE UNIQUE CLUSTERED INDEX [PK_Main]
    ON [dbo].[ВозвратТоваровОтПокупателя]([Дата] ASC, [Магазин] ASC, [Номенклатура] ASC, [Ссылка] ASC, [НомерСтроки] ASC);

