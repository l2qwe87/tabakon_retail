Функция ПолучиьтСуммуККТ_Сервер()
	Попытка
		Fptr = ПодключитьВнешнююКомпоненту("AddIn.Fptr10");
		Fptr = Новый COMобъект("AddIn.Fptr10");
		Fptr.open();
		
		Если не Fptr.isOpened() тогда 
			Fptr.close();
			
			Возврат Неопределено;		
		КонецЕсли; 		

		Fptr.setParam(Fptr.LIBFPTR_PARAM_DATA_TYPE, Fptr.LIBFPTR_DT_CASH_SUM);
		Fptr.queryData();

		СуммаККТ = Fptr.getParamDouble(Fptr.LIBFPTR_PARAM_SUM);
		
		Fptr.close();
		Возврат СуммаККТ; 
		
	Исключение
		Возврат Неопределено;
	КонецПопытки;  
КонецФункции