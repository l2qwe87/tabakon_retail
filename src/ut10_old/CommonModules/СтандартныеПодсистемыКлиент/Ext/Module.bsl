﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Устанавливает заголовок главного окна приложения, используя представление текущего пользователя,
// значение константы ЗаголовокПриложения и заголовок приложения по умолчанию.
//
// Параметры:
//   ПриЗапуске - Булево - Истина, если вызывается при начале работы программы.
//
Процедура УстановитьРасширенныйЗаголовокПриложения(ПриЗапуске = Ложь) Экспорт
	
	ПараметрыКлиента = ?(ПриЗапуске, СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске(),
		СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента());
		
	Если ПараметрыКлиента.ДоступноИспользованиеРазделенныхДанных Тогда
		ПредставлениеЗаголовка = ПараметрыКлиента.ЗаголовокПриложения;
		ПредставлениеПользователя = ПараметрыКлиента.ПредставлениеПользователя;
		ПредставлениеКонфигурации = ПараметрыКлиента.ПодробнаяИнформация;
		
		Если ПустаяСтрока(СокрЛП(ПредставлениеЗаголовка)) Тогда
			Если ПараметрыКлиента.Свойство("ПредставлениеОбластиДанных") Тогда
				ШаблонЗаголовка = "%1 / %2 / %3";
				ЗаголовокПриложения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонЗаголовка, 
					ПараметрыКлиента.ПредставлениеОбластиДанных, ПредставлениеКонфигурации, 
					ПредставлениеПользователя);
			Иначе
				ШаблонЗаголовка = "%1 / %2";
				ЗаголовокПриложения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонЗаголовка, 
					ПредставлениеКонфигурации, ПредставлениеПользователя);
			КонецЕсли;
		Иначе
			ШаблонЗаголовка = "%1 / %2 / %3";
			ЗаголовокПриложения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонЗаголовка, 
				СокрЛП(ПредставлениеЗаголовка), ПредставлениеПользователя, ПредставлениеКонфигурации);
		КонецЕсли;
		
		УстановитьЗаголовокПриложения(ЗаголовокПриложения);
	Иначе
		ШаблонЗаголовка = "%1 / %2";
		ЗаголовокПриложения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонЗаголовка, 
			НСтр("ru = 'Не установлены разделители'"), ПараметрыКлиента.ПодробнаяИнформация);
		
		УстановитьЗаголовокПриложения(ЗаголовокПриложения);
	КонецЕсли;
	
КонецПроцедуры

// Отключает выдачу предупреждения пользователю при завершении работы программы.
//
Процедура ПропуститьПредупреждениеПередЗавершениемРаботыСистемы() Экспорт
	
	ПропуститьПредупреждениеПередЗавершениемРаботыСистемы = Истина;
	
КонецПроцедуры

// Вызывает форму вопроса.
//
//  Параметры и возвращаемое значение совместимы с функцией глобального контекста "Вопрос" со следующими дополнениями:
//
//      Кнопки - может принимать значение типа "СписокЗначений", в котором:
//               Значение – содержит значение, связанное с 
//                  кнопкой и возвращаемое при выборе кнопки. В качестве значения может использоваться значение 
//                  перечисления КодВозвратаДиалога, а также другие значения, поддерживающее XDTO сериализацию.
//               Представление – задает текст кнопки.
//
//      БольшеНеЗадаватьЭтотВопрос (Булево) - принимает значение, выбранное пользователем в соответствующим 
//                                            флажке диалога.
//
//      ПредлагатьБольшеНеЗадаватьЭтотВопрос (Булево) - флаг того, что пользователю надо предлагать вариант.
//
Функция ВопросПользователю(ТекстСообщения, Кнопки, Таймаут = 0, КнопкаПоУмолчанию = Неопределено, Заголовок = "", КнопкаТаймаута = Неопределено,
	БольшеНеЗадаватьЭтотВопрос = Ложь, ПредлагатьБольшеНеЗадаватьЭтотВопрос=Истина) Экспорт
	
	БольшеНеЗадаватьЭтотВопрос = Ложь;
	
	Параметры = Новый Структура;
	
	Если ТипЗнч(Кнопки) = Тип("РежимДиалогаВопрос") Тогда
		Если      Кнопки = РежимДиалогаВопрос.ДаНет Тогда
			КнопкиПараметр = "РежимДиалогаВопрос.ДаНет";
		ИначеЕсли Кнопки = РежимДиалогаВопрос.ДаНетОтмена Тогда
			КнопкиПараметр = "РежимДиалогаВопрос.ДаНетОтмена";
		ИначеЕсли Кнопки = РежимДиалогаВопрос.ОК Тогда
			КнопкиПараметр = "РежимДиалогаВопрос.ОК";
		ИначеЕсли Кнопки = РежимДиалогаВопрос.ОКОтмена Тогда
			КнопкиПараметр = "РежимДиалогаВопрос.ОКОтмена";
		ИначеЕсли Кнопки = РежимДиалогаВопрос.ПовторитьОтмена Тогда
			КнопкиПараметр = "РежимДиалогаВопрос.ПовторитьОтмена";
		ИначеЕсли Кнопки = РежимДиалогаВопрос.ПрерватьПовторитьПропустить Тогда
			КнопкиПараметр = "РежимДиалогаВопрос.ПрерватьПовторитьПропустить";
		КонецЕсли;
	Иначе
		КнопкиПараметр = Кнопки;
	КонецЕсли;
	
	Если ТипЗнч(КнопкаПоУмолчанию) = Тип("КодВозвратаДиалога") Тогда
		КнопкаПоУмолчаниюПараметр = КодВозвратаДиалогаВСтроку(КнопкаПоУмолчанию);
	Иначе
		КнопкаПоУмолчаниюПараметр = КнопкаПоУмолчанию;
	КонецЕсли;
	
	Если ТипЗнч(КнопкаТаймаута) = Тип("КодВозвратаДиалога") Тогда
		КнопкаТаймаутаПараметр = КодВозвратаДиалогаВСтроку(КнопкаТаймаута);
	Иначе
		КнопкаТаймаутаПараметр = КнопкаТаймаута;
	КонецЕсли;
	
	Параметры.Вставить("Кнопки",            КнопкиПараметр);
	Параметры.Вставить("Таймаут",           Таймаут);
	Параметры.Вставить("КнопкаПоУмолчанию", КнопкаПоУмолчаниюПараметр);
	Параметры.Вставить("Заголовок",         Заголовок);
	Параметры.Вставить("КнопкаТаймаута",    КнопкаТаймаутаПараметр);
	Параметры.Вставить("ТекстСообщения",    ТекстСообщения);
	
	Параметры.Вставить("ПредлагатьБольшеНеЗадаватьЭтотВопрос", ПредлагатьБольшеНеЗадаватьЭтотВопрос);
	
	Результат = ОткрытьФормуМодально("ОбщаяФорма.Вопрос", Параметры);
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		БольшеНеЗадаватьЭтотВопрос = Результат.БольшеНеЗадаватьЭтотВопрос;
		Возврат Результат.Значение;
	Иначе
		Возврат КодВозвратаДиалога.Отмена;
	КонецЕсли;
	
