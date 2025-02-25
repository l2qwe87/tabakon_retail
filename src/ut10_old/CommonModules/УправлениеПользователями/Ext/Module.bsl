﻿
// Функция возвращает ссылку на элемент справочника "Пользователи",
// соответствующий текущему пользователю информационной базы.
//
Функция ОпределитьТекущегоПользователя() экспорт

	Если ПустаяСтрока(ИмяПользователя()) Тогда
		ИмяПользователя           = "<Не указан>";
		ПолноеИмяПользователя     = "<Не указан>";        
	Иначе
		ИмяПользователя           = ИмяПользователя();
		
		Если ПустаяСтрока(ПолноеИмяПользователя()) Тогда
			ПолноеИмяПользователя = ИмяПользователя;
		Иначе
			ПолноеИмяПользователя = ПолноеИмяПользователя();
		КонецЕсли;
	КонецЕсли;
	
	ДлинаКодаПользователя = Метаданные.Справочники.Пользователи.ДлинаКода;
	
	Если СтрДлина(ИмяПользователя) > ДлинаКодаПользователя Тогда
		ИмяПользователя = Лев(ИмяПользователя, ДлинаКодаПользователя);
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Пользователи.Ссылка КАК Ссылка,
	|	Пользователи.ЭтоГруппа
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|ГДЕ
	|	Пользователи.Код = &Код";
	
	Запрос.УстановитьПараметр("Код", ИмяПользователя);
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		
		ОбъектПользователь = Справочники.Пользователи.СоздатьЭлемент();
		
		ОбъектПользователь.Код          = ИмяПользователя;
		ОбъектПользователь.Наименование = ПолноеИмяПользователя;
        
		Попытка
			ОбъектПользователь.ОбменДанными.Загрузка = Истина;
			ОбъектПользователь.Записать();
			
        Исключение
			ВызватьИсключение "Пользователь : " + ИмяПользователя + " не был найден в справочнике пользователей. Возникла ошибка при добавлении пользователя в справочник.
				|" + ОписаниеОшибки();
        
			Возврат Справочники.Пользователи.ПустаяСсылка();
			
		КонецПопытки;
        
		ТекущийПользователь = ОбъектПользователь.Ссылка;

    Иначе
        Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		Если Выборка.ЭтоГруппа Тогда
			ВызватьИсключение "Пользователь : " + ИмяПользователя + " не зарегистрирован. В справочнике присутствует группа с тем же именем";
		Иначе
			ТекущийПользователь = Выборка.Ссылка;
		КонецЕсли;	       
		
	КонецЕсли; 
       
    Возврат ТекущийПользователь;

КонецФункции // ОпределитьТекущегоПользователя()


// Процедура проверяет возможность запуска ИБ с определенными для текущего
// пользователя доступными ролями
//
Процедура ПроверитьВозможностьРаботыПользователя(Отказ) Экспорт

	Если НЕ ПолныеПрава.ЕстьДоступныеПраваДляЗапускаКонфигурации() Тогда
		Отказ = Истина;
		#Если Клиент Тогда
		Предупреждение("У текущего пользователя нет доступных ролей, для запуска информационной базы.", 10, "Недостаточно прав доступа");
		#КонецЕсли
	КонецЕсли; 
	
КонецПроцедуры

// Функция возвращает список значений права, установленных для пользователя.
// Если количество значений меньше количество доступных ролей, то возвращается значение по умолчанию
//
// Параметры:
//  Право               - право, для которого определяются значения
//  ЗначениеПоУмолчанию - значение по умолчанию для передаваемого права (возвращается в случае
//                        отсутствия значений в регистре сведений)
//
// Возвращаемое значение:
//  Список всех значений, установленных наборам прав (ролям), доступных пользователю
//
Функция ПолучитьЗначениеПраваДляТекущегоПользователя(Право, ЗначениеПоУмолчанию = Неопределено) Экспорт
	
	КэшДополнительныхПрав = глЗначениеПеременной("ЗначенияДополнительныхПравПользователя");
	ЗначениеПрава = КэшДополнительныхПрав[Право];
	Если ЗначениеПрава = Неопределено Тогда
		ЗначениеПрава = ПрочитатьЗначениеПраваДляТекущегоПользователя(Право, ЗначениеПоУмолчанию);
		КэшДополнительныхПрав[Право] = ЗначениеПрава;
		#Если Сервер Тогда
			глЗначениеПеременнойУстановить("ЗначенияДополнительныхПравПользователя", КэшДополнительныхПрав, Истина);
		#КонецЕсли
	КонецЕсли;	
	Возврат ЗначениеПрава;
	
