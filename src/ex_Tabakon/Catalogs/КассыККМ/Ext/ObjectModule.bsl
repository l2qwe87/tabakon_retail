﻿
&Вместо("ПередЗаписью")
Процедура ТБКПередЗаписью(Отказ)
	// Вставить содержимое метода.
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если НЕ ЭтоГруппа Тогда
		
		Если НЕ ПодключаемоеОборудование.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ККТ Тогда
			ЭлектронныйЧекSMSПередаютсяПрограммой1С   = Ложь;
			ЭлектронныйЧекEmailПередаютсяПрограммой1С = Ложь;
		КонецЕсли;
		
		Если ТипКассы = Перечисления.ТипыКассККМ.ККМOffline Тогда
			Возврат;
		КонецЕсли;

		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КассыККМ.Ссылка.Наименование КАК Наименование
		|ИЗ
		|	Справочник.КассыККМ КАК КассыККМ
		|ГДЕ
		|	КассыККМ.Магазин = &Магазин
		|	И НЕ (КассыККМ.ТипКассы = ЗНАЧЕНИЕ(Перечисление.ТипыКассККМ.ККМOffline))
		|	И КассыККМ.Владелец = &Владелец
		|	И КассыККМ.РабочееМесто = &РабочееМесто
		|	И НЕ КассыККМ.Ссылка = &Ссылка";
		
		Запрос.УстановитьПараметр("Магазин", Магазин);
		Запрос.УстановитьПараметр("Владелец", Владелец);
		Запрос.УстановитьПараметр("РабочееМесто", РабочееМесто);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		Результат = Запрос.Выполнить();
		
		Выборка = Результат.Выбрать();
		
		//Если Выборка.Следующий() Тогда
		//
		//	Отказ = Истина;
		//	СтрокаСообщения = НСтр("ru = 'Касса с такими же параметрами уже существует
		//								 |" + Выборка.Наименование + " :
		//								 |Магазин      - " + Магазин + "
		//								 |Организация  - " + Владелец + "
		//								 |РабочееМесто - " + РабочееМесто + "'"); 
		//	
		//	ОбщегоНазначения.СообщитьПользователю(СтрокаСообщения)
		//КонецЕсли;
		
		ТипОборудования = ПодключаемоеОборудование.ТипОборудования;
	КонецЕсли;
КонецПроцедуры
