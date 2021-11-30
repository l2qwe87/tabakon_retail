Функция ПолучитьСуммуККТ_Сервер() экспорт
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

Функция СинхронизироватьСДатойКомпьютера_Сервер() экспорт
	Попытка
		Fptr = ПодключитьВнешнююКомпоненту("AddIn.Fptr10");
		Fptr = Новый COMобъект("AddIn.Fptr10");
		Fptr.open();
		
		Если не Fptr.isOpened() тогда 
			Fptr.close();			
			Возврат ложь;		
		КонецЕсли; 	
		
		//Проверка на разницу во времени фискальника и компа. если меньше трех минут то ничего не делаем
		Fptr.setParam(Fptr.LIBFPTR_PARAM_DATA_TYPE, Fptr.LIBFPTR_DT_DATE_TIME);
	    Fptr.queryData();
		ДатаВремяФискальника	=	Fptr.getParamDateTime(Fptr.LIBFPTR_PARAM_DATE_TIME);
		Разница					=	ДатаВремяФискальника - ТекущаяДата();
		Разница					=	Макс(Разница,-1*Разница);
		Если Разница < 180 тогда
			Fptr.close();			
			Возврат истина;
		КонецЕсли;    
		//
		
		СтрТекДат	= Формат(ТекущаяДата(),"ДФ=yyyy.MM.dd") +" "+  Формат(ТекущаяДата(),"ДЛФ=T");		
	
		sc =  Новый COMобъект("MSScriptControl.ScriptControl");    
		sc.Language="vbscript";
		sc.AddCode("
		    |Function strOperationProductionStartTime(fp,X)
		    |   strOperationProductionStartTime =  fp.setParam(fp.LIBFPTR_PARAM_DATE_TIME, CDate(X))
		    |End Function
		    |");
		sc.CodeObject.strOperationProductionStartTime(Fptr,СтрТекДат);  				
		
		Fptr.writeDateTime();  
		
		Fptr.close();
		Возврат истина;		
	Исключение
		Возврат ложь;
	КонецПопытки;
КонецФункции
