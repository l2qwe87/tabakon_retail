﻿Функция Установить_ОсобенностьУчетаДля_ТабачнаяПродукция() ЭКСПОРТ
	
	//Изменил Вик 2024-08-28
	//Запрос = Новый Запрос;
	//Запрос.Текст = "ВЫБРАТЬ
	//               |	Номенклатура.Ссылка КАК Ссылка,
	//               |	Номенклатура.ОсобенностьУчета КАК ОсобенностьУчета,
	//               |	Номенклатура.ВидНоменклатуры.ИспользоватьХарактеристики КАК ИспользоватьХарактеристики,
	//               |	ВидыНоменклатуры.Ссылка КАК ВидНоменклатуры
	//               |ИЗ
	//               |	Справочник.Номенклатура КАК Номенклатура
	//               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
	//               |		ПО (ВидыНоменклатуры.ПометкаУдаления = ЛОЖЬ)
	//               |			И (ВидыНоменклатуры.ОсобенностьУчета = &ОсобенностьУчета)
	//               |			И Номенклатура.ВидНоменклатуры.ИспользоватьХарактеристики = ВидыНоменклатуры.ИспользоватьХарактеристики
	//               |ГДЕ
	//               |	Номенклатура.ПометкаУдаления = ЛОЖЬ
	//               |	И Номенклатура.ТабачнаяПродукция = ИСТИНА
	//               |	И (Номенклатура.ОсобенностьУчета <> &ОсобенностьУчета
	//               |			ИЛИ Номенклатура.ВидНоменклатуры <> ВидыНоменклатуры.Ссылка)";
	//
	//
	//
	//особенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.ТабачнаяПродукция;
	//
	//Запрос.УстановитьПараметр("ОсобенностьУчета",особенностьУчета);
	//
	//рез = Запрос.Выполнить().Выбрать();
	//
	//инд = 0;
	//Пока Рез.Следующий() Цикл
	//	об = рез.Ссылка.ПолучитьОбъект();
	//	Если Ложь Тогда об = Справочники.Номенклатура.СоздатьЭлемент(); КонецЕсли;
	//	
	//	об.ВидНоменклатуры = рез.ВидНоменклатуры;
	//	об.ОсобенностьУчета = особенностьУчета;
	//	
	//	Попытка
	//		об.Записать();
	//		инд = инд + 1;
	//	Исключение
	//	КонецПопытки;
	//КонецЦикла;
	//
	//Возврат инд;
	
	Запрос	=	Новый запрос("ВЫБРАТЬ
	      	 	             |	Номенклатура.Ссылка КАК Ссылка,
	      	 	             |	Номенклатура.ВидНоменклатуры КАК ВидНоменклатуры
	      	 	             |ИЗ
	      	 	             |	Справочник.Номенклатура КАК Номенклатура
	      	 	             |ГДЕ
	      	 	             |	Номенклатура.ОсобенностьУчета = &ОсобенностьУчета
	      	 	             |	И НЕ Номенклатура.ВидНоменклатуры.Наименование ПОДОБНО ""%Табак%""
	      	 	             |	И НЕ Номенклатура.ПометкаУдаления
	      	 	             |	И НЕ Номенклатура.ЭтоГруппа");
	ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.ТабачнаяПродукция;
	Вид	=	Справочники.ВидыНоменклатуры.НайтиПоНаименованию("Табак");
	
	Запрос.УстановитьПараметр("ОсобенностьУчета",особенностьУчета);
	
	рез = Запрос.Выполнить().Выбрать();
	
	инд = 0;
	Пока Рез.Следующий() Цикл
		об = рез.Ссылка.ПолучитьОбъект();
	
		об.ВидНоменклатуры  = Вид;
		об.ОсобенностьУчета = ОсобенностьУчета;
		
		Попытка
			об.Записать();
			инд = инд + 1;
		Исключение
		КонецПопытки;
	КонецЦикла;
	
	Возврат инд;

КонецФункции


