
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO32    ºAutor  ³Microsiga           º Data ³  02/05/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava en SE2 Y SE1 lo informado en F1_NATUREZ/F2_NATUREZ.  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LOCXPE37()                               

	Local _aArea   := GetArea()
	Local cSerie   := SF1->F1_SERIE
	Local cNumero  := SF1->F1_DOC
	Local cProveed := SF1->F1_FORNECE
	Local cLojF1   := SF1->F1_LOJA 
	Local cNatSF1  := SF1->F1_NATUREZ      
	Local cTpSF1   := SF1->F1_TPDOC    // Modificado 02.10.2017 Juan Pablo Astorga 
	
	Local cPrefi   := SF2->F2_SERIE
	Local cDocum   := SF2->F2_DOC
	Local cClien   := SF2->F2_CLIENTE
	Local cLojF2   := SF2->F2_LOJA  
	Local cNatSF2  := SF2->F2_NATUREZ
	Local cTpSF2   := SF2->F2_TPDOC    // Modificado 02.10.2017 Juan Pablo Astorga                                                                                         
	                                                                                            
	Local cChaveSE1:= ""// xFilial("SE1")+cNumero+cSerie
	Local cChaveSE2:= ""//xFilial("SE2")+cProveed+cLoja+cNumero+cSerie 
	
	If nNFTipo = 10 .OR. nNFTipo == 13 .OR. nNFTipo == 14 .OR. nNFTipo == 9 //Si es factura de compra (normal o de importacion)/ nota debito proveedor- 14 - DUA
       
		DbSelectArea("SE2")	//E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
    	cChaveSE2:= xFilial("SE2")+cProveed+cLojF1+cSerie+ cNumero
		DbSetOrder(6)                                                                                              
		if DbSeek(xFilial("SE2")+cProveed+cLojF1+cSerie+cNumero)

			While !Eof() .and. SE2->E2_FILIAL + SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_PREFIXO + SE2->E2_NUM == cChaveSE2

				RecLock("SE2",.F.)
			                  
			 	IF Alltrim(SE2->E2_TIPO)<>'TX'   			// Modificado 02.10.2017 Juan Pablo Astorga 
			  		SE2->E2_NATUREZ  := cNatSF1    			// Modificado 02.10.2017 Juan Pablo Astorga 
			  		SE2->E2_XTPDOC   := cTpSF1  			// Modificado 02.10.2017 Juan Pablo Astorga 
			 	EndIf 
			 	IF Alltrim(SF1->F1_HAWB)<>''  
			   		IF Len(Alltrim(DBB->DBB_XSER2))>=3		// Modificado 02.10.2017 Juan Pablo Astorga 
			  			SE2->E2_SERORI := DBB->DBB_XSER2		// Modificado 02.10.2017 Juan Pablo Astorga 
               		EndIF	
             	EndIf 		    
             	IF Empty(Alltrim(SF1->F1_SERIE))           // Modificado 29.12.2017 Juan Pablo Astorga
             		SE2->E2_SERORI := SF1->F1_SERIE2		// Modificado 29.12.2017 Juan Pablo Astorga
             	EndIf  
             	IF Empty(Alltrim(SF1->F1_SERIE2))			// Modificado 29.12.2017 Juan Pablo Astorga
             		SE2->E2_SERORI := SF1->F1_SERIE			// Modificado 29.12.2017 Juan Pablo Astorga
             	EndIf
                                  
				MsUnLock()

				DbSelectArea("SE2")
				DbSkip()
			End 
	
		endif    
		
		IF Alltrim(SF1->F1_HAWB)<>''
			IF Len(Alltrim(DBB->DBB_XSER2))==4		// Modificado 09.10.2017 Juan Pablo Astorga 
				SF1->( RecLock("SF1",.f.) )			// Modificado 09.10.2017 Juan Pablo Astorga 
				SF1->F1_SERIE2	:= DBB->DBB_XSER2	// Modificado 09.10.2017 Juan Pablo Astorga 
				SF1->F1_SERORI	:= DBB->DBB_XSER2	// Modificado 09.10.2017 Juan Pablo Astorga 
				SF1->( MsUnlock() )
			EndIf  
		EndIF	
			
	Elseif nNFTipo = 7 //Nota credito proveedor 
       
		DbSelectArea("SE2")     //E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
    	cChaveSE2:= xFilial("SE2")+cClien+cLojF2+cSerie+ cDocum
		DbSetOrder(6)
   		If DbSeek(xFilial("SE2")+cClien+cLojF2+cSerie+ cDocum)

			While !Eof() .and. SE2->E2_FILIAL + SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_PREFIXO + SE2->E2_NUM == cChaveSE2

				RecLock("SE2",.F.)
			  	IF Alltrim(SE2->E2_TIPO)<>'TX' // Modificado 02.10.2017 Juan Pablo Astorga 
			  		SE2->E2_NATUREZ  := cNatSF2   
			  		SE2->E2_XTPDOC   := cTpSF2	 // Modificado 02.10.2017 Juan Pablo Astorga 
        		EndIf
				MsUnLock()

				DbSelectArea("SE2")
				DbSkip()
			End
  		Endif
  		
	Elseif  nNFTipo == 2.OR. nNFTipo == 1 // Nota debito cliente/factura de venta
                                                                                 
		DbSelectArea("SE1")	//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO        
    	cChaveSE1:= xFilial("SE1")+ cClien + cLojF2 + cPrefi + cDocum
		DbSetOrder(2)
    	IF 	DbSeek(xFilial("SE1")+ cClien + cLojF2 + cPrefi + cDocum )
	
  			While !Eof() .and. SE1->E1_FILIAL + SE1->E1_CLIENTE + SE1->E1_LOJA + SE1->E1_PREFIXO + SE1->E1_NUM == cChaveSE1
				RecLock("SE1",.F.)
		    	SE1->E1_NATUREZ := cNatSF2
				MsUnLock()
				DbSelectArea("SE1")
	 			DbSkip()
			End 
   		Endif     
   
	Elseif  nNFTipo == 4 //Nota credito cliente
   
                                                                                                                                                                     
   		DbSelectArea("SE1")	//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO        
    	cChaveSE1:= xFilial("SE1")+  cProveed + cLojF1 +cSerie + cNumero
		DbSetOrder(2)
    	IF DbSeek(xFilial("SE1")+ cProveed + cLojF1 +cSerie + cNumero )
	
  			While !Eof() .and. SE1->E1_FILIAL + SE1->E1_CLIENTE + SE1->E1_LOJA + SE1->E1_PREFIXO + SE1->E1_NUM == cChaveSE1
				RecLock("SE1",.F.)
		    	SE1->E1_NATUREZ := cNatSF1
				MsUnLock()
				DbSelectArea("SE1")
	 			DbSkip()
			End 
   		Endif
   
	EndIf
	
	restArea(_aArea)

Return()