КонецФункции

// Возвращает структуру параметров, необходимых для работы
// конфигурации на клиенте при завершении, т.е. в обработчиках событий
// - ПередЗавершениемРаботыСистемы,
// - ПриЗавершенииРаботыСистемы
// 
// Возвращаемое значение:
//   ФиксированнаяСтруктура - структура параметров работы клиента при завершении.
//
Функция ПараметрыРаботыКлиентаПриЗавершении() Экспорт
	
	Если ПараметрыРаботыКлиентаПриЗавершении = Неопределено Тогда
		ПараметрыРаботыКлиентаПриЗавершении = СтандартныеПодсистемыВызовСервера.ПараметрыРаботыКлиентаПриЗавершении();
	КонецЕсли;
	
	Возврат ПараметрыРаботыКлиентаПриЗавершении;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// Обработка результата выполнения

// Выводит результат выполнения какой-либо операции.
//
// Параметры:
//   ЭтаФорма (УправляемаяФорма) Форма, для которой требуется вывод.
//   Результат (Структура) Результат выполнения операции, который необходимо вывести.
//       |- ВыводОповещения (Структура)
//           |- Использование (Булево) Выводить оповещение.
//           |- Заголовок     (Строка)
//           |- Ссылка        (Строка) Навигационная гиперссылка.
//           |- Текст         (Строка)
//           |- Картинка      (Картинка)
//       |- ВыводСообщения (Структура)
//           |- Использование       (Булево) Выводить сообщение.
//           |- Текст               (Строка)
//           |- ПутьКРеквизитуФормы (Строка) Путь к реквизиту формы, к которому относится сообщение.
//       |- ВыводПредупреждения (Структура)
//           |- Использование       (Булево) Выводить предупреждение.
//           |- Текст               (Строка)
//           |- ТекстОшибок         (Строка) Необязательный. Тексты ошибок, которые при желании может просмотреть пользователь.
//           |- ПутьКРеквизитуФормы (Строка) Необязательный. Путь к реквизиту формы, значение которого вызывало ошибку.
//       |- ОповещениеФорм (Структура) см. справку к методу глобального контекста Оповестить().
//           |- Использование (Булево) Оповещать открытые формы.
//           |- ИмяСобытия    (Строка) Имя события, которое используется для первичной идентификации сообщений принимающими формами.
//           |- Параметр      (*) Набор данных, которые используются принимающей формой для обновления состава.
//           |- Источник      (*) Источник оповещения, например форма-источником.
//       |- ОповещениеДинамическихСписков (Структура) см. справку к методу глобального контекста ОповеститьОбИзменении().
//           |- Использование (Булево) Оповещать динамические списки.
//           |- СсылкаИлиТип  (*) Ссылка, тип, или массив типов, которые необходимо обновить.
//
// Описание:
//   Предназначен только для отображения результата работы сервера на клиенте,
//     не предназначен для отображения промежуточных стадий - диалогов и т.п..
//
// См. также:
//   СтандартныеПодсистемыКлиентСервер.НовыйРезультатВыполнения()
//   СтандартныеПодсистемыКлиентСервер.ПодготовитьОповещениеДинамическихСписков()
//
Процедура ПоказатьРезультатВыполнения(ЭтаФорма, Результат) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") И ТипЗнч(Результат) <> Тип("ФиксированнаяСтруктура") Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Свойство("ВыводОповещения") И Результат.ВыводОповещения.Использование Тогда
		Оповещение = Результат.ВыводОповещения;
		ПоказатьОповещениеПользователя(Оповещение.Заголовок, Оповещение.Ссылка, Оповещение.Текст, Оповещение.Картинка);
	КонецЕсли;
	
	Если Результат.Свойство("ВыводСообщения") И Результат.ВыводСообщения.Использование Тогда
		Сообщение = Новый СообщениеПользователю;
		Если ТипЗнч(ЭтаФорма) = Тип("УправляемаяФорма") Тогда
			Сообщение.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
		КонецЕсли;
		Сообщение.Текст = Результат.ВыводСообщения.Текст;
		Сообщение.Поле  = Результат.ВыводСообщения.ПутьКРеквизитуФормы;
		Сообщение.Сообщить();
	КонецЕсли;
	
	Если Результат.Свойство("ВыводПредупреждения") И Результат.ВыводПредупреждения.Использование Тогда
		Если ЗначениеЗаполнено(Результат.ВыводПредупреждения.ТекстОшибок) Тогда
			Кнопки = Новый СписокЗначений;
			Кнопки.Добавить(1, НСтр("ru = 'Показать ошибки'"));
			
			Если ТипЗнч(ЭтаФорма) = Тип("УправляемаяФорма") И ЗначениеЗаполнено(Результат.ВыводПредупреждения.ПутьКРеквизитуФормы) Тогда
				Кнопки.Добавить(2, НСтр("ru = 'Перейти к реквизиту'"));
			КонецЕсли;
			
			Кнопки.Добавить(0, НСтр("ru = 'Продолжить'"));
			
			Ответ = Вопрос(Результат.ВыводПредупреждения.Текст, Кнопки, , 1);
			
			Если Ответ = 1 Тогда
				
				ЗаголовокДокумента = Результат.ВыводПредупреждения.Текст;
				ЗаголовокДокумента = СтрЗаменить(ЗаголовокДокумента, Символы.ПС, "; ");
				Если СтрДлина(ЗаголовокДокумента) > 75 Тогда
					ЗаголовокДокумента = Лев(ЗаголовокДокумента, 72) + "...";
				КонецЕсли;
				
				ТекстовыйДокумент = Новый ТекстовыйДокумент;
				ТекстовыйДокумент.УстановитьТекст(Результат.ВыводПредупреждения.ТекстОшибок);
				ТекстовыйДокумент.Показать(ЗаголовокДокумента);
				
			ИначеЕсли Ответ = 2 Тогда
				
				Сообщение = Новый СообщениеПользователю;
				Сообщение.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
				Сообщение.Текст = Результат.ВыводПредупреждения.Текст;
				Сообщение.Поле  = Результат.ВыводПредупреждения.ПутьКРеквизитуФормы;
				Сообщение.Сообщить();
				
			КонецЕсли;
			
		Иначе
			Предупреждение(Результат.ВыводПредупреждения.Текст);
		КонецЕсли;
	КонецЕсли;
	
	Если Результат.Свойство("ОповещениеФорм") И Результат.ОповещениеФорм.Использование Тогда
		Оповестить(Результат.ОповещениеФорм.ИмяСобытия, Результат.ОповещениеФорм.Параметр, Результат.ОповещениеФорм.Источник);
	КонецЕсли;
	
	Если Результат.Свойство("ОповещениеДинамическихСписков") И Результат.ОповещениеДинамическихСписков.Использование Тогда
		Если ТипЗнч(Результат.ОповещениеДинамическихСписков.СсылкаИлиТип) = Тип("Массив") Тогда
			Для Каждого СсылкаИлиТип Из Результат.ОповещениеДинамическихСписков.СсылкаИлиТип Цикл
				ОповеститьОбИзменении(СсылкаИлиТип);
			КонецЦикла;
		Иначе
			ОповеститьОбИзменении(Результат.ОповещениеДинамическихСписков.СсылкаИлиТип);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов в другие подсистемы

