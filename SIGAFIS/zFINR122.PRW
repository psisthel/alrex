#include "RwMake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "FINR122.ch"

#define PIX_DIF_COLUNA_VALORES		300		// Pixel inicial para impressao dos tracos das colunas dinamicas
#define PIX_INICIAL_VALORES			000		// Pixel para impressao do traco vertical
#define PIX_EQUIVALENTE				010		// Pixel inicial para impressao das colunas dinamicas

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFINR1_02  บ Autor ณ Totvs              บ Data ณ  14/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณLIBRO CAJA Y BANCOS DETALLE DE LOS MOV. LA CUENTA CORRIENTE บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณFINR1_02 - Localiza็ใo Peru                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function zFINR122()
	Local cPerg		:= "FIN122"
	Local olReport
	Private aRenglon := {}

	/*ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	ณ MV_PAR01 - ฟDe Banco?                                            ณ
	ณ MV_PAR02 - ฟA Banco?                                             ณ
	ณ MV_PAR03 - ฟDe fecha?                                            ณ
	ณ MV_PAR04 - ฟA fecha?                                             ณ
	ณ MV_PAR05 - ฟDe Sucursal? 										   ณ
	ณ MV_PAR06 - ฟA Sucursal?										   ณ
	ณ MV_PAR07 - ฟGenerar Archivo TXT? 							       ณ
	ณ MV_PAR08 - ฟRuta para generar  TXT? 							   ณ
	ณ MV_PAR09 - ฟMoneda? 										       ณ
	ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/

	Pergunte(cPerg,.F.)
	
	olReport := FinRelat(cPerg)
	olReport:SetParam(cPerg)
	olReport:PrintDialog()
Return

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณFINRelat  ณ Autor ณ Totvs                 ณ Data | 14/05/10 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณCria็ใo do objeto TReport para a impressใo do relatorio.    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณFinRelat( cPerg )           				                  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณExpC1 = Perguntas dos parametros                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FinRelat( cPerg )
	Local clNomProg		:= FunName()
	Local clTitulo 		:= STR0001 //"Detalhes da Diferenca de Cambio"
	Local clDesc   		:= STR0001 //"Detalhes da Diferenca de Cambio"
	Local olReport
	
	olReport:=TReport():New(clNomProg,clTitulo,cPerg,{|olReport| FinPrc122(olReport)},clDesc)
	olReport:SetLandscape()					// Formato paisagem
	olReport:lHeaderVisible 	:= .F. 		// Nใo imprime cabe็alho do protheus
	olReport:lFooterVisible 	:= .F.		// Nใo imprime rodap้ do protheus
	olReport:lParamPage			:= .F.		// Nใo imprime pagina de parametros
Return olReport

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณFinpRC122 ณ Autor ณ Totvs                 ณ Data | 14/05/10 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณImpressใo do relatorio.								      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ FinProc( ExpC1 )         				                  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณExpC1 = Objeto tReport                                      ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FinPrc122( olReport )

	private cTabela14	:= ""
	private cExpMda		:= ""
	private cBanco		:= GetMv("MV_CAJALF")

	DbSelectArea("CT1")
	aCT1 := GetArea()
	DbSetORder(1)
	DbSelectArea("CT2")
	aCT2 := GetArea()
	DbSetORder(16)
	DbSelectArea("CV3")
	aCV3 := GetArea()
	DbSetORder(3)
	
	// Carrega a tabela 14 - Da mesma forma como feita no extrato bancario - FINR470
	SX5->(DbSetOrder(1))
	SX5->(MsSeek(xFilial("SX5")+"14"))
	While SX5->(!Eof()) .And. SX5->X5_TABELA == "14"
		cTabela14 += (Alltrim(SX5->X5_CHAVE) + "/")
		SX5->(DbSkip())
	End

	cTabela14 += If(cPaisLoc=="BRA","","/$ ")
	cExpMda	:= " E5_MOEDA NOT IN " + FormatIn(cTabela14,"/")
	
	If MV_PAR07 == 1
   		Processa({|| GerArq(AllTrim(MV_PAR08))},,STR0040 ) //"Generando archivo"
	Else
		Processa({|| GerReporte(olReport,AllTrim(MV_PAR08))},,STR0040 ) //"Generando Fisico"
	EndIf
	
	RestArea(aCV3)
	RestArea(aCT2)
	RestArea(aCT1)

Return

	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณZFINR122  บAutor  ณMicrosiga           บFecha ณ  10/13/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GerReporte(olReport,cDir)

	Local nReg			:= 0 //Quantidade de registros impressos
	Local nPag			:= 0 //Quantidade de paginas por pagina
	Local nCol			:= 0
	Local aCnts			:= {}
	Local aColFin       := { STR0002, "", "", "", "", "", "", "", "", ""}
	Local aColFin2      := { STR0010 , STR0011, STR0012, STR0032,	STR0014, ;
						STR0015, "","","",""}
	Local aColFin3      := {STR0017, STR0018, " ", STR0018, STR0023,;
						 STR0024, STR0025, STR0026, STR0027, STR0028}
	// Deve obedecer a ordem das colunas do relatorio, caso nใo tenha campo na Query, identificar a primeira letra com "n - numerico, c - caracter"
	Local aEquivale 	:= { "E5_NODIA", "E5_DATA", "E5_TIPO","E5_HISTOR", "E5_BENEF", "E5_NUMERO","CT2_CREDIT","CT1_DESC01","E5_MOEDA","E5_VALOR"}
	Local nInc			:= 0
	Local nPos			:= 0
	Local nPosEquiv		:= 0
	Local cStrFil		:= ""
	Local oFont 		:= TFont():New( "Courier New",, -08 )
	Local oFont12 		:= TFont():New( "Courier New",, -12 )
	Local aVert			:= { 5, 130, 250, PIX_INICIAL_VALORES }
	Local nIniDin		:= PIX_INICIAL_VALORES					// Pixel redimencionado dinamicamente
	Local nLimitrofe	:= 4850
	Local nLinHist 		:= 1
	Local aHistorico	:= {}
	Local aSelFil		:= {}
	Local cNomCon	    := ""
	Local cContCtb		:= ""  // armazena conta contabil, se E5_RECPAG = "P", CT2_CREDIT, senao CT2_DEBITO

	Local nTotDeb 		:= 0
	Local nTotDeb_C 	:= 0
	Local nTotDeb_A 	:= 0
	Local nTotDeb_B 	:= 0
	Local nTotDeb_T		:= 0        // totalizadores para Banco/Agencia/Conta
	Local nTotCre 		:= 0
	Local nTotCre_C 	:= 0
	Local nTotCre_A 	:= 0
	Local nTotCre_B 	:= 0
	Local nTotCre_T 	:= 0        // totalizadores para Banco/Agencia/Conta
	Local cTipPer       := ""
	Local cDescPrt 		:= ""
	Local nTotDeb_P     := ""
	Local nTotCre_P     := ""
	Local aCT1			:= {}
	Local aCV3			:= {}
	Local aCT2			:= {}
	Local cBanMov 		:= ""
	Local cConMov 		:= ""
	Local cAgeMov		:= ""
	Local lNext			:= .T.
	Local cLinea        := ""
	Local cPeriodo      := AllTrim(StrZero(Year(MV_PAR03),4)) + AllTrim(StrZero(Month(MV_PAR03),2)) + "00"
	Local cEdoOpe       := "1"
	Local cCodEntFin    := ""
	Local cCtaBanCon    := ""
	Local cFechaOpe     := ""
	Local cDesOpeBan    := ""
	Local cNumTraBan    := ""
	Local cTipoDoc      := ""
	Local cTipo         := ""
	Local cBenef        := ""
	Local nValDeu       := 0
	Local cNumDoc       := ""
	Local cNumCorre     := ""
	Local cCodUniOpe    := ""
	Local nTotDatos     := 0
	Local lMoeda := IIf(alltrim(MV_PAR09)$'01|1',.T.,.F.)
	Local lVerCorr := .F.
	Local nTasa    := 1
	local aCuentas		:= {}
	local aOtros		:= {}
	Local cTmpCT1Fil	:= ""
	local lprnOtros		:= .t.
	local aDatCt2		:= {}
	local cCtaCtb		:= ""

	vsql := "SELECT A6_COD,A6_AGENCIA,A6_NUMCON,A6_CONTA,A6_NOME,A6_IDFIN,A6_CGC,A6_MOEDA"
	vsql += "  FROM "+RetSqlName("SA6")
	//vsql += " WHERE A6_FILIAL BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"
	vsql += " WHERE A6_FILIAL='"+xFilial("SA6")+"'"
	vsql += "   AND A6_COD NOT IN "+Formatin(cBanco,"/")
	vsql += "   AND A6_CONTA<>''"
	vsql += "   AND D_E_L_E_T_=''"
	
	If Select("PER") > 1
		PER->( DbCLoseArea() )
	Endif
	
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, vsql ), "PER",.T.,.T.)

	DbSelectArea( "PER" )
	PER->( DbGoTop() )
	
	If PER->( !Eof() )
		FCabR122( olReport, nCol, aColFin, aColFin2, aColFin3) //Impressใo do cabe็alho
		olReport:SetMeter( RecCount() )
		olReport:OnPageBreak( { || FCabR122( olReport, nCol, aColFin, aColFin2, aColFin3 ) } )
	Endif
	
	nTotDeb	  := 0
	nTotCre	  := 0
	nValDeu  := 0
	nValAcre := 0
	
	
	While PER->(!Eof())
	
		If olReport:Cancel()
			Exit
		EndIf
		
		If PER->A6_CONTA<>cCtaCtb
			cCtaCtb := PER->A6_CONTA
			olReport:Box(360,10,360,3000)
			FR122Prnt( olReport, {0,5,300,600,1200,1500,1800,2100,2400,2700,3000} )
			olReport:Say(390,610,STR0035,oFont)
			//nSalIni := SldBco(PER->A6_COD,PER->A6_AGENCIA,PER->A6_NUMCON,MV_PAR03-1,1)
			aSldAnt := SaldoCT7Fil(PER->A6_CONTA,MV_PAR03-1,MV_PAR09,"1","FINR122")
			nSalIni := aSldAnt[1]
			//nSalIni := xMoeda(nSalIni,PER->A6_MOEDA,val(MV_PAR09),MV_PAR03-1)
			olReport:Say(390,IIf(nSalIni <= 0,2410,2710),Transform(IIf(nSalIni > 0,nSalIni,nSalIni * -1),"@E 9999,999,999,999.99"),oFont)
	
			olReport:SkipLine( 1 )
			olReport:Box(390,10,390,3000)
			lNext := .F.
	      	nTotDeb := 0
	      	nTotCre := 0
		EndIf

		aCuentas := {}
		cBenef := ""
		cBanMov := PER->A6_COD
		cConMov := PER->A6_NUMCON
		cAgeMov := PER->A6_AGENCIA
		cNomCon  := ""
		cContCtb := ""
		cCodEntFin := PER->A6_IDFIN
		cCtaBanCon := PER->A6_NUMCON
		cFechaOpe  := SPACE(8)
		cDesOpeBan := ""
		cNumTraBan := ""
		//cCtaCajas := fgetCajas(cBanco)
		cNumCorre := ""
		cCodUniOpe := ""
		lVerCorr := .F.
		lSoloSE5 := .f.
		aCUOsCta := {}
		aCUOsCta := getCUOs(PER->A6_CONTA)
		
		for np := 1 to len(aCUOsCta)
		
			hAlias := getNextAlias()
		
			cQry := "SELECT CT2_FILIAL,CT2_KEY,CT2_ROTINA,CT2_LP,CT2_LINHA,CT2_NODIA,CT2_SEGOFI,CT2_DEBITO,CT2_CREDIT,CT2_VALOR,CT2_HIST,CT2_DATA"
			cQry += "  FROM " + RetSqlName("CT2") + " CT2"
			cQry += " WHERE CT2_SEGOFI = '" + aCUOsCta[np][1] + "'"
			cQry += "   AND CT2_FILIAL BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"
			cQry += "   AND CT2_DEBITO<>''"
			cQry += "   AND CT2_DEBITO<>'"+cCtaCtb+"'"
			cQry += "   AND ( SUBSTRING(CT2_DEBITO,1,1)<>'9' AND SUBSTRING(CT2_DEBITO,1,2)<>'79' )"
			cQry += "   AND CT2_VALOR>0"
			cQry += "   AND CT2_MOEDLC='"+strzero(val(MV_PAR09),2)+"'"
			cQry += "   AND CT2_DATA BETWEEN '" + DTOS( mv_par03 ) + "' AND '" + DTOS ( mv_par04 ) + "' "
			cQry += "   AND CT2.D_E_L_E_T_='' "
			cQry += " UNION ALL "
			cQry += "SELECT CT2_FILIAL,CT2_KEY,CT2_ROTINA,CT2_LP,CT2_LINHA,CT2_NODIA,CT2_SEGOFI,CT2_DEBITO,CT2_CREDIT,CT2_VALOR,CT2_HIST,CT2_DATA"
			cQry += "  FROM " + RetSqlName("CT2") + " CT2"
			cQry += " WHERE CT2_SEGOFI = '" + aCUOsCta[np][1] + "'"
			cQry += "   AND CT2_FILIAL BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"
			cQry += "   AND CT2_CREDIT<>''"
			cQry += "   AND CT2_CREDIT<>'"+cCtaCtb+"'"
			cQry += "   AND ( SUBSTRING(CT2_CREDIT,1,1)<>'9' AND SUBSTRING(CT2_CREDIT,1,2)<>'79' )"
			cQry += "   AND CT2_VALOR>0"
			cQry += "   AND CT2_MOEDLC='"+strzero(val(MV_PAR09),2)+"'"
			cQry += "   AND CT2_DATA BETWEEN '" + DTOS( mv_par03 ) + "' AND '" + DTOS ( mv_par04 ) + "' "
			cQry += "   AND CT2.D_E_L_E_T_='' "
			cQry += " ORDER BY CT2_FILIAL,CT2_DATA,CT2_SEGOFI"
				
			dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQry ), hAlias,.T.,.T.) 
			
			if (hAlias)->( !Eof() )
			
				while (hAlias)->( !Eof() )
				
					aDtaOrigen := {}
					aDtaOrigen := ObtInfo((hAlias)->CT2_KEY,(hAlias)->CT2_LP)
					cCodUniOpe := Alltrim((hAlias)->CT2_LINHA)
					cContCtb := Iif( empty((hAlias)->CT2_CREDIT),(hAlias)->CT2_DEBITO,(hAlias)->CT2_CREDIT )
					cNumCorre := (hAlias)->CT2_SEGOFI
					cGlosa := (hAlias)->CT2_HIST
					
					If CT1->(dBSeek(xFilial("CT1") + cContCtb))
						cNomCon := Substr(CT1->CT1_DESC01,1,21)
					Endif                  
					
					Aadd( aCuentas, {	cCodUniOpe			,;							// 01
										cContCtb			,;							// 02
										cNomCon				,;							// 03
										(hAlias)->CT2_VALOR	,;							// 04
										cNumCorre			,;							// 05
										if(empty((hAlias)->CT2_CREDIT),"D","C"),;		// 06
										(hAlias)->CT2_CREDIT	,;						// 07
										(hAlias)->CT2_DEBITO	,;						// 08
										aDtaOrigen[1][3]	,;							// 09 - nombre
										aDtaOrigen[1][4]	,;							// 10 - tipo documento
										aDtaOrigen[1][5]	,;							// 11 - ruc
										aDtaOrigen[1][6]	,;							// 12 - dni
										aDtaOrigen[1][7]	,;							// 13 - ORDEN PAGO
										cGlosa				,;							// 14 - glosa 
										aCUOsCta[np][2]		,;							// 15 - valor cuenta
										aCUOsCta[np][3]		,;							// 16 - linea
										aCUOsCta[np][4]		,;							// 17 - C o D
										(hAlias)->CT2_DATA	,;							// 18 - FECHA
										aDtaOrigen[1][8]	,;							// 19 - TIPO DOC SE5
										aDtaOrigen[1][9]	,;							// 20 - MOEDA SE5
										aCUOsCta[np][11]	;							// 21 - FILIAL
					}  )
										
					(hAlias)->(DbSkip())
					
				End
			
			EndIf	
			
			(hAlias)->( dbCLoseArea() )

		Next np
		
		nTasa := 1

		if len(aCuentas)>0
		
			for nX := 1 to len(aCuentas)
			
				nPosEquiv := PIX_EQUIVALENTE
				cCodUniOpe := aCuentas[nX][1]
				nValDeu	  := 0
				nValAcre  := 0
						
				For nInc := 1 To Len( aEquivale )
			
					aVert		:= { 5, PIX_INICIAL_VALORES }
					
					If nInc > 1
						nPosEquiv 	+= PIX_DIF_COLUNA_VALORES
					EndIf
					
			    	If aEquivale[nInc] == "CT2_CREDIT"
						olReport:Say( olReport:Row(), nPosEquiv, aCuentas[nX][2], oFont )
					ElseIf aEquivale[nInc] == "CT1_DESC01"
						olReport:Say( olReport:Row(), nPosEquiv, aCuentas[nX][3], oFont )
					Else
						if aEquivale[nInc] == "E5_TIPO" .and. cPaisLoc == "PER"
							If !Empty(aCuentas[nX][19])
								cTipPer := Posicione("FR0",1 ,xFilial("FR0") + "PE1" + aCuentas[nX][19], "FR0_CHVAUX")
							Else
								cTipPer := Posicione("FR0",1 ,xFilial("FR0") + "PE1" + aCuentas[nX][20], "FR0_CHVAUX")
							EndIf
							If Empty(cTipPer)
								cTipPer := PadR("999",TamSX3("FR0_CHVAUX")[1]) //Outros
							EndIf
							olReport:Say( Iif(olReport:Row() = 0, 330, olReport:Row()) , nPosEquiv, PadC(cTipPer,21),  oFont )
						Elseif aEquivale[nInc] == "E5_NODIA" .and. cPaisLoc == "PER"
							cNumCorre := aCuentas[nX][5]
							olReport:Say( Iif(olReport:Row() = 0, 330, olReport:Row()) , nPosEquiv,Substr( cNumCorre,1,21), oFont )
						Elseif aEquivale[nInc] == "E5_MOEDA" .and. cPaisLoc == "PER"
						Elseif aEquivale[nInc] == "E5_HISTOR" .and. cPaisLoc == "PER"
							olReport:Say( Iif(olReport:Row() = 0, 330, olReport:Row()) , nPosEquiv,Substr( aCuentas[nX][14],1,21), oFont )
						Elseif aEquivale[nInc] == "E5_BENEF"
							olReport:Say( Iif(olReport:Row() = 0, 330, olReport:Row()) , nPosEquiv,Substr( aCuentas[nX][9],1,21), oFont )
						Elseif aEquivale[nInc] == "E5_NUMERO"
							olReport:Say( Iif(olReport:Row() = 0, 330, olReport:Row()) , nPosEquiv,Substr( aCuentas[nX][13],1,21), oFont )
						Else
							//olReport:Say( Iif(olReport:Row() = 0, 330, olReport:Row()) , nPosEquiv,Substr( PER->&( aEquivale[nInc] ),1,21), oFont )
						Endif
						If aEquivale[nInc] == "E5_VALOR" .and. nInc <= 10
							if aCuentas[nX][6]=="C"
								olReport:Say( olReport:Row(), nPosEquiv-300, Transform( aCuentas[nX][4], "@E 999,999,999.99"), oFont )
								nTotDeb	  += aCuentas[nX][4]
							Else
								olReport:Say( olReport:Row(), nPosEquiv + 50, Transform( aCuentas[nX][4], "@E 999,999,999.99"), oFont )
								nTotCre	  += aCuentas[nX][4]
							Endif
						EndIf
						If aEquivale[nInc] == "E5_DATA"
							olReport:Say( olReport:Row(), nPosEquiv, DTOC(STOD( aCuentas[nX][18] ) ), oFont )
						EndIf
					Endif
				
				Next nInc

				If aCuentas[nX][17]=="C"
					nValDeu	  := aCuentas[nX][15]
				Else
					nValAcre  := aCuentas[nX][15]
				Endif

				nIniDin	:= 0
			
				For nInc := 1 To Len(aEquivale)
					nIniDin += PIX_DIF_COLUNA_VALORES
					aAdd( aVert, nIniDin )
				Next
			
				nLimitrofe := nIniDin
				olReport:Box(olReport:Row(),olReport:Col(), olReport:Row(), nLimitrofe )
			
				// Imprime a linhas verticais e passa para proxima linha
			
				FR122Prnt( olReport, aVert )
				olReport:SkipLine( 1 )
				
			next nX
			
		endif
			
		DbSelectArea("PER")
		PER->( DbSkip() )
	
		nPag++				// Quantidade de registros por pagina
		nReg++				// Quantidade de registros impressos
		
	    If PER->A6_COD + PER->A6_AGENCIA + PER->A6_NUMCON <> cBanMov + cAgeMov + cConMov
			Do case
			case PER->A6_NUMCON <> cConMov 	// total conta
				nTotDeb_A = nTotDeb_A + nTotDeb                           	// acumula no total da Agencia
				nTotCre_A = nTotCre_A + nTotCre
	
				olReport:Box(olReport:Row(),10,olReport:Row(),3000)
				FR122Prnt( olReport, {0,5,300,600,1200,1500,1800,2100,2400,2700,3000} )
				olReport:Say(olReport:Row(),610,STR0036 + DtoC(MV_PAR04),oFont)
				If nTotDeb > nTotCre
					//nSalIni += (nTotDeb - nTotCre)
					nSalIni -= (nTotDeb - nTotCre)
				Else
					//nSalIni -= (nTotCre - nTotDeb)
					nSalIni += (nTotCre - nTotDeb)
				EndIf
				olReport:Say(olReport:Row(),IIf(nSalIni <= 0,2410,2710),Transform(IIf(nSalIni > 0,nSalIni,nSalIni * -1),"@E 9999,999,999,999.99"),oFont)
				nSalIni := 0
				olReport:SkipLine( 1 )
				olReport:Box(olReport:Row(),10,olReport:Row(),3000)
	
				fTotR122(olReport, STR0029, nTotDeb, nTotCre)
				olReport:EndPage()
				lNext := .T.
				nPag := 0
		      	nTotDeb := 0
		      	nTotCre := 0
	        	// imprime total agencia
			case PER->A6_AGENCIA <> cAgeMov .and. PER->A6_NUMCON <> cConMov
				nTotDeb_B = nTotDeb_B + Iif(nTotDeb_A = 0, nTotdeb, nTotDeb_A)
				nTotCre_B = nTotCre_B + Iif(nTotCre_A = 0, nTotCre, nTotCre_A)
	
				olReport:Box(olReport:Row(),10,olReport:Row(),3000)
				FR122Prnt( olReport, {0,5,300,600,1200,1500,1800,2100,2400,2700,3000} )
				olReport:Say(olReport:Row(),610,STR0036 + DtoC(MV_PAR04),oFont)
				If nTotDeb_A > nTotCre_A
					//nSalIni += (nTotDeb_A - nTotCre_A)
					nSalIni -= (nTotDeb_A - nTotCre_A)
				Else
					//nSalIni -= (nTotCre_A - nTotDeb_A)
					nSalIni += (nTotCre_A - nTotDeb_A)
				EndIf
				olReport:Say(olReport:Row(),IIf(nSalIni <= 0,2410,2710),Transform(IIf(nSalIni > 0,nSalIni,nSalIni * -1),"@E 9999,999,999,999.99"),oFont)
				nSalIni := 0
				olReport:SkipLine( 1 )
				olReport:Box(olReport:Row(),10,olReport:Row(),3000)
	
				If nTotDeb_A + nTotCre_A > 0  																	// caso conta e agencia sejam diferentes
					fTotR122(olReport, STR0030, nTotDeb_A, nTotCre_A)
				Endif
				olReport:EndPage()
				lNext := .T.
				nPag := 0
				nTotDeb_A := 0
	       		nTotCre_A := 0
		      	nTotDeb := 0
		      	nTotCre := 0
				// Imprime total do Banco
			case PER->A6_COD <> cBanMov .and. PER->A6_AGENCIA <> cAgeMov .and. PER->A6_NUMCON <> cConMov
				nTotDeb_T = nTotDeb_T + nTotDeb_B
				nTotCre_T = nTotCre_T + nTotCre_B
	
				olReport:Box(olReport:Row(),10,olReport:Row(),3000)
				FR122Prnt( olReport, {0,5,300,600,1200,1500,1800,2100,2400,2700,3000} )
				olReport:Say(olReport:Row(),610,STR0036 + DtoC(MV_PAR04),oFont)
				If nTotDeb_B > nTotCre_B
					//nSalIni += (nTotDeb_B - nTotCre_B)
					nSalIni -= (nTotDeb_B - nTotCre_B)
				Else
					//nSalIni -= (nTotCre_B - nTotDeb_B)
					nSalIni += (nTotCre_B - nTotDeb_B)
				EndIf
				olReport:Say(olReport:Row(),IIf(nSalIni <= 0,2410,2710),Transform(IIf(nSalIni > 0,nSalIni,nSalIni * -1),"@E 9999,999,999,999.99"),oFont)
				nSalIni := 0
				olReport:SkipLine( 1 )
				olReport:Box(olReport:Row(),10,olReport:Row(),3000)
	
				If nTotDeb_B <> nTotDeb_A
					fTotR122(olReport, STR0019, nTotDeb_B, nTotCre_B)
					olReport:EndPage()
					lNext := .T.
					nPag := 0
					nTotDeb_B := 0
		        	nTotCre_B := 0
				Endif
		      	nTotDeb := 0
		      	nTotCre := 0
			Endcase
		EndIf
	
		If nPag > 55
			olReport:EndPage()
			nPag := 0
		EndIf
		
	End
	
	olReport:IncMeter()
	
	If nTotDeb + nTotCre <> 0
		FTotR122(olReport, STR0019, nTotDeb, nTotCre)
	Endif
	
	PER->( DbCLoseArea() )
	
Return()

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณFCabR122  ณ Autor ณ Totvs                 ณ Data | 06/05/10 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณCabe็alho do relatorio.								      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณFCabR122(Expo1,ExpN1,ExpA1)  				                  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณExpO1 = Objeto tReport                                      ณฑฑ
ฑฑณ          ณExpN1 = Posi็ใo da coluna de impressใo                      ณฑฑ
ฑฑณ          ณExpA1 = Array com as contas do ativo                        ณฑฑ
ฑฑณ          ณExpA2 = Array com as contas do passivo                      ณฑฑ
ฑฑณ          ณExpA3 = Array com as contas de patrimonio                   ณฑฑ
ฑฑณ          ณExpA4 = Array com as contas de gasto                        ณฑฑ
ฑฑณ          ณExpA5 = Array com as contas de receita                      ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FCabR122( olReport, nCol, aColFin, aColFin2, aColFin3 )

	Local nInc			:= 0
	Local nColPix		:= olReport:Col()+10
	Local aVert			:= { olReport:Col()+ 5 , PIX_INICIAL_VALORES }
	Local nIniDin		:= PIX_INICIAL_VALORES					// Pixel redimencionado dinamicamente
	Local oFont 		:= TFont():New( "Courier New",, -08 )
	Local oFont12 		:= TFont():New( "Courier New",, -12 )
	Local nLimitrofe	:= 4850
	Local nTamPad		:= 0
	Local nCharPCol		:= 30							// Quantidade de caracteres por coluna

	nCol := olReport:Col() + 10
	
	olReport:PrintText( " " + STR0001,olReport:Row()   ,nColPix)
	olReport:SkipLine()
	olReport:PrintText( STR0004 + dToC( MV_PAR03 ) + " - " + dToC( MV_PAR04 ) ) //+ STR0033 + MV_PAR05 + STR0034 + MV_PAR06,olReport:Row()   ,nColPix) //Periodo
	olReport:PrintText( STR0005 + AllTrim( SM0->M0_CGC)											  ,olReport:Row()+35,nColPix) //RUC
	olReport:PrintText( STR0006 + " " + AllTrim(SM0->M0_NOMECOM),olReport:Row()+35,nColPix) //APELLIDOS Y NOMBRES, DENOMINACIำN O RAZำN SOCIAL:"
	olReport:PrintText( STR0007 + AllTrim( PER->A6_COD )+ "/" + AllTrim( PER->A6_AGENCIA ) + " - " + Alltrim(PER->A6_NOME) ,olReport:Row()+35,nColPix ) //ENTIDAD FINANCIERA: "
	olReport:PrintText( STR0008 + " " + Alltrim(PER->A6_NUMCON),olReport:Row()+35,nColPix ) //CำDIGO DE LA CUENTA CORRIENTE: "
	
	olReport:SkipLine( 2 )
	
	// Primeira linha
	nTamPad	:= Len( aColFin ) * nCharPCol
	
	olReport:Box( olReport:Row()-004, 600 , olReport:Row() + 034, 1800 )  								// box
	olReport:Say( olReport:Row()-003, (nColPix + 1000)  ,	STR0003 + " " + STR0009, oFont12 )			//  Operaciones Bancarias
	
	
	olReport:Box( olReport:Row()-004, 1800 , olReport:Row() + 034, 2400 )  							// box
	olReport:Say( olReport:Row()-003, (nColPix + 1800)  ,	STR0013, oFont12 )	 						//   CUENTA CONTABLE ASOCIADA
	
	olReport:Box( olReport:Row()-004, 2400 , olReport:Row() + 034, 3000 )							 	// box
	olReport:Say( olReport:Row()-004, nColPix + 2250,	 STR0016,	oFont12 )							//   SALDOS Y MOVIMIENTOS
	nIniDin += ( PIX_DIF_COLUNA_VALORES * Len( aColFin ) )
	
	aAdd( aVert, nIniDin )
	
	nLimitrofe := nIniDin
	olReport:Box(olReport:Row()-004,olReport:Col()-004, olReport:Row()+034, 600 )
	FR122Prnt( olReport, aVert )													// Imprime a linhas verticais e passa para proxima linha
	olReport:SkipLine( 1 )
	
	// Segunda linha - Imprime as contas
	
	nIniDin	:= PIX_INICIAL_VALORES
	
	For nInc := 1 To Len( aColFin )
		olReport:Say( olReport:Row(), nIniDin, PadC( Alltrim(aColFin[nInc]), 25 ), oFont )
		nIniDin += PIX_DIF_COLUNA_VALORES
		aAdd( aVert, nIniDin )
	Next
	
	FR122Prnt( olReport, aVert )														// Imprime a linhas verticais e passa para proxima linha
	olReport:SkipLine( 1 )
	
	// Terceira linha - Imprime as contas
	
	nIniDin	:= PIX_INICIAL_VALORES
	
	For nInc := 1 To Len( aColFin2 )
		olReport:Say( olReport:Row(), nIniDin, PadC( Alltrim(aColFin2[nInc]), 25 ), oFont )
		nIniDin += PIX_DIF_COLUNA_VALORES
		aAdd( aVert, nIniDin )
	Next
	
	FR122Prnt( olReport, aVert )														// Imprime a linhas verticais e passa para proxima linha
	olReport:SkipLine( 1 )
	
	nIniDin	:= PIX_INICIAL_VALORES
	
	For nInc := 1 To Len( aColFin3 )
		olReport:Say( olReport:Row(), nIniDin, PadC( Alltrim(aColFin3[nInc]), 25 ), oFont )
		nIniDin += PIX_DIF_COLUNA_VALORES
	
		aAdd( aVert, nIniDin )
	Next
	
	FR122Prnt( olReport, aVert )														// Imprime a linhas verticais e passa para proxima linha
	olReport:SkipLine( 1 )
	
	olReport:Row() := 330
Return()


/*/
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณFR122Prnt ณ Autor ณ Totvs                 ณ Data | 07/05/10 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณImprime as linhas verticais e horizontais do relatorio      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณFR122Prnt( ExpA1 )         				                  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณExpA1 = Array com as colunas                                ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FR122Prnt( olReport, aCol )
	Local nInc 		:= 1
	Local nLinPix   := 34
	
	For nInc := 1 To Len( aCol )
		olReport:Box( olReport:Row(), aCol[nInc], olReport:Row()+nLinPix, aCol[nInc] ) 			// traco vertical
	Next
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfTotR122  บAutor  ณMicrosiga           บ Data ณ  05/25/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpressao do total                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FTotR122(olReport, cDescPrt, nTotDeb_P, nTotCre_P)
	olReport:Line( olReport:Row(), PIX_EQUIVALENTE , olReport:Row(), 2100 )
  	olReport:Box( olReport:Row(), 2100 , olReport:Row() + 034, 2400 )
	olReport:Say( olReport:Row(), 2110	, cDescPrt, TFont():New( "Courier New",, -12 ) )
	olReport:Box( olReport:Row(), 2400 , olReport:Row() + 034, 2700 )
	olReport:Say( olReport:Row(), 2435	, Transform( nTotDeb_P, "@E 99,999,999,999.99"), TFont():New( "Courier New",, -08 ) )
	olReport:Box( olReport:Row(), 2700 , olReport:Row() + 034, 3000 )
	olReport:Say( olReport:Row(), 2734 , Transform( nTotCre_P, "@E 99,999,999,999.99"), TFont():New( "Courier New",, -08 ) )
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF122RetSalบAutor  ณ Pedro Pereira Lima บ Data ณ  13/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function F122RetSal(cBanco,cAgencia,cConta,dDtSal)
	Local aArea		 := GetArea()
	Local cAliasQry	 := GetNextAlias()
	Local nRetSal	 := 0

	BeginSql Alias cAliasQry
		SELECT
			MAX(SE8.E8_DTSALAT) DTSAL, SE8.E8_SALATUA SALDO
		FROM
			%Table:SE8% SE8
		WHERE
			SE8.E8_FILIAL = %Exp:xFilial("SE8")% AND
			SE8.E8_BANCO = %Exp:cBanco% AND
			SE8.E8_AGENCIA = %Exp:cAgencia% AND
			SE8.E8_CONTA = %Exp:cConta% AND
			SE8.E8_DTSALAT < %Exp:DtoS(dDtSal)% AND
			SE8.%NotDel%
		GROUP BY
			SE8.E8_SALATUA
	EndSql
	
	nRetSal := IIf((cAliasQry)->SALDO != Nil,(cAliasQry)->SALDO,0)
	
	(cAliasQry)->(dbCloseArea())
	
	RestArea(aArea)
