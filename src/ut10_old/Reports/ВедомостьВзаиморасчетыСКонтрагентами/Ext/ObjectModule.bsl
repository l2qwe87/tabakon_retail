﻿#Если Клиент Тогда
	
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ НАЧАЛЬНОЙ НАСТРОЙКИ ОТЧЕТА

// Процедура установки текста запроса построителя отчета
//
Процедура УстановитьТекстЗапроса(ЕстьПолеРегистратор = Истина)

	// Описание исходного текста запроса.
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Взаиморасчеты.Организация КАК Организация,
	|	ПРЕДСТАВЛЕНИЕ(Взаиморасчеты.Организация),
	|	Взаиморасчеты.Контрагент КАК Контрагент,
	|	ПРЕДСТАВЛЕНИЕ(Взаиморасчеты.Контрагент),
	|	Взаиморасчеты.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	ПРЕДСТАВЛЕНИЕ(Взаиморасчеты.ДоговорКонтрагента),
	|	Взаиморасчеты.Сделка КАК Сделка,
	|	ПРЕДСТАВЛЕНИЕ(Взаиморасчеты.Сделка),
	|	Взаиморасчеты.ДокументРасчетовСКонтрагентом КАК ДокументРасчетовСКонтрагентом,
	|	ПРЕДСТАВЛЕНИЕ(Взаиморасчеты.ДокументРасчетовСКонтрагентом),
	|	Взаиморасчеты.ДоговорКонтрагента.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|	ПРЕДСТАВЛЕНИЕ(Взаиморасчеты.ДоговорКонтрагента.ВалютаВзаиморасчетов) КАК ВалютаВзаиморасчетовПредставление,
	|	Взаиморасчеты.Регистратор КАК Регистратор,
	|	ПРЕДСТАВЛЕНИЕ(Взаиморасчеты.Регистратор),
	|	Взаиморасчеты.Период КАК Период,
	|	Взаиморасчеты.ПериодДень КАК ПериодДень,
	|	Взаиморасчеты.ПериодНеделя КАК ПериодНеделя,
	|	Взаиморасчеты.ПериодДекада КАК ПериодДекада,
	|	Взаиморасчеты.ПериодМесяц КАК ПериодМесяц,
	|	Взаиморасчеты.ПериодКвартал КАК ПериодКвартал,
	|	Взаиморасчеты.ПериодПолугодие КАК ПериодПолугодие,
	|	Взаиморасчеты.ПериодГод КАК ПериодГод,
	|	Взаиморасчеты.СуммаВзаиморасчетовНачальныйОстаток КАК СуммаВзаиморасчетовНачальныйОстаток,
	|	Взаиморасчеты.СуммаВзаиморасчетовКонечныйОстаток КАК СуммаВзаиморасчетовКонечныйОстаток,
	|	Взаиморасчеты.СуммаВзаиморасчетовПриход КАК СуммаВзаиморасчетовПриход,
	|	Взаиморасчеты.СуммаВзаиморасчетовРасход КАК СуммаВзаиморасчетовРасход,
	|	Взаиморасчеты.СуммаУпрНачальныйОстаток КАК СуммаУпрНачальныйОстаток,
	|	Взаиморасчеты.СуммаУпрКонечныйОстаток КАК СуммаУпрКонечныйОстаток,
	|	Взаиморасчеты.СуммаУпрПриход КАК СуммаУпрПриход,
	|	Взаиморасчеты.СуммаУпрРасход КАК СуммаУпрРасход
	|	//ПОЛЯ_СВОЙСТВА
	|	//ПОЛЯ_КАТЕГОРИИ
	|{ВЫБРАТЬ
	|	Организация.* КАК Организация,
	|	Контрагент.* КАК Контрагент,
	|	ДоговорКонтрагента.* КАК ДоговорКонтрагента,
	|	Контрагент.* КАК Контрагент,
	|	Сделка.* КАК Сделка,
	|	ДокументРасчетовСКонтрагентом.* КАК ДокументРасчетовСКонтрагентом,
	|	ВалютаВзаиморасчетов.* КАК ВалютаВзаиморасчетов,
	|	Регистратор.* КАК Регистратор,
	|	Период,
	|	ПериодДень,
	|	ПериодНеделя,
	|	ПериодДекада,
	|	ПериодМесяц,
	|	ПериодКвартал,
	|	ПериодПолугодие,
	|	ПериодГод,
	|	СуммаВзаиморасчетовНачальныйОстаток,
	|	СуммаВзаиморасчетовКонечныйОстаток,
	|	СуммаВзаиморасчетовПриход,
	|	СуммаВзаиморасчетовРасход,
	|	СуммаУпрНачальныйОстаток,
	|	СуммаУпрКонечныйОстаток,
	|	СуммаУпрПриход,
	|	СуммаУпрРасход
	|	//ПСЕВДОНИМЫ_СВОЙСТВА
	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ
	|}
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВзаиморасчетыБезГруппировки.Организация КАК Организация,
	|		ВзаиморасчетыБезГруппировки.Контрагент КАК Контрагент,
	|		ВзаиморасчетыБезГруппировки.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|		ВзаиморасчетыБезГруппировки.Сделка КАК Сделка,
	|		ВзаиморасчетыБезГруппировки.ДокументРасчетовСКонтрагентом КАК ДокументРасчетовСКонтрагентом,
	|		ВзаиморасчетыБезГруппировки.ДоговорКонтрагента.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|		ВзаиморасчетыБезГруппировки.Регистратор КАК Регистратор,
	|		ВзаиморасчетыБезГруппировки.Период КАК Период,
	|		ВзаиморасчетыБезГруппировки.ПериодДень КАК ПериодДень,
	|		ВзаиморасчетыБезГруппировки.ПериодНеделя КАК ПериодНеделя,
	|		ВзаиморасчетыБезГруппировки.ПериодДекада КАК ПериодДекада,
	|		ВзаиморасчетыБезГруппировки.ПериодМесяц КАК ПериодМесяц,
	|		ВзаиморасчетыБезГруппировки.ПериодКвартал КАК ПериодКвартал,
	|		ВзаиморасчетыБезГруппировки.ПериодПолугодие КАК ПериодПолугодие,
	|		ВзаиморасчетыБезГруппировки.ПериодГод КАК ПериодГод,
	|		СУММА(ВзаиморасчетыБезГруппировки.СуммаВзаиморасчетовНачальныйОстаток) КАК СуммаВзаиморасчетовНачальныйОстаток,
	|		СУММА(ВзаиморасчетыБезГруппировки.СуммаВзаиморасчетовКонечныйОстаток) КАК СуммаВзаиморасчетовКонечныйОстаток,
	|		СУММА(ВзаиморасчетыБезГруппировки.СуммаВзаиморасчетовПриход) КАК СуммаВзаиморасчетовПриход,
	|		СУММА(ВзаиморасчетыБезГруппировки.СуммаВзаиморасчетовРасход) КАК СуммаВзаиморасчетовРасход,
	|		СУММА(ВзаиморасчетыБезГруппировки.СуммаУпрНачальныйОстаток) КАК СуммаУпрНачальныйОстаток,
	|		СУММА(ВзаиморасчетыБезГруппировки.СуммаУпрКонечныйОстаток) КАК СуммаУпрКонечныйОстаток,
	|		СУММА(ВзаиморасчетыБезГруппировки.СуммаУпрПриход) КАК СуммаУпрПриход,
	|		СУММА(ВзаиморасчетыБезГруппировки.СуммаУпрРасход) КАК СуммаУпрРасход
	|	{ВЫБРАТЬ
	|		Организация.* КАК Организация,
	|		Контрагент.* КАК Контрагент,
	|		ДоговорКонтрагента.* КАК ДоговорКонтрагента,
	|		Контрагент.* КАК Контрагент,
	|		Сделка.* КАК Сделка,
	|		ДокументРасчетовСКонтрагентом.* КАК ДокументРасчетовСКонтрагентом,
	|		ВалютаВзаиморасчетов.* КАК ВалютаВзаиморасчетов,
	|		Регистратор.* КАК Регистратор,
	|		Период,
	|		ПериодДень,
	|		ПериодНеделя,
	|		ПериодДекада,
	|		ПериодМесяц,
	|		ПериодКвартал,
	|		ПериодПолугодие,
	|		ПериодГод,
	|		СуммаВзаиморасчетовНачальныйОстаток,
	|		СуммаВзаиморасчетовКонечныйОстаток,
	|		СуммаВзаиморасчетовПриход,
	|		СуммаВзаиморасчетовРасход,
	|		СуммаУпрНачальныйОстаток,
	|		СуммаУпрКонечныйОстаток,
	|		СуммаУпрПриход,
	|		СуммаУпрРасход}
	|	ИЗ
	|		(ВЫБРАТЬ
	|			ВзаиморасчетыПоДокументам.Организация КАК Организация,
	|			ВзаиморасчетыПоДокументам.Контрагент КАК Контрагент,
	|			ВзаиморасчетыПоДокументам.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|			ВзаиморасчетыПоДокументам.Сделка КАК Сделка,
	|			ВзаиморасчетыПоДокументам.ДокументРасчетовСКонтрагентом КАК ДокументРасчетовСКонтрагентом,
	|			ВзаиморасчетыПоДокументам.ДоговорКонтрагента.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|			ВзаиморасчетыПоДокументам.Регистратор КАК Регистратор,
	|			ВзаиморасчетыПоДокументам.Период КАК Период,
	|			НАЧАЛОПЕРИОДА(ВзаиморасчетыПоДокументам.Период, ДЕНЬ) КАК ПериодДень,
	|			НАЧАЛОПЕРИОДА(ВзаиморасчетыПоДокументам.Период, НЕДЕЛЯ) КАК ПериодНеделя,
	|			НАЧАЛОПЕРИОДА(ВзаиморасчетыПоДокументам.Период, ДЕКАДА) КАК ПериодДекада,
	|			НАЧАЛОПЕРИОДА(ВзаиморасчетыПоДокументам.Период, МЕСЯЦ) КАК ПериодМесяц,
	|			НАЧАЛОПЕРИОДА(ВзаиморасчетыПоДокументам.Период, КВАРТАЛ) КАК ПериодКвартал,
	|			НАЧАЛОПЕРИОДА(ВзаиморасчетыПоДокументам.Период, ПОЛУГОДИЕ) КАК ПериодПолугодие,
	|			НАЧАЛОПЕРИОДА(ВзаиморасчетыПоДокументам.Период, ГОД) КАК ПериодГод,
	|			ВзаиморасчетыПоДокументам.СуммаВзаиморасчетовНачальныйОстаток КАК СуммаВзаиморасчетовНачальныйОстаток,
	|			ВзаиморасчетыПоДокументам.СуммаВзаиморасчетовКонечныйОстаток КАК СуммаВзаиморасчетовКонечныйОстаток,
	|			ВзаиморасчетыПоДокументам.СуммаВзаиморасчетовПриход КАК СуммаВзаиморасчетовПриход,
	|			ВзаиморасчетыПоДокументам.СуммаВзаиморасчетовРасход КАК СуммаВзаиморасчетовРасход,
	|			0 КАК СуммаУпрНачальныйОстаток,
	|			0 КАК СуммаУпрКонечныйОстаток,
	|			0 КАК СуммаУпрПриход,
	|			0 КАК СуммаУпрРасход
	|		{ВЫБРАТЬ
	|			Организация.* КАК Организация,
	|			Контрагент.* КАК Контрагент,
	|			ДоговорКонтрагента.* КАК ДоговорКонтрагента,
	|			Контрагент.* КАК Контрагент,
	|			Сделка.* КАК Сделка,
	|			ДокументРасчетовСКонтрагентом.* КАК ДокументРасчетовСКонтрагентом,
	|			ВалютаВзаиморасчетов.* КАК ВалютаВзаиморасчетов,
	|			Регистратор.* КАК Регистратор,
	|			Период,
	|			ПериодДень,
	|			ПериодНеделя,
	|			ПериодДекада,
	|			ПериодМесяц,
	|			ПериодКвартал,
	|			ПериодПолугодие,
	|			ПериодГод,
	|			СуммаВзаиморасчетовНачальныйОстаток,
	|			СуммаВзаиморасчетовКонечныйОстаток,
	|			СуммаВзаиморасчетовПриход,
	|			СуммаВзаиморасчетовРасход,
	|			СуммаУпрНачальныйОстаток,
	|			СуммаУпрКонечныйОстаток,
	|			СуммаУпрПриход,
	|			СуммаУпрРасход}
	|		ИЗ
	|			РегистрНакопления.ВзаиморасчетыСКонтрагентамиПоДокументамРасчетов.ОстаткиИОбороты(&ДатаНач, &ДатаКон, Регистратор {(&Периодичность)}, , УпрУчет = ИСТИНА {(ДоговорКонтрагента).* КАК ДоговорКонтрагента, (Сделка).* КАК Сделка, (Контрагент).* КАК Контрагент, (Организация).* КАК Организация, (ДоговорКонтрагента.ВалютаВзаиморасчетов).* КАК ВалютаВзаиморасчетов, (ДокументРасчетовСКонтрагентом).* КАК ДокументРасчетовСКонтрагентом}) КАК ВзаиморасчетыПоДокументам
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			ВзаиморасчетыПоДокументамУпрУчет.Организация,
	|			ВзаиморасчетыПоДокументамУпрУчет.Контрагент,
	|			ВзаиморасчетыПоДокументамУпрУчет.ДоговорКонтрагента,
	|			ВзаиморасчетыПоДокументамУпрУчет.Сделка,
	|			НЕОПРЕДЕЛЕНО,
	|			ВзаиморасчетыПоДокументамУпрУчет.ДоговорКонтрагента.ВалютаВзаиморасчетов,
	|			ВзаиморасчетыПоДокументамУпрУчет.Регистратор,
	|			ВзаиморасчетыПоДокументамУпрУчет.Период,
	|			НАЧАЛОПЕРИОДА(ВзаиморасчетыПоДокументамУпрУчет.Период, ДЕНЬ),
	|			НАЧАЛОПЕРИОДА(ВзаиморасчетыПоДокументамУпрУчет.Период, НЕДЕЛЯ),
	|			НАЧАЛОПЕРИОДА(ВзаиморасчетыПоДокументамУпрУчет.Период, ДЕКАДА),
	|			НАЧАЛОПЕРИОДА(ВзаиморасчетыПоДокументамУпрУчет.Период, МЕСЯЦ),
	|			НАЧАЛОПЕРИОДА(ВзаиморасчетыПоДокументамУпрУчет.Период, КВАРТАЛ),
	|			НАЧАЛОПЕРИОДА(ВзаиморасчетыПоДокументамУпрУчет.Период, ПОЛУГОДИЕ),
	|			НАЧАЛОПЕРИОДА(ВзаиморасчетыПоДокументамУпрУчет.Период, ГОД),
	|			0,
	|			0,
	|			0,
	|			0,
	|			ВзаиморасчетыПоДокументамУпрУчет.СуммаУпрНачальныйОстаток,
	|			ВзаиморасчетыПоДокументамУпрУчет.СуммаУпрКонечныйОстаток,
	|			ВзаиморасчетыПоДокументамУпрУчет.СуммаУпрПриход,
	|			ВзаиморасчетыПоДокументамУпрУчет.СуммаУпрРасход
	|		{ВЫБРАТЬ
	|			Организация.* КАК Организация,
	|			Контрагент.* КАК Контрагент,
	|			ДоговорКонтрагента.* КАК ДоговорКонтрагента,
	|			Контрагент.* КАК Контрагент,
	|			Сделка.* КАК Сделка,
	|			ДокументРасчетовСКонтрагентом.* КАК ДокументРасчетовСКонтрагентом,
	|			ВалютаВзаиморасчетов.* КАК ВалютаВзаиморасчетов,
	|			Регистратор.* КАК Регистратор,
	|			Период,
	|			ПериодДень,
	|			ПериодНеделя,
	|			ПериодДекада,
	|			ПериодМесяц,
	|			ПериодКвартал,
	|			ПериодПолугодие,
	|			ПериодГод,
	|			СуммаВзаиморасчетовНачальныйОстаток,
	|			СуммаВзаиморасчетовКонечныйОстаток,
	|			СуммаВзаиморасчетовПриход,
	|			СуммаВзаиморасчетовРасход,
	|			СуммаУпрНачальныйОстаток,
	|			СуммаУпрКонечныйОстаток,
	|			СуммаУпрПриход,
	|			СуммаУпрРасход}
	|		ИЗ
	|			РегистрНакопления.ВзаиморасчетыСКонтрагентами.ОстаткиИОбороты(&ДатаНач, &ДатаКон, Регистратор {(&Периодичность)}, , ДоговорКонтрагента.ВестиПоДокументамРасчетовСКонтрагентом = ИСТИНА {(ДоговорКонтрагента).*, (Сделка).*, (Контрагент).*, (Организация).*, (ДоговорКонтрагента.ВалютаВзаиморасчетов).* КАК ВалютаВзаиморасчетов}) КАК ВзаиморасчетыПоДокументамУпрУчет
	|		ГДЕ
	|			(НЕ ВзаиморасчетыПоДокументамУпрУчет.Регистратор ССЫЛКА Документ.ПереоценкаВалютныхСредств)"
	+ ?(ЕстьПолеРегистратор, "
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			ВзаиморасчетыПоДокументамПереоценкаВал.Организация,
	|			ВзаиморасчетыПоДокументамПереоценкаВал.Контрагент,
	|			ВзаиморасчетыПоДокументамПереоценкаВал.ДоговорКонтрагента,
	|			ВзаиморасчетыПоДокументамПереоценкаВал.Сделка,
	|			НЕОПРЕДЕЛЕНО,
	|			ВзаиморасчетыПоДокументамПереоценкаВал.ДоговорКонтрагента.ВалютаВзаиморасчетов,
	|			ВзаиморасчетыПоДокументамПереоценкаВал.Регистратор,
	|			ВзаиморасчетыПоДокументамПереоценкаВал.Период,
	|			НАЧАЛОПЕРИОДА(ВзаиморасчетыПоДокументамПереоценкаВал.Период, ДЕНЬ),
	|			НАЧАЛОПЕРИОДА(ВзаиморасчетыПоДокументамПереоценкаВал.Период, НЕДЕЛЯ),
	|			НАЧАЛОПЕРИОДА(ВзаиморасчетыПоДокументамПереоценкаВал.Период, ДЕКАДА),
	|			НАЧАЛОПЕРИОДА(ВзаиморасчетыПоДокументамПереоценкаВал.Период, МЕСЯЦ),
	|			НАЧАЛОПЕРИОДА(ВзаиморасчетыПоДокументамПереоценкаВал.Период, КВАРТАЛ),
	|			НАЧАЛОПЕРИОДА(ВзаиморасчетыПоДокументамПереоценкаВал.Период, ПОЛУГОДИЕ),
	|			НАЧАЛОПЕРИОДА(ВзаиморасчетыПоДокументамПереоценкаВал.Период, ГОД),
	|			ВзаиморасчетыПоДокументамПереоценкаВал.СуммаВзаиморасчетовНачальныйОстаток,
	|			ВзаиморасчетыПоДокументамПереоценкаВал.СуммаВзаиморасчетовКонечныйОстаток,
	|			ВзаиморасчетыПоДокументамПереоценкаВал.СуммаВзаиморасчетовПриход,
	|			ВзаиморасчетыПоДокументамПереоценкаВал.СуммаВзаиморасчетовРасход,
	|			ВзаиморасчетыПоДокументамПереоценкаВал.СуммаУпрНачальныйОстаток,
	|			ВзаиморасчетыПоДокументамПереоценкаВал.СуммаУпрКонечныйОстаток,
	|			ВзаиморасчетыПоДокументамПереоценкаВал.СуммаУпрПриход,
	|			ВзаиморасчетыПоДокументамПереоценкаВал.СуммаУпрРасход
	|		{ВЫБРАТЬ
	|			Организация.* КАК Организация,
	|			Контрагент.* КАК Контрагент,
	|			ДоговорКонтрагента.* КАК ДоговорКонтрагента,
	|			Контрагент.* КАК Контрагент,
	|			Сделка.* КАК Сделка,
	|			ДокументРасчетовСКонтрагентом.* КАК ДокументРасчетовСКонтрагентом,
	|			ВалютаВзаиморасчетов.* КАК ВалютаВзаиморасчетов,
	|			Регистратор.* КАК Регистратор,
	|			Период,
	|			ПериодДень,
	|			ПериодНеделя,
	|			ПериодДекада,
	|			ПериодМесяц,
	|			ПериодКвартал,
	|			ПериодПолугодие,
	|			ПериодГод,
	|			СуммаВзаиморасчетовНачальныйОстаток,
	|			СуммаВзаиморасчетовКонечныйОстаток,
	|			СуммаВзаиморасчетовПриход,
	|			СуммаВзаиморасчетовРасход,
	|			СуммаУпрНачальныйОстаток,
	|			СуммаУпрКонечныйОстаток,
	|			СуммаУпрПриход,
	|			СуммаУпрРасход}
	|		ИЗ
	|			РегистрНакопления.ВзаиморасчетыСКонтрагентами.ОстаткиИОбороты(&ДатаНач, &ДатаКон, Регистратор {(&Периодичность)}, , ДоговорКонтрагента.ВестиПоДокументамРасчетовСКонтрагентом = ИСТИНА {(ДоговорКонтрагента).*, (Сделка).*, (Контрагент).*, (Организация).*, (ДоговорКонтрагента.ВалютаВзаиморасчетов).* КАК ВалютаВзаиморасчетов}) КАК ВзаиморасчетыПоДокументамПереоценкаВал
	|		ГДЕ
	|			ВзаиморасчетыПоДокументамПереоценкаВал.Регистратор ССЫЛКА Документ.ПереоценкаВалютныхСредств", "") + "
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			ВзаиморасчетыБезДокументов.Организация,
	|			ВзаиморасчетыБезДокументов.Контрагент,
	|			ВзаиморасчетыБезДокументов.ДоговорКонтрагента,
	|			ВзаиморасчетыБезДокументов.Сделка,
	|			НЕОПРЕДЕЛЕНО,
	|			ВзаиморасчетыБезДокументов.ДоговорКонтрагента.ВалютаВзаиморасчетов,
	|			ВзаиморасчетыБезДокументов.Регистратор,
	|			ВзаиморасчетыБезДокументов.Период,
	|			НАЧАЛОПЕРИОДА(ВзаиморасчетыБезДокументов.Период, ДЕНЬ),
	|			НАЧАЛОПЕРИОДА(ВзаиморасчетыБезДокументов.Период, НЕДЕЛЯ),
	|			НАЧАЛОПЕРИОДА(ВзаиморасчетыБезДокументов.Период, ДЕКАДА),
	|			НАЧАЛОПЕРИОДА(ВзаиморасчетыБезДокументов.Период, МЕСЯЦ),
	|			НАЧАЛОПЕРИОДА(ВзаиморасчетыБезДокументов.Период, КВАРТАЛ),
	|			НАЧАЛОПЕРИОДА(ВзаиморасчетыБезДокументов.Период, ПОЛУГОДИЕ),
	|			НАЧАЛОПЕРИОДА(ВзаиморасчетыБезДокументов.Период, ГОД),
	|			ВзаиморасчетыБезДокументов.СуммаВзаиморасчетовНачальныйОстаток,
	|			ВзаиморасчетыБезДокументов.СуммаВзаиморасчетовКонечныйОстаток,
	|			ВзаиморасчетыБезДокументов.СуммаВзаиморасчетовПриход,
	|			ВзаиморасчетыБезДокументов.СуммаВзаиморасчетовРасход,
	|			ВзаиморасчетыБезДокументов.СуммаУпрНачальныйОстаток,
	|			ВзаиморасчетыБезДокументов.СуммаУпрКонечныйОстаток,
	|			ВзаиморасчетыБезДокументов.СуммаУпрПриход,
	|			ВзаиморасчетыБезДокументов.СуммаУпрРасход
	|		{ВЫБРАТЬ
	|			Организация.* КАК Организация,
	|			Контрагент.* КАК Контрагент,
	|			ДоговорКонтрагента.* КАК ДоговорКонтрагента,
	|			Контрагент.* КАК Контрагент,
	|			Сделка.* КАК Сделка,
	|			ДокументРасчетовСКонтрагентом.* КАК ДокументРасчетовСКонтрагентом,
	|			ВалютаВзаиморасчетов.* КАК ВалютаВзаиморасчетов,
	|			Регистратор.* КАК Регистратор,
	|			Период,
	|			ПериодДень,
	|			ПериодНеделя,
	|			ПериодДекада,
	|			ПериодМесяц,
	|			ПериодКвартал,
	|			ПериодПолугодие,
	|			ПериодГод,
	|			СуммаВзаиморасчетовНачальныйОстаток,
	|			СуммаВзаиморасчетовКонечныйОстаток,
	|			СуммаВзаиморасчетовПриход,
	|			СуммаВзаиморасчетовРасход,
	|			СуммаУпрНачальныйОстаток,
	|			СуммаУпрКонечныйОстаток,
	|			СуммаУпрПриход,
	|			СуммаУпрРасход}
	|		ИЗ
	|			РегистрНакопления.ВзаиморасчетыСКонтрагентами.ОстаткиИОбороты(&ДатаНач, &ДатаКон, Регистратор {(&Периодичность)}, , ДоговорКонтрагента.ВестиПоДокументамРасчетовСКонтрагентом = ЛОЖЬ {(ДоговорКонтрагента).*, (Сделка).*, (Контрагент).*, (Организация).*, (ДоговорКонтрагента.ВалютаВзаиморасчетов).* КАК ВалютаВзаиморасчетов}) КАК ВзаиморасчетыБезДокументов) КАК ВзаиморасчетыБезГруппировки
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ВзаиморасчетыБезГруппировки.Организация,
	|		ВзаиморасчетыБезГруппировки.Контрагент,
	|		ВзаиморасчетыБезГруппировки.ДоговорКонтрагента,
	|		ВзаиморасчетыБезГруппировки.Сделка,
	|		ВзаиморасчетыБезГруппировки.ДокументРасчетовСКонтрагентом,
	|		ВзаиморасчетыБезГруппировки.ДоговорКонтрагента.ВалютаВзаиморасчетов,
	|		ВзаиморасчетыБезГруппировки.Регистратор,
	|		ВзаиморасчетыБезГруппировки.Период,
	|		ВзаиморасчетыБезГруппировки.ПериодДень,
	|		ВзаиморасчетыБезГруппировки.ПериодНеделя,
	|		ВзаиморасчетыБезГруппировки.ПериодДекада,
	|		ВзаиморасчетыБезГруппировки.ПериодМесяц,
	|		ВзаиморасчетыБезГруппировки.ПериодКвартал,
	|		ВзаиморасчетыБезГруппировки.ПериодПолугодие,
	|		ВзаиморасчетыБезГруппировки.ПериодГод) КАК Взаиморасчеты
	|//СОЕДИНЕНИЯ
	|{ГДЕ
	|	Взаиморасчеты.Регистратор.* КАК Регистратор,
	|	Взаиморасчеты.Период КАК Период,
	|	Взаиморасчеты.ПериодДень КАК ПериодДень,
	|	Взаиморасчеты.ПериодНеделя КАК ПериодНеделя,
	|	Взаиморасчеты.ПериодДекада КАК ПериодДекада,
	|	Взаиморасчеты.ПериодМесяц КАК ПериодМесяц,
	|	Взаиморасчеты.ПериодКвартал КАК ПериодКвартал,
	|	Взаиморасчеты.ПериодПолугодие КАК ПериодПолугодие,
	|	Взаиморасчеты.ПериодГод КАК ПериодГод,
	|	Взаиморасчеты.СуммаВзаиморасчетовНачальныйОстаток КАК СуммаВзаиморасчетовНачальныйОстаток,
	|	Взаиморасчеты.СуммаВзаиморасчетовКонечныйОстаток КАК СуммаВзаиморасчетовКонечныйОстаток,
	|	Взаиморасчеты.СуммаВзаиморасчетовПриход КАК СуммаВзаиморасчетовПриход,
	|	Взаиморасчеты.СуммаВзаиморасчетовРасход КАК СуммаВзаиморасчетовРасход,
	|	Взаиморасчеты.СуммаУпрНачальныйОстаток КАК СуммаУпрНачальныйОстаток,
	|	Взаиморасчеты.СуммаУпрКонечныйОстаток КАК СуммаУпрКонечныйОстаток,
	|	Взаиморасчеты.СуммаУпрПриход КАК СуммаУпрПриход,
	|	Взаиморасчеты.СуммаУпрРасход КАК СуммаУпрРасход
	|	//УСЛОВИЯ_СВОЙСТВА
	|	//УСЛОВИЯ_КАТЕГОРИИ
	|}
	|{УПОРЯДОЧИТЬ ПО
	|	Организация.* КАК Организация,
	|	Контрагент.* КАК Контрагент,
	|	ДоговорКонтрагента.* КАК ДоговорКонтрагента,
	|	Контрагент.* КАК Контрагент,
	|	Сделка.* КАК Сделка,
	|	ДокументРасчетовСКонтрагентом.* КАК ДокументРасчетовСКонтрагентом,
	|	ВалютаВзаиморасчетов.* КАК ВалютаВзаиморасчетов,
	|	Регистратор.* КАК Регистратор,
	|	Период,
	|	ПериодДень,
	|	ПериодНеделя,
	|	ПериодДекада,
	|	ПериодМесяц,
	|	ПериодКвартал,
	|	ПериодПолугодие,
	|	ПериодГод,
	|	СуммаВзаиморасчетовНачальныйОстаток,
	|	СуммаВзаиморасчетовКонечныйОстаток,
	|	СуммаВзаиморасчетовПриход,
	|	СуммаВзаиморасчетовРасход,
	|	СуммаУпрНачальныйОстаток,
	|	СуммаУпрКонечныйОстаток,
	|	СуммаУпрПриход,
	|	СуммаУпрРасход
	|	//ПСЕВДОНИМЫ_СВОЙСТВА
	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ
	|}
	|ИТОГИ
	|	СУММА(СуммаВзаиморасчетовНачальныйОстаток),
	|	СУММА(СуммаВзаиморасчетовКонечныйОстаток),
	|	СУММА(СуммаВзаиморасчетовПриход),
	|	СУММА(СуммаВзаиморасчетовРасход),
	|	СУММА(СуммаУпрНачальныйОстаток),
	|	СУММА(СуммаУпрКонечныйОстаток),
	|	СУММА(СуммаУпрПриход),
	|	СУММА(СуммаУпрРасход)
	|	//ИТОГИ_СВОЙСТВА
	|	//ИТОГИ_КАТЕГОРИИ
	|ПО
	|	ОБЩИЕ
	|{ИТОГИ ПО
	|	Организация.* КАК Организация,
	|	Контрагент.* КАК Контрагент,
	|	ДоговорКонтрагента.* КАК ДоговорКонтрагента,
	|	Контрагент.* КАК Контрагент,
	|	Сделка.* КАК Сделка,
	|	ДокументРасчетовСКонтрагентом.* КАК ДокументРасчетовСКонтрагентом,
	|	ВалютаВзаиморасчетов.* КАК ВалютаВзаиморасчетов,
	|	ПериодДень,
	|	ПериодНеделя,
	|	ПериодДекада,
	|	ПериодМесяц,
	|	ПериодКвартал,
	|	ПериодПолугодие,
	|	ПериодГод
	|	//ПСЕВДОНИМЫ_СВОЙСТВА
	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ
	|}";
	
	// В универсальном отчете включен флаг использования свойств и категорий.
	Если УниверсальныйОтчет.ИспользоватьСвойстваИКатегории Тогда
		
		// Добавление свойств и категорий поля запроса в таблицу полей.
		// Необходимо вызывать для каждого поля запроса, предоставляющего возможность использования свойств и категорий.
		
		// УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля(<ПсевдонимТаблицы>.<Поле> , <ПсевдонимПоля>, <Представление>, <Назначение>);
		
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("Взаиморасчеты.Организация", "Организация", "Организация", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Организации);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("Взаиморасчеты.Контрагент", "Контрагент", "Контрагент", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Контрагенты);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("Взаиморасчеты.ДоговорКонтрагента", "ДоговорКонтрагента", "Договор контрагента", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_ДоговорыКонтрагентов);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("Взаиморасчеты.Сделка", "Сделка", "Сделка", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Документы);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("Взаиморасчеты.Сделка", "Сделка", "Сделка", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Документ_ЗаказПокупателя);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("Взаиморасчеты.ДокументРасчетовСКонтрагентом", "ДокументРасчетовСКонтрагентом", "Документ расчетов с контрагентом", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Документы);
		
		// Добавление свойств и категорий в исходный текст запроса.
		УниверсальныйОтчет.ДобавитьВТекстЗапросаСвойстваИКатегории(ТекстЗапроса);
		
	КонецЕсли;
		
	// Инициализация текста запроса построителя отчета
	УниверсальныйОтчет.ПостроительОтчета.Текст = ТекстЗапроса;