// Открывает форму ввода пароля пользователя сервиса
//
// Параметры:
//  ПарольПользователяСервиса - Строка - пароль пользователя сервиса
//  Отказ - Булево - флаг отказа от выполнения действия
//
Процедура ПриЗапросеПароляДляАутентификацииВСервисе(ПарольПользователяСервиса, Отказ) Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ПользователиВМоделиСервиса") Тогда
		Модуль = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ПользователиСлужебныйВМоделиСервисаКлиент");
		Модуль.ЗапроситьПарольДляАутентификацииВСервисе(ПарольПользователяСервиса, Отказ);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Стандартные действия выполняемые перед началом работы системы.
//
// Параметры:
// Отказ - Булево - флаг отказа от выполнения операции. 
//  В случае установки в Истина вход в систему осуществлен не будет.
//
Процедура ДействияПередНачаломРаботыСистемы(Отказ) Экспорт
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	УстановитьРазделениеСеанса(Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ОтметитьПервыйЗапросПараметровРаботыКлиентаПриЗапуске();
	ПараметрыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если НЕ ПустаяСтрока(ПараметрыКлиента.ИнформационнаяБазаЗаблокированаДляОбновления) Тогда
		Отказ = Истина;
		Предупреждение(ПараметрыКлиента.ИнформационнаяБазаЗаблокированаДляОбновления);
		Возврат;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ПараметрыКлиента.ОшибкаЗапускаСПустымСпискомПользователей) Тогда
		Отказ = Истина;
		ПользователиСлужебныйКлиент.СоздатьАдминистратораИлиЗавершитьРаботу(
			ПараметрыКлиента.ОшибкаЗапускаСПустымСпискомПользователей);
		Возврат;
	КонецЕсли;
	
	Если ПараметрыКлиента.НеобходимоОбновлениеПараметровРаботыПрограммы Тогда
		// Параметры работы программы должны быть обновлены до продолжения работы.
		ЗагрузитьОбновитьПараметрыРаботыПрограммы(Отказ, ПараметрыКлиента);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	// СтандартныеПодсистемы.Пользователи
	ПользователиСлужебныйКлиент.ПроверитьАвторизациюПользователя(Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Пользователи
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	Если НЕ ПараметрыКлиента.ДоступноИспользованиеРазделенныхДанных
	   И ПараметрыКлиента.НеобходимоОбновлениеНеразделенныхДанныхИнформационнойБазы Тогда
		// Обновление неразделенных данных ИБ в модели сервиса.
		Состояние(НСтр("ru = 'Пожалуйста, подождите, выполняется обновление информационной базы...'"));
		ОбновлениеИнформационнойБазыВызовСервера.ВыполнитьОбновлениеИнформационнойБазы(, Истина);
		Состояние(НСтр("ru = 'Обновление информационной базы выполнено успешно.'"));
	КонецЕсли;
	
	Если Не ПараметрыКлиента.ДоступноИспользованиеРазделенныхДанных Тогда
		Возврат;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	УстановитьРасширенныйЗаголовокПриложения(Истина); // Для вспомогательных окон.
	
	// Для толстого клиента в режиме обычного приложения логика выполняется
	// в обработчике "ПриНачалеРаботыСистемы".
	//
	// В остальных случаях - в обработчике "ПередНачаломРаботыСистемы".
#Если НЕ ТолстыйКлиентОбычноеПриложение Тогда
	ВерсияАктуальна = ПроверитьВерсиюПлатформыПриЗапуске();
	Если Не ВерсияАктуальна Тогда 
		Отказ = Истина;
		Возврат;
	КонецЕсли;
#КонецЕсли
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	// СтандартныеПодсистемы.ЗавершениеРаботыПользователей
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует(
		"СтандартныеПодсистемы.ЗавершениеРаботыПользователей") Тогда
		
		МодульСоединенияИБКлиент = Вычислить("СоединенияИБКлиент");
		МодульСоединенияИБКлиент.ПередНачаломРаботыСистемы(Отказ);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ЗавершениеРаботыПользователей
	
#Если НЕ ТолстыйКлиентОбычноеПриложение Тогда
	// СтандартныеПодсистемы.ОбновлениеВерсииИБ
	ОбновлениеИБДоступно = Истина;
	// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ
	
	// СтандартныеПодсистемы.ПроверкаЛегальностиПолученияОбновления
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует(
		   "СтандартныеПодсистемы.ПроверкаЛегальностиПолученияОбновления") Тогда
		
		Модуль = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ПроверкаЛегальностиПолученияОбновленияКлиент");
		ОбновлениеИБДоступно = Модуль.ПроверитьЛегальностьПолученияОбновленияПриЗапуске();
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПроверкаЛегальностиПолученияОбновления
	
	// СтандартныеПодсистемы.ОбновлениеВерсииИБ
	Если ОбновлениеИБДоступно Тогда
		ОбновлениеИнформационнойБазыКлиент.ОбновитьИнформационнуюБазу(Отказ, Истина);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ
#КонецЕсли
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	ОбработчикиСобытия = ОбщегоНазначенияКлиент.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПередНачаломРаботыСистемы");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПередНачаломРаботыСистемы(Отказ);
	КонецЦикла;
	
	ОбщегоНазначенияКлиентПереопределяемый.ПередНачаломРаботыСистемы(Отказ);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
КонецПроцедуры

// Стандартные действия выполняемые при начале работы системы.
//
// Выполняется при начале работы пользователя с областью данных,
// либо в локальном режиме работы.
// Соответствует обработчику ПриНачалеРаботыСистемы. 
//
// Параметры:
//  ОбработкаПараметровЗапуска - Булево.
//    Истина - обработчик вызван при обычном входе пользователя
//             в систему и обработка параметров запуска будет выполнена.
//    Ложь   - обработчик вызван при входе неразделенного пользователя
//             в область данных и обработка параметров запуска будет пропущена.
//
Процедура ДействияПриНачалеРаботыСистемы(ОбработкаПараметровЗапуска = Истина, ВыполнятьОбновление = Истина) Экспорт
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	УстановитьРасширенныйЗаголовокПриложения(Истина); // Для главного окна.
	
	// Для толстого клиента в режиме обычного приложения логика выполняется
	// в обработчике "ПриНачалеРаботыСистемы".
	//
	// В остальных случаях - в обработчике "ПередНачаломРаботыСистемы".
#Если ТолстыйКлиентОбычноеПриложение Тогда
	ВерсияАктуальна = ПроверитьВерсиюПлатформыПриЗапуске();
	Если Не ВерсияАктуальна Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	Если ВыполнятьОбновление Тогда
		// СтандартныеПодсистемы.ОбновлениеВерсииИБ
		ОбновлениеИБДоступно = Истина;
		// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ
		
		// СтандартныеПодсистемы.ПроверкаЛегальностиПолученияОбновления
		Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует(
			"СтандартныеПодсистемы.ПроверкаЛегальностиПолученияОбновления") Тогда
			
			Модуль = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ПроверкаЛегальностиПолученияОбновленияКлиент");
			ОбновлениеИБДоступно = Модуль.ПроверитьЛегальностьПолученияОбновленияПриЗапуске();
		КонецЕсли;
		// Конец СтандартныеПодсистемы.ПроверкаЛегальностиПолученияОбновления
		
		// СтандартныеПодсистемы.ОбновлениеВерсииИБ
		Если ОбновлениеИБДоступно Тогда
			Отказ = Ложь;
			ОбновлениеИнформационнойБазыКлиент.ОбновитьИнформационнуюБазу(Отказ, Истина);
			Если Отказ Тогда
				Возврат;
			КонецЕсли;
		КонецЕсли;
		// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ
	КонецЕсли;
#КонецЕсли
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	
	// Обработка параметров запуска системы.
	Если ОбработкаПараметровЗапуска И НЕ ОбработатьПараметрыЗапуска() Тогда
		Возврат;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	// СтандартныеПодсистемы.ЗавершениеРаботыПользователей
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует(
		"СтандартныеПодсистемы.ЗавершениеРаботыПользователей") Тогда
		
		МодульСоединенияИБКлиент = Вычислить("СоединенияИБКлиент");
		МодульСоединенияИБКлиент.ПриНачалеРаботыСистемы();
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ЗавершениеРаботыПользователей
	
	// СтандартныеПодсистемы.РегламентныеЗадания
	// Прим.: подсистема РегламентныеЗадания должна настраиваться ранее многих других подсистем,
	//        т.к. в режиме запуска отдельного сеанса обработки регламентных заданий,
	//        управление не будет и не должно быть передано далее.
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует(
		"СтандартныеПодсистемы.РегламентныеЗадания") Тогда
		
		МодульРегламентныеЗаданияСлужебныйКлиент = Вычислить("РегламентныеЗаданияСлужебныйКлиент");
		МодульРегламентныеЗаданияСлужебныйКлиент.ПриНачалеРаботыСистемы();
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РегламентныеЗадания
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	ОбработчикиСобытия = ОбщегоНазначенияКлиент.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриНачалеРаботыСистемы");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриНачалеРаботыСистемы(ОбработкаПараметровЗапуска);
	КонецЦикла;
	
	ОбщегоНазначенияКлиентПереопределяемый.ПриНачалеРаботыСистемы(ОбработкаПараметровЗапуска);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
КонецПроцедуры

// Обработать параметры запуска программы.
//
// Возвращаемое значение:
//   Булево   – Истина, если необходимо прервать выполнение процедуры ПриНачалеРаботыСистемы.
//
Функция ОбработатьПараметрыЗапуска()

	Если ПустаяСтрока(ПараметрЗапуска) Тогда
		Возврат Истина;
	КонецЕсли;
	
	// Параметр может состоять из частей, разделенных символом ";".
	// Первая часть - главное значение параметра запуска. 
	// Наличие дополнительных частей определяется логикой обработки главного параметра.
	ПараметрыЗапуска = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПараметрЗапуска, ";");
	ПервыйПараметр = Врег(ПараметрыЗапуска[0]);
	
	Отказ = Ложь;
	ОбработчикиСобытия = ОбщегоНазначенияКлиент.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриОбработкеПараметровЗапуска");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриОбработкеПараметровЗапуска(ПервыйПараметр, ПараметрыЗапуска, Отказ);
	КонецЦикла;
	
	Отказ = ОбщегоНазначенияКлиентПереопределяемый.ОбработатьПараметрыЗапуска(
		ПервыйПараметр, ПараметрыЗапуска) Или Отказ;
	
	Возврат НЕ Отказ;
	
