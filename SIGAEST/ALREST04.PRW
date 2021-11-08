#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#Include "Topconn.ch"
#define CRLF chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALREST01  ºAutor  ³Percy Arias,SISTHEL º Data ³  02/02/21   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Apunta orden de produccion de forma manual atraves de la   º±±
±±º          ³ lectura del codigo de barras                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ALREST04

	local _aArea		:= getArea()
	local nOpc			:= 0
	local oDlg
	local aVetor		:= {}
	local lHasButton	:= .T.
	local lDo			:= .t.
	local nCont			:= 1
	
	private _CodBarras	:= Criavar("D3_YCODBAR")
	private _nCantidad	:= Criavar("C2_QUANT")
	private _cCodeProd	:= Criavar("C2_PRODUTO")
	private _cCodeDepo	:= Criavar("C2_LOCAL")
	private _cCodePedi	:= Criavar("C2_PEDIDO")
	private _lEmbalado	:= .f.
	private _dFEntrega	:= Criavar("C5_SUGENT")
	private oTButton1
	private _cDireccion := Criavar("D3_YOBS")
	private _cNewCodBar	:= Criavar("D3_YCODBAR")
	private oGet1
	private oGet2
	private oGet3
	
	do while lDo

		_CodBarras	:= Criavar("D3_YCODBAR")
		_nCantidad	:= Criavar("C2_QUANT")
		_cCodeProd	:= Criavar("C2_PRODUTO")
		_cCodeDepo	:= Criavar("C2_LOCAL")
		_cCodePedi	:= Criavar("C2_PEDIDO")
		_dFEntrega	:= Criavar("C5_SUGENT")
		//_cDireccion := Criavar("D3_YOBS")
		_cNewCodBar	:= Criavar("D3_YCODBAR")
		_lEmbalado	:= .f.
		lMsErroAuto := .f.

		DEFINE MSDIALOG oDlg TITLE "Apuntar Produccion" FROM 0,0 TO 250,650 PIXEL		// vertical / horizontal
			
		@ 010,010 SAY "Pase el lector de cod.de barras o digite la O.P." SIZE 080,015 OF oDlg PIXEL
		@ 025,010 MSGET oGet2 VAR _CodBarras SIZE 120,015 OF oDlg PIXEL PICTURE "@9" WHEN .T. F3 "SC2" VALID fgetOp(_CodBarras)
	
		@ 045,010 SAY "Cantidad" SIZE 080,015 OF oDlg PIXEL
		@ 055,010 MSGET oGet3 VAR _nCantidad SIZE 120,015 OF oDlg PIXEL PICTURE "@E 999,999.99" WHEN .F.
		
		@ 010,150 SAY "Producto:" SIZE 080,015 OF oDlg PIXEL
		@ 010,190 MSGET _cCodeProd SIZE 120,015 OF oDlg PIXEL PICTURE "@!" WHEN .F.
		
		@ 030,150 SAY "Deposito:" SIZE 080,015 OF oDlg PIXEL
		@ 030,190 MSGET _cCodeDepo SIZE 120,015 OF oDlg PIXEL PICTURE "@!" WHEN .F.
	
		@ 050,150 SAY "Nro.Pedido:" SIZE 080,015 OF oDlg PIXEL
		@ 050,190 MSGET _cCodePedi SIZE 120,015 OF oDlg PIXEL PICTURE "@!" WHEN .F.

		@ 070,150 SAY "Embalado ?" SIZE 080,015 OF oDlg PIXEL
		@ 070,190 MSGET if(_lEmbalado,"Si","No") SIZE 120,015 OF oDlg PIXEL PICTURE "@!" WHEN .F.
		
		@ 090,150 SAY "Entrega:" SIZE 080,015 OF oDlg PIXEL
		@ 090,190 MSGET _dFEntrega SIZE 120,015 OF oDlg PIXEL PICTURE "@!" WHEN .F.
		
		oTButton1 := TButton():New( 090,010, "Confirmar",oDlg,{||msgRun("Generando apunte de producción...", "Procesando...",{|| nOpc := runApunte() }),oGet2:Setfocus(),oDlg:End()}, 35,15,,,.F.,.T.,.F.,,.F.,,,.F. )
		@ 090,050 BUTTON "Anular" SIZE 035,015 PIXEL OF oDlg ACTION (nOpc := 0,oDlg:End())
		//@ 120,190 BUTTON "Ver Apuntes" SIZE 120,015 PIXEL OF oDlg ACTION ( u_VERAPUNTE() )

		oGet2:Setfocus()

		Activate MSDialog oDlg Centered
		
		if nOpc==1
			//msgbox("¡ Apunte realizado con suceso !","ALREX","INFO")
			lDo := .t.
		elseif nOpc==2
			//msgbox("¡ Valores informados de forma incorrecta !","ALREX","STOP")
			lDo := .t.
		elseif nOpc==3
			lDo := .t.
		else
			lDo := .f.
		endif
		
	enddo
	
	RestArea(_aArea)
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALREST01  ºAutor  ³Microsiga           º Data ³  04/04/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fgetOp(_pCodBarras)

	local _lret := .t.
	local _acodBar := {}
	local cQry := ""
	local _cAlias := getNextAlias()
	
	_pCodBarras := replace(_pCodBarras,"'","-")
	_acodBar := StrTokArr( _pCodBarras, "-" )
	
	_cNewCodBar := _pCodBarras
	
	for nX := 1 to len(_acodBar)
		if nX==1
			_pCodBarras := _acodBar[nX]
		elseif nX==2
			_pCodBarras += "01"		//strzero(val(_acodBar[nX]),2)
		elseif nX==3
			_pCodBarras += "001"	//strzero(val(_acodBar[nX]),3)
		endif
	next nX

	if !empty(_pCodBarras)
	
		SC2->( dbSetOrder(1) )		// C2_FILIAL, C2_NUM, C2_ITEM, C2_SEQUEN, C2_ITEMGRD
		if SC2->( dbSeek( xFilial("SC2")+_pCodBarras ) )
			_nCantidad	:= ( SC2->C2_QUANT - SC2->C2_QUJE )
			_cCodeProd	:= SC2->C2_PRODUTO
			_cCodeDepo	:= SC2->C2_LOCAL
			_cCodePedi	:= SC2->C2_PEDIDO
			_CodBarras	:= _pCodBarras
			_lret := .t.
		endif
	
		/*
		if !empty(_cNewCodBar)
		
			cQry := "SELECT COUNT(*) NCONT"
			cQry += "  FROM "+RetSqlName("SD3")
			cQry += " WHERE D3_FILIAL='"+xFilial("SD3")+"'"
			cQry += "   AND D3_OP='"+_pCodBarras+"'"
			cQry += "   AND D3_YCODBAR='"+_cNewCodBar+"'"
			cQry += "   AND D3_ESTORNO<>'S'"
			cQry += "   AND D_E_L_E_T_=''"
			cQry += "   AND R_E_C_N_O_>0"
		
			cQry := ChangeQuery(cQry)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),_cAlias,.T.,.T.)
			//if (_cAlias)->NCONT>0
			if (_cAlias)->NCONT>=_nCantidad
				msgbox("¡ Codigo de Barras YA fue leido, tente otra etiqueta !","ALREX","STOP")
				Return(.f.)
			endif
			(_cAlias)->( dbCloseArea() )
		
		endif
		*/
	
		if _nCantidad <= 0
			msgbox("¡ Codigo de Barras YA fue leido, tente otra etiqueta !","ALREX","STOP")
			_lret := .f.
		endif
	
		if _lret
	
			SC5->( dbSetOrder(1) )
			if SC5->( dbSeek( xFilial("SC5")+_cCodePedi ) )
				_dFEntrega := SC5->C5_SUGENT
				if SC5->C5_EMBALAD=="2"
					_lEmbalado := .f.
				else
					_lEmbalado := .t.
				endif
			endif
			
			if _nCantidad> 0
				_nCantidad := 1
			endif
			
			if !empty(_CodBarras) .And. _nCantidad > 0
				oTButton1:Click()
			endif
		
		endif
	
	endif
	
