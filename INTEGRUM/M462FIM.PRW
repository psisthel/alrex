#INCLUDE "rwmake.ch"    
#Include "protheus.ch"          
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M462FIM   ºAutor  ³Percy Arias,SISTHEL ºFecha ³  20170426   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Llama la rutina de impresion de Remision al finalizar la   º±±
±±º          ³ grabacion de la remision                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION M462FIM()

	/*
		
	Local aAreaSD2	:= GetArea()
	Local cEspecie	:= Alltrim(SF2->F2_ESPECIE)   
	Local _cNroPed	:= ""
	Local _cEnde1	:= ""
	Local _cEnde2	:= ""
	Local _cEnde3	:= ""
	Local _cEnde4	:= ""
	Local _cEnde5	:= ""
	Local _cPerg	:= PADR("PRNGUIA",10)
	Local _xNomCli	:= ""
	
	If cEspecie =='RFN' .and. FUNNAME()=="MATA462AN"	// guia de remision de saida
	                           
        SC5->( dbSetOrder(1) )
        If SC5->( dbSeek( xFilial("SC5")+_cNroPed ) )
        	_cEnde1 := SC5->C5_YENDENT
        	_cEnde2 := SC5->C5_YCOMDIR
        	_cEnde3 := SC5->C5_YDISENT
        	_cEnde4 := SC5->C5_YPROENT
        	_cEnde5 := SC5->C5_YDPTENT
        Endif
        
        if !empty(_cEnde1)
        
        	SX1->( dbSetOrder(1) )
        	If SX1->( dbSeek(_cPerg+"02") )
        		SX1->( RecLock("SX1",.F.) )
        		SX1->X1_PRESEL := 1
        		SX1->( MsUnlock() )
        	EndIf
        
        	If SX1->( dbSeek(_cPerg+"03") )
        		SX1->( RecLock("SX1",.F.) )
        		SX1->X1_CNT01 := _cEnde1
        		SX1->( MsUnlock() )
        	EndIf
        	
        	If SX1->( dbSeek(_cPerg+"04") )
        		SX1->( RecLock("SX1",.F.) )
        		SX1->X1_CNT01 := _cEnde2
        		SX1->( MsUnlock() )
        	EndIf
        
        	If SX1->( dbSeek(_cPerg+"05") )
        		SX1->( RecLock("SX1",.F.) )
        		SX1->X1_CNT01 := _cEnde3
        		SX1->( MsUnlock() )
        	EndIf
        
        	If SX1->( dbSeek(_cPerg+"06") )
        		SX1->( RecLock("SX1",.F.) )
        		SX1->X1_CNT01 := _cEnde4
        		SX1->( MsUnlock() )
        	EndIf
        
        	If SX1->( dbSeek(_cPerg+"07") )
        		SX1->( RecLock("SX1",.F.) )
        		SX1->X1_CNT01 := _cEnde5
        		SX1->( MsUnlock() )
        	EndIf
        				
        	if Pergunte(_cPerg,.t.)
        	
        		if MV_PAR02==2
        		
        			_cEnde1	:= Alltrim(SM0->M0_ENDENT)
        			_cEnde2	:= Alltrim(SM0->M0_COMPENT)
        			_cEnde3	:= Alltrim(SM0->M0_BAIRENT)
        			_cEnde4	:= Alltrim(SM0->M0_CIDENT)
        			_cEnde5	:= Alltrim(SM0->M0_ESTENT)
        
        			If SX1->( dbSeek(_cPerg+"03") )
        				SX1->( RecLock("SX1",.F.) )
        				SX1->X1_CNT01 := _cEnde1
        				SX1->( MsUnlock() )
        			EndIf
        			
        			If SX1->( dbSeek(_cPerg+"04") )
        				SX1->( RecLock("SX1",.F.) )
        				SX1->X1_CNT01 := _cEnde2
        				SX1->( MsUnlock() )
        			EndIf
        	
        			If SX1->( dbSeek(_cPerg+"05") )
        				SX1->( RecLock("SX1",.F.) )
        				SX1->X1_CNT01 := _cEnde3
        				SX1->( MsUnlock() )
        			EndIf
        
        			If SX1->( dbSeek(_cPerg+"06") )
        				SX1->( RecLock("SX1",.F.) )
        				SX1->X1_CNT01 := _cEnde4
        				SX1->( MsUnlock() )
        			EndIf
        
        			If SX1->( dbSeek(_cPerg+"07") )
        				SX1->( RecLock("SX1",.F.) )
        				SX1->X1_CNT01 := _cEnde5
        				SX1->( MsUnlock() )
        			EndIf
        			
        			Pergunte(_cPerg,.f.)
        
        		endif
        	
        		SC5->( RecLock("SC5",.f.) )
        		SC5->C5_TRANSP  := MV_PAR01
        		SC5->C5_YENDENT := MV_PAR03
        		SC5->C5_YCOMDIR := MV_PAR04
        		SC5->C5_YDISENT := MV_PAR05
        		SC5->C5_YPROENT := MV_PAR06
        		SC5->C5_YDPTENT := MV_PAR07
        		SC5->( MsUnlock() )
        
        		U_ALR003(.T.)
        	
        	endif
        
        endif
        		
	Endif          
	
	RestArea( aAreaSD2 )
	*/

Return()
       