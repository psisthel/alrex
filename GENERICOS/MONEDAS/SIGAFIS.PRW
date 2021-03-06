#INCLUDE "RWMAKE.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � SIGAFAT  � Autor �                       � Data � 26-05-04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Punto de entrada al ingresar a facturacion                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � SIGAFIS.PRW                                                ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFIS                                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function SIGAFIS
Local cNombre1   := UPPER(alltrim(Substr(cUsuario,7,15)))
Local cClave1    := alltrim(Substr(cUsuario,1,6))
Local cMVALTMONE := ALLTRIM(UPPER(GETNewPAR("AL_ALTMONE","ADMINISTRADOR/carlos amoretti/percy arias")))
Local lAutoriza  := (cNombre1 $ cMVALTMONE)

lNoMon:=Valmone()
//Si existe alguna moneda sin cotizacion altera tabla para que se indique
IF !lNoMon
   MSGBOX("Atenci�n,las tasas de cambio monetarias (TRM) de la fecha de trabajo no fueron "+;
         "cargadas en el sistema, usted no podr� operar con el mismo. Favor comunicarse "+;
  		 "con el departamento de Administraci�n y Finanzas a los efectos de solucionar "+;     
         "este inconveniente. Para consultas intente ingresar con una fecha anterior "+;
         "si sus permisos lo habilitan.  "+chr(13)+chr(13)+chr(13)+;
         " Intentar Nuevamente  ?","TRM NO INGRESADAS","YESNO")          
         Final(OemToAnsi("FINALIZA "))//CIERRA CESION DE USUARIO