Return(_lret)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALREST01  ºAutor  ³Microsiga           º Data ³  04/05/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function runApunte()
    
	local _nop := 0
	local _cPartotal := SC5->C5_YSTATUS
	local xAlias := GetNextAlias()
	local _xPartotal := "T"
	
	if !empty(_CodBarras) .And. _nCantidad > 0 .And. ( _nCantidad <= ( SC2->C2_QUANT - SC2->C2_QUJE ) )
		
		if _nCantidad<( SC2->C2_QUANT - SC2->C2_QUJE )
			_xPartotal := "P"
		endif
		
		_cDireccion := alltrim(replace(_cDireccion,"'","-"))
				
		aVetor := 	{;                
					{"D3_OP"		,_CodBarras  		,NIL},;
					{"D3_COD"		,SC2->C2_PRODUTO	,NIL},;
					{"D3_UM"		,SC2->C2_UM			,NIL},;
					{"D3_LOCAL"		,SC2->C2_LOCAL		,NIL},;
					{"D3_LOCALIZ"	,_cDireccion		,NIL},;
					{"D3_QUANT"		,_nCantidad			,NIL},;
					{"D3_EMISSAO"	,dDataBase			,NIL},;
					{"D3_PARCTOT"	,_xPartotal			,NIL},;
					{"D3_YOBS"		,_cDireccion		,NIL},;
					{"D3_YCODBAR"	,_cNewCodBar		,NIL},;
					{"D3_YHORA"		,time()				,NIL},;
					{"D3_TM"		,"001"				,NIL}}                                                     	
			
		MSExecAuto({|x, y| mata250(x, y)}, aVetor, 3 )
	
		If lMsErroAuto    
			Mostraerro()
		else
			_nop := 1
		Endif
	else
		_nop := 2
	endif
	
	if _nOp==1

		cQry := "SELECT COUNT(*) NCONT1"
		cQry += "  FROM "+ RetSqlName("SC2")
		cQry += " WHERE C2_FILIAL='" + xFilial("SC2") + "'"
		cQry += "   AND C2_PEDIDO='" + SC5->C5_NUM + "'"
		cQry += "   AND D_E_L_E_T_=''"
		cQry += "   AND R_E_C_N_O_>0"

		cQry := ChangeQuery(cQry)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),xAlias,.T.,.T.)
		nCtPed := (xAlias)->NCONT1
		(xAlias)->( dbCloseArea() )
	
		cQry := "SELECT COUNT(*) NCONT"
		cQry += "  FROM "+ RetSqlName("SC2")
		cQry += " WHERE C2_FILIAL='" + xFilial("SC2") + "'"
		cQry += "   AND C2_PEDIDO='" + SC5->C5_NUM + "'"
		cQry += "   AND D_E_L_E_T_=''"
		cQry += "   AND R_E_C_N_O_>0"
		cQry += "   AND C2_QUANT=C2_QUJE"

		cQry := ChangeQuery(cQry)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),xAlias,.T.,.T.)
		if (xAlias)->NCONT<nCtPed
			_cPartotal := "7"
		elseif (xAlias)->NCONT==nCtPed .and. (xAlias)->NCONT>0
			_cPartotal := "9"
		endif
		(xAlias)->( dbCloseArea() )

		SC5->( RecLock("SC5",.f.) )
		SC5->C5_YSTATUS := _cPartotal
		SC5->( MsUnlock() )
			
		if !empty(SC2->C2_DATRF)
			
			cSql := "SELECT SC9.R_E_C_N_O_ AS XRECNO"
			cSql += "  FROM " + InitSqlName("SC9") + " SC9"
			cSql += " WHERE C9_PEDIDO='" + SC2->C2_PEDIDO + "'"
			cSql += "   AND C9_BLEST<>'"+Space( TamSx3("C9_BLEST")[1] )+"'"
			cSql += "   AND SC9.D_E_L_E_T_ <> '*'"
					
			TCQuery cSql New Alias &xAlias
					
			If (xAlias)->( !Eof() )

				While (xAlias)->( !Eof() )
					SC9->( dbgoto( (xAlias)->XRECNO ) )
					/*
					SC9->( RecLock("SC9",.F.) )
					SC9->C9_BLEST := Space( TamSx3("C9_BLEST")[1] )
					SC9->( MsUnLock() )
					*/
					aSaldos := {}
					a450Grava(1,.F.,.T.,.F.,aSaldos,.T.)

					(xAlias)->( dbSkip() )
				End
			EndIf
						
			(xAlias)->( dbCloseArea() )
			
			SC2->( RecLock("SC2",.f.) )
			SC2->C2_YHRAPUN := time()
			SC2->( MsUnlock() )

		endif
		
		SC6->( dbSetOrder(1) )
		if SC6->( dbSeek( xFilial("SC6")+SC2->C2_PEDIDO+SC2->C2_ITEMPV+SC2->C2_PRODUTO ) )
			SC6->( RecLock("SC6",.f.) )
			SC6->C6_YAPUPEN := (SC2->C2_QUANT - SC2->C2_QUJE)
			SC6->( MsUnlock() )
		endif
		
	endif
	
	oGet2:Setfocus()

