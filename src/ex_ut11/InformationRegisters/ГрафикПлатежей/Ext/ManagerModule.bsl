﻿
&Вместо("РассчитатьГрафикПлатежейПоДенежнымСредствамВПути")
Процедура TBK_РассчитатьГрафикПлатежейПоДенежнымСредствамВПути(ТаблицаОбъектовОплаты, Очередь)
	// Вставить содержимое метода.
	Попытка
		ПродолжитьВызов(ТаблицаОбъектовОплаты, Очередь);
	Исключение
	КонецПопытки;
КонецПроцедуры
