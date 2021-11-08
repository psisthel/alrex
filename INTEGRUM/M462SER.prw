#Include "Rwmake.ch"
#Include "Protheus.ch"
#include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M462SER   ºAutor  ³Juan Pablo Astorga  ºFecha ³20170426	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Altera a serie da Guia de remissao                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M462SER
    
	local aArea		:= GetArea()
	
	private _npedido		:= SC5->C5_NUM		//Criavar("C5_NUM")
	private _cmotivo		:= Criavar("C5_YMOTRAN")
	private _cfechaini		:= Criavar("C5_YINITRA")
	private _cserie			:= Criavar("F2_SERIE")
	private _cnroguia		:= Criavar("F2_DOC")
	private _ctransporte	:= Criavar("C5_TRANSP")
	private _cdir1			:= Criavar("C5_YENDENT")
	private _cdir2			:= Criavar("C5_YCOMDIR")
	private _cdir3			:= Criavar("C5_YDISENT")
	private _cdir4			:= Criavar("C5_YPROENT")
	private _cdir5			:= Criavar("C5_YDPTENT")
	private _aOpcoes		:= {}
	private _aMotivos		:= {}
	private _aTransporte	:= {}

	_cfechaini		:= dDataBase
	//_cserie			:= alltrim(GetMv("AL_SERIGR"))
	_cserie			:= "G01"
	_ctransporte	:= SC5->C5_TRANSP
	_cdir1			:= SC5->C5_YENDENT
	_cdir2			:= SC5->C5_YCOMDIR
	_cdir3			:= SC5->C5_YDISENT
	_cdir4			:= SC5->C5_YPROENT
	_cdir5			:= SC5->C5_YDPTENT
		
	if Alltrim(FUNNAME())=="MATA462AN"
	
		SX5->( dbSetOrder(1) )		// X5_FILIAL, X5_TABELA, X5_CHAVE
		if SX5->( MsSeek( xFilial("SX5")+'01'+Padr(_cserie,6) ) )
			_cnroguia := Padr(alltrim(SX5->X5_DESCSPA),TamSx3("F2_DOC")[1])
		endif
	
		Aadd(_aOpcoes,"1 - Usar Direccion Actual")
		Aadd(_aOpcoes,"2 - Nueva Direccion")
		Aadd(_aOpcoes,"3 - Tienda Lince")
		Aadd(_aOpcoes,"4 - Recoje en Oficina")
		
		SX5->( dbSetOrder(1) )
		If SX5->( dbSeek( xFilial("SX5")+"Z2") )
		    While SX5->X5_TABELA=="Z2" .And. SX5->( !Eof() )
				Aadd( _aMotivos, alltrim(SX5->X5_CHAVE) + " - " + SX5->X5_DESCSPA )
				SX5->( dbskip() )
			end
		endif

		SA4->( dbSetOrder(1) )
		SA4->( dbGotop() )
	    While SA4->( !Eof() )
			Aadd( _aTransporte, alltrim(SA4->A4_COD) + " - " + SA4->A4_NOME )
			SA4->( dbskip() )
		end
		
		if EndEntrega()

	 		SC5->( RecLock("SC5",.f.) )
	        SC5->C5_TRANSP  := left(_ctransporte,6)
	        SC5->C5_YENDENT := _cdir1
	        SC5->C5_YCOMDIR := _cdir2
	        SC5->C5_YDISENT := _cdir3
	        SC5->C5_YPROENT := _cdir4
	        SC5->C5_YDPTENT := _cdir5
	        SC5->C5_YMOTRAN := left(_cmotivo,2)
	        SC5->C5_YINITRA := _cfechaini
	        if SC5->( fieldpos("C5_MODTRAD") )
	        	if empty(SC5->C5_MODTRAD)
		        	SC5->C5_MODTRAD := left(_cmotivo,2)
		        endif
	        endif
	        SC5->( MsUnlock() )
		Endif
		        	
	Endif          
				
	RestArea(aArea)
	
