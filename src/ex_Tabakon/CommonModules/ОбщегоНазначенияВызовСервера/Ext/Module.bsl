﻿Функция ПроверитьВозможностьРедактирования_Общая() экспорт
	Возврат РольДоступна("ПолныеПрава");
КонецФункции

Функция ПолучитьПрокси(Пароль="", Пользователь = "", Адрес = "", Таймаут = 60, НеВыводитьошибку = Ложь) Экспорт
	
	ТекстОшибки = "";
	ИмяСервиса = "tbk"; 
	ИмяСервисаСоап = "tbkSoap";
	
	
	Попытка                                 
		Определения = Новый WSОпределения(Адрес,Пользователь,Пароль, Таймаут);
	Исключение			
		Если не НеВыводитьошибку тогда
			Сообщить(ОписаниеОшибки());
		КонецЕсли;
		Возврат Неопределено; 
	КонецПопытки;
	
	URI =  "http://www.1c.ru/SaaS/1.0/WS";
	Прокси = Новый WSПрокси(Определения, URI, ИмяСервиса, ИмяСервисаСоап);
	Прокси.Пользователь = Пользователь;
	Прокси.Пароль = Пароль;
	Возврат Прокси;   	
КонецФункции

Функция ПроверитьЧекНаНаличиеСкидок(ЧекККМПродажаОснование) экспорт
	Запрос	=	Новый запрос("ВЫБРАТЬ
	      	 	             |	КомментарииСтатистики.Наименование КАК Наименование
	      	 	             |ИЗ
	      	 	             |	РегистрСведений.КомментарииСтатистики КАК КомментарииСтатистики
	      	 	             |ГДЕ
	      	 	             |	КомментарииСтатистики.Наименование Подобно &Наименование");
	Запрос.УстановитьПараметр("Наименование","%"+ЧекККМПродажаОснование.Номер+"%");
	
	Возврат Запрос.Выполнить().Пустой();
КонецФункции

Функция УдалитьЛидирующиеНули(НужнаяСтрока) Экспорт
	
	Если ТипЗнч(НужнаяСтрока) <> Тип("Строка") Тогда
		Возврат НужнаяСтрока;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(НужнаяСтрока) Тогда
		Возврат НужнаяСтрока;
	КонецЕсли; 
	

	НомерПервойЦифры = 0;
	Для а = 1 По СтрДлина(НужнаяСтрока) Цикл
		НомерПервойЦифры = НомерПервойЦифры + 1;
		КодСимвола = КодСимвола(Сред(НужнаяСтрока, а, 1));
		Если КодСимвола <> 48 Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	НужнаяСтрока = Сред(НужнаяСтрока, НомерПервойЦифры);

	Возврат НужнаяСтрока;  	
КонецФункции

Функция ЭтоМаркированнаяНоменклатураСервер(Номенклатура) экспорт
	возврат Найти(Номенклатура.ВидНоменклатуры.Наименование,"Табак (х)") или Номенклатура.ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.ТабачнаяПродукция;	
КонецФункции

Функция EmailValid(Адрес) Экспорт

    //Адрес = "test@me@gmail.narod.am";

    ЛатинскиеБуквы = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

    Цифры = "0123456789";

    //ищем крайний справа символ @ для правильного выделения локальной и доменной части

    ИндексСобаки = Найти(Адрес,"@");

    //1. строка адреса вообще не содержит разделителя

    Если ИндексСобаки = 0 Тогда

        Возврат ЛОЖЬ;

    КонецЕсли;

    УрезаемаяСтрока = Сред(Адрес, ИндексСобаки+1);

    Пока Найти(УрезаемаяСтрока,"@") > 0 Цикл

        ИндексСобаки = ИндексСобаки + Найти(УрезаемаяСтрока,"@");

        УрезаемаяСтрока = Сред(УрезаемаяСтрока, ИндексСобаки+1);

    КонецЦикла;

    ДоменнаяЧасть = Сред(Адрес, ИндексСобаки+1);

    ЛокальнаяЧасть = Лев(Адрес, ИндексСобаки-1);

    //2. Проверяем длину локальной части

    Если СтрДлина(ЛокальнаяЧасть) < 1 ИЛИ СтрДлина(ЛокальнаяЧасть) > 64 Тогда

        Возврат ЛОЖЬ;

    КонецЕсли;

    //3. Проверяем длину доменной части

    Если СтрДлина(ДоменнаяЧасть) < 1 ИЛИ СтрДлина(ДоменнаяЧасть) > 255 Тогда

        Возврат ЛОЖЬ;

    КонецЕсли;

    //4. Проверяем что локальная части не начинается и не заканчивается на "."

    Если Лев(ЛокальнаяЧасть, 1) = "." ИЛИ Прав(ЛокальнаяЧасть, 1) = "." Тогда

        Возврат ЛОЖЬ;

    КонецЕсли;

    //5. Локальная части не содержит 2 или более "." подряд

    Если Найти(ЛокальнаяЧасть, "..") > 0 Тогда

        Возврат ЛОЖЬ;

    КонецЕсли;

    //Проверка доменной части

    //6. Доменная часть не начинается с точки

    Если Лев(ДоменнаяЧасть, 1) = "." Тогда

        Возврат ЛОЖЬ;

    КонецЕсли;

    //7. Доменная часть не содержит 2 или более "." подряд

    Если Найти(ДоменнаяЧасть, "..") > 0 Тогда

        Возврат ЛОЖЬ;

    КонецЕсли;

    //8. Проверка частей доменной части

    //каждая часть начинается с буквы и заканчивается буквой или цифрой

    //каждая часть длиной не более 63 символов

    ИдентификаторыДоменнойЧасти = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ДоменнаяЧасть, ".");

    Для Каждого ИдентификаторДомена ИЗ ИдентификаторыДоменнойЧасти Цикл

        Если СтрДлина(ИдентификаторДомена) > 63 Тогда

            Возврат ЛОЖЬ;

        КонецЕсли;

        Если Найти(ЛатинскиеБуквы, Лев(ИдентификаторДомена,1)) = 0

            //для доменов, нарушающих RFC 1035 п.2.3.1, например @1c.ru :)

            И Найти(Цифры, Лев(ИдентификаторДомена,1)) = 0

            Тогда

            Возврат ЛОЖЬ;

        КонецЕсли;

        Если Найти(ЛатинскиеБуквы, Прав(ИдентификаторДомена,1)) = 0 И Найти(Цифры, Прав(ИдентификаторДомена,1)) = 0 Тогда

            Возврат ЛОЖЬ;

        КонецЕсли;

    КонецЦикла;



    //Все проверки пройдены - радуемся

    Возврат ИСТИНА;

