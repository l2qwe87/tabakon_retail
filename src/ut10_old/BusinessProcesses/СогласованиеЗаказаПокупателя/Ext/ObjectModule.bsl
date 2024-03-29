﻿
////////////////////////////////////////////////////////////////////////////////
//ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура выполняет принудительное завершение бизнес-процесса.
//
Процедура ВыполнитьЗавершениеБизнесПроцесса(НовоеСостояниеСогласования = Неопределено) Экспорт

	Запрос       = Новый Запрос;
	Запрос.УстановитьПараметр("БизнесПроцесс" , Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Задачи.Ссылка КАК ЗадачаПользователя
	|ИЗ
	|	Задача.ЗадачиПользователя КАК Задачи
	|ГДЕ
	|	Задачи.БизнесПроцесс = &БизнесПроцесс
	|	И Задачи.Выполнена = ЛОЖЬ";

	Выборка        = Запрос.Выполнить().Выбрать();
	РазмерВыборки  = Выборка.Количество();
	СчетчикВыборки = 0;

	НачатьТранзакцию();

	Пока Выборка.Следующий() Цикл

		#Если Клиент Тогда
		Состояние("Обработка:" + СчетчикВыборки + " из " + РазмерВыборки);
		#КонецЕсли

		СчетчикВыборки = СчетчикВыборки + 1;
		Попытка

			ЗадачаОбъект = Выборка.ЗадачаПользователя.ПолучитьОбъект();
			ЗадачаОбъект.Выполнена = Истина;
			ЗадачаОбъект.Записать();

		Исключение

			ВызватьИсключение "Ошибка при выполнении задачи:" + Строка(Выборка.ЗадачаПользователя)
								+ Символы.ПС + "По причине: " + ОписаниеОшибки();
		КонецПопытки;
	КонецЦикла;

	ДатаЗавершения        = ТекущаяДата();
	Завершен              = Истина;
	ЗавершенПринудительно = Истина;

	Если НовоеСостояниеСогласования <> Неопределено Тогда
		СостояниеСогласования = НовоеСостояниеСогласования;
	КонецЕсли;

	Попытка

		Записать();

	Исключение

		ВызватьИсключение "Ошибка при записи бизнес-процесса:" + Строка(Ссылка)
							+ Символы.ПС + "По причине: " + ОписаниеОшибки();
	КонецПопытки;

	ЗафиксироватьТранзакцию();

КонецПроцедуры // ВыполнитьЗавершениеБизнесПроцесса()

////////////////////////////////////////////////////////////////////////////////
//СЕРВИСНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура проверяет необходимость повторного согласования, вызывается из 
//обработчика проверки условия точки маршрута "ПовторноеСогласование".
//
Процедура ПроверитьНеобходимостьПовторногоСогласования(Результат)

	Результат = РаботаСБизнесПроцессами.ПолучитьРезультатВТочкеМаршрута(
			Ссылка,
			БизнесПроцессы.СогласованиеЗаказаПокупателя.ТочкиМаршрута.ОзнакомитьсяСРезультатами,
			Перечисления.РезультатыБизнесПроцессаСогласование.ПовторноеСогласование);

	Если Результат Тогда

		// Если повторное согласование - то обновим реквизит "СостояниеСогласования".
		СостояниеСогласования = Перечисления.СостояниеОбъектаСогласования.НаСогласовании;

		// Обновим номер цикла согласования.
		ОбновитьНомерЦиклаБизнесПроцесса();
		Записать();

	КонецЕсли;

КонецПроцедуры // ПроверитьНеобходимостьПовторногоСогласования()

// Процедура вызывается перед стартом бизнес-процесса для выполнения проверок и
//заполнения реквизитов.
//
Процедура ПередСтартомБизнесПроцесса(Отказ)

	Заголовок = "Старт бизнес-процесса:" + Ссылка;

	ПроверитьЗаполнениеРеквизитов(Отказ,Заголовок);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	ОбработатьСтартБизнесПроцесса();

	ОбновитьНомерЦиклаБизнесПроцесса();

КонецПроцедуры // ПередСтартомБизнесПроцесса()

// Процедура вызывается перед стартом бизнес-процесса для заполнения реквизитов.
//
Процедура ОбработатьСтартБизнесПроцесса()

	ДатаСтарта = ТекущаяДата();
	Если Инициатор.Пустая() Тогда
		Инициатор = ОбщегоНазначения.ПолучитьЗначениеПеременной("глТекущийПользователь");
	КонецЕсли;

	// Установим начальное состояние согласования.
	СостояниеСогласования = Перечисления.СостояниеОбъектаСогласования.НаСогласовании;

КонецПроцедуры // ОбработатьСтартБизнесПроцесса()

// Процедура проверяет заполнение обязательных реквизитов шапки бизнес-процесса.
//
// Параметры:
//  Отказ     - булево, отказ от выполняемого действия.
//  Заголовок - строка, заголовок сообщения в случае отказа.
//
Процедура ПроверитьЗаполнениеРеквизитов(Отказ,Заголовок)

	Если ОбъектСогласования.Пустая() Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не заполнено значение реквизита ""Заказ"".",
											Отказ, Заголовок);
	КонецЕсли;

	Если Настройка.Пустая() Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не заполнено значение реквизита ""Настройка "".",
											Отказ, Заголовок);
	КонецЕсли;

