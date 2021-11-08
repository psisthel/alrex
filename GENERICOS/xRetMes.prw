#INCLUDE "rwmake.ch"    
#Include "protheus.ch"          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXRETMES   บAutor  ณMicrosiga           บ Data ณ  04/30/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RetMes(nMes)

	nMes := strzero(nMes,2)
	
	IF nMes == '01'
		cMes := "ENERO" 
	ElseIf nMes == '02'
		cMes := "FEBRERO"
	ElseIf nMes == '03'
		cMes := "MARZO"
	ElseIf nMes == '04'
		cMes := "ABRIL"
	ElseIf nMes == '05'
		cMes := "MAYO"
	ElseIf nMes == '06'
		cMes := "JUNIO"
	ElseIf nMes == '07'
		cMes := "JULIO"
	ElseIf nMes == '08'
		cMes := "AGOSTO"
	ElseIf nMes == '09'
		cMes := "SETIEMBRE"
	ElseIf nMes == '10'
		cMes := "OCTUBRE"
	ElseIf nMes == '11'
		cMes := "NOVIEMBRE"
	ElseIf nMes == '12'
		cMes := "DICIEMBRE"
	EndIf
	
Return(cMes)
