CREATE TABLE [dbo].[НоменклатураИерархия] (
    [Ссылка]       UNIQUEIDENTIFIER NOT NULL,
    [Родитель]     UNIQUEIDENTIFIER NULL,
    [ЭтоГруппа]    DECIMAL (15, 5)  NULL,
    [Код]          NVARCHAR (255)   NULL,
    [Наименование] NVARCHAR (255)   NULL
);




GO
CREATE UNIQUE CLUSTERED INDEX [PK_Main]
    ON [dbo].[НоменклатураИерархия]([Ссылка] ASC);

