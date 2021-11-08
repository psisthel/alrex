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
	local aVetor		:= {}
	local lHasButton	:= .T.
	local lDo			:= .t.
	local nCont			:= 1
	
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

		DEFINE MSDIALOG oDlg TITLE "Apuntar Orden de Produccion" FROM 0,0 TO 300,650 PIXEL		// vertical / horizontal
			
		@ 010,010 SAY "Direccion:" SIZE 080,015 OF oDlg PIXEL
		
		if nCont==1
			@ 020,010 MSGET oGet1 VAR _cDireccion SIZE 120,015 OF oDlg PIXEL PICTURE "@!"
		else
			@ 020,010 MSGET oGet1 VAR _cDireccion SIZE 090,015 OF oDlg PIXEL PICTURE "@!" WHEN .F.
			oTButton1 := TButton():New( 020,100, "Cambia Direc.",oDlg,{|| nCont:=1,nOpc:=3,oDlg:End()}, 35,17,,,.F.,.T.,.F.,,.F.,,,.F. )
		endif
			
		@ 045,010 SAY "Pase el lector de cod.de barras o digite la O.P." SIZE 080,015 OF oDlg PIXEL
		@ 060,010 MSGET oGet2 VAR _CodBarras SIZE 120,015 OF oDlg PIXEL PICTURE "@9" WHEN .T. F3 "SC2" VALID fgetOp(_CodBarras)
	
		@ 080,010 SAY "Cantidad" SIZE 080,015 OF oDlg PIXEL
		@ 090,010 MSGET oGet3 VAR _nCantidad SIZE 120,015 OF oDlg PIXEL PICTURE "@E 999,999.99" WHEN .F.
		
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
		
		oTButton1 := TButton():New( 120,010, "Confirmar",oDlg,{||msgRun("Generando apunte de producción...", "Procesando...",{|| nOpc := runApunte() }),nCont++,oGet2:Setfocus(),oDlg:End()}, 35,15,,,.F.,.T.,.F.,,.F.,,,.F. )
		@ 120,050 BUTTON "Anular" SIZE 035,015 PIXEL OF oDlg ACTION (nOpc := 0,oDlg:End())
		@ 120,190 BUTTON "Ver Apuntes" SIZE 120,015 PIXEL OF oDlg ACTION ( u_VERAPUNTE() )

		if nCont==1
			oGet1:Setfocus()
		else
			oGet2:Setfocus()
		endif
									 
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
	local cQry      := ""
	local _cAlias   := getNextAlias()
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
	
	if !empty(_pCodBarras)

		SC2->( dbSetOrder(1) )		// C2_FILIAL, C2_NUM, C2_ITEM, C2_SEQUEN, C2_ITEMGRD
		if SC2->( dbSeek( xFilial("SC2")+_pCodBarras ) )

	
		ZZV->( dbSetOrder(5) )		// ZZV_FILIAL, ZZV_CODBAR
		if ZZV->( !dbSeek( xFilial("ZZV")+cBarraOri ) )
            ZZV->(RecLock('ZZV',.t.))
            ZZV->ZZV_FILIAL     := xFilial("ZZV")
            ZZV->ZZV_PEDIDO     := 
            ZZV->ZZV_ITEMPV 
            ZZV->ZZV_OP 
            ZZV->ZZV_FASE 
            ZZV->ZZV_PROD 
            ZZV->ZZV_LOCAL 
            ZZV->ZZV_EMIS 
            ZZV->ZZV_QUANT 
            ZZV->ZZV_USUINC 
            ZZV->ZZV_DATINC 
            ZZV->ZZV_HORINC 
            ZZV->D_E_L_E_T_ 
            ZZV->R_E_C_N_O_ 
            ZZV->R_E_C_D_E_L_ 
            ZZV->ZZV_CODBAR 
            ZZV->ZZV_DIRECC 

			_lret := .t.
        else
            _lret := .f.
			msgbox("¡ Codigo de Barras YA fue leido, tente otra etiqueta !","ALREX","STOP")
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