КонецФункции

Функция ОткрытьНужнуюИнструкцию(НазваниеИнструкции) экспорт  		
	Запрос	=	Новый запрос("ВЫБРАТЬ
	      	 	             |	ТБК_Инструкции.СсылкаНаФайл КАК СсылкаНаФайл
	      	 	             |ИЗ
	      	 	             |	Справочник.ТБК_Инструкции КАК ТБК_Инструкции
	      	 	             |ГДЕ
	      	 	             |	ТБК_Инструкции.Наименование ПОДОБНО &Наименование");   
	Запрос.УстановитьПараметр("Наименование","%" + НазваниеИнструкции + "%"); 
	Рез = Запрос.Выполнить().Выбрать();
	Если Рез.Следующий() тогда 
		ЗапуститьПриложение(Рез.СсылкаНаФайл);
	иначе
		Сообщить("Не найдена инструкция: " + НазваниеИнструкции);
	КонецЕсли; 	
КонецФункции 

Функция ПолучитьТекущегоПродавца() экспорт
	текущийПользователь = Пользователи.ТекущийПользователь();
	Возврат текущийПользователь.ФизическоеЛицо;
КонецФункции

Функция  ПолучитьЦветФонаКонпки() экспорт
	Возврат ЦветаСтиля.ЦветФонаКнопки;
КонецФункции

//Марк
Функция ПолучитьНоменклатураБК(Номенклатура) Экспорт 		
	Возврат Справочники.Номенклатура.НайтиПоНаименованию("" + СокрЛП(Номенклатура) + " БК");   	
КонецФункции // ()
//конецМарк

//Вик 2023-09-13
Процедура ЗаписатьВЛог(ТекстСообщения) экспорт
	СтрокаСоединенияСБД =  СтрокаСоединенияИнформационнойБазы();
	ПутьКБД 			= Сред(СтрокаСоединенияСБД, 7, СтрДлина(СтрокаСоединенияСБД) -8);
	Каталог = Новый Файл(ПутьКБД);
	
	ТекстСообщения	=	Строка(ТекущаяДата()) + ": " + ТекстСообщения;

	Если Каталог.Существует() Тогда
		ПутьКФайлу	=	ПутьКБД + "\tbk_log.txt";
		Файл_Лога = Новый Файл(ПутьКФайлу);
		
		Если не Файл_Лога.Существует() Тогда  			
			док = Новый ТекстовыйДокумент();
			док.УстановитьТекст(ТекстСообщения);
			док.Записать(ПутьКФайлу, "windows-1251");
		иначе

			Текст = Новый ЗаписьТекста(ПутьКФайлу, "windows-1251",,Истина);
			Текст.ЗаписатьСтроку(Символы.ПС+Символы.ПС+ТекстСообщения);
			Текст.Закрыть();

		КонецЕсли; 		
	КонецЕсли;
КонецПроцедуры

Функция Установить_ЗначениеКонстанты_Общая(имяКонстанты, значениеКонстанты)экспорт
	запись = РегистрыСведений.ТБК_Константы.СоздатьМенеджерЗаписи();
	
	запись.ИмяКонстанты = имяКонстанты;
	запись.ЗначениеКонстанты = значениеКонстанты; 
	запись.Записать(Истина);
КонецФункции

Функция ПолучитьЦенуНоменклатуры(Номенклатура) экспорт
	Запрос	=	Новый запрос("ВЫБРАТЬ
	      	 	             |	ДействующиеЦеныНоменклатурыСрезПоследних.Номенклатура КАК Номенклатура,
	      	 	             |	ДействующиеЦеныНоменклатурыСрезПоследних.Цена КАК Цена
	      	 	             |ИЗ
	      	 	             |	РегистрСведений.ДействующиеЦеныНоменклатуры.СрезПоследних(&Дата, Номенклатура = &Номенклатура) КАК ДействующиеЦеныНоменклатурыСрезПоследних");
	Запрос.УстановитьПараметр("Номенклатура",Номенклатура);
	Запрос.УстановитьПараметр("Дата", ТекущаяДата());
	Рез = Запрос.Выполнить().Выбрать();

	Если Рез.Следующий() тогда
		Возврат Рез.цена;
	иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьРеальнуюНоменклатуруДляБК(Номенклатура) экспорт
	Возврат	Справочники.Номенклатура.НайтиПоНаименованию(СтрЗаменить(Номенклатура.Наименование, " БК",""));	
КонецФункции

Функция ПолучитьНоменклатуруПоКуару(Данные) экспорт
	ШК						 = Данные; 
	ШтрихкодEAN				 = ШтрихкодированиеИС.ТБКEANИзКодаМаркировки(Данные);  
 
	Если не ЗначениеЗаполнено(ШтрихкодEAN) тогда
		//ШтрихкодEAN	=	ПолучитьЕАН(СканированныйШК_Копия);
		
		Если лев(ШК,3) = "010" тогда
			ШК = Сред(СокрЛП(ШК),4);
		КонецЕсли;
		
		Если лев(ШК,5) = "00000" тогда
			флЭтоЕан8	=	Истина;
		иначе
			флЭтоЕан8	=	ложь;
		КонецЕсли;
		
		ШК  = ОбщегоНазначенияВызовСервера.УдалитьЛидирующиеНули(ШК);
		
		ШК	= лев(ШК,13);
		
		Если флЭтоЕан8 тогда
			ШК	= лев(ШК,8);
		иначе
			Попытка
				ФФФ	=	Число(ШК);
			Исключение
				ШК = Лев("0" + ШК, 13);
			КонецПопытки;
		КонецЕсли;
		
		ШтрихкодEAN = ШК;
	КонецЕсли;
	
	Запрос	=	Новый запрос("ВЫБРАТЬ
	      	 	             |	Штрихкоды.Владелец КАК Владелец,
	      	 	             |	Штрихкоды.Упаковка КАК Упаковка
	      	 	             |ИЗ
	      	 	             |	РегистрСведений.Штрихкоды КАК Штрихкоды
	      	 	             |ГДЕ
	      	 	             |	Штрихкоды.Штрихкод = &Штрихкод"); 
	Запрос.УстановитьПараметр("Штрихкод",ШтрихкодEAN); 
	рез = Запрос.Выполнить().Выгрузить();
	Если Рез.Количество() = 0 тогда     
		Запрос.УстановитьПараметр("Штрихкод","0"+ШтрихкодEAN);	
		рез = Запрос.Выполнить().Выгрузить();

		Если Рез.Количество() = 0 тогда  
			Запрос.УстановитьПараметр("Штрихкод","00000"+ШтрихкодEAN);	
			рез = Запрос.Выполнить().Выгрузить();

			
			Если Рез.Количество() = 0 тогда 
				
				Запрос	=	Новый Запрос("ВЫБРАТЬ
				      	 	             |	ТБКУниверсальныеМарки.Номенклатура КАК Владелец
				      	 	             |ИЗ
				      	 	             |	РегистрСведений.ТБКУниверсальныеМарки КАК ТБКУниверсальныеМарки
				      	 	             |ГДЕ
				      	 	             |	ТБКУниверсальныеМарки.Марка ПОДОБНО &Марка");
				Запрос.УстановитьПараметр("Марка", Данные);
				Рез = Запрос.Выполнить().Выгрузить();
				
				Если Рез.Количество() = 0 тогда				
					//Сообщить("номенклатура не найдена. Штрихкод: "+ШтрихкодEAN);
					
					Запрос.УстановитьПараметр("Марка", Сред(Данные,1,СтрДлина(Данные)-4));
					
					Рез = Запрос.Выполнить().Выгрузить(); 				
					Если Рез.Количество() = 0 тогда						
						Возврат Неопределено; 
					КонецЕсли;
				КонецЕсли;
				
			КонецЕсли;   
		КонецЕсли;
	КонецЕсли;
	
	Возврат Рез[0].Владелец; 

КонецФункции

Функция ПолучитьКоличествоВУпаковкеПоКуару(Данные) экспорт
	ШК						 = Данные; 
	ШтрихкодEAN				 = ШтрихкодированиеИС.ТБКEANИзКодаМаркировки(Данные);  
 
	Если не ЗначениеЗаполнено(ШтрихкодEAN) тогда
		//ШтрихкодEAN	=	ПолучитьЕАН(СканированныйШК_Копия);
		
		Если лев(ШК,3) = "010" тогда
			ШК = Сред(СокрЛП(ШК),4);
		КонецЕсли;
		
		Если лев(ШК,5) = "00000" тогда
			флЭтоЕан8	=	Истина;
		иначе
			флЭтоЕан8	=	ложь;
		КонецЕсли;
		
		ШК  = ОбщегоНазначенияВызовСервера.УдалитьЛидирующиеНули(ШК);
		
		ШК	= лев(ШК,13);
		
		Если флЭтоЕан8 тогда
			ШК	= лев(ШК,8);
		иначе
			Попытка
				ФФФ	=	Число(ШК);
			Исключение
				ШК = Лев("0" + ШК, 13);
			КонецПопытки;
		КонецЕсли;
		
		ШтрихкодEAN = ШК;
	КонецЕсли;
	
	Запрос	=	Новый запрос("ВЫБРАТЬ
	      	 	             |	Штрихкоды.Владелец КАК Владелец,
	      	 	             |	Штрихкоды.Упаковка КАК Упаковка,
	      	 	             |	Штрихкоды.Упаковка.Коэффициент КАК УпаковкаКоэффициент
	      	 	             |ИЗ
	      	 	             |	РегистрСведений.Штрихкоды КАК Штрихкоды
	      	 	             |ГДЕ
	      	 	             |	Штрихкоды.Штрихкод = &Штрихкод"); 
	Запрос.УстановитьПараметр("Штрихкод",ШтрихкодEAN); 
	рез = Запрос.Выполнить().Выгрузить();
	Если Рез.Количество() = 0 тогда     
		Запрос.УстановитьПараметр("Штрихкод","0"+ШтрихкодEAN);	
		рез = Запрос.Выполнить().Выгрузить();

		Если Рез.Количество() = 0 тогда  
			Запрос.УстановитьПараметр("Штрихкод","00000"+ШтрихкодEAN);	
			рез = Запрос.Выполнить().Выгрузить();   
		КонецЕсли;
	КонецЕсли;
	
	Если Рез.Количество() = 0 тогда
		возврат 1;
	иначе
		Возврат Рез[0].УпаковкаКоэффициент; 
	КонецЕсли;

КонецФункции

Функция ПолучитьКоличествоЧеков(ДатаНач = Неопределено, ДатаКон = Неопределено, Продавец = Неопределено) экспорт
	СтруктураОтвета	=	Новый Структура;
	СтруктураОтвета.Вставить("КолЧеков",0);
	СтруктураОтвета.Вставить("КолЧековЛояльность",0);
	СтруктураОтвета.Вставить("КолЧековСНачалаМесяца",0);
	СтруктураОтвета.Вставить("КолЧековЛояльностьСНачалаМесяца",0);
	
	Если ДатаНач = Неопределено тогда
		Запрос	=	Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
		      	 	             |	КассоваяСмена.Дата КАК Дата
		      	 	             |ИЗ
		      	 	             |	Документ.КассоваяСмена КАК КассоваяСмена
		      	 	             |ГДЕ
		      	 	             |	КассоваяСмена.Проведен
		      	 	             |	И КассоваяСмена.Статус = &Статус
		      	 	             |	И КассоваяСмена.Дата >= &Дата
		      	 	             |	И НЕ КассоваяСмена.КассаККМ.ПометкаУдаления
		      	 	             |
		      	 	             |УПОРЯДОЧИТЬ ПО
		      	 	             |	Дата");
		Запрос.УстановитьПараметр("Статус", Перечисления.СтатусыКассовойСмены.Открыта); 
		Запрос.УстановитьПараметр("Дата", ТекущаяДата() - 24*60*60 );
		
		Рез = Запрос.Выполнить().Выбрать();
		
		
		Если Рез.Следующий() тогда
			НужДатаНач = Рез.Дата;	
			НужДатаКон = ТекущаяДата();	
		КонецЕсли; 
	иначе
		НужДатаНач = ДатаНач;	
		НужДатаКон = ДатаКон;			
	КонецЕсли;
	Запрос	=	Новый Запрос();
	Запрос.Текст			= "ВЫБРАТЬ
	      	 	             |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЧекККМТовары.Ссылка) КАК КолЧеков
	      	 	             |ИЗ
	      	 	             |	Документ.ЧекККМ.Товары КАК ЧекККМТовары
	      	 	             |ГДЕ
	      	 	             |	ЧекККМТовары.Ссылка.Проведен
	      	 	             |	И ЧекККМТовары.Ссылка.Дата МЕЖДУ &ДатаНач И &ДатаКон
	      	 	             |	И ЧекККМТовары.Ссылка.ВидОперации = &ВидОперации
	      	 	             |	И ЧекККМТовары.Ссылка.СтатусЧекаККМ <> &СтатусЧекаККМ" +?(ЗначениеЗаполнено(Продавец)," 
	      	 	             |	И (ЧекККМТовары.Продавец = &Продавец
	      	 	             |			ИЛИ ЧекККМТовары.Продавец1 = &Продавец
	      	 	             |			ИЛИ ЧекККМТовары.Продавец2 = &Продавец)","");	
	
	Запрос.УстановитьПараметр("ДатаНач", 		НужДатаНач);
	Запрос.УстановитьПараметр("ДатаКон", 		НужДатаКон);
	Запрос.УстановитьПараметр("СтатусЧекаККМ", 	Перечисления.СтатусыЧековККМ.Аннулированный);
	Запрос.УстановитьПараметр("ВидОперации", 	Перечисления.ВидыОперацийЧекККМ.Продажа);
	Запрос.УстановитьПараметр("Продавец", 		Продавец);
		
	Рез1	=	Запрос.Выполнить().Выбрать();
	
	Если Рез1.Следующий() тогда
		СтруктураОтвета.КолЧеков	=	Рез1.КолЧеков;
	КонецЕсли;
	
	
	Запрос	=	Новый Запрос("ВЫБРАТЬ
	      	 	             |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТБК_ИсторияПокупокРозница.Чек) КАК КолЧековЛояльность
	      	 	             |ИЗ
	      	 	             |	РегистрСведений.ТБК_ИсторияПокупокРозница КАК ТБК_ИсторияПокупокРозница
	      	 	             |ГДЕ
	      	 	             |	ТБК_ИсторияПокупокРозница.ВидОперации = &ВидОперации
	      	 	             |	И ТБК_ИсторияПокупокРозница.Чек.Проведен
	      	 	             |	И ТБК_ИсторияПокупокРозница.Чек.Дата МЕЖДУ &ДатаНач И &ДатаКон" +?(ЗначениеЗаполнено(Продавец),"
	      	 	             |	И (ТБК_ИсторияПокупокРозница.Чек.Товары.Продавец = &Продавец
	      	 	             |			ИЛИ ТБК_ИсторияПокупокРозница.Чек.Товары.Продавец1 = &Продавец
	      	 	             |			ИЛИ ТБК_ИсторияПокупокРозница.Чек.Товары.Продавец2 = &Продавец)",""));	
	Запрос.УстановитьПараметр("ДатаНач", 		НужДатаНач);
	Запрос.УстановитьПараметр("ДатаКон", 		НужДатаКон); 
	Запрос.УстановитьПараметр("ВидОперации", 	"Продажа");
	Запрос.УстановитьПараметр("Продавец", 		Продавец);
	
	
	Рез1	=	Запрос.Выполнить().Выбрать();
	
	Если Рез1.Следующий() тогда
		СтруктураОтвета.КолЧековЛояльность	=	Рез1.КолЧековЛояльность;
	КонецЕсли;

	
	Возврат СтруктураОтвета;	
КонецФункции

Функция ПолучитьКоличествоКассККМ() экспорт
	Запрос	=	Новый запрос("ВЫБРАТЬ
	      	 	             |	ЕСТЬNULL(КОЛИЧЕСТВО(РАЗЛИЧНЫЕ КассыККМ.Ссылка), 0) КАК Ссылка
	      	 	             |ИЗ
	      	 	             |	Справочник.КассыККМ КАК КассыККМ
	      	 	             |ГДЕ
	      	 	             |	НЕ КассыККМ.ПометкаУдаления");	
	Рез = Запрос.Выполнить().Выбрать();
	Если Рез.Следующий() тогда
		Возврат Рез.Ссылка;
	иначе
		Возврат 0;
	КонецЕсли;
КонецФункции

Функция ЭтоОбезличеннаяМарка(Данные) Экспорт

	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ТБКОбезличенныеМарки.ШтрихкодОбезличеннойМарки КАК ШтрихкодОбезличеннойМарки
	                      |ИЗ
	                      |	РегистрСведений.ТБКОбезличенныеМарки КАК ТБКОбезличенныеМарки
	                      |ГДЕ
	                      |	&ШтрихкодОбезличеннойМарки ПОДОБНО ""%"" + ТБКОбезличенныеМарки.ШтрихкодОбезличеннойМарки + ""%""");
	Запрос.УстановитьПараметр("ШтрихкодОбезличеннойМарки", Данные);
	Возврат НЕ Запрос.Выполнить().Пустой();

КонецФункции // ()
