﻿Перем мУдалятьДвижения;

Перем мВалютаРегламентированногоУчета Экспорт;

// Хранит структуру, содержащую параметры для определения договора, доступного в данном документе:
//    список допустимых видов договоров;
//    список допустимых способов ведения взаиморасчетов.
Перем мСтруктураПараметровДляПолученияДоговора Экспорт;

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

Процедура ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок)

	СтруктураОбязательныхПолей = Новый Структура("Организация, Контрагент, ДоговорКонтрагента");

	Если СтруктураШапкиДокумента.Дата >= '20150101' Тогда
		СтруктураОбязательныхПолей.Вставить("КодВидаОперации");
	КонецЕсли;

	// Вызовем общую процедуру для проверки проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Выгружает результат запроса в табличную часть, добавляет ей необходимые колонки для проведения.
//
// Параметры: 
//  РезультатЗапросаПоТоварам - результат запроса по табличной части "Товары",
//  СтруктураШапкиДокумента   - выборка по результату запроса по шапке документа.
//
// Возвращаемое значение:
//  Сформированная таблица значений.
//
Функция ПодготовитьТаблицуТоваров(РезультатЗапросаПоТоварам, СтруктураШапкиДокумента)

	ТаблицаТоваров = РезультатЗапросаПоТоварам.Выгрузить();

	ТаблицаТоваров.Колонки.Добавить("КодВидаОперации", ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(10));
	Если СтруктураШапкиДокумента.Дата >= '20150101' Тогда
		ТаблицаТоваров.ЗаполнитьЗначения(СтруктураШапкиДокумента.КодВидаОперации, "КодВидаОперации");
	КонецЕсли;

	Возврат ТаблицаТоваров;

КонецФункции // ПодготовитьТаблицуТоваров()

// Процедура формирует таблицы документа, вляиющие на состояние расчетов с контрагентами.
//
Процедура ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента, ТаблицаПоТоварам) Экспорт
	
	Если СтруктураШапкиДокумента.ДокументСоздан_НО_НДС Тогда
		// Проверка и дополнительная обработка не требуются
		Возврат;
	КонецЕсли; 
	
	СтруктураПолей = УправлениеЗапасами.СформироватьСтруктуруПолейТовары();
	СтруктураПолей.Вставить("Количество", "Количество");
	СтруктураПолей.Вставить("Услуга"	, "Номенклатура.Услуга");
	
	СтруктураПолей.Удалить("ХарактеристикаНоменклатуры");
	СтруктураПолей.Удалить("СерияНоменклатуры");


	РезультатЗапросаПоТоварам = ОбщегоНазначения.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "ТоварыИУслуги", СтруктураПолей);

	// Подготовим таблицу товаров для проведения.
	ТаблицаПоТоварам = ПодготовитьТаблицуТоваров(РезультатЗапросаПоТоварам, СтруктураШапкиДокумента);
	
 	БухгалтерскийУчетРасчетовСКонтрагентами.ПодготовкаТаблицыЗначенийДляЦелейПриобретенияИРеализации(ТаблицаПоТоварам, СтруктураШапкиДокумента, Истина, мВалютаРегламентированногоУчета);
	
КонецПроцедуры // СформироватьТаблицыДокумента()

// Дополняет структуру шапки документа значениями, требуемыми для проведения
//
Процедура ДополнитьСтруктуруШапкиДокумента(СтруктураШапкиДокумента)
	
	СтруктураШапкиДокумента.Вставить("ОтражатьВНалоговомУчете", Ложь);
	
КонецПроцедуры

// Процедура формирует структуру шапки документа и дополнительных полей.
//
Процедура ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента) Экспорт
	
	// Дерево значений, содержащее имена необходимых полей в запросе по шапке.
	Перем ДеревоПолейЗапросаПоШапке;

	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	ДополнитьСтруктуруШапкиДокумента(СтруктураШапкиДокумента);
	
	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке      = ОбщегоНазначения.СформироватьДеревоПолейЗапросаПоШапке();
	
	ОбщегоНазначения.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "ВедениеВзаиморасчетов",                  "ВедениеВзаиморасчетов");
	//ОбщегоНазначения.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "ВалютаВзаиморасчетов",                   "ВалютаВзаиморасчетов");
	ОбщегоНазначения.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "Организация",                            "ДоговорОрганизация");
	ОбщегоНазначения.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "ВидДоговора",                            "ВидДоговора");
	ОбщегоНазначения.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "РасчетыВУсловныхЕдиницах"                , "РасчетыВУсловныхЕдиницах");
	ОбщегоНазначения.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "УчетАгентскогоНДС"                       , "УчетАгентскогоНДС");
	ОбщегоНазначения.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "ВидАгентскогоДоговора"                   , "ВидАгентскогоДоговора");
	ОбщегоНазначения.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "УчетнаяПолитика",      "ВестиПартионныйУчетПоСкладам",           "ВестиПартионныйУчетПоСкладам");
	
	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = УправлениеЗапасами.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, мВалютаРегламентированногоУчета);
	
	ДокументСоздан_НО_НДС = (ЗначениеЗаполнено(СтруктураШапкиДокумента.РасчетныйДокумент)) и (ТипЗнч(СтруктураШапкиДокумента.РасчетныйДокумент) = Тип("ДокументСсылка.ВводНачальныхОстатковНДС"));
	СтруктураШапкиДокумента.Вставить("ДокументСоздан_НО_НДС", ДокументСоздан_НО_НДС);

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(СтруктураШапкиДокумента);

КонецПроцедуры // ПодготовитьСтруктуруШапкиДокумента() 