КонецПроцедуры // ПровертьЗаполнениеРеквизитов()

// Процедура устанавливает реквизиты бизнес-процесса перед завершением.
//
Процедура ОбработатьЗавершениеБизнесПроцесса()

	ДатаЗавершения = ТекущаяДата();

	// Если при завершении процесса состояние согласования не определено
	//то считаем объект не согласованным.
	Если Не (СостояниеСогласования = Перечисления.СостояниеОбъектаСогласования.Согласован
			Или СостояниеСогласования = Перечисления.СостояниеОбъектаСогласования.НеСогласован) Тогда

		СостояниеСогласования = Перечисления.СостояниеОбъектаСогласования.НеСогласован

	КонецЕсли;

КонецПроцедуры // ОбработатьЗавершениеБизнесПроцесса()

// Процедура обрабатывает результаты согласования объекта в точке маршрута.
//
// Параметры:
//  ТочкаМаршрута - ТочкаМаршрутаБизнесПроцесса.
//
Процедура ПодвестиИтогиСогласования(ТочкаМаршрута)

	ОбъектСогласован = РаботаСБизнесПроцессами.ПолучитьРезультатВТочкеМаршрута(Ссылка, ТочкаМаршрута);

	Если ОбъектСогласован Тогда
		ВремСостояниеСогласования = Перечисления.СостояниеОбъектаСогласования.Согласован;
	Иначе
		ВремСостояниеСогласования = Перечисления.СостояниеОбъектаСогласования.НеСогласован;
	КонецЕсли;

	Если СостояниеСогласования <> ВремСостояниеСогласования Тогда

		СостояниеСогласования = ВремСостояниеСогласования;
		Записать();

	КонецЕсли;

КонецПроцедуры // ПодвестиИтогиСогласования()

// Функция определяет необходимость автообработки результатов согласования (в случе, если
// точка маршрута "ПодвестиИтогиСогласования" не активна).
//
Функция НеобходимоВыполнитьАвтобработкуРезультатов()

	ВыборкаПараметры = РаботаСБизнесПроцессами.ПолучитьПараметрыТочкиМаршрута(
		Настройка,
		БизнесПроцессы.СогласованиеЗаказаПокупателя.ТочкиМаршрута.ПодвестиИтогиСогласования);

	Результат = Истина;

	Если ВыборкаПараметры.Следующий() Тогда
		Результат = Не ВыборкаПараметры.Выполнять;
	КонецЕсли;

	Возврат Результат;

КонецФункции // НеобходимоВыполнитьАвтобработкуРезультатов()

