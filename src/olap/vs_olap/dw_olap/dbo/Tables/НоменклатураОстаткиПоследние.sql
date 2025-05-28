CREATE TABLE [dbo].[НоменклатураОстаткиПоследние] (
    [Склад]             UNIQUEIDENTIFIER NOT NULL,
    [Номенклатура]      UNIQUEIDENTIFIER NOT NULL,
    [КоличествоОстаток] DECIMAL (15, 5)  NULL
);




GO
CREATE UNIQUE CLUSTERED INDEX [PK_Main]
    ON [dbo].[НоменклатураОстаткиПоследние]([Склад] ASC, [Номенклатура] ASC);