Return nRetSal


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณZFINR122  บAutor  ณMicrosiga           บFecha ณ  10/01/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ObtInfo(ct2Key,ct2Lp)

	Local cQry := ""
	Local aCampos := {}
	Local cLinha := ""
	Local cSegOfi := ""
	Local cKeyArr := ""
	Local cKey := ""
	Local nX := 0
	Local aKey := {}
	
	SA1->( dbSetOrder(1) )
	SA2->( dbSetOrder(1) )
	
	dbSelectArea("CTL")
	dbSetOrder(1) //CTL_FILIAL + CTL_LP
	
	If CTL->(dbSeek(xFilial("CTL") + ct2Lp))
		cKeyArr := CTL->CTL_KEY
	EndIf
	
	If !Empty(cKeyArr) 
		aCampos := StrTokArr( cKeyArr, "+" )
	EndIf
	
	If ct2Lp $ "575/576"	
	
		nPos := 1
		
		cQry := "SELECT EL_FILIAL,EL_CLIENTE,EL_LOJA,EL_RECIBO,EL_MOEDA,EL_TIPO "
	    cQry += " FROM " + RetSqlName("SEL") 
	    cQry += " WHERE D_E_L_E_T_='' "
		
		For nX := 1 To Len(aCampos)
			cQry += " AND " + alltrim(aCampos[nX]) + "='" + substr(ct2Key,nPos,TamSx3(aCampos[nX])[1] ) + "'"
			nPos += TamSx3(aCampos[nX])[1]
		Next nX
	    
	    If Select("TRBSEK") > 1
			TRBSEK->( DbCLoseArea() )
		EndIf
		
		dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQry ), "TRBSEK",.T.,.T.) 
		
		DbSelectArea( "TRBSEK" )
		TRBSEK->( DbGoTop() )
		
		if TRBSEK->( !Eof() )
			Aadd( aKey, { TRBSEK->EL_CLIENTE	,;
						  TRBSEK->EL_LOJA		,; 
						  Posicione("SA1",1,xFilial("SA1")+TRBSEK->EL_CLIENTE+TRBSEK->EL_LOJA,"A1_NOME")	,;
						  Posicione("SA1",1,xFilial("SA1")+TRBSEK->EL_CLIENTE+TRBSEK->EL_LOJA,"A1_TIPDOC")	,;
						  Posicione("SA1",1,xFilial("SA1")+TRBSEK->EL_CLIENTE+TRBSEK->EL_LOJA,"A1_CGC")		,;
						  Posicione("SA1",1,xFilial("SA1")+TRBSEK->EL_CLIENTE+TRBSEK->EL_LOJA,"A1_PFISICA")	,;
						  TRBSEK->EL_RECIBO		,;
						  TRBSEK->EL_TIPO		,;
						  TRBSEK->EL_MOEDA		;
			} )
		else
			Aadd( aKey, { "" ,;
						  "" ,; 
						  "" ,;
						  "" ,;
						  "" ,;
						  "" ,;
						  "" ,;
						  "" ,;
						  "" ;
			} )
		Endif
		
	ElseIf ct2Lp $ "570/571"

		// EK_FILIAL+EK_ORDPAGO+EK_TIPODOC+EK_PREFIXO+EK_NUM+EK_PARCELA+EK_TIPO 
		nPos := 1
		
		cQry := "SELECT EK_FILIAL,EK_FORNECE,EK_LOJA,EK_ORDPAGO,EK_MOEDA,EK_TIPO "
	    cQry += " FROM " + RetSqlName("SEK") 
	    cQry += " WHERE D_E_L_E_T_='' "
		For nX := 1 To Len(aCampos)
			cQry += " AND " + alltrim(aCampos[nX]) + "='" + substr(ct2Key,nPos,TamSx3(aCampos[nX])[1] ) + "'"
			nPos += TamSx3(aCampos[nX])[1]
		Next nX
	    
	    If Select("TRBSEK") > 1
			TRBSEK->( DbCLoseArea() )
		EndIf
		
		dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQry ), "TRBSEK",.T.,.T.) 
		
		DbSelectArea( "TRBSEK" )
		TRBSEK->( DbGoTop() )
		
		if TRBSEK->( !Eof() )
			Aadd( aKey, { TRBSEK->EK_FORNECE	,;
						  TRBSEK->EK_LOJA		,; 
						  Posicione("SA2",1,xFilial("SA2")+TRBSEK->EK_FORNECE+TRBSEK->EK_LOJA,"A2_NOME")	,;
						  Posicione("SA2",1,xFilial("SA2")+TRBSEK->EK_FORNECE+TRBSEK->EK_LOJA,"A2_TIPDOC")	,;
						  Posicione("SA2",1,xFilial("SA2")+TRBSEK->EK_FORNECE+TRBSEK->EK_LOJA,"A2_CGC")		,;
						  Posicione("SA2",1,xFilial("SA2")+TRBSEK->EK_FORNECE+TRBSEK->EK_LOJA,"A2_PFISICA")	,;
						  TRBSEK->EK_ORDPAGO	,;
						  TRBSEK->EK_TIPO		,;
						  TRBSEK->EK_MOEDA		;
			} )
		else
			Aadd( aKey, { "" ,;
						  "" ,; 
						  "" ,;
						  "" ,;
						  "" ,;
						  "" ,;
						  "" ,;
						  "" ,;
						  "" ;
			} )
		Endif
	
	ElseIf ct2Lp $ "560/561|562/563|564/565"	// TB salida-pagar / entrada-cobrar
	
		//E5_FILIAL+DTOS(E5_DATA)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ
		nPos := 1
		
		cQry := "SELECT E5_FILIAL,E5_DTDIGIT,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_NUMCHEQ,E5_DOCUMEN,E5_RECPAG,E5_HISTOR,E5_TIPO,E5_MOEDA,E5_CLIFOR"
	    cQry += " FROM " + RetSqlName("SE5") 
	    cQry += " WHERE D_E_L_E_T_='' "
	    if ct2Lp$"561/563/565"		// receber
	    	cQry += " AND E5_RECPAG='R'"
	    else
	    	cQry += " AND E5_RECPAG='P'"
	    endif
		For nX := 1 To Len(aCampos)
			if "DTOS"$aCampos[nX]
				aCampos[nX] := strTran(aCampos[nX],"DTOS(","")
				aCampos[nX] := strTran(aCampos[nX],")","")
			endif
			cQry += " AND " + alltrim(aCampos[nX]) + "='" + substr(ct2Key,nPos,TamSx3(aCampos[nX])[1] ) + "'"
			nPos += TamSx3(aCampos[nX])[1]
		Next nX
	    
	    If Select("TRBSEK") > 1
			TRBSEK->( DbCLoseArea() )
		EndIf
		
		dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQry ), "TRBSEK",.T.,.T.) 
		
		DbSelectArea( "TRBSEK" )
		TRBSEK->( DbGoTop() )
		
		if TRBSEK->( !Eof() )
		
			cNomMov := PER->A6_NOME
			cDocMov := PER->A6_CGC
			
			if !empty(TRBSEK->E5_CLIFOR)
				if TRBSEK->E5_RECPAG=="R"
					if SA1->( dbSeek( xFilial("SA1")+TRBSEK->E5_CLIFOR ) )
						cNomMov := SA1->A1_NOME
						cDocMov := if(!EMPTY(SA1->A1_CGC),SA1->A1_CGC,SA1->A1_PFISICA)
					endif
				else
					if SA2->( dbSeek( xFilial("SA2")+TRBSEK->E5_CLIFOR ) )
						cNomMov := SA2->A2_NOME
						cDocMov := if(!EMPTY(SA2->A2_CGC),SA2->A2_CGC,SA2->A2_PFISICA)
					endif
				endif
			endif
		
			Aadd( aKey, { cNomMov				,;
						  ""					,; 
						  cNomMov				,;
						  "6"					,;
						  cDocMov				,;
						  ""					,;
						  iif(empty(TRBSEK->E5_DOCUMEN),TRBSEK->E5_NUMCHEQ,TRBSEK->E5_DOCUMEN)	,;
						  TRBSEK->E5_TIPO		,;
						  TRBSEK->E5_MOEDA		;
			} )

		else
			Aadd( aKey, { "" ,;
						  "" ,; 
						  "" ,;
						  "" ,;
						  "" ,;
						  "" ,;
						  "" ,;
						  "" ,;
						  "" ;
			} )
		Endif	
		
	else

		Aadd( aKey, { "" ,;
					  "" ,; 
					  "" ,;
					  "" ,;
					  "" ,;
					  "" ,;
					  "" ,;
					  "" ,;
					  "" ;
		} )
	
	EndIf
	
	If Select("TRBSEK") > 1
		TRBSEK->( DbCLoseArea() )
	Endif
	