КонецФункции // ПолучитьЗначениеПраваДляТекущегоПользователя()

Функция ПрочитатьЗначениеПраваДляТекущегоПользователя(Право, ЗначениеПоУмолчанию)

	ВозвращаемыеЗначения = Новый СписокЗначений;
	
	Запрос = Новый Запрос;

	Запрос.УстановитьПараметр("Пользователь"     , ПараметрыСеанса.ТекущийПользователь);
	Запрос.УстановитьПараметр("ПравоПользователя", Право);

	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	               |	РегистрЗначениеПрав.Значение
	               |ИЗ
	               |	РегистрСведений.ЗначенияДополнительныхПравПользователя КАК РегистрЗначениеПрав
	               |ГДЕ
	               |	РегистрЗначениеПрав.Право = &ПравоПользователя
	               |	И РегистрЗначениеПрав.Пользователь В
	               |			(ВЫБРАТЬ
	               |				ПользователиГруппы.Ссылка КАК Ссылка
	               |			ИЗ
	               |				Справочник.ГруппыПользователей.ПользователиГруппы КАК ПользователиГруппы
	               |			ГДЕ
	               |				ПользователиГруппы.Пользователь = &Пользователь
	               |		
	               |			ОБЪЕДИНИТЬ ВСЕ
	               |		
	               |			ВЫБРАТЬ
	               |				ЗНАЧЕНИЕ(Справочник.ГруппыПользователей.ВсеПользователи)
	               |		
	               |			ОБЪЕДИНИТЬ ВСЕ
	               |		
	               |			ВЫБРАТЬ
	               |				&Пользователь)";
	
	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.Количество() = 0 Тогда
		ВозвращаемыеЗначения.Добавить(ЗначениеПоУмолчанию);
	Иначе
		Пока Выборка.Следующий() Цикл
			ВозвращаемыеЗначения.Добавить(Выборка.Значение);
		КонецЦикла;
	КонецЕсли;

	Возврат ВозвращаемыеЗначения;

КонецФункции // ПолучитьЗначениеПраваДляТекущегоПользователя()

// Функция возвращает значение по умолчанию для передаваемого пользователя и настройки.
//
// Параметры:
//  Пользователь - текущий пользователь программы
//  Настройка    - признак, для которого возвращается значение по умолчанию
//
// Возвращаемое значение:
//  Значение по умолчанию для настройки.
//
Функция ПолучитьЗначениеПоУмолчанию(Пользователь, Настройка) Экспорт

	Если Пользователь = глЗначениеПеременной("глТекущийПользователь") Тогда		
		НастройкаСсылка = ПланыВидовХарактеристик.НастройкиПользователей[Настройка];		
		КэшНастроекПользователей = глЗначениеПеременной("ЗначенияНастроекПользователей");
		ЗначениеНастройки = КэшНастроекПользователей[НастройкаСсылка];
		Если ЗначениеНастройки = Неопределено Тогда
			ЗначениеНастройки = ПолучитьЗначениеПоУмолчаниюПользователя(Пользователь, Настройка);
			КэшНастроекПользователей[НастройкаСсылка] = ЗначениеНастройки;
			#Если Сервер Тогда
				глЗначениеПеременнойУстановить("ЗначенияНастроекПользователей", КэшНастроекПользователей, Истина);
			#КонецЕсли
		КонецЕсли;	
		Возврат ЗначениеНастройки;		
	КонецЕсли;
	
	Возврат ПолучитьЗначениеПоУмолчаниюПользователя(Пользователь, Настройка);

КонецФункции // ПолучитьЗначениеПоУмолчанию()

// Функция возвращает значение по умолчанию и значения реквизитов данного значения для передаваемого пользователя, настройки и списка реквизитов.
//
// Параметры:
//  Пользователь - текущий пользователь программы
//  Настройка    - признак, для которого возвращается значение по умолчанию
//  СписокПолей  - список значений, содержащий имена реквизитов значения настройки, которые необходимо получить
//
// Возвращаемое значение:
//  Элемент выборки запроса либо структура (в случае пустой выборки).
//
Функция ПолучитьЗначениеПоУмолчаниюСДополнительнымиПолями(Пользователь, Настройка, СписокПолей) Экспорт
	
	Возврат ПолучитьЗначениеПоУмолчаниюПользователя(Пользователь, Настройка, СписокПолей);
	
