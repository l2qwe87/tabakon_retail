﻿Перем мУдалятьДвижения;

// Текущие курс и кратность валюты документа для расчетов
Перем КурсДокумента Экспорт;
Перем КратностьДокумента Экспорт;

Перем мВалютаРегламентированногоУчета Экспорт;

// Хранят группировочные признаки вида операции
Перем ЕстьРасчетыСКонтрагентами Экспорт;
Перем ЕстьРасчетыПоКредитам Экспорт;

Перем ТаблицаПлатежейУпр;

//Определение периода движений документа
Перем ДатаДвижений;

Перем РасчетыВозврат;

Перем мСтруктураПараметровДенежныхСредств;

Перем СтарыйРасчетныйДокумент;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

//Заполняет сумму документа и расшифровку платежа по расчетному документу
 //
Процедура ЗаполнитьПоРасчетномуДокументуУпр() Экспорт
	
	Организация=РасчетныйДокумент.Организация;
	СчетОрганизации=РасчетныйДокумент.СчетОрганизации;
	
	Контрагент=РасчетныйДокумент.Контрагент;
	СчетКонтрагента=РасчетныйДокумент.СчетКонтрагента;
	
	ВалютаДокумента=РасчетныйДокумент.ВалютаДокумента;
	СтруктураКурсаДокумента   = МодульВалютногоУчета.ПолучитьКурсВалюты(ВалютаДокумента,Дата);
	КурсДокумента      = СтруктураКурсаДокумента.Курс;
	КратностьДокумента = СтруктураКурсаДокумента.Кратность;
	
	ВидОперацииДокумент=РасчетныйДокумент.ВидОперации;
	
	Если ВидОперацииДокумент=Перечисления.ВидыОперацийППИсходящее.ВозвратДенежныхСредствПокупателю Тогда
		ВидОперации=Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ВозвратДенежныхСредствПокупателю
	ИначеЕсли ВидОперацииДокумент=Перечисления.ВидыОперацийППИсходящее.ОплатаПоставщику Тогда
		ВидОперации=Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ОплатаПоставщику
	ИначеЕсли ВидОперацииДокумент=Перечисления.ВидыОперацийППИсходящее.ПеречислениеНалога Тогда
		ВидОперации=Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ПеречислениеНалога
	ИначеЕсли ВидОперацииДокумент=Перечисления.ВидыОперацийППИсходящее.ПрочееСписаниеБезналичныхДенежныхСредств Тогда
		ВидОперации=Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ПрочееСписаниеБезналичныхДенежныхСредств
	ИначеЕсли ВидОперацииДокумент=Перечисления.ВидыОперацийППИсходящее.РасчетыПоКредитамИЗаймамСКонтрагентами Тогда
		ВидОперации=Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.РасчетыПоКредитамИЗаймам
	ИначеЕсли ВидОперацииДокумент=Перечисления.ВидыОперацийППИсходящее.ПрочиеРасчетыСКонтрагентами Тогда
		ВидОперации=Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ПрочиеРасчетыСКонтрагентами;
	ИначеЕсли ВидОперацииДокумент=Перечисления.ВидыОперацийППИсходящее.ПереводНаДругойСчет Тогда
		ВидОперации=Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ПереводНаДругойСчет;
	ИначеЕсли ВидОперацииДокумент = Перечисления.ВидыОперацийППИсходящее.ПеречислениеДенежныхСредствПодотчетнику Тогда
		ВидОперации = Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ПеречислениеДенежныхСредствПодотчетнику;
	Иначе
		ВидОперации=ВидОперацииДокумент;
	КонецЕсли;
		
	ЕстьРасчетыСКонтрагентами=УправлениеДенежнымиСредствами.ЕстьРасчетыСКонтрагентами(ВидОперации);
	ЕстьРасчетыПоКредитам=УправлениеДенежнымиСредствами.ЕстьРасчетыПоКредитам(ВидОперации);
		
	ОтраженоВОперУчете=РасчетныйДокумент.ОтраженоВОперУчете;
	ОтражатьВБухгалтерскомУчете=РасчетныйДокумент.ОтражатьВБухгалтерскомУчете;
	
	Если ЕстьРасчетыСКонтрагентами ИЛИ ЕстьРасчетыПоКредитам Тогда
		
	    //По расшифровке платежа 
		
			ТекстЗапроса="ВЫБРАТЬ
		             |	ДенежныеСредстваКСписаниюОстатки.ДокументСписания,
		             |	ДенежныеСредстваКСписаниюОстатки.СуммаОстаток,
					 |	ДенежныеСредстваКСписаниюОстатки.СтатьяДвиженияДенежныхСредств,
		             |	РасчетныйДокумент.ДоговорКонтрагента,
		             |	РасчетныйДокумент.Сделка,
		             |	РасчетныйДокумент.Ссылка.СуммаДокумента КАК СуммаДокумента,
		             |	РасчетныйДокумент.СуммаПлатежа,
					 |	РасчетныйДокумент.КурсВзаиморасчетов,
		             |	РасчетныйДокумент.КратностьВзаиморасчетов,
		             |	РасчетныйДокумент.СуммаВзаиморасчетов,
		             |	РасчетныйДокумент.СтавкаНДС,
		             |	РасчетныйДокумент.СуммаНДС,
					 |	РасчетныйДокумент.Проект 				 
		             |ИЗ
		             |	РегистрНакопления.ДенежныеСредстваКСписанию.Остатки(, ДокументСписания=&РасчетныйДокумент) КАК ДенежныеСредстваКСписаниюОстатки
		             |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ."+РасчетныйДокумент.Метаданные().Имя+".РасшифровкаПлатежа КАК РасчетныйДокумент
		             |		ПО ДенежныеСредстваКСписаниюОстатки.ДокументСписания = РасчетныйДокумент.Ссылка";
					 
		Запрос=Новый Запрос;
		Запрос.Текст=ТекстЗапроса;
		Запрос.УстановитьПараметр("РасчетныйДокумент",РасчетныйДокумент);
		
		Результат=Запрос.Выполнить().Выбрать();
		
		Пока Результат.Следующий() Цикл
			
			СтрокаПлатеж=РасшифровкаПлатежа.Добавить();
			
			СтрокаПлатеж.ДоговорКонтрагента=Результат.ДоговорКонтрагента;
			СтрокаПлатеж.Сделка=Результат.Сделка;
			СтрокаПлатеж.КурсВзаиморасчетов=Результат.КурсВзаиморасчетов;
			СтрокаПлатеж.КратностьВзаиморасчетов=Результат.КратностьВзаиморасчетов;
			СтрокаПлатеж.СтавкаНДС=Результат.СтавкаНДС;
			СтрокаПлатеж.СтатьяДвиженияДенежныхСредств=Результат.СтатьяДвиженияДенежныхСредств;
			СтрокаПлатеж.Проект=Результат.Проект;
			
			КоэффициентПересчета=?(Результат.СуммаДокумента=0,0,Результат.СуммаОстаток/Результат.СуммаДокумента);
			
			СтрокаПлатеж.СуммаПлатежа=Результат.СуммаПлатежа*КоэффициентПересчета;
			СтрокаПлатеж.СуммаВзаиморасчетов=Результат.СуммаВзаиморасчетов*КоэффициентПересчета;
			СтрокаПлатеж.СуммаНДС=Результат.СуммаНДС*КоэффициентПересчета;
			
		КонецЦикла;
		
		СуммаДокумента=РасшифровкаПлатежа.Итог("СуммаПлатежа");

	Иначе
		
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	ЕСТЬNULL(ДенежныеСредстваКСписаниюОстатки.СуммаОстаток, 0) КАК СуммаОстаток
		|ИЗ
		|	РегистрНакопления.ДенежныеСредстваКСписанию.Остатки(, ДокументСписания=&РасчетныйДокумент) КАК ДенежныеСредстваКСписаниюОстатки";
					 
		Запрос = Новый Запрос;
		Запрос.Текст = ТекстЗапроса;
		Запрос.УстановитьПараметр("РасчетныйДокумент", РасчетныйДокумент);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Выборка.Следующий();
		
		СуммаДокумента = Выборка.СуммаОстаток;
		
		СтрокаПлатеж   = РасшифровкаПлатежа.Добавить();
		СтрокаПлатеж.СуммаПлатежа = СуммаДокумента;
		
		СтатьяДвиженияДенежныхСредств = РасчетныйДокумент.СтатьяДвиженияДенежныхСредств;
		
		Если ВидОперации = Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ПеречислениеДенежныхСредствПодотчетнику Тогда
		
			ФизЛицо                       = РасчетныйДокумент.ФизЛицо;
			ВалютаВзаиморасчетовРаботника = РасчетныйДокумент.ВалютаВзаиморасчетовРаботника;
			РасчетныйДокументРаботника    = РасчетныйДокумент.РасчетныйДокументРаботника;
			ДатаПогашенияАванса           = РасчетныйДокумент.ДатаПогашенияАванса;
			
			СтруктураКурсаВзаиморасчетов         = МодульВалютногоУчета.ПолучитьКурсВалюты(ВалютаВзаиморасчетовРаботника, Дата);
			СтрокаПлатеж.КурсВзаиморасчетов      = СтруктураКурсаВзаиморасчетов.Курс;
			СтрокаПлатеж.КратностьВзаиморасчетов = СтруктураКурсаВзаиморасчетов.Кратность;
			СтрокаПлатеж.СуммаВзаиморасчетов     = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(СтрокаПлатеж.СуммаПлатежа, 
				ВалютаДокумента, ВалютаВзаиморасчетовРаботника,
				КурсДокумента, СтрокаПлатеж.КурсВзаиморасчетов,
				КратностьДокумента, СтрокаПлатеж.КратностьВзаиморасчетов);
			
		КонецЕсли;
		
	КонецЕсли;	
		
