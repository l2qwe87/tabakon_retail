CREATE TABLE [dbo].[ОтчетОРозничныхПродажах] (
    [Ссылка]                     NVARCHAR (255)  NULL,
    [СсылкаПредставление]        NVARCHAR (255)  NULL,
    [НомерСтроки]                DECIMAL (15, 5) NULL,
    [Номер]                      NVARCHAR (255)  NULL,
    [Дата]                       DATETIME2 (7)   NULL,
    [Магазин]                    NVARCHAR (255)  NULL,
    [Номенклатура]               NVARCHAR (255)  NULL,
    [Цена]                       DECIMAL (15, 5) NULL,
    [Количество]                 DECIMAL (15, 5) NULL,
    [Сумма]                      DECIMAL (15, 5) NULL,
    [ХарактеристикаНоменклатуры] NVARCHAR (255)  NULL,
    [Организация]                NVARCHAR (255)  NULL,
    [Себестоимость]              DECIMAL (15, 5) NULL
);


GO
CREATE NONCLUSTERED INDEX [_IX_ОтчетОРозничныхПродажах_UPLOAD_2]
    ON [dbo].[ОтчетОРозничныхПродажах]([Магазин] ASC, [Дата] ASC);


GO
CREATE NONCLUSTERED INDEX [zzz_IX_ОтчетОРозничныхПродажах_avgU_483]
    ON [dbo].[ОтчетОРозничныхПродажах]([Дата] ASC)
    INCLUDE([Ссылка], [СсылкаПредставление], [НомерСтроки], [Номер], [Магазин], [Номенклатура], [Цена], [Количество], [Сумма], [ХарактеристикаНоменклатуры], [Организация], [Себестоимость]);