// Проверяет правильность заполнения строк табличной части "Товары".
//
// Параметры:
// Параметры: 
//  ТаблицаПоТоварам        - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  СтруктураШапкиДокумента - выборка из результата запроса по шапке документа,
//  Отказ                   - флаг отказа в проведении.
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеТабличнойЧастиТовары(ТаблицаПоТоварам, СтруктураШапкиДокумента, Отказ, Заголовок)

	ИмяТабличнойЧасти = "ТоварыИУслуги";

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("Номенклатура, Сумма, СтавкаНДС");

	// Теперь вызовем общую процедуру проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, ИмяТабличнойЧасти, СтруктураОбязательныхПолей, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиТовары()

// Процедура выполняет движения по регистрам
//
Процедура ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок)
	
	ДвиженияРегистровПодсистемыНДС(СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок);

КонецПроцедуры // ДвиженияПоРегистрам()

Процедура ДвиженияРегистровПодсистемыНДС(СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок) Экспорт

	Если СтруктураШапкиДокумента.ДокументСоздан_НО_НДС Тогда
		// Проверка и дополнительная обработка не требуются
		Возврат;
	КонецЕсли; 
	
	Если СтруктураШапкиДокумента.ПрямаяЗаписьВКнигу Тогда
		// Прямая запись в книгу покупок
		ТаблицаДвижений_НДСЗаписиКнигиПродаж = Движения.НДСЗаписиКнигиПродаж.Выгрузить();
		ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаПоТоварам,ТаблицаДвижений_НДСЗаписиКнигиПродаж);
		
		ТаблицаДвижений_НДСЗаписиКнигиПродаж.ЗаполнитьЗначения(СтруктураШапкиДокумента.Организация, "Организация");
		ТаблицаДвижений_НДСЗаписиКнигиПродаж.ЗаполнитьЗначения(СтруктураШапкиДокумента.ДатаОплаты, "ДатаОплаты");
		ТаблицаДвижений_НДСЗаписиКнигиПродаж.ЗаполнитьЗначения(СтруктураШапкиДокумента.РасчетныйДокумент, "ДокументОплаты");
		ТаблицаДвижений_НДСЗаписиКнигиПродаж.ЗаполнитьЗначения(СтруктураШапкиДокумента.Ссылка, "СчетФактура");
		ТаблицаДвижений_НДСЗаписиКнигиПродаж.ЗаполнитьЗначения(СтруктураШапкиДокумента.Контрагент, "Покупатель");
		ТаблицаДвижений_НДСЗаписиКнигиПродаж.ЗаполнитьЗначения(Перечисления.СобытияПоНДСПродажи.Реализация, "Событие");
		
		Движения.НДСЗаписиКнигиПродаж.мПериод 			= СтруктураШапкиДокумента.Дата;
		Движения.НДСЗаписиКнигиПродаж.мТаблицаДвижений	= ТаблицаДвижений_НДСЗаписиКнигиПродаж;
		Движения.НДСЗаписиКнигиПродаж.ДобавитьДвижение();
	    Возврат;
	КонецЕсли;
	
	УчетНДСФормированиеДвижений.СформироватьДвиженияПоРегиструНДСНачисленный_ОтражениеРеализации(СтруктураШапкиДокумента, ТаблицаПоТоварам, Движения, Отказ);
	
	УчетНДСФормированиеДвижений.СформироватьДвиженияПоРегиструНДСРасчетыСПокупателями_Задолженность(СтруктураШапкиДокумента, ТаблицаПоТоварам, Движения, Отказ);
	
	// При необходимости, отражаем в регистре партионного учета для НДС
	//////////////////////////////////////////////////////////////////////
	
КонецПроцедуры // ДвиженияРегистровПодсистемыНДС()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура вызывается перед записью документа 
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	мУдалятьДвижения = НЕ ЭтоНовый();

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	// Посчитать суммы документа и записать ее в соответствующий реквизит шапки для показа в журналах
	СуммаДокумента = ТоварыИУслуги.Итог("Сумма") + ТоварыИУслуги.Итог("СуммаНДС");
	
	Если не ЗначениеЗаполнено(ВалютаДокумента) Тогда
		ВалютаДокумента = мВалютаРегламентированногоУчета;
	КонецЕсли; 
	
	Если НЕ (ЗначениеЗаполнено(РасчетныйДокумент) и ТипЗнч(РасчетныйДокумент) = Тип("ДокументСсылка.ВводНачальныхОстатковНДС")) Тогда
		УчетНДС.СинхронизацияПометкиНаУдалениеУСчетаФактуры(ЭтотОбъект);
				
	КонецЕслИ;

КонецПроцедуры // ПередЗаписью

// Процедура - обработчик события "ПриЗаписи"
//
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ (ЗначениеЗаполнено(РасчетныйДокумент) и ТипЗнч(РасчетныйДокумент) = Тип("ДокументСсылка.ВводНачальныхОстатковНДС")) Тогда
		УчетНДС.ПроверитьСоответствиеРеквизитовСчетаФактуры(ЭтотОбъект);	
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	Перем Заголовок, СтруктураШапкиДокумента, ТаблицаПоТоварам;
	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента);	

	Если СтруктураШапкиДокумента.ДокументСоздан_НО_НДС Тогда
		// Проверка и дополнительная обработка не требуются
		Возврат;
	КонецЕсли; 
	
	// Проверим правильность заполнения шапки документа
	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);

    ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента, ТаблицаПоТоварам);
	
	ПроверитьЗаполнениеТабличнойЧастиТовары(ТаблицаПоТоварам, СтруктураШапкиДокумента, Отказ, Заголовок);
	
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок);
	КонецЕсли;

КонецПроцедуры // ОбработкаПроведения()

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);

КонецПроцедуры

мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");

мСтруктураПараметровДляПолученияДоговора = Новый Структура();