КонецПроцедуры // ЗаполнитьПоРасчетномуДокументуУпр()

// Проверяет установленные курсы валют документа перед пересчетом сумм
// Нулевые курсы устанавливаются в 1
//
Процедура ПроверкаКурсовВалют(СтрокаПлатеж)

	КурсДокумента=?(КурсДокумента=0,1, КурсДокумента);
	КратностьДокумента=?(КратностьДокумента=0,1, КратностьДокумента);
	СтрокаПлатеж.КурсВзаиморасчетов=?(СтрокаПлатеж.КурсВзаиморасчетов=0,1,СтрокаПлатеж.КурсВзаиморасчетов);
	СтрокаПлатеж.КратностьВзаиморасчетов=?(СтрокаПлатеж.КратностьВзаиморасчетов=0,1,СтрокаПлатеж.КратностьВзаиморасчетов);

КонецПроцедуры // ПроверкаКурсовВалют()

// Процедура выполняет заполнение суммы документа и суммы взаиморасчетов по регистру расчетов с подотчетными лицами
//
Процедура ЗаполнитьПоВзаиморасчетамСПодотчетнымЛицомУпр(СтрокаПлатеж) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",          Организация);
	Запрос.УстановитьПараметр("ФизЛицо",              ФизЛицо);
	Запрос.УстановитьПараметр("РасчетныйДокумент",    РасчетныйДокументРаботника);
	Запрос.УстановитьПараметр("ВалютаВзаиморасчетов", ВалютаВзаиморасчетовРаботника);

	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВзаиморасчетыСПодотчетнымиЛицамиОстатки.СуммаВзаиморасчетовОстаток КАК СуммаДолга
	|ИЗ
	|	РегистрНакопления.ВзаиморасчетыСПодотчетнымиЛицами.Остатки(
	|			,
	|			Организация = &Организация
	|				И ФизЛицо = &ФизЛицо
	|				И РасчетныйДокумент = &РасчетныйДокумент
	|				И Валюта = &ВалютаВзаиморасчетов) КАК ВзаиморасчетыСПодотчетнымиЛицамиОстатки
	|ГДЕ
	|	ВзаиморасчетыСПодотчетнымиЛицамиОстатки.СуммаВзаиморасчетовОстаток < 0";

	РезультатЗапроса = Запрос.Выполнить();

	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Следующий() Тогда
		
		СтрокаПлатеж.СуммаВзаиморасчетов = - Выборка.СуммаДолга;
		
		СуммаДокумента = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(
			СтрокаПлатеж.СуммаВзаиморасчетов, 
		    ВалютаВзаиморасчетовРаботника, ВалютаДокумента,
		    СтрокаПлатеж.КурсВзаиморасчетов, КурсДокумента,
		    СтрокаПлатеж.КратностьВзаиморасчетов, КратностьДокумента);
		СтрокаПлатеж.СуммаПлатежа = СуммаДокумента;							
									
	КонецЕсли;