КонецФункции // ПолучитьЗначениеПоУмолчаниюСДополнительнымиПолями()

// Общая служебная функция получения значения настроек пользователя
Функция ПолучитьЗначениеПоУмолчаниюПользователя(Пользователь, Настройка, СписокПолей = Неопределено)
	
	НастройкаТипЗнч = ПланыВидовХарактеристик.НастройкиПользователей[Настройка].ТипЗначения;
	НастройкаТипЗнчСправочник = Справочники.ТипВсеСсылки().СодержитТип(НастройкаТипЗнч.Типы()[0]);
	Если НастройкаТипЗнчСправочник Тогда
		МетаданныеТипаНастройки = Метаданные.НайтиПоТипу(НастройкаТипЗнч.Типы()[0]);
	КонецЕсли;
		
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("Настройка"   , ПланыВидовХарактеристик.НастройкиПользователей[Настройка]);	
	
	
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Значение КАК Значение";
	
	Если СписокПолей <> Неопределено И НастройкаТипЗнчСправочник Тогда
		
		СправочникИмя = МетаданныеТипаНастройки.Имя;
		
		Для каждого Элемент из СписокПолей цикл
			
			ИмяРеквизита = Элемент.Значение;
			Представление = Элемент.Представление;
			Если ПустаяСтрока(Представление) Тогда
				Представление = ИмяРеквизита;
			КонецЕсли;
				
			Запрос.Текст = Запрос.Текст + ",
			|ВЫРАЗИТЬ(Значение КАК Справочник." + СправочникИмя + ")." + ИмяРеквизита + "  КАК " + Представление;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Запрос.Текст = Запрос.Текст + "		
	|ИЗ
	|	РегистрСведений.НастройкиПользователей КАК РегистрЗначениеПрав
	|
	|ГДЕ
	|	Пользователь = &Пользователь
	| И Настройка    = &Настройка
	|";
		
		
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если СписокПолей = Неопределено Тогда
		ПустоеЗначение = НастройкаТипЗнч.ПривестиЗначение();
	Иначе
		ПустоеЗначение = новый Структура("Значение", НастройкаТипЗнч.ПривестиЗначение());
		Для каждого ЭлементСписка из СписокПолей цикл
			ПустоеЗначение.Вставить(?(ПустаяСтрока(ЭлементСписка.Представление), ЭлементСписка.Значение, ЭлементСписка.Представление));
		КонецЦикла;				
	КонецЕсли;
	
	Если Выборка.Следующий() Тогда
	
		Если НЕ ЗначениеЗаполнено(Выборка.Значение) Тогда
			Возврат ПустоеЗначение;
		КонецЕсли;		
		
		Если НастройкаТипЗнчСправочник И ПараметрыДоступа("Чтение", МетаданныеТипаНастройки, "Ссылка").ОграничениеУсловием Тогда
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ 1 ИЗ Справочник." + МетаданныеТипаНастройки.Имя + " ГДЕ Ссылка = &Ссылка";
			Запрос.УстановитьПараметр("Ссылка", Выборка.Значение);
			РезультатЗапроса = Запрос.Выполнить();
			Если РезультатЗапроса.Пустой() Тогда
				Возврат ПустоеЗначение;
			КонецЕсли;
		КонецЕсли;		
		
		Если СписокПолей = Неопределено Тогда
			Возврат Выборка.Значение;
		Иначе
			ЗаполнитьЗначенияСвойств(ПустоеЗначение, Выборка);
			Возврат ПустоеЗначение;
		КонецЕсли;	
		
	Иначе
		Возврат ПустоеЗначение;
	КонецЕсли;	
	
	
КонецФункции // ПолучитьЗначениеПоУмолчаниюПользователя()

