﻿
&После("ПередЗаписью")
Процедура ТБКПередЗаписью(Отказ)
	// Вставить содержимое метода.
	Попытка
		//прсингМарки = ШтрихкодированиеИСВызовСервера.РазобратьКодМаркировки(
		//	ЭтотОбъект.ЗначениеШтрихкода,
		//	Перечисления.ВидыПродукцииИС.Табачная
		//);
		
		МРЦПачки = ШтрихкодированиеМОТПКлиентСервер.МРЦКодаМаркировкиТабачнойПачки(ЭтотОбъект.ЗначениеШтрихкода);
		
		Если МРЦПачки = Неопределено Тогда
			МРЦБлока = ШтрихкодированиеМОТПКлиентСервер.МРЦКодаМаркировкиБлока(ЭтотОбъект.ЗначениеШтрихкода);
			Если МРЦБлока <> Неопределено Тогда
				мрц = МРЦБлока;
			КонецЕсли
		Иначе
			мрц = МРЦПачки;
		Конецесли;
		
		Если номенклатура.ВидНоменклатуры.ИспользоватьХарактеристики и мрц<>Неопределено Тогда
			ЭтотОбъект.Характеристика = Справочники.ШтрихкодыУпаковокТоваров.ПолучитьХарактеристику(
				номенклатура, 
				мрц
			);
		КонецЕсли;
	Исключение
	КонецПопытки;
	
КонецПроцедуры
