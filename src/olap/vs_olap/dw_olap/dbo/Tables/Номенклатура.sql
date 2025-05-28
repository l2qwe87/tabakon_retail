CREATE TABLE [dbo].[Номенклатура] (
    [Ссылка]                              UNIQUEIDENTIFIER NOT NULL,
    [Родитель]                            UNIQUEIDENTIFIER NULL,
    [ЭтоГруппа]                           DECIMAL (15, 5)  NULL,
    [Код]                                 NVARCHAR (255)   NULL,
    [Наименование]                        NVARCHAR (255)   NULL,
    [Артикул]                             NVARCHAR (255)   NULL,
    [БазоваяЕдиницаИзмеренияНаименование] NVARCHAR (255)   NULL,
    [ЕдиницаХраненияОстатковНаименование] NVARCHAR (255)   NULL,
    [ЕдиницаДляОтчетовНаименование]       NVARCHAR (255)   NULL,
    [ВестиУчетПоХарактеристикам]          DECIMAL (15, 5)  NULL,
    [НаименованиеПолное]                  NVARCHAR (255)   NULL,
    [Услуга]                              DECIMAL (15, 5)  NULL,
    [Статус]                              NVARCHAR (255)   NULL,
    [Представление]                       NVARCHAR (255)   NULL,
    [РодительНаименование]                NVARCHAR (255)   NULL,
    [ОсновнойПоставщик]                   NVARCHAR (255)   NULL,
    [ЦеноваяГруппа]                       UNIQUEIDENTIFIER NULL,
    [ТипНоменклатуры]                     UNIQUEIDENTIFIER NULL,
    [Родитель1]                           NVARCHAR (255)   NULL,
    [Родитель2]                           NVARCHAR (255)   NULL,
    [Родитель3]                           NVARCHAR (255)   NULL,
    [Родитель4]                           NVARCHAR (255)   NULL,
    [Родитель5]                           NVARCHAR (255)   NULL,
    [Родитель6]                           NVARCHAR (255)   NULL,
    [Родитель7]                           NVARCHAR (255)   NULL,
    [Родитель8]                           NVARCHAR (255)   NULL,
    [Родитель9]                           NVARCHAR (255)   NULL,
    [Уровень1]                            NVARCHAR (255)   NULL,
    [Уровень2]                            NVARCHAR (255)   NULL,
    [Уровень3]                            NVARCHAR (255)   NULL,
    [Уровень4]                            NVARCHAR (255)   NULL,
    [ГруппаМинОст]                        NVARCHAR (255)   NULL
);




GO
CREATE UNIQUE CLUSTERED INDEX [IX_PK]
    ON [dbo].[Номенклатура]([Ссылка] ASC);

