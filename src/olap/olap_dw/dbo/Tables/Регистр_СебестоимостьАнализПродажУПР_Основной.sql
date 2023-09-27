CREATE TABLE [dbo].[Регистр_СебестоимостьАнализПродажУПР_Основной] (
    [Дата]                    DATETIME2 (7)    NOT NULL,
    [Магазин]                 UNIQUEIDENTIFIER NOT NULL,
    [Номенклатура]            UNIQUEIDENTIFIER NOT NULL,
    [ПрибыльУПР]              DECIMAL (15, 5)  NULL,
    [ПродажиБезНДС]           DECIMAL (15, 5)  NULL,
    [Продажии]                DECIMAL (15, 5)  NULL,
    [Регистратор]             UNIQUEIDENTIFIER NOT NULL,
    [СебестоимостьБезНДС_УПР] DECIMAL (15, 5)  NULL,
    [СебестоимостьИтого]      DECIMAL (15, 5)  NULL,
    [СебестоимостьУПР]        DECIMAL (15, 5)  NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [PK_Main]
    ON [dbo].[Регистр_СебестоимостьАнализПродажУПР_Основной]([Дата] ASC, [Магазин] ASC, [Номенклатура] ASC, [Регистратор] ASC);

