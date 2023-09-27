CREATE TABLE [dbo].[Справочник_Магазины_Основной] (
    [Ссылка]        UNIQUEIDENTIFIER NOT NULL,
    [Код]           VARCHAR (255)    NULL,
    [Наименование]  VARCHAR (255)    NULL,
    [ПочтовыйЯщик]  VARCHAR (255)    NULL,
    [Адрес]         VARCHAR (255)    NULL,
    [ВидСклада]     VARCHAR (255)    NULL,
    [Город]         VARCHAR (255)    NULL,
    [Ответственный] VARCHAR (255)    NULL,
    [ЭтоГруппа]     DECIMAL (15, 5)  NULL,
    [ЮрЛицо]        VARCHAR (255)    NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [PK_Main]
    ON [dbo].[Справочник_Магазины_Основной]([Ссылка] ASC);

