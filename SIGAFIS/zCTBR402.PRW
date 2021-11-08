#Include "TopConn.ch"
#Include "CTBR400.Ch"
#Include "PROTHEUS.Ch"

#DEFINE TAM_VALOR  20
#DEFINE TAM_CONTA  20

Static lFWCodFil := FindFunction("FWCodFil")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ CTBR402  ³ Autor ³ Cicero J. Silva   	³ Data ³ 04.08.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balancete Centro de Custo/Conta         			 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CTBR402()    											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso 		 ³ SIGACTB      											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³Data    ³ BOPS     ³ Motivo da Alteracao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jonathan Glz³26/06/15³PCREQ-4256³Se elimina la funcion Ajusta402SX1() y³±±
±±³            ³        ³          ³se elimina la modificacion a SX1 de la³±±
±±³            ³        ³          ³funcion CTBR402() para Colombia y Peru³±±
±±³            ³        ³          ³por motivo de adecuacion a fuentes a  ³±±
±±³            ³        ³          ³nuevas estructuras SX para Version 12.³±±
±±³Jonathan Glz³09/10/15³PCREQ-4261³Merge v12.1.8                         ³±±
±±³Alf. Medrano³30/11/16³SERINN001-167³se quita la creacion de tablas tem ³±±
±±³            ³        ³          ³-porales y se asigna FWTemporaryTable ³±±
±±³            ³        ³          ³en fun CTBGeRaNIT                     ³±±
±±³Veronica Flo³12/10/18³DMINA-3963³Se modifica el valor de la variable en³±±
±±³            ³        ³          ³Pergunte de "CTR400" por "CTR402" ,con³±±
±±³            ³        ³          ³motivo de estandarización de preguntas³±±
±±³Alf. Medrano³15/05/19³DMINA-6664³Replica de DMINA-6266 Libro Mayor re- ³±±
±±³            ³        ³          ³formulación del campo 20. Se actualiza³±±
±±³            ³        ³          ³búsqueda en tabla CV3. Se asigna llave³±±
±±³            ³        ³          ³de búsqueda NODIA.Se adiciona la tabla³±±
±±³            ³        ³          ³SE2 en la búsqueda se incluye el param³±±
±±³            ³        ³          ³MV_CLIPAD para validar client estandar³±±
±±³            ³        ³          ³(PER)                                 ³±±
±±³            ³17/05/19³          ³En fun gerarq() se declaran variables ³±±
±±³            ³        ³          ³de tipo fecha, se comentan los indices³±±
±±³LuisEnríquez³10/07/19³DMINA-6847³Se compatibiliza rutina para versión  ³±±
±±³            ³        ³          ³v11.8 usando las funciones CTBR402CT y³±±
±±³            ³        ³          ³CTBR402ET para creación y borrado de  ³±±
±±³            ³        ³          ³tablas temporales. (PER)              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function zCTBR402(	cContaIni, cContaFim, dDataIni, dDataFim, cMoeda, cSaldos,;
					cBook, lCusto, cCustoIni, cCustoFim, lItem, cItemIni, cItemFim,;
					lNit, cNitIni, cNitFim,lSaltLin,cMoedaDesc,aSelFil )

Local aArea     := GetArea()
Local aCtbMoeda := {}
Local lOk       := .T.
Local lExterno  := cContaIni <> Nil

PRIVATE oTmpTable   := Nil
PRIVATE cTipoAnt	:= ""
PRIVATE cPerg	 	:= IIf(cVersao=="11","CTR400","CTR402")
PRIVATE nomeProg  	:= "CTBR402"
PRIVATE nSldTransp	:= 0 // Esta variavel eh utilizada para calcular o valor de transporte
PRIVATE oReport
PRIVATE nLin		:= 0
PRIVATE cArqTmp     := ""

DbSelectArea("CT0")
DbSetOrder(1) //CT0_FILIAL+CT0_ID
DbSeek(xFilial("CT0")+ "05" )

PRIVATE cPlano     := CT0->CT0_ENTIDA
PRIVATE cCodigo    := ""
DEFAULT lCusto     := .F.
DEFAULT lItem      := .F.
DEFAULT lNit       := .F.
DEFAULT lSaltLin   := .T.
DEFAULT cMoedaDesc := cMoeda 
DEFAULT aSelFil    := {}

	lOk := AMIIn(34)		// Acesso somente pelo SIGACTB
	If lOk
		Pergunte(cPerg, .F.)
		If !lExterno
			lOk := Pergunte(cPerg, .T.)
		Endif
	Endif

	If lOk
		//Verifica se o relatorio foi chamado a partir de outro programa. Ex. CTBC402
		If !lExterno
			lCusto	:= Iif(mv_par12 == 1,.T.,.F.)
			lItem	:= Iif(mv_par15 == 1,.T.,.F.)
			lNit	:= Iif(mv_par18 == 1,.T.,.F.)
			// Se aFil nao foi enviada, exibe tela para selecao das filiais
			If lOk .And. mv_par36 == 1 .And. Len( aSelFil ) <= 0
					aSelFil := AdmGetFil()

				If Len( aSelFil ) <= 0
					lOk := .F.
				EndIf
			EndIf
		Else  //Caso seja externo, atualiza os parametros do relatorio com os dados passados como parametros.
			mv_par01 := cContaIni
			mv_par02 := cContaFim
			mv_par03 := dDataIni
			mv_par04 := dDataFim
			mv_par05 := cMoeda
			mv_par06 := cSaldos
			mv_par07 := cBook
			mv_par12 := If(lCusto =.T.,1,2)
			mv_par13 := cCustoIni
			mv_par14 := cCustoFim
			mv_par15 := If(lItem =.T.,1,2)
			mv_par16 := cItemIni
			mv_par17 := cItemFim
			mv_par18 := If(lNit =.T.,1,2)
			mv_par19 := cNitIni
			mv_par20 := cNitFim
			mv_par31 := If(lSaltLin==.T.,1,2)
			mv_par32 := 56
			mv_par34 := cMoedaDesc
		Endif
	Endif

	//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano
	//³ Gerencial -> montagem especifica para impressao)
	If ! ct040Valid(mv_par07) // Set Of Books
		lOk := .F.
	EndIf

	If lOk .And. mv_par32 < 10
	                //"Valor informado inválido do" ### "'Num. linhas p/ o razão'"
		ShowHelpDlg("MINQTDELIN", {STR0083,STR0084},5,{STR0085,STR0086},5)
		                              //"Favor preencher uma quantidade" ###"mínima de 10 linhas"
		lOk := .F.
	EndIf

	If lOk
	    aCtbMoeda  	:= CtbMoeda(MV_PAR05) // Moeda?
	    If Empty( aCtbMoeda[1] )
			Help(" ",1,"NOMOEDA")
			lOk := .F.
		Endif

		IF lOk .And. ! Empty( mv_par34 )
			aCtbMoeddesc := CtbMoeda(mv_par34) // Moeda?

			If Empty( aCtbMoeddesc[1] )
				Help(" ",1,"NOMOEDA")
				lOk := .F.
			Endif
			aCtbMoeddesc := nil
		Endif
	Endif

	If lOk
		CTBR402R4(aCtbMoeda,lCusto,lItem,lNit,@cArqTmp,aSelFil )
	EndIf
	
	CTBR402ET() //Inicializa tabla temporal

RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CTBR402R4 º Autor ³                    º Data ³  15/09/09  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Impressao do relatorio em R4                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACTB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CTBR402R4(aCtbMoeda,lCusto,lItem,lNit,cArqTmp,aSelFil )
	oReport := ReportDef(aCtbMoeda,lCusto,lItem,lNit,@cArqTmp,aSelFil)
	oReport:PrintDialog()

	oReport := Nil
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ReportDef º Autor ³ Cicero J. Silva    º Data ³  01/08/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Definicao do objeto do relatorio personalizavel e das      º±±
±±º          ³ secoes que serao utilizadas                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ aCtbMoeda  - Matriz ref. a moeda                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACTB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef(aCtbMoeda,lCusto,lItem,lNit,cArqTmp,aSelFil)
Local oReport
Local oSection1
Local oSection1_1
Local oSection2
Local oSection3
Local cDesc1      := STR0001	//"Este programa ir  imprimir o Raz„o Contabil,"
Local cDesc2      := STR0002	// "de acordo com os parametros solicitados pelo"
Local cDesc3      := STR0003	// "usuario."
Local titulo      := STR0006 	//"Emissao do Razao Contabil"
Local cNormal     := ""
Local cPerg       := IIf(cVersao=="11","CTR400","CTR402") 
Local aTamConta   := TAMSX3("CT1_CONTA")
Local aTamCusto   := TAMSX3("CT3_CUSTO")
Local nTamConta   := Len(CriaVar("CT1_CONTA"))
Local nTamHist    := If(cPaisLoc$"CHI|ARG",29,Len(CriaVar("CT2_HIST")))
Local nTamItem    := Len(CriaVar("CTD_ITEM"))
Local nTamNit     := Len(CriaVar("CV0_CODIGO"))
Local nTamSegOfi  := Len(CriaVar("CT2_SEGOFI"))
Local nTamRotina  := Len(CriaVar("CT2_ROTINA"))
Local nTamData    := 25

Local lAnalitico  := Iif(mv_par08==1,.T.,.F.)// Analitico ou Resumido dia (resumo)
Local lPrintZero  := IIf(mv_par30==1,.T.,.F.)// Imprime valor 0.00    ?
Local lSalto      := Iif(mv_par21==1,.T.,.F.)// Salto de pagina                       ³

Local cSayCusto   := CtbSayApro("CTT")
Local cSayItem    := CtbSayApro("CTD")
Local cSayNit     := STR0076 //"N.I.T."
Local aSetOfBook  := CTBSetOf(mv_par07)// Set Of Books
Local cPicture    := aSetOfBook[4]
Local cDescMoeda  := aCtbMoeda[2]
Local nDecimais   := DecimalCTB(aSetOfBook,mv_par05)// Moeda
Local nTamTransp  := 0
Local nTamFilial  := IIf( lFWCodFil, FWGETTAMFILIAL, TamSx3( "CT2_FILIAL" )[1] )

//Mascaras
Local cMascara1 := ""
Local cMascara2 := ""
Local cMascara3 := ""
Local cMascara4 := ""

