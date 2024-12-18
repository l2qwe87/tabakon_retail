﻿
&НаКлиенте
Процедура Зарегистрировать(Команда)
	Если не ЗначениеЗаполнено(ТелефонКлиента) или не ЗначениеЗаполнено(ИмяКлиента) 
				или не ЗначениеЗаполнено(ДатаРождения)  тогда
		Сообщить("Заполните все поля!");
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Почта) тогда
		Если не ОбщегоНазначенияВызовСервера.EmailValid(Почта) тогда
			Сообщить("Неверно заполнена почта клиента!");
			Возврат;	
		КонецЕсли;
	КонецЕсли;
	
	Возраст	=	ВычислитьВозраст(ДатаРождения);
	
	Если Возраст <18 тогда
		Сообщить("Нельзя регистрировать клиентов меньше 18 лет!");
		Возврат;	
	КонецЕсли;  
	
	Если Найти(ТелефонКлиента, " ") или Лев(ТелефонКлиента,3) <> "+79" или СтрДлина(ТелефонКлиента) <> 12  тогда
		Сообщить("Неверно указан номер!");
		Возврат;		
	КонецЕсли;
	
	ЗапрещенныеСимволы = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!№;%:?*()@#$^&*";
	
	Для Ном = 1 по СтрДлина(ЗапрещенныеСимволы) цикл
		Если Найти(ИмяКлиента,Сред(ЗапрещенныеСимволы,Ном,1))  тогда
			Сообщить("В имени клиента присутствуют запрещенные символы!");
			Возврат;	
		КонецЕсли;
	КонецЦикла;
	
	Если Найти(ИмяКлиента,Символ(34))  тогда //кавычка
		Сообщить("В имени клиента присутствуют запрещенные символы!");
		Возврат;
	КонецЕсли; 
	
	ЗарегистрироватьНаСервере();	
КонецПроцедуры

&НаКлиенте
Процедура ТелефонКлиентаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	Если текст = "" тогда
		ЭтаФорма.ТекущийЭлемент.УстановитьГраницыВыделения(3,3);
	КонецЕсли;  
КонецПроцедуры

&НаСервере
Процедура ЗарегистрироватьНаСервере()
	//Перевод регистрации в офлайн
	рег = РегистрыСведений.ТБКРегистрацияКлиентов.СоздатьМенеджерЗаписи();
	Рег.Телефон			=	СокрЛП(ТелефонКлиента);
	Рег.Имя				=	ИмяКлиента;
	Рег.Почта			=	Почта;
	Рег.ДатаРождения	=	ДатаРождения;
	рег.Записать();
	флУспех				=	Истина;
	Сообщить("Клиент успешно зарегистрирован!");
	//
	//
	//Попытка
	//	Адрес			= "http://mx.tbkon.ru:1777/ut/ws/tbk_WebExchange?wsdl";
	//	Пользователь	= "WS_User_tbk";
	//	Пароль			= "123456";
	//	Таймаут			= 10;
	//	ТекстОшибки 	= "";
	//	ИмяСервиса 		= "tbk_WebExchange"; 
	//	ИмяСервисаСоап 	= "tbk_WebExchangeSoap";
	//	
	//	Определения = Новый WSОпределения(Адрес,Пользователь,Пароль, Таймаут);
	//	
	//	URI					=  "http://www.1c.ru/SaaS/1.0/WS_tbk_WebExchange";
	//	Прокси 				= Новый WSПрокси(Определения, URI, ИмяСервиса, ИмяСервисаСоап);
	//	Прокси.Пользователь = Пользователь;
	//	Прокси.Пароль 		= Пароль;	
	//Исключение
	//	Сообщить("Не удалось подключиться к УТ. Попробуйте выполнить действие позже. "+ОписаниеОшибки());
	//	Возврат; 
	//КонецПопытки; 	
	//
	//МассивВозврата	=	Новый Массив; 	
	//
	//эл	=	Новый Структура;
	//эл.Вставить("phone", 	СокрЛП(ТелефонКлиента));
	//эл.Вставить("update", 	"false");
	//эл.Вставить("fio", 		ИмяКлиента);
	//эл.Вставить("email",	Почта);
	//эл.Вставить("birthday", Строка(ДатаРождения));
	//
	//МассивВозврата.Добавить(эл);	
	//JS = ОбщегоНазначения.СтруктураВjson_Общая(МассивВозврата);

	//ОтветJS	=	Прокси.registration(JS);

	//МассивПринятый	=	ОбщегоНазначения.jsonВСтруктура_Общая(ОтветJS);

	//Для каждого Строка из МассивПринятый цикл 
	//	Результат	=	Строка.result;
	//	Если Результат = "false" тогда
	//		Сообщить("Не удалось зарегистрировать! "+Строка.description);
	//		Прокси	=	Неопределено;
	//	иначе
	//		флУспех	=	Истина;
	//		//регистрация в УТ прошла успешно. теперь регаем в самосейле
	//		//Куар	=	Строка.ID_S;
	//		Результат	=	Расш_SamosaleСоздатьКлиентаПослеНаСервере(СокрЛП(ТелефонКлиента));
	//		
	//		//Если Результат.КодСостояния >= 300 Тогда
	//		//	Сообщить(Строка(Результат.КодСостояния) + ". Возникла ошибка при создании клиента в системе Samosale. Клиент не зарегистрирован.");
	//		//ИначеЕсли Результат.КодСостояния = 200 Тогда
	//			Сообщить("Клиент успешно зарегистрирован!");
	//		//КонецЕсли;

	//	КонецЕсли; 		
	//КонецЦикла;

	//Прокси	=	Неопределено
	
