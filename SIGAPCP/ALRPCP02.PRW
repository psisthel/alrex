#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#Include "Topconn.ch"
#define CRLF chr(13)+chr(10)

/* 
 Fonte: ALRPCP02.PRW
 Descripcion: Apunte de Produccion por Fases, estas fases iran provenir del maestro de familias
 Fecha: 04/11/2021
 Author: SISTHEL SAC
 */

User Function ALRPCP02

	local _aArea		:= getArea()
	local nOpc			:= 0
	local oDlg
	local lDo			:= .t.
	local nCont			:= 1
	local oLst
	local nList			:= 0
	
	private _CodBarras	:= Criavar("ZZV_CODBAR")
	private _nCantidad	:= Criavar("ZZV_QUANT")
	private _cCodeProd	:= Criavar("ZZV_PROD")
	private _cCodeDepo	:= Criavar("ZZV_LOCAL")
	private _cCodePedi	:= Criavar("ZZV_PEDIDO")
	private _lEmbalado	:= .f.
	private _dFEntrega	:= Criavar("C5_SUGENT")
	private oTButton1
	private _cDireccion := Criavar("ZZV_DIRECC")
	private _cNewCodBar	:= Criavar("ZZV_CODBAR")
	private oGet1
	private oGet2
	private oGet3
	private _aApuntes	:= {}
	
	_aApuntes := _getApuntes()

	do while lDo

		_CodBarras	:= Criavar("ZZV_CODBAR")
		_nCantidad	:= Criavar("ZZV_QUANT")
		_cCodeProd	:= Criavar("ZZV_PROD")
		_cCodeDepo	:= Criavar("ZZV_LOCAL")
		_cCodePedi	:= Criavar("ZZV_PEDIDO")
		_dFEntrega	:= Criavar("C5_SUGENT")
		_cNewCodBar	:= Criavar("ZZV_CODBAR")
		_lEmbalado	:= .f.
		lMsErroAuto := .f.

		iif(nList = 0,nList := 1,nList)

		DEFINE MSDIALOG oDlg TITLE "Apuntar Orden de Produccion" FROM 0,0 TO 400,650 PIXEL		// vertical / horizontal
			
		@ 010,005 SAY "Pase el lector de cod.de barras o digite la O.P." SIZE 200,015 OF oDlg PIXEL
		@ 020,005 MSGET oGet2 VAR _CodBarras SIZE 200,015 OF oDlg PIXEL PICTURE "@9" WHEN .T. F3 "SC2" VALID fgetOp(_CodBarras)
	
		oTButton1 := TButton():New( 180,010, "Confirmar",oDlg,{||msgRun("Generando apunte de producción...", "Procesando...",{|| nOpc := runApunte() }),nCont++,oGet2:Setfocus(),oDlg:End()}, 35,15,,,.F.,.T.,.F.,,.F.,,,.F. )
		@ 180,050 BUTTON "Anular" SIZE 035,015 PIXEL OF oDlg ACTION (nOpc := 0,oDlg:End())
		@ 180,190 BUTTON "Ver Apuntes" SIZE 120,015 PIXEL OF oDlg ACTION ( u_VERAPUNTE() )

		oGet2:Setfocus()

		@ 040,005 LISTBOX oLst VAR lVarMat1 Fields HEADER "O.P.","Producto","Almacen","Cant.Informada","Cont.Auntada" SIZE 330,180 /*On DblClick ( ConfChoice(oLst:nAt, @_aDados, @_bRet) )*/ OF oDlg PIXEL

		oLst:SetArray(_aApuntes)
		oLst:nAt := nList
		oLst:bLine := { || { 	_aApuntes[oLst:nAt,1],;
								_aApuntes[oLst:nAt,2],;
								_aApuntes[oLst:nAt,3],;
								Transform( _aApuntes[oLst:nAt,4],"999.99"),;
								Transform( _aApuntes[oLst:nAt,5],"999.99") }}

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

	local _lret     := .t.
	local _acodBar  := {}
    local nX        := 1
    local cBarraOri := _pCodBarras
	
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

	_pCodBarras := "08260401001"
	cBarraOri := _pCodBarras
	
	if !empty(_pCodBarras)

		SC2->( dbSetOrder(1) )		// C2_FILIAL, C2_NUM, C2_ITEM, C2_SEQUEN, C2_ITEMGRD
		SC2->( dbSeek( xFilial("SC2")+_pCodBarras ) )

		ZZV->( dbSetOrder(5) )		// ZZV_FILIAL, ZZV_CODBAR
		if ZZV->( !dbSeek( xFilial("ZZV")+cBarraOri ) )
            ZZV->(RecLock('ZZV',.t.))
            ZZV->ZZV_FILIAL     := xFilial("ZZV")
            ZZV->ZZV_PEDIDO     := SC2->C2_PEDIDO
            ZZV->ZZV_ITEMPV 	:= SC2->C2_ITEMPV
            ZZV->ZZV_OP 		:= SC2->C2_NUM
            ZZV->ZZV_FASE 		:= 1
            ZZV->ZZV_PROD 		:= SC2->C2_PRODUTO
            ZZV->ZZV_LOCAL 		:= SC2->C2_LOCAL
            ZZV->ZZV_EMIS 		:= dDataBase
            ZZV->ZZV_QUANT 		:= SC2->C2_QUANT
            ZZV->ZZV_SEQ 		:= 1
            ZZV->ZZV_USUINC 	:= Upper(cUserName)
            ZZV->ZZV_DATINC 	:= dDataBase
            ZZV->ZZV_HORINC 	:= time()
            ZZV->ZZV_CODBAR 	:= cBarraOri
            ZZV->ZZV_DIRECC 	:= ""
			ZZV->(MsUnlock())

			_lret := .t.
        else
            _lret := .f.
			msgbox("¡ Codigo de Barras YA fue leido, tente otra etiqueta !","ALREX","STOP")
		endif
	
		if _lret
	
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
	local _xPartotal := "T"
	
	if !empty(_CodBarras) .And. _nCantidad > 0 .And. ( _nCantidad <= ( SC2->C2_QUANT - SC2->C2_QUJE ) )
		
		if _nCantidad<( SC2->C2_QUANT - SC2->C2_QUJE )
			_xPartotal := "P"
		endif
		
		_cDireccion := alltrim(replace(_cDireccion,"'","-"))
				
		_nop := 1
	else
		_nop := 2
	endif
	
	if _nOp==1

		_cPartotal := "7"

		SC5->( RecLock("SC5",.f.) )
		SC5->C5_YSTATUS := _cPartotal
		SC5->( MsUnlock() )
	
	endif
	
	oGet2:Setfocus()

return( _nop )


Static Function _getApuntes()

	Local oArea		:= getArea()
	Local cQry1		:= ""
	Local cAlias	:= getNextAlias()
	Local aUltComp	:= {}

	cQry1 := "SELECT TOP 20 * "
	cQry1 += "  FROM " + RetSqlname("ZZV")
	cQry1 += " WHERE ZZV_FILIAL='"+xFilial("ZZV")+"'"
	cQry1 += "   AND D_E_L_E_T_=''"
	cQry1 += " ORDER BY ZZV_OP,ZZV_SEQ"
	 
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQry1),cAlias, .F., .T.)
 
	If (cAlias)->( !Eof() )

		While (cAlias)->( !Eof() )
		
			Aadd( aUltComp, {	(cAlias)->ZZV_OP,;
								(cAlias)->ZZV_PROD,;
								(cAlias)->ZZV_LOCAL,;
								(cAlias)->ZZV_QUANT,;
								(cAlias)->ZZV_SEQ;
							 } )

			(cAlias)->( dbSkip() )

		End
	Else
		Aadd( aUltComp, { "", "", "", "", ""} )
	Endif
	
	(cAlias)->( dbCloseArea() )
	
	RestArea( oArea )

Return( aUltComp )
