CREATE TABLE [dbo].[Регистр_НоменклатураОстаткиПоследние_Основной] (
    [Магазин]           UNIQUEIDENTIFIER NOT NULL,
    [Номенклатура]      UNIQUEIDENTIFIER NOT NULL,
    [КоличествоОстаток] DECIMAL (15, 5)  NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [PK_Main]
    ON [dbo].[Регистр_НоменклатураОстаткиПоследние_Основной]([Магазин] ASC, [Номенклатура] ASC);

