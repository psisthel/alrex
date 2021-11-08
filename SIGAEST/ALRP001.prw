#include 'protheus.ch'    
#include 'rwmake.ch'
#INCLUDE "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณALRP001   บAutor  ณPercy Arias,SISTHEL บ Data ณ  10/22/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impresion de ticket referente a las transferencias reali-  บฑฑ
ฑฑบ          ณ zadas en almacen.                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ALRP001(pFilial, pNroDoc, pTipoMov)

	Local cAreaA		:= Alias()
	Local cTamanho		:= 'M'
	Local cPerg			:= "FAC010"
	
	aDriver			:= ReadDriver()
	cString			:= "SF2"
	cTitulo			:= PadC("Emisi๓n de las Facturas" ,74)
	cDesc1 			:= PadC("Serแ solicitado el intervalo para la emisi๓n de las",74)
	cDesc2 			:= PadC("Facturas",74)
	cDesc3 			:= ""                                                     
	wnrel			:= "FAC"     
	wFilial			:= pFilial
	wNroDoc			:= pNroDoc
	wTipoMov		:= pTipoMov
	
	Private aReturn	:= {"Zebrado", 1,"Administracao", 2, 2, 1, "",1}
	
	wnrel	 := SetPrint(cString,wnrel,cPerg,cTitulo,cDesc1,cDesc2,cDesc3,.F.,,,"M",,.T.)

	If nLastKey!=27
	
		SetDefault(aReturn, cString)
		
		If nLastKey!=27
			VerImp()       
			RptStatus({|lEnd| RptNota()})
		EndIf

	EndIf   
	
	dbSelectArea(cAreaA)

return              

