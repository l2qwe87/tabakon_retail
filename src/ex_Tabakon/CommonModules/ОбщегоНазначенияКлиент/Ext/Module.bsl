﻿функция ПолучитьПутьКаталогаИб() Экспорт
	КаталогИб = СтрокаСоединенияИнформационнойБазы();
	КаталогИб = СтрЗаменить(КаталогИб, "File=""", "");
	КаталогИб = СтрЗаменить(КаталогИб, """;", "");
	Возврат КаталогИб;
КонецФункции