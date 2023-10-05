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

Функция СинхронизироватьСДатойКомпьютера_Сервер(КассаККМ) экспорт
	Попытка
		Fptr = ПодключитьВнешнююКомпоненту("AddIn.Fptr10");
		Fptr = Новый COMобъект("AddIn.Fptr10");
		Fptr.open();
		
		Если не Fptr.isOpened() тогда 
			Fptr.close();			
			Возврат ложь;		
		КонецЕсли; 	
				
		//Собрать Версию прошивки 1 раз
		Попытка
			Fptr.setParam(Fptr.LIBFPTR_PARAM_DATA_TYPE, 17);
			Fptr.querydata();		
			Версия	=	Fptr.getParamString(Fptr.LIBFPTR_PARAM_UNIT_VERSION);

			СтрокаСоединенияСБД =  СтрокаСоединенияИнформационнойБазы();
			ПутьКБД 			= Сред(СтрокаСоединенияСБД, 7, СтрДлина(СтрокаСоединенияСБД) -8);
			Каталог 			= Новый Файл(ПутьКБД);
			
			ТекстСообщения	=	Строка(КассаККМ) + " версия прошивки: "+  Версия;

			Если Каталог.Существует() Тогда
				ПутьКФайлу	=	ПутьКБД + "\tbk_version_atol.txt";
				Файл_Версии = Новый Файл(ПутьКФайлу);
				
				Если не Файл_Версии.Существует() Тогда  			
					док = Новый ТекстовыйДокумент();
					док.УстановитьТекст(ТекстСообщения);
					док.Записать(ПутьКФайлу, "windows-1251");				
				КонецЕсли; 		
			КонецЕсли;
		Исключение
		КонецПопытки;	
		//Конец Сбора

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


Функция УстановитьКлише_Сервер() экспорт
	Попытка
		Fptr = ПодключитьВнешнююКомпоненту("AddIn.Fptr10");
		Fptr = Новый COMобъект("AddIn.Fptr10");
		Fptr.open();
		
		Если не Fptr.isOpened() тогда 
			Fptr.close();			
			Возврат ложь;		
		КонецЕсли; 	
		
		Fptr.setParam(Fptr.LIBFPTR_PARAM_DATA_TYPE, 17);
		Fptr.querydata(); 

		
		Если не Fptr.getParamString(Fptr.LIBFPTR_PARAM_UNIT_VERSION) = "3.0.1245" тогда
		    fptr.setParam(fptr.LIBFPTR_PARAM_FILENAME, "C:\Users\admin\Desktop\Новая папка\logo.bmp");
	    	fptr.setParam(fptr.LIBFPTR_PARAM_SCALE_PERCENT, 70.0);
	    	fptr.uploadPictureCliche();
			
			Fptr.setParam(Fptr.LIBFPTR_PARAM_SETTING_ID, 184);
			Fptr.setParam(Fptr.LIBFPTR_PARAM_SETTING_VALUE, "");
			
			Fptr.writeDeviceSetting();   	
			Fptr.commitSettings();

			
			Fptr.setParam(Fptr.LIBFPTR_PARAM_SETTING_ID, 185);
			Fptr.setParam(Fptr.LIBFPTR_PARAM_SETTING_VALUE, "⇌⤊04⤊»П»Р»И»Г»Л»А»Ш»А»Е»М »Н»А »Р»А»Б»О»Т»У");
			
			Fptr.writeDeviceSetting();   	
			Fptr.commitSettings();

			
			Fptr.setParam(Fptr.LIBFPTR_PARAM_SETTING_ID, 186);
			Fptr.setParam(Fptr.LIBFPTR_PARAM_SETTING_VALUE, "⤊04⤊8-981-987-30-34, 8-969-734-16-42⇌"); 
			
			Fptr.writeDeviceSetting();   	
			Fptr.commitSettings();


			Fptr.setParam(Fptr.LIBFPTR_PARAM_SETTING_ID, 187);
			Fptr.setParam(Fptr.LIBFPTR_PARAM_SETTING_VALUE, "⤊04⤊⇌»w»w»w.»t»a»b»a»k»o»n.»s»u");	
			
			Fptr.writeDeviceSetting();   	
			Fptr.commitSettings();    	
			
			ОбщегоНазначенияВызовСервера.Установить_ЗначениеКонстанты_Общая("КлишеИзмененоУспешно", истина);	
		иначе
			Fptr.setParam(Fptr.LIBFPTR_PARAM_SETTING_ID, 14);
			Fptr.setParam(Fptr.LIBFPTR_PARAM_SETTING_VALUE, 5);
			
			Fptr.writeDeviceSetting();   	
			Fptr.commitSettings();
			
			Fptr.setParam(Fptr.LIBFPTR_PARAM_SETTING_ID, 35);
			Fptr.setParam(Fptr.LIBFPTR_PARAM_SETTING_VALUE, 3);
			
			Fptr.writeDeviceSetting();   	
			Fptr.commitSettings();


			
			Fptr.setParam(Fptr.LIBFPTR_PARAM_SETTING_ID, 186);
			Fptr.setParam(Fptr.LIBFPTR_PARAM_SETTING_VALUE, "     »П»Р»И»Г»Л»А»Ш»А»Е»М »Н»А »Р»А»Б»О»Т»У");
			
			Fptr.writeDeviceSetting();   	
			Fptr.commitSettings();

			
			Fptr.setParam(Fptr.LIBFPTR_PARAM_SETTING_ID, 187);
			Fptr.setParam(Fptr.LIBFPTR_PARAM_SETTING_VALUE, "         8-981-987-30-34, 8-969-734-16-42⇌"); 
			
			Fptr.writeDeviceSetting();   	
			Fptr.commitSettings();


			Fptr.setParam(Fptr.LIBFPTR_PARAM_SETTING_ID, 188);
			Fptr.setParam(Fptr.LIBFPTR_PARAM_SETTING_VALUE, "            »w»w»w.»t»a»b»a»k»o»n.»s»u");	
			
			Fptr.writeDeviceSetting();   	
			Fptr.commitSettings();    	
			
			ОбщегоНазначенияВызовСервера.Установить_ЗначениеКонстанты_Общая("КлишеИзмененоУспешно", истина);				
		КонецЕсли;

	
		Fptr.close();
		Возврат истина;		
	Исключение
		Возврат ложь;
	КонецПопытки;
КонецФункции   


