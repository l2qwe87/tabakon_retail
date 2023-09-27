CREATE TABLE [dbo].[Справочник_Номенклатура_Основной] (
    [Ссылка]             UNIQUEIDENTIFIER NOT NULL,
    [Наименование]       VARCHAR (255)    NULL,
    [Артикул]            VARCHAR (255)    NULL,
    [ГруппаМинОст]       VARCHAR (255)    NULL,
    [Код]                VARCHAR (255)    NULL,
    [НаименованиеПолное] VARCHAR (255)    NULL,
    [Родитель]           UNIQUEIDENTIFIER NULL,
    [Статус]             VARCHAR (255)    NULL,
    [ТипНоменклатуры]    UNIQUEIDENTIFIER NULL,
    [Услуга]             DECIMAL (15, 5)  NULL,
    [ЦеноваяГруппа]      UNIQUEIDENTIFIER NULL,
    [ЭтоГруппа]          DECIMAL (15, 5)  NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [PK_Main]
    ON [dbo].[Справочник_Номенклатура_Основной]([Ссылка] ASC);

