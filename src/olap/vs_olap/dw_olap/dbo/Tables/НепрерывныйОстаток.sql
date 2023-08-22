CREATE TABLE [dbo].[НепрерывныйОстаток] (
    [Период]             DATETIME       NULL,
    [Номенклатура]       NVARCHAR (255) NULL,
    [Склад]              NVARCHAR (255) NULL,
    [НепрерывныйОстаток] BIGINT         NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_НепрерывныйОстаток_1]
    ON [dbo].[НепрерывныйОстаток]([Период] ASC);

