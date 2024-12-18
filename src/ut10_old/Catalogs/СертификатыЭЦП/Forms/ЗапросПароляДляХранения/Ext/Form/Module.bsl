﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Процедура УстановитьДоступностьВидимость()
	
	Если Параметры.ДляЗаписиВИБ ИЛИ ТипЗнч(ВыбранныйСертификат) = Тип("Строка") Тогда
		Элементы.ВыбранныйСертификат.Доступность = Ложь;
		Элементы.ЗапомнитьПарольНаВремяСеанса.Доступность = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВыбранныйСертификат) Тогда
		Элементы.ВыбранныйСертификат.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если ТаблицаЭД.Количество() > 1 Тогда
		Элементы.ОбъектыДляОбработки.Заголовок = НСтр("ru = 'Список'");
	КонецЕсли;
	
	Элементы.ОбъектыДляОбработки.Видимость = (ТаблицаЭД.Количество() > 0);
	
КонецПроцедуры

&НаКлиенте
Функция ПараметрыВозвратаПароля()
	
	РезультатВыбора = Новый Структура;
	
	РезультатВыбора.Вставить("ВыбранныйСертификат", ВыбранныйСертификат);
	РезультатВыбора.Вставить("Пользователь",        Пользователь);
	РезультатВыбора.Вставить("ПарольПользователя",  ПарольПользователя);
	РезультатВыбора.Вставить("Комментарий",         "");
	
	Возврат РезультатВыбора;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаВыбораСертификата()
	
	Пароль = Неопределено;
	ПарольСохранен = Ложь;
	Если НЕ ЗначениеЗаполнено(ВыбранныйСертификат) Тогда
		Возврат;
	КонецЕсли;
	Если ЭлектронныеДокументыСлужебныйКлиент.ПарольИзГлобальнойПеременнойПолучен(ВыбранныйСертификат, Пароль) Тогда
		ПарольПользователя = Пароль;
		ЗапомнитьПарольНаВремяСеанса = НЕ Параметры.ДляЗаписиВИБ;
	Иначе
		Соответствие = ПолучитьИзВременногоХранилища(АдресХранилища);
		РеквизитыСертификата = Соответствие.Получить(ВыбранныйСертификат);
		ПарольПользователя = ?(РеквизитыСертификата.ПарольПолучен = Истина, РеквизитыСертификата.ПарольПользователя, Неопределено);
		ЗапомнитьПарольНаВремяСеанса = Ложь;
		ПарольСохранен = РеквизитыСертификата.ЗапомнитьПарольКСертификату;
	КонецЕсли;
	Элементы.ЗапомнитьПарольНаВремяСеанса.Доступность = НЕ (ПарольСохранен ИЛИ Параметры.ДляЗаписиВИБ);
	Элементы.ПарольПользователя.Доступность = НЕ ПарольСохранен ИЛИ Параметры.ДляЗаписиВИБ;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура КомандаГотово(Команда)
	
	// Блок проверки на заполненность сертификата ЭП.
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.ВводПароляКСертификату
		И Не ЗначениеЗаполнено(ВыбранныйСертификат) Тогда
		ТекстСообщения = ЭлектронныеДокументыКлиентСервер.ПолучитьТекстСообщения("Поле", "Заполнение", "Сертификат подписи");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "ВыбранныйСертификат");
		Возврат;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.ВводЛогинаИПароля И ПустаяСтрока(Пользователь) Тогда
		ТекстСообщения = ЭлектронныеДокументыКлиентСервер.ПолучитьТекстСообщения("Поле", "Заполнение", "Пользователь");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Пользователь");
		Возврат;
	КонецЕсли;
	
	Если Параметры.ДляЗаписиВИБ Тогда
		Если ПарольПользователя = "" Тогда
			ТекстВопроса = НСтр("ru = 'Задан пустой пароль. Продолжить?'");
			Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, 30, КодВозвратаДиалога.Да);
			Если Ответ <> КодВозвратаДиалога.Да Тогда
				Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.ВводПароляКСертификату Тогда
		СохраняемыйКлюч = ВыбранныйСертификат;
		СохраняемоеЗначение = ПарольПользователя;
	Иначе
		СохраняемыйКлюч = СоглашениеЭД;
		ДанныеАвторизации = Новый Структура("Пользователь, Пароль", Пользователь, ПарольПользователя);
		СохраняемоеЗначение = ДанныеАвторизации;
	КонецЕсли;
	
	Если ЗапомнитьПарольНаВремяСеанса Тогда
		ЭлектронныеДокументыСлужебныйКлиент.ДобавитьПарольВГлобальнуюПеременную(СохраняемыйКлюч, СохраняемоеЗначение);
	Иначе
		ЭлектронныеДокументыСлужебныйКлиент.УдалитьПарольИзГлобальнойПеременной(СохраняемыйКлюч);
	КонецЕсли;
	
	Закрыть(ПараметрыВозвратаПароля());
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЕЙ ФОРМЫ

