CREATE TABLE [dbo].[Справочник_Контрагенты_Основной] (
    [Ссылка]       UNIQUEIDENTIFIER NOT NULL,
    [Наименование] VARCHAR (255)    NOT NULL,
    [Родитель]     UNIQUEIDENTIFIER NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [PK_Main]
    ON [dbo].[Справочник_Контрагенты_Основной]([Ссылка] ASC);

