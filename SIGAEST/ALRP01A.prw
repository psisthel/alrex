#INCLUDE "rwmake.ch"    
#Include "protheus.ch"          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA261TRD3 ºAutor  ³Microsiga           º Data ³  02/05/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impresion del recibo de trnsferencias y movimientos        º±±
±±º          ³ internos de stock                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function ALRP01A(wFilial,wNroDoc,wTipoMov)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	LOCAL oDlg := NIL
	LOCAL cString	:= "SD3"
	PRIVATE titulo 	:= ""
	PRIVATE nLastKey:= 0
	PRIVATE nomeProg:= FunName()
	Private nTotal	:= 0
	Private nSubTot	:= 0
	 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros					  		³
	//³ mv_par01				// Numero da PT                   		³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel := FunName()            //Nome Default do relatorio em Disco
	 
	PRIVATE cTitulo := "Impresion del Recibo"
	PRIVATE oPrn    := NIL
	PRIVATE oFont1  := NIL
	PRIVATE oFont2  := NIL
	PRIVATE oFont3  := NIL
	PRIVATE oFont4  := NIL
	PRIVATE oFont5  := NIL
	PRIVATE oFont6  := NIL
	Private nLastKey := 0
	Private nLin := 0 // Linha de inicio da impressao das clausulas contratuais
	
	lContinua := .t.
	 
	DEFINE FONT oFont1 NAME "Times New Roman" SIZE 0,20 BOLD  OF oPrn
	DEFINE FONT oFont2 NAME "Times New Roman" SIZE 0,14 BOLD OF oPrn
	DEFINE FONT oFont3 NAME "Times New Roman" SIZE 0,14 OF oPrn
	DEFINE FONT oFont4 NAME "Times New Roman" SIZE 0,14 ITALIC OF oPrn
	DEFINE FONT oFont5 NAME "Times New Roman" SIZE 0,14 OF oPrn
	DEFINE FONT oFont6 NAME "Courier New" BOLD
	 
	//oFont10 := TFont():New("Consolas",,08,,.f.,,,,,.f.)
	oFont10 := TFont():New("Courier New",,08,,.f.,,,,,.f.)
	 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tela de Entrada de Dados - Parametros                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLastKey  := IIf(LastKey() == 27,27,nLastKey)
	 
	If nLastKey == 27
		Return
	Endif
	 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicio do lay-out / impressao                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	 
	oPrn := TMSPrinter():New(cTitulo)
	oPrn:Setup()
	oPrn:SetPortrait() //SetLansCape()
	oPrn:SetPaperSize(31)
	oPrn:StartPage() 
	xRecibo(wFilial,wNroDoc,wTipoMov)
	SetPgEject(.F.) // Funcao pra n?o ejetar pagina em branco 
	oPrn:Print( {1,1}, 1 ) 
	oPrn:EndPage()
	oPrn:End()
	//Ms_Flush()
 
Return( lContinua )


