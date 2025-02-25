﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен данными"
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Для внутреннего использования
//
Процедура ПроверитьНедопустимыеСимволыВИмениПользователяWSПрокси(Знач ИмяПользователя) Экспорт
	
	Если СтрокаСодержитСимвол(ИмяПользователя, НедопустимыеСимволыВИмениПользователяWSПрокси()) Тогда
		
		СтрокаСообщения = НСтр("ru = 'В имени пользователя %1 содержатся недопустимые символы.
			|Имя пользователя не должно содержать символы %2.'"
		);
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения,
			ИмяПользователя, НедопустимыеСимволыВИмениПользователяWSПрокси()
		);
		ВызватьИсключение СтрокаСообщения;
	КонецЕсли;
	
КонецПроцедуры

// Для внутреннего использования
//
Функция НедопустимыеСимволыВИмениПользователяWSПрокси() Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	
	Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(СистемнаяИнформация.ВерсияПриложения, "8.2.17.0") > 0 Тогда
		Возврат ":";
	Иначе
		Возврат "@/\[]#&*?:;=";
	КонецЕсли;
	
КонецФункции

// Для внутреннего использования
//
Функция СтрокаСодержитСимвол(Знач Строка, Знач СтрокаСимволов)
	
	Для Индекс = 1 По СтрДлина(СтрокаСимволов) Цикл
		
		Символ = Сред(СтрокаСимволов, Индекс, 1);
		
		Если Найти(Строка, Символ) <> 0 Тогда
			
			Возврат Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ложь;
КонецФункции
