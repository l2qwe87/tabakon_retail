CREATE TABLE [dbo].[Регистр_НоменклатураЦеныПоследние_Основной] (
    [Номенклатура]     UNIQUEIDENTIFIER NOT NULL,
    [Закупочная]       DECIMAL (15, 5)  NULL,
    [РасчетнаяБазовая] DECIMAL (15, 5)  NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [PK_Main]
    ON [dbo].[Регистр_НоменклатураЦеныПоследние_Основной]([Номенклатура] ASC);