&НаКлиенте
Процедура ВыбранныйСертификатОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", ВыбранныйСертификат);
	ПараметрыФормы.Вставить("ТолькоПросмотр", Истина);
	ОткрытьФорму("Справочник.СертификатыЭЦП.Форма.ФормаЭлемента", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныйСертификатПриИзменении(Элемент)
	
	ОбработкаВыбораСертификата();
	ОбновитьОтображениеДанных();
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольПользователяОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	#Если НЕ ВебКлиент Тогда
	ПарольПользователя = Текст;
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольАвторизацииОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	#Если НЕ ВебКлиент Тогда
		ПарольПользователя = Текст;
	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура ОбъектыДляОбработкиНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТаблицаЭД.Количество() > 1 Тогда
		МассивСтруктур = Новый Массив;
		Для Каждого СтрокаДанных Из ТаблицаЭД Цикл
			СтруктураПараметров = Новый Структура;
			СтруктураПараметров.Вставить("ЭлектронныйДокумент",СтрокаДанных.ЭлектронныйДокумент);
			СтруктураПараметров.Вставить("ВладелецЭД",         СтрокаДанных.ВладелецЭД);
			СтруктураПараметров.Вставить("НаправлениеЭД",      ПредопределенноеЗначение("Перечисление.НаправленияЭД.Исходящий"));
			МассивСтруктур.Добавить(СтруктураПараметров);
		КонецЦикла;
		ФормаПросмотраЭД = ОткрытьФорму("Обработка.ЭлектронныеДокументы.Форма.ФормаСпискаВыгружаемыхДокументов",
			Новый Структура("СтруктураЭД", МассивСтруктур), ЭтаФорма);
		
	ИначеЕсли ТипЗнч(ТаблицаЭД[0].ВладелецЭД) = Тип("ДокументСсылка.ПакетЭД") Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ",          ТаблицаЭД[0].ВладелецЭД);
		ПараметрыФормы.Вставить("ТолькоПросмотр", Истина);
		ОткрытьФорму("Документ.ПакетЭД.Форма.ФормаДокумента", ПараметрыФормы);
	ИначеЕсли ТипЗнч(ТаблицаЭД[0].ВладелецЭД) = Тип("ДокументСсылка.ПроизвольныйЭД") Тогда
		
		// Откроем вложение по стандартному механизму
		ДанныеФайла = ЭлектронныеДокументыСлужебныйВызовСервера.ПолучитьДанныеФайла(ТаблицаЭД[0].ЭлектронныйДокумент,
			УникальныйИдентификатор);
		ПрисоединенныеФайлыКлиент.ОткрытьФайл(ДанныеФайла, Ложь);
	Иначе
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЭлектронныйДокумент", ТаблицаЭД[0].ЭлектронныйДокумент);
		ПараметрыФормы.Вставить("ВладелецЭД",          ТаблицаЭД[0].ВладелецЭД);
		ОткрытьФорму("Обработка.ЭлектронныеДокументы.Форма.ФормаЗагрузкиПросмотраЭД", ПараметрыФормы, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВидОперации = Параметры.ВидОперации;
	
	Если ВидОперации = Нстр("ru = 'Авторизация на сервере банка'") Тогда
		Заголовок = НСтр("ru = 'Введите данные авторизации'");
		Элементы.Страницы.ТекущаяСтраница = Элементы.ВводЛогинаИПароля;
		Если ТипЗнч(Параметры.Соответствие) = Тип("Соответствие") И Параметры.Соответствие.Количество() > 0 Тогда
			Для Каждого КлючИЗначение Из Параметры.Соответствие Цикл
				СоглашениеЭД = КлючИЗначение.Ключ;
			КонецЦикла;
		Иначе
			Возврат;
		КонецЕсли;
		
		Пользователь = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СоглашениеЭД, "Пользователь");
		
	Иначе
		Если ТипЗнч(Параметры.Соответствие) = Тип("Соответствие") И Параметры.Соответствие.Количество() > 0 Тогда
			АдресХранилища = ПоместитьВоВременноеХранилище(Параметры.Соответствие, УникальныйИдентификатор);
			Для Каждого КлючИЗначение Из Параметры.Соответствие Цикл
				Элементы.ВыбранныйСертификат.СписокВыбора.Добавить(КлючИЗначение.Ключ);
			КонецЦикла;
			Если Параметры.Соответствие.Количество() > 1 Тогда
				Элементы.ВыбранныйСертификат.РежимВыбораИзСписка = Истина;
			Иначе
				ВыбранныйСертификат = Элементы.ВыбранныйСертификат.СписокВыбора[0].Значение;
			КонецЕсли;
		Иначе
			Возврат;
		КонецЕсли;
	КонецЕсли;
		
	Если ТипЗнч(Параметры.ОбъектыДляОбработки) = Тип("Массив") И Параметры.ОбъектыДляОбработки.Количество() > 0 Тогда
		Если Параметры.ОбъектыДляОбработки.Количество() = 1 Тогда
			ЭлектронныйДокумент = Параметры.ОбъектыДляОбработки[0];
			ШаблонГиперссылки = НСтр("ru = '%1 № %2 от %3'");
			ВладелецЭД = Неопределено;
			Если ТипЗнч(ЭлектронныйДокумент) = Тип("ДокументСсылка.ПакетЭД") Тогда
				СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЭлектронныйДокумент, "Номер, Дата");
				ТекстГиперссылки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонГиперссылки,
					Строка(ТипЗнч(ЭлектронныйДокумент)),
					СтруктураРеквизитов.Номер, Формат(СтруктураРеквизитов.Дата, "ДЛФ=Д"));
				СтруктураРеквизитов.Вставить("ВладелецЭД", ЭлектронныйДокумент);
				НоваяСтрока = ТаблицаЭД.Добавить();
				НоваяСтрока.ЭлектронныйДокумент = ЭлектронныйДокумент;
				НоваяСтрока.ВладелецЭД          = ЭлектронныйДокумент;
			ИначеЕсли ТипЗнч(ЭлектронныйДокумент) = Тип("СправочникСсылка.ЭДПрисоединенныеФайлы") Тогда
				СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЭлектронныйДокумент,
					"ВидЭД, НомерДокументаОтправителя, ДатаДокументаОтправителя, Организация, ВладелецФайла,
					|НаименованиеФайла, Наименование, Расширение");
				Если ТипЗнч(СтруктураРеквизитов.ВладелецФайла) = Тип("СправочникСсылка.СоглашенияОбИспользованииЭД") Тогда
					Если СтруктураРеквизитов.ВидЭД = Перечисления.ВидыЭД.КаталогТоваров Тогда
						ШаблонГиперссылки = НСтр("ru = '%1 %2 от %3'");
						ТекстГиперссылки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонГиперссылки,
							СтруктураРеквизитов.ВидЭД, СтруктураРеквизитов.Организация,
							Формат(СтруктураРеквизитов.ДатаДокументаОтправителя, "ДЛФ=Д"));
					Иначе
						ТекстГиперссылки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонГиперссылки,
							СтруктураРеквизитов.ВидЭД, СтруктураРеквизитов.НомерДокументаОтправителя,
							Формат(СтруктураРеквизитов.ДатаДокументаОтправителя, "ДЛФ=Д"));
					КонецЕсли;
				ИначеЕсли СтруктураРеквизитов.ВидЭД = Перечисления.ВидыЭД.ПроизвольныйЭД Тогда
					ТекстГиперссылки = ?(ЗначениеЗаполнено(СтруктураРеквизитов.НаименованиеФайла),
						СтруктураРеквизитов.НаименованиеФайла, СтруктураРеквизитов.Наименование) + "." + СтруктураРеквизитов.Расширение;
				ИначеЕсли ЭлектронныеДокументыСлужебныйВызовСервера.ЭтоСлужебныйДокумент(ЭлектронныйДокумент) Тогда
					ВидОперации = НСтр("ru = 'Подписание служебных электронных документов'");
					
					ШаблонГиперссылки = НСтр("ru = '%1'");
					ТекстГиперссылки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонГиперссылки,
						СтруктураРеквизитов.ВидЭД);
				Иначе
					РеквизитыВладельца = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СтруктураРеквизитов.ВладелецФайла, "Номер, Дата");
					ТекстГиперссылки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонГиперссылки,
						Строка(ТипЗнч(СтруктураРеквизитов.ВладелецФайла)),
						РеквизитыВладельца.Номер, Формат(РеквизитыВладельца.Дата, "ДЛФ=Д"));
				КонецЕсли;
				НоваяСтрока = ТаблицаЭД.Добавить();
				НоваяСтрока.ЭлектронныйДокумент = ЭлектронныйДокумент;
				НоваяСтрока.ВладелецЭД          = СтруктураРеквизитов.ВладелецФайла;
			КонецЕсли;
		Иначе
			Соответствие = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(Параметры.ОбъектыДляОбработки, "ВладелецФайла");
			Для Каждого КлючИЗначение Из Соответствие Цикл
				НоваяСтрока = ТаблицаЭД.Добавить();
				НоваяСтрока.ЭлектронныйДокумент = КлючИЗначение.Ключ;
				НоваяСтрока.ВладелецЭД          = КлючИЗначение.Значение.ВладелецФайла;
			КонецЦикла;
			ШаблонГиперссылки = НСтр("ru = 'Электронные документы (%1)'");
			ТекстГиперссылки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонГиперссылки,
				Параметры.ОбъектыДляОбработки.Количество());
		КонецЕсли;
		
		ТекстГиперссылки = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ТекстГиперссылки);
		НадписьОбъектыДляОбработки = ТекстГиперссылки;
	КонецЕсли;
	
	КлючСохраненияПоложенияОкна = ?(ТаблицаЭД.Количество() > 0, "СОбъектами", "БезОбъектов");
	УстановитьДоступностьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Элементы.ВыбранныйСертификат.СписокВыбора.Количество() = 1 Тогда
		ОбработкаВыбораСертификата();
	КонецЕсли;
	ОбновитьОтображениеДанных();
	
	Если ЗначениеЗаполнено(Пользователь) Тогда
		ТекущийЭлемент = Элементы.ПарольАвторизации;
	КонецЕсли;
	
КонецПроцедуры