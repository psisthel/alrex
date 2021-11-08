User Function TXSD3TRANS()
    
Local nTxmoe02 := 0
Local cEmissao := Dtos(SD3->D3_EMISSAO)  
   
If Empty(cEmissao)
 Return nTxMoe02
Endif
dbSelectArea("CTP")
CTP->( dbSetOrder(1) )
If CTP->( dbSeek( xFilial("CTP") + cEmissao + "02" ) ) 

    nTxMoe02 := CTP->CTP_TAXA

EndIf

Return(nTxMoe02)    