﻿
&Вместо("ОткрытьФормуСчитыванияКодаМаркировки")
Процедура ТБКОткрытьФормуСчитыванияКодаМаркировки(ФормаВладелец, ПараметрыОткрытия, ОповещениеОЗавершении)
	Если Не ПараметрыОткрытия.МаркируемаяПродукция Тогда
		
		ПоказатьПредупреждение(
			Неопределено, НСтр("ru = 'Для данной строки не указываются акцизные марки'"));
		
		Возврат;
	КонецЕсли;
	
	Если ОповещениеОЗавершении = Неопределено Тогда
		ОповещениеОЗавершении = Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ФормаВладелец, ОповещениеОЗавершении);
	КонецЕсли;
	
	Если ПараметрыОткрытия.ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Алкогольная") Тогда

		ОткрытьФорму(
			"Обработка.РаботаСАкцизнымиМаркамиЕГАИС.Форма.ФормаВводаАкцизнойМарки",
			ПараметрыОткрытия, ФормаВладелец,,,,ОповещениеОЗавершении);
			
	ИначеЕсли ПараметрыОткрытия.ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Табачная") Тогда
		//Марк
		НоменклатураБК	=	ОбщегоНазначенияВызовСервера.ПолучитьНоменклатураБК(ПараметрыОткрытия.Номенклатура);
		Если не НоменклатураБК.Пустая() Тогда
			ПараметрыОткрытия.Вставить("НоменклатураБК", НоменклатураБК); 
		    ОткрытьФорму(
			"Обработка.РМКУправляемыйРежим.Форма.ТБКФормаБыстрыйПодборПоБК",       
			ПараметрыОткрытия, ФормаВладелец);
		иначе 
		//МаркКонец	
			ОткрытьФорму(
			"Обработка.ПроверкаИПодборТабачнойПродукцииМОТП.Форма.ФормаВводаКодаМаркировки",
			ПараметрыОткрытия, ФормаВладелец,,,,ОповещениеОЗавершении);	
		КонецЕсли;
			
	ИначеЕсли ПараметрыОткрытия.ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Обувная") Тогда
			
		ОткрытьФорму(
			"Обработка.ПроверкаИПодборПродукцииИСМП.Форма.ФормаВводаКодаМаркировки",
			ПараметрыОткрытия, ФормаВладелец,,,,ОповещениеОЗавершении);
			
	КонецЕсли;
	//ПродолжитьВызов(ФормаВладелец, ПараметрыОткрытия, ОповещениеОЗавершении);
КонецПроцедуры

&Вместо("УточнитьДанныеУПользователя")
Процедура ТБКУточнитьДанныеУПользователя(ФормаВладелец, ПараметрыОткрытияФормы, ОповещениеПовторнойОбработки)
	Если ПараметрыОткрытияФормы.Операция = "СопоставлениеНоменклатуры" Тогда
		
		ШтрихкодыКСопоставлению = ПараметрыОткрытияФормы.ДанныеДляУточненияСведенийПользователя.ШтрихкодыКСопоставлению;
		ИсходныеДанные          = ПараметрыОткрытияФормы.ДанныеДляУточненияСведенийПользователя.ИсходныеДанные;
		ПараметрыСканирования   = ПараметрыОткрытияФормы.ДанныеДляУточненияСведенийПользователя.ПараметрыСканирования;
		
		ДополнительныеПараметры = Новый Структура("ОповещениеПовторнойОбработки, ИсходныеДанные, ПараметрыСканирования",
		ОповещениеПовторнойОбработки, ИсходныеДанные, ПараметрыСканирования);
		ОповещениеОЗавершенииСопоставления = Новый ОписаниеОповещения("СопоставлениеНоменклатурыШтрихкодамЗавершение", ШтрихкодированиеИСКлиент, ДополнительныеПараметры);
		ШтрихкодированиеИСКлиентПереопределяемый.ОткрытьФормуПодбораНоменклатурыПоШтрихкодам(
		ШтрихкодыКСопоставлению, ФормаВладелец, ОповещениеОЗавершенииСопоставления);
		
	ИначеЕсли ПараметрыОткрытияФормы.Операция = "ОткрытьФормуВводаКодаМаркировки" Тогда
		
		ОткрытьФормуСчитыванияКодаМаркировки(ФормаВладелец, ПараметрыОткрытияФормы.ДанныеДляУточненияСведенийПользователя, ОповещениеПовторнойОбработки);
		
	Иначе
		
		Если СтрДлина(ПараметрыОткрытияФормы.ШтрихкодEAN) <=13 И СтрДлина(ПараметрыОткрытияФормы.ШтрихкодEAN) >= 8 
			И ПараметрыОткрытияФормы.Номенклатура.Количество() > 0 Тогда

			ПараметрыОткрытияФормы.Номенклатура = ПараметрыОткрытияФормы.Номенклатура[0];
			
			НоменклатураБК	=	ОбщегоНазначенияВызовСервера.ПолучитьНоменклатураБК(ПараметрыОткрытияФормы.Номенклатура);
			Если Не НоменклатураБК.Пустая() Тогда
				
				ПараметрыОткрытияФормы.Вставить("НоменклатураБК", НоменклатураБК);
				
				РежимОткрытия = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
				ОткрытьФорму("Обработка.РМКУправляемыйРежим.Форма.ТБКФормаБыстрыйПодборПоБК", 
				ПараметрыОткрытияФормы, ФормаВладелец)
				
			КонецЕсли;
		Иначе
			РежимОткрытия = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
			ОткрытьФорму(
			"ОбщаяФорма.ФормаУточненияДанныхИС", ПараметрыОткрытияФормы, ФормаВладелец,,,, ОповещениеПовторнойОбработки, РежимОткрытия);
			
		КонецЕсли;
	КонецЕсли;
	//ПродолжитьВызов(ФормаВладелец, ПараметрыОткрытияФормы, ОповещениеПовторнойОбработки);
КонецПроцедуры