/*                                                                           
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO3     บAutor  ณMicrosiga           บFecha ณ  11/21/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
                         
Static Function RptNota()

//	Local nLin, nTotImp, nTotItem, cLin, nIndSD3, nIndSD2 
	Local aArea    		:= GetArea()
//	Local nTotal		:= 0
//	Local nTotIGV		:= 0
//	Local nTotPer		:= 0
//	Local nPercPer		:= 0
	Local cDescProd		:= Space(TamSx3("B1_DESC")[1])
	Local cDesTran 		:= ""
	Local cAlmOri 		:= ""
	Local cDesAlmOri 	:= ""
	Local cAlmDes 		:= ""
	Local cDesAlmDes 	:= ""
//	Local aObs1 		:= {}
//	Local cYObs1 		:= "" 
//	Local cMes      	:= ""
//	Local wcx			:= ""
                   
	Private ccont  
	DbSelectArea("SB1")
	DbSetOrder(1)
	
	DbSelectArea("NNR")
	DbSetOrder(1)

/*
  	If Empty(cNroDoc)
		SD3->(DbGoTop())
	EndIf
	
	DbSeek(xFilial("SD3") + cNroDoc)
	
	cNroDoc := SD3->D3_DOC
	
	DbSeek(xFilial("NNR") + SD3->D3_LOCAL) 
*/	
	
	@ 00,000 PSAY Chr(15)
	SetPrc(00,00)
            
	cQry := "SELECT D3_LOCAL,NNR_DESCRI,D3_DOC,D3_EMISSAO,D3_COD,D3_UM,D3_QUANT,D3_LOCALIZ,D3_NUMSERI,"
  	cQry += "D3_USUARIO, D3_TM, D3_CF "
	cQry += "FROM " + RetSqlName("SD3")+ " "
	cQry += "INNER JOIN " + RetSqlName("NNR")+ " ON  D3_LOCAL = NNR_CODIGO "	
	cQry += "WHERE D3_FILIAL ='"+wFilial+"' AND D3_DOC = '"+wNroDoc+"' AND SD3020.D_E_L_E_T_ = ' '" 
	if wTipoMov = "499" .OR. wTipoMov = "999"
		cQry += " AND D3_TM = '999' " 	
	Endif
	
	cAlias := CriaTrab(Nil,.F.)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQry),cAlias, .F., .T.)  
	
	(cAlias)->(DbGoTop())
	If (cAlias)->(Eof())
		Return .F.
	Endif                              
	
	cAlmOri		:= ""
	cDesAlmOri 	:= ""
   //	cEmision 	:= (cAlias)->D3_EMISSAO
   //	cDia		:= SubStr(DtoS(cEmision),7,2)
  //	nMes		:= SubStr(DtoS(cEmision),5,2)
  //	cAno		:= SubStr(DtoS(cEmision),1,4)  
	DO CASE
		CASE wTipoMov = "499" .OR. wTipoMov = "999"
			cDesTran := "TRANSFERENCIA"
		 	If wTipoMov = "499"
		 		cAlmDes := Alltrim((cAlias)->D3_LOCAL)
		 		cDesAlmDes := Alltrim((cAlias)->NNR_DESCRI)
		 		cQry2 := "SELECT D3_LOCAL, NNR_DESCRI "
				cQry2 += "FROM " + RetSqlName("SD3")+ " "
				cQry2 += "INNER JOIN " + RetSqlName("NNR")+ " ON  D3_LOCAL = NNR_CODIGO "	
				cQry2 += "WHERE D3_FILIAL ='"+wFilial+"' AND D3_DOC = '"+wNroDoc+"' AND D3_TM = '999' AND SD3020.D_E_L_E_T_ = ' ' "  
				cAlias2 := CriaTrab(Nil,.F.)
				DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQry2),cAlias2, .F., .T.)  
				(cAlias2)->(DbGoTop())
				If (cAlias2)->(Eof())
					Return .F.
				Endif
				cAlmOri := Alltrim((cAlias2)->D3_LOCAL)
		 		cDesAlmOri := Alltrim((cAlias2)->NNR_DESCRI)                              
			Endif
		   
		  	If wTipoMov = "999"
		  		cAlmOri		:= Alltrim((cAlias)->D3_LOCAL)
		   		cDesAlmOri 	:= Alltrim((cAlias)->NNR_DESCRI)
		 		cQry2 := "SELECT D3_LOCAL, NNR_DESCRI "
				cQry2 += "FROM " + RetSqlName("SD3")+ " "
				cQry2 += "INNER JOIN " + RetSqlName("NNR")+ " ON  D3_LOCAL = NNR_CODIGO "	
				cQry2 += "WHERE D3_FILIAL ='"+wFilial+"' AND D3_DOC = '"+wNroDoc+"' AND D3_TM = '499' AND SD3020.D_E_L_E_T_ = ' ' "  
				cAlias2 := CriaTrab(Nil,.F.)
				DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQry2),cAlias2, .F., .T.)  
				(cAlias2)->(DbGoTop())
				If (cAlias2)->(Eof())
					Return .F.
				Endif
				cAlmDes := Alltrim((cAlias2)->D3_LOCAL)
		 		cDesAlmDes := Alltrim((cAlias2)->NNR_DESCRI)                              
		   Endif		   
		   
		CASE wTipoMov < "500"
	 		cDesTran := "INGRESOS"
	 		cAlmDes := Alltrim((cAlias)->D3_LOCAL)
			cDesAlmDes := Alltrim((cAlias)->NNR_DESCRI)   
	   	CASE wTipoMov < "999"
	    	cDesTran := "SALIDAS"                       
	    	cAlmOri		:= Alltrim((cAlias)->D3_LOCAL)
			cDesAlmOri 	:= Alltrim((cAlias)->NNR_DESCRI)
		OTHERWISE
			cDesTran := ""
	ENDCASE
    
	nLin := 0    //                        mi
	@ 001 , 000 PSay "CIA. ALREX SAC"
	@ 002 , 000 PSay "MOVIMIENTOS DE ALMACEN"
	@ 003 , 000 PSay cDesTran	
	@ 004 , 000 PSay "ALMACEN ORIGEN: " + cAlmOri + "-" + cDesAlmOri
	@ 005 , 000 PSay "ALMACEN DESTINO: " + cAlmDes + "-" + cDesAlmDes
	@ 006 , 000 PSay "FECHA: " + (cAlias)->D3_EMISSAO  	// cDia+"/"+nMes+"/"+cAno      
	@ 007 , 000 PSay "DOCUMENTO: " + Alltrim((cAlias)->D3_DOC)
	@ 008 , 000 PSay "USUARIO: " + Alltrim((cAlias)->D3_USUARIO)
	
	@ 009 , 000 PSay "----------------------------------------"
	@ 010 , 000 PSay "CODIGO"
	@ 010 , 017 PSay "UM"
	@ 010 , 020 PSay "CAN"
	@ 010 , 027 PSay "UBICACION"
	@ 011 , 000 PSay "DESCRIPCION"
	@ 012 , 000 PSay "----------------------------------------"
	nLin := 12 
	    	
	While (cAlias)->(!Eof())   
	    	
		If SB1->( DbSeek(xFilial("SB1") + (cAlias)->D3_COD ))
			cDescProd := Alltrim(SB1->B1_DESC)  
		else
			cDescProd := ""
		EndIf
	
		@ nLin + 1 , 000 PSay Alltrim((cAlias)->D3_COD)
		@ nLin + 1 , 017 PSay Alltrim((cAlias)->D3_UM)
		@ nLin + 1 , 024 PSay (cAlias)->D3_QUANT
		@ nLin + 1 , 027 PSay Alltrim((cAlias)->D3_LOCALIZ)
		@ nLin + 2 , 000 PSay cDescProd
  		@ nLin + 3 , 000 PSay  " "
   //		@ nLin + 3 , 020 PSay Alltrim((cAlias)->D3_LOCALIZ)			
  //		@ nLin + 3 , 030 PSay Alltrim((cAlias)->D3_NUMSERI)
		
  		nLin := nLin + 3
		
	  	(cAlias)->(DbSkip())
	  	
	Enddo  
	nLin := nLin + 3                        
	@ nLin , 000 PSay "----------------"
	@ nLin + 1 , 000 PSay "  RECIBIDO POR"
	nLin := nLin + 15	
   	@ nLin , 000 PSay Chr(27) + Chr(109)
	
	Set Device To Screen
	                            
	If aReturn[5] == 1
		Set Printer TO
		DbCommitAll()
		OurSpool(wnrel)
	EndIf
	
	Ms_Flush()
	          
	DbSelectArea("SD3")
//	DbSetOrder(nIndSD3)
	
	RestArea(aArea)
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO3     บAutor  ณMicrosiga           บFecha ณ  11/21/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 

Static Function VerImp()
	nLin:= 0         
	If aReturn[5]==2
		nOpc:= 1
		While .T.
			Eject
	      	DbCommitAll()
	      	SetPRC(0,0)
	       	If (MsgYesNo("Fomulario esta posicionado ? "))
	      		nOpc := 1
	      	ElseIf (MsgYesNo("Intenta Nuevamente ? "))
	      		nOpc := 2
	      	Else
	      		nOpc := 3
	      	EndIf
			Do Case
	        	Case nOpc == 1                                                       
	            	lContinua := .T.
	            	Exit
	        	Case nOpc == 2
	            	Loop
	         	Case nOpc == 3
	            	lContinua := .F.
	            	Return
	      	EndCase
	   End
	EndIf
Return
