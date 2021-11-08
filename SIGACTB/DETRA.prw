#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

User Function DETRA()

Local cTipo		:= 0
Local cValor	:= 0     
Local ctasa		:= 0

IF Alltrim(SEK->EK_TIPO)=='TX'.AND.SEK->EK_MOEDA='2'
    DbSelectArea("SE2")
	SE2->(DbSetOrder(1))
	If SE2->(DbSeek(xFilial("SE2")+SEK->EK_PREFIXO+SEK->EK_NUM+"A"))	// E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA
   		cTasa:=SE2->E2_TXMOEDA 
   		cValor := Round(SEK->EK_VALOR*cTasa,0)
     EndIf
EndIf
                         
IF Alltrim(SEK->EK_TIPO)=='TX'.AND.SEK->EK_MOEDA='1' 
	
	cValor:=SEK->EK_VALOR      

EndIf

Return cValor                 

User Function GANDETRA()

Local cValor	:= 0
Local ctasa		:= 0
Local cTasaSE2	:= 0
Local cTasaSEK	:= 0

IF Alltrim(SEK->EK_TIPO)=='TX'.AND.SEK->EK_MOEDA='2'
    DbSelectArea("SE2")
	SE2->(DbSetOrder(1))
	If SE2->(DbSeek(xFilial("SE2")+SEK->EK_PREFIXO+SEK->EK_NUM+"A"))	
   		cTasaSE2:=SE2->E2_TXMOEDA  
   	EndIf  
    dbSelectArea("CTP")
	CTP->( dbSetOrder(1) )
	If CTP->( dbSeek( xFilial("CTP") + DTOS(SEK->EK_DTDIGIT) + "02" ) ) 
   		cTasaSEK:=CTP->CTP_TAXA
   	EndIf	
EndIf         

IF cTasaSE2>cTasaSEK       

	cValorTF:= Round(GETADVFVAL("SEK", "EK_VALOR",XFILIAL("SEK")+SEK->EK_ORDPAGO+"CP",1,"")/cTasaSEK,2)
	cValorTX:= GETADVFVAL("SEK", "EK_VALOR",XFILIAL("SEK")+SEK->EK_ORDPAGO+"TB",1,"")

	cValor:= cValorTF-cValorTX
	
EndIf

Return cValor         
                  
// Perdida Detraccion 

User Function PERDETRA()

Local cValor	:= 0
Local ctasa		:= 0
Local cTasaSE2	:= 0
Local cTasaSEK	:= 0

IF Alltrim(SEK->EK_TIPO)=='TX'.AND.SEK->EK_MOEDA='2'
    DbSelectArea("SE2")
	SE2->(DbSetOrder(1))
	If SE2->(DbSeek(xFilial("SE2")+SEK->EK_PREFIXO+SEK->EK_NUM+"A"))	
   		cTasaSE2:=SE2->E2_TXMOEDA  
   	EndIf  
    dbSelectArea("CTP")
	CTP->( dbSetOrder(1) )
	If CTP->( dbSeek( xFilial("CTP") + DTOS(SEK->EK_DTDIGIT) + "02" ) ) 
   		cTasaSEK:=CTP->CTP_TAXA
   	EndIf	
EndIf         

IF cTasaSE2<cTasaSEK       

	cValorTF:= Round(GETADVFVAL("SEK", "EK_VALOR",XFILIAL("SEK")+SEK->EK_ORDPAGO+"CP",1,"")/cTasaSEK,2)
	cValorTX:= GETADVFVAL("SEK", "EK_VALOR",XFILIAL("SEK")+SEK->EK_ORDPAGO+"TB",1,"")

	cValor:= cValorTX-cValorTF
	
EndIf

Return cValor  