﻿#Если Клиент Тогда
	
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ НАЧАЛЬНОЙ НАСТРОЙКИ ОТЧЕТА

// Процедура установки начальных настроек отчета по метаданным регистра накопления
//
Процедура УстановитьНачальныеНастройки(ДополнительныеПараметры = Неопределено) Экспорт
	
	// Настройка общих параметров универсального отчета
	
	// Содержит название отчета, которое будет выводиться в шапке.
	// Тип: Строка.
	// Пример:
	// УниверсальныйОтчет.мНазваниеОтчета = "Название отчета";
	УниверсальныйОтчет.мНазваниеОтчета = СокрЛП(ЭтотОбъект.Метаданные().Синоним);
	
	// Содержит признак необходимости отображения надписи и поля выбора раздела учета в форме настройки.
	// Тип: Булево.
	// Значение по умолчанию: Истина.
	// Пример:
	// УниверсальныйОтчет.мВыбиратьИмяРегистра = Ложь;
	УниверсальныйОтчет.мВыбиратьИмяРегистра = Ложь;
	
	// Содержит имя регистра, по метаданным которого будет выполняться заполнение настроек отчета.
	// Тип: Строка.
	// Пример:
	// УниверсальныйОтчет.ИмяРегистра = "ТоварыНаСкладах";
	УниверсальныйОтчет.ИмяРегистра = "ТоварыВРознице";
	
	// Содержит признак необходимости вывода отрицательных значений показателей красным цветом.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.ОтрицательноеКрасным = Истина;
	
	// Содержит признак необходимости вывода в отчет общих итогов.
	// Тип: Булево.
	// Значение по умолчанию: Истина.
	// Пример:
	// УниверсальныйОтчет.ВыводитьОбщиеИтоги = Ложь;
	
	// Содержит признак необходимости вывода детальных записей в отчет.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.ВыводитьДетальныеЗаписи = Истина;
	
	// Содержит признак необходимости отображения флага использования свойств и категорий в форме настройки.
	// Тип: Булево.
	// Значение по умолчанию: Истина.
	// Пример:
	// УниверсальныйОтчет.мВыбиратьИспользованиеСвойств = Ложь;
	
	// Содержит признак использования свойств и категорий при заполнении настроек отчета.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.ИспользоватьСвойстваИКатегории = Истина;
	
	// Содержит признак использования простой формы настроек отчета без группировок колонок.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.мРежимФормыНастройкиБезГруппировокКолонок = Истина;
	
	// Дополнительные параметры, переданные из отчета, вызвавшего расшифровку.
	// Информация, передаваемая в переменной ДополнительныеПараметры, может быть использована
	// для реализации специфичных для данного отчета параметрических настроек.
	
	УниверсальныйОтчет.ДобавитьПолеГруппировка("БазоваяЕдиницаИзмерения", "Номенклатура", "БазоваяЕдиницаИзмерения", "Базовая единица измерения");
	
	УниверсальныйОтчет.ДобавитьПолеРесурс("КоличествоЕдиницОтчетовНачальныйОстаток", "ИсточникДанных.КоличествоНачальныйОстаток * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ИсточникДанных.Номенклатура.ЕдиницаДляОтчетов.Коэффициент", "Количество (в ед. отчетов) (нач. ост.)");
	УниверсальныйОтчет.ДобавитьПолеРесурс("КоличествоЕдиницОтчетовПриход",           "ИсточникДанных.КоличествоПриход * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ИсточникДанных.Номенклатура.ЕдиницаДляОтчетов.Коэффициент", "Количество (в ед. отчетов) (приход)");
	УниверсальныйОтчет.ДобавитьПолеРесурс("КоличествоЕдиницОтчетовРасход",           "ИсточникДанных.КоличествоРасход * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ИсточникДанных.Номенклатура.ЕдиницаДляОтчетов.Коэффициент", "Количество (в ед. отчетов) (расход)");
	УниверсальныйОтчет.ДобавитьПолеРесурс("КоличествоЕдиницОтчетовКонечныйОстаток",  "ИсточникДанных.КоличествоКонечныйОстаток  * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ИсточникДанных.Номенклатура.ЕдиницаДляОтчетов.Коэффициент", "Количество (в ед. отчетов) (кон. ост.)");
	УниверсальныйОтчет.ДобавитьПолеРесурс("КоличествоЕдиницОтчетовОборот",           "ИсточникДанных.КоличествоОборот * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ИсточникДанных.Номенклатура.ЕдиницаДляОтчетов.Коэффициент", "Количество (в ед. отчетов) (оборот)");
	
	УниверсальныйОтчет.ДобавитьПолеРесурс("КоличествоБазовыхЕдНачальныйОстаток",     "ИсточникДанных.КоличествоНачальныйОстаток * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент", "Количество (в базовых единицах) (нач. ост.)");
	УниверсальныйОтчет.ДобавитьПолеРесурс("КоличествоБазовыхЕдПриход",               "ИсточникДанных.КоличествоПриход * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент", "Количество (в базовых единицах) (приход)");
	УниверсальныйОтчет.ДобавитьПолеРесурс("КоличествоБазовыхЕдРасход",               "ИсточникДанных.КоличествоРасход * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент", "Количество (в базовых единицах) (расход)");
	УниверсальныйОтчет.ДобавитьПолеРесурс("КоличествоБазовыхЕдКонечныйОстаток",      "ИсточникДанных.КоличествоКонечныйОстаток  * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент", "Количество (в базовых единицах) (кон. ост.)");
	УниверсальныйОтчет.ДобавитьПолеРесурс("КоличествоБазовыхЕдОборот",               "ИсточникДанных.КоличествоОборот * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент", "Количество (в базовых единицах) (оборот)");
	
	//Балашева
	УниверсальныйОтчет.ДобавитьПоказатель("Цена","Цена", Ложь, "ЧЦ=15; ЧДЦ=3", "Цена", "Цена");
	УниверсальныйОтчет.ДобавитьПоказатель("ЦенаПриход", "Стоимость Приход", Ложь, "ЧЦ=15; ЧДЦ=3", "Цена", "Цена");
	УниверсальныйОтчет.ДобавитьПоказатель("ЦенаРасход", "Стоимость Расход", Ложь, "ЧЦ=15; ЧДЦ=3", "Цена", "Цена");
	УниверсальныйОтчет.ДобавитьПоказатель("ЦенаОстаток", "Стоимость Остаток", Ложь, "ЧЦ=15; ЧДЦ=3", "Цена", "Цена");
	//
	
	// НЧАН
	УниверсальныйОтчет.ДобавитьПоказатель("МинОст", "Мин. остаток", Ложь, "ЧЦ=15", "МинОст", "МинОст");
	// КЧАН
	
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоБазовыхЕдНачальныйОстаток", "Начальный остаток", Истина, "ЧЦ=15; ЧДЦ=3", "КолБазовыхЕд", "Количество (в базовых единицах)");
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоБазовыхЕдПриход",           "Приход",            Истина, "ЧЦ=15; ЧДЦ=3", "КолБазовыхЕд", "Количество (в базовых единицах)");
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоБазовыхЕдРасход",           "Расход",            Истина, "ЧЦ=15; ЧДЦ=3", "КолБазовыхЕд", "Количество (в базовых единицах)");
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоБазовыхЕдКонечныйОстаток",  "Конечный остаток",  Истина, "ЧЦ=15; ЧДЦ=3", "КолБазовыхЕд", "Количество (в базовых единицах)");
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоБазовыхЕдОборот",           "Оборот",              Ложь, "ЧЦ=15; ЧДЦ=3", "КолБазовыхЕд", "Количество (в базовых единицах)");
	
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоЕдиницОтчетовНачальныйОстаток", "Начальный остаток", Ложь, "ЧЦ=15; ЧДЦ=3", "КоличествоЕдиницОтчетов", "Количество (в ед. отчетов)");
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоЕдиницОтчетовПриход",           "Приход",            Ложь, "ЧЦ=15; ЧДЦ=3", "КоличествоЕдиницОтчетов", "Количество (в ед. отчетов)");
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоЕдиницОтчетовРасход",           "Расход",            Ложь, "ЧЦ=15; ЧДЦ=3", "КоличествоЕдиницОтчетов", "Количество (в ед. отчетов)");
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоЕдиницОтчетовКонечныйОстаток",  "Конечный остаток",  Ложь, "ЧЦ=15; ЧДЦ=3", "КоличествоЕдиницОтчетов", "Количество (в ед. отчетов)");
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоЕдиницОтчетовОборот",           "Оборот",            Ложь, "ЧЦ=15; ЧДЦ=3", "КоличествоЕдиницОтчетов", "Количество (в ед. отчетов)");
	
	// Заполнение начальных настроек универсального отчета
		
	УниверсальныйОтчет.УстановитьНачальныеНастройки(Истина);
		
	//Балашева
	
	// НЧАН
	ТаблицаПолейП = Неопределено;
	ТекстЗапроса = ПолучитьТекстЗапроса(ТаблицаПолейП);
	Если УниверсальныйОтчет.ИспользоватьСвойстваИКатегории Тогда
		УниверсальныйОтчет.ДобавитьВТекстЗапросаСвойстваИКатегории(ТекстЗапроса, ТаблицаПолейП);		
	КонецЕсли;
	//УниверсальныйОтчет.УстановитьНачальныеНастройки(Истина);
	УниверсальныйОтчет.ПостроительОтчета.Текст = ТекстЗапроса;
	
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("МинОст","Мин. остаток");
	// КЧАН
	
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Цена","Цена товара");	
	
	ОтборПериодичность = УниверсальныйОтчет.ПостроительОтчета.Отбор.Найти("Периодичность");
	
	Если ОтборПериодичность <> Неопределено Тогда
		
		УниверсальныйОтчет.ПостроительОтчета.Отбор.Удалить(УниверсальныйОтчет.ПостроительОтчета.Отбор.Индекс(ОтборПериодичность));
		
	КонецЕсли;
	
	УниверсальныйОтчет.ПостроительОтчета.ВыбранныеПоля.Очистить();
	
	
	
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоНачальныйОстаток",, Ложь,, "Количество");
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоПриход",,           Ложь,, "Количество");
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоРасход",,           Ложь,, "Количество");
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоКонечныйОстаток",,  Ложь,, "Количество");
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоОборот",,           Ложь,, "Количество");
	
		
	// Добавление предопределенных группировок строк отчета.
	// Необходимо вызывать для каждой добавляемой группировки строки.
	// УниверсальныйОтчет.ДобавитьИзмерениеСтроки(<ПутьКДанным>);
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Склад");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Номенклатура");
	
	//Балашева
	//УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Цена");
	//
	
	// Добавление предопределенных группировок колонок отчета.
	// Необходимо вызывать для каждой добавляемой группировки колонки.
	// УниверсальныйОтчет.ДобавитьИзмерениеКолонки(<ПутьКДанным>);
	
	// Добавление предопределенных отборов отчета.
	// Необходимо вызывать для каждого добавляемого отбора.
	// УниверсальныйОтчет.ДобавитьОтбор(<ПутьКДанным>);
	////
	
	////
	УниверсальныйОтчет.ДобавитьОтбор("Склад");
	УниверсальныйОтчет.ДобавитьОтбор("Номенклатура");
	
	
	// Добавление предопределенных полей порядка отчета.
	// Необходимо вызывать для каждого добавляемого поля порядка.
	// УниверсальныйОтчет.ДобавитьПорядок(<ПутьКДанным>);
	
	// Установка связи подчиненных и родительских полей
	// УниверсальныйОтчет.УстановитьСвязьПолей(<ПутьКДанным>, <ПутьКДаннымРодитель>);
	
	// Установка связи полей и измерений
	// УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения(<ИмяПоля>, <ИмяИзмерения>);
	
	// Добавление дополнительных полей
	// Необходимо вызывать для каждого добавляемого дополнительного поля.
	// УниверсальныйОтчет.ДобавитьДополнительноеПоле(<ПутьКДанным>, <Размещение>, <Положение>);
	
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("БазоваяЕдиницаИзмерения");  //
	//УниверсальныйОтчет.ДобавитьДополнительноеПоле("Цена");
	
	КонецПроцедуры // УстановитьНачальныеНастройки()

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ОТЧЕТА 
	
