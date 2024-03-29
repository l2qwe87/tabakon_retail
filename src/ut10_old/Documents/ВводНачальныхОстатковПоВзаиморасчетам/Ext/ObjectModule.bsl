﻿Перем мУдалятьДвижения;
Перем мУчетнаяПолитика;

Перем мВалютаРегламентированногоУчета Экспорт;
Перем мВалютаУправленческогоУчета     Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

// Процедура пересчитывает СуммаУпр от суммы взаиморасчетов
//
Процедура ПересчетСуммыУпр(ТекСтрока) Экспорт
	
	Если ТекСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если ТекСтрока.ВалютаВзаиморасчетов    = Неопределено
	 ИЛИ ТекСтрока.КурсВзаиморасчетов      = 0
	 ИЛИ ТекСтрока.КратностьВзаиморасчетов = 0 Тогда
		Возврат;
	КонецЕсли;
	
	КурсУпр = МодульВалютногоУчета.ПолучитьКурсВалюты(мВалютаУправленческогоУчета, Дата);
	ТекСтрока.СуммаУпр = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(
		ТекСтрока.СуммаВзаиморасчетов,
		ТекСтрока.ВалютаВзаиморасчетов,
		мВалютаУправленческогоУчета,
		ТекСтрока.КурсВзаиморасчетов,
		КурсУпр["Курс"],
		ТекСтрока.КратностьВзаиморасчетов,
		КурсУпр["Кратность"]);
	
КонецПроцедуры // ПересчетСуммыУпр()

// Процедура пересчитывает СуммаРегл от суммы взаиморасчетов
//
Процедура ПересчетСуммыРегл(ТекСтрока) Экспорт
	
	Если ТекСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если ТекСтрока.ВалютаВзаиморасчетов    = Неопределено
	 ИЛИ ТекСтрока.КурсВзаиморасчетов      = 0
	 ИЛИ ТекСтрока.КратностьВзаиморасчетов = 0 Тогда
		Возврат;
	КонецЕсли;
	
	КурсРегл = МодульВалютногоУчета.ПолучитьКурсВалюты(мВалютаРегламентированногоУчета, Дата);
	ТекСтрока.СуммаРегл = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(
		ТекСтрока.СуммаВзаиморасчетов,
		ТекСтрока.ВалютаВзаиморасчетов,
		мВалютаРегламентированногоУчета,
		ТекСтрока.КурсВзаиморасчетов,
		КурсРегл["Курс"],
		ТекСтрока.КратностьВзаиморасчетов,
		КурсРегл["Кратность"]);
	
КонецПроцедуры // ПересчетСуммыРегл()

