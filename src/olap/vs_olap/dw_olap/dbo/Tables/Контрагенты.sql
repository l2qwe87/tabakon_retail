CREATE TABLE [dbo].[Контрагенты] (
    [Ссылка]               UNIQUEIDENTIFIER NOT NULL,
    [Наименование]         NVARCHAR (255)   NULL,
    [Родитель]             UNIQUEIDENTIFIER NULL,
    [РодительНаименование] NVARCHAR (255)   NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [PK_Main]
    ON [dbo].[Контрагенты]([Ссылка] ASC);

