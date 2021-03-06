﻿Функция ЗагрузитьЭлементХМЛ(ОбъектXML, ИмяУзла, Параметры) Экспорт
	Перем СтрокаТовара;
	
	Параметры.Свойство("СтрокаТовара", СтрокаТовара);
	
	Если ИмяУзла = "ТоварКРаботе" Тогда
		
	ИначеЕсли ИмяУзла = "НомерИсходногоДокумента" Тогда
		ИсходныйДокумент = ЭлектронныеДокументы.ПолучитьСсылкуНаДокументПоДаннымИзXML(ОбъектXML, Документы.ИсходящийКаталогТоваров.ПустаяСсылка(), Параметры);
		
	ИначеЕсли ИмяУзла = "ДлительностьОжидания" Тогда
		ДлительностьОжиданияОтвета = ЭлектронныеДокументы.ПолучитьДлительностьЭлемента(ОбъектXML);
		
	ИначеЕсли ИмяУзла = "Товар" Тогда
			
		СтрокаТовара = Товары.Добавить();
		Параметры.Вставить("СтрокаТовара",СтрокаТовара);
			
	ИначеЕсли ИмяУзла = "ИдТовараКлиента" Тогда
			
		СтрокаТовара.ИдТовараКонтрагента = ЭлектронныеДокументы.ПолучитьТекстЭлементаХМЛ(ОбъектXML);
			
	ИначеЕсли   ИмяУзла = "ИдТовараПоставщика" Тогда
			
		Значение = ЭлектронныеДокументы.ПолучитьСсылкуЭлемента(ОбъектXML);		
		ЭлектронныеДокументы.ЗаполнитьНоменклатуруИХарактеристикуПоИдентификатору(СтрокаТовара, Значение, Параметры);
					
	ИначеЕсли ИмяУзла = "Наименование" Тогда
		СтрокаТовара.НаименованиеНоменклатурыКонтрагента = ЭлектронныеДокументы.ПолучитьТекстЭлементаХМЛ(ОбъектXML);
		
	ИначеЕсли   ИмяУзла = "КоэффициентПересчета" Тогда
		
		СтрокаТовара.КоэффициенПересчета = ЭлектронныеДокументы.ПолучитьЧислоЭлемента(ОбъектXML);
		Если СтрокаТовара.КоэффициентПересчета <> 1 Тогда
			
			ЭлектронныеДокументы.ДополинтьИнформациюДляСообщения(Параметры.ТекстОшибки, "Торговая система не поддерживает обмен каталогов с коэффициентом пересчета <> 1");
			
		КонецЕсли;
		
	ИначеЕсли ИмяУзла = "Примечание" Тогда
		СтрокаТовара.Примечание = ЭлектронныеДокументы.ПолучитьТекстЭлементаХМЛ(ОбъектXML);
		
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Процедура ПринятьКРаботе(Отказ) Экспорт
	
	Для каждого СтрокаДанных Из Товары Цикл
		Если Не ЗначениеЗаполнено(СтрокаДанных.Номенклатура) Тогда
			Продолжить;
		КонецЕсли;
		МенеджерЗаписи = РегистрыСведений.НоменклатураКонтрагентов.СоздатьМенеджерЗаписи();
			
		МенеджерЗаписи.Контрагент                          = Контрагент;
		МенеджерЗаписи.Номенклатура                        = СтрокаДанных.Номенклатура;
		МенеджерЗаписи.ХарактеристикаНоменклатуры          = СтрокаДанных.ХарактеристикаНоменклатуры;
		МенеджерЗаписи.КодНоменклатурыКонтрагента          = СтрокаДанных.ИдТовараКонтрагента;
		МенеджерЗаписи.НаименованиеНоменклатурыКонтрагента = СтрокаДанных.НаименованиеНоменклатурыКонтрагента;
			
		МенеджерЗаписи.ЕдиницаНоменклатурыКонтрагента      = СтрокаДанных.Номенклатура.БазоваяЕдиницаИзмерения;
			
		Попытка
			МенеджерЗаписи.Записать();
		Исключение
			ОбщегоНазначения.СообщитьОбОшибке(ОписаниеОшибки());
			Отказ = Истина;
			Возврат;
		КонецПопытки;
			
	КонецЦикла;
	
	Обработан = Истина;
	Попытка
		Записать();
	Исключение
		ОбщегоНазначения.СообщитьОбОшибке(ОписаниеОшибки());
		Отказ = Истина;
	КонецПопытки;	
	
КонецПроцедуры // () 