// Процедура выполняет установку настроек по умолчанию для нового пользователя
Процедура УстановитьНастройкиПоУмолчанию(Пользователь) Экспорт
	
	ЗначенияПоУмолчанию = Новый Соответствие;	
	ЗначенияПоУмолчанию.Вставить(ПланыВидовХарактеристик.НастройкиПользователей.ЗапрашиватьПодтверждениеПриЗакрытии, Истина);	
	ЗначенияПоУмолчанию.Вставить(ПланыВидовХарактеристик.НастройкиПользователей.ОсновнойОтветственный, Пользователь);
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	НастройкиПользователей.Ссылка
	               |ИЗ
	               |	ПланВидовХарактеристик.НастройкиПользователей КАК НастройкиПользователей
	               |ГДЕ
	               |	(НЕ НастройкиПользователей.ЭтоГруппа)
	               |	И (НЕ НастройкиПользователей.ПометкаУдаления)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Набор = РегистрыСведений.НастройкиПользователей.СоздатьНаборЗаписей();
	Набор.Отбор.Пользователь.Установить(Пользователь);
	Пока Выборка.Следующий() Цикл
		Запись = Набор.Добавить();
		Запись.Пользователь = Пользователь;
		Запись.Настройка = Выборка.Ссылка;
		Запись.Значение = Запись.Настройка.ТипЗначения.ПривестиЗначение(ЗначенияПоУмолчанию[Запись.Настройка]);
	КонецЦикла;
	Набор.Записать();
	
КонецПроцедуры

// Процедура записывает значение по умолчанию для передаваемого пользователя и настройки.
//
// Параметры:
//  Пользователь - текущий пользователь программы
//  Настройка    - признак, для которого записывается значение по умолчанию
//  Значение     - значение по умолчанию
//
// Возвращаемое значение:
//  Нет
//
Процедура УстановитьЗначениеПоУмолчанию(Пользователь, Настройка, Значение) Экспорт

	СсылкаНастройки = ПланыВидовХарактеристик.НастройкиПользователей[Настройка];
	МенеджерЗаписи = РегистрыСведений.НастройкиПользователей.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Пользователь = Пользователь;
	МенеджерЗаписи.Настройка = СсылкаНастройки;
	МенеджерЗаписи.Значение = Значение;
	МенеджерЗаписи.Записать(Истина);

КонецПроцедуры // ПолучитьЗначениеПоУмолчанию()

// Функция генерирует новый пароль. 
// Используется для пароля WEB-приложения "Управление заказами".
// Пароль генерится на основе нового GUID.
//
Функция СгенерироватьПароль() Экспорт
	
	GUID = Новый УникальныйИдентификатор();
	СтрокаИдентификатора = Строка(GUID);
	
	ПозицияТире = Найти(СтрокаИдентификатора, "-");
	
	Возврат Сред(СтрокаИдентификатора, 1, ПозицияТире - 1);
	
КонецФункции //СгенерироватьПароль()

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ С ПОЛЬЗОВАТЕЛЯМИ ИБ

