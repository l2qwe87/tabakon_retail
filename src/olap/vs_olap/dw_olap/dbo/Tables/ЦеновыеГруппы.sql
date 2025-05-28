CREATE TABLE [dbo].[ЦеновыеГруппы] (
    [Ссылка]       UNIQUEIDENTIFIER NOT NULL,
    [Родитель]     UNIQUEIDENTIFIER NULL,
    [Наименование] NVARCHAR (255)   NULL
);



