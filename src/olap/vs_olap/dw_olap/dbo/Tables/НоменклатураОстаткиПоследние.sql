CREATE TABLE [dbo].[НоменклатураОстаткиПоследние] (
    [Склад]             NVARCHAR (255)  NULL,
    [Номенклатура]      NVARCHAR (255)  NULL,
    [КоличествоОстаток] DECIMAL (15, 5) NULL
);


GO
CREATE NONCLUSTERED INDEX [vw_byType]
    ON [dbo].[НоменклатураОстаткиПоследние]([Склад] ASC)
    INCLUDE([Номенклатура], [КоличествоОстаток]);

