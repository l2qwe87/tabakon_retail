﻿#Если Клиент Тогда
	
////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// Все возможные показатели
Перем мТаблицаПоказатели Экспорт; 

// Настройка периода
Перем НП Экспорт;

// Соответствия, содержащая назначения свойств и категорий именам
Перем мСоответствиеНазначений Экспорт;

Перем мСтруктураСвязиПоказателейИИзмерений Экспорт; // содержит связь показателей и измерений

Перем мМассивШиринКолонок Экспорт; // массив ширин колонок табличного документа для сохранения между формированиями отчета

Перем мИсходныйМакетОтчета; // исходный макет, используемый для отчета. По умолчанию "Макет", но может быть переопределен

Перем мНазваниеОтчета Экспорт; // название отчета

Перем мВыбиратьИмяРегистра Экспорт; // признак выбора (изменения) имени регистра (вида отчета)

Перем мВыбиратьИспользованиеСвойств Экспорт; // признак выбора (изменения) флажка использования свойств и категорий

Перем мСтруктураДляОтбораПоКатегориям Экспорт; // содержит связь отборов текста запроса Построителя и значений категорий

Перем мРежимВводаПериода Экспорт; // 0 - произвольный период, 1 - дата, 2 - месяц, 3 - квартал, 4 - год

Перем ШиринаТаблицы;

Перем СтруктураФорматаПолей Экспорт; // хранит формат полей примитивных типов

Перем ОписаниеТиповСтрока;

