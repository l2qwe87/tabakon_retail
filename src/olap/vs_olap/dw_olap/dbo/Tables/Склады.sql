CREATE TABLE [dbo].[Склады] (
    [Ссылка]        UNIQUEIDENTIFIER NULL,
    [ЭтоГруппа]     DECIMAL (15, 5)  NULL,
    [Код]           NVARCHAR (255)   NULL,
    [Наименование]  NVARCHAR (255)   NULL,
    [ВидСклада]     NVARCHAR (255)   NULL,
    [ПочтовыйЯщик]  NVARCHAR (255)   NULL,
    [Адрес]         NVARCHAR (255)   NULL,
    [Город]         NVARCHAR (255)   NULL,
    [Ответственный] NVARCHAR (255)   NULL,
    [ЮрЛицо]        NVARCHAR (255)   NULL
);