КонецФункции

// Соответствует обработчику ПередЗавершениемРаботыСистемы
//
// Параметры:
//  Отказ - Булево - признак отказа от завершения работы системы.
//
Процедура ДействияПередЗавершениемРаботыСистемы(Отказ) Экспорт
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	ОбработчикиСобытия = ОбщегоНазначенияКлиент.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПередЗавершениемРаботыСистемы");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПередЗавершениемРаботыСистемы(Отказ);
	КонецЦикла;
	
	ОбщегоНазначенияКлиентПереопределяемый.ПередЗавершениемРаботыСистемы(Отказ);
	
	Если Отказ = Истина Тогда
		Возврат;
	КонецЕсли;
	
	// Если перед завершение работы есть незаписанные сообщения для журнала регистрации,
	// накопленные в переменной, то их необходимо записать
	Если ТипЗнч(СообщенияДляЖурналаРегистрации) = Тип("СписокЗначений") И СообщенияДляЖурналаРегистрации.Количество() <> 0 Тогда
		ОбщегоНазначенияВызовСервера.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
	КонецЕсли;
	
	Если СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ДоступноИспользованиеРазделенныхДанных Тогда
		ОткрытьФормуПредупрежденийПриЗавершенииРаботы(Отказ);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
КонецПроцедуры

