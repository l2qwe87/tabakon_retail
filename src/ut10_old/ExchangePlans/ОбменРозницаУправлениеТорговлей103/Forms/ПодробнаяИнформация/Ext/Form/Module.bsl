﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Макет = ПланыОбмена.ОбменРозницаУправлениеТорговлей103.ПолучитьМакет("ПодробнаяИнформация");
	ПолеHTMLДокумента = Макет.ПолучитьТекст();
	
	Заголовок = НСтр("ru = 'Информация о синхронизации данных конфигураций Управление торговлей ред. 10.3 и Бухгалтерия Предприятия ред. 3'");

КонецПроцедуры
