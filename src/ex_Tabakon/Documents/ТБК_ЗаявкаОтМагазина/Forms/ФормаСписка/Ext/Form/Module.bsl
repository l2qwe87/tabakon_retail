﻿
&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	ТекСтрока = Элементы.Список.ТекущиеДанные;
	Если ТекСтрока <> Неопределено Тогда
		Если ТекСтрока.ПризнакОбновление = 0 тогда
			УбратьПризнакСервер(ТекСтрока.Номер, ТекСтрока.Дата);
			Элементы.Список.Обновить();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСерверебезКонтекста
Процедура УбратьПризнакСервер(Номер,Дата)
	Об	=	Документы.ТБК_ЗаявкаОтМагазина.НайтиПоНомеру(Номер,дата).ПолучитьОбъект();
	Об.ПризнакОбновление	=	1;
	Об.Записать();	
КонецПроцедуры

&НаКлиенте
Процедура Инструкция(Команда)
	ОбщегоНазначенияВызовСервера.ОткрытьНужнуюИнструкцию("Заявка на возврат товара");		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,"Статус",,ВидСравненияКомпоновкиДанных.Содержит,,,РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//Марк 2024-02-21
	//Условгное фомормление Возврат (Собирать) интернет-магазин
	попытка
		ссылка_проект_собирать_интернет_магазин = Справочники.ТБКПроекты.НайтиПоНаименованию("Возврат (Собирать) интернет-магазин");
		этаформа.УсловноеОформление.Элементы[2].Отбор.Элементы[0].Элементы[1].ПравоеЗначение = ссылка_проект_собирать_интернет_магазин;;
		этаформа.УсловноеОформление.Элементы[3].Отбор.Элементы[0].Элементы[1].ПравоеЗначение = ссылка_проект_собирать_интернет_магазин;;
		этаформа.УсловноеОформление.Элементы[4].Отбор.Элементы[0].Элементы[1].ПравоеЗначение = ссылка_проект_собирать_интернет_магазин;;
		этаформа.УсловноеОформление.Элементы[5].Отбор.Элементы[0].Элементы[1].ПравоеЗначение = ссылка_проект_собирать_интернет_магазин;;
		этаформа.УсловноеОформление.Элементы[6].Отбор.Элементы[0].Элементы[1].ПравоеЗначение = ссылка_проект_собирать_интернет_магазин;;
	Исключение
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Ошибка: Условное оформление на проект Возврат (Собирать) интернет-магазин";
		Сообщение.Сообщить(); 	
	КонецПопытки;
	//КонецМарк
КонецПроцедуры