private _aDocOrig := {}

	IF MV_PAR35 == 1 // COLOCA O TAMANHO DAS ENTIDADES NO TAMANHO MAXIMO DE 20 PARA IMPRESSAO CORRETA DAS MASCARAS.
		aTamCusto[1]	:= 20
		nTamItem		:= 20
		nTamNit			:= 20
	ENDIF

	If mv_par11 == 3 						//// SE O PARAMETRO DO CODIGO ESTIVER PARA IMPRESSAO
		nTamConta := Len(CT1->CT1_CODIMP)	//// USA O TAMANHO DO CAMPO CODIGO DE IMPRESSAO
	Else
		If lAnalitico
			If (lCusto .Or. lItem .Or. lNit)
				nTamConta := 30						// Tamanho disponivel no relatorio para imprimir
			Else
				nTamConta := 40						// Tamanho disponivel no relatorio para imprimir
			Endif
		EndIf
	Endif

	If cPaisLoc = "PER"
		cSayNit := STR0077 //"R.U.C."
	Endif

	oReport := TReport():New(nomeProg,titulo,cPerg, {|oReport| ReportPrint(oReport,aCtbMoeda,aSetOfBook,cPicture,cDescMoeda,nDecimais,nTamConta,lAnalitico,lCusto,lItem,lNit,cArqTmp,aSelFil)},cDesc1+cDesc2+cDesc3)
	oReport:SetTotalInLine(.F.)
	oReport:EndPage(.T.)

	If lAnalitico
		oReport:SetLandScape(.T.)
	Else
		oReport:SetPortrait(.T.)
	EndIf
	oReport:lFooterVisible 	:= .F.		// Não imprime rodapé do protheus

	// oSection1
	oSection1 := TRSection():New(oReport,STR0043,{"cArqTmp"},/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/)	//"Conta"

	If lSalto
		oSection1:SetPageBreak(.T.)
	EndIf

	//Inicio do tratamento das mascaras
	// Mascara da Conta
	cMascara1 := IIf(Empty(aSetOfBook[2]),AllTrim(GetMv("MV_MASCARA")),RetMasCtb(aSetOfBook[2],@cSepara1))

	If lCusto .Or. lItem .Or. lNit
		// Mascara do Centro de Custo
		cMascara2 := IIf(Empty(aSetOfBook[6]),AllTrim(GetMv("MV_MASCCUS")),RetMasCtb(aSetOfBook[6],@cSepara2))
		// Mascara do Item Contabil
		cMascara3 := IIf(Empty(aSetOfBook[7]),AllTrim(GetNewPar("MV_MASCCTD","")),RetMasCtb(aSetOfBook[7],@cSepara3))
		// Mascara da Classe de Valor
		cMascara4 := AllTrim(GetNewPar("MV_MASCCTH",""))
	EndIf

	//Soma a mascara no tamanho da conta
	If Len( cMascara1 ) > 0 .And. Len( aTamConta ) > 0
		aTamConta[1] += Len( cMascara1 ) - 1
	EndIf
	//Soma a mascara no tamanho do centro de custo
	If Len( cMascara2 ) > 0 .And. Len( aTamCusto ) > 0
		aTamCusto[1] += Len( cMascara2 ) - 1
	EndIf
	//Soma a mascara no tamanho do item contabil
	If Len( cMascara3 ) > 0
		nTamItem += Len( cMascara3 ) - 1
	EndIf
	//Soma a mascara no tamanho da classe de valor
	If Len( cMascara4 ) > 0
		nTamNit += Len( cMascara4 ) - 1
	EndIf
	//Final do tratamento das mascaras

	If cPaisloc <> "PER"
		TRCell():New(oSection1,"CONTA"	,"cArqTmp",STR0041,/*Picture*/,aTamConta[1],/*lPixel*/,/*{|| }*/)	//"CONTA"
		TRCell():New(oSection1,"DESCCC"	,"cArqTmp",STR0042,/*Picture*/,nTamConta+20,/*lPixel*/,/*{|| }*/)		//"DESCRICAO"
		oSection1:SetReadOnly()
	Else
		TRCell():New(oSection1,"CONTA"	,"cArqTmp",STR0041,/*Picture*/,aTamConta[1],/*lPixel*/,/*{|| }*/)	//"CONTA"
		TRCell():New(oSection1,"DESCCC"	,"cArqTmp",STR0042,/*Picture*/,nTamConta+20,/*lPixel*/,/*{|| }*/)		//"DESCRICAO"
		//TRCell():New(oSection1,"TITDESC","cArqTmp", + CRLF + STR0066,/*Picture*/,nTamConta+20,/*lPixel*/,/*{|| }*/)		//"Código y Denominación de la Cuenta Contable:"
		oSection1:SetReadOnly()
		oSection1:Cell("CONTA"):Disable()
		oSection1:Cell("DESCCC"):Disable()
	EndIf

	// oSection2
	oSection2 := TRSection():New(oReport,STR0044,{"cArqTmp","CT2"},/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/)	//"Custo"
	oSection2:SetHeaderPage(.T.)
	oSection2:SetReadOnly()
	
	If cPaisLoc <> "PER"
		TRCell():New(oSection2,"DATAL"		,"cArqTmp",STR0019,/*Picture*/,nTamData,/*lPixel*/,/*{|| }*/,/*"LEFT"*/,,/*"LEFT"*/,,,.F.)	// "DATA"
		TRCell():New(oSection2,"CORRELATIVO",""       ,STR0034,/*Picture*/,If(nTamSegOfi < 20, 20,nTamSegOfi),/*lPixel*/,{|| cArqTmp->SEGOFI },/*"LEFT"*/,,/*"LEFT"*/,,,.F.)// "LOTE/SUB/DOC/LINHA"

		TRCell():New(oSection2,"HISTORICO"	,""		  ,STR0035,/*Picture*/,nTamHist	,/*lPixel*/,{|| cArqTmp->HISTORICO},/*"LEFT"*/,.T.,/*"LEFT"*/,,,.F.)// "HISTORICO"
		TRCell():New(oSection2,"XPARTIDA"	,"cArqTmp",STR0036,/*Picture*/,20,/*lPixel*/,/*{|| }*/,/*"LEFT"*/,,/*"LEFT"*/,,,.F.)// "XPARTIDA"

		TRCell():New(oSection2,"CCUSTO"		,"cArqTmp",Upper(cSayCusto),/*Picture*/,aTamCusto[1],/*lPixel*/,{|| IIF(lCusto == .T.,cArqTmp->CCUSTO,Nil) },/*"LEFT"*/,,/*"LEFT"*/,,,.F.)// Centro de Custo
		TRCell():New(oSection2,"ITEM"		,"cArqTmp",Upper(cSayItem) ,/*Picture*/,nTamItem,/*lPixel*/,{|| IIF(lItem == .T.,cArqTmp->ITEM,Nil) },/*"LEFT"*/,,/*"LEFT"*/,,,.F.)// Item Contabil
		TRCell():New(oSection2,"NIT"		,"cArqTmp",Upper(cSayNit) ,/*Picture*/,nTamNit,/*lPixel*/,{|| IIF(lNit == .T.,cArqTmp->NIT,Nil) },/*"LEFT"*/,,/*"LEFT"*/,,,.F.)// Classe de Valor
		TRCell():New(oSection2,"CLANCDEB"	,"cArqTmp",STR0037,/*Picture*/,TAM_VALOR,/*lPixel*/,{|| ValorCTB(cArqTmp->LANCDEB,,,TAM_VALOR,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) },/*"RIGHT"*/,,"CENTER",,,.F.)// "DEBITO"
		TRCell():New(oSection2,"CLANCCRD"	,"cArqTmp",STR0038,/*Picture*/,TAM_VALOR,/*lPixel*/,{|| ValorCTB(cArqTmp->LANCCRD,,,TAM_VALOR,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) },/*"RIGHT"*/,,"CENTER",,,.F.)// "CREDITO"
		TRCell():New(oSection2,"CTPSLDATU"	,"cArqTmp",STR0039,/*Picture*/,TAM_VALOR+2,/*lPixel*/,/*{|| }*/,/*"RIGHT"*/,,"CENTER",,,.F.)// "SALDO ATUAL"
	Else
		TRCell():New(oSection2,"DATAL"		,"cArqTmp",STR0059,/*Picture*/,nTamData,/*lPixel*/,/*{|| }*/,/*"LEFT"*/,,/*"LEFT"*/,,,.F.)	// "Fecha de la Operación"
		TRCell():New(oSection2,"CORRELATIVO",""       ,STR0060,/*Picture*/,If(nTamSegOfi < 20, 40,nTamSegOfi),/*lPixel*/,{|| cArqTmp->SEGOFI },/*"LEFT"*/,,/*"LEFT"*/,,,.F.)// "Numero Correlativo del Libro Diário"

		TRCell():New(oSection2,"HISTORICO"	,""		   ,STR0061,/*Picture*/,nTamHist	,/*lPixel*/,{|| cArqTmp->HISTORICO},/*"LEFT"*/,.T.,/*"LEFT"*/,,,.F.)// "Descripcion o Glosa de la Operación"
		TRCell():New(oSection2,"XPARTIDA"	,""		   ,""		 ,/*Picture*/,20,/*lPixel*/,/*{|| }*/,/*"LEFT"*/,,/*"LEFT"*/,,,.F.)// "XPARTIDA"

		TRCell():New(oSection2,"CCUSTO"		,"cArqTmp",""		 ,/*Picture*/,aTamCusto[1],/*lPixel*/,{|| IIF(lCusto == .T.,cArqTmp->CCUSTO,Nil) },/*"LEFT"*/,,/*"LEFT"*/,,,.F.)// Centro de Custo
		TRCell():New(oSection2,"ITEM"		,"cArqTmp",""		 ,/*Picture*/,nTamItem,/*lPixel*/,{|| ,,},/*"LEFT"*/,,/*"LEFT"*/,,,.F.)// Item Contabil
		TRCell():New(oSection2,"NIT"		,"cArqTmp",""		 ,/*Picture*/,nTamNit,/*lPixel*/,{|| IIF(lNit == .T.,cArqTmp->NIT,Nil) },/*"LEFT"*/,,/*"LEFT"*/,,,.F.)// Classe de Valor
		//camos nuevos
		//-------------
		TRCell():New(oSection2,"CODLIBRO"	,"","Codigo del libro o registro",/*Picture*/,12,/*lPixel*/,{|| ALLTRIM(STR(VAL(cArqTmp->DIACTB))) },"LEFT",,"LEFT") //"Codigo del" # " libro " # "o registro"
		TRCell():New(oSection2,"CORREL"	  	,"","Numero correlativo",/*Picture*/,14,/*lPixel*/,{|| "M"+STRZERO(VAL(cArqTmp->LINHA),9) },"LEFT",,"LEFT") //"Numero" # "correlativo"
		TRCell():New(oSection2,"DOCUM" 		,"","Número del documento sustentario",/*Picture*/,17,/*lPixel*/,{|| cArqTmp->DOCUMENTO },"LEFT",,"LEFT") //"Número del " # "documento" # "sustentario"
		//-------------
		TRCell():New(oSection2,"CLANCDEB"   ,"cArqTmp","" + CRLF + STR0079,/*Picture*/,TAM_VALOR,/*lPixel*/,{|| ValorCTB(cArqTmp->LANCDEB,,,TAM_VALOR,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) },"",,"RIGHT",,,.F.) //"Deudor"
		TRCell():New(oSection2,"CLANCCRD"   ,"cArqTmp", STR0064+ STR0081 + CRLF + STR0080,/*Picture*/,29,/*lPixel*/,{|| ValorCTB(cArqTmp->LANCCRD,,,29,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) },"",,"RIGHT",,,.F.) //"         ." ##"Acreedor"
		//TRCell():New(oSection2,"CTPSLDATU"	,"cArqTmp",STR0078    ,/*Picture*/,TAM_VALOR+2,/*lPixel*/,/*{|| }*/,/*"RIGHT"*/,,"CENTER",,,.F.)// "SALDO ATUAL"

		TRCell():New(oSection2,"SEGOFI"	,"cArqTmp","",/*Picture*/,TamSx3("CT2_SEGOFI")[1],/*lPixel*/,{|| ,, }) //"SEGOFI"
		TRCell():New(oSection2,"ROTINA"	,"cArqTmp","",/*Picture*/,TamSx3("CT2_ROTINA")[1],/*lPixel*/,{|| ,, }) //"SEGOFI"

		oSection2:Cell("XPARTIDA"):Disable()
		oSection2:Cell("CCUSTO"):Disable()
		oSection2:Cell("ITEM"):Disable()
		//oSection2:Cell("CTPSLDATU")//:Disable()
		oSection2:Cell("SEGOFI"):Disable()
		oSection2:Cell("ROTINA"):Disable()
	EndIf

	If cPaisLoc $ "CHI|ARG"
		TRCell():New(oSection2,"SEGOFI"	,"cArqTmp","SEGOFI",/*Picture*/,TamSx3("CT2_SEGOFI")[1],/*lPixel*/,{|| cArqTmp->SEGOFI }) //"SEGOFI"
		TRCell():New(oSection2,"ROTINA"	,"cArqTmp","ROTINA",/*Picture*/,TamSx3("CT2_ROTINA")[1],/*lPixel*/,{|| cArqTmp->ROTINA }) //"SEGOFI"
		oSection2:Cell("ROTINA"):Hide()
		oSection2:Cell("ROTINA"):HideHeader()
	EndIf

	// Tratamento do campo SEGOFI para Chile e Argentina
	// Caso o relatorio seja resumido imprime na coluna historico
	// Caso seja analitico imprime em uma nova coluna.
	If cPaisLoc $ "CHI|ARG|PER" .and. lAnalitico //Se for relatorio analitico

		oSection2:Cell("HISTORICO"):SetSize(29)
		oSection2:Cell("HISTORICO"):SetBlock( { || Subs(cArqTmp->HISTORICO,1,29)})

	ElseIf cPaisLoc $ "CHI|ARG|PER" .and. !lAnalitico //Se for relatorio Resumido

		oSection2:Cell("SEGOFI"):Hide()
		oSection2:Cell("SEGOFI"):HideHeader()

		oSection2:Cell("CORRELATIVO"):SetTitle(STR0034 + " - " + "SEGOFI")
		oSection2:Cell("CORRELATIVO"):SetSize(oSection2:Cell("CORRELATIVO"):GetSize() + Len(CriaVar("CT2_SEGOFI")) )
	  	oSection2:Cell("CORRELATIVO"):SetBlock( { || cArqTmp->SEGOFI+" - "+ cArqTmp->SEGOFI } )
	  	oSection2:Cell("HISTORICO"  ):SetBlock( { || Subs(cArqTmp->HISTORICO,1,40)})

	EndIf

	// Oculta campos para relatorio resumido
	If !lAnalitico // Resumido

	  	oSection2:Cell("CORRELATIVO"):Hide()
		oSection2:Cell("CORRELATIVO"):SetTitle('')

	  	oSection2:Cell("HISTORICO"):Hide()
	 	oSection2:Cell("HISTORICO"):SetTitle('')

	    oSection2:Cell("XPARTIDA"):Disable()

	EndIf

	// Inibir a coluna FILIAL do relatorio quando utiliza multi-filiais
	If !lAnalitico
		nTamTransp := oSection2:Cell("DATAL"):GetSize() + oSection2:Cell("CORRELATIVO"):GetSize() + oSection2:Cell("HISTORICO"):GetSize();
		              + oSection2:Cell("CLANCDEB"):GetSize() + oSection2:Cell("CLANCCRD"):GetSize()+3
	Else
		nTamTransp := oSection2:Cell("DATAL"):GetSize() + oSection2:Cell("CORRELATIVO"):GetSize() + oSection2:Cell("HISTORICO"):GetSize();
		              + oSection2:Cell("XPARTIDA"):GetSize() + oSection2:Cell("CCUSTO"):GetSize();
		              + oSection2:Cell("ITEM"):GetSize() + oSection2:Cell("NIT"):GetSize() + oSection2:Cell("CLANCDEB"):GetSize();
		              + oSection2:Cell("CLANCCRD"):GetSize() + 4
	Endif

	oSection2:Cell("DATAL"      ):lHeaderSize := .F.
	oSection2:Cell("CORRELATIVO"):lHeaderSize := .F.
	oSection2:Cell("CLANCDEB"   ):lHeaderSize := .F.
	oSection2:Cell("CLANCCRD"   ):lHeaderSize := .F.
	//oSection2:Cell("CTPSLDATU"  ):lHeaderSize := .F.

	// Imprime linha saldo anterior
	//oSection1_1 - Totalizadores Conta
	oSection1_1 := TRSection():New(oReport,STR0050,/*{"cArqTmp","CT2"}*/,/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/)

	// Tamanho da coluna descrição da seção Section1_1
	nTamDesc := nTamData + nTamSegOfi + nTamHist

	TRCell():New(oSection1_1,"DESCRICAO","cArqTmp","",/*Picture*/,nTamDesc,/*lPixel*/,{|| })
	TRCell():New(oSection1_1,"SALDOANT"	,"cArqTmp","",/*Picture*/,TAM_VALOR + 20,/*lPixel*/,{|| },"RIGHT",,"RIGHT")
	oSection1_1:SetHeaderSection(.F.)
	oSection1_1:SetReadOnly()

	//oSection3 - Totalizadores Transporte
	oSection3 := TRSection():New(oReport,STR0051,/*Alias*/,/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/,,,,,,.F.,,,)	//"Transporte"

	TRCell():New(oSection3,"CTRANSP"	,/*Alias*/,/*titulo*/,/*Picture*/,nTamTransp,/*lPixel*/,/*{||}*/,,,,,,.F.)
	TRCell():New(oSection3,"CSLDATU"	,/*Alias*/,/*titulo*/,/*Picture*/,TAM_VALOR+2,/*lPixel*/,/*{||}*/,,,/*"RIGHT"*/,,,.F.)
	oSection3:SetHeaderSection(.F.)
	oSection3:SetReadOnly()

	oSection3:Cell("CTRANSP"):lHeaderSize := .F.
	oSection3:Cell("CSLDATU"):lHeaderSize := .F.

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportPrintº Autor ³ Cicero J. Silva    º Data ³  14/07/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Definicao do objeto do relatorio personalizavel e das      º±±
±±º          ³ secoes que serao utilizadas                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint(oReport,aCtbMoeda,aSetOfBook,cPicture,cDescMoeda,nDecimais,nTamConta,lAnalitico,lCusto,lItem,lNIt,cArqTmp,aSelFil)
Local oSection1 	:= oReport:Section(1)
Local oSection2		:= oReport:Section(2)
Local oSection1_1	:= oReport:Section(3)
Local oSection3		:= oReport:Section(4)

Local cFiltro		:= oSection2:GetAdvplExp()
Local cSayCusto		:= CtbSayApro("CTT")
Local cSayItem		:= CtbSayApro("CTD")
Local cSayNit		:= "NIT"
Local aSaldo		:= {}
Local aSaldoAnt		:= {}
Local cContaIni		:= mv_par01 // da conta
Local cContaFim		:= mv_par02 // ate a conta
Local cMoeda		:= mv_par05 // Moeda
Local cSaldo		:= mv_par06 // Saldos
Local cCustoIni		:= mv_par13 // Do Centro de Custo
Local cCustoFim		:= mv_par14 // At‚ o Centro de Custo
Local cItemIni		:= mv_par16 // Do Item
Local cItemFim		:= mv_par17 // Ate Item
Local cNitIni		:= mv_par19 // Imprime Classe de Valor?
Local cNitFim		:= mv_par20 // Ate a Classe de Valor
Local cContaAnt		:= ""
Local cDescConta	:= ""
Local cCodRes		:= ""
Local cResCC		:= ""
Local cResItem		:= ""
Local cDescSint		:= ""
Local cContaSint	:= ""
Local cNormal 		:= ""
Local xConta		:= ""
Local cSepara1		:= ""
Local cSepara2		:= ""
Local cSepara3		:= ""
Local cSepara4		:= ""
Local cMascara1		:= ""
Local cMascara2		:= ""
Local cMascara3		:= ""
Local cMascara4		:= ""
Local dDataAnt		:= CTOD("  /  /  ")
Local dDataIni		:= mv_par03 // da data
Local dDataFim		:= mv_par04 // Ate a data
Local nTotDeb		:= 0
Local nTotCrd		:= 0
Local nTotGerDeb	:= 0
Local nTotGerCrd	:= 0
Local nVlrDeb		:= 0
Local nVlrCrd		:= 0
Local nCont			:= 0

