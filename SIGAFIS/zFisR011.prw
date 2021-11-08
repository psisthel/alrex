#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FISR011.CH'
#INCLUDE "FILEIO.CH"

Static cStartPath   := AllTrim(GetPvProfString(GetEnvServer(), 'StartPath', 'ERROR', GetADV97()) + If(Right(AllTrim(GetPvProfString(GetEnvServer(), 'StartPath', 'ERROR', GetADV97())), 1) == '\', '', '\'))
Static cPath        := If(Left(cStartPath, 1) <> '\', '\', '') + cStartPath

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥FisR011   ∫ Autor ≥ Rodrigo M. Pontes  ∫ Data ≥  30/11/09   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥Relatorio de impress„o dos livros fiscais do Peru           ∫±±
±±∫          ≥Relatorio de registro de vendas e ingressos                 ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
User Function ZFISR011( nOpc )

Local uRet 
default nOpc := 0

do case

	case nOpc == 0
		uRet := execRel()
	case nOpc == 1
		uRet := f3Param()
	case nOpc == 2
		uRet := f3RetParam()

endCase

Return uRet

/*/{Protheus.doc} execRel
Funcao para executar o relatorio
@type  Static Function
@author DS2U (SDA)
@since 14/09/2019
@version version
/*/
Static Function execRel()
	
Local oReport
Local aArea := GetArea()

If FindFunction('TRepInUse') .And. TRepInUse()
	oReport := ReportDef()
	oReport:PrintDialog()

Else
	Aviso('ATENCION', 'Informe disponible sÛlo para TReport', {'OK'})

EndIf

RestArea(aArea)
Return


/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥ReportDef ≥ Autor ≥ Rodrigo M. Pontes     ≥ Data | 30/11/09 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥CriaÁ„o do objeto TReport para a impress„o do relatorio.    ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function ReportDef()
Local oReport  := NIL
Local cPerg    := 'FISR011'
Local cNomProg := 'ZFISR011'
Local cTitulo  := STR0001	//-- Registros de Vendas e Ingressos
Local cDesc    := STR0002	//-- Relatorio de registros de Vendas e Ingressos

// -------------------------------------------------------------------------------
// PARAMETROS
// -------------------------------------------------------------------------------
// MV_PAR01 : DATA INICIAL
// MV_PAR02 : DATA FINAL
// MV_PAR03 : IMPRIME PAGINAS (1-SIM | 2-NAO)
// MV_PAR04 : No PAGINA INICIAL
// MV_PAR05 : SELECIONA FILIAIS (1-SIM | 2-NAO)
// MV_PAR06 : GERA RELATORIO, ARQUIVO OU AMBOS (1-RELATORIO | 2-ARQUIVO)
// MV_PAR07 : DIRETORIO P/ GERACAO DO ARQUIVO
// -------------------------------------------------------------------------------

Pergunte(cPerg, .T.)

// ---------------------------------------------------
// CRIA OBJETO TREPORT
// ---------------------------------------------------
oReport := TReport():New(cNomProg, cTitulo, cPerg, {|oReport| ReportPrint(oReport)}, cDesc)

oReport:SetLandscape()				//-- Formato paisagem
oReport:oPage:nPaperSize := 8		//-- Impress„o em papel A3
oReport:lHeaderVisible   := .F.		//-- Nao imprime cabeÁalho do protheus
oReport:lFooterVisible   := .F.		//-- Nao imprime rodapÈ do protheus
oReport:lParamPage       := .F.		//-- Nao imprime pagina de parametros

Return(oReport)

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥ReportPrint≥ Autor ≥ V. RASPA                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥Trata impressao e/ou geracao do arquivo txt                 ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function ReportPrint(oReport)
Local aParams    := {}
Local aFiliais   := {}
Local cArq       := ''
Local cStatusPrc := ''

// -------------------------------------------------
// GUARDA PARAMETROS INFORMADOS (DEVIDO MULTI-THREAD
// -------------------------------------------------
aAdd(aParams, MV_PAR01) //-- MV_PAR01 : DATA INICIAL
aAdd(aParams, MV_PAR02) //-- MV_PAR02 : DATA FINAL
aAdd(aParams, MV_PAR03) //-- MV_PAR03 : IMPRIME PAGINAS (1-SIM | 2-NAO)
aAdd(aParams, MV_PAR04) //-- MV_PAR04 : No PAGINA INICIAL
aAdd(aParams, MV_PAR05) //-- MV_PAR05 : SELECIONA FILIAIS (1-SIM | 2-NAO)
aAdd(aParams, MV_PAR06) //-- MV_PAR06 : GERA RELATORIO, ARQUIVO OU AMBOS (1-RELATORIO | 2-ARQUIVO)
aAdd(aParams, MV_PAR07) //-- MV_PAR07 : DIRETORIO P/ GERACAO DO ARQUIVO

// -----------------------------------------
// VERIFICA FILIAIS SELECIONADAS
// -----------------------------------------
aFiliais := MatFilCalc(MV_PAR05 == 1)	//-- Seleciona Filiais
cPath := allTrim( getNewpar( "MV_PZFIS11","\data\") ) // Diretorio no servidor que sera utilizado para criar o arquivo

// ------------------------------------------------
// PROCESSO DE IMPRESSAO E/OU GERACAO ARQUIVO TEXTO
// ------------------------------------------------
If aParams[6] == 1			// .Or. aParams[6] == 3
	/*
	If aParams[6] == 3

		VarSetUID('ZFISR011', .T.)
		VarSetXD('ZFISR011', 'cStatusPrc', '0')
		VarSetXD('ZFISR011', 'cArq', '')

		StartJob('U_GerArq' , GetEnvServer(), .F., aFiliais, aParams, cEmpAnt, cFilAnt)
		//U_GerArq(aFiliais, aParams, cEmpAnt, cFilAnt)

	EndIf
	*/

	//-- REALIZA IMPRESSAO DO RELATORIO...
	FImpLivFis(oReport, aFiliais, aParams)

	/*
	If aParams[6] == 3
		VarGetXD('ZFISR011', 'cStatusPrc', @cStatusPrc)
		VarGetXD('ZFISR011', 'cArq', @cArq)

		ConOut('cStatusPrc .... ' + cStatusPrc)
		ConOut('cPath + cArq .. ' + cPath + cArq)
		ConOut('aParams[7] .... ' + AllTrim(aParams[7]) + If(Right(AllTrim(aParams[7]), 1) == '\', '', '\'))
		ConOut(File(cPath+cArq))

		If cStatusPrc == '-1'
			ApMsgStop("Ocorreu um erro ao criar o arquivo.")
		Else
			While cStatusPrc == '1'
				Sleep(1000)
				VarGetXD('ZFISR011', 'cStatusPrc', @cStatusPrc)
			End

			If cStatusPrc == '-1'
				ApMsgStop("Ocorreu um erro ao criar o arquivo.")
			Else
				If CpyS2T(cPath + cArq, AllTrim(aParams[7]) + If(Right(AllTrim(aParams[7]), 1) == '\', '', '\'))
					MsgAlert(STR0064 + ' -  Directorio: ' + AllTrim(aParams[7]) + If(Right(AllTrim(aParams[7]), 1) == '\', '', '\'))
   				Else
					MsgAlert('No se pudo copiar el archivo')
				EndIf
			EndIf

		EndIf
	EndIf
	*/

EndIf

If aParams[6] == 2
	Processa({|lEnd| U_GerArq(aFiliais, aParams, @lEnd)},, STR0063, .T.)
	MsgAlert(STR0064 + ' -  Directorio: ' + AllTrim(aParams[7]) + If(Right(AllTrim(aParams[7]), 1) == '\', '', '\'))
EndIf

Return


/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥FImpLivFis≥ Autor ≥ Rodrigo M. Pontes     ≥ Data | 30/11/09 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥Impress„o do relatorio.								      ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function FImpLivFis(oReport, aFiliais, aParams)
Local nI           := 0
Local nlExpo       := 0	//-- Total de exportaÁ„o
Local nlBase       := 0	//-- Total de base do imposto
Local nlExon       := 0	//-- Total (isento do IGV e Exonerada)
Local nlInaf       := 0	//-- Total (isento do IGV e Inafecta)
Local nlIsc        := 0	//-- Total do Valor de ISC
Local nlIgv        := 0	//-- Total do Valor de IGV
Local nlTrib       := 0	//-- Total outros tributados
Local nlValC       := 0	//-- Total do Valor total do documento
Local nColT        := 0	//-- Coluna de impress„o do total
Local nLinT        := 0	//-- Linha de impress„o do total
Local nLinP        := 0	//-- Linha de impress„o do total parcial
Local nColP        := 0	//-- Coluna de impress„o do total parcial
Local nlExpoPar    := 0	//-- Total parcial de exportaÁ„o
Local nlBasePar    := 0	//-- Total parcial de base do imposto
Local nlExonPar    := 0	//-- Total parcial (isento do IGV e Exonerada)
Local nlInafPar    := 0	//-- Total parcial (isento do IGV e Inafecta)
Local nlIscPar     := 0	//-- Total parcial do Valor de ISC
Local nlIgvPar     := 0	//-- Total parcial do Valor de IGV
Local nlTribPar    := 0	//-- Total parcial outros tributados
Local nlValCPar    := 0	//-- Total parcial do Valor total do documento
Local nlF3Base     := 0	//-- Recebe o valor da base imponible
Local nTributo     := 0
Local nReg         := 0	//-- Contador de registros
Local nlTotReg     := 0	//-- Total de registros
Local nlTotRel     := 0	//-- Total geral de registros
Local nlTotPag     := 77	//-- 80
Local nCol         := 0
Local i            := 0
Local cTpDoc       := ""
Local dDtEmis      := CtoD(Space(08))
Local lNotOri      := .F.
Local nSinal       := 1
Local cCorrela     := ""
Local nT           := 1
Local lImpri       := .T.
Local nValcont     := 0
Local cTipoDoc_Anu := ''
Local cAliasTrib   := ''
Local lCpDoc       := SF3->(FieldPos("F3_TPDOC")) > 0
Local lSer3        := SFP->(FieldPos("FP_YSERIE")) > 0 //-- Impresion de la serie 2 (factura electrocnica - Peru)
Local lSerie2      := SF1->(FieldPos("F1_SERIE2")) > 0 .And. SF2->(FieldPos("F2_SERIE2")) > 0 .And. SF3->(FieldPos("F3_SERIE2")) > 0 .And. GetNewPar("MV_LSERIE2", .F.)
Local lSerOri      := SF1->(FieldPos("F1_SERORI")) > 0 .And. SF2->(FieldPos("F2_SERORI")) > 0 .And. SF3->(FieldPos("F3_SERORI")) > 0
Local lCodSF1      := SF1->(FieldPos('F1_TPDOC')) > 0
Local lCodSF2      := SF2->(FieldPos('F2_TPDOC')) > 0
Local lSerie2SFP   := SFP->(FieldPos("FP_SERIE2"))>0
Local cTipoDoc_Anu := ""
Local cFilSFP	:= xFilial("SFP")
Local cFilSF1	:= xFilial("SF1")
Local cFilSF2	:= xFilial("SF2")
Local cFilSD1	:= xFilial("SD1")
Local cFilSD2   := xFilial("SD2")

Local nCount       := 0
Local nDiv         := 1000

Private oTmpTable := Nil
Private cPosCpo   := IIf(cVersao=="11", "FieldPos", "ColumnPos")

// ----------------------------------------
// TRATA LOG DE PROCESSAMENTO
// ----------------------------------------
ConOut('[DS2U]' + Repl('-', 50))
ConOut('INICIO DO PROCESSAMENTO: ' + Time())
ConOut(Repl('-', 50))
/*
ConOut('PARAMETROS:')
ConOut('DATA INICIAL      : ' + DtoC(MV_PAR01))
ConOut('DATA FINAL        : ' + DtoC(MV_PAR02))
ConOut('IMPRIME PAGINAS   : ' + AllTrim(Str(MV_PAR03)))
ConOut('No PAGINA INICIAL : ' + AllTrim(Str(MV_PAR04)))
ConOut('SELECIONA FILIAIS : ' + AllTrim(Str(MV_PAR05)))
ConOut('GERAR             : ' + If(MV_PAR06 == 1, 'RELATORIO', 'ARQUIVO'))
ConOut('DIRETORIO         : ' + AllTrim(MV_PAR07))
*/
ConOut(Repl('-', 50))


// -----------------------------------------
// PROCESSA A QUERY PRINCIPAL
// -----------------------------------------
cAliasPer  := FISR011Qry(aFiliais, aParams)


// ---------------------------------------------
// PROCESSA ARQUIVO TEMPORARIO - OUTROS TRIBUTOS
// ---------------------------------------------
cAliasTrib := FISR011Trib(aFiliais, aParams)


// -------------------------------------------
// INICIA PROCESSO DE IMPRESSAO
// -------------------------------------------
ConOut('[DS2U]' + Repl('-', 50))
ConOut('INICIANDO PROCESSAMENTO DA IMPRESSAO: ' + Time())
ConOut(Repl('-', 50))


If (cAliasPer)->(!EOF())
	FCabR011(oReport,nCol,,,,,,,,, aParams)
	(cAliasPer)->(DBEval({|| nReg++}, {|| .T.}, {|| !Eof()}))
Endif
(cAliasPer)->(dbGoTop())
oReport:SetMeter(nReg)

ConOut('TOTAL DE REGISTROS: ' + AllTrim(Str(nReg)) + ' - ' + Time())

While (cAliasPer)->(!Eof())
	//-- Trata eventual cancelamento da impressao...
	If oReport:Cancel()
		Exit
	EndIf

	If	lImpri
		nlTotRel++
	 	lImpri:=.F.
	EndIf

	cCorrela := (cAliasPer)->F2_NODIA
	If Empty((cAliasPer)->F2_NODIA)
		cCorrela := BuscaCorre((cAliasPer)->F3_FILIAL, (cAliasPer)->F3_NFISCAL, (cAliasPer)->F3_SERIE, (cAliasPer)->F3_CLIEFOR, (cAliasPer)->F3_LOJA, (cAliasPer)->F3_EMISSAO,(cAliasPer)->F3_ESPECIE)
	EndIf

	nSinal       := If(("NC" $ (cAliasPer)->F3_ESPECIE .OR. (cAliasPer)->CCL_CODGOV == '25'), -1, 1)
	cFil         := (cAliasPer)->F3_FILIAL
	cNFiscal     := (cAliasPer)->F3_NFISCAL
	cSerie       := (cAliasPer)->F3_SERIE
	cClifor      := (cAliasPer)->F3_CLIEFOR
	cLoja        := (cAliasPer)->F3_LOJA
	cEspecie     := (cAliasPer)->F3_ESPECIE
	cNome        := (cAliasPer)->A1_NOME
	cCGC         := (cAliasPer)->A1_CGC
	cPessFis     := (cAliasPer)->A1_PFISICA
	cTipoDoc     := (cAliasPer)->A1_TIPDOC
	cCodGov      := (cAliasPer)->CCL_CODGOV
	dEmissao     := (cAliasPer)->F3_EMISSAO
	cTipoDoc_Anu := If(lCpDoc, (cAliasPer)->F3_TPDOC, '')

	If AllTrim(cCGC) <> 'Anulado'
		nValcont1 := (cAliasPer)->F3_VALCONT - ((cAliasPer)->(EXONERADA + F3_BASIMP1 + F3_BASIMP2 + F3_VALIMP2 + F3_VALIMP1 + EXPORTACAO + INAFECTA))
		nTxMoeda  := (cAliasPer)->F2_TXMOEDA
		nExporta  := (cAliasPer)->EXPORTACAO
		nExonera  := (cAliasPer)->EXONERADA
		nInafecta := (cAliasPer)->INAFECTA
		nValimp2  := (cAliasPer)->F3_VALIMP2
		nValimp1  := (cAliasPer)->F3_VALIMP1
		nBase1    := (cAliasPer)->F3_BASIMP1
		nBase2    := (cAliasPer)->F3_BASIMP2
		nValcont  := 0

	Else
		nValcont  := 0
		nTxMoeda  := 0
		nExporta  := 0
		nExonera  := 0
		nInafecta := 0
		nValimp2  := 0
		nValimp1  := 0
		nBase1    := 0
		nBase2    := 0

	EndIf

	dVenctoRe := (cAliasPer)->E1_VENCREA
	cSer2     := If(lSerie2, (cAliasPer)->F3_SERIE2, '')
	cSerOri   := If(lSerOri, (cAliasPer)->F3_SERORI, '')

	lImprime:=.T.
	If (cAliasPer)->(Eof())
		lImprime:=.F.
	EndIf

	(cAliasPer)->(DbSkip())
	nCount++


	If (cAliasPer)->(!Eof())
		nlTotRel++
	EndIf

	If nBase1 > 0 .And. nBase2 = 0
		nlBasePar += nBase1 * nSinal //Total parcial
		nlBase    += nBase1 * nSinal //Total geral
		nlF3Base  := nBase1 * nSinal //Campo para a impress„o

	Elseif nBase1 = 0 .And. nBase2 > 0
		nlBasePar += nBase2 * nSinal //Total parcial
		nlBase    += nBase2 * nSinal //Total geral
		nlF3Base  := nBase2 * nSinal //Campo para a impress„o

	Elseif nBase1 > 0 .And. nBase2 > 0
		nlBasePar += (nBase1 - nBase2) * nSinal //Total parcial
		nlBase    += (nBase1 - nBase2) * nSinal //Total geral
		nlF3Base  := (nBase1 - nBase2) * nSinal //Campo para a impress„o

	Else
		nlBasePar += 0
		nlBase    += 0
		nlF3Base  := 0

	Endif

	If AllTrim(cCGC) <> 'Anulado'
		nlExpoPar += nExporta * nSinal //Total parcial
		nlExpo    += nExporta * nSinal //Total geral
		nlExonPar += nExonera * nSinal //Total parcial
		nlExon    += nExonera * nSinal//Total geral

		nlInafPar += nInafecta * nSinal //Total parcial
		nlInaf    += nInafecta * nSinal //Total geral

		nlIscPar  += nValimp2 * nSinal //Total parcial
		nlIsc     += nValimp2 * nSinal //Total geral

		nlIgvPar  += nValimp1 * nSinal //Total parcial
		nlIgv     += nValimp1 * nSinal //Total geral

		nValcont  := nValcont + nValcont1 + nExporta + Abs(nlF3Base) + nExonera + nInafecta + nValimp2 + nValimp1

		nlValCPar += (nValcont1 + nExporta + Abs(nlF3Base) + nExonera + nInafecta + nValimp2 + nValimp1) * nSinal //Total parcial
		nlValC    += (nValcont1 + nExporta + Abs(nlF3Base) + nExonera + nInafecta + nValimp2 + nValimp1) * nSinal //Total geral

		If (cAliasPer)->(!Eof()) .And. cFil+cNFiscal+cSerie+cCliFor+cLoja+cEspecie == (cAliasPer)->(F3_FILIAL+F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA+F3_ESPECIE)
			lImprime:=.F.
		EndIf

	EndIf


	If lImprime
		oReport:PrintText(cCorrela			, oReport:Row(), oReport:Col()+0040)	// 1
		oReport:PrintText(DtoC(dEmissao)	, oReport:Row(), oReport:Col()+0070)	// 2
		oReport:PrintText(DtoC(dVenctoRe)	, oReport:Row(), oReport:Col()+0070)	// 3

		If Alltrim(cEspecie) $ "NDP/NDE/NCI/NCC"
			SF1->(DbSetOrder(1))
			If SF1->(dbSeek(xFilial("SF1")+cNFiscal+cSerie+cClifor+cLoja))
				cTpDoc := AllTrim(SF1->F1_TPDOC)
			Else
				If Empty(cTipoDoc_Anu)
					cTpDoc:=xNCCAnul(cFil,cNFiscal,cSerie,cClifor,cLoja)
				Else
					cTpDoc := AllTrim(cTipoDoc_Anu)
				EndIf
			EndIf
		Else
			If !Empty(cCodGov) .And. AllTrim(cCGC) <> 'Anulado'
				cTpDoc := Trim(cCodGov)
			ElseIf cTpDoc <> "12" .And. AllTrim(cCGC) <> 'Anulado'
				SF2->(DbSetOrder(1)) //--F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
				If SF2->(DbSeek(cFil+cNFiscal+cSerie+cCliFor+cLoja))
					cTpDoc := AllTrim(SF2->F2_TPDOC)
				Else
					cTpDoc := Space(02)
				EndIf
			ElseIf  AllTrim(cCGC) == 'Anulado' .and. lCpDoc
				cTpDoc := AllTrim(cTipoDoc_Anu)
			ElseIf AllTrim(cCGC) == 'Anulado' .and. cTpDoc <> "12"
				cTpDoc:= Trim(BuscaTpDoc(cFil,cNFiscal,cSerie,cClifor,cLoja))
			EndIf
		EndIf
		cSerieNf := Alltrim(Iif(lSerOri .and. !Empty(cSerOri), RetNewSer(cSerOri), Iif(lSerie2 .and. Empty(cSerie), RetNewSer(cSer2), RetNewSer(cSerie))))
		cSerieNf := Padr(cSerieNf,TamSx3("FP_SERIE")[1])
		lTemSFP := .f.

		// ----------------------------------------------------------------------------------- //
		// Adicionado por SISTHEL para impresion de la serie 2 ( factura electrocnica - Peru ) //
		// ----------------------------------------------------------------------------------- //
		SFP->(dbSetOrder(5))	//FP_FILIAL, FP_FILUSO, FP_SERIE, FP_ESPECIE, R_E_C_N_O_, D_E_L_E_T_
		If SFP->(dbSeek(xFilial("SFP")+cFil+cSerieNf+"1"))
			If lSer3 .And. !Empty(SFP->FP_YSERIE)
				If Len( Alltrim(SFP->FP_YSERIE) ) > 4
					cTpDoc := "12"
				EndIf
			EndIf
			if SFP->( FieldPos("FP_SERIE2") )>0
				if !empty(SFP->FP_SERIE2)
					cSerieNf := SFP->FP_SERIE2
					lTemSFP := .t.
				endif
			endif
		Else
			If SFP->( dbSeek( xFilial("SFP")+cFil+cSerieNf+"6"))
				If lSer3 .And. !Empty(SFP->FP_YSERIE)
					If Len( Alltrim(SFP->FP_YSERIE) ) > 4
						cTpDoc := "12"
					EndIf
				EndIf
			EndIf
		EndIf

		oReport:PrintText(Trim(cTpDoc),oReport:Row(),oReport:Col()+0055)//4
		
		// ----------------------------------------------------------------------------------- //
		// Adicionado por SISTHEL para impresion de la serie 2 ( factura electrocnica - Peru ) //
		// ----------------------------------------------------------------------------------- //

		SFP->( dbSetOrder(5) )	//FP_FILIAL, FP_FILUSO, FP_SERIE, FP_ESPECIE, R_E_C_N_O_, D_E_L_E_T_
		If SFP->( dbSeek( xFilial("SFP")+cFil+cSerieNf+"1" ) )
			If lSer3 .And. !Empty(SFP->FP_YSERIE)
				cSerieNf := SFP->FP_YSERIE
				lTemSFP := .t.
			else
				if !empty(SFP->FP_SERIE2)
					cSerieNf := SFP->FP_SERIE2
					lTemSFP := .t.
				endif
			endif
		endif
		
		if !lTemSFP
			If SFP->( MsSeek( cFilSFP+cFil+cSerieNf+"6" ) )
				If lSer3 .And. !Empty(SFP->FP_YSERIE)
					cSerieNf := SFP->FP_YSERIE
					lTemSFP := .t.
				else
					if !empty(SFP->FP_SERIE2)
						cSerieNf := SFP->FP_SERIE2
						lTemSFP := .t.
					endif
				endif
			endif
		EndIf

		if !lTemSFP
			If SFP->( MsSeek( cFilSFP+cFil+cSerieNf+"3" ) )
				If lSer3 .And. !Empty(SFP->FP_YSERIE)
					cSerieNf := SFP->FP_YSERIE
					lTemSFP := .t.
				else
					if !empty(SFP->FP_SERIE2)
						cSerieNf := SFP->FP_SERIE2
						lTemSFP := .t.
					endif
				endif
			endif
		EndIf

		if !lTemSFP
			If SFP->( MsSeek( cFilSFP+cFil+cSerieNf+"2" ) )
				If lSer3 .And. !Empty(SFP->FP_YSERIE)
					cSerieNf := SFP->FP_YSERIE
					lTemSFP := .t.
				else
					if !empty(SFP->FP_SERIE2)
						cSerieNf := SFP->FP_SERIE2
						lTemSFP := .t.
					endif
				endif
			endif
		EndIf

		If lSer3
			oReport:PrintText(Alltrim(cSerieNf)+Space(Len(SFP->FP_YSERIE)-Len(Alltrim(cSerieNf))), oReport:Row(), oReport:Col()+093)//5
		Else
			If !Empty(cSer2) .And. Subs(cSer2,1,1) $ "B|E|F"
				cSerieNf := Alltrim(cSer2)
			Else
				cSerieNf := AllTrim(RetNewSer(cSerie))
			EndIf

			If len(cSerieNf)<=3
				cSerieNf := Replicate("0",4-Len(cSerieNf))+cSerieNf
			EndIf
			
			If AllTrim(cTpDoc)=='05'
				cSerieNf :=  "4"
			EndIf
			oReport:PrintText(Alltrim(cSerieNf), oReport:Row(), oReport:Col()+093)//5
		EndIf

		If lSer3
			oReport:PrintText(cNFiscal, oReport:Row(), oReport:Col()+0050/*0163*/)//6
		Else
			oReport:PrintText(cNFiscal, oReport:Row(), oReport:Col()+0200/*0163*/)//6
		EndIf

		IF AllTrim(cCGC) <> 'Anulado'
			oReport:PrintText(cTipoDoc, oReport:Row(), oReport:Col()+0040)//7
		Else
			oReport:PrintText(SPACE(2), oReport:Row(), oReport:Col()+0040)//7
		EndIf

		oReport:PrintText(IIF(!EMPTY(cCGC), cCGC, SUBSTR(cPessFis,1,14)), oReport:Row(), oReport:Col()+0100)//8

		IF ALLTRIM( cCGC)<>'Anulado'
			oReport:PrintText(Left(cNome,40),oReport:Row(),oReport:Col()+0060)//9
		Else
			oReport:PrintText(SPACE(40)	,oReport:Row(),oReport:Col()+0060)//9
		ENDIF

		oReport:PrintText(Transform(nlExpoPar * nSinal	, "@E 999,999,999.99")	, oReport:Row()	, oReport:Col()+0001)//10
		oReport:PrintText(Transform(nlF3Base			, "@E 999,999,999.99")	, oReport:Row()	, oReport:Col()+0008)//11
		oReport:PrintText(Transform(nlExonPar * nSinal	, "@E 999,999,999.99")	, oReport:Row()	, oReport:Col()+0013)//12
		oReport:PrintText(Transform(nlInafPar * nSinal	, "@E 999,999,999.99")	, oReport:Row()	, oReport:Col()+0015)//13
		oReport:PrintText(Transform(nValimp2 * nSinal	, "@E 999,999,999.99")	, oReport:Row()	, oReport:Col()+0003)//14
		oReport:PrintText(Transform(nValimp1 * nSinal	, "@E 999,999,999.99")	, oReport:Row()	, oReport:Col()+0018)//15

		(cAliasTrib)->(DbSetOrder(1))
		If (cAliasTrib)->(MsSeek(cNFiscal+cSerie+cClifor+cLoja))
			IF nlInafPar > 0 .Or. nlExonPar > 0
				oReport:PrintText(Transform(nlInafPar + nlExonPar ,"@E 999,999,999.99")	,oReport:Row(),oReport:Col()+0030)//16
				nlTribPar += (nlInafPar + nlExonPar )* nSinal //Total parcial
				nlTrib	  += (nlInafPar + nlExonPar )* nSinal //Total geral
				nTributo  := 0
				nTributo  += nlInafPar + nlExonPar
			Else
				oReport:PrintText(Transform(0 ,"@E 999,999,999.99")	, oReport:Row(), oReport:Col()+0030)//16
				nlTribPar += 0//nValimp2 + nValimp1 //Total parcial
				nlTrib	  += 0//nValimp2 + nValimp1 //Total geral
				nTributo  := 0
				nTributo  += nlInafPar + nlExonPar
			EndIf
		Else
			oReport:PrintText(Transform(0   ,"@E 999,999,999.99"), oReport:Row(), oReport:Col()+0030)//16
		EndIf

		oReport:PrintText(Transform(nValcont * nSinal, "@E 999,999,999.99")	, oReport:Row(),oReport:Col()+0040)//17
		oReport:PrintText(Transform(nTxMoeda, "@E 999999.9999 "), oReport:Row(), oReport:Col()+0020)//18
		If Alltrim(cEspecie) $ "NDC/NCE/NCP/NDI"
			SD2->(DbSetOrder(3))
			If SD2->(DbSeek(xFilial("SD2") + cNFiscal + cSerie + cClifor + cLoja ))
				If Len(Trim(SD2->D2_NFORI)) > 0
					_cTpoDoc := ""			// SISTHEL

					SF2->(DbSetOrder(1))
					If SF2->(dbSeek(xFilial("SF2")+AvKey(cNFiscal,"F2_DOC")+AvKey(cSerie,"F2_SERIE")+AvKey(cClifor,"F2_CLIENTE")+AvKey(cLoja,"D2_LOJA")))
						oReport:PrintText(Trim(DtoC(SF2->F2_EMISSAO)), oReport:Row(), oReport:Col()+0075)//19
						_cTpoDoc := Trim(SF2->F2_TPDOC)		// SISTHEL
					Else
						oReport:PrintText("      ", oReport:Row(),oReport:Col()+0075) //19
						_cTpoDoc := ""						// SISTHEL
					Endif

					// ----------------------------------------------------------------------------------- //
					// Adicionado por SISTHEL para impresion de la serie 2 ( factura electrocnica - Peru ) //
					// ----------------------------------------------------------------------------------- //
					SFP->( dbSetOrder(5) )	//FP_FILIAL, FP_FILUSO, FP_SERIE, FP_ESPECIE, R_E_C_N_O_, D_E_L_E_T_
					If SFP->( dbSeek( xFilial("SFP")+cFil+cSerieNf+"1" ) )
						If lSer3 .And. !Empty(SFP->FP_YSERIE)
							If Len( Alltrim(SFP->FP_YSERIE) ) > 4
								_cTpoDoc := "12"
							EndIf
						EndIf
					Else
						If SFP->( dbSeek( xFilial("SFP")+cFil+cSerieNf+"6" ) )
							If lSer3 .And. !Empty(SFP->FP_YSERIE)
								If Len( Alltrim(SFP->FP_YSERIE) ) > 4
									_cTpoDoc := "12"
								EndIf
							EndIf
						EndIf
					EndIf

					oReport:PrintText(Trim(_cTpoDoc),oReport:Row(),oReport:Col()+0055)//20
					Do While SD2->(!Eof()) .And. ALLTRIM(SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA)==ALLTRIM(cNFiscal + cSerie + cClifor + cLoja)
						If !Empty(SD2->D2_NFORI+SD2->D2_SERIORI)
							oReport:nCol:=4450
							// ----------------------------------------------------------------------------------- //
							// Adicionado por SISTHEL para impresion de la serie 2 ( factura electrocnica - Peru ) //
							// ----------------------------------------------------------------------------------- //
							cSSerie := SD2->D2_SERIORI
							lTemSFP := .f.
							SFP->( dbSetOrder(5) )	//FP_FILIAL, FP_FILUSO, FP_SERIE, FP_ESPECIE, R_E_C_N_O_, D_E_L_E_T_
							If SFP->( dbSeek( xFilial("SFP")+cFil+cSSerie+"1" ) )
								If lSer3 .And. !Empty(SFP->FP_YSERIE)
									cSSerie := Alltrim(SFP->FP_YSERIE)
									lTemSFP := .t.
								EndIf
								if lSerie2SFP .And. !empty(SFP->FP_SERIE2)
									cSSerie := Alltrim(SFP->FP_SERIE2)
									lTemSFP := .t.
								endif
							endif
							if !lTemSFP
								If SFP->( dbSeek( xFilial("SFP")+cFil+cSSerie+"6" ) )
									If lSer3 .And. !Empty(SFP->FP_YSERIE)
										cSSerie := Alltrim(SFP->FP_YSERIE)
										lTemSFP := .t.
									EndIf
								endif
								if lSerie2SFP .And. !empty(SFP->FP_SERIE2)
									cSSerie := Alltrim(SFP->FP_SERIE2)
									lTemSFP := .t.
								endif
							EndIf
							if !lTemSFP
								If SFP->( dbSeek( xFilial("SFP")+cFil+cSSerie+"3" ) )
									If lSer3 .And. !Empty(SFP->FP_YSERIE)
										cSSerie := Alltrim(SFP->FP_YSERIE)
										lTemSFP := .t.
									EndIf
								endif
								if lSerie2SFP .And. !empty(SFP->FP_SERIE2)
									cSSerie := Alltrim(SFP->FP_SERIE2)
									lTemSFP := .t.
								endif
							EndIf
							if !lTemSFP
								If SFP->( dbSeek( xFilial("SFP")+cFil+cSSerie+"2" ) )
									If lSer3 .And. !Empty(SFP->FP_YSERIE)
										cSSerie := Alltrim(SFP->FP_YSERIE)
										lTemSFP := .t.
									EndIf
								endif
								if lSerie2SFP .And. !empty(SFP->FP_SERIE2)
									cSSerie := Alltrim(SFP->FP_SERIE2)
									lTemSFP := .t.
								endif
							EndIf
							If Len(cSSerie)<=3
								cSSerie := Replicate("0",4-Len(cSSerie))+cSSerie
							EndIf
							oReport:PrintText(Trim(cSSerie)	,oReport:Row(),oReport:Col()+0015)//21
							oReport:PrintText(Trim(SD2->D2_NFORI),oReport:Row(),oReport:Col()+0065)//22
							FLinR011(oReport,nCol,nlTotReg,nReg,.F.)
							lNotOri:=.T.
						Else
							FLinR011(oReport,nCol,nlTotReg,nReg,.F.)
						Endif
						SD2->(DbSkip())
					End
				ElseIf (cAliasPer)->(!Eof())
					lNotOri:=.F.
				EndIf
			Endif

			nlTotReg++
			If lNotOri
				oReport:Box(oReport:Row()-005,oReport:Col()-0005,oReport:Row()-005,oReport:Col()+4850,)
			Else
				FLinR011(oReport,nCol,nlTotReg,nReg,.T.)
			Endif

		ElseIf Alltrim(cEspecie) $ "NDP/NDE/NCI/NCC"
			SD1->(DbSetOrder(1))
			If SD1->(DbSeek(xFilial("SD1") + cNFiscal + cSerie + cClifor + cLoja))
				_cTpoDoc := ""		// SISTHEL

				SF2->(DbSetOrder(1))
				If SF2->(DbSeek(xFilial("SF2") + AvKey(SD1->D1_NFORI,"F2_DOC")+ AvKey(SD1->D1_SERIORI,"F2_SERIE")+AvKey(SD1->D1_FORNECE,"D2_CLIENTE")+AvKey(SD1->D1_LOJA,"D2_LOJA")))
					oReport:PrintText(Trim(DtoC(SF2->F2_EMISSAO)),oReport:Row(),oReport:Col()+0075)//19
					_cTpoDoc := Trim(SF2->F2_TPDOC)		// SISTHEL
				Else
					oReport:PrintText("      ", oReport:Row(),  oReport:Col()+0075)//19
					_cTpoDoc := ""						// SISTHEL
				Endif
				// ----------------------------------------------------------------------------------- //
				// Adicionado por SISTHEL para impresion de la serie 2 ( factura electrocnica - Peru ) //
				// ----------------------------------------------------------------------------------- //
				SFP->( dbSetOrder(5) )	//FP_FILIAL, FP_FILUSO, FP_SERIE, FP_ESPECIE, R_E_C_N_O_, D_E_L_E_T_
				If SFP->( dbSeek( xFilial("SFP")+cFil+cSerieNf+"1" ) )
					If lSer3 .And. !Empty(SFP->FP_YSERIE)
						If Len( Alltrim(SFP->FP_YSERIE) ) > 4
							_cTpoDoc := "12"
						EndIf
					EndIf
				Else
					If SFP->( dbSeek( xFilial("SFP")+cFil+cSerieNf+"6" ) )
						If lSer3 .And. !Empty(SFP->FP_YSERIE)
							If Len( Alltrim(SFP->FP_YSERIE) ) > 4
								_cTpoDoc := "12"
							EndIf
						EndIf
					EndIf
				EndIf

				oReport:PrintText(Trim(_cTpoDoc), oReport:Row(), oReport:Col()+0055)//20
				Do While SD1->(!Eof()) .And. ALLTRIM(SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA) == ALLTRIM(cNFiscal + cSerie + cClifor + cLoja)
					If !Empty(SD1->D1_NFORI+SD1->D1_SERIORI)
						oReport:nCol:=4450

						// ----------------------------------------------------------------------------------- //
						// Adicionado por SISTHEL para impresion de la serie 2 ( factura electrocnica - Peru ) //
						// ----------------------------------------------------------------------------------- //
						cSSerie := SD1->D1_SERIORI
						lTemSFP := .f.
						SFP->( dbSetOrder(5) )	//FP_FILIAL, FP_FILUSO, FP_SERIE, FP_ESPECIE, R_E_C_N_O_, D_E_L_E_T_
						If SFP->( dbSeek( xFilial("SFP")+cFil+cSSerie+"1" ) )
							If lSer3 .And. !Empty(SFP->FP_YSERIE)
								cSSerie := Alltrim(SFP->FP_YSERIE)
								lTemSFP := .t.
							EndIf
							if lSerie2SFP .And. !empty(SFP->FP_SERIE2)
								cSSerie := Alltrim(SFP->FP_SERIE2)
								lTemSFP := .t.
							endif
						endif

						if !lTemSFP
							If SFP->( dbSeek( xFilial("SFP")+cFil+cSSerie+"6" ) )
								If lSer3 .And. !Empty(SFP->FP_YSERIE)
									cSSerie := Alltrim(SFP->FP_YSERIE)
									lTemSFP := .t.
								EndIf
							endif
							if lSerie2SFP .And. !empty(SFP->FP_SERIE2)
								cSSerie := Alltrim(SFP->FP_SERIE2)
								lTemSFP := .t.
							endif
						EndIf

						if !lTemSFP
							If SFP->( dbSeek( xFilial("SFP")+cFil+cSSerie+"3" ) )
								If lSer3 .And. !Empty(SFP->FP_YSERIE)
									cSSerie := Alltrim(SFP->FP_YSERIE)
									lTemSFP := .t.
								EndIf
							endif
							if lSerie2SFP .And. !empty(SFP->FP_SERIE2)
								cSSerie := Alltrim(SFP->FP_SERIE2)
								lTemSFP := .t.
							endif
						EndIf

						if !lTemSFP
							If SFP->( MsSeek( cFilSFP+cFil+cSSerie+"2" ) )
								If lSer3 .And. !Empty(SFP->FP_YSERIE)
									cSSerie := Alltrim(SFP->FP_YSERIE)
									lTemSFP := .t.
								EndIf
							endif
							if lSerie2SFP .And. !empty(SFP->FP_SERIE2)
								cSSerie := Alltrim(SFP->FP_SERIE2)
								lTemSFP := .t.
							endif
						EndIf

						If Len(cSSerie)<=3
							cSSerie := Replicate("0",4-Len(cSSerie))+cSSerie
						EndIf

						oReport:PrintText(Trim(cSSerie),oReport:Row(),oReport:Col()+0015)//21

						oReport:PrintText(Trim(SD1->D1_NFORI),oReport:Row(),oReport:Col()+0065)//22
						lNotOri:=.T.
						FLinR011(oReport,nCol,nlTotReg,nReg,.F.)
					Else
						FLinR011(oReport,nCol,nlTotReg,nReg,.F.)
					Endif
					SD1->(DbSkip())
				End
			Endif

			nlTotReg++

			If lNotOri
				oReport:Box(oReport:Row()-005,oReport:Col()-0005,oReport:Row()-005,oReport:Col()+4850,)
			Else
				FLinR011(oReport,nCol,nlTotReg,nReg,.T.)
			Endif
		Else
			nlTotReg++
			If !(nlTotReg > nlTotPag .or. nReg == nlTotRel) .Or. (cAliasPer)->(!EOF())
				FLinR011(oReport,nCol,nlTotReg,nReg,.T.)
			EndIf
		Endif

		If nReg == nlTotRel
			nLinP := oReport:Row()+32
			nColP := oReport:Col()-1810

			oReport:SetPageFooter(1,{|| oReport:PrintText(STR0006,nLinP,oReport:Col()+1800),; //TOTAIS GERAIS: - "Totales:"
			oReport:PrintText(Transform(nlExpo,"@E 999,999,999.99"),nLinP,oReport:Col()+0270),;  //0098
			oReport:PrintText(Transform(nlBase,"@E 999,999,999.99"),nLinP,oReport:Col()+0020),;  //0116
			oReport:PrintText(Transform(nlExon,"@E 999,999,999.99"),nLinP,oReport:Col()+0015),;  //0326
			oReport:PrintText(Transform(nlInaf,"@E 999,999,999.99"),nLinP,oReport:Col()+0015),;  //0535
			oReport:PrintText(Transform(nlIsc ,"@E 999,999,999.99"),nLinP,oReport:Col()+0015),;  //0742
			oReport:PrintText(Transform(nlIgv ,"@E 999,999,999.99"),nLinP,oReport:Col()+0010),;  //0958
			oReport:PrintText(Transform(nlTrib,"@E 999,999,999.99"),nLinP,oReport:Col()+0010),;  //1190
			oReport:PrintText(Transform(nlValC,"@E 999,999,999.99"),nLinP,oReport:Col()+0050),;  //1438
			nlExpoPar := nlBasePar := nlExonPar := nlInafPar := nlIscPar := nlIgvPar := ;
			nlTribPar := nlValCPar := 0,oReport:ThinLine(),;
			oReport:Box(oReport:Row()-005,oReport:Col()+1625,oReport:Row()+030,oReport:Col()+3940,),;
			oReport:Box(oReport:Row()-005,oReport:Col()+1625,oReport:Row()+030,oReport:Col()+3940,),;
			oReport:Box(oReport:Row()-005,oReport:Col()+1625,oReport:Row()+030,oReport:Col()+1625,),;
			oReport:Box(oReport:Row()-005,oReport:Col()+2210,oReport:Row()+030,oReport:Col()+2210,),;
			oReport:Box(oReport:Row()-005,oReport:Col()+2415,oReport:Row()+030,oReport:Col()+2415,),;
			oReport:Box(oReport:Row()-005,oReport:Col()+2620,oReport:Row()+030,oReport:Col()+2620,),;
			oReport:Box(oReport:Row()-005,oReport:Col()+2825,oReport:Row()+030,oReport:Col()+2825,),;
			oReport:Box(oReport:Row()-005,oReport:Col()+3040,oReport:Row()+030,oReport:Col()+3040,),;
			oReport:Box(oReport:Row()-005,oReport:Col()+3245,oReport:Row()+030,oReport:Col()+3245,),;
			oReport:Box(oReport:Row()-005,oReport:Col()+3465,oReport:Row()+030,oReport:Col()+3465,),;
			oReport:Box(oReport:Row()-005,oReport:Col()+3700,oReport:Row()+030,oReport:Col()+3700,)})

		Else
			nLinP    := oReport:Row()+32
			nColP    := oReport:Col()-1810
			nlExpoPa := nlExpoPar
			nlBasePa := nlBasePar
			nlExonPa := nlExonPar
			nlInafPa := nlInafPar
			nlIscPa  := nlIscPar
			nlIgvPa  := nlIgvPar
			nlTribPa := nlTribPar
			nlValCPa := nlValCPar

			oReport:SetPageFooter(1, {|| oReport:PrintText(STR0005, nLinP, oReport:Col()+1800),; //TOTAIS PARCIAIS: - "Va..."
			oReport:PrintText(Transform(nlExpoPar,"@E 999,999,999.99"),nLinP,nColP-0050),;
			oReport:PrintText(Transform(nlBasePar,"@E 999,999,999.99"),nLinP,nColP+0116),;
			oReport:PrintText(Transform(nlExonPar,"@E 999,999,999.99"),nLinP,nColP+0325),;
			oReport:PrintText(Transform(nlInafPar,"@E 999,999,999.99"),nLinP,nColP+0535),;
			oReport:PrintText(Transform(nlIscPar ,"@E 999,999,999.99"),nLinP,nColP+0742),;
			oReport:PrintText(Transform(nlIgvPar ,"@E 999,999,999.99"),nLinP,nColP+0963),;
			oReport:PrintText(Transform(nlTribPar,"@E 999,999,999.99"),nLinP,nColP+1198),;
			oReport:PrintText(Transform(nlValCPar,"@E 999,999,999.99"),nLinP,nColP+1438),;
			oReport:ThinLine(),;
			oReport:Box(oReport:Row()-005,oReport:Col()+1625,oReport:Row()+030,oReport:Col()+3940,),;
			oReport:Box(oReport:Row()-005,oReport:Col()+1625,oReport:Row()+030,oReport:Col()+3940,),;
			oReport:Box(oReport:Row()-005,oReport:Col()+1625,oReport:Row()+030,oReport:Col()+1625,),;
			oReport:Box(oReport:Row()-005,oReport:Col()+2210,oReport:Row()+030,oReport:Col()+2210,),;
			oReport:Box(oReport:Row()-005,oReport:Col()+2415,oReport:Row()+030,oReport:Col()+2415,),;
			oReport:Box(oReport:Row()-005,oReport:Col()+2620,oReport:Row()+030,oReport:Col()+2620,),;
			oReport:Box(oReport:Row()-005,oReport:Col()+2825,oReport:Row()+030,oReport:Col()+2825,),;
			oReport:Box(oReport:Row()-005,oReport:Col()+3040,oReport:Row()+030,oReport:Col()+3040,),;
			oReport:Box(oReport:Row()-005,oReport:Col()+3245,oReport:Row()+030,oReport:Col()+3245,),;
			oReport:Box(oReport:Row()-005,oReport:Col()+3465,oReport:Row()+030,oReport:Col()+3465,),;
			oReport:Box(oReport:Row()-005,oReport:Col()+3700,oReport:Row()+030,oReport:Col()+3700,)})
		EndIf

		oReport:OnPageBreak({|| FCabR011(oReport,nCol,nlExpoPa,nlBasePa,nlExonPa,nlInafPa,nlIscPa,nlIgvPa,nlTribPa,nlValCPa, aParams)})

		If nlTotReg > nlTotPag
			oReport:EndPage()
			nlTotReg :=0
		EndIf

		nlExpoPar := 0
		nlF3Base  := 0
		nlExonPar := 0
		nlInafPar := 0
		nValcont  := 0

	EndIf

	oReport:IncMeter()
	ConOut( "Processando registro " + allTrim( cValToChar( nCount ) ) + " de " + allTrim( cValToChar( nReg ) ) )	
	
EndDo

If nReg == 0
	oReport:PrintText(STR0004,oReport:Row(),oReport:Col()+0010)
EndIf

ConOut('[DS2U]' + Repl('-', 50))
ConOut('TERMINO DO PROCESSO DE IMPRESSAO: ' + Time())
ConOut(Repl('-', 50))

(cAliasPer)->(DbCLoseArea())

Return(oReport)

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥FCabR011  ≥ Autor ≥ Rodrigo M. Pontes     ≥ Data | 30/11/09 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥CabeÁalho do relatorio.								      ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function FCabR011(oReport,nCol,nlExpoPa,nlBasePa,nlExonPa,nlInafPa,nlIscPa,nlIgvPa,nlTribPa,nlValCPa, aParams)
Local oReport1 := oReport

DEFAULT nlExpoPa :=0
DEFAULT nlBasePa :=0
DEFAULT nlExonPa :=0
DEFAULT nlInafPa :=0
DEFAULT nlIscPa  :=0
DEFAULT nlIgvPa  :=0
DEFAULT nlTribPa :=0
DEFAULT nlValCPa :=0

nCol := oReport:Col() + 10
oReport:PrintText(STR0062)//"FORMATO 14.1 REGISTRO DE VENTAS E INGRESOS"
oReport:PrintText(STR0007+AllTrim(Str(Month(aParams[1])))+"/"+AllTrim(Str(Year(aParams[1]))) +" - " +	AllTrim(Str(Month(aParams[2])))+"/"+AllTrim(Str(Year(aParams[2]))), oReport:Row(), nCol) //Periodo
oReport:PrintText(STR0008+AllTrim(SM0->M0_CGC)					, oReport:Row()+35, nCol) //RUC
oReport:PrintText(STR0009+AllTrim(Capital(SM0->M0_NOMECOM))	, oReport:Row()+40, nCol) //Nome Contribuinte
If aParams[3] == 1
	oReport:PrintText(STR0010+AllTrim(Str(aParams[4])),oReport:Row()+40,nCol) //Pagina
Endif
oReport:SkipLine(2)

oReport:Box(oReport:Row()-005	,oReport:Col()-0005,oReport:Row()-005,oReport:Col()+4850,)
oReport:Box(oReport:Row()-005	,oReport:Col()-0005,oReport:Row()+192,oReport:Col()-0005,)
oReport:Box(oReport:Row()-005	,oReport:Col()+4850,oReport:Row()+192,oReport:Col()+4850,)

oReport:Box(oReport:Row()-005,oReport:Col()+0215,oReport:Row()+155,oReport:Col()+0215,)
oReport:Box(oReport:Row()-005,oReport:Col()+0425,oReport:Row()+155,oReport:Col()+0425,)
oReport:Box(oReport:Row()-005,oReport:Col()+0610,oReport:Row()+155,oReport:Col()+0610,)
oReport:Box(oReport:Row()-005,oReport:Col()+1210,oReport:Row()+155,oReport:Col()+1210,)
oReport:Box(oReport:Row()+060,oReport:Col()+0610,oReport:Row()+060,oReport:Col()+1210,)
oReport:Box(oReport:Row()+060,oReport:Col()+0690,oReport:Row()+155,oReport:Col()+0690,)
oReport:Box(oReport:Row()+060,oReport:Col()+1000,oReport:Row()+155,oReport:Col()+1000,)
oReport:Box(oReport:Row()-005,oReport:Col()+2210,oReport:Row()+155,oReport:Col()+2210,)
oReport:Box(oReport:Row()+060,oReport:Col()+1210,oReport:Row()+060,oReport:Col()+2210,)
oReport:Box(oReport:Row()+090,oReport:Col()+1210,oReport:Row()+090,oReport:Col()+1625,)
oReport:Box(oReport:Row()+060,oReport:Col()+1625,oReport:Row()+155,oReport:Col()+1625,)
oReport:Box(oReport:Row()+090,oReport:Col()+1375,oReport:Row()+155,oReport:Col()+1375,)
oReport:Box(oReport:Row()-005,oReport:Col()+2415,oReport:Row()+155,oReport:Col()+2415,)
oReport:Box(oReport:Row()-005,oReport:Col()+2620,oReport:Row()+155,oReport:Col()+2620,)
oReport:Box(oReport:Row()+060,oReport:Col()+2620,oReport:Row()+060,oReport:Col()+3040,)
oReport:Box(oReport:Row()+060,oReport:Col()+2825,oReport:Row()+155,oReport:Col()+2825,)
oReport:Box(oReport:Row()-005,oReport:Col()+3040,oReport:Row()+155,oReport:Col()+3040,)
oReport:Box(oReport:Row()-005,oReport:Col()+3245,oReport:Row()+155,oReport:Col()+3245,)
oReport:Box(oReport:Row()-005,oReport:Col()+3465,oReport:Row()+155,oReport:Col()+3465,)
oReport:Box(oReport:Row()-005,oReport:Col()+3700,oReport:Row()+155,oReport:Col()+3700,)
oReport:Box(oReport:Row()-005,oReport:Col()+3940,oReport:Row()+155,oReport:Col()+3940,)
oReport:Box(oReport:Row()-005,oReport:Col()+4120,oReport:Row()+155,oReport:Col()+4120,)
oReport:Box(oReport:Row()+060,oReport:Col()+4120,oReport:Row()+060,oReport:Col()+4850,)
oReport:Box(oReport:Row()+060,oReport:Col()+4295,oReport:Row()+155,oReport:Col()+4295,)
oReport:Box(oReport:Row()+060,oReport:Col()+4400,oReport:Row()+155,oReport:Col()+4400,)
oReport:Box(oReport:Row()+060,oReport:Col()+4500,oReport:Row()+155,oReport:Col()+4500,)

oReport:Box(oReport:Row()+155,oReport:Col()+0215,oReport:Row()+192,oReport:Col()+0215,)
oReport:Box(oReport:Row()+155,oReport:Col()+0425,oReport:Row()+192,oReport:Col()+0425,)
oReport:Box(oReport:Row()+155,oReport:Col()+0610,oReport:Row()+192,oReport:Col()+0610,)
oReport:Box(oReport:Row()+155,oReport:Col()+0690,oReport:Row()+192,oReport:Col()+0690,)
oReport:Box(oReport:Row()+155,oReport:Col()+1000,oReport:Row()+192,oReport:Col()+1000,)
oReport:Box(oReport:Row()+155,oReport:Col()+1210,oReport:Row()+192,oReport:Col()+1210,)
oReport:Box(oReport:Row()+155,oReport:Col()+1375,oReport:Row()+192,oReport:Col()+1375,)
oReport:Box(oReport:Row()+155,oReport:Col()+1625,oReport:Row()+192,oReport:Col()+1625,)
oReport:Box(oReport:Row()+155,oReport:Col()+2210,oReport:Row()+192,oReport:Col()+2210,)
oReport:Box(oReport:Row()+155,oReport:Col()+2415,oReport:Row()+192,oReport:Col()+2415,)
oReport:Box(oReport:Row()+155,oReport:Col()+2620,oReport:Row()+192,oReport:Col()+2620,)
oReport:Box(oReport:Row()+155,oReport:Col()+2825,oReport:Row()+192,oReport:Col()+2825,)
oReport:Box(oReport:Row()+155,oReport:Col()+3040,oReport:Row()+192,oReport:Col()+3040,)
oReport:Box(oReport:Row()+155,oReport:Col()+3245,oReport:Row()+192,oReport:Col()+3245,)
oReport:Box(oReport:Row()+155,oReport:Col()+3465,oReport:Row()+192,oReport:Col()+3465,)
oReport:Box(oReport:Row()+155,oReport:Col()+3700,oReport:Row()+192,oReport:Col()+3700,)
oReport:Box(oReport:Row()+155,oReport:Col()+3940,oReport:Row()+192,oReport:Col()+3940,)
oReport:Box(oReport:Row()+155,oReport:Col()+4120,oReport:Row()+192,oReport:Col()+4120,)
oReport:Box(oReport:Row()+155,oReport:Col()+4295,oReport:Row()+192,oReport:Col()+4295,)
oReport:Box(oReport:Row()+155,oReport:Col()+4400,oReport:Row()+192,oReport:Col()+4400,)
oReport:Box(oReport:Row()+155,oReport:Col()+4500,oReport:Row()+192,oReport:Col()+4500,)

oReport:PrintText(STR0011,oReport:Row(),nCol+0060) //N˙mero
oReport:PrintText(STR0012,oReport:Row(),nCol+0265) //Data de
oReport:PrintText(STR0013,oReport:Row(),nCol+0480) //Data
oReport:PrintText(STR0014,oReport:Row(),nCol+0770) //Comprovante de pago
oReport:PrintText(STR0015,oReport:Row(),nCol+1525) //InformaÁ„o do cliente
oReport:PrintText(STR0016,oReport:Row(),nCol+2280) //Valor
oReport:PrintText(STR0017,oReport:Row(),nCol+2485) //Base
oReport:PrintText(STR0018,oReport:Row(),nCol+2625) //Importe total da operaÁ„o
oReport:PrintText(STR0019,oReport:Row(),nCol+3480) //Outros tributos
oReport:PrintText(STR0020,oReport:Row(),nCol+3770) //Importe
oReport:PrintText(STR0021,oReport:Row(),nCol+4220) //Referencia do comprovante pago
oReport:SkipLine(1)
oReport:PrintText(STR0022,oReport:Row(),nCol+0030) //Correlativo
oReport:PrintText(STR0023,oReport:Row(),nCol+0245) //Emiss„o do
oReport:PrintText(STR0024,oReport:Row(),nCol+0500) //de
oReport:PrintText(STR0025,oReport:Row(),nCol+0830) //O documento
oReport:PrintText(STR0026,oReport:Row(),nCol+2250) //Faturado
oReport:PrintText(STR0027,oReport:Row(),nCol+2450) //Imponible
oReport:PrintText(STR0028,oReport:Row(),nCol+2685) //Exonerada ou Inafecta
oReport:PrintText(STR0029,oReport:Row(),nCol+3495) //e cargos que
oReport:PrintText(STR0030,oReport:Row(),nCol+3785) //Total
oReport:PrintText(STR0031,oReport:Row(),nCol+4005) //Tipo
oReport:PrintText(STR0032,oReport:Row(),nCol+4205) //o documento original que se modifica
oReport:SkipLine(1)
oReport:PrintText(STR0033,oReport:Row(),nCol+0010) //do registro
oReport:PrintText(STR0034,oReport:Row(),nCol+0245) //comprovante
oReport:PrintText(STR0035,oReport:Row(),nCol+0440) //Vencimento
oReport:PrintText(STR0036,oReport:Row(),nCol+0780) //N∫ serie o
oReport:PrintText(STR0037,oReport:Row(),nCol+1265) //Documento de identidade
oReport:PrintText(STR0038,oReport:Row(),nCol+1765) //Nome e sobrenome,
oReport:PrintText(STR0039,oReport:Row(),nCol+2280) //da
oReport:PrintText(STR0039,oReport:Row(),nCol+2480) //da
oReport:PrintText(STR0040,oReport:Row(),nCol+3120) //ISC
oReport:PrintText(STR0041,oReport:Row(),nCol+3270) //IGV e/ou IPM
oReport:PrintText(STR0042,oReport:Row(),nCol+3475) //n„o formam parte
oReport:PrintText(STR0043,oReport:Row(),nCol+3800) //do
oReport:PrintText(STR0024,oReport:Row(),nCol+4020) //de
oReport:PrintText(STR0044,oReport:Row(),nCol+4625) //N∫ do
oReport:SkipLine(1)
oReport:PrintText(STR0045,oReport:Row(),nCol+0020) //codigo unico
oReport:PrintText(STR0046,oReport:Row(),nCol+0275) //de pago
oReport:PrintText(STR0047,oReport:Row(),nCol+0465) //e/ou pago
oReport:PrintText(STR0031,oReport:Row(),nCol+0620) //Tipo
oReport:PrintText(STR0048,oReport:Row(),nCol+0730) //N∫ de serie da
oReport:PrintText(STR0011,oReport:Row(),nCol+1060) //N˙mero
oReport:PrintText(STR0031,oReport:Row(),nCol+1265) //Tipo
oReport:PrintText(STR0011,oReport:Row(),nCol+1450) //N˙mero
oReport:PrintText(STR0049,oReport:Row(),nCol+1820) //denominaÁ„o
oReport:PrintText(STR0050,oReport:Row(),nCol+2240) //exportaÁ„o
oReport:PrintText(STR0051,oReport:Row(),nCol+2450) //operaÁ„o
oReport:PrintText(STR0052,oReport:Row(),nCol+2660) //Exonerada
oReport:PrintText(STR0053,oReport:Row(),nCol+2880) //Inafecta
oReport:PrintText(STR0039,oReport:Row(),nCol+3540) //da
oReport:PrintText(STR0034,oReport:Row(),nCol+3745) //comprovante
oReport:PrintText(STR0054,oReport:Row(),nCol+3990) //cambio
oReport:PrintText(STR0013,oReport:Row(),nCol+4170) //Data
oReport:PrintText(STR0031,oReport:Row(),nCol+4315) //Tipo
oReport:PrintText(STR0055,oReport:Row(),nCol+4415) //serie
oReport:PrintText(STR0034,oReport:Row(),nCol+4590) //comprovante
oReport:SkipLine(1)
oReport:PrintText(STR0056,oReport:Row(),nCol     ) //da operaÁ„o
oReport:PrintText(STR0025,oReport:Row(),nCol+0245) //o documento
oReport:PrintText(STR0057,oReport:Row(),nCol+0710) //maquina registradora
oReport:PrintText(STR0058,oReport:Row(),nCol+1805) //raz„o social
oReport:PrintText(STR0059,oReport:Row(),nCol+2465) //gravada
oReport:PrintText(STR0060,oReport:Row(),nCol+3480) //base imponible
oReport:PrintText(STR0046,oReport:Row(),nCol+3770) //de pago
oReport:PrintText(STR0061,oReport:Row(),nCol+4535) //de pago o documento
oReport:SkipLine(1.2)
oReport:Box(oReport:Row()	,oReport:Col()-0005,oReport:Row(),oReport:Col()+4850,)
aParams[4]++

If nlExpoPa+nlBasePa+nlExonPa+nlInafPa+nlIscPa+nlIgvPa+nlTribPa+nlValCPa > 0
	nLinP := oReport:Row()
	oReport1:ThinLine()
	oReport1:PrintText(STR0066,nLinP,oReport:Col()+1800) // Carrega valores da pagina anterior
	oReport1:PrintText(Transform(nlExpoPa,"@E 999,999,999.99"),nLinP,oReport:Col()+290)  //360
	oReport1:PrintText(Transform(nlBasePa,"@E 999,999,999.99"),nLinP,oReport:Col()+8)   //12
	oReport1:PrintText(Transform(nlExonPa,"@E 999,999,999.99"),nLinP,oReport:Col()+8)   //12
	oReport1:PrintText(Transform(nlInafPa,"@E 999,999,999.99"),nLinP,oReport:Col()+8)   //12
	oReport1:PrintText(Transform(nlIscPa ,"@E 999,999,999.99"),nLinP,oReport:Col()+8)   //17
	oReport1:PrintText(Transform(nlIgvPa ,"@E 999,999,999.99"),nLinP,oReport:Col()+12)   //23
	oReport1:PrintText(Transform(nlTribPa,"@E 999,999,999.99"),nLinP,oReport:Col()+36)
	oReport1:PrintText(Transform(nlValCPa,"@E 999,999,999.99"),nLinP,oReport:Col()+46)
	oReport:SkipLine(1)

	oReport1:Box(oReport:Row()-005	,oReport:Col()-0005,oReport:Row()+030,oReport:Col()-0005)
	oReport1:Box(oReport:Row()-005	,oReport:Col()+0215,oReport:Row()+030,oReport:Col()+0215)
	oReport1:Box(oReport:Row()-005,oReport:Col()+0425,oReport:Row()+030,oReport:Col()+0425)
	oReport1:Box(oReport:Row()-005,oReport:Col()+0610,oReport:Row()+030,oReport:Col()+0610)
	oReport1:Box(oReport:Row()-005,oReport:Col()+0690,oReport:Row()+030,oReport:Col()+0690)
	oReport1:Box(oReport:Row()-005,oReport:Col()+1000,oReport:Row()+030,oReport:Col()+1000)
	oReport1:Box(oReport:Row()-005,oReport:Col()+1210,oReport:Row()+030,oReport:Col()+1210)
	oReport1:Box(oReport:Row()-005,oReport:Col()+1375,oReport:Row()+030,oReport:Col()+1375)
	oReport1:Box(oReport:Row()-005,oReport:Col()+1625,oReport:Row()+030,oReport:Col()+1625)
	oReport1:Box(oReport:Row()-005,oReport:Col()+2210,oReport:Row()+030,oReport:Col()+2210)
	oReport1:Box(oReport:Row()-005,oReport:Col()+2415,oReport:Row()+030,oReport:Col()+2415)
	oReport1:Box(oReport:Row()-005,oReport:Col()+2620,oReport:Row()+030,oReport:Col()+2620)
	oReport1:Box(oReport:Row()-005,oReport:Col()+2825,oReport:Row()+030,oReport:Col()+2825)
	oReport1:Box(oReport:Row()-005,oReport:Col()+3040,oReport:Row()+030,oReport:Col()+3040)
	oReport1:Box(oReport:Row()-005,oReport:Col()+3245,oReport:Row()+030,oReport:Col()+3245)
	oReport1:Box(oReport:Row()-005,oReport:Col()+3465,oReport:Row()+030,oReport:Col()+3465)
	oReport1:Box(oReport:Row()-005,oReport:Col()+3700,oReport:Row()+030,oReport:Col()+3700)
	oReport1:Box(oReport:Row()-005,oReport:Col()+3940,oReport:Row()+030,oReport:Col()+3940)
	oReport1:Box(oReport:Row()-005,oReport:Col()+4120,oReport:Row()+030,oReport:Col()+4120)
	oReport1:Box(oReport:Row()-005,oReport:Col()+4295,oReport:Row()+030,oReport:Col()+4295)
	oReport1:Box(oReport:Row()-005,oReport:Col()+4400,oReport:Row()+030,oReport:Col()+4400)
	oReport1:Box(oReport:Row()-005,oReport:Col()+4500,oReport:Row()+030,oReport:Col()+4500)
	oReport1:Box(oReport:Row()-005	,oReport:Col()+4850,oReport:Row()+030,oReport:Col()+4850)
	oReport:ThinLine()
EndIf

Return

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥FLinR011  ≥ Autor ≥ Rodrigo M. Pontes     ≥ Data | 30/11/09 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥IMPRESSAO DA LINHA                                          ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function FLinR011(oReport,nCol,nlTotReg,nReg,lRet)

If nlTotReg <= nReg - 1
	oReport:SkipLine(1.2)

	If nlTotReg < nReg //- 1

		If lRet
			oReport:Box(oReport:Row()-005,oReport:Col()-0005,oReport:Row()-005,oReport:Col()+4850,)
		Endif

		oReport:Box(oReport:Row()-005,oReport:Col()-0005,oReport:Row()+030,oReport:Col()-0005,)
		oReport:Box(oReport:Row()-005,oReport:Col()+4850,oReport:Row()+030,oReport:Col()+4850,)
		oReport:Box(oReport:Row()-005,oReport:Col()+0215,oReport:Row()+030,oReport:Col()+0215,)
		oReport:Box(oReport:Row()-005,oReport:Col()+0425,oReport:Row()+030,oReport:Col()+0425,)
		oReport:Box(oReport:Row()-005,oReport:Col()+0610,oReport:Row()+030,oReport:Col()+0610,)
		oReport:Box(oReport:Row()-005,oReport:Col()+0690,oReport:Row()+030,oReport:Col()+0690,)
		oReport:Box(oReport:Row()-005,oReport:Col()+1000,oReport:Row()+030,oReport:Col()+1000,)
		oReport:Box(oReport:Row()-005,oReport:Col()+1210,oReport:Row()+030,oReport:Col()+1210,)
		oReport:Box(oReport:Row()-005,oReport:Col()+1375,oReport:Row()+030,oReport:Col()+1375,)
		oReport:Box(oReport:Row()-005,oReport:Col()+1625,oReport:Row()+030,oReport:Col()+1625,)
		oReport:Box(oReport:Row()-005,oReport:Col()+2210,oReport:Row()+030,oReport:Col()+2210,)
		oReport:Box(oReport:Row()-005,oReport:Col()+2415,oReport:Row()+030,oReport:Col()+2415,)
		oReport:Box(oReport:Row()-005,oReport:Col()+2620,oReport:Row()+030,oReport:Col()+2620,)
		oReport:Box(oReport:Row()-005,oReport:Col()+2825,oReport:Row()+030,oReport:Col()+2825,)
		oReport:Box(oReport:Row()-005,oReport:Col()+3040,oReport:Row()+030,oReport:Col()+3040,)
		oReport:Box(oReport:Row()-005,oReport:Col()+3245,oReport:Row()+030,oReport:Col()+3245,)
		oReport:Box(oReport:Row()-005,oReport:Col()+3465,oReport:Row()+030,oReport:Col()+3465,)
		oReport:Box(oReport:Row()-005,oReport:Col()+3700,oReport:Row()+030,oReport:Col()+3700,)
		oReport:Box(oReport:Row()-005,oReport:Col()+3940,oReport:Row()+030,oReport:Col()+3940,)
		oReport:Box(oReport:Row()-005,oReport:Col()+4120,oReport:Row()+030,oReport:Col()+4120,)
		oReport:Box(oReport:Row()-005,oReport:Col()+4295,oReport:Row()+030,oReport:Col()+4295,)
		oReport:Box(oReport:Row()-005,oReport:Col()+4400,oReport:Row()+030,oReport:Col()+4400,)
		oReport:Box(oReport:Row()-005,oReport:Col()+4500,oReport:Row()+030,oReport:Col()+4500,)

	Elseif nlTotReg == nReg - 1
		oReport:Box(oReport:Row()-005,oReport:Col()-0005,oReport:Row()+030,oReport:Col()-0005,)
		oReport:Box(oReport:Row()-005,oReport:Col()+0215,oReport:Row()+030,oReport:Col()+0215,)
		oReport:Box(oReport:Row()-005,oReport:Col()+0425,oReport:Row()+030,oReport:Col()+0425,)
		oReport:Box(oReport:Row()-005,oReport:Col()+0610,oReport:Row()+030,oReport:Col()+0610,)
		oReport:Box(oReport:Row()-005,oReport:Col()+0690,oReport:Row()+030,oReport:Col()+0690,)
		oReport:Box(oReport:Row()-005,oReport:Col()+1000,oReport:Row()+030,oReport:Col()+1000,)
		oReport:Box(oReport:Row()-005,oReport:Col()+1210,oReport:Row()+030,oReport:Col()+1210,)
		oReport:Box(oReport:Row()-005,oReport:Col()+1375,oReport:Row()+030,oReport:Col()+1375,)
		oReport:Box(oReport:Row()-005,oReport:Col()+1625,oReport:Row()+030,oReport:Col()+1625,)
		oReport:Box(oReport:Row()-005,oReport:Col()+2210,oReport:Row()+030,oReport:Col()+2210,)
		oReport:Box(oReport:Row()-005,oReport:Col()+2415,oReport:Row()+030,oReport:Col()+2415,)
		oReport:Box(oReport:Row()-005,oReport:Col()+2620,oReport:Row()+030,oReport:Col()+2620,)
		oReport:Box(oReport:Row()-005,oReport:Col()+2825,oReport:Row()+030,oReport:Col()+2825,)
		oReport:Box(oReport:Row()-005,oReport:Col()+3040,oReport:Row()+030,oReport:Col()+3040,)
		oReport:Box(oReport:Row()-005,oReport:Col()+3245,oReport:Row()+030,oReport:Col()+3245,)
		oReport:Box(oReport:Row()-005,oReport:Col()+3465,oReport:Row()+030,oReport:Col()+3465,)
		oReport:Box(oReport:Row()-005,oReport:Col()+3700,oReport:Row()+030,oReport:Col()+3700,)
		oReport:Box(oReport:Row()-005,oReport:Col()+3940,oReport:Row()+030,oReport:Col()+3940,)
		oReport:Box(oReport:Row()-005,oReport:Col()+4120,oReport:Row()+030,oReport:Col()+4120,)
		oReport:Box(oReport:Row()-005,oReport:Col()+4295,oReport:Row()+030,oReport:Col()+4295,)
		oReport:Box(oReport:Row()-005,oReport:Col()+4400,oReport:Row()+030,oReport:Col()+4400,)
		oReport:Box(oReport:Row()-005,oReport:Col()+4500,oReport:Row()+030,oReport:Col()+4500,)
		oReport:Box(oReport:Row()-005	,oReport:Col()+4850,oReport:Row()+030,oReport:Col()+4850,)

	Endif
Endif

Return

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒø±±
±±≥ Funcao     ≥ GerArq   ≥ Autor ≥ Ivan Haponczuk      ≥ Data ≥ 15.03.2012 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Descricao  ≥ Gera o arquivo magnÈtico do livro de venda.                ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
User Function GerArq(aFiliais, aParams, cEmpresa, cFil, lEnd)
Local nHdl         := 0
Local nSinal       := 0
Local nlF3Bas      := 0
Local cLin         := ""
Local cSep         := "|"
Local cTipDoc      := ""
Local cSerie       := ""
Local cSerFre      := ""
Local cNumDoc      := ""
Local cOriser      := ""
Local dEmiss       := CtoD(Space(08))
Local cAliasPer    := ''
Local cAliasTrib   := ''
Local nCont        := 0
Local nT           := 1
Local nInd         := 0
Local nValorC      := 0
Local nTot1        := 1
Local nReg         := 0
Local lRet         := .T.
Local cDir         := ''
Local lCpDoc       := .F.
Local lSer3        := .F.
Local lSerie2      := .F.
Local lSerOri      := .F.
Local lCodSF1      := .F.
Local lCodSF2      := .F.
Local lSerie2SFP   := .F.
Local cArq         := ''
Local cNfefin := ""
Local cTipoDoc_Anu := ""		// add por SISTHEL - 13/07/2018
Local cFilSD1 := xFilial("SD1")
Local cFilSF1 := xFilial("SF1")
Local cFilSFP := xFilial("SFP")
Local cFilSD2 := xFilial("SD2")
Local cFilSF2 := xFilial("SF2")
Local aInfAnul := {}

Default cEmpresa   := cEmpAnt
Default cFil       := cFilAnt
Default lEnd       := .F.

Private cPosCpo   := IIf(cVersao=="11", "FieldPos", "ColumnPos")

// ----------------------------------------
// TRATA LOG DE PROCESSAMENTO
// ----------------------------------------
ConOut('[DS2U]' + Repl('-', 50))
ConOut('INICIO DO PROCESSAMENTO: ' + Time())
ConOut(Repl('-', 50))
ConOut('PARAMETROS:')
ConOut('DATA INICIAL      : ' + DtoC(aParams[1]))
ConOut('DATA FINAL        : ' + DtoC(aParams[2]))
ConOut('IMPRIME PAGINAS   : ' + AllTrim(Str(aParams[3])))
ConOut('No PAGINA INICIAL : ' + AllTrim(Str(aParams[4])))
ConOut('SELECIONA FILIAIS : ' + AllTrim(Str(aParams[5])))
ConOut('GERAR             : ' + If(aParams[6] == 1, 'RELATORIO', If(aParams[6] == 2, 'ARQUIVO', 'AMBOS')))
ConOut('DIRETORIO         : ' + AllTrim(aParams[7]))
ConOut(Repl('-', 50))

// -------------------------------------
// PREPARA ENVIRONMENT, QDO MULTI-THREAD
// -------------------------------------
/*
If aParams[6] == 3
	ConOut('[DS2U]' + Repl('-', 50))
	ConOut('SUBINDO PROCESSO MULTI-THREAD')
	ConOut(Repl('-', 50))

	RpcSetType(3)
	RpcSetEnv(cEmpresa, cFil,,, 'FIS')

	VarSetX('ZFISR011', 'cStatusPrc', '1')
EndIf
*/

// -----------------------------------------
// PROCESSA A QUERY PRINCIPAL
// -----------------------------------------
cAliasPer  := FISR011Qry(aFiliais, aParams, .F. /*aParams[6] == 3*/)


// ---------------------------------------------
// PROCESSA ARQUIVO TEMPORARIO - OUTROS TRIBUTOS
// ---------------------------------------------
cAliasTrib := FISR011Trib(aFiliais, aParams)


// ---------------------------------------
// TRATA DICIONARIO DE DADOS
// ---------------------------------------
lCpDoc     := SF3->(FieldPos("F3_TPDOC")) > 0
lSer3      := SFP->(FieldPos("FP_YSERIE")) > 0 //-- Impresion de la serie 2 (factura electrocnica - Peru)
lSerie2    := SF1->(FieldPos("F1_SERIE2")) > 0 .And. SF2->(FieldPos("F2_SERIE2")) > 0 .And. SF3->(FieldPos("F3_SERIE2")) > 0 .And. GetNewPar("MV_LSERIE2", .F.)
lSerOri    := SF1->(FieldPos("F1_SERORI")) > 0 .And. SF2->(FieldPos("F2_SERORI")) > 0 .And. SF3->(FieldPos("F3_SERORI")) > 0
lSerie2SFP := SFP->(FieldPos("FP_SERIE2"))>0

If SF1->&(cPosCpo + '("F1_TPDOC")') > 0
	lCodSf1:=.T.	
EndIf

If SF2->&(cPosCpo + '("F2_TPDOC")') > 0
	lCodSf2:=.T.	
Endif


// -----------------------------------------
// TRATA NOME DO ARQUIVO
// -----------------------------------------
cArq := ''
cArq += "LE"									//-- Fixo  'LE'
cArq +=  AllTrim(SM0->M0_CGC)					//-- Ruc
cArq +=  AllTrim(Str(Year(aParams[2])))		//-- Ano
cArq +=  AllTrim(Strzero(Month(aParams[2]),2))	//-- Mes
cArq +=  "00"									//-- Fixo '00'
cArq += "140100"								//-- Fixo '140100'
cArq += "00"									//-- Fixo '00'
cArq += "1"
cArq += If((cAliasPer)->(!Eof()), '1', '0')
cArq += "1"
cArq += "1"
cArq += ".TXT" // Extensao

/*
If aParams[6] == 3
	VarSetX('ZFISR011', 'cArq', cArq)
ElseIf aParams[6] == 2
	cPath := allTrim( getNewpar( "ES_PZFIS11","\data\") ) // Diretorio no servidor que sera utilizado para criar o arquivo
EndIf
*/

//cPath := allTrim( getNewpar( "MV_PZFIS11","\data\") ) // Diretorio no servidor que sera utilizado para criar o arquivo

if aParams[6] == 2
	cPath := AllTrim(aParams[7]) + If(Right(AllTrim(aParams[7]), 1) == '\', '', '\')
endif
	
// -------------------------------------------
// PROCESSA GERACAO DO ARQUIVO
// -------------------------------------------
nHdl := fCreate(cPath + cArq,NIL,NIL,.F.)
If nHdl <= 0
	ConOut(Repl('-', 50))
	ConOut('NAO FOI POSSIVEL CRIAR ARQUIVO TEXTO')
	ConOut(cPath + cArq)
	ConOut('CODIGO DO ERRO: ' + AllTrim(Str(fError())))
	ConOut(Repl('-', 50))
	lRet := .F.

Else
	ConOut("[SISTHEL] ----------------------------")
	ConOut("[SISTHEL]" + cPath + cArq)
	ConOut("[SISTHEL] ----------------------------")
	(cAliasPer)->(DBEval({|| nReg++}, {|| .T.}, {|| !Eof()}))
	(cAliasPer)->(DbGoTop())

	ProcRegua(nReg)
	Do While (cAliasPer)->(!EOF())
		cFil         := (cAliasPer)->F3_FILIAL
		cNFiscal     := (cAliasPer)->F3_NFISCAL
	    cSerie       := (cAliasPer)->F3_SERIE
	    cClifor      := (cAliasPer)->F3_CLIEFOR
	    cLoja        := (cAliasPer)->F3_LOJA
	    cEspecie     := (cAliasPer)->F3_ESPECIE
	    nValcont     := (cAliasPer)->F3_VALCONT
	    nTxMoeda     := (cAliasPer)->F2_TXMOEDA
	    nExporta     := (cAliasPer)->EXPORTACAO
	    nExonera     := (cAliasPer)->EXONERADA
	    nInafecta    := (cAliasPer)->INAFECTA
	    nValimp2     := (cAliasPer)->F3_VALIMP2
	    nValimp1     := (cAliasPer)->F3_VALIMP1
	    cNome        := (cAliasPer)->A1_NOME
	    cCGC         := (cAliasPer)->A1_CGC
	    cPessFis     := (cAliasPer)->A1_PFISICA
	    cTipoDoc     := (cAliasPer)->A1_TIPDOC
	    cCodGov      := (cAliasPer)->CCL_CODGOV
	    dEmissao     := (cAliasPer)->F3_EMISSAO
	    dVenctoRe    := (cAliasPer)->E1_VENCREA
	    nBase1       := (cAliasPer)->F3_BASIMP1
	    nBase2       := (cAliasPer)->F3_BASIMP2
	    nMoeda       := (cAliasPer)->F2_MOEDA
    	cTipoDoc_Anu := If(lCpDoc, (cAliasPer)->F3_TPDOC, '')
	    cSer2        := (cAliasPer)->F3_SERIE2
	    cSerOri      := (cAliasPer)->F3_SERORI
	    nValorC      := (cAliasPer)->F3_VALCONT
	    //nOutTributos := (cAliasPer)->F3_OUTRAS
		cCorrela     := If(Empty((cAliasPer)->F2_NODIA), BuscaCorre(cFil,cNFiscal,cSerie,cClifor,cLoja,dEmissao,cEspecie), (cAliasPer)->F2_NODIA)

		(cAliasPer)->(DbSkip())

		IncProc()

		If lEnd
			Exit
		EndIf

	    lImprime:=.T.
	    If cFil == (cAliasPer)->F3_FILIAL .And. cNFiscal == (cAliasPer)->F3_NFISCAL .And. cSerie == (cAliasPer)->F3_SERIE .And.;
	    	cClifor == (cAliasPer)->F3_CLIEFOR .And. cLoja == (cAliasPer)->F3_LOJA .And. cEspecie == (cAliasPer)->F3_ESPECIE .And. (cAliasPer)->(!Eof())
			lImprime:=.F.
	    EndIf

		If lImprime
			nSinal := Iif(("NC"$cEspecie .OR. cCodGov=='25' ),-1,1)
			cLin   := ""

			//01 - Periodo
			cLin += SubStr(DTOS(dEmissao),1,6)+"00"
			cLin += cSep


			//02 - Num correlativo
			cLin += AllTrim(cCorrela)
			cLin += cSep

			//03 - Numero correlativo del registro
			//cLin += "M"+StrZero(++nInd,9)
			//cLin += cSep
			
			If Alltrim(cEspecie) $ "NDP|NDE|NCI|NCC"
				SF1->( DbSetOrder(1) ) //F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA
					If SF1->( MsSeek(cFil+cNFiscal+cSerie+cClifor+cLoja) )
					if !empty(SF1->F1_NODIA)
		    	        cLin += "M"+getLinCT2(AllTrim(SF1->F1_NODIA),SF1->F1_VALBRUT,SF1->F1_MOEDA,.T.,cFil)
		   			else
		   				cLin += space(10)
		   			endif
				else
		   			aInfAnul := xBusNFAnul(cFil,cNFiscal,cSerie,cClifor,cLoja,.F.)
		   			if len(aInfAnul) > 0
			   			cLin += "M"+getLinCT2(AllTrim(aInfAnul[1]),aInfAnul[2],aInfAnul[3],.T.,cFil)
			   		else
			   			cLin += space(10)
			   		endif
				endif
			else
				IF ALLTRIM( cCGC) <> 'Anulado'
			        SF2->( DbSetOrder(1) ) //F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_FORMUL, F2_TIPO
						If SF2->( MsSeek(cFil+cNFiscal+cSerie+cClifor+cLoja) )
						//if !empty(SF2->F2_NODIA)
						if !empty(cCorrela)
			    	        //cLin += "M"+getLinCT2(AllTrim(SF2->F2_NODIA),SF2->F2_VALBRUT,SF2->F2_MOEDA,.f.)
			    	        cLin += "M"+getLinCT2(AllTrim(cCorrela),SF2->F2_VALBRUT,SF2->F2_MOEDA,.f.,cFil)
			   			else
			   				cLin += space(10)
			   			endif
		   			else
		   				cLin += space(10)
		   			endif
		   		else
		   			aInfAnul := xBusNFAnul(cFil,cNFiscal,cSerie,cClifor,cLoja,.T.)
		   			if len(aInfAnul) > 0
			   			cLin += "M"+getLinCT2(AllTrim(aInfAnul[1]),aInfAnul[2],aInfAnul[3],.f.,cFil)
			   		else
			   			cLin += space(10)
			   		endif
		   		endif
		   	endif
			cLin += cSep

			//04 - Fecha de emisiÛn del Comprobante de Pago
			cLin += SubStr(DTOC(dEmissao),1,6)+SubStr(DTOS(dEmissao),1,4)
			cLin += cSep

			//05 - Fecha de Vencimiento o Fecha de Pago (1)
			// AlteraÁ„o realizada em 08/02/13 para atender OAS - Regiane
			// Para NFs canceladas o campo 5 - tipo de documento = "00", sendo assim, este campo n„o È obrigatÛrio
			//cLin += SubStr(DTOC((cAliasPer)->E1_VENCREA),1,6)+SubStr(DTOS((cAliasPer)->E1_VENCREA),1,4)
			cTpDoc := cTipoDoc_Anu
			if empty(cTpDoc)
			If Alltrim(cEspecie) $ "NDP|NDE|NCI|NCC"
				SF1->(DbSetOrder(1))
				If SF1->(dbSeek(xFilial("SF1")+cNFiscal+cSerie+cClifor+cLoja))
					cTpDoc := AllTrim(SF1->F1_TPDOC)
				Else
					// ------------------------------------------------------------------------- //
					// add por SISTHEL - 13/07/2018
					// El campo F3_TPDOC puede no existir en alguns antornos, el problema que
					// mismo existiendo este campo llega en blanco.
					// ------------------------------------------------------------------------- //
					if empty(cTipoDoc_Anu)
							cTpDoc := xNCCAnul(cFil,cNFiscal,cSerie,cClifor,cLoja)
					else
					    cTpDoc := AllTrim(cTipoDoc_Anu)
					endif
				EndIf
			Else
	           IF ! EMPTY(cCodGov)
	 	          cTpDoc := cCodGov
	    		   ELSE
		              cTpDoc:=BuscaTpDoc(cFil,cNFiscal,cSerie,cClifor,cLoja)
				   ENDIF
				ENDIF
			endif
			
			If AllTrim(cTpDoc) == "14" .AND. ALLTRIM(cCGC) <> 'Anulado'
				If !Empty(AllTrim(cCodGov)) .AND. ! EMPTY(dVenctoRe)
					cLin += SubStr(DTOC(dVenctoRe),1,6)+SubStr(DTOS(dVenctoRe),1,4)
				Else
					cLin += "01/01/0001"
				EndIf
			Else
		        cLin += "01/01/0001"
			EndIf
			cLin += cSep

			//06 Tipo de Comprobante de Pago o Documento tabela 10
			// ----------------------------------------------------------------------------------- //
			// Adicionado por SISTHEL para impresion de la serie 2 ( factura electrocnica - Peru ) //
			// ----------------------------------------------------------------------------------- //
			cSerieNf := Alltrim(Iif(lSerOri .and. !Empty(cSerOri),RetNewSer(cSerOri),Iif(lSerie2 .and. Empty(cSerie),RetNewSer(cSer2),RetNewSer(cSerie)) ))
			cSerieNf := Padr(cSerieNf,TamSx3("FP_SERIE")[1])
			cLin += AllTrim(cTpDoc)
			cLin += cSep

			//07 N˙mero serie del comprobante de pago o documento o n˙mero de serie de la maquina registradora
			nT := Len(cSerieNf)+1

			// ----------------------------------------------------------------------------------- //
			// Adicionado por SISTHEL para impresion de la serie 2 ( factura electrocnica - Peru ) //
			// ----------------------------------------------------------------------------------- //
			if empty(cSer2)
				lTemSFP := .f.
				SFP->( dbSetOrder(5) )	//FP_FILIAL, FP_FILUSO, FP_SERIE, FP_ESPECIE, R_E_C_N_O_, D_E_L_E_T_
				If SFP->( dbSeek( xFilial("SFP")+cFil+cSerieNf+"1" ) )
					If lSer3 .And. !Empty(SFP->FP_YSERIE)
						cSerieNf := Alltrim(SFP->FP_YSERIE)
						lTemSFP := .t.
					else
						if lSerie2SFP
							if !empty(SFP->FP_SERIE2)
								cSerieNf := Alltrim(SFP->FP_SERIE2)
								lTemSFP := .t.
							endif
						endif
					endif
				endif
	
				if !lTemSFP
					If SFP->( dbSeek( xFilial("SFP")+cFil+cSerieNf+"6" ) )
						If lSer3 .And. !Empty(SFP->FP_YSERIE)
							cSerieNf := Alltrim(SFP->FP_YSERIE)
							lTemSFP := .t.
						else
							if lSerie2SFP
								if !empty(SFP->FP_SERIE2)
									cSerieNf := Alltrim(SFP->FP_SERIE2)
									lTemSFP := .t.
								endif
							endif
						endif
					endif
				EndIf

			if !lTemSFP
				If SFP->( dbSeek( xFilial("SFP")+cFil+cSerieNf+"3" ) )
					If lSer3 .And. !Empty(SFP->FP_YSERIE)
						cSerieNf := Alltrim(SFP->FP_YSERIE)
						lTemSFP := .t.
						else
							if lSerie2SFP
								if !empty(SFP->FP_SERIE2)
									cSerieNf := Alltrim(SFP->FP_SERIE2)
									lTemSFP := .t.
								endif
							endif
						endif
					endif
				EndIf

			if !lTemSFP
				If SFP->( dbSeek( xFilial("SFP")+cFil+cSerieNf+"2" ) )
					If lSer3 .And. !Empty(SFP->FP_YSERIE)
						cSerieNf := Alltrim(SFP->FP_YSERIE)
						lTemSFP := .t.
						else
							if lSerie2SFP
								if !empty(SFP->FP_SERIE2)
									cSerieNf := Alltrim(SFP->FP_SERIE2)
									lTemSFP := .t.
								endif
							endif
						endif
					endif
				EndIf
			endif
	
			If Len(cSerieNf)<=3 .and. empty(cSer2)
				cSerieNf := Replicate("0",4-Len(cSerieNf))+cSerieNf
			elseIf Len(cSerieNf)==3 .and. !empty(cSer2)
				cSerieNf := cSer2
			else
				if !lTemSFP
					cSerieNf := cSer2
				endif
			EndIf
			// -------------------------------------------------------------------------[ Fim ]-- //

			If !lSer3
				If !Empty(cSer2) .And. Subs(cSer2,1,1) $ "B|E|F"
					cSerieNf := Alltrim(cSer2)
				Else
					cSerieNf := AllTrim(RetNewSer(cSerie))
				EndIf

				If LEN(cSerieNf)<=3
					cSerieNf := Replicate("0",4-Len(cSerieNf))+cSerieNf
				EndIf
			EndIf

			If AllTrim(cTpDoc)=='05'
				cLin +=  "4"
			Else
				cLin += AllTrim(cSerieNf)
			EndIf

			cLin += cSep

			//08 N˙mero del comprobante de pago o documento.
			cLin += Right(AllTrim(cNFiscal),8)
			cLin += cSep

			//09   1. Para efectos del registro de tickets o cintas emitidos por m·quinas registradoras que no otorguen
			//			derecho a crÈdito fiscal de acuerdo a las normas de Comprobantes de Pago y opten por anotar el importe total
			//			de las operaciones realizadas por dÌa y por m·quina registradora, registrar el n˙mero final (2).
			//		2. Se permite la consolidaciÛn diaria de las Boletas de Venta emitidas de manera electrÛnica
			// 			AlteraÁ„o realizada em 08/02/13 para atender OAS - Regiane
			//			Peru trabalha de forma analitica n„o consolidada por isto registrar "0"
			If AllTrim(cTpDoc) == "03" .and. nValcont >= 700.00
				cLin += Right(AllTrim(cNFiscal),8)
			Else
				cLin += ""
			EndIf
			cLin += cSep

			//10 Tipo de Documento de Identidad del cliente
			If ALLTRIM(cCGC)=='Anulado'
				cLin += "0"
			Else
				cLin += IIF(!Empty(AllTrim(cTipoDoc)),strzero(Val(cTipoDoc),1),"0")
			EndIf
			cLin += cSep

			//11 - N˙mero de Documento de Identidad del cliente
			if alltrim(cTipoDoc)$"6/06"
				cLin += IIF(!Empty(AllTrim( cCGC)),AllTrim( cCGC),"1")
			ELSE
			    cLin += IIF(!Empty(AllTrim(cPessFis)),AllTrim(cPessFis),"1")
			ENDIF
			cLin += cSep


			//12 Apellidos y nombres, denominaciÛn o razÛn social  del cliente.
			If AllTrim(cTpDoc) $ "00|05|06|07|08|11|12|13|14|15|16|18|19|23|26|28|30|34|35|36|37|55|56|87|88";
				.Or. ALLTRIM( cCGC)=='Anulado';
				.Or. (AllTrim(StrTran(Transform( nExporta* nSinal,"@E 999999999.99"),",",".")) > AllTrim(StrTran(Transform(0 * nSinal,"@E 999999999.99"),",",".")));
				.Or. (AllTrim(StrTran(Transform( nValcont* nSinal,"@E 999999999.99"),",",".")) < AllTrim(StrTran(Transform(0 * nSinal,"@E 999999999.99"),",",".")) .And. AllTrim(cTpDoc)$ "03|12");
				.Or. (AllTrim(cTpDoc)) <> ""

				cLin += AllTrim(cNome)

			Else
				cLin += ""
			EndIF
			cLin += cSep

			//13 Valor facturado de la exportaciÛn
  			cLin += AllTrim(StrTran(Transform( nExporta* nSinal,"@E 999999999.99"),",","."))
			cLin += cSep
			
			if alltrim(cNFiscal)=="00000014"
				x:=1
			endif

			If  nBase1 > 0 .And.  nBase2 = 0
				nlF3Bas :=  nBase1 * nSinal
			ElseIf  nBase1 = 0 .And.  nBase2 > 0
				nlF3Bas := nBase2 * nSinal
			ElseIf  nBase1 > 0 .And.  nBase2 > 0
				nlF3Bas := ( nBase1 - nBase2) * nSinal
			Else
				nlF3Bas := 0
			EndIf

			//14 Base imponible de la operaciÛn gravada (4)
			dEmiss  := CTOD("  /  /  ")   			    

			If alltrim(cTpDoc)$"07" 
				dbSelectArea("SD1")
				SD1->(dbSetOrder(1))
				If SD1->(dbSeek(xFilial("SD1")+cNFiscal+cSerie+cClifor+cLoja))
					SF2->(dbSelectArea("SF2"))
					SF2->(dbSetOrder(1))
					If SF2->(dbSeek(xFilial("SF2")+AvKey(SD1->D1_NFORI,"F2_DOC")+AvKey(SD1->D1_SERIORI,"F2_SERIE")+AvKey(SD1->D1_FORNECE,"D2_CLIENTE")+AvKey(SD1->D1_LOJA,"D2_LOJA")))
						dEmiss  := SF2->F2_EMISSAO
			        EndIf
			     EndIf
			
				If DtoS(dEmiss)<DtoS(aParams[1])
					cLin += ""
					cLin += cSep
				Else
					cLin += AllTrim(StrTran(Transform(nlF3Bas,"@E 999999999.99"),",","."))
					cLin += cSep					
				EndIf
			 
			Else
				cLin += AllTrim(StrTran(Transform(nlF3Bas,"@E 999999999.99"),",","."))
				cLin += cSep									
			EndIF		           
			
			//15 Descuento de la Base Imponible
			If alltrim(cTpDoc)$"07"
				dbSelectArea("SD1")
				SD1->(dbSetOrder(1))
				If SD1->(dbSeek(xFilial("SD1")+cNFiscal+cSerie+cClifor+cLoja))
					SF2->(dbSelectArea("SF2"))
					SF2->(dbSetOrder(1))
					If SF2->(dbSeek(xFilial("SF2")+AvKey(SD1->D1_NFORI,"F2_DOC")+AvKey(SD1->D1_SERIORI,"F2_SERIE")+AvKey(SD1->D1_FORNECE,"D2_CLIENTE")+AvKey(SD1->D1_LOJA,"D2_LOJA")))
						dEmiss  := SF2->F2_EMISSAO
			        EndIf
			     EndIf
			     				
				If DtoS(dEmiss)>=DtoS(aParams[1])
					cLin += ""
					cLin += cSep
				Else
					cLin += AllTrim(StrTran(Transform(nlF3Bas,"@E 999999999.99"),",","."))
					cLin += cSep					
				EndIf
			Else
				cLin += ""
				cLin += cSep									
			EndIf									
				
			//16 Impuesto General a las Ventas y/o Impuesto de PromociÛn Municipal
			If alltrim(cTpDoc)$"07"
				If DtoS(dEmiss)<DtoS(aParams[1])				
					cLin += ""
					cLin += cSep	
				Else
					cLin += AllTrim(StrTran(Transform(nValimp1*nSinal,"@E 999999999.99"),",","."))
					cLin += cSep	
				EndIF					
			Else
				cLin += AllTrim(StrTran(Transform(nValimp1*nSinal,"@E 999999999.99"),",","."))
				cLin += cSep					
			EndIf										

			//17 Descuento del Impuesto General a las Ventas y/o Impuesto de PromociÛn Municipal
			If alltrim(cTpDoc)$"07"
				If DtoS(dEmiss)>=DtoS(aParams[1])				
					cLin += ""
					cLin += cSep	
				Else
					cLin += AllTrim(StrTran(Transform(nValimp1*nSinal,"@E 999999999.99"),",","."))
					cLin += cSep	
				EndIF					
			Else
				cLin += ""
				cLin += cSep					
			EndIf
				
			//18 Importe total de la operaciÛn exonerada
			if abs(nlF3Bas) >0
				cLin += AllTrim(StrTran(Transform(0,"@E 999999999.99"),",","."))
			else
				cLin += AllTrim(StrTran(Transform(nExonera*nSinal,"@E 999999999.99"),",","."))
			endif
			cLin += cSep
				
			//19 Importe total de la operaciÛn inafecta 
			if alltrim(Posicione("SA1",1,xFilial("SA1")+cClifor+cLoja,"SA1->A1_EST"))=="EX" 
				cLin += "0.00"
			Else	
				cLin += AllTrim(StrTran(Transform(nInafecta*nSinal,"@E 999999999.99"),",","."))
			EndIf
			cLin += cSep

			//20 Impuesto Selectivo al Consumo, de ser el caso.
			cLin += AllTrim(StrTran(Transform(nValimp2*nSinal,"@E 999999999.99"),",","."))
			cLin += cSep

			//21 Base imponible de la operaciÛn gravada con el Impuesto a las Ventas del Arroz Pilado
			cLin += ""
			cLin += cSep

			//22 Impuesto a las Ventas del Arroz Pilado
			cLin += ""
			cLin += cSep

			//23 Impuesto a las bolsas de plastico
			cLin += "0.00"
			cLin += cSep

			//24 - Otros conceptos, tributos y cargos que no forman parte de la base imponible
			if (nExonera*nSinal) <= 0 .And. ALLTRIM(cCGC) <> 'Anulado'
				(cAliasTrib)->(DbSetOrder(1))
				If (cAliasTrib)->(DbSeek(cNFiscal+cSerie+cClifor+cLoja))
					cLin += AllTrim(StrTran(Transform((cAliasTrib)->TRIBUTO,"@E 999999999.99"),",","."))
				Else
					cLin += "0.00"
				Endif
			else
				cLin += "0.00"
			endif
			
			//cLin += AllTrim(StrTran(Transform(nOutTributos,"@E 999999999.99"),",","."))
			cLin += cSep

			//25 - Importe total del comprobante de pago
			//cLin += AllTrim(StrTran(Transform( nValorC * nSinal,"@E 999999999.99"),",","."))
			if ALLTRIM(cCGC) <> 'Anulado'
				//nvtot := fValTotal(cFil,cNFiscal,cSerie,cClifor,cLoja)
				//if nvtot >0 
				//	cLin += AllTrim(StrTran(Transform( nvtot * nSinal,"@E 999999999.99"),",","."))
				//else
					cLin += AllTrim(StrTran(Transform( nValorC * nSinal,"@E 999999999.99"),",","."))
				//endif
			else
				cLin += "0.00"
			endif
			cLin += cSep

			// Tratamento para as notas "NDC|NCE|NCP|NDI"
			cSerFre := cSerie
			cTipDoc := ""
			cNumDoc := ""
			cOriser := ""
			dEmiss  := CTOD("  /  /  ")

			If Alltrim(cEspecie) $ "NDC|NCE|NCP|NDI"
					dbSelectArea("SD2")
					SD2->(dbSetOrder(3)) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
					If SD2->(dbSeek(cFil+cNFiscal+cSerie+cClifor+cLoja))   
					  If Len(Trim(SD2->D2_NFORI)) > 0
					    dbSelectArea("SF2")      
					    SF2->(DbSetOrder(1)) //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
                        //If SF2->(dbSeek(xFilial("SF2")+AvKey(cNFiscal,"F2_DOC")+AvKey(cSerie,"F2_SERIE")+AvKey(cClifor,"F2_CLIENTE")+AvKey(cLoja,"D2_LOJA")))
                        If SF2->(dbSeek(cFil+AvKey(SD2->D2_NFORI,"F2_DOC")+AvKey(SD2->D2_SERIORI,"F2_SERIE")+AvKey(SD2->D2_CLIENTE,"F2_CLIENTE")+AvKey(SD2->D2_LOJA,"D2_LOJA")))
							dEmiss  := SF2->F2_EMISSAO
							cTipDoc := SF2->F2_TPDOC
						EndIf
						Do While SD2->(!Eof()) .And. ALLTRIM(SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA) == ALLTRIM(cNFiscal+cSerie+cClifor+cLoja)
							If !Empty(SD2->D2_NFORI+SD2->D2_SERIORI)
								cOriSer  := SD2->D2_SERIORI
								cNumDoc := SD2->D2_NFORI
								exit
							Endif
							SD2->(DbSkip())
						EndDo
					  EndIf
					EndIf	

			ElseIf Alltrim(cEspecie) $ "NDP|NDE|NCI|NCC"
				
				dbSelectArea("SD1")
				SD1->(dbSetOrder(1)) //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
				//If SD1->(dbSeek(xFilial("SD1")+cNFiscal+cSerie+cClifor+cLoja))
				If SD1->(dbSeek(cFil+cNFiscal+cSerie+cClifor+cLoja))
					SF2->(dbSelectArea("SF2"))
					SF2->(dbSetOrder(1)) //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
					//If SF2->( dbSeek( xFilial("SF2")+SD1->D1_NFORI+SD1->D1_SERIORI+SD1->D1_FORNECE+SD1->D1_LOJA ) )
					If SF2->( dbSeek( cFil+SD1->D1_NFORI+SD1->D1_SERIORI+SD1->D1_FORNECE+SD1->D1_LOJA ) )
						dEmiss  := SF2->F2_EMISSAO
						cTipDoc := SF2->F2_TPDOC
						SFP->( dbSetOrder(5) )	//FP_FILIAL, FP_FILUSO, FP_SERIE, FP_ESPECIE, R_E_C_N_O_, D_E_L_E_T_
						If SFP->( dbSeek( xFilial("SFP")+cFil+SD1->D1_SERIORI+"1" ) )
							If lSer3 .And. !Empty(SFP->FP_YSERIE)
								If Len( Alltrim(SFP->FP_YSERIE) ) > 4
									cTipDoc := "12"
								EndIf
							EndIf
						Else
							If SFP->( dbSeek( xFilial("SFP")+cFil+SD1->D1_SERIORI+"6" ) )
								If lSer3 .And. !Empty(SFP->FP_YSERIE)
									If Len( Alltrim(SFP->FP_YSERIE) ) > 4
										cTipDoc := "12"
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
					Do While SD1->(!Eof()) .And. ALLTRIM(SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA) == ALLTRIM(cNFiscal+cSerie+cClifor+cLoja)     
						If !Empty(SD1->D1_NFORI+SD1->D1_SERIORI)
							cOriSer  := SD1->D1_SERIORI
							cNumDoc := SD1->D1_NFORI
							cFilNCC := SD1->D1_FILIAL
							_jAlias := getNextAlias()
							xqry := "SELECT F2_EMISSAO,F2_TPDOC"
							xqry += "  FROM "+RetSQLTab('SF2')
							xqry += " WHERE F2_DOC='"+SD1->D1_NFORI+"'"
							xqry += "   AND F2_SERIE='"+SD1->D1_SERIORI+"'"
							xqry += "   AND F2_CLIENTE='"+SD1->D1_FORNECE+"'"
							xqry += "   AND F2_LOJA='"+SD1->D1_LOJA+"'"
							
							dbUseArea( .T., "TOPCONN", TcGenQry( ,, xqry ), _jAlias,.T.,.T.)

							if (_jAlias)->( !eof() )
								dEmiss  := stod((_jAlias)->F2_EMISSAO)
								cTipDoc := (_jAlias)->F2_TPDOC
							endif
							(_jAlias)->( dbCloseArea() )
							exit
						Endif	
						SD1->(DbSkip())
					EndDo
				EndIf
			
			EndIf

			//25 - CÛdigo  de la Moneda (Tabla 4)
			cLin += xFINDMO1(cFil,cNFiscal,cSerie,cClifor,cLoja,cEspecie)
			cLin += cSep

			//26 - Tipo de cambio (5)
			if nTxMoeda<=0
				nTxMoeda := yFINDMO2(cFil,cNFiscal,cSerie,cClifor,cLoja,cEspecie)		// SISTHEL - 24/08/2018
			endif
			cLin += AllTrim(StrTran(Transform(nTxMoeda,"@E 999999999.999"),",","."))
			cLin += cSep

			//27 - Fecha de emisiÛn del comprobante de pago o documento original que se modifica (6)
			//		o documento referencial al documento que sustenta el crÈdito fiscal
			If !Empty(dEmiss)
				cLin += SubStr(DTOC(dEmiss),1,6)+SubStr(DTOS(dEmiss),1,4)
			Else
				cLin += ""
			EndIf
			cLin += cSep

			//28 - Tipo del comprobante de pago que se modifica (6)
			If AllTrim(cTpDoc) $ "06|07|08|87|88" .And. ALLTRIM( cCGC)<>'Anulado'
				If !Empty(cTipDoc)
					cLin += AllTrim(cTipDoc)
				Else
					cLin += AllTrim(cTipDoc)
				EndIf
			Else
				cLin += ""
			EndIf
			cLin += cSep

			//29 - N˙mero de serie del comprobante de pago que se modifica (6) o CÛdigo de la Dependencia Aduanera
			If AllTrim(cTpDoc) $ "06|07|08|87|88" .And. ALLTRIM(cCGC)<>'Anulado'
				// ----------------------------------------------------------------------------------- //
				// Adicionado por SISTHEL para impresion de la serie 2 ( factura electrocnica - Peru ) //
				// ----------------------------------------------------------------------------------- //
				lTemSFP := .f.
				SFP->( dbSetOrder(5) )	//FP_FILIAL, FP_FILUSO, FP_SERIE, FP_ESPECIE, R_E_C_N_O_, D_E_L_E_T_
//					If SFP->( dbSeek( xFilial("SFP")+cFil+cSerie+"1" ) ) 
					If SFP->( dbSeek( xFilial("SFP")+cFil+cOriser+"1" ) ) 
					If lSer3 .And. !Empty(SFP->FP_YSERIE)
							cOriSer := Alltrim(SFP->FP_YSERIE)
						lTemSFP := .t.
					EndIf
					if SFP->( FieldPos("FP_SERIE2") )>0
						if !empty(SFP->FP_SERIE2)
								cOriSer := Alltrim(SFP->FP_SERIE2)
							lTemSFP := .t.
						endif
					endif
				endif
				
				if !lTemSFP
					If SFP->( dbSeek( xFilial("SFP")+cFil+cOriser+"6" ) )
						If lSer3 .And. !Empty(SFP->FP_YSERIE)
							cOriSer := Alltrim(SFP->FP_YSERIE)
							lTemSFP := .t.
						EndIf
					endif
					if SFP->( FieldPos("FP_SERIE2") )>0
						if !empty(SFP->FP_SERIE2)
							cOriSer := Alltrim(SFP->FP_SERIE2)
							lTemSFP := .t.
						endif
					endif
				EndIf

				if !lTemSFP
						If SFP->( dbSeek( xFilial("SFP")+cFil+cOriser+"3" ) )
						If lSer3 .And. !Empty(SFP->FP_YSERIE)
								cOriSer := Alltrim(SFP->FP_YSERIE)
							lTemSFP := .t.
						EndIf
					endif
					if SFP->( FieldPos("FP_SERIE2") )>0
						if !empty(SFP->FP_SERIE2)
								cOriSer := Alltrim(SFP->FP_SERIE2)
							lTemSFP := .t.
						endif
					endif
				EndIf

				if !lTemSFP
					If SFP->( dbSeek( xFilial("SFP")+cFil+cOriser+"2" ) )
						If lSer3 .And. !Empty(SFP->FP_YSERIE)
								cOriSer := Alltrim(SFP->FP_YSERIE)
							lTemSFP := .t.
						EndIf
					endif
					if SFP->( FieldPos("FP_SERIE2") )>0
						if !empty(SFP->FP_SERIE2)
								cOriser := Alltrim(SFP->FP_SERIE2)
							lTemSFP := .t.
						endif
					endif
				EndIf

				If Len(cOriSer)<=3
					cOriSer := Replicate("0",4-Len(cOriSer))+cOriSer
				EndIf
				
				// -------------------------------------------------------------------------[ Fim ]-- //
				If !Empty(cOriSer)
					cSerF := ""
					cSer  := Alltrim(cOriSer)
					nTot1 := Len(cSer)+1
					For nTot1 := Len(cSer)+1 to 4
						cSerF+="0"
					Next						
					cSerF += cOriSer 												
					cLin += AllTrim(cSerF)						
				Else
					cLin += "-"
				EndIf
				
			else
				cLin += ""
			EndIf	
			cLin += cSep

			//30 - N˙mero del comprobante de pago que se modifica (6) o N˙mero de la DUA, de corresponder
			If AllTrim(cTpDoc) $ "06|07|08|87|88" .And. ALLTRIM( cCGC)<>'Anulado'
				If !Empty(cNumDoc)
					cLin += Right(AllTrim(cNumDoc),8)
				Else
					cLin += "-"
				EndIf
			Else
				cLin += "-"
			EndIF
			cLin += cSep

			//31 - IdentificaciÛn del Contrato o del proyecto en el caso de los Operadores de las sociedades
			//     irregulares, consorcios, joint ventures u otras formas de contratos de colaboraciÛn empresarial,
			//     que no lleven contabilidad independiente.
			cLin += ""
			cLin += cSep

			//32 - Error tipo 1: inconsistencia en el tipo de cambio
			cLin += ""
			cLin += cSep

			//33 - Indicador de Comprobantes de pago cancelados con medios de pago
			cLin += ""
			cLin += cSep

			//34 - Estado que identifica la oportunidad de la anotaciÛn o indicaciÛn si Èsta corresponde a alguna
			//     de las situaciones previstas en el inciso e del artÌculo 8∞
			IF SubStr(DTOS(aParams[1]),1,6)==SubStr(DTOS(dEmissao),1,6)
				IF ALLTRIM( cCGC)=='Anulado'
					cLin += "2"
				Else
			   		cLin += "1"
			   	EndIf
			ELSEIF dEmissao >= aParams[1] - 365
				IF ALLTRIM( cCGC)=='Anulado'
					cLin += "2"
				Else
			   		cLin += "8"
			   	EndIf
			ENDIF
			cLin += cSep

			cLin += chr(13)+chr(10)
			fWrite(nHdl,cLin)
			nValorC := 0
		EndIf
	EndDo
	fClose(nHdl)
EndIf

If !lRet
	If aParams[6] == 2
		ApMsgStop("Ocorreu um erro ao criar o arquivo.")
	//ElseIf aParams[6] == 3
		//VarSetX('ZFISR011', 'cStatusPrc', '-1')
	EndIf
Else
	/*
	If aParams[6] == 3
		VarSetX('ZFISR011', 'cStatusPrc', '2')
	EndIf
	*/
EndIf

ConOut('[DS2U]' + Repl('-', 50))
ConOut('TERMINO DA GERACAO DO ARQUIVO TEXTO: ' + Time())
ConOut(Repl('-', 50))

Return


/*/
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥BuscaCorre≥ Autor ≥ Totvs                 ≥ Data | Jan/2013 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥Busca Correlativo Caso em Branco                            ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function BuscaCorre(cFil,cDoc,cSer,cForn,cLoj,dEmis,cEsp)
Local cQuery    := ''
Local nRecno1:=0
Local cNodia:="  "
Local aArea:=GetArea()
Local nTamDoc := 0
Local ntamcDoc := 0
Local cAlias01 := GetNextAlias()

If Alltrim(cEsp) $ "NDP|NDE|NCI|NCC"
	cSql003:= " SELECT MAX(R_E_C_N_O_) RECNO1  "
	cSql003+= " FROM "+ RetSqlName("SF1") + " SF1 "
	cSql003+= " WHERE SF1.F1_FILIAL  = '"+cFil+"' "
	cSql003+= "   AND SF1.F1_DOC     = '"+cDoc+"' "
	cSql003+= "   AND SF1.F1_SERIE   = '"+cSer+"' "
	cSql003+= "   AND SF1.F1_FORNECE = '"+cForn+"' "
	cSql003+= "   AND SF1.F1_LOJA    = '"+cLoj+"' "
	cSql003+= "   AND SF1.F1_NODIA<>''"
else
	cSql003:= " SELECT MAX(R_E_C_N_O_) RECNO1  "
	cSql003+= " FROM "+ RetSqlName("SF2") + " SF2 "
	cSql003+= " WHERE SF2.F2_FILIAL  = '"+cFil+"' "
	cSql003+= "   AND SF2.F2_DOC     = '"+cDoc+"' "
	cSql003+= "   AND SF2.F2_SERIE   = '"+cSer+"' "
	cSql003+= "   AND SF2.F2_CLIENTE = '"+cForn+"' "
	cSql003+= "   AND SF2.F2_LOJA    = '"+cLoj+"' "
	cSql003+= "   AND SF2.F2_NODIA<>''"
endif
cAliasCor := GetNextAlias()
dbUseArea( .T., "TOPCONN", TcGenQry( ,, cSql003 ), cAliasCor,.T.,.T.)
(cAliasCor)->(dBGotop())
IF (cAliasCor)->(! EOF())
	nRecno1:=(cAliasCor)->RECNO1
	if nRecno1 > 0
		(cAliasCor)->(DbCLoseArea())
		cSql003:= " SELECT CT2_NODIA  "
		cSql003+= " FROM "+ RetSqlName("CV3") + " CV3, "+ RetSqlName("CT2") + " CT2 "
		cSql003+= " WHERE CV3.CV3_FILIAL = '"+xFilial("CV3")+"' "
		If Alltrim(cEsp) $ "NDP|NDE|NCI|NCC"
			cSql003+= "   AND CV3.CV3_TABORI  = 'SF1' "
		else
			cSql003+= "   AND CV3.CV3_TABORI  = 'SF2' "
		endif
		cSql003+= "   AND CV3.CV3_RECORI  = '"+ALLTRIM(str(nRecno1,17))+"' "
		cSql003+= "   AND CV3.D_E_L_E_T_ = ' ' "
		cSql003+= "   AND CV3.CV3_FILIAL  = CT2.CT2_FILIAL  "
		cSql003+= "   AND CV3.CV3_DTSEQ   = CT2.CT2_DATA  "
		cSql003+= "   AND CV3.CV3_SEQUEN  = CT2.CT2_SEQUEN  "
		cSql003+= "   AND CT2.CT2_NODIA <> '        '  "
		cSql003+= "   AND CT2.D_E_L_E_T_ = ' ' "
		cAliasCor := GetNextAlias()
		dbUseArea( .T., "TOPCONN", TcGenQry( ,, cSql003 ), cAliasCor,.T.,.T.)
		(cAliasCor)->(dBGotop())
		IF (cAliasCor)->(!EOF()) .AND. !Empty((cAliasCor)->CT2_NODIA)
			cNodia:=(cAliasCor)->CT2_NODIA
		/*
		ELSE
		
			If Alltrim(cEsp) $ "NDP|NDE|NCI|NCC"
				cSql003:= " SELECT SF1.F1_NODIA NODIA"
				cSql003+= " FROM "+ RetSqlName("SF1") + " SF1 "
				cSql003+= " WHERE SF1.F1_FILIAL  = '"+cFil+"' "
				cSql003+= "   AND SF1.F1_DOC     = '"+cDoc+"' "
				cSql003+= "   AND SF1.F1_SERIE   = '"+cSer+"' "
				cSql003+= "   AND SF1.F1_FORNECE = '"+cForn+"' "
				cSql003+= "   AND SF1.F1_LOJA    = '"+cLoj+"' "
				cSql003+= "   AND SF1.F1_NODIA<>''"
			else
				cSql003:= " SELECT SF2.F2_NODIA NODIA"
				cSql003+= " FROM "+ RetSqlName("SF2") + " SF2 "
				cSql003+= " WHERE SF2.F2_FILIAL  = '"+cFil+"' "
				cSql003+= "   AND SF2.F2_DOC     = '"+cDoc+"' "
				cSql003+= "   AND SF2.F2_SERIE   = '"+cSer+"' "
				cSql003+= "   AND SF2.F2_CLIENTE = '"+cForn+"' "
				cSql003+= "   AND SF2.F2_LOJA    = '"+cLoj+"' "
				cSql003+= "   AND SF2.F2_NODIA<>''"
			endif
			dbUseArea( .T., "TOPCONN", TcGenQry( ,, cSql003 ), cAlias01,.T.,.T.)
			
			if (cAlias01)->( !eof() )
				cNodia:=(cAlias01)->NODIA
			endif
			
			(cAlias01)->( dbCloseArea() )
		*/
		ENDIF
	endif
ENDIF
RestArea(aArea)
(cAliasCor)->(DbCLoseArea())
IF EMPTY(cNodia)
	//nTamDoc:=(TamSX3("F2_NODIA")[1]-4)
	//ntamcDoc:=(Len(ALLTRIM(cDoc)) - nTamDoc + 1)
	//cNodia :=StrZero(Val(Subs(cDoc,ntamcDoc,nTamDoc)),6)+Right(DtoS(dEmis),4)
	cNodia :=space(10)
ENDIF   

	/*
	Local cQuery    := ''
	Local nRecnoSF2 := 0
	Local cNodia	:= ""
	Local aArea		:= GetArea()
	
	If Alltrim(cEsp) $ "NDP|NDE|NCI|NCC"
		SF1->(DbSetOrder(1)) //--F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_TIPO
		If SF1->(DbSeek(cFil+cDoc+cSer+cForn+cLoj))
			While !SF1->(Eof()) .And. SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) == cFil+cDoc+cSer+cForn+cLoj
				If nRecnoSF2 < SF1->(RecNo())
					nRecnoSF2 := SF1->(RecNo())
					exit
				EndIf
				SF1->(DbSkip())
			End
		endif
		cytab := "SF1"
	else
		SF2->(DbSetOrder(1)) //--F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
		If SF2->(DbSeek(cFil+cDoc+cSer+cForn+cLoj))
			While !SF2->(Eof()) .And. SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA) == cFil+cDoc+cSer+cForn+cLoj
				If nRecnoSF2 < SF2->(RecNo())
					nRecnoSF2 := SF2->(RecNo())
					exit
				EndIf
				SF2->(DbSkip())
			End
		endif
		cytab := "SF2"
	endif

	if nRecnoSF2 > 0
	
		CV3->(DbSetOrder(3)) //--CV3_FILIAL+CV3_TABORI+CV3_RECORI
		If CV3->(DbSeek(cFil+cytab+AllTrim(Str(nRecnoSF2))))
		
			cQuery := "SELECT CT2_NODIA "
			cQuery += "  FROM " + RetSQLTab('CT2')
			cQuery += " WHERE CT2.CT2_FILIAL = '" + cFil + "' "
			cQuery += "   AND CT2.CT2_DATA = '" + DtoS(CV3->CV3_DTSEQ) + "' "
			cQuery += "   AND CT2.CT2_SEQUEN = '" + CV3->CV3_SEQUEN + "' "
			cQuery += "   AND CT2.CT2_NODIA <> '        '"
			cQuery += "   AND CT2.D_E_L_E_T_ = ' ' "
	
			cQuery    := ChangeQuery(cQuery)
			cAliasQry := GetNextAlias()
			dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery), cAliasQry, .T., .T.)
	
			If !(cAliasQry)->(Eof()) .And. !Empty((cAliasQry)->CT2_NODIA)
				cNodia := (cAliasQry)->CT2_NODIA
			EndIf
			(cAliasQry)->(DbCloseArea())
			
		else
			cNodia := space(10)
		endif
		
		(cAliasCor)->(DbCLoseArea())
		cSql003:= " SELECT CT2_NODIA  "
		cSql003+= " FROM "+ RetSqlName("CV3") + " CV3, "+ RetSqlName("CT2") + " CT2 "
		cSql003+= " WHERE CV3.CV3_FILIAL = '"+xFilial("CV3")+"' "
		If Alltrim(cEsp) $ "NDP|NDE|NCI|NCC"
			cSql003+= "   AND CV3.CV3_TABORI  = 'SF1' "
		else
			cSql003+= "   AND CV3.CV3_TABORI  = 'SF2' "
		endif
		cSql003+= "   AND CV3.CV3_RECORI  = '"+ALLTRIM(str(nRecno1,17))+"' "
		cSql003+= "   AND CV3.D_E_L_E_T_ = ' ' "
		cSql003+= "   AND CV3.CV3_FILIAL  = CT2.CT2_FILIAL  "
		cSql003+= "   AND CV3.CV3_DTSEQ   = CT2.CT2_DATA  "
		cSql003+= "   AND CV3.CV3_SEQUEN  = CT2.CT2_SEQUEN  "
		cSql003+= "   AND CT2.CT2_NODIA <> '        '  "
		cSql003+= "   AND CT2.D_E_L_E_T_ = ' ' "
		cAliasCor := GetNextAlias()
		dbUseArea( .T., "TOPCONN", TcGenQry( ,, cSql003 ), cAliasCor,.T.,.T.)
		(cAliasCor)->(dBGotop())
		IF (cAliasCor)->(!EOF()) .AND. !Empty((cAliasCor)->CT2_NODIA)
			cNodia:=(cAliasCor)->CT2_SEGOFI
		ENDIF

	endif

	RestArea(aArea)
	
	*/

Return(cNodia)

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥xFINDMO1  ∫Autor  ≥Microsiga           ∫ Data ≥  07/13/18   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Retorna descricao da moeda                                  ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function xFINDMO1(cFil, cDoc, cSer, cForn, cLoj, cEspec, nRet)
Local cMoeda   := Space(03)
Local nMoeda   := 0

Local aArea    := GetArea()
Local aAreaSF1 := SF1->(GetArea())
Local aAreaSF2 := SF2->(GetArea())
Local aAreaSX5 := SX4->(GetArea())
Local cSql003  := ""
Local cAliasM  := getNextAlias()

If Alltrim(cEspec) $ "NDP|NDE|NCI|NCC"
	SF1->(DbSetOrder(1)) //--F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
	If SF1->(DbSeek(cFil+cDoc+cSer+cForn+cLoj))
		nMoeda := SF1->F1_MOEDA
	EndIf

Else
	SF2->(DbSetOrder(1)) //--F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
	If SF2->(DbSeek(cFil+cDoc+cSer+cForn+cLoj))
		nMoeda := SF2->F2_MOEDA
	EndIf

EndIf

if nMoeda==0
	If Alltrim(cEspec) $ "NDP|NDE|NCI|NCC"
		cSql003:= " SELECT F1_MOEDA AS MONEDA"
		cSql003+= " FROM "+ RetSqlName("SF1")
		cSql003+= " WHERE F1_FILIAL  = '"+cFil+"' "
		cSql003+= "   AND F1_DOC     = '"+cDoc+"' "
		cSql003+= "   AND F1_SERIE   = '"+cSer+"' "
		cSql003+= "   AND F1_FORNECE = '"+cForn+"' "
		cSql003+= "   AND F1_LOJA    = '"+cLoj+"' "
		cSql003+= "   AND D_E_L_E_T_='*'"
	else
		cSql003:= " SELECT F2_MOEDA AS MONEDA"
		cSql003+= " FROM "+ RetSqlName("SF2")
		cSql003+= " WHERE F2_FILIAL  = '"+cFil+"' "
		cSql003+= "   AND F2_DOC     = '"+cDoc+"' "
		cSql003+= "   AND F2_SERIE   = '"+cSer+"' "
		cSql003+= "   AND F2_CLIENTE = '"+cForn+"' "
		cSql003+= "   AND F2_LOJA    = '"+cLoj+"' "
		cSql003+= "   AND D_E_L_E_T_='*'"
	endif
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cSql003 ), cAliasM,.T.,.T.)
			
	if (cAliasM)->( !eof() )
		nMoeda := (cAliasM)->MONEDA
	endif
			
	(cAliasM)->( dbCloseArea() )
endif

SX5->(DbSetOrder(1)) //--X5_FILIAL+X5_TABELA+X5_CHAVE
If SX5->(DbSeek(xFilial('SX5')+'XQ'+AllTrim(Str(nMoeda))))
	cMoeda := AllTrim(SX5->X5_DESCSPA)
EndIf


//--RESTAURA AMBIENTE:
RestArea(aArea)
RestArea(aAreaSF1)
RestArea(aAreaSF2)
RestArea(aAreaSX5)

Return(cMoeda)

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥yFINDMO2  ∫Autor  ≥Microsiga           ∫Fecha ≥  08/24/18   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Retorna taxa da moeda                                       ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function yFINDMO2(cFil, cDoc, cSer, cForn, cLoj, cEspec)
Local nMoeda   := 1

Local aArea    := GetArea()
Local aAreaSF1 := SF1->(GetArea())
Local aAreaSF2 := SF2->(GetArea())

If Alltrim(cEspec) $ "NDP|NDE|NCI|NCC"
	SF1->(DbSetOrder(1)) //--F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
	If SF1->(DbSeek(cFil+cDoc+cSer+cForn+cLoj))
		nMoeda := SF1->F1_TXMOEDA
	EndIf

Else
	SF2->(DbSetOrder(1)) //--F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
	If SF2->(DbSeek(cFil+cDoc+cSer+cForn+cLoj))
		nMoeda := SF2->F2_TXMOEDA
	EndIf

EndIf

//--RESTAURA AMBIENTE
RestArea(aArea)
RestArea(aAreaSF1)
RestArea(aAreaSF2)

Return(nMoeda)

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ZFISR011  ∫Autor  ≥Microsiga           ∫Fecha ≥  09/10/19   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function getLinCT2(cSegofi,nVal,nMda,lncc,cXFil)

	local cSql		:= ""
	local cMoeda	:= strzero(nMda,2)
	local cVlRed	:= alltrim(str(Round(nVal,0)))
	local _cAlias	:= getNextAlias()
	local bLinha	:= "000000000"
	
	cSql := " SELECT CT2_LINHA,CT2_CREDIT,CT2_DEBITO,ROUND(CT2_VALOR,0) CT2_VALOR"
	cSql += "   FROM "+ RetSqlName("CT2")
	cSql += "  WHERE CT2_FILIAL = '"+cXFil+"'"
	cSql += "    AND CT2_MOEDLC='"+cMoeda+"'"
	if !lncc
		cSql += "    AND ROUND(CT2_VALOR,0)="+cVlRed
	endif
	cSql += "    AND CT2_SEGOFI='"+cSegofi+"'"
	cSql += "    AND D_E_L_E_T_ <> '*' "	
	
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cSql ), _cAlias,.T.,.T.)

	If (_cAlias)->( !eof() )
		While (_cAlias)->( !eof() )
			/*
			if left((_cAlias)->CT2_DEBITO,1)=="7"
				bLinha := strzero(val((_cAlias)->CT2_LINHA),9)
				exit
			elseif left((_cAlias)->CT2_CREDIT,1)=="7"
				bLinha := strzero(val((_cAlias)->CT2_LINHA),9)
				exit
			*/
			if left((_cAlias)->CT2_DEBITO,2)=="12"
				bLinha := strzero(val((_cAlias)->CT2_LINHA),9)
				exit
			elseif left((_cAlias)->CT2_CREDIT,2)=="12"
				bLinha := strzero(val((_cAlias)->CT2_LINHA),9)
				exit
			endif
			(_cAlias)->( dbSkip() )
		End
	EndIf

	(_cAlias)->( dbCloseArea() )

Return(bLinha)

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ZFISR011  ∫Autor  ≥Microsiga           ∫Fecha ≥  09/10/19   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function xBusNFAnul(cFil,cDoc,cSer,cCli,cLoj,lF2)

	Local cTpDoc	:= space(TAMSX3("F1_TPDOC")[1])
	Local aArea		:= GetArea()
	local _cAlias	:= GetNextAlias()
	local cSql004	:= ""
	local aret		:= {}
	
	if lF2

		cSql004:= " SELECT F2_NODIA AS NODIA,F2_VALBRUT AS VALBRUT,F2_MOEDA AS MOEDA  "
		cSql004+= " FROM "+ RetSqlName("SF2") + " SF2 "
		cSql004+= " WHERE SF2.F2_FILIAL  = '"+cFil+"' "
		cSql004+= "   AND SF2.F2_DOC     = '"+cDoc+"' "
		cSql004+= "   AND SF2.F2_SERIE   = '"+cSer+"' "
		cSql004+= "   AND SF2.F2_CLIENTE = '"+cCli+"' "
		cSql004+= "   AND SF2.F2_LOJA    = '"+cLoj+"' "
		cSql004+= "   AND SF2.D_E_L_E_T_ = '*' "
		cSql004+= "   AND SF2.R_E_C_N_O_ > 0"
		
	else

		cSql004:= " SELECT F1_NODIA AS NODIA,F1_VALBRUT AS VALBRUT,F1_MOEDA AS MOEDA  "
		cSql004+= " FROM "+ RetSqlName("SF1") + " SF1 "
		cSql004+= " WHERE SF1.F1_FILIAL  = '"+cFil+"' "
		cSql004+= "   AND SF1.F1_DOC     = '"+cDoc+"' "
		cSql004+= "   AND SF1.F1_SERIE   = '"+cSer+"' "
		cSql004+= "   AND SF1.F1_FORNECE = '"+cCli+"' "
		cSql004+= "   AND SF1.F1_LOJA    = '"+cLoj+"' "
		cSql004+= "   AND SF1.D_E_L_E_T_ = '*' "
		cSql004+= "   AND SF1.R_E_C_N_O_ > 0"
	
	endif
		
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cSql004 ), _cAlias,.T.,.T.)
	IF (_cAlias)->( !EOF() )
	   Aadd( aret,(_cAlias)->NODIA )
	   Aadd( aret,(_cAlias)->VALBRUT )
	   Aadd( aret,(_cAlias)->MOEDA )
	ENDIF   
	
	(_cAlias)->( dbCloseArea() )

	RestArea(aArea)

Return(aret)

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø±±
±±≥Funcao    ≥FISR011Qry ≥ Autor ≥ V. RASPA                                ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descricao ≥Queries utilizadas no reltoario                              ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function FISR011Qry(aFiliais, aParams, lMultiThread)
Local cQuery    := ''
Local cAliasQry := ''
Local cFiliais  := ''
Local lSerie2   := SF1->(FieldPos("F1_SERIE2")) > 0 .And. SF2->(FieldPos("F2_SERIE2")) > 0 .And. SF3->(FieldPos("F3_SERIE2")) > 0 .And. GetNewPar("MV_LSERIE2", .F.)
Local lSerOri   := SF1->(FieldPos("F1_SERORI")) > 0 .And. SF2->(FieldPos("F2_SERORI")) > 0 .And. SF3->(FieldPos("F3_SERORI")) > 0
Local lCpDoc    := SF3->(FieldPos("F3_TPDOC")) > 0
Local lCodSF2   := SF2->(FieldPos('F2_TPDOC')) > 0

Default lMultiThread := .F.

//-- Trata filiais selecionadas...
aEval(aFiliais, {|e| If(e[1], cFiliais += e[2] + '|', NIL)})
cFiliais += cFiliais + Space(TamSX3("F3_FILIAL")[1]) + '|'

// -------------------------------------------
// QUERY P/ CALCULAR O CAMPO "OUTROS TRIBUTOS"
// -------------------------------------------
cQuery := "SELECT F3_FILIAL,F3_ESPECIE,F3_EMISSAO,E1_VENCREA,CCL_CODGOV,F3_SERIE2,F3_SERORI,F3_TPDOC,F3_SERIE,F3_NFISCAL,F3_CLIEFOR,F3_LOJA,F3_TIPO,A1_NOME,A1_EST,F2_TXMOEDA,F2_MOEDA,F2_NODIA,A1_TIPDOC,A1_CGC,A1_PFISICA,"
cQuery += "			SUM(EXPORTACAO) EXPORTACAO,SUM(F3_BASIMP1) F3_BASIMP1,SUM(F3_BASIMP2) F3_BASIMP2,SUM(EXONERADA) EXONERADA,SUM(INAFECTA) INAFECTA,SUM(F3_VALIMP2) F3_VALIMP2,SUM(F3_VALIMP1) F3_VALIMP1,SUM(F3_VALCONT) F3_VALCONT"
cQuery += "  FROM ("
cQuery += "SELECT DISTINCT "
cQuery += "       SF3.F3_FILIAL, "
cQuery += "       SF3.F3_ESPECIE, "
cQuery += "       SF3.F3_EMISSAO, "
cQuery += "       CASE WHEN SF3.F3_DTCANC =  ' ' THEN SE1.E1_VENCREA ELSE 'Anulado       ' END AS E1_VENCREA,  "
If !lCodSF2
	cQuery += " CCL.CCL_CODGOV, "
Else
    cQuery += " CASE WHEN SF3.F3_DTCANC = ' ' AND SF3.F3_TIPO = 'D' THEN F1_TPDOC
    cQuery += "      WHEN SF3.F3_DTCANC = ' ' AND SF3.F3_TIPO = 'N' THEN F2_TPDOC
    cQuery += "      ELSE '01' END AS CCL_CODGOV, "
EndIf
if lSerie2
	cQuery += " CASE WHEN SF3.F3_SERIE2=' ' AND SF3.F3_TIPO = 'D' THEN F1_SERIE2
	cQuery += "      WHEN SF3.F3_SERIE2=' ' AND SF3.F3_TIPO = 'N' THEN F2_SERIE2
	cQuery += "      ELSE SF3.F3_SERIE2 END AS F3_SERIE2, "
endif
cQuery += If(lSerOri, " SF3.F3_SERORI, ", "")
cQuery += If(lCpDoc, " SF3.F3_TPDOC, ", "")
cQuery += "       SF3.F3_SERIE, "
cQuery += "       SF3.F3_NFISCAL, "
cQuery += "       SF3.F3_CLIEFOR, "
cQuery += "       SF3.F3_LOJA, "
cQuery += "       SF3.F3_TIPO, "
cQuery += "       SA1.A1_NOME, "
cQuery += "       SA1.A1_EST, "
//cQuery += "       CASE WHEN SF3.F3_DTCANC = ' '  AND F3_ESPECIE='NCC' THEN SF2.F2_NODIA ELSE '   ' END AS F2_NODIA, "
cQuery += "       CASE WHEN SF3.F3_DTCANC = ' '  AND F3_ESPECIE='NCC' THEN SF1.F1_NODIA ELSE SF2.F2_NODIA END AS F2_NODIA, "
cQuery += "       CASE WHEN SF3.F3_DTCANC = ' ' THEN SA1.A1_TIPDOC ELSE SA1.A1_TIPDOC END AS A1_TIPDOC, "
cQuery += "       CASE WHEN SF3.F3_DTCANC = ' ' THEN SA1.A1_CGC ELSE 'Anulado       ' END AS A1_CGC, "
cQuery += "       CASE WHEN SF3.F3_DTCANC = ' ' THEN SA1.A1_PFISICA ELSE 'Anulado       ' END AS A1_PFISICA, "
cQuery += "       CASE WHEN (F3_DTCANC = ' ' AND A1_EST = 'EX' AND F4_CALCIGV <> '1') THEN SUM(F3_VALCONT) ELSE 0 END AS EXPORTACAO, "
cQuery += "       CASE WHEN F3_DTCANC = ' '  AND A1_EST<>'EX' AND F4_CALCIGV = '1' THEN SUM(F3_BASIMP1) ELSE 0 END AS F3_BASIMP1, "
cQuery += "       CASE WHEN F3_DTCANC = ' '  AND A1_EST<>'EX' AND F4_CALCIGV = '1' THEN SUM(F3_BASIMP2) ELSE 0 END AS F3_BASIMP2, "
//cQuery += "       CASE WHEN F3_DTCANC = ' '  AND F4_CALCIGV = '2' AND A1_EST<>'EX' THEN SUM(F3_EXENTAS) ELSE 0 END AS EXONERADA, "
cQuery += "       CASE WHEN F3_DTCANC = ' '  AND F4_CALCIGV = '2' AND A1_EST<>'EX' THEN SUM(F3_EXENTAS) "
cQuery += "            WHEN F3_DTCANC = ' '  AND F4_CALCIGV = '1' AND A1_EST<>'EX' THEN SUM(F3_BASIMP1) ELSE 0 END AS EXONERADA, "
cQuery += "       CASE WHEN F3_DTCANC = ' '  AND F4_CALCIGV = '3'  THEN SUM(F3_EXENTAS) ELSE 0 END AS INAFECTA, "
cQuery += "       CASE WHEN SF3.F3_DTCANC = ' ' THEN SUM(SF3.F3_VALIMP2) ELSE 0  END AS F3_VALIMP2, "
cQuery += "       CASE WHEN SF3.F3_DTCANC = ' ' THEN SUM(SF3.F3_VALIMP1) ELSE 0  END AS F3_VALIMP1, "
cQuery += "       CASE WHEN SF3.F3_DTCANC = ' ' THEN SUM(SF3.F3_VALCONT) ELSE 0  END AS F3_VALCONT, "
cQuery += "        CASE WHEN F3_DTCANC = ' '  AND F3_ESPECIE='NCC' THEN F1_TXMOEDA     ELSE F2_TXMOEDA  END AS F2_TXMOEDA, "
cQuery += "        CASE WHEN F3_DTCANC = ' '  AND F3_ESPECIE='NCC' THEN F1_MOEDA       ELSE F2_MOEDA  END AS F2_MOEDA "

cQuery += "  FROM " + RetSQLTab('SF3')

cQuery += "  LEFT JOIN " + RetSQLTab('SE1')
cQuery += "    ON SE1.E1_FILIAL = SF3.F3_FILIAL "
cQuery += "   AND SE1.E1_EMISSAO = SF3.F3_ENTRADA "
cQuery += "   AND SE1.E1_NUM = SF3.F3_NFISCAL "
cQuery += "   AND SE1.E1_PREFIXO = SF3.F3_SERIE "
cQuery += "   AND SE1.E1_CLIENTE = SF3.F3_CLIEFOR "
cQuery += "   AND SE1.E1_LOJA = SF3.F3_LOJA "
cQuery += "   AND SE1.E1_TIPO IN ('NF','NCC','NDC')  "
cQuery += "   AND SE1.D_E_L_E_T_ = ' ' "

If !lCodSF2
	cQuery += "  LEFT JOIN " + RetSQLTab('CCM')
	cQuery += "    ON CCM.CCM_COD42 = SF3.F3_ESPECIE "
	cQuery += "   AND CCM_FILIAL = '" + xFilial("CCM") + "' "
	cQuery += "   AND CCM.D_E_L_E_T_ <> '*' "

	cQuery += " LEFT JOIN " + RetSQLTab('CCL')
	cQuery += "   ON CCL.CCL_CODIGO = CCM_CODGOV "
	cQuery += "  AND CCL.CCL_FILIAL = '" + xFilial("CCL") + "' "
	cQuery += "  AND CCL.D_E_L_E_T_ = ' ' "
Endif

cQuery += "  LEFT JOIN " + RetSQLTab('SA1')
cQuery += "    ON SA1.A1_FILIAL = '" + xFilial("SA1") + "'"
cQuery += "   AND SA1.A1_LOJA = SF3.F3_LOJA "
cQuery += "   AND SA1.A1_COD = SF3.F3_CLIEFOR "
cQuery += "   AND SA1.D_E_L_E_T_ = ' ' "

cQuery += "  LEFT JOIN " + RetSQLTab('SF4')
cQuery += "    ON SF4.F4_FILIAL = '" + xFilial("SF4") + "'"
cQuery += "   AND SF4.F4_CODIGO = SF3.F3_TES"
cQuery += "   AND SF4.D_E_L_E_T_ = ' ' "

cQuery += "  LEFT JOIN " + RetSQLTab('SF2')
cQuery += "    ON SF2.F2_FILIAL = SF3.F3_FILIAL "
cQuery += "   AND SF2.F2_DOC = SF3.F3_NFISCAL "
cQuery += "   AND SF2.F2_SERIE = SF3.F3_SERIE "
cQuery += "   AND SF2.F2_ESPECIE = SF3.F3_ESPECIE "
cQuery += "   AND SF2.F2_CLIENTE = SF3.F3_CLIEFOR "
cQuery += "   AND SF2.F2_LOJA = SF3.F3_LOJA "
cQuery += "   AND SF2.D_E_L_E_T_ = ' ' "

cQuery += "  LEFT JOIN " + RetSQLTab('SF1')
cQuery += "    ON SF1.F1_FILIAL = SF3.F3_FILIAL "
cQuery += "   AND SF1.F1_DOC = SF3.F3_NFISCAL "
cQuery += "   AND SF1.F1_SERIE = SF3.F3_SERIE "
cQuery += "   AND SF1.F1_ESPECIE = SF3.F3_ESPECIE "
cQuery += "   AND SF1.F1_FORNECE = SF3.F3_CLIEFOR "
cQuery += "   AND SF1.F1_LOJA = SF3.F3_LOJA "
cQuery += "   AND SF1.D_E_L_E_T_ = ' ' "

cQuery += " WHERE SF3.F3_FILIAL IN " +  FormatIn(cFiliais, '|')
cQuery += "   AND SF3.F3_ENTRADA BETWEEN '" + DtoS(aParams[1]) + "' AND '" + DtoS(aParams[2]) + "' "
If !lCodSF2
	cQuery += " AND ((SF3.F3_TIPOMOV = 'V' AND SF3.F3_ESPECIE = 'NF') OR (SF3.F3_TIPOMOV = 'C' AND SF3.F3_FORMUL = 'S' AND SF3.F3_ESPECIE <> 'NF') OR (SF3.F3_TIPOMOV = 'V'  AND SF3.F3_FORMUL = 'S' AND SF3.F3_ESPECIE <> 'NF'))"
Else
	cQuery += " AND ((SF3.F3_TIPOMOV = 'V') OR (SF3.F3_TIPOMOV = 'C' AND SF3.F3_FORMUL = 'S') OR (SF3.F3_TIPOMOV = 'V' AND SF3.F3_FORMUL = 'S')) "
Endif
cQuery += "   AND SF3.D_E_L_E_T_ = ' ' "
//cQuery += "   AND (SF3.F3_BASIMP1>0 OR SF3.F3_BASIMP2>0)"
//cQuery += "   AND SF3.F3_TES<>'554'"

cQuery += " GROUP BY F1_NODIA,F2_NODIA, "
cQuery += "       F3_EMISSAO, "
cQuery += "       F3_NFISCAL, "
cQuery += "       F3_FILIAL, "
cQuery += "       F3_SERIE, "
if lSerie2
	cQuery += " F1_SERIE2, "
	cQuery += " F2_SERIE2, "
	cQuery += " F3_SERIE2, "
endif
cQuery += If(lSerOri, " F3_SERORI, ", "")
cQuery += "       F3_CLIEFOR,"
cQuery += "       F3_LOJA,"
cQuery += "       F3_DTCANC,"
cQuery += "       E1_VENCREA,"

If !lCodSF2
	cQuery += "       CCL_CODGOV, "
Else
	cQuery += "       F2_TPDOC, "
	cQuery += "       F1_TPDOC, "
Endif

cQuery += "      A1_TIPDOC, "
cQuery += "      A1_CGC, "
cQuery += "      A1_PFISICA, "
cQuery += "      A1_NOME, "
cQuery += "      A1_EST, "
cQuery += "      F2_TXMOEDA, "
cQuery += "      F4_CALCIGV, "
cQuery += "      F3_ESPECIE, "
cQuery += "      F3_TIPO, "
cQuery += "       F1_TXMOEDA,"  
cQuery += "       F1_MOEDA, "
cQuery += "       F2_MOEDA "
cQuery += If(lCpDoc, " ,F3_TPDOC ", "")
cQuery += " ) A"
cQuery += " GROUP BY F3_FILIAL,F3_ESPECIE,F3_EMISSAO,E1_VENCREA,CCL_CODGOV,F3_SERIE2,F3_SERORI,F3_TPDOC,F3_SERIE,F3_NFISCAL,F3_CLIEFOR,F3_LOJA,F3_TIPO,A1_NOME,A1_EST,F2_TXMOEDA,F2_MOEDA,F2_NODIA,A1_TIPDOC,A1_CGC,A1_PFISICA"
cQuery += " ORDER BY CCL_CODGOV, F3_SERIE, F3_NFISCAL"

cQuery    := ChangeQuery(cQuery)


// -----------------------------------------------
// PROCESSA QUERY:
// -----------------------------------------------
ConOut('[DS2U]' + Repl('-', 50))
ConOut('EXECUTANDO QUERY PRINCIPAL: ' + Time())
ConOut(Repl('-', 50))

cAliasQry := GetNextAlias()
If !lMultiThread
	MsgRun('Por favor espere...', 'SelecciÛn de registros...', {|| DbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), cAliasQry, .F., .T.)})
