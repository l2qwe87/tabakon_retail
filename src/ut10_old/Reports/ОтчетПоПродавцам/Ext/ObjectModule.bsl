﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	Настройки = КомпоновщикНастроек.Настройки;
	ДатаНачО = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДатаНач"));
	ДатаНачО.Использование = Истина;
	ДатаНачО.Значение = ДатаНач;
	    
	ДатаКонО = настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДатаКон"));
	ДатаКонО.Использование = Истина;
	ДатаКонО.Значение = ДатаКон;
	
	
	КомпоновщикНастроек.Настройки.Отбор.Элементы[0].ПравоеЗначение = Склад;
	КомпоновщикНастроек.Настройки.Отбор.Элементы[0].Использование  = ЗначениеЗаполнено(Склад);
	
	КомпоновщикНастроек.Настройки.Отбор.Элементы[1].ПравоеЗначение = Продавец;
	КомпоновщикНастроек.Настройки.Отбор.Элементы[1].Использование  = ЗначениеЗаполнено(Продавец);
	
	КомпоновщикНастроек.Настройки.Отбор.Элементы[2].ПравоеЗначение = Админ;
	КомпоновщикНастроек.Настройки.Отбор.Элементы[2].Использование  = ЗначениеЗаполнено(Админ);

	
КонецПроцедуры