Static Function xRecibo(wFilial,wNroDoc,wTipoMov)

	Local aArea    		:= GetArea()
	Local cDescProd		:= Space(TamSx3("B1_DESC")[1])
	Local cDesTran 		:= ""
	Local cAlmOri 		:= ""
	Local cDesAlmOri 	:= ""
	Local cAlmDes 		:= ""
	Local cDesAlmDes 	:= ""
	Local cNomeUser		:= UsrRetName( NNS->NNS_SOLICT )
                   
	DbSelectArea("SB1")
	DbSetOrder(1)
	
	DbSelectArea("NNR")
	DbSetOrder(1)

	cQry := "SELECT D3_LOCAL,NNR_DESCRI,D3_DOC,D3_EMISSAO,D3_COD,D3_UM,D3_QUANT,D3_LOCALIZ,D3_NUMSERI,"
  	cQry += "D3_USUARIO, D3_TM, D3_CF "
	cQry += "FROM " + RetSqlName("SD3")+ " "
	cQry += "INNER JOIN " + RetSqlName("NNR")+ " ON  D3_LOCAL = NNR_CODIGO "	
	cQry += "WHERE D3_FILIAL ='"+wFilial+"'"
	cQry += "  AND (D3_DOC='"+wNroDoc+"' OR D3_YDOC='"+wNroDoc+"')"
	cQry += "  AND SD3020.D_E_L_E_T_ = ' '"
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

	DO CASE
		CASE wTipoMov = "499" .OR. wTipoMov = "999"
			cDesTran := "TRANSFERENCIA"
		 	If wTipoMov = "499"
		 		cAlmDes := Alltrim((cAlias)->D3_LOCAL)
		 		cDesAlmDes := Alltrim((cAlias)->NNR_DESCRI)
		 		cQry2 := "SELECT D3_LOCAL, NNR_DESCRI "
				cQry2 += "FROM " + RetSqlName("SD3")+ " "
				cQry2 += "INNER JOIN " + RetSqlName("NNR")+ " ON  D3_LOCAL = NNR_CODIGO "	
				cQry2 += "WHERE D3_FILIAL ='"+wFilial+"'"
				cQry2 += "  AND (D3_DOC='"+wNroDoc+"' OR D3_YDOC='"+wNroDoc+"')"
				cQry2 += "  AND D3_TM = '999' AND SD3020.D_E_L_E_T_ = ' ' " 
				cAlias2 := CriaTrab(Nil,.F.)
				DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQry2),cAlias2, .F., .T.)  
				(cAlias2)->(DbGoTop())
				If (cAlias2)->(Eof())
					Return .F.
				Endif
				cAlmOri := Alltrim((cAlias2)->D3_LOCAL)
		 		cDesAlmOri := Alltrim((cAlias2)->NNR_DESCRI)                              
		 		(cAlias2)->( dbCloseArea() )
			Endif
		   
		  	If wTipoMov = "999"
		  		cAlmOri		:= Alltrim((cAlias)->D3_LOCAL)
		   		cDesAlmOri 	:= Alltrim((cAlias)->NNR_DESCRI)
		 		cQry2 := "SELECT D3_LOCAL, NNR_DESCRI "
				cQry2 += "FROM " + RetSqlName("SD3")+ " "
				cQry2 += "INNER JOIN " + RetSqlName("NNR")+ " ON  D3_LOCAL = NNR_CODIGO "	
				cQry2 += "WHERE D3_FILIAL ='"+wFilial+"'"
				cQry2 += "  AND (D3_DOC='"+wNroDoc+"' OR D3_YDOC='"+wNroDoc+"')"
				cQry2 += "  AND D3_TM = '499' AND SD3020.D_E_L_E_T_ = ' ' "  
				cAlias2 := CriaTrab(Nil,.F.)
				DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQry2),cAlias2, .F., .T.)  
				(cAlias2)->(DbGoTop())
				If (cAlias2)->(Eof())
					Return .F.
				Endif
				cAlmDes := Alltrim((cAlias2)->D3_LOCAL)
		 		cDesAlmDes := Alltrim((cAlias2)->NNR_DESCRI)                              
		 		(cAlias2)->( dbCloseArea() )
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
	oPrn:Say(000,005,"CIA. ALREX SAC",oFont10)
	oPrn:Say(040,005,"MOVIMIENTOS DE ALMACEN",oFont10)
	oPrn:Say(080,005,cDesTran,oFont10)	
	oPrn:Say(120,005,"ALMACEN ORIGEN: " + cAlmOri + "-" + cDesAlmOri,oFont10)
	oPrn:Say(160,005,"ALMACEN DESTINO: " + cAlmDes + "-" + cDesAlmDes,oFont10)
	oPrn:Say(200,005,"FECHA: " + dtoc(stod((cAlias)->D3_EMISSAO)),oFont10)  	// cDia+"/"+nMes+"/"+cAno      
	oPrn:Say(240,005,"DOCUMENTO: " + Alltrim((cAlias)->D3_DOC),oFont10)
	oPrn:Say(280,005,"USUARIO: " + Alltrim((cAlias)->D3_USUARIO),oFont10)
	//oPrn:Say(280,005,"USUARIO: " + Alltrim(cNomeUser),oFont10)
	
	oPrn:Say(320,000,"----------------------------------------------",oFont10)
	oPrn:Say(360,000,"CODIGO",oFont10)
	oPrn:Say(360,378,"UM",oFont10)
	oPrn:Say(360,500,"CAN",oFont10)
	oPrn:Say(360,590,"UBICACION",oFont10)
	oPrn:Say(400,000,"DESCRIPCION",oFont10)
	oPrn:Say(440,000,"----------------------------------------------",oFont10)
	nLin := 480 
	    	
	While (cAlias)->(!Eof())   
	    	
		If SB1->( DbSeek(xFilial("SB1") + (cAlias)->D3_COD ))
			cDescProd := Alltrim(SB1->B1_DESC)  
		else
			cDescProd := ""
		EndIf
	
		oPrn:Say(nLin,000,Alltrim((cAlias)->D3_COD),oFont10)
		oPrn:Say(nLin,359,Alltrim((cAlias)->D3_UM),oFont10)
		oPrn:Say(nLin,450,transform((cAlias)->D3_QUANT,'@E 99,999.99'),oFont10)
		//oPrn:Say(nLin,590,Alltrim((cAlias)->D3_LOCALIZ),oFont10)
		nLin = nLin + 40
		oPrn:Say(nLin,000,cDescProd,oFont10)
		oPrn:Say(nLin,580,Alltrim((cAlias)->D3_LOCALIZ),oFont10)
  		nLin = nLin + 50
		
	  	(cAlias)->(DbSkip())
	  	
	Enddo  
	
	nLin += 150                        
	oPrn:Say(nLin,027,"----------------",oFont10)
	nLin += 50
	oPrn:Say(nLin,027,"RECIBIDO POR  ",oFont10)
	nLin += 200
	oPrn:Say(nLin,000,"+",oFont10)

   	//@ nLin , 000 PSay Chr(27) + Chr(109)
	
	RestArea(aArea)
	
Return