Else
	DbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), cAliasQry, .F., .T.)
EndIf

ConOut(Repl('-', 50))
ConOut('EXECUTANDO QUERY PRINCIPAL (TERMINO): ' + Time())
ConOut(Repl('-', 50))

// -----------------------------------------------
// COMPATIBILIZA CAMPOS:
// -----------------------------------------------
TCSetField(cAliasQry, "F3_EMISSAO", "D")
TCSetField(cAliasQry, "E1_VENCREA", "D")
TCSetField(cAliasQry, "F3_BASIMP1", "N", 14, 2)
TCSetField(cAliasQry, "F3_BASIMP2", "N", 14, 2)
TCSetField(cAliasQry, "F3_VALIMP1", "N", 14, 2)
TCSetField(cAliasQry, "F3_VALIMP2", "N", 14, 2)
TCSetField(cAliasQry, "F3_VALCONT", "N", 14, 2)

Return(cAliasQry)


/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø±±
±±≥Funcao    ≥FISR011Trib≥ Autor ≥ V. RASPA                                ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descricao ≥Monta arquivo temporario p/ apurar "Outros Tributos"         ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function FISR011Trib(aFiliais, aParams)
Local cQuery   := ''
Local cKey     := 'F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA'
Local aStruct  := {}
Local cArqTrab := ''
Local cFiliais := ''
Local lSerie2  := SF1->(FieldPos("F1_SERIE2")) > 0 .And. SF2->(FieldPos("F2_SERIE2")) > 0 .And. SF3->(FieldPos("F3_SERIE2")) > 0 .And. GetNewPar("MV_LSERIE2", .F.)
Local lSerOri  := SF1->(FieldPos("F1_SERORI")) > 0 .And. SF2->(FieldPos("F2_SERORI")) > 0 .And. SF3->(FieldPos("F3_SERORI")) > 0

