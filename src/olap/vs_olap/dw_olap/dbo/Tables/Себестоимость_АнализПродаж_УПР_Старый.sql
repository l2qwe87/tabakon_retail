CREATE TABLE [dbo].[Себестоимость_АнализПродаж_УПР_Старый] (
    [Период]                   DATETIME2 (7)    NOT NULL,
    [Регистратор]              UNIQUEIDENTIFIER NOT NULL,
    [Номенклатура]             UNIQUEIDENTIFIER NOT NULL,
    [СебестоимостьУПР]         DECIMAL (15, 5)  NULL,
    [СебестоимостьБезНДС_УПР]  DECIMAL (15, 5)  NULL,
    [Магазин]                  UNIQUEIDENTIFIER NOT NULL,
    [ПрибыльУПР]               DECIMAL (15, 5)  NULL,
    [СебестоимостьИтого]       DECIMAL (15, 5)  NULL,
    [РегистраторПредставление] NVARCHAR (255)   NULL,
    [Продажии]                 DECIMAL (15, 5)  NULL,
    [ПродажиБезНДС]            DECIMAL (15, 5)  NULL
) ON [Olap_mdf2];


GO
CREATE NONCLUSTERED INDEX [IX_1]
    ON [dbo].[Себестоимость_АнализПродаж_УПР_Старый]([Регистратор] ASC)
    INCLUDE([РегистраторПредставление])
    ON [Olap_mdf2];


GO
CREATE UNIQUE CLUSTERED INDEX [PK_Main]
    ON [dbo].[Себестоимость_АнализПродаж_УПР_Старый]([Период] ASC, [Магазин] ASC, [Номенклатура] ASC, [Регистратор] ASC)
    ON [Olap_mdf2];

