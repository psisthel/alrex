#INCLUDE "RWMAKE.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � SIGAFIS  � Autor �                       � Data � 26-05-04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Punto de entrada al ingresar a facturacion                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � SIGAFIS.PRW                                                ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGACOM                                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function SIGACOM
Local cNombre1   := UPPER(alltrim(Substr(cUsuario,7,15)))
Local cClave1    := alltrim(Substr(cUsuario,1,6))
Local cMVALTMONE := ALLTRIM(UPPER(GETNewPAR("AL_ALTMONE","'ADMINISTRADOR'/carlos amoretti/percy arias")))
Local lAutoriza  := (cNombre1 $ cMVALTMONE)

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
/* NACHO
lnoper	:= u_CtbPeriodos("01",dDatabase,dDataBase,.F.,.F.)
IF !lnoper
   MSGBOX("Atenci�n, El calendario contable se encuentra cerrado o bloqueado para esta fecha"+;
   			" para continuar Operando solicite al Sector de Administracion y finanzas la Apertura del mismo")             
         Final(OemToAnsi("FINALIZA "))//CIERRA CESION DE USUARIO
ENDIF
*/ 
Return

///*****************************************
///* ValMone  : VAlida que las monedas tengan
///*            su cotizacion diaria
///******************************************
Static Function Valmone
Local lRet:=.T.

Select SM2
Seek dDataBase

IF GetNewPar("MV_MOEDA2","*") != "*"
   IF !Empty(MV_MOEDA2)
      IF SM2->M2_MOEDA2 = 0.00
         lRet:=.F.
      ENDIF
   Endif
Endif
/*IF GetNewPar("MV_MOEDA3","*") != "*"
  IF !Empty(MV_MOEDA3)
    IF SM2->M2_MOEDA3 = 0.00
       lRet:=.F.
    ENDIF
  Endif
Endif
IF GetNewPar("MV_MOEDA4","*") != "*"
  IF !Empty(MV_MOEDA4)
     IF SM2->M2_MOEDA4 = 0.00
        lRet:=.F.
      ENDIF
  Endif
Endif
IF GetNewPar("MV_MOEDA5","*") != "*"
  IF !Empty(MV_MOEDA5)
      IF SM2->M2_MOEDA5 = 0.00
         lRet:=.F.
      ENDIF
  Endif
Endif   */

return(lRet)
