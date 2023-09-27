CREATE TABLE [dbo].[Документ_ВозвратТоваровПоставщику_Основной] (
    [Дата]                DATETIME2 (7)    NOT NULL,
    [Магазин]             UNIQUEIDENTIFIER NOT NULL,
    [Ссылка]              UNIQUEIDENTIFIER NOT NULL,
    [Организация]         UNIQUEIDENTIFIER NOT NULL,
    [Контрагент]          UNIQUEIDENTIFIER NOT NULL,
    [Номер]               VARCHAR (255)    NOT NULL,
    [СсылкаПредставление] VARCHAR (255)    NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [PK_Main]
    ON [dbo].[Документ_ВозвратТоваровПоставщику_Основной]([Дата] ASC, [Магазин] ASC, [Ссылка] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Ref]
    ON [dbo].[Документ_ВозвратТоваровПоставщику_Основной]([Ссылка] ASC);