Процедура ЗаполнитьНачальныеНастройки() Экспорт
	
	мВыбиратьИмяРегистра = Ложь;
	ИмяРегистра = "ДенежныеСредства";
	НП = Новый НастройкаПериода;
	ВыводитьИтогиПоВсемУровням = Ложь;
	ВыводитьПоказателиВСтроку = Истина;
	
	мТаблицаПоказатели  = Новый ТаблицаЗначений;
	мТаблицаПоказатели.Колонки.Добавить("ИмяПоля", ОписаниеТиповСтрока);
	мТаблицаПоказатели.Колонки.Добавить("ПредставлениеПоля", ОписаниеТиповСтрока);
	мТаблицаПоказатели.Колонки.Добавить("ФорматнаяСтрока", ОписаниеТиповСтрока);
	
	ЗаполнитьПоказатели("ТекущийОстаток_ВВалютеДенСредств", "Остаток в валюте банковского счета/кассы", Истина, "ЧЦ = 15 ; ЧДЦ = 2");
	ЗаполнитьПоказатели("СуммаКСписанию_ВВалютеДенСредств", "К списанию в валюте банковского счета/кассы", Истина, "ЧЦ = 15 ; ЧДЦ = 2");
	ЗаполнитьПоказатели("СуммаКПолучению_ВВалютеДенСредств", "К получению в валюте банковского счета/кассы", Истина, "ЧЦ = 15 ; ЧДЦ = 2");
	ЗаполнитьПоказатели("СуммаВРезерве_ВВалютеДенСредств", "В резерве в валюте банковского счета/кассы", Истина, "ЧЦ = 15 ; ЧДЦ = 2");
	ЗаполнитьПоказатели("СуммаСвободныйОстатокВВалютеДенСредств", "Ожидаемый остаток в валюте банковского счета/кассы", Истина, "ЧЦ = 15 ; ЧДЦ = 2");
	
	мРежимВводаПериода = 0;
	мНазваниеОтчета = "Анализ доступности денежных средств по дням";
	
	МассивОтбора = Новый Массив;
	МассивОтбора.Добавить("БанковскийСчетКасса");
	МассивОтбора.Добавить("ВидДенежныхСредств");
	
	ТекстЗапроса= "
	|ВЫБРАТЬ
	|	БанковскийСчетКасса,
	|	СУММА(ТекущийОстаток_ВВалютеДенСредств) КАК ТекущийОстаток_ВВалютеДенСредств,
	|	СУММА(ТекущийОстаток_Оборот) КАК ТекущийОстаток_Оборот,
	|	СУММА(СуммаКСписанию_ВВалютеДенСредств) КАК СуммаКСписанию_ВВалютеДенСредств,
	|	СУММА(СуммаКСписанию_Оборот) КАК СуммаКСписанию_Оборот,
	|	СУММА(СуммаКПолучению_ВВалютеДенСредств) КАК СуммаКПолучению_ВВалютеДенСредств,
	|	СУММА(СуммаКПолучению_Оборот) КАК СуммаКПолучению_Оборот,
	|	СУММА(СуммаВРезерве_ВВалютеДенСредств) КАК СуммаВРезерве_ВВалютеДенСредств,
	|	СУММА(СуммаВРезерве_Оборот) КАК СуммаВРезерве_Оборот,
	|	Период
	|{
	|ВЫБРАТЬ
	|	Период,
	|	БанковскийСчетКасса}
	|ИЗ
	|(ВЫБРАТЬ
	|	ДенежныеСредства.ВидДенежныхСредств,
	|	ДенежныеСредства.БанковскийСчетКасса,
	|	ДенежныеСредства.Период КАК Период,
	|	ДенежныеСредства.СуммаКонечныйОстаток КАК ТекущийОстаток_ВВалютеДенСредств,
	|	ДенежныеСредства.СуммаОборот КАК ТекущийОстаток_Оборот,
	|	0 КАК СуммаКСписанию_ВВалютеДенСредств,
	|	0 КАК СуммаКСписанию_Оборот,
	|	0 КАК СуммаКПолучению_ВВалютеДенСредств,
	|	0 КАК СуммаКПолучению_Оборот,
	|	0 КАК СуммаВРезерве_ВВалютеДенСредств,
	|	0 КАК СуммаВРезерве_Оборот
	|ИЗ
	|	РегистрНакопления.ДенежныеСредства.ОстаткиИОбороты(&ДатаНач,&ДатаКон,День) КАК ДенежныеСредства
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДенежныеСредстваКСписанию.ВидДенежныхСредств,
	|	ДенежныеСредстваКСписанию.БанковскийСчетКасса,
	|	ДенежныеСредстваКСписанию.Период КАК Период,
	|	0,
	|	0,
	|	ДенежныеСредстваКСписанию.СуммаКонечныйОстаток,
	|	ДенежныеСредстваКСписанию.СуммаОборот,
	|	0,
	|	0,
	|	0,
	|	0
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваКСписанию.ОстаткиИОбороты(&ДатаНач,&ДатаКон,День) КАК ДенежныеСредстваКСписанию
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДенежныеСредстваКПолучению.ВидДенежныхСредств,
	|	ДенежныеСредстваКПолучению.БанковскийСчетКасса,
	|	ДенежныеСредстваКПолучению.Период КАК Период,
	|	0,
	|	0,
	|	0,
	|	0,
	|	ДенежныеСредстваКПолучению.СуммаКонечныйОстаток,
	|	ДенежныеСредстваКПолучению.СуммаОборот,
	|	0,
	|	0
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваКПолучению.ОстаткиИОбороты(&ДатаНач,&ДатаКон,День) КАК ДенежныеСредстваКПолучению
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДенежныеСредстваВРезерве.ВидДенежныхСредств,
	|	ДенежныеСредстваВРезерве.БанковскийСчетКасса,
	|	ДенежныеСредстваВРезерве.Период КАК Период,
	|	0,
	|	0,
	|	0,
	|	0,
	|	0,
	|	0,
	|	ДенежныеСредстваВРезерве.СуммаКонечныйОстаток,
	|	ДенежныеСредстваВРезерве.СуммаОборот
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваВРезерве.ОстаткиИОбороты(&ДатаНач,&ДатаКон,День) КАК ДенежныеСредстваВРезерве
	|) КАК СостояниеДенежныхСредств
	|{
	|ГДЕ
	|	БанковскийСчетКасса,
	|	ВидДенежныхСредств КАК ВидДенежныхСредств
	|}
    |СГРУППИРОВАТЬ ПО
	|	СостояниеДенежныхСредств.БанковскийСчетКасса,
	|	СостояниеДенежныхСредств.Период
	|ИТОГИ
	|	СУММА(ТекущийОстаток_ВВалютеДенСредств),
	|	СУММА(ТекущийОстаток_Оборот),
	|	СУММА(СуммаКСписанию_ВВалютеДенСредств),
	|	СУММА(СуммаКСписанию_Оборот),
	|	СУММА(СуммаКПолучению_ВВалютеДенСредств),
	|	СУММА(СуммаКПолучению_Оборот),
	|	СУММА(СуммаВРезерве_ВВалютеДенСредств),
	|	СУММА(СуммаВРезерве_Оборот)
	|ПО
	|	БанковскийСчетКасса,
	|	Период ПЕРИОДАМИ (День,&ДатаНач,&ДатаКон)
	|{
	|ИТОГИ ПО
	|	БанковскийСчетКасса.*,
	|	Период 
	|}";
	
	
	ПостроительОтчета.Текст = ТекстЗапроса;
	ПостроительОтчета.Параметры.Вставить("ВалютаУпрУчета", глЗначениеПеременной("ВалютаУправленческогоУчета"));
	СтруктураПредставлениеПолей = Новый Структура;
	
	УправлениеОтчетами.ЗаполнитьПредставленияПолей(СтруктураПредставлениеПолей, ПостроительОтчета);
	
	СтруктураПредставлениеПолей.Вставить("Период", "Период");
		
	УправлениеОтчетами.ОчиститьДополнительныеПоляПостроителя(ПостроительОтчета);
	УправлениеОтчетами.ЗаполнитьОтбор(МассивОтбора, ПостроительОтчета);
	
	// Установим дату начала отчета
	Если ЗначениеЗаполнено(глЗначениеПеременной("глТекущийПользователь")) Тогда
		ДатаНач = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"),"ОсновнаяДатаНачалаОтчетов");
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ОТЧЕТА 
// 

