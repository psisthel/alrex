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
User Function SLDXLOTE()

	Local bRet := .T.
	Local __aArea := getArea()
 
	Private cCodigo := Alltrim(&(ReadVar()))
 
	_bRet := FiltraSB8()
	
	RestArea(__aArea)
 
Return(_bRet)
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SLDXLOTE  ºAutor  ³Microsiga           º Data ³  01/07/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FiltraSB8()

	Local kArea := getArea()
	Local cQuery
	Local oLstSB1 := nil
	Local _cTexto := Space(40)

	Private oDlgZZY		:= nil
	Private _bRet		:= .F.
	Private aDadosSC6 	:= {}
	Private nList		:= 0
	Private oLstZZY
	Private _aBuscar	:= {}
	Private _cForma		:= ""
	
	private cCodigo := Space(TAMSX3("NNT_PROD")[1])
	public XNNTLOCAL := Space(TAMSX3("NNT_LOCAL")[1])
	public XNNTLOTE := Space(TAMSX3("NNT_LOTECT")[1])
 
	aAdd( aDadosSC6, {	"",;
						"",;
						"",;
						"",;
						"",;
						"",;
						"" } )

	aSort( aDadosSC6,1,, { |x, y| x[1] > y[1] } )
	
	Aadd(_aBuscar,"1 - Codigo del Producto")
	Aadd(_aBuscar,"2 - Descripcion del Producto")

	iif(nList = 0,nList := 1,nList)
		
		SB1->( dbSetOrder(1) )
	 
		Define MsDialog oDlgZZY Title "Productos X Lote" From 0,0 To 450, 1140 Of oMainWnd Pixel
	 
	 	@  5,05 MSGET _cTexto SIZE 135,8.5 OF oDlgZZY  PIXEL
	 	
	 	DEFINE SBUTTON FROM 5,145 TYPE 17 ACTION ( aDadosSC6 := BuscaPedido(_cTexto),oLstZZY:SetArray(aDadosSC6),	aSort( aDadosSC6,1,, { |x, y| x[2] < y[2] } ),oLstZZY:bLine := { || {aDadosSC6[oLstZZY:nAt,1], aDadosSC6[oLstZZY:nAt,2], aDadosSC6[oLstZZY:nAt,3], aDadosSC6[oLstZZY:nAt,4],aDadosSC6[oLstZZY:nAt,5],aDadosSC6[oLstZZY:nAt,6],aDadosSC6[oLstZZY:nAt,7] }} ) ENABLE OF oDlgZZY
	
	 	_oCmbFormas := TComboBox():New(5,180, {|u| If(PCount()>0,_cForma:=u,_cForma)},_aBuscar,130,60,oDlgZZY,,,,,,.T.,,,,,,,,,) 
	
		@ 25,5 LISTBOX oLstZZY VAR lVarMat Fields HEADER "Producto","Descripcion","Local","Lote","Validez","Saldo","A Clasificar";
				SIZE 560,180 On DblClick ( _bRet:=.T.,cCodigo:=aDadosSC6[oLstZZY:nAt,1],XNNTLOCAL:=aDadosSC6[oLstZZY:nAt,3],XNNTLOTE:=aDadosSC6[oLstZZY:nAt,4],oDlgZZY:End() /*ConfSC6(oLstZZY:nAt, @aDadosSC6, @_bRet)*/ ) OF oDlgZZY PIXEL
	 
		oLstZZY:SetArray(aDadosSC6)
		//oLstZZY:nAt := nList
		oLstZZY:bLine := { || {aDadosSC6[oLstZZY:nAt,1], aDadosSC6[oLstZZY:nAt,2], aDadosSC6[oLstZZY:nAt,3], aDadosSC6[oLstZZY:nAt,4],aDadosSC6[oLstZZY:nAt,5],aDadosSC6[oLstZZY:nAt,6],aDadosSC6[oLstZZY:nAt,7] }}
	 	
		oTButton1 := TButton():New( 210, 005, "Confirma",oDlgZZY,{|| _bRet:=.T.,cCodigo:=aDadosSC6[oLstZZY:nAt,1],XNNTLOCAL:=aDadosSC6[oLstZZY:nAt,3],XNNTLOTE:=aDadosSC6[oLstZZY:nAt,4],oDlgZZY:End() }, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )   
		oTButton2 := TButton():New( 210, 050, "Anular",oDlgZZY,{|| _bRet:=.F.,oDlgZZY:End() }, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )   
	 
		Activate MSDialog oDlgZZY Centered

		If _bRet
			M->NNT_PROD := cCodigo
			M->NNT_LOCAL := XNNTLOCAL
			M->NNT_LOTECT := XNNTLOTE
		Else
			M->NNT_PROD := Space( TAMSX3("NNT_PROD")[1] )
			M->NNT_LOCAL := Space( TAMSX3("NNT_LOCAL")[1] )
			M->NNT_LOTECT := Space( TAMSX3("NNT_LOTECT")[1] )
		EndIf
		
	restArea(kArea)
		