// Процедура формирования отчета
//
Процедура СформироватьОтчет(ТабличныйДокумент) Экспорт
	
	// Перед формирование отчета можно установить необходимые параметры универсального отчета.
	//Балашева
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ДатаОтчета", ?(ЗначениеЗаполнено(ДатаЦен),КонецДня(ДатаЦен),ТекущаяДата()));
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ТипЦены",ТипЦен);	
	//--
	УниверсальныйОтчет.СформироватьОтчет(ТабличныйДокумент);

КонецПроцедуры // СформироватьОтчет()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура обработки расшифровки
//
Процедура ОбработкаРасшифровки(Расшифровка, Объект) Экспорт
	
	// Дополнительные параметры в расшифровывающий отчет можно передать
	// посредством инициализации переменной "ДополнительныеПараметры".
	
	ДополнительныеПараметры = Неопределено;
	УниверсальныйОтчет.ОбработкаРасшифровкиУниверсальногоОтчета(Расшифровка, Объект, ДополнительныеПараметры);
	
КонецПроцедуры // ОбработкаРасшифровки()

// Формирует структуру для сохранения настроек отчета
//
Процедура СформироватьСтруктуруДляСохраненияНастроек(СтруктураСНастройками) Экспорт
	
	УниверсальныйОтчет.СформироватьСтруктуруДляСохраненияНастроек(СтруктураСНастройками);
	
