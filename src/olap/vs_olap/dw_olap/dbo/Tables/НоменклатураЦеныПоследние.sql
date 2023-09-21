CREATE TABLE [dbo].[НоменклатураЦеныПоследние] (
    [Номенклатура]      NVARCHAR (255)  NULL,
    [закупочная]        DECIMAL (15, 5) NULL,
    [Расчетная_Базовая] DECIMAL (15, 5) NULL
);


GO
CREATE CLUSTERED INDEX [ClusteredIndex-20230801-014223]
    ON [dbo].[НоменклатураЦеныПоследние]([Номенклатура] ASC);