ENDIF
/*
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

/*/
����������������������������������������������������������������������������������������
������������������������������������������������������������������������������������Ŀ��
���Fun��o	 �CtbPeriodos� Autor � Pilar S. Albaladejo 			   � Data � 27/11/00 ���
������������������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna os periodos para a moeda.                                      ���
������������������������������������������������������������������������������������Ĵ��
���Sintaxe	 �CtbPeriodos(cMoeda,dDtIni,dDtFim,lExercicio,lZeradas)                  ���
������������������������������������������������������������������������������������Ĵ��
���Retorno	 �aRet                                                        			 ���
������������������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 												 			 ���
������������������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Moeda                            				 			 ���
���			 � ExpD1 = Data Inicial													 ���
���			 � ExpD2 = Data Final  													 ���
���			 � ExpL1 = Indica se a verificacao do periodo deve ser por exercicio     ���
���			 � ExpL2 = Indica se a existirem calendarios fora da data solicita       ���
���			 �         Retornara matriz com informacoes em branco                    ���
�������������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������������
����������������������������������������������������������������������������������������
/*/
user FUNCTION CtbPeriodos( cMoeda, dDtIni, dDtFim, lExercicio, lZeradas, cCalend )


LOCAL aRet		:= {}
Local aAreaPer	:= GetArea()
Local lAchouFim	:= .F.


dDtFim := Iif(Empty(dDtFim),dDtIni,dDtFim)

// Se nao informou o calendario, exige amarracao entre Moeda e Calendario
If Empty( cCalend )
	
	// Localiza a moeda 
	dbSelectArea("CTO")
	dbSetOrder(1)
	If MsSeek(xFilial("CTO")+cMoeda)
		dbSelectArea("CTE")
		dbSetOrder(1)    
		If MsSeek(xFilial()+cMoeda)
			While !Eof() .And. CTE_FILIAL == xFilial() .And. CTE->CTE_MOEDA == cMoeda
				// Localiza os periodos para a moeda
				dbSelectArea("CTG")
				dbSetOrder(1)
				MsSeek(xFilial()+CTE->CTE_CALEND)
				While 	CTG->(!Eof()) 							.AND.;
						CTG->CTG_FILIAL == xFilial("CTG") 		.AND.;
						CTG->CTG_CALEND == CTE->CTE_CALEND
					
					// Se estiver dentro do periodo solicitado
					If 	If(lExercicio,  Year(CTG->CTG_DTFIM) <= Year(dDtFim) .And.;
										Year(CTG->CTG_DTINI) >= Year(dDtIni),;
						CTG->CTG_DTINI <= dDtIni .AND.;
						CTG->CTG_DTFIM >= dDtFim)
						// Adiciona os periodos na matriz de retorno
						Aadd( aRet, { 	CTG->CTG_DTINI, CTG->CTG_DTFIM,;
										CTG->CTG_EXERC, CTG->CTG_STATUS } )
						lAchouFim := .T.
	               
		            // Se o Periodo do Calendario estiver dentro do intervalo solicitado. Para atender, por exemplo, calendario com periodos diarios
					ElseIf !lExercicio .And. CTG->CTG_DTINI >= dDtIni .AND. CTG->CTG_DTINI <= dDtFim
	
						Aadd( aRet, { CTG->CTG_DTINI, CTG->CTG_DTFIM, CTG->CTG_EXERC, CTG->CTG_STATUS } )
		               	// Verificando se encontrou a data final do intervalo no calendario
						If ! lAchouFim
							lAchouFim := ( CTG->CTG_DTFIM >= dDtFim )
						EndIf
	
					ElseIf lZeradas
						Aadd( aRet, {	CTOD("  /  /  "), CTOD("  /  /  "), Space(4), " " })
					Endif					  
					dbSkip()
				EndDo
				dbSelectArea("CTE")
				dbSkip()
			EndDo	
			If Len(aRet) = 0
				Aadd( aRet, {	CTOD("  /  /  "), CTOD("  /  /  "), Space(4), " " })
	
			ElseIf !lAchouFim		//	Se nao encontrou no calendario a data final do intervalo, nao permitir continuar
				aRet := {}
				Aadd( aRet, {	CTOD("  /  /  "), CTOD("  /  /  "), Space(4), " " })
			Endif			
		Else
			Aadd( aRet, {	CTOD("  /  /  "), CTOD("  /  /  "), Space(4), " " })
		EndIf
	Else                                                                         
		Aadd( aRet, {	CTOD("  /  /  "), CTOD("  /  /  "), Space(4), " " })
	EndIf	

Else	//	Se informou o calendario, NAO exige amarracao entre Moeda e Calendario. Utilizado para agrupar os 
		//	valores de varias formas (Ex.: mensal, trimestral, semestral, anual, etc.) sem ter que alterar o 
		//	calendario que possui a amarracao com as moedas.

	dbSelectArea("CTG")
	dbSetOrder(1)
	MsSeek( xFilial("CTG")+cCalend )
	
    While CTG->(!Eof()) .And. CTG->CTG_FILIAL == xFilial("CTG") .And. CTG->CTG_CALEND == cCalend

		// Se estiver dentro do periodo solicitado
        If 	If( lExercicio,	Year(CTG->CTG_DTFIM) <= Year(dDtFim) .And. Year(CTG->CTG_DTINI) >= Year(dDtIni),;
							CTG->CTG_DTINI <= dDtIni .AND. CTG->CTG_DTFIM >= dDtFim )

			// Adiciona os periodos na matriz de retorno
			Aadd( aRet, { CTG->CTG_DTINI, CTG->CTG_DTFIM, CTG->CTG_EXERC, CTG->CTG_STATUS } )
            lAchouFim := .T.


        // Se o Periodo do Calendario estiver dentro do intervalo solicitado. Para atender, por exemplo, calendario 
        // com periodos diarios
        ElseIf !lExercicio .And. CTG->CTG_DTINI >= dDtIni .AND. CTG->CTG_DTINI <= dDtFim

			Aadd( aRet, { CTG->CTG_DTINI, CTG->CTG_DTFIM, CTG->CTG_EXERC, CTG->CTG_STATUS } )

	        // Verificando se encontrou a data final do intervalo no calendario
            If ! lAchouFim
               lAchouFim := ( CTG->CTG_DTFIM >= dDtFim )
            EndIf

        ElseIf lZeradas
			Aadd( aRet, { CTOD("  /  /  "), CTOD("  /  /  "), Space(4), " " })
        Endif

		CTG->( DbSkip() )
    EndDo

EndIf


RestArea(aAreaPer)

RETURN iIf(aRet[1][4]=='1',.T.,.F.)


