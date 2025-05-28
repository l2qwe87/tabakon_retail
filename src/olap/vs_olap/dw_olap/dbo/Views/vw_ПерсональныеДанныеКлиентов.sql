
CREATE VIEW vw_ПерсональныеДанныеКлиентов AS 

SELECT        Телефон, ID, Имя, Фамилия, Отчество, Почта,


CASE WHEN ДатаРождения < '19000101' THEN NULL ELSE ДатаРождения END ДатаРождения


, Пароль, 
CASE WHEN ДатаРегистрации < '19000101' THEN NULL ELSE ДатаРегистрации END ДатаРегистрации


, Samosale_ID, Telegram_ID, ID_S
FROM            ПерсональныеДанныеКлиентов