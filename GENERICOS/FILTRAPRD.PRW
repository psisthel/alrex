#include "protheus.ch"
#include "rwmake.ch"
#include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GETSB1B2  ºAutor  ³Percy Arias,SISTHEL º Data ³  03/08/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta consulta especifica en los precupuestos, llamando la º±±
±±º          ³ consulta generica SB1FAT a partir del campo CK_PRODUTO     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Uso FUSAC                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FILTRAPRD()

	Local bRet := .T.
	Local __aArea := getArea()
 
	Private cCodigo := Alltrim(&(ReadVar()))
 
	bRet := FiltraSB1()
	
	RestArea(__aArea)
 
Return(bRet)
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GETSB1B2  ºAutor  ³Microsiga           º Data ³  03/08/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FiltraSB1()

	Local cQuery
	Local oLstSB1 := nil
	Local _cTexto := Space(40)
	Local cAlias1 := getNextAlias()
	Local cCodigo := Space(TAMSX3("C7_PRODUTO")[1])

	Private oDlgZZY		:= nil
	Private _bRet		:= .F.
	Private aDadosSC6 	:= {}
	Private nList		:= 0
	Private oLstZZY
	Private _aBuscar	:= {}
	Private _cForma		:= ""
 
	cQuery := "SELECT B1_COD,B1_DESC,A5_CODPRF,A5_YPRDFOR,A5_NOMEFOR,SA5.R_E_C_N_O_ AS NREC"
	cQuery += "  FROM " + RetSQLName("SB1") + " SB1"
	cQuery += "  LEFT JOIN " + RetSQLName("SA5") + " SA5" 
	cQuery += "    ON SA5.A5_PRODUTO=SB1.B1_COD"
	cQuery += " WHERE SB1.B1_FILIAL='" + xFilial("SB1") + "'" 
	cQuery += "   AND SB1.B1_TIPO='MP'"
	cQuery += "   AND SB1.R_E_C_N_O_ > 0"
	cQuery += "   AND SB1.D_E_L_E_T_=''"
	cQuery += " ORDER BY SA5.A5_YPRDFOR"
			
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias1, .F., .T.)
 
	(cAlias1)->(DbGoTop())
	If (cAlias1)->(Eof())

		ConPad1(,,,"SB1")
		_bRet := .t.
		
	else
 
		While (cAlias1)->(!Eof())

			aAdd( aDadosSC6, { (cAlias1)->B1_COD,;
					(cAlias1)->B1_DESC,;
					(cAlias1)->A5_CODPRF,;
					(cAlias1)->A5_YPRDFOR,;
					(cAlias1)->A5_NOMEFOR } )

			(cAlias1)->(DbSkip())
	 
		End
	 
		(cAlias1)->( DbCloseArea() )
	 
		aSort( aDadosSC6,1,, { |x, y| x[1] > y[1] } )
	
		Aadd(_aBuscar,"1 - Codigo Producto en Proveedor")
		Aadd(_aBuscar,"2 - Descrip.Producto en Proveedor")
		Aadd(_aBuscar,"3 - Descripcion del Producto")
		Aadd(_aBuscar,"4 - Codigo del Producto")
		Aadd(_aBuscar,"5 - Nombre del Proveedor")
	 
		iif(nList = 0,nList := 1,nList)
		
		SB1->( dbSetOrder(1) )
	 
		Define MsDialog oDlgZZY Title "Productos" From 0,0 To 450, 1140 Of oMainWnd Pixel
	 
	 	@  5,05 MSGET _cTexto SIZE 135,8.5 OF oDlgZZY  PIXEL
	 	
	 	DEFINE SBUTTON FROM 5,145 TYPE 17 ACTION ( aDadosSC6 := BuscaPedido(_cTexto),oLstZZY:SetArray(aDadosSC6),	aSort( aDadosSC6,1,, { |x, y| x[2] < y[2] } ),oLstZZY:bLine := { || {aDadosSC6[oLstZZY:nAt,1], aDadosSC6[oLstZZY:nAt,2], aDadosSC6[oLstZZY:nAt,3], aDadosSC6[oLstZZY:nAt,4],aDadosSC6[oLstZZY:nAt,5] }} ) ENABLE OF oDlgZZY
	
	 	_oCmbFormas := TComboBox():New(5,180, {|u| If(PCount()>0,_cForma:=u,_cForma)},_aBuscar,130,60,oDlgZZY,,,,,,.T.,,,,,,,,,) 
	
		@ 25,5 LISTBOX oLstZZY VAR lVarMat Fields HEADER "Codigo","Descripcion","Prod.Proveedor","Producto Prov.","Nombre Proveedor";
				SIZE 560,180 On DblClick ( _bRet:=.T.,cCodigo:=aDadosSC6[oLstZZY:nAt,1],oDlgZZY:End() /*ConfSC6(oLstZZY:nAt, @aDadosSC6, @_bRet)*/ ) OF oDlgZZY PIXEL
	 
		oLstZZY:SetArray(aDadosSC6)
		//oLstZZY:nAt := nList
		oLstZZY:bLine := { || {aDadosSC6[oLstZZY:nAt,1], aDadosSC6[oLstZZY:nAt,2], aDadosSC6[oLstZZY:nAt,3], aDadosSC6[oLstZZY:nAt,4],aDadosSC6[oLstZZY:nAt,5] }}
	 	
		oTButton1 := TButton():New( 210, 005, "Confirma",oDlgZZY,{|| _bRet:=.T.,cCodigo:=aDadosSC6[oLstZZY:nAt,1],oDlgZZY:End() }, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )   
		oTButton2 := TButton():New( 210, 050, "Anular",oDlgZZY,{|| _bRet:=.F.,oDlgZZY:End() }, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )   
		oTButton3 := TButton():New( 210, 095, "Ver Producto",oDlgZZY,{|| SB1->( MsSeek( xFilial("SB1")+aDadosSC6[oLstZZY:nAt,1] ) ),A010Visul("SB1",SB1->(Recno())) }, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
		oTButton4 := TButton():New( 210, 140, "Ver Saldos",oDlgZZY,{|| u_BVIEWSB2() }, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	 
		Activate MSDialog oDlgZZY Centered
		
		If _bRet
			if FUNNAME()=="MATA113"
				M->C1_PRODUTO := cCodigo
			else
				M->C7_PRODUTO := cCodigo
			endif
		Else
			if FUNNAME()=="MATA113"
				M->C7_PRODUTO := Space(TAMSX3("C7_PRODUTO")[1])
			else
				M->C1_PRODUTO := Space(TAMSX3("C1_PRODUTO")[1])
			endif
		EndIf
		
	endif
 
Return _bRet
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GETSB1B2  ºAutor  ³Microsiga           º Data ³  03/03/17   º±±
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
	
	cQuery := "SELECT B1_COD,B1_DESC,A5_CODPRF,A5_YPRDFOR,A5_NOMEFOR,SA5.R_E_C_N_O_ AS NREC"
	cQuery += "  FROM " + RetSQLName("SB1") + " SB1"
	cQuery += "  LEFT JOIN " + RetSQLName("SA5") + " SA5" 
	cQuery += "    ON SA5.A5_PRODUTO=SB1.B1_COD"
	cQuery += " WHERE SB1.B1_FILIAL='" + xFilial("SB1") + "'" 
	cQuery += "   AND SB1.B1_TIPO='MP'"
	cQuery += "   AND SB1.R_E_C_N_O_ > 0"
	cQuery += "   AND SB1.D_E_L_E_T_=''"

	If Left(_cForma,1)=="2"
		cQuery += "   AND SA5.A5_YPRDFOR LIKE '%" + Alltrim(Upper(_cTexto)) + "%'"
	ElseIf Left(_cForma,1)=="1"
		cQuery += "   AND SA5.A5_CODPRF LIKE '%" + Alltrim(Upper(_cTexto)) + "%'"
	ElseIf Left(_cForma,1)=="3"
		cQuery += "   AND SB1.B1_DESC LIKE '%" + Alltrim(Upper(_cTexto)) + "%'"
	ElseIf Left(_cForma,1)=="4"
		cQuery += "   AND SB1.B1_COD LIKE '%" + Alltrim(Upper(_cTexto)) + "%'"
	ElseIf Left(_cForma,1)=="5"
		cQuery += "   AND SA5.A5_NOMEFOR LIKE '%" + Alltrim(Upper(_cTexto)) + "%'"
	EndIf

	cQuery += " ORDER BY SA5.A5_YPRDFOR"
	
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),_cAlias1, .F., .T.)
 
	If (_cAlias1)->(!Eof())
	
		(_cAlias1)->(DbGoTop())
 
		While (_cAlias1)->(!Eof())

			aAdd( aDadSCK, { (_cAlias1)->B1_COD,;
					(_cAlias1)->B1_DESC,;
					(_cAlias1)->A5_CODPRF,;
					(_cAlias1)->A5_YPRDFOR,;
					(_cAlias1)->A5_NOMEFOR } )
	 					
			(_cAlias1)->(DbSkip())
	 
		End
		
	Else
			aAdd( aDadSCK, { "",;
					"",;
					"",;
					"",;
					"" } )

	EndIf
	 
	(_cAlias1)->( DbCloseArea() )
	
	oLstZZY:SetArray(aDadSCK)
	oLstZZY:Refresh()

Return( aDadSCK )