return( _nop )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALREST01  ºAutor  ³Microsiga           º Data ³  08/15/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// User Function VERAPUNTE()

// 	Local aArea		:= GetArea()
// 	Local _aDados	:= {}
// 	Local nList		:= 0
// 	Local oLst
	
// 	Private oDlg
// 	Private _bRet	:= .F.
	
// 	_aDados := _getMovim()
	
// 	If Len( _aDados ) > 0
	
// 		If _aDados[1][2] <> ""
	
// 			iif(nList = 0,nList := 1,nList)
			
// 			Define MsDialog oDlg Title "50 Ultimos Apuntes" FROM 0,0 TO 295,1050 PIXEL
			
// 			@ 5,5 LISTBOX oLst VAR lVarMat Fields HEADER " ","Pedido","Familia.","Emisión","Hora","Almacen","Ubicacion","Cod.Barras","Cantidad" SIZE 520,120 /*On DblClick ( ConfChoice(oLst:nAt, @_aDados, @_bRet) )*/ OF oDlg PIXEL
				
// 			oLst:SetArray(_aDados)
// 			oLst:nAt := nList
// 			oLst:bLine := { || { 	Transform( _aDados[oLst:nAt,1],"99") ,;
// 									_aDados[oLst:nAt,2],;
// 									_aDados[oLst:nAt,3],;
// 									_aDados[oLst:nAt,4],;
// 									_aDados[oLst:nAt,5],;
// 									_aDados[oLst:nAt,6],;
// 									_aDados[oLst:nAt,7],;
// 									_aDados[oLst:nAt,8],;
// 									Transform( _aDados[oLst:nAt,9],"999,999.99") }}
				 