// Заполнение пустых значений ДокументРасчетовСКонтрагентом в строках указанной табличной части
// создаваемыми документами типа ДокументРасчетовСКонтрагентом.
// Вызывается по кнопке подменю Заполнить табличных частей
//
Процедура ЗаполнитьДокументыРасчетов(ТабЧасть, ИмяТабЧасти = "РасчетыСКонтрагентами") Экспорт

	Заголовок = ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект, "Ввод начальных остатков по взаиморасчетам");
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не заполнена организация!", , Заголовок);
		Возврат;
	КонецЕсли;
	
	ИмяРеквизитаДокумент = ?(ИмяТабЧасти = "РасчетыСКонтрагентами", "Документ", "ДокументОплаты");
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДоговорКонтрагента,
	|	" + ИмяРеквизитаДокумент + " КАК ДокументРасчетов
	|ПОМЕСТИТЬ ТаблицаДокумента
	|ИЗ
	|	&ТабЧастьДокумента КАК ТабЧастьДокумента";
	Запрос.УстановитьПараметр("ТабЧастьДокумента", ЭтотОбъект[ИмяТабЧасти]);
	Результат = Запрос.Выполнить();
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДоговорКонтрагента
	|ИЗ
	|	ТаблицаДокумента
	|ГДЕ
	|	ДоговорКонтрагента.ВестиПоДокументамРасчетовСКонтрагентом
	|	И ДокументРасчетов В (&ПустыеДокументыРасчетов)";
	
	ПустыеДокументыРасчетов = Новый Массив;
	ПустыеДокументыРасчетов.Добавить(Неопределено);
	Для каждого ТипРеквизита Из Метаданные().ТабличныеЧасти[ИмяТабЧасти].Реквизиты[ИмяРеквизитаДокумент].Тип.Типы() Цикл
		ПустыеДокументыРасчетов.Добавить(Новый(ТипРеквизита));
	КонецЦикла;
	Запрос.УстановитьПараметр("ПустыеДокументыРасчетов", ПустыеДокументыРасчетов);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	ТаблицаДоговоров = Результат.Выгрузить();
	ТаблицаДоговоров.Индексы.Добавить("ДоговорКонтрагента");
	
	Для каждого СтрокаТабЧасти Из ТабЧасть Цикл
		
		Если ТаблицаДоговоров.Найти(СтрокаТабЧасти.ДоговорКонтрагента, "ДоговорКонтрагента") = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаТабЧасти[ИмяРеквизитаДокумент]) Тогда
			Продолжить;
		КонецЕсли;
		
		ТекстОшибки = "";
		Если НЕ ЗначениеЗаполнено(СтрокаТабЧасти.Контрагент) Тогда
			ТекстОшибки = ТекстОшибки  + "Не заполнен контрагент. ";
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(СтрокаТабЧасти.ВалютаВзаиморасчетов) Тогда
			ТекстОшибки = ТекстОшибки  + "Не заполнена валюта взаиморасчетов. ";
		КонецЕсли;
		Если СтрокаТабЧасти.СуммаВзаиморасчетов = 0 Тогда
			ТекстОшибки = ТекстОшибки  + "Сумма взаиморасчетов равна нулю. ";
		КонецЕсли;
		
		Если НЕ ПустаяСтрока(ТекстОшибки) Тогда
			ОбщегоНазначения.СообщитьОбОшибке(
			"Строка " + СтрокаТабЧасти.НомерСтроки 
			+ " табличной части " + ?(ИмяТабЧасти = "РасчетыСКонтрагентами", "Расчеты с контрагентами", "Авансы") +": 
			|" + ТекстОшибки + "
			|Документ расчетов по строке " + СтрокаТабЧасти.НомерСтроки + " не будет создан.", , Заголовок);
			Продолжить;
		КонецЕсли;
		
		Попытка
			
			НовыйДокумент = Документы.ДокументРасчетовСКонтрагентом.СоздатьДокумент();
			
			НовыйДокумент.Дата               = Дата;
			НовыйДокумент.Организация        = Организация;
			НовыйДокумент.Контрагент         = СтрокаТабЧасти.Контрагент;
			НовыйДокумент.ДоговорКонтрагента = СтрокаТабЧасти.ДоговорКонтрагента;
			НовыйДокумент.ВалютаДокумента    = СтрокаТабЧасти.ВалютаВзаиморасчетов;
			НовыйДокумент.СуммаДокумента     = СтрокаТабЧасти.СуммаВзаиморасчетов;
			НовыйДокумент.Комментарий        = "Создан автоматически (" + Заголовок + ")";
			
			НовыйДокумент.Записать();
			
			СтрокаТабЧасти[ИмяРеквизитаДокумент] = НовыйДокумент.Ссылка;
			
		Исключение
			
			Если ИмяТабЧасти = "РасчетыСКонтрагентами" Тогда
				ОбщегоНазначения.СообщитьОбОшибке(
				"Не удалось записать документ расчетов в строке " + СтрокаТабЧасти.НомерСтроки + " табличной части ""Расчеты с контрагентами"":
				|" + ОписаниеОшибки(), , Заголовок);
			Иначе
				ОбщегоНазначения.СообщитьОбОшибке(
				"Не удалось записать документ оплаты в строке " + СтрокаТабЧасти.НомерСтроки + " табличной части ""Авансы"":
				|" + ОписаниеОшибки(), , Заголовок);
			КонецЕсли;
			
			Продолжить;
			
		КонецПопытки;
	
	КонецЦикла;

КонецПроцедуры

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

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизтов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверяется также правильность заполнения реквизитов ссылочных полей документа.
// Проверка выполняется по объекту и по выборке из результата запроса по шапке.
//
// Параметры: 
//  СтруктураШапкиДокумента - выборка из результата запроса по шапке документа,
//  Отказ                   - флаг отказа в проведении,
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить:
	ОбязательныеРеквизитыШапки = "Организация";
	
	СтруктураОбязательныхПолей = Новый Структура(ОбязательныеРеквизитыШапки);

	// Документ должен принадлежать хотя бы к одному виду учета (управленческий, бухгалтерский, налоговый)
	ОбщегоНазначения.ПроверитьПринадлежностьКВидамУчета(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	// Теперь вызовем общую процедуру проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Процедура проверяет правильность заполнения реквизитов документа
//
Процедура ПроверкаРеквизитовТЧ( СтруктураШапкиДокумента, Отказ, Заголовок)

	РеквизитыТабРасчеты = "Контрагент, ДоговорКонтрагента, ВалютаВзаиморасчетов";
	РеквизитыТабАвансы  = "Контрагент, ДоговорКонтрагента, ВалютаВзаиморасчетов";
	
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "РасчетыСКонтрагентами", Новый Структура(РеквизитыТабРасчеты), Отказ, Заголовок);
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Авансы",                Новый Структура(РеквизитыТабАвансы ), Отказ, Заголовок);
	
	// Проверяем заполнение реквизитов Сделка и Документ (ДокументОплаты)
	
	Запрос = Новый Запрос;
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ВводНачальныхОстатковПоВзаиморасчетамРасчетыСКонтрагентами.НомерСтроки КАК НомерСтроки,
	|	""""""Расчеты с контрагентами"""""" КАК ТабЧасть,
	|	1 КАК Порядок,
	|	""Не заполнен реквизит """"Сделка"""", в договоре установлен способ ведения расчетов """"По заказам"""""" КАК ТекстОшибки
	|ИЗ
	|	Документ.ВводНачальныхОстатковПоВзаиморасчетам.РасчетыСКонтрагентами КАК ВводНачальныхОстатковПоВзаиморасчетамРасчетыСКонтрагентами
	|ГДЕ
	|	ВводНачальныхОстатковПоВзаиморасчетамРасчетыСКонтрагентами.Ссылка = &Ссылка
	|	И ВводНачальныхОстатковПоВзаиморасчетамРасчетыСКонтрагентами.ДоговорКонтрагента.ВедениеВзаиморасчетов = ЗНАЧЕНИЕ(Перечисление.ВедениеВзаиморасчетовПоДоговорам.ПоЗаказам)
	|	И ВводНачальныхОстатковПоВзаиморасчетамРасчетыСКонтрагентами.Сделка В(&ПустыеСделкиРасчетов)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВводНачальныхОстатковПоВзаиморасчетамРасчетыСКонтрагентами.НомерСтроки,
	|	""""""Расчеты с контрагентами"""""",
	|	1,
	|	""Не заполнен реквизит """"Сделка"""", в договоре установлен способ ведения расчетов """"По счетам""""""
	|ИЗ
	|	Документ.ВводНачальныхОстатковПоВзаиморасчетам.РасчетыСКонтрагентами КАК ВводНачальныхОстатковПоВзаиморасчетамРасчетыСКонтрагентами
	|ГДЕ
	|	ВводНачальныхОстатковПоВзаиморасчетамРасчетыСКонтрагентами.Ссылка = &Ссылка
	|	И ВводНачальныхОстатковПоВзаиморасчетамРасчетыСКонтрагентами.ДоговорКонтрагента.ВедениеВзаиморасчетов = ЗНАЧЕНИЕ(Перечисление.ВедениеВзаиморасчетовПоДоговорам.ПоСчетам)
	|	И ВводНачальныхОстатковПоВзаиморасчетамРасчетыСКонтрагентами.Сделка В(&ПустыеСделкиРасчетов)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВводНачальныхОстатковПоВзаиморасчетамРасчетыСКонтрагентами.НомерСтроки,
	|	""""""Расчеты с контрагентами"""""",
	|	2,
	|	""Не заполнен реквизит """"Документ расчетов"""", в договоре установлен флаг ведения расчетов по документам""
	|ИЗ
	|	Документ.ВводНачальныхОстатковПоВзаиморасчетам.РасчетыСКонтрагентами КАК ВводНачальныхОстатковПоВзаиморасчетамРасчетыСКонтрагентами
	|ГДЕ
	|	ВводНачальныхОстатковПоВзаиморасчетамРасчетыСКонтрагентами.Ссылка = &Ссылка
	|	И ВводНачальныхОстатковПоВзаиморасчетамРасчетыСКонтрагентами.ДоговорКонтрагента.ВестиПоДокументамРасчетовСКонтрагентом = ИСТИНА
	|	И ВводНачальныхОстатковПоВзаиморасчетамРасчетыСКонтрагентами.Документ В(&ПустыеДокументыРасчетов)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВводНачальныхОстатковПоВзаиморасчетамАвансы.НомерСтроки,
	|	""""""Авансы"""""",
	|	1,
	|	""Не заполнен реквизит """"Сделка"""", в договоре установлен способ ведения расчетов """"По заказам""""""
	|ИЗ
	|	Документ.ВводНачальныхОстатковПоВзаиморасчетам.Авансы КАК ВводНачальныхОстатковПоВзаиморасчетамАвансы
	|ГДЕ
	|	ВводНачальныхОстатковПоВзаиморасчетамАвансы.Ссылка = &Ссылка
	|	И ВводНачальныхОстатковПоВзаиморасчетамАвансы.ДоговорКонтрагента.ВедениеВзаиморасчетов = ЗНАЧЕНИЕ(Перечисление.ВедениеВзаиморасчетовПоДоговорам.ПоЗаказам)
	|	И ВводНачальныхОстатковПоВзаиморасчетамАвансы.Сделка В(&ПустыеСделкиАвансов)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВводНачальныхОстатковПоВзаиморасчетамАвансы.НомерСтроки,
	|	""""""Авансы"""""",
	|	1,
	|	""Не заполнен реквизит """"Сделка"""", в договоре установлен способ ведения расчетов """"По счетам""""""
	|ИЗ
	|	Документ.ВводНачальныхОстатковПоВзаиморасчетам.Авансы КАК ВводНачальныхОстатковПоВзаиморасчетамАвансы
	|ГДЕ
	|	ВводНачальныхОстатковПоВзаиморасчетамАвансы.Ссылка = &Ссылка
	|	И ВводНачальныхОстатковПоВзаиморасчетамАвансы.ДоговорКонтрагента.ВедениеВзаиморасчетов = ЗНАЧЕНИЕ(Перечисление.ВедениеВзаиморасчетовПоДоговорам.ПоСчетам)
	|	И ВводНачальныхОстатковПоВзаиморасчетамАвансы.Сделка В(&ПустыеСделкиАвансов)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВводНачальныхОстатковПоВзаиморасчетамАвансы.НомерСтроки,
	|	""""""Авансы"""""",
	|	2,
	|	""Не заполнен реквизит """"Документ оплаты"""", в договоре установлен флаг ведения расчетов по документам""
	|ИЗ
	|	Документ.ВводНачальныхОстатковПоВзаиморасчетам.Авансы КАК ВводНачальныхОстатковПоВзаиморасчетамАвансы
	|ГДЕ
	|	ВводНачальныхОстатковПоВзаиморасчетамАвансы.Ссылка = &Ссылка
	|	И ВводНачальныхОстатковПоВзаиморасчетамАвансы.ДоговорКонтрагента.ВестиПоДокументамРасчетовСКонтрагентом = ИСТИНА
	|	И ВводНачальныхОстатковПоВзаиморасчетамАвансы.ДокументОплаты В(&ПустыеДокументыАвансов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТабЧасть УБЫВ,
	|	НомерСтроки,
	|	Порядок";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	ПустыеСделкиРасчетов = Новый Массив;
	ПустыеСделкиРасчетов.Добавить(Неопределено);
	Для каждого ТипРеквизита Из Метаданные().ТабличныеЧасти.РасчетыСКонтрагентами.Реквизиты.Сделка.Тип.Типы() Цикл
		ПустыеСделкиРасчетов.Добавить(Новый(ТипРеквизита));
	КонецЦикла;
	
	ПустыеСделкиАвансов = Новый Массив;
	ПустыеСделкиАвансов.Добавить(Неопределено);
	Для каждого ТипРеквизита Из Метаданные().ТабличныеЧасти.Авансы.Реквизиты.Сделка.Тип.Типы() Цикл
		ПустыеСделкиАвансов.Добавить(Новый(ТипРеквизита));
	КонецЦикла;
	
	ПустыеДокументыРасчетов = Новый Массив;
	ПустыеДокументыРасчетов.Добавить(Неопределено);
	Для каждого ТипРеквизита Из Метаданные().ТабличныеЧасти.РасчетыСКонтрагентами.Реквизиты.Документ.Тип.Типы() Цикл
		ПустыеДокументыРасчетов.Добавить(Новый(ТипРеквизита));
	КонецЦикла;
	
	ПустыеДокументыАвансов = Новый Массив;
	ПустыеДокументыАвансов.Добавить(Неопределено);
	Для каждого ТипРеквизита Из Метаданные().ТабличныеЧасти.Авансы.Реквизиты.ДокументОплаты.Тип.Типы() Цикл
		ПустыеДокументыАвансов.Добавить(Новый(ТипРеквизита));
	КонецЦикла;
	
	Запрос.УстановитьПараметр("ПустыеСделкиРасчетов",    ПустыеСделкиРасчетов);
	Запрос.УстановитьПараметр("ПустыеСделкиАвансов",     ПустыеСделкиАвансов);
	Запрос.УстановитьПараметр("ПустыеДокументыРасчетов", ПустыеДокументыРасчетов);
	Запрос.УстановитьПараметр("ПустыеДокументыАвансов",  ПустыеДокументыАвансов);
	
	Запрос.Текст = ТекстЗапроса;
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
	
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			ТекстОшибки = "Строка №" + Выборка.НомерСтроки + " табличной части " + Выборка.ТабЧасть + ": " + Выборка.ТекстОшибки;
			ОбщегоНазначения.СообщитьОбОшибке(ТекстОшибки, Отказ, Заголовок);
		
		КонецЦикла;
	
	КонецЕсли;
	
КонецПроцедуры // ПроверкаРеквизитовТЧ()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ФОРМИРОВАНИЯ ДВИЖЕНИЙ ДОКУМЕНТА

// По результату запроса по шапке документа формируем движения по регистрам.
//
// Параметры: 
//  РежимПроведения           - режим проведения документа (оперативный или неоперативный),
//  СтруктураШапкиДокумента   - выборка из результата запроса по шапке документа,
//  ТаблицаРасчеты            - таблица значений, содержащая данные для проведения и проверки ТЧ "Расчеты с контрагентами"
//  ТаблицаАвансы             - таблица значений, содержащая данные для проведения и проверки ТЧ "Авансы"
//  Отказ                     - флаг отказа в проведении,
//  Заголовок                 - строка, заголовок сообщения об ошибке проведения.
//
Процедура ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаРасчеты, ТаблицаАвансы, Отказ, Заголовок)
	
	Если СтруктураШапкиДокумента.ОтражатьВУправленческомУчете Тогда
		ДвиженияПоРегистрамУпр(РежимПроведения, СтруктураШапкиДокумента, ТаблицаРасчеты, ТаблицаАвансы, Отказ, Заголовок)
	КонецЕсли;

	ДвиженияПоРегиструОперативныхРасчетов(РежимПроведения, СтруктураШапкиДокумента, ТаблицаРасчеты, ТаблицаАвансы, Отказ, Заголовок);
	ДвиженияПоРегистрамНДС(РежимПроведения, СтруктураШапкиДокумента, ТаблицаРасчеты, ТаблицаАвансы, Отказ, Заголовок)
	
КонецПроцедуры // ДвиженияПоРегистрам()

// Формирование движений по регистрам по управленческому учету.
//
Процедура ДвиженияПоРегистрамУпр(РежимПроведения, СтруктураШапкиДокумента, ТаблицаРасчеты, ТаблицаАвансы, Отказ, Заголовок)

	// Движения по регистру ВзаиморасчетыСКонтрагентами
	
		
	// Таблица расчетов
	ТаблицаДвиженийВзаиморасчеты = Движения.ВзаиморасчетыСКонтрагентами.ВыгрузитьКолонки();
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаРасчеты, ТаблицаДвиженийВзаиморасчеты);
	
	Движения.ВзаиморасчетыСКонтрагентами.мПериод = Дата;
	Движения.ВзаиморасчетыСКонтрагентами.мТаблицаДвижений   = ТаблицаДвиженийВзаиморасчеты;
	Если СтруктураШапкиДокумента.ВидОперации = Перечисления.ВидыОперацийВводНачальныхОстатковПоВзаиморасчетам.РасчетыСПокупателями Тогда
		Движения.ВзаиморасчетыСКонтрагентами.ВыполнитьПриход();
	Иначе
		Движения.ВзаиморасчетыСКонтрагентами.ВыполнитьРасход();
	КонецЕсли;
	
	// Таблица авансов
	ТаблицаДвиженийВзаиморасчеты = Движения.ВзаиморасчетыСКонтрагентами.ВыгрузитьКолонки();
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаАвансы, ТаблицаДвиженийВзаиморасчеты);
	
	Движения.ВзаиморасчетыСКонтрагентами.мПериод = Дата;
	Движения.ВзаиморасчетыСКонтрагентами.мТаблицаДвижений   = ТаблицаДвиженийВзаиморасчеты;
	Если СтруктураШапкиДокумента.ВидОперации = Перечисления.ВидыОперацийВводНачальныхОстатковПоВзаиморасчетам.РасчетыСПокупателями Тогда
		Движения.ВзаиморасчетыСКонтрагентами.ВыполнитьРасход();
	Иначе
		Движения.ВзаиморасчетыСКонтрагентами.ВыполнитьПриход();
	КонецЕсли;
	
	// Движения по регистру РасчетыСКонтрагентами
	// делаются по авансам всегда, по расчетам - если не заполнена сделка или если расчеты "по счетам"
	
	// Таблица расчетов
	ТаблицаДвиженийРасчеты = Движения.РасчетыСКонтрагентами.ВыгрузитьКолонки();
	Для каждого СтрокаРасчеты Из ТаблицаРасчеты Цикл
	
		Если (НЕ ЗначениеЗаполнено(СтрокаРасчеты.Сделка)
			ИЛИ СтрокаРасчеты.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоСчетам)
			И СтрокаРасчеты.ВедениеВзаиморасчетов <> Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоДоговоруВЦелом
			Тогда
			СтрокаДвиженийРасчеты = ТаблицаДвиженийРасчеты.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаДвиженийРасчеты, СтрокаРасчеты);
			СтрокаДвиженийРасчеты.Сделка = СтрокаРасчеты.СделкаРасчеты;
		КонецЕсли;
	
	КонецЦикла;
	ТаблицаДвиженийРасчеты.ЗаполнитьЗначения(Перечисления.РасчетыВозврат.Расчеты, "РасчетыВозврат");
	
	Движения.РасчетыСКонтрагентами.мПериод = Дата;
	Движения.РасчетыСКонтрагентами.мТаблицаДвижений = ТаблицаДвиженийРасчеты;
	Если СтруктураШапкиДокумента.ВидОперации = Перечисления.ВидыОперацийВводНачальныхОстатковПоВзаиморасчетам.РасчетыСПокупателями Тогда
		Движения.РасчетыСКонтрагентами.ВыполнитьПриход();
	Иначе
		Движения.РасчетыСКонтрагентами.ВыполнитьРасход();
	КонецЕсли;
	
	// Таблица авансов
	ТаблицаДвиженийРасчеты = Движения.РасчетыСКонтрагентами.ВыгрузитьКолонки();
	Для каждого СтрокаАвансы Из ТаблицаАвансы Цикл
	
		СтрокаДвиженийРасчеты = ТаблицаДвиженийРасчеты.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаДвиженийРасчеты, СтрокаАвансы);
		СтрокаДвиженийРасчеты.Сделка = СтрокаАвансы.СделкаРасчеты;
	
	КонецЦикла;
	ТаблицаДвиженийРасчеты.ЗаполнитьЗначения(Перечисления.РасчетыВозврат.Расчеты, "РасчетыВозврат");
	
	Движения.РасчетыСКонтрагентами.мПериод = Дата;
	Движения.РасчетыСКонтрагентами.мТаблицаДвижений = ТаблицаДвиженийРасчеты;
	Если СтруктураШапкиДокумента.ВидОперации = Перечисления.ВидыОперацийВводНачальныхОстатковПоВзаиморасчетам.РасчетыСПокупателями Тогда
		Движения.РасчетыСКонтрагентами.ВыполнитьРасход();
	Иначе
		Движения.РасчетыСКонтрагентами.ВыполнитьПриход();
	КонецЕсли;
	
КонецПроцедуры // ДвиженияПоРегистрамУпр()

// Формирование движений по регистру взаиморасчетов с контрагентами по документам
//
Процедура ДвиженияПоРегиструОперативныхРасчетов(РежимПроведения, СтруктураШапкиДокумента, ТаблицаРасчеты, ТаблицаАвансы, Отказ, Заголовок)
	
	Если СтруктураШапкиДокумента.ВидОперации = Перечисления.ВидыОперацийВводНачальныхОстатковПоВзаиморасчетам.РасчетыСПокупателями Тогда
		ВидРасчетовСКонтрагентом = Перечисления.ВидыРасчетовСКонтрагентами.ПоРеализации;
	ИначеЕсли СтруктураШапкиДокумента.ВидОперации = Перечисления.ВидыОперацийВводНачальныхОстатковПоВзаиморасчетам.РасчетыСПоставщиками Тогда
		ВидРасчетовСКонтрагентом = Перечисления.ВидыРасчетовСКонтрагентами.ПоПриобретению;
	Иначе //.РасчетыПоПрочимОперациям - не обслуживаются
		Возврат;
	КонецЕсли;
	УпрУчет = СтруктураШапкиДокумента.ОтражатьВУправленческомУчете;
	
	// Таблица расчетов
	ТаблицаДвижений = Движения.ВзаиморасчетыСКонтрагентамиПоДокументамРасчетов.ВыгрузитьКолонки();
	Для Каждого СтрокаРасчетов Из ТаблицаРасчеты Цикл
		Если СтрокаРасчетов.ВестиПоДокументамРасчетовСКонтрагентом Тогда
			Движение = ТаблицаДвижений.Добавить();
			ЗаполнитьЗначенияСвойств(Движение, СтрокаРасчетов);
			Если НЕ СтруктураШапкиДокумента.ОтражатьВРегламентированномУчете 
				ИЛИ СтрокаРасчетов.ВалютаВзаиморасчетов = мВалютаРегламентированногоУчета Тогда
				Движение.СуммаРегл = 0;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	ТаблицаДвижений.ЗаполнитьЗначения(ВидРасчетовСКонтрагентом, "ВидРасчетовСКонтрагентом");
	ТаблицаДвижений.ЗаполнитьЗначения(УпрУчет, "УпрУчет");
	
	Движения.ВзаиморасчетыСКонтрагентамиПоДокументамРасчетов.мПериод = Дата;
	Движения.ВзаиморасчетыСКонтрагентамиПоДокументамРасчетов.мТаблицаДвижений = ТаблицаДвижений;
	Если СтруктураШапкиДокумента.ВидОперации = Перечисления.ВидыОперацийВводНачальныхОстатковПоВзаиморасчетам.РасчетыСПокупателями Тогда
		Движения.ВзаиморасчетыСКонтрагентамиПоДокументамРасчетов.ВыполнитьПриход();
	Иначе
		Движения.ВзаиморасчетыСКонтрагентамиПоДокументамРасчетов.ВыполнитьРасход();
	КонецЕсли;
	
	// Таблица авансов
	ТаблицаДвижений = Движения.ВзаиморасчетыСКонтрагентамиПоДокументамРасчетов.ВыгрузитьКолонки();
	Для Каждого СтрокаАванса Из ТаблицаАвансы Цикл
		Если СтрокаАванса.ВестиПоДокументамРасчетовСКонтрагентом Тогда
			Движение = ТаблицаДвижений.Добавить();
			ЗаполнитьЗначенияСвойств(Движение, СтрокаАванса);
			Если НЕ СтруктураШапкиДокумента.ОтражатьВРегламентированномУчете 
				ИЛИ СтрокаАванса.ВалютаВзаиморасчетов = мВалютаРегламентированногоУчета Тогда
				Движение.СуммаРегл = 0;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	ТаблицаДвижений.ЗаполнитьЗначения(ВидРасчетовСКонтрагентом, "ВидРасчетовСКонтрагентом");
	ТаблицаДвижений.ЗаполнитьЗначения(УпрУчет, "УпрУчет");
	
	Движения.ВзаиморасчетыСКонтрагентамиПоДокументамРасчетов.мПериод = Дата;
	Движения.ВзаиморасчетыСКонтрагентамиПоДокументамРасчетов.мТаблицаДвижений = ТаблицаДвижений;
	Если СтруктураШапкиДокумента.ВидОперации = Перечисления.ВидыОперацийВводНачальныхОстатковПоВзаиморасчетам.РасчетыСПокупателями Тогда
		Движения.ВзаиморасчетыСКонтрагентамиПоДокументамРасчетов.ВыполнитьРасход();
	Иначе
		Движения.ВзаиморасчетыСКонтрагентамиПоДокументамРасчетов.ВыполнитьПриход();
	КонецЕсли;
	
КонецПроцедуры // ДвиженияПоРегиструОперативныхРасчетов

Процедура ДвиженияПоРегистрамНДС(РежимПроведения, СтруктураШапкиДокумента, ТаблицаРасчеты, ТаблицаАвансы, Отказ, Заголовок)
	
	Если Не ОтразитьРасчетыСКонтрагентамиДляЦелейНДС Тогда
		Возврат;
	КонецЕсли;
	
	СоответствиеКолонок = Новый Соответствие;
	Если СтруктураШапкиДокумента.ВидОперации = Перечисления.ВидыОперацийВводНачальныхОстатковПоВзаиморасчетам.РасчетыСПокупателями Тогда
		НаборДвижений = Движения.НДСРасчетыСПокупателями;
		СоответствиеКолонок.Вставить("Контрагент", "Покупатель");
		
	ИначеЕсли СтруктураШапкиДокумента.ВидОперации = Перечисления.ВидыОперацийВводНачальныхОстатковПоВзаиморасчетам.РасчетыСПоставщиками Тогда
		НаборДвижений = Движения.НДСРасчетыСПоставщиками;
		СоответствиеКолонок.Вставить("Контрагент", "Поставщик");
	Иначе //.РасчетыПоПрочимОперациям - не обслуживаются
		Возврат;
	КонецЕсли;
	ТаблицаДвижений = НаборДвижений.ВыгрузитьКолонки();
	
	СоответствиеКолонок.Вставить("СуммаРегл", "Сумма");
	СоответствиеКолонок.Вставить("ВалютаВзаиморасчетов", "ВалютаРасчетов");
	СоответствиеКолонок.Вставить("СуммаВзаиморасчетов", "ВалютнаяСумма");
	
	// Авансы
	ТаблицаАвансы.Колонки.Добавить("ВидДвижения");
	ТаблицаАвансы.ЗаполнитьЗначения(ВидДвиженияНакопления.Расход, "ВидДвижения");
	
	УчетНДС.ПереименованиеКолонок(ТаблицаАвансы, СоответствиеКолонок);
	
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаАвансы, ТаблицаДвижений);
	
	УчетНДС.ПереименованиеКолонок(ТаблицаАвансы, СоответствиеКолонок, Истина);
	ТаблицаАвансы.Колонки.Удалить("ВидДвижения");
	
	// Расчеты
	ТаблицаРасчеты.Колонки.Добавить("ВидДвижения");
	ТаблицаРасчеты.ЗаполнитьЗначения(ВидДвиженияНакопления.Приход, "ВидДвижения");
	УчетНДС.ПереименованиеКолонок(ТаблицаРасчеты, СоответствиеКолонок);
	
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаРасчеты, ТаблицаДвижений);
	
	УчетНДС.ПереименованиеКолонок(ТаблицаРасчеты, СоответствиеКолонок, Истина);
	ТаблицаРасчеты.Колонки.Удалить("ВидДвижения");
	
	ТаблицаДвижений.ЗаполнитьЗначения(Истина, "Активность");
	ТаблицаДвижений.ЗаполнитьЗначения(СтруктураШапкиДокумента.Дата, "Период");
	ТаблицаДвижений.ЗаполнитьЗначения(СтруктураШапкиДокумента.Дата, "ДатаСобытия");
	
	Если ТаблицаДвижений.Количество() <> 0 Тогда
		НаборДвижений.мТаблицаДвижений = ТаблицаДвижений;
		НаборДвижений.ВыполнитьДвижения();
	КонецЕсли;
		
КонецПроцедуры // ДвиженияПоРегистрамНДС

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаПроведения"
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке = ОбщегоНазначения.СформироватьДеревоПолейЗапросаПоШапке();
	ОбщегоНазначения.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "Организации", "ОтражатьВРегламентированномУчете", "ОтражатьВРегламентированномУчете");

	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = УправлениеЗапасами.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, мВалютаРегламентированногоУчета);

	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(СтруктураШапкиДокумента);

	// Проверим правильность заполнения шапки документа
	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);

	ПроверкаРеквизитовТЧ(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	мУчетнаяПолитика = ОбщегоНазначения.ПолучитьПараметрыУчетнойПолитики(КонецМесяца(Дата), Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Получим необходимые данные для проведения и проверки заполнения данные по табличных частей.
	СтруктураПолей = Новый Структура();
	СтруктураПолей.Вставить( "Контрагент",                     "Контрагент");
	СтруктураПолей.Вставить( "ДоговорКонтрагента",             "ДоговорКонтрагента");
	СтруктураПолей.Вставить( "Организация",             	   "ДоговорКонтрагента.Организация");
	СтруктураПолей.Вставить( "СделкаРасчеты",                  "Сделка");
	СтруктураПолей.Вставить( "Документ",                       "Документ");
	СтруктураПолей.Вставить( "ДокументРасчетовСКонтрагентом",  "Документ");
	СтруктураПолей.Вставить( "ВалютаВзаиморасчетов",           "ВалютаВзаиморасчетов");
	СтруктураПолей.Вставить( "СуммаВзаиморасчетов",            "СуммаВзаиморасчетов");
	СтруктураПолей.Вставить( "СуммаРегл",                      "СуммаРегл");
	СтруктураПолей.Вставить( "СуммаРег",                       "СуммаРегл");
	СтруктураПолей.Вставить( "СуммаУпр",                       "СуммаУпр");
	СтруктураПолей.Вставить( "РасчетыВУсловныхЕдиницах",       "ДоговорКонтрагента.РасчетыВУсловныхЕдиницах");
	СтруктураПолей.Вставить( "ВедениеВзаиморасчетов",          "ДоговорКонтрагента.ВедениеВзаиморасчетов");
	СтруктураПолей.Вставить( "ВестиПоДокументамРасчетовСКонтрагентом", "ДоговорКонтрагента.ВестиПоДокументамРасчетовСКонтрагентом");
	
	СтруктураСложныхПолей = Новый Структура();
	СтруктураСложныхПолей.Вставить( "Сделка", 
		"ВЫБОР 
		|	КОГДА Док.ДоговорКонтрагента.ВедениеВзаиморасчетов = ЗНАЧЕНИЕ(Перечисление.ВедениеВзаиморасчетовПоДоговорам.ПоДоговоруВЦелом)
		|		ТОГДА НЕОПРЕДЕЛЕНО
		|	ИНАЧЕ Док.Сделка
		|КОНЕЦ");
	
	РезультатЗапроса = ОбщегоНазначения.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "РасчетыСКонтрагентами", СтруктураПолей, СтруктураСложныхПолей);
	ТаблицаРасчеты   = РезультатЗапроса.Выгрузить();
	
	Для каждого СтрокаРасчеты Из ТаблицаРасчеты Цикл
	
		Если НЕ ЗначениеЗаполнено(СтрокаРасчеты.Сделка) Тогда
			СтрокаРасчеты.Сделка = Неопределено;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(СтрокаРасчеты.СделкаРасчеты) Тогда
			СтрокаРасчеты.СделкаРасчеты = Неопределено;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(СтрокаРасчеты.ДокументРасчетовСКонтрагентом) Тогда
			СтрокаРасчеты.ДокументРасчетовСКонтрагентом = Неопределено;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(СтрокаРасчеты.Документ) Тогда
			СтрокаРасчеты.Документ = Неопределено;
		КонецЕсли;
	
	КонецЦикла;
	
	СтруктураПолей.Вставить( "ДатаОплаты",                     "ДокументОплаты.Дата");
	СтруктураПолей.Вставить( "Документ",                       "ДокументОплаты");
	СтруктураПолей.Вставить( "ДокументРасчетовСКонтрагентом",  "ДокументОплаты");
	
	РезультатЗапроса = ОбщегоНазначения.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "Авансы", СтруктураПолей, СтруктураСложныхПолей);
	ТаблицаАвансы    = РезультатЗапроса.Выгрузить();
	
	Для каждого СтрокаАвансы Из ТаблицаАвансы Цикл
	
		Если НЕ ЗначениеЗаполнено(СтрокаАвансы.Сделка) Тогда
			СтрокаАвансы.Сделка = Неопределено;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(СтрокаАвансы.СделкаРасчеты) Тогда
			СтрокаАвансы.СделкаРасчеты = Неопределено;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(СтрокаАвансы.ДокументРасчетовСКонтрагентом) Тогда
			СтрокаАвансы.ДокументРасчетовСКонтрагентом = Неопределено;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(СтрокаАвансы.Документ) Тогда
			СтрокаАвансы.Документ = Неопределено;
		КонецЕсли;
	
	КонецЦикла;
	
	// Движения по документу
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаРасчеты, ТаблицаАвансы, Отказ, Заголовок);
	КонецЕсли;

КонецПроцедуры // ОбработкаПроведения()

// Процедура - обработчик события "ПередЗаписью"
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	мУдалятьДвижения = НЕ ЭтоНовый();

КонецПроцедуры

// Процедура - обработчик события "ОбработкаУдаленияПроведения"
//
Процедура ОбработкаУдаленияПроведения(Отказ)

	ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);	

КонецПроцедуры // ОбработкаУдаленияПроведения

// Процедура - обработчик события "ОбработкаЗаполнения"
//
Процедура ОбработкаЗаполнения(Основание)
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ВводНачальныхОстатковНДС") Тогда
		
		// Заполнение шапки
		Организация = Основание.Организация;
		Дата        = Основание.Дата;

		Ответственный = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "ОсновнойОтветственный");

		Если Основание.ВидОперации = Перечисления.ВидыОперацийВводНачОстатковНДС.НДСПоПриобретеннымЦенностям Тогда
			ВидОперации = Перечисления.ВидыОперацийВводНачальныхОстатковПоВзаиморасчетам.РасчетыСПоставщиками;
		Иначе
			ВидОперации = Перечисления.ВидыОперацийВводНачальныхОстатковПоВзаиморасчетам.РасчетыСПокупателями;
		КонецЕсли;
		
		ОтразитьРасчетыСКонтрагентамиДляЦелейНДС = Ложь;
		ОтражатьВУправленческомУчете             = Истина;
		
		Для Каждого СтрокаОснования Из Основание.РасчетыСКонтрагентами Цикл
			
			Если СтрокаОснования.Аванс Тогда
				НоваяСтрока = Авансы.Добавить();
			Иначе
				НоваяСтрока = РасчетыСКонтрагентами.Добавить();
			КонецЕсли;
			
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаОснования);
			
			НоваяСтрока.СуммаВзаиморасчетов = СтрокаОснования.ВалютнаяСуммаВзаиморасчетов;
			НоваяСтрока.СуммаРегл           = СтрокаОснования.СуммаВзаиморасчетов;
			Если НЕ СтрокаОснования.Аванс Тогда
				НоваяСтрока.Документ        = СтрокаОснования.СчетФактура;
			КонецЕсли;
			
			ПересчетСуммыУпр(НоваяСтрока);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаЗаполнения()


мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");
мВалютаУправленческогоУчета     = Константы.ВалютаУправленческогоУчета    .Получить();

