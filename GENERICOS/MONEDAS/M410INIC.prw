#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M410INIC  ºAutor  ³Microsiga           º Data ³  07/25/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M410INIC

	lNoMon:=Valmone()
	//Si existe alguna moneda sin cotizacion altera tabla para que se indique
	IF !lNoMon
	   MSGBOX("Atención, las tasas de cambio monetarias (TRM) de la fecha de trabajo no fueron "+;
	         "cargadas en el sistema, usted no podrá operar con el mismo. Favor comunicarse "+;
	  		 "con el departamento de Administración y Finanzas a los efectos de solucionar "+;     
	         "este inconveniente. Para consultas intente ingresar con una fecha anterior "+;
	         "si sus permisos lo habilitan.  "+chr(13)+chr(13)+chr(13)+;
	         " Intentar Nuevamente  ?","TRM NO INGRESADAS","YESNO")
	
	         Final(OemToAnsi("FINALIZA "))//CIERRA CESION DE USUARIO
	ENDIF
	
Return

Static Function Valmone

	Local lRet:=.T.
	local _aArea := getArea()
	
	Select SM2
	Seek dDataBase
	
	IF GetNewPar("MV_MOEDA2","*") != "*"
	   IF !Empty(MV_MOEDA2)
	      IF SM2->M2_MOEDA2 = 0.00
	         lRet:=.F.
	      ENDIF
	   Endif
	Endif
	
	restArea(_aArea)
	
return(lRet)