// Показывает пользователю диалог подтверждения выхода из программы.
//
// Параметры:
//  Отказ - Булево - признак отказа от завершения работы системы.
//
Процедура ВопросПользователюПередЗавершениемРаботыСистемы(Отказ) Экспорт
	
	БольшеНеЗадаватьЭтотВопрос = Не СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ЗапрашиватьПодтверждениеПриЗавершенииПрограммы;
	Если БольшеНеЗадаватьЭтотВопрос Тогда
		Возврат;
	КонецЕсли;
	
	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить("КодВозвратаДиалога.Да",  НСтр("ru = 'Завершить'"));
	Кнопки.Добавить("КодВозвратаДиалога.Нет", НСтр("ru = 'Отмена'"));
	
	Результат = ВопросПользователю(
		НСтр("ru = 'Завершить работу с программой?'"),
		Кнопки,
		,
		КодВозвратаДиалога.Да,
		НСтр("ru = 'Завершение работы'"), 
		КодВозвратаДиалога.Нет,
		БольшеНеЗадаватьЭтотВопрос
	);
	
	Если БольшеНеЗадаватьЭтотВопрос Тогда
		СтандартныеПодсистемыВызовСервера.СохранитьНастройкуПодтвержденияПриЗавершенииПрограммы(НЕ БольшеНеЗадаватьЭтотВопрос);
	КонецЕсли;
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Проверяет версию платформы, в зависимости от места вызова и возвращает Истина, 
// если она подходит для запуска конфигурации.
//
// Возвращаемое значение
//  Булево - если версия актуальна, тогда Истина, иначе - Ложь.
//
Функция ПроверитьВерсиюПлатформыПриЗапуске() Экспорт
	
	Если СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске().РазделениеВключено Тогда
		Возврат Истина;
	КонецЕсли;
	
	// Определяем минимальную версию платформы для запуска и логику входа в программу
	ПараметрыРаботы = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	
	Возврат ПроверитьВерсиюПлатформы(ПараметрыРаботы.МинимальноНеобходимаяВерсияПлатформы, ПараметрыРаботы.РаботаВПрограммеЗапрещена);
	