Return( aKey )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณZFINR122  บAutor  ณMicrosiga           บFecha ณ  10/03/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fSekOrdRec( cIdFil, cIdDoc, cRecPag )

	local dArea		:= getArea()
	local cQry		:= ""
	local _cAlias	:= getNextAlias()
	local nX		:= 0
	
	if cRecPag=="R"
	
		cQry := "SELECT EL_RECIBO,EL_CLIENTE, COUNT(*) NCONT FROM "+RetSqlName("SEL")
		cQry += " WHERE EL_FILIAL='"+cIdFil+"'"
		cQry += "   AND EL_RECIBO='"+cIdDoc+"'"
		cQry += "   AND EL_TIPO='NF'"
		cQry += "   AND D_E_L_E_T_=''"
		cQry += " GROUP BY EL_RECIBO,EL_CLIENTE"

		dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQry ), _cAlias,.T.,.T.)
	
		if (_cAlias)->(!eof())
			while (_cAlias)->(!eof())
				nX++
				(_cAlias)->( dbSkip() )
			end
		endif

		(_cAlias)->( dbCloseArea() )	
	
	else
	
		cQry := "SELECT EK_ORDPAGO,EK_FORNECE,COUNT(*) NCONT FROM "+RetSqlName("SEK")
		cQry += " WHERE EK_FILIAL='"+cIdFil+"'"
		cQry += "   AND EK_ORDPAGO='"+cIdDoc+"'"
		cQry += "   AND EK_TIPO='NF'"
		cQry += "   AND D_E_L_E_T_=''"
		cQry += " GROUP BY EK_ORDPAGO,EK_FORNECE"
			
		dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQry ), _cAlias,.T.,.T.)
			
		if (_cAlias)->(!eof())
			while (_cAlias)->(!eof())
				nX++
				(_cAlias)->( dbSkip() )
			end
		endif
			
		(_cAlias)->( dbCloseArea() )
		
	endif
	
	restArea(dArea)
	
