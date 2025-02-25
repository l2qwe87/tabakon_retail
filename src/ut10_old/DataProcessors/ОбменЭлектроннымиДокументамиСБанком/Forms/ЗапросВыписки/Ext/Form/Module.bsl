﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Параметры.СоглашениеЭД) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	РеквизитыСоглашения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		Параметры.СоглашениеЭД, "Организация, Контрагент, ПрограммаБанка");
	
	ПрограммаБанка = РеквизитыСоглашения.ПрограммаБанка;

	МассивБанковскихСчетов = Новый Массив;
	Если ЗначениеЗаполнено(Параметры.НомерСчета) Тогда
		МассивБанковскихСчетов.Добавить(Параметры.НомерСчета);
	Иначе
		ЭлектронныеДокументыПереопределяемый.ПолучитьНомераБанковскихСчетов(РеквизитыСоглашения.Организация,
																			РеквизитыСоглашения.Контрагент,
																			МассивБанковскихСчетов);
	КонецЕсли;
	
	Если ПрограммаБанка = Перечисления.ПрограммыБанка.ОбменЧерезДопОбработку Тогда
		БИК = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РеквизитыСоглашения.Контрагент, "Код");
		ХранилищеСчетов = ПоместитьВоВременноеХранилище(МассивБанковскихСчетов, УникальныйИдентификатор);
		ДанныеСертификатов = ДанныеСертификатов(Параметры.СоглашениеЭД);
		ХранилищеДанныхСертификатов = ПоместитьВоВременноеХранилище(ДанныеСертификатов, УникальныйИдентификатор);
	Иначе
		ЭД = СформироватьЭДЗаказВыписки(
			Параметры.ДатаНачала, Параметры.ДатаОкончания, Параметры.СоглашениеЭД, МассивБанковскихСчетов);
		Если Не ЗначениеЗаполнено(ЭД) Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
	ВыполнятьКриптооперацииНаСервере = ЭлектронныеДокументыСлужебныйВызовСервера.ВыполнятьКриптооперацииНаСервере();
	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Перем ЗапросОтправлен, ВыпискаБанка;
	
	Если ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.ОбменЧерезДопОбработку") Тогда
		Отказ = Истина;
		ПолучитьВыпискуЧерезДопОбработку();
		Возврат;
	КонецЕсли;
	
	Попытка
		Если ВыполнятьКриптооперацииНаСервере Тогда
			МассивСтруктурСертификатов = ЭлектронныеДокументыСлужебныйВызовСервера.ПолучитьМассивСтруктурСертификатов(Истина);
		Иначе
			МассивСтруктурСертификатов = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьМассивСтруктурСертификатов(Истина);
		КонецЕсли;
		МассивСтруктурДоступныхСертификатов = МассивСтруктурДоступныхДляПодписиСертификатов(МассивСтруктурСертификатов);
	Исключение
		МассивСтруктурДоступныхСертификатов = Новый Массив;
	КонецПопытки;
	
	НастройкиОбмена = ОпределитьНастройкиОбменаЭДПоИсточнику(МассивСтруктурДоступныхСертификатов, ЭД, Параметры.СоглашениеЭД);
	
	Если НастройкиОбмена = Неопределено Тогда
		Отказ = Истина;
		ПроизошлаОшибка = Истина;
		Возврат;
	КонецЕсли;
	
	МассивЭД = Новый Массив;
	МассивЭД.Добавить(ЭД);
	
	Если НастройкиОбмена.Подписывать Тогда
		Если НЕ ЗначениеЗаполнено(НастройкиОбмена.СертификатОрганизацииДляПодписи)
				ИЛИ НЕ НастройкиОбмена.СертификатДоступен Тогда
			ТекстСообщения = НСтр("ru = 'Не найден подходящий сертификат для подписи документа Запрос выписки'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
			ПроизошлаОшибка = Истина;
			Возврат;
		КонецЕсли;
		
		ПараметрыСертификата = ЭлектронныеДокументыСлужебныйВызовСервера.РеквизитыСертификата(
			НастройкиОбмена.СертификатОрганизацииДляПодписи);
		Соответствие = Новый Соответствие;
		Соответствие.Вставить(НастройкиОбмена.СертификатОрганизацииДляПодписи, ПараметрыСертификата);
		ВидОперации = НСтр("ru = 'Подписание электронных документов'");
		КолПодписанных = 0;
		Если ЭлектронныеДокументыСлужебныйКлиент.ПарольКСертификатуПолучен(Соответствие, ВидОперации, МассивЭД)
			И Соответствие.Количество() > 0 Тогда
			Для Каждого КлючИЗначение Из Соответствие Цикл
				КолПодписанных = ЭлектронныеДокументыСлужебныйКлиент.ПодписатьЭДОпределеннымСертификатом(МассивЭД,
				                                                                   КлючИЗначение.Ключ,
				                                                                   КлючИЗначение.Значение);
				Прервать;
			КонецЦикла;
		КонецЕсли;
	
		Если КолПодписанных = 0 тогда
			ПроизошлаОшибка = Истина;
			Закрыть();
			Возврат;
		ИначеЕсли КолПодписанных = Неопределено Тогда
			Закрыть();
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("СоглашениеЭД", Параметры.СоглашениеЭД);
	ПараметрыЗапроса.Вставить("Пользователь", Параметры.Пользователь);
	ПараметрыЗапроса.Вставить("Пароль", Параметры.Пароль);
	ПараметрыЗапроса.Вставить("ЭД", ЭД);
	
	ОперацияВыполнена = ОтправитьЗапросНаСервере(
		ПараметрыЗапроса, ИБФайловая, АдресХранилища, УникальныйИдентификатор, ИдентификаторЗадания, ПроизошлаОшибка);
	
	Если ОперацияВыполнена Тогда
		ОбработатьРезультатЗапроса();
		Возврат;
	КонецЕсли;
	
	// Операция еще не завершена, выполняется с помощью фонового задания (асинхронно).
	ПараметрыОбработчикаОжидания = Новый Структура(
												"МинимальныйИнтервал, МаксимальныйИнтервал, ТекущийИнтервал, КоэффициентУвеличенияИнтервала",
												1,
												15,
												1,
												1.4);
	ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если ПроизошлаОшибка Тогда
		Отказ = Истина;
		ПроизошлаОшибка = Ложь;
		Элементы.ДекорацияПоясняющийТекстДлительнойОперации.Заголовок = "Ошибка";
		Элементы.ДекорацияДлительнаяОперация.Видимость = Ложь;
		Элементы.ФормаОтмена.Заголовок = "Закрыть";
	КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	ПриЗакрытииНаСервере(ИдентификаторЗадания);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервереБезКонтекста
Функция ОпределитьНастройкиОбменаЭДПоИсточнику(МассивСтруктурДоступныхСертификатов, Знач ЭД, Знач СоглашениеЭД)
	
	Возврат ЭлектронныеДокументыСлужебный.ОпределитьНастройкиОбменаЭДПоИсточнику(
					СоглашениеЭД, Истина, МассивСтруктурДоступныхСертификатов, ЭД);
	
КонецФункции

&НаСервереБезКонтекста
Функция ОтправитьЗапросНаСервере(Знач ПараметрыЗапроса, ИБФайловая, АдресХранилища, УникальныйИдентификатор, ИдентификаторЗадания, ЕстьОшибка)
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	
	Если ИБФайловая Тогда
		ЭлектронныеДокументыСлужебный.ОтправитьЗапросВыпискиВБанк(ПараметрыЗапроса, АдресХранилища, ЕстьОшибка);
		Возврат Истина;
	КонецЕсли;
	
	ЗаданиеВыполнено = Ложь;
		
	// В клиент-серверном режиме работы выполняем операцию в фоновом задании (асинхронно).
	НаименованиеЗадания = НСтр("ru = 'Отправка запроса выписки в банк'");
	ПараметрыВыполнения = Новый Массив;
	ПараметрыВыполнения.Добавить(ПараметрыЗапроса);
	ПараметрыВыполнения.Добавить(АдресХранилища);
	ПараметрыВыполнения.Добавить(Ложь);
	
	Если ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая Тогда
		ВремяОжидания = 4;
	Иначе
		ВремяОжидания = 2;
	КонецЕсли;
	
	Задание = ФоновыеЗадания.Выполнить(
					"ЭлектронныеДокументыСлужебный.ОтправитьЗапросВыпискиВБанк",
					ПараметрыВыполнения,
					,
					НаименованиеЗадания);
	Попытка
		Задание.ОжидатьЗавершения(ВремяОжидания);
	Исключение
		// Специальная обработка не требуется. Предположительно, исключение вызвано истечением времени ожидания.
	КонецПопытки;

	ИдентификаторЗадания = Задание.УникальныйИдентификатор;
	// Если операция уже завершилась, то сразу обрабатываем результат.
	Если ДлительныеОперации.ЗаданиеВыполнено(Задание.УникальныйИдентификатор) Тогда
		ЗаданиеВыполнено = Истина;
	КонецЕсли;
	Возврат ЗаданиеВыполнено;
	
КонецФункции

&НаСервереБезКонтекста
Функция МассивСтруктурДоступныхДляПодписиСертификатов(Знач МассивСтруктурСертификатов)
	
	Возврат ЭлектронныеДокументыСлужебный.МассивСтруктурДоступныхДляПодписиСертификатов(МассивСтруктурСертификатов);
	
КонецФункции

&НаСервереБезКонтекста
Процедура ПриЗакрытииНаСервере(Знач ИдентификаторЗадания)
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()

	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
			ОбработатьРезультатЗапроса();
		КонецЕсли;
	Исключение
		ВызватьИсключение;
	КонецПопытки;

	ПараметрыОбработчикаОжидания.ТекущийИнтервал = ПараметрыОбработчикаОжидания.ТекущийИнтервал
													* ПараметрыОбработчикаОжидания.КоэффициентУвеличенияИнтервала;
	Если ПараметрыОбработчикаОжидания.ТекущийИнтервал > ПараметрыОбработчикаОжидания.МаксимальныйИнтервал Тогда
		ПараметрыОбработчикаОжидания.ТекущийИнтервал = ПараметрыОбработчикаОжидания.МаксимальныйИнтервал;
	КонецЕсли;
	ПодключитьОбработчикОжидания(
							"Подключаемый_ПроверитьВыполнениеЗадания",
							ПараметрыОбработчикаОжидания.ТекущийИнтервал,
							Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультатЗапроса()

	КолОтправленных = 0;
	КолПолученных = 0;
	
	СтруктураВозврата = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	ПроизошлаОшибка = СтруктураВозврата.ЕстьОшибка;
	Если ПроизошлаОшибка Тогда
		Если НЕ ИБФайловая Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтруктураВозврата.ТекстОшибки);
			ПриЗакрытииНаСервере(ИдентификаторЗадания);
		КонецЕсли;
		Закрыть();
		Возврат
	КонецЕсли;
	
	Если СтруктураВозврата.ЗапросОтправлен Тогда
		КолОтправленных = 1;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтруктураВозврата.ВыпискаБанка) Тогда
		КолПолученных = 1;
		
		Если НЕ ВыполнятьКриптооперацииНаСервере И СтруктураВозврата.Подписи.Количество() > 0 Тогда
			
			ДобавитьПодписиВЭлектронныйДокумент(СтруктураВозврата.ВыпискаБанка, СтруктураВозврата.Подписи);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаголовокОповещения = НСтр("ru = 'Обмен электронными документами'");
	ТекстОповещения = НСтр("ru = 'Отправленных пакетов нет'");
	
	Если КолОтправленных > 0 Тогда
		ТекстОповещения = НСтр("ru = 'Отправлено документов: (%1)'");
		ТекстОповещения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОповещения, КолОтправленных);
	КонецЕсли;
	
	Если КолПолученных = 0 Тогда
		ТекстОповещения = ТекстОповещения + НСтр("ru = ', полученных документов нет'");
	Иначе
		ТекстОповещения = ТекстОповещения
		+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = ', получено документов: (%1)'"), КолПолученных);
	КонецЕсли;
	
	Оповестить("ОбновитьСостояниеЭД");
	
	ПоказатьОповещениеПользователя(ЗаголовокОповещения, , ТекстОповещения);
	
	ОповеститьОВыборе(СтруктураВозврата.ВыпискаБанка);

КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(Знач ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура ДобавитьПодписиВЭлектронныйДокумент(ЭД, Подписи)
	
	Попытка
		НастройкиКриптографии = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьПерсональныеНастройкиРаботыСЭЦП();
		ПровайдерЭЦП = НастройкиКриптографии.ПровайдерЭЦП;
		ПутьМодуляКриптографии = НастройкиКриптографии.ПутьМодуляКриптографии;
		ТипПровайдераЭЦП = НастройкиКриптографии.ТипПровайдераЭЦП;
			
		МенеджерКриптографии = Новый МенеджерКриптографии(ПровайдерЭЦП, ПутьМодуляКриптографии, ТипПровайдераЭЦП);
		МенеджерКриптографии.АлгоритмПодписи     = НастройкиКриптографии.АлгоритмПодписи;
		МенеджерКриптографии.АлгоритмХеширования = НастройкиКриптографии.АлгоритмХеширования;
		МенеджерКриптографии.АлгоритмШифрования  = НастройкиКриптографии.АлгоритмШифрования;
	Исключение
		ТекстСообщения = ЭлектронныеДокументыСлужебныйВызовСервера.ПолучитьСообщениеОбОшибке("100");
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Операция = НСтр("ru = 'Инициализация криптосредства на компьютере'");
		ЭлектронныеДокументыСлужебныйВызовСервера.ОбработатьИсключениеПоЭДНаСервере(Операция,
																					ТекстОшибки,
																					ТекстСообщения,
																					1);
		Возврат;
	КонецПопытки;
	
	Для Каждого Подпись ИЗ Подписи Цикл
		СертификатыПодписи = МенеджерКриптографии.ПолучитьСертификатыИзПодписи(Подпись);
		Если СертификатыПодписи.Количество() > 0 Тогда
			Сертификат = СертификатыПодписи[0];
		Иначе
			Продолжить;
		КонецЕсли;
		ПредставлениеПользователя = ЭлектроннаяЦифроваяПодписьКлиентСервер.ПолучитьПредставлениеПользователя(
																							Сертификат.Субъект);
		Отпечаток = Base64Строка(Сертификат.Отпечаток);
		ДвоичныеДанныеСертификата = Сертификат.Выгрузить();
		ЗанестиИнформациюОПодписи(ЭД, Подпись, Отпечаток, ПредставлениеПользователя, ДвоичныеДанныеСертификата);
	КонецЦикла;
	
	ЭлектронныеДокументыСлужебныйКлиент.ОпределитьСтатусыПодписей(ЭД);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗанестиИнформациюОПодписи(Знач ЭД,
									Знач Подпись,
									Знач Отпечаток,
									Знач ПредставлениеПользователя,
									Знач ДвоичныеДанныеСертификата)
									
	ДатаУстановкиПодписи = ЭлектронныеДокументыСлужебный.ДатаУстановкиПодписи(Подпись);
	ДатаУстановкиПодписи = ?(ЗначениеЗаполнено(ДатаУстановкиПодписи), ДатаУстановкиПодписи, ТекущаяДатаСеанса());
	ЭлектроннаяЦифроваяПодпись.ЗанестиИнформациюОПодписи(
								ЭД,
								Подпись,
								Отпечаток,
								ДатаУстановкиПодписи,
								"",
								,
								ПредставлениеПользователя,
								ДвоичныеДанныеСертификата);

КонецПроцедуры

&НаСервере
Функция ДанныеСертификатов(СоглашениеЭД)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	СертификатыПодписейОрганизации.Сертификат
	|ПОМЕСТИТЬ Сертификаты
	|ИЗ
	|	Справочник.СоглашенияОбИспользованииЭД.СертификатыПодписейОрганизации КАК СертификатыПодписейОрганизации
	|ГДЕ
	|	СертификатыПодписейОрганизации.Ссылка = &СоглашениеЭД
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СертификатыЭЦП.Ссылка КАК Сертификат,
	|	СертификатыЭЦП.ФайлСертификата,
	|	СертификатыЭЦП.ЗапомнитьПарольКСертификату,
	|	СертификатыЭЦП.ПарольПользователя,
	|	СертификатыЭЦП.ПрограммаБанка
	|ИЗ
	|	Справочник.СертификатыЭЦП КАК СертификатыЭЦП
	|ГДЕ
	|	ВЫБОР
	|			КОГДА СертификатыЭЦП.ОграничитьДоступКСертификату
	|				ТОГДА СертификатыЭЦП.Пользователь = &ТекущийПользователь
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|	И СертификатыЭЦП.Ссылка В
	|			(ВЫБРАТЬ
	|				Сертификаты.Сертификат
	|			ИЗ
	|				Сертификаты)";
	Запрос.УстановитьПараметр("СоглашениеЭД", СоглашениеЭД);
	Запрос.УстановитьПараметр("ТекущийПользователь", Пользователи.АвторизованныйПользователь());
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаСертификаты = РезультатЗапроса.Выбрать();
	ДанныеСертификатов = Новый Массив;
	Пока ВыборкаСертификаты.Следующий() Цикл
		ДанныеСертификата = Новый Структура("Сертификат, ФайлСертификата, ЗапомнитьПарольКСертификату, ПарольПользователя, ПрограммаБанка");
		ЗаполнитьЗначенияСвойств(ДанныеСертификата, ВыборкаСертификаты);
		ДанныеСертификата.ФайлСертификата = ВыборкаСертификаты.ФайлСертификата.Получить();
		ДанныеСертификатов.Добавить(ДанныеСертификата);
	КонецЦикла;
	
	Возврат ДанныеСертификатов;
	
КонецФункции

&НаКлиенте
Процедура ПолучитьВыпискуЧерезДопОбработку()
	
	ВнешнийПодключаемыйМодуль = ЭлектронныеДокументыСлужебныйКлиент.ВнешнийПодключаемыйМодуль(Параметры.СоглашениеЭД);
	
	Если ВнешнийПодключаемыйМодуль = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСертификатов = ПолучитьИзВременногоХранилища(ХранилищеДанныхСертификатов);
	
	Устройства = ЭлектронныеДокументыСлужебныйКлиент.ПодключенныеХранилища(ВнешнийПодключаемыйМодуль);
	
	СписокВыбора = Новый Массив;
	Соответствие = Новый Соответствие;
	Если Устройства.Количество() > 0 Тогда
		Для Каждого ДанныеСертификата ИЗ ДанныеСертификатов Цикл
			ДанныеСертификатаЧерезДопОбработку = ЭлектронныеДокументыСлужебныйКлиент.ДанныеСертификатаЧерезДопОбработку(
			                                                                          ВнешнийПодключаемыйМодуль,
			                                                                          ДанныеСертификата.ФайлСертификата);
			Если Устройства.Найти(ДанныеСертификатаЧерезДопОбработку.ИдентификаторХранилища) <> Неопределено Тогда
				Соответствие.Вставить(ДанныеСертификата.Сертификат, ДанныеСертификата);
			КонецЕсли;
		КонецЦикла
	Иначе
		Возврат
	КонецЕсли;
	
	ВидОперации = НСтр("ru = 'Авторизация на ресурсе банка'");
	Если Соответствие.Количество() > 0 Тогда
		Если ЭлектронныеДокументыСлужебныйКлиент.ПарольКСертификатуПолучен(Соответствие, ВидОперации)
			И Соответствие.Количество() > 0 Тогда
			Для Каждого КлючИЗначение Из Соответствие Цикл
				ПарольПользователя = КлючИЗначение.Значение.ПарольПользователя;
				ВыбранныйСертификат = КлючИЗначение.Ключ;
				Прервать;
			КонецЦикла;
		Иначе
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Для Каждого ДанныеСертификата ИЗ ДанныеСертификатов Цикл
		Если ДанныеСертификата.Сертификат = ВыбранныйСертификат Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ДанныеСертификатаЧерезДопОбработку = ЭлектронныеДокументыСлужебныйКлиент.ДанныеСертификатаЧерезДопОбработку(
													ВнешнийПодключаемыйМодуль, ДанныеСертификата.ФайлСертификата);
	Если ДанныеСертификатаЧерезДопОбработку = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ПинКодУстановлен = ЭлектронныеДокументыСлужебныйКлиент.УстановитьПинКодЕслиТребуется(
		ВнешнийПодключаемыйМодуль, ДанныеСертификатаЧерезДопОбработку.ИдентификаторХранилища);
	Если Не ПинКодУстановлен Тогда
		Возврат;
	КонецЕсли;
	
	ПарольУстановлен = ЭлектронныеДокументыСлужебныйКлиент.УстановитьПарольСертификатаЧерезДополнительнуюОбработку(
									ВнешнийПодключаемыйМодуль, ДанныеСертификата.ФайлСертификата, ПарольПользователя);
	Если НЕ ПарольУстановлен Тогда
		Возврат;
	КонецЕсли;
	
	СоединениеУстановлено = ЭлектронныеДокументыСлужебныйКлиент.УстановитьСоединениеЧерезДопОбработку(
							Параметры.СоглашениеЭД, ВнешнийПодключаемыйМодуль, ДанныеСертификата.ФайлСертификата);
	Если Не СоединениеУстановлено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыВыписки = Новый Структура;
	ДатаНачалаСтрокой    = Формат(Параметры.ДатаНачала,    "ДЛФ=D");
	ДатаОкончанияСтрокой = Формат(Параметры.ДатаОкончания, "ДЛФ=D");
	НазваниеЭД = НСтр("ru = 'Выписка банка за период с %1 по %2'");
	НазваниеЭД = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НазваниеЭД, ДатаНачалаСтрокой, ДатаОкончанияСтрокой);
	КолПолученных = 0;
	
	МассивНомеровБанковскихСчетов = ПолучитьИзВременногоХранилища(ХранилищеСчетов);
	Для Каждого НомерСчета Из МассивНомеровБанковскихСчетов Цикл
		ПараметрыВыписки.Вставить("НомерСчета",        НомерСчета);
		ПараметрыВыписки.Вставить("БИК",               БИК);
		ПараметрыВыписки.Вставить("ДатаНачала"   ,     Формат(Параметры.ДатаНачала,    "ДФ=dd.MM.yyyy"));
		ПараметрыВыписки.Вставить("ДатаОкончания",     Формат(Параметры.ДатаОкончания, "ДФ=dd.MM.yyyy"));
		ПараметрыВыписки.Вставить("ВерсияСхемыДанных", ЭлектронныеДокументыКлиентСервер.ВерсияФорматаСинхронногоОбмена());
		ДанныеВыписки = ЭлектронныеДокументыСлужебныйКлиент.ОтправитьЗапросЧерезДопОбработку(
			ВнешнийПодключаемыйМодуль, ДанныеСертификата.ФайлСертификата, 2, ПараметрыВыписки);
		Если ДанныеВыписки = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Для Каждого Подпись Из ДанныеВыписки.Подписи Цикл
			
			ДанныеСертификатаПодписи = ЭлектронныеДокументыСлужебныйКлиент.ДанныеСертификатаЧерезДопОбработку(
																ВнешнийПодключаемыйМодуль, Подпись.Сертификат);
			Если ДанныеСертификатаПодписи = Неопределено Тогда
				Возврат;
			КонецЕсли;
			Подпись.Вставить("ДанныеСертификата", ДанныеСертификатаПодписи);
			
		КонецЦикла;
		
		ЭДВыписка = СохранитьВыписку(ДанныеВыписки, Параметры.СоглашениеЭД, НазваниеЭД);
		ЭлектронныеДокументыСлужебныйКлиент.ОпределитьСтатусыПодписейЧерезДопОбработку(ЭДВыписка, ВнешнийПодключаемыйМодуль);
		ЭлектронныеДокументыСлужебныйВызовСервера.ОпределитьИсполненныеПлатежныеПоручения(ЭДВыписка);
		КолПолученных = КолПолученных + 1;
	КонецЦикла;
			
	ЗаголовокОповещения = НСтр("ru = 'Обмен электронными документами'");
			
	Если КолПолученных = 0 Тогда
		ТекстОповещения = НСтр("ru = 'Полученных документов нет'");
	Иначе
		ТекстОповещения = НСтр("ru = 'Получено документов: (%1)'");
		ТекстОповещения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОповещения, КолПолученных);
	КонецЕсли;
		
	Оповестить("ОбновитьСостояниеЭД");
		
	ПоказатьОповещениеПользователя(ЗаголовокОповещения, , ТекстОповещения);
	
	ОповеститьОВыборе(ЭДВыписка);
	