КонецПроцедуры // СформироватьСтруктуруДляСохраненияНастроек()

// Заполняет настройки отчета из структуры сохраненных настроек
//
Функция ВосстановитьНастройкиИзСтруктуры(СтруктураСНастройками) Экспорт
	
	Возврат УниверсальныйОтчет.ВосстановитьНастройкиИзСтруктуры(СтруктураСНастройками, ЭтотОбъект);
	
КонецФункции // ВосстановитьНастройкиИзСтруктуры()

// Содержит значение используемого режима ввода периода.
// Тип: Число.
// Возможные значения: 0 - произвольный период, 1 - на дату, 2 - неделя, 3 - декада, 4 - месяц, 5 - квартал, 6 - полугодие, 7 - год
// Значение по умолчанию: 0
// Пример:
// УниверсальныйОтчет.мРежимВводаПериода = 1;

// НЧАН
Функция ПолучитьТекстЗапроса(мТаблицаПолей)
	
	мТаблицаПолей = Новый ТаблицаЗначений;
	мТаблицаПолей.Колонки.Добавить("ПутьКДанным");   
	мТаблицаПолей.Колонки.Добавить("ИмяИзмерения");  
	мТаблицаПолей.Колонки.Добавить("Представление"); 
	мТаблицаПолей.Колонки.Добавить("Назначение");    
	мТаблицаПолей.Колонки.Добавить("НетКатегорий");

	НовКат = мТаблицаПолей.Добавить();
	НовКат.ПутьКДанным = "ИсточникДанных.Склад";  
	НовКат.ИмяИзмерения = "Склад";  
	НовКат.Представление = "Склад";   
	НовКат.Назначение = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.НайтиПоКоду("000000105");   
	НовКат.НетКатегорий = "Ложь"; 

	НовКат = мТаблицаПолей.Добавить();
	НовКат.ПутьКДанным = "ИсточникДанных.Склад";  
	НовКат.ИмяИзмерения = "Склад";  
	НовКат.Представление = "Склад";   
	НовКат.Назначение = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.НайтиПоКоду("000000107");   
	НовКат.НетКатегорий = "Ложь"; 

	НовКат = мТаблицаПолей.Добавить();
	НовКат.ПутьКДанным = "ИсточникДанных.Номенклатура";  
	НовКат.ИмяИзмерения = "Номенклатура";  
	НовКат.Представление = "Номенклатура";   
	НовКат.Назначение = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.НайтиПоКоду("000000102");   
	НовКат.НетКатегорий = "Ложь"; 

	НовКат = мТаблицаПолей.Добавить();
	НовКат.ПутьКДанным = "ИсточникДанных.Номенклатура";  
	НовКат.ИмяИзмерения = "Номенклатура";  
	НовКат.Представление = "Номенклатура";   
	НовКат.Назначение = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.НайтиПоКоду("000000107");   
	НовКат.НетКатегорий = "Ложь"; 

	НовКат = мТаблицаПолей.Добавить();
	НовКат.ПутьКДанным = "ИсточникДанных.ХарактеристикаНоменклатуры";  
	НовКат.ИмяИзмерения = "ХарактеристикаНоменклатуры";  
	НовКат.Представление = "Характеристика номенклатуры";   
	НовКат.Назначение = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.НайтиПоКоду("000000103");   
	НовКат.НетКатегорий = "Ложь";

	НовКат = мТаблицаПолей.Добавить();
	НовКат.ПутьКДанным = "ИсточникДанных.Регистратор";  
	НовКат.ИмяИзмерения = "Регистратор";  
	НовКат.Представление = "Документ движения (регистратор)";   
	НовКат.Назначение  = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.НайтиПоКоду("000000002");   
	НовКат.НетКатегорий = "Ложь";

	НовКат = мТаблицаПолей.Добавить();
	НовКат.ПутьКДанным = "ИсточникДанных.Регистратор";  
	НовКат.ИмяИзмерения = "Регистратор";  
	НовКат.Представление = "Документ движения (регистратор)";   
	НовКат.Назначение = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.НайтиПоКоду("000000107");   
	НовКат.НетКатегорий = "Ложь";
	
	Возврат "ВЫБРАТЬ
	        |	МинимальныйОстаток.Склад,
	        |	МинимальныйОстаток.Номенклатура,
	        |	МАКСИМУМ(МинимальныйОстаток.МинОстаток) КАК МинОстаток
	        |ПОМЕСТИТЬ МО
	        |ИЗ
	        |	РегистрСведений.МинимальныйОстаток КАК МинимальныйОстаток
	        |
	        |СГРУППИРОВАТЬ ПО
	        |	МинимальныйОстаток.Склад,
	        |	МинимальныйОстаток.Номенклатура
	        |;
	        |
	        |////////////////////////////////////////////////////////////////////////////////
	        |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	        |	ИсточникДанных.Склад КАК Склад,
	        |	ПРЕДСТАВЛЕНИЕ(ИсточникДанных.Склад) КАК СкладПредставление,
	        |	ИсточникДанных.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	        |	ПРЕДСТАВЛЕНИЕ(ИсточникДанных.ХарактеристикаНоменклатуры) КАК ХарактеристикаНоменклатурыПредставление,
	        |	ИсточникДанных.СерияНоменклатуры КАК СерияНоменклатуры,
	        |	ПРЕДСТАВЛЕНИЕ(ИсточникДанных.СерияНоменклатуры) КАК СерияНоменклатурыПредставление,
	        |	ИсточникДанных.Качество КАК Качество,
	        |	ПРЕДСТАВЛЕНИЕ(ИсточникДанных.Качество) КАК КачествоПредставление,
	        |	ИсточникДанных.Номенклатура.БазоваяЕдиницаИзмерения КАК БазоваяЕдиницаИзмерения,
	        |	ПРЕДСТАВЛЕНИЕ(ИсточникДанных.Номенклатура.БазоваяЕдиницаИзмерения) КАК БазоваяЕдиницаИзмеренияПредставление,
	        |	ИсточникДанных.КоличествоНачальныйОстаток КАК КоличествоНачальныйОстаток,
	        |	ИсточникДанных.КоличествоПриход КАК КоличествоПриход,
	        |	ИсточникДанных.КоличествоРасход КАК КоличествоРасход,
	        |	ИсточникДанных.КоличествоКонечныйОстаток КАК КоличествоКонечныйОстаток,
	        |	ИсточникДанных.КоличествоОборот КАК КоличествоОборот,
	        |	ИсточникДанных.СуммаПродажнаяНачальныйОстаток КАК СуммаПродажнаяНачальныйОстаток,
	        |	ИсточникДанных.СуммаПродажнаяПриход КАК СуммаПродажнаяПриход,
	        |	ИсточникДанных.СуммаПродажнаяРасход КАК СуммаПродажнаяРасход,
	        |	ИсточникДанных.СуммаПродажнаяКонечныйОстаток КАК СуммаПродажнаяКонечныйОстаток,
	        |	ИсточникДанных.СуммаПродажнаяОборот КАК СуммаПродажнаяОборот,
	        |	ИсточникДанных.КоличествоНачальныйОстаток * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ИсточникДанных.Номенклатура.ЕдиницаДляОтчетов.Коэффициент КАК КоличествоЕдиницОтчетовНачальныйОстаток,
	        |	ИсточникДанных.КоличествоПриход * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ИсточникДанных.Номенклатура.ЕдиницаДляОтчетов.Коэффициент КАК КоличествоЕдиницОтчетовПриход,
	        |	ИсточникДанных.КоличествоРасход * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ИсточникДанных.Номенклатура.ЕдиницаДляОтчетов.Коэффициент КАК КоличествоЕдиницОтчетовРасход,
	        |	ИсточникДанных.КоличествоКонечныйОстаток * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ИсточникДанных.Номенклатура.ЕдиницаДляОтчетов.Коэффициент КАК КоличествоЕдиницОтчетовКонечныйОстаток,
	        |	ИсточникДанных.КоличествоОборот * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ИсточникДанных.Номенклатура.ЕдиницаДляОтчетов.Коэффициент КАК КоличествоЕдиницОтчетовОборот,
	        |	ИсточникДанных.КоличествоНачальныйОстаток * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК КоличествоБазовыхЕдНачальныйОстаток,
	        |	ИсточникДанных.КоличествоПриход * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК КоличествоБазовыхЕдПриход,
	        |	ИсточникДанных.КоличествоРасход * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК КоличествоБазовыхЕдРасход,
	        |	ИсточникДанных.КоличествоКонечныйОстаток * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК КоличествоБазовыхЕдКонечныйОстаток,
	        |	ИсточникДанных.КоличествоОборот * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК КоличествоБазовыхЕдОборот,
	        |	ПРЕДСТАВЛЕНИЕ(ИсточникДанных.Регистратор) КАК РегистраторПредставление,
	        |	ИсточникДанных.Период КАК Период,
	        |	НАЧАЛОПЕРИОДА(ИсточникДанных.Период, ДЕНЬ) КАК ПериодДень,
	        |	НАЧАЛОПЕРИОДА(ИсточникДанных.Период, НЕДЕЛЯ) КАК ПериодНеделя,
	        |	НАЧАЛОПЕРИОДА(ИсточникДанных.Период, ДЕКАДА) КАК ПериодДекада,
	        |	НАЧАЛОПЕРИОДА(ИсточникДанных.Период, МЕСЯЦ) КАК ПериодМесяц,
	        |	НАЧАЛОПЕРИОДА(ИсточникДанных.Период, КВАРТАЛ) КАК ПериодКвартал,
	        |	НАЧАЛОПЕРИОДА(ИсточникДанных.Период, ПОЛУГОДИЕ) КАК ПериодПолугодие,
	        |	НАЧАЛОПЕРИОДА(ИсточникДанных.Период, ГОД) КАК ПериодГод,
	        |	ЦеныНоменклатурыСрезПоследних.Цена КАК Цена,
	        |	ЕСТЬNULL(ИсточникДанных.КоличествоПриход, 0) * ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена, 0) КАК ЦенаПриход,
	        |	ЕСТЬNULL(ИсточникДанных.КоличествоРасход, 0) * ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена, 0) КАК ЦенаРасход,
	        |	ЕСТЬNULL(ИсточникДанных.КоличествоКонечныйОстаток, 0) * ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена, 0) КАК ЦенаОстаток,
	        |	МО.МинОстаток КАК МинОст
					|   //ПОЛЯ_СВОЙСТВА
		|   //ПОЛЯ_КАТЕГОРИИ
	        |{ВЫБРАТЬ
	        |	Склад.*,
	        |	ХарактеристикаНоменклатуры.*,
	        |	СерияНоменклатуры.*,
	        |	Качество.*,
	        |	БазоваяЕдиницаИзмерения.*,
	        |	КоличествоНачальныйОстаток,
	        |	КоличествоПриход,
	        |	КоличествоРасход,
	        |	КоличествоКонечныйОстаток,
	        |	КоличествоОборот,
	        |	СуммаПродажнаяНачальныйОстаток,
	        |	СуммаПродажнаяПриход,
	        |	СуммаПродажнаяРасход,
	        |	СуммаПродажнаяКонечныйОстаток,
	        |	СуммаПродажнаяОборот,
	        |	КоличествоЕдиницОтчетовНачальныйОстаток,
	        |	КоличествоЕдиницОтчетовПриход,
	        |	КоличествоЕдиницОтчетовРасход,
	        |	КоличествоЕдиницОтчетовКонечныйОстаток,
	        |	КоличествоЕдиницОтчетовОборот,
	        |	КоличествоБазовыхЕдНачальныйОстаток,
	        |	КоличествоБазовыхЕдПриход,
	        |	КоличествоБазовыхЕдРасход,
	        |	КоличествоБазовыхЕдКонечныйОстаток,
	        |	КоличествоБазовыхЕдОборот,
	        |	Период КАК Период,
	        |	ПериодДень,
	        |	ПериодНеделя,
	        |	ПериодДекада,
	        |	ПериодМесяц,
	        |	ПериодКвартал,
	        |	ПериодПолугодие,
	        |	ПериодГод,
	        |	Цена,
	        |	ЦенаПриход,
	        |	ЦенаРасход,
	        |	ЦенаОстаток,
	        |	ИсточникДанных.Номенклатура.*,
	        |	ИсточникДанных.Регистратор.*,
	        |	МинОст
										|	//ПСЕВДОНИМЫ_СВОЙСТВА
	|//ПСЕВДОНИМЫ_КАТЕГОРИИ
|}
	        |ИЗ
	        |	РегистрНакопления.ТоварыВРознице.ОстаткиИОбороты(&ДатаНач, &ДатаКон, Регистратор {(&Периодичность)}, , {(Склад).* КАК Склад, (Номенклатура).* КАК Номенклатура, (ХарактеристикаНоменклатуры).* КАК ХарактеристикаНоменклатуры, (СерияНоменклатуры).* КАК СерияНоменклатуры, (Качество).* КАК Качество, (Номенклатура.БазоваяЕдиницаИзмерения).* КАК БазоваяЕдиницаИзмерения}) КАК ИсточникДанных
	        |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&ДатаОтчета, ТипЦен = &ТипЦены {(Номенклатура).* КАК НоменклатураЦены, (ХарактеристикаНоменклатуры).* КАК ХарактеристикаНоменклатуры}) КАК ЦеныНоменклатурыСрезПоследних
	        |		ПО ИсточникДанных.Номенклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура
	        |			И ИсточникДанных.ХарактеристикаНоменклатуры = ЦеныНоменклатурыСрезПоследних.ХарактеристикаНоменклатуры
	        |		ЛЕВОЕ СОЕДИНЕНИЕ МО КАК МО
	        |		ПО ИсточникДанных.Склад = МО.Склад
	        |			И ИсточникДанных.Номенклатура = МО.Номенклатура
			|//СОЕДИНЕНИЯ
	        |{ГДЕ
	        |	ИсточникДанных.КоличествоНачальныйОстаток КАК КоличествоНачальныйОстаток,
	        |	ИсточникДанных.КоличествоПриход КАК КоличествоПриход,
	        |	ИсточникДанных.КоличествоРасход КАК КоличествоРасход,
	        |	ИсточникДанных.КоличествоКонечныйОстаток КАК КоличествоКонечныйОстаток,
	        |	ИсточникДанных.КоличествоОборот КАК КоличествоОборот,
	        |	ИсточникДанных.СуммаПродажнаяНачальныйОстаток КАК СуммаПродажнаяНачальныйОстаток,
	        |	ИсточникДанных.СуммаПродажнаяПриход КАК СуммаПродажнаяПриход,
	        |	ИсточникДанных.СуммаПродажнаяРасход КАК СуммаПродажнаяРасход,
	        |	ИсточникДанных.СуммаПродажнаяКонечныйОстаток КАК СуммаПродажнаяКонечныйОстаток,
	        |	ИсточникДанных.СуммаПродажнаяОборот КАК СуммаПродажнаяОборот,
	        |	(ИсточникДанных.КоличествоНачальныйОстаток * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ИсточникДанных.Номенклатура.ЕдиницаДляОтчетов.Коэффициент) КАК КоличествоЕдиницОтчетовНачальныйОстаток,
	        |	(ИсточникДанных.КоличествоПриход * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ИсточникДанных.Номенклатура.ЕдиницаДляОтчетов.Коэффициент) КАК КоличествоЕдиницОтчетовПриход,
	        |	(ИсточникДанных.КоличествоРасход * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ИсточникДанных.Номенклатура.ЕдиницаДляОтчетов.Коэффициент) КАК КоличествоЕдиницОтчетовРасход,
	        |	(ИсточникДанных.КоличествоКонечныйОстаток * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ИсточникДанных.Номенклатура.ЕдиницаДляОтчетов.Коэффициент) КАК КоличествоЕдиницОтчетовКонечныйОстаток,
	        |	(ИсточникДанных.КоличествоОборот * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ИсточникДанных.Номенклатура.ЕдиницаДляОтчетов.Коэффициент) КАК КоличествоЕдиницОтчетовОборот,
	        |	(ИсточникДанных.КоличествоНачальныйОстаток * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент) КАК КоличествоБазовыхЕдНачальныйОстаток,
	        |	(ИсточникДанных.КоличествоПриход * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент) КАК КоличествоБазовыхЕдПриход,
	        |	(ИсточникДанных.КоличествоРасход * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент) КАК КоличествоБазовыхЕдРасход,
	        |	(ИсточникДанных.КоличествоКонечныйОстаток * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент) КАК КоличествоБазовыхЕдКонечныйОстаток,
	        |	(ИсточникДанных.КоличествоОборот * ИсточникДанных.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент) КАК КоличествоБазовыхЕдОборот,
	        |	ИсточникДанных.Период КАК Период,
	        |	(НАЧАЛОПЕРИОДА(ИсточникДанных.Период, ДЕНЬ)) КАК ПериодДень,
	        |	(НАЧАЛОПЕРИОДА(ИсточникДанных.Период, НЕДЕЛЯ)) КАК ПериодНеделя,
	        |	(НАЧАЛОПЕРИОДА(ИсточникДанных.Период, ДЕКАДА)) КАК ПериодДекада,
	        |	(НАЧАЛОПЕРИОДА(ИсточникДанных.Период, МЕСЯЦ)) КАК ПериодМесяц,
	        |	(НАЧАЛОПЕРИОДА(ИсточникДанных.Период, КВАРТАЛ)) КАК ПериодКвартал,
	        |	(НАЧАЛОПЕРИОДА(ИсточникДанных.Период, ПОЛУГОДИЕ)) КАК ПериодПолугодие,
	        |	(НАЧАЛОПЕРИОДА(ИсточникДанных.Период, ГОД)) КАК ПериодГод,
	        |	ЦеныНоменклатурыСрезПоследних.Цена КАК Цена,
	        |	(ЕСТЬNULL(ИсточникДанных.КоличествоПриход, 0) * ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена, 0)) КАК ЦенаПриход,
	        |	(ЕСТЬNULL(ИсточникДанных.КоличествоРасход, 0) * ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена, 0)) КАК ЦенаРасход,
	        |	(ЕСТЬNULL(ИсточникДанных.КоличествоКонечныйОстаток, 0) * ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена, 0)) КАК ЦенаОстаток,
	        |	ИсточникДанных.Номенклатура.*,
	        |	ИсточникДанных.Регистратор.*
										| //УСЛОВИЯ_СВОЙСТВА
	| //УСЛОВИЯ_КАТЕГОРИИ
		|}
	        |{УПОРЯДОЧИТЬ ПО
	        |	Склад.*,
	        |	ХарактеристикаНоменклатуры.*,
	        |	СерияНоменклатуры.*,
	        |	Качество.*,
	        |	БазоваяЕдиницаИзмерения.*,
	        |	КоличествоНачальныйОстаток,
	        |	КоличествоПриход,
	        |	КоличествоРасход,
	        |	КоличествоКонечныйОстаток,
	        |	КоличествоОборот,
	        |	СуммаПродажнаяНачальныйОстаток,
	        |	СуммаПродажнаяПриход,
	        |	СуммаПродажнаяРасход,
	        |	СуммаПродажнаяКонечныйОстаток,
	        |	СуммаПродажнаяОборот,
	        |	КоличествоЕдиницОтчетовНачальныйОстаток,
	        |	КоличествоЕдиницОтчетовПриход,
	        |	КоличествоЕдиницОтчетовРасход,
	        |	КоличествоЕдиницОтчетовКонечныйОстаток,
	        |	КоличествоЕдиницОтчетовОборот,
	        |	КоличествоБазовыхЕдНачальныйОстаток,
	        |	КоличествоБазовыхЕдПриход,
	        |	КоличествоБазовыхЕдРасход,
	        |	КоличествоБазовыхЕдКонечныйОстаток,
	        |	КоличествоБазовыхЕдОборот,
	        |	Период,
	        |	ПериодДень,
	        |	ПериодНеделя,
	        |	ПериодДекада,
	        |	ПериодМесяц,
	        |	ПериодКвартал,
	        |	ПериодПолугодие,
	        |	ПериодГод,
	        |	Цена,
	        |	ЦенаПриход,
	        |	ЦенаРасход,
	        |	ЦенаОстаток,
	        |	ИсточникДанных.Номенклатура.*,
	        |	ИсточникДанных.Регистратор.*,
	        |	МинОст
										|	//ПСЕВДОНИМЫ_СВОЙСТВА
	| //ПСЕВДОНИМЫ_КАТЕГОРИИ
		|}
	        |ИТОГИ
	        |	СУММА(КоличествоНачальныйОстаток),
	        |	СУММА(КоличествоПриход),
	        |	СУММА(КоличествоРасход),
	        |	СУММА(КоличествоКонечныйОстаток),
	        |	СУММА(КоличествоОборот),
	        |	СУММА(СуммаПродажнаяНачальныйОстаток),
	        |	СУММА(СуммаПродажнаяПриход),
	        |	СУММА(СуммаПродажнаяРасход),
	        |	СУММА(СуммаПродажнаяКонечныйОстаток),
	        |	СУММА(СуммаПродажнаяОборот),
	        |	СУММА(КоличествоЕдиницОтчетовНачальныйОстаток),
	        |	СУММА(КоличествоЕдиницОтчетовПриход),
	        |	СУММА(КоличествоЕдиницОтчетовРасход),
	        |	СУММА(КоличествоЕдиницОтчетовКонечныйОстаток),
	        |	СУММА(КоличествоЕдиницОтчетовОборот),
	        |	СУММА(КоличествоБазовыхЕдНачальныйОстаток),
	        |	СУММА(КоличествоБазовыхЕдПриход),
	        |	СУММА(КоличествоБазовыхЕдРасход),
	        |	СУММА(КоличествоБазовыхЕдКонечныйОстаток),
	        |	СУММА(КоличествоБазовыхЕдОборот),
	        |	МАКСИМУМ(Цена),
	        |	СУММА(ЦенаПриход),
	        |	СУММА(ЦенаРасход),
	        |	СУММА(ЦенаОстаток),
	        |	МАКСИМУМ(МинОст)
								|	//ИТОГИ_СВОЙСТВА
	|//ИТОГИ_КАТЕГОРИИ

	        |ПО
	        |	ОБЩИЕ
	        |{ИТОГИ ПО
	        |	Склад.*,
	        |	ХарактеристикаНоменклатуры.*,
	        |	СерияНоменклатуры.*,
	        |	Качество.*,
	        |	БазоваяЕдиницаИзмерения.*,
	        |	Период,
	        |	ПериодДень,
	        |	ПериодНеделя,
	        |	ПериодДекада,
	        |	ПериодМесяц,
	        |	ПериодКвартал,
	        |	ПериодПолугодие,
	        |	ПериодГод,
	        |	Цена,
	        |	ИсточникДанных.Номенклатура.*,
	        |	ИсточникДанных.Регистратор.*,
	        |	МинОст
								|	//ПСЕВДОНИМЫ_СВОЙСТВА
	|//ПСЕВДОНИМЫ_КАТЕГОРИИ
		|}";
		
КонецФункции	
// КЧАН

#КонецЕсли