// Процедура формирует задачи в точках маршрута.Вызывается из обработчков события
//"ПередВыполненимЗадач" точек маршрута.
//
// Параметры:
//  ТочкаМаршрутаБизнесПроцесса - точка маршрута бизнес-процесса.
//  ФормируемыеЗадачи - массив, массив задач.
//  СтандартнаяОбработка - булево, признак отказа от стандартного механизма формирования задач.
//
Процедура СформироватьЗадачиТочкиМаршрута(ТочкаМаршрутаБизнесПроцесса,
											ФормируемыеЗадачи,
											СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	// Исполнителей нужно взять из настройки.
	Исполнители = РаботаСБизнесПроцессами.ПолучитьИсполнителейЗадачТочкиМаршрута(Настройка,
																ТочкаМаршрутаБизнесПроцесса);
	
	Если Исполнители.Количество()= 0 Тогда
		Возврат;
	КонецЕсли;

	ВыборкаПараметры= РаботаСБизнесПроцессами.ПолучитьПараметрыТочкиМаршрута(
							Настройка,
							ТочкаМаршрутаБизнесПроцесса);

	Выполнять = Ложь;
	Если ВыборкаПараметры.Следующий() Тогда
		Выполнять = ВыборкаПараметры.Выполнять;
	КонецЕсли;

	Если Не Выполнять Тогда
		Возврат;
	КонецЕсли;

	ПараметрыЗадач = РаботаСБизнесПроцессами.СформироватьПараметрыШапкиЗадач(ВыборкаПараметры);
	ПараметрыЗадач.Вставить("БизнесПроцесс", Ссылка);
	ПараметрыЗадач.Вставить("Объект",        ОбъектСогласования);
	ПараметрыЗадач.Вставить("ТочкаМаршрута", ТочкаМаршрутаБизнесПроцесса);

	Для Каждого Исполнитель Из Исполнители Цикл

		Если ТипЗнч(Исполнитель) = Тип("ПеречислениеСсылка.ВидыИсполнителейЗадач") Тогда

			ТекИсполнитель = Инициатор;
		Иначе
			ТекИсполнитель = Исполнитель;
		КонецЕсли;

		ПараметрыЗадач.Вставить("Исполнитель", ТекИсполнитель);
		ФормируемыеЗадачи.Добавить(
				РаботаСБизнесПроцессами.УстановитьПараметрыЗадачи(ПараметрыЗадач));

	КонецЦикла;

КонецПроцедуры // СформироватьЗадачиТочкиМаршрута()

// Процедура обновляет номер цикла согласования.
//
Процедура ОбновитьНомерЦиклаБизнесПроцесса()

	НомерЦикла = НомерЦикла + 1;

КонецПроцедуры // ОбновитьНомерЦиклаБизнесПроцесса()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ  ОБРАБОТКИ СОБЫТИЙ ТОЧЕК МАРШРУТА

// Процедура - обработчик события "ПередСтартом" точки маршрута "Старт".
//
Процедура НачатьСогласованиеПередСтартом(ТочкаМаршрутаБизнесПроцесса, Отказ)

	ПередСтартомБизнесПроцесса(Отказ);

КонецПроцедуры // НачатьСогласованиеПередСтартом()

//Процедура - обработчик события "ПередСозданиемЗадач" точки маршрута "Согласовать".
//
Процедура СогласоватьПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса,
										ФормируемыеЗадачи,
										СтандартнаяОбработка)

	СформироватьЗадачиТочкиМаршрута(ТочкаМаршрутаБизнесПроцесса,
							ФормируемыеЗадачи, СтандартнаяОбработка);

КонецПроцедуры // СогласоватьПередСозданиемЗадач()

// Процедура - обработчик события "ПриВыполнении" точки маршрута "Согласовать".
//
Процедура СогласоватьПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)

	//Если есть необходимость обработать результаты согласования.
	Если Не НеобходимоВыполнитьАвтобработкуРезультатов() Тогда
		Возврат;
	КонецЕсли;

	ПодвестиИтогиСогласования(ТочкаМаршрутаБизнесПроцесса);

КонецПроцедуры // СогласоватьПриВыполнении()

