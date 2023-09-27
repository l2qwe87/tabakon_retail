CREATE TABLE [dbo].[Справочник_ЦеновыеГруппы_Основной] (
    [Ссылка]       UNIQUEIDENTIFIER NULL,
    [Наименование] VARCHAR (255)    NULL,
    [Родитель]     UNIQUEIDENTIFIER NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [PK_Main]
    ON [dbo].[Справочник_ЦеновыеГруппы_Основной]([Ссылка] ASC);