КонецПроцедуры // ЗаполнитьПоВзаиморасчетамСПодотчетнымЛицомУпр()

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда

// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходмое количество копий.
//
//  Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  НазваниеМакета - строка, название макета.
//
Процедура Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт

	Если ЭтоНовый() Тогда
		Предупреждение("Документ можно распечатать только после его записи");
		Возврат;
	ИначеЕсли Не УправлениеДопПравамиПользователей.РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
		Предупреждение("Недостаточно полномочий для печати непроведенного документа!");
		Возврат;
	КонецЕсли;

	Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	Если ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда

		ТабДокумент = УниверсальныеМеханизмы.НапечататьВнешнююФорму(Ссылка, ИмяМакета);
		
		Если ТабДокумент = Неопределено Тогда
			Возврат;
		КонецЕсли; 
		
	КонецЕсли;

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект), Ссылка);

КонецПроцедуры // Печать

#КонецЕсли

// Возвращает доступные варианты печати документа
//
// Вовращаемое значение:
//  Струткура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура;

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

// Формирует структуру полей, обязательных для заполнения при отражении фактического
// движения средств по банку.
//
// Возвращаемое значение:
//   СтруктураОбязательныхПолей   – структура для проверки
//
Функция СтруктураОбязательныхПолейОплата()

	СтруктураПолей=Новый Структура;
	СтруктураПолей.Вставить("СчетОрганизации","Не указан банковский счет организации!");
	СтруктураПолей.Вставить("СуммаДокумента");
	
	Если ВидОперации=Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ПереводНаДругойСчет Тогда
		СтруктураПолей.Вставить("СчетКонтрагента","Не указан банковский счет, на который производится перевод!");
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ПеречислениеДенежныхСредствПодотчетнику Тогда
		СтруктураПолей.Вставить("ФизЛицо","Не указано подотчетное лицо");
		СтруктураПолей.Вставить("ВалютаВзаиморасчетовРаботника","Не указана валюта взаиморасчетов с подотчетным лицом");
	КонецЕсли;

	Возврат СтруктураПолей;

