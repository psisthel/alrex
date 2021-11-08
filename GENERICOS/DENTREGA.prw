#include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DENTREGA  ºAutor  ³Microsiga           º Data ³  08/06/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DENTREGA( _cNumPed )

	local _lret := .t.
	Local _cEnde1	:= ""
	Local _cEnde2	:= ""
	Local _cEnde3	:= ""
	Local _cEnde4	:= ""
	Local _cEnde5	:= ""
	Local _cPerg	:= PADR("PRNGUIA",10)
	Local cSerGR	:= alltrim(GetMv("AL_SERIGR"))		//G01
	
	if MV_PAR03==4							// recoje en oficina
        		
 		if SM0->( dbSeek( cEmpAnt + cFilAnt ) ) 
			_cEnde1	:= Alltrim(SM0->M0_ENDENT)
	       	_cEnde2	:= Alltrim(SM0->M0_COMPENT)
	       	_cEnde3	:= Alltrim(SM0->M0_BAIRENT)
	       	_cEnde4	:= Alltrim(SM0->M0_CIDENT)
	       	_cEnde5	:= Alltrim(SM0->M0_ESTENT)
		endif
		
		cSerGR := "GRI"
		
	elseif MV_PAR03==3						// Tienda Lince

		If SM0->( dbSeek( cEmpAnt + '02' ) )
			_cEnde1	:= Alltrim(SM0->M0_ENDENT)
        	_cEnde2	:= Alltrim(SM0->M0_COMPENT)
        	_cEnde3	:= Alltrim(SM0->M0_BAIRENT)
        	_cEnde4	:= Alltrim(SM0->M0_CIDENT)
        	_cEnde5	:= Alltrim(SM0->M0_ESTENT)
		EndIf
				
		SM0->( dbSeek( cEmpAnt + cFilAnt ) ) 
				
	elseif MV_PAR03==2						// Nueva direccion

		_cEnde1	:= ""
        _cEnde2	:= ""
        _cEnde3	:= ""
        _cEnde4	:= ""
        _cEnde5	:= ""

	elseif MV_PAR03==1						// direccion actual
	
		SC5->( dbSetOrder(1) )
	    If SC5->( dbSeek( xFilial("SC5")+_cNumPed ) )
	    	_cEnde1 := SC5->C5_YENDENT
	        _cEnde2 := SC5->C5_YCOMDIR
	        _cEnde3 := SC5->C5_YDISENT
	        _cEnde4 := SC5->C5_YPROENT
	        _cEnde5 := SC5->C5_YDPTENT
		Endif
	
	endif
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	
   	If SX1->( dbSeek(_cPerg+"04") )
    	SX1->( RecLock("SX1",.F.) )
       	SX1->X1_CNT01 := _cEnde1
       	SX1->( MsUnlock() )
	EndIf
        			
  	If SX1->( dbSeek(_cPerg+"05") )
   		SX1->( RecLock("SX1",.F.) )
   		SX1->X1_CNT01 := _cEnde2
       	SX1->( MsUnlock() )
	EndIf
        	
    If SX1->( dbSeek(_cPerg+"06") )
    	SX1->( RecLock("SX1",.F.) )
        SX1->X1_CNT01 := _cEnde3
        SX1->( MsUnlock() )
     EndIf
        
     If SX1->( dbSeek(_cPerg+"07") )
     	SX1->( RecLock("SX1",.F.) )
        SX1->X1_CNT01 := _cEnde4
        SX1->( MsUnlock() )
	EndIf
        
    If SX1->( dbSeek(_cPerg+"08") )
    	SX1->( RecLock("SX1",.F.) )
        SX1->X1_CNT01 := _cEnde5
        SX1->( MsUnlock() )
	EndIf

    If SX1->( dbSeek(_cPerg+"10") )
    	SX1->( RecLock("SX1",.F.) )
        SX1->X1_CNT01 := cSerGR
        SX1->( MsUnlock() )
	EndIf
        			
    Pergunte(_cPerg,.f.)
    
Return(_lret)