КонецПроцедуры


&НаСервере
Функция ПолучитьЗаказВыпискиCML(ДатаНачала, ДатаКонца, МассивБанковскихСчетов, Банк)
	
	Попытка
		URI = "urn:1C.ru:ClientBankExchange";
		
		Пакет = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(URI,"ClientBankExchange"));
		Пакет.ВерсияФормата = ЭлектронныеДокументыКлиентСервер.ВерсияФорматаСинхронногоОбмена();
		Пакет.Получатель = Банк.Наименование;
		Пакет.Отправитель = "1С: Предприятие";
		Пакет.ДатаСоздания = ТекущаяДатаСеанса();
		Пакет.ВремяСоздания = ТекущаяДатаСеанса();
		
		УсловияОтбора = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(URI,"УсловияОтбора"));
		УсловияОтбора.ДатаНачала = ДатаНачала;
		УсловияОтбора.ДатаКонца = ДатаКонца;
		Для Каждого НомерСчета Из МассивБанковскихСчетов Цикл
			УсловияОтбора.РасчСчет.Добавить(НомерСчета);
		КонецЦикла;
		
		Пакет.УсловияОтбора = УсловияОтбора;
		
		Пакет.Проверить();
		
	Исключение
		ШаблонСообщения = НСтр("ru = '%1 (подробности см. в Журнале регистрации).'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения,
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЭлектронныеДокументыСлужебныйВызовСервера.ОбработатьИсключениеПоЭДНаСервере(НСтр("ru = 'Формирование ЭД'"),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()), ТекстСообщения, 1);
		
		Возврат Неопределено;
	КонецПопытки;
	
	Возврат Пакет;
	