//-- Trata filiais selecionadas...
aEval(aFiliais, {|e| If(e[1], cFiliais += e[2] + '|', NIL)})
cFiliais += cFiliais + Space(TamSX3("F3_FILIAL")[1]) + '|'

// --------------------------------------------------
// MONTA QUERY P/ PROCESSAMENTO
// --------------------------------------------------
cQuery := "SELECT DISTINCT CASE WHEN SF3.F3_DTCANC = ' ' THEN SD2.D2_TOTAL ELSE 0 END AS TRIBUTO, "
cQuery += "       SF3.F3_NFISCAL, SF3.F3_SERIE, SF3.F3_CLIEFOR, SF3.F3_LOJA "

cQuery += "  FROM " + RetSQLTab('SF3')

cQuery += "  LEFT JOIN " + RetSQLTab('SD2')
cQuery += "    ON SD2.D2_DOC = SF3.F3_NFISCAL "
cQuery += "   AND SD2.D2_SERIE = SF3.F3_SERIE "
cQuery += "   AND SD2.D2_CLIENTE = SF3.F3_CLIEFOR "
cQuery += "   AND SD2.D2_LOJA = SF3.F3_LOJA "
cQuery += "   AND SD2.D2_ESPECIE = SF3.F3_ESPECIE "
cQuery += "   AND SD2.D2_FILIAL = SF3.F3_FILIAL "
cQuery += "   AND SD2.D2_TES = SF3.F3_TES "
cQuery += "   AND SD2.D_E_L_E_T_ = ' ' "

