CREATE TABLE [dbo].[ОтчетОРозничныхПродажах] (
    [Ссылка]                     UNIQUEIDENTIFIER NOT NULL,
    [СсылкаПредставление]        NVARCHAR (255)   NULL,
    [НомерСтроки]                DECIMAL (15, 5)  NULL,
    [Номер]                      NVARCHAR (255)   NULL,
    [Дата]                       DATETIME2 (7)    NULL,
    [Магазин]                    UNIQUEIDENTIFIER NOT NULL,
    [Номенклатура]               UNIQUEIDENTIFIER NOT NULL,
    [Цена]                       DECIMAL (15, 5)  NULL,
    [Количество]                 DECIMAL (15, 5)  NULL,
    [Сумма]                      DECIMAL (15, 5)  NULL,
    [ХарактеристикаНоменклатуры] NVARCHAR (255)   NULL,
    [Организация]                UNIQUEIDENTIFIER NULL,
    [Себестоимость]              DECIMAL (15, 5)  NULL
) ON [Olap_mdf2];




GO



GO
CREATE UNIQUE CLUSTERED INDEX [PK_Main]
    ON [dbo].[ОтчетОРозничныхПродажах]([Дата] ASC, [Магазин] ASC, [Номенклатура] ASC, [Ссылка] ASC, [НомерСтроки] ASC)
    ON [Olap_mdf2];


GO
CREATE NONCLUSTERED INDEX [IX_1]
    ON [dbo].[ОтчетОРозничныхПродажах]([Ссылка] ASC)
    INCLUDE([СсылкаПредставление])
    ON [Olap_mdf2];

