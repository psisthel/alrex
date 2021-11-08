#include "protheus.ch"
#include "rwmake.ch"
#include "Topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณALRFAT02  บAutor  ณMicrosiga           บ Data ณ  05/08/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Hace salidas de la mercaderia para el cliente - despacho   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ALRFAT02()

	local clTitulo	:= "Filas de Entrega"
	local olChkLst
	local olPanel
	local olSplitter1
	local olBtn1
	local olBtn2
	local olDlg
	local olFont	:= TFont():New('Arial',,-16,.T.)
	local llRet		:= .F.

	local olItens
	local olPanelItem
	local olSplitter2
	local olDlgItem
	
	local nLsHeader := 0
	local nLsCols := 0
	
	private aSize    	:= MsAdvSize()
	private aObjects 	:= {}
	private aInfo    	:= {aSize[1],aSize[2],aSize[3],aSize[4],3,2}
	private aPosObj  	:= {}
	private apDatos		:= {}
	private apItens		:= {}
	private nTotPedido	:= 0
	
	AADD( aObjects, { 100, 0, .T., .F. } )
	AADD( aObjects, { 100, 100, .T., .T. } )
	AADD( aObjects, { 100, 10, .T., .F. } )
	
	aPosObj := MsObjSize(aInfo,aObjects)	
	
	getInfoGuias()

	if ( len( apDatos ) > 0 )
	
		iif(nLsHeader = 0,nLsHeader := 1,nLsHeader) 
		iif(nLsCols = 0,nLsCols := 1,nLsCols)
	
		//MsgRun( "Aguarde, identificando itens ..." ,, {|| u_getInfoItens( apDatos[1][1],1 ) } )
	
		olDlg := TDialog():New(aSize[7],0,((aSize[6]/100)*98),((aSize[5]/100)*99),clTitulo,,,,,,,,oMainWnd,.T.)
		
		TSay():New( aPosObj[1,1]-27,aPosObj[1,2],{|| "Filas de Entrega" },olDlg,,olFont,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,200,020)
		
		@ aPosObj[2,1]-15, aPosObj[2,2] LISTBOX olChkLst FIELDS COLSIZES 40,15,40,70,150,40,40,15 /*COLOR CLR_YELLOW,CLR_BLUE */ HEADER  "Pedido","Serie","Nro Guia","Cliente","Nombre Cliente","Emisi๓n","Entrega","Embalado","Transporte","Cond.Pago" SIZE (aPosObj[2,4]-7), (aPosObj[2,3]-10) OF olDlg PIXEL
		
		olChkLst:lUseDefaultColors:=.F.
		olChkLst:setArray( apDatos )
		olChkLst:nAt := nLsHeader
		olChkLst:bLine	:= { || { apDatos[olChkLst:nAt][1], apDatos[olChkLst:nAt][2], apDatos[olChkLst:nAt][3], apDatos[olChkLst:nAt][4], apDatos[olChkLst:nAt][5], apDatos[olChkLst:nAt][6], apDatos[olChkLst:nAt][7], apDatos[olChkLst:nAt][8], apDatos[olChkLst:nAt][9], apDatos[olChkLst:nAt][11] } }
		olChkLst:BlDblClick := { || MsgRun( "Aguarde, identificando itens ..." ,, {|| u_getInfoItens( apDatos[olChkLst:nAt][1],olChkLst:nAt ) } ), olChkLst:Refresh(), u_PRO002(apDatos[olChkLst:nAt][10],olChkLst:nAt), olChkLst:Refresh() , /*olItens:Refresh()*/ }
			
		olPanel := TPanel():New(aPosObj[1,1]-28,aPosObj[1,2]+100,'',olDlg,, .T., .T.,, ,(aPosObj[3,4]-110),012,.F.,.F. )
		
		olBtn1		 := TButton():New( 002, 002, "Actualizar", olPanel,{|| llRet := .T.,getInfoGuias(),olChkLst:Refresh()/*,olItens:Refresh(),olDlg:End()*/ }, 55,10,,,.F.,.T.,.F.,,.F.,,,.F. ) // "Ok"
		olBtn1:Align := CONTROL_ALIGN_RIGHT
			
		olSplitter1 := TSplitter():New( 01,01,olPanel,005,01 )
		olSplitter1:Align := CONTROL_ALIGN_RIGHT
				
		oBtn2		:= TButton():New( 002, 002, "Salir",olPanel,{|| llRet := .F., olDlg:End() }, 55,10,,,.F.,.T.,.F.,,.F.,,,.F. ) // "Retornar"
		oBtn2:Align	:= CONTROL_ALIGN_RIGHT

		olSplitter2	:= TSplitter():New( 01,01,olPanel,005,01 )
		olSplitter1:Align := CONTROL_ALIGN_RIGHT
				
		//oBtn3		:= TButton():New( 002, 002, "Devoluciones",olPanel,{|| llRet := fGetDevol(), olDlg:End() }, 55,10,,,.F.,.T.,.F.,,.F.,,,.F. ) // "Retornar"
		oBtn3		:= TButton():New( 002, 002, "Entregar",olPanel,{|| llRet := fEntrega(apDatos[olChkLst:nAt][10]), olDlg:End() }, 55,10,,,.F.,.T.,.F.,,.F.,,,.F. ) // "Retornar"
		oBtn3:Align	:= CONTROL_ALIGN_RIGHT
		
		//------------------------------------------------------------//

		/*
		@ aPosObj[2,3]-110, aPosObj[2,2] LISTBOX olItens FIELDS COLSIZES 30,40,40,250,50,50 HEADER  "Item","Familia","Codigo","Descripci๓n","Saldo","Entregues" SIZE (aPosObj[2,4]-7), (aPosObj[2,3]-180) OF olDlg PIXEL

		if ( len( apItens ) > 0 ) 
		
			olItens:setArray( apItens )
			olItens:nAt := nLsCols
			olItens:bLine	:= { || { apItens[olItens:nAt][1], apItens[olItens:nAt][2], apItens[olItens:nAt][3], apItens[olItens:nAt][4], apItens[olItens:nAt][5], apItens[olItens:nAt][6] } }
			
		endif
		*/

		olDlg:Activate() 		
		
	else 
		Alert("กNo existen documentos a entregar!")
	endif