cQuery += " WHERE SF3.F3_FILIAL IN " +  FormatIn(cFiliais, '|')
cQuery += "   AND SF3.F3_EMISSAO BETWEEN '" + DtoS(aParams[1]) + "' AND '" + DtoS(aParams[2]) + "' "
//cQuery += "   AND ( ( ((SF3.F3_VALIMP1 > 0 AND SD2.D2_VALIMP1 = 0) OR (SF3.F3_VALIMP2 > 0 AND SD2.D2_VALIMP2 = 0)) AND SF3.F3_TIPOMOV = 'V' ) OR SF3.F3_TPDOC <> '') "
cQuery += "   AND SF3.D_E_L_E_T_  =  ' ' "
cQuery += "   AND SF3.F3_TIPOMOV = 'V'"
cQuery += "   AND SF3.F3_TPDOC <> ''"
cQuery += "   AND ( SF3.F3_VALIMP1 = 0 AND SF3.F3_VALIMP2 = 0 )"

cQuery += " GROUP BY SF3.F3_NFISCAL"
cQuery += " ,        SF3.F3_DTCANC"
cQuery += " ,        SF3.F3_SERIE"
cQuery += If(lSerie2, " , SF3.F3_SERIE2", "")
cQuery += If(lSerOri, " , SF3.F3_SERORI", "")
cQuery += " ,        SF3.F3_CLIEFOR"
cQuery += " ,        SF3.F3_LOJA"
cQuery += " ,        SD2.D2_TOTAL"
cQuery += " ORDER BY SF3.F3_NFISCAL"