Return( Alltrim( _cserie ) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M462SER   ºAutor  ³Microsiga           º Data ³  08/06/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function EndEntrega()

	local _aArea	:= getArea()
	local lDo		:= .t.
	local nOpc		:= 0
	local oDlg
	
	Private _cForma	:= ""
	
	While .t.

		Define MsDialog oDlg Title "Direccion de Entrega" FROM 0,0 TO 445,500 PIXEL	// vertical / horizontal
	
		@ 010,010 SAY "Nro Pedido" 									SIZE 080,011 OF oDlg PIXEL
		@ 010,060 MSGET _opedido 		 		VAR _npedido 		SIZE 045,011 OF oDlg PIXEL PICTURE "@!" WHEN .F.
		@ 025,010 SAY "Motivo Translado" 							SIZE 080,011 OF oDlg PIXEL
		_oCmbForma1 := TComboBox():New(025,060, {|u| If(PCount()>0,_cmotivo:=u,_cmotivo)},_aMotivos,170,20,oDlg,,,,,,.T.,,,,,,,,,) 
		@ 045,010 SAY "Inicio Translado" 							SIZE 080,011 OF oDlg PIXEL
		@ 045,060 MSGET _ofechaini 				VAR _cfechaini		SIZE 045,011 OF oDlg PIXEL PICTURE "@!"
		@ 060,010 SAY "Serie/Nro GR" 								SIZE 080,011 OF oDlg PIXEL
		@ 060,060 MSGET _oserie 				VAR _cserie 		SIZE 045,011 OF oDlg PIXEL PICTURE "@!"
		@ 060,105 MSGET _onroguia 				VAR _cnroguia 		SIZE 060,011 OF oDlg PIXEL PICTURE "@!" WHEN .F.
		@ 075,010 SAY "Transportadora" 								SIZE 080,011 OF oDlg PIXEL
		_oCmbForma2 := TComboBox():New(075,060, {|u| If(PCount()>0,_ctransporte:=u,_ctransporte)},_aTransporte,170,20,oDlg,,,,,,.T.,,,,,,,,,) 
		@ 095,010 SAY "Seleccione" 									SIZE 080,011 OF oDlg PIXEL
		_oCmbForma3 := TComboBox():New(095,060, {|u| If(PCount()>0,_cForma:=u,_cForma)},_aOpcoes,170,30,oDlg,,{|| DENTREGA()},,,,.T.,,,,,,,,,) 
		@ 115,010 SAY "Direccion Entrega" 							SIZE 080,011 OF oDlg PIXEL
		@ 115,060 MSGET _odir1					VAR _cdir1			SIZE 170,011 OF oDlg PIXEL PICTURE "@!"
		@ 130,010 SAY "Complemento" 								SIZE 080,011 OF oDlg PIXEL
		@ 130,060 MSGET _odir2		 			VAR _cdir2			SIZE 170,011 OF oDlg PIXEL PICTURE "@!"
		@ 145,010 SAY "Distrito" 									SIZE 080,011 OF oDlg PIXEL
		@ 145,060 MSGET _odir3		 			VAR _cdir3			SIZE 170,011 OF oDlg PIXEL PICTURE "@!"
		@ 160,010 SAY "Provincia" 									SIZE 080,011 OF oDlg PIXEL
		@ 160,060 MSGET _odir4		 			VAR _cdir4			SIZE 170,011 OF oDlg PIXEL PICTURE "@!"
		@ 175,010 SAY "Departamento" 								SIZE 080,011 OF oDlg PIXEL
		@ 175,060 MSGET _odir5					VAR _cdir5		SIZE 170,011 OF oDlg PIXEL PICTURE "@!"
		
		oTButton1 := TButton():New( 193,060, "Confirmar"	,oDlg,{|| nOpc := 1,lDo := fvalcpos(),oDlg:End() }, 75,15,,,.F.,.T.,.F.,,.F.,,,.F. )
		oTButton2 := TButton():New( 193,140, "Anular"		,oDlg,{|| nOpc := 0,lDo := .t.,_cserie := "NoExist",oDlg:End() }, 75,15,,,.F.,.T.,.F.,,.F.,,,.F. )

		Activate MSDialog oDlg Centered
		
		if lDo
			exit
		endif
		
	End
		
	RestArea(_aArea)

Return( lDo )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M462SER   ºAutor  ³Microsiga           º Data ³  12/07/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fvalcpos()

	local lNoOk := .t.
	
	if empty(_cmotivo)
		Alert("Escoja el motivo de transporte!")
		lNoOk := .f.
	endif

	if empty(_cserie)
		Alert("Escoja el nro de serie correcto!")
		lNoOk := .f.
	endif

	if empty(_ctransporte)
		Alert("Escoja el transporte!")
		lNoOk := .f.
	endif

	if empty(_cdir1)
		Alert("Escoja la direccion de entrega correcta!")
		lNoOk := .f.
	endif

	if empty(_cdir3)
		Alert("Escoja la direccion de entrega correcta!")
		lNoOk := .f.
	endif

	if empty(_cdir4)
		Alert("Escoja la direccion de entrega correcta!")
		lNoOk := .f.
	endif

	if empty(_cdir5)
		Alert("Escoja la direccion de entrega correcta!")
		lNoOk := .f.
	endif
	
Return( lNoOk )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M462SER   ºAutor  ³Microsiga           º Data ³  12/07/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DENTREGA()

	local _lret := .t.

	_cserie	:= alltrim(GetMv("AL_SERIGR"))		//"G01"
	
	if left(_cForma,1)=="4"							// recoje en oficina
        		
 		if SM0->( dbSeek( cEmpAnt + cFilAnt ) ) 
			_cdir1	:= Padr(Alltrim(SM0->M0_ENDENT),TamSX3("C5_YENDENT")[1])
	       	_cdir2	:= Padr(Alltrim(SM0->M0_COMPENT),TamSX3("C5_YCOMDIR")[1])
	       	_cdir3	:= Padr(Alltrim(SM0->M0_BAIRENT),TamSX3("C5_YDISENT")[1])
	       	_cdir4	:= Padr(Alltrim(SM0->M0_CIDENT),TamSX3("C5_YPROENT")[1])
	       	_cdir5	:= Padr(Alltrim(SM0->M0_ESTENT),TamSX3("C5_YDPTENT")[1])
		endif
		
		_cserie := "GRI"
		
	elseif left(_cForma,1)=="3"						// Tienda Lince

		If SM0->( dbSeek( cEmpAnt + '02' ) )
			_cdir1	:= Padr(Alltrim(SM0->M0_ENDENT),TamSX3("C5_YENDENT")[1])
        	_cdir2	:= Padr(Alltrim(SM0->M0_COMPENT),TamSX3("C5_YCOMDIR")[1])
        	_cdir3	:= Padr(Alltrim(SM0->M0_BAIRENT),TamSX3("C5_YDISENT")[1])
        	_cdir4	:= Padr(Alltrim(SM0->M0_CIDENT),TamSX3("C5_YPROENT")[1])
        	_cdir5	:= Padr(Alltrim(SM0->M0_ESTENT),TamSX3("C5_YDPTENT")[1])
		EndIf
				
		SM0->( dbSeek( cEmpAnt + cFilAnt ) ) 
				
	elseif left(_cForma,1)=="2"						// Nueva direccion

		_cdir1	:= space(TamSX3("C5_YENDENT")[1])
        _cdir2	:= space(TamSX3("C5_YCOMDIR")[1])
        _cdir3	:= space(TamSX3("C5_YDISENT")[1])
        _cdir4	:= space(TamSX3("C5_YPROENT")[1])
        _cdir5	:= space(TamSX3("C5_YDPTENT")[1])

	elseif left(_cForma,1)=="1"						// direccion actual
	
		//SC5->( dbSetOrder(1) )
	    //If SC5->( dbSeek( xFilial("SC5")+_npedido ) )
	    	_cdir1 := SC5->C5_YENDENT
	        _cdir2 := SC5->C5_YCOMDIR
	        _cdir3 := SC5->C5_YDISENT
	        _cdir4 := SC5->C5_YPROENT
	        _cdir5 := SC5->C5_YDPTENT
		//Endif
	
	endif	
	
	SX5->( dbSetOrder(1) )		// X5_FILIAL, X5_TABELA, X5_CHAVE
	if SX5->( MsSeek( xFilial("SX5")+'01'+Padr(_cserie,6) ) )
		_cnroguia := Padr(alltrim(SX5->X5_DESCSPA),TamSx3("F2_DOC")[1])
	endif
    
Return(_lret)