КонецФункции

// Проверяет минимально допустимую версию платформы для запуска.
// Если версия платформы более поздняя, чем РекомендуемаяВерсияПлатформы, то пользователю будет 
// показано оповещение. Работа программы будет прекращена, если ЗавершитьРаботу = Истина.
//
// Параметры:
//  РекомендуемаяВерсияПлатформы - Строка - версия платформы рекомендуемая для работы;
//  РаботаВПрограммеЗапрещена    - Булево - если Истина и текущая версия платформы меньше рекомендуемой, 
//                                          то продолжение работы в программе невозможно.
//
// Возвращаемое значение:
//  Булево - Истина, если версия платформы подходит для работы.
//
Функция ПроверитьВерсиюПлатформы(знач РекомендуемаяВерсияПлатформы, знач РаботаВПрограммеЗапрещена = Ложь) Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(СистемнаяИнформация.ВерсияПриложения, РекомендуемаяВерсияПлатформы) >= 0 Тогда
		Возврат Истина;
	КонецЕсли;
	
	ЕстьДоступДляОбновленияВерсииПлатформы = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске().ЕстьДоступДляОбновленияВерсииПлатформы;
	Если РаботаВПрограммеЗапрещена Тогда
		Если ЕстьДоступДляОбновленияВерсииПлатформы Тогда
			ТекстСообщения = НСтр("ru = 'Вход в программу невозможен.
				|Необходимо предварительно обновить версию платформы 1С:Предприятие.'");
		Иначе
			ТекстСообщения = НСтр("ru = 'Вход в программу невозможен.
				|Необходимо обратиться к администратору для обновления версии платформы 1С:Предприятие.'");
		КонецЕсли;
	Иначе
		Если ЕстьДоступДляОбновленияВерсииПлатформы Тогда
			ТекстСообщения = 
				НСтр("ru='Рекомендуется завершить работу программы и обновить версию платформы 1С:Предприятия.
			         |В противном случае некоторые возможности программы будут недоступны или будут работать некорректно.'");
		Иначе
			ТекстСообщения = 
				НСтр("ru='Рекомендуется завершить работу программы и обратиться к администратору для обновления версии платформы 1С:Предприятия.
			         |В противном случае некоторые возможности программы будут недоступны или будут работать некорректно.'");
		КонецЕсли;
	КонецЕсли;
	Параметры = Новый Структура;
	Параметры.Вставить("ТекстСообщения", ТекстСообщения);
	Параметры.Вставить("ЗавершитьРаботу", РаботаВПрограммеЗапрещена);
	Параметры.Вставить("РекомендуемаяВерсияПлатформы", РекомендуемаяВерсияПлатформы);
	Результат = ОткрытьФормуМодально("Обработка.НерекомендуемаяВерсияПлатформы.Форма.НерекомендуемаяВерсияПлатформы", Параметры);
	Если РаботаВПрограммеЗапрещена Тогда
		ПрекратитьРаботуСистемы();
		Возврат Ложь;
	ИначеЕсли Результат = КодВозвратаДиалога.OK Тогда
		ПрекратитьРаботуСистемы();
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Выводит форму сообщений пользователю при закрытии программы,
// либо выводит сообщение.
//
// Параметры:
//  Отказ - Булево - признак отказа от завершения работы системы.
//
Процедура ОткрытьФормуПредупрежденийПриЗавершенииРаботы(Отказ) Экспорт
	
	Если ПропуститьПредупреждениеПередЗавершениемРаботыСистемы = Истина Тогда 
		Возврат;
	КонецЕсли;
	
	Предупреждения = Новый Массив;
	
	ОбработчикиСобытия = ОбщегоНазначенияКлиент.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриПолученииСпискаПредупрежденийЗавершенияРаботы");
	
	Для Каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриПолученииСпискаПредупрежденийЗавершенияРаботы(Предупреждения);
	КонецЦикла;
	
	Если Предупреждения.Количество() = 0 Тогда
		ВопросПользователюПередЗавершениемРаботыСистемы(Отказ);
	Иначе
		ПараметрыПередачи = Новый Структура;
		ПараметрыПередачи.Вставить("Предупреждения", Предупреждения);
		
		ИмяФормы = "ОбщаяФорма.ПредупрежденияПриЗавершенииРаботы";
		
		Если Предупреждения.Количество() = 1 Тогда
			Результат = ОткрытьПрикладнуюФормуПредупреждения(Предупреждения[0], ИмяФормы, ПараметрыПередачи);
		Иначе
			Результат = ОткрытьФормуМодально(ИмяФормы, ПараметрыПередачи);
		КонецЕсли;
		Если Результат = Истина ИЛИ Результат = Неопределено Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
	// Если выход из приложения не выполнен, то необходимо "сбросить" ПараметрыРаботыКлиентаПриЗавершении,
	// чтобы при следующем выходе из приложения их зачитать.
	Если Отказ Тогда
		ПараметрыРаботыКлиентаПриЗавершении = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при необходимости открыть форму списка активных пользователей,
// которые в данный момент времени работают с системой.
//
Процедура ОткрытьСписокАктивныхПользователей() Экспорт
	
	ИмяФормы = "";
	
	ОбработчикиСобытия = ОбщегоНазначенияКлиент.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриОпределенииФормыАктивныхПользователей");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриОпределенииФормыАктивныхПользователей(ИмяФормы);
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ИмяФормы) Тогда
		ОткрытьФорму(ИмяФормы);
	Иначе
		Предупреждение(
			НСтр("ru = 'Для того чтобы открыть список активных пользователей, перейдите в меню
			           |Все функции - Стандартные - Активные пользователи.'"));
	КонецЕсли;
	
КонецПроцедуры

// Возвращает клиентский общий модуль по имени.
Функция КлиентскийОбщийМодуль(Имя) Экспорт
	
	Модуль = Вычислить(Имя);
	
#Если НЕ ВебКлиент Тогда
	Если ТипЗнч(Модуль) <> Тип("ОбщийМодуль") Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Общий модуль ""%1"" не найден.'"), Имя);
	КонецЕсли;
#КонецЕсли
	
	Возврат Модуль;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции

// Установить разделения сеанса при запуске программы.
//
// Параметры:
//  Отказ  - Булево - если Истина, то запуск программы должен быть прекращен.
//
Процедура УстановитьРазделениеСеанса(Отказ)

	Если ПустаяСтрока(ПараметрЗапуска) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЗапуска = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПараметрЗапуска, ";");
	ЗначениеПараметраЗапуска = Врег(ПараметрыЗапуска[0]);
	
	Если ЗначениеПараметраЗапуска <> ВРег("ВойтиВОбластьДанных") Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыЗапуска.Количество() < 2 Тогда
		ВызватьИсключение(НСтр("ru = 'При указании параметра запуска ВойтиВОбластьДанных,
				|дополнительным параметром необходимо указать значение разделителя.'"));
	КонецЕсли;
	
	Попытка
		ЗначениеРазделителя = Число(ПараметрыЗапуска[1]);
	Исключение
		ВызватьИсключение(НСтр("ru = 'Значением разделителя в параметре ВойтиВОбластьДанных должно быть число.'"));
	КонецПопытки;
	
	ОбщегоНазначенияВызовСервера.УстановитьРазделениеСеанса(Истина, ЗначениеРазделителя);
	
КонецПроцедуры 

// Возвращает строковое представление значения типа КодВозвратаДиалога
Функция КодВозвратаДиалогаВСтроку(Значение)
	
	Результат = "КодВозвратаДиалога." + Строка(Значение);
	
	Если Значение = КодВозвратаДиалога.Да Тогда
		Результат = "КодВозвратаДиалога.Да";
	ИначеЕсли Значение = КодВозвратаДиалога.Нет Тогда
		Результат = "КодВозвратаДиалога.Нет";
	ИначеЕсли Значение = КодВозвратаДиалога.ОК Тогда
		Результат = "КодВозвратаДиалога.ОК";
	ИначеЕсли Значение = КодВозвратаДиалога.Отмена Тогда
		Результат = "КодВозвратаДиалога.Отмена";
	ИначеЕсли Значение = КодВозвратаДиалога.Повторить Тогда
		Результат = "КодВозвратаДиалога.Повторить";
	ИначеЕсли Значение = КодВозвратаДиалога.Прервать Тогда
		Результат = "КодВозвратаДиалога.Прервать";
	ИначеЕсли Значение = КодВозвратаДиалога.Пропустить Тогда
		Результат = "КодВозвратаДиалога.Пропустить";
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Формирует отображение одного вопроса.
//
//	Если в ПредупреждениеПользователю есть свойство "ТекстГиперссылки", то открывается "ФормаИндивидуальногоОткрытия" из Структуры вопроса.
//	Если в ПредупреждениеПользователю есть свойство "ТекстФлажка", то открывается форма "ОбщаяФорма.ВопросПередЗавершениемРаботыСистемы".
//
// Параметры:
//	ПредупреждениеПользователю - Структура - структура передаваемого предупреждения.
//	ИмяФормы - Строка - имя общей формы с вопросами.
//	ПараметрыПередачи - Структура - параметры для формы с вопросами.
//
// Возвращаемое значение:
//	Булево - Истина, если форма открыта.
//
Функция ОткрытьПрикладнуюФормуПредупреждения(ПредупреждениеПользователю, ИмяФормы, ПараметрыПередачи)
	Отказ = Ложь;
	
	ТекстФлажка = "";
	Если ПредупреждениеПользователю.Свойство("ТекстФлажка", ТекстФлажка) Тогда 
		Если Не ПустаяСтрока(ТекстФлажка) Тогда 
			Отказ = ОткрытьФормуМодально(ИмяФормы, ПараметрыПередачи);
		КонецЕсли;
			
		Возврат Отказ;
	КонецЕсли;	
	
	ТекстГиперссылки = "";
	Если ПредупреждениеПользователю.Свойство("ТекстГиперссылки", ТекстГиперссылки) Тогда 
		Если Не ПустаяСтрока(ТекстГиперссылки) Тогда 
			ДействиеПриНажатииГиперссылки = Неопределено;
			Если ПредупреждениеПользователю.Свойство("ДействиеПриНажатииГиперссылки", ДействиеПриНажатииГиперссылки) Тогда 
				ДействиеГиперссылка = ПредупреждениеПользователю.ДействиеПриНажатииГиперссылки;
				Форма = Неопределено;
				Если ДействиеГиперссылка.Свойство("ПрикладнаяФормаПредупреждения", Форма) Тогда 
					ПараметрыФормы = Неопределено;
					Если ДействиеГиперссылка.Свойство("ПараметрыПрикладнойФормыПредупреждения", ПараметрыФормы) Тогда
						Если ТипЗнч(ПараметрыФормы) = Тип("Структура") Тогда 
							ПараметрыФормы.Вставить("ЗавершениеРаботыПрограммы", Истина);
						ИначеЕсли ПараметрыФормы = Неопределено Тогда 
							ПараметрыФормы = Новый Структура;
							ПараметрыФормы.Вставить("ЗавершениеРаботыПрограммы", Истина);
						КонецЕсли;
						
						ПараметрыФормы.Вставить("ЗаголовокКнопкиДа",  НСтр("ru = 'Завершить'"));
						ПараметрыФормы.Вставить("ЗаголовокКнопкиНет", НСтр("ru = 'Отмена'"));
						
					КонецЕсли;
					Ответ = ОткрытьФормуМодально(Форма, ПараметрыФормы);
					Отказ = ОпределитьОтветФормы(Ответ);
					
					Возврат Отказ;
				ИначеЕсли ДействиеГиперссылка.Свойство("Форма", Форма) Тогда 
					ПараметрыФормы = Неопределено;
					Если ДействиеГиперссылка.Свойство("ПараметрыФормы", ПараметрыФормы) Тогда
						Если ТипЗнч(ПараметрыФормы) = Тип("Структура") Тогда 
							ПараметрыФормы.Вставить("ЗавершениеРаботыПрограммы", Истина);
						ИначеЕсли ПараметрыФормы = Неопределено Тогда 
							ПараметрыФормы = Новый Структура;
							ПараметрыФормы.Вставить("ЗавершениеРаботыПрограммы", Истина);
						КонецЕсли;
					КонецЕсли;
					Ответ = ОткрытьФормуМодально(Форма, ПараметрыФормы);
					Отказ = ОпределитьОтветФормы(Ответ);
					
					Возврат Отказ;
				КонецЕсли;	
			КонецЕсли;	
		КонецЕсли;
			
		Возврат Отказ;
	КонецЕсли;	
	
	Возврат Отказ;
КонецФункции

// Определяет отказ по ответу формы.
//
// Параметры:
//	Ответ - ответ формы.
//
Функция ОпределитьОтветФормы(Ответ)
	Возврат Ответ = Неопределено Или Ответ = КодВозвратаДиалога.Нет Или Ответ = Истина;
КонецФункции	

Процедура ЗагрузитьОбновитьПараметрыРаботыПрограммы(Отказ, ПараметрыКлиента)
	
	Если ПараметрыКлиента.Свойство("ПодтвердитьНастройкиЗагрузкиСообщенияВПодчиненномУзлеРИБ") Тогда
		Модуль = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ОбменДаннымиКлиент");
		Модуль.ПодтвердитьНастройкиЗагрузкиСообщенияВПодчиненномУзлеРИБ(ПараметрыКлиента.ГлавныйУзел);
	КонецЕсли;
	
	Модуль = Неопределено;
	Если ПараметрыКлиента.ИнформационнаяБазаФайловая
	   И ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.ЗавершениеРаботыПользователей") Тогда
		
		Модуль = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("СоединенияИБКлиент");
	КонецЕсли;
	
	СнятьБлокировкуФайловойБазы = Ложь;
	Попытка
		Пока Истина Цикл
			ТекстСостояния = НСтр("ru = 'Пожалуйста, подождите, выполняется подготовка к обновлению информационной базы...'");
			Состояние(ТекстСостояния);
			
			ОшибкаУстановкиМонопольногоРежима = "";
			СтандартныеПодсистемыВызовСервера.ЗагрузитьОбновитьПараметрыРаботыПрограммы(ОшибкаУстановкиМонопольногоРежима);
			
			Если НЕ ЗначениеЗаполнено(ОшибкаУстановкиМонопольногоРежима) Тогда
				Прервать;
			КонецЕсли;
			
			Если Модуль = Неопределено Тогда
				Предупреждение(ОшибкаУстановкиМонопольногоРежима);
				Отказ = Истина;
				Возврат;
			КонецЕсли;
			
			Модуль.ПриОткрытииФормыОшибкиУстановкиМонопольногоРежима(Отказ);
			Если Отказ Тогда
				Если СнятьБлокировкуФайловойБазы Тогда
					ОбновлениеИнформационнойБазыВызовСервера.СнятьБлокировкуФайловойБазы();
				КонецЕсли;
				Возврат;
			КонецЕсли;
			СнятьБлокировкуФайловойБазы = Истина;
		КонецЦикла;
	Исключение
		Если СнятьБлокировкуФайловойБазы Тогда
			ОбновлениеИнформационнойБазыВызовСервера.СнятьБлокировкуФайловойБазы();
		КонецЕсли;
		ВызватьИсключение;
	КонецПопытки;
	
	Если СнятьБлокировкуФайловойБазы Тогда
		ОбновлениеИнформационнойБазыВызовСервера.СнятьБлокировкуФайловойБазы();
	КонецЕсли;
	
	Состояние(НСтр("ru = 'Подготовка к обновлению информационной базы выполнена успешно.'"));
	
	ОбновитьПовторноИспользуемыеЗначения();
	ПараметрыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	
КонецПроцедуры

Процедура ОтметитьПервыйЗапросПараметровРаботыКлиентаПриЗапуске()
	
	Если ТипЗнч(ПараметрыРаботыКлиентаПриОбновлении) <> Тип("Структура") Тогда
		ПараметрыРаботыКлиентаПриОбновлении = Новый Структура;
	КонецЕсли;
	
	ПараметрыРаботыКлиентаПриОбновлении.Вставить("ПервыйЗапросПараметров");
	
КонецПроцедуры