// ---------------------------------------
// GERA ARQUIVO TEMPORARIO
// ---------------------------------------
aAdd(aStruct, {'F3_NFISCAL'	, 'C', TamSX3('F3_NFISCAL')[1]	, 0})
aAdd(aStruct, {'F3_SERIE'	, 'C', TamSX3('F3_SERIE')[1]	, 0})
aAdd(aStruct, {'F3_CLIEFOR'	, 'C', TamSX3('F3_CLIEFOR')[1]	, 0})
aAdd(aStruct, {'F3_LOJA'	, 'C', TamSX3('F3_LOJA')[1]		, 0})
aAdd(aStruct, {'TRIBUTO'	, 'N', 14, 2})
cArqTrab := CriaTrab(aStruct, .T.) // Nome do arquivo temporario

ConOut(Replicate('-', 50))
ConOut('QUERY + ARQUIVO TEMPORARIO (INICIO): ' + Time())
ConOut(Replicate('-', 50))

dbUseArea(.T., __LocalDriver, cArqTrab, cArqTrab, .F.)
Processa({|| SqlToTrb(cQuery, aStruct, cArqTrab)})
IndRegua(cArqTrab, cArqTrab, cKey,,, 'Aguarde...')

ConOut(Replicate('-', 50))
ConOut('QUERY + ARQUIVO TEMPORARIO (TERMINO): ' + Time())
ConOut(Replicate('-', 50))