КонецПроцедуры

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
	// УниверсальныйОтчет.мВыбиратьИмяРегистра = Ложь;
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
	// УниверсальныйОтчет.ВыводитьОбщиеИтоги = Ложь;
	
	// Содержит признак необходимости вывода детальных записей в отчет.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.ВыводитьДетальныеЗаписи = Истина;
	
	// Содержит признак необходимости отображения флага использования свойств и категорий в форме настройки.
	// Тип: Булево.
	// Значение по умолчанию: Истина.
	// Пример:
	// УниверсальныйОтчет.мВыбиратьИспользованиеСвойств = Ложь;
	УниверсальныйОтчет.мВыбиратьИспользованиеСвойств = Истина;
	
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
	
	УстановитьТекстЗапроса();
	
	ВалютаУпр = "(" + СокрЛП(глЗначениеПеременной("ВалютаУправленческогоУчета").Наименование) + ")";
	
	// Представления полей отчета.
	// Необходимо вызывать для каждого поля запроса.
	// УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить(<ИмяПоля>, <ПредставлениеПоля>);
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ДоговорКонтрагента", "Договор контрагента");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ДокументРасчетовСКонтрагентом", "Документ расчетов с контрагентом");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаВзаиморасчетовНачальныйОстаток", "Сумма взаиморасчетов начальный остаток");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаВзаиморасчетовКонечныйОстаток", "Сумма взаиморасчетов конечный остаток");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаВзаиморасчетовПриход", "Сумма взаиморасчетов приход");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаВзаиморасчетовРасход", "Сумма взаиморасчетов расход");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаУпрНачальныйОстаток", "Сумма " + ВалютаУпр + " начальный остаток");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаУпрКонечныйОстаток", "Сумма " + ВалютаУпр + " конечный остаток");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаУпрПриход", "Сумма " + ВалютаУпр + " приход");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаУпрРасход", "Сумма " + ВалютаУпр + " расход");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ВалютаВзаиморасчетов", "Валюта взаиморасчетов");
	
	// Добавление показателей
	// Необходимо вызывать для каждого добавляемого показателя.
	// УниверсальныйОтчет.ДобавитьПоказатель(<ИмяПоказателя>, <ПредставлениеПоказателя>, <ВключенПоУмолчанию>, <Формат>, <ИмяГруппы>, <ПредставлениеГруппы>);
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаВзаиморасчетовНачальныйОстаток", "нач. остаток", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаВзаиморасчетов", "Сумма взаиморасчетов");
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаВзаиморасчетовПриход", "приход", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаВзаиморасчетов", "Сумма взаиморасчетов");
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаВзаиморасчетовРасход", "расход", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаВзаиморасчетов", "Сумма взаиморасчетов");
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаВзаиморасчетовКонечныйОстаток",  "кон. остаток", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаВзаиморасчетов", "Сумма взаиморасчетов");
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаУпрНачальныйОстаток", "нач. остаток", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаУпр", "Сумма " + ВалютаУпр);
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаУпрПриход", "приход", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаУпр", "Сумма " + ВалютаУпр);
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаУпрРасход", "расход", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаУпр", "Сумма " + ВалютаУпр);
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаУпрКонечныйОстаток", "кон. остаток", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаУпр", "Сумма " + ВалютаУпр);
	
	// Добавление предопределенных группировок строк отчета.
	// Необходимо вызывать для каждой добавляемой группировки строки.
	// УниверсальныйОтчет.ДобавитьИзмерениеСтроки(<ПутьКДанным>);
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Организация");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Контрагент");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ДоговорКонтрагента");
	//УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ДокументРасчетовСКонтрагентом");
	
	// Добавление предопределенных группировок колонок отчета.
	// Необходимо вызывать для каждой добавляемой группировки колонки.
	// УниверсальныйОтчет.ДобавитьИзмерениеКолонки(<ПутьКДанным>);
	
	// Добавление предопределенных отборов отчета.
	// Необходимо вызывать для каждого добавляемого отбора.
	// УниверсальныйОтчет.ДобавитьОтбор(<ПутьКДанным>);
	УниверсальныйОтчет.ДобавитьОтбор("Организация");
	УниверсальныйОтчет.ДобавитьОтбор("Контрагент");
	УниверсальныйОтчет.ДобавитьОтбор("ДоговорКонтрагента");
	
	// Добавление предопределенных полей порядка отчета.
	// Необходимо вызывать для каждого добавляемого поля порядка.
	// УниверсальныйОтчет.ДобавитьПорядок(<ПутьКДанным>);
	
	// Установка связи подчиненных и родительских полей
	// УниверсальныйОтчет.УстановитьСвязьПолей(<ПутьКДанным>, <ПутьКДаннымРодитель>);
	УниверсальныйОтчет.УстановитьСвязьПолей("ВалютаВзаиморасчетов", "ДоговорКонтрагента");
	
	// Установка связи полей и измерений
	// УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения(<ИмяПоля>, <ИмяИзмерения>);
	
	// Установка представлений полей
	УниверсальныйОтчет.УстановитьПредставленияПолей(УниверсальныйОтчет.мСтруктураПредставлениеПолей, УниверсальныйОтчет.ПостроительОтчета);
	
	// Установка типов значений свойств в отборах отчета
	УниверсальныйОтчет.УстановитьТипыЗначенийСвойствДляОтбора();
	
	// Заполнение начальных настроек универсального отчета
	УниверсальныйОтчет.УстановитьНачальныеНастройки(Ложь);
	
	// Добавление дополнительных полей
	// Необходимо вызывать для каждого добавляемого дополнительного поля.
	// УниверсальныйОтчет.ДобавитьДополнительноеПоле(<ПутьКДанным>, <Размещение>, <Положение>);
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("ВалютаВзаиморасчетов");
	