Return( NIL ) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณALRFAT02  บAutor  ณMicrosiga           บ Data ณ  05/08/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PROCE001(_xRec)

	/*

	local _aArea		:= getArea()
	local nOpc			:= 0
	local oDlg
	local aVetor		:= {}
	local lHasButton	:= .T.
	local lDo			:= .t.
	local nCont			:= 1
	local olFont		:= TFont():New('Arial',,-16,.T.)

	for nX := 1 to len( apItens )

		for nY := 1 to len( apItens[nX][5] )
		
			if val(apItens[nX][5]) > 0
			
				_CodBarras	:= Criavar("D3_YCODBAR")
		
				DEFINE MSDIALOG oDlg TITLE "Despacho de Almacen" FROM 0,0 TO 140,450 PIXEL		// vertical / horizontal

				@ 008,010 SAY apItens[nX][1] + " " + apItens[nX][3] SIZE 150,015 FONT olFont OF oDlg PIXEL
				@ 008,170 SAY apItens[nX][5] SIZE 080,015 FONT olFont OF oDlg PIXEL
				@ 018,010 SAY apItens[nX][4] SIZE 150,015 FONT olFont OF oDlg PIXEL
					
				@ 030,010 SAY "Pase el lector de cod.de barras" SIZE 080,015 OF oDlg PIXEL
				@ 040,010 MSGET oGet1 VAR _CodBarras SIZE 150,015 OF oDlg PIXEL PICTURE "@9" WHEN .T.
			
				oTButton1 := TButton():New( 030,170, "Confirmar",oDlg,{||msgRun("Aguarde, validando informaciones de despacho...", "ALREX",{|| nOpc := exDespacho( _CodBarras,apItens[nX][7],nX,_xRec ) }),oGet1:Setfocus(),oDlg:End()}, 50,15,,,.F.,.T.,.F.,,.F.,,,.F. )
				oTButton2 := TButton():New( 050,170, "Salir",oDlg,{|| msgRun("Cerrando...", "ALREX",{|| nOpc := 0 }),oDlg:End()}, 50,15,,,.F.,.T.,.F.,,.F.,,,.F. )
		
				oGet1:Setfocus()
														 
				Activate MSDialog oDlg Centered
				
				if nOpc==0
					exit
				endif
			
			else
				exit	
			endif

		next nY
			
	next nX
	
	RestArea(_aArea)
	*/
		
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณALRFAT02  บAutor  ณMicrosiga           บ Data ณ  05/08/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
exDespacho( xCodBar,apItens[olItens:nAt][8],olItens:nAt,_xRec )
*/
Static Function exDespacho(_pCodBarras,nIdRec,nNx,_nxRec)

	local _lret			:= .t.
	local _acodBar		:= {}
	local _cCodePedi	:= Criavar("C2_PEDIDO")
	local _cNewCodBar	:= ""
	local nX			:= 1
	
	_pCodBarras := replace(_pCodBarras,"'","-")
	_acodBar	:= StrTokArr( _pCodBarras, "-" )
	_cNewCodBar	:= _pCodBarras
	
	for nX := 1 to len(_acodBar)
		if nX==1
			_pCodBarras := _acodBar[nX]
		elseif nX==2
			_pCodBarras += "01"		//strzero(val(_acodBar[nX]),2)
		elseif nX==3
			_pCodBarras += "001"	//strzero(val(_acodBar[nX]),3)
		endif
	next nX
	
	if !empty(_cNewCodBar)

		SC2->( dbSetOrder(1) )		// C2_FILIAL, C2_NUM, C2_ITEM, C2_SEQUEN, C2_ITEMGRD
		if SC2->( dbSeek( xFilial("SC2")+_pCodBarras ) )
			
			_cCodePedi := SC2->C2_PEDIDO
			_cCodeProd := SC2->C2_PRODUTO
			
			if alltrim(apDatos[nNx][1])==alltrim(_cCodePedi)
	
				ZZX->( dbSetOrder(1) ) // ZZX_FILIAL, ZZX_CODBAR
				if ZZX->( !dbSeek( xFilial("ZZX")+_cNewCodBar ) )
				
					nNx := aScan( apItens, { |x| x[3] == _cCodeProd } )
	
					apItens[nNx][5] := transform(val(apItens[nNx][5])-1,"999.99")		// saldo de itens
					apItens[nNx][6] := transform(val(apItens[nNx][6])+1,"999.99")		// itens entregues
				
					SD2->( dbgoto( apItens[nNx][8] ) )
				
					ZZX->( RecLock("ZZX",.t.) )
					ZZX->ZZX_ITEM		:= SD2->D2_ITEM
					ZZX->ZZX_PROD		:= SD2->D2_COD
					ZZX->ZZX_SERIE		:= SD2->D2_SERIE
					ZZX->ZZX_DOC		:= SD2->D2_DOC
					ZZX->ZZX_CLIENT		:= SD2->D2_CLIENTE
					ZZX->ZZX_PEDIDO		:= SD2->D2_PEDIDO
					ZZX->ZZX_CODBAR		:= _cNewCodBar
					ZZX->( MsUnlock() )
					
					SD2->( RecLock( "SD2",.f. ) )
					SD2->D2_YQTDENT := val(apItens[nNx][6])
					SD2->( MsUnLock() )		
					
				else
				
					Alert("ก Codigo de Barras ya fue leido !")
				
				endif
				
				lEntregue := .t.
				
				for nX := 1 to len(apItens)
					if val(apItens[nX][5]) > 0
						lEntregue := .f.
						exit
					endif
				next 
				
				if lEntregue
					SF2->( dbgoto( _nxRec ) )
					SF2->( RecLock("SF2",.f.) )
					SF2->F2_YENTREG := "S"
					SF2->F2_YUSRENT := Upper(cUserName)
					SF2->F2_YDATENT := dDataBase
					SF2->F2_YHORENT := time()
					SF2->( MsUnlock() )
				endif
		    
			else
				
				Alert("ก Numero del Pedido leido diferente del pedido escogido !")
				
			endif
		
		else
		
			Alert("ก Codigo de barras no encontrado !")
			
		endif
		
	endif
	
