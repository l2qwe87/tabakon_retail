CREATE TABLE [dbo].[Документ_ВозвратТоваровОтПокупателя_Товары] (
    [СсылкаВладелец] UNIQUEIDENTIFIER NOT NULL,
    [НомерСтроки]    DECIMAL (15, 5)  NOT NULL,
    [Номенклатура]   UNIQUEIDENTIFIER NOT NULL,
    [Количество]     DECIMAL (15, 5)  NOT NULL,
    [Сумма]          DECIMAL (15, 5)  NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [PK_Rem_Main]
    ON [dbo].[Документ_ВозвратТоваровОтПокупателя_Товары]([СсылкаВладелец] ASC, [НомерСтроки] ASC)
   ;