КонецФункции // СтруктураОбязательныхПолейОплата()

// Формирует структуру полей, обязательных для заполнения при отражении операции во 
// взаиморасчетах
// Возвращаемое значение:
//   СтруктурахПолей   – структура для проверки
//
Функция СтруктураОбязательныхПолейРасчеты()

	СтруктураПолей = Новый Структура("Организация, Контрагент, СуммаДокумента");
	СтруктураПолей.Вставить("СчетОрганизации","Не указан банковский счет организации!");
	
	СтруктураПолей.Вставить("Контрагент");
	
	Возврат СтруктураПолей;

КонецФункции // СтруктураОбязательныхПолейОплата()

// Проверяет значение, необходимое при проведении
Процедура ПроверитьЗначение(Значение, Отказ, Заголовок, ИмяРеквизита)
	
	Если НЕ ЗначениеЗаполнено(Значение) Тогда 
		
		ОбщегоНазначения.СообщитьОбОшибке("Не заполнено значение реквизита """+ИмяРеквизита+"""",Отказ, Заголовок);
		
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗначение()

// Проверяет заполнение табличной части документа
//
Процедура ПроверитьЗаполнениеТЧ(Отказ, Заголовок)
	
	Для Каждого Платеж Из РасшифровкаПлатежа Цикл
		
		ПроверитьЗначение(Платеж.ДоговорКонтрагента,Отказ, Заголовок,"Договор");
		ПроверитьЗначение(Платеж.СуммаВзаиморасчетов,Отказ, Заголовок,"Сумма взаиморасчетов");
		
		Если Не Отказ Тогда
			
			// Сделка должна быть заполнена, если учет взаиморасчетов ведется по заказам.
			Если Платеж.ДоговорКонтрагента.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоЗаказам Тогда
				
				ТекстСделка=?(УправлениеДенежнымиСредствами.ОпределитьПараметрыВыбораСделки(ВидОперации).ТипЗаказа="ЗаказПокупателя","Заказ покупателя","Заказ поставщику");
				ПроверитьЗначение(Платеж.Сделка,Отказ, Заголовок,ТекстСделка);
				
				Если Отказ Тогда
				
					Сообщить("По договору "+Строка(Платеж.ДоговорКонтрагента)+" установлен способ ведения взаиморасчетов ""по заказам""! 
					|Заполните поле """+ТекстСделка+"""!");
					
				КонецЕсли;
				
			ИначеЕсли Платеж.ДоговорКонтрагента.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоСчетам Тогда
				
				ТекстСделка=?(УправлениеДенежнымиСредствами.ОпределитьПараметрыВыбораСделки(ВидОперации).ТипЗаказа="ЗаказПокупателя","Счет покупателя","Счет поставщику");
				ПроверитьЗначение(Платеж.Сделка,Отказ, Заголовок,ТекстСделка);

				Если Отказ Тогда
					Сообщить("По договору "+Строка(Платеж.ДоговорКонтрагента)+" установлен способ ведения взаиморасчетов ""по счетам""! 
					|Заполните поле """+ТекстСделка+"""!");
				КонецЕсли;
						
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Организация) 
				И Организация <> Платеж.ДоговорКонтрагента.Организация Тогда
				ОбщегоНазначения.СообщитьОбОшибке("Выбран договор контрагента, не соответствующий организации, указанной в документе!", Отказ, Заголовок);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // ПроверитьЗаполнениеТЧ

// Формирует движения по регистрам
//  Отказ                     - флаг отказа в проведении,
//  Заголовок                 - строка, заголовок сообщения об ошибке проведения.
//  Режим 					  - режим проведения документа
//
Процедура ДвиженияПоРегистрам(РежимПроведения, Отказ, Заголовок, СтруктураШапкиДокумента)

	ДвиженияПоРегистрамУпр(РежимПроведения, Отказ, Заголовок, СтруктураШапкиДокумента);

	Если ЕстьРасчетыСКонтрагентами или ЕстьРасчетыПоКредитам Тогда
		ДвиженияПоРегистрамОперативныхВзаиморасчетов(РежимПроведения, Отказ, Заголовок,СтруктураШапкиДокумента);
	КонецЕсли;

	//Движения по расчетам для ДНС
	Если ЕстьРасчетыСКонтрагентами и ОтражатьВБухгалтерскомУчете и Оплачено Тогда
		ДвиженияРегистровПодсистемыНДС(СтруктураШапкиДокумента, Заголовок);
	КонецЕсли;
	
КонецПроцедуры // ДвиженияПоРегистрам()

Процедура ДвиженияРегистровПодсистемыНДС(СтруктураШапкиДокумента, Заголовок)
	
	Если СтруктураШапкиДокумента.ОрганизацияНеЯвляетсяПлательщикомНДС тогда
		// Движения по этому документу делать не нужно
		Возврат;
	КонецЕсли;

	СтруктураПараметров = БухгалтерскийУчетРасчетовСКонтрагентами.ПодготовкаСтруктурыПараметровДляДвиженияДенег(Ссылка, мВалютаРегламентированногоУчета, Заголовок);
	
	Если СтруктураПараметров = Ложь Тогда
	    //Ошибка при подготовке табдлиц. 
		// Указанный вид операции не влияет на расчеты с контрагентами.
		Возврат;
	КонецЕсли; 
	
	БухгалтерскийУчетРасчетовСКонтрагентами.ДвижениеДенег(СтруктураПараметров, ЭтотОбъект);

КонецПроцедуры

Процедура ДвиженияПоРегистрамУпр(РежимПроведения, Отказ, Заголовок, СтруктураШапкиДокумента)
	
	мСтруктураПараметровДенежныхСредств.Вставить("РасчетыВозврат",            РасчетыВозврат);
	мСтруктураПараметровДенежныхСредств.Вставить("ЕстьРасчетыСКонтрагентами", ЕстьРасчетыСКонтрагентами);
	мСтруктураПараметровДенежныхСредств.Вставить("ЕстьРасчетыПоКредитам",     ЕстьРасчетыПоКредитам);
	мСтруктураПараметровДенежныхСредств.Вставить("БанковскийСчетКасса",       СчетОрганизации);
	мСтруктураПараметровДенежныхСредств.Вставить("ДатаДвижений",              ДатаДвижений);
	мСтруктураПараметровДенежныхСредств.Вставить("ПоРасчетномуДокументу",     ЗначениеЗаполнено(РасчетныйДокумент));
	
	Если ВидОперации = Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ПереводНаДругойСчет Тогда
		мСтруктураПараметровДенежныхСредств.Вставить("БанковскийСчетКассаПолучатель", СчетКонтрагента);
		мСтруктураПараметровДенежныхСредств.Вставить("ВидДенежныхСредствПолучатель",  Перечисления.ВидыДенежныхСредств.Безналичные);
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ПеречислениеДенежныхСредствПодотчетнику Тогда
		мСтруктураПараметровДенежныхСредств.Вставить("ФизЛицо",                    ФизЛицо);
		мСтруктураПараметровДенежныхСредств.Вставить("РасчетныйДокументРаботника", РасчетныйДокументРаботника);
	КонецЕсли;
	
	УправлениеДенежнымиСредствами.ПровестиСписаниеДенежныхСредствУпр(
		СтруктураШапкиДокумента, мСтруктураПараметровДенежныхСредств, ТаблицаПлатежейУпр, Движения, Отказ, Заголовок);

КонецПроцедуры

Процедура ДвиженияПоРегистрамОперативныхВзаиморасчетов(РежимПроведения, Отказ, Заголовок, СтруктураШапкиДокумента)
	
	Если НЕ (Оплачено И ОтраженоВОперУчете) Тогда
		Возврат;
	КонецЕсли;
	
	ВидДвижения = ВидДвиженияНакопления.Приход;
	Если СтруктураШапкиДокумента.ВидОперации = Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ВозвратДенежныхСредствПокупателю Тогда
		ВидРасчетовПоОперации = перечисления.ВидыРасчетовСКонтрагентами.ПоРеализации;
	ИначеЕсли СтруктураШапкиДокумента.ВидОперации = Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ОплатаПоставщику Тогда
		ВидРасчетовПоОперации = перечисления.ВидыРасчетовСКонтрагентами.ПоПриобретению;
	Иначе
		ВидРасчетовПоОперации = перечисления.ВидыРасчетовСКонтрагентами.Прочее;
	КонецЕсли;
	СтруктураШапкиДокумента.Вставить("РежимПроведения", РежимПроведения);
	
	УправлениеВзаиморасчетами.ОтражениеОплатыВРегистреОперативныхРасчетовПоДокументам(СтруктураШапкиДокумента, ДатаДвижений, "РасшифровкаПлатежа", ВидРасчетовПоОперации, ВидДвижения, Движения, Отказ, Заголовок);

КонецПроцедуры
 
Процедура ПроверитьЗаполнениеДокументаУпр(Отказ, Режим, Заголовок)
	
	Если ОтраженоВОперУчете И (ЕстьРасчетыСКонтрагентами ИЛИ ЕстьРасчетыПоКредитам) Тогда
		
		ПроверитьЗаполнениеТЧ(Отказ, Заголовок);
		
		Если Не Отказ Тогда
			УправлениеДенежнымиСредствами.КонтрольОстатковПоТЧ(Дата, ТаблицаПлатежейУпр, Отказ, Заголовок,РасчетыВозврат);
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ПодготовитьСтруктуруШапкиДокумента(СтруктураШапкиДокумента, Заголовок)
	
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке      = ОбщегоНазначения.СформироватьДеревоПолейЗапросаПоШапке();
	ОбщегоНазначения.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "ВедениеВзаиморасчетов"                         , "ВедениеВзаиморасчетов");
	ОбщегоНазначения.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "ВалютаВзаиморасчетов"                          , "ВалютаВзаиморасчетов");
	ОбщегоНазначения.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "Организация"                       			, "ДоговорОрганизация");
	ОбщегоНазначения.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "ВидДоговора"                       			, "ВидДоговора");
	ОбщегоНазначения.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "КонтролироватьДенежныеСредстваКомитента"       , "КонтролироватьДенежныеСредстваКомитента");
	ОбщегоНазначения.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "УчетнаяПолитика"     , "ВедениеУчетаПоПроектам"                     , "ВедениеУчетаПоПроектам");
	ОбщегоНазначения.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "Организации"         , "ОтражатьВРегламентированномУчете"              , "ОтражатьВРегламентированномУчете");

	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = УправлениеЗапасами.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, мВалютаРегламентированногоУчета);
	СтруктураШапкиДокумента.Вставить("ОтражатьВУправленческомУчете",Истина); // Банковские документы всегда отражаются в упр. учете
	
	Если ВидОперации = Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ПрочиеРасчетыСКонтрагентами ИЛИ
		ВидОперации = Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.РасчетыПоКредитамИЗаймам Тогда
		
		КурсДокумента      = РасшифровкаПлатежа[0].КурсВзаиморасчетов;
		КратностьДокумента = РасшифровкаПлатежа[0].КратностьВзаиморасчетов;

	Иначе	
		СтруктураКурсаДокумента = МодульВалютногоУчета.ПолучитьКурсВалюты(ВалютаДокумента,Дата);
		
		КурсДокумента      = СтруктураКурсаДокумента.Курс;
		КратностьДокумента = СтруктураКурсаДокумента.Кратность;
	КонецЕсли;
	СтруктураШапкиДокумента.Вставить("КурсДокумента"		, КурсДокумента);
	СтруктураШапкиДокумента.Вставить("КратностьДокумента"	, КратностьДокумента);

	ДатаДвижений=УправлениеДенежнымиСредствами.ПолучитьДатуДвижений(Дата,ДатаОплаты);
	СтруктураШапкиДокумента.Вставить("ДатаОплаты",ДатаДвижений);

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(СтруктураШапкиДокумента);
	
КонецПроцедуры
 
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(Основание)

	Если Основание = Неопределено ИЛИ НЕ Документы.ТипВсеСсылки().СодержитТип(ТипЗнч(Основание)) Тогда
		возврат;
	КонецЕсли;

	Если ТипЗнч(Основание) = Тип("ДокументСсылка.АвансовыйОтчет") Тогда
		
		ЗаполнениеДокументов.ЗаполнитьШапкуДокументаПоОснованию(ЭтотОбъект, Основание);

		СтрокаПлатеж=РасшифровкаПлатежа.Добавить();
		
		ВидОперации = Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ПеречислениеДенежныхСредствПодотчетнику;
		ФизЛицо                       = Основание.ФизЛицо;
		РасчетныйДокументРаботника    = Основание;
		ВалютаВзаиморасчетовРаботника = Основание.ВалютаДокумента;
		
		СтруктураКурсаВзаиморасчетов         = МодульВалютногоУчета.ПолучитьКурсВалюты(ВалютаВзаиморасчетовРаботника, ТекущаяДата());
		СтрокаПлатеж.КурсВзаиморасчетов      = СтруктураКурсаВзаиморасчетов.Курс;
		СтрокаПлатеж.КратностьВзаиморасчетов = СтруктураКурсаВзаиморасчетов.Кратность;

		ПроверкаКурсовВалют(СтрокаПлатеж);
		ЗаполнитьПоВзаиморасчетамСПодотчетнымЛицомУпр(СтрокаПлатеж);
		
	ИначеЕсли Основание.Метаданные().Реквизиты.Найти("Оплачено") <> Неопределено Тогда
		
		Если Основание.Оплачено Тогда
			Сообщить("Платежный ордер не вводится на основании документов, уже исполненных банком.");
			Возврат;
		КонецЕсли;
		
		РасчетныйДокумент = Основание;
		
		ЗаполнитьПоРасчетномуДокументуУпр();
		
	Иначе
		
		УправлениеДенежнымиСредствами.ЗаполнитьРасходПоОснованию(ЭтотОбъект, Основание, УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнойОтветственный"));
		
	КонецЕсли;

	Ответственный = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(ОбщегоНазначения.ПолучитьЗначениеПеременной("глТекущийПользователь"), "ОсновнойОтветственный");
	ДокументОснование  = Основание;
	
КонецПроцедуры // ОбработкаЗаполнения()

Процедура ОбработкаПроведения(Отказ, Режим)
	
	Перем Заголовок, СтруктураШапкиДокумента;
	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	ПодготовитьСтруктуруШапкиДокумента(СтруктураШапкиДокумента, Заголовок);
	
	ЕстьРасчетыСКонтрагентами=УправлениеДенежнымиСредствами.ЕстьРасчетыСКонтрагентами(ВидОперации);
	ЕстьРасчетыПоКредитам=УправлениеДенежнымиСредствами.ЕстьРасчетыПоКредитам(ВидОперации);
	РасчетыВозврат = УправлениеДенежнымиСредствами.НаправленияДвиженияДляДокументаДвиженияДенежныхСредствУпр(ВидОперации);
	
	// Документ должен принадлежать хотя бы к одному виду учета (управленческий, бухгалтерский, налоговый)
	ОбщегоНазначения.ПроверитьПринадлежностьКВидамУчета(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	Если РасшифровкаПлатежа.Итог("СуммаПлатежа") <> СуммаДокумента Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не совпадают сумма документа и ее расшифровка.",Отказ, Заголовок);
	КонецЕсли;
	
	Если ВидОперации <> Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ПеречислениеДенежныхСредствПодотчетнику
		И ЗначениеЗаполнено(РасчетныйДокумент)
		И РасчетныйДокумент.Оплачено 
		Тогда
		ОбщегоНазначения.СообщитьОбОшибке(Строка(РасчетныйДокумент)+" уже оплачен полностью. Проведение отменено.", Отказ, Заголовок);
	КонецЕсли;
	
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолейОплата(), Отказ, Заголовок);
	
	Если ОтраженоВОперУчете И Не ВидОперации=Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ПереводНаДругойСчет Тогда
		ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолейРасчеты(), Отказ, Заголовок);
	КонецЕсли;
	
	ТаблицаПлатежейУпр = УправлениеДенежнымиСредствами.ПолучитьТаблицуПлатежейУпр(ДатаДвижений,ВалютаДокумента,Ссылка, "ПлатежныйОрдерСписаниеДенежныхСредств");
	
	ПроверитьЗаполнениеДокументаУпр(Отказ, Режим, Заголовок);
	
	//Проверим на возможность проведения в БУ и НУ
	Если ОтражатьВБухгалтерскомУчете тогда
		Для каждого СтрокаОплаты из ТаблицаПлатежейУпр Цикл
			УправлениеВзаиморасчетами.ПроверкаВозможностиПроведенияВ_БУ_НУ(СтрокаОплаты.ДоговорКонтрагента, СтруктураШапкиДокумента.ВалютаДокумента,
			СтруктураШапкиДокумента.ОтражатьВБухгалтерскомУчете,СтруктураШапкиДокумента.ОтражатьВНалоговомУчете,
			мВалютаРегламентированногоУчета, Истина, Отказ, Заголовок, "Строка " + СтрокаОплаты.НомерСтроки + " - ",
			СтрокаОплаты.ВалютаВзаиморасчетов, СтрокаОплаты.РасчетыВУсловныхЕдиницах);
		КонецЦикла;
	КонецЕсли;
	
	// Движения по документу
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(Режим, Отказ, Заголовок, СтруктураШапкиДокумента);
	КонецЕсли;
		
	Если НЕ Отказ 
		И ЗначениеЗаполнено(РасчетныйДокумент) 
		И НЕ РасчетныйДокумент.ЧастичнаяОплата 
		Тогда
		
		ИзменяемыйДокумент=РасчетныйДокумент.ПолучитьОбъект();
		Попытка
			ИзменяемыйДокумент.Заблокировать();
		Исключение
			ОбщегоНазначения.СообщитьОбОшибке("Не удалось заблокировать документ " + ИзменяемыйДокумент, Отказ);
			Возврат;
		КонецПопытки;
		ИзменяемыйДокумент.Разблокировать();

		ИзменяемыйДокумент.ЧастичнаяОплата = Истина;
		Попытка
			ИзменяемыйДокумент.Записать(РежимЗаписиДокумента.Запись);
		Исключение
			ОбщегоНазначения.СообщитьОбОшибке("Не удалось записать документ " + ИзменяемыйДокумент +":" + Символы.ПС
				+ ИнформацияОбОшибке(), Отказ);
			Возврат;
		КонецПопытки;
													
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Проверим необходимость снятия флага частичной оплаты у расчетного документа
	
	Если ЗначениеЗаполнено(РасчетныйДокумент) Тогда	
		
		Запрос=Новый Запрос;
		Запрос.Текст="ВЫБРАТЬ
		|	ПлатежныйОрдерСписаниеДенежныхСредств.Ссылка
		|ИЗ
		|	Документ.ПлатежныйОрдерСписаниеДенежныхСредств КАК ПлатежныйОрдерСписаниеДенежныхСредств
		|
		|ГДЕ
		|	ПлатежныйОрдерСписаниеДенежныхСредств.Ссылка <> &Ссылка И
		|  ПлатежныйОрдерСписаниеДенежныхСредств.РасчетныйДокумент=&РасчетныйДокумент И
		|	ПлатежныйОрдерСписаниеДенежныхСредств.Проведен";
		
		Запрос.УстановитьПараметр("Ссылка",Ссылка);
		Запрос.УстановитьПараметр("РасчетныйДокумент",РасчетныйДокумент);
		
		Результат=Запрос.Выполнить();
		Если Результат.Пустой() Тогда
			
			ИзменяемыйДокумент=РасчетныйДокумент.ПолучитьОбъект();
			Попытка
				ИзменяемыйДокумент.Заблокировать();
			Исключение
				ОбщегоНазначения.СообщитьОбОшибке("Не удалось заблокировать документ " + ИзменяемыйДокумент, Отказ);
				Возврат;
			КонецПопытки;
			ИзменяемыйДокумент.Разблокировать();

			ИзменяемыйДокумент.ЧастичнаяОплата = Ложь;
			Попытка
				ИзменяемыйДокумент.Записать(РежимЗаписиДокумента.Запись);
			Исключение
				ОбщегоНазначения.СообщитьОбОшибке("Не удалось записать документ " + ИзменяемыйДокумент +":" + Символы.ПС
					+ ИнформацияОбОшибке(), Отказ);
				Возврат;
			КонецПопытки;
			
		КонецЕсли;
				
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	мУдалятьДвижения = НЕ ЭтоНовый();

	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;

	СтруктураДействий = Новый Структура("УстановитьДоговор");
	УправлениеДенежнымиСредствами.ВыполнитьДействияПередЗаписьюПлатежногоДокумента(ЭтотОбъект, СтруктураДействий, Отказ, РежимЗаписи, РежимПроведения);
	
	Оплачено   = Истина;
	ДатаОплаты = Дата;
	
	Если НЕ Отказ
		И НЕ ЭтоНовый() 
		Тогда
	
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Док.РасчетныйДокумент
		|ИЗ
		|	Документ.ПлатежныйОрдерСписаниеДенежныхСредств КАК Док
		|ГДЕ
		|	Док.Ссылка = &Ссылка");
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Выборка = Запрос.Выполнить().Выбрать();
		Выборка.Следующий();
		
		СтарыйРасчетныйДокумент = Выборка.РасчетныйДокумент;
	
	КонецЕсли;

КонецПроцедуры // ПередЗаписью

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;

	// Проверим необходимость снятия флага частичной оплаты у старого расчетного документа
	
	Если НЕ Отказ 
		И ЗначениеЗаполнено(СтарыйРасчетныйДокумент)
		И СтарыйРасчетныйДокумент <> РасчетныйДокумент 
		Тогда
		
		Запрос=Новый Запрос;
		Запрос.Текст="ВЫБРАТЬ
		|	ПлатежныйОрдерСписаниеДенежныхСредств.Ссылка
		|ИЗ
		|	Документ.ПлатежныйОрдерСписаниеДенежныхСредств КАК ПлатежныйОрдерСписаниеДенежныхСредств
		|
		|ГДЕ
		|	ПлатежныйОрдерСписаниеДенежныхСредств.Ссылка <> &Ссылка И
		|  ПлатежныйОрдерСписаниеДенежныхСредств.РасчетныйДокумент=&РасчетныйДокумент И
		|	ПлатежныйОрдерСписаниеДенежныхСредств.Проведен";
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.УстановитьПараметр("РасчетныйДокумент", СтарыйРасчетныйДокумент);
		
		Результат = Запрос.Выполнить();
		Если Результат.Пустой() Тогда
			
			ИзменяемыйДокумент = СтарыйРасчетныйДокумент.ПолучитьОбъект();
			Попытка
				ИзменяемыйДокумент.Заблокировать();
			Исключение
				ОбщегоНазначения.СообщитьОбОшибке("Не удалось заблокировать документ " + ИзменяемыйДокумент, Отказ);
				Возврат;
			КонецПопытки;
			ИзменяемыйДокумент.Разблокировать();

			ИзменяемыйДокумент.ЧастичнаяОплата = Ложь;
			Попытка
				ИзменяемыйДокумент.Записать(РежимЗаписиДокумента.Запись);
			Исключение
				ОбщегоНазначения.СообщитьОбОшибке("Не удалось записать документ " + ИзменяемыйДокумент +":" + Символы.ПС
					+ ИнформацияОбОшибке(), Отказ);
				Возврат;
			КонецПопытки;
			
		КонецЕсли;
				
	КонецЕсли;
	
КонецПроцедуры

мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");

мСтруктураПараметровДенежныхСредств = Новый Структура;
мСтруктураПараметровДенежныхСредств.Вставить("ВидДенежныхСредств", Перечисления.ВидыДенежныхСредств.Безналичные);
