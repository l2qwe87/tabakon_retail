CREATE TABLE [dbo].[prt_ТоварыОстатки] (
    [Период]                     DATETIME2 (7)    NULL,
    [Склад]                      UNIQUEIDENTIFIER NOT NULL,
    [Номенклатура]               UNIQUEIDENTIFIER NOT NULL,
    [КоличествоНачальныйОстаток] DECIMAL (15, 5)  NULL,
    [КоличествоКонечныйОстаток]  DECIMAL (15, 5)  NULL
) ON [Olap_mdf2];


GO
CREATE UNIQUE CLUSTERED INDEX [PK_Rem_Main]
    ON [dbo].[prt_ТоварыОстатки]([Период] ASC, [Склад] ASC, [Номенклатура] ASC)
    ON [Olap_mdf2];

