CREATE TABLE [dbo].[НоменклатураСвойства] (
    [Номенклатура]       UNIQUEIDENTIFIER NOT NULL,
    [Бренд]              NVARCHAR (255)   NULL,
    [Класс]              NVARCHAR (255)   NULL,
    [Формат]             NVARCHAR (255)   NULL,
    [Рейтинг_продаж]     NVARCHAR (255)   NULL,
    [Количество_затяжек] NVARCHAR (255)   NULL,
    [Вкус]               NVARCHAR (255)   NULL
);




GO
CREATE UNIQUE CLUSTERED INDEX [PK_Main]
    ON [dbo].[НоменклатураСвойства]([Номенклатура] ASC);

