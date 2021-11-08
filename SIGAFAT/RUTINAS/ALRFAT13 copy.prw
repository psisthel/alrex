#Include "Rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALRFAT13  ºAutor  ³Percy Arias,SISTHEL º Data ³  08/22/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Informar el Anticipo despues de liberado el PV             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ALRFAT13()

	Local _aArea	:= getArea()
	Local lDo		:= .t.
	Local _cPerg	:= PADR("XDOCRA",10)

	dbSelectArea("SX1")
	dbSetOrder(1)

	If dbSeek(_cPerg+"02")
		SX1->( RecLock("SX1",.F.) )
		SX1->X1_CNT01 := Space( TAMSX3("A6_COD")[1] )
		SX1->( MsUnlock() )
	EndIf

	If dbSeek(_cPerg+"03")
		SX1->( RecLock("SX1",.F.) )
		SX1->X1_CNT01 := Space( TAMSX3("A6_AGENCIA")[1] )
		SX1->( MsUnlock() )
	EndIf

	If dbSeek(_cPerg+"04")
		SX1->( RecLock("SX1",.F.) )
		SX1->X1_CNT01 := Space( TAMSX3("A6_NUMCON")[1] )
		SX1->( MsUnlock() )
	EndIf
		
	If dbSeek(_cPerg+"05")
		SX1->( RecLock("SX1",.F.) )
		SX1->X1_CNT01 := Space( 20 )
		SX1->( MsUnlock() )
	EndIf

	If dbSeek(_cPerg+"06")
		SX1->( RecLock("SX1",.F.) )
		SX1->X1_CNT01 := dtos(dDataBase)
		SX1->( MsUnlock() )
	EndIf

	If dbSeek(_cPerg+"07")
		SX1->( RecLock("SX1",.F.) )
		SX1->X1_CNT01 := transform(0,"999,999,999.99")
		SX1->( MsUnlock() )
	EndIf

	lDo := .t.
			
	While lDo
		
		if Pergunte(_cPerg,.t.)
	
			if !empty(MV_PAR02)
		
				ZZW->( dbSetOrder(1) )
				If ZZW->( dbSeek( xFilial("ZZW")+SC5->C5_NUM ) )
					ZZW->( RecLock("ZZW",.f.) )
				Else
					ZZW->( RecLock("ZZW",.t.) )
				Endif
				ZZW->ZZW_CLIENT	:= SC5->C5_CLIENTE
				ZZW->ZZW_NOMCLI	:= SC5->C5_YNOMCLI
				ZZW->ZZW_PEDIDO	:= SC5->C5_NUM
				if MV_PAR01==1		// efectivo
					ZZW->ZZW_TIPDOC	:= "EF"
				elseif MV_PAR01==2		// cheque
					ZZW->ZZW_TIPDOC	:= "CH"
				else
					ZZW->ZZW_TIPDOC	:= "TF"
				endif
				ZZW->ZZW_BANCO	:= MV_PAR02
				ZZW->ZZW_DOC	:= MV_PAR05
				ZZW->ZZW_DATA	:= MV_PAR06
				ZZW->ZZW_VALOR	:= MV_PAR07
				ZZW->ZZW_STATUS	:= "0"
				ZZW->( MsUnlock() )
				
				lDo := .f.
				
			else
			
				If MsgBox("¡No fueron completados los datos del Anticipo!"+CRLF+"¿Desea Continuar?", "ALREX", "YESNO")
					lDo := .f.
				else
					lDo := .t.
				endif
			endif
		
		else
		
			lDo := .f.
			
		endif
			
	end
		
Return