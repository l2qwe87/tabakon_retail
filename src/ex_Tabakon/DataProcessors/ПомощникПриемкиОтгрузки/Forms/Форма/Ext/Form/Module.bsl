﻿
&НаСервере
&Вместо("ИнициализироватьТоварыПоФакту")
Процедура ТБКИнициализироватьТоварыПоФакту()
	// Вставить содержимое метода.
	
	//ПродолжитьВызов();
	инициализация = Ложь;
	Если Объект.ТоварыФакт.Итог("Количество") = 0 Тогда
		инициализация = Истина;
	КонецЕсли;
	
	Для Каждого СтрокаРаспоряжение Из Объект.ТоварыРаспоряжение Цикл
		
		СтруктураПоиска = Новый Структура("Номенклатура, Характеристика, Упаковка");
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаРаспоряжение);
		
		СтрокиФакт = Объект.ТоварыФакт.НайтиСтроки(СтруктураПоиска);
		Если СтрокиФакт.Количество() = 0 Тогда
			//ЗаполнитьЗначенияСвойств(Объект.ТоварыФакт.Добавить(), СтрокаРаспоряжение, "Номенклатура, Характеристика, Упаковка, ИдентификаторСтроки, КлючСвязиСерийныхНомеров, Цена");
			ЗаполнитьЗначенияСвойств(Объект.ТоварыФакт.Добавить(), СтрокаРаспоряжение, "Номенклатура, Характеристика, Упаковка, ИдентификаторСтроки, КлючСвязиСерийныхНомеров, Цена, Количество, КоличествоУпаковок");
			
		КонецЕсли;
		
	КонецЦикла;
КонецПроцедуры