КонецПроцедуры

Функция  Расш_SamosaleСоздатьКлиентаПослеНаСервере(Тел)
	ssl = Новый ЗащищенноеСоединениеOpenSSL();
	Соединение = Новый HTTPСоединение("app.samosale.ru",443,,,,,ssl);
	
	Токен	=	"_u2byml67gDNlFqGS6jf-BdadAd4ft4bC5tJt52K7qlu7hLbzr_Bev58frKQB-HE";	  
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Authorization", "Bearer " + Токен);
	Заголовки.Вставить("Content-Type", "application/json");
	
	Запрос = Новый HTTPЗапрос("api/cash-box/create-client", Заголовки);
	
	
	СтруктураДляJSON = Новый Структура;
    СтруктураДляJSON.Вставить("phone", Тел);
    //СтруктураДляJSON.Вставить("Куар", Куар);

	Запись = Новый ЗаписьJSON;
    Запись.УстановитьСтроку();
    ЗаписатьJSON(Запись,СтруктураДляJSON);
    ТелоЗапроса = Запись.Закрыть();
    Запрос.УстановитьТелоИзСтроки(ТелоЗапроса);
   		
	Результат = Соединение.ОтправитьДляОбработки(Запрос);
	
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	СтруктураВозврата = новый Структура;
	СтруктураВозврата.Вставить("флУспех",флУспех);
	СтруктураВозврата.Вставить("ТелефонКлиента",СокрЛП(ТелефонКлиента)); 
	СтруктураВозврата.Вставить("ИмяКлиента",СокрЛП(ИмяКлиента)); 

	ВладелецФормы.СтруктураВозвратаЗарегистрироватьКлиента = СтруктураВозврата;
КонецПроцедуры

&НаСерверебезКонтекста
Функция ВычислитьВозраст(ДатаРождения)

	Возраст = Год(Текущаядата()) - Год(ДатаРождения);	
	
	ДеньТекущий = День(Текущаядата());
	МесяцТекущий = Месяц(ТекущаяДата());
	
	ДеньРождения = День(ДатаРождения);
	МесяцРождения = Месяц(ДатаРождения);
	
	Если МесяцРождения > МесяцТекущий ИЛИ (МесяцРождения = МесяцТекущий И ДеньРождения > ДеньТекущий) Тогда
		
		Возраст = Возраст - 1;

	КонецЕсли;
	
	Возврат Возраст;	

КонецФункции 