Return(_bRet)
 
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
	
	cQuery := "SELECT B1_COD,B1_DESC,B8_LOCAL,B8_LOTECTL,B8_DTVALID,B8_SALDO,B8_QACLASS"+CRLF
	cQuery += "  FROM " + RetSQLName("SB1") + " SB1"+CRLF
	cQuery += "  LEFT JOIN " + RetSQLName("SB8") + " SB8 ON SB8.B8_PRODUTO=B1_COD"+CRLF
	cQuery += "   AND SB8.D_E_L_E_T_=''"+CRLF
	cQuery += "   AND SB8.R_E_C_N_O_>0"+CRLF
	cQuery += "   AND SB8.B8_SALDO>0"+CRLF
	cQuery += " WHERE SB1.B1_FILIAL=' '"+CRLF
	cQuery += "   AND SB1.B1_TIPO='MP'"+CRLF
	cQuery += "   AND SB1.R_E_C_N_O_ > 0"+CRLF
	cQuery += "   AND SB1.D_E_L_E_T_=''"+CRLF
	If Left(_cForma,1)=="2"
		cQuery += "   AND SB1.B1_DESC LIKE '%" + Alltrim(Upper(_cTexto)) + "%'"+CRLF
	ElseIf Left(_cForma,1)=="1"
		cQuery += "   AND SB1.B1_COD LIKE '%" + Alltrim(Upper(_cTexto)) + "%'"+CRLF
	EndIf
	cQuery += "   AND SB1.B1_LOCALIZ='S'"+CRLF
	cQuery += " ORDER BY SB1.B1_COD,SB8.B8_LOCAL,SB8.B8_DTVALID,SB8.B8_LOTECTL"+CRLF
	
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),_cAlias1, .F., .T.)
 
	If (_cAlias1)->(!Eof())
	
		(_cAlias1)->(DbGoTop())
 
		While (_cAlias1)->(!Eof())
		
			//aDados := xgetLote((_cAlias1)->B1_COD,(_cAlias1)->B1_LOCPAD)
			
			Aadd( aDadSCK,	{	(_cAlias1)->B1_COD,;
								(_cAlias1)->B1_DESC,;
								(_cAlias1)->B8_LOCAL,;
								(_cAlias1)->B8_LOTECTL,;
								stod((_cAlias1)->B8_DTVALID),;
								(_cAlias1)->B8_SALDO,;
								(_cAlias1)->B8_QACLASS;
			})

			(_cAlias1)->(DbSkip())
	 
		End
		
	Else
			aAdd( aDadSCK, { "",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"" } )

	EndIf
	 
	(_cAlias1)->( DbCloseArea() )
	
	oLstZZY:SetArray(aDadSCK)
	oLstZZY:Refresh()

Return( aDadSCK )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SLDXLOTE  ºAutor  ³Microsiga           º Data ³  01/07/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xgetLote(cProduto,cLocal)

	local harea		:= getArea()
	//local cProduto	:= TMP->B1_COD
	//local cLocal	:= TMP->B1_LOCPAD
	local aArrayF4	:= {}
	local lEmpPrev 	:= If(SuperGetMV("MV_QTDPREV")== "S",.T.,.F.)
	local cPict		:= PesqpictQt("B8_SALDO",14)
	
	dbSelectArea("SB8")
	dbSetOrder(1)
	nSaldo := 0
	//MsSeek(xFilial()+cProduto+cLocal)
	MsSeek(xFilial()+cProduto)

	While !EOF() .And. B8_FILIAL+B8_PRODUTO == xFilial()+cProduto

		If SB8SALDO(,,,,,lEmpPrev,,,.T.)-(SB8SALDO(.T.,,,,,lEmpPrev,,,.T.)+AvalQtdPre("SB8",1)) <= 0
			DbSkip()
			Loop
		EndIf
	
		If Rastro( cProduto, "S" )
		
			AADD(aArrayF4, { B8_NUMLOTE,B8_PRODUTO,Dtoc(B8_DATA),;
				Dtoc(B8_DTVALID),Transform(SB8SALDO(,,,,,lEmpPrev,,,.T.)-(SB8SALDO(.T.,,,,,lEmpPrev,,,.T.)+AvalQtdPre("SB8",1)),cPict),B8_LOTECTL })
		Else

			nScan := AScan( aArrayF4, { |x| x[6] == B8_LOTECTL } )

			If nScan == 0
				AADD(aArrayF4, { B8_LOTECTL,B8_PRODUTO,Dtoc(B8_DATA),;
					Dtoc(B8_DTVALID),Transform(SB8SALDO(,,,,,lEmpPrev,,,.T.)-(SB8SALDO(.T.,,,,,lEmpPrev,,,.T.)+AvalQtdPre("SB8",1)),cPict),B8_LOTECTL })
			Else
				nSaldoLt := Val( aArrayF4[ nScan, 5 ] )
				nSaldoLt += SB8SALDO(,,,,,lEmpPrev,,,.T.) - (SB8SALDO(.T.,,,,,lEmpPrev,,,.T.)+AvalQtdPre("SB8",1))
				aArrayF4[ nScan ] := { B8_LOTECTL,B8_PRODUTO,Dtoc(B8_DATA),;
						Dtoc(B8_DTVALID),Transform(nSaldoLt,cPict),B8_LOTECTL }
			EndIf
		EndIf

		nSaldo += SB8SALDO(,,,,,lEmpPrev,,,.T.)-(SB8SALDO(.T.,,,,,lEmpPrev,,,.T.)+AvalQtdPre("SB8",1))

		cLtAnt := B8_LOTECTL

		dbSkip()
	EndDo
	
	restArea(harea)

Return(aArrayF4)