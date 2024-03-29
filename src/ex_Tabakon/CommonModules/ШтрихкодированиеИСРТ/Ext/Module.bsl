﻿
&Вместо("ЗаполнитьДанныеПоШтрихкодамEAN")
Процедура ТБКЗаполнитьДанныеПоШтрихкодамEAN(ДанныеПоШтрихкодамEAN)

	ШтрихкодыEAN = ДанныеПоШтрихкодамEAN.ВыгрузитьКолонку("ШтрихкодEAN");
	МассивКодовSKU = Новый Массив;
	СоответствиеВесовыхШтрихкодов = Новый Соответствие;
	Для Каждого ШтрихкодEAN Из ШтрихкодыEAN Цикл 
		ПрефиксВнутреннегоШтрихкодаВесовогоТовара = ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("ПрефиксВнутреннегоШтрихкодаВесовогоТовара");
		ПрефиксВнутреннегоШтрихкодаШтучногоФасованногоТовара = ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("ПрефиксВнутреннегоШтрихкодаШтучногоФасованногоТовара");
		ДлинаКодаВесовогоТовара = СтрДлина(Формат(ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("ВерхняяГраницаДиапазонаSKUВесовогоТовара"), "ЧГ = 0"));

		ПрефиксКода = Лев(ШтрихкодEAN, 2);
		ПрефиксВесовой = "2" + ПрефиксВнутреннегоШтрихкодаВесовогоТовара;
		ПрефиксШтучный = "2" + ПрефиксВнутреннегоШтрихкодаШтучногоФасованногоТовара;
		ЭтоВесовой = ПрефиксКода = ПрефиксВесовой И СтрДлина(ШтрихкодEAN) < 20; // EAN всегда короче, иначе это марка
		ЭтоШтучный = ПрефиксКода = ПрефиксШтучный;

		//вик 2023-04-28
		ЭтоВесовой = ложь;//появились штучные штрихкоды с префиксом весового
		//
		
		Если ДлинаКодаВесовогоТовара < 5 Тогда
			ДлинаКодаВесовогоТовара = 5;
		КонецЕсли;

		КодТовара = ШтрихкодEAN;
		Если ЭтоВесовой ИЛИ ЭтоШтучный Тогда
			КодТовара = Число(Сред(ШтрихкодEAN, 3,  ДлинаКодаВесовогоТовара));
			МассивКодовSKU.Добавить(КодТовара);
		КонецЕсли;

		СоответствиеВесовыхШтрихкодов.Вставить(КодТовара, ШтрихкодEAN);
	КонецЦикла;

	ТекстЗапроса = 
	"ВЫБРАТЬ DISTINCT
	|	0 КАК Порядок,
	|	ВЫРАЗИТЬ(ШтрихкодыНоменклатуры.Владелец КАК Справочник.Номенклатура) КАК Номенклатура,
	|	ПРЕДСТАВЛЕНИЕ(ШтрихкодыНоменклатуры.Владелец) КАК ПредставлениеНоменклатуры,
	
	//|	ШтрихкодыНоменклатуры.Характеристика КАК Характеристика,
	|	Характеристики.Ссылка КАК Характеристика,
	
	|	Значение(Справочник.СерииНоменклатуры.ПустаяСсылка) КАК Серия,
	|	ШтрихкодыНоменклатуры.Штрихкод КАК ШтрихкодEAN,
	|	ВЫБОР
	|		КОГДА ВЫРАЗИТЬ(ШтрихкодыНоменклатуры.Владелец КАК Справочник.Номенклатура).АлкогольнаяПродукция
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.Алкогольная)
	|		КОГДА ВЫРАЗИТЬ(ШтрихкодыНоменклатуры.Владелец КАК Справочник.Номенклатура).ТабачнаяПродукция
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.Табачная)
	|		КОГДА ВЫРАЗИТЬ(ШтрихкодыНоменклатуры.Владелец КАК Справочник.Номенклатура).ОбувнаяПродукция
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.Обувная)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.ПустаяСсылка)
	|	КОНЕЦ КАК ВидПродукции,
	|	ЕСТЬNULL(ВЫРАЗИТЬ(ШтрихкодыНоменклатуры.Владелец КАК Справочник.Номенклатура).ВидАлкогольнойПродукцииЕГАИС.Маркируемый, ЛОЖЬ)
	|		ИЛИ ВЫРАЗИТЬ(ШтрихкодыНоменклатуры.Владелец КАК Справочник.Номенклатура).ТабачнаяПродукция
	|		ИЛИ ВЫРАЗИТЬ(ШтрихкодыНоменклатуры.Владелец КАК Справочник.Номенклатура).ОбувнаяПродукция КАК МаркируемаяПродукция
	|ИЗ
	|	РегистрСведений.Штрихкоды КАК ШтрихкодыНоменклатуры
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
	|		ПО (ВидыНоменклатуры.Ссылка = ВЫРАЗИТЬ(ШтрихкодыНоменклатуры.Владелец КАК Справочник.Номенклатура).ВидНоменклатуры)
	|			И (ВидыНоменклатуры.ОсобенностьУчета В (ЗНАЧЕНИЕ(Перечисление.ОсобенностиУчетаНоменклатуры.АлкогольнаяПродукция), ЗНАЧЕНИЕ(Перечисление.ОсобенностиУчетаНоменклатуры.ТабачнаяПродукция), ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.Обувная)))
	|	LEFT JOIN Справочник.ХарактеристикиНоменклатуры Характеристики ПО Характеристики.Владелец = ШтрихкодыНоменклатуры.Владелец И ШтрихкодыНоменклатуры.Владелец.ВидНоменклатуры.ИспользоватьХарактеристики
	|ГДЕ
	|	НЕ ШтрихкодыНоменклатуры.Владелец.ПометкаУдаления
	|	И ШтрихкодыНоменклатуры.Штрихкод В(&Штрихкоды)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ DISTINCT
	|	1,
	|	ВЫРАЗИТЬ(ШтрихкодыНоменклатуры.Владелец КАК Справочник.Номенклатура),
	|	ПРЕДСТАВЛЕНИЕ(ШтрихкодыНоменклатуры.Владелец),
	
	//|	ШтрихкодыНоменклатуры.Характеристика,
	|	Характеристики.Ссылка КАК Характеристика,
	
	|	Значение(Справочник.СерииНоменклатуры.ПустаяСсылка),
	|	ШтрихкодыНоменклатуры.Штрихкод,
	|	ВЫБОР
	|		КОГДА ВЫРАЗИТЬ(ШтрихкодыНоменклатуры.Владелец КАК Справочник.Номенклатура).АлкогольнаяПродукция
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.Алкогольная)
	|		КОГДА ВЫРАЗИТЬ(ШтрихкодыНоменклатуры.Владелец КАК Справочник.Номенклатура).ТабачнаяПродукция
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.Табачная)
	|		КОГДА ВЫРАЗИТЬ(ШтрихкодыНоменклатуры.Владелец КАК Справочник.Номенклатура).ОбувнаяПродукция
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.Обувная)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.ПустаяСсылка)
	|	КОНЕЦ,
	|	ЕСТЬNULL(ВЫРАЗИТЬ(ШтрихкодыНоменклатуры.Владелец КАК Справочник.Номенклатура).ВидАлкогольнойПродукцииЕГАИС.Маркируемый, ЛОЖЬ)
	|		ИЛИ ВЫРАЗИТЬ(ШтрихкодыНоменклатуры.Владелец КАК Справочник.Номенклатура).ТабачнаяПродукция
	|		ИЛИ ВЫРАЗИТЬ(ШтрихкодыНоменклатуры.Владелец КАК Справочник.Номенклатура).ОбувнаяПродукция
	|ИЗ
	|	РегистрСведений.Штрихкоды КАК ШтрихкодыНоменклатуры
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
	|		ПО (ВидыНоменклатуры.Ссылка = ВЫРАЗИТЬ(ШтрихкодыНоменклатуры.Владелец КАК Справочник.Номенклатура).ВидНоменклатуры)
	|			И (НЕ ВидыНоменклатуры.ОсобенностьУчета В (ЗНАЧЕНИЕ(Перечисление.ОсобенностиУчетаНоменклатуры.АлкогольнаяПродукция), ЗНАЧЕНИЕ(Перечисление.ОсобенностиУчетаНоменклатуры.ТабачнаяПродукция), ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.Обувная)))
	|	LEFT JOIN Справочник.ХарактеристикиНоменклатуры Характеристики ПО Характеристики.Владелец = ШтрихкодыНоменклатуры.Владелец И ШтрихкодыНоменклатуры.Владелец.ВидНоменклатуры.ИспользоватьХарактеристики
	|ГДЕ
	|	НЕ ШтрихкодыНоменклатуры.Владелец.ПометкаУдаления
	|	И ШтрихкодыНоменклатуры.Штрихкод В(&Штрихкоды)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	2,
	|	КодыТоваровSKU.Номенклатура,
	|	ПРЕДСТАВЛЕНИЕ(КодыТоваровSKU.Номенклатура),
	|	КодыТоваровSKU.Характеристика,
	|	Значение(Справочник.СерииНоменклатуры.ПустаяСсылка),
	|	КодыТоваровSKU.SKU,
	|	ВЫБОР
	|		КОГДА СпрНоменклатура.АлкогольнаяПродукция
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.Алкогольная)
	|		КОГДА СпрНоменклатура.ТабачнаяПродукция
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.Табачная)
	|		КОГДА СпрНоменклатура.ОбувнаяПродукция
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.Обувная)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.ПустаяСсылка)
	|	КОНЕЦ,
	|	ЕСТЬNULL(СпрНоменклатура.ВидАлкогольнойПродукцииЕГАИС.Маркируемый, ЛОЖЬ)
	|		ИЛИ СпрНоменклатура.ТабачнаяПродукция
	|		ИЛИ СпрНоменклатура.ОбувнаяПродукция
	|ИЗ
	|	РегистрСведений.КодыТоваровSKU КАК КодыТоваровSKU
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНоменклатура
	|		ПО КодыТоваровSKU.Номенклатура = СпрНоменклатура.Ссылка
	|ГДЕ
	|	КодыТоваровSKU.SKU В(&МассивКодовSKU)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	3,
	|	ВЫРАЗИТЬ(ШтрихкодыНоменклатуры.Владелец КАК Справочник.ИнформационныеКарты),
	|	ПРЕДСТАВЛЕНИЕ(ШтрихкодыНоменклатуры.Владелец),
	|	ШтрихкодыНоменклатуры.Характеристика,
	|	Значение(Справочник.СерииНоменклатуры.ПустаяСсылка),
	|	ШтрихкодыНоменклатуры.Штрихкод,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.ПустаяСсылка),
	|	ЛОЖЬ
	|ИЗ
	|	РегистрСведений.Штрихкоды КАК ШтрихкодыНоменклатуры
	|ГДЕ
	|	НЕ ШтрихкодыНоменклатуры.Владелец.ПометкаУдаления
	|	И ШтрихкодыНоменклатуры.Штрихкод В(&Штрихкоды)
	|	И ТИПЗНАЧЕНИЯ(ШтрихкодыНоменклатуры.Владелец) = ТИП(Справочник.ИнформационныеКарты)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	4,
	|	ВЫРАЗИТЬ(ШтрихкодыНоменклатуры.Владелец КАК Справочник.СерийныеНомера),
	|	ПРЕДСТАВЛЕНИЕ(ШтрихкодыНоменклатуры.Владелец),
	|	ШтрихкодыНоменклатуры.Характеристика,
	|	Значение(Справочник.СерииНоменклатуры.ПустаяСсылка),
	|	ШтрихкодыНоменклатуры.Штрихкод,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.ПустаяСсылка),
	|	ЛОЖЬ
	|ИЗ
	|	РегистрСведений.Штрихкоды КАК ШтрихкодыНоменклатуры
	|ГДЕ
	|	НЕ ШтрихкодыНоменклатуры.Владелец.ПометкаУдаления
	|	И ШтрихкодыНоменклатуры.Штрихкод В(&Штрихкоды)
	|	И ТИПЗНАЧЕНИЯ(ШтрихкодыНоменклатуры.Владелец) = ТИП(Справочник.СерийныеНомера)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок";

	Запрос = Новый Запрос(ТекстЗапроса);

	Запрос.УстановитьПараметр("Штрихкоды",      ШтрихкодыEAN);
	Запрос.УстановитьПараметр("МассивКодовSKU", МассивКодовSKU);

	ДанныеПоШтрихкодам = Запрос.Выполнить().Выгрузить();
	Для Каждого ДанныеПоШтрихкоду Из ДанныеПоШтрихкодам Цикл 
		ДанныеПоШтрихкоду.ШтрихкодEAN = СоответствиеВесовыхШтрихкодов.Получить(ДанныеПоШтрихкоду.ШтрихкодEAN);
	КонецЦикла;

	ДанныеПоШтрихкодамEAN = ДанныеПоШтрихкодам;

КонецПроцедуры
