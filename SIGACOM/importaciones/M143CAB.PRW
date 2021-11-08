/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³MT143SF1 ºAutor ³Juan Pablo Astorga        ºFecha ³ 06/10/17 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc. ³ Grabacion de Tipo de comprobante , Codigo Diario y Serie de 4  º±±
±±º ³ Caracteres para documentos disntos a CIF y FOB					  º±±
±±º ³ 																	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso ³ MSExecAuto/MATA143 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M143CAB()

	Local aRetSF1	:= ParamIXB[1]
	Local _aAREA	:= GETAREA()       
	Local cSerie	:= DBB->DBB_SERIE
	Local cSerie2	:= DBB->DBB_XSER2
	local _cModal	:= getNewPar("AL_MODFOR","0900001")
	
	AADD(aRetSF1,{"F1_TPDOC" , DBB->DBB_XTPDOC,NIL})	
	AADD(aRetSF1,{"F1_DIACTB", "08",NIL})   
	Aadd(aRetSF1,{"F1_NATUREZ", _cModal,NIL})
	
	IF POSICIONE("SA2",1,XFILIAL("SA2")+DBB->DBB_FORNECE+DBB->DBB_LOJA,"A2_DOMICIL")=='2'	
		AADD(aRetSF1,{"F1_TPRENTA",DBB->DBB_XTPREN,NIL})                     
	EndIf
	
	RestArea(_aArea)
	
Return(aRetSF1)