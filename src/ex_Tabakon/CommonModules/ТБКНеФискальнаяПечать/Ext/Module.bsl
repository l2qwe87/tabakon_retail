&НаКлиенте
Процедура НапечататьЧек(Товары, Сдача, СНО, Магазин, Кассир) экспорт
	
	ШиринаЛенты		=	64;
	СуммаИтого		=	0;
	
	СпецСимвол	=	ПолучитьСпецСимвол(СНО); 	
	
	Fptr = ПодключитьВнешнююКомпоненту("AddIn.Fptr10");
	Fptr = Новый COMобъект("AddIn.Fptr10");
	Fptr.open();
	
	
	Если не Fptr.isOpened() тогда
		МенеджерОборудованияКлиент.ПоменятьПараметры(Истина);
		
		Fptr = ПодключитьВнешнююКомпоненту("AddIn.Fptr10");
		Fptr = Новый COMобъект("AddIn.Fptr10");
		Fptr.open();
	КонецЕсли;    
	
	Если не Fptr.isOpened() тогда
		Сообщить("Ошибка печати!");
		Возврат;
	КонецЕсли;
	
	//запрос данных из ККТ
	Fptr.setParam(Fptr.LIBFPTR_PARAM_DATA_TYPE, Fptr.LIBFPTR_DT_STATUS);
	Fptr.queryData();
	serialNumber    = Fptr.getParamString(Fptr.LIBFPTR_PARAM_SERIAL_NUMBER);
	receiptNumber   = Fptr.getParamInt(Fptr.LIBFPTR_PARAM_RECEIPT_NUMBER);
	documentNumber  = Fptr.getParamInt(Fptr.LIBFPTR_PARAM_DOCUMENT_NUMBER);
	shiftNumber     = Fptr.getParamInt(Fptr.LIBFPTR_PARAM_SHIFT_NUMBER);    	
	
	Fptr.setParam(Fptr.LIBFPTR_PARAM_FN_DATA_TYPE, Fptr.LIBFPTR_FNDT_REG_INFO);
	Fptr.fnQueryData();
	registrationNumber        = fptr.getParamString(1037);
	organizationVATIN         = fptr.getParamString(1018);
	paymentsAddress           = fptr.getParamString(1187);
	organizationName          = fptr.getParamString(1048);
	
	Fptr.setParam(Fptr.LIBFPTR_PARAM_FN_DATA_TYPE, Fptr.LIBFPTR_FNDT_FN_INFO);
	Fptr.fnQueryData();

	fnSerial            = Fptr.getParamString(Fptr.LIBFPTR_PARAM_SERIAL_NUMBER);
	fnVersion           = Fptr.getParamString(Fptr.LIBFPTR_PARAM_FN_VERSION);

	//
	
	Fptr.beginNonfiscalDocument();
	
	ПечатьСтроки(Fptr,"Кассовый чек",2);
	
	ТоЧтоСлева		=	"Место расчетов";
	ТоЧтоСправа		=	Магазин;
	ПечатьСтроки_Пробелы(Fptr, ТоЧтоСлева, ТоЧтоСправа);
	
	//Товары
	Для каждого Строка из Товары цикл
		ТоЧтоСлева		=	Строка(Строка.Номенклатура);
		ТоЧтоСправа		=	Строка(Строка.Цена) + ".00      *" +Строка(Строка.Количество)+"   =" + Строка(Строка.Цена*Строка.Количество)+СпецСимвол;
		Если СтрДлина(ТоЧтоСлева+ТоЧтоСправа) > ШиринаЛенты -1 тогда
			ПечатьСтроки(Fptr,ТоЧтоСлева);
		    ПечатьСтроки_Пробелы(Fptr, "", ТоЧтоСправа);
		иначе
			ПечатьСтроки_Пробелы(Fptr, ТоЧтоСлева, ТоЧтоСправа);
		КонецЕсли;
		
		Если СпецСимвол = "" тогда
			ПечатьСтроки(Fptr,"НДС не облагается");
		КонецЕсли;

		
		
		СуммаИтого	=	СуммаИтого + Строка.Цена * Строка.Количество; 
	КонецЦикла;
	//
	//Итого
	Стр = "_________________________________________________________________";
	ПечатьСтроки(Fptr,Стр);    
	
	ТоЧтоСлева		=	"ИТОГ";
	ТоЧтоСправа		=	"=" +СуммаИтого+".00";
	ПечатьСтроки_Пробелы(Fptr, ТоЧтоСлева, ТоЧтоСправа, Истина);

		
	Стр = "_________________________________________________________________";
	ПечатьСтроки(Fptr,Стр);
	//
	
	//Секция С Данными
	Если СпецСимвол	=	" А" тогда
		ТоЧтоСлева	=	"А: СУММА НДС 20%";
		ТоЧтоСправа	=	"="+ Окр((СуммаИтого/1.2 - СуммаИтого)*-1,2);
	иначе
		ТоЧтоСлева	=	"СУММА БЕЗ НДС";
		ТоЧтоСправа	=	"="+ СуммаИтого+".00";   
	КонецЕсли;
	ПечатьСтроки_Пробелы(Fptr, ТоЧтоСлева, ТоЧтоСправа);
	
	
	ТоЧтоСлева		=	"НАЛИЧНЫМИ";
	ТоЧтоСправа		=	"="+ СуммаИтого+".00";
	ПечатьСтроки_Пробелы(Fptr, ТоЧтоСлева, ТоЧтоСправа);
	
	Если Сдача >0 тогда
		ТоЧтоСлева		=	"ПОЛУЧЕНО НАЛИЧНЫМИ";
		ТоЧтоСправа		=	"="+ (СуммаИтого+Сдача)+".00";
		ПечатьСтроки_Пробелы(Fptr, ТоЧтоСлева, ТоЧтоСправа);
		
		ТоЧтоСлева		=	"СДАЧА";
		ТоЧтоСправа		=	"="+ Сдача+".00";
		ПечатьСтроки_Пробелы(Fptr, ТоЧтоСлева, ТоЧтоСправа);
	КонецЕсли;

	ТоЧтоСлева		=	"Кассир";
	ТоЧтоСправа		=	Кассир;
	ПечатьСтроки_Пробелы(Fptr, ТоЧтоСлева, ТоЧтоСправа);
	
	ПечатьСтроки(Fptr,organizationName);
	ПечатьСтроки(Fptr,paymentsAddress);

	ТоЧтоСлева		=	"ОФД";
	ТоЧтоСправа		=	"ООО ""Такском""";
	ПечатьСтроки_Пробелы(Fptr, ТоЧтоСлева, ТоЧтоСправа);
	
	ТоЧтоСлева		=	"Сайт ФНС";
	ТоЧтоСправа		=	"nalog.ru";
	ПечатьСтроки_Пробелы(Fptr, ТоЧтоСлева, ТоЧтоСправа);

	Стр = "_________________________________________________________________";
	ПечатьСтроки(Fptr,Стр);  
	
	//фискальные данные
	
	ПечатьСтроки(Fptr,"ЗН ККТ "	+	serialNumber);
	ПечатьСтроки(Fptr,"РН ККТ "	+	registrationNumber);
	ПечатьСтроки(Fptr,"ИНН "	+	organizationVATIN);
	ПечатьСтроки(Fptr,"ФН "		+	fnSerial);
	ПечатьСтроки(Fptr,"ФД "		+	documentNumber);
	ПечатьСтроки(Fptr,"ФП 2996364181");
	ПечатьСтроки(Fptr,"ЧЕК 00"+(receiptNumber+1)+" ПРИХОД");
	//ПечатьСтроки(Fptr,"СМЕНА 000"+shiftNumber);
	Если Строка(СНО) = "Общая" тогда
		ПечатьСтроки(Fptr,"СНО ОСН");
	иначе
		ПечатьСтроки(Fptr,"СНО УСН доход-расход");
	КонецЕсли;
	
	ПечатьСтроки(Fptr,Лев(Строка(ТекущаяДата()),16) + "   СМЕНА 000"+shiftNumber);
	
	

	
	//печать рядом с куаром не работает!
	//Fptr.setParam(Fptr.LIBFPTR_PARAM_TEXT, "W");
	//Fptr.setParam(Fptr.LIBFPTR_PARAM_ALIGNMENT, Fptr.LIBFPTR_ALIGNMENT_RIGHT);
	//Fptr.setParam(Fptr.LIBFPTR_PARAM_DEFER,Fptr.LIBFPTR_DEFER_OVERLAY);
	//Fptr.printText();
	//Fptr.setParam(Fptr.LIBFPTR_PARAM_TEXT, "W");
	//Fptr.setParam(Fptr.LIBFPTR_PARAM_ALIGNMENT, Fptr.LIBFPTR_ALIGNMENT_RIGHT);
	//Fptr.setParam(Fptr.LIBFPTR_PARAM_DEFER,1);
	//Fptr.printText();
	//
	Fptr.setParam(Fptr.LIBFPTR_PARAM_BARCODE, "tt=20211015T1222&s=2.00&fn=996005591440300344360&i=188&fp=919818984&n=1");
	Fptr.setParam(Fptr.LIBFPTR_PARAM_BARCODE_TYPE, Fptr.LIBFPTR_BT_QR);
	Fptr.setParam(Fptr.LIBFPTR_PARAM_ALIGNMENT, Fptr.LIBFPTR_ALIGNMENT_LEFT);
	Fptr.setParam(Fptr.LIBFPTR_PARAM_SCALE, 5);
	Fptr.printBarcode();

	
	//Конец
	Fptr.setParam(Fptr.LIBFPTR_PARAM_PRINT_FOOTER, false);
	Fptr.endNonfiscalDocument();
	
	Fptr.close();
	//	        