// Вывод строки отчета (с проверкой необходимости этого вывода)
//
// Параметры:
//	Выборка       - выборка из результата отчета, которая обходится в процедуре
//	СтруктураПараметров - структура параметров, необходимых для вывода строки
//	Номер         - число, номер обходимой группировки
//
Процедура ВывестиСтроку(Выборка, СтруктураПараметров, Номер,МассивРасшифровки,СтруктураЗначенийПоказателей)

	ОбластьОбщийОтступ = СтруктураПараметров.ОбщийОтступ;
	ОбластьЗначениеГруппировки   = СтруктураПараметров.ЗначениеГруппировки;
	ОбластьПоказатель   = СтруктураПараметров.ОбластьПоказатель;

	СтруктураВыводГруппировок = СтруктураПараметров.СтруктураВыводГруппировок;

	УровеньЗаписи   = Выборка.Уровень();
	СдвигУровня     = 0;

	ИмяГруппировки  = Выборка.Группировка();

	ТабДок = СтруктураПараметров.ТабДок;

	ЗначениеГруппировки = "";

	ЗначениеРасшифровки = Неопределено;

	ТипЗаписиВыборки = Выборка.ТипЗаписи();

	МассивВыводГруппировок = Новый Массив;

	Если ТипЗаписиВыборки = ТипЗаписиЗапроса.ИтогПоИерархии Тогда

		ЗначениеТекущейГруппировки = "" + Выборка[ИмяГруппировки];
		Если ПустаяСтрока(ЗначениеТекущейГруппировки) Тогда

			ЗначениеТекущейГруппировки = "<...>";
		КонецЕсли;

		ЗначениеГруппировки = ЗначениеГруппировки + ЗначениеТекущейГруппировки;

	ИначеЕсли ТипЗаписиВыборки = ТипЗаписиЗапроса.ИтогПоГруппировке Тогда
		
		Если СтруктураВыводГруппировок.Свойство(ИмяГруппировки, МассивВыводГруппировок) Тогда
			
			ЗначениеТекущейГруппировки = "" + Выборка[ИмяГруппировки];
			
			Если ПустаяСтрока(ЗначениеТекущейГруппировки) Тогда
				ЗначениеТекущейГруппировки = "<...>";
			КонецЕсли;
			
			ЗначениеГруппировки = ЗначениеГруппировки + ЗначениеТекущейГруппировки;
			
			Если ЗначениеРасшифровки = Неопределено Тогда 
				ЗначениеРасшифровки = Выборка[ИмяГруппировки];
			КонецЕсли;
			
		КонецЕсли;

	ИначеЕсли ТипЗаписиВыборки = ТипЗаписиЗапроса.ОбщийИтог Тогда
		Возврат;
	КонецЕсли;

	// Для итогов по группировке сдвиг нужно уменьшить на количество пропущенных группировок, 
	// заранее рассчитанное для каждой группировки
	Если ТипЗаписиВыборки = ТипЗаписиЗапроса.ИтогПоГруппировке Тогда

		МассивРасшифровки.Добавить(ИмяГруппировки);

		ЗначениеРасшифровкиСтрока = Новый Структура;
		Для Каждого Элемент Из МассивРасшифровки Цикл
			ЗначениеРасшифровкиСтрока.Вставить(Элемент, Выборка[Элемент])
		КонецЦикла;

		СдвигУровня = СтруктураПараметров.СтруктураСдвигУровняГруппировок[ИмяГруппировки];

		// Для итогов по иерархии сдвиг нужно уменьшить на количество пропущенных группировок для предыдущей группировки
		// заранее рассчитанное для каждой группировки
	ИначеЕсли ТипЗаписиВыборки = ТипЗаписиЗапроса.ИтогПоИерархии Тогда
		СдвигУровня = СтруктураПараметров.СтруктураСдвигУровняГруппировок[СтруктураПараметров.МассивГруппировки[Номер - 1]];
	КонецЕсли;
	
	УровеньЗаписи = УровеньЗаписи - СдвигУровня;
	
	ТабДок.Вывести(ОбластьОбщийОтступ, УровеньЗаписи);
	ТабДок.Область(ТабДок.ВысотаТаблицы,1).Расшифровка = ЗначениеРасшифровкиСтрока;
	
	ОбластьЗначениеГруппировки.Параметры.ЗначениеГруппировки = СокрЛП(ЗначениеГруппировки);
	ОбластьЗначениеГруппировки.Параметры.Расшифровка = ЗначениеРасшифровки;
	ОбластьЗначениеГруппировки.Область().Отступ = УровеньЗаписи;
	
	ТабДок.Присоединить(ОбластьЗначениеГруппировки);
	
	// Заполняем значений показателей для расчета
	Для каждого Показатель Из Показатели Цикл
	
		ЕстьВхождение=Найти(Показатель.Имя,"_");
		Если (НЕ ЕстьВхождение=0) И (НЕ Выборка[Лев(Показатель.Имя,ЕстьВхождение-1)+"_Оборот"]=0) Тогда
			СтруктураЗначенийПоказателей.Вставить(Показатель.Имя,Выборка[Показатель.Имя]);
		КонецЕсли;
	
	КонецЦикла;
	
	СтруктураЗначенийПоказателей.Вставить("СуммаСвободныйОстатокВВалютеДенСредств",
								СтруктураЗначенийПоказателей.ТекущийОстаток_ВВалютеДенСредств
	                            + СтруктураЗначенийПоказателей.СуммаКПолучению_ВВалютеДенСредств
								- СтруктураЗначенийПоказателей.СуммаКСписанию_ВВалютеДенСредств
								- СтруктураЗначенийПоказателей.СуммаВРезерве_ВВалютеДенСредств);
	
	// Выводим показатели в отчет
	Для каждого Показатель Из Показатели Цикл
		
		Если Показатель.Использование Тогда
			
			Если ИмяГруппировки="Период" Тогда
				
				ОбластьПоказатель.Параметры.Показатель=СтруктураЗначенийПоказателей[Показатель.Имя];
				
			Иначе
				
				ОбластьПоказатель.Параметры.Показатель=0;
				
			КонецЕсли;
			
			ТабДок.Присоединить(ОбластьПоказатель);
			
		КонецЕсли;
		
	КонецЦикла; 
		
