CREATE TABLE [dbo].[НоменклатураИерархия] (
    [Ссылка]       NVARCHAR (255)  NULL,
    [Родитель]     NVARCHAR (255)  NULL,
    [ЭтоГруппа]    DECIMAL (15, 5) NULL,
    [Код]          NVARCHAR (255)  NULL,
    [Наименование] NVARCHAR (255)  NULL
);

