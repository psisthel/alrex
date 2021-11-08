User Function CTBTotTpS(lTudoOk,cMoedas, cTipSal)
 
	Local aSaveArea    := GetArea()
	Local aTotMov := {}
	Local lPartDob := .T.
	Local nRecTmp := 0
	Local aMoedas := {}
	Local cMoedAux   := ''
	Local nValCt2    := 0
	Local nI         := 0  
	Local nSoma := ''
	 
	nSoma =  SuperGetMV("MV_SOMA2",.F.,"1")
	 
	If cMoedas == Nil
		aMoedas := {{'01' , .T.}}
 
 		Aadd( aTotMov , {0,0,0} )
	Else
 		cMoedAux := Alltrim( cMoedas )
 
 		FOR nI := 1 TO Len( cMoedAux )
   			aAdd( aMoedas , { StrZero(nI,2) , iif( Substr( cMoedAux ,1,1 ) == '1' , .T. , .F. ) } )
   			cMoedAux := Substr( cMoedAux ,2 )
			Aadd( aTotMov , {0,0,0} )
   		NEXT
 
	Endif
 
	dbSelectArea("TMP")
	nRecTmp := Recno()          
	DbGoTop()
	
	While ! Eof()
 		
 		If CT2_FLAG                       // Nao le lancamentos deletados
 			DbSkip()
   			Loop
     	Endif
 
 		FOR nI := 1 To Len( aMoedas )
                              
 			IF aMoedas[nI][2] == .T. // moedas que irão entrar na validação
   				If aMoedas[nI][1] == '01'
    				nValCt2 := CT2_VALOR
       			Else
        			nValCt2 := &("CT2_VALR" + aMoedas[nI][1] )
           		Endif
			Else
             	nValCt2 := 0
			Endif
 
 			IF nValCt2 <> 0
    			
    			IF CT2_TPSALD == cValToChar(cTipSal)
       				
       				If CT2_DC == '3' .OR. CT2_DC == '1'
           				aTotMov[nI][2] += nValCt2                                                       // Valor a Debito
               		Endif
                 	
                 	If CT2_DC == '3' .OR. CT2_DC == '2'
                  		aTotMov[nI][3] += nValCt2                                                        // Valor a Credito
                    Endif
               
               		If CT2_DC == '3'
                 		lPartDob := .T.
                   	Endif
 
 					If lPartDob
      					If ALLTRIM(nSoma) == '1'
           					aTotMov[nI][1]+= nValCt2
                		Elseif ALLTRIM(nSoma) == '2'
                  			aTotMov[nI][1]+= (nValCt2 * 2)
                  		EndIf
                    Else
                    	aTotMov[nI][1]+= nValCt2
                    Endif 
				EndIf
    		Endif                                                               
    	Next
 
 		dbSkip()
	EndDo
 
	dbSelectArea("TMP")
	dbGoto(nRecTmp)         
	
	RestArea(aSaveArea)
 
Return aTotMov