КонецПроцедуры // ВывестиСтроку()

// Обход выборки из результата запроса по группировкам для вывода строк отчета
//
// Параметры:
//
//	Выборка       - выборка из результата отчета, которая обходится в процедуре,
//	СтруктураПараметров - структура параметров, передеваемых в процедуру вывода
//	                строки отчета,
//	Номер         - число, номер обходимой группировки
//	МассивРасшифровки: массив, содержащий список группировок текущей строки
//
Процедура ВывестиВыборку(Выборка, СтруктураПараметров, Номер, МассивРасшифровки, СтруктураЗначенийПоказателей)

	ОбработкаПрерыванияПользователя();

	ВсегоГруппировок = СтруктураПараметров.ВсегоГруппировок;
	
	Если Выборка.Следующий() И Выборка.Группировка()="Период" Тогда  // Сбросим значения показателей
		
		Для каждого Показатель Из Показатели Цикл
			
			СтруктураЗначенийПоказателей.Вставить(Показатель.Имя,0);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Выборка.Сбросить();

	// Берутся группировки все подряд, 
	Пока Выборка.Следующий() Цикл

		ВывестиСтроку(Выборка, СтруктураПараметров, Номер, МассивРасшифровки, СтруктураЗначенийПоказателей);

		// Детальные записи не нужны: для последней группировки после итогов оп группировке идут 
		// детальные записи
		Если Номер = ВсегоГруппировок - 1
			И Выборка.ТипЗаписи() =  ТипЗаписиЗапроса.ИтогПоГруппировке Тогда 
			Продолжить;
		КонецЕсли;

		// На каждом уровне используется своя копия структуры расшифровок
		КопияМассивРасшифровки = Новый Массив;
		Для Каждого Элемент Из МассивРасшифровки Цикл
			КопияМассивРасшифровки.Добавить(Элемент);
		КонецЦикла;

		ВывестиВыборку(Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,,?(Выборка.Группировка()="Период","ВСЕ","")), СтруктураПараметров, Номер + 1, КопияМассивРасшифровки, СтруктураЗначенийПоказателей);
		
	КонецЦикла;

КонецПроцедуры // ВывестиВыборку()

