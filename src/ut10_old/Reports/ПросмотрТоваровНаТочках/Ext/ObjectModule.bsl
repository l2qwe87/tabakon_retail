﻿Перем Прокси;
Перем V83COMCon;
Перем Единение;

Функция ПодключитьсяКFTPСерверу()
 
    Соединение = Новый FTPСоединение(
        "mx.tabakon.ru", // адрес ftp сервера
        21, // порт сервера
        "manager", // имя пользователя
        "office", // пароль пользователя
        Неопределено, // прокси не используется
        Истина, // пассивный режим работы
        0, // таймаут (0 - без ограничений)
        Неопределено // незащищенное соединение
    );
 
    // Для случаев, когда у ftp сервера нет возможности
    // обращаться к нам (мы находимся за межсетевым экраном)
    // следует использовать пассивный режим работы.
 
    Возврат Соединение;
 
КонецФункции

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
СтандартнаяОбработка=Ложь;

Если ЗначениеЗаполнено(Склад) Тогда
	
	Если ВариантОтчета<>"По одному складу" Тогда
		ВариантОтчета="По одному складу";
		СхемаКомпоновкиДанных = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
		
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
		КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КонецЕсли;	
	
	//ПараметрНоменклатура = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("Склад");
	//ПараметрНоменклатура.Использование = Истина;
	//ПараметрНоменклатура.Значение  = Склад;
	
	ОстаткиНаТочках=0;
	ОстаткиВУТ=0;
	Разница=0;
	РазницаСГР=0;
	ОстаткиВГР=0;
	
	ТЗОбщая = Новый ТаблицаЗначений;
	ТЗОбщая.Колонки.Добавить("Время",Новый ОписаниеТипов("Строка"));
	ТЗОбщая.Колонки.Добавить("Склад",Новый ОписаниеТипов("СправочникСсылка.Склады"));
	ТЗОбщая.Колонки.Добавить("Номенклатура",Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));	
	ТзОбщая.Колонки.Добавить("КоличествоНаТочке",Новый ОписаниеТипов("Число"));
	ТЗОбщая.Колонки.Добавить("КоличествоВГР",Новый ОписаниеТипов("Число"));
	ТЗОбщая.Колонки.Добавить("КоличествоВУТ",Новый ОписаниеТипов("Число"));
	ТЗОбщая.Колонки.Добавить("РазницаУТГР",Новый ОписаниеТипов("Число"));
	ТЗОбщая.Колонки.Добавить("РазницаУТТТ",Новый ОписаниеТипов("Число"));
	
	Единение=ПодключитьсяКбазе();
	
	Соединение = ПодключитьсяКFTPСерверу();
	
	Соединение.УстановитьТекущийКаталог("/");
	
	Для Каждого ЭлементСписка из Склад Цикл
	
    НайденныеФайлы = Соединение.НайтиФайлы("/ostatok "+ЭлементСписка.Значение+".xml");
 
    Если НайденныеФайлы.Количество() > 0 Тогда
        Файл = НайденныеФайлы[0];
    КонецЕсли;

	ИмяВременогоФайла = ПолучитьИмяВременногоФайла("xml");
	
	Соединение.Получить(
         Файл.ПолноеИмя, // что качаем
         ИмяВременогоФайла // куда качаем
    );
	
	Файл=ИмяВременогоФайла;
	Файлик = Новый ЧтениеXML;
    Файлик.ОткрытьФайл(Файл);
 
    Построитель = Новый ПостроительDOM;
 
    Документ = Построитель.Прочитать(Файлик);
	
	ТЗ = Новый ТаблицаЗначений;
    ТЗ.Колонки.Добавить("Номенклатура",Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));	
	Тз.Колонки.Добавить("КоличествоОстатокНаТочке",Новый ОписаниеТипов("Число"));
	
	ТЗГР = Новый ТаблицаЗначений;
    ТЗГР.Колонки.Добавить("Номенклатура",Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));	
	ТзГР.Колонки.Добавить("Количество",Новый ОписаниеТипов("Число"));	
	
	Для Каждого Элемент Из Документ.ЭлементДокумента.ДочерниеУзлы Цикл
		Если Элемент.ИмяУзла = "Товар" Тогда
			Товар = Элемент;
			НоваяСтрока=ТЗ.Добавить();
			Наименование = Товар.Атрибуты.ПолучитьИменованныйЭлемент("Наименование");
			Номен="";
			Номен=Справочники.Номенклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(Наименование.Значение));
			НоваяСтрока.Номенклатура=Номен;
			КонечныйОстаток = Товар.Атрибуты.ПолучитьИменованныйЭлемент("КонечныйОстаток");
			Если Строка(КонечныйОстаток)<>"" Тогда
				НоваяСтрока.КоличествоОстатокНаТочке=Число(КонечныйОстаток.Значение);
			КонецЕсли;
			
		КонецЕсли;
		Если Элемент.ИмяУзла = "ОбщееКоличество" Тогда
			ОбщееКоличество = Элемент.Атрибуты.ПолучитьИменованныйЭлемент("ОбщееКоличествоОстаток");
			ОстаткиНаТочках = ОстаткиНаТочках+ОбщееКоличество.Значение;
		КонецЕсли;
		Если Элемент.ИмяУзла = "ВремяФормирования" Тогда
			Конец = Элемент.Атрибуты.ПолучитьИменованныйЭлемент("Время");
			КонецПериода = Конец.Значение; 
			//НачалоПериода=Дата(КонецПериода-604800);
		КонецЕсли;
	КонецЦикла;
	
	
	ПолучитьИзГлавнойРозницы(ТЗГР, ЭлементСписка.Значение);
	//
	//УстановитьСоединениеСВебСервисом();
	//Табл = Прокси.GetProductBalances(ЭлементСписка.Значение.Код, Формат(КонецПериода, "ДФ=ггггММддЧЧммсс"));
	//ТабличныеДанные = Табл.Получить();	

	//ЧтениеХМЛ = новый ЧтениеXML;
	//ЧтениеХМЛ.УстановитьСтроку(ТабличныеДанные);
	//Табл = СериализаторXDTO.ПрочитатьXML( ЧтениеХМЛ);

	//Для каждого Стр Из Табл Цикл	
	//	НоваяСтрока=ТЗГР.Добавить();
	//	Номен=Справочники.Номенклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(Стр.СсылкаНоменклатура));
	//	НоваяСтрока.Номенклатура=Номен;
	//	НоваяСтрока.Количество=Число(Стр.Количество);
	//КонецЦикла;
	
	
	//Если ЗначениеЗаполнено(НачалоПериода) Тогда
	//	ПараметрНачалоПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("НачалоПериода");
	//	ПараметрНачалоПериода.Использование = Истина;
	//	ПараметрНачалоПериода.Значение  = НачалоПериода;
	//Иначе
	//	ПараметрНачалоПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("НачалоПериода");
	//	ПараметрНачалоПериода.Использование = Истина;
	//	ПараметрНачалоПериода.Значение  = Неопределено;
	//КонецЕсли;

	//Если ЗначениеЗаполнено(КонецПериода) Тогда
	//	//КонецПериода = КонецДня(КонецПериода);
	//	ПараметрКассир = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("КонецПериода");
	//	ПараметрКассир.Использование = Истина;
	//	ПараметрКассир.Значение  = КонецПериода;
	//Иначе
	//	ПараметрКассир = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("КонецПериода");
	//	ПараметрКассир.Использование = Истина;
	//	ПараметрКассир.Значение  = Неопределено;
	//КонецЕсли;
	
    Файлик.Закрыть();	
	
	ТЗ.Свернуть("Номенклатура","КоличествоОстатокНаТочке");
	ТЗГР.Свернуть("Номенклатура","Количество");
	
	Запрос=Новый Запрос;
	Запрос.УстановитьПараметр("ТЗГР", ТЗГР);
	Запрос.УстановитьПараметр("ТаблицаТочки", ТЗ);
	Запрос.УстановитьПараметр("Склад", ЭлементСписка.Значение);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);

	Запрос.Текст="ВЫБРАТЬ
	             |	ТоварыВРозницеОстатки.КоличествоОстаток КАК КоличествоОстаток,
	             |	ТоварыВРозницеОстатки.Номенклатура КАК Номенклатура
	             |ПОМЕСТИТЬ ВУтешке
	             |ИЗ
	             |	РегистрНакопления.ТоварыВРознице.Остатки(&КонецПериода, ) КАК ТоварыВРозницеОстатки
	             |ГДЕ
	             |	ТоварыВРозницеОстатки.Склад = &Склад
	             |
	             |СГРУППИРОВАТЬ ПО
	             |	ТоварыВРозницеОстатки.Номенклатура,
	             |	ТоварыВРозницеОстатки.КоличествоОстаток
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	ТЗГР.Номенклатура,
	             |	ТЗГР.Количество КАК Количество
	             |ПОМЕСТИТЬ ТЗГР
	             |ИЗ
	             |	&ТЗГР КАК ТЗГР
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	ТаблицаТочки.Номенклатура,
	             |	ТаблицаТочки.КоличествоОстатокНаТочке КАК КоличествоОстатокНаТочке
	             |ПОМЕСТИТЬ ТаблицаТочки
	             |ИЗ
	             |	&ТаблицаТочки КАК ТаблицаТочки
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	ВЫБОР
	             |		КОГДА ЕСТЬNULL(ВУтешке.Номенклатура, 0) <> 0
	             |			ТОГДА ВУтешке.Номенклатура
	             |		ИНАЧЕ ВЫБОР
	             |				КОГДА ЕСТЬNULL(ТаблицаТочки.Номенклатура, 0) <> 0
	             |					ТОГДА ТаблицаТочки.Номенклатура
	             |				ИНАЧЕ ВЫБОР
	             |						КОГДА ЕСТЬNULL(ТЗГР.Номенклатура, 0) > 0
	             |							ТОГДА ТЗГР.Номенклатура
	             |						ИНАЧЕ ""Номенклатура не найдена""
	             |					КОНЕЦ
	             |			КОНЕЦ
	             |	КОНЕЦ КАК Номенклатура,
	             |	ЕСТЬNULL(ТаблицаТочки.КоличествоОстатокНаТочке, 0) КАК КоличествоНаТочке,
	             |	ЕСТЬNULL(ТЗГР.Количество, 0) КАК КоличествоВГР,
	             |	ЕСТЬNULL(ВУтешке.КоличествоОстаток, 0) КАК КоличествоВУТ,
	             |	ВЫБОР
	             |		КОГДА ЕСТЬNULL(ВУтешке.КоличествоОстаток, 0) - ЕСТЬNULL(ТаблицаТочки.КоличествоОстатокНаТочке, 0) >= 0
	             |			ТОГДА ЕСТЬNULL(ВУтешке.КоличествоОстаток, 0) - ЕСТЬNULL(ТаблицаТочки.КоличествоОстатокНаТочке, 0)
	             |		ИНАЧЕ (ЕСТЬNULL(ВУтешке.КоличествоОстаток, 0) - ЕСТЬNULL(ТаблицаТочки.КоличествоОстатокНаТочке, 0)) * -1
	             |	КОНЕЦ КАК РазницаУТТТ,
	             |	ВЫБОР
	             |		КОГДА ЕСТЬNULL(ВУтешке.КоличествоОстаток, 0) - ЕСТЬNULL(ТЗГР.Количество, 0) >= 0
	             |			ТОГДА ЕСТЬNULL(ВУтешке.КоличествоОстаток, 0) - ЕСТЬNULL(ТЗГР.Количество, 0)
	             |		ИНАЧЕ (ЕСТЬNULL(ВУтешке.КоличествоОстаток, 0) - ЕСТЬNULL(ТЗГР.Количество, 0)) * -1
	             |	КОНЕЦ КАК РазницаУТГР
	             |ИЗ
	             |	ВУтешке КАК ВУтешке
	             |		ПОЛНОЕ СОЕДИНЕНИЕ ТЗГР КАК ТЗГР
	             |		ПО ВУтешке.Номенклатура = ТЗГР.Номенклатура
	             |		ПОЛНОЕ СОЕДИНЕНИЕ ТаблицаТочки КАК ТаблицаТочки
	             |		ПО ВУтешке.Номенклатура = ТаблицаТочки.Номенклатура";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	//ТЗ = Новый ТаблицаЗначений;
	//ТЗ.Колонки.Добавить("Склад"Новый ОписаниеТипов("СправочникСсылка.Склад");
	//ТЗ.Колонки.Добавить("Номенклатура",Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));	
	//Тз.Колонки.Добавить("КоличествоНаТочке",Новый ОписаниеТипов("Число"));
	//ТЗ.Колонки.Добавить("КоличествоВГР",Новый ОписаниеТипов("Число"));
	//ТЗ.Колонки.Добавить("КоличествоВУТ",Новый ОписаниеТипов("Число"));
	//ТЗ.Колонки.Добавить("РазницаУТГР",Новый ОписаниеТипов("Число"));
	//ТЗ.Колонки.Добавить("РазницаУТТТ",Новый ОписаниеТипов("Число"));
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НоваяСтрока=ТЗОбщая.Добавить();
		НоваяСтрока.Склад=ЭлементСписка.Значение;
		НоваяСтрока.Время=КонецПериода;
		НоваяСтрока.Номенклатура=ВыборкаДетальныеЗаписи.Номенклатура;
		НоваяСтрока.КоличествоНаТочке=Число(ВыборкаДетальныеЗаписи.КоличествоНаТочке);
		НоваяСтрока.КоличествоВГР=Число(ВыборкаДетальныеЗаписи.КоличествоВГР);
		НоваяСтрока.КоличествоВУТ=Число(ВыборкаДетальныеЗаписи.КоличествоВУТ);
		НоваяСтрока.РазницаУТГР=Число(ВыборкаДетальныеЗаписи.РазницаУТГР);
		НоваяСтрока.РазницаУТТТ=Число(ВыборкаДетальныеЗаписи.РазницаУТТТ);
		ОстаткиВУТ=ОстаткиВУТ+Число(ВыборкаДетальныеЗаписи.КоличествоВУТ);
		Разница=Разница+Число(ВыборкаДетальныеЗаписи.РазницаУТТТ);
		РазницаСГР=РазницаСГР+Число(ВыборкаДетальныеЗаписи.РазницаУТГР);
		ОстаткиВГР=ОстаткиВГР+Число(ВыборкаДетальныеЗаписи.КоличествоВГР);
	КонецЦикла;
	
	КонецЦикла;
	
	Настройки = КомпоновщикНастроек.ПолучитьНастройки(); 
 
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных; 
 
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;	
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);	
	
	ВнешнийНаборДанных = Новый Структура("ТаблицаЗначений", ТЗОбщая); 
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных; 
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешнийНаборДанных, ДанныеРасшифровки); 
	
	ДокументРезультат.Очистить();
	
 	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент; 
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат); 
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
Иначе     //Для всех складов разом /////////////////////////////////////////////////////////////////
	КонецПериода=Дата("00000000");	
	ОстаткиНаТочках=0;
	ОстаткиВУТ=0;
	Разница=0;
	РазницаСГР=0;
	ОстаткиВГР=0;
	
	Если ВариантОтчета<>"По всем складам" Тогда
		ВариантОтчета="По всем складам"; 
		СхемаКомпоновкиДанных = ПолучитьМакет("Макет");
		
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
		КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КонецЕсли;	

	
	ТЗ = Новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("Склад");	
	Тз.Колонки.Добавить("КоличествоОстатокНаТочке",Новый ОписаниеТипов("Число"));
	Тз.Колонки.Добавить("КоличествоВГР",Новый ОписаниеТипов("Число"));
	ТЗ.Колонки.Добавить("ВремяФормирования");
	ТЗ.Колонки.Добавить("КоличествоВУТ",Новый ОписаниеТипов("Число"));
	ТЗ.Колонки.Добавить("Разница");
	ТЗ.Колонки.Добавить("РазницаСГР");

	Единение=ПодключитьсяКбазе();
	
	Соединение = ПодключитьсяКFTPСерверу();
	
	Соединение.УстановитьТекущийКаталог("/");
	
	Выборка = Справочники.Склады.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		
		
		НайденныеФайлы = Соединение.НайтиФайлы("/ostatok "+Выборка.Наименование+".xml");
		
		Если НайденныеФайлы.Количество() > 0 Тогда
			
			Файл = НайденныеФайлы[0];
		
			ИмяВременогоФайла = ПолучитьИмяВременногоФайла("xml");
			
			Соединение.Получить(
			Файл.ПолноеИмя, // что качаем
			ИмяВременогоФайла // куда качаем
			);
			
			Файл=ИмяВременогоФайла;
			Файлик = Новый ЧтениеXML;
			Файлик.ОткрытьФайл(Файл);
			
			Построитель = Новый ПостроительDOM;
			
			Документ = Построитель.Прочитать(Файлик);
			КонецПериода=Дата("00000000");
			ОбщееКоличество=0;
			Для Каждого Элемент Из Документ.ЭлементДокумента.ДочерниеУзлы Цикл
				Если Элемент.ИмяУзла = "ОбщееКоличество" Тогда
					ОбщееКоличество = Элемент.Атрибуты.ПолучитьИменованныйЭлемент("ОбщееКоличествоОстаток");
					ОбщееКоличество = ОбщееКоличество.Значение;
				КонецЕсли;
				Если Элемент.ИмяУзла = "ВремяФормирования" Тогда
					Конец = Элемент.Атрибуты.ПолучитьИменованныйЭлемент("Время");
					КонецПериода = Конец.Значение; 
				КонецЕсли;
			КонецЦикла;
			Файлик.Закрыть();
			
			ОстаткиНаТочках=ОстаткиНаТочках+ОбщееКоличество;
			
			ТЗГР = Новый ТаблицаЗначений;
			ТЗГР.Колонки.Добавить("Номенклатура",Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));	
			ТзГР.Колонки.Добавить("Количество",Новый ОписаниеТипов("Число"));
			КоличествоГРПоСкладу=0;
			ПолучитьИзГлавнойРозницы(ТЗГР, Выборка.Ссылка);
			КоличествоГРПоСкладу=КоличествоГРПоСкладу+ТЗГР.Итог("Количество");
			ОстаткиВГР=ОстаткиВГР+ТЗГР.Итог("Количество");
			
			НоваяСтрока=ТЗ.Добавить();
			НоваяСтрока.Склад=Выборка.Ссылка;
			НоваяСтрока.ВремяФормирования=КонецПериода;
			НоваяСтрока.КоличествоОстатокНаТочке=Число(ОбщееКоличество);
			НоваяСтрока.КоличествоВГР=КоличествоГРПоСкладу;
				
			//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
			// Данный фрагмент построен конструктором.
			// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
			
			Зап = Новый Запрос;
			Зап.Текст = 
			"ВЫБРАТЬ
			|	ТоварыВРозницеОстатки.КоличествоОстаток
			|ИЗ
			|	РегистрНакопления.ТоварыВРознице.Остатки(&КонецПериода, ) КАК ТоварыВРозницеОстатки
			|ГДЕ
			|	ТоварыВРозницеОстатки.Склад = &Склад
			|
			|СГРУППИРОВАТЬ ПО
			|	ТоварыВРозницеОстатки.КоличествоОстаток";
			
			Зап.УстановитьПараметр("КонецПериода", Дата(КонецПериода));
			Зап.УстановитьПараметр("Склад", Выборка.Ссылка);
			
			Результат = Зап.Выполнить();
			
			ВыборкаДетальныеЗаписи = Результат.Выбрать();
			
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				НоваяСтрока.КоличествоВУТ=ВыборкаДетальныеЗаписи.КоличествоОстаток;
				ОстаткиВУТ=ОстаткиВУТ+ВыборкаДетальныеЗаписи.КоличествоОстаток;
				РазницаНаСкладе=ВыборкаДетальныеЗаписи.КоличествоОстаток-ОбщееКоличество;
				Если РазницаНаСкладе>=0 Тогда
					НоваяСтрока.Разница=РазницаНаСкладе;
				Иначе
					НоваяСтрока.Разница=-РазницаНаСкладе;
				КонецЕсли;
				РазницаНаСкладе=ВыборкаДетальныеЗаписи.КоличествоОстаток-КоличествоГРПоСкладу;
				Если РазницаНаСкладе>=0 Тогда
					НоваяСтрока.РазницаСГР=РазницаНаСкладе;
				Иначе
					НоваяСтрока.РазницаСГР=-РазницаНаСкладе;
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Разница=ОстаткиВУТ-ОстаткиНаТочках;	
	Если Разница>=0 Тогда
		Разница=Разница;
	Иначе
		Разница=-Разница;
	КонецЕсли;
	РазницаСГР=ОстаткиВУТ-ОстаткиВГР;	
	Если РазницаСГР>=0 Тогда
		РазницаСГР=РазницаСГР;
	Иначе
		РазницаСГР=-РазницаСГР;
	КонецЕсли;
	//СхемаКомпоновкиДанных = ПолучитьМакет("Макет");
	
	Настройки = КомпоновщикНастроек.ПолучитьНастройки(); 
	
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных; 
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;	
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);	
	
	ВнешнийНаборДанных = Новый Структура("ТЗ", ТЗ); 
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных; 
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешнийНаборДанных, ДанныеРасшифровки); 
	
	ДокументРезультат.Очистить();
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент; 
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат); 
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);	
	
