﻿
&Вместо("ПоследнийНомерДокументаКассыККМ")
Функция ТБКПоследнийНомерДокументаКассыККМ(Ссылка)
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                      |	ЕСТЬNULL(МАКСИМУМ(ОплатаОтПокупателяПлатежнойКартой.НомерЧекаККМ), 0) КАК НомерЧекаККМ
	                      |ПОМЕСТИТЬ ТаблицаПоследнихДокументов
	                      |ИЗ
	                      |	Документ.ОплатаОтПокупателяПлатежнойКартой КАК ОплатаОтПокупателяПлатежнойКартой
	                      |ГДЕ
	                      |	ОплатаОтПокупателяПлатежнойКартой.КассаККМ = &КассаККМ
	                      |	И ОплатаОтПокупателяПлатежнойКартой.Дата >= &Дата
	                      |
	                      |ОБЪЕДИНИТЬ ВСЕ
	                      |
	                      |ВЫБРАТЬ
	                      |	ЕСТЬNULL(МАКСИМУМ(ПриходныйКассовыйОрдер.НомерЧекаККМ), 0)
	                      |ИЗ
	                      |	Документ.ПриходныйКассовыйОрдер КАК ПриходныйКассовыйОрдер
	                      |ГДЕ
	                      |	ПриходныйКассовыйОрдер.КассаККМ = &КассаККМ
	                      |	И ПриходныйКассовыйОрдер.Дата >= &Дата
	                      |
	                      |ОБЪЕДИНИТЬ ВСЕ
	                      |
	                      |ВЫБРАТЬ
	                      |	ЕСТЬNULL(МАКСИМУМ(РасходныйКассовыйОрдер.НомерЧекаККМ), 0)
	                      |ИЗ
	                      |	Документ.РасходныйКассовыйОрдер КАК РасходныйКассовыйОрдер
	                      |ГДЕ
	                      |	РасходныйКассовыйОрдер.КассаККМ = &КассаККМ
	                      |	И РасходныйКассовыйОрдер.Дата >= &Дата
	                      |
	                      |ОБЪЕДИНИТЬ ВСЕ
	                      |
	                      |ВЫБРАТЬ
	                      |	ЕСТЬNULL(МАКСИМУМ(ЧекККМ.НомерЧекаККМ), 0)
	                      |ИЗ
	                      |	Документ.ЧекККМ КАК ЧекККМ
	                      |ГДЕ
	                      |	ЧекККМ.КассаККМ = &КассаККМ
	                      |	И ЧекККМ.Дата >= &Дата
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ЕСТЬNULL(МАКСИМУМ(ТаблицаПоследнихДокументов.НомерЧекаККМ), 0) КАК НомерЧекаККМ
	                      |ПОМЕСТИТЬ ТаблицаПоследнихНомеров
	                      |ИЗ
	                      |	ТаблицаПоследнихДокументов КАК ТаблицаПоследнихДокументов
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ТаблицаПоследнихНомеров.НомерЧекаККМ КАК НомерЧекаККМ
	                      |ИЗ
	                      |	ТаблицаПоследнихНомеров КАК ТаблицаПоследнихНомеров
	                      |ГДЕ
	                      |	ТаблицаПоследнихНомеров.НомерЧекаККМ <> 0");
	Запрос.УстановитьПараметр("КассаККМ", Ссылка);
	Запрос.УстановитьПараметр("Дата", ТекущаяДата() - 30*24*60*60); //2023-05-02 Вик, иногда запрос зависает на 10 и более секунд, поэтому добавил условие на дату

	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			НомерЧекаККМ = Выборка.НомерЧекаККМ + 1;
		КонецЦикла; 
	КонецЕсли; 

	Возврат НомерЧекаККМ;

КонецФункции
