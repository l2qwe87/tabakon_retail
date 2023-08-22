CREATE TABLE [dbo].[Себестоимость_АнализПродаж_УПР] (
    [Период]                   DATETIME2 (7)    NULL,
    [Регистратор]              UNIQUEIDENTIFIER NOT NULL,
    [Номенклатура]             UNIQUEIDENTIFIER NULL,
    [СебестоимостьУПР]         DECIMAL (15, 5)  NULL,
    [СебестоимостьБезНДС_УПР]  DECIMAL (15, 5)  NULL,
    [Магазин]                  UNIQUEIDENTIFIER NULL,
    [ПрибыльУПР]               DECIMAL (15, 5)  NULL,
    [СебестоимостьИтого]       DECIMAL (15, 5)  NULL,
    [РегистраторПредставление] NVARCHAR (255)   NULL,
    [Продажии]                 DECIMAL (15, 5)  NULL,
    [ПродажиБезНДС]            DECIMAL (15, 5)  NULL
);

