﻿#Если Клиент Тогда
	
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ НАЧАЛЬНОЙ НАСТРОЙКИ ОТЧЕТА

// Процедура установки начальных настроек отчета с использованием текста запроса
//
Процедура УстановитьНачальныеНастройки(ДополнительныеПараметры = Неопределено) Экспорт
	
	// Настройка общих параметров универсального отчета
	
	// Содержит название отчета, которое будет выводиться в шапке.
	// Тип: Строка.
	// Пример:
	// УниверсальныйОтчет.мНазваниеОтчета = "Название отчета";
	УниверсальныйОтчет.мНазваниеОтчета = СокрЛП(ЭтотОбъект.Метаданные().Синоним);
	
	// Содержит признак необходимости отображения надписи и поля выбора раздела учета в форме настройки.
	// Тип: Булево.
	// Значение по умолчанию: Истина.
	// Пример:
	УниверсальныйОтчет.мВыбиратьИмяРегистра = Ложь;
	
	// Содержит имя регистра, по метаданным которого будет выполняться заполнение настроек отчета.
	// Тип: Строка.
	// Пример:
	// УниверсальныйОтчет.ИмяРегистра = "ТоварыНаСкладах";
	
	// Содержит признак необходимости вывода отрицательных значений показателей красным цветом.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.ОтрицательноеКрасным = Истина;
	
	// Содержит признак необходимости вывода в отчет общих итогов.
	// Тип: Булево.
	// Значение по умолчанию: Истина.
	// Пример:
	УниверсальныйОтчет.ВыводитьОбщиеИтоги = Ложь;
	
	// Содержит признак необходимости вывода детальных записей в отчет.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	УниверсальныйОтчет.ВыводитьДетальныеЗаписи = Истина;
	
	// Содержит признак необходимости отображения флага использования свойств и категорий в форме настройки.
	// Тип: Булево.
	// Значение по умолчанию: Истина.
	// Пример:
	// УниверсальныйОтчет.мВыбиратьИспользованиеСвойств = Ложь;
	
	// Содержит признак использования свойств и категорий при заполнении настроек отчета.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.ИспользоватьСвойстваИКатегории = Истина;
	
	// Содержит признак использования простой формы настроек отчета без группировок колонок.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.мРежимФормыНастройкиБезГруппировокКолонок = Истина;
	
	// Дополнительные параметры, переданные из отчета, вызвавшего расшифровку.
	// Информация, передаваемая в переменной ДополнительныеПараметры, может быть использована
	// для реализации специфичных для данного отчета параметрических настроек.
	
	// Описание исходного текста запроса.
	// При написании текста запроса рекомендуется следовать правилам, описанным в следующем шаблоне текста запроса:
	//
	//ВЫБРАТЬ // РАЗРЕШЕННЫЕ
	//	<ПсевдонимТаблицы.Поле> КАК <ПсевдонимПоля>,
	//	ПРЕДСТАВЛЕНИЕ(<ПсевдонимТаблицы>.<Поле>),
	//	<ПсевдонимТаблицы.Показатель> КАК <ПсевдонимПоказателя>
	//	<ПсевдонимТаблицы>.Регистратор КАК Регистратор,
	//	<ПсевдонимТаблицы>.Период КАК Период,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, ДЕНЬ) КАК ПериодДень,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, НЕДЕЛЯ) КАК ПериодНеделя,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, ДЕКАДА) КАК ПериодДекада,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, МЕСЯЦ) КАК ПериодМесяц,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, КВАРТАЛ) КАК ПериодКвартал,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, ПОЛУГОДИЕ) КАК ПериодПолугодие,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, ГОД) КАК ПериодГод
	//	//ПОЛЯ_СВОЙСТВА
	//	//ПОЛЯ_КАТЕГОРИИ
	//{ВЫБРАТЬ
	//	<ПсевдонимПоля>.*,
	//	<ПсевдонимПоказателя>,
	//	Регистратор,
	//	Период,
	//	ПериодДень,
	//	ПериодНеделя,
	//	ПериодДекада,
	//	ПериодМесяц,
	//	ПериодКвартал,
	//	ПериодПолугодие,
	//	ПериодГод
	//	//ПОЛЯ_СВОЙСТВА
	//	//ПОЛЯ_КАТЕГОРИИ
	//}
	//ИЗ
	//	<Таблица> КАК <ПсевдонимТаблицы>
	//	//СОЕДИНЕНИЯ
	//{ГДЕ
	//	<ПсевдонимТаблицы.Поле>.* КАК <ПсевдонимПоля>,
	//	<ПсевдонимТаблицы.Показатель> КАК <ПсевдонимПоказателя>,
	//	<ПсевдонимТаблицы>.Регистратор КАК Регистратор,
	//	<ПсевдонимТаблицы>.Период КАК Период,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, ДЕНЬ) КАК ПериодДень,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, НЕДЕЛЯ) КАК ПериодНеделя,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, ДЕКАДА) КАК ПериодДекада,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, МЕСЯЦ) КАК ПериодМесяц,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, КВАРТАЛ) КАК ПериодКвартал,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, ПОЛУГОДИЕ) КАК ПериодПолугодие,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, ГОД) КАК ПериодГод
	//	//ПОЛЯ_СВОЙСТВА
	//	//ПОЛЯ_КАТЕГОРИИ
	//}
	//{УПОРЯДОЧИТЬ ПО
	//	<ПсевдонимПоля>.*,
	//	<ПсевдонимПоказателя>,
	//	Регистратор,
	//	Период,
	//	ПериодДень,
	//	ПериодНеделя,
	//	ПериодДекада,
	//	ПериодМесяц,
	//	ПериодКвартал,
	//	ПериодПолугодие,
	//	ПериодГод
	//	//УПОРЯДОЧИТЬ_СВОЙСТВА
	//	//УПОРЯДОЧИТЬ_КАТЕГОРИИ
	//}
	//ИТОГИ
	//	АГРЕГАТНАЯ_ФУНКЦИЯ(<ПсевдонимПоказателя>)
	//	//ИТОГИ_СВОЙСТВА
	//	//ИТОГИ_КАТЕГОРИИ
	//ПО
	//	ОБЩИЕ
	//{ИТОГИ ПО
	//	<ПсевдонимПоля>.*,
	//	Регистратор,
	//	Период,
	//	ПериодДень,
	//	ПериодНеделя,
	//	ПериодДекада,
	//	ПериодМесяц,
	//	ПериодКвартал,
	//	ПериодПолугодие,
	//	ПериодГод
	//	//ПОЛЯ_СВОЙСТВА
	//	//ПОЛЯ_КАТЕГОРИИ
	//}
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РезультатыАнкетирования.ФизЛицо КАК ФизЛицо,
	|	ПРЕДСТАВЛЕНИЕ(РезультатыАнкетирования.ФизЛицо),
	|	РезультатыАнкетирования.Анкета,
	|	ПРЕДСТАВЛЕНИЕ(РезультатыАнкетирования.Анкета),
	|	РезультатыАнкетирования.ДатаАнкетирования,
	|	РезультатыАнкетирования.Вопрос,
	|	ПРЕДСТАВЛЕНИЕ(РезультатыАнкетирования.Вопрос),
	|	РезультатыАнкетирования.Ответ,
	|	ПРЕДСТАВЛЕНИЕ(РезультатыАнкетирования.Ответ),
	|	РезультатыАнкетирования.ТиповойОтвет,
	|	ВариантыОтветовОпросов.ОценкаОтвета КАК ОценкаОтвета,
	|	ТиповыеАнкетыВопросыАнкеты.ВесВопроса КАК ВесВопроса,
	|	ТиповыеАнкетыВопросыАнкеты.ВесВопроса * ВариантыОтветовОпросов.ОценкаОтвета КАК АбсолютнаяОценка
	|	//ПОЛЯ_СВОЙСТВА
	|	//ПОЛЯ_КАТЕГОРИИ
	|
	|{ВЫБРАТЬ
	|	ФизЛицо.*,
	|	Анкета.*,
	|	ДатаАнкетирования,
	|	Вопрос.*,
	|	Ответ,
	|	ТиповойОтвет,
	|	ОценкаОтвета,
	|	ВесВопроса,
	|	АбсолютнаяОценка
	|	//ПСЕВДОНИМЫ_СВОЙСТВА
	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ
	|}
	|ИЗ
	|	(ВЫБРАТЬ
	|		ОпросВопросы.Ссылка.ОпрашиваемоеЛицо КАК ФизЛицо,
	|		ОпросВопросы.Ссылка.ТиповаяАнкета КАК Анкета,
	|		ОпросВопросы.Ссылка.Дата КАК ДатаАнкетирования,
	|		ОпросВопросы.Вопрос КАК Вопрос,
	|		ОпросВопросы.Ответ КАК Ответ,
	|		ОпросВопросы.ТиповойОтвет КАК ТиповойОтвет
	|	ИЗ
	|		Документ.Опрос.Вопросы КАК ОпросВопросы
	|	ГДЕ
	|		ОпросВопросы.ТиповойОтвет <> НЕОПРЕДЕЛЕНО
	|		И ОпросВопросы.ТиповойОтвет <> &ПустойОтвет
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ОпросСоставнойОтвет.Ссылка.ОпрашиваемоеЛицо,
	|		ОпросСоставнойОтвет.Ссылка.ТиповаяАнкета,
	|		ОпросСоставнойОтвет.Ссылка.Дата,
	|		ОпросСоставнойОтвет.ВопросВладелец,
	|		ОпросСоставнойОтвет.Ответ,
	|		ОпросСоставнойОтвет.ТиповойОтвет
	|	ИЗ
	|		Документ.Опрос.СоставнойОтвет КАК ОпросСоставнойОтвет) КАК РезультатыАнкетирования
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ТиповыеАнкеты.ВопросыАнкеты КАК ТиповыеАнкетыВопросыАнкеты
	|		ПО РезультатыАнкетирования.Анкета = ТиповыеАнкетыВопросыАнкеты.Ссылка
	|			И РезультатыАнкетирования.Вопрос = ТиповыеАнкетыВопросыАнкеты.Вопрос
	|		{ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВариантыОтветовОпросов КАК ВариантыОтветовОпросов
	|		ПО РезультатыАнкетирования.ТиповойОтвет = ВариантыОтветовОпросов.Ссылка}
	|		//СОЕДИНЕНИЯ
	|{ГДЕ
	|	РезультатыАнкетирования.ФизЛицо.*,
	|	РезультатыАнкетирования.Анкета.*,
	|	РезультатыАнкетирования.ДатаАнкетирования,
	|	РезультатыАнкетирования.Вопрос.* КАК Вопрос,
	|	РезультатыАнкетирования.Ответ КАК Ответ,
	|	РезультатыАнкетирования.ТиповойОтвет КАК ТиповойОтвет
	|	//УСЛОВИЯ_СВОЙСТВА
	|	//УСЛОВИЯ_КАТЕГОРИИ
	|}

	|{УПОРЯДОЧИТЬ ПО
	|	ФизЛицо.*,
	|	Анкета.*,
	|	ДатаАнкетирования,
	|	Вопрос.*,
	|	Ответ,
	|	ТиповойОтвет
	|	//ПСЕВДОНИМЫ_СВОЙСТВА
	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ
	|}
	|
	|ИТОГИ
	|	СУММА(АбсолютнаяОценка)
	|	//ИТОГИ_СВОЙСТВА
	|	//ИТОГИ_КАТЕГОРИИ
	|ПО
	|	ОБЩИЕ
	|
	|{ИТОГИ ПО
	|	ФизЛицо.*,
	|	Анкета.*,
	|	ДатаАнкетирования,
	|	Вопрос.*,
	|	Ответ,
	|	ТиповойОтвет
	|	//ПСЕВДОНИМЫ_СВОЙСТВА
	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ
	|}
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	// В универсальном отчете включен флаг использования свойств и категорий.
	Если УниверсальныйОтчет.ИспользоватьСвойстваИКатегории Тогда
		
		// Добавление свойств и категорий поля запроса в таблицу полей.
		// Необходимо вызывать для каждого поля запроса, предоставляющего возможность использования свойств и категорий.
		
		// УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля(<ПсевдонимТаблицы>.<Поле> , <ПсевдонимПоля>, <Представление>, <Назначение>);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("РезультатыАнкетирования.ФизЛицо", "ФизЛицо", "Опрашиваемое лицо", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_ФизическиеЛица);
		
		// Добавление свойств и категорий в исходный текст запроса.
		УниверсальныйОтчет.ДобавитьВТекстЗапросаСвойстваИКатегории(ТекстЗапроса);
		
	КонецЕсли;
		
	// Инициализация текста запроса построителя отчета
	УниверсальныйОтчет.ПостроительОтчета.Текст = ТекстЗапроса;
	
	// Представления полей отчета.
	// Необходимо вызывать для каждого поля запроса.
	// УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить(<ИмяПоля>, <ПредставлениеПоля>);
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ФизЛицо", "Опрашиваемое лицо");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ДатаАнкетирования", "Дата опроса");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ТиповойОтвет", "Типовой ответ");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ОценкаОтвета", "Оценка ответа");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ВесВопроса", "Вес вопроса");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("АбсолютнаяОценка", "Абсолютная оценка");
	
	УниверсальныйОтчет.мСтруктураФорматаПолей.Вставить("ДатаАнкетирования", "ДФ=dd.MM.yyyy");
	УниверсальныйОтчет.мСтруктураФорматаПолей.Вставить("ТиповойОтвет", "ЧЦ=15; ЧДЦ=2; ДФ=dd.MM.yyyy; БЛ=Нет; БИ=Да");
	
	// Добавление показателей
	// Необходимо вызывать для каждого добавляемого показателя.
	// УниверсальныйОтчет.ДобавитьПоказатель(<ИмяПоказателя>, <ПредставлениеПоказателя>, <ВключенПоУмолчанию>, <Формат>, <ИмяГруппы>, <ПредставлениеГруппы>);
	УниверсальныйОтчет.ДобавитьПоказатель("АбсолютнаяОценка", "Абс.оценка", Истина, "ЧЦ=15; ЧДЦ=2", , );
	
	// Добавление предопределенных группировок строк отчета.
	// Необходимо вызывать для каждой добавляемой группировки строки.
	// УниверсальныйОтчет.ДобавитьИзмерениеСтроки(<ПутьКДанным>);
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ФизЛицо");
	
	// Добавление предопределенных группировок колонок отчета.
	// Необходимо вызывать для каждой добавляемой группировки колонки.
	// УниверсальныйОтчет.ДобавитьИзмерениеКолонки(<ПутьКДанным>);
	
	// Добавление предопределенных отборов отчета.
	// Необходимо вызывать для каждого добавляемого отбора.
	// УниверсальныйОтчет.ДобавитьОтбор(<ПутьКДанным>);
	УниверсальныйОтчет.ДобавитьОтбор("ФизЛицо");
	
	// Добавление предопределенных полей порядка отчета.
	// Необходимо вызывать для каждого добавляемого поля порядка.
	// УниверсальныйОтчет.ДобавитьПорядок(<ПутьКДанным>);
	
	// Установка связи подчиненных и родительских полей
	// УниверсальныйОтчет.УстановитьСвязьПолей(<ПутьКДанным>, <ПутьКДаннымРодитель>);
	//УниверсальныйОтчет.УстановитьСвязьПолей("ТиповойОтвет", "ФизЛицо");
	//УниверсальныйОтчет.УстановитьСвязьПолей("Ответ", "ФизЛицо");
	//УниверсальныйОтчет.УстановитьСвязьПолей("ТиповойОтвет", "Вопрос");
	//УниверсальныйОтчет.УстановитьСвязьПолей("Ответ", "Вопрос");
	
	// Установка связи полей и измерений
	// УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения(<ИмяПоля>, <ИмяИзмерения>);
	//УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения("ТиповойОтвет", "ФизЛицо");
	//УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения("Ответ", "ФизЛицо");
	//УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения("ТиповойОтвет", "Вопрос");
	//УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения("Ответ", "Вопрос");
	
	// Установка представлений полей
	УниверсальныйОтчет.УстановитьПредставленияПолей(УниверсальныйОтчет.мСтруктураПредставлениеПолей, УниверсальныйОтчет.ПостроительОтчета);
	
	// Установка типов значений свойств в отборах отчета
	УниверсальныйОтчет.УстановитьТипыЗначенийСвойствДляОтбора();
	
	// Заполнение начальных настроек универсального отчета
	УниверсальныйОтчет.УстановитьНачальныеНастройки(Ложь);
	
	// Добавление дополнительных полей
	// Необходимо вызывать для каждого добавляемого дополнительного поля.
	// УниверсальныйОтчет.ДобавитьДополнительноеПоле(<ПутьКДанным>, <Размещение>, <Положение>);
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("Вопрос");
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("ТиповойОтвет");
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("Ответ");
	