Local lNoMov		:= Iif(mv_par09==1,.T.,.F.) // Imprime conta sem movimento?
Local lSldAnt		:= Iif(mv_par09==3,.T.,.F.) // Imprime conta sem movimento?
Local lJunta		:= Iif(mv_par10==1,.T.,.F.) // Junta Contas com mesmo C.Custo?
Local lPrintZero	:= Iif(mv_par30==1,.T.,.F.) // Imprime valor 0.00    ?
Local lImpLivro		:= .t.
Local lImpTermos	:= .f.
Local lSldAntCC		:= Iif(mv_par33 == 2, .T.,.F.)// Saldo Ant. nivel?Cta/C.C/Item/Cl.Vlr
Local lSldAntIt  	:= Iif(mv_par33 == 3, .T.,.F.)// Saldo Ant. nivel?Cta/C.C/Item/Cl.Vlr
Local cMoedaDesc	:= iif( Empty( mv_par34 ) , cMoeda , mv_par34 ) // RFC - 18/01/07 | BOPS 103653
Local nMaxLin   	:= mv_par32 // Num.linhas p/ o Razao?
Local nLinReport	:= 8
Local lResetPag		:= .T.
Local m_pag			:= 1 // controle de numeração de pagina
Local l1StQb		:= .T.
Local nPagIni		:= mv_par22
Local nPagFim		:= mv_par23
Local nReinicia		:= mv_par24
Local nBloco		:= 0
Local nBlCount		:= 1
Local nX
Local cTitulo	 	:= " "
Local cLbSiDom		:= getNewPar("MV_LFSDOM","080100")
Local cLbNoDom		:= getNewPar("MV_LFNDOM","080200")
Local cLbVenta		:= getNewPar("MV_LFVENT","140100")
Local cCodLibr		:= ""

	IF mv_par36 == 1 .And. Len( aSelFil ) <= 0
		aSelFil := AdmGetFil()
	EndIf

	If oReport:GetOrientation() == 1 .or. !lAnalitico // Resumido

	   	nTransp := oSection2:Cell("DATAL"):GetSize() + oSection2:Cell("CORRELATIVO"):GetSize() + oSection2:Cell("HISTORICO"):GetSize();
	             + oSection2:Cell("XPARTIDA"):GetSize()+ oSection2:Cell("CLANCDEB"):GetSize();
		         + oSection2:Cell("CLANCCRD"):GetSize()+6

		If oReport:nDevice == 1
			nTransp -= 20
		Endif

		oSection3:Cell("CTRANSP"):SetSize(nTransp)
	   	oSection2:Cell("CCUSTO"):Disable()
	  	oSection2:Cell("ITEM"):Disable()
	  	oSection2:Cell("NIT"):Disable()

		If cPaisloc <> "PER"
			MsgAlert(STR0049) // "Atenção, as colunas das entidades Cl Valor, C.Custo e Item Contábil  não serão impressas no modo retrato ou na opção Resumido.")
	 	EndIf

	Endif

	// Mascara da Conta
	cMascara1 := IIf (Empty(aSetOfBook[2]),AllTrim(GetMv("MV_MASCARA")),RetMasCtb(aSetOfBook[2],@cSepara1) )

	If lCusto .Or. lItem .Or. lNit
		// Mascara do Centro de Custo
		cMascara2 := IIf ( Empty(aSetOfBook[6]),AllTrim(GetMv("MV_MASCCUS")),RetMasCtb(aSetOfBook[6],@cSepara2) )
		// Mascara do Item Contabil
		cMascara3 := IIf(Empty(aSetOfBook[7]),AllTrim(GetNewPar("MV_MASCCTD","")), RetMasCtb(aSetOfBook[7],@cSepara3))
		// Mascara da Classe de Valor
		cMascara4 := AllTrim(GetNewPar("MV_MASCCTH",""))
	EndIf

	//³ Impressao de Termo / Livro
	Do Case
		Case mv_par29==1 ; lImpLivro:=.t. ; lImpTermos:=.f.
		Case mv_par29==2 ; lImpLivro:=.t. ; lImpTermos:=.t.
		Case mv_par29==3 ; lImpLivro:=.f. ; lImpTermos:=.t.
	EndCase

	//³Titulo do Relatorio
	If oReport:Title() == oReport:cRealTitle
		IF lAnalitico
			cTitulo	:= Iif(cPaisLoc=="PER",STR0065,	STR0007)	//"RAZAO ANALITICO EM "
			Titulo  := cTitulo
		Else
			cTitulo	:= Iif(cPaisLoc=="PER",STR0065,	STR0008)	//"RAZAO SINTETICO EM "
			Titulo  := cTitulo+	cDescMoeda + STR0009 + DTOC(dDataIni) +;	// "DE"
						STR0010 + DTOC(dDataFim) + CtbTitSaldo(mv_par06)	// "ATE"
		EndIf
	Else
		Titulo  := oReport:Title()  //NewHead
		cTitulo := Titulo
	EndIf

	If FindFunction("CABRELPER") .and.  cPaisLoc=="PER"
		oReport:SetTitle(cTitulo)
		oReport:SetCustomText( {|| CABRELPER(	,	,	,	,	,dDataFim,oReport:Title() ,	,	,	,	,oReport,.T. ,@lResetPag,@nPagIni,@nPagFim,@nReinicia,@m_pag,@nBloco,@nBlCount,@l1StQb,	,cTitulo,.T.) } )
	Else
		oReport:SetTitle(Titulo)
		oReport:SetCustomText( {|| CtCGCCabTR(,,,,,dDataFim,oReport:Title(),,,,,oReport,.T.,@lResetPag,@nPagIni,@nPagFim,@nReinicia,@m_pag,@nBloco,@nBlCount,@l1StQb) } )
	Endif

	oSection1:OnPrintLine(   {|| CTR402Maxl(@nMaxLin,@nLinReport)} )
	oSection1_1:OnPrintLine( {|| CTR402Maxl(@nMaxLin,@nLinReport)} )
	oSection2:OnPrintLine(   {|| CTR402Maxl(@nMaxLin,@nLinReport)} )

	oReport:OnPageBreak( {|| CTR402Maxl(@nMaxLin,@nLinReport)} )

	If lImpLivro
		//³ Monta Arquivo Temporario para Impressao
		MsgMeter({|	oMeter, oText, oDlg, lEnd | CTBGeRaNIT(	oMeter,oText,oDlg,lEnd,@cArqTmp,cContaIni,cContaFim,cCustoIni,cCustoFim,;
								cItemIni,cItemFim,cNitIni,cNitFim,cMoeda,dDataIni,dDataFim,;
								aSetOfBook,lNoMov,cSaldo,lJunta,"1",lAnalitico,,,cFiltro,lSldAnt,aSelFil) },;
					STR0018,;		// "Criando Arquivo Tempor rio..."
					STR0006)		// "Emissao do Razao"
					
		//IIF(cPaisLoc="COL" .And. mv_par39==1,"1","4")

		dbSelectArea("cArqTmp")
		dbGoTop()

		oReport:SetMeter( RecCount() )
		oReport:NoUserFilter()
	EndIf

	If IIF(cPaisLoc == "PER", ALLTRIM(STR(MV_PAR37)) $ "1|3" , .T. )

		oBrkConta 	:= TRBreak():New( oSection2, { || cArqTmp->CONTA }, OemToAnsi(STR0020), )

		oTotDeb 	:= TRFunction():New( oSection2:Cell("CLANCDEB")	, ,"ONPRINT", oBrkConta,/*Titulo*/,cPicture,;
							{ || ValorCTB(nTotDeb  ,,,TAM_VALOR,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection2)

		oTotCred	:= TRFunction():New( oSection2:Cell("CLANCCRD")	, ,"ONPRINT", oBrkConta,/*Titulo*/,cPicture,;
							{ || ValorCTB(nTotCrd  ,,,TAM_VALOR,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection2)
							
		//oTotTpSld 	:= TRFunction():New( oSection2:Cell("CTPSLDATU")	, ,"ONPRINT", oBrkConta,/*Titulo*/,cPicture,;
		//							{ || ValorCTB(nSaldoAtu,,,TAM_VALOR-2,nDecimais,.T.,cPicture,cNormal,,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection2)

		If lImpLivro .And. mv_par28 == 1	//Imprime total Geral
			oBrkEnd 	:= TRBreak():New( oReport, { || /*cArqTmp->(Eof())*/	}, OemToAnsi(STR0025), )//"T O T A L  G E R A L  ==> "
			oTotGerDeb 	:= TRFunction():New( oSection2:Cell("CLANCDEB")	, ,"ONPRINT", oBrkEnd,/*Titulo*/,cPicture,;
						{ || ValorCTB(nTotGerDeb  ,,,TAM_VALOR,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection2)
			oTotGerCred	:= TRFunction():New( oSection2:Cell("CLANCCRD")	, ,"ONPRINT", oBrkEnd,/*Titulo*/,cPicture,;
						{ || ValorCTB(nTotGerCrd  ,,,TAM_VALOR,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection2)
		EndIf

		//³Impressao do Saldo Anterior do Centro de Custo
		oSection1_1:Cell("DESCRICAO"):SetBlock( {|| xConta } )
		oSection1_1:Cell("SALDOANT"):SetBlock( {|| STR0033 + ValorCTB(aSaldoAnt[6],,,TAM_VALOR,nDecimais,.T.,cPicture,cNormal,,,,,,lPrintZero,.F.) } )//"SALDO ANTERIOR: "

		oSection1_1:Cell("DESCRICAO"):HideHeader()
		oSection1_1:Cell("SALDOANT"):HideHeader()

		//Se tiver parametrizado com Plano Gerencial, exibe a mensagem que o Plano Gerencial
		//nao esta disponivel e sai da rotina.
		If lImpLivro
			If cArqTmp->(EoF())
				// Atencao ### "Nao existem dados para os parâmetros especificados."
				Aviso(STR0047,STR0048,{"Ok"})
				oReport:CancelPrint()
				Return
			Else
				While lImpLivro .And. cArqTmp->(!Eof()) .And. !oReport:Cancel()
					//³INICIO DA 1a SECAO
				    If oReport:Cancel()
				    	Exit
				    EndIf

					If lSldAntCC
						aSaldo    := SaldTotCT3(cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,cArqTmp->DATAL,cMoeda,cSaldo,aSelFil)
						aSaldoAnt := SaldTotCT3(cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,dDataIni,cMoeda,cSaldo,aSelFil)
					ElseIf lSldAntIt
						aSaldo    := SaldTotCT4(cItemIni,cItemFim,cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,cArqTmp->DATAL,cMoeda,cSaldo,aSelFil)
						aSaldoAnt := SaldTotCT4(cItemIni,cItemFim,cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,dDataIni,cMoeda,cSaldo,aSelFil)
					Else
						aSaldo 		:= SaldoCT7Fil(cArqTmp->CONTA,cArqTmp->DATAL,cMoeda,cSaldo,,,,aSelFil)
						aSaldoAnt	:= SaldoCT7Fil(cArqTmp->CONTA,dDataIni,cMoeda,cSaldo,"CTBR402",,,aSelFil)
					EndIf

					If f180Fil(lNoMov,aSaldo,dDataIni,dDataFim)
						dbSkip()
						Loop
					EndIf

					// Conta Sintetica
					cContaSint := Ctr402Sint(cArqTmp->CONTA,@cDescSint,cMoeda,@cDescConta,@cCodRes,cMoedaDesc)
					cNormal := CT1->CT1_NORMAL

		 			oSection1:Cell("DESCCC"):SetBlock( { || " - " + cDescSint } )
					oSection1:Cell("DESCCC"):SetSize(LEN(cDescSint)+3)
					If mv_par11 == 3
						oSection1:Cell("CONTA" ):SetBlock( { || EntidadeCTB(CT1->CT1_CODIMP,0,0,nTamConta,.F.,cMascara1,cSepara1,,,,,.F.) } )
					Else
						oSection1:Cell("CONTA" ):SetBlock( { || EntidadeCTB(cContaSint,0,0,Len(cContaSint),.F.,cMascara1,cSepara1,,,,,.F.) } )
					Endif

					oSection3:Cell("CTRANSP"):SetBlock( { || Iif(nLinReport == 11,  STR0023, STR0022)})
					oSection3:Cell("CSLDATU"):SetBlock( { || ValorCTB(nSldTransp,,,TAM_VALOR-2,nDecimais,.T.,cPicture,cNormal,,,,,,lPrintZero,.F.) })

					//³INICIO DA IMPRESSAO DA 1A SECAO
		    	 	oSection1:Init()
		    	 	nLin := 3

			     	oSection1:PrintLine()
				    oSection1:Finish()

				    If cPaisloc <> "PER"
				    	xConta := STR0016 //"CONTA - "
				    Else
				    	xConta := "" //""
					EndIf

					If mv_par11 == 1							// Imprime Cod Normal
						xConta += EntidadeCTB(cArqTmp->CONTA,0,0,nTamConta,.F.,cMascara1,cSepara1,,,,,.F.)
					Else
						dbSelectArea("CT1")
						dbSetOrder(1)//CT1_FILIAL+CT1_CONTA
						MsSeek(xFilial("CT1")+cArqTMP->CONTA,.F.)
						If mv_par11 == 3						// Imprime Codigo de Impressao
							xConta += EntidadeCTB(CT1->CT1_CODIMP,0,0,nTamConta,.F.,cMascara1,cSepara1,,,,,.F.)
						Else										// Caso contrário usa codigo reduzido
							xConta += EntidadeCTB(CT1->CT1_RES,0,0,nTamConta,.F.,cMascara1,cSepara1,,,,,.F.)
						EndIf

						cDescConta := &("CT1->CT1_DESC" + cMoedaDesc )
					Endif

					If !lAnalitico
						xConta +=  " - " + Left(cDescConta,30)
					Else
						xConta +=  " - " + Left(cDescConta,40)
					Endif

					oSection1_1:Init()
					nLin := 2
			     	oSection1_1:PrintLine()
				    oSection1_1:Finish()

					nSaldoAtu := aSaldoAnt[6]
					//³FIM DA 1a SECAO

					//³INICIO DA 2a SECAO
					dbSelectArea("cArqTmp")
					cContaAnt := cArqTmp->CONTA
					dDataAnt  := CTOD("  /  /  ")
					oSection2:Init()
					Do While cArqTmp->(!Eof() .And. CONTA == cContaAnt ) .And. !oReport:Cancel()

					    If oReport:Cancel()
					    	Exit
					    EndIf

						If dDataAnt <> cArqTmp->DATAL
							If ( cArqTmp->LANCDEB <> 0 .Or. cArqTmp->LANCCRD <> 0 )
								oSection2:Cell("DATAL"):SetBlock( { || dDataAnt } )
							Endif
							dDataAnt := cArqTmp->DATAL
						EndIf

						If lAnalitico //Se for relatorio analitico
							nSaldoAtu 	:= nSaldoAtu - cArqTmp->LANCDEB + cArqTmp->LANCCRD
							nTotDeb		+= cArqTmp->LANCDEB
							nTotCrd		+= cArqTmp->LANCCRD
							nTotGerDeb	+= cArqTmp->LANCDEB
							nTotGerCrd	+= cArqTmp->LANCCRD

							dbSelectArea("cArqTmp")
							If mv_par11 == 1 // Impr Cod (Normal/Reduzida/Cod.Impress)
								oSection2:Cell("XPARTIDA"):SetBlock( { || EntidadeCTB(cArqTmp->XPARTIDA,0,0,nTamConta,.F.,cMascara1,cSepara1,,,,,.F.) } )
							ElseIf mv_par11 == 3
								oSection2:Cell("XPARTIDA"):SetBlock( { || EntidadeCTB(CT1->CT1_CODIMP,0,0,nTamConta,.F.,cMascara1,cSepara1,,,,,.F.) } )
							Else
								dbSelectArea("CT1")
								dbSetOrder(1)//CT1_FILIAL+CT1_CONTA
								MsSeek(xFilial("CT1")+cArqTmp->XPARTIDA,.F.)
								oSection2:Cell("XPARTIDA"):SetBlock( { || EntidadeCTB(CT1->CT1_RES,0,0,TAM_CONTA,.F.,cMascara1,cSepara1,,,,,.F.) } )
							Endif

							If lCusto
								If mv_par25 == 1 //Imprime Cod. Centro de Custo Normal
									oSection2:Cell("CCUSTO"):SetBlock( { || EntidadeCTB(cArqTmp->CCUSTO,0,0,TAM_CONTA,.F.,cMascara2,cSepara2,,,,,.F.) } )
								Else
									dbSelectArea("CTT")
									dbSetOrder(1)//CTT_FILIAL+CTT_CUSTO
									dbSeek(xFilial("CTT")+cArqTmp->CCUSTO)
									cResCC := CTT->CTT_RES
									oSection2:Cell("CCUSTO"):SetBlock( { || EntidadeCTB(cResCC,0,0,TAM_CONTA,.F.,cMascara2,cSepara2,,,,,.F.) } )
									dbSelectArea("cArqTmp")
								Endif
							Endif
							If lItem 						//Se imprime item
								If mv_par26 == 1 //Imprime Codigo Normal Item Contabl
									oSection2:Cell("ITEM"):SetBlock( { || EntidadeCTB(cArqTmp->ITEM,0,0,TAM_CONTA,.F.,cMascara3,cSepara3,,,,,.F.) } )
								Else
									dbSelectArea("CTD")
									dbSetOrder(1)//CTD_FILIAL+CTD_ITEM
									dbSeek(xFilial("CTD")+cArqTmp->ITEM)
									cResItem := CTD->CTD_RES
									oSection2:Cell("ITEM"):SetBlock( { || EntidadeCTB(cResItem,0,0,TAM_CONTA,.F.,cMascara3,cSepara3,,,,,.F.) } )
									dbSelectArea("cArqTmp")
								Endif
							Endif
							If lNIt //Se imprime classe de valor
								oSection2:Cell("NIT"):SetBlock( { || EntidadeCTB(cArqTmp->NIT,0,0,TAM_CONTA,.F.,cMascara4,cSepara4,,,,,.F.) } )
							Endif

							//oSection2:Cell("CTPSLDATU"):SetBlock( { || ValorCTB(nSaldoAtu,,,TAM_VALOR-2,nDecimais,.T.,cPicture,cNormal,,,,,,lPrintZero,.F.) } )
					        nLin := 1
					     	oSection2:PrintLine()

							nSldTransp := nSaldoAtu // Valor a Transportar - 1

						    oReport:IncMeter()

							// Procura complemento de historico e imprime
						  	ImpCompl( oSection2 )

							dbSkip()

						Else // !lAnalitico	 -- Se for resumido.

							dbSelectArea("cArqTmp")

							While dDataAnt == cArqTmp->DATAL .And. cContaAnt == cArqTmp->CONTA
								nVlrDeb   	+= cArqTmp->LANCDEB
								nVlrCrd	    += cArqTmp->LANCCRD
								nTotGerDeb	+= cArqTmp->LANCDEB
								nTotGerCrd	+= cArqTmp->LANCCRD
								dbSkip()
							EndDo

							nSaldoAtu	:= nSaldoAtu - nVlrDeb + nVlrCrd
						  	oSection2:Cell("CLANCDEB" ):SetBlock( { || ValorCTB(nVlrDeb  ,,,TAM_VALOR  ,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) })// Debito
						  	oSection2:Cell("CLANCCRD" ):SetBlock( { || ValorCTB(nVlrCrd  ,,,TAM_VALOR  ,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) })// Credito
							//oSection2:Cell("CTPSLDATU"):SetBlock( { || ValorCTB(nSaldoAtu,,,TAM_VALOR-2,nDecimais,.T.,cPicture,cNormal,,,,,,lPrintZero,.F.) })// Sinal do Saldo Atual => Consulta Razao

							//Imprime Section(1) - resumida.
							nLin := 1
					     	oSection2:PrintLine()
						    oReport:IncMeter()

							nSldTransp := nSaldoAtu // Valor a Transportar

							nTotDeb += nVlrDeb
							nTotCrd += nVlrCrd
							nVlrDeb	:= 0
							nVlrCrd	:= 0
						Endif
					EndDo

		 	   		If nSldTransp != 0
		 	   			nLinReport+=3
		 	   		Endif

		 			oSection2:Finish()

		           	nSldTransp  := 0
					nSaldoAtu   := 0
					nTotDeb	    := 0
					nTotCrd	    := 0

					//³FIM DA 2a SECAO
				EndDo
			EndIf
		EndIf

		//³Impressao dos Termos
		If lImpTermos // Impressao dos Termos

			oSection2:SetHeaderPage(.F.) // Desabilita a impressao

			cArqAbert:=GetNewPar("MV_LRAZABE","")
			cArqEncer:=GetNewPar("MV_LRAZENC","")

		    If Empty(cArqAbert)
				ApMsgAlert(	STR0027 +; //"Devem ser criados os parametros MV_LRAZABE e MV_LRAZENC. "
							STR0028) //"Utilize como base o parametro MV_LDIARAB."
			Endif
		Endif

		If lImpTermos .And. ! Empty(cArqAbert)
			dbSelectArea("SM0")
			aVariaveis := {}

			For nCont := 1 to FCount()
				If FieldName(nCont)=="M0_CGC"
					AADD(aVariaveis,{FieldName(nCont),Transform(FieldGet(nCont),"@R 99.999.999/9999-99")})
				Else
		            If FieldName(nCont)=="M0_NOME"
		                Loop
		            EndIf
					AADD(aVariaveis,{FieldName(nCont),FieldGet(nCont)})
				Endif
			Next

			dbSelectArea("SX1")
			dbSeek( padr( "CTR402" , Len( X1_GRUPO ) , ' ' ) + "01" )
			While ! Eof() .And. SX1->X1_GRUPO  == padr( "CTR402" , Len( X1_GRUPO ) , ' ' )
				AADD(aVariaveis,{Rtrim(Upper(X1_VAR01)),&(X1_VAR01)})
				dbSkip()
			EndDo

			If AliasIndic( "CVB" )
				dbSelectArea( "CVB" )
				CVB->(dbSeek( xFilial( "CVB" ) ))
				For nCont:=1 to FCount()
					If FieldName(nCont)=="CVB_CGC"
						AADD(aVariaveis,{FieldName(nCont),Transform(FieldGet(nCont),"@R 99.999.999/9999-99")})
					ElseIf FieldName(nCont)=="CVB_CPF"
						AADD(aVariaveis,{FieldName(nCont),Transform(FieldGet(nCont),"@R 999.999.999-99")})
					Else
						AADD(aVariaveis,{FieldName(nCont),FieldGet(nCont)})
					Endif
				Next
			EndIf

			AADD(aVariaveis,{"M_DIA",StrZero(Day(dDataBase),2)})
			AADD(aVariaveis,{"M_MES",MesExtenso()})
			AADD(aVariaveis,{"M_ANO",StrZero(Year(dDataBase),4)})

			If !File(cArqAbert)
				aSavSet:=__SetSets()
				cArqAbert:=CFGX024(,"Razão") // Editor de Termos de Livros
				__SetSets(aSavSet)
				Set(24,Set(24),.t.)
			Endif

			If !File(cArqEncer)
				aSavSet:=__SetSets()
				cArqEncer:=CFGX024(,"Razão") // Editor de Termos de Livros
				__SetSets(aSavSet)
				Set(24,Set(24),.t.)
			Endif

			If cArqAbert#NIL
				oReport:EndPage()
				ImpTerm2(cArqAbert,aVariaveis,,,,oReport)
			Endif

			If cArqEncer#NIL
				oReport:EndPage()
				ImpTerm2(cArqEncer,aVariaveis,,,,oReport)
			Endif
		Endif
	EndIf

	//³ Gera arquivo TXT
	If cPaisLoc == "PER"
		If Alltrim(STR(MV_PAR43)) $ "2|3" .Or. (cVersao == "11" .And. Alltrim(STR(MV_PAR37)) == "1")
			If cVersao == "11"
				GerArq(AllTrim(MV_PAR38) , cArqTmp)
			else
				GerArq(AllTrim(MV_PAR44) , cArqTmp)
			endif
		EndIf
	EndIf

	dbSelectArea("CT2")
	If !Empty(dbFilter())
		dbClearFilter()
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTR402MaxLºAutor  ³                    º Data ³  25/05/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³														      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBR402                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CTR402MaxL(nMaxLin, nLinReport)
Local oSection1	:= oReport:Section(1)
Local oSection3	:= oReport:Section(4)
Local lSalLin 	:= IIf(mv_par31==1,.T.,.F.)//"Salta linha entre contas?"

	If oSection1:Printing() .AND. lSalLin
		oReport:SkipLine()
		nLinReport++
	Endif

	nLinReport += nLin

	If nLinReport >= nMaxLin
		If nSldTransp != 0
			oSection3:Init()
			oSection3:PrintLine()
			oReport:EndPage()

			nLinReport := 11
			oSection3:PrintLine()
			oReport:SkipLine()
			oSection3:Finish()
		Else
			oReport:EndPage()
			nLinReport := 9 + nLin
	    Endif
	Endif

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpCompl  ºAutor  ³Cicero J. Silva     º Data ³  27/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna a descricao, da conta contabil, item, centro de     º±±
±±º          ³custo ou classe valor                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBR390                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpCompl(oSection2)
	oSection2:Cell("DATAL"		):Hide()
	oSection2:Cell("CORRELATIVO"):Hide()
 	oSection2:Cell("XPARTIDA"	):Hide()
	oSection2:Cell("CCUSTO"		):Hide()
	oSection2:Cell("ITEM"		):Hide()
	oSection2:Cell("NIT"		):Hide()
	oSection2:Cell("CLANCDEB"	):Hide()
	oSection2:Cell("CLANCCRD"	):Hide()
	//oSection2:Cell("CTPSLDATU"	):Hide()

	// Procura pelo complemento de historico
	dbSelectArea("CT2")
	dbSetOrder(10)//CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_SEQLAN+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC+CT2_SEQHIS   
	If MsSeek(xFilial("CT2")+cArqTMP->(DTOS(DATAL)+LOTE+SUBLOTE+DOC+SEQLAN+EMPORI+FILORI),.F.)
		dbSkip()
		If CT2->CT2_DC == "4"			//// TRATAMENTO PARA IMPRESSAO DAS CONTINUACOES DE HISTORICO
			While !CT2->(Eof()) .And.;
					CT2->CT2_FILIAL == xFilial("CT2") .And.;
					 CT2->CT2_LOTE == cArqTMP->LOTE .And.;
					  CT2->CT2_SBLOTE == cArqTMP->SUBLOTE .And.;
					   CT2->CT2_DOC == cArqTmp->DOC .And.;
						CT2->CT2_SEQLAN == cArqTmp->SEQLAN .And.;
						 CT2->CT2_EMPORI == cArqTmp->EMPORI .And.;
						  CT2->CT2_FILORI == cArqTmp->FILORI .And.;
						   CT2->CT2_DC == "4" .And.;
				    	    DTOS(CT2->CT2_DATA) == DTOS(cArqTmp->DATAL)

				oSection2:Cell("HISTORICO"):SetBlock({|| CT2->CT2_HIST } )
				oSection2:Printline()
				CT2->(dbSkip())
			EndDo
		EndIf
	EndIf

	oSection2:Cell("HISTORICO"  ):SetBlock( { || cArqTmp->HISTORICO } )
	oSection2:Cell("DATAL"		):Show()
	oSection2:Cell("CORRELATIVO"):Show()
  	oSection2:Cell("XPARTIDA"	):Show()
	oSection2:Cell("CCUSTO"		):Show()
	oSection2:Cell("ITEM"		):Show()
	oSection2:Cell("NIT"		):Show()
	oSection2:Cell("CLANCDEB"	):Show()
	oSection2:Cell("CLANCCRD"	):Show()
	//oSection2:Cell("CTPSLDATU"	):Show()

	dbSelectArea("cArqTmp")
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³f180Fil   ºAutor  ³Cicero J. Silva     º Data ³  24/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBR402                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function f180Fil(lNoMov,aSaldo,dDataIni,dDataFim)
Local lDeixa := .F.

	If !lNoMov //Se imprime conta sem movimento
		If aSaldo[6] == 0 .And. cArqTmp->LANCDEB ==0 .And. cArqTmp->LANCCRD == 0
			lDeixa	:= .T.
		Endif
	Endif

	If lNoMov .And. aSaldo[6] == 0 .And. cArqTmp->LANCDEB ==0 .And. cArqTmp->LANCCRD == 0
		If CtbExDtFim("CT1")
			dbSelectArea("CT1")
			dbSetOrder(1)//CT1_FILIAL+CT1_CONTA
			If MsSeek(xFilial()+cArqTmp->CONTA)
				If !CtbVlDtFim("CT1",dDataIni)
					lDeixa	:= .T.
	            EndIf

	            If !CtbVlDtIni("CT1",dDataFim)
					lDeixa	:= .T.
	            EndIf

		    EndIf
		EndIf
	EndIf

	dbSelectArea("cArqTmp")
Return(lDeixa)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CTBGeRaNIT³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 05/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Cria Arquivo Temporario para imprimir o Razao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³CTBGeRaNIT(oMeter,oText,oDlg,lEnd,cArqTmp,cContaIni,cContaFim³±±
±±³			  ³cCustoIni,cCustoFim,cItemIni,cItemFim,cNitIni,cNitFim,      ³±±
±±³			  ³cMoeda,dDataIni,dDataFim,aSetOfBook,lNoMov,cSaldo,lJunta,   ³±±
±±³			  ³cTipo,lAnalit)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Nome do arquivo temporario                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpO1 = Objeto oMeter                                      ³±±
±±³           ³ ExpO2 = Objeto oText                                       ³±±
±±³           ³ ExpO3 = Objeto oDlg                                        ³±±
±±³           ³ ExpL1 = Acao do Codeblock                                  ³±±
±±³           ³ ExpC1 = Arquivo temporario                                 ³±±
±±³           ³ ExpC2 = Conta Inicial                                      ³±±
±±³           ³ ExpC3 = Conta Final                                        ³±±
±±³           ³ ExpC4 = C.Custo Inicial                                    ³±±
±±³           ³ ExpC5 = C.Custo Final                                      ³±±
±±³           ³ ExpC6 = Item Inicial                                       ³±±
±±³           ³ ExpC7 = Cl.Valor Inicial                                   ³±±
±±³           ³ ExpC8 = Cl.Valor Final                                     ³±±
±±³           ³ ExpC9 = Moeda                                              ³±±
±±³           ³ ExpD1 = Data Inicial                                       ³±±
±±³           ³ ExpD2 = Data Final                                         ³±±
±±³           ³ ExpA1 = Matriz aSetOfBook                                  ³±±
±±³           ³ ExpL2 = Indica se imprime movimento zerado ou nao.         ³±±
±±³           ³ ExpC10= Tipo de Saldo                                      ³±±
±±³           ³ ExpL3 = Indica se junta CC ou nao.                         ³±±
±±³           ³ ExpC11= Tipo do lancamento                                 ³±±
±±³           ³ ExpL4 = Indica se imprime analitico ou sintetico           ³±±
±±³           ³ c2Moeda = Indica moeda 2 a ser incluida no relatorio       ³±±
±±³           ³ cUFilter= Conteudo Txt com o Filtro de Usuario (CT2)       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CTBGeRaNIT(oMeter,oText,oDlg,lEnd,cArqTmp,cContaIni,cContaFim,cCustoIni,cCustoFim,;
						cItemIni,cItemFim,cNitIni,cNitFim,cMoeda,dDataIni,dDataFim,;
						aSetOfBook,lNoMov,cSaldo,lJunta,cTipo,lAnalit,c2Moeda,;
						nTipo,cUFilter,lSldAnt,aSelFil)
Local aTamConta  := TAMSX3("CT1_CONTA")
Local aTamCusto  := TAMSX3("CT3_CUSTO")
Local aTamVal    := TAMSX3("CT2_VALOR")
Local aCtbMoeda  := {}
Local aSaveArea  := GetArea()
Local aCampos
Local nTamHist   := Len(CriaVar("CT2_HIST"))
Local nTamItem   := Len(CriaVar("CTD_ITEM"))
Local nTamNit    := Len(CriaVar("CV0_CODIGO"))
Local nDecimais  := 0
Local cMensagem  := STR0030// O plano gerencial nao esta disponivel nesse relatorio.
Local nTamFilial := IIf( lFWCodFil, FWGETTAMFILIAL, TamSx3( "CT2_FILIAL" )[1] )
Local nTamSegOfi := Len(CriaVar("CT2_SEGOFI"))
Local nTamRotina := Len(CriaVar("CT2_ROTINA"))
Local nTamNodia:= Len(CriaVar("CT2_NODIA"))
DEFAULT c2Moeda  := ""
DEFAULT nTipo    := 1
DEFAULT cUFilter := ""
DEFAULT lSldAnt  := .F.
DEFAULT aSelFil  := {}

	#IFDEF TOP
		If TcSrvType() != "AS/402" .And. cTipo == "1" .And. FunName() == 'ZCTBR402' .And. TCGetDb() $ "MSSQL7/MSSQL"
			DEFAULT cUFilter	:= ".T."
		Else
	#ENDIF
			DEFAULT cUFilter	:= ""
	#IFDEF TOP
		Endif
	#ENDIF

	// Retorna Decimais
	aCtbMoeda := CTbMoeda(cMoeda)
	nDecimais := aCtbMoeda[5]

	aCampos :={	{ "CONTA"		, "C", aTamConta[1]        , 0         },; // Codigo da Conta
				{ "XPARTIDA"   	, "C", aTamConta[1]        , 0         },; // Contra Partida
				{ "TIPO"       	, "C", 01                  , 0         },; // Tipo do Registro (Debito/Credito/Continuacao)
				{ "LANCDEB"		, "N", aTamVal[1]+2        , nDecimais },; // Debito
				{ "LANCCRD"		, "N", aTamVal[1]+2        , nDecimais },; // Credito
				{ "SALDOSCR"	, "N", aTamVal[1]+2        , nDecimais },; // Saldo
				{ "TPSLDANT"	, "C", 01                  , 0         },; // Sinal do Saldo Anterior => Consulta Razao
				{ "TPSLDATU"	, "C", 01                  , 0         },; // Sinal do Saldo Atual => Consulta Razao
				{ "HISTORICO"	, "C", nTamHist            , 0         },; // Historico
				{ "CCUSTO"		, "C", aTamCusto[1]        , 0         },; // Centro de Custo
				{ "ITEM"		, "C", nTamItem            , 0         },; // Item Contabil
				{ "NIT"			, "C", nTamNit             , 0         },; // Classe de Valor
				{ "DATAL"		, "D", 10                  , 0         },; // Data do Lancamento
				{ "LOTE" 		, "C", 06                  , 0         },; // Lote
				{ "SUBLOTE" 	, "C", 03                  , 0         },; // Sub-Lote
				{ "DOC" 		, "C", 06                  , 0         },; // Documento
				{ "LINHA"		, "C", Len(CT2->CT2_LINHA) , 0         },; // Linha  03
				{ "SEQLAN"		, "C", Len(CT2->CT2_SEQLAN), 0         },; // Sequencia do Lancamento  03
				{ "SEQHIST"     , "C", 03                  , 0         },; // Seq do Historico
				{ "EMPORI"		, "C", 02                  , 0         },; // Empresa Original
				{ "FILORI"		, "C", nTamFilial          , 0         },; // Filial Original
				{ "NOMOV"		, "L", 01                  , 0         },; // Conta Sem Movimento
				{ "FILIAL"		, "C", nTamFilial          , 0         },; // Filial do sistema
				{ "SEGOFI"		, "C", nTamSegOfi          , 0         },; // Numero do Correlativo
				{ "NODIA"		, "C", nTamNodia	   , 0         },; // Numero do Correlativo - NODIA
				{ "MOEDAL"		, "C", Len(CT2->CT2_MOEDLC), 0         },;
				{ "ROTINA"		, "C", nTamRotina          , 0         },;
				{ "NRECNO"		, "N", aTamVal[1]+2        , 0         }}

	If ! Empty(c2Moeda)
		Aadd(aCampos, { "LANCDEB_1"	, "N", aTamVal[1]+2, nDecimais }) // Debito
		Aadd(aCampos, { "LANCCRD_1"	, "N", aTamVal[1]+2, nDecimais }) // Credito
		Aadd(aCampos, { "TXDEBITO"	, "N", aTamVal[1]+2, 6         }) // Taxa Debito
		Aadd(aCampos, { "TXCREDITO"	, "N", aTamVal[1]+2, 6         }) // Taxa Credito
	Endif
	
	// campo adicionado
	// ----------------
	Aadd(aCampos, { "DIACTB", "C", TamSX3("CT2_DIACTB")[1], 0		}) // codigo del libro
	Aadd(aCampos, { "DOCUMENTO","C", 20, 0         					}) // DOCUMENTO - SERIE-DOC
	Aadd(aCampos, { "LP","C", TAMSX3("CT2_LP")[1], 0   				}) // LP
	Aadd(aCampos, { "XKEY","C", TAMSX3("CT2_KEY")[1], 0  			}) // KEY

	// Se o arquivo temporario de trabalho esta aberto
	If ( Select ( "cArqTmp" ) > 0 )
		cArqTmp->(dbCloseArea())
	Endif

	CTBR402CT(aCampos, cTipo, lAnalit, FunName()) //Creación de tabla temporal cArqTmp
	
	cArqTmp->(dbSetOrder(1))
	
	If !Empty(aSetOfBook[5])
		MsgAlert(cMensagem)
		Return
	EndIf

	#IFDEF TOP
		If TcSrvType() != "AS/402" .And. cTipo == "1" .And. FunName() == 'ZCTBR402' .And. TCGetDb() $ "MSSQL7/MSSQL"
			CtbQryRNIT(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,cCustoIni,cCustoFim,;
					cItemIni,cItemFim,cNitIni,cNitFim,cMoeda,dDataIni,dDataFim,;
					aSetOfBook,lNoMov,cSaldo,lJunta,cTipo,c2Moeda,cUFilter,lSldAnt,aSelFil)
		Else
	#ENDIF
			// Monta Arquivo para gerar o Razao
			CtbRazNIT(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,cCustoIni,cCustoFim,;
					cItemIni,cItemFim,cNitIni,cNitFim,cMoeda,dDataIni,dDataFim,;
					aSetOfBook,lNoMov,cSaldo,lJunta,cTipo,c2Moeda,nTipo,cUFilter,lSldAnt,aSelFil)
	#IFDEF TOP
		EndIf
	#ENDIF

RestArea(aSaveArea)
Return cArqTmp

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CtbRazNIT ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 05/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Realiza a "filtragem" dos registros do Razao                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³CtbRazNIT(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,       ³±±
±±³			  ³cCustoIni,cCustoFim, cItemIni,cItemFim,cNitIni,cNitFim,     ³±±
±±³			  ³cMoeda,dDataIni,dDataFim,aSetOfBook,lNoMov,cSaldo,lJunta,   ³±±
±±³			  ³cTipo)                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpO1 = Objeto oMeter                                      ³±±
±±³           ³ ExpO2 = Objeto oText                                       ³±±
±±³           ³ ExpO3 = Objeto oDlg                                        ³±±
±±³           ³ ExpL1 = Acao do Codeblock                                  ³±±
±±³           ³ ExpC2 = Conta Inicial                                      ³±±
±±³           ³ ExpC3 = Conta Final                                        ³±±
±±³           ³ ExpC4 = C.Custo Inicial                                    ³±±
±±³           ³ ExpC5 = C.Custo Final                                      ³±±
±±³           ³ ExpC6 = Item Inicial                                       ³±±
±±³           ³ ExpC7 = Cl.Valor Inicial                                   ³±±
±±³           ³ ExpC8 = Cl.Valor Final                                     ³±±
±±³           ³ ExpC9 = Moeda                                              ³±±
±±³           ³ ExpD1 = Data Inicial                                       ³±±
±±³           ³ ExpD2 = Data Final                                         ³±±
±±³           ³ ExpA1 = Matriz aSetOfBook                                  ³±±
±±³           ³ ExpL2 = Indica se imprime movimento zerado ou nao.         ³±±
±±³           ³ ExpC10= Tipo de Saldo                                      ³±±
±±³           ³ ExpL3 = Indica se junta CC ou nao.                         ³±±
±±³           ³ ExpC11= Tipo do lancamento                                 ³±±
±±³           ³ c2Moeda = Indica moeda 2 a ser incluida no relatorio       ³±±
±±³           ³ cUFilter= Conteudo Txt com o Filtro de Usuario (CT2)       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CtbRazNIT(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,cCustoIni,cCustoFim,;
					  	cItemIni,cItemFim,cNitIni,cNitFim,cMoeda,dDataIni,dDataFim,;
					  	aSetOfBook,lNoMov,cSaldo,lJunta,cTipo,c2Moeda,nTipo,cUFilter,lSldAnt,aSelFil)
Local cCpoChave  := ""
Local cTmpChave  := ""
Local cContaI    := ""
Local cContaF    := ""
Local cCustoI    := ""
Local cCustoF    := ""
Local cItemI     := ""
Local cItemF     := ""
Local cNitI      := ""
Local cNitF      := ""
Local cVldEnt    := ""
Local cAlias    := ""
Local lUFilter   := !Empty(cUFilter)			//// SE O FILTRO DE USUÁRIO NÃO ESTIVER VAZIO - TEM FILTRO DE USUÁRIO
Local cFilMoeda  := ""
Local cAliasCT2  := "CT2"
Local bCond      := {||.T.}
Local cQryFil    := '' // variavel de condicional da query
Local cTmpCT2Fil

#IFDEF TOP
	Local cQuery   := ""
	Local cOrderBy := ""
	Local nI       := 0
	Local aStru    := {}
#ENDIF

DEFAULT cUFilter := ".T."
DEFAULT lSldAnt	  := .F.
DEFAULT aSelFil  := {}

	cQryFil := " CT2_FILIAL " + GetRngFil( aSelFil ,"CT2", .T., @cTmpCT2Fil)

	cCustoI	:= cCustoIni
	cCustoF := cCustoFim
	cContaI	:= cContaIni
	cContaF := cContaFim
	cItemI	:= cItemIni
	cItemF 	:= cItemFim
	cNitI	:= cNitIni
	cNitF 	:= cNitFim

	#IFDEF TOP
		If TcSrvType() != "AS/402"
			If !Empty(c2Moeda)
				cFilMoeda	:= " (CT2_MOEDLC = '" + cMoeda + "' OR "
				cFilMoeda	+= " CT2_MOEDLC = '" + c2Moeda + "') "
			Else
				cFilMoeda	:= " CT2_MOEDLC = '" + cMoeda + "' "
			EndIf
		Else
	#ENDIF
			If !Empty(c2Moeda)
				cFilMoeda	:= " (CT2_MOEDLC = '" + cMoeda + "' .Or. "
				cFilMoeda	+= " CT2_MOEDLC = '" + c2Moeda + "') "
			Else
				cFilMoeda	:= " CT2_MOEDLC = '" + cMoeda + "' "
			EndIf
	#IFDEF TOP
		EndIf
	#ENDIF

	oMeter:nTotal := CT1->(RecCount())

	// ³ Obt‚m os d‚bitos
	If cTipo <> "1"
		If cTipo = "2" .And. Empty(cCustoIni)
			CTT->(DbSeek(xFilial("CTT")))
			cCustoIni := CTT->CTT_CUSTO
		Endif
		If cTipo = "3" .And. Empty(cItemIni)
			CTD->(DbSeek(xFilial("CTD")))
			cItemIni := CTD->CTD_ITEM
		Endif
		If cTipo = "4" .And. Empty(cNitIni)
			CV0->(DbSeek(xFilial("CV0")+"01"))
			cClVlIni := CV0->CV0_CODIGO
		Endif
	Endif

	#IFDEF TOP
		If TcSrvType() != "AS/402"

			If cTipo == "1"
				dbSelectArea("CT2")
				dbSetOrder(2)//CT2_FILIAL+CT2_DEBITO+DTOS(CT2_DATA)  
				cValid	:= 	"CT2_DEBITO>='" + cContaIni + "' AND " +;
							"CT2_DEBITO<='" + cContaFim + "'"
				cVldEnt := 	"CT2_CCD>='" + cCustoIni + "' AND " +;
							"CT2_CCD<='" + cCustoFim + "' AND " +;
							"CT2_ITEMD>='" + cItemIni + "' AND " +;
							"CT2_ITEMD<='" + cItemFim + "' AND " +;
							"CT2_EC05DB>='" + cNitIni + "' AND " +;
							"CT2_EC05DB<='" + cNitFim + "'"
				cOrderBy:= " CT2_FILIAL, CT2_DEBITO, CT2_DATA "
			ElseIf cTipo == "2"
				dbSelectArea("CT2")
				dbSetOrder(4)//CT2_FILIAL+CT2_CCD+DTOS(CT2_DATA) 
				cValid	:= 	"CT2_CCD >= '" + cCustoIni + "'  AND  " +;
							"CT2_CCD <= '" + cCustoFim + "'"
				cVldEnt := 	"CT2_DEBITO >= '" + cContaIni + "'  AND  " +;
							"CT2_DEBITO <= '" + cContaFim + "'  AND  " +;
							"CT2_ITEMD >= '" + cItemIni + "'  AND  " +;
							"CT2_ITEMD <= '" + cItemFim + "'  AND  " +;
							"CT2_EC05DB >= '" + cNitIni + "'  AND  " +;
							"CT2_EC05DB <= '" + cNitFim + "'"
				cOrderBy:= " CT2_FILIAL, CT2_CCD, CT2_DATA "
			ElseIf cTipo == "3"
				dbSelectArea("CT2")
				dbSetOrder(6)//CT2_FILIAL+CT2_ITEMD+DTOS(CT2_DATA)  
				cValid 	:= 	"CT2_ITEMD >= '" + cItemIni + "'  AND  " +;
							"CT2_ITEMD <= '" + cItemFim + "'"
				cVldEnt	:= 	"CT2_DEBITO >= '" + cContaIni + "'  AND  " +;
							"CT2_DEBITO <= '" + cContaFim + "'  AND  " +;
							"CT2_CCD >= '" + cCustoIni + "'  AND  " +;
							"CT2_CCD <= '" + cCustoFim + "'  AND  " +;
							"CT2_EC05DB >= '" + cNitIni + "'  AND  " +;
							"CT2_EC05DB <= '" + cNitFim + "'"
				cOrderBy:= " CT2_FILIAL, CT2_ITEMD, CT2_DATA "
			ElseIf cTipo == "4"
				dbSelectArea("CT2")
				dbSetOrder(8)//CT2_FILIAL+CT2_CLVLDB+DTOS(CT2_DATA)  
				cValid 	:= 	"CT2_EC05DB >= '" + cNitIni + "'  AND  " +;
							"CT2_EC05DB <= '" + cNitFim + "'"
				cVldEnt	:= 	"CT2_DEBITO >= '" + cContaIni + "'  AND  " +;
							"CT2_DEBITO <= '" + cContaFim + "'  AND  " +;
							"CT2_CCD >= '" + cCustoIni + "'  AND  " +;
							"CT2_CCD <= '" + cCustoFim + "'  AND  " +;
							"CT2_ITEMD >= '" + cItemIni + "'  AND  " +;
							"CT2_ITEMD <= '" + cItemFim + "'"
				cOrderBy:= " CT2_FILIAL, CT2_EC05DB, CT2_DATA "
			EndIf

			cAliasCT2	:= "cAliasCT2"

			cQuery	:= " SELECT * "
			cQuery	+= " FROM " + RetSqlName("CT2")
			cQuery	+= " WHERE " + cQryFil + " AND "
			cQuery	+= cValid + " AND "
			cQuery	+= " CT2_DATA >= '" + DTOS(dDataIni) + "' AND "
			cQuery	+= " CT2_DATA <= '" + DTOS(dDataFim) + "' AND "
			cQuery	+= cVldEnt+ " AND "
			cQuery	+= cFilMoeda + " AND "
			cQuery	+= " CT2_TPSALD = '"+ cSaldo + "'"
			cQuery	+= " AND (CT2_DC = '1' OR CT2_DC = '3')"
			cQuery	+= " AND D_E_L_E_T_ = ' ' "
			cQuery	+= " ORDER BY "+ cOrderBy
			cQuery  := ChangeQuery(cQuery)

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCT2,.T.,.F.)
			aStru := CT2->(dbStruct())

			For nI := 1 to Len(aStru)
				If aStru[nI,2] != 'C'
					TCSetField(cAliasCT2, aStru[nI,1], aStru[nI,2],aStru[nI,3],aStru[nI,4])
				Endif
			Next nI

			If lUFilter					//// ADICIONA O FILTRO DEFINIDO PELO USUÁRIO SE NÃO ESTIVER EM BRANCO
				If !Empty(cVldEnt)
					cVldEnt  += " AND "			/// SE JÁ TIVER CONTEUDO, ADICIONA "AND"
					cVldEnt  += cUFilter				/// ADICIONA O FILTRO DE USUÁRIO
				EndIf
			EndIf

			If (!lUFilter) .or. Empty(cUFilter)
				cUFilter := ".T."
			EndIf

			dbSelectArea(cAliasCT2)
			While !Eof()
				If &cUFilter
					CtbGrvRNIT(lJunta,cMoeda,cSaldo,"1",c2Moeda,cAliasCT2,nTipo)
					dbSelectArea(cAliasCT2)
				EndIf
				dbSkip()
			EndDo
			If ( Select ( "cAliasCT2" ) <> 0 )
				dbSelectArea( "cAliasCT2" )
				dbCloseArea()
			Endif

	    Else
	#ENDIF
			If cTipo == "1"
				dbSelectArea("CT2")
				dbSetOrder(2)//CT2_FILIAL+CT2_DEBITO+DTOS(CT2_DATA) 
				cValid	:= 	"CT2_DEBITO>='" + cContaIni + "' .And. " +;
							"CT2_DEBITO<='" + cContaFim + "'"
				cVldEnt := 	"CT2_CCD>='" + cCustoIni + "' .And. " +;
							"CT2_CCD<='" + cCustoFim + "' .And. " +;
							"CT2_ITEMD>='" + cItemIni + "' .And. " +;
							"CT2_ITEMD<='" + cItemFim + "' .And. " +;
							"CT2_EC05DB>='" + cNitIni + "' .And. " +;
							"CT2_EC05DB<='" + cNitFim + "'"
				bCond 	:= { ||CT2->CT2_DEBITO >= cContaIni .And. CT2->CT2_DEBITO <= cContaFim}
			ElseIf cTipo == "2"
				dbSelectArea("CT2")
				dbSetOrder(4)//CT2_FILIAL+CT2_CCD+DTOS(CT2_DATA)   
				cValid	:= 	"CT2_CCD >= '" + cCustoIni + "'  .And.  " +;
							"CT2_CCD <= '" + cCustoFim + "'"
				cVldEnt := 	"CT2_DEBITO >= '" + cContaIni + "'  .And.  " +;
							"CT2_DEBITO <= '" + cContaFim + "'  .And.  " +;
							"CT2_ITEMD >= '" + cItemIni + "'  .And.  " +;
							"CT2_ITEMD <= '" + cItemFim + "'  .And.  " +;
							"CT2_EC05DB >= '" + cNitIni + "'  .And.  " +;
							"CT2_EC05DB <= '" + cNitFim + "'"
			ElseIf cTipo == "3"
				dbSelectArea("CT2")
				dbSetOrder(6)//CT2_FILIAL+CT2_ITEMD+DTOS(CT2_DATA)   
				cValid 	:= 	"CT2_ITEMD >= '" + cItemIni + "'  .And.  " +;
							"CT2_ITEMD <= '" + cItemFim + "'"
				cVldEnt	:= 	"CT2_DEBITO >= '" + cContaIni + "'  .And.  " +;
							"CT2_DEBITO <= '" + cContaFim + "'  .And.  " +;
							"CT2_CCD >= '" + cCustoIni + "'  .And.  " +;
							"CT2_CCD <= '" + cCustoFim + "'  .And.  " +;
							"CT2_EC05DB >= '" + cNitIni + "'  .And.  " +;
							"CT2_EC05DB <= '" + cNitFim + "'"
			ElseIf cTipo == "4"
				dbSelectArea("CT2")
				dbSetOrder(8)//CT2_FILIAL+CT2_CLVLDB+DTOS(CT2_DATA)   
				cValid 	:= 	"CT2_EC05DB >= '" + cNitIni + "'  .And.  " +;
							"CT2_EC05DB <= '" + cNitFim + "'"
				cVldEnt	:= 	"CT2_DEBITO >= '" + cContaIni + "'  .And.  " +;
							"CT2_DEBITO <= '" + cContaFim + "'  .And.  " +;
							"CT2_CCD >= '" + cCustoIni + "'  .And.  " +;
							"CT2_CCD <= '" + cCustoFim + "'  .And.  " +;
							"CT2_ITEMD >= '" + cItemIni + "'  .And.  " +;
							"CT2_ITEMD <= '" + cItemFim + "'"
			EndIf

			If lUFilter					//// ADICIONA O FILTRO DEFINIDO PELO USUÁRIO SE NÃO ESTIVER EM BRANCO
				If !Empty(cVldEnt)
					cVldEnt  += " .and. "			/// SE JÁ TIVER CONTEUDO, ADICIONA ".AND."
				EndIf
			Endif

			cVldEnt  += cUFilter				/// ADICIONA O FILTRO DE USUÁRIO

			If cTipo == "1"						/// TRATAMENTO CONTAS A CREDITO

				dbSelectArea("CT2")
				dbSetOrder(2)//CT2_FILIAL+CT2_DEBITO+DTOS(CT2_DATA)      

				dbSelectArea("CT1")
				dbSetOrder(3)//CT1_FILIAL+CT1_CLASSE+CT1_CONTA
				cFilCT1 := xFilial("CT1")
				cFilCT2	:= xFilial("CT2")
				cContaIni := If(Empty(cContaIni),"",cContaIni)		/// Se tiver espacos em branco usa "" p/ seek
				dbSeek(cFilCT1+"2"+cContaIni,.T.)					/// Procura inicial analitica

				While CT1->(!Eof()) .and. CT1->CT1_FILIAL == cFilCT1 .And. CT1->CT1_CONTA <= cContaFim
					dbSelectArea("CT2")
					MsSeek(cFilCT2+CT1->CT1_CONTA+DTOS(dDataIni),.T.)
					While !Eof() .And. CT2->CT2_FILIAL == cFilCT2 .And. CT2->CT2_DEBITO == CT1->CT1_CONTA .and. CT2->CT2_DATA <= dDataFim

						If CT2->CT2_VALOR = 0
							dbSkip()
							Loop
						EndIf

						If Empty(c2Moeda)
							If CT2->CT2_MOEDLC <> cMoeda
								dbSkip()
								Loop
							EndIF
						Else
							If !(&(cFilMoeda))
								dbSkip()
								Loop
							EndIf
						EndIf

						If (CT2->CT2_DC == "1" .Or. CT2->CT2_DC == "3") .And. &(cValid) .And. &(cVldEnt) .And. CT2->CT2_TPSALD == cSaldo
							CT2->(CtbGrvRNIT(lJunta,cMoeda,cSaldo,"1",c2Moeda,cAliasCT2,nTipo))
						Endif
						dbSelectArea("CT2")
						dbSkip()
					EndDo
					CT1->(dbSkip())
				EndDo
			Else
				dbSelectArea("CT2")

				cTabCad := "CTT"
				cEntIni	:= cCustoIni
				bCond 	:= { || CT2->CT2_CCD == CTT->CTT_CUSTO}
				bCondCad:= { || .T.}
				dbSetOrder(4)//CT2_FILIAL+CT2_CCD+DTOS(CT2_DATA)   

				If cTipo == "3"
					cTabCad := "CTD"
					cEntIni := cItemIni
					bCond 	:= { || CT2->CT2_ITEMD == CTD->CTD_ITEM}
					dbSetOrder(6)//CT2_FILIAL+CT2_ITEMD+DTOS(CT2_DATA)    
				ElseIf cTipo == "4"
					cTabCad := "CV0"
					cEntIni := cNitIni
					bCond 	:= { || CT2->CT2_EC05DB == CV0->CV0_CODIGO}
					dbSetOrder(8)//CT2_FILIAL+CT2_CLVLDB+DTOS(CT2_DATA)    
				EndIf

				dbSelectArea(cTabCad)
				//CTT - CTT_FILIAL+CTT_CLASSE+CTT_CUSTO   
				//CTD - CTD_FILIAL+CTD_CLASSE+CTD_ITEM    
				//CV0 - CV0_FILIAL+CV0_CODIGO   
				dbSetOrder(2)
				cFilEnt := xFilial(cTabCad)
				cFilCT2	:= xFilial("CT2")
				cEntIni := If(Empty(cEntIni),"",cEntIni)		/// Se tiver espacos em branco usa "" p/ seek
				dbSeek(cFilEnt+"2"+cEntIni,.T.)					/// Procura inicial analitica

				If cTipo == "2"
					bCondCad := {|| CTT->CTT_FILIAL == cFilEnt .and. CTT->CTT_CUSTO <= cCustoFim }
				ElseIf cTipo == "3"
		   			bCondCad := {|| CTD->CTD_FILIAL == cFilEnt .and. CTD->CTD_ITEM <= cItemFim }
		  		ElseIf cTipo == "4"
					bCondCad := {|| CTH->CTH_FILIAL == cFilEnt .and. CV0->CV0_CODIGO <= cNitFim }
		  		EndIf

				While (cTabCad)->(!Eof()) .and. Eval(bCondCad)			/// WHILE DO CADASTRO DE ENTIDADES

					dbSelectArea("CT2")
					If cTipo == "2"
						MsSeek(cFilCT2+CTT->CTT_CUSTO+DTOS(dDataIni),.T.)
					ElseIf cTipo == "3"
						MsSeek(cFilCT2+CTD->CTD_ITEM+DTOS(dDataIni),.T.)
					Else
						MsSeek(cFilCT2+CV0->CV0_CODIGO+DTOS(dDataIni),.T.)
					EndIf

					dbSelectArea("CT2")									/// WHILE CT2 - DEBITOS
					While CT2->(!Eof()) .And. CT2->CT2_FILIAL == cFilCT2 .and. Eval(bCond) .and. CT2->CT2_DATA <= dDataFim

						If CT2->CT2_VALOR = 0
							dbSkip()
							Loop
						EndIf

						If Empty(c2Moeda)
							If CT2->CT2_MOEDLC <> cMoeda
								dbSkip()
								Loop
							EndIF
						Else
							If !(&(cFilMoeda))
								dbSkip()
								Loop
							EndIf
						EndIf

						If (CT2->CT2_DC == "1" .Or. CT2->CT2_DC == "3") .And. &(cVldEnt) .And. CT2->CT2_TPSALD == cSaldo
							CT2->(CtbGrvRNIT(lJunta,cMoeda,cSaldo,"1",c2Moeda,cAliasCT2,nTipo))
						Endif
						dbSelectArea("CT2")
						dbSkip()
					EndDo
					(cTabCad)->(dbSkip())
				EndDo
			Endif
	#IFDEF TOP
		EndIf
	#ENDIF

	// ³ Obt‚m os creditos
	If cTipo == "1"
		dbSelectArea("CT2")
		dbSetOrder(3)//CT2_FILIAL+CT2_CREDIT+DTOS(CT2_DATA)   
	ElseIf cTipo == "2"
		dbSelectArea("CT2")
		dbSetOrder(5)//CT2_FILIAL+CT2_CCC+DTOS(CT2_DATA) 
	ElseIf cTipo == "3"
		dbSelectArea("CT2")
		dbSetOrder(7)//CT2_FILIAL+CT2_ITEMC+DTOS(CT2_DATA)
	ElseIf cTipo == "4"
		dbSelectArea("CT2")
		dbSetOrder(9) //CT2_FILIAL+CT2_CLVLCR+DTOS(CT2_DATA)      
	EndIf

	#IFDEF TOP
		If TcSrvType() != "AS/402"
			If cTipo == "1"
				cValid	:= 	"CT2_CREDIT>='" + cContaIni + "' AND " +;
							"CT2_CREDIT<='" + cContaFim + "'"
				cVldEnt :=	"CT2_CCC>='" + cCustoIni + "' AND " +;
							"CT2_CCC<='" + cCustoFim + "' AND " +;
							"CT2_ITEMC>='" + cItemIni + "' AND " +;
							"CT2_ITEMC<='" + cItemFim + "' AND " +;
							"CT2_EC05CR>='" + cNitIni + "' AND " +;
							"CT2_EC05CR<='" + cNitFim + "'"
				cOrderBy:= " CT2_FILIAL, CT2_CREDIT, CT2_DATA "
			ElseIf cTipo == "2"
				cValid 	:= 	"CT2_CCC >= '" + cCustoIni + "'  AND  " +;
							"CT2_CCC <= '" + cCustoFim + "'"
				cVldEnt	:= 	"CT2_CREDIT >= '" + cContaIni + "'  AND  " +;
							"CT2_CREDIT <= '" + cContaFim + "'  AND  " +;
							"CT2_ITEMC >= '" + cItemIni + "'  AND  " +;
							"CT2_ITEMC <= '" + cItemFim + "'  AND  " +;
							"CT2_EC05CR >= '" + cNitIni + "'  AND  " +;
							"CT2_EC05CR <= '" + cNitFim + "'"
				cOrderBy:= " CT2_FILIAL, CT2_CCC, CT2_DATA "
			ElseIf cTipo == "3"
				cValid 	:= 	"CT2_ITEMC >= '" + cItemIni + "'  AND  " +;
							"CT2_ITEMC <= '" + cItemFim + "'"
				cVldEnt := 	"CT2_CREDIT >= '" + cContaIni + "'  AND  " +;
							"CT2_CREDIT <= '" + cContaFim + "'  AND  " +;
							"CT2_CCC >= '" + cCustoIni + "'  AND  " +;
							"CT2_CCC <= '" + cCustoFim + "'  AND  " +;
							"CT2_EC05CR >= '" + cNitIni + "'  AND  " +;
							"CT2_EC05CR <= '" + cNitFim + "'"
				cOrderBy:= " CT2_FILIAL, CT2_ITEMC, CT2_DATA "
			ElseIf cTipo == "4"
				cValid 	:= 	"CT2_EC05CR >= '" + cNitIni + "'  AND  " +;
							"CT2_EC05CR <= '" + cNitFim + "'"
				cVldEnt := 	"CT2_CREDIT >= '" + cContaIni + "'  AND  " +;
							"CT2_CREDIT <= '" + cContaFim + "'  AND  " +;
							"CT2_CCC >= '" + cCustoIni + "'  AND  " +;
							"CT2_CCC <= '" + cCustoFim + "'  AND  " +;
							"CT2_ITEMC >= '" + cItemIni + "'  AND  " +;
							"CT2_ITEMC <= '" + cItemFim + "'"
				cOrderBy:= " CT2_FILIAL, CT2_EC05CR, CT2_DATA "
			EndIf

			cAliasCT2	:= "cAliasCT2"

			cQuery	:= " SELECT * "
			cQuery	+= " FROM " + RetSqlName("CT2")
			cQuery	+= " WHERE " + cQryFil + " AND "
			cQuery	+= cValid + " AND "
			cQuery	+= " CT2_DATA >= '" + DTOS(dDataIni) + "' AND "
			cQuery	+= " CT2_DATA <= '" + DTOS(dDataFim) + "' AND "
			cQuery	+= cVldEnt+ " AND "
			cQuery	+= cFilMoeda + " AND "
			cQuery	+= " CT2_TPSALD = '"+ cSaldo + "' AND "
			cQuery	+= " (CT2_DC = '2' OR CT2_DC = '3') AND "
			cQuery	+= " D_E_L_E_T_ = ' ' "
			cQuery	+= " ORDER BY "+ cOrderBy
			cQuery := ChangeQuery(cQuery)

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCT2,.T.,.F.)

			aStru := CT2->(dbStruct())

			For nI := 1 to Len(aStru)
				If aStru[nI,2] != 'C'
					TCSetField(cAliasCT2, aStru[nI,1], aStru[nI,2],aStru[nI,3],aStru[nI,4])
				Endif
			Next nI


			If lUFilter					//// ADICIONA O FILTRO DEFINIDO PELO USUÁRIO SE NÃO ESTIVER EM BRANCO
				If !Empty(cVldEnt)
					cVldEnt  += " AND "			/// SE JÁ TIVER CONTEUDO, ADICIONA "AND"
					cVldEnt  += cUFilter				/// ADICIONA O FILTRO DE USUÁRIO
				EndIf
			EndIf

			If (!lUFilter) .or. Empty(cUFilter)
				cUFilter := ".T."
			EndIf

			dbSelectArea(cAliasCT2)
			While !Eof()
				If &cUFilter
					CtbGrvRNIT(lJunta,cMoeda,cSaldo,"2",c2Moeda,cAliasCT2,nTipo)
					dbSelectArea(cAliasCT2)
			    EndIf
				dbSkip()
			EndDo

			If ( Select ( "cAliasCT2" ) <> 0 )
				dbSelectArea ( "cAliasCT2" )
				dbCloseArea ()
			Endif

		Else
	#ENDIF
			bCond	:= {||.T.}

			If cTipo == "1"
				cValid	:= 	"CT2_CREDIT>='" + cContaIni + "'.And." +;
							"CT2_CREDIT<='" + cContaFim + "'"
				cVldEnt :=	"CT2_CCC>='" + cCustoIni + "'.And." +;
							"CT2_CCC<='" + cCustoFim + "'.And." +;
							"CT2_ITEMC>='" + cItemIni + "'.And." +;
							"CT2_ITEMC<='" + cItemFim + "'.And." +;
							"CT2_EC05CR>='" + cNitIni + "'.And." +;
							"CT2_EC05CR<='" + cNitFim + "'"
				bCond 	:= { ||CT2->CT2_CREDIT >= cContaIni .And. CT2->CT2_CREDIT <= cContaFim}
			ElseIf cTipo == "2"
				cValid 	:= 	"CT2_CCC >= '" + cCustoIni + "' .And. " +;
							"CT2_CCC <= '" + cCustoFim + "'"
				cVldEnt	:= 	"CT2_CREDIT >= '" + cContaIni + "' .And. " +;
							"CT2_CREDIT <= '" + cContaFim + "' .And. " +;
							"CT2_ITEMC >= '" + cItemIni + "' .And. " +;
							"CT2_ITEMC <= '" + cItemFim + "' .And. " +;
							"CT2_EC05CR >= '" + cNitIni + "' .And. " +;
							"CT2_EC05CR <= '" + cNitFim + "'"
			ElseIf cTipo == "3"
				cValid 	:= 	"CT2_ITEMC >= '" + cItemIni + "' .And. " +;
							"CT2_ITEMC <= '" + cItemFim + "'"
				cVldEnt := 	"CT2_CREDIT >= '" + cContaIni + "' .And. " +;
							"CT2_CREDIT <= '" + cContaFim + "' .And. " +;
							"CT2_CCC >= '" + cCustoIni + "' .And. " +;
							"CT2_CCC <= '" + cCustoFim + "' .And. " +;
							"CT2_EC05CR >= '" + cNitIni + "' .And. " +;
							"CT2_EC05CR <= '" + cNitFim + "'"
			ElseIf cTipo == "4"
				cValid 	:= 	"CT2_EC05CR >= '" + cNitIni + "' .And. " +;
							"CT2_EC05CR <= '" + cNitFim + "'"
				cVldEnt := 	"CT2_CREDIT >= '" + cContaIni + "' .And. " +;
							"CT2_CREDIT <= '" + cContaFim + "' .And. " +;
							"CT2_CCC >= '" + cCustoIni + "' .And. " +;
							"CT2_CCC <= '" + cCustoFim + "' .And. " +;
							"CT2_ITEMC >= '" + cItemIni + "' .And. " +;
							"CT2_ITEMC <= '" + cItemFim + "'"
			EndIf

			If lUFilter					//// ADICIONA O FILTRO DEFINIDO PELO USUÁRIO SE NÃO ESTIVER EM BRANCO
				If !Empty(cVldEnt)
					cVldEnt  += " .and. "			/// SE JÁ TIVER CONTEUDO, ADICIONA ".AND."
				EndIf
			Endif

			cVldEnt  += cUFilter				/// ADICIONA O FILTRO DE USUÁRIO
			If cTipo == "1"						/// TRATAMENTO CONTAS A CREDITO
				dbSelectArea("CT2")
				dbSetOrder(3)//CT2_FILIAL+CT2_CREDIT+DTOS(CT2_DATA) 

				dbSelectArea("CT1")
				dbSetOrder(3)//CT1_FILIAL+CT1_CLASSE+CT1_CONTA 
				cFilCT1 := xFilial("CT1")
				cFilCT2	:= xFilial("CT2")
				cContaIni := If(Empty(cContaIni),"",cContaIni)		/// Se tiver espacos em branco usa "" p/ seek
				dbSeek(cFilCT1+"2"+cContaIni,.T.)					/// Procura inicial analitica

				While CT1->(!Eof()) .and. CT1->CT1_FILIAL == cFilCT1 .And. CT1->CT1_CONTA <= cContaFim
					dbSelectArea("CT2")
					MsSeek(cFilCT2+CT1->CT1_CONTA+DTOS(dDataIni),.T.)
					While !Eof() .And. CT2->CT2_FILIAL == cFilCT2 .And. CT2->CT2_CREDIT == CT1->CT1_CONTA .and. CT2->CT2_DATA <= dDataFim

						If CT2->CT2_VALOR = 0
							dbSkip()
							Loop
						EndIf

						If (CT2->CT2_DC == "2" .Or. CT2->CT2_DC == "3") .And. &(cValid) .And. &(cVldEnt) .And. CT2->CT2_TPSALD == cSaldo
							If Empty(c2Moeda)
								If CT2->CT2_MOEDLC <> cMoeda
									dbSkip()
									Loop
								EndIF
							Else
								If !(&(cFilMoeda))
									dbSkip()
									Loop
								EndIf
							EndIf
							CT2->(CtbGrvRNIT(lJunta,cMoeda,cSaldo,"2",c2Moeda,cAliasCT2,nTipo))
						Endif
						dbSelectArea("CT2")
						dbSkip()
					EndDo
					CT1->(dbSkip())
				EndDo
			Else
				dbSelectArea("CT2")

				cTabCad := "CTT"
				cEntIni	:= cCustoIni
				bCond 	:= { || CT2->CT2_CCC == CTT->CTT_CUSTO}
				bCondCad:= { || .T.}
				dbSetOrder(5)//CTT_FILIAL+CTT_CCSUP

				If cTipo == "3"
					cTabCad := "CTD"
					cEntIni := cItemIni
					bCond 	:= { || CT2->CT2_ITEMC == CTD->CTD_ITEM}
					dbSetOrder(7)
				ElseIf cTipo == "4"
					cTabCad := "CTH"
					cEntIni := cNitIni
					bCond 	:= { || CT2->CT2_EC05CR == CV0->CV0_CODIGO}
					dbSetOrder(9)
				EndIf

				dbSelectArea(cTabCad)
				//CTD - CTD_FILIAL+CTD_CLASSE+CTD_ITEM 
				//CTH - CTH_FILIAL+CTH_CLASSE+CTH_CLVL        
				dbSetOrder(2)
				cFilEnt := xFilial(cTabCad)
				cFilCT2	:= xFilial("CT2")
				cEntIni := If(Empty(cEntIni),"",cEntIni)		/// Se tiver espacos em branco usa "" p/ seek
				dbSeek(cFilEnt+"2"+cEntIni,.T.)					/// Procura inicial analitica

				If cTipo == "2"
					bCondCad := {|| CTT->CTT_FILIAL == cFilEnt .and. CTT->CTT_CUSTO <= cCustoFim }
				ElseIf cTipo == "3"
		   			bCondCad := {|| CTD->CTD_FILIAL == cFilEnt .and. CTD->CTD_ITEM <= cItemFim }
		  		ElseIf cTipo == "4"
					bCondCad := {|| CTH->CTH_FILIAL == cFilEnt .and. CV0->CV0_CODIGO <= cNitFim }
		  		EndIf

				While (cTabCad)->(!Eof()) .and. Eval(bCondCad)			/// WHILE DO CADASTRO DE ENTIDADES
					dbSelectArea("CT2")
					If cTipo == "2"
						MsSeek(cFilCT2+CTT->CTT_CUSTO+DTOS(dDataIni),.T.)
					ElseIf cTipo == "3"
						MsSeek(cFilCT2+CTD->CTD_ITEM+DTOS(dDataIni),.T.)
					Else
						MsSeek(cFilCT2+CV0->CV0_CODIGO+DTOS(dDataIni),.T.)
					EndIf

					dbSelectArea("CT2")									/// WHILE CT2 - CREDITO
					While CT2->(!Eof()) .And. CT2->CT2_FILIAL == cFilCT2 .and. Eval(bCond) .and. CT2->CT2_DATA <= dDataFim
						If CT2->CT2_VALOR = 0
							dbSkip()
							Loop
						EndIf

						If Empty(c2Moeda)
							If CT2->CT2_MOEDLC <> cMoeda
								dbSkip()
								Loop
							EndIF
						Else
							If !(&(cFilMoeda))
								dbSkip()
								Loop
							EndIf
						EndIf

						If (CT2->CT2_DC == "2" .Or. CT2->CT2_DC == "3") .And. &(cVldEnt) .And. CT2->CT2_TPSALD == cSaldo
							CT2->(CtbGrvRNIT(lJunta,cMoeda,cSaldo,"2",c2Moeda,cAliasCT2,nTipo))
						Endif
						dbSelectArea("CT2")
						dbSkip()
					EndDo
					(cTabCad)->(dbSkip())
				EndDo
			EndIf
	#IFDEF TOP
		EndIf
	#ENDIF

	If lNoMov .or. lSldAnt
		If cTipo == "1"
			dbSelectArea("CT1")
			dbSetOrder(3)//CT1_FILIAL+CT1_CLASSE+CT1_CONTA  
			IndRegua(	Alias(),CriaTrab(nil,.f.),IndexKey(),,;
							"CT1_FILIAL == '" + xFilial("CT1") + "' .And. CT1_CONTA >= '"+cContaI+ "' .And. CT1_CONTA <= '" +;
							cContaF + "' .And. CT1_CLASSE = '2'",STR0017)
			cCpoChave := "CT1_CONTA"
			cTmpChave := "CONTA"
		ElseIf cTipo == "2"
			dbSelectArea("CTT")
			dbSetOrder(2)//CTT_FILIAL+CTT_CLASSE+CTT_CUSTO   
			IndRegua(	Alias(),CriaTrab(nil,.f.),IndexKey(),,;
							"CTT_FILIAL == '" + xFilial("CTT") + "' .And. CTT_CUSTO >= '"+cCustoI+"' .And. CTT_CUSTO <= '" +;
							cCUSTOF + "' .And. CTT_CLASSE == '2'",STR0017)
			cCpoChave := "CTT_CUSTO"
			cTmpChave := "CCUSTO"
		ElseIf ctipo == "3"
			dbSelectArea("CTD")
			dbSetOrder(2)//CTD_FILIAL+CTD_CLASSE+CTD_ITEM
			IndRegua(	Alias(),CriaTrab(nil,.f.),IndexKey(),,;
							"CTD_FILIAL == '" + xFilial("CTD") + "' .And. CTD_ITEM >= '"+cItemI+"' .And. CTD_ITEM <= '" +;
							cITEMF + "' .And. CTD_CLASSE == '2'",STR0017)
			cCpoChave := "CTD_ITEM"
			cTmpChave := "ITEM"
		ElseIf ctipo == "4"
			dbSelectArea("CV0") 
			dbSetOrder(1) //CV0_FILIAL+CV0_PLANO+CV0_CODIGO 
			IndRegua(	Alias(),CriaTrab(nil,.f.),IndexKey(),,;
							"CV0_FILIAL == '" + xFilial("CTH") + "' .and. CV0_PLANO='01' .And. CV0_CODIGO >= '"+cNitI+"' .And. CV0_CODIGO <= '" +;
							cNitF + "' .And. CV0_CLASSE == '2'",STR0017)
			cCpoChave := "CV0_CODIGO"
			cTmpChave := "NIT"
		EndIf

		cAlias := Alias()
		While ! Eof()
			dbSelectArea("cArqTmp")
			cKey2Seek	:= &(cAlias + "->" + cCpoChave)
			If !DbSeek(cKey2Seek)
				If lNoMov
					CtbGrvNNIT(cKey2Seek,dDataIni,cTmpChave)
				ElseIf cTipo == "1"		/// SOMENTE PARA O RAZAO POR CONTA
					/// TRATA OS DADOS PARA A PERGUNTA "IMPRIME CONTA SEM MOVIMENTO" = "NAO C/ SLD.ANT."
					If SaldoCT7Fil(cKey2Seek,dDataIni,cMoeda,cSaldo,'CTBR402')[6] <> 0 .and. cArqTMP->CONTA <> cKey2Seek
						/// SE TIVER SALDO ANTERIOR E NÃO TIVER MOVIMENTO GRAVADO
						CtbGrvNNIT(cKey2Seek,dDataIni,cTmpChave)
					Endif
				EndIf
			Endif
			DbSelectArea(cAlias)
			DbSkip()
		EndDo

		DbSelectArea(cAlias)
		DbClearFil()
		RetIndex(cAlias)
	Endif

CtbTmpErase(cTmpCT2Fil)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CtbGrvRNIT³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 05/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Grava registros no arq temporario - Razao                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³CtbGrvRNIT(lJunta,cMoeda,cSaldo,cTipo)                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpL1 = Se Junta CC ou nao                                 ³±±
±±³           ³ ExpC1 = Moeda                                              ³±±
±±³           ³ ExpC2 = Tipo de saldo                                      ³±±
±±            ³ ExpC3 = Tipo do lancamento                                 ³±±
±±³           ³ c2Moeda = Indica moeda 2 a ser incluida no relatorio       ³±±
±±³           ³ cAliasQry = Alias com o conteudo selecionado do CT2        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CtbGrvRNIT(lJunta,cMoeda,cSaldo,cTipo,c2Moeda,cAliasCT2,nTipo)
Local cConta
Local cContra
Local cCusto
Local cItem
Local cNit
Local cChave       := ""
Local lImpCPartida := GetNewPar("MV_IMPCPAR",.T.) // Se .T.,IMPRIME Contra-Partida para TODOS os tipos de lançamento (Débito, Credito e Partida-Dobrada)
                                                  // se .F., NÃO IMPRIME Contra-Partida para NENHUM   tipo  de lançamento.
DEFAULT cAliasCT2  := "CT2"

	If !Empty(c2Moeda)
		If cTipo == "1"
			cChave := (cAliasCT2)->(CT2_DEBITO+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_EMPORI+CT2_FILORI)
		Else
	    	cChave := (cAliasCT2)->(CT2_CREDIT+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_EMPORI+CT2_FILORI)
	 	EndIf
	EndIf

	If cTipo == "1"
		cConta 	:= (cAliasCT2)->CT2_DEBITO
		cContra	:= (cAliasCT2)->CT2_CREDIT
		cCusto	:= (cAliasCT2)->CT2_CCD
		cItem	:= (cAliasCT2)->CT2_ITEMD
		cNit	:= (cAliasCT2)->CT2_EC05DB
		If cPaisLoc == "PER"
			cMoedal := (cAliasCT2)->CT2_MOEDLC
		EndIf
	EndIf

	If cTipo == "2"
		cConta 	:= (cAliasCT2)->CT2_CREDIT
		cContra := (cAliasCT2)->CT2_DEBITO
		cCusto	:= (cAliasCT2)->CT2_CCC
		cItem	:= (cAliasCT2)->CT2_ITEMC
		cNit	:= (cAliasCT2)->CT2_EC05CR
		If cPaisLoc == "PER"
			cMoedal := (cAliasCT2)->CT2_MOEDLC
		EndIf
	EndIf

	CTL->( dbSetOrder(1) )
	CTL->( MsSeek( xFilial("CTL")+cAliasCT2->CT2_LP ) )
	_aDocOrig := u_fDocOri(cAliasCT2->CT2_KEY,CTL->CTL_ALIAS,CTL->CTL_ORDER,cAliasCT2->CT2_LP)
	
	dbSelectArea("cArqTmp")
	cArqTmp->(dbSetOrder(1))
	If !Empty(c2Moeda)
		If MsSeek(cChave,.F.)
			Reclock("cArqTmp",.F.)
		Else
			RecLock("cArqTmp",.T.)
		EndIf
	Else
		RecLock("cArqTmp",.T.)
	EndIf
			Replace NRECNO	With (cAliasCT2)->R_E_C_N_O_
			Replace DATAL	With (cAliasCT2)->CT2_DATA
			Replace TIPO	With cTipo
			Replace LOTE	With (cAliasCT2)->CT2_LOTE
			Replace SUBLOTE	With (cAliasCT2)->CT2_SBLOTE
			Replace DOC		With (cAliasCT2)->CT2_DOC
			Replace LINHA	With (cAliasCT2)->CT2_LINHA
			Replace CONTA	With cConta

		If lImpCPartida
			Replace XPARTIDA	With cContra
		EndIf
		
			Replace CCUSTO		With cCusto
			Replace ITEM		With cItem
			Replace NIT			With cNit
			Replace HISTORICO	With (cAliasCT2)->CT2_HIST
			Replace EMPORI		With (cAliasCT2)->CT2_EMPORI
			Replace FILORI		With (cAliasCT2)->CT2_FILORI
			Replace SEQHIST		With (cAliasCT2)->CT2_SEQHIST
			Replace SEQLAN		With (cAliasCT2)->CT2_SEQLAN
			Replace NOMOV		With .F.							// Conta com movimento
			Replace SEGOFI		With (cAliasCT2)->CT2_SEGOFI		// Conta com movimento
			Replace ROTINA		With (cAliasCT2)->CT2_ROTINA
			Replace DIACTB		With (cAliasCT2)->CT2_DIACTB
			if !empty(_aDocOrig[1][4])
				Replace DOCUMENTO	With alltrim(_aDocOrig[1][3])+"-"+alltrim(_aDocOrig[1][4])
			else
				Replace DOCUMENTO	With "0000-00000000"
			endif
			Replace NODIA		With (cAliasCT2)->CT2_NODIA
			Replace LP			With (cAliasCT2)->CT2_LP
			Replace XKEY		With (cAliasCT2)->CT2_KEY

		If cPaisLoc == "PER"
			Replace MOEDAL	With (cAliasCT2)->CT2_MOEDLC
		EndIf

		If cPaisLoc $ "CHI|ARG"
			Replace SEGOFI	With (cAliasCT2)->CT2_SEGOFI// Correlativo para Chile
		EndIf

		If Empty(c2Moeda)	//Se nao for Razao em 2 Moedas
			If cTipo == "1"
				Replace LANCDEB	With LANCDEB + (cAliasCT2)->CT2_VALOR
			EndIf
			If cTipo == "2"
				Replace LANCCRD	With LANCCRD + (cAliasCT2)->CT2_VALOR
			EndIf
			If (cAliasCT2)->CT2_DC == "3"
				Replace TIPO	With cTipo
			Else
				Replace TIPO 	With (cAliasCT2)->CT2_DC
			EndIf
		Else	//Se for Razao em 2 Moedas
			If (nTipo = 1 .Or. nTipo = 3) .And. (cAliasCT2)->CT2_MOEDLC = cMoeda //Se Imprime Valor na Moeda ou ambos
				If cTipo == "1"
					Replace LANCDEB With (cAliasCT2)->CT2_VALOR
				Else
					Replace LANCCRD With (cAliasCT2)->CT2_VALOR
				EndIf
			EndIf
		    If (nTipo = 2 .Or. nTipo = 3) .And. (cAliasCT2)->CT2_MOEDLC = c2Moeda	//Se Imprime Moeda Corrente ou Ambas
				If cTipo == "1"
					Replace LANCDEB_1	With (cAliasCT2)->CT2_VALOR
				Else
					Replace LANCCRD_1	With (cAliasCT2)->CT2_VALOR
				Endif
			EndIf
			If LANCDEB_1 <> 0 .And. LANCDEB <> 0
				Replace TXDEBITO  	With LANCDEB_1 / LANCDEB
			Endif
			If LANCCRD_1 <> 0 .And. LANCCRD <> 0
				Replace TXCREDITO 	With LANCCRD_1 / LANCCRD
			EndIf
			If (cAliasCT2)->CT2_DC == "3"
				Replace TIPO	With cTipo
			Else
				Replace TIPO 	With (cAliasCT2)->CT2_DC
			EndIf
		EndIf

		If nTipo = 1 .And. (LANCDEB + LANCCRD) = 0
			DbDelete()
		ElseIf nTipo = 2 .And. (LANCDEB_1 + LANCCRD_1) = 0
			DbDelete()
		Endif

		If ! Empty(c2Moeda) .And. LANCDEB + LANCDEB_1 + LANCCRD + LANCCRD_1 = 0
			DbDelete()
		Endif

		MsUnlock()
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CtbGrvNNIT  ³ Autor ³ Pilar S. Albaladejo ³ Data ³ 05/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Grava registros no arq temporario sem movimento.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³CtbGrvNNIT(cConta)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ cConteudo = Conteudo a ser gravado no campo chave de acordo³±±
±±³           ³             com o razao impresso                           ³±±
±±³           ³ dDataL = Data para verificacao do movimento da conta       ³±±
±±³           ³ cCpoChave = Nome do campo para gravacao no temporario      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CtbGrvNNIT(cConteudo,dDataL,cCpoTmp)
	dbSelectArea("cArqTmp")
	cArqTmp->(dbSetOrder(1))

	RecLock("cArqTmp",.T.)
		Replace &(cCpoTmp)	  WITH cConteudo
		If cCpoTmp = "CONTA"
			Replace HISTORICO WITH STR0021		//"CONTA SEM MOVIMENTO NO PERIODO"

		ElseIf cCpoTmp = "CCUSTO"
			Replace HISTORICO WITH Upper(AllTrim(CtbSayApro("CTT"))) + " "  + STR0026	//"SEM MOVIMENTO NO PERIODO"

		ElseIf cCpoTmp = "ITEM"
			Replace HISTORICO WITH Upper(AllTrim(CtbSayApro("CTD"))) + " "  + STR0026	//"SEM MOVIMENTO NO PERIODO"

		ElseIf cCpoTmp = "NIT"
			Replace HISTORICO WITH Upper(AllTrim("NIT")) + " "  + STR0026	//"SEM MOVIMENTO NO PERIODO"

		Endif
		Replace DATAL  WITH dDataL
		// Grava filial do sistema para uso no relatorio
		Replace FILORI WITH cFilAnt
	MsUnlock()
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³Ctr402Sint³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 05/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Imprime conta sintetica da conta do razao                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³Ctr402Sint( cConta,cDescSint,cMoeda,cDescConta,cCodRes	   ³±±
±±³		      |		   	 , cMoedaDesc)									   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Conta Sintetic		                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpC1 = Conta                                              ³±±
±±³           ³ ExpC2 = Descricao da Conta Sintetica                       ³±±
±±³           ³ ExpC3 = Moeda                                              ³±±
±±³           ³ ExpC4 = Descricao da Conta                                 ³±±
±±³           ³ ExpC5 = Codigo reduzido                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ctr402Sint(cConta,cDescSint,cMoeda,cDescConta,cCodRes,cMoedaDesc)
Local aSaveArea  := GetArea()
Local nPosCT1					//Guarda a posicao no CT1
Local cContaPai  := ""
Local cContaSint := ""

// seta o default da descrição da moeda para a moeda corrente
Default cMoedaDesc := cMoeda

	dbSelectArea("CT1")
	dbSetOrder(1)//CT1_FILIAL+CT1_CONTA     
	If dbSeek(xFilial("CT1")+cConta)
		nPosCT1    := Recno()
		cDescConta := &("CT1->CT1_DESC" + cMoedaDesc )

		If Empty( cDescConta )
			cDescConta := CT1->CT1_DESC01
		Endif

		cCodRes   := CT1->CT1_RES
		cContaPai := CT1->CT1_CTASUP

		If dbSeek(xFilial("CT1")+cContaPai)
			cContaSint := CT1->CT1_CONTA
			cDescSint  := &("CT1->CT1_DESC" + cMoedaDesc )

			If Empty(cDescSint)
				cDescSint := CT1->CT1_DESC01
			Endif
		EndIf

		dbGoto(nPosCT1)
	EndIf

RestArea(aSaveArea)
Return cContaSint

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CtbQryRNIT³ Autor ³ Simone Mie Sato       ³ Data ³ 22/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Realiza a "filtragem" dos registros do Razao                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³CtbQryRNIT(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,	   ³±±
±±³			  ³	cCustoIni,cCustoFim, cItemIni,cItemFim,cNitIni,cNitFim,    ³±±
±±³			  ³	cMoeda,dDataIni,dDataFim,aSetOfBook,lNoMov,cSaldo,lJunta,  ³±±
±±³			  ³	cTipo)                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpO1 = Objeto oMeter                                      ³±±
±±³           ³ ExpO2 = Objeto oText                                       ³±±
±±³           ³ ExpO3 = Objeto oDlg                                        ³±±
±±³           ³ ExpL1 = Acao do Codeblock                                  ³±±
±±³           ³ ExpC2 = Conta Inicial                                      ³±±
±±³           ³ ExpC3 = Conta Final                                        ³±±
±±³           ³ ExpC4 = C.Custo Inicial                                    ³±±
±±³           ³ ExpC5 = C.Custo Final                                      ³±±
±±³           ³ ExpC6 = Item Inicial                                       ³±±
±±³           ³ ExpC7 = Cl.Valor Inicial                                   ³±±
±±³           ³ ExpC8 = Cl.Valor Final                                     ³±±
±±³           ³ ExpC9 = Moeda                                              ³±±
±±³           ³ ExpD1 = Data Inicial                                       ³±±
±±³           ³ ExpD2 = Data Final                                         ³±±
±±³           ³ ExpA1 = Matriz aSetOfBook                                  ³±±
±±³           ³ ExpL2 = Indica se imprime movimento zerado ou nao.         ³±±
±±³           ³ ExpC10= Tipo de Saldo                                      ³±±
±±³           ³ ExpL3 = Indica se junta CC ou nao.                         ³±±
±±³           ³ ExpC11= Tipo do lancamento                                 ³±±
±±³           ³ c2Moeda = Indica moeda 2 a ser incluida no relatorio       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CtbQryRNIT(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,cCustoIni,cCustoFim,;
				  cItemIni,cItemFim,cNitIni,cNitFim,cMoeda,dDataIni,dDataFim,;
				  aSetOfBook,lNoMov,cSaldo,lJunta,cTipo,c2Moeda,cUFilter,lSldAnt,aSelFil)

Local aSaveArea    := GetArea()
Local nMeter       := 0
Local cQuery       := ""
Local aTamVlr      := TAMSX3("CT2_VALOR")
Local lNoMovim     := .F.
Local cContaAnt    := ""
Local cCampUSU     := ""
local aStrSTRU     := {}
Local nStr         := 0
Local cQryFil      := '' // variavel de condicional da query
Local lImpCPartida := GetNewPar( "MV_IMPCPAR" , .T.) // Se .T.,IMPRIME Contra-Partida para TODOS os tipos de lançamento (Débito, Credito e Partida-Dobrada),
													 // se .F., NÃO IMPRIME Contra-Partida para NENHUM   tipo  de lançamento.
Local cTmpCT2Fil
DEFAULT lSldAnt := .F.
DEFAULT aSelFil := {}

	// trataviva para o filtro de multifiliais
	cQryFil := " CT2.CT2_FILIAL " + GetRngFil( aSelFil, "CT2", .T., @cTmpCT2Fil )

	oMeter:SetTotal(CT2->(RecCount()))
	oMeter:Set(0)

	cQuery	:= " SELECT CT1_CONTA CONTA, ISNULL(CT2_CCD,'') CUSTO,ISNULL(CT2_ITEMD,'') ITEM, ISNULL(CT2_EC05DB,'') NIT, "
	cQuery	+= " ISNULL(CT2_DATA,'') DDATA, ISNULL(CT2_TPSALD,'') TPSALD, "
	cQuery	+= " ISNULL(CT2_DC,'') DC, ISNULL(CT2_LOTE,'') LOTE, ISNULL(CT2_SBLOTE,'') SUBLOTE, ISNULL(CT2_DOC,'') DOC, "
	cQuery	+= " ISNULL(CT2_LINHA,'') LINHA, ISNULL(CT2_CREDIT,'') XPARTIDA, ISNULL(CT2_HIST,'') HIST, ISNULL(CT2_SEQHIS,'') SEQHIS, "
	cQuery	+= " ISNULL(CT2_SEQLAN,'') SEQLAN, '1' TIPOLAN,  ISNULL(CT2_DIACTB,'') DIACTB, ISNULL(CT2_LP,'') CT2_LP, ISNULL(CT2_KEY,'') CT2_KEY, "

	//// TRATAMENTO PARA O FILTRO DE USUÁRIO NO RELATORIO
	cCampUSU  := ""										//// DECLARA VARIAVEL COM OS CAMPOS DO FILTRO DE USUÁRIO
	If !Empty(cUFilter)									//// SE O FILTRO DE USUÁRIO NAO ESTIVER VAZIO
		aStrSTRU := CT2->(dbStruct())				//// OBTEM A ESTRUTURA DA TABELA USADA NA FILTRAGEM
		nStruLen := Len(aStrSTRU)
		For nStr := 1 to nStruLen                       //// LE A ESTRUTURA DA TABELA
			cCampUSU += aStrSTRU[nStr][1]+","			//// ADICIONANDO OS CAMPOS PARA FILTRAGEM POSTERIOR
		Next
	Endif
	cQuery += cCampUSU									//// ADICIONA OS CAMPOS NA QUERY

	cQuery  += " ISNULL(CT2_VALOR,0) VALOR, ISNULL(CT2_EMPORI,'') EMPORI, ISNULL(CT2_FILORI,'') FILORI"
	If cPaisLoc $ "CHI|ARG|PER"
	cQuery	+= ", ISNULL(CT2_SEGOFI,'') SEGOFI, ISNULL(CT2_ROTINA,'') ROTINA, ISNULL(CT2_NODIA,'') NODIA"
	EndIf

	cQuery += " FROM "+ RetSqlName("CT1") + " CT1 LEFT JOIN " + RetSqlName("CT2") + " CT2 "
	cQuery += " ON " + cQryFil

	cQuery	+= " AND CT2.CT2_DEBITO = CT1.CT1_CONTA"
	cQuery  += " AND CT2.CT2_DATA >= '"+DTOS(dDataIni)+ "' AND CT2.CT2_DATA <= '"+DTOS(dDataFim)+"'"
	cQuery	+= " AND CT2.CT2_CCD >= '" + cCustoIni + "' AND CT2.CT2_CCD <= '" + cCustoFim +"'"
	cQuery  += " AND CT2.CT2_ITEMD >= '" + cItemIni + "' AND CT2.CT2_ITEMD <= '"+ cItemFim +"'"
	cQuery  += " AND CT2.CT2_EC05DB >= '" + cNitIni + "' AND CT2.CT2_EC05DB <= '" + cNitFim +"'"
	cQuery  += " AND CT2.CT2_TPSALD = '"+ cSaldo + "'"
	cQuery	+= " AND CT2.CT2_MOEDLC = '" + cMoeda +"'"
	cQuery  += " AND (CT2.CT2_DC = '1' OR CT2.CT2_DC = '3') "
	cQuery	+= " AND CT2.D_E_L_E_T_ = ' ' "
	cQuery	+= " WHERE CT1.CT1_FILIAL = '"+xFilial("CT1")+"' "
	cQuery	+= " AND CT1.CT1_CLASSE = '2' "
	cQuery	+= " AND CT1.CT1_CONTA >= '"+ cContaIni+"' AND CT1.CT1_CONTA <= '"+cContaFim+"'"
	cQuery	+= " AND CT1.D_E_L_E_T_ = '' "
	cQuery	+= " UNION "
	cQuery	+= " SELECT CT1_CONTA CONTA, ISNULL(CT2_CCC,'') CUSTO, ISNULL(CT2_ITEMC,'') ITEM, ISNULL(CT2_EC05CR,'') NIT, ISNULL(CT2_DATA,'') DDATA, ISNULL(CT2_TPSALD,'') TPSALD, "
	cQuery	+= " ISNULL(CT2_DC,'') DC, ISNULL(CT2_LOTE,'') LOTE, ISNULL(CT2_SBLOTE,'')SUBLOTE, ISNULL(CT2_DOC,'') DOC, ISNULL(CT2_LINHA,'') LINHA, ISNULL(CT2_DEBITO,'') XPARTIDA, ISNULL(CT2_HIST,'') HIST, ISNULL(CT2_SEQHIS,'') SEQHIS, ISNULL(CT2_SEQLAN,'') SEQLAN, '2' TIPOLAN, ISNULL(CT2_DIACTB,'') DIACTB, ISNULL(CT2_LP,'') CT2_LP, ISNULL(CT2_KEY,'') CT2_KEY, "

	//// TRATAMENTO PARA O FILTRO DE USUÁRIO NO RELATORIO
	cCampUSU  := ""										//// DECLARA VARIAVEL COM OS CAMPOS DO FILTRO DE USUÁRIO
	If !Empty(cUFilter)									//// SE O FILTRO DE USUÁRIO NAO ESTIVER VAZIO
		aStrSTRU := CT2->(dbStruct())				//// OBTEM A ESTRUTURA DA TABELA USADA NA FILTRAGEM
		nStruLen := Len(aStrSTRU)
		For nStr := 1 to nStruLen                       //// LE A ESTRUTURA DA TABELA
			cCampUSU += aStrSTRU[nStr][1]+","			//// ADICIONANDO OS CAMPOS PARA FILTRAGEM POSTERIOR
		Next
	Endif

	cQuery += cCampUSU									//// ADICIONA OS CAMPOS NA QUERY
	cQuery  += " ISNULL(CT2_VALOR,0) VALOR, ISNULL(CT2_EMPORI,'') EMPORI, ISNULL(CT2_FILORI,'') FILORI "

	If cPaisLoc $ "CHI|ARG|PER"
		cQuery	+= ", ISNULL(CT2_SEGOFI,'') SEGOFI, ISNULL(CT2_ROTINA,'') ROTINA, ISNULL(CT2_NODIA,'') NODIA"
	EndIf

	cQuery += " FROM "+RetSqlName("CT1")+ ' CT1 LEFT JOIN '+ RetSqlName("CT2") + ' CT2 '
	cQuery += " ON " + cQryFil
	cQuery	+= " AND CT2.CT2_CREDIT =  CT1.CT1_CONTA "
	cQuery  += " AND CT2.CT2_DATA >= '"+DTOS(dDataIni)+ "' AND CT2.CT2_DATA <= '"+DTOS(dDataFim)+"'"
	cQuery	+= " AND CT2.CT2_CCC >= '" + cCustoIni + "' AND CT2.CT2_CCC <= '" + cCustoFim +"'"
	cQuery  += " AND CT2.CT2_ITEMC >= '" + cItemIni + "' AND CT2.CT2_ITEMC <= '"+ cItemFim +"'"
	cQuery  += " AND CT2.CT2_EC05CR >= '" + cNitIni + "' AND CT2.CT2_EC05CR <= '" + cNitFim +"'"
	cQuery  += " AND CT2.CT2_TPSALD = '"+ cSaldo + "'"
	cQuery	+= " AND CT2.CT2_MOEDLC = '" + cMoeda +"'"
	cQuery  += " AND (CT2.CT2_DC = '2' OR CT2.CT2_DC = '3') "
	cQuery	+= " AND CT2.D_E_L_E_T_ = ' ' "
	cQuery	+= " WHERE CT1.CT1_FILIAL = '"+xFilial("CT1")+"' "
	cQuery	+= " AND CT1.CT1_CLASSE = '2' "
	cQuery	+= " AND CT1.CT1_CONTA >= '"+ cContaIni+"' AND CT1.CT1_CONTA <= '"+cContaFim+"'"
	cQuery	+= " AND CT1.D_E_L_E_T_ = ''"

	cQuery := ChangeQuery(cQuery)

	If Select(" ") > 0
		dbSelectArea("cArqCT2")
		dbCloseArea()
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"cArqCT2",.T.,.F.)

	TcSetField("cArqCT2","CT2_VLR"+cMoeda,"N",aTamVlr[1],aTamVlr[2])
	TcSetField("cArqCT2","DDATA","D",8,0)

	If !Empty(cUFilter)									//// SE O FILTRO DE USUÁRIO NAO ESTIVER VAZIO
		For nStr := 1 to nStruLen                       //// LE A ESTRUTURA DA TABELA
			If aStrSTRU[nStr][2] <> "C" .and. cArqCT2->(FieldPos(aStrSTRU[nStr][1])) > 0
				TcSetField("cArqCT2",aStrSTRU[nStr][1],aStrSTRU[nStr][2],aStrSTRU[nStr][3],aStrSTRU[nStr][4])
			EndIf
		Next
	Endif

	dbSelectarea("cArqCT2")
	If Empty(cUFilter)
		cUFilter := ".T."
	Endif

	While !Eof()
		If Empty(cArqCT2->DDATA) //Se nao existe movimento
			cContaAnt	:= cArqCT2->CONTA
			cArqCT2->(dbSkip())
			If Empty(cArqCT2->DDATA) .And. cContaAnt == cArqCT2->CONTA
				lNoMovim	:= .T.
			EndIf
		Endif

		If &("cArqCT2->("+cUFilter+")")
			If lNoMovim
				If lNoMov
					If CtbExDtFim("CT1")
						dbSelectArea("CT1")
						dbSetOrder(1)//CT1_FILIAL+CT1_CONTA     
						If MsSeek(xFilial()+cArqCT2->CONTA)
							If CtbVlDtFim("CT1",dDataIni)
								CtbGrvNNIT(cArqCT2->CONTA,dDataIni,"CONTA")	//Esta sendo passado "CONTA" fixo, porque essa funcao esta sendo
							EndIf												//chamada somente para o CTBR402
						EndIf
					Else
						CtbGrvNNIT(cArqCT2->CONTA,dDataIni,"CONTA")	//Esta sendo passado "CONTA" fixo, porque essa funcao esta sendo
					EndIf												//chamada somente para o CTBR402
				ElseIf lSldAnt
					If SaldoCT7Fil(cArqCT2->CONTA,dDataIni,cMoeda,cSaldo,'CTBR402')[6] <> 0 .and. cArqTMP->CONTA <> cArqCT2->CONTA
						CtbGrvNNIT(cArqCT2->CONTA,dDataIni,"CONTA")
					Endif
				EndIf
			Else
			
				CTL->( dbSetOrder(1) )
				CTL->( MsSeek( xFilial("CTL")+cArqCT2->CT2_LP ) )
				_aDocOrig := u_fDocOri(cArqCT2->CT2_KEY,CTL->CTL_ALIAS,CTL->CTL_ORDER,cArqCT2->CT2_LP)
			
				RecLock("cArqTmp",.T.)
				    Replace DATAL		With cArqCT2->DDATA
					Replace TIPO		With cArqCT2->DC
					Replace LOTE		With cArqCT2->LOTE
					Replace SUBLOTE		With cArqCT2->SUBLOTE
					Replace DOC			With cArqCT2->DOC
					Replace LINHA		With cArqCT2->LINHA
					Replace CONTA		With cArqCT2->CONTA
					Replace CCUSTO		With cArqCT2->CUSTO
					Replace ITEM		With cArqCT2->ITEM
					Replace NIT			With cArqCT2->NIT

					If lImpCPartida
						Replace XPARTIDA	With cArqCT2->XPARTIDA
					EndIf

					Replace HISTORICO	With cArqCT2->HIST
					Replace EMPORI		With cArqCT2->EMPORI
					Replace FILORI		With cArqCT2->FILORI
					Replace SEQHIST		With cArqCT2->SEQHIS
					Replace SEQLAN		With cArqCT2->SEQLAN

					If cPaisLoc $ "CHI|ARG|PER"
						Replace SEGOFI With cArqCT2->SEGOFI// Correlativo para Chile
						Replace ROTINA With cArqCT2->ROTINA
					EndIf

					If cArqCT2->TIPOLAN = '1'
						Replace LANCDEB	With LANCDEB + cArqCT2->VALOR
					EndIf

					If cArqCT2->TIPOLAN = '2'
						Replace LANCCRD	With LANCCRD + cArqCT2->VALOR
					EndIf

					If cPaisLoc == "PER"
						Replace MOEDAL	With cMoeda //modifique
					EndIF
					
					Replace DIACTB With cArqCT2->DIACTB
					if !empty(_aDocOrig[1][4])
						Replace DOCUMENTO	With alltrim(_aDocOrig[1][3])+"-"+alltrim(_aDocOrig[1][4])
					else
						Replace DOCUMENTO	With "0000-00000000"
					endif
					Replace NODIA		With cArqCT2->NODIA
					Replace LP			With cArqCT2->CT2_LP
					Replace XKEY		With cArqCT2->CT2_KEY

		
					
				MsUnlock()
			Endif
		EndIf
		lNoMovim	:= .F.
		dbSelectArea("cArqCT2")
		dbSkip()
		nMeter++
		oMeter:Set(nMeter)
	Enddo

	CtbTmpErase(cTmpCT2Fil)

RestArea(aSaveArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao     ³ GerArq   ³ Autor ³ Marivaldo           ³ Data ³ 23.04.2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao  ³ Gera o arquivo magnético do Diario contabil                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Parametros ³ cDir - Diretorio de criacao do arquivo.                    ³±±
±±³            ³ cArq - Nome do arquivo com extensao do arquivo.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno    ³ Nulo                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ Fiscal Peru - Diario contabil - Arquivo Magnetico          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GerArq(cDir , cArqTmp)

private nHdl     := 0
private cLin     := ""
private cSep     := "|"
private n		   := 0
private cArq     := ""
private nCont    := 0
private cSegofi  := ""
private cFilCt2  := "" 
private aSelFil  := {}
private cTmpCT2Fil
private cChave   := ""
private _cCliPad := getMV("MV_CLIPAD")
private _aLinha := {}
private _aDatos := {}
private cDoc    :=""
private cOserie :=""
private cTienda :=""
private cOtienda:=""
private cMovtip :=""
private cEspecie:=""
private cVcto   :=""
private dBaixa  := Ctod("  /  /  ")
private dFecha  := Ctod("  /  /  ")
private nDetra  := 0
private cFilSF3 :=""
private dFechsf3:=Ctod("  /  /  ")     
private cPrefixo :=""
private cNumero  :=""
private cParcela :=""
private cTipo    :=""
private dSfefecha:=Ctod("  /  /  ")    
private nPos     := 0
private aRet     := {}  
private cDctb	   :="" 
private cF1doc   :=""
private cF1tienda:=""    
private cFornece :=""
private nY 	   := 0
private nX	   := 0
private ctipDoc  := ""
private cContAux := space(10)

private cLbSiDom := getNewPar("MV_LFSDOM","080100")
private cLbNoDom := getNewPar("MV_LFNDOM","080200")
private cLbVenta := getNewPar("MV_LFVENT","140100")
private cCodLibr := ""
Private cMesInic := ""
Private cAnoInic := ""
Private cMesFin := ""
Private cAnoFin := ""
Private dDUtilInic:= Ctod("  /  /  ")
Private dDUtilFin := Ctod("  /  /  ")
Private cMV_1DUP  := padr(SuperGetMV("MV_1DUP",,"1"),TamSx3("E5_PARCELA")[1])  

nHdl := fCreate(cDir+cArq)

CTL->( dbSetOrder(1) )

cFilCt2  := " CT2_FILIAL " + GetRngFil( aSelFil, "CT2", .T., @cTmpCT2Fil ) 			
cQuery := " SELECT CT2_FILIAL"
cQuery += "      , CT2_MOEDLC"
cQuery += "      , CT2.R_E_C_N_O_"
cQuery += "   FROM " + RetSqlName('CT2') + " CT2"
cQuery += "  WHERE " + cFilCT2
cQuery += "    AND CT2_DATA BETWEEN '" + DTOS( mv_par03 ) + "' AND '" + DTOS ( mv_par04 ) + "' "
cQuery += "    AND CT2_MOEDLC = '" + mv_par05 + "' "
cQuery += "    AND CT2.D_E_L_E_T_ = ' ' "
cQuery += "  ORDER BY CT2_DATA "						
ChangeQuery(cQuery)			
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), 'TMP', .T., .F. )  
		
DbSelectArea('TMP')		
TcSetField("TMP","CT2_DATA" ,"D")
dbSelectArea("TMP")
TMP ->(dbGoTop())
dbSelectArea("cArqTmp")
cArqTmp->(dbGoTop())

Do While cArqTmp->(!EOF())

	aTID := {}
	_aDocOrig := {}
	
	CTL->( MsSeek( xFilial("CTL")+cArqTmp->LP ) )
	_aDocOrig := u_fDocOri(cArqTmp->XKEY,CTL->CTL_ALIAS,CTL->CTL_ORDER,cArqTmp->LP)  //Obtiene informacion de las facturas o documentos relacionados al asiento
	
	if empty(_aDocOrig[1,5]) .And. empty(_aDocOrig[1,9])
		Aadd( aTID, { "","","","" } )
	else
		aTID:= u_fFindA12( _aDocOrig[1,5],_aDocOrig[1,9],_aDocOrig[1,6] ) //Obtiene el tipo de Identificacion del cliente o del proveedor
	endif

	If cArqTmp->LANCDEB > 0 .or. cArqTmp->LANCCRD > 0

		//01 - Periodo
		cLin :=""
		cLin += SubStr(DTOS(MV_PAR04),1,6)+"00"
		cLin += cSep

		//02 - Num correlativo
		cLin += AllTrim(cArqTmp->SEGOFI)
		cLin += cSep
					
		if cSegofi<>AllTrim(cArqTmp->SEGOFI)
			cSegofi := AllTrim(cArqTmp->SEGOFI)
			//nContAux := 1
		endif			
		
		//03 - M+Num correlativo
		cCodLibr:=''
		if left(AllTrim(cArqTmp->SEGOFI),2)=="14"
			cCodLibr := cLbVenta
		elseif left(AllTrim(cArqTmp->SEGOFI),2)=="08"
		   	if  !empty(aTID[1,4])
				if aTID[1,4]=='1'	// domiciliados
					cCodLibr := cLbSiDom
				else
					cCodLibr := cLbNoDom
				EndIf
			endif
		endif

		cContAux := "M"+Strzero(val(cArqTmp->LINHA),9)
		cLin += cContAux
		cLin += cSep
		
		//04 - Código del Plan de Cuentas - Código de la cuenta contable desagregado en subcuentas al nivel máximo de dígitos utilizado, según la estructura 5.3
		cLin += AllTrim(cArqTmp->CONTA)
		cLin += cSep		
		//05 - Código de la Unidad de Operación, de la Unidad Económica Administrativa, de la Unidad de Negocio(Não Obrigatório)
		cLin += ""
		cLin += cSep				
		//06 - Código del Centro de Costos, Centro de Utilidades o Centro de Inversión, de corresponder(Não Obrigatório)
		cLin += cArqTmp->CCUSTO
		cLin += cSep
		
		//07 - Tipo de Moneda de origen -  Validar con parámetro tabla 4			
		SYF->(DbSetOrder(1))//YF_FILIAL+YF_MOEDA    
		If SYF->(Dbseek(xFilial("SYF")+(GetMV("MV_SIMB"+AllTrim(STR(VAL(cArqTmp->MOEDAL))))))) 
			if !Empty(AllTrim(SYF->YF_ISO))
				cLin += AllTrim(SYF->YF_ISO)
			else
				cLin += ""
			endif
		else
			cLin += ""
		EndIf					   				       
		cLin += cSep 			
		
		
		aArea := Getarea()
		cRecCT2 := ""
		cRecCT2 := ALLTRIM(STR(INT((TMP->R_E_C_N_O_))))
		dbSelectArea("CV3")
		CV3 ->(dbGoTop())
		nRecOri := int(val(CV3->CV3_RECORI))  									  
		ctipDoc:="00"
		cSerieN:= ""
		
		If len(_aDocOrig)>0
			cTipDoc := alltrim(_aDocOrig[1,1])
			if alltrim(cTipDoc)$"50|05"
				cSerieN := _aDocOrig[1,2]
			else
				cSerieN := if(!empty(_aDocOrig[1,3]),_aDocOrig[1,3],_aDocOrig[1,2])
			endif
		EndIf

		//08 - tipo de documento de identidad del emisor(Não Obrigatório)
		_cTpDocCli := ""
		If len(_aDocOrig)>0
			_cTpDocCli := aTID[1,1]
			If alltrim( aTID[1,2])$_cCliPad	  //"99999999999/00000000000"
				cLin += "0"
			ElseIf alltrim( aTID[1,3])$_cCliPad//"99999999999/00000000000"
				cLin += "0"
			Else
				cLin += iif(empty(_cTpDocCli),"0",_cTpDocCli)
			EndIf
		Else
			cLin += "0"
		EndIf
		cLin += cSep			

		//09 - numero de documento de identidad del emisor(Não Obrigatório)
		cFornece:=''
		If len(_aDocOrig)>0
			If _cTpDocCli$"0/1"
				cLin += if(empty(aTID[1,2]),"00000000000",aTID[1,2]) // fisica
				cFornece:=_aDocOrig[1][5]  
			Else 
				If empty(_aDocOrig[1][4])
					cLin += "00000000000"
				Else						
					cLin += if(empty(aTID[1,3]),"00000000000",aTID[1,3]) // juridica
					cFornece:=_aDocOrig[1][5]
				EndIf
			EndIf
		Else
			cLin += "00000000000"
		EndIf
		cLin += cSep

		
		//10 - Tipo de Comprobante de Pago o Documento asociada a la operación, de corresponder - tabla 10																	
		If Len(cSerieN)>4
			cLin += "12"
		Else
			cLin += iif(AllTrim(cTipDoc)=="","00",AllTrim(cTipDoc))
		EndIf
		cLin += cSep			
		//11 - Número de serie del comprobante de pago o documento asociada a la operación, de corresponder(Não Obrigatório)
		cSerNf := Alltrim(cSerieN)	
		cTipDoc:=Alltrim(cTipDoc)	
		cSerieNf:=cSerNf
				
		If !(cTipDoc $ "50|05")
			If Len(cSerieNf)<=3
				if left(cSerieNf,1)$"E/F/B"
					cSerieNf := left(cSerieNf,1)+"0"+right(cSerieNf,2)
				elseif substr(cSerieNf,2,1)$"E/F/A/B/C/D"
					cSerieNf := left(cSerieNf,2)+"0"+right(cSerieNf,1)
				else
					cSerieNf := Replicate("0",4-Len(cSerieNf))+cSerieNf
				endif
			EndIf
		EndIf
			 
		If cTipDoc == "00" .Or. empty(cTipDoc)
			cLin += "0000"
		Else
			cLin += AllTrim(cSerieNf)
		EndIf
		cLin += cSep
		RestArea(aArea)

		//12 - Número del comprobante de pago o documento asociada a la operación
		cDocX := space(TamSX3("F2_DOC")[1])
		If len(_aDocOrig)>0
			If empty(_aDocOrig[1][4])
				cLin += "0000"
			Else
				cLin += right(alltrim(_aDocOrig[1][4]),8)
				cDocX := _aDocOrig[1][4]
			EndIf
		Else
			cLin += "0000" 
		EndIf
		cLin += cSep				

		//13  - Data da contabilizacao(Não Obrigatório)
		cLin += SubStr(DTOC(cArqTmp->DATAL),1,6)+SubStr(DTOS(cArqTmp->DATAL),1,4)
		cLin += cSep

		//14 - Fecha de vencimiento(Não Obrigatório)
		cLin += ""
		cLin += cSep	
		
		//15 - Fecha de la operación o emisión
		if len(_aDocOrig) > 0
			if empty(_aDocOrig[1][7])
				cLin += SubStr(DTOC(cArqTmp->DATAL),1,6)+SubStr(DTOS(cArqTmp->DATAL),1,4)
			else
				cLin += dtoc( stod( _aDocOrig[1][7] ) )
			endif
		else
			cLin += SubStr(DTOC(cArqTmp->DATAL),1,6)+SubStr(DTOS(cArqTmp->DATAL),1,4)
		endif
		cLin += cSep	
		//16 - Glosa o descripción de la naturaleza de la operación registrada, de ser el caso.
		cLin += StrTran(StrTran(StrTran(AllTrim(cArqTmp->HISTORICO),"/"," "),"\"," "),"|"," ")
		cLin += cSep
		//17 - Glosa referencial, de ser el caso(Não Obrigatório)
	    cLin += ""
		cLin += cSep				
		//18  - Conta Debito - Movimientos del Debe
		If cArqTmp->LANCDEB == 0
			cLin += "0.00"
		Else
			cLin += AllTrim(StrTran(Transform(cArqTmp->LANCDEB,"@E 999999999.99"),",","."))
		EndIf
		cLin += cSep
		//19 - Conta Credito - Movimientos del Haber
		If cArqTmp->LANCCRD == 0
			cLin += "0.00"
		Else
			cLin += AllTrim(StrTran(Transform(cArqTmp->LANCCRD,"@E 999999999.99"),",","."))
		EndIf
		cLin += cSep	
		//20 - Dato Estructurado: Código del libro, campo 1, campo 2 y campo 3 del Registro de Ventas e Ingresos o del Registro de Compras, 
	    //separados con el carácter "&", de corresponder.(Não Obrigatório)
		if Left(AllTrim(cArqTmp->SEGOFI),2)<>"99" .and. _aDocOrig[1][1]<>"02" .and. !empty(_aDocOrig[1][1])
			cLin += u_fgenAnidado(cDocX,cFornece,mv_par03,mv_par04,cCodLibr,cArqTmp->SEGOFI,cContAux,cArqTmp->FILIAL)
		Else
			cLin += ""
		EndIf
		cLin += cSep

		//21 - Estado da Operacao
		cLin += '1'
		cLin += cSep
		_aLinha := {}
		_aLinha := StrTokArr2( cLin, "|", .T. )			
		Aadd( _aDatos, _aLinha )

	EndIf
	cArqTmp->(dbSkip())
	TMP->(dbSkip())		
	n := n+1
EndDo
TMP->(DbCloseArea())

//-------------------------------------------------//
// genera el archivo TXT indexado por el SEGOFI    //
//-------------------------------------------------//
ASORT(_aDatos, , , { | x,y | x[4]+x[13] < y[4]+y[13] } )

FOR nCont:=LEN(ALLTRIM(cDir)) TO 1 STEP -1
	IF SUBSTR(cDir,nCont,1)=='\'
		cDir:=Substr(cDir,1,nCont)
		EXIT
	ENDIF
NEXT

//Nome do arquivo TXT conforme layout (7_2Nombres) - SUNAT
cArq += "LE"                            // Fixo  'LE'
cArq +=  AllTrim(SM0->M0_CGC)           // Ruc
cArq +=  AllTrim(Str(Year(MV_PAR04)))   // Ano
cArq +=  AllTrim(Strzero(Month(MV_PAR04),2))  // Mes
cArq +=  "00"                            // Fixo '00'
cArq += "060100"                         // Fixo '060100'
cArq += "00"                             // Fixo '00'
cArq += "1"
cArq += "1"
cArq += "1"
cArq += "1"
cArq += ".TXT" // Extensao

nHdl := fCreate(cDir+cArq,0,Nil,.F.)
If nHdl <= 0
	//ApMsgStop(STR0087)//Ocurrió un error al crear el archivo.
	ApMsgStop("Ocurrió un error al crear el archivo.")
Else
	for nX := 1 to len( _aDatos )
		cLin := ""
		for nY := 1 to len( _aDatos[nX] )
			cLin += _aDatos[nX][nY]+"|"
		next nY
		cLin += chr(13)+chr(10)
		fWrite(nHdl,cLin)
	next nX
endif
fClose(nHdl)
	
Return Nil

