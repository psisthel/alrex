#Include "Rwmake.ch"
#Include "Protheus.ch"
#INCLUDE "AppExcel.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALXSS020  ºAutor  ³Microsiga           º Data ³  02/07/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Consulta generica de saldos en stock                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ALRSS020()

	Local aArea		:= GetArea()
	Local oLst1
	Local _aDados	:= {}
	Local  nList	:= 0
	Local oDlg
	Local _bRet		:= .F.
	Local oSatGet
	Local _yAlias	:= getNextAlias()
	Local xSql		:= ""
	Local _cTexto	:= Space(40)
	
	Private nValor	:= 0 
	Private nVunit	:= 0 
	Private __aMeses := {}
	Private _aValores := {}
	Private _aBuscar	:= {}
	Private _cForma		:= ""
	Private oLst
	
	Define font oFont Name "Arial" SIZE 12,16
	Define font oFont1 Name "Arial" SIZE 09,10

	xSql := "SELECT TOP 1 B2_COD,B1_DESC,B1_TIPO,B2_LOCAL,B2_QATU,(B2_QATU-B2_QEMP) ACTUAL,B2_QEMP,B2_SALPEDI"
	xSql += "  FROM " + RetSqlname("SB2") + " A"
	xSql += "  LEFT JOIN " + RetSqlname("SB1") + " B"
	xSql += "    ON A.B2_COD = B.B1_COD"
	xSql += " WHERE A.B2_FILIAL='"+xFilial("SB2")+"'"
	xSql += "   AND B.B1_FILIAL='"+xFilial("SB1")+"'"
	xSql += "   AND A.D_E_L_E_T_=''"
	xSql += "   AND B.D_E_L_E_T_=''"
	xSql += "   AND B.B1_TIPO='MP'"
	xSql += " ORDER BY A.B2_COD,A.B2_LOCAL"
	 		
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,xSql),_yAlias, .F., .T.)
	 
	If (_yAlias)->( !Eof() )
		
		While (_yAlias)->( !Eof() )

			Aadd( _aDados, {	(_yAlias)->B2_COD,;			// 01
								(_yAlias)->B1_DESC,;		// 02
								(_yAlias)->B1_TIPO,;		// 03
								(_yAlias)->B2_LOCAL,;		// 04
								(_yAlias)->B2_QATU,;		// 05
								(_yAlias)->ACTUAL,;			// 06
								(_yAlias)->B2_QEMP,;		// 07
								(_yAlias)->B2_SALPEDI;		// 08
								})

			(_yalias)->( dbSkip() )
				
		End
			
	Endif
		
	(_yAlias)->( dbCloseArea() )
	

	aSort( _aDados,1,, { |x, y| x[1] > y[1] } )

	Aadd(_aBuscar,"1 - Descripcion del Producto")
	Aadd(_aBuscar,"2 - Codigo del Producto")
	Aadd(_aBuscar,"3 - Codigo de Barras")
 
	iif(nList = 0,nList := 1,nList)
	
	SB1->( dbSetOrder(1) )
 
	Define MsDialog oDlg Title "Saldos en Stock - Productos" From 0,0 To 600, 1140 Of oMainWnd Pixel
 
 	@  5,05 MSGET _cTexto SIZE 135,12 OF oDlg  PIXEL
 	
 	DEFINE SBUTTON FROM 5,145 TYPE 17 ACTION ( _aDados := BuscaPedido(_cTexto),oLst:SetArray(_aDados),	aSort( _aDados,1,, { |x, y| x[2] < y[2] } ),oLst:bLine := { || { _aDados[oLst:nAt,1], _aDados[oLst:nAt,2], _aDados[oLst:nAt,3], _aDados[oLst:nAt,4], _aDados[oLst:nAt,5], _aDados[oLst:nAt,6], _aDados[oLst:nAt,7], _aDados[oLst:nAt,8] }} ) ENABLE OF oDlg

 	_oCmbFormas := TComboBox():New(5,180, {|u| If(PCount()>0,_cForma:=u,_cForma)},_aBuscar,130,60,oDlg,,,,,,.T.,,,,,,,,,) 

	@ 25,5 LISTBOX oLst VAR lVarMat Fields HEADER "Codigo","Descripcion","Tipo","Almacen","Saldo Actual","Disponible","Empeño","En O.Compra";
			SIZE 560,180 On DblClick ( _bRet:=.T.,cCodigo:=_aDados[oLst:nAt,1],oDlg:End() /*ConfSC6(oLstZZY:nAt, @aDadosSC6, @_bRet)*/ ) OF oDlg PIXEL
 
	oLst:SetArray(_aDados)
	//oLstZZY:nAt := nList
	oLst:bLine := { || {_aDados[oLst:nAt,1], _aDados[oLst:nAt,2], _aDados[oLst:nAt,3], _aDados[oLst:nAt,4],_aDados[oLst:nAt,5], _aDados[oLst:nAt,6], _aDados[oLst:nAt,7], _aDados[oLst:nAt,8] }}
 
	oTButton1 := TButton():New( 210, 005, "Confirma",oDlg,{|| _bRet:=.T.,cCodigo:=_aDados[oLst:nAt,1],oDlg:End() }, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTButton2 := TButton():New( 210, 050, "Anular",oDlg,{|| _bRet:=.F.,oDlg:End() }, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTButton3 := TButton():New( 210, 095, "Principio Activo",oDlg,{|| _bRet:=.T.,_aDados:=BuscaGenerico(_aDados[oLst:nAt,3]),oLst:SetArray(_aDados),aSort( _aDados,1,, { |x, y| x[1] > y[1] } ),oLst:bLine := { || {_aDados[oLst:nAt,1], _aDados[oLst:nAt,2], _aDados[oLst:nAt,3], _aDados[oLst:nAt,4], _aDados[oLst:nAt,5], _aDados[oLst:nAt,6], _aDados[oLst:nAt,7], _aDados[oLst:nAt,8] }} }, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTButton4 := TButton():New( 210, 140, "Otros Locales",oDlg,{|| OtroLocal( _aDados[oLst:nAt,1] ) }, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTButton5 := TButton():New( 210, 185, "Ver Producto",oDlg,{|| SB1->( MsSeek( xFilial("SB1")+_aDados[oLst:nAt,1] ) ),A010Visul("SB1",SB1->(Recno())) }, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
 
	Activate MSDialog oDlg Centered

	RestArea( aArea )
	
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALXSS020  ºAutor  ³Microsiga           º Data ³  02/07/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function BuscaPedido(_cTexto)

	Local cQuery := ""
	Local _cAlias1 := getNextAlias()
	Local aDadSCK := {}

	cQuery := "SELECT B2_COD,B1_DESC,B1_TIPO,B2_LOCAL,B2_QATU,(B2_QATU-B2_QEMP) ACTUAL,B2_QEMP,B2_SALPEDI"
	cQuery += "  FROM " + RetSqlname("SB2") + " A"
	cQuery += "  LEFT JOIN " + RetSqlname("SB1") + " B"
	cQuery += "    ON A.B2_COD = B.B1_COD"
	cQuery += " WHERE A.B2_FILIAL='"+xFilial("SB2")+"'"
	cQuery += "   AND B.B1_FILIAL='"+xFilial("SB1")+"'"
	cQuery += "   AND A.D_E_L_E_T_=''"
	cQuery += "   AND B.D_E_L_E_T_=''"
	cQuery += "   AND B.B1_TIPO='MP'"
	
	If Left(_cForma,1)=="1"
		cQuery += "   AND B.B1_DESC LIKE '%" + Alltrim(Upper(_cTexto)) + "%'"
	ElseIf Left(_cForma,1)=="2"
		cQuery += "   AND B.B1_COD LIKE '%" + Alltrim(Upper(_cTexto)) + "%'"
	ElseIf Left(_cForma,1)=="3"
		cQuery += "   AND B.B1_CODBAR LIKE '%" + Alltrim(Upper(_cTexto)) + "%'"
	EndIf
	cQuery += " ORDER BY A.B2_COD,A.B2_LOCAL"
	
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),_cAlias1, .F., .T.)
 
	If (_cAlias1)->(!Eof())
	
		(_cAlias1)->(DbGoTop())
 
		While (_cAlias1)->(!Eof())

			Aadd( aDadSCK, {	(_cAlias1)->B2_COD,;		// 01
								(_cAlias1)->B1_DESC,;		// 02
								(_cAlias1)->B1_TIPO,;		// 03
								(_cAlias1)->B2_LOCAL,;		// 04
								transform((_cAlias1)->B2_QATU,"@E 999,999.999"),;	// 05
								transform((_cAlias1)->ACTUAL,"@E 999,999.999"),;		// 06
								transform((_cAlias1)->B2_QEMP,"@E 999,999.999"),;		// 07
								transform((_cAlias1)->B2_SALPEDI,"@E 999,999.999");		// 08
								})

			(_cAlias1)->( dbSkip() )
	 	 
		End
		
	Else
			aAdd( aDadSCK, { "",;
					"",;
					"",;
					"",;
					transform(0,"@E 999,999.999"),;
					transform(0,"@E 999,999.999"),;
					transform(0,"@E 999,999.999"),;
					transform(0,"@E 999,999.999");
					} )

	EndIf
	 
	(_cAlias1)->( DbCloseArea() )
	
	oLst:SetArray(aDadSCK)
	oLst:Refresh()

Return( aDadSCK )