// 			DEFINE SBUTTON FROM 130,5 TYPE 2  ACTION ( oDlg:End() ) ENABLE OF oDlg 
				 
// 			Activate MSDialog oDlg Centered
			
// 		EndIf

// 	EndIf
	
// 	RestArea( aArea )

// Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALREST01  ºAutor  ³Microsiga           º Data ³  08/15/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _getMovim()

	Local oArea		:= getArea()
	Local cQry1		:= ""
	Local cQry2		:= ""
	Local cAlias
	Local aUltComp	:= {}
	Local nX 		:= 1                                  
	Local xAlias	:= getNextAlias()
	Local cPedido	:= ""

	cQry1 := "SELECT TOP 50 D3_YCOD FAMILIA,D3_OP,D3_COD,D3_LOCAL,D3_YOBS UBICA,D3_YCODBAR,D3_QUANT,D3_EMISSAO,D3_YHORA "
	cQry1 += "  FROM " + RetSqlname("SD3")
	cQry1 += " WHERE D3_FILIAL='" + xFilial("SD3") + "'"
	cQry1 += "   AND D3_TM='001'"
	cQry1 += "   AND D_E_L_E_T_=''"
	cQry1 += " ORDER BY R_E_C_N_O_ DESC"
	 
	cAlias := CriaTrab(Nil,.F.)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQry1),cAlias, .F., .T.)
 
	If (cAlias)->( !Eof() )

		While (cAlias)->( !Eof() )
		
			cPedido := ""
		
			cQry2 := "SELECT C6_NUM "
			cQry2 += "  FROM " + RetSqlname("SC6")
			cQry2 += " WHERE C6_FILIAL='"+xFilial("SC6")+"'"
			cQry2 += "   AND C6_PRODUTO='"+(cAlias)->D3_COD+"'"
			cQry2 += "   AND D_E_L_E_T_=''
			 
			DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQry2),xAlias, .F., .T.)
			
			If (xAlias)->( !Eof() )
				cPedido := (xAlias)->C6_NUM
			EndIf
			
			(xAlias)->( dbCloseArea() )
		
			Aadd( aUltComp, {	nX,;
								cPedido,;
								substr((cAlias)->FAMILIA,1,10),;
								stod((cAlias)->D3_EMISSAO),;
								(cAlias)->D3_YHORA,;
								(cAlias)->D3_LOCAL,;
								substr((cAlias)->UBICA,1,10),;
								(cAlias)->D3_YCODBAR,;
								(cAlias)->D3_QUANT } )
			(cAlias)->( dbSkip() )
			nX++
		End
	Else
		Aadd( aUltComp, { 0, "", "", "", "", "", "", 0 } )
	Endif
	
	(cAlias)->( dbCloseArea() )
	
	RestArea( oArea )

Return( aUltComp )