//Функция создает нового пользователя ИБ с настройками по умолчанию и возвращает его
Функция ДобавитьНовогоПользователяИБ(ИмяПользователя, ПолноеИмя = Неопределено, СообщатьОДобавленииПользователя = Истина, ЗаписатьПользователяВИБ = Истина) Экспорт
	
	НовыйПользователь = ПользователиИнформационнойБазы.СоздатьПользователя();
	НовыйПользователь.Имя = ИмяПользователя;
	НовыйПользователь.ПолноеИмя = ?(НЕ ЗначениеЗаполнено(ПолноеИмя), ИмяПользователя, ПолноеИмя);
	
	НовыйПользователь.АутентификацияСтандартная = Истина;
	НовыйПользователь.ПоказыватьВСпискеВыбора = Истина;
	
	Если ЗаписатьПользователяВИБ Тогда
		
		Попытка
			НовыйПользователь.Записать();
			#Если Клиент Тогда
			Если СообщатьОДобавленииПользователя Тогда
				Сообщить("В список пользователей ИБ добавлен пользователь с именем """ + ИмяПользователя + """");
			КонецЕсли;
			#КонецЕсли

		Исключение
		
			#Если Клиент Тогда
			Сообщить("Ошибка при добавлении пользователя в список пользователей ИБ """ + ИмяПользователя + """");
			#КонецЕсли
	
		КонецПопытки;
	
	КонецЕсли;	
	
	Возврат НовыйПользователь;
КонецФункции

// Функция по имени ищет пользователя ИБ, если не находит - создает нового и его возвращает
//
// Параметры:
//  ИмяПользователя                 - строка по которой ищется пользователь ИБ
//  ПолноеИмяПользователя           - строка, при добавлении пользователя ИБ таким будет установлено полное имя пользователя
//  СообщатьОДобавленииПользователя - Булево, нужно ли сообщать о добавлении нового пользователя ИБ
//  ЗаписатьПользователяВИБ         - Нужно ли при добавлении пользователя записывать его
Функция НайтиПользователяИБ(ИмяПользователя) Экспорт
	
	Если ИмяПользователя = "НеАвторизован" Тогда
		ПользовательИБ = Неопределено
	Иначе
		// ищем пользователя ИБ по имени
		Попытка
			ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(ИмяПользователя);
		Исключение
			ПользовательИБ = Неопределено;
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат ПользовательИБ;
КонецФункции

// Функция дополняет ИМЯ пробелами справа до длины 50
Функция СформироватьИмяПользователяВСправочнике(Имя) Экспорт
	
	ИмяПользователя = Имя;
	Для Счетчик = СтрДлина(ИмяПользователя) + 1 По 50 Цикл
		ИмяПользователя = ИмяПользователя + " ";	
	КонецЦикла;
	
	ИмяПользователя = Лев(ИмяПользователя, 50);
	
	Возврат ИмяПользователя;
	
КонецФункции

// Процедура синхронизирует справочник пользователей с пользователями ИБ
Процедура СинхронизироватьПользователейИПользователейИБ() Экспорт
	
	// при синхронизации списков пользователей и пользователей ИБ приоритетом
	// пользуются пользователи ИБ
	// если нет пользователя ИБ, то такой элемент списка пользователей помечаем на удаление
	// если пользователь ИБ есть а всписке такоео элемента нет, то добавляем его, а если он помечен на удаение, то снимаем пометку
	
	// имена пользователей ИБ могут быть заданы с незначащими символами
	// надо все незначимые символы из имен пользователей ИБ убрать
	МассивПользователейИБ = ПользователиИнформационнойБазы.ПолучитьПользователей();
	Для Каждого ПользовательИБ Из МассивПользователейИБ Цикл
		
		ИмяПользователяИБ = СокрЛП(ПользовательИБ.Имя);	
		Если ИмяПользователяИБ <> ПользовательИБ.Имя Тогда
			
			СтароеИмяПользователяИБ = ПользовательИБ.Имя;
			// полное имя тоже изменим если оно совпадает с имененм самого пользователя
			Если ПользовательИБ.ПолноеИмя = ПользовательИБ.Имя Тогда
				ПользовательИБ.ПолноеИмя = ИмяПользователяИБ;	
			КонецЕсли;
			ПользовательИБ.Имя = ИмяПользователяИБ;
			
			Попытка
				ПользовательИБ.Записать();
			Исключение
				// не смогли пользователя еще одного записать, значит есть очень похожие имена
				Сообщить("В списке пользователей базы данных присутствуют пользователи с именами """ + 
					СтароеИмяПользователяИБ + """ и """ + ИмяПользователяИБ + """", СтатусСообщения.Важное);
					
				Сообщить("Этим пользователям будет сопоставлен единственный элемент справочника ""Пользователи"" с именем  """ + ИмяПользователяИБ + """", СтатусСообщения.Важное);	
			КонецПопытки;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// 1 Пробегаем по справочнику пользователей и каких пользователей в ИБ
	// не нашли - тех помечаем на удаление
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	                |	Пользователи.*
	                |ИЗ
	                |	Справочник.Пользователи КАК Пользователи
					|
					| ГДЕ Пользователи.ЭтоГруппа = Ложь 
					|	И Пользователи.ПометкаУдаления = Ложь";
	
	ТаблицаПользователей = Запрос.Выполнить().Выгрузить();
	Для Каждого ПользовательСправочника Из ТаблицаПользователей Цикл

		// Для пользователя с пустым именем не надо пользователя в ИБ создавать
		ИмяПользователя = СокрЛП(ПользовательСправочника.Код);
		Если ИмяПользователя = "" ИЛИ ИмяПользователя = "НеАвторизован" Тогда           
			Продолжить;
		КонецЕсли;
			
		// ищем пользователя ИБ по имени
		ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(ИмяПользователя);
		Если ПользовательИБ = Неопределено Тогда
			// такого пользователя не нашли в пользователях ИБ - помечаем его на удаление
			
			ПользовательСсылка = Справочники.Пользователи.НайтиПоКоду(ПользовательСправочника.Код);
			// такого быть не может - должны найти всегда
			Если НЕ ЗначениеЗаполнено(ПользовательСсылка) Тогда
				Продолжить;
			КонецЕсли;
			
			ПользовательОбъект = ПользовательСсылка.ПолучитьОбъект();
			Попытка
				// обходим что бы можно было установить пометку на удаление
				ПользовательОбъект.ОбменДанными.Загрузка = Истина;
				ПользовательОбъект.УстановитьПометкуУдаления(Истина, Ложь);
				#Если Клиент Тогда
				Сообщить("Пользователь """ + СокрЛП(ПользовательОбъект.КОД) + """ помечен на удаление в справочнике пользователей.");
				#КонецЕсли

			Исключение
				
				#Если Клиент Тогда
				Сообщить("Ошибка при пометке на удаления пользователя """ + СокрЛП(ПользовательОбъект.КОД) + """. " + ОписаниеОшибки());
				#КонецЕсли
 			
			КонецПопытки;
			
		КонецЕсли;
	
	КонецЦикла;
	
	// 2 Пробегаем по пользователеям ИБ и тех кого не нашли в справочнике добавляем
	Для Каждого ПользовательИБ Из МассивПользователейИБ Цикл
		
		ИмяПользователяВСправочнике = СформироватьИмяПользователяВСправочнике(ПользовательИБ.Имя);
		ПользовательСправочника = Справочники.Пользователи.НайтиПоКоду(ИмяПользователяВСправочнике);
		// пользователя в справочнике нашли
		Если ЗначениеЗаполнено(ПользовательСправочника) Тогда
			
			ПользовательОбъект = ПользовательСправочника.ПолучитьОбъект();
			// нельзя что бы имя пользователя ИБ совпадало с именем группы
			Если ПользовательОбъект.ЭтоГруппа Тогда
				
				#Если Клиент Тогда
				Сообщить("Имя пользователя ИБ """ + СокрЛП(ПользовательОбъект.КОД) + """ совпадает с именем группы в справочнике пользователей!", СтатусСообщения.Важное);
				#КонецЕсли

				Продолжить;
			КонецЕсли;
			
			Если НЕ ПользовательОбъект.ПометкаУдаления Тогда
				Продолжить;
			КонецЕсли;
				
			Попытка
				// обходим что бы можно было установить пометку на удаление
				ПользовательОбъект.ОбменДанными.Загрузка = Истина;
				ПользовательОбъект.УстановитьПометкуУдаления(Ложь, Ложь);
				ПользовательОбъект.мПользовательИБ = ПользовательИБ;
		        ПользовательОбъект.Код          = ИмяПользователяВСправочнике;
				ПользовательОбъект.Наименование = ПользовательИБ.ПолноеИмя;
					
				ПользовательОбъект.Записать();
				#Если Клиент Тогда
				Сообщить("У пользователя """ + СокрЛП(ПользовательОбъект.КОД) + """ снята пометка на удаление в справочнике пользователей.");
				#КонецЕсли

			Исключение
					
				#Если Клиент Тогда
				Сообщить("Ошибка при снятии пометки на удаления у пользователя """ + СокрЛП(ПользовательОбъект.КОД) + """. " + ОписаниеОшибки());
				#КонецЕсли
	 			
			КонецПопытки;
			
		Иначе
			// пользователя в справочнике не нашли
			ОбъектПользователь = Справочники.Пользователи.СоздатьЭлемент();
			ОбъектПользователь.мПользовательИБ = ПользовательИБ;
	        ОбъектПользователь.Код          = ИмяПользователяВСправочнике;
			ОбъектПользователь.Наименование = ПользовательИБ.ПолноеИмя;

			Попытка
				ОбъектПользователь.Записать();
				
				#Если Клиент Тогда
				Сообщить("Пользователь """ + СокрЛП(ПользовательИБ.Имя) + """ зарегистрирован в справочнике пользователей.");
				#КонецЕсли
			Исключение
				ОбщегоНазначения.СообщитьОбОшибке("Ошибка при добавлении пользователя """ + СокрЛП(ПользовательИБ.Имя) + """ в справочник.");
		    КонецПопытки;

		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Процедура копирует пользователя ИБ с определенным именем и создает нового с такими же настройками
Функция СкопироватьПользователяИБ(ИмяПользователяИБ) Экспорт
	
	ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(ИмяПользователяИБ);
	Если ПользовательИБ = Неопределено Тогда
		ПолноеИмяПользователяИБ = ИмяПользователяИБ;
	Иначе
		ПолноеИмяПользователяИБ = ПользовательИБ.ПолноеИмя;
	КонецЕсли;
	
	НовыйПользовательИБ = ДобавитьНовогоПользователяИБ(ИмяПользователяИБ, ПользовательИБ.ПолноеИмя, Ложь, Ложь);
	
	Если ПользовательИБ <> Неопределено Тогда
		// Если есть от кого копировать настройки - копируем
		НовыйПользовательИБ.ПользовательОС = ПользовательИБ.ПользовательОС;
		НовыйПользовательИБ.Пароль = "";
		НовыйПользовательИБ.АутентификацияСтандартная = ПользовательИБ.АутентификацияСтандартная;
		НовыйПользовательИБ.ПоказыватьВСпискеВыбора = ПользовательИБ.ПоказыватьВСпискеВыбора;
		НовыйПользовательИБ.АутентификацияОС = ПользовательИБ.АутентификацияОС;
		НовыйПользовательИБ.Язык = ПользовательИБ.Язык;
		НовыйПользовательИБ.ОсновнойИнтерфейс = ПользовательИБ.ОсновнойИнтерфейс;
		
		// Роли сохраняем
		Для Каждого ДоступныеРолиПользователяИБ Из ПользовательИБ.Роли Цикл
			НовыйПользовательИБ.Роли.Добавить(ДоступныеРолиПользователяИБ);
		КонецЦикла; 
	
	КонецЕсли;
  	
	Возврат  НовыйПользовательИБ;
	
КонецФункции

#Если Клиент Тогда

//Функция редактирует или создает нового пользователя ИБ
//Процедура редактирует пользователя ИБ
Функция РедактироватьИлиСоздатьПользователяИБ(ОбъектПользователя, ТекущийПользовательИБ, Знач Модифицированность = Ложь,
	Знач ПользовательДляКопированияНастроек = Неопределено) Экспорт
	
	СозданНовыйЭлемент = Ложь;
	
	Если ТекущийПользовательИБ = Неопределено Тогда
		
		Если ОбъектПользователя = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
		
		ИмяПользователя = СокрЛП(ОбъектПользователя.Код);
		
		ОтветПользователя = Вопрос("Пользователь ИБ с именем """ + ИмяПользователя + """ не найден. Создать нового пользователя ИБ?", РежимДиалогаВопрос.ДаНет);
		Если ОтветПользователя <> КодВозвратаДиалога.Да Тогда
			Возврат Ложь;
		КонецЕсли;
		
		// создаем нового пользователя ИБ
		ТекущийПользовательИБ = ПользователиИнформационнойБазы.СоздатьПользователя();
		ТекущийПользовательИБ.Имя = ИмяПользователя;
		ТекущийПользовательИБ.ПолноеИмя = СокрЛП(ОбъектПользователя.Наименование);
		
		СозданНовыйЭлемент = Истина;		
		
	КонецЕсли;
	
	// надо показать форму редактирования настроек пользователя ИБ
	ФормаРедактированияПользователяИБ = ПолучитьОбщуюФорму("ФормаПользователяИБ");
	ФормаРедактированияПользователяИБ.ПользовательИБ = ТекущийПользовательИБ;
	ФормаРедактированияПользователяИБ.ПользовательДляКопированияНастроек = ПользовательДляКопированияНастроек;
	ФормаРедактированияПользователяИБ.Модифицированность = Модифицированность ИЛИ СозданНовыйЭлемент;
	ФормаРедактированияПользователяИБ.Пользователь = ОбъектПользователя;
	
	РезультатОткрытия = ФормаРедактированияПользователяИБ.ОткрытьМодально();
	
	Возврат РезультатОткрытия;
	
КонецФункции

#КонецЕсли


Процедура ИнформироватьОИзмененииНастроекПравАктивныхПользователей(НаборЗаписей, СохраненныеЗначения, ИмяЗначащегоПоля, 
																   ТекущийПользователь, ТекстСообщенияОбИзменениях, 
																   ОбновлятьЗначениеГлПеременнойНаСервере, УстанавливатьНовоеЗначение = Истина) Экспорт
	
	МассивПользователей = Новый Массив;
	МассивГруппПользователей = Новый Массив;
	
	ОбновлятьЗначениеГлПеременнойНаСервере = Ложь;
	ТипЗнчПользователь = ТипЗнч(Справочники.Пользователи.ПустаяСсылка());
		
	Для Каждого Запись Из НаборЗаписей Цикл
		Если Запись.Пользователь = ТекущийПользователь Тогда
			Если УстанавливатьНовоеЗначение Тогда
				СохраненныеЗначения[Запись[ИмяЗначащегоПоля]] = Запись.Значение;
			Иначе
				СохраненныеЗначения.Удалить(Запись[ИмяЗначащегоПоля]);
			КонецЕсли;
			ОбновлятьЗначениеГлПеременнойНаСервере = Истина;
		Иначе
			#Если Клиент Тогда
				Если ТипЗнч(Запись.Пользователь) = ТипЗнчПользователь Тогда
					Массив = МассивПользователей;
				Иначе
					Массив = МассивГруппПользователей;
				КонецЕсли;
				Если Массив.Найти(Запись.Пользователь) = Неопределено Тогда
					Массив.Добавить(Запись.Пользователь);
				КонецЕсли;
			#КонецЕсли
		КонецЕсли;
	КонецЦикла;

	#Если Клиент Тогда
		Если МассивПользователей.Количество() > 0 ИЛИ МассивГруппПользователей.Количество() > 0  Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = "
			|ВЫБРАТЬ Код, Ссылка
			|ИЗ Справочник.Пользователи 
			|ГДЕ Ссылка В (&МассивПользователей)
			|ИЛИ Ссылка В (ВЫБРАТЬ РАЗЛИЧНЫЕ Пользователь ИЗ Справочник.ГруппыПользователей.ПользователиГруппы ГДЕ Ссылка В(&МассивГруппПользователей))";
			Запрос.УстановитьПараметр("МассивПользователей", МассивПользователей);
			Запрос.УстановитьПараметр("МассивГруппПользователей", МассивГруппПользователей);
			
			ТаблицаПользователей = Новый ТаблицаЗначений;
			ТаблицаПользователей.Колонки.Добавить("Код");
			ТаблицаПользователей.Индексы.Добавить("Код");
			
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				Если Выборка.Ссылка = ТекущийПользователь Тогда
					СохраненныеЗначения = Новый Соответствие;
					ОбновлятьЗначениеГлПеременнойНаСервере = Истина;
					Продолжить;
				КонецЕсли;
				СтрокаПользователя = ТаблицаПользователей.Добавить();
				СтрокаПользователя.Код = СокрЛП(Выборка.Код);			
			КонецЦикла;		
			
			МассивПользователей.Очистить();
			МассивСоединений = ПолучитьСоединенияИнформационнойБазы();
			НомерТекущегоСоединения = НомерСоединенияИнформационнойБазы();
			
			Для Каждого Соединение ИЗ МассивСоединений Цикл
				Если Соединение.Пользователь <> Неопределено Тогда
					Если Соединение.ИмяПриложения <> "Designer" 
						И Соединение.НомерСоединения <> НомерТекущегоСоединения
						И ТаблицаПользователей.Найти(Соединение.Пользователь.Имя, "Код") <> Неопределено Тогда
							МассивПользователей.Добавить(Соединение.Пользователь.Имя);
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;			
			
			Если МассивПользователей.Количество() > 0 Тогда
				Сообщить("Были изменены " + ТекстСообщенияОбИзменениях + " пользователей, которые в данный момент работают с ИБ");
				СписокПользователей = "";
				Для Каждого Пользователь ИЗ МассивПользователей Цикл
					СписокПользователей = СписокПользователей + ?(СписокПользователей = "", "(", " ;") + Пользователь;
				КонецЦикла;
				СписокПользователей = СписокПользователей + ")";
				Сообщить(СписокПользователей);			
				Сообщить("Для них новые значения вступят в силу только после перезапуска их сеанса работы с программой");
			КонецЕсли;
			
		КонецЕсли;
	#КонецЕсли	
	
КонецПроцедуры

