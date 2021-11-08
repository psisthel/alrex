#INCLUDE "RWMAKE.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ SIGAFAT  ³ Autor ³                       ³ Data ³ 26-05-04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Punto de entrada al ingresar a facturacion                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ SIGAFIS.PRW                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFIS                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SIGAFIS
Local cNombre1   := UPPER(alltrim(Substr(cUsuario,7,15)))
Local cClave1    := alltrim(Substr(cUsuario,1,6))
Local cMVALTMONE := ALLTRIM(UPPER(GETNewPAR("AL_ALTMONE","ADMINISTRADOR/carlos amoretti/percy arias")))
Local lAutoriza  := (cNombre1 $ cMVALTMONE)

lNoMon:=Valmone()
//Si existe alguna moneda sin cotizacion altera tabla para que se indique
IF !lNoMon
   MSGBOX("Atención,las tasas de cambio monetarias (TRM) de la fecha de trabajo no fueron "+;
         "cargadas en el sistema, usted no podrá operar con el mismo. Favor comunicarse "+;
  		 "con el departamento de Administración y Finanzas a los efectos de solucionar "+;     
         "este inconveniente. Para consultas intente ingresar con una fecha anterior "+;
         "si sus permisos lo habilitan.  "+chr(13)+chr(13)+chr(13)+;
         " Intentar Nuevamente  ?","TRM NO INGRESADAS","YESNO")          
         Final(OemToAnsi("FINALIZA "))//CIERRA CESION DE USUARIO
ENDIF
/*
lnoper	:= u_CtbPeriodos("01",dDatabase,dDataBase,.F.,.F.)
IF !lnoper
   MSGBOX("Atención, El calendario contable se encuentra cerrado o bloqueado para esta fecha"+;
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³CtbPeriodos³ Autor ³ Pilar S. Albaladejo 			   ³ Data ³ 27/11/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Retorna os periodos para a moeda.                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³CtbPeriodos(cMoeda,dDtIni,dDtFim,lExercicio,lZeradas)                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³aRet                                                        			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												 			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Moeda                            				 			 ³±±
±±³			 ³ ExpD1 = Data Inicial													 ³±±
±±³			 ³ ExpD2 = Data Final  													 ³±±
±±³			 ³ ExpL1 = Indica se a verificacao do periodo deve ser por exercicio     ³±±
±±³			 ³ ExpL2 = Indica se a existirem calendarios fora da data solicita       ³±±
±±³			 ³         Retornara matriz com informacoes em branco                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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


