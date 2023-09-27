CREATE TABLE [dbo].[Справочник_Организации_Основной] (
    [Ссылка]             UNIQUEIDENTIFIER NOT NULL,
    [Код]                VARCHAR (255)    NULL,
    [ИНН]                VARCHAR (255)    NULL,
    [Наименование]       VARCHAR (255)    NOT NULL,
    [НаименованиеПолное] VARCHAR (255)    NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [PK_Main]
    ON [dbo].[Справочник_Организации_Основной]([Ссылка] ASC);

