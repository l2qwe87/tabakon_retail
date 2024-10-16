﻿Перем мВалютаРегламентированногоУчета Экспорт;

Перем мУдалятьДвижения;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

// Возвращает доступные варианты печати документа
//
// Вовращаемое значение:
//  Струткура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура;

КонецФункции // ПолучитьТаблицуПечатныхФорм()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Процедура проверяет корректность заполнения реквизитов шапки документа
//
Процедура ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок)
	
	// Укажем, что надо проверить:
	СтрРекв = "Организация";
					
	// Вызовем общую процедуру для проверки проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, Новый Структура(СтрРекв), Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Процедура проверяет корректность заполнения реквизитов таб. части документа
//
Процедура ПроверитьЗаполнениеТабЧасти(СтруктураШапкиДокумента, Отказ, Заголовок);

	ОбязательныеРеквизиты = "Номенклатура";

	//проверка заполнения обязательных реквизитов
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "ДанныеПоПартиям", Новый Структура(ОбязательныеРеквизиты), Отказ, Заголовок);
	
	//Проверка таблицы дополнительных сведений
	ОбязательныеРеквизиты = "ВидЦенности, СтавкаНДС";
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "ДанныеПоСФ", Новый Структура(ОбязательныеРеквизиты), Отказ, Заголовок);

	ОбязательныеРеквизиты = "СчетФактура";
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "ДанныеПоСФ", Новый Структура(ОбязательныеРеквизиты), Неопределено, Заголовок);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ЭтотОбъект.Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СУММА(ЕСТЬNULL(ВводНачальныхОстатковНДСпоПартиямДанныеПоСФ.Количество,0)) КАК Количество,
	|	МАКСИМУМ(ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям.Количество) КАК КоличествоПоПартии,
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям.НомерСтроки,
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям.Партия
	|ИЗ
	|	Документ.ВводНачальныхОстатковНДСпоПартиям.ДанныеПоПартиям КАК ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВводНачальныхОстатковНДСпоПартиям.ДанныеПоСФ КАК ВводНачальныхОстатковНДСпоПартиямДанныеПоСФ
	|		ПО ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям.КлючСтроки = ВводНачальныхОстатковНДСпоПартиямДанныеПоСФ.КлючСтроки
	|			И ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям.Ссылка = ВводНачальныхОстатковНДСпоПартиямДанныеПоСФ.Ссылка
	|ГДЕ
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям.НомерСтроки,
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям.Партия
	|
	|";
		
	Результат = Запрос.Выполнить().Выгрузить();
	Для Каждого Строка Из Результат Цикл
		Если Строка.Количество <> Строка.КоличествоПоПартии Тогда
			СтрокаСообщенияОбОшибке = "В строке номер """+ СокрЛП(Строка.НомерСтроки) +
			                               """ табличной части ""Данные по партиям"": Количество по партии не соответствует количеству по счетам-фактурам";
			ОбщегоНазначения.СообщитьОбОшибке(СтрокаСообщенияОбОшибке, Отказ, Заголовок);
		КонецЕсли; 
		
		Если НЕ ЗначениеЗаполнено(Строка.Партия) Тогда
			СтрокаСообщенияОбОшибке = "В строке номер """+ СокрЛП(Строка.НомерСтроки) +
			                               """ табличной части ""Данные по партиям"": Не заполнена партия.";
			ОбщегоНазначения.СообщитьОбОшибке(СтрокаСообщенияОбОшибке, , Заголовок, СтатусСообщения.Информация);
		КонецЕсли; 
			

	КонецЦикла;
	
КонецПроцедуры // ПроверитьЗаполнениеТабЧасти()

Функция ПодготовитьТаблицуДвиженийДокумента(СтруктураШапкиДокумента, Отказ, Заголовок)
	
	ТаблицаДокумента = Новый ТаблицаЗначений;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ЭтотОбъект.Ссылка);

	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям.Номенклатура,
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям.Партия,
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям.Склад,
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоСФ.СчетФактура,
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоСФ.ВидЦенности,
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоСФ.НДСВключенВСтоимость,
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоСФ.Количество,
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоСФ.Стоимость,
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоСФ.СтавкаНДС,
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоСФ.НДС,
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям.ХарактеристикаНоменклатуры,
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям.СерияНоменклатуры
	|ИЗ
	|	Документ.ВводНачальныхОстатковНДСпоПартиям.ДанныеПоСФ КАК ВводНачальныхОстатковНДСпоПартиямДанныеПоСФ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВводНачальныхОстатковНДСпоПартиям.ДанныеПоПартиям КАК ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям
	|		ПО ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям.КлючСтроки = ВводНачальныхОстатковНДСпоПартиямДанныеПоСФ.КлючСтроки
	|ГДЕ
	|	ВводНачальныхОстатковНДСпоПартиямДанныеПоСФ.Ссылка = &Ссылка
	|	И ВводНачальныхОстатковНДСпоПартиямДанныеПоПартиям.Ссылка = &Ссылка";
	
	ТаблицаДокумента = Запрос.Выполнить().Выгрузить();
	
	
	Если Не СтруктураШапкиДокумента.ВестиПартионныйУчетПоСкладам Тогда
		ТаблицаДокумента.ЗаполнитьЗначения(Справочники.Склады.ПустаяСсылка(),"Склад");
	КонецЕсли;
	
	Для каждого СтрокаТаблицыДокумента Из ТаблицаДокумента Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицыДокумента.Партия) Тогда
			СтрокаТаблицыДокумента.Партия = Неопределено;
		КонецЕсли;
		
	КонецЦикла; 
	
	Возврат ТаблицаДокумента;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ДВИЖЕНИЙ ДОКУМЕНТА ПО РЕГИСТРАМ

// Процедура формирования движений по регистрам.
//
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаДокумента, Отказ,Заголовок)
	
	Если ТаблицаДокумента.Количество()=0 Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаДвижений = Движения.НДСПартииТоваров.ВыгрузитьКолонки();
	ТаблицаДокумента.Колонки.Добавить("Организация");
	ТаблицаДокумента.ЗаполнитьЗначения(СтруктураШапкиДокумента.Организация, "Организация");
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаДокумента,ТаблицаДвижений);
	
	Если ТаблицаДвижений.Количество() > 0 Тогда
		Движения.НДСПартииТоваров.мПериод          = СтруктураШапкиДокумента.Дата;
		Движения.НДСПартииТоваров.мТаблицаДвижений = ТаблицаДвижений;

		Движения.НДСПартииТоваров.ВыполнитьПриход();
		Движения.НДСПартииТоваров.Записать();
	КонецЕсли;
	
КонецПроцедуры // ДвиженияПоРегистрам()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ)

	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке = ОбщегоНазначения.СформироватьДеревоПолейЗапросаПоШапке();
	ОбщегоНазначения.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "УчетнаяПолитика", 	"ВестиПартионныйУчетПоСкладам", "ВестиПартионныйУчетПоСкладам");

	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = УправлениеЗапасами.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, мВалютаРегламентированногоУчета);

	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(СтруктураШапкиДокумента);

	// Проверим правильность заполнения шапки документа
	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);
	ПроверитьЗаполнениеТабЧасти(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	ТаблицаДокумента = ПодготовитьТаблицуДвиженийДокумента(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	Если Не Отказ Тогда
				
		ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаДокумента, Отказ, Заголовок);
			
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроведения()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	мУдалятьДвижения = НЕ ЭтоНовый();

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	
КонецПроцедуры


мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");