Процедура ЗаполнитьПоказатели(ИмяПоля, ПредставлениеПоля, ВклПоУмолчанию, ФорматнаяСтрока) Экспорт

	//СтруктураПредставлениеПолей.Вставить(ИмяПоля, ПредставлениеПоля);

	// Показатели заносятся в специальную таблицу и добавляются в список
	СтрПоказатели = мТаблицаПоказатели.Добавить();
	СтрПоказатели.ИмяПоля           = ИмяПоля;
	СтрПоказатели.ПредставлениеПоля = ПредставлениеПоля;
	//СтрПоказатели.ВклПоУмолчанию    = ВклПоУмолчанию;
	СтрПоказатели.ФорматнаяСтрока   = ФорматнаяСтрока;
	Если Показатели.Найти(ИмяПоля) = Неопределено Тогда
		НовыйПоказатель = Показатели.Добавить();
		НовыйПоказатель.Имя = ИмяПоля;
		НовыйПоказатель.Представление = ПредставлениеПоля;
		НовыйПоказатель.Использование    = ВклПоУмолчанию;
	КонецЕсли;
КонецПроцедуры

// Выполняет запрос и формирует табличный документ-результат отчета
// в соответствии с настройками, заданными значениями реквизитов отчета.
//
// Параметры:
//	ДокументРезультат - табличный документ, формируемый отчетом,
//	ЕстьОшибки - флаг того, что при формировании произошли ошибки
//
//Процедура СформироватьОтчет(ДокументРезультат, ЕстьОшибки = Ложь) Экспорт
Процедура СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок, ВысотаЗаголовка, ТолькоЗаголовок = Ложь,  ЕстьОшибки = Ложь)	Экспорт

	ПостроительОтчета.АвтоДетальныеЗаписи = Ложь;
	ПостроительОтчета.ВыводитьОбщиеИтоги=Ложь;
	
	Если ДатаНач > ДатаКон И ДатаКон <> '00010101000000' Тогда
		Предупреждение("Дата начала периода не может быть больше даты конца периода");
		ЕстьОшибки = Истина;
		Возврат;
	КонецЕсли;

	Если НЕ УправлениеОтчетами.ЗадатьПараметрыОтбораПоКатегориям(ПостроительОтчета, мСтруктураДляОтбораПоКатегориям) Тогда
		Предупреждение("По одной категории нельзя устанавливать несколько отборов");
		ЕстьОшибки = Истина;
		Возврат;
	КонецЕсли;
	СписокЗначений = Новый СписокЗначений;
		
	ДокументРезультат.Очистить();
	
	// Запоминание ширины колонки
	Если НЕ ДокументРезультат.ВысотаТаблицы = ВысотаЗаголовка Тогда

		мМассивШиринКолонок.Очистить();

		// Запоминать следует, если документ не пустой
		Если ДокументРезультат.ВысотаТаблицы > 0 Тогда
			
			Для Сч=1 По ШиринаТаблицы Цикл
				мМассивШиринКолонок.Добавить(ДокументРезультат.Область(1,Сч).ШиринаКолонки);
			КонецЦикла;
			
		КонецЕсли;

	КонецЕсли; 
	
	ВыводитьДетальныеЗаписи= Ложь;

	ПостроительОтчета.Параметры.Вставить("ДатаНач", ДатаНач);

	Если ДатаКон <> '00010101000000' Тогда
		ПостроительОтчета.Параметры.Вставить("ДатаКон", КонецДня(ДатаКон));
	Иначе
		ПостроительОтчета.Параметры.Вставить("ДатаКон", '00010101000000');
	КонецЕсли;
	
	Макет = ПолучитьМакет("Макет");

	// Оформление измерений
	ОформлениеДетальныхЗаписей = Неопределено;

	ОформлениеСтроки = Новый Массив;

	ОформлениеСтрокиИерархии = Новый ТаблицаЗначений;
	ОформлениеСтрокиИерархии = Новый Массив;
	
	// Расшифровки
	ПостроительОтчета.ЗаполнениеРасшифровки = ВидЗаполненияРасшифровкиПостроителяОтчета.Расшифровка;

	ПостроительОтчета.ВыводитьДетальныеЗаписи = ВыводитьДетальныеЗаписи;

	Заголовок = мНазваниеОтчета;
	
	Если ДатаНач = '00010101000000' И ДатаКон = '00010101000000' Тогда
		ОписаниеПериода     = "Период не установлен";
		
	Иначе
		Если ДатаНач = '00010101000000' ИЛИ ДатаКон = '00010101000000' Тогда
			ОписаниеПериода = "" + Формат(ДатаНач, "ДФ = ""дд.ММ.гггг""; ДП = ""...""") 
			+ " - "      + Формат(ДатаКон, "ДФ = ""дд.ММ.гггг""; ДП = ""...""");
			
		Иначе
			
			Если ДатаНач <= ДатаКон Тогда
				ОписаниеПериода = "" + ПредставлениеПериода(НачалоДня(ДатаНач), КонецДня(ДатаКон), "ФП = Истина");
			Иначе
				ОписаниеПериода = "Неправильно задан период!"
			КонецЕсли;
			
		КонецЕсли;
			
	КонецЕсли;
	
	// Структура вывода группировок: ключи определяют "основные" группировки,
	// значения - дополнительные.
	СтруктураВыводГруппировок = Новый Структура;
	МассивГруппировки    = Новый Массив;

	// Структура "поправок" сдвига группировок вправо: уровень записи строки 
	// формируемого запроса будет отличаться от нужного из-за пропусков группировок,
	// по которым не нужно выводить итоги.
	СтруктураСдвигУровняГруппировок = Новый Структура;

	МассивБулево = Новый Массив;
	МассивБулево.Добавить(Тип("Булево"));
	ОписаниеТиповБулево = Новый ОписаниеТипов(МассивБулево);

	ВсегоГруппировок = 0;
	КолГруппировокБезИтогов = 0;
	Массив = Новый Массив;

    Для Сч=0 По ПостроительОтчета.ИзмеренияСтроки.Количество()-1 Цикл

		ВсегоГруппировок = ВсегоГруппировок + 1;
		СтруктураСдвигУровняГруппировок.Вставить(ПостроительОтчета.ИзмеренияСтроки[Сч].Имя, 0);
		МассивГруппировки.Добавить(ПостроительОтчета.ИзмеренияСтроки[Сч].Имя);
		СтруктураВыводГруппировок.Вставить(ПостроительОтчета.ИзмеренияСтроки[Сч].Имя, Новый Массив);
		
	КонецЦикла;

			
	СписокИзмерений = "";
	Для Сч=0 По ПостроительОтчета.ИзмеренияСтроки.Количество()-1 Цикл
	
		СписокИзмерений = СписокИзмерений +", "+ ПостроительОтчета.ИзмеренияСтроки[Сч].Представление
		+" "+ ПостроительОтчета.ИзмеренияСтроки[Сч].ТипИзмерения;
	
	КонецЦикла; 

	СписокПоказателей = "";
	Для Сч=0 По Показатели.Количество()-1 Цикл

		Если Показатели[Сч].Использование Тогда
		
			СписокПоказателей = СписокПоказателей +", "+ Показатели[Сч].Представление;
		
		КонецЕсли; 
	
	КонецЦикла; 

	СписокОтбор = "";
	Для Сч=0 По ПостроительОтчета.Отбор.Количество()-1 Цикл

		Если ПостроительОтчета.Отбор[Сч].Использование И Не ПостроительОтчета.Отбор[Сч].Имя = "Периодичность" Тогда

			СписокОтбор = СписокОтбор +", "+ ПостроительОтчета.Отбор[Сч].Представление 
			+" "+ ПостроительОтчета.Отбор[Сч].ВидСравнения +" "+ ПостроительОтчета.Отбор[Сч].Значение;

		КонецЕсли; 
	
	КонецЦикла; 
	
    Для Сч = 1 По 3 Цикл
		Если Сч = 1 Тогда
			Префикс = "Верх";
		ИначеЕсли Сч = 2 Тогда

			// Если нет фильтров, не выводим
			Если ПустаяСтрока(СписокОтбор) Тогда
				Продолжить;
			КонецЕсли;
			Префикс = "Середина";
		ИначеЕсли Сч = 3 Тогда
			Префикс = "Низ";
		КонецЕсли;

		ДокументРезультат.Вывести(Макет.ПолучитьОбласть("ОбщийОтступ|Шапка" + Префикс));

		// Вывод шапки отчета
		ОбластьЗначение   = Макет.ПолучитьОбласть("Значение|Шапка" + Префикс);

		Если Префикс = "Верх" Тогда
			ОбластьЗначение.Параметры.ЗаголовокОтчета = мНазваниеОтчета;
			Если ДатаНач = '00010101000000' И ДатаКон = '00010101000000' Тогда
				ОбластьЗначение.Параметры.Период = "Период: без ограничения ";
			Иначе
				Если ДатаНач = '00010101000000' ИЛИ ДатаКон = '00010101000000' Тогда
					ОбластьЗначение.Параметры.Период = "Период: " + Формат(ДатаНач, "ДФ = ""дд.ММ.гггг""; ДП = ""без ограничения""") 
														  + " - " + Формат(ДатаКон, "ДФ = ""дд.ММ.гггг""; ДП = ""без ограничения""");
				Иначе
					ОбластьЗначение.Параметры.Период = "Период: " + ПредставлениеПериода(НачалоДня(ДатаНач), КонецДня(ДатаКон));
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли Префикс = "Середина" Тогда
			ОбластьЗначение.Параметры.Фильтры = "Отбор: " + СписокОтбор;
		ИначеЕсли Префикс = "Низ" Тогда
			ОбластьЗначение.Параметры.Группировки = "Группировки: " + СписокИзмерений;
			ОбластьЗначение.Параметры.Показатели = "Показатели: " + СписокПоказателей;

		КонецЕсли;

		ДокументРезультат.Присоединить(ОбластьЗначение);

	КонецЦикла;
	
	ВысотаЗаголовка=ДокументРезультат.ВысотаТаблицы;
	
	// Когда нужен только заголовок:
	Если ТолькоЗаголовок Тогда

		Возврат;
	
	КонецЕсли;
		
	Макет = ПолучитьМакет("Макет");
	СтруктураПараметров = Новый Структура;

	// Области строки отчета - табличные документы из макета отчета
	СтруктураПараметров.Вставить("ОбщийОтступ", Макет.ПолучитьОбласть("ОбщийОтступ|Строка"));
	СтруктураПараметров.Вставить("ЗначениеГруппировки",   Макет.ПолучитьОбласть("Значение|Строка"));
	СтруктураПараметров.Вставить("ОбластьПоказатель",   Макет.ПолучитьОбласть("Показатель|Строка"));
  
	// Табличный документ - результат отчета
	СтруктураПараметров.Вставить("ТабДок",    ДокументРезультат);

	// Массив выводимых показателей отчета
	СтруктураПараметров.Вставить("МассивПоказатели", Показатели.ВыгрузитьКолонку("Имя"));

	// Общее количество группировок запроса, т.е. как выводимых, так и пропускаемых
	СтруктураПараметров.Вставить("ВсегоГруппировок", 			ВсегоГруппировок);

	// Заполненная структура вывода группировок
	СтруктураПараметров.Вставить("СтруктураВыводГруппировок", 	СтруктураВыводГруппировок);

	// Массив всех группировок запроса, т.е. как выводимых, так и пропускаемых
	СтруктураПараметров.Вставить("МассивГруппировки", 	МассивГруппировки);

	// Заполненная структура "поправки" сдвига группировок вправо
	СтруктураПараметров.Вставить("СтруктураСдвигУровняГруппировок", СтруктураСдвигУровняГруппировок);

	// Наклонный шрифт для групп
	СтруктураПараметров.Вставить("ШрифтГрупп", Новый Шрифт(Макет.Область("Показатель|Строка").Шрифт,,,,Истина));

	// Форматная строка для вывода показателей
	СтруктураПараметров.Вставить("ФорматПоказателей", 			Новый Структура);
	Для Каждого Строка Из Показатели Цикл
		МетаданныеРесурса = 0;
		ФорматнаяСтрока = "";

		Нстр = мТаблицаПоказатели.Найти(Строка.Имя, "ИмяПоля");
		Если Не (Нстр = Неопределено) Тогда
			ФорматнаяСтрока = НСтр.ФорматнаяСтрока;
		КонецЕсли;

		СтруктураПараметров.ФорматПоказателей.Вставить(Строка.Имя, ФорматнаяСтрока);
	КонецЦикла;

	ДокументРезультат.Вывести(Макет.ПолучитьОбласть("ОбщийОтступ|ШапкаТаблица"));
	ДокументРезультат.Присоединить(Макет.ПолучитьОбласть("Значение|ШапкаТаблица"));
	
	ШапкаПоказатели=Макет.ПолучитьОбласть("Показатель|ШапкаТаблица");
	
	Для каждого Показатель Из Показатели Цикл
	
		Если Показатель.Использование Тогда
			ШапкаПоказатели.Параметры.ИмяПоказателя=Показатель.Представление;
			ДокументРезультат.Присоединить(ШапкаПоказатели);
		КонецЕсли;
	
	КонецЦикла;	
	
	// Зафиксируем заголовок отчета
	ДокументРезультат.ФиксацияСверху = ДокументРезультат.ВысотаТаблицы;
	ДокументРезультат.ФиксацияСлева = 2;
	
	// Инициируем структуру значений показателей
	СтруктураЗначенийПоказателей=Новый Структура;
	Для каждого Показатель Из Показатели Цикл
	
		СтруктураЗначенийПоказателей.Вставить(Показатель.Имя,0);
	
	КонецЦикла; 
	
	ПостроительОтчета.Выполнить();
	Результат=ПостроительОтчета.Результат;
	
	
	// Вывод строк отчета
	ДокументРезультат.НачатьАвтогруппировкуСтрок();

		ВывестиВыборку(Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам), СтруктураПараметров, 0, Новый Массив, СтруктураЗначенийПоказателей);

	ДокументРезультат.ЗакончитьАвтогруппировкуСтрок();

	// Вывод подвала отчета
	ДокументРезультат.Вывести(Макет.ПолучитьОбласть("ОбщийОтступ|Подвал"));

	ОбластьЗначение   = Макет.ПолучитьОбласть("Значение|Подвал");

	ДокументРезультат.Присоединить(ОбластьЗначение);
	
	ОбластьПоказатель= Макет.ПолучитьОбласть("Показатель|Подвал");
	
	Для каждого Показатель Из Показатели Цикл
	
		Если Показатель.Использование Тогда
		
			ДокументРезультат.Присоединить(ОбластьПоказатель)
		
		КонецЕсли; 
	
	КонецЦикла; 

	// Первую колонку не печатаем
	ДокументРезультат.ОбластьПечати = ДокументРезультат.Область(1,2,ДокументРезультат.ВысотаТаблицы,ДокументРезультат.ШиринаТаблицы);

	// Заполним общую расшифровку:
	СтруктураНастроекОтчета = Новый Структура;
	СтруктураНастроекОтчета.Вставить("ИмяОтчета", "АнализОстатковДенежныхСредствПоДням");

	Для Каждого Реквизит Из Метаданные.Отчеты["АнализОстатковДенежныхСредствПоДням"].Реквизиты Цикл
		СтруктураНастроекОтчета.Вставить(Реквизит.Имя, ЭтотОбъект[Реквизит.Имя]);
	КонецЦикла;

	Для Каждого ТабличнаяЧасть Из Метаданные.Отчеты["АнализОстатковДенежныхСредствПоДням"].ТабличныеЧасти Цикл
		СтруктураНастроекОтчета.Вставить(ТабличнаяЧасть.Имя, ЭтотОбъект[ТабличнаяЧасть.Имя].Выгрузить());
	КонецЦикла;
	
	ДокументРезультат.Область(1,1).Расшифровка = СтруктураНастроекОтчета;

	ДокументРезультат.ОриентацияСтраницы=ОриентацияСтраницы.Ландшафт;
	ДокументРезультат.Автомасштаб=Истина;
	