КонецФункции


&НаСервереБезКонтекста
Функция СохранитьВыписку(Знач ДанныеВыписки, Знач СоглашениеЭД, Знач НазваниеЭД)
	
	РеквизитыСоглашения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СоглашениеЭД, "Организация, Контрагент");
	
	
	АдресФайла = ПоместитьВоВременноеХранилище(ДанныеВыписки.Выписка);
	ДобавленныйФайл = ПрисоединенныеФайлы.ДобавитьФайл(
							СоглашениеЭД,
							НазваниеЭД,
							"xml",
							ТекущаяДатаСеанса(),
							ТекущаяДатаСеанса(),
							АдресФайла,
							,
							,
							Справочники.ЭДПрисоединенныеФайлы.ПолучитьСсылку());
		
	Ответственный = ЭлектронныеДокументыПереопределяемый.ПолучитьОтветственногоПоЭД(
										РеквизитыСоглашения.Контрагент, СоглашениеЭД);
	
	СтруктураЭД = Новый Структура;
	СтруктураЭД.Вставить("Автор",                    Пользователи.АвторизованныйПользователь());
	СтруктураЭД.Вставить("НаправлениеЭД",            Перечисления.НаправленияЭД.Входящий);
	СтруктураЭД.Вставить("СтатусЭД",                 Перечисления.СтатусыЭД.Получен);
	СтруктураЭД.Вставить("Ответственный",            Ответственный);
	СтруктураЭД.Вставить("Организация",              РеквизитыСоглашения.Организация);
	СтруктураЭД.Вставить("ВидЭД",                    Перечисления.ВидыЭД.ВыпискаБанка);
	СтруктураЭД.Вставить("СоглашениеЭД",             СоглашениеЭД);
	СтруктураЭД.Вставить("Контрагент",               РеквизитыСоглашения.Контрагент);
	СтруктураЭД.Вставить("ДатаИзмененияСтатусаЭД",   ТекущаяДатаСеанса());
	СтруктураЭД.Вставить("ДатаДокументаОтправителя", ТекущаяДатаСеанса());
	СтруктураЭД.Вставить("НаименованиеФайла",        НазваниеЭД);
	
	ЭлектронныеДокументыСлужебный.ИзменитьПоСсылкеПрисоединенныйФайл(ДобавленныйФайл, СтруктураЭД, Ложь);
	
	Для Каждого Подпись ИЗ ДанныеВыписки.Подписи Цикл
		ДанныеПодписи = Новый Структура;
		ДанныеПодписи.Вставить("НоваяПодписьДвоичныеДанные", Подпись.Подпись);
		ДанныеПодписи.Вставить("Отпечаток",                  Подпись.ДанныеСертификата.Отпечаток);
		ДанныеПодписи.Вставить("ДатаПодписи",                ТекущаяДатаСеанса());
		ДанныеПодписи.Вставить("Комментарий",                "");
		ДанныеПодписи.Вставить("ИмяФайлаПодписи",            НСтр("ru='Подпись'"));
		ДанныеПодписи.Вставить("КомуВыданСертификат",        Подпись.ДанныеСертификата.ВладелецФИО);
		ДанныеПодписи.Вставить("ДвоичныеДанныеСертификата",  Подпись.Сертификат);
		ЭлектронныеДокументыСлужебныйВызовСервера.ДобавитьПодпись(ДобавленныйФайл, ДанныеПодписи);
	КонецЦикла;
	
	Возврат ДобавленныйФайл;
	
