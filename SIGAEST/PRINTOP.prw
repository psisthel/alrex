#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"  
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "Font.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PRINTOP   ºAutor  ³Percy Arias         ºFecha ³  09/18/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime O.P. 	                                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PRINTOP()

	Local aArea			:= GetArea()
	Local clPathCli		:= GetTempPath()
	Local nlLin			:= 80
	Local Titulo		:= "Orden de Producción"

	Private oPrint
	Private cpNameArq	:= "OP_"+ DtoS(Date()) + "_" + Strtran(Time(), ":", "")
	Private cpPathServ	:= "\Relato"
	Private cString 	:= "SC2"
	
	dbSelectArea(cString)
	dbSetOrder(1)
	
	oPrint := FWMSPrinter():New(cpNameArq, IMP_PDF,.T., /*clPathServer*/,.T.,,,,, /*[ lPDFAsPNG]*/,, .T./*[ lViewPDF]*/, )
		
	oPrint:SetResolution(72)
	oPrint:SetPortrait()
	oPrint:setPaperSize(9)
	oPrint:cPathPDF := clPathCli

	RptStatus({|| RunReport1(nlLin) },Titulo)
	
	RestArea( aArea )

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PRINTOP   ºAutor  ³Microsiga           ºFecha ³  09/18/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RunReport1( nlLin )

	Local nQuant     	:= 1
	Local nomeprog   	:= "PRINOP"
	Local cProduto   	:= Space(LEN(SC2->C2_PRODUTO))
	Local cQtd,i,nBegin
	Local cIndSC2    	:= CriaTrab(NIL,.F.), nIndSC2
	Local cItemOP    	:= SC2->C2_NUM
	Local olFont01		:= TFont():New("Courier New",	9,13,.T.,.F.,5,.T.,5,.T.,.F.)
	Local olFont02		:= TFont():New("Courier New",	9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	Local olFont03		:= TFont():New("Courier New",	9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	Local olFont04		:= TFont():New("Courier New",	9,18,.T.,.T.,5,.T.,5,.T.,.F.)
	Local olFont05		:= TFont():New("Courier New",	9,18,.T.,.F.,5,.T.,5,.T.,.F.)
	Local olFont10		:= TFont():New("Courier New",	9,10,.T.,.F.,5,.T.,5,.T.,.F.)
	Local olFont16		:= TFont():New("Courier New",	9,16,.T.,.F.,5,.T.,5,.T.,.F.)
	Local nlPag			:= 1
	Local nTotPeso		:= 0
	Local nAcBatch		:= 0
	Local nAcPigme		:= 0
	Local nValItem		:= 0
	Local nAcAgent		:= 0
	Local nCantItm		:= 0

	Private cAlias		:= getNextAlias()
	Private aArray		:= {}
	Private aPigme		:= {}
	Private aBatch		:= {}
	Private lEToner		:= .f.
	Private nQtdeDeBat	:= 0
	Private aAgLub		:= {}
	Private nCantDaOP	:= 0
	Private cObsDaOP	:= ""

	cQuery := "SELECT C2_FILIAL, C2_NUM, C2_ITEM, C2_SEQUEN, C2_ITEMGRD, C2_DATPRF, C2_EMISSAO, "
	cQuery += "		  C2_DATRF, C2_PRODUTO, C2_DESTINA, C2_PEDIDO, C2_ROTEIRO, C2_QUJE,"
	cQuery += "		  C2_PERDA, C2_QUANT, C2_DATPRI, C2_CC, C2_DATAJI, C2_DATAJF,"
	cQuery += "		  C2_STATUS, C2_OBS, C2_TPOP, SC2.R_E_C_N_O_  SC2RECNO "
	cQuery += "  FROM "+RetSqlName("SC2")+" SC2"
	cQuery += " WHERE C2_FILIAL='"+xFilial("SC2")+"'"
	cQuery += "   AND SC2.D_E_L_E_T_=' '"
	cQuery += "   AND C2_NUM='" + cItemOP + "'"
	cQuery += " ORDER BY C2_NUM,C2_ITEM"

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
	
	dbSelectArea(cAlias)
	SetRegua((cAlias)->(LastRec()))

	While (cAlias)->( !Eof() )
	
		IncRegua()
			
		cProduto  := (cAlias)->C2_PRODUTO
		nQuant    := aSC2Sld("SC2")
		cObsDaOP  := (cAlias)->C2_OBS
		
		dbSelectArea("SB1")
		dbSeek(xFilial()+cProduto)
		
		nlLin := cabecOp(nlLin, olFont01, olFont03, olFont04, nlPag, olFont16)

		SG1->( dbSetOrder(1) )
		If SG1->( dbSeek( xFilial("SG1")+cProduto ) )
		
			While SG1->( !Eof() ) .And. SG1->G1_FILIAL+SG1->G1_COD == xFilial("SG1")+cProduto
	
				Aadd( aArray, { SG1->G1_COMP,Posicione("SB1",1,xFilial("SB1")+SG1->G1_COMP,"B1_DESC"),SG1->G1_QUANT } )
				SG1->( dbSkip() )
	
			Enddo
		
		EndIf
		
		(cAlias)->( dbSkip() )
		
	EndDO
	
	(cAlias)->( dbCloseArea() )
	
	nlLin += 10
	
	For t := 1 to Len( aArray ) 

		oPrint:Say	(nlLin, 0100, aArray[t][1]+" "+aArray[t][2], olFont03)
		oPrint:Say	(nlLin, 1200, Transform( aArray[t][3],"@E 999999.9999"), olFont03)
		oPrint:Say	(nlLin, 1600, Transform( (aArray[t][3]*nCantDaOP),"@E 999999.9999" ), olFont03)
		
		nlLin += 40
	Next t
	
	nlLin += 10
	
	oPrint:Line	(nlLin,0000,nlLin,2500)
	
	nlLin += 40

	If !(Empty(cObsDaOP))
		oPrint:Say	(nlLin, 0100, "Observaciones:", olFont01)
		nlLin += 40
		For nBegin := 1 To Len(Alltrim(cObsDaOP)) Step 65
			oPrint:Say	(nlLin, 0100, Substr(cObsDaOP,nBegin,65), olFont03)
			nlLin += 40
		Next nBegin
		
		oPrint:Line	(nlLin,0000,nlLin,2500)
		
		nlLin += 40
		
	EndIf
	
	oPrint:Say	(nlLin, 0100, "Total de Itens: "+Transform(Len( aArray ),"@E 999999.9999"), olFont03)
	
	nlLin += 40
	
	oPrint:Line	(nlLin,0000,nlLin,2500)
	
	nlLin += 200
	
	oPrint:Say	(nlLin, 0200, "__________________________________________", olFont03)
	oPrint:Say	(nlLin, 1300, "__________________________________________", olFont03)
	
	nlLin += 40
	
	oPrint:Say	(nlLin, 0450, "JEFE DE PRODUCCION", olFont03)
	oPrint:Say	(nlLin, 1600, "V.B. GERENCIA", olFont03)
	
	SET DEVICE TO SCREEN	
	oPrint:Preview()
	
	MS_FLUSH()
	
Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PRINTOP   ºAutor  ³Microsiga           ºFecha ³  09/18/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CabecOp(nlLin, olFont01, olFont03, olFont04, nlPg, olFont16)
                                                                  
	Local nBegin
	
	oPrint:StartPage()
	nlLin := 0010
	nCantDaOP := (cAlias)->C2_QUANT

	oPrint:Line	(nlLin,0000,nlLin,2500)
	nlLin += 10
	oPrint:SayBitmap( (nlLin+50), 0060, "\system\LGMID.png", 320, 140)
	nlLin += 105
	oPrint:Say	(nlLin, 0500, SM0->M0_NOMECOM, olFont04)	
	oPrint:Say	(nlLin, 1700, "Nro O.P.: " + (cAlias)->C2_NUM, olFont04)
	nlLin += 75
	oPrint:Say	(nlLin, 0500, SM0->M0_ENDCOB, olFont03)
	oPrint:Say	(nlLin, 1700, "Emisión: " + Dtoc(Stod((cAlias)->C2_EMISSAO)), olFont01)
	nlLin += 28
	oPrint:Say	(nlLin, 0500, "R.U.C. "+SM0->M0_CGC, olFont03)
	oPrint:Say	(nlLin, 1700, "Entrega: "+Dtoc(Stod((cAlias)->C2_DATPRF)), olFont01)
	//nlLin += 28
	//oPrint:Say	(nlLin, 0500, "Maquina: "+Left( Posicione("ZA1",1,xFilial("ZA1")+TRB->C2_YMAQUIN,"ZA1_DESC") , 30 ), olFont03)
	//oPrint:Say	(nlLin, 1700, "Fecha de Producción: "+Dtoc(Stod((cAlias)->C2_DATPRI)), olFont01)
	nlLin += 30
	oPrint:Line	(nlLin,0000,nlLin,2500)
	nlLin += 60	
	oPrint:Say	(nlLin, 0100, "Producto: "+Alltrim(SB1->B1_COD)+" - "+SB1->B1_DESC, olFont16)
	oPrint:Say	(nlLin, 1600, "Cantidad: "+Transform( nCantDaOP,"@E 999999.9999" )+ " "+ Posicione("SB1",1,xFilial("SB1")+SB1->B1_COD,"SB1->B1_UM") , olFont16)
	nlLin += 40
	oPrint:Line	(nlLin,0000,nlLin,2500)
	nlLin += 40
	
Return nlLin


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PRINTOP   ºAutor  ³Microsiga           ºFecha ³  10/18/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xRetArrendoda( nValArray )

	Local nCalc1 := nValArray
	Local nCalc2 := Round( nCalc1, 1 )
	Local nCalc3 := Alltrim( Str( NoRound( nCalc1, 2 ) ) )
	
	nCalc3 := transform(nCalc3,"@E9,999.99")
	
	If At(".", Alltrim(Str(nValArray)) ) > 0
	
		If Len( Substr( nCalc3, At(".", Alltrim(nCalc3))+1, Len(Alltrim(nCalc3)) ) ) > 1
	
			If Val( Right( nCalc3,1 ) ) < 5
				nCalc2 := nCalc2 + 0.05
			ElseIf Val( Right( nCalc3,1 ) ) = 5
				nCalc2 := NoRound( nValArray,2 )
			EndIf
		Else
			nCalc2 := NoRound( nValArray,2 )
		EndIf
	Else
		nCalc2 := NoRound( nValArray,2 )
	EndIf
	
	If nValArray<=0
		nCalc2 := 0
	EndIf
	
Return( nCalc2 )
