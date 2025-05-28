CREATE TABLE [dbo].[ПерсональныеДанныеКлиентов] (
    [Телефон]         NVARCHAR (255) NULL,
    [ID]              NVARCHAR (255) NULL,
    [Имя]             NVARCHAR (255) NULL,
    [Фамилия]         NVARCHAR (255) NULL,
    [Отчество]        NVARCHAR (255) NULL,
    [Почта]           NVARCHAR (255) NULL,
    [ДатаРождения]    DATETIME2 (7)  NULL,
    [Пароль]          NVARCHAR (255) NULL,
    [ДатаРегистрации] DATETIME2 (7)  NULL,
    [Samosale_ID]     NVARCHAR (255) NULL,
    [Telegram_ID]     NVARCHAR (255) NULL,
    [ID_S]            NVARCHAR (255) NULL
);


GO
CREATE CLUSTERED INDEX [IX_pk]
    ON [dbo].[ПерсональныеДанныеКлиентов]([ID] ASC);

