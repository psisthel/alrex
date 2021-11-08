#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CHKAPUNTE ºAutor  ³Percy Arias,SISTHEL º Data ³  07/19/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CHKAPUNTE()

	Local aArea		:= GetArea()
	Local _aDados	:= {}
	Local _aApuntes	:= {}
	Local nList		:= 0
	Local oLst
	Local nList1	:= 0
	Local oLst1
	
	Private oDlg
	Private _bRet	:= .F.
	
	_aDados := _getPedido()
	_aApuntes := _getApuntes()
	
	If Len( _aDados ) > 0
	
		If _aDados[1][2] <> ""
	
			iif(nList = 0,nList := 1,nList)
			iif(nList1 = 0,nList1 := 1,nList1)
			
			Define MsDialog oDlg Title "Validar Pedidos X Apuntes" FROM 0,0 TO 530,850 PIXEL /*alto x ancho */
			
			@ 5,5 LISTBOX oLst VAR lVarMat Fields HEADER "Pedido","Item","Familia.","Producto","Cant.Solicitada" SIZE 420,120 /*On DblClick ( ConfChoice(oLst:nAt, @_aDados, @_bRet) )*/ OF oDlg PIXEL

			oLst:SetArray(_aDados)
			oLst:nAt := nList
			oLst:bLine := { || { 	_aDados[oLst:nAt,1],;
									_aDados[oLst:nAt,2],;
									_aDados[oLst:nAt,3],;
									_aDados[oLst:nAt,4],;
									Transform( _aDados[oLst:nAt,5],"999,999.99") }}

			@ 125,5 LISTBOX oLst1 VAR lVarMat1 Fields HEADER "O.P.","Item","Pedido","Producto","Cant.Apuntada" SIZE 420,120 /*On DblClick ( ConfChoice(oLst:nAt, @_aDados, @_bRet) )*/ OF oDlg PIXEL

			oLst1:SetArray(_aApuntes)
			oLst1:nAt := nList1
			oLst1:bLine := { || { 	_aApuntes[oLst1:nAt,1],;
									_aApuntes[oLst1:nAt,2],;
									_aApuntes[oLst1:nAt,3],;
									_aApuntes[oLst1:nAt,4],;
									Transform( _aApuntes[oLst1:nAt,5],"999,999.99") }}

				 
			DEFINE SBUTTON FROM 250,5 TYPE 2  ACTION ( oDlg:End() ) ENABLE OF oDlg 
				 
			Activate MSDialog oDlg Centered
			
		EndIf

	EndIf
	
	RestArea( aArea )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CHKAPUNTE ºAutor  ³Microsiga           º Data ³  07/19/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _getPedido()

	Local oArea		:= getArea()
	Local cQry1		:= ""
	Local cAlias	:= getNextAlias()
	Local aUltComp	:= {}

	cQry1 := "SELECT * "
	cQry1 += "  FROM " + RetSqlname("SC6")
	cQry1 += " WHERE C6_FILIAL='"+xFilial("SC6")+"'"
	cQry1 += "   AND C6_NUM='"+SC5->C5_NUM+"'"
	cQry1 += "   AND D_E_L_E_T_=''"
	cQry1 += " ORDER BY C6_ITEM"
	 
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQry1),cAlias, .F., .T.)
 
	If (cAlias)->( !Eof() )

		While (cAlias)->( !Eof() )
		
			Aadd( aUltComp, {	(cAlias)->C6_NUM,;
								(cAlias)->C6_ITEM,;
								(cAlias)->C6_YCODF,;
								(cAlias)->C6_PRODUTO,;
								(cAlias)->C6_QTDVEN } )
			(cAlias)->( dbSkip() )

		End
	Else
		Aadd( aUltComp, { 0, "", "", "", "", "", "", 0 } )
	Endif
	
	(cAlias)->( dbCloseArea() )
	
	RestArea( oArea )

Return( aUltComp )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CHKAPUNTE ºAutor  ³Microsiga           º Data ³  07/19/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _getApuntes()

	Local oArea		:= getArea()
	Local cQry1		:= ""
	Local cAlias	:= getNextAlias()
	Local aUltComp	:= {}

	cQry1 := "SELECT * "
	cQry1 += "  FROM " + RetSqlname("SC2")
	cQry1 += " WHERE C2_FILIAL='"+xFilial("SC2")+"'"
	cQry1 += "   AND C2_PEDIDO='"+SC5->C5_NUM+"'"
	cQry1 += "   AND D_E_L_E_T_=''"
	cQry1 += " ORDER BY C2_NUM"
	 
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQry1),cAlias, .F., .T.)
 
	If (cAlias)->( !Eof() )

		While (cAlias)->( !Eof() )
		
			Aadd( aUltComp, {	(cAlias)->C2_NUM,;
								(cAlias)->C2_ITEM,;
								(cAlias)->C2_PEDIDO,;
								(cAlias)->C2_PRODUTO,;
								(cAlias)->C2_QUJE } )
			(cAlias)->( dbSkip() )

		End
	Else
		Aadd( aUltComp, { 0, "", "", "", "", "", "", 0 } )
	Endif
	
	(cAlias)->( dbCloseArea() )
	
	RestArea( oArea )

Return( aUltComp )