КонецПроцедуры // УстановитьНачальныеНастройки()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ОТЧЕТА 
	
// Процедура формирования отчета
//
Процедура СформироватьОтчет(ТабличныйДокумент) Экспорт
	
	// Перед формированием отчета можно установить необходимые параметры универсального отчета
	
	ЕстьПолеРегистратор = Ложь;
	Для каждого ВыбранноеПоле Из УниверсальныйОтчет.ПостроительОтчета.ВыбранныеПоля Цикл
	
		ЕстьПолеРегистратор = Найти(ВыбранноеПоле.ПутьКДанным, "Регистратор") > 0;
		Если ЕстьПолеРегистратор Тогда
			Прервать;
		КонецЕсли;
	
	КонецЦикла;
	
	НастройкиПостроителя = УниверсальныйОтчет.ПостроительОтчета.ПолучитьНастройки(); 
	УстановитьТекстЗапроса(ЕстьПолеРегистратор);
	УниверсальныйОтчет.ПостроительОтчета.УстановитьНастройки(НастройкиПостроителя); 
	
	Если ЕстьПолеРегистратор Тогда
		
		НетГруппировкиПоДоговору = УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Найти("ДоговорКонтрагента") = Неопределено;
		Если НетГруппировкиПоДоговору Тогда
		
			НужноеИзмерение = УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Найти("Контрагент");
			Если НужноеИзмерение = Неопределено Тогда
				НужноеИзмерение = УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Найти("Организация");
			КонецЕсли;
			Если НужноеИзмерение = Неопределено Тогда
				НужноеИзмерение = УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Найти("ВалютаВзаиморасчетов");
			КонецЕсли;
			
			Если НужноеИзмерение = Неопределено Тогда
				ИндексДоговора = 0;
			Иначе
				ИндексДоговора = УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Индекс(НужноеИзмерение) + 1;
			КонецЕсли;
				
			УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Вставить("ДоговорКонтрагента", , , , , ИндексДоговора);
		
		КонецЕсли;
	
	КонецЕсли;
	
	УниверсальныйОтчет.СформироватьОтчет(ТабличныйДокумент);

КонецПроцедуры // СформироватьОтчет()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура обработки расшифровки
//
Процедура ОбработкаРасшифровки(Расшифровка, Объект) Экспорт
	
	// Дополнительные параметры в расшифровывающий отчет можно передать
	// посредством инициализации переменной "ДополнительныеПараметры".
	
	УниверсальныйОтчет.ОбработкаРасшифровкиУниверсальногоОтчета(Расшифровка, Объект);
	
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
// Возможные значения: 0 - произвольный период, 1 - на дату, 2 - неделя, 3 - декада, 4 - месяц, 5 - квартал, 6 - полугодие, 7 - год
// Значение по умолчанию: 0
// Пример:
// УниверсальныйОтчет.мРежимВводаПериода = 1;

#КонецЕсли
