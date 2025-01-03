﻿// Выполняет проверку разницы времени с сервером приложения.
//
// Возвращаемое значение:
//   Булево   - Истина, если проверка завершилась успешно.
//              Ложь, если работа программы завершается.
//
Функция ВыполнитьПроверку() Экспорт

	Если ОпределитьЭтаИнформационнаяБазаФайловая() Тогда
		Возврат Истина;
	КонецЕсли; 
	
	Если НЕ Константы.ПроверятьРазницуВоВремениССервером.Получить() Тогда
		Возврат Истина;
	КонецЕсли;

	Запрос = Новый Запрос();
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	НастройкиПользователей.Значение КАК Значение
	|ИЗ
	|	РегистрСведений.НастройкиПользователей КАК НастройкиПользователей
	|ГДЕ
	|	НастройкиПользователей.Пользователь = &Пользователь
	|	И НастройкиПользователей.Настройка = ЗНАЧЕНИЕ(ПланВидовХарактеристик.НастройкиПользователей.ПредупреждатьОРазницеВремениССервером)
	|";
	Запрос.УстановитьПараметр("Пользователь", глЗначениеПеременной("глТекущийПользователь"));
	РезультатЗапроса = Запрос.Выполнить();
	ПропуститьПроверку = Неопределено;
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ВыборкаЗапросаНастройкиПользователей = РезультатЗапроса.Выбрать();
		ВыборкаЗапросаНастройкиПользователей.Следующий();
		ПропуститьПроверку = НЕ ВыборкаЗапросаНастройкиПользователей.Значение;
	КонецЕсли;

	Если ПропуститьПроверку = Истина Тогда
		Возврат Истина;
	КонецЕсли; 
	
	ВремяНаКлиенте = ТекущаяДата();
	ВремяНаСервере = ПроверкаРазницыВремени.ТекущаяДатаСервера();
	РазницаВремени = ВремяНаСервере - ВремяНаКлиенте;
	ПредельнаяРазница = 15 * 60; // 15 минут
	Если РазницаВремени < ПредельнаяРазница И РазницаВремени > -ПредельнаяРазница Тогда
		Возврат Истина;
	КонецЕсли; 
	Форма = Обработки.ПредупреждениеОРазницеВоВремениССервером.ПолучитьФорму();
	Форма.ВремяНаСервере = ВремяНаСервере;
	Форма.ВремяНаКлиенте = ВремяНаКлиенте;
	Результат = Форма.ОткрытьМодально();
	Если Результат <> Истина Тогда
		ЗавершитьРаботуСистемы(Ложь);
		Возврат Ложь;
	КонецЕсли; 
	Возврат Истина;

КонецФункции 
 