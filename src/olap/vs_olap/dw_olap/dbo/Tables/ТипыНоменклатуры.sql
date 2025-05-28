CREATE TABLE [dbo].[ТипыНоменклатуры] (
    [Ссылка]       UNIQUEIDENTIFIER NOT NULL,
    [Родитель]     UNIQUEIDENTIFIER NULL,
    [Наименование] NVARCHAR (255)   NULL
);



