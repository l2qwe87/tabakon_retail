CREATE TABLE [dbo].[НепрерывныйОстаток] (
    [Период]             DATETIME         NULL,
    [Номенклатура]       UNIQUEIDENTIFIER NOT NULL,
    [Склад]              UNIQUEIDENTIFIER NOT NULL,
    [НепрерывныйОстаток] BIGINT           NULL
);




GO
CREATE NONCLUSTERED INDEX [IX_НепрерывныйОстаток_1]
    ON [dbo].[НепрерывныйОстаток]([Период] ASC);


GO
CREATE CLUSTERED INDEX [PK_Main]
    ON [dbo].[НепрерывныйОстаток]([Период] ASC, [Склад] ASC, [Номенклатура] ASC);

