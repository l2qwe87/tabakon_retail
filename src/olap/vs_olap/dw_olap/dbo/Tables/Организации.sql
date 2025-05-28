CREATE TABLE [dbo].[Организации] (
    [Ссылка]             UNIQUEIDENTIFIER NOT NULL,
    [Код]                NVARCHAR (255)   NULL,
    [Наименование]       NVARCHAR (255)   NULL,
    [НаименованиеПолное] NVARCHAR (255)   NULL,
    [ИНН]                NVARCHAR (255)   NULL
);




GO
CREATE UNIQUE CLUSTERED INDEX [PK_Main]
    ON [dbo].[Организации]([Ссылка] ASC);