КонецПроцедуры // СформироватьОтчет()

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
// 

НП = Новый НастройкаПериода;

мТаблицаПоказатели  = Новый ТаблицаЗначений;

ОписаниеТиповСтрока = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(100);

МассивБулево = Новый Массив;
МассивБулево.Добавить(Тип("Булево"));
ОписаниеТиповБулево = Новый ОписаниеТипов(МассивБулево);

// Инициализация таблиц всех возможных показателей, группировок,  фильтров
мТаблицаПоказатели.Колонки.Добавить("ИмяПоля", ОписаниеТиповСтрока);
мТаблицаПоказатели.Колонки.Добавить("ПредставлениеПоля", ОписаниеТиповСтрока);
мТаблицаПоказатели.Колонки.Добавить("ФорматнаяСтрока", ОписаниеТиповСтрока);
мТаблицаПоказатели.Индексы.Добавить("ИмяПоля");

мМассивШиринКолонок = Новый Массив;

мСтруктураСвязиПоказателейИИзмерений = Новый Структура;

мСоответствиеНазначений = Новый Соответствие;

мНазваниеОтчета = "";

мВыбиратьИмяРегистра = Истина;
мВыбиратьИспользованиеСвойств = Истина;

мРежимВводаПериода = 0;

ПоказыватьЗаголовок = Истина;

ШиринаТаблицы = 0;

СтруктураФорматаПолей = Новый Структура;
СтруктураФорматаПолей.Вставить("ПериодГод", "ДФ = ""гггг """"г.""""""");
СтруктураФорматаПолей.Вставить("ПериодКвартал", "ДФ = ""к"""" квартал"""" гггг """"г.""""""");
СтруктураФорматаПолей.Вставить("ПериодМесяц", "ДФ = ""ММММ гггг """"г.""""""");
СтруктураФорматаПолей.Вставить("ПериодНеделя","ДФ = """"""Неделя с"""" дд.ММ.гггг """"""");
СтруктураФорматаПолей.Вставить("ПериодДень", "ДФ = дд.ММ.гггг");

#КонецЕсли