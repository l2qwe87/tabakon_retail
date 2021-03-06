﻿
// Записывает версию объекта в регистр сведений
Процедура ЗаписатьВерсиюОбъекта(знач СсылкаНаОбъект,
                                знач ЧислоВерсийОбъекта = Неопределено,
                                знач ХранилищеДанных) Экспорт
	
	// Получим версию последнего объекта этого типа хранящегося в регистре сведений
	Если ЧислоВерсийОбъекта = Неопределено Тогда 
		НомерВерсии = ПолучитьЧислоВерсийОбъекта(СсылкаНаОбъект);
	Иначе
		НомерВерсии = ЧислоВерсийОбъекта;
	КонецЕсли;
	
	// Увеличиваем номер версии на 1
	НомерВерсии = Число(НомерВерсии) + 1;
	
	ДатаИзменения = ТекущаяДата();
	
	ВерсииОбъектов = РегистрыСведений.ВерсииОбъектов;
	
	МенеджерЗаписиИИО = ВерсииОбъектов.СоздатьМенеджерЗаписи();
	МенеджерЗаписиИИО.Объект        = СсылкаНаОбъект;
	МенеджерЗаписиИИО.ДатаВерсии    = ДатаИзменения;
	МенеджерЗаписиИИО.ВерсияОбъекта = ХранилищеДанных;
	МенеджерЗаписиИИО.НомерВерсии	= НомерВерсии;
	МенеджерЗаписиИИО.АвторВерсии	= ПараметрыСеанса.ТекущийПользователь;
	МенеджерЗаписиИИО.Сжато         = Ложь;
	Попытка
		МенеджерЗаписиИИО.Записать();
	Исключение
		ВызватьИсключение "Ошибка записи версии объекта: " + ОписаниеОшибки();
	КонецПопытки;
	
КонецПроцедуры

Процедура ВыполнитьСжатиеВерсийОбъектовПоРегламентномуЗаданию() Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ Объект,  НомерВерсии, ВерсияОбъекта 
	                | ИЗ РегистрСведений.ВерсииОбъектов 
	                | ГДЕ Сжато = Ложь";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ДвоичныеДанные = Выборка.ВерсияОбъекта.Получить();
		ХранилищеДанныхFastInfoSet = Новый ХранилищеЗначения(ДвоичныеДанные, Новый СжатиеДанных(9));
		ВерсииОбъектов = РегистрыСведений.ВерсииОбъектов;
		
		МенеджерЗаписиИИО = ВерсииОбъектов.СоздатьМенеджерЗаписи();
		МенеджерЗаписиИИО.Объект       = Выборка.Объект;
		МенеджерЗаписиИИО.НомерВерсии  = Выборка.НомерВерсии;
		
		МенеджерЗаписиИИО.Прочитать();
		МенеджерЗаписиИИО.ВерсияОбъекта = ХранилищеДанныхFastInfoSet;
		МенеджерЗаписиИИО.Сжато = Истина;
		МенеджерЗаписиИИО.Записать();
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьЧислоВерсийОбъекта(знач Ссылка) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	| ВЫБРАТЬ ЕСТЬNULL(Максимум(НомерВерсии), 0) КАК НомерВерсии
	| ИЗ РегистрСведений.ВерсииОбъектов
	| ГДЕ Объект=&Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	НомерВерсии = Выборка.НомерВерсии;
	
	Возврат НомерВерсии;
	
КонецФункции