Return(cArqTrab)




/*/
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥BuscaTpDoc≥ Autor ≥ Totvs                                   ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥Busca Tipo de documento de nota cancelada                   ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function BuscaTpDoc(cFil, cDoc, cSerie, cClieFor, cLoja)
Local cTpDoc    := Space(02)
Local cAliasQry := GetNextAlias()

BeginSQL Alias cAliasQry
	SELECT F2_TPDOC
	  FROM %Table:SF2% SF2
	 WHERE SF2.F2_FILIAL = %Exp:cFil%
	   AND SF2.F2_DOC = %Exp:cDoc%
	   AND SF2.F2_SERIE = %Exp:cSerie%
	   AND SF2.F2_CLIENTE = %Exp:cClieFor%
	   AND SF2.F2_LOJA = %Exp:cLoja%
EndSQL

If !(cAliasQry)->(Eof())
	cTpDoc := (cAliasQry)->F2_TPDOC
EndIf

(cAliasQry)->(DbCloseArea())

Return(cTpDoc)

Static Function f3Param()

cPath := cGetFile( "Seleccionar directorio | ", "Seleccionar directorio" , NIL , "" , .F. , GETF_LOCALHARD + GETF_RETDIRECTORY )

Return .T.

Static Function f3RetParam()
Return cPath
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥xNCCAnul  ∫Autor  ≥Percy Arias,SISTHEL ∫ Data ≥  07/13/18   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Se creo una busqueda directo en la tabla SF1 de la NCC     ∫±±
±±∫          ≥ Anulada, pues en la SF3 el TPDOC esta en blanco            ∫±±
±±∫          ≥ Apos correccion de este llamado retirar esta funcion       ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function xNCCAnul(cFil,cDoc,cSer,cForn,cLoj)

	Local cTpDoc	:= space(TAMSX3("F1_TPDOC")[1])
	Local aArea		:= GetArea()
	local _cAlias	:= GetNextAlias()
	local cSql004	:= ""

	cSql004:= " SELECT F1_TPDOC  "
	cSql004+= " FROM "+ RetSqlName("SF1") + " SF1 "
	cSql004+= " WHERE SF1.F1_FILIAL  = '"+cFil+"' "
	cSql004+= "   AND SF1.F1_DOC     = '"+cDoc+"' "
	cSql004+= "   AND SF1.F1_SERIE   = '"+cSer+"' "
	cSql004+= "   AND SF1.F1_FORNECE = '"+cForn+"' "
	cSql004+= "   AND SF1.F1_LOJA    = '"+cLoj+"' "
	cSql004+= "   AND SF1.D_E_L_E_T_ = '*' "
	cSql004+= "   AND SF1.R_E_C_N_O_ > 0"
	
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cSql004 ), _cAlias,.T.,.T.)
	IF (_cAlias)->( !EOF() )
	   cTpDoc := (_cAlias)->F1_TPDOC
	ENDIF   
	
	(_cAlias)->( dbCloseArea() )

	RestArea(aArea)

Return(cTpDoc)

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ZFISR011  ∫Autor  ≥Microsiga           ∫ Data ≥  11/13/19   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function fValTotal(vFil,vDoc,vSer,vForn,vLoj)

	local aArea := getArea()
	local _gAlias := getnextAlias()
	local cSql004 := ""
	local nVtot := 0
	local lOk := .f.
	
	cSql004:= " SELECT COUNT(*) NCONT  "
	cSql004+= " FROM "+ RetSqlName("SF3") + " SF3 "
	cSql004+= " WHERE SF3.F3_FILIAL  = '"+vFil+"' "
	cSql004+= "   AND SF3.F3_NFISCAL = '"+vDoc+"' "
	cSql004+= "   AND SF3.F3_SERIE   = '"+vSer+"' "
	cSql004+= "   AND SF3.F3_CLIEFOR = '"+vForn+"' "
	cSql004+= "   AND SF3.F3_LOJA    = '"+vLoj+"' "
	cSql004+= "   AND SF3.D_E_L_E_T_ = ' '"
	cSql004+= "   AND SF3.R_E_C_N_O_ > 0"

	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cSql004 ), _gAlias,.T.,.T.)
	IF (_gAlias)->NCONT > 1
		lok := .t.
	ENDIF   
	(_gAlias)->( dbCloseArea() )
	
	if lok

		cSql004:= " SELECT SUM(F3_VALCONT) F3_VALCONT  "
		cSql004+= " FROM "+ RetSqlName("SF3") + " SF3 "
		cSql004+= " WHERE SF3.F3_FILIAL  = '"+vFil+"' "
		cSql004+= "   AND SF3.F3_NFISCAL = '"+vDoc+"' "
		cSql004+= "   AND SF3.F3_SERIE   = '"+vSer+"' "
		cSql004+= "   AND SF3.F3_CLIEFOR = '"+vForn+"' "
		cSql004+= "   AND SF3.F3_LOJA    = '"+vLoj+"' "
		cSql004+= "   AND SF3.D_E_L_E_T_ = ' '"
		cSql004+= "   AND SF3.R_E_C_N_O_ > 0"
		
		dbUseArea( .T., "TOPCONN", TcGenQry( ,, cSql004 ), _gAlias,.T.,.T.)
		IF (_gAlias)->( !EOF() )
			nVtot := (_gAlias)->F3_VALCONT
		ENDIF   
		
		(_gAlias)->( dbCloseArea() )
	
	endif
	
	RestArea(aArea)
	
Return(nVtot)
