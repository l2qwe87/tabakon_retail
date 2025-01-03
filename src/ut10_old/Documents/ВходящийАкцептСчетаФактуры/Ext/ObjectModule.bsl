﻿
Функция ЗагрузитьЭлементХМЛ(ОбъектXML, ИмяУзла, Параметры) Экспорт
	Перем СтрокаТовара, ТипНалога, ВалютаСтрок;
	
	Параметры.Свойство("СтрокаТовара", СтрокаТовара);
	Параметры.Свойство("ТипНалога", ТипНалога);
	
	Если ИмяУзла = "АкцептСчетФактура" Тогда
		Обработан = Ложь;
		
	ИначеЕсли ИмяУзла = "НомерИсходногоДокумента" Тогда
		ИсходныйДокумент = ЭлектронныеДокументы.ПолучитьСсылкуНаДокументПоДаннымИзXML(ОбъектXML, Документы.ИсходящийЗаказ.ПустаяСсылка(), Параметры);
		УчетныйДокумент  = ИсходныйДокумент.УчетныйДокумент;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

