#Include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO17    บAutor  ณMicrosiga           บ Data ณ  08/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Rodrigo Pilewski Modifica forma de buscar el deposito     บฑฑ
ฑฑบ          ณ  de Origen, haciendo el posicionamiento por D3_NUMSEQ      บฑฑ
ฑฑบ          ณ  04/09/2012									              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//User Function RetDepOri(cDoc,cProd)

User Function RetDepOri(nNumSeq)

// Funcion usada en el asiento estandar 672 - 001 para obtener si es deposito de transito.

Local cRet 		:= ""
Local _aArea	:= GetArea()
Local cQuery	:= ""

cQuery := " SELECT D3_TM, D3_LOCAL, D3_NUMSEQ, D3_FILIAL "
cQuery += " FROM " + RetSQLName("SD3") + " SD3 "
cQuery += " WHERE "
cQuery +=   " D3_NUMSEQ  = '" + nNumSeq  + "' "
cQuery +=   " AND D3_TM  > '500' "
cQuery +=   " AND SD3.D_E_L_E_T_ <> '*' "

DbUseArea( .T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQuery)),'T_PRE',.F.,.T. )

T_PRE->(DbGoTop())
				  
IF T_PRE->(!Eof()) 
	cRet := T_PRE->D3_LOCAL
Endif

T_PRE->(DbCloseArea())

RestArea(_aArea)

Return(cRet)                    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO17    บAutor  ณMicrosiga           บ Data ณ  15/11/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Ignacio Ascurra                                           บฑฑ
ฑฑบ          ณ  Determina cual es el deposito de destino                  บฑฑ
ฑฑบ          ณ            									              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RetDepDes(nNumSeq)

// Funcion usada en el asiento estandar 670 - 001 para obtener si es deposito de transito el destino.

Local cRet 		:= ""
Local _aArea	:= GetArea()
Local cQuery	:= ""

cQuery := " SELECT D3_TM, D3_LOCAL, D3_NUMSEQ, D3_FILIAL "
cQuery += " FROM " + RetSQLName("SD3") + " SD3 "
cQuery += " WHERE "
cQuery +=   " D3_NUMSEQ  = '" + nNumSeq  + "' "
cQuery +=   " AND D3_TM  < '500' "
cQuery +=   " AND SD3.D_E_L_E_T_ <> '*' "

DbUseArea( .T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQuery)),'T_PRE',.F.,.T. )

T_PRE->(DbGoTop())
				  
IF T_PRE->(!Eof()) 
	cRet := T_PRE->D3_LOCAL
Endif

T_PRE->(DbCloseArea())

RestArea(_aArea)

Return(cRet)                    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO17    บAutor  ณMicrosiga           บ Data ณ  08/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Rodrigo Pilewski                                          บฑฑ
ฑฑบ          ณ  Determina si el deposito es de transito                   บฑฑ
ฑฑบ          ณ									                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RetDepTra(cDeposito)
// Funcion usada en asientos de costos para que devuelve Verdadero si el deposito es de transito, caso contrario devuelve Falso
Local lRet := .F.

ZZ1->(DbSetOrder(1))
IF ZZ1->(DbSeek(xFilial("ZZ1")+cDeposito))
	If ZZ1->ZZ1_XTRANS == "1"
		lRet := .T.
	EndIf
EndIf

Return lRet                       


User Function F670002V
// 670 002 Usado en asiento 670 002 campo Valor
Return ( IF(U_RetDepTra(SD3->D3_LOCAL).AND.!U_RetDepTra(U_RetDepDes(SD3->D3_NUMSEQ)).AND.Round(U_CustDBA(SD3->D3_COD,SD3->D3_LOCAL,SD3->D3_LOCALIZ)*SD3->D3_QUANT,2)<>0,Round((SD3->D3_QUANT*SB1->B1_CUSTD),2)-Round(U_CustDBA(SD3->D3_COD,SD3->D3_LOCAL,SD3->D3_LOCALIZ)*SD3->D3_QUANT,2),0) )
                      
User Function F670003V                         
// 670 003 Usado en asiento 670 002 campo Valor
Return ( IF(U_RetDepTra(SD3->D3_LOCAL).AND.!U_RetDepTra(U_RetDepDes(SD3->D3_NUMSEQ)).AND.Round(U_CustDBA(SD3->D3_COD,SD3->D3_LOCAL,SD3->D3_LOCALIZ)*SD3->D3_QUANT,2)<>0,Round(U_CustDBA(SD3->D3_COD,SD3->D3_LOCAL,SD3->D3_LOCALIZ)*SD3->D3_QUANT,2)-Round((SD3->D3_QUANT*SB1->B1_CUSTD),2),0) )