Return(1)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณYEXPEDICIOบAutor  ณPercy Arias         บ Data ณ  03/12/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RPT001()

	Local _aArea	:= getArea()
	Local _cPerg	:= PADR("RPT001",10)

	If !Pergunte(_cPerg,.t.)
		Return
	EndIf
	
	RPT001A(_cPerg)
	
	RestArea(_aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณYEXPEDICIOบAutor  ณMicrosiga           บ Data ณ  03/17/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RPT001A(_cPerg)

	Local cAreaA	:= GetArea()
	Local cDesc1	:= "Este programa tiene como objetivo imprimir informe  "
	Local cDesc2    := "de acuerdo con los parametros informados por el user"
	Local cDesc3    := ""
	Local cPict     := ""
	Local titulo    := "Situacion del Despacho"
	Local nLin      := 80
	                        //          1         2         3         4         5         6         7         8         9         *         1         2         3     |            |
	                       //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678
	Local   Cabec1       := " IT  PRODUCTO                                               UM    AL   TES  CANTIDAD      UNITARIO       TOTAL"
	Local   Cabec2       := ""

	Private lAbortPrint  := .F.
	Private tamanho      := "G"
	Private nomeprog     := "RELENT" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 18
	Private aReturn      :={ "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private CONTFL       := 1
	Private m_pag        := 1
	Private wnrel        := "INFORME DE ENTREGAS" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private cString      := ""
	Private nVDes        := 0
	Private nGuarda      := 0
	Private _aFileVen
	
	Pergunte(_cPerg,.f.)
	
	wnrel := SetPrint(cString,NomeProg,_cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho,,.f.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
		Return
	Endif
	                                                               
	nTipo := If(aReturn[4]==1,15,18)
	
	RptStatus({|| ImpInforme(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	
	RestArea(cAreaA)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณYEXPEDICIOบAutor  ณMicrosiga           บ Data ณ  03/17/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpInforme( Cabec1,Cabec2,Titulo,nLin )

	Local nQuant     	:= 1
	Local cProduto   	:= Space( TamSx3("C2_PRODUTO")[1] )
	Local cArqTMP    	:= CriaTrab(NIL,.F.)
	Local cIndTMP    	:= CriaTrab(NIL,.F.)
	Local nPag			:= 1
	Local nTotFact		:= 0
	Local nTotQtde		:= 0

	cQuery := "SELECT F2_FILIAL,F2_SERIE,F2_DOC,F2_EMISSAO,F2_CLIENTE,D2_ITEM,D2_COD,D2_YDESCRI,D2_UM,D2_LOCAL,D2_TES,D2_QUANT,D2_PRCVEN,D2_TOTAL" 
	cQuery += "  FROM " + RetSqlName("SF2")+" SF2, " + RetSqlName("SD2")+" SD2"
	cQuery += " WHERE F2_EMISSAO BETWEEN '" + Dtos(mv_par02) + "' AND '" + Dtos(mv_par03) + "'" 
	cQuery += "   AND SF2.D_E_L_E_T_=''" 
	cQuery += "   AND SD2.D_E_L_E_T_=''" 
	cQuery += "   AND F2_FILIAL='"+xFilial("SF2")+"'"
	cQuery += "   AND D2_FILIAL='"+xFilial("SD2")+"'"
	cQuery += "   AND D2_DOC BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "'"
	cQuery += "   AND D2_DOC=F2_DOC"
	cQuery += "   AND F2_ESPECIE='NF'"
	cQuery += "   AND D2_SERIE=F2_SERIE"

	If !Empty( mv_par04 )
		cQuery += " AND D2_SERIE='" + mv_par04 + "'"
	EndIf
	
	If !Empty( mv_par01 )
		cQuery += " AND D2_LOCAL='" + mv_par01 + "'"
	EndIf

	If mv_par07==1
		cQuery += " AND F2_YENTREG='S'"
	EndIf
	
	cQuery += " ORDER BY D2_FILIAL,D2_SERIE,D2_DOC,D2_ITEM"
	 
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArqTMP,.T.,.T.)
	
	dbSelectArea(cArqTMP)
	SetRegua((cArqTMP)->(LastRec()))

	If (cArqTMP)->( !Eof() )
	
		cDocSF2  := ""
	
		While (cArqTMP)->( !Eof() )
		
			IncRegua()
				
			IF lEnd
				@PROW()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")
				Exit
			Endif
			
			If nLin > 65
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			
			If cDocSF2 <> (cArqTMP)->F2_SERIE+(cArqTMP)->F2_DOC
				
				@ nLin,001 PSAY "Fecha Emision: " + Dtoc( Stod((cArqTMP)->F2_EMISSAO) )
				@ nLin,030 PSAY "Serie: " + (cArqTMP)->F2_SERIE
				@ nLin,060 PSAY "Factura: " + (cArqTMP)->F2_DOC 
				
				nLin++
				@ nLin,000 pSay Replicate("-",190)
				nLin++
				
				cDocSF2 := (cArqTMP)->F2_SERIE+(cArqTMP)->F2_DOC
				
			EndIf
		
			@ nLin,001 PSAY (cArqTMP)->D2_ITEM
			@ nLin,005 PSAY (cArqTMP)->D2_COD
			@ nLin,020 PSAY (cArqTMP)->D2_YDESCRI
			@ nLin,060 PSAY (cArqTMP)->D2_UM
			@ nLin,065 PSAY (cArqTMP)->D2_LOCAL
			@ nLin,070 PSAY (cArqTMP)->D2_TES
			@ nLin,075 PSAY (cArqTMP)->D2_QUANT Picture "@E 999,999,999.999"
			@ nLin,090 PSAY (cArqTMP)->D2_PRCVEN Picture "@E 999,999,999.9999"
			@ nLin,105 PSAY (cArqTMP)->D2_TOTAL Picture "@E 999,999,999.99"
		 
			nTotQtde += (cArqTMP)->D2_QUANT
			nTotFact += (cArqTMP)->D2_TOTAL
	
			(cArqTMP)->( dbSkip() )
			
			If cDocSF2 <> (cArqTMP)->F2_SERIE+(cArqTMP)->F2_DOC
			
				nLin ++
				@ nLin,078 pSay "==========="
				@ nLin,108 pSay "==========="
				nLin++
				@ nLin,075 PSAY nTotQtde Picture "@E 999,999,999.99"
				@ nLin,105 PSAY nTotFact Picture "@E 999,999,999.99"

				nLin ++
				@ nLin,000 pSay Replicate("-",190)
				nLin ++
						
				nTotQtde := 0
				nTotFact := 0
			
			EndIf
			
			nLin ++
		
		EndDo
		
	EndIf
	
	nLin ++
	@ nLin,000 pSay Replicate("-",190)
	nLin ++
		
	SET DEVICE TO SCREEN

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()

	(cArqTMP)->( DbCloseArea() )
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณALRFAT02  บAutor  ณMicrosiga           บ Data ณ  05/10/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function getInfoGuias

	local a_area := getArea()
	local cQry := ""
	local cArqTrb := getNextAlias()
	
	apDatos := {}
	
	cQry := "SELECT F2_YCOD,F2_SERIE,F2_DOC,F2_CLIENTE,F2_YNOMCLI,F2_EMISSAO,F2_TRANSP,R_E_C_N_O_ XREC "
	cQry += "  FROM " + RetSQLName("SF2")
	cQry += " WHERE F2_FILIAL='" + xFilial("SF2") + "'" 
	cQry += "   AND D_E_L_E_T_=''"
	cQry += "   AND F2_ESPECIE='RFN'"  
	cQry += "   AND F2_YENTREG<>'S'"
	cQry += "   AND SUBSTRING(F2_SERIE,1,1)='G'"
	cQry += " ORDER BY F2_YCOD DESC"
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cArqTrb,.T.,.T.)

	if (cArqTrb)->( !eof() )
	
		While (cArqTrb)->( !eof() )
		
			_cCondPag := Posicione("SC5",1,xFilial("SC5")+(cArqTrb)->F2_YCOD,"SC5->C5_CONDPAG")
		
			Aadd( apDatos, {	(cArqTrb)->F2_YCOD,;
								(cArqTrb)->F2_SERIE,;
								(cArqTrb)->F2_DOC,;
								(cArqTrb)->F2_CLIENTE,;
								(cArqTrb)->F2_YNOMCLI,;
								stod((cArqTrb)->F2_EMISSAO),;
								Posicione("SC5",1,xFilial("SC5")+(cArqTrb)->F2_YCOD,"SC5->C5_SUGENT"),;
								if(Posicione("SC5",1,xFilial("SC5")+(cArqTrb)->F2_YCOD,"SC5->C5_EMBALAD")="1","Si","No"),;
								Posicione("SA4",1,xFilial("SA4")+(cArqTrb)->F2_TRANSP,"SA4->A4_NOME"),;
								(cArqTrb)->XREC,;
								_cCondPag + " " + Posicione("SE4",1,xFilial("SE4")+_cCondPag,"SE4->E4_DESCRI") ;
								 } )
		
			(cArqTrb)->( dbSkip() )
		End
	
	endif
	
	(cArqTrb)->( dbCloseArea() )
	
	RestArea(a_area)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณALRFAT02  บAutor  ณMicrosiga           บ Data ณ  05/10/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function getInfoItens( vItem,nX )

	local b_area := getArea()
	local cQry := ""
	local cSql := ""
	local cArqTrb := getNextAlias()
	local cArqSD3 := getNextAlias()
	local cpFamilia := ""
	local cpUbica := ""
		
	apItens := {}
	nTotPedido	:= 0
	
	SC6->( dbSetOrder(1) )		// C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO, R_E_C_N_O_, D_E_L_E_T_ 
	SG1->( dbSetorder(1) )		// G1_FILIAL, G1_COD, G1_COMP, G1_TRT, R_E_C_N_O_, D_E_L_E_T_
	
	cQry := "SELECT D2_ITEM,D2_COD,D2_CLIENTE,D2_DOC,D2_SERIE,D2_YDESCRI,D2_QUANT,D2_YQTDENT,R_E_C_N_O_ NREC "
	cQry += "  FROM " + RetSQLName("SD2")
	cQry += " WHERE D2_FILIAL='" + xFilial("SD2") + "'" 
	cQry += "   AND D_E_L_E_T_=''"
	cQry += "   AND D2_ESPECIE='RFN'"  
	cQry += "   AND D2_SERIE='" + apDatos[nX][2] + "'"
	cQry += "   AND D2_DOC='" + apDatos[nX][3] + "'"
	cQry += "   AND D2_CLIENTE='" + apDatos[nX][4] + "'"
	cQry += " ORDER BY D2_ITEM"
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cArqTrb,.T.,.T.)

	if (cArqTrb)->( !eof() )
	
		While (cArqTrb)->( !eof() )
		
			cpFamilia := ""
			cpUbica := ""
			
			if SG1->( dbSeek( xFilial("SG1")+(cArqTrb)->D2_COD ) )
				if SC6->( dbSeek( xFilial("SC6")+apDatos[nX][1]+(cArqTrb)->D2_ITEM+(cArqTrb)->D2_COD ) )
					cpFamilia := SC6->C6_YCODF
				endif
			endif

			cSql := ""
			cSql := "SELECT D3_YOBS "
			cSql += "  FROM " + RetSQLName("SD3")
			cSql += " WHERE D3_FILIAL='" + xFilial("SD3") + "'" 
			cSql += "   AND D_E_L_E_T_=''"
			cSql += "   AND R_E_C_N_O_>0"  
			cSql += "   AND D3_COD='" + (cArqTrb)->D2_COD + "'"
			cSql += "   AND D3_YCOD='" + cpFamilia + "'"

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cArqSD3,.T.,.T.)
			if (cArqSD3)->( !eof() )
				cpUbica := left((cArqSD3)->D3_YOBS,10)
			endif
			(cArqSD3)->( dbCloseArea() )
		
			Aadd( apItens, {	(cArqTrb)->D2_ITEM													,;
								cpFamilia															,;
								(cArqTrb)->D2_COD													,;
								(cArqTrb)->D2_YDESCRI												,;
								transform(((cArqTrb)->D2_QUANT-(cArqTrb)->D2_YQTDENT),"999.999")	,;
								transform((cArqTrb)->D2_YQTDENT,"999.999")							,;
								cpUbica																,;
								(cArqTrb)->NREC														;
							} )
							
			nTotPedido += (cArqTrb)->D2_QUANT
		
			(cArqTrb)->( dbSkip() )

		End
	
	endif
	
	(cArqTrb)->( dbCloseArea() )
		
	RestArea(b_area)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณALRFAT02  บAutor  ณMicrosiga           บ Data ณ  08/13/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PRO002(_xRec,nX)

	local oDlg
	local oSatGet
	local oSatGet1
	local oSatGet2
	local nList := 0
	local lVarMat
	local oGet
	local xCodBar := Criavar("D3_YCODBAR")

	If Len( apItens ) > 0
	
		iif(nList = 0,nList := 1,nList)

		Define MsDialog oDlg Title "Registro de Itens" FROM 0,0 TO 450,1000 PIXEL

		oSatGet := TSAY():Create(oDlg)
		oSatGet:cName := "oSatGet"
		oSatGet:cCaption := "Documento: " + apDatos[nX][2]+" - "+apDatos[nX][3]
		oSatGet:nLeft := 10
		oSatGet:nTop := 10
		oSatGet:nWidth := 1000
		oSatGet:nHeight := 20
		oSatGet:lShowHint := .F.
		oSatGet:lReadOnly := .F.
		oSatGet:Align := 0
		oSatGet:lWordWrap := .F.
		oSatGet:lTransparent := .F.
		oSatGet:oFont :=  oFont
		oSatGet:nCLRText := CLR_RED

		oSatGet1 := TSAY():Create(oDlg)
		oSatGet1:cName := "oSatGet1"
		oSatGet1:cCaption := "Cliente: " + apDatos[nX][4]+" - "+apDatos[nX][5]
		oSatGet1:nLeft := 10
		oSatGet1:nTop := 30
		oSatGet1:nWidth := 1000
		oSatGet1:nHeight := 20
		oSatGet1:lShowHint := .F.
		oSatGet1:lReadOnly := .F.
		oSatGet1:Align := 0
		oSatGet1:lWordWrap := .F.
		oSatGet1:lTransparent := .F.
		oSatGet1:oFont :=  oFont
		oSatGet1:nCLRText := CLR_RED

		oSatGet2 := TSAY():Create(oDlg)
		oSatGet2:cName := "oSatGet2"
		oSatGet2:cCaption := "Nro Pedido: " + apDatos[nX][1]
		oSatGet2:nLeft := 860
		oSatGet2:nTop := 10
		oSatGet2:nWidth := 1000
		oSatGet2:nHeight := 20
		oSatGet2:lShowHint := .F.
		oSatGet2:lReadOnly := .F.
		oSatGet2:Align := 0
		oSatGet2:lWordWrap := .F.
		oSatGet2:lTransparent := .F.
		oSatGet2:oFont :=  oFont
		oSatGet2:nCLRText := CLR_RED
		
		oSatGet2 := TSAY():Create(oDlg)
		oSatGet2:cName := "oSatGet2"
		oSatGet2:cCaption := "Cant. Itens: " + transform(nTotPedido,"9,999.99")
		oSatGet2:nLeft := 860
		oSatGet2:nTop := 30
		oSatGet2:nWidth := 1000
		oSatGet2:nHeight := 20
		oSatGet2:lShowHint := .F.
		oSatGet2:lReadOnly := .F.
		oSatGet2:Align := 0
		oSatGet2:lWordWrap := .F.
		oSatGet2:lTransparent := .F.
		oSatGet2:oFont :=  oFont
		oSatGet2:nCLRText := CLR_RED
		
		oGet := TGET():Create(oDlg)
		oGet:cName := "oGet"
		oGet:nLeft := 10
		oGet:nTop := 50
		oGet:nWidth := 600
		oGet:nHeight := 26
		oGet:lShowHint := .F.
		oGet:lReadOnly := .F.
		oGet:Align := 0
		oGet:cVariable := "xCodBar"
		oGet:bSetGet := {|u| If(PCount()>0,xCodBar:=u,xCodBar) }
		oGet:lVisibleControl := .T.
		oGet:lPassword := .F.
		oGet:lHasButton := .F.

		oTButton1 := TButton():New( 025,450, "Confirmar",oDlg,{|| ;
				msgRun("Aguarde, validando informaciones de despacho...", "ALREX", {|| nOpc := exDespacho( xCodBar,apItens[olItens:nAt][8],olItens:nAt,_xRec ),xCodBar:=space(TamSX3("D3_YCODBAR")[1]),oGet:Setfocus(),olItens:Refresh() } ),;
				}, 50,12,,,.F.,.T.,.F.,,.F.,,,.F. )
			
		@ 40,5 LISTBOX olItens VAR lVarMat Fields HEADER "Item","Familia","Codigo","Descripci๓n","Saldo","Entregues","Ubicaci๓n";
			  	SIZE 495,150 /*On DblClick( ConfChoice(olItens:nAt, @apItens),oDlg:End() )*/ OF oDlg PIXEL

		olItens:setArray( apItens )
		olItens:nAt := nList
		olItens:bLine	:= { || { apItens[olItens:nAt][1], apItens[olItens:nAt][2], apItens[olItens:nAt][3], apItens[olItens:nAt][4], apItens[olItens:nAt][5], apItens[olItens:nAt][6], apItens[olItens:nAt][7] } }
			
		oTButton2 := TButton():New( 200, 005, "Salir",oDlg,{|| impAcce(),oDlg:End()}, 490,10,,,.F.,.T.,.F.,,.F.,,,.F. )   

		Activate MSDialog oDlg Centered
				
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณALRFAT02  บAutor  ณMicrosiga           บ Data ณ  09/22/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGetDevol

	local _lRet := .f.
	local nOpc	:= 1
	
	private _cCodeBar := Space(15)
	
	DEFINE MSDIALOG oDlg TITLE "Devolver Producto Terminado" FROM 0,0 TO 100,400 PIXEL		// vertical / horizontal
			
	@ 010,010 SAY "Codigo Barras:" SIZE 080,015 OF oDlg PIXEL
	@ 020,010 MSGET oGet1 VAR _cCodeBar SIZE 100,015 OF oDlg PIXEL PICTURE "@!"
			
	oTButton1 := TButton():New( 020,120, "Confirmar",oDlg,{||msgRun("Devolviendo Productos", "Procesando...",{|| nOpc := runDevol(_cCodeBar) }),oGet1:Setfocus()}, 35,15,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTButton2 := TButton():New( 020,160, "Salir",oDlg,{||oDlg:End()}, 35,15,,,.F.,.T.,.F.,,.F.,,,.F. ) 

	oGet1:Setfocus()

	Activate MSDialog oDlg Centered
		
	if nOpc==1
	
	endif

Return( _lRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณALRFAT02  บAutor  ณMicrosiga           บ Data ณ  09/24/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function runDevol( _pCodBarras )

	local _lret			:= .t.
	local _acodBar		:= {}
	local _cCodePedi	:= Criavar("C2_PEDIDO")
	local _cNewCodBar	:= ""
	local nX			:= 1
	local cCodeSF2		:= Criavar("F2_DOC")
	local cSeriSF2		:= Criavar("F2_SERIE")
	
	_pCodBarras := replace(_pCodBarras,"'","-")
	_acodBar	:= StrTokArr( _pCodBarras, "-" )

	_cNewCodBar	:= _pCodBarras
	
	for nX := 1 to len(_acodBar)
		if nX==1
			_pCodBarras := _acodBar[nX]
		elseif nX==2
			_pCodBarras += "01"		//strzero(val(_acodBar[nX]),2)
		elseif nX==3
			_pCodBarras += "001"	//strzero(val(_acodBar[nX]),3)
		endif
	next nX
	
	lEntregue := .f.
	
	if !empty(_cNewCodBar)

		SC2->( dbSetOrder(1) )		// C2_FILIAL, C2_NUM, C2_ITEM, C2_SEQUEN, C2_ITEMGRD
		if SC2->( dbSeek( xFilial("SC2")+_pCodBarras ) )
			
			_cCodePedi := SC2->C2_PEDIDO
			_cItemProd := SC2->C2_ITEMPV
			_cCodeProd := SC2->C2_PRODUTO
			
			ZZX->( dbSetOrder(1) ) // ZZX_FILIAL, ZZX_CODBAR
			if ZZX->( dbSeek( xFilial("ZZX")+_cNewCodBar ) )
				
				ZZX->( RecLock("ZZX",.F.) )
				ZZX->( dbDelete() )
				ZZX->( MsUnlock() )
				
				SD2->( dbSetOrder(8) )
				If SD2->( dbSeek( xFilial("SD2")+_cCodePedi+_cItemProd ) )
					SD2->( RecLock( "SD2",.f. ) )
					SD2->D2_YQTDENT := (SD2->D2_YQTDENT - 1 )
					SD2->( MsUnLock() )		
					lEntregue := .t.
					cCodeSF2 := SD2->D2_DOC
					cSeriSF2 := SD2->D2_SERIE
				endif
					
			else
				
				Alert("ก Codigo de Barras ya fue leido !")
				
			endif
				
			if SF2->( dbSeek( xFilial("SF2")+cCodeSF2+cSeriSF2 ) ) 			// F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_FORMUL, F2_TIPO, R_E_C_N_O_, D_E_L_E_T_
				
				SF2->( dbgoto( _nxRec ) )
				SF2->( RecLock("SF2",.f.) )
				SF2->F2_YENTREG := ""
				SF2->F2_YUSRENT := ""
				SF2->F2_YDATENT := ""
				SF2->F2_YHORENT := ""
				SF2->( MsUnlock() )
			endif
		    
		else
				
			Alert("ก Numero del Pedido leido diferente del pedido escogido !")
				
		endif
		
	else
		
		Alert("ก Codigo de barras no encontrado !")
			
	endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณALRFAT02  บAutor  ณMicrosiga           บ Data ณ  11/21/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function impAcce()

Return

//--------------------------------------------

Static Function fEntrega(_nxRec)

	Local cMailDe	:= GetNewPar("AL_MAILENV","ventas@alrex.com.pe")
	Local alCliente	:= {}
	Local clArqDest	:= ""

	SF2->( dbgoto( _nxRec ) )
	SF2->( RecLock("SF2",.f.) )
	SF2->F2_YENTREG := "S"
	SF2->F2_YUSRENT := Upper(cUserName)
	SF2->F2_YDATENT := dDataBase
	SF2->F2_YHORENT := time()
	SF2->( MsUnlock() )

	alCliente := u_FGETCLIE( SF2->F2_CLIENTE )
	clCc := U_GETCCSA1( alCliente[12], alCliente[13] )

	if !empty(cMailDe)

		clMensPadrao := xMsgBody()

		alRetMail := U_SBMAILDLG(AllTrim(cMailDe), AllTrim( alCliente[11] ), clCc, + "Documento nบ " + SF2->F2_SERIE+"-"+SF2->F2_DOC, clMensPadrao)
					
		if	Len( alRetMail ) > 0 .And.;
			if u_FBEMail(	AllTrim( alRetMail[2] )	,;	// Para
						AllTrim( alRetMail[4] )	,;	// Assunto
						AllTrim( alRetMail[5] )	,;	// Corpo do E-mail
						clArqDest				,;	// Anexo
						AllTrim( alRetMail[3] )	,;	// E-mail en copia
						AllTrim( cMailDe )		,;	// E-mail de envio (del usuario logado)
						AllTrim( alRetMail[6] )	;	// psw de envio
					) 
				MsgInfo("E-mail enviado con exito")
			endif
		else
			MsgInfo("E-mail NO enviado!")
		endif
	else
		Aviso("AVISO", "No fue posํble enviar el correo para el cliente, correo de envio invalido, verifique con el administrador!", {"&Ok"}, 3)
	endif

Return


Static Function xMsgBody()
	
	local cTexto	:= ""
	local xCRLF		:= (chr(13)+chr(10))
	Local cMonXML  := If(SF2->F2_MOEDA==1,"PEN","USD")
	
	cTexto := "<table border='0' width='80%'>
	cTexto += "<tr><td><h2><font color='#FF8000'>DOCUMENTO "+SF2->F2_SERIE2+"-"+alltrim(SF2->F2_DOC)+"</h2></td></tr>"
	cTexto += "<tr><td><hr width='100%'></td></tr>"
	cTexto += "<tr><td>&nbsp;</td></tr>"
	cTexto += "<tr><td>Estimados "+alltrim(SA1->A1_NOME)+"</td></tr>"
	cTexto += "<tr><td>&nbsp;</td></tr>"
 	cTexto += "<tr><td>Se adjunta en este mensaje una "+cLetFac+"</td></tr>"
	cTexto += "<tr><td><li><b>"+cLetFac+": "+(cAliasPDF)->F2_SERIE2+"-"+alltrim((cAliasPDF)->DOCUMENTO)+"</b></td></tr>"
	cTexto += "<tr><td><li><b>Fecha de emisi๓n: "+DTOC(SF2->F2_EMISSAO)+"</b></td></tr>"
	cTexto += "<tr><td><li><b>Total: "+cMonXML+" "+alltrim(transform(SF2->F2_VALMERC,"9,999,999.99"))+"</b></td></tr>"
	cTexto += "<tr><td>&nbsp;</td></tr>"
	cTexto += "<tr><td>Se adjunta en este mensaje el documento electr๓nico en formato PDF. La representaci๓n impresa en PDF tiene la misma validez que una emitida de manera tradicional. Tambi้n puedes ver el documento visitando el siguiente link.</td></tr>"
	cTexto += "<tr><td><a href='http://www.nubefact.com/10077763851'>VER "+cLetFac+"</a></td></tr>"
	cTexto += "<tr><td>&nbsp;</td></tr>"
	cTexto += "<tr><td>Si el link no funciona, usa el siguiente enlace en tu navegador:</td></tr>"
	cTexto += "<tr><td>http://www.nubefact.com/10077763851</td></tr>"
	cTexto += "<tr><td>&nbsp;</td></tr>"
	cTexto += "<tr><td>Atentamente,</td></tr>"
	cTexto += "<tr><td><b>ANDERS ZIEDEK WERNER HANS</b></td></tr>"
	cTexto += "<tr><td><b>RUC 10077763851</b></td></tr>"
	cTexto += "</table>"

Return( cTexto )
