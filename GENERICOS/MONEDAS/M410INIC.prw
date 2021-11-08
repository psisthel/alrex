#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M410INIC  �Autor  �Microsiga           � Data �  07/25/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function M410INIC

	lNoMon:=Valmone()
	//Si existe alguna moneda sin cotizacion altera tabla para que se indique
	IF !lNoMon
	   MSGBOX("Atenci�n, las tasas de cambio monetarias (TRM) de la fecha de trabajo no fueron "+;
	         "cargadas en el sistema, usted no podr� operar con el mismo. Favor comunicarse "+;
	  		 "con el departamento de Administraci�n y Finanzas a los efectos de solucionar "+;     
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