КонецФункции

&НаСервере
Функция СформироватьЭДЗаказВыписки(ДатаНачала, ДатаОкончания, СоглашениеЭД, МассивБанковскихСчетов)
	
	РеквизитыСоглашения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СоглашениеЭД, "Организация, Контрагент");
	
	Если МассивБанковскихСчетов.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Не найдены актуальные банковские счета для организации: %1 с банком: %2'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
															ТекстСообщения,
															РеквизитыСоглашения.Организация,
															РеквизитыСоглашения.Контрагент);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат Неопределено;
	КонецЕсли;

	Ответственный = ЭлектронныеДокументыПереопределяемый.ПолучитьОтветственногоПоЭД(РеквизитыСоглашения.Контрагент,
																					СоглашениеЭД);
	
	ПакетXDTO = ПолучитьЗаказВыпискиCML(ДатаНачала,
										ДатаОкончания,
										МассивБанковскихСчетов,
										РеквизитыСоглашения.Контрагент);
		
	Если ПакетXDTO=Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПолноеИмяФайла = ПолучитьИмяВременногоФайла("xml");
	Запись = Новый ЗаписьXML;
	Запись.ОткрытьФайл(ПолноеИмяФайла);
	Запись.ЗаписатьОбъявлениеXML();

	ФабрикаXDTO.ЗаписатьXML(Запись,
							ПакетXDTO,
							"ClientBankExchange",
							"urn:1C.ru:ClientBankExchange",
							,
							НазначениеТипаXML.Явное);
	
	Запись.Закрыть();
	
	ДвоичныеДанные = Новый ДвоичныеДанные(ПолноеИмяФайла);
	АдресФайла = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
	
	ШаблонСообщения = НСтр("ru='Запрос выписки с %1 по %2'");
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения,
																			 Формат(ДатаНачала, "ДЛФ=D"), 
																			 Формат(ДатаОкончания, "ДЛФ=D"));
	
	ЭД = ПрисоединенныеФайлы.ДобавитьФайл(СоглашениеЭД,
										  ТекстСообщения,
										  "xml",
										  ТекущаяДатаСеанса(),
										  ТекущаяДатаСеанса(),
										  АдресФайла,
										  ,
										  ,
										  Справочники.ЭДПрисоединенныеФайлы.ПолучитьСсылку());

	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("Автор", Пользователи.АвторизованныйПользователь());
	СтруктураПараметров.Вставить("НаправлениеЭД", Перечисления.НаправленияЭД.Исходящий);
	СтруктураПараметров.Вставить("ВидЭД", Перечисления.ВидыЭД.ЗапросВыписки);
	СтруктураПараметров.Вставить("СтатусЭД", Перечисления.СтатусыЭД.Сформирован);
	СтруктураПараметров.Вставить("Ответственный", Ответственный);
	СтруктураПараметров.Вставить("Организация", РеквизитыСоглашения.Организация);
	СтруктураПараметров.Вставить("Контрагент", РеквизитыСоглашения.Контрагент);
	СтруктураПараметров.Вставить("ВладелецЭД", СоглашениеЭД);
	СтруктураПараметров.Вставить("СоглашениеЭД", СоглашениеЭД);
	СтруктураПараметров.Вставить("ДатаДокументаОтправителя", ТекущаяДатаСеанса());
	СтруктураПараметров.Вставить("НаименованиеФайла", ТекстСообщения);
	
	ЭлектронныеДокументыСлужебный.ИзменитьПоСсылкеПрисоединенныйФайл(ЭД, СтруктураПараметров);
	
	Возврат ЭД;
	
КонецФункции