КонецЕсли;
		
КонецПроцедуры

Функция ПодключитьсяКбазе()
		//ПараметрыПодключенияКлиентСервернойИБ = "Srvr=""Имя_Сервера""; Ref=""Имя_базы""; Usr=""Имя_пользователя""; Pwd=""Пароль""";
		ПараметрыПодключенияИБ = "Srvr=""localhost""; Ref=""roznica_gu""; Usr=""ЛегкийКод"";Pwd=""16722188""";
		V83COMCon = Новый COMОбъект("V83.COMConnector");
		Попытка
			Возврат V83COMCon.Connect(ПараметрыПодключенияИБ);
		Исключение
			Сообщить(ОписаниеОшибки());
			Возврат Неопределено;
		КонецПопытки;
КонецФункции

Функция ПолучитьИзГлавнойРозницы(ТЗ, СкладСсылка)
	
//Соединение = ПодключитьсяКбазе();
Соединение=Единение;

Если ТипЗнч(Соединение) <> Тип("Неопределено") Тогда 
	
	Запрос = Соединение.NewObject("Запрос");
    Запрос.Текст ="ВЫБРАТЬ РАЗРЕШЕННЫЕ
                  |	ТоварыНаСкладахОстатки.КоличествоОстаток,
                  |	ТоварыНаСкладахОстатки.Номенклатура
                  |ИЗ
                  |	РегистрНакопления.ТоварыНаСкладах.Остатки(&ПериодКонец, ) КАК ТоварыНаСкладахОстатки
                  |ГДЕ
                  |	ТоварыНаСкладахОстатки.Склад.Код = &Склад
                  |
                  |СГРУППИРОВАТЬ ПО
                  |	ТоварыНаСкладахОстатки.Номенклатура,
                  |	ТоварыНаСкладахОстатки.КоличествоОстаток";
		
    Запрос.УстановитьПараметр("ПериодКонец",КонецПериода);
	Запрос.УстановитьПараметр("Склад", СкладСсылка.Код);

	РезультатЗапроса = Запрос.Выполнить(); 

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	 
	 
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Строчка=ТЗ.Добавить();
		Ссыл=ВыборкаДетальныеЗаписи.Номенклатура;
		Ном=Соединение.String(ВыборкаДетальныеЗаписи.Номенклатура.УникальныйИдентификатор());
		Строчка.Номенклатура=Справочники.Номенклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(Ном));
		Строчка.Количество=Число(ВыборкаДетальныеЗаписи.КоличествоОстаток)
	КонецЦикла;
	 
	
	// НЧАН	
	КоличествоЗАДатой = Новый Соответствие;	

	Запрос = Соединение.NewObject("Запрос");
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПриходныйОрдерНаТоварыТовары.Номенклатура КАК Номенклатура,
		|	ПриходныйОрдерНаТоварыТовары.ХарактеристикаНоменклатуры,
		|	ПриходныйОрдерНаТоварыТовары.Количество КАК Количество,
		|	ПриходныйОрдерНаТоварыТовары.Коэффициент,
		|	ПриходныйОрдерНаТоварыТовары.ЕдиницаИзмерения,
		|	ПриходныйОрдерНаТоварыТовары.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ ВТ
		|ИЗ
		|	Документ.ПриходныйОрдерНаТовары.Товары КАК ПриходныйОрдерНаТоварыТовары
		|ГДЕ
		|	ПриходныйОрдерНаТоварыТовары.Ссылка.Дата > &ДатаОтчета
		|	И ПриходныйОрдерНаТоварыТовары.Ссылка.ДокументОснование.Дата <= &ДатаОтчета
		|	И ПриходныйОрдерНаТоварыТовары.Ссылка.Склад.Код = &Код
		|	И ПриходныйОрдерНаТоварыТовары.Ссылка.Проведен
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	РасходныйОрдерНаТоварыТовары.Номенклатура,
		|	РасходныйОрдерНаТоварыТовары.ХарактеристикаНоменклатуры,
		|	-РасходныйОрдерНаТоварыТовары.Количество,
		|	РасходныйОрдерНаТоварыТовары.Коэффициент,
		|	РасходныйОрдерНаТоварыТовары.ЕдиницаИзмерения,
		|	РасходныйОрдерНаТоварыТовары.Ссылка
		|ИЗ
		|	Документ.РасходныйОрдерНаТовары.Товары КАК РасходныйОрдерНаТоварыТовары
		|ГДЕ
		|	РасходныйОрдерНаТоварыТовары.Ссылка.Дата > &ДатаОтчета
		|	И РасходныйОрдерНаТоварыТовары.Ссылка.ДокументОснование.Дата <= &ДатаОтчета
		|	И РасходныйОрдерНаТоварыТовары.Ссылка.Склад.Код = &Код
		|	И РасходныйОрдерНаТоварыТовары.Ссылка.Проведен
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ.Номенклатура КАК Номенклатура,
		|	ВТ.ХарактеристикаНоменклатуры,
		|	СУММА(ВТ.Количество) КАК Количество,
		|	ВТ.Коэффициент,
		|	ВТ.ЕдиницаИзмерения,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВТ.Ссылка) КАК Ссылка
		|ИЗ
		|	ВТ КАК ВТ
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ.Номенклатура,
		|	ВТ.ХарактеристикаНоменклатуры,
		|	ВТ.Коэффициент,
		|	ВТ.ЕдиницаИзмерения
		|ИТОГИ ПО
		|	Номенклатура";
		
	Запрос.УстановитьПараметр("ДатаОтчета", КонецПериода);
	Запрос.УстановитьПараметр("Код", СкладСсылка.Код);
   	РезультатЗапроса = Запрос.Выполнить();
	 //КЧАН

	ВыборкаНоменклатура = РезультатЗапроса.Выбрать();
	ДополнительноеКоличество=0;
	Пока ВыборкаНоменклатура.Следующий() Цикл
		Строчка=ТЗ.Добавить();
		Ссыл=ВыборкаНоменклатура.Номенклатура;
		Ном=Соединение.String(ВыборкаНоменклатура.Номенклатура.УникальныйИдентификатор());
		Строчка.Номенклатура=Справочники.Номенклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(Ном));
		Строчка.Количество=Число(ВыборкаНоменклатура.Количество)
	КонецЦикла;

	ТЗ.Свернуть("Номенклатура, Количество");
		  
КонецЕсли;
КонецФункции