Return( if(nX>1,"VARIOS","") )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGerArq    บAutor  ณ Luis Enrํquez      บ Data ณ  17/04/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funci๓n para generar archivo plano de Libro Caja y Bancos. บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณSintaxe   ณGerArq(cDir)			  				                      ณฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณParametrosณcDir = Direcci๓n donde serแ creado archivo.                 ณฑฑ
ฑฑณ          ณcArchivo = Nombre y extensi๓n de archivo a generar.         ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑบUso       ณ FINR122                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GerArq(cDir)

	Local nHdl		:= 0
	Local nPos		:= 0
	Local cLinea	:= ""
	Local cCRLF		:= (chr(13)+chr(10))
	Local nTotDatos	:= 0
	Local vsql		:= ""
	Local aRegb
	local aCuentas	:= {}
	local aOtros	:= {}
	Local cTmpCT1Fil:= ""
	local lprnOtros	:= .t.
	local aDatCt2	:= {}
	local cCtaCtb	:= ""
	Local aSelFil	:= {}
	Local nTasa    := 1
	Local cPeriodo      := AllTrim(StrZero(Year(MV_PAR03),4)) + AllTrim(StrZero(Month(MV_PAR03),2)) + "00"
	Local cEdoOpe       := "1"
	Local cCodEntFin    := ""
	Local cCtaBanCon    := ""
	Local cFechaOpe     := ""
	Local cDesOpeBan    := ""
	Local cNumTraBan    := ""
	Local cTipoDoc      := ""
	Local cTipo         := ""
	Local cBenef        := ""
	Local nValDeu       := 0
	Local cNumDoc       := ""
	Local cNumCorre     := ""
	Local cCodUniOpe    := ""
	Local nTotDatos     := 0
	Local lMoeda := IIf(alltrim(MV_PAR09)$'01|1',.T.,.F.)
	local aCuentas		:= {}
	local aOtros		:= {}
	Local cTmpCT1Fil	:= ""
	local lprnOtros		:= .t.
	local cCtaCtb		:= ""

	vsql := "SELECT A6_COD,A6_AGENCIA,A6_NUMCON,A6_CONTA,A6_NOME,A6_IDFIN,A6_CGC"
	vsql += "  FROM "+RetSqlName("SA6")
	vsql += " WHERE A6_FILIAL='"+xFilial("SA6")+"'"
	vsql += "   AND A6_COD NOT IN "+Formatin(cBanco,"/")
	vsql += "   AND A6_CONTA<>''"
	
	If Select("PER") > 1
		PER->( DbCLoseArea() )
	Endif
	
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, vsql ), "PER",.T.,.T.)

	DbSelectArea( "PER" )
	PER->( DbGoTop() )
	
	nTotDeb	  := 0
	nTotCre	  := 0
	nValDeu  := 0
	nValAcre := 0
	
	While PER->(!Eof())
	
		aCuentas := {}
		cBenef := ""
		cBanMov := PER->A6_COD
		cConMov := PER->A6_NUMCON
		cAgeMov := PER->A6_AGENCIA
		cNomCon  := ""
		cContCtb := ""
		cCodEntFin := PER->A6_IDFIN
		cCtaBanCon := PER->A6_NUMCON
		cFechaOpe  := SPACE(8)
		cDesOpeBan := ""
		cNumTraBan := ""
		//cCtaCajas := fgetCajas(cBanco)
		cNumCorre := ""
		cCodUniOpe := ""
		lVerCorr := .F.
		lSoloSE5 := .f.
		aCUOsCta := {}
		aCUOsCta := getCUOs(PER->A6_CONTA)
		
		if len(aCUOsCta) > 0

			for np := 1 to len(aCUOsCta)

				aDtaOrigen := {}
				aDtaOrigen := ObtInfo(aCUOsCta[np][5],aCUOsCta[np][6])
				cCodUniOpe := Alltrim(aCUOsCta[np][3])
				cContCtb := Iif( empty(aCUOsCta[np][7]),aCUOsCta[np][8],aCUOsCta[np][7] )
				cNumCorre := aCUOsCta[np][1]
				cGlosa := aCUOsCta[np][9]
						
				If CT1->(dBSeek(xFilial("CT1") + cContCtb))
					cNomCon := Substr(CT1->CT1_DESC01,1,21)
				Endif
				
				If !Empty(aDtaOrigen[1][8])
					aDtaOrigen[1][8] := Posicione("FR0",1 ,xFilial("FR0") + "PE1" + aDtaOrigen[1][8], "FR0_CHVAUX")
				Else
					aDtaOrigen[1][8] := PadR("999",TamSX3("FR0_CHVAUX")[1]) //Outros
				EndIf
						
				Aadd( aCuentas, {	cCodUniOpe			,;							// 01
									cContCtb			,;							// 02
									cNomCon				,;							// 03
									aCUOsCta[np][2]		,;							// 04
									cNumCorre			,;							// 05
									if(empty(aCUOsCta[np][7]),"D","C"),;			// 06
									aCUOsCta[np][7]		,;							// 07
									aCUOsCta[np][8]		,;							// 08
									aDtaOrigen[1][3]	,;							// 09 - nombre
									aDtaOrigen[1][4]	,;							// 10 - tipo documento
									aDtaOrigen[1][5]	,;							// 11 - ruc
									aDtaOrigen[1][6]	,;							// 12 - dni
									aDtaOrigen[1][7]	,;							// 13 - ORDEN PAGO
									cGlosa				,;							// 14 - glosa 
									aCUOsCta[np][2]		,;							// 15 - valor cuenta
									aCUOsCta[np][3]		,;							// 16 - linea
									aCUOsCta[np][4]		,;							// 17 - C o D
									aCUOsCta[np][10]	,;							// 18 - FECHA
									aDtaOrigen[1][8]	,;							// 19 - TIPO DOC SE5
									aDtaOrigen[1][9]	,;							// 20 - MOEDA SE5
									aCUOsCta[np][11]	;							// 21 - FILIAL
				}  )
											
		
			Next np
			
		endif
			
		if len(aCuentas)>0
		
			for nX := 1 to len(aCuentas)

				if aScan(aRenglon,{|x| x[3] == aCuentas[nX][5] .And. x[16] == aCuentas[nX][1] }) == 0

					c2Benef := alltrim(fSekOrdRec(aCuentas[nX][21],aCuentas[nX][7],if(aCuentas[nX][6]=="C","P","R")))
					cTipoDoc := aCuentas[nX][10]
					cNumDoc := aCuentas[nX][11]
					cBenef := aCuentas[nX][9]
					
					If aCuentas[nX][6]=="D"
						nValDeu	  := aCuentas[nX][15]
						nValAcre  := 0
					Else
						nValDeu	  := 0
						nValAcre  := aCuentas[nX][15]
					Endif
					
					if empty(aCuentas[nX][11])
						aCuentas[nX][11] := aCuentas[nX][12]		// IDENTIFICA SI EL RUC ES VACIO, ENTONCES AGARRA EL DNI PARA CASO NO DOMICILIADOS
					endif
					
					aAdd(aRenglon,{	cPeriodo,;											// 01
									"M"+aCuentas[nX][1],;								// 02
									aCuentas[nX][5],;									// 03
									cCodEntFin,;										// 04
									cCtaBanCon,;										// 05
									aCuentas[nX][18],;									// 06
									Alltrim(aCuentas[nX][19]),;							// 07
									Alltrim(aCuentas[nX][14]),;							// 08
									iif(empty(c2Benef),Alltrim(aCuentas[nX][10]),"-"),;			// 09
									iif(empty(c2Benef),Alltrim(aCuentas[nX][11]),"-"),;			// 10	 - RUC
									iif(empty(c2Benef),Alltrim(cBenef),c2Benef),;		// 11
									alltrim(aCuentas[nX][13]),;							// 12
									Alltrim(Str(nValDeu,12,2)),;						// 13
						   			Alltrim(Str(nValAcre,12,2)),;						// 14
						   			cEdoOpe,;											// 15
						   			aCuentas[nX][1];									// 16
					})

				endif
			
			next nX
			
		endif
			
		DbSelectArea("PER")
		PER->( DbSkip() )
		
	End
	
	PER->( DbCLoseArea() )
	
	FOR nCont:=LEN(ALLTRIM(cDir)) TO 1 STEP -1
		IF SUBSTR(cDir,nCont,1)=='\'
			cDir:=Substr(cDir,1,nCont)
			EXIT
		ENDIF
	NEXT
	
	//---------------------------------//
	//nombre del archivo               // 
	//LERRRRRRRRRRRAAAAMM0001020000OIM1//
	//123456789012345678901234567890123//
	//---------------------------------//
	cArchivo := ""
	cArchivo += "LE"                                  // Fijo  'LE'
	cArchivo +=  AllTrim(SM0->M0_CGC)                 // RUC
	cArchivo +=  AllTrim(StrZero(Year(MV_PAR03),4))   // Ano
	cArchivo +=  AllTrim(StrZero(Month(MV_PAR03),2))  // Mes
	cArchivo += "00"                                  // Fixo '00'
	cArchivo += "010200"                              // Fixo '010200'
	cArchivo += "00"                                  // Fixo '00'
	cArchivo += "1"                                   // Fixo 'O' - 0-cierre de operaciones 1-empresa operativa 2-cierre de libro
	If len(aRenglon) > 0
		cArchivo += "1" 
	Else
		cArchivo += "0"
	EndIf
	cArchivo += Alltrim(Str(val(MV_PAR09)))+"1"		  // 1 -soles 2-doalres
	cArchivo += ".TXT"                                // Extensao	

	nHdl := fCreate(cDir + cArchivo,nil,nil,.f.)
	
	If nHdl <= 0
		ApMsgStop(STR0041) // "Ocurri๓ un error generar archivo TXT de Libro Caja y Bancos."
		Return
	endif
	
	For nPos := 1 To Len(aRenglon)
		cLinea :=	aRenglon[nPos][1] + "|" +;									// 01 - periodo
					aRenglon[nPos][3] + "|" +;									// 02 - correlativo CUO
					aRenglon[nPos][2] + "|" +;									// 03 - nro linea CT2_LINHA
					aRenglon[nPos][4] + "|" +;									// 04 - entidad financiera A6_IDFIN
					alltrim(aRenglon[nPos][5]) + "|" +;							// 05 - cuenta banco
					dtoc(stod(aRenglon[nPos][6])) + "|" +;						// 06 - fecha de la operacion
					aRenglon[nPos][7] + "|" +;									// 07 - modo de pago
					aRenglon[nPos][8] + "|" +;									// 08 - descripcion de la operacion bancaria - glosa CT2_HIST
					if(alltrim(aRenglon[nPos][9])=="-",aRenglon[nPos][9],alltrim(str(val(aRenglon[nPos][9])))) + "|" +;			// 09 - tipo de documento
					if(empty(aRenglon[nPos][10]),"00000000000",aRenglon[nPos][10]) + "|" +;										// 10 - RUC de la entidad
					if(empty(aRenglon[nPos][11]),"-",aRenglon[nPos][11]) + "|" +;												// 11 - Nombre o razon social
					if(empty(aRenglon[nPos][12]),"000000",aRenglon[nPos][12]) + "|" +;											// 12 - numero del documento
					aRenglon[nPos][13] + "|" +;									// 13 - valor debito
					aRenglon[nPos][14]  + "|" +;								// 14 - valor credito
					aRenglon[nPos][15] + "|" + cCRLF							// 15
		fWrite(nHdl,cLinea)
	Next nPos
	MsgAlert(STR0042 + cArchivo + STR0043 + Alltrim(cDir)) //"Archivo plano " //" de Libro Caja y Bancos generado con exito, en ruta "
	fClose(nHdl)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณZFINR122  บAutor  ณMicrosiga           บFecha ณ  10/13/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fgetCajas(cCajas)

	local vArea := getArea()
	local cQry := ""
	local jalias := getNextAlias()
	local cCContab := ""

	cQry := "SELECT A6_CONTA"
	cQry += "  FROM " + RetSqlName("SA6") 
	cQry += " WHERE A6_FILIAL='"+xFilial("SA6")+"'"
	cQry += "   AND A6_COD IN "+Formatin(cCajas,"/")+""
	cQry += "   AND D_E_L_E_T_='' "
					
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQry ), Jalias,.T.,.T.) 
					
	if (jalias)->( !Eof() )
		while (jalias)->( !Eof() )
			cCContab += alltrim((jalias)->A6_CONTA)+"|"
			(jalias)->( dbSkip() )
		end
	endif
	
	(jalias)->( dbCloseArea() )
	
	RestArea(vArea)