КонецПроцедуры // УстановитьНачальныеНастройки()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ОТЧЕТА 
	
// Процедура формирования отчета
//
Процедура СформироватьОтчет(ТабличныйДокумент) Экспорт
	
	// Перед формирование отчета можно установить необходимые параметры универсального отчета.
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ПустойВопрос", ПланыВидовХарактеристик.ВопросыДляАнкетирования.ПустаяСсылка());
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ПустойОтвет", Справочники.ВариантыОтветовОпросов.ПустаяСсылка());
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ДатаАктуальности", УниверсальныйОтчет.ДатаКон);
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ДатаАктуальности_Год", Год(УниверсальныйОтчет.ДатаКон));
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ДатаАктуальности_Месяц", Месяц(УниверсальныйОтчет.ДатаКон));
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ДатаАктуальности_День", День(УниверсальныйОтчет.ДатаКон));
	
	УниверсальныйОтчет.СформироватьОтчет(ТабличныйДокумент);

КонецПроцедуры // СформироватьОтчет()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура обработки расшифровки
//
Процедура ОбработкаРасшифровки(Расшифровка, Объект) Экспорт
	
	// Дополнительные параметры в расшифровывающий отчет можно передать
	// посредством инициализации переменной "ДополнительныеПараметры".
	
	ДополнительныеПараметры = Неопределено;
	УниверсальныйОтчет.ОбработкаРасшифровкиУниверсальногоОтчета(Расшифровка, Объект, ДополнительныеПараметры);
	
КонецПроцедуры // ОбработкаРасшифровки()

// Формирует структуру для сохранения настроек отчета
//
Процедура СформироватьСтруктуруДляСохраненияНастроек(СтруктураСНастройками) Экспорт
	
	УниверсальныйОтчет.СформироватьСтруктуруДляСохраненияНастроек(СтруктураСНастройками);
	
КонецПроцедуры // СформироватьСтруктуруДляСохраненияНастроек()

// Заполняет настройки отчета из структуры сохраненных настроек
//
Функция ВосстановитьНастройкиИзСтруктуры(СтруктураСНастройками) Экспорт
	
	Возврат УниверсальныйОтчет.ВосстановитьНастройкиИзСтруктуры(СтруктураСНастройками, ЭтотОбъект);
	
КонецФункции // ВосстановитьНастройкиИзСтруктуры()

// Содержит значение используемого режима ввода периода.
// Тип: Число.
// Возможные значения: // (-1) - не выбирать период, 0 - произвольный период, 1 - на дату, 2 - неделя, 3 - декада, 4 - месяц, 5 - квартал, 6 - полугодие, 7 - год
// Значение по умолчанию: 0
// Пример:
УниверсальныйОтчет.мРежимВводаПериода = 1;

#КонецЕсли