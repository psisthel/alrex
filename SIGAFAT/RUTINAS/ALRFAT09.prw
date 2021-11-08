#Include "Rwmake.ch"            
#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALRFAT09  ºAutor  ³Microsiga           º Data ³  05/21/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impresion de la guia de remision en modo grafico           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ALRFAT09()

	Local _aArea := getArea()
	local _cParam := ""
	local lComPedido := .t.
	
	Private xcPerg := ""
	
	SD2->( dbsetorder(3) )		//D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_COD, D2_ITEM, R_E_C_N_O_, D_E_L_E_T_
	SD2->( MsSeek( xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA ) )
	
	if left(SD2->D2_COD,3)<>"ALR"
		xcPerg := Padr("IMPGRN",10)
		lComPedido := .f.
	else
		xcPerg := Padr("IMPRGR",10)
		lComPedido := .t.
	endif
	
	dbSelectArea("SX1")
	dbSetOrder(1)

	If dbSeek(xcPerg+"01")
		SX1->( RecLock("SX1",.F.) )
		SX1->X1_CNT01 := SF2->F2_SERIE
		SX1->( MsUnlock() )
	EndIf

	If dbSeek(xcPerg+"02")
		SX1->( RecLock("SX1",.F.) )
		SX1->X1_CNT01 := SF2->F2_DOC
		SX1->( MsUnlock() )
	EndIf

	If dbSeek(xcPerg+"03")
		SX1->( RecLock("SX1",.F.) )
		SX1->X1_CNT01 := SF2->F2_DOC
		SX1->( MsUnlock() )
	EndIf
	
	if Pergunte(xcPerg,.T.)

		//_cParam := DTOS(Mv_Par01)+";"+DTOS(Mv_Par02)+";"+Mv_Par03+";"+Mv_Par04
		_cParam := Mv_Par01+";"+Mv_Par02+";"+Mv_Par03
	
		if lComPedido
			CallCrys('IMPRGR',_cParam,coptions:="1;0;1;Guia Remision")
		else
			CallCrys('IMPGRN',_cParam,coptions:="1;0;1;Guia Remision")
		endif
		
	endif
	
	RestArea(_aArea)
	
Return