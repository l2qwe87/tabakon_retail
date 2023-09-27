CREATE TABLE [dbo].[Справочник_ТипыНоменклатуры_Основной] (
    [Ссылка]       UNIQUEIDENTIFIER NOT NULL,
    [Наименование] VARCHAR (255)    NULL,
    [Родитель]     UNIQUEIDENTIFIER NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [PK_Main]
    ON [dbo].[Справочник_ТипыНоменклатуры_Основной]([Ссылка] ASC);

