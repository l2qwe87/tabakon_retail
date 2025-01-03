﻿CREATE TABLE [dbo].[ВозвратТоваровПоставщику] (
    [Ссылка]                     UNIQUEIDENTIFIER NOT NULL,
    [НомерСтроки]                DECIMAL (15, 5)  NULL,
    [Номер]                      NVARCHAR (255)   NULL,
    [Дата]                       DATETIME2 (7)    NULL,
    [Склад]                      UNIQUEIDENTIFIER NULL,
    [Номенклатура]               UNIQUEIDENTIFIER NULL,
    [Цена]                       DECIMAL (15, 5)  NULL,
    [Количество]                 DECIMAL (15, 5)  NULL,
    [Сумма]                      DECIMAL (15, 5)  NULL,
    [ХарактеристикаНоменклатуры] UNIQUEIDENTIFIER NULL,
    [Организация]                UNIQUEIDENTIFIER NULL
);