// Процедура - обработчик события "ПередСозданиемЗадач" точки маршрута "ПодвестиИтогиСогласования".
//
Процедура ПодвестиИтогиСогласованияПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса,
														ФормируемыеЗадачи,
														СтандартнаяОбработка)

	СформироватьЗадачиТочкиМаршрута(ТочкаМаршрутаБизнесПроцесса,
									ФормируемыеЗадачи, 
									СтандартнаяОбработка);

КонецПроцедуры // ПодвестиИтогиСогласованияПередСозданиемЗадач()

// Процедура - обработчик события "ПриВыполнении" точки маршрута "ПодвестиИтогиСогласования".
//
Процедура ПодвестиИтогиСогласованияПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)

	ПодвестиИтогиСогласования(ТочкаМаршрутаБизнесПроцесса);

КонецПроцедуры // ПодвестиИтогиСогласованияПриВыполнении()

// Процедура - обработчик события "ПроверкаУсловия" точки маршрута "Согласовано".
//
Процедура СогласованоПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)

	Результат = (СостояниеСогласования = Перечисления.СостояниеОбъектаСогласования.Согласован);

КонецПроцедуры // СогласованоПроверкаУсловия()

// Процедура - обработчик события "ПередСозданиемЗадач" точки маршрута "ОзнакомитьсяСРезультатами".
//
Процедура ОзнакомитьсяСРезультатамиПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса,
														ФормируемыеЗадачи,
														СтандартнаяОбработка)

	СформироватьЗадачиТочкиМаршрута(ТочкаМаршрутаБизнесПроцесса,
									ФормируемыеЗадачи,
									СтандартнаяОбработка);

КонецПроцедуры // ОзнакомитьсяСРезультатамиПередСозданиемЗадач()

// Процедура - обработчик события "ПроверкаУсловия" точки маршрута "ПовторноеСогласование".
//
Процедура ПовторноеСогласованиеПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)

	ПроверитьНеобходимостьПовторногоСогласования(Результат);

КонецПроцедуры // ОзнакомитьсяСРезультатамиПриВыполнении()

// Процедура - обработчик события "ПередСозданиемЗадач" точки маршрута "НачатьВыполнениеЗаказа".
//
Процедура НачатьВыполнениеЗаказаПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса,
													ФормируемыеЗадачи,
													СтандартнаяОбработка)

	СформироватьЗадачиТочкиМаршрута(ТочкаМаршрутаБизнесПроцесса,
									ФормируемыеЗадачи,
									СтандартнаяОбработка);

КонецПроцедуры // НачатьВыполнениеЗаказаПередСозданиемЗадач()

// Процедура - обработчик события "ПриЗавершении" точки маршрута "ЗаказСогласован".
//
Процедура ЗаказСогласованПриЗавершении(ТочкаМаршрутаБизнесПроцесса, Отказ)

	ОбработатьЗавершениеБизнесПроцесса();

КонецПроцедуры // ЗаказСогласованПриЗавершении()

// Процедура - обработчик события "ПриЗавершении" точки маршрута "ЗаказНеСогласован".
//
Процедура ЗаказНеСогласованПриЗавершении(ТочкаМаршрутаБизнесПроцесса, Отказ)

	ОбработатьЗавершениеБизнесПроцесса()

КонецПроцедуры // ЗаказНеСогласованПриЗавершении()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБРАБОТКИ СОБЫТИЙ ОБЪЕКТА

// Процедура - обработчик события "ПриКопировании".
//
Процедура ПриКопировании(ОбъектКопирования)

	ДатаСтарта            = Дата(1, 1, 1);
	НомерЦикла            = 0;
	ДатаЗавершения        = Дата(1 ,1 ,1);
	ЗавершенПринудительно = Ложь;
	СостояниеСогласования = Перечисления.СостояниеОбъектаСогласования.ПустаяСсылка();
	
КонецПроцедуры // ПриКопировании()

// Процедура - обработчик события "ВводНаОсновании".
//
Процедура ОбработкаЗаполнения(Основание)

	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
		ОбъектСогласования = Основание.Ссылка;
	КонецЕсли;

КонецПроцедуры // ОбработкаЗаполнения()
