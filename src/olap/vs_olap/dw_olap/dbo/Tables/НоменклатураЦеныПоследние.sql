CREATE TABLE [dbo].[НоменклатураЦеныПоследние] (
    [Номенклатура]      UNIQUEIDENTIFIER NOT NULL,
    [закупочная]        DECIMAL (15, 5)  NULL,
    [Расчетная_Базовая] DECIMAL (15, 5)  NULL
);




GO
CREATE UNIQUE CLUSTERED INDEX [PK_Main]
    ON [dbo].[НоменклатураЦеныПоследние]([Номенклатура] ASC);