КонецПроцедуры  

Процедура ПечатьСтроки(ДрайверККМ,Стр , Выравнивание = 1)
	
	Если Выравнивание = 1 тогда
		ДрайверККМ.setParam(ДрайверККМ.LIBFPTR_PARAM_ALIGNMENT, ДрайверККМ.LIBFPTR_ALIGNMENT_LEFT);
		
	ИначеЕсли Выравнивание = 2 тогда
		ДрайверККМ.setParam(ДрайверККМ.LIBFPTR_PARAM_ALIGNMENT, ДрайверККМ.LIBFPTR_ALIGNMENT_CENTER);
	Иначе
		ДрайверККМ.setParam(ДрайверККМ.LIBFPTR_PARAM_ALIGNMENT, ДрайверККМ.LIBFPTR_ALIGNMENT_RIGHT);
	КонецЕсли;
	
		
	ДрайверККМ.setParam(ДрайверККМ.LIBFPTR_PARAM_TEXT, Стр);  
	
	ДрайверККМ.printText();  
КонецПроцедуры

Процедура ПечатьСтроки_Пробелы(ДрайверККМ, ТоЧтоСлева, ТоЧтоСправа, НуженЖир = Ложь)
	ШиринаЛенты 	= 64;
	
	Если НуженЖир тогда
		ДрайверККМ.setParam(ДрайверККМ.LIBFPTR_PARAM_FONT_DOUBLE_WIDTH, true);	
		ШиринаЛенты = ШиринаЛенты/2;
	КонецЕсли;

	КолПробелов		=	ШиринаЛенты - СтрДлина(ТоЧтоСправа) -  СтрДлина(ТоЧтоСлева);	
	Стр				=	ТоЧтоСлева + ДобавитьСлева(КолПробелов) + ТоЧтоСправа;
	
		
	ДрайверККМ.setParam(ДрайверККМ.LIBFPTR_PARAM_TEXT, Стр);  
	
	
	ДрайверККМ.printText();  
КонецПроцедуры

Функция  ДобавитьСлева(КолПробелов)
	СтрВ	=	"";
	Для Ном = 1 по КолПробелов цикл
		СтрВ = СтрВ + " ";
	КонецЦикла;
	Возврат СтрВ;
КонецФункции


Функция ПолучитьСпецСимвол(СНО) 
	Если Строка(СНО)	=	"Общая" тогда
		СпецСимвол	=	" А";
	иначе
		СпецСимвол	=	"";
	КонецЕсли;
	
	Возврат СпецСимвол;	
КонецФункции

