﻿
&НаКлиенте
Процедура ТБКОбработкаЗаписиНовогоПеред(НовыйОбъект, Источник, СтандартнаяОбработка)
	ф=1;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ТБКСинхронизацияШтрихкодовПослеНаСервере()
	РегистрыСведений.ТБК_Штрихкоды.СинхронизацияШтрихкодов();
КонецПроцедуры

&НаКлиенте
Процедура ТБКСинхронизацияШтрихкодовПосле(Команда)
	ТБКСинхронизацияШтрихкодовПослеНаСервере();
КонецПроцедуры
