﻿//<pozdniakov.a
Процедура ОткрытьФормуВыбораТекущихСотрудников(ДатаАктуальности, Организация, Элемент, СтандартнаяОбработка) Экспорт
	//Запрос = Новый Запрос;
	//Запрос.Текст = 
	//	"ВЫБРАТЬ
	//	|	КадровыйУчетСотрудниковСрезПоследних.Сотрудник
	//	|ИЗ
	//	|	РегистрСведений.КадровыйУчетСотрудников.СрезПоследних(&ДатаАктуальности, Организация = &Организация) КАК КадровыйУчетСотрудниковСрезПоследних
	//	|ГДЕ
	//	|	КадровыйУчетСотрудниковСрезПоследних.Состояние <> ЗНАЧЕНИЕ(Перечисление.СостоянияСотрудников.Уволен)
	//	|";
	//
	//Запрос.УстановитьПараметр("ДатаАктуальности", ДатаАктуальности);
	//Запрос.УстановитьПараметр("Организация", Организация);
	//
	//РезультатЗапроса = Запрос.Выполнить();
	//


	//Если НЕ РезультатЗапроса.Пустой() Тогда
	//	СписокТекущихСотрудников = Новый СписокЗначений;
	//	
	//	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	//	
	//	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	//		СписокТекущихСотрудников.Добавить(ВыборкаДетальныеЗаписи.Сотрудник);
	//	КонецЦикла;

	//	ФормаВыбора = ПолучитьФормуВыбора("ФормаВыбора", Элемент);
	//	
	//	ЭлементОтбора = ФормаВыбора.Отбор.Ссылка;
	//	ЭлементОтбора.ВидСравнения = ВидСравнения.ВСписке;
	//	ЭлементОтбора.Значение = СписокТекущихСотрудников;
	//	ЭлементОтбора.Использование = Истина;
	//	
	//	ФормаВыбора.Заголовок = "Выбор сотрудника (только работающие на " + Формат(ДатаАктуальности, "ДФ=дд.ММ.гггг") + ")";
	//	ФормаВыбора.ПараметрВыборГруппИЭлементов = ИспользованиеГруппИЭлементов.Элементы;
	//	ФормаВыбора.ЭлементыФормы.СправочникСписок.ИерархическийПросмотр = Ложь;
	//	ФормаВыбора.Открыть();
	//	
	//	СтандартнаяОбработка = Ложь;
	//КонецЕсли;
	//
КонецПроцедуры
//pozdniakov.a>

//ЛК копия кода========================
Процедура ОткрытьФормуВыбораТекущихСотрудниковСОтбором(ДатаАктуальности, Организация, Элемент, СтандартнаяОбработка, Склад) Экспорт
	
	//ЛК Андрей =====================	
	Если Склад<>"" Тогда
		
		Список = Новый СписокЗначений;		
		
		Запрос = Новый Запрос; 
		Запрос.УстановитьПараметр("Дата", ДатаАктуальности);
		Запрос.УстановитьПараметр("Ссылка", Склад);
		
		Запрос.Текст="ВЫБРАТЬ
		             |	КадровоеПеремещение.Сотрудник.Наименование
		             |ИЗ
		             |	Документ.КадровоеПеремещение КАК КадровоеПеремещение
		             |ГДЕ
		             |	КадровоеПеремещение.ОтделПеремещения.Ссылка = &Ссылка
		             |	И КадровоеПеремещение.ДатаПеревода >= &Дата";
		Результат = Запрос.Выполнить();
		Выбор = Результат.Выбрать();
		
		Пока Выбор.Следующий() Цикл			
			Список.Добавить(Выбор.СотрудникНаименование);
		КонецЦикла;		
		
		Запрос = Новый Запрос; 
		Запрос.УстановитьПараметр("Ссылка", Склад);
		Запрос.Текст="ВЫБРАТЬ
		             |	ФизическиеЛица.Наименование
		             |ИЗ
		             |	Справочник.ФизическиеЛица КАК ФизическиеЛица
		             |ГДЕ
		             |	ФизическиеЛица.Отдел.Ссылка = &Ссылка";
		Результат = Запрос.Выполнить();
		Выбор = Результат.Выбрать();
		
		Пока Выбор.Следующий() Цикл			
			Список.Добавить(Выбор.Наименование);
		КонецЦикла;		
		
		Форма = ПолучитьФормуВыбора("ФормаВыбора", Элемент);
		Форма.Отбор.Наименование.Использование=Истина;
		Форма.Отбор.Наименование.ВидСравнения=ВидСравнения.ВСписке;
		Форма.Отбор.Наименование.Значение=Список;// ТЗ запроса 
		Форма.Открыть();
		СтандартнаяОбработка = Ложь;

	КонецЕсли;
	//===============================	
	
КонецПроцедуры
//======================================

Процедура ОткрытьФормуВыбораТекущихСотрудниковСОтборомПоДокументу(Документ, Элемент, СтандартнаяОбработка) Экспорт
	
	Если Документ<>"" Тогда
		Запрос = Новый Запрос;	
		Запрос.УстановитьПараметр("Документ", Документ);
		Запрос.Текст = "ВЫБРАТЬ
		|	СписаниеТоваровРаспределениеНедостачи.Сотрудник.Ссылка КАК Сотрудник
		|ИЗ
		|	Документ.СписаниеТоваров.РаспределениеНедостачи КАК СписаниеТоваровРаспределениеНедостачи
		|ГДЕ
		|	СписаниеТоваровРаспределениеНедостачи.Ссылка = &Документ";
		
		ФормаВыбора = ПолучитьФормуВыбора("ФормаВыбора", Элемент);
		ФормаВыбора.Отбор.Наименование.ВидСравнения = ВидСравнения.ВСписке;
		
		Список = Новый СписокЗначений();	
		Запрос = Запрос.Выполнить().Выгрузить();
		Для каждого Строчка Из Запрос Цикл
			Список.Добавить(Строка(Строчка.Сотрудник));
		КонецЦикла;
		
		ФормаВыбора.Отбор.Наименование.Значение = Список;
		ФормаВыбора.Отбор.Наименование.Использование = ИСТИНА;
		ФормаВыбора.Открыть();
		СтандартнаяОбработка = Ложь;
	КонецЕсли;	
		
КонецПроцедуры
//======================================

