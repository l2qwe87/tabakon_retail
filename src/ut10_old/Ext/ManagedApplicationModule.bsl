﻿// СписокЗначений для накапливания пакета сообщений в журнал регистрации, 
// формируемых в клиентской бизнес-логике.
Перем СообщенияДляЖурналаРегистрации Экспорт;

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ГЛОБАЛЬНОГО КОНТЕКСТА

// Процедура - обработчик события "При начале работы системы".
//
Процедура ПриНачалеРаботыСистемы()
	
	УправлениеСоединениямиИБКлиент.УстановитьКонтрольРежимаЗавершенияРаботыПользователей();

КонецПроцедуры 