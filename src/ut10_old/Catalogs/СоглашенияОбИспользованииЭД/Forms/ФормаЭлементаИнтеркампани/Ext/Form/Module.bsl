﻿// Электронный документооборот (для Интеркампани) нужен для фиксации юридической значимости
// совершаемых хозяйственных операций (передача/возврат товара между организациями).
// Исходя из этого, любой ЭД, сформированный в рамках Интеркампани, должен иметь ЭЦП.
// Следовательно, в соглашении об использовании ЭД, достаточно указать вид ЭД,
// что автоматически будет подразумевать необходимость подписывать его и получать
// подтверждение о подписании его другой стороной.

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Функция ОбъектЗаполнен()
	
	Возврат РеквизитФормыВЗначение("Объект").ПроверитьЗаполнение();
	
КонецФункции

&НаСервере
Процедура УстановитьИдентификатор(ИсточникИдентификатора, Данные)
	
	Если ИсточникИдентификатора = "Организация" Тогда
		СтрокаЗаполнения = Строка(Данные.ИНН)+"_"+Строка(Данные.КПП);
		Если Прав(СтрокаЗаполнения, 1) = "_" Тогда
			СтрокаЗаполнения = СтрЗаменить(СтрокаЗаполнения, "_", "");
		КонецЕсли;
		Объект.ИдентификаторОрганизации = СокрЛП(СтрокаЗаполнения);
	Иначе
		СтрокаЗаполнения = Строка(Данные.ИНН)+"_"+Строка(Данные.КПП);
		Если Прав(СтрокаЗаполнения, 1) = "_" Тогда
			СтрокаЗаполнения = СтрЗаменить(СтрокаЗаполнения, "_", "");
		КонецЕсли;
		Объект.ИдентификаторКонтрагента = СокрЛП(СтрокаЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВидыЭДДоступнымиЗначениями()
	
	АктуальныеВидыЭД = ЭлектронныеДокументыПовтИсп.ПолучитьАктуальныеВидыЭД();
	
	Для Каждого ЗначениеПеречисления Из АктуальныеВидыЭД Цикл
		Если ЗначениеПеречисления = Перечисления.ВидыЭД.ВозвратТоваровМеждуОрганизациями
			ИЛИ ЗначениеПеречисления = Перечисления.ВидыЭД.ПередачаТоваровМеждуОрганизациями Тогда
			
			МассивСтрок = Объект.ВходящиеДокументы.НайтиСтроки(Новый Структура("ВходящийДокумент", ЗначениеПеречисления));
			Если МассивСтрок.Количество() = 0 Тогда
				НоваяСтрока = Объект.ВходящиеДокументы.Добавить();
				НоваяСтрока.ВходящийДокумент = ЗначениеПеречисления;
			КонецЕсли;
			
			МассивСтрок = Объект.ИсходящиеДокументы.НайтиСтроки(Новый Структура("ИсходящийДокумент", ЗначениеПеречисления));
			Если МассивСтрок.Количество() = 0 Тогда
				НоваяСтрока = Объект.ИсходящиеДокументы.Добавить();
				НоваяСтрока.ИсходящийДокумент = ЗначениеПеречисления;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьДоступностьСертификатовПодписей()
	
	Элементы.СертификатыПодписейКонтрагента.Доступность = Объект.ПроверятьСертификатыПодписей;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначенияЭтаповОбменаПоНастройкам(СтруктураПараметров)
	
	МассивСтатусов = ЭлектронныеДокументыСлужебный.ВернутьМассивСтатусовЭД(СтруктураПараметров);
	Если ТаблицаЭтаповИсходящие <> Неопределено Тогда
		ТаблицаЭтаповИсходящие.Очистить();
		
		Для Каждого Элемент Из МассивСтатусов Цикл
			ТаблицаЭтаповИсходящие.Добавить(Элемент);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтруктуруПараметров(СтруктураДанных)
	
	СтруктураПараметров = СтруктураПараметровВидаЭД();
	Если СтруктураДанных.Формировать Тогда
		ЗаполнитьЗначенияСвойств(СтруктураПараметров, СтруктураДанных);
		СтруктураПараметров.СпособОбмена = Объект.СпособОбменаЭД;
		СтруктураПараметров.Направление = Перечисления.НаправленияЭД.Исходящий;
		СтруктураПараметров.ВерсияФорматаПакета = Неопределено;
	КонецЕсли;
	УстановитьЗначенияЭтаповОбменаПоНастройкам(СтруктураПараметров);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьСертификатыТабличнойЧасти(АдресВХранилище, ИндексСтроки, ПараметрыСертификата)
	
	ДанныеФайла              = ПолучитьИзВременногоХранилища(АдресВХранилище);
	ДобавитьДанныеПоТабЧасти(ИндексСтроки, ДанныеФайла, ПараметрыСертификата);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьДанныеПоТабЧасти(ИндексСтроки, ДвоичныеДанные, СтруктураПараметровРезультата)
	
	Если ИндексСтроки < 0 Тогда
		Возврат ;
	КонецЕсли;
	
	Если ДвоичныеДанные <> Неопределено Тогда
		
		СертификатПодписи = Новый СертификатКриптографии(ДвоичныеДанные);
		ПредставлениеСертификата = ЭлектроннаяЦифроваяПодписьКлиентСервер.ПолучитьПредставлениеПользователя(СертификатПодписи.Субъект);
		Отпечаток = Base64Строка(СертификатПодписи.Отпечаток);
		
		ХранилищеЗначения  = Новый ХранилищеЗначения(ДвоичныеДанные);
		Документ = РеквизитФормыВЗначение("Объект");
		Документ.СертификатыПодписейКонтрагента[ИндексСтроки].Сертификат = ХранилищеЗначения;
		Документ.СертификатыПодписейКонтрагента[ИндексСтроки].Отпечаток  = Отпечаток;
		Документ.Записать();
		
		ЗначениеВРеквизитФормы(Документ, "Объект");
		Прочитать();
		ПеречитатьДанныеПоСертификатам(Документ);
		
		СтруктураПараметровРезультата.Представление = ПредставлениеСертификата;
		СтруктураПараметровРезультата.Отпечаток     = Отпечаток;
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ПеречитатьДанныеПоСертификатам(ДокументОбъект)
	
	Для Каждого ЭлементСтрока Из ДокументОбъект.СертификатыПодписейКонтрагента Цикл
		ДвоичныеДанныеСертификата = ЭлементСтрока.Сертификат.Получить();
		Если ДвоичныеДанныеСертификата <> Неопределено Тогда
			
			Попытка
				СертификатПодписи = Новый СертификатКриптографии(ДвоичныеДанныеСертификата);
				ПредставлениеСертификата = ЭлектроннаяЦифроваяПодписьКлиентСервер.ПолучитьПредставлениеПользователя(СертификатПодписи.Субъект);
				Объект.СертификатыПодписейКонтрагента[ДокументОбъект.СертификатыПодписейКонтрагента.Индекс(ЭлементСтрока)].ПредставлениеСертификатаКонтрагента = ПредставлениеСертификата;
			Исключение
			КонецПопытки;
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеДокумента()
	
	Документ = РеквизитФормыВЗначение("Объект");
	ПеречитатьДанныеПоСертификатам(Документ);
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьАктуальностьДанныхСоглашения(ТекстОшибкиАктуальности)
	
	ЗапросПоСоглашениям = Новый Запрос;
	ЗапросПоСоглашениям.УстановитьПараметр("СтатусСоглашения",  Перечисления.СтатусыСоглашенийЭД.Действует);
	ЗапросПоСоглашениям.УстановитьПараметр("ТекущееСоглашение", Объект.Ссылка);
	ЗапросПоСоглашениям.УстановитьПараметр("Организация",       Объект.Организация);
	ЗапросПоСоглашениям.УстановитьПараметр("Контрагент",        Объект.Контрагент);
	ЗапросПоСоглашениям.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СоглашенияОбИспользованииЭДВходящиеДокументы.ВходящийДокумент КАК ТипДокумента,
	|	ИСТИНА КАК Входящий,
	|	СоглашенияОбИспользованииЭДВходящиеДокументы.Ссылка КАК Соглашение
	|ИЗ
	|	Справочник.СоглашенияОбИспользованииЭД.ВходящиеДокументы КАК СоглашенияОбИспользованииЭДВходящиеДокументы
	|ГДЕ
	|	СоглашенияОбИспользованииЭДВходящиеДокументы.Ссылка.СтатусСоглашения = &СтатусСоглашения
	|	И СоглашенияОбИспользованииЭДВходящиеДокументы.Ссылка.УдалитьЭтоТиповое = ЛОЖЬ
	|	И СоглашенияОбИспользованииЭДВходящиеДокументы.Формировать = ИСТИНА
	|	И СоглашенияОбИспользованииЭДВходящиеДокументы.Ссылка.ПометкаУдаления = ЛОЖЬ
	|	И СоглашенияОбИспользованииЭДВходящиеДокументы.Ссылка <> &ТекущееСоглашение
	|	И СоглашенияОбИспользованииЭДВходящиеДокументы.Ссылка.Организация = &Организация
	|	И СоглашенияОбИспользованииЭДВходящиеДокументы.Ссылка.Контрагент = &Контрагент
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СоглашенияОбИспользованииЭДИсходящиеДокументы.ИсходящийДокумент,
	|	ЛОЖЬ,
	|	СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка
	|ИЗ
	|	Справочник.СоглашенияОбИспользованииЭД.ИсходящиеДокументы КАК СоглашенияОбИспользованииЭДИсходящиеДокументы
	|ГДЕ
	|	СоглашенияОбИспользованииЭДИсходящиеДокументы.Формировать = ИСТИНА
	|	И СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка.УдалитьЭтоТиповое = ЛОЖЬ
	|	И СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка.СтатусСоглашения = &СтатусСоглашения
	|	И СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка.ПометкаУдаления = ЛОЖЬ
	|	И СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка <> &ТекущееСоглашение
	|	И СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка.Организация = &Организация
	|	И СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка.Контрагент = &Контрагент";
	
	Результат = ЗапросПоСоглашениям.Выполнить().Выгрузить();
	
	ТекстОшибкиИсходящие = "";
	ТекстОшибкиВходящие = "";
	ПроверитьУникальностьДокументов(Объект.ИсходящиеДокументы, Результат, ТекстОшибкиИсходящие);
	ПроверитьУникальностьДокументов(Объект.ВходящиеДокументы, Результат, ТекстОшибкиВходящие, Истина);
	
	ТекстОшибкиАктуальности = ТекстОшибкиИсходящие + ТекстОшибкиВходящие;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьУникальностьДокументов(ТабличнаяЧастьДокументов, РезультатПроверки, ТекстОшибки, ПроверятьВходящиеДокументы = Ложь)
	
	ОтборСуществующихДокументов = Новый Структура("Входящий", ПроверятьВходящиеДокументы);
	ВидыДокументовДругихСоглашений = РезультатПроверки.НайтиСтроки(ОтборСуществующихДокументов);
	Если ВидыДокументовДругихСоглашений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ТекущийДокументСоглашения Из ТабличнаяЧастьДокументов Цикл
		Если ТекущийДокументСоглашения.Формировать Тогда
			Для Каждого ДокументВДругихСоглашениях Из ВидыДокументовДругихСоглашений Цикл
				Если ТекущийДокументСоглашения[?(ПроверятьВходящиеДокументы, "ВходящийДокумент", "ИсходящийДокумент")] = ДокументВДругихСоглашениях.ТипДокумента Тогда
					ТекстОшибки = НСтр("ru = 'По виду электронных документов %1 %2 
					|уже существует действующее соглашение между участниками %3 - %4:
					|%5.
					|'");
					ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						ТекстОшибки, ДокументВДругихСоглашениях.ТипДокумента,
						?(ПроверятьВходящиеДокументы, "Входящий", "Исходящий"),
						Объект.Организация, 
						Объект.Контрагент, 
						ДокументВДругихСоглашениях.Соглашение);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция СоглашениеЗаписано()
	
	Если НЕ Параметры.Ключ.Пустая() Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если НЕ Объект.УдалитьЭтоТиповое Тогда
		ТекстВопроса = НСтр("ru = 'Внешние сертификаты можно выбирать только в записанном соглашении.
		|Записать соглашение?'");
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	Иначе
		Ответ = КодВозвратаДиалога.Да;
	КонецЕсли;
	
	Возврат Ответ = КодВозвратаДиалога.Да И ОбъектЗаполнен();
	
КонецФункции

&НаКлиенте
Процедура ИзменитьНадписьНаправлениеДокументов()
	
	ШаблонСообщения = НСтр("ru='От кого: %1, кому: %2'");
	НадписьНаправлениеДокументов = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, 
		Объект.Организация, Объект.Контрагент);
	
КонецПроцедуры

&НаСервере
Функция СписокОрганизаций(ИсключаемыйЭлемент)
	
	НазваниеСправочникаОрганизации = ЭлектронныеДокументыПовтИсп.ПолучитьИмяПрикладногоСправочника("Организации");
	Если Не ЗначениеЗаполнено(НазваниеСправочникаОрганизации) Тогда
		НазваниеСправочникаОрганизации = "Организации";
	КонецЕсли; 
	
	МассивОрганизаций = Новый Массив;
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организации.Ссылка,
	|	Организации.Наименование
	|ИЗ
	|	Справочник."+ НазваниеСправочникаОрганизации +" КАК Организации
	|ГДЕ
	|	Организации.Ссылка <> &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", ИсключаемыйЭлемент);
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		МассивОрганизаций = Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
	КонецЕсли;
	
	Возврат МассивОрганизаций;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьНаименование()
	
	Организация = Объект.Организация;
	Контрагент  = Объект.Контрагент;
	Если НЕ ЗначениеЗаполнено(Объект.Наименование)
		И ЗначениеЗаполнено(Организация)
		И ЗначениеЗаполнено(Контрагент) Тогда
		Объект.Наименование = "" + Организация + " -> " + Контрагент;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокВыбораОрганизаций(СписокВыбора, ИсключаемыйЭлемент)
	
	МассивОрганизаций = СписокОрганизаций(ИсключаемыйЭлемент);
	Если МассивОрганизаций.Количество() > 0 Тогда
		СписокВыбора.ЗагрузитьЗначения(МассивОрганизаций);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СтруктураПараметровВидаЭД()
	
	СтруктураВозврата = Новый Структура("СпособОбмена, Направление, ВидЭД, ИспользоватьПодпись,
	|ИспользоватьКвитанции, ВерсияФорматаПакета");
	Возврат СтруктураВозврата;
	
КонецФункции

&НаКлиенте
Функция СтруктураСертификата()
	
	СтруктураВозврата =  Новый Структура("Представление, Отпечаток","","");
	Возврат СтруктураВозврата;
	
КонецФункции

&НаСервере
Процедура ОбновитьЗаголовокФормы()
	
	Если Объект.УдалитьЭтоТиповое Тогда
		ТекстЗаголовка = НСтр("ru='Типовая настройка ЭДО между организациями'");
	Иначе
		ТекстЗаголовка = НСтр("ru='Настройка ЭДО между организациями'");
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Заголовок = ТекстЗаголовка + НСтр("ru=' (создание)'");
	Иначе
		Заголовок = ТекстЗаголовка;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТаблицуЭтапов()
	
	Если Элементы.Страницы.ТекущаяСтраница <> Неопределено Тогда
		ТекущиеДанные = Неопределено;
		Если Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.ГруппаИсходящиеДокументы Тогда
			ТекущиеДанные = Элементы.ИсходящиеДокументы.ТекущиеДанные;
			ВидЭД = ТекущиеДанные.ИсходящийДокумент;
		КонецЕсли;
		Если ТекущиеДанные <> Неопределено Тогда
			СтруктураДанных = Новый Структура("ИспользоватьПодпись, ИспользоватьКвитанции, Формировать, ВидЭД");
			СтруктураДанных.ИспользоватьПодпись = ТекущиеДанные.ИспользоватьЭЦП;
			СтруктураДанных.ИспользоватьКвитанции = ТекущиеДанные.ОжидатьКвитанциюОДоставке;
			СтруктураДанных.Формировать = ТекущиеДанные.Формировать;
			СтруктураДанных.ВидЭД = ВидЭД;
			ЗаполнитьСтруктуруПараметров(СтруктураДанных);
		КонецЕсли;
	КонецЕсли	

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЕЙ ФОРМЫ

&НаКлиенте
Процедура ОрганизацияОтправительОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Объект.ИдентификаторОрганизации) Тогда
		Если ВыбранноеЗначение <> Объект.Организация Тогда
			ТекстВопроса = НСтр("ru = 'Была изменена организация. Изменить идентификатор обмена организации?'");
			Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
			Если Ответ = КодВозвратаДиалога.Да Тогда
				УстановитьИдентификатор("Организация", ВыбранноеЗначение);
			КонецЕсли;
		КонецЕсли;
	Иначе
		
		УстановитьИдентификатор("Организация", ВыбранноеЗначение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверятьСертификатыПодписейПриИзменении(Элемент)
	
	ОпределитьДоступностьСертификатовПодписей();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОтправительПриИзменении(Элемент)
	
	ЗаполнитьНаименование();
	ИзменитьНадписьНаправлениеДокументов();
	ЗаполнитьСписокВыбораОрганизаций(Элементы.Контрагент.СписокВыбора, Объект.Организация);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучательОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Объект.ИдентификаторКонтрагента) Тогда
		Если ВыбранноеЗначение <> Объект.Контрагент Тогда
			ТекстВопроса = НСтр("ru = 'Была изменена организация получатель. Изменить идентификатор получателя?'");
			Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
			Если Ответ = КодВозвратаДиалога.Да Тогда
				УстановитьИдентификатор("Контрагент", ВыбранноеЗначение);
			КонецЕсли;
		КонецЕсли;
	Иначе
		УстановитьИдентификатор("Контрагент", ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучательПриИзменении(Элемент)
	
	ЗаполнитьНаименование();
	ИзменитьНадписьНаправлениеДокументов();
	ЗаполнитьСписокВыбораОрганизаций(Элементы.ОрганизацияОтправитель.СписокВыбора, Объект.Контрагент);

КонецПроцедуры

&НаКлиенте
Процедура ИдентификаторОрганизацииПриИзменении(Элемент)
	
	Объект.ИдентификаторОрганизации = СокрЛП(Объект.ИдентификаторОрганизации);
	
КонецПроцедуры

&НаКлиенте
Процедура ИдентификаторКонтрагентаПриИзменении(Элемент)
	
	Объект.ИдентификаторКонтрагента = СокрЛП(Объект.ИдентификаторКонтрагента);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЕЙ ТАБЛИЦЫ ИСХОДЯЩИЕ ДОКУМЕНТЫ

&НаКлиенте
Процедура ИсходящиеДокументыПриИзменении(Элемент)
	
	Элемент.ТекущиеДанные.ИспользоватьЭЦП = Элемент.ТекущиеДанные.Формировать;
	
	ЗаполнитьТаблицуЭтапов();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсходящиеДокументыПриАктивизацииСтроки(Элемент)
	
	ЗаполнитьТаблицуЭтапов();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсходящиеДокументыИспользоватьОбменПриИзменении(Элемент)
	
	ЗначениеЭлемента = Элемент.Родитель.ТекущиеДанные.Формировать;
	Если НЕ ЗначениеЭлемента Тогда
		
		Элемент.Родитель.ТекущиеДанные.ОжидатьКвитанциюОДоставке = ЗначениеЭлемента;
		Элемент.Родитель.ТекущиеДанные.ИспользоватьЭЦП           = ЗначениеЭлемента;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЕЙ ТАБЛИЦЫ СЕРТИФИКАТЫ ПОДПИСЕЙ КОНТРАГЕНТА

&НаКлиенте
Процедура СертификатыПодписейКонтрагентаПредставлениеСертификатаКонтрагентаПриИзменении(Элемент)
	
	Если НЕ СоглашениеЗаписано() Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(Элемент.ТекстРедактирования) Тогда
		СтруктураПараметров = СтруктураСертификата();
		ДобавитьДанныеПоТабЧасти(
			Объект.СертификатыПодписейКонтрагента.Индекс(Элементы.СертификатыПодписейКонтрагента.ТекущиеДанные),
			Неопределено,
			СтруктураПараметров);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыПодписейКонтрагентаПредставлениеСертификатаКонтрагентаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если НЕ СоглашениеЗаписано() Тогда
		Возврат;
	КонецЕсли;
	
	ВыбранныеФайл   = "";
	АдресВХранилище = Неопределено;
	Если ПоместитьФайл(АдресВХранилище, "", ВыбранныеФайл, Истина, УникальныйИдентификатор) Тогда
		
		ИндексСтроки = Объект.СертификатыПодписейКонтрагента.Индекс(Элементы.СертификатыПодписейКонтрагента.ТекущиеДанные);
		ПараметрыДобавленногоСертификата = СтруктураСертификата();
		ДобавитьСертификатыТабличнойЧасти(АдресВХранилище, ИндексСтроки, ПараметрыДобавленногоСертификата);
		
		Элементы.СертификатыПодписейКонтрагента.ТекущиеДанные.ПредставлениеСертификатаКонтрагента = ПараметрыДобавленногоСертификата.Представление;
		Элементы.СертификатыПодписейКонтрагента.ТекущиеДанные.Отпечаток                           = ПараметрыДобавленногоСертификата.Отпечаток;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыПодписейКонтрагентаПредставлениеСертификатаКонтрагентаОчистка(Элемент, СтандартнаяОбработка)
	
	СтруктураПараметров = СтруктураСертификата();
	ДобавитьДанныеПоТабЧасти(
		Объект.СертификатыПодписейКонтрагента.Индекс(Элементы.СертификатыПодписейКонтрагента.ТекущиеДанные),
		Неопределено,
		СтруктураПараметров);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыПодписейКонтрагентаПослеУдаления(Элемент)
	
	ОбновитьДанныеДокумента();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("РежимОткрытияОкна") Тогда
		РежимОткрытияОкна = Параметры.РежимОткрытияОкна;
	КонецЕсли;
	
	ЗаполнитьВидыЭДДоступнымиЗначениями();
	
	ОбъектЭлемента = РеквизитФормыВЗначение("Объект");
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда // Новый
		Если Параметры.Свойство("Типовое") И Параметры.Типовое Тогда
			Объект.УдалитьЭтоТиповое = Истина;
		КонецЕсли;
		Объект.ЭтоИнтеркампани  = Истина;
		Объект.СтатусСоглашения = Перечисления.СтатусыСоглашенийЭД.НеСогласовано;
		Если НЕ ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда // Не копирование
			Объект.Контрагент = ЭлектронныеДокументыПовтИсп.ПолучитьПустуюСсылку("Организации");
		Иначе
			// При копировании не переносим настройки шифрования и эталонные сертификаты контрагента
			Объект.СертификатОрганизацииДляРасшифровки = Неопределено;
			Объект.ПроверятьСертификатыПодписей        = Ложь;
			Объект.СертификатыПодписейКонтрагента.Очистить();
		КонецЕсли;
	Иначе
		ДокументОбъект = РеквизитФормыВЗначение("Объект");
		Попытка
			ДвоичныеДанныеСертификата  = ДокументОбъект.СертификатКонтрагентаДляШифрования.Получить();
			Если ДвоичныеДанныеСертификата <> Неопределено Тогда
				СертификатКриптографии = Новый СертификатКриптографии(ДвоичныеДанныеСертификата);
				ПредставлениеСертификата = ЭлектроннаяЦифроваяПодписьКлиентСервер.ПолучитьПредставлениеПользователя(
					СертификатКриптографии.Субъект);
				ФормаСертификатКонтрагентаДляШифрования = ПредставлениеСертификата;
			КонецЕсли;
			ОпределитьДоступностьСертификатовПодписей();
			ПеречитатьДанныеПоСертификатам(ДокументОбъект);
		Исключение
			ТекстСообщения = КраткоеПредставлениеОшибки(ИнформацияОбОшибке())
				+ НСтр("ru = ' (подробности см. в Журнале регистрации).'");
			ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЭлектронныеДокументыСлужебныйВызовСервера.ОбработатьИсключениеПоЭДНаСервере(
				НСтр("ru = 'открытие формы соглашения'"), ТекстОшибки, ТекстСообщения);
		КонецПопытки;
	КонецЕсли;
	
	ИспользуютсяЭЦП = ЭлектронныеДокументыСлужебныйВызовСервера.ПолучитьЗначениеФункциональнойОпции("ИспользоватьЭлектронныеЦифровыеПодписи");
	Если НЕ ИспользуютсяЭЦП Тогда
		Элементы.ИсходящиеДокументыИспользоватьЭЦП.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ГруппаШапкаПраво.Видимость                                 = НЕ Объект.УдалитьЭтоТиповое;
	Элементы.СертификатыЭЦП.Видимость                                   = НЕ Объект.УдалитьЭтоТиповое И ИспользуютсяЭЦП;
	Элементы.ФормаЭД.Видимость                                          = НЕ Объект.УдалитьЭтоТиповое;
	Элементы.ФормаКоманднаяПанель.ПодчиненныеЭлементы.ФормаЭД.Видимость = Ложь;
	Если Объект.УдалитьЭтоТиповое Тогда
		Для Каждого Элемент Из Элементы.ГруппаШапкаПраво.ПодчиненныеЭлементы Цикл
			Элемент.РастягиватьПоГоризонтали = Истина;
		КонецЦикла;
	КонецЕсли;
	ТекущийСпособОбменаЭД = Объект.СпособОбменаЭД;
	ОбновитьЗаголовокФормы();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ПеречитатьДанныеПоСертификатам(ДокументОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если НЕ Объект.УдалитьЭтоТиповое Тогда
		Если Объект.СтатусСоглашения = ПредопределенноеЗначение("Перечисление.СтатусыСоглашенийЭД.Действует") Тогда
			ТекстОшибкиАктуальности = "";
			ПроверитьАктуальностьДанныхСоглашения(ТекстОшибкиАктуальности);
			Если НЕ ПустаяСтрока(ТекстОшибкиАктуальности) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибкиАктуальности, , , , Отказ);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИзменитьНадписьНаправлениеДокументов();
	МассивОрганизаций = СписокОрганизаций(ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка"));
	Если МассивОрганизаций.Количество() > 0 Тогда
		Элементы.ОрганизацияОтправитель.СписокВыбора.ЗагрузитьЗначения(МассивОрганизаций);
		Элементы.Контрагент.СписокВыбора.ЗагрузитьЗначения(МассивОрганизаций);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ОпределитьДоступностьСертификатовПодписей();
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.ГруппаИсходящиеДокументы Тогда
		Если  НЕ Элементы.ИсходящиеДокументы.ТекущаяСтрока=Неопределено Тогда
			
			СтруктураПараметров = СтруктураПараметровВидаЭД();
			СтруктураПараметров.СпособОбмена          = Объект.СпособОбменаЭД;
			СтруктураПараметров.Направление           = Перечисления.НаправленияЭД.Интеркампани;
			СтруктураПараметров.ИспользоватьПодпись   = Объект.ИсходящиеДокументы[Элементы.ИсходящиеДокументы.ТекущаяСтрока].ИспользоватьЭЦП;
			СтруктураПараметров.ИспользоватьКвитанции = Объект.ИсходящиеДокументы[Элементы.ИсходящиеДокументы.ТекущаяСтрока].ОжидатьКвитанциюОДоставке;
			
			Если НЕ Объект.ИсходящиеДокументы[Элементы.ИсходящиеДокументы.ТекущаяСтрока].Формировать Тогда
				СтруктураПараметров = Неопределено;
			КонецЕсли;
			
			УстановитьЗначенияЭтаповОбменаПоНастройкам(СтруктураПараметров);
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	СписокСтрокКУдалению = Новый СписокЗначений;
	Для каждого СтрокаСертификата ИЗ ТекущийОбъект.СертификатыПодписейКонтрагента Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаСертификата.Отпечаток) Тогда
			СписокСтрокКУдалению.Добавить(СтрокаСертификата.НомерСтроки);
		КонецЕсли;
	КонецЦикла;
	
	СписокСтрокКУдалению.СортироватьПоЗначению(НаправлениеСортировки.Убыв);
	
	Для Каждого Запись ИЗ СписокСтрокКУдалению Цикл
		ТекущийОбъект.СертификатыПодписейКонтрагента.Удалить(Запись.Значение - 1);
	КонецЦикла
	
КонецПроцедуры
