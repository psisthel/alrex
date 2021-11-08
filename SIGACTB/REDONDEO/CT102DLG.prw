#Include "PRTOPDEF.ch"
#Include "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "stdwin.ch"
#Include "Colors.ch"   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CT102DLG  ºAutor  ³Microsiga           ºFecha ³  06/22/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CT102DLG()

	local v_area := getArea()
	local cSequen1 := CTK->CTK_SEQUEN
	local v_valor := 0
	local a2Totais := {}
	
	DbSelectArea("CTK")
	Dbseek(xFilial("CTK")+cSequen1)
	While !CTK->(Eof()) .and. CTK->CTK_SEQUEN=cSequen1
		if CTK->CTK_LP=="999"
			v_valor := CTK->CTK_VLR01
			exit
		endif
	   CTK->(DbSkip())
	EndDo  
	
	if v_valor > 0
	
		TMP->( dbgotop() )
		While TMP->( !Eof() )
			TMP->( RecLock("TMP",.f.) )
			TMP->CT2_CONVER	:= "14"
			TMP->CT2_CRCONV	:= "1"
			if TMP->CT2_LP=="999"
				TMP->CT2_VALOR	:= v_valor
			endif
			TMP->( MsUnlock() )
			TMP->( dbSkip() )
		End
		
		TMP->( dbgotop() )
	
	endif
	
	a2Totais := U_CTBTotTpS(.T.,"12222", 1)
	
	aTotRdpe[1][2] := a2Totais[1][2]
	aTotRdpe[1][3] := a2Totais[1][3]
	
	oDeb:Refresh()
	oCred:Refresh()
	oGetDb:Refresh()
	oGetDb:oBrowse:Refresh()
	
	
	RestArea(v_area)
	
Return(.t.)