Return(cCContab)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณZFINR122  บAutor  ณMicrosiga           บFecha ณ  10/19/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function getCUOs(xCtaCtb)

	local _vArea  := getArea()
	local _vAlias := getNextAlias()
	local _aCuosg := {}

	cQry := "SELECT CT2_FILIAL,CT2_KEY,CT2_ROTINA,CT2_LP,CT2_LINHA,CT2_NODIA,CT2_SEGOFI,CT2_DEBITO,CT2_CREDIT,CT2_VALOR,CT2_NODIA,CT2_DATA,CT2_HIST"
	cQry += "  FROM " + RetSqlName("CT2") 
	cQry += " WHERE CT2_FILIAL BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"
	cQry += "   AND CT2_DEBITO<>''"
	cQry += "   AND CT2_DEBITO='"+xCtaCtb+"'"
	cQry += "   AND ( SUBSTRING(CT2_DEBITO,1,1)<>'9' AND SUBSTRING(CT2_DEBITO,1,2)<>'79')"
	cQry += "   AND CT2_VALOR>0"
	cQry += "   AND CT2_MOEDLC='"+strzero(val(MV_PAR09),2)+"'"
	cQry += "   AND D_E_L_E_T_='' "
	cQry += "   AND CT2_DATA BETWEEN '" + DTOS( mv_par03 ) + "' AND '" + DTOS ( mv_par04 ) + "' "
	cQry += " UNION ALL "
	cQry += "SELECT CT2_FILIAL,CT2_KEY,CT2_ROTINA,CT2_LP,CT2_LINHA,CT2_NODIA,CT2_SEGOFI,CT2_DEBITO,CT2_CREDIT,CT2_VALOR,CT2_NODIA,CT2_DATA,CT2_HIST"
	cQry += "  FROM " + RetSqlName("CT2") 
	cQry += " WHERE CT2_FILIAL BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"
	cQry += "   AND CT2_CREDIT<>''"
	cQry += "   AND CT2_CREDIT='"+xCtaCtb+"'"
	cQry += "   AND ( SUBSTRING(CT2_CREDIT,1,1)<>'9' AND SUBSTRING(CT2_CREDIT,1,2)<>'79')"
	cQry += "   AND CT2_VALOR>0"
	cQry += "   AND CT2_MOEDLC='"+strzero(val(MV_PAR09),2)+"'"
	cQry += "   AND CT2_DATA BETWEEN '" + DTOS( mv_par03 ) + "' AND '" + DTOS ( mv_par04 ) + "' "
	cQry += "   AND D_E_L_E_T_='' "
	cQry += " ORDER BY CT2_DATA"
			
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQry ), _vAlias,.T.,.T.) 
			
	IF (_vAlias)->( !Eof() )
	
		while (_vAlias)->( !Eof() )

			if aScan(_aCuosg,{|x| x[1] == (_vAlias)->CT2_SEGOFI }) == 0
				Aadd( _aCuosg, {	(_vAlias)->CT2_SEGOFI						,;			// 01
									(_vAlias)->CT2_VALOR						,;			// 02
									(_vAlias)->CT2_LINHA						,;			// 03
									if(!empty((_vAlias)->CT2_CREDIT),"C","D")	,;			// 04
									(_vAlias)->CT2_KEY							,;			// 05
									(_vAlias)->CT2_LP							,;			// 06
									(_vAlias)->CT2_CREDIT						,;			// 07
									(_vAlias)->CT2_DEBITO						,;			// 08
									(_vAlias)->CT2_HIST							,;			// 09
									(_vAlias)->CT2_DATA							,;			// 10
									(_vAlias)->CT2_FILIAL						;			// 11
					})
			endif
			(_vAlias)->( dbSkip() )
		end
		
	endif
	
	(_vAlias)->( dbCloseArea() )
	
	restArea(_vArea)
	
Return(_aCuosg)