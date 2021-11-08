#INCLUDE "PROTHEUS.CH"
#INCLUDE "MATR263.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR263  ³ Autor ³ Bruno Schmidt			³ Data ³ 07/10/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Registro de Inventario Permanente Valorizado.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³Data    ³ BOPS     ³ Motivo da Alteracao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Marco A. Glz³07/02/18³DMINA-1798³Se realizan modificaciones para la    ³±±
±±³            ³        ³          ³correcta impresion de Archivo/Reporte ³±±
±±³            ³        ³          ³Inventario Valorizado. (PER)          ³±±
±±³gSantacruz  ³26/03/18³DMINA-2024³Hace caso omiso del MV_PAR14 para     ³±±
±±³            ³        ³          ³generar el archivo txt.               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function zMATR263()
Local oReport	:= Nil
Local lImpR4	:= FindFunction( "TRepInUse" ) .And. TRepInUse()

Private titulo		:= STR0001
Private nomeprog	:= STR0005
Private nInd		:= 0

//Determina o uso dos campos _SERIE2 para o Peru
Private lSerie2 := GetNewPar("MV_LSERIE2",.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta Sx1 / SX5 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1()
AjustaSX5()

If lImpR4
	oReport := ReportDef()
	If Valtype( oReport ) == 'O'
		If ! Empty( oReport:uParam )
			Pergunte( oReport:uParam, .F. )
		EndIf
		oReport:PrintDialog()
	Endif
Endif
	
oReport := Nil

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³Bruno Schmidt		    ³ Data ³ 07/10/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatorio                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local aOrdem    := {}
Local cTamD1Doc := TamSX3('D1_DOC')[1]
Local cPicD1Qt  := PesqPict("SD1","D1_QUANT" ,18)
Local cTamD1Qt  := TamSX3('D1_QUANT')[1]
Local cPicD1Cust:= PesqPict("SD1","D1_CUSTO",18)
Local cTamD1Cust:= TamSX3('D1_CUSTO')[1]
Local cPicD2Qt  := PesqPict("SD2","D2_QUANT" ,18)
Local cTamD2Qt  := TamSX3('D2_QUANT')[1]
Local cPicD2Cust:= PesqPict("SD2","D2_CUSTO1",18)
Local cTamD2Cust:= TamSX3('D2_CUSTO1')[1]
Local cPicB2Qt  := PesqPictQt("B2_QATU",18)
Local oSection1 := Nil
Local oSection2 := Nil
Local oSection3 := Nil
Local oReport   := Nil
Local oCell     := Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se utiliza custo unificado por Empresa/Filial       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lCusUnif := IIf(FindFunction("A330CusFil"),A330CusFil(),GetMV("MV_CUSFIL",.F.))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta perguntas no SX1 a fim de preparar o relatorio p/     ³
//³ custo unificado por empresa                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCusUnif
	MTR263CUnf(lCusUnif)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := TReport():New("MATR263",SubStr(STR0001,1,94),"MTR263",{|oReport| IIf(IIf(Empty(MV_PAR15),.T.,Len(Alltrim(MV_PAR15)) >= 4 .And. Len(Alltrim(MV_PAR15)) < 8) ,ReportPrint(oReport),VerPerg())}, "")// "Formato 13.1: Registro de inventario permanente valorizado – Detalle del inventario valorizado" - validação 4 digitos na pergunta estabelecimento
oReport:SetLandscape()    
oReport:SetTotalInLine(.F.)
oReport:lFooterVisible := .F.	// Não imprime rodapé do protheus

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                     ³
//³ mv_par01         // Do produto                           ³
//³ mv_par02         // Ate o produto                        ³
//³ mv_par03         // Do tipo                              ³
//³ mv_par04         // Ate o tipo                           ³
//³ mv_par05         // Da data                              ³
//³ mv_par06         // Ate a data                           ³
//³ mv_par07         // Qual Local (almoxarifado)            ³
//³ mv_par08         // Do  Grupo                            ³
//³ mv_par09         // Ate o Grupo                          ³
//³ mv_par10         // Qual moeda imprimir ( 1 a 5 )        ³
//³ mv_par11         // Qual Custo ? ( Medio / Reposicao )   ³
//³ mv_par12         // Seq.de Impresao (Digitacao /Calculo )³
//³ mv_par13         // Metodo de Avaliacao 		         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte( Padr("MTR263",10),.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao da Sessao 1 - Dados do Produto                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1 := TRSection():New(oReport,STR0063,{"SB1","SB2"}) //"Cabecalio"
oSection1 :SetTotalInLine(.F.)
oSection1 :SetReadOnly()
oSection1 :SetLineStyle()
oSection1 :SetHeaderPage()
oSection1 :NCOLS:=1

TRCell():New(oSection1,"CODIGO"		 ,"   ",STR0071	,/*Picture*/,TAMSX3("B1_COD")[1],/*lPixel*/,/*{|| code-block de impressao }*/)		// "CODIGO DE EXISTENCIA"
TRCell():New(oSection1,"TIPO"		 ,"   ",STR0058+STR0028,/*Picture*/,30         		,/*lPixel*/,/*{|| code-block de impressao }*/)	// "TIPO"  " (TABLA 5)"
TRCell():New(oSection1,"DESC"		 ,"   ",STR0072	,/*Picture*/,TAMSX3("B1_DESC")[1],/*lPixel*/,/*{|| code-block de impressao }*/)	// "DESCRIPCION"
TRCell():New(oSection1,"CODUN"       ,"   ",STR0073	,/*Picture*/,30         		,/*lPixel*/,/*{|| code-block de impressao }*/)		// "CODIGO DE LA UNIDAD DE MEDIDA (TABLA 6)"
TRCell():New(oSection1,"METVAL"      ,"   ",STR0016 ,/*Picture*/,30,   				,/*lPixel*/,/*{|| code-block de impressao }*/)		// "Método de Valuación
TRCell():New(oSection1,"ESTABL"      ,"   ","CODIGO DEL ESTABLECIMIENTO" ,/*Picture*/,50,   				,/*lPixel*/,/*{|| code-block de impressao }*/)		// "cODIGO DEL ESTABLECIMIENTO

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao da Sessao 2 - Cont. dos dados do Produto           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection2 := TRSection():New(oSection1,STR0064,{"SB1","SB2"}) //"Produtos (Parte 2)"
oSection2 :SetTotalInLine(.F.)
oSection2 :SetReadOnly()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao da Sessao 3 - Movimentos                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection3 := TRSection():New(oSection2,STR0065,{"SD1","SD2","SD3"}) //"Movimentação dos Produtos"
oSection3 :SetTotalInLine(.F.)
oSection3 :SetTotalText(STR0021) //"T O T A I S  :"
oSection3 :SetReadOnly()

oSection3 :NCOLS:=1 
TRCell():New(oSection1," "	,"",SPACE(80),/*Picture*/,80,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1," "	,"",SPACE(80),/*Picture*/,80,/*lPixel*/,/*{|| code-block de impressao }*/) 
TRCell():New(oSection1," "	,"",Replicate("_",50),/*Picture*/,80,/*lPixel*/,/*{|| code-block de impressao }*/) 
TRCell():New(oSection1," "	,"",STR0082 + CRLF + STR0083 + CRLF + Replicate("_",50),/*Picture*/,80,/*lPixel*/,/*{|| code-block de impressao }*/) //"DOCUMENTO DE TRASLADO, COMPROBANTE DE PAGO,       :" - "DOCUMENTO INTERNO O SIMILAR                       :"
oSection3 :NCOLS:=0

TRCell():New(oSection3,"dDtMov"		,"   ",STR0040				,/*Picture*/,13         ,/*lPixel*/,/*{|| code-block de impressao }*/)	//"FECHA"
TRCell():New(oSection3,"Tipo"		,"   ",STR0058+CRLF+STR0029	,"@!"	,8			,/*lPixel*/,/*{|| code-block de impressao }*/)  // "TIPO" "(TAB.10)"
TRCell():New(oSection3,"cCF"		,"   "," "					,"@!"		,4/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  // "C.F"
TRCell():New(oSection3,"SERIE"		,"   ",STR0074				,"@!"		,20			,/*lPixel*/,/*{|| code-block de impressao }*/)	// "SERIE"
TRCell():New(oSection3,"cDoc"		,"   ",STR0044				,"@!"		,cTamD1Doc	,/*lPixel*/,/*{|| code-block de impressao }*/)	//"DOCUMENTO" "NUMERO"
TRCell():New(oSection3,"cTraco1"	,"   ","|"+CRLF+"|"			,/*Picture*/,1			,/*lPixel*/,{|| "|" })
TRCell():New(oSection3,"TpOper"		,"   ",STR0041+CRLF+STR0053 ,"@!"		,2			,/*lPixel*/,/*{|| code-block de impressao }*/)   // "TP.OPERAC." "(TABLA 12)"
TRCell():New(oSection3,"cTraco1"	,"   ","|"+CRLF+"|"			,/*Picture*/,1			,/*lPixel*/,{|| "|" })
TRCell():New(oSection3,"nENTQtd"	,"   "," *=========="+CRLF+STR0046	,cPicD1Qt	,cTamD1Qt	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"cTraco2"	,"   ",CRLF+"|"			,/*Picture*/,1			,/*lPixel*/,{|| "|" })
TRCell():New(oSection3,"nCusMovEnt"	,"   ",STR0045+CRLF+STR0027	,cPicD1Cust	,cTamD1Cust	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"cTraco3"	,"   ",CRLF+"|"			,/*Picture*/,1			,/*lPixel*/,{|| "|" })
TRCell():New(oSection3,"nENTCus"	,"   "," ===========*"+CRLF+STR0047	,cPicD1Cust	,cTamD1Cust	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"cTraco4"	,"   ","|"+CRLF+"|"			,/*Picture*/,1			,/*lPixel*/,{|| "|" })
TRCell():New(oSection3,"nSAIQtd"	,"   "," *=========="+CRLF+STR0046	,cPicD2Qt	,cTamD2Qt	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"cTraco5"	,"   ",CRLF+"|"			,/*Picture*/,1			,/*lPixel*/,{|| "|" })
TRCell():New(oSection3,"nCusMovSai"	,"   ",STR0050+CRLF+STR0027	,cPicD1Cust	,cTamD1Cust	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"cTraco6"	,"   ",CRLF+"|"			,/*Picture*/,1			,/*lPixel*/,{|| "|" })
TRCell():New(oSection3,"nSAICus"	,"   "," ===========*"+CRLF+STR0047	,cPicD2Cust	,cTamD2Cust	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"cTraco7"	,"   ","|"+CRLF+"|"			,/*Picture*/,1			,/*lPixel*/,{|| "|" })                                   
TRCell():New(oSection3,"nSALDQtd"	,"   "," *=========="+CRLF+STR0046	,cPicD1Qt	,cTamD1Qt	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"cTraco8"	,"   ",CRLF+"|"			,/*Picture*/,1			,/*lPixel*/,{|| "|" })
TRCell():New(oSection3,"nSALDCus"	,"   ",STR0051+" FINAL"+CRLF+STR0027,cPicD1Cust	,cTamD1Cust	,/*lPixel*/,/*{|| code-block de impressao }*/) // "SALDO"###"COSTO UNITARIO"
TRCell():New(oSection3,"cTraco9"	,"   ",CRLF+"|"			,/*Picture*/,1			,/*lPixel*/,{|| "|" })
TRCell():New(oSection3,"TcusTot"	,"   "," ===========*"+CRLF+STR0047	,cPicD1Cust ,cTamD1Cust,/*lPixel*/,/*{|| code-block de impressao }*/) // "SALDO"###"COSTO TOTAL"

TRFunction():New(oSection3:Cell("nENTQtd"),NIL,"SUM",/*oBreak*/,"",cPicD1Qt	,/*uFormula*/,.T.,.F.) 
TRFunction():New(oSection3:Cell("nENTCus"),NIL,"SUM",/*oBreak*/,"",cPicD1Cust	,/*uFormula*/,.T.,.F.) 

TRFunction():New(oSection3:Cell("nSAIQtd"),NIL,"SUM",/*oBreak*/,"",cPicD2Qt	,/*uFormula*/,.T.,.F.) 
TRFunction():New(oSection3:Cell("nSAICus"),NIL,"SUM",/*oBreak*/,"",cPicD2Cust	,/*uFormula*/,.T.,.F.) 

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³Bruno Schmidt	 	    ³ Data ³ 07/10/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport)

Local oSection1	:= oReport:Section(1) 
Local oSection2	:= oReport:Section(1):Section(1)  
Local oSection3	:= oReport:Section(1):Section(1):Section(1) 
Local cSelectD1	:= '', cWhereD1 := '%%'
Local cSelectD2	:= '', cWhereD2 := '%%', cD2EMISSAO := ''
Local cSelectD3	:= '', cWhereD3 := '%%'
Local cWhereRE	:= ''
Local cAlias	:= ''
Local cProdAnt	:= ''
Local cLocalAnt	:= ''
Local cSeqIni	:= '999999'

Local CprodAux	:= ''
Local nTipo		:= 0
Local nEntrada	:= 0
Local nSaida	:= 0
Local nCEntrada	:= 0 
Local nCSaida	:= 0
Local nTam		:= 18
Local cPicB2Qt2	:= PesqPictQt("B2_QTSEGUM" ,nTam)
Local aSalAtu	:= {0,0,0,0,0,0,0}
Local lQuery	:= .F.
Local nTamCod	:= TamSX3("B1_COD")[1]
Local lUsaD2DIG	:= IIF(FindFunction("UsaD2DTDIG"), UsaD2DTDIG(), .F.)
Local cDepTrf	:= SuperGetMv("MV_DEPTRANS",.F.,"95")	// Dep.transferencia
Local aArea		:= GetArea()

Local cRUC			:= ""
Local cRAZONSOCIAL	:= "" 
Local cESTAB		:= ""
Local cCODIGO		:= ""
Local lTranSB2		:= SuperGetMv("MV_TRANSB2" ,.F.,.F.)	// Atualiza saldos de transferencia
Local lLocProc		:= .F.
Local lOnlyLocP		:= .F.
Local lInverte		:= .F.
Local lInverteMov	:= .F.
Local cTP			:= ""
Local nSalIni		:= 0
Local nQtIni		:= 0
Local nX			:= 0
Local lSele			:= .F.
Local cSerKINV		:= SuperGetMv("MV_SERKINV", .F., "")    
Local cSerKTM		:= SuperGetMv("MV_SERKTM", .F., "")

Local cTmpSD1Fil	:= ""
Local cTmpSD2Fil	:= ""
Local cTmpSD3Fil	:= ""

Local lRet			:= .T.
Local cFilialProd	:= ""
Local cEstabProd	:= ""

#IFNDEF TOP
	Local cCondicao := ''
#ELSE
	Local cAliasTop := ''
#ENDIF

oReport:SetCustomText( {|| Cabec263( oReport ) })

Private aSelFil		:= {}
Private bBloco := { |nV,nX| Trim(nV)+IIf(Valtype(nX)='C',"",Str(nX,1)) }
Private nDecs  := MsDecimais(mv_par10)
Private aLocal := {}
Private nTamLocal := SB1->(Len(B1_LOCPAD))
Private aLocalFil := {}
Private aLocalFiR := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³MV_CUSREP - Parametro utilizado para habilitar o calculo do   ³
//³            Custo de Reposicao.                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private lCusRep  := SuperGetMv("MV_CUSREP",.F.,.F.) .And. (FindFunction("MA330AvRep") .And. MA330AvRep())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se utiliza custo unificado por Empresa/Filial       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private lCusUnif := IIf(FindFunction("A330CusFil"),A330CusFil(),GetMV("MV_CUSFIL",.F.))
lCusUnif :=	lCusUnif .And. mv_par07 == "**"

If lRet .And. Empty(mv_par15) .And. Len( aSelFil ) <= 0
	aSelFil := AdmGetFil()
	If Len( aSelFil ) <= 0
		lRet := .F.
	EndIf
Else
	aSelFil := {cFilAnt} 
EndIf

#IFDEF TOP
	MV_PAR07 := SelLocal(ALLTRIM(MV_PAR07),aSelFil)
    lSele := .F.
    For nX:=1 To Len(aLocal)
   	    IF aLocal[nX,1]
           lSele:=.T.
           EXIT
        ENDIF
    NEXT       
    IF ! lSele
       MV_PAR07 := "('"+PADR('01',nTamLocal)+"')"
    ENDIF   
#ELSE
	IF MV_PAR07=='**'
		MsgBox(STR0069,STR0068,'Info')  // 'Para base CODE, parametro de armazem não pode ser Todos' 'Atencao'
		RETURN()
	ENDIF
#ENDIF

lLocProc  := GetMv("MV_LOCPROC") $ MV_PAR07
lOnlyLocP := Alltrim(MV_PAR07) == "('"+Alltrim(GetMv("MV_LOCPROC"))+"')"
      
oReport:SetTitle(OemToAnsi(STR0008)+OemToAnsi(STR0009) + Iif(lCusUnif,"",OemToAnsi(STR0011)+" "+mv_par07))     // ""Registro de Inventario Permanente Valorizado""###"(SEQUENCIA)"###"ARMAZEM:"
oReport:SetTitle(oReport:Title()+STR0017+STR0004+STR0018+AllTrim(&("MV_SIMB"+Str(mv_par10,1)))+")") //" (Por "###" ,em "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Genera segundo arquivo de Trabalho                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB1")
dbSetOrder(1) //B1_FILIAL+B1_COD
Set Softseek On
dbseek(cFilialProd+mv_par01)
Set Softseek Off
cCond1:="SB1->B1_COD"
cCond2:="mv_par02"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera arquivo de Trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTamQ:=TamSX3("B2_QATU")
aTamT:=TamSX3("B2_VFIM1")
aTamC:=TamSX3("B2_CM1")
aTamX:=TamSX3("F4_CF")
aTamF:=TamSX3("A2_COD")
aTamL:=TamSX3("A2_LOJA")
aTamP:=TamSX3("B2_FILIAL")

aCampos := {}
AADD(aCampos,{"FILIAL"  ,"C",aTamP[1],aTamP[2]})
AADD(aCampos,{"PRODUTO"  ,"C",nTamCod,0})
AADD(aCampos,{"EMISSAO"  ,"D",08,0})
AADD(aCampos,{"SEQCALC"  ,"C",14,0})
AADD(aCampos,{"NUMSEQ"   ,"C",14,0})
AADD(aCampos,{"TES"      ,"C",03,0})
AADD(aCampos,{"CF"       ,"C",aTamX[1],aTamX[2]})
AADD(aCampos,{"TIPODOC"  ,"C",03,0})
AADD(aCampos,{"NUMDOC"   ,"C",TamSX3('D1_DOC')[1],0})
AADD(aCampos,{"SERIE"    ,"C",03,0})
AADD(aCampos,{"QUANT"    ,"N",aTamQ[1],aTamQ[2]})
AADD(aCampos,{"CUSTOTAL" ,"N",aTamT[1],aTamT[2]})
AADD(aCampos,{"CLIFOR"   ,"C",aTamF[1],aTamF[2]})
AADD(aCampos,{"LOJA"     ,"C",aTamL[1],aTamL[2]})
AADD(aCampos,{"NODIA"    ,"C",10,0})
AADD(aCampos,{"CUSFINAL" ,"N",aTamT[1],aTamT[2]})
AADD(aCampos,{"CUSTUNI"  ,"N",aTamT[1],aTamT[2]})
AADD(aCampos,{"CUSTINI"  ,"N",aTamT[1],aTamT[2]})
AADD(aCampos,{"DTDIGIT1" ,"D",08,0})
AADD(aCampos,{"SERIE2"   ,"C",20,0})
AADD(aCampos,{"SERIE3"   ,"C",20,0})
AADD(aCampos,{"XLOCAL"   ,"C",TamSX3('B2_LOCAL')[1],0})
AADD(aCampos,{"XTPESTAB" ,"C",TamSX3('NNR_TIPOES')[1],0})
AADD(aCampos,{"XIDESTAB" ,"C",TamSX3('NNR_IDSUNA')[1],0})
AADD(aCampos,{"XITEM" 	 ,"C",10,0})


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatório                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Transforma parametros Range em expressao SQL                            ³	
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeSqlExpr(oReport:uParam)
		cAliasTop := "TRC"
	lQuery := .T.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatorio da secao 1                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):BeginQuery()	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Complemento do SELECT da tabela SD1                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cSelectD1 := "%
   	If mv_par10 == 1
		If lCusRep .And. mv_par11 == 2
			//cSelectD1 += " sum(D1_CUSRP1) CUSTOTAL,"
			cSelectD1 += " sum(D1_CUSRP1) CUSTOTAL "
		Else
			//cSelectD1 += " sum(D1_CUSTO) CUSTOTAL,"
			cSelectD1 += " sum(D1_CUSTO) CUSTOTAL "
		EndIf	
   	Else
		If lCusRep .And. mv_par11 == 2
   			//cSelectD1 += " sum(D1_CUSRP"+str(mv_par10,1)+") CUSTOTAL,"
   			cSelectD1 += " sum(D1_CUSRP"+str(mv_par10,1)+") CUSTOTAL "
   		Else
   			//cSelectD1 += " sum(D1_CUSTO"+str(mv_par10,1)+") CUSTOTAL,"
   			cSelectD1 += " sum(D1_CUSTO"+str(mv_par10,1)+") CUSTOTAL "
   		EndIf	
   	EndIf	
   	cSelectD1 += "%"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Complemento do Where da tabela SD1                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	cWhereD1 := "%" 
	If !lCusUnif
   		cWhereD1 += " SD1.D1_LOCAL IN "+mv_par07+" AND "
	EndIf
	cWhereD1 += " SD1.D1_FILIAL " + GetRngFil( aSelFil, "SD1", .T., @cTmpSD1Fil ) +  " AND "
	
	cWhereD1 += "%"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Complemento do SELECT da tabela SD2                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lCusRep .And. mv_par11 == 2
	    cSelectD2 := "% sum(D2_CUSRP"
	    cSelectD2 += Str(mv_par10,1) + ")"// Coloca a Moeda do Custo
	Else
	    cSelectD2 := "% sum(D2_CUSTO"
	    cSelectD2 += Str(mv_par10,1) + ")" // Coloca a Moeda do Custo
	EndIf
	//cSelectD2 += " CUSTOTAL,"
	cSelectD2 += " CUSTOTAL "
    cSelectD2 += "%"
	// Verifica se usa o campo D2_DTDIGIT ou nao, de acordo com a funcao UsaD2DTDIG
    If lUsaD2DIG
    	cD2EMISSAO := "% D2_DTDIGIT EMISSAO,%"
    Else
    	cD2EMISSAO := "% D2_EMISSAO EMISSAO,%"
    EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Complemento do Where da tabela SD2                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	cWhereD2 := "%" 
	If !lCusUnif
		cWhereD2 += " SD2.D2_LOCAL IN "+mv_par07+" AND "
	EndIf
	// Verifica se usa o campo D2_DTDIGIT ou nao, de acordo com a funcao UsaD2DTDIG
    If lUsaD2DIG
		cWhereD2 += " SD2.D2_DTDIGIT >= '"+Dtos(mv_par05)+"' AND "
		cWhereD2 += " SD2.D2_DTDIGIT <= '"+Dtos(mv_par06)+"' AND "
	Else
		cWhereD2 += " SD2.D2_EMISSAO >= '"+Dtos(mv_par05)+"' AND "
		cWhereD2 += " SD2.D2_EMISSAO <= '"+Dtos(mv_par06)+"' AND "
	EndIf
	cWhereD2 += " SD2.D2_FILIAL " + GetRngFil( aSelFil, "SD2", .T., @cTmpSD2Fil )+  " AND "
	
	cWhereD2 += "%"    
	
	cWhereRE := "%" 
	cWhereRE += " (SD2.D2_REMITO   = '" + Space(TamSx3('D2_REMITO')[1]) + "' OR SD2.D2_TPDCENV IN ('1','A')) "	
	cWhereRE += "%" 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Complemento do SELECT da tabelas SD3                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lCusRep .And. mv_par11 == 2
		cSelectD3 := "% sum(D3_CUSRP"
		cSelectD3 += Str(mv_par10,1)  + ")"// Coloca a Moeda do Custo
	Else
		cSelectD3 := "% sum(D3_CUSTO"
		cSelectD3 += Str(mv_par10,1)  + ")"// Coloca a Moeda do Custo
	EndIf	
	//cSelectD3 += " CUSTOTAL, "	
	cSelectD3 += " CUSTOTAL "	
	cSelectD3 += "%"    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Complemento do WHERE da tabela SD3                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    cWhereD3 := "%"
   	If !lCusUnif
   		If lLocProc  
   			cWhereD3 += " (SD3.D3_LOCAL IN "+mv_par07+" OR SD3.D3_CF IN ('RE3','DE3')) AND"
   		Else
   			cWhereD3 += " SD3.D3_LOCAL IN "+mv_par07+" AND"
   		EndIf
   	EndIf
	If !lTranSB2 
		cWhereD3 += " SD3.D3_LOCAL <> '"+cDepTrf+"' AND"
	EndIf
   	If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
   		cWhereD3 += " SD3.D3_ESTORNO <> 'S' AND"
   	EndIf  
	If SuperGetMV('MV_D3SERVI', .F., 'N') == 'N' .And. IntDL()
		cWhereD3 += " ( (D3_SERVIC = '   ') OR (D3_SERVIC <> '   ' AND D3_TM <= '500' AND D3_STSERV = '3') ) AND"
	EndIf
	cWhereD3 += " SD3.D3_FILIAL " + GetRngFil( aSelFil, "SD3", .T., @cTmpSD3Fil )+  " AND "
		      	
	cWhereD3 += "%"	

	cOrder := "%"
   	If mv_par12 == 1
   		If UPPER(TcGetDB()) != "INFORMIX"
			cOrder += " PRODUTO,FILIAL,EMISSAO,NODIA,NUMSEQ,TES"// Modificado por Walmar de Freitas. 26092019: Agregado el NODIA para evitar los errores en los correlativos.
   		Else
   			cOrder += " 1,3, 4, 5"
   		EndIf
   	Else                                 
    	If UPPER(TcGetDB()) != "INFORMIX"
   			cOrder += " PRODUTO,FILIAL,SEQCALC,NODIA,TES"    // Modificado por Walmar de Freitas. 26092019: Agregado el NODIA para evitar los errores en los correlativos.
    	Else
      		cOrder += " 1,3, 5 "
       	EndIf	
	EndIf
	cOrder += "%"
	
	cWhereTP := "%"
	cWhereGR := "%"
	cPar18 := ""
	cPar19 := ""
	
	If !empty(MV_PAR18)
		cPar18 := RetiraChar(MV_PAR18)
		cPar18 := "'"+Replace(ALLTRIM(cPar18),"/","','")+"'"
	EndIf

	If !empty(MV_PAR19)
		cPar19 := RetiraChar(MV_PAR19)
		cPar19 := "'"+Replace(ALLTRIM(cPar19),"/","','")+"'"
	EndIf
	
	if !empty(cPar18)
		cWhereTP += " SB1.B1_TIPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
		cWhereTP += " SB1.B1_TIPO NOT IN ("+cPar18+") AND "
	else
		cWhereTP += " SB1.B1_TIPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
	endif

	if !empty(cPar19)
		cWhereGR += " SB1.B1_GRUPO BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' AND "
		cWhereGR += " SB1.B1_GRUPO NOT IN ("+cPar19+") AND "
	else
		cWhereGR += " SB1.B1_GRUPO BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' AND "
	endif
	
	cWhereTP += "%"
	cWhereGR += "%"	

	BeginSql Alias cAliasTop
	
		SELECT 	 
			     D1_FILIAL FILIAL,
			     B1_TIPO TIPO, 				
		         D1_COD PRODUTO,
		         D1_SEQCALC SEQCALC,
		         D1_NUMSEQ NUMSEQ,
		         D1_DTDIGIT EMISSAO,
		         D1_TES TES,
		         D1_CF CF, 
		         D1_ESPECIE TIPODOC,
		         D1_DOC NUMDOC,
		         D1_SERIE SERIE,
		         SUM(D1_QUANT) QUANT,
		         D1_FORNECE CLIFOR,
		         D1_LOJA LOJA,
		         F1_NODIA NODIA,
		         F1_SERIE2 SERIE2,		
		         D1_DTDIGIT DTDIGIT1,
		         D1_LOCAL XLOCAL,
		         D1_ITEM XITEM,
				 %Exp:cSelectD1%
				 
		FROM %table:SD1% SD1,%table:SF4% SF4,%table:SB1% SB1,%table:SF1% SF1

		WHERE SD1.D1_COD     >= %Exp:mv_par01% 	AND
              SD1.D1_COD     <= %Exp:mv_par02% AND        
		      %Exp:cWhereD1%
		      SD1.D1_DTDIGIT >= %Exp:mv_par05% 	AND
			  SD1.D1_DTDIGIT <= %Exp:mv_par06%	AND		
			  SD1.D1_ORIGLAN <> 'LF'           	AND
			  SD1.D1_REMITO  = ' '             	AND
			  SD1.D1_TIPO_NF >= ' '            	AND
			  SD1.%NotDel%						AND
			  SF4.F4_FILIAL  =  %xFilial:SF4%	AND 	
			  SF4.F4_CODIGO  = SD1.D1_TES 		AND
			  SF4.F4_ESTOQUE = 'S' 				AND
			  SF4.%NotDel%                     	AND      
			  SB1.B1_FILIAL  =  %xFilial:SB1%	AND 	
			  %Exp:cWhereTP%
			  SB1.B1_COD     = SD1.D1_COD 		AND
		      %Exp:cWhereGR%
              SB1.%NotDel%    AND
              SF1.F1_FILIAL = SD1.D1_FILIAL  AND
	          SF1.F1_DOC = SD1.D1_DOC   AND
		      SF1.F1_SERIE = SD1.D1_SERIE AND 				
		      SF1.F1_FORNECE = SD1.D1_FORNECE  AND 
		      SF1.F1_LOJA = SD1.D1_LOJA      AND   	 		
		      SF1.F1_TIPO = SD1.D1_TIPO      AND     
		      SF1.%NotDel%
		      
		//GROUP BY D1_FILIAL,B1_TIPO,D1_COD,D1_SEQCALC,D1_NUMSEQ,D1_DTDIGIT,D1_TES,D1_CF,D1_ESPECIE,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_DTDIGIT,F1_NODIA,F1_SERIE2
		GROUP BY D1_FILIAL,B1_TIPO,D1_COD,D1_SEQCALC,D1_NUMSEQ,D1_DTDIGIT,D1_TES,D1_CF,D1_ESPECIE,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,F1_NODIA,F1_SERIE2,D1_DTDIGIT,D1_LOCAL,D1_ITEM

	    UNION
	    
		SELECT 	
				D2_FILIAL FILIAL,
				B1_TIPO TIPO,
		        D2_COD PRODUTO,
		        D2_SEQCALC SEQCALC,
		        D2_NUMSEQ NUMSEQ,
		        %Exp:cD2EMISSAO%
		        D2_TES TES,
		        D2_CF CF,
		        D2_ESPECIE TIPODOC,
		        D2_DOC NUMDOC,
		        D2_SERIE SERIE,
		        SUM(D2_QUANT) QUANT,
		        D2_CLIENTE CLIFOR,
		        D2_LOJA LOJA,		        	
		        F2_NODIA NODIA,        
		        F2_SERIE2 SERIE2,
		        D2_DTDIGIT DTDIGIT1,
		        D2_LOCAL XLOCAL,
		        D2_ITEM XITEM,
				%Exp:cSelectD2%	
				
    	FROM %table:SD2% SD2,%table:SF4% SF4,%table:SB1% SB1,%table:SF2% SF2

		 WHERE SD2.D2_COD     >= %Exp:mv_par01% 	AND
              SD2.D2_COD     <= %Exp:mv_par02% AND         
		      %Exp:cWhereD2%
			  SD2.D2_ORIGLAN <> 'LF'           	AND
			  %Exp:cWhereRE%                    	AND
			  SD2.%NotDel%						AND
			  SF4.F4_FILIAL  =  %xFilial:SF4%	AND 	
			  SF4.F4_CODIGO  = SD2.D2_TES 		AND
			  SF4.F4_ESTOQUE = 'S' 				AND
			  SF4.%NotDel%                     	AND      
			  SB1.B1_FILIAL  =  %xFilial:SB1%	AND 	
			  %Exp:cWhereTP%
			  SB1.B1_COD     = SD2.D2_COD 		AND
		      %Exp:cWhereGR%
              SB1.%NotDel%  AND
              SF2.F2_FILIAL = SD2.D2_FILIAL  AND
		      SF2.F2_DOC = SD2.D2_DOC   AND  
		      SF2.F2_SERIE = SD2.D2_SERIE AND 
		      SF2.F2_CLIENTE = SD2.D2_CLIENTE  AND 
		      SF2.F2_LOJA = SD2.D2_LOJA      AND 	
		      SF2.F2_TIPO = SD2.D2_TIPO      AND	  
              SF2.%NotDel% 
        
        //GROUP BY D2_FILIAL,B1_TIPO,D2_COD,D2_SEQCALC,D2_NUMSEQ,D2_EMISSAO,D2_TES,D2_CF,D2_ESPECIE,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,D2_UM,D2_DTDIGIT,F2_NODIA,F2_SERIE2
        GROUP BY D2_FILIAL,B1_TIPO,D2_COD,D2_SEQCALC,D2_NUMSEQ,D2_EMISSAO,D2_TES,D2_CF,D2_ESPECIE,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,D2_UM,F2_NODIA,F2_SERIE2,D2_DTDIGIT,D2_LOCAL,D2_ITEM

		UNION		
	
		SELECT 	
				D3_FILIAL FILIAL,
				B1_TIPO TIPO,
		        D3_COD PRODUTO,
		        D3_SEQCALC SEQCALC,
		        D3_NUMSEQ NUMSEQ,
		        D3_EMISSAO EMISSAO, 
		        D3_TM TES, 
		        D3_CF CF, 
		        D3_CF TIPODOC,
		        D3_DOC NUMDOC,
		        ' ' SERIE,
		        SUM(D3_QUANT) QUANT,
				' ' CLIFOR,
				' ' LOJA,
				D3_NODIA NODIA,		
				' ' SERIE2, 
				D3_EMISSAO DTDIGIT1,
				D3_LOCAL XLOCAL,
				' ' XITEM,
				%Exp:cSelectD3%			

		FROM %table:SD3% SD3,%table:SB1% SB1
		
		WHERE SD3.D3_COD     >= %Exp:mv_par01% 	AND
              SD3.D3_COD     <= %Exp:mv_par02% AND
		      SD3.D3_EMISSAO >= %Exp:mv_par05% 	AND
			  SD3.D3_EMISSAO <= %Exp:mv_par06%	AND
			  %Exp:cWhereD3%                      
			  SD3.%NotDel%						AND
			  SB1.B1_FILIAL  =  %xFilial:SB1%	AND 	
			  %Exp:cWhereTP%
			  SB1.B1_COD     = SD3.D3_COD 		AND
		      %Exp:cWhereGR%
              SB1.%NotDel%                     	                       

		GROUP BY D3_FILIAL,B1_TIPO,D3_COD,D3_SEQCALC,D3_NUMSEQ,D3_EMISSAO,D3_TM,D3_CF,D3_CF,D3_DOC,D3_UM,D3_EMISSAO,D3_NODIA,D3_EMISSAO,D3_LOCAL
//		ORDER BY %Exp:cOrder%
		ORDER BY PRODUTO,NODIA, EMISSAO		
	EndSql 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Metodo EndQuery ( Classe TRSection )                                    ³
	//³                                                                        ³
	//³Prepara o relatorio para executar o Embedded SQL.                       ³
	//³                                                                        ³
	//³ExpA1 : Array com os parametros do tipo Range                           ³
	//³                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
	
	aEval(aCampos, {|e| IIf(e[2]!= "C", TCSetField("TRC", e[1], e[2],e[3],e[4]),Nil)})
	MTR263FillTrb(aCampos)	
		
#ELSE
	dbSelectArea("SB2")
	dbSetOrder(1) //B2_FILIAL+B2_COD+B2_LOCAL 
	
	dbSelectArea("SD1")
	dbSetOrder(5) //D1_FILIAL+D1_COD+D1_LOCAL+D1_NUMSEQ
	
	dbSelectArea("SD2")
	dbSetOrder(1) //D2_FILIAL+D2_COD+D2_LOCAL+D2_NUMSEQ
	
	dbSelectArea("SD3")
	dbSetOrder(3) //D3_FILIAL+D3_DOC+D3_COD

	cNomeArq:=CriaTrab(aCampos)
		
	dbUseArea( .T., __cRDDNTTS, cNomeArq, "TRB", IIf(.F. .Or. .F., !.F., NIL), .F. )
    
   // Modificado por Walmar de Freitas. 26092019: Agregado el NODIA para evitar los errores en los correlativos.
	If mv_par12 == 1
		IndRegua("TRB",cNomeArq,'PRODUTO+FILIAL+Dtos(EMISSAO)+NODIA+NUMSEQ+TES',,,STR0019)  //"Selecionando Registros..."
	Else
		IndRegua("TRB",cNomeArq,'PRODUTO+FILIAL+SEQCALC+NODIA+TES',,,STR0019)  //"Selecionando Registros..."
	Endif	
	
	dbSelectArea("SB1")
	dbSetOrder(1) //B1_FILIAL+B1_COD
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Transforma parametros Range em expressao Advpl                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeAdvplExpr(oReport:uParam)

	cCondicao := 'B1_FILIAL == "'+xFilial("SB1")+'".And.' 
	cCondicao += 'B1_COD >= "'+mv_par01+'".And.B1_COD <="'+mv_par02+'".And.'
	cCondicao += 'B1_TIPO >= "'+mv_par03+'".And.B1_TIPO <="'+mv_par04+'" .And. ' 
	oReport:Section(1):SetFilter(cCondicao,IndexKey())
	
	DbSelectArea("SB1")
	While !Eof() 

   		dbSelectArea("SB2")
	   	dbSeek(cFilialProd+SB1->B1_COD+IIf(lCusUnif,"",mv_par07))
    	
	   	lGravado  := .F.
   		cProdAnt  := SB1->B1_COD
		cLocalAnt := SB2->B2_LOCAL

		dbSelectArea("SD1")
		dbSeek(cFilialProd+SB1->B1_COD+IIf(lCusUnif,"",SB2->B2_LOCAL))
		dbSelectArea("SD2")
	   	dbSeek(cFilialProd+SB1->B1_COD+IIf(lCusUnif,"",SB2->B2_LOCAL))
   		dbSelectArea("SD3")
	   	dbSeek(cFilialProd+SB1->B1_COD+IIf(lCusUnif,"",SB2->B2_LOCAL))

	   	dbSelectArea("SD1")
	   	dbSeek(xFilial("SD1")+SB1->B1_COD+IIf(lCusUnif,"",SB2->B2_LOCAL))

   		While ! Eof() .And. D1_FILIAL == xFilial("SD1") .And. D1_COD == cProdAnt .And. IIf(lCusUnif,.T.,D1_LOCAL == cLocalAnt)

			dbSelectArea("SF4")
			dbSeek(cFilialProd+SD1->D1_TES)
			dbSelectArea("SD1")

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Para paises do MercoSul, desprezar as Notas Fiscais que foram ³
			//³ ingressadas por Remitos de Salida...                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        	If ! Empty(D1_REMITO)
           		dbSkip()
	           	Loop
        	EndIf
        	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//| Notas geradas pelo EIC considerar somente notas de FOB       |
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        	If D1_TIPO_NF $ '6789AB'
           		dbSkip()
	           	Loop
        	EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Despreza Notas Fiscais Lancadas Pelo Modulo do Livro Fiscal  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If D1_ORIGLAN $ "LF" .Or. SF4->F4_ESTOQUE != "S"
         		dbSkip()
	         	Loop
    		Else
         		If D1_DTDIGIT < mv_par05 .Or. D1_DTDIGIT > mv_par06
            		dbSkip()
					loop
				Else
					cSeqIni := IIf(mv_par12 == 1, D1_NUMSEQ, D1_SEQCALC+D1_NUMSEQ)
					cAlias := Alias()
	         	EndIf
			EndIf

			dbSelectArea("TRB")
			RecLock("TRB",.T.)
			If alltrim(SD1->D1_ESPECIE) $ "FT/NF"
	        	cTipoDoc := "FAC"
			Else
         		cTipoDoc := SD1->D1_ESPECIE
			EndIf
     	   
			Replace PRODUTO   With SD1->D1_COD
			Replace SEQCALC   With SD1->D1_SEQCALC
			Replace NUMSEQ    With SD1->D1_NUMSEQ
			Replace EMISSAO   With SD1->D1_DTDIGIT
			Replace TES       With SD1->D1_TES
			Replace CF        With SD1->D1_CF
			Replace TIPODOC   With cTipoDoc
			Replace NUMDOC    With SD1->D1_DOC
			Replace SERIE     With SD1->D1_SERIE
			Replace QUANT     With SD1->D1_QUANT
			Replace NODIA     With SF1->F1_NODIA
			Replace CUSFINAL  With 0
			Replace CUSTUNI   With 0
			Replace CUSTINI   With 0
			Replace SERIE2    With SF1->F1_SERIE2
			Replace DTDIGIT1  With SD1->D1_DTDIGIT
			//if SF1->( FieldPos("F1_YSERIE") ) > 0
			//	Replace SERIE3    With SF1->F1_YSERIE
			//else
				Replace SERIE3    With ''
			//endif
			If SD1->D1_QUANT > 0
				If mv_par10 == 1
					If lCusRep .And. mv_par11 == 2
		       			Replace CUSTOTAL With SD1->D1_CUSRP1
                	Else
		       			Replace CUSTOTAL With SD1->D1_CUSTO
		       		EndIf	
				ElseIf mv_par10 == 2
					If lCusRep .And. mv_par11 == 2
		       			Replace CUSTOTAL With SD1->D1_CUSRP2
                	Else
		           		Replace CUSTOTAL With SD1->D1_CUSTO2
		           	EndIf	
				ElseIf mv_par10 == 3
					If lCusRep .And. mv_par11 == 2
		       			Replace CUSTOTAL With SD1->D1_CUSRP3
                	Else
	            		Replace CUSTOTAL With SD1->D1_CUSTO3
	            	EndIf	
				ElseIf mv_par10 == 4
					If lCusRep .And. mv_par11 == 2
		       			Replace CUSTOTAL With SD1->D1_CUSRP4
                	Else
		         		Replace CUSTOTAL With SD1->D1_CUSTO4
		         	EndIf	
				ElseIf mv_par10 == 5
					If lCusRep .And. mv_par11 == 2
		       			Replace CUSTOTAL With SD1->D1_CUSRP5
                	Else
		    			Replace CUSTOTAL With SD1->D1_CUSTO5
		    		EndIf	
				EndIf
			Else
         		If mv_par10 == 1
					If lCusRep .And. mv_par11 == 2
		       			Replace CUSTOTAL With SD1->D1_CUSRP1
                	Else
		         		Replace CUSTOTAL With SD1->D1_CUSTO
		         	EndIf	
	        	ElseIf mv_par10 == 2
					If lCusRep .And. mv_par11 == 2
		       			Replace CUSTOTAL With SD1->D1_CUSRP2
                	Else
		         		Replace CUSTOTAL With SD1->D1_CUSTO2
		         	EndIf	
     	      	ElseIf mv_par10 == 3
					If lCusRep .And. mv_par11 == 2
		       			Replace CUSTOTAL With SD1->D1_CUSRP3
                	Else
		           		Replace CUSTOTAL With SD1->D1_CUSTO3
		           	EndIf	
     	      	ElseIf mv_par10 == 4
					If lCusRep .And. mv_par11 == 2
		       			Replace CUSTOTAL With SD1->D1_CUSRP4
                	Else
	    	        	Replace CUSTOTAL With SD1->D1_CUSTO4
	    	        EndIf	
	         	ElseIf mv_par10 == 5
					If lCusRep .And. mv_par11 == 2
		       			Replace CUSTOTAL With SD1->D1_CUSRP5
                	Else
	          			Replace CUSTOTAL With SD1->D1_CUSTO5
	          		EndIf	
	         	EndIf
			Endif
      	   
			MsUnLock()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  		//³ Control para imprimir sin movimientos                   ³
	    	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	     	lGravado := .T.

			dbSelectArea("SD1")
			dbSkip()
		EndDo
  		dbSelectArea("SD2")
		dbSeek(xFilial("SD2")+SB1->B1_COD+IIf(lCusUnif,"",SB2->B2_LOCAL))

		While ! Eof() .And. D2_FILIAL == xFilial("SD2") .And. D2_COD == cProdAnt .And. IIf(lCusUnif,.T.,D2_LOCAL == cLocalAnt)

			dbSelectArea("SF4")
			dbSeek(cFilialProd+SD2->D2_TES)
	    	dbSelectArea("SD2")

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	    	//³ Para paises do MercoSul, desprezar as Notas Fiscais que foram ³
			//³ ingressadas por Remitos de Salida...                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ! Empty(D2_REMITO) .And. !(D2_TPDCENV $ "1A")
				SD2->(DbSkip())
		  		Loop
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  		//³ Despreza Notas Fiscais Lancadas Pelo Modulo do Livro Fiscal  ³
	      	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	      	If D2_ORIGLAN == "LF" .Or. SF4->F4_ESTOQUE != "S"
				SD2->(DbSkip())
		       	Loop
			Else
	      		If IIf(lUsaD2DIG, D2_DTDIGIT, D2_EMISSAO) < mv_par05 .or. IIf(lUsaD2DIG, D2_DTDIGIT, D2_EMISSAO) > mv_par06
	       			dbSkip()
		         	loop
				Else
     	    		If mv_par12 == 1
		          	 	If D2_NUMSEQ < cSeqIni
    	          			cSeqIni := D2_NUMSEQ
	    	            	cAlias	:= Alias()
	     	    	    Endif
	              	Else
    		           	If D2_SEQCALC+D2_NUMSEQ < cSeqIni
            	    		cSeqIni := D2_SEQCALC+D2_NUMSEQ
	            	     	cAlias	:= Alias()
	     	            Endif
					EndIf
     			EndIf
			Endif		

			dbSelectArea("TRB")

			RecLock("TRB",.T.)
			If alltrim(SD2->D2_ESPECIE) $ "FT/NF"
	    		cTipoDoc := "FAC"
			Else
         		cTipoDoc := SD2->D2_ESPECIE
			EndIf
     	   
			Replace PRODUTO   With SD2->D2_COD
	      	Replace SEQCALC   With SD2->D2_SEQCALC
     	   	Replace NUMSEQ    With SD2->D2_NUMSEQ 
	      	Replace EMISSAO   With IIf(lUsaD2DIG, SD2->D2_DTDIGIT, SD2->D2_EMISSAO)
	      	Replace TES       With SD2->D2_TES
     	   	Replace CF        With SD2->D2_CF
	      	Replace TIPODOC   With cTipoDoc
     	  	Replace NUMDOC    With SD2->D2_DOC
	      	Replace SERIE     With SD2->D2_SERIE
     	   	Replace QUANT	  With SD2->D2_QUANT
     	   	Replace NODIA     With SF2->F2_NODIA
     	   	Replace CUSFINAL  With 0
     	   	Replace CUSTUNI   With 0
     	   	Replace CUSTINI   With 0
     	   	Replace SERIE2    With SF2->F2_SERIE2
     	   	Replace DTDIGIT1  With SD2->D2_DTDIGIT
     	   	Replace SERIE3    With ""  	     	   	
	      	If SD2->D2_QUANT <> 0
				If mv_par10 == 1
					If lCusRep .And. mv_par11 == 2
		       			Replace CUSTOTAL With SD2->D2_CUSRP1
                	Else
		            	Replace CUSTOTAL With SD2->D2_CUSTO1
		            EndIf	
				ElseIf mv_par10 == 2
					If lCusRep .And. mv_par11 == 2
		       			Replace CUSTOTAL With SD2->D2_CUSRP2
                	Else
	        			Replace CUSTOTAL With SD2->D2_CUSTO2
	        		EndIf	
				ElseIf mv_par10 == 3
					If lCusRep .And. mv_par11 == 2
		       			Replace CUSTOTAL With SD2->D2_CUSRP3
                	Else
	         			Replace CUSTOTAL With SD2->D2_CUSTO3
	         		EndIf	
	        	ElseIf mv_par10 == 4
					If lCusRep .And. mv_par11 == 2
		       			Replace CUSTOTAL With SD2->D2_CUSRP4
                	Else
	          			Replace CUSTOTAL With SD2->D2_CUSTO4
	          		EndIf	
	         	ElseIf mv_par10 == 5
					If lCusRep .And. mv_par11 == 2
		       			Replace CUSTOTAL With SD2->D2_CUSRP5
                	Else
	     	    		Replace CUSTOTAL With SD2->D2_CUSTO5
	     	    	EndIf	
         		EndIf
			Endif
			MsUnLock()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Controle para imprimir sin movimientos                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lGravado := .T.

			dbSelectArea("SD2")
			dbSkip()
		EndDo

		dbSelectArea("SD3")
		dbSeek(cFilialProd+SB1->B1_COD+IIf(lCusUnif,"",SB2->B2_LOCAL))

		While !Eof()  .And. D3_FILIAL == xFilial("SD3") .And. D3_COD == cProdAnt .And. IIf(lCusUnif,.T.,D3_LOCAL == cLocalAnt)

			If !D3Valido()
   				SD3->(DbSkip())
	     		Loop
        	Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Nao imprimir os produtos que estao no armazem de transito                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If cPaisLoc <> "BRA" .And. !lTranSB2 .And. AllTrim(SD3->D3_LOCAL) == AllTrim(cDepTrf)
				dbSkip()
				Loop
			EndIf	
		
			If D3_EMISSAO < mv_par05 .Or. D3_EMISSAO > mv_par06
				dbSkip()
	   			Loop
	      	Else
				If mv_par12 == 1
		   			If D3_NUMSEQ < cSeqIni
     	 				cSeqIni := D3_NUMSEQ
        	  			cAlias := Alias()
	        	    EndIf
	      		Else
        			If D3_SEQCALC+D3_NUMSEQ < cSeqIni
		          		cSeqIni := D3_SEQCALC+D3_NUMSEQ
     		            cAlias := Alias()
     		        EndIf
	   			EndIf
			EndIf

			dbSelectArea("TRB")
   			RecLock("TRB",.T.)
	    	Replace PRODUTO   With SD3->D3_COD
	    	Replace SEQCALC   With SD3->D3_SEQCALC
     	   	Replace NUMSEQ    With SD3->D3_NUMSEQ 
	      	Replace EMISSAO   With SD3->D3_EMISSAO
     	   	Replace TES       With SD3->D3_TM
	      	Replace CF        With SD3->D3_CF
	      	Replace TIPODOC   With SD3->D3_CF
			Replace NUMDOC    With SD3->D3_DOC
     		Replace SERIE     With ""
			Replace QUANT     With SD3->D3_QUANT
			Replace DTDIGIT1  With SD3->D3_EMISSAO
			Replace SERIE3    With ""
			Replace SERIE2    With SD3->SERIE2
	      	If mv_par10 == 1
				If lCusRep .And. mv_par11 == 2
	       			Replace CUSTOTAL With SD3->D3_CUSRP1
               	Else
			      	Replace CUSTOTAL With SD3->D3_CUSTO1
			    EndIf	
	    	ElseIf mv_par10 == 2
				If lCusRep .And. mv_par11 == 2
	       			Replace CUSTOTAL With SD3->D3_CUSRP2
               	Else
		    	  	Replace CUSTOTAL With SD3->D3_CUSTO2
		    	EndIf  	
	  	   	ElseIf mv_par10 == 3
				If lCusRep .And. mv_par11 == 2
	       			Replace CUSTOTAL With SD3->D3_CUSRP3
               	Else
			 	  	Replace CUSTOTAL With SD3->D3_CUSTO3
			 	EndIf  	
		   	ElseIf mv_par10 == 4
				If lCusRep .And. mv_par11 == 2
	       			Replace CUSTOTAL With SD3->D3_CUSRP4
               	Else
		  		  	Replace CUSTOTAL With SD3->D3_CUSTO4
		  		EndIf  	
	  	   	ElseIf mv_par10 == 5
				If lCusRep .And. mv_par11 == 2
	       			Replace CUSTOTAL With SD3->D3_CUSRP5
               	Else
			 	  	Replace CUSTOTAL With SD3->D3_CUSTO5
			 	EndIf  	
	      	EndIf
	      	MsUnLock()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Control para imprimir sin movimientos                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lGravado := .T.

			dbSelectArea("SD3")
			dbSkip()
		EndDo
	   	dbSelectArea("SB1")
   		dbSkip()
	EndDo
#ENDIF		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB1") 
dbSetOrder(1) //B1_FILIAL+B1_COD
SB1->(dbSeek(xFilial()+mv_par01,.T.))

/*
If MV_PAR14 == 1 //Lista productos sin movimiento
	M263SemMov()
EndIf
*/

dbSelectArea("TRB")
oReport:SetMeter(TRB->(LastRec()))
dbGoTop()

DBSelectArea("SX5")
SX5->(MsSeek(xFilial("SX5")+"P6"+Alltrim( MV_PAR13 )))

If AllTrim(str(MV_PAR16)) $ "2/3"

	While !oReport:Cancel() .And. !("TRB")->(Eof()) 
	
		oSection3:Cell("nSALDQtd"):SetValue(0)			
		oSection3:Cell("nSALDCus"):SetValue(0)
		oSection3:Cell("TcusTot") :SetValue(0)
		oSection3:Cell("nSAIQTD") :SetValue(0)
		nEntradas := 0
		nSalidas  := 0
		nCEntrada := 0
		nCSalidas := 0
		lImpCabec := .T.
		
		cProduto := TRB->PRODUTO
	
		If TRB->FILIAL <> cFilialProd
			cFilialProd := TRB->FILIAL
			aLocalFiR := LocFilial(mv_par07,TRB->FILIAL,TRB->PRODUTO)
	    EndIF 

		If TRB->XIDESTAB <> cEstabProd
			cEstabProd := TRB->XIDESTAB
	    EndIF 
	    
		SB1->(MsSeek(xFilial()+TRB->PRODUTO))
		If SB1->B1_GRUPO < MV_PAR08 .Or. SB1->B1_GRUPO > MV_PAR09
			TRB->(dbSkip())
			loop
		EndIf
	
		SB5->(MsSeek(TRB->FILIAL+TRB->PRODUTO))
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Tratamento para produtos sem movimentacao ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//If TRB->NUMDOC == "***SEM-MOV***"
		//If MV_PAR14 == 1 //Lista productos sin movimiento
			If ALLTRIM(TRB->NUMDOC) == "*SINMOV*"
			
				aSalAtu   := {0,0,0,0,0,0,0}
				nQtini :=0
				nSalIni:=0
				
				For nX:=1 To Len(aLocalFiR)
					IF aLocalFiR[nX,1]
					   aSalatu1:=fCalcEst(SB1->B1_COD,aLocalFiR[nX,2],MV_PAR05,TRB->FILIAL)
					   nQtIni +=aSalAtu1[1]           // QUANTIDADE 
					   nSalIni+=aSalAtu1[MV_PAR10+1]  // VALOR 
					ENDIF
				Next     
				
				if nQtini == 0
					TRB->(dbSkip())
					loop
				endif
				
				aSalAtu[1]         +=nQtIni
				aSalAtu[mv_par10+1]+=nSalIni

				oSection1:Init()
				oSection1:Cell("CODIGO"):SetValue(SB1->B1_COD)
				oSection1:Cell("TIPO")  :SetValue(fTabla5(SB1->B1_TIPO))
				oSection1:Cell("DESC")  :SetValue(SB1->B1_DESC)
				oSection1:Cell("CODUN") :SetValue(fTabla6(SB1->B1_UM)) 
				oSection1:Cell("METVAL") :SetValue(Alltrim( MV_PAR13 )+' - '+Posicione("SX5",1,xFilial("SX5")+"P6"+Alltrim(MV_PAR13),"SX5->X5_DESCSPA") )
				oSection1:Cell("ESTABL") :SetValue(TRB->XIDESTAB +' - '+ Posicione("SX5",1,xFilial("SX5")+"XZ"+TRB->XTPESTAB,"SX5->X5_DESCSPA") )
				
				oSection1:PrintLine()
				oSection1:Finish()
				
				oSection3:Init()
				oSection3:Cell("dDtMov")	:SetValue(MV_PAR05)  // STR0020 "SALDO INICIAL"
				oSection3:Cell("Tipo")   	:SetValue(' ')
				oSection3:Cell("cCF")   	:SetValue(' ')
				oSection3:Cell("SERIE")	    :SetValue(' ')
				oSection3:Cell("cDoc")	    :SetValue(' ')
				oSection3:Cell("cTraco1")	:SetValue(' ')
				oSection3:Cell("TpOper")	:SetValue('16')
				oSection3:Cell("cTraco1")	:SetValue(' ')
				oSection3:Cell("nSALDQtd")	:Hide()
				oSection3:Cell("cTraco2")	:SetValue(' ')
				oSection3:Cell("nCusMovEnt"):Hide()
				oSection3:Cell("cTraco3")	:SetValue(' ')
				oSection3:Cell("TcusTot")	:Hide()
				oSection3:Cell("cTraco4")	:SetValue(' ')
				oSection3:Cell("nSAIQtd")	:Hide()
				oSection3:Cell("cTraco5")	:SetValue(' ')
				oSection3:Cell("nCusMovSai"):Hide()
				oSection3:Cell("cTraco6")	:SetValue(' ')
				oSection3:Cell("nSAICus")	:SetValue(0)
				oSection3:Cell("nSAICus")	:Hide()
				oSection3:Cell("cTraco7")	:SetValue(' ')
				oSection3:Cell("nSALDCus")	:Hide()
				oSection3:Cell("nENTQtd")	:Show()
				oSection3:Cell("nENTQtd")	:SetValue(nQtIni)
				oSection3:Cell("nCusMovEnt"):Show()
				oSection3:Cell("nENTCus")	:Show()
				oSection3:Cell("nENTCus")	:SetValue(nSalIni)
				oSection3:Cell("nSALDqtd")	:Show()
				oSection3:Cell("nSALDqtd")	:SetValue(nQtIni)
				oSection3:Cell("nSALDCus")	:Show()
				oSection3:Cell("tcusTot")	:Show()
				oSection3:Cell("tcusTot")	:SetValue(nSalIni)
				If nQtIni<>0
					oSection3:Cell("nCusMovEnt"):SetValue(nSalIni/nQtini)
					oSection3:Cell("nSALDCus"):SetValue(nSalIni/nQtini)
				Else
					oSection3:Cell("nCusMovEnt"):SetValue(0)
					oSection3:Cell("nSALDCus"):SetValue(0)  
				EndIf
				oSection3:Cell("cTraco8"):SetValue(' ')
				oSection3:Cell("cTraco9"):SetValue(' ')
				oSection3:PrintLine()
				oReport:PrintText(STR0023)	//"NO HUBO MOVIMIENTO PARA ESTE PRODUCTO"
				oSection3:Finish()
				oReport:ThinLine()
	
				TRB->(dbSkip())
				loop
			EndIf
		//endif
		
		If oReport:Cancel()
			Exit
		EndIf
		CprodAux := " "
		If !lQuery .Or. (lQuery .And. TRB->PRODUTO == SB1->B1_COD)
			
			//While !Eof() .And. TRB->PRODUTO == cProduto .and. TRB->FILIAL == CFilialProd
			While TRB->(!Eof()) .And. TRB->PRODUTO == cProduto .and. TRB->XIDESTAB == cEstabProd
		
				If oReport:Cancel()
					Exit
				EndIf				
				
				oReport:IncMeter()  
				
				If CprodAux <> SB1->B1_COD     
				//If ((cFilialProd <> TRB->XIDESTAB).Or.(AllTrim(TRB->PRODUTO) <> AllTrim(cProd)))
	
	                aSalAtu   := {0,0,0,0,0,0,0}
	
					oSection1:Init()
					oSection1:Cell("CODIGO"):SetValue(SB1->B1_COD)
	
					oSection1:Cell("TIPO")  :SetValue(fTabla5(SB1->B1_TIPO))
					oSection1:Cell("DESC")  :SetValue(SB1->B1_DESC)
					oSection1:Cell("CODUN") :SetValue(fTabla6(SB1->B1_UM))
					oSection1:Cell("METVAL") :SetValue(Alltrim( MV_PAR13 )+' - '+Posicione("SX5",1,xFilial("SX5")+"P6"+Alltrim(MV_PAR13),"SX5->X5_DESCSPA") )
					oSection1:Cell("ESTABL") :SetValue(TRB->XIDESTAB +' - '+ Posicione("SX5",1,xFilial("SX5")+"XZ"+TRB->XTPESTAB,"SX5->X5_DESCSPA") )
					oSection1:PrintLine()
					CprodAux:= SB1->B1_COD
	
	                nQtini :=0
	                nSalIni:=0
	                
	         		For nX:=1 To Len(aLocalFiR)
	        			IF aLocalFiR[nX,1]
	                  	   aSalatu1 := fCalcEst(SB1->B1_COD,aLocalFiR[nX,2],MV_PAR05,TRB->FILIAL)
	                       nQtIni += aSalAtu1[1]           // QUANTIDADE 
	                       nSalIni += aSalAtu1[MV_PAR10+1]  // VALOR 
		                ENDIF
		            Next     
	                
	                aSalAtu[1]         +=nQtIni
	                aSalAtu[mv_par10+1]+=nSalIni
	               
	                
	                // Guarda o valor para o arquivo TXT
	                RecLock("TRB",.F.) 
	                CUSTINI := nQtIni	
					TRB->(MsUnlock())
	                
	    			oSection3:Init()
					oSection3:Cell("dDtMov")	:SetValue(MV_PAR05)
					oSection3:Cell("Tipo")   	:SetValue(' ')
					oSection3:Cell("cCF")   	:SetValue(' ')
					oSection3:Cell("SERIE")	    :SetValue(' ')
					oSection3:Cell("cDoc")	    :SetValue(' ')
					oSection3:Cell("cTraco1")	:SetValue(' ')
					oSection3:Cell("TpOper")	:SetValue('16')
					oSection3:Cell("cTraco1")	:SetValue(' ')
					oSection3:Cell("nSALDQtd")	:Hide()
					oSection3:Cell("cTraco2")	:SetValue(' ')
					oSection3:Cell("nCusMovEnt"):Hide()
					oSection3:Cell("cTraco3")	:SetValue(' ')
					oSection3:Cell("TcusTot")	:Hide()
					oSection3:Cell("cTraco4")	:SetValue(' ')
					oSection3:Cell("nSAIQtd")	:Hide()
					oSection3:Cell("cTraco5")	:SetValue(' ')
					oSection3:Cell("nCusMovSai"):Hide()
					oSection3:Cell("cTraco6")	:SetValue(' ')
			        oSection3:Cell("nSAICus")	:SetValue(0)
					oSection3:Cell("nSAICus")	:Hide()
					oSection3:Cell("cTraco7")	:SetValue(' ')
					oSection3:Cell("nSALDCus")	:Hide()
	
	   				oSection3:Cell("nENTQtd")	:Show()
	     			oSection3:Cell("nENTQtd")	:SetValue(nQtIni)
	   				oSection3:Cell("nCusMovEnt"):Show()
	   				oSection3:Cell("nENTCus")	:Show()
	   				oSection3:Cell("nENTCus")	:SetValue(nSalIni)
	   				oSection3:Cell("nSALDqtd")	:Show()
	     			oSection3:Cell("nSALDqtd")	:SetValue(nQtIni)
	   				oSection3:Cell("nSALDCus")	:Show()
	   				oSection3:Cell("tcusTot")	:Show()
	   				oSection3:Cell("tcusTot")	:SetValue(nSalIni)
	                IF nQtIni<>0
		   				oSection3:Cell("nCusMovEnt"):SetValue(nSalIni/nQtini)
	    				oSection3:Cell("nSALDCus"):SetValue(nSalIni/nQtini)
					ELSE
	    				oSection3:Cell("nCusMovEnt"):SetValue(0)
	    				oSection3:Cell("nSALDCus"):SetValue(0)
					ENDIF
	
					oSection3:Cell("cTraco8"):SetValue(' ')
					oSection3:Cell("cTraco9"):SetValue(' ')
					oSection3:PrintLine()
				
				EndIf
	                       
				dbSelectArea("TRB")
		
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica la fecha para productos sin movimientos        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				oSection3:Init() 
	
				oSection3:Cell("nSAICus"):SetValue(0)
	
				If lQuery
				 	If alltrim(TIPODOC) $ "FT/NF"     
				    	TIPODOC := "FAC"
				 	EndIf
			  	EndIf
				If CtoD("  /  /  ") != EMISSAO
	
					oSection3:Cell("dDtMov"):SetValue(EMISSAO)
					If !(Alltrim(CF) $ "DE3|RE3")
						oSection3:Cell("cCF")   :SetValue(TIPODOC)
					EndIf								
	
					// ----------------------------------------------------------------------------------- //
					// Adicionado por SISTHEL para impresion de la serie 3 ( campo customizado )		   //
					// ----------------------------------------------------------------------------------- //
					_cSerieNf := TRB->SERIE
					If TRB->TES > "500" // Documentos de Salida
						_cSerieNf := getSerie2("1/3/4/5/6/7")
					Else 
						_cSerieNf := getSerie2("2")
					EndIf

					If Empty(_cSerieNf)
						If lSerie2 .And. !Empty(AllTrim(TRB->SERIE2))
							_cSerieNf := AllTrim(TRB->SERIE2)
						Elseif  !Empty(AllTrim(TRB->SERIE))
							_cSerieNf := AllTrim(TRB->SERIE)
						Else
							_cSerieNf := "0"
						EndIf
					Endif
			                      
					If Alltrim(TRB->NUMDOC) $ "INVENT" .AND. Alltrim(TRB->CF) $ "DE0|RE0"
				    	_cSerieNf :=  Alltrim(cSerKINV)
					Elseif Alltrim(TRB->CF) $ "DE0|DE1|DE4|DE6|ER0|PR0|RE0|RE1|RE4|RE6"
						_cSerieNf :=  Alltrim(cSerKTM)
					EndIf

					If len(Alltrim(_cSerieNf))==3
						_cSerieNf += "0"+alltrim(_cSerieNf)
					EndIf
				
					oSection3:Cell("SERIE") :SetValue(_cSerieNf)
					oSection3:Cell("cDoc")  :SetValue(Right(Alltrim(NUMDOC),8))				
	
					// Tratamento para Movimentos do tipo RE3/DE3
					If Alltrim(CF) $ "DE3|RE3"
						If lLocProc .and. !lOnlyLocP .and. !lInverte
							lInverte := .T.
						Else
							lInverte := .F.
						EndIf
						oSection3:Cell("cCF")   :SetValue(TIPODOC)
						If (!lLocProc .and. Alltrim(CF) == "DE3") .or. (lOnlyLocP .and. Alltrim(CF) == "RE3") .or. (lLocProc .and. !lOnlyLocP .and. Alltrim(CF) == "DE3" .and. !lInverte) .or. (lLocProc .and. Alltrim(CF) == "RE3" .and. lInverte)
							oSection3:Cell("nENTQtd"):Show()
							oSection3:Cell("nENTCus"):Show()
							oSection3:Cell("nENTQtd"):SetValue(QUANT)			
							oSection3:Cell("nENTCus"):SetValue(Round(CUSTOTAL,aTamT[2]))					            
		
							nCusto := 0
			            	If QUANT != 0
							   	nCusto := Round(CUSTOTAL,aTamT[2])/QUANT
							   	oSection3:Cell("nCusMovSai"):Hide()
							  	oSection3:Cell("nCusMovEnt"):Show()
							  	oSection3:Cell("nCusMovEnt"):SetValue(nCusto)		               
			    	        Else 
			    	        	oSection3:Cell("nCusMovSai"):Hide()
							  	oSection3:Cell("nCusMovEnt"):Hide()
							  	oSection3:Cell("nCusMovEnt"):SetValue(0)		               	    	        
			    	        EndIf
							oSection3:Cell("nSAIQtd"):Hide()
							oSection3:Cell("nSAICus"):Hide()
							oSection3:Cell("nSAIQtd"):SetValue(0)			
							oSection3:Cell("nSAICus"):SetValue(0)
							If Alltrim(CF) == "RE3"
								oSection3:Cell("cCF")   :SetValue(TIPODOC+"*")
							EndIf
						Else
				   			nCusto := 0
				            If QUANT != 0
							   	nCusto := Round(CUSTOTAL,aTamT[2])/QUANT
							   	oSection3:Cell("nCusMovEnt"):Hide()
							  	oSection3:Cell("nCusMovSai"):Show()
							  	oSection3:Cell("nCusMovSai"):SetValue(nCusto)		               	        	       
			    	        Else
			    	        	oSection3:Cell("nCusMovEnt"):Hide()
							  	oSection3:Cell("nCusMovSai"):Hide()
							  	oSection3:Cell("nCusMovSai"):SetValue(0)		               	    	        
			            	EndIf
		
							If Alltrim(CF) == "DE3"
								oSection3:Cell("cCF")   :SetValue(TIPODOC+"*")
							EndIf
							oSection3:Cell("nSAIQtd"):Show()
							oSection3:Cell("nSAICus"):Show()
							oSection3:Cell("nSAIQtd"):SetValue(QUANT)			
							oSection3:Cell("nSAICus"):SetValue(Round(CUSTOTAL,aTamT[2]))										            
		
							oSection3:Cell("nENTQtd"):Hide()
							oSection3:Cell("nENTCus"):Hide()
							oSection3:Cell("nENTQtd"):SetValue(0)			
							oSection3:Cell("nENTCus"):SetValue(0)
						EndIf
					 	If (!lLocProc .and. Alltrim(CF) == "DE3") .or. (lOnlyLocP .and. Alltrim(CF) == "RE3") .or. (lLocProc .and. !lOnlyLocP .and. Alltrim(CF) == "DE3" .and. !lInverte) .or. (lLocProc .and. Alltrim(CF) == "RE3" .and. lInverte)
							aSalAtu[1] += QUANT
							aSalAtu[mv_par10+1] += IIF(QUANT >0,( QUANT * nCusto ),Round(CUSTOTAL,aTamT[2]))
							aSalAtu[7] += ConvUm(SB1->B1_COD,QUANT,0,2)
					 	Else
							aSalAtu[1] -= QUANT
							aSalAtu[mv_par10+1] -= Round(CUSTOTAL,aTamT[2])  
							aSalAtu[7] -= ConvUm(SB1->B1_COD,QUANT,0,2)
					 	EndIf
					EndIf
					
					// Demais movimentos
					If !(Alltrim(CF) $ "DE3|RE3")
						If TES <= "500"
								oSection3:Cell("nENTQtd"):Show()
							oSection3:Cell("nENTCus"):Show()
							oSection3:Cell("nENTQtd"):SetValue(QUANT)			
							oSection3:Cell("nENTCus"):SetValue(Round(CUSTOTAL,aTamT[2]))					            
							nCusto := 0
			            	If QUANT != 0
							   	nCusto := Round(CUSTOTAL,aTamT[2])/QUANT
							   	oSection3:Cell("nCusMovSai"):Hide()
							  	oSection3:Cell("nCusMovEnt"):Show()
							  	oSection3:Cell("nCusMovEnt"):SetValue(nCusto)		               
			    	        Else 
			    	        	oSection3:Cell("nCusMovSai"):Hide()
							  	oSection3:Cell("nCusMovEnt"):Hide()
							  	oSection3:Cell("nCusMovEnt"):SetValue(0)		               	    	        
			    	        EndIf
							oSection3:Cell("nSAIQtd"):Hide()
							oSection3:Cell("nSAICus"):Hide()
							oSection3:Cell("nSAIQtd"):SetValue(0)			
							oSection3:Cell("nSAICus"):SetValue(0)								
						Else                
				   			nCusto := 0
				            If QUANT != 0
							   	nCusto := Round(CUSTOTAL,aTamT[2])/QUANT
							   	oSection3:Cell("nCusMovEnt"):Hide()
							  	oSection3:Cell("nCusMovSai"):Show()
							  	oSection3:Cell("nCusMovSai"):SetValue(nCusto)		               	        	       
			    	        Else
			    	        	oSection3:Cell("nCusMovEnt"):Hide()
							  	oSection3:Cell("nCusMovSai"):Hide()
							  	oSection3:Cell("nCusMovSai"):SetValue(0)		               	    	        
			            	EndIf
		
							oSection3:Cell("nSAIQtd"):Show()
							oSection3:Cell("nSAICus"):Show()
							oSection3:Cell("nSAIQtd"):SetValue(QUANT)			
							oSection3:Cell("nSAICus"):SetValue(Round(CUSTOTAL,aTamT[2]))										            
							oSection3:Cell("nENTQtd"):Hide()
							oSection3:Cell("nENTCus"):Hide()
							oSection3:Cell("nENTQtd"):SetValue(0)			
							oSection3:Cell("nENTCus"):SetValue(0)					            					
						EndIf
					EndIf
						
					// Totalizadores
					If !(Alltrim(CF) $ "DE3|RE3")	         
					 	If TES <= "500"
							aSalAtu[1] += QUANT
							aSalAtu[mv_par10+1] += IIF(QUANT >0,( QUANT * nCusto ),Round(CUSTOTAL,aTamT[2]))
							aSalAtu[7] += ConvUm(SB1->B1_COD,QUANT,0,2)
					 	Else
							aSalAtu[1] -= QUANT
							aSalAtu[mv_par10+1] -= Round(CUSTOTAL,aTamT[2])  
							aSalAtu[7] -= ConvUm(SB1->B1_COD,QUANT,0,2)
					 	EndIf
					 EndIf
					 nSaldoT := 0 
					 nTcusTot := 0	
			        If aSalAtu[1] != 0
				        nSaldoT := (aSalAtu[mv_par10+1]/aSalAtu[1])	
						oSection3:Cell("nSALDQtd"):Show()
						oSection3:Cell("nSALDCus"):Show()
						oSection3:Cell("TcusTot") :Show()
						oSection3:Cell("nSALDQtd"):SetValue(aSalAtu[1])
						oSection3:Cell("nSALDCus"):SetValue(nSaldoT)
						nTcusTot:=Round(aSalAtu[mv_par10+1],aTamT[2])
						oSection3:Cell("TcusTot") :SetValue(nTcusTot)
					Else
						oSection3:Cell("nSALDQtd"):Show()
						oSection3:Cell("nSALDCus"):Show()
						oSection3:Cell("TcusTot") :Show()
						oSection3:Cell("nSALDQtd"):SetValue(0)			
						oSection3:Cell("nSALDCus"):SetValue(0)
						oSection3:Cell("TcusTot") :SetValue(0)		        	
		        	EndIf
	
		        	// Guarda o valor para o arquivo TXT
					RecLock("TRB",.F.) 
					CUSTUNI  := nSaldoT
					CUSFINAL := nTcusTot
					TRB->(MsUnlock())
	
					cMovto := ""
	
					If TRB->TES > "500" .And. ALLTRIM(TRB->TIPODOC) $ "REM|NF|FAC"
						cMovto := OemToAnsi(STR0030) //"CLI"
					ElseIf TRB->TES > "500" .And. ALLTRIM(TRB->TIPODOC) $ "RE0|DE0|RE8|DE8|RE3"
						cMovto := OemToAnsi(STR0032) //"CC"
					ElseIf TRB->TES <= "500" .And. ALLTRIM(TRB->TIPODOC) $ "RE6|DE6"
						cMovto := OemToAnsi(STR0034) //"MAN"
					ElseIf TRB->TES <= "500" .And. ALLTRIM(TRB->TIPODOC) $ "RE8|DE8|DE3"
						cMovto := OemToAnsi(STR0032) //"CC"
					ElseIf TRB->TES <= "500" .And. ALLTRIM(TRB->TIPODOC) $ "REM|NF|FAC"
						cMovto := OemToAnsi(STR0031) //"PROV"
					Else
						cMovto := OemToAnsi(STR0033) //"OP"
					EndIf
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Carrega os Tipos de Operacao ref. a tabela 12 da lei    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			        aArea:=Getarea()
					If ALLTRIM(TRB->TIPODOC) $ "RE4|DE4" 
						cTP:=""
						cTP:="11"
						oSection3:Cell("TpOper"):SetValue(cTP)
					ElseIf ALLTRIM(TRB->TIPODOC) $ "REM|NF|FAC|RCN|RFN"
						DbSelectArea("SF4")
						Dbsetorder(1) //F4_FILIAL+F4_CODIGO
						If dbseek(xFilial()+TRB->TES)
							oSection3:Cell("TpOper"):SetValue(SF4->F4_TPOP)
						EndIf 
					Else
						cTP:=""
					    cTP:="99"
					 	oSection3:Cell("TpOper"):SetValue(cTP)
					EndIf
			        RestArea(aArea)
		           	
		           	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Carrega os Tipos de Operacao ref. a tabela 10 da lei    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		            If ALLTRIM(TRB->TIPODOC) $ "NDI/NCC" 
		           		oSection3:Cell("TIPO"):SetValue("07")
		           	ElseIf ALLTRIM(TRB->TIPODOC) $ "FAC" 
		           		oSection3:Cell("TIPO"):SetValue("01")
	       	        ElseIf ALLTRIM(TRB->TIPODOC) $ "RCN/RTS/RTE/RCD/RFN" 
		           		oSection3:Cell("TIPO"):SetValue("09")
		            ElseIf ALLTRIM(TRB->TIPODOC) $ "NDC" 
		           		oSection3:Cell("TIPO"):SetValue("08")
		           	Else
		           		oSection3:Cell("TIPO"):SetValue("00")
		            EndIf
		            
					nEntradas += Iif(TES <= "500",QUANT,0)
		         	nSalidas  += Iif(TES >  "500",QUANT,0)
		         	nCEntrada += Iif(TES <= "500",Round(CUSTOTAL,aTamT[2]),0)
		         	nCSalidas += Iif(TES >  "500",Round(CUSTOTAL,aTamT[2]),0) 
		         	
					oSection3:PrintLine()
		         	If lInverte
		         		Loop
		         	EndIf
				EndIf
				
		     	dbSelectArea("TRB")
				dbSkip()
				
			EndDo
		EndIf	
			
		If (nEntradas + nSalidas) > 0
		   	oSection1:Finish()
			oSection2:Finish()
			oSection3:Finish()
			oReport:ThinLine()		
	
		   	If lQuery
				SB1->(DbSkip())
			EndIf   
		Else
			SB1->(DbSkip())
		EndIf
	EndDo
EndIf

If AllTrim(str(MV_PAR16))=="2"  // - IMPRESSÃO DO ARQUIVO MAGNETICO
	IF MSGYESNO(STR0084) //"¿Desea generar el Archivo Magnético?" 	   
			Processa({|| GerArq(AllTrim(MV_PAR17))}, STR0085, STR0086, .T. ) //"Espere..." - "Generando Archivo Magnético..."
	Endif
EndIf

dbSelectArea("SB1")
DbClearFilter()
dbSetOrder(1) //B1_FILIAL+B1_COD

dbSelectArea("TRB")
dbCloseArea()

If !lQuery
    Ferase(cNomeArq+GetDbExtension())	// Elimina arquivos de Trabalho
    Ferase(cNomeArq+OrdBagExt())		// Elimina arquivos de Trabalho
EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MTR263Dev³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 17/07/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Avalia se item pertence a uma nota de devolu‡ao             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR263                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MTR263Dev()
Local cAlias := Alias()
Local lRet := .F.

If cAlias == "SD1"
   dbSelectArea("SF1")
   dbSeek(cFilialProd+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA)
   If SF1->F1_TIPO == "D"
      lRet:=.T.
   EndIf
ElseIf cAlias == "SD2"
   dbSelectArea("SF2")
   dbSeek(cFilialProd+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA)
   If SF2->F2_TIPO == "D"
      lRet:=.T.
   EndIf
EndIf
dbSelectArea(cAlias)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MTR263VAlm ³ Autor ³ Lucas                 ³ Data ³19/02/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida Almoxarifado do KARDEX com relacao a custo unificado ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR263                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MTR263VAlm
LOCAL lRet:=.T.
LOCAL cConteudo:=&(ReadVar())
LOCAL nOpc:=2
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se utiliza custo unificado por Empresa/Filial       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL lCusUnif := IIf(FindFunction("A330CusFil"),A330CusFil(),GetMV("MV_CUSFIL",.F.))
If lCusUnif .And. cConteudo != "**"
	nOpc := Aviso(STR0035,STR0036,{STR0037,STR0038})	//"Aten‡„o"###"Ao alterar o almoxarifado o custo medio unificado sera desconsiderado."###"Confirma"###"Abandona"
	If nOpc == 2
		lRet:=.F.
	EndIf
EndIf
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MTR263CUnf ³ Autor ³Nereu Humberto Junior  ³ Data ³18/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Ajusta grupo de perguntas p/ Custo Unificado                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR263                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MTR263CUnf(lCusUnif)
Local aSvAlias:=GetArea()        
Local nTamSX1 :=Len(SX1->X1_GRUPO)
dbSelectArea("SX1")
If dbSeek(PADR("MTR263",nTamSX1)+"08",.F.)
	If !("MTR263VAlm" $ X1_VALID)
		RecLock("SX1",.F.)
		If Empty(X1_VALID)
			Replace X1_VALID With "MTR263VAlm"
		Else
			Replace X1_VALID With X1_VALID+".And.MTR263VAlm"
		EndIf
		MsUnlock()
	EndIf
	If lCusUnif .And. X1_CNT01 != "**"
		RecLock("SX1",.F.)
		Replace X1_CNT01 With "**"
		MsUnlock()
	EndIf
EndIf
RestArea(aSvAlias)
Return(NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MTR263NFExp ³ Autor ³Lucas				 ³ Data ³18/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Carrega arquivo TRB com resultado da Query                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR263                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MTR263FillTrb(aCampos)

	Local cNomeArq:=CriaTrab(aCampos)                                                                '
	Local aCodsPrds := {}
	Local _cAlias := getNextAlias()
	
	If Select("TRB") > 0		
		TRB->(DbCloseArea())
	EndIf
	
	NNR->( dbSetOrder(1) )
	
	// Modificado por Walmar de Freitas. 26092019: Agregado el NODIA para evitar los errores en los correlativos.		
	dbUseArea( .T., __cRDDNTTS, cNomeArq, "TRB", if(.F. .Or. .F., !.F., NIL), .F. )
	If mv_par12 == 1
		IndRegua("TRB",cNomeArq,'PRODUTO+XIDESTAB+XLOCAL+XTPESTAB+FILIAL+Dtos(EMISSAO)+NODIA+TES',,,STR0019)  //"Selecionando Registros..."
	Else
		IndRegua("TRB",cNomeArq,'PRODUTO+XIDESTAB+XLOCAL+XTPESTAB+FILIAL+SEQCALC+NODIA+TES',,,STR0019)  //"Selecionando Registros..."
	Endif
			
	DbSelectArea("TRC")
	DbGoTop()                                                             
	While !Eof()
	
		/*
		if TRC->QUANT==0
			DbSelectArea("TRC")
			DbSkip()
			Loop
		endif
		*/
	
		NNR->( MsSeek( xFilial("NNR")+TRC->XLOCAL ) )
	
		DbSelectArea("TRB")
		Reclock("TRB",.T.)
		Replace 	FILIAL 		With	TRC->FILIAL
		Replace 	PRODUTO 	With	TRC->PRODUTO
		Replace 	EMISSAO 	With	TRC->EMISSAO
		Replace 	SEQCALC 	With	TRC->SEQCALC
		Replace 	NUMSEQ 		With	TRC->NUMSEQ
		Replace 	TES 		With	TRC->TES
		Replace 	CF 			With	TRC->CF
		Replace 	TIPODOC 	With	If(AllTrim(TRC->TIPODOC) $ "FT|NF","FAC",TRC->TIPODOC)
		Replace 	NUMDOC 		With	TRC->NUMDOC
		Replace 	SERIE 		With	TRC->SERIE
		Replace 	QUANT 		With	TRC->QUANT
		Replace 	CUSTOTAL 	With	TRC->CUSTOTAL
		Replace 	CLIFOR	 	With	TRC->CLIFOR
		Replace 	LOJA		With	TRC->LOJA
		Replace 	NODIA		With	getNodiaOrig(TRC->SERIE,Right(AllTrim(TRC->NUMDOC),8),TRC->TIPODOC,TRC->CLIFOR,TRC->LOJA,TRC->NUMDOC,TRC->FILIAL)	//TRC->NODIA
		Replace		SERIE2		With    TRC->SERIE2
		Replace 	DTDIGIT1	With	TRC->DTDIGIT1 
		Replace 	XLOCAL 		With	TRC->XLOCAL
		Replace 	XTPESTAB	With	NNR->NNR_TIPOES
		Replace 	XIDESTAB	With	NNR->NNR_IDSUNA
		Replace 	XITEM 		With	TRC->XITEM
		MsUnLock()
		
		if Ascan( aCodsPrds, TRC->PRODUTO )==0
			Aadd( aCodsPrds, TRC->PRODUTO )
		endif
		
		DbSelectArea("TRC")
		DbSkip()
	End	

	M263SemMov(aCodsPrds)
	
	// --------------------------------- //
	// adiciona productos sin movimiento //
	// --------------------------------- //
	/*
	dDataAnt := mv_par06
	nMesAnt := month(mv_par06)-1
	nAnoAnt := year(mv_par06)
	if nMesAnt<1
		nMesAnt := 12
		nAnoAnt := year(mv_par06)-1
	endif
	nMesAnt := strzero(nMesAnt,2)
	nAnoAnt := strzero(nAnoAnt,4)
	
	cSql := "SELECT B9_FILIAL,B9_COD,B9_LOCAL,B9_QINI,B9_DATA,B9_VINI1"+CRLF
	cSql += "  FROM " + RetSqlName("SB9")+CRLF
	cSql += " WHERE LEFT(B9_DATA,6)='"+nAnoAnt+nMesAnt+"'"+CRLF
	cSql += "   AND D_E_L_E_T_=''"+CRLF
	If MV_PAR14 == 2 //Lista productos sin movimiento (N)
		cSql += "   AND B9_QINI<>0"+CRLF
	endif
	cSql += " ORDER BY B9_COD,B9_LOCAL"

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),_cAlias,.T.,.T.)
	
	if (_cAlias)->( !eof() )
	
		While (_cAlias)->( !Eof() )
	
			if Ascan( aCodsPrds, (_cAlias)->B9_COD ) == 0
			
				NNR->( MsSeek( xFilial("NNR")+(_cAlias)->B9_LOCAL ) )

				DbSelectArea("TRB")
				TRB->(Reclock("TRB",.T.))
				Replace 	FILIAL 		With	(_cAlias)->B9_FILIAL
				Replace 	PRODUTO 	With	(_cAlias)->B9_COD
				Replace 	EMISSAO 	With	dDataAnt
				Replace 	SEQCALC 	With	""
				Replace 	NUMSEQ 		With	TRC->NUMSEQ
				Replace 	TES 		With	"501"
				Replace 	CF 			With	""
				Replace 	TIPODOC 	With	"RE0"
				Replace 	NUMDOC 		With	"*SINMOV*"
				Replace 	SERIE 		With	""
				Replace 	QUANT 		With	(_cAlias)->B9_QINI
				Replace 	CUSTOTAL 	With	(_cAlias)->B9_VINI1
				Replace 	CLIFOR	 	With	""
				Replace 	LOJA		With	""
				Replace 	NODIA		With	""
				Replace		SERIE2		With    ""
				Replace 	DTDIGIT1	With	dDataAnt
				Replace 	XLOCAL 		With	(_cAlias)->B9_LOCAL
				Replace 	XTPESTAB	With	NNR->NNR_TIPOES
				Replace 	XIDESTAB	With	NNR->NNR_IDSUNA
				TRB->(MsUnLock())

			Endif
			
			(_cAlias)->( dbSkip() )
			
		Enddo
		
	EndIf
	
	(_cAlias)->( dbCloseArea() )
	*/

Return  

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Cabec263   ³ Autor ³ Bruno Schmidt       ³ Data ³ 15/06/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±ºDesc.     ³Cria o cabecalio da rotia		                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATR262                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Cabec263( oReport )
Local aArea		:= GetArea()
Local aCabec	:= {}
Local cChar		:= chr(160)  // caracter dummy para alinhamento do cabeçalho
Local cDescrP6  := ''
Local cPERIODO  := ''
SX3->( DbSetOrder(2) )
SX3->( MsSeek( "A1_CGC" , .T.))

cPERIODO := dtoC(mv_par05)+" a "+DtoC(mv_par06) 
 
If SM0->(Eof())                                
	SM0->( MsSeek( cEmpAnt + cFilAnt , .T. ))
Endif

If SX5->(dbSeek(xFilial("SX5")+"P6"+Alltrim( MV_PAR13 )))
	cDescrP6 := SUBSTR(TRIM(X5Descri()),1,26)
EndIf

aCabec := {	"__LOGOEMP__" ,;
			cChar + "         " + "         " + cChar + RptFolha+ TRANSFORM(oReport:Page(),'999999'),;
          	cChar + "         " + "         " + cChar, ;
          	UPPER(AllTrim(titulo)),;
          	STR0054 + cPERIODO,;
          	" RUC.: " + SM0->M0_CGC,;
          	STR0061 +Trim(SM0->M0_NOMECOM),;   // "Apellidos y nombres, Denominación o razón social: "####" / Filial:" + STR0062 + Trim(SM0->M0_FILIAL)
          	STR0016 +Alltrim( MV_PAR13 )+' - '+AllTrim(cDescrP6)+cChar} // "Método de Valuación:"
          	
          	//"__NOTRANSFORM__"+ STR0015 + SM0->M0_ENDCOB+cChar,; // "Establecimiento(1): "

RestArea( aArea )   
              
Return aCabec

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³AjustaSX1 ºAutor³		Bruno Schmidt	 º Data ³  15/06/12	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA170                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AjustaSX1()

Local aHelpPor :={}
Local aHelpEng :={}
Local aHelpSpa :={}
Local aAreaSX1 := SX1->(GetArea())
Local nTamSx1Grp:= Len(SX1->X1_GRUPO)
Local aHelpSpa01 :={}

SX1->(DbSetOrder(1))
If SX1->(dbSeek(PadR("MTR263",nTamSx1Grp)+"07"))
	aHelpSpa := {}
	aHelpSpa := {"Al informar '**' en la pregunta, se",;
				" solicitará seleccionar las Filiales",; 
				" y Depositos, que se utilizarán para",;
				" la generación del Informe y Archivo."}
	PutSX1Help("P" + ".MTR26307.", aHelpSpa, aHelpSpa, aHelpSpa, .T., "")
EndIf

If ! SX1->(dbSeek(PadR("MTR263",nTamSx1Grp)+"12"))
	aHelpPor :={}
	aHelpEng :={}
	aHelpSpa :={}
	aAdd( aHelpPor, "Considera a sequencia de impressao do" )
	aAdd( aHelpPor, "relatório: " )
	aAdd( aHelpPor, "   - Por Emissão, Entradas e Saidas" )
	aAdd( aHelpPor, "   - Por cálculo" )
	aAdd( aHelpEng, "Consider the report print sequence:" )
	aAdd( aHelpEng, "     - Per Emission, Inflow and Outflow" )
	aAdd( aHelpEng, "     - Per calculation" )
	aAdd( aHelpSpa, "Considera la secuencia de impresion del" )
	aAdd( aHelpSpa, "informe: " )
	aAdd( aHelpSpa, "   - Por Emission, Entradas y Salidas" )
	aAdd( aHelpSpa, "   - Por calculo" )

	PutSx1("MTR263", "12", "Sequencia Impressao  ?","¿Sec. Impresion ?","Printing Sequence ?","mv_chc"	,"N"	,01, 0 , ,;
			"C","","","","","mv_par12","Emissao+TES","Emission+TES","Emission+TIO","","Calculo","Calculo","Calculation","",;
			"","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
EndIf

aHelpPor :={}
aHelpEng :={}
aHelpSpa :={}
aAdd( aHelpPor, "Informe o Método de Avaliação." )
aAdd( aHelpEng, "Enter the Evaluation Method." )
aAdd( aHelpSpa, "Informe el Método de Evaluación." )

PutSX1("MTR263","13","Método de Avaliação","Método de Valuación" ,"Evaluation Method","mv_chd",;
		"C",4 ,0,0,"G"," ","P6"," "," ","mv_par13"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ",aHelpPor,aHelpEng,aHelpSpa) 

If SX1->(dbSeek(PadR("MTR263",nTamSx1Grp)+"13"))
	If AllTrim(UPPER(SX1->X1_PERSPA)) != Alltrim(Upper("Método de Valuación?"))
		Reclock("SX1",.F.)
		SX1->X1_PERSPA := "Método de Valuación?"
		SX1->(MsUnlock())
	EndIf
EndIf

aHelpPor := {}
aHelpEng := {}
aHelpSpa := {}
aHelpPor := {'Considera a lista de produtos sem',;
		     'movimentos.'}
aHelpSpa := {'Considera que la lista de productos sin',;
		     'movimientos.'}
aHelpEng := {'Considers the list of products with no',;
		     'movements.'}

PutSx1("MTR263","14", "Mostra Prods S/Movim?","¿Lista Prods S/Movim ?","Printing Sequence ?","mv_che"	,"N",01, 0 , ,"C","","","","","mv_par14",;
		"Sim","Si","Yes","","Não","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpSpa01 := {"Código de establecimiento de la filial ",; 
				"en curso. Si la pregunta está vacía, ",; 
				"se presentará una pantalla donde ",;
				"se seleccionarán las sucursales que ",;
				"se integrarán al archivo de salida."}

PutSx1( "MTR263","15","Estabelecimento (1):","Establecimiento (1).","Establishment (1)","MV_CHF",;
		"C",7,0,0,"G","","","","","mv_par15","","","","","","","","","","","","","","","","",aHelpSpa01,aHelpSpa01,aHelpSpa01)

PutSx1("MTR263","16","Gera Arquivo/Relatorio/Ambos?","¿Genera Archivo/Reporte/Ambos?","Generates File/Report/Both?","MV_CHG","N",1,0,0,"C","","","","","MV_PAR16","Arquivo","Archivo","File","",;
		"Relatorio","Reporte","Report","Ambos","Ambos","Both","","","","","","",{"Informe se deve ser gerado o Arquivo Magnetico/Relatorio/Ambos"},{"Generate a Magnetic File/Report/Ambos"},{"Informe si desea generar un Archivo Magnético/Reporte/Ambos."})

PutSx1("MTR263","17","Diretorio ?","¿Directorio?","Directory?","MV_CHH","C",40,0,0,"G","","HSSDIR","","","MV_PAR17","","","","",;
		"","","","","","","","","","","","",{"Diretorio do arquivo"},{"Directory file determination"},{"Directorio de los archivos."})

RestArea(aAreaSX1)

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³EstAtuSX5 ³ Autor ³Bruno Schmidt	        ³ Data ³ 03/10/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX5    		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao EST                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AjustaSX5()

Local aSX5   := {}                                       
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local lSX5	 := .F.

aEstrut:= { "X5_FILIAL","X5_TABELA","X5_CHAVE","X5_DESCRI","X5_DESCSPA","X5_DESCENG"}


aAdd(asx5,{Space(Len(xFilial("SX5"))),"P6","01","MÉDIA PONDERADA"					 ,"PROMEDIO PONDERADO"				  ,"WEIGHTED AVERAGE"			  })
aAdd(asx5,{Space(Len(xFilial("SX5"))),"P6","02","PRIMEIRAS ENTRADAS,PRIMEIRAS SAIDAS","PRIMERAS ENTRADAS,PRIMERAS SALIDAS","FIRST INFLOWS, FIRST OUTFLOWS"})
aAdd(asx5,{Space(Len(xFilial("SX5"))),"P6","03","EXISTÊNCIAS BASICAS"				 ,"EXISTENCIAS BASICAS"				  ,"BASIC STOCKS"	   			  })
aAdd(asx5,{Space(Len(xFilial("SX5"))),"P6","04","CONSIGNAÇÃO ENTREGUE"			   	 ,"DETALLISTA"					      ,"DETAILED"					  })
aAdd(asx5,{Space(Len(xFilial("SX5"))),"P6","05","INDENTIFICAÇÃO ESPECÍFICA"	   	 ,"INDENTIFICACIÓN ESPECÍFICA"		  ,"SPECIFIC IDENTIFICATION"	  })
aAdd(asx5,{Space(Len(xFilial("SX5"))),"P6","09","OUTROS"					 		 ,"OTROS"		   					  ,"OTHERS"		  				  })

ProcRegua(Len(aSX5))

dbSelectArea("SX5")
dbSetOrder(1)
For i:= 1 To Len(aSX5)
	If !Empty(aSX5[i][2])
		If !dbSeek(aSX5[i,1]+aSX5[i,2]+aSX5[i,3])	
			lSX5	:= .T.
			RecLock("SX5",.T.)
	   
			For j:=1 To Len(aSX5[i])		
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX5[i,j])
				EndIf
			Next j
	  
			dbCommit()        
			MsUnLock()
		EndIf			
	EndIf
Next i
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ SelLocal ³ Autor ³ MicroSiga			    ³ Data ³03.10.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Seleciona armazens										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR263                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SelLocal(cLocal1,aSelFil)  // Seleciona Armazem.

Local oDlg		:= Nil
Local cTitulo	:= STR0075 //"Selecione os Armazéns "
Local oOk		:= LoadBitmap( GetResources(), "CHECKED" )
Local oNo		:= LoadBitmap( GetResources(), "UNCHECKED" )
Local oChk1		:= Nil
Local oChk2		:= Nil
Local nOpc		:= 0
Local nX		:= 0
Local cTmpSB2Fil := "" 

Private oLbx	:= Nil  
Private lMark	:= .F.

//+-----------------------------------------------+
//| Monta a tela para usuario visualizar consulta |
//+-----------------------------------------------+
IF cLocal1=='**'
	cLocal1:="("
	aLocal:={}
	
	cSql003:=""
	cSql003+= " SELECT DISTINCT B2_LOCAL LOCAL1  "
	cSql003+= " FROM "+ RetSqlName("SB2") + " SB2"
    cSql003+= " WHERE SB2.B2_FILIAL " + GetRngFil( aSelFil, "SB2", .T., @cTmpSB2Fil ) 
	cSql003+= " AND SB2.D_E_L_E_T_ = ' ' "
	cSql003+= " AND SB2.B2_LOCAL <> '  '    "

	cSql003+= " UNION "
	cSql003+= " SELECT DISTINCT B9_LOCAL LOCAL1  "
	cSql003+= " FROM "+ RetSqlName("SB9") + " SB9"
    cSql003+= " WHERE SB9.B9_FILIAL " + GetRngFil( aSelFil, "SB9", .T., @cTmpSB2Fil ) 
	cSql003+= " AND SB9.D_E_L_E_T_ = ' ' "
	cSql003+= " AND SB9.B9_LOCAL <> '  '    "
	cAliasTSB2 := GetNextAlias()
	
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cSql003 ), cAliasTSB2,.T.,.T.)
	(cAliasTSB2)->(dBGotop())
	WHILE ! EOF()
		aAdd(aLocal, { .F., (cAliasTSB2)->LOCAL1,STR0055+(cAliasTSB2)->LOCAL1}) // 'ARMAZEM '
		DBSKIP()
	ENDDO

	IF Select( cAliasTSB2 ) > 0
		dbSelectArea( cAliasTSB2 )
		dbCloseArea()
	EndIf
	
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 240,500 PIXEL
	
	@ 10,10 LISTBOX oLbx FIELDS HEADER ;
	" ", STR0056, STR0057;  // "Codigo"####"Descricao"
	SIZE 230,095 OF oDlg PIXEL ON dblClick(aLocal[oLbx:nAt,1] := !aLocal[oLbx:nAt,1])
	
	oLbx:SetArray( aLocal )
	oLbx:bLine := {|| {Iif(aLocal[oLbx:nAt,1],oOk,oNo),;
	aLocal[oLbx:nAt,2],;
	aLocal[oLbx:nAt,3]}}
	
	DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION (nOpc:=1,oDlg:End()) ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTER
	
	If nOpc==1 .And. Len(aLocal) >= 1
		For nX:=1 To Len(aLocal)
			If aLocal[nX,1]
				cLocal1+="'"+aLocal[nX,2]+"',"
			EndIf
		Next nX
	Endif
	cLocal1:=SUBSTR(cLocal1,1,len(alltrim(cLocal1))-1)+')'
ELSE
	aAdd(aLocal, { .T., cLocal1,''})
	cLocal1:="('"+PADR(cLocal1,nTamLocal)+"')"
ENDIF
IF cLocal1 == '(' .OR. EMPTY(cLocal1)
	aAdd(aLocal, { .T., PADR('01',nTamLocal),''})
	cLocal1 :="('"+PADR('01',nTamLocal)+"')"
Endif
Return(cLocal1)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ SelLocal ³ Autor ³ MicroSiga			    ³ Data ³03.10.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Seleciona armazens										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR263                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LocFilial(cLocal1,cFilsel,cProd)  // Seleciona Armazem.

Local aAreaSb2  := GetArea()
Local cAliasTSB2 := ""

//+-----------------------------------------------+
//| Monta a tela para usuario visualizar consulta |
//+-----------------------------------------------+

aLocalFiR:={}

cSql003:=""
cSql003+= " SELECT DISTINCT B2_LOCAL LOCAL1  "
cSql003+= " FROM "+ RetSqlName("SB2") + " SB2"
cSql003+= " WHERE SB2.B2_FILIAL = '" + cFilsel +"'"
cSql003+= " AND SB2.D_E_L_E_T_ = ' ' "
cSql003+= " AND SB2.B2_LOCAL IN "+cLocal1+"  "
//cSql003+= " AND SB2.B2_LOCAL='"+cLocal1+"'"
cSql003+= " AND SB2.B2_COD='"+cProd+"'"
	
cSql003+= " UNION "
cSql003+= " SELECT DISTINCT B9_LOCAL LOCAL1  "
cSql003+= " FROM "+ RetSqlName("SB9") + " SB9"
cSql003+= " WHERE SB9.B9_FILIAL = '" + cFilsel + "'"
cSql003+= " AND SB9.D_E_L_E_T_ = ' ' "
cSql003+= " AND SB9.B9_LOCAL IN "+cLocal1+"  "
//cSql003+= " AND SB9.B9_LOCAL='"+cLocal1+"'"
cSql003+= " AND SB9.B9_COD='"+cProd+"'"
cAliasTSB2 := GetNextAlias()

dbUseArea( .T., "TOPCONN", TcGenQry( ,, cSql003 ), cAliasTSB2,.T.,.T.)
(cAliasTSB2)->(dBGotop())
WHILE ! EOF()
	aAdd(aLocalFiR, { .T., (cAliasTSB2)->LOCAL1,STR0055+(cAliasTSB2)->LOCAL1}) // 'ARMAZEM '
	DBSKIP()
ENDDO

IF Select( cAliasTSB2 ) > 0
	dbSelectArea( cAliasTSB2 )
	dbCloseArea()
EndIf

RestArea( aAreaSb2 )

Return(aLocalFiR)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fTabla5  ³ Autor ³ Ricardo Berti         ³ Data ³12.11.2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Obtem cod. SUNAT Tabla 5 - Tipos de Existencia             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpC2 := fTabla5(ExpC1)				                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1: Tipo de Material Protheus (SX5-Tab.02)			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpC2: Tipo de Existencia SUNAT      					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR263                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fTabla5(cTipo)

Local cTipoS := ""
DEFAULT cTipo := ""

Do Case
	Case cTipo == "ME"		// MERCADERIA
		cTipoS := "01"
	Case cTipo == "PA"	// PRODUCTO TERMINADO
		cTipoS := "02"
	Case cTipo $ "MC|MP|PI|PP"	// MATERIAS PRIMAS Y AUXILIARES - MATERIALES
		cTipoS := "03"
	Case cTipo == "EM"	// ENVASES Y EMBALAJES
		cTipoS := "04"
	Case cTipo == "OI"	// SUMINISTROS DIVERSOS
		cTipoS := "05"
	Otherwise	// Otros (Especificar)
		// AI BN GG MO PV SL SP
		cTipoS := "99 - "+Trim(Posicione("SX5",1,xFilial("SX5")+"02"+cTipo,"X5_DESCSPA"))
EndCase
Return(cTipoS)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fTabla6  ³ Autor ³ Ricardo Berti         ³ Data ³12.11.2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Obtem codigo SUNAT Tabla 6 - Unidades de Medida 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpC2 := fTabla6(ExpC1)				                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1: Unidade de Medida Protheus (SAH)					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpC2: Unidade de Medida SUNAT       					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR263                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fTabla6(cUMedida)

Local cUM := ""
DEFAULT cUMedida := ""

SAH->( dbSetOrder(1) )
SAH->( MsSeek( xFilial("SAH")+cUMedida) )
//cUM := Trim(SAH->AH_QPREF1)+" - "+Trim(SAH->AH_DESCES)
cUM := Trim(SAH->AH_CODERP)+" - "+Trim(SAH->AH_DESCES)
/*
Do Case
	Case cUMedida == "KG"	// KILOGRAMOS
		cUM := "01"
	Case cUMedida == "LB"	// LIBRAS
		cUM := "02"
	Case cUMedida == "TL"	// TONELADAS LARGAS
		cUM := "03"
	Case cUMedida == "TM"	// TONELADAS METRICAS
		cUM := "04"
	Case cUMedida == "TC"	// TONELADAS CORTAS
		cUM := "05"
	Case cUMedida == "G "	// GRAMOS
		cUM := "06"
	Case cUMedida == "UN"	// UNIDADES
		cUM := "07"
	Case cUMedida == "L "	// LITROS
		cUM := "08"
	Case cUMedida == "GL"	// GALONES
		cUM := "09"
	Case cUMedida == "BR"	// BARRILES
		cUM := "10"
	Case cUMedida == "LT"	// LATAS
		cUM := "11"
	Case cUMedida == "CX"	// CAJAS
		cUM := "12"
	Case cUMedida == "MI"	// MILLARES
		cUM := "13"
	Case cUMedida == "M3"	// METROS CUBICOS
		cUM := "14"
	Case cUMedida == "MT"	// METROS
		cUM := "15"
	Otherwise	// Otros (Especificar)
		cUM := "99 - "+Trim(POSICIONE("SAH",1,xFilial("SAH")+cUMedida,"AH_DESCES"))
EndCase
*/
Return(cUM)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ M263SemMov ³ Autor ³ MicroSiga           ³ Data ³28/04/2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Tratamento para produtos sem movimento                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function M263SemMov(aCodsPrds)

Local cQuery := ""
Local aArea  := GetArea()
Local cAliPr := GetNextAlias()
Local nX := 1
Local cNoProds := ""

	cNoProds := "'"
	for nX:=1 to len(aCodsPrds)
		cNoProds += aCodsPrds[nX]+"','"
	next nX
	cNoProds := substr(cNoProds,1,len(cNoProds)-2)

	dDataAnt := mv_par06
	nMesAnt := month(mv_par06)-1
	nAnoAnt := year(mv_par06)
	if nMesAnt<1
		nMesAnt := 12
		nAnoAnt := year(mv_par06)-1
	endif
	nMesAnt := strzero(nMesAnt,2)
	nAnoAnt := strzero(nAnoAnt,4)
	
	cQuery := "SELECT B9_FILIAL,B9_COD,B9_LOCAL,B9_DATA"+CRLF
	cQuery += "  FROM "+RetSqlName("SB1")+" SB1, "+RetSqlName("SB9")+" SB9"+CRLF
	cQuery += " WHERE B1_FILIAL = '"+xFilial("SB1")+"'"+CRLF
	cQuery += "   AND B9_FILIAL = '"+xFilial("SB9")+"'"+CRLF
	cQuery += "   AND SB9.D_E_L_E_T_ = ''"+CRLF
	cQuery += "   AND SB1.D_E_L_E_T_ = ''"+CRLF
	cQuery += "   AND B1_COD NOT IN ("+cNoProds+")"+CRLF
	cQuery += "   AND LEFT(B9_DATA,6)='"+nAnoAnt+nMesAnt+"'"+CRLF
	cQuery += "   AND B1_COD=B9_COD"+CRLF
	If MV_PAR14 == 1 //Lista productos sin movimiento
		cQuery += "   AND B9_QINI=0"+CRLF
	else
		cQuery += "   AND B9_QINI<>0"+CRLF
	endif
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliPr,.T.,.T.)
	if (cAliPr)->(!Eof())
		While (cAliPr)->(!Eof())
		
			//if Ascan( aCodsPrds, (cAliPr)->B1_COD ) == 0
			
				NNR->( MsSeek( xFilial("NNR")+(cAliPr)->B9_LOCAL ) )
		
				//If !(TRB->(MsSeek((cAliPr)->B1_COD)))
					TRB->(RecLock("TRB",.T.))
					TRB->FILIAL		:= (cAliPr)->B9_FILIAL
					TRB->EMISSAO	:= dDataAnt
					TRB->DTDIGIT1	:= dDataAnt
					TRB->PRODUTO	:= (cAliPr)->B9_COD
					TRB->NUMDOC		:= "*SINMOV*"
					TRB->XLOCAL		:= (cAliPr)->B9_LOCAL
					TRB->XTPESTAB	:= NNR->NNR_TIPOES
					TRB->XIDESTAB	:= NNR->NNR_IDSUNA
					TRB->(MsUnlock())
				//EndIf
			
			//endif
			
			(cAliPr)->(dbSkip())
		EndDo
	endif
	(cAliPr)->(DbCloseArea())

RestArea(aArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao     ³ GerArq   ³ Autor ³                     ³ Data ³16.02.2016  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao  ³ Arquivo magnético do Registro de Inventário Valorizado     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Parametros ³ cDir - Diretorio de criacao do arquivo.                    ³±±
±±³            ³ cArq - Nome do arquivo com extensao do arquivo.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno    ³ Nulo                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ Fiscal Peru - Registro de Inventário - Arquivo Magnetico   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GerArq(cDir)

Local cLin			:= ""
Local cSep			:= "|"
Local nCont			:= 0
Local cArq			:= ""
Local dDtDigit		:= CTOD("  /  /  ")
Local cExisten		:= " "
Local nSecNodia		:= 0
Local cNodiaAnt		:= "XX"
Local nCusIni		:= 0
Local cCusInic		:= 0
Local cSerKINV		:= SuperGetMv("MV_SERKINV", .F., "")
Local cSerKTM		:= SuperGetMv("MV_SERKTM", .F., "")
Local cFilialProd	:= ""
Local cProd			:= ""
Local cEstabProd	:= ""

Private lUsaCodBar	:= SuperGetMv("MV_USACBAR" ,.F.,.F.) 
Private lusaTsx5	:= SuperGetMv("MV_USATSX5" ,.F.,.F.) 
Private nHdl		:= 0
Private cQuantT		:= 0
Private cQuantTo	:= 0
Private nCustoTo	:= 0
private nCorr		:= 1
//private aFilImpre	:= {}

FOR nCont := LEN(AllTrim(cDir)) TO 1 STEP -1
	IF SUBSTR(cDir,nCont,1)=='\'
		cDir:=Substr(cDir,1,nCont)
		EXIT
	ENDIF
NEXT

 // Nome do arquivo TXT a ser impresso
cArq += "LE"	                            // Fixo  'LE'
cArq +=  AllTrim(SM0->M0_CGC)           // Ruc
cArq +=  AllTrim(Str(Year(MV_PAR06)))   // Ano
cArq +=  AllTrim(Strzero(Month(MV_PAR06),2))  // Mes
cArq +=  "00"                            // Fixo '00'
cArq += "130100"                         // Fixo '130100' 
cArq += "00"                             // Fixo '00'
cArq += "1"
cArq += "1"
cArq += "1"
cArq += "1"
cArq += ".TXT" // Extensao

nHdl := fCreate(cDir+UPPER(cArq),Nil,Nil,.F.)
If nHdl <= 0
	ApMsgStop(STR0087) //"Ha ocurrido un error al generar el archivo, intente nuevamente."
Else		
	dbSelectArea("TRB")
	TRB->(dbGoTop())

	Do While TRB->(!EOF()) 
	
		/*
		if TRB->QUANT==0
			TRB->( dbSkip() )
			Loop
		endif
		*/

		If MV_PAR14 == 2 //Lista productos sin movimiento
			If ALLTRIM(TRB->NUMDOC) == "*SINMOV*"
				TRB->( dbSkip() )
				Loop
			endif
		endif
	
		cLin:=""
		cProduto := TRB->PRODUTO

		If ((cEstabProd <> TRB->XIDESTAB).Or.(AllTrim(TRB->PRODUTO) <> AllTrim(cProd)))
			fSaldoIni(TRB->PRODUTO,TRB->XIDESTAB)
			cEstabProd := TRB->XIDESTAB
			cProd := TRB->PRODUTO
			cEstmento := TRB->XIDESTAB
		EndIF	

		nCusto := 0
		dDtDigit := TRB->DTDIGIT1
		nCusIni  := 0
				
		// - 01 Periodo
		cLin += SubStr(DTOS(Emissao),1,6)+"00"
		cLin += cSep
				
		// - 02 Código Único de la Operación (CUO)
		if empty(TRB->NODIA)
			cLin += "CUO-VACIO"		//getNodiaOrig(TRB->SERIE,Right(AllTrim(TRB->NUMDOC),8))
		else
			cLin += AllTrim(TRB->NODIA)
		endif
		cLin += cSeP
					
		// - 03 correlativo 	
		/*
		If !Empty(AllTrim(TRB->NODIA)) .and. cNodiaAnt <> AllTrim(TRB->NODIA)
			cNodiaAnt := AllTrim(TRB->NODIA)
			nSecNodia := 0
			cLin += "M"+StrZero(++nSecNodia,5)
		ElseIf !Empty (AllTrim(TRB->NODIA)) .and. cNodiaAnt == AllTrim(TRB->NODIA)
			cLin += "M"+StrZero(++nSecNodia,5)
		Else
			cLin += ""	
		EndIf
		*/
		If !Empty(AllTrim(TRB->XITEM))
			cLin += "M"+StrZero(val(TRB->XITEM),5)
		else
			If !Empty(AllTrim(TRB->NODIA)) .and. cNodiaAnt <> AllTrim(TRB->NODIA)
				cNodiaAnt := AllTrim(TRB->NODIA)
				nSecNodia := 0
				cLin += "M"+StrZero(++nSecNodia,5)
			ElseIf !Empty (AllTrim(TRB->NODIA)) .and. cNodiaAnt == AllTrim(TRB->NODIA)
				cLin += "M"+StrZero(++nSecNodia,5)
			Else
				cLin += ""	
			endif
		endif
		cLin += cSeP
					
		// - 04 Estabelecimento		
		cLin += AllTrim(cEstmento)
		cLin += cSep
						
		// - 05 Código del catálogo utilizado tabela 13 -  USAR 3(EAN) OU 9(OUTROS)	
	 	lCodBar:=.F. 
	 	SB1->(DbSetOrder(1)) //B1_FILIAL+B1_COD
		SB1->(MsSeek(xFilial("SB1")+TRB->PRODUTO))
	 	If !empty(SB1->B1_CODBAR) .AND. lUsaCodBar
			lCodBar := .T.
			cLin += "3"
		Else
			cLin += "9"	
		EndIf	
		cLin += cSep	 
		
		// - 06 Tipo de existencia  - tabela 5, Creado en el UPDEST43	  
		cLin += AllTrim(SB1->B1_TIPOEX)					
		cLin += cSeP  
				  
		// - 07 Código propio de la existencia correspondiente al catálogo señalado en el campo 5.  
		If lCodBar
			cLin += AllTrim(SB1->B1_CODBAR)
		Else
			cLin += AllTrim(TRB->PRODUTO)	
		EndIf	
		cLin += cSep
		
		// - 08 Código de la existencia, de acuerdo al Catálogo de Bienes, Servicios y Obras (*) - UPDEST43	  
		/*
		If SB5->(FieldPos("B5_CODEXIS")) > 0
			SB5->(DbSetOrder(1)) //B1_FILIAL+B1_COD
			If ALLTRIM(xFilial("SB5")) <> ""
				SB5->(DbSeek(TRB->FILIAL+TRB->PRODUTO))
			Else
				SB5->(DbSeek(xFilial("SB5")+TRB->PRODUTO))
			EndIF
			cLin += ALLTRIM(SB5->B5_CODEXIS)
		else
			cLin += ""
		endif
		cLin += cSep
		*/
		If SB1->(FieldPos("B1_PRODSAT")) > 0
			cLin += ALLTRIM(SB1->B1_PRODSAT)+"00000000"
		Else
			cLin += ""
		EndIf
		cLin += cSep
		
		// - 09 Fecha de emisión del documento de traslado, comprobante de pago, documento interno o similar				
		cLin += SubStr(DTOC(Emissao),1,6)+SubStr(DTOS(Emissao),1,4)
		cLin += cSeP    
			
		// - 10 Tipo del documento de traslado, comprobante de pago, documento interno o similar TABELA 10			  
		If AllTrim(TRB->TIPODOC) $ "NDI/NCC"
          cLin +="07"
        ElseIf AllTrim(TRB->TIPODOC) $ "FAC" 
       
			// ----------------------------------------------------------------------------------- //
			// Adicionado por SISTHEL para impresion de la serie 3 ( campo customizado )		   //
			// Adicionada a serie 12 para series de etiquetadoras								   //
			// ----------------------------------------------------------------------------------- //
			If TRB->TES > "500" // Documentos de Salida
			
				SFP->( dbSetOrder(5) )	//FP_FILIAL, FP_FILUSO, FP_SERIE, FP_ESPECIE
				If SFP->( dbSeek( xFilial("SFP")+TRB->FILIAL+TRB->SERIE+"1" ) )
					If Len(Alltrim((SFP->FP_YSERIE))) <= 4
						cLin +="01"
					Else
						cLin +="12"
					EndIf
				Else
					If SFP->( dbSeek( xFilial("SFP")+TRB->FILIAL+TRB->SERIE+"6" ) )
						If Len(Alltrim((SFP->FP_YSERIE))) <= 4
							cLin +="03"
						Else
							cLin +="12"
						EndIf
					Else
						cLin +="01"
					EndIf
				EndIf
					
			Else
				if alltrim(Posicione("SA2",1,xFilial("SA2")+TRB->CLIFOR+TRB->LOJA,"A2_EST"))=="EX"
					cLin +="91"
				else
					cLin +="01"
				endif
			EndIf
          	
        ElseIf AllTrim(TRB->TIPODOC) $ "RCN/RTS/RTE/RCD/RFN" 
          cLin +="09"
        ElseIf AllTrim(TRB->TIPODOC) $ "NDC" 
          cLin +="08"		      
	    Else	
		  cLin +="00"
	    EndIf	
  					   
		cLin += cSeP 
		  		
		// - 11 Número de serie del documento de traslado, comprobante de pago, documento interno o similar

		// ----------------------------------------------------------------------------------- //
		// Adicionado por SISTHEL para impresion de la serie 3 ( campo customizado )		   //
		// ----------------------------------------------------------------------------------- //
		_cSerieNf := ""
		If TRB->TES > "500" // Documentos de Salida
			_cSerieNf := getSerie2("1/3/4/5/6/7")
		Else 
			_cSerieNf := getSerie2("2")
		EndIf
		
		If Alltrim(TRB->NUMDOC) $ "INVENT" .AND. Alltrim(TRB->CF) $ "DE0|RE0"
	    	_cSerieNf :=  Alltrim(cSerKINV)
		Elseif Alltrim(TRB->CF) $ "DE0|DE1|DE4|DE6|ER0|PR0|RE0|RE1|RE4|RE6"
			_cSerieNf :=  Alltrim(cSerKTM)
		EndIf

		If Empty(_cSerieNf)
			If lSerie2 .And. !Empty(AllTrim(TRB->SERIE2))
				_cSerieNf := AllTrim(TRB->SERIE2)
			Elseif !Empty(AllTrim(TRB->SERIE))
				_cSerieNf := AllTrim(TRB->SERIE)
			Else
				_cSerieNf := "0000"
			EndIf
		Endif
		
		if alltrim(Posicione("SA2",1,xFilial("SA2")+TRB->CLIFOR+TRB->LOJA,"A2_EST"))=="EX"
			cLin += "0000"
		else
			If Len(Alltrim(_cSerieNf))==3
				cLin += "0"+_cSerieNf
			Else
				cLin += _cSerieNf
			EndIf
		endif
		cLin += cSeP 
																				  																						  

		// - 12 Número del documento de traslado, comprobante de pago, documento interno o similar 
		If !Empty (AllTrim(TRB->NUMDOC)) 
			// Modificado por Walmar de Freitas. 26092019: Agregado el filtro de Guias Despacho (091)- Los documentos max son de 08 Caracteres
			If _cSerieNf = "091" 
				cLin += Right(AllTrim(TRB->NUMDOC),8)
			Else
				cLin += Right(AllTrim(TRB->NUMDOC),20)
			EndIf
		Else
			cLin += "0"	
		EndIf		
		cLin += cSeP					  
	
		// - 13 Tipo de operación efectuada - TABELA 12, Creado en el UPDEST43  				  
		aArea:=Getarea()					
		If AllTrim(TRB->TIPODOC) $ "REM|NF|FAC|RCN|RFN"
			dbSelectArea("SF4")
			Dbsetorder(1) //F4_FILIAL+F4_CODIGO
			If dbseek(cFilialProd+TRB->TES)
				cLin += AllTrim(SF4->F4_TPOP)
			else
				If dbseek(xFilial("SF4")+TRB->TES)
					cLin += AllTrim(SF4->F4_TPOP)
				endif
			EndIf 
		Else
			cLin +="99"
		EndIf
		RestArea(aArea)					
		cLin += cSeP
		
		// - 14 Descripción de la existencia P7 - Tabela 05 da Existencia, Creado en el UPDEST43 			
		SX5->(DBSetOrder(1))
		SX5->(MsSeek(xFilial("SX5")+"P7"+SB1->B1_TIPOEX))

		If lUsaTSX5
			cExisten := IIf(SX5->(Found()),Trim(X5Descri())," ")  
		Else
			cExisten := SUBSTR(SB1->B1_DESC,1,80)
		EndIf
		cLin += cExisten
		cLin += cSeP 
		  
		// - 15 Código Unidade de Medida TABELA 6, Creado en el UPDEST43											
		cLin += alltrim(Posicione("SAH",1,xFilial("SAH")+SB1->B1_UM,"AH_CODERP"))				// AllTrim(SB5->B5_UNSUNAT)					
		cLin += cSeP 
								
		// - 16 Código del Método de valuación de existencias aplicado - tabela 14	
		cLin += AllTrim(STR(VAL(MV_PAR13)))					
		cLin += cSeP 
	
		// - 17 Cantidad de unidades físicas del bien ingresado
		If AllTrim(TRB->TES) <= "500" 										
			cLin += AllTrim(StrTran(Transform(TRB->QUANT,"@E 99999999.99"),",","."))			
		Else
			cLin += "0.00"
		Endif	
		cLin += cSeP 
	
		// - 18 Costo unitario del bien ingresado. 1.	Obligatorio si campo 17 <> '0.00' / 2.	Positivo o '0.00'
		SB1->(DbSetOrder(1)) //B1_FILIAL+B1_COD 
		SB1->(MsSeek(xFilial("SB1")+TRB->PRODUTO))				
		If TRB->QUANT != 0 .And. AllTrim(TRB->TES) <= "500"		       	
			nCusto := Round(TRB->CUSTOTAL,aTamT[2])/TRB->QUANT
			cLin += AllTrim(StrTran(Transform(nCusto,"@E 99999999.99"),",","."))
		ElseIf TRB->QUANT != 0 .And. AllTrim(TRB->TES) > "500"
			nCusto := Round(TRB->CUSTOTAL,aTamT[2])/TRB->QUANT
			cLin += "0.00"
		Else	
			cLin += "0.00"	
		EndIf	
		
		cLin += cSeP
		
		// - 19 Costo total del bien ingresado, 2.	Producto del campo 17 y del campo 18
		If AllTrim(TRB->TES) <= "500"
			cLin += AllTrim(StrTran(Transform(TRB->CUSTOTAL,"@E 99999999.99"),",","."))
		Else
			cLin += "0.00"
		Endif	
		cLin += cSeP
		
		// - 20 Cantidad de unidades físicas del bien retirado. 2.	Negativo o '0.00' // validar se a TES atualiza estouque ou não
		If AllTrim(TRB->TES) > "500"	
			//cLin += "-"+(AllTrim(StrTran(Transform(TRB->QUANT,"@E 99999999.99"),",",".")))					
			cLin += (AllTrim(StrTran(Transform(TRB->QUANT,"@E 99999999.99"),",",".")))					
		Else
			cLin += "0.00"
		Endif	
		cLin += cSeP
		
		// - 21 Costo unitario del bien retirado. 1.	Obligatorio si campo 20 <> '0.00'	
		If AllTrim(TRB->TES) > "500"
			cLin += AllTrim(StrTran(Transform(nCusto,"@E 99999999.99"),",","."))
		Else
			cLin += "0.00"
		Endif	
		cLin += cSeP

		// - 22 Costo total del bien retirado. 2.	Producto del campo 20 y del campo 21. 3.	Excepcionalmente puede ser positivo
		If AllTrim(TRB->TES) > "500"
			cLin += AllTrim(StrTran(Transform(TRB->CUSTOTAL,"@E 99999999.99"),",","."))
		Else
			cLin += "0.00"
		Endif	
		cLin += cSeP 
						
		// - 23 Cantidad de unidades físicas del saldo final. Excepcionalmente puede ser negativo		
		If AllTrim(TRB->TES) <= "500"
			cQuantT  := TRB->QUANT
			cCusInic := 0//TRB->CUSTINI
			cQuantTo += cQuantT += cCusInic
			nCustoTo += round(TRB->CUSTOTAL,aTamT[2])
			cLin += AllTrim(StrTran(Transform(cQuantTo,"@E 99999999.99"),",","."))
		Else
			cQuantT  := TRB->QUANT
			cCusInic := 0 //TRB->CUSTINI
			cQuantTo -= cQuantT -= cCusInic
			nCustoTo -= round(TRB->CUSTOTAL,aTamT[2])
			cLin += AllTrim(StrTran(Transform(cQuantTo,"@E 99999999.99"),",","."))
		EndIf	
	 	cLin += cSeP
	 					
	 	// - 24 Costo unitario del saldo final. Obligatorio si campo 23 <> '0.00' . Positivo o '0.00'	 		
		nCustoUniT := round(nCustoTo/cQuantTo,aTamT[2])
	 	cLin += AllTrim(StrTran(Transform( round(nCustoUniT,aTamT[2]),"@E 99999999.99"),",","."))			
	 	cLin += cSeP	
	 				
	 	// - 25 Costo total del saldo final. Producto del campo 23 y del campo 24. Excepcionalmente puede ser negativo
		cLin += AllTrim(StrTran(Transform( nCustoTo,"@E 99999999.99"),",","."))
	 	cLin += cSeP 		
	 		 				  					
		// - 26 Indica el estado de la operación
		//	'1' cuando la operación corresponde al periodo Registrar 
		//	'8' cuando la operación corresponde a un periodo anterior y NO ha sido anotada en dicho periodo 
		//	'9' cuando la operación corresponde a un periodo anterior y SI ha sido anotada en dicho periodo."
		If dDtDigit >= MV_PAR05 .And. dDtDigit <= MV_PAR06 
			cLin += "1"
		Else	
			cLin += "8"
		EndIf
						
		cLin += cSeP 
									
		cLin += chr(13)+chr(10) // QUEBRA LINHA 
		
		fWrite(nHdl,cLin)
		TRB->(DbSkip())
		
		cCusInic := 0		
		If AllTrim(TRB->PRODUTO) <> AllTrim(cProduto) // Zera totalizadores do Custo Total		
			cQuantT := 0
			cQuantTo:= 0	
			cCusInic := 0
			nCustoTo := 0
			//GenSldIni(TRB->PRODUTO,TRB->FILIAL)
			//fSaldoIni(TRB->PRODUTO,TRB->FILIAL)
		EndIf 	

	EndDo	
	fClose(nHdl)
	MsgInfo(STR0080, STR0088) //"El archivo de texto, se ha generado correctamente." - "Generación de Archivo Magnético"
EndIf
Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ VerPerg  ³ Autor ³                       ³ Data ³12.02.2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validar código do estabelecimento                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Fiscal Peru - Registro de Inventário - Arquivo Magnetico   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function VerPerg()

Local oReport

Aviso(STR0077,STR0078,{STR0079},2) //"Aviso" - "Código de establecimiento debe tener como mínimo 4 y como máximo 7 dígitos, para ser generado." - "OK"

Return(oReport)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GenSldIni³ Autor ³Cesar Bautista         ³ Data ³12.02.2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Genera el Saldo Inicial por Empresa.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Fiscal Peru - Registro de Inventário - Arquivo Magnetico   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GenSldIni(cCodProd,cCodeSuc)

Local aAreaSb9	:= GetArea()
Local cFilProd	:= ""
Local cLin		:= ""
Local cSep		:= "|"
Local nX		:= 0
Local ny		:= 0

cQuantTo := 0
nCustoTo := 0

For nX := 1 To Len(aSelFil)

	aSalAtu   := {0,0,0,0,0,0,0}
	nQtini :=0
	nSalIni:=0

    aLocalFiR := LocFilial(mv_par07,aSelFil[nX],cCodProd)
    //aLocalFiR := LocFilial(mv_par07,cCodeSuc,cCodProd)
	     
	For ny:=1 To Len(aLocalFiR)
		IF aLocalFiR[ny,1]
		   aSalatu1:=fCalcEst(cCodProd,aLocalFiR[ny,2],MV_PAR05,aSelFil[nX])
		   //aSalatu1:=fCalcEst(cCodProd,aLocalFiR[ny,2],MV_PAR05,cCodeSuc)
		   nQtIni +=aSalAtu1[1]           // QUANTIDADE 
		   nSalIni+=aSalAtu1[MV_PAR10+1]  // VALOR 
		ENDIF
	Next     
	
	aSalAtu[1]         +=nQtIni
	aSalAtu[mv_par10+1]+=nSalIni

	If nSalIni <> 0

		cLin:=""
		If cFilProd <> aSelFil[nX]
		//If cFilProd <> cCodeSuc
			//cFilProd := cCodeSuc
			cFilProd := aSelFil[nX]
			//cEstmento := IIF(ALLTRIM(MV_PAR15) == "",iif(SM0->(DbSeek(cEmpAnt+aSelFil[nX])),IIF(ALLTRIM(SM0->M0_INSC)<>"",ALLTRIM(SM0->M0_INSC),"DEF VACIO"),"FILIAL INVALIDA"),MV_PAR15)
			cEstmento := RetEstable(cFilProd)
		EndIF	

		nCusto := 0
		nCusIni  := nSalIni
				
		// - 01 Periodo
		cLin += SubStr(DTOS(MV_PAR05),1,6)+"00"
		cLin += cSep
				
		// - 02 Código Único de la Operación (CUO)									
		cLin += AllTrim("SLDINI")
		cLin += cSeP
					
		// - 03 correlativo 				
		cLin += "M"+StrZero(++nInd,5)
			
		cLin += cSeP
					
		// - 04 Estabelecimento		
		cLin += AllTrim(cEstmento)
		cLin += cSep
						
		// - 05 Código del catálogo utilizado tabela 13 -  USAR 3(EAN) OU 9(OUTROS)			 	
	 	lCodBar:=.F. 
	 	SB1->(DbSetOrder(1)) //B1_FILIAL+B1_COD
		SB1->(MsSeek(xFilial("SB1") + cCodProd))
	 	If SB1->B1_CODBAR <> " " .AND. lUsaCodBar
			lCodBar:=.T.
			cLin += "3"
		Else
			cLin += "9"	
		EndIf	
		cLin += cSep	 
		
		// - 06 Tipo de existencia  - tabela 5, Creado en el UPDEST43						  
		cLin += AllTrim(SB1->B1_TIPOEX)					
		cLin += cSeP  
				  
		// - 07 Código propio de la existencia correspondiente al catálogo señalado en el campo 5. 					  
		If lCodBar
			cLin += AllTrim(SB1->B1_CODBAR)
		Else
			cLin += AllTrim(cCodProd)
		EndIf	
		cLin += cSep
		
		// - 08 Código de la existencia, de acuerdo al Catálogo de Bienes, Servicios y Obras (*) - UPDEST43					  
		/*
		If SB5->(FieldPos("B5_CODEXIS")) > 0
			SB5->(DbSetOrder(1)) //B1_FILIAL+B1_COD
			If ALLTRIM(xFilial("SB5")) <> ""
				SB5->(DbSeek(aSelFil[nX]+cCodProd))
			Else
				SB5->(DbSeek(xFilial("SB5")+cCodProd))										
			EndIF
			cLin += ALLTRIM(SB5->B5_CODEXIS)
		else
			cLin += ""
		endif
		cLin += cSep
		*/
		If SB1->(FieldPos("B1_PRODSAT")) > 0
			cLin += ALLTRIM(SB1->B1_PRODSAT)+"00000000"
		Else
			cLin += ""
		EndIf
		cLin += cSep
		
		// - 09 Fecha de emisión del documento de traslado, comprobante de pago, documento interno o similar								
		cLin += SubStr(DTOC(MV_PAR05),1,6)+SubStr(DTOS(MV_PAR05),1,4)
		cLin += cSeP    
			
		// - 10 Tipo del documento de traslado, comprobante de pago, documento interno o similar TABELA 10			  			  
		cLin +="00"
 					   
		cLin += cSeP 
		  		
		// - 11 Número de serie del documento de traslado, comprobante de pago, documento interno o similar
		cLin += "0"

		cLin += cSeP 
																				  																						  
		// - 12 Número del documento de traslado, comprobante de pago, documento interno o similar 			
		cLin += "0"	
		cLin += cSeP					  
								  
		// - 13 Tipo de operación efectuada - TABELA 12, Creado en el UPDEST43			  				  
		cLin +="16"
		cLin += cSeP
		
		// - 14 Descripción de la existencia P7 - Tabela 05 da Existencia, Creado en el UPDEST43  						 				
		SX5->(DBSetOrder(1))
		SX5->(MsSeek(xFilial("SX5")+"P7"+SB1->B1_TIPOEX))

		If lusaTsx5
			cExisten := IIf(SX5->(Found()),Trim(X5Descri())," ")  
		Else
			cExisten := SUBSTR(SB1->B1_DESC,1,80)
		EndIf
		cLin += cExisten
		
		cLin += cSeP 
		  
		// - 15 Código Unidade de Medida TABELA 6, Creado en el UPDEST43	  												
		cLin += alltrim(Posicione("SAH",1,xFilial("SAH")+SB1->B1_UM,"AH_CODERP"))				// AllTrim(SB5->B5_UNSUNAT)					
		cLin += cSeP 
								
		// - 16 Código del Método de valuación de existencias aplicado - tabela 14	
		cLin += AllTrim(STR(VAL(MV_PAR13)))					
		cLin += cSeP 
	
		// - 17 Cantidad de unidades físicas del bien ingresado
		If nQtIni <> 0										
			cLin += AllTrim(StrTran(Transform(nQtIni,"@E 99999999.99"),",","."))
		Else
			cLin += "0.00"
		Endif	
		cLin += cSeP 
	
		// - 18 Costo unitario del bien ingresado. 1.	Obligatorio si campo 17 <> '0.00' / 2.	Positivo o '0.00'
		SB1->(DbSetOrder(1)) //B1_FILIAL+B1_COD
		SB1->(MsSeek(xFilial("SB1")+ cCodProd))
		If nQtIni != 0		       	
			nCusto := round(Round(nSalIni,aTamT[2])/nQtIni,aTamT[2])
			cLin += AllTrim(StrTran(Transform(nCusto,"@E 99999999.99"),",","."))
		Else
			cLin += "0.00"	
		EndIf	
		
		cLin += cSeP
		
		// - 19 Costo total del bien ingresado, 2.	Producto del campo 17 y del campo 18
		If nQtIni != 0
			cLin += AllTrim(StrTran(Transform(nSalIni,"@E 99999999.99"),",","."))
		Else
			cLin += "0.00"
		Endif	
		cLin += cSeP
		
		// - 20 Cantidad de unidades físicas del bien retirado. 2.	Negativo o '0.00' // validar se a TES atualiza estouque ou não
		cLin += "0.00"
		cLin += cSeP
		
		// - 21 Costo unitario del bien retirado. 1.	Obligatorio si campo 20 <> '0.00'	
		cLin += "0.00"
		cLin += cSeP

		// - 22 Costo total del bien retirado. 2.	Producto del campo 20 y del campo 21. 3.	Excepcionalmente puede ser positivo
		cLin += "0.00"
		cLin += cSeP 
						
		// - 23 Cantidad de unidades físicas del saldo final. Excepcionalmente puede ser negativo
		cQuantT  := round(nQtIni,aTamT[2])
		cCusInic := round(nSalIni,aTamT[2])
		
		cQuantTo += cQuantT 
		nCustoTo  += cCusInic
		cLin += AllTrim(StrTran(Transform(cQuantTo,"@E 99999999.99"),",","."))
	 	cLin += cSeP
	 					
	 	// - 24 Costo unitario del saldo final. Obligatorio si campo 23 <> '0.00' . Positivo o '0.00'
		nCustoUniT := round(round(nCustoTo,aTamT[2])/cQuantTo,aTamT[2])
	 	cLin += AllTrim(StrTran(Transform( nCustoUniT,"@E 99999999.99"),",","."))			 		
	 	cLin += cSeP	
	 				
	 	// - 25 Costo total del saldo final. Producto del campo 23 y del campo 24. Excepcionalmente puede ser negativo
	 	cLin += AllTrim(StrTran(Transform(nCustoTo,"@E 99999999.99"),",","."))						 	

	 	cLin += cSeP 		
	 		 				  					
		// - 26 Indica el estado de la operación
		//	'1' cuando la operación corresponde al periodo Registrar 
		//	'8' cuando la operación corresponde a un periodo anterior y NO ha sido anotada en dicho periodo 
		//	'9' cuando la operación corresponde a un periodo anterior y SI ha sido anotada en dicho periodo."
		cLin += "1"
		cLin += cSeP 						
		cLin += chr(13)+chr(10) // QUEBRA LINHA 

		fWrite(nHdl,cLin)
    EndIf
Next

RestArea(aAreaSb9)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ZMATR263  ºAutor  ³Microsiga           ºFecha ³  05/22/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RetEstable(cFProd)

	Local cEstab := ""
	
	If SM0->( DbSeek(cEmpAnt+cFProd/*TRB->FILIAL*/) )
		IF ALLTRIM(SM0->M0_INSC)<>""
			//cEstab := Left(ALLTRIM(SM0->M0_INSC),4)+strzero(nCorr,3)
			cEstab := Left(ALLTRIM(SM0->M0_INSC),4)
		else
			cEstab := "DEF VACIO"
		endif
	else
		cEstab := "DEF VACIO"
	endif
	
	nCorr++

Return(cEstab)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ZMATR263  ºAutor  ³Microsiga           ºFecha ³  05/22/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function getNodiaOrig(xSerie,xNumDoc,xTpDoc,xClifor,xLoja,xDoc,xFil)

	local _aArea	:= getArea()
	local cQuery	:= ""
	local cAlias	:= getNextAlias()

	local cQuery2	:= ""
	local cAlias2	:= getNextAlias()
	
	local cQuery3	:= ""
	local cAlias3	:= getNextAlias()

	local cQuery4	:= ""
	local cAlias4	:= getNextAlias()


	local _cCliente := ""
	local _cLoja	:= ""
	local _cDoc		:= ""
	local _cSerie	:= ""
	local xNodia	:= ""
	local lOk		:= .f.
	local xNumDoc	:= Padr(alltrim(xNumDoc),TamSx3("F1_DOC")[1])
	local xClifor	:= Padr(alltrim(xClifor),TamSx3("F1_FORNECE")[1])
	
If alltrim(xTpDoc)<>"NCC"  // 
	
		cQuery := "SELECT D2_CLIENTE,D2_LOJA,D2_DOC,D2_SERIE"
		cQuery += "  FROM "+RetSqlName("SD2")
		//cQuery += " WHERE D2_FILIAL='"+xFilial("SD2")+"'"
		cQuery += " WHERE D2_FILIAL='"+ xFil +"'"
		cQuery += "   AND D2_SERIREM='"+xSerie+"'"
		cQuery += "   AND D2_REMITO='"+xNumDoc+"'"
		cQuery += "   AND D_E_L_E_T_=''"

		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
		
		if (cAlias)->(!Eof())
			_cCliente	:= (cAlias)->D2_CLIENTE
			_cLoja		:= (cAlias)->D2_LOJA
			_cDoc		:= (cAlias)->D2_DOC
			_cSerie		:= (cAlias)->D2_SERIE
			lOk			:= .t.
		
		else
			// -----------------------------------------------------------------------------------------------------
			// Codigo Anexado Por: Walmar de Freitas G. - Fecha: 03092019
			// Motivo: Anexado para recuperar el NODIA de las facturas que no tienen Remito - Cargadas Directamente
			// -----------------------------------------------------------------------------------------------------
				cQuery2 := "SELECT TOP 1 D2_CLIENTE,D2_LOJA,D2_DOC,D2_SERIE"
				cQuery2 += "  FROM "+RetSqlName("SD2")
			//	cQuery2 += " WHERE D2_FILIAL='"+xFilial("SD2")+"'"
				cQuery2 += " WHERE D2_FILIAL='"+ xFil +"'"
				cQuery2 += "   AND D2_SERIE='"+xSerie+"'"
				cQuery2 += "   AND D2_DOC='"+xDoc+"'"
				cQuery2 += "   AND D_E_L_E_T_=''"
				
				cQuery2 := ChangeQuery(cQuery2)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),cAlias2,.T.,.T.)

				If (cAlias2)->(!Eof())
					_cCliente	:= (cAlias2)->D2_CLIENTE
					_cLoja		:= (cAlias2)->D2_LOJA
					_cDoc		:= (cAlias2)->D2_DOC
					_cSerie		:= (cAlias2)->D2_SERIE
					lOk			:= .t.
				EndIf		
				(cAlias2)->( dbCloseArea() )
			//---------------------------------------------------------------------------------------------------------					
		endif
		(cAlias)->( dbCloseArea() )
	
else

		SF1->( dbSetOrder(1) )	// xSerie,xNumDoc,xTpDoc,xClifor,xLoja)
		//if SF1->( dbSeek( xFilial("SF1")+xNumDoc+xSerie+xClifor+xLoja ) ) 
		if SF1->( dbSeek( xFil + xNumDoc + xSerie + xClifor + xLoja ) )		
			xNodia := alltrim(SF1->F1_NODIA)
		endif
		lOk := .f.
endif


	if lOk
		SF2->( dbSetOrder(2) )
		//if SF2->( dbSeek( xFilial("SF2")+_cCliente+_cLoja+_cDoc+_cSerie ) )
		if SF2->( dbSeek( xFil +_cCliente + _cLoja + _cDoc + _cSerie ) )
			xNodia := alltrim(SF2->F2_NODIA)
		endif
	endif

   
	// -----------------------------------------------------------------------------------------------------
	// Codigo Anexado Por: Walmar de Freitas G. - Fecha: 03092019
	// Motivo: Anexado para recuperar el NODIA de los movmimientos de Inventario
	// Sin crear MV_SERKINV y MV_SERKTM - Deben ser creados para que se regularice . Solo Aplica a Bakels
	// -----------------------------------------------------------------------------------------------------
			If alltrim(xTpDoc) $ "DE0|DE1|DE4|DE6|ER0|PR0|RE0|RE1|RE4|RE6"
		
						cQuery3 := "SELECT TOP 1 D3_NODIA"
						cQuery3 += "  FROM "+RetSqlName("SD3")
						cQuery3 += " WHERE D3_FILIAL='" + xFil +"'"
						cQuery3 += "   AND D3_DOC='"    + xDoc +"'"
						cQuery3 += "   AND D_E_L_E_T_=''"
						cQuery3 += "   AND D3_ESTORNO <> 'S' " 
						cQuery3 := ChangeQuery(cQuery3)
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery3),cAlias3,.T.,.T.)
		
						If (cAlias3)->(!Eof())
							xNodia	:= (cAlias3)->D3_NODIA
						EndIf		
						(cAlias3)->( dbCloseArea() )
		   EndIf
	// -----------------------------------------------------------------------------------------------------

		
	// -----------------------------------------------------------------------------------------------------
	// Codigo Anexado Por: Walmar de Freitas G. - Fecha: 04092019
	// Motivo: Anexado para recuperar el NODIA de las series 001 y especie RCN que no aparecen.
	// -----------------------------------------------------------------------------------------------------
			If alltrim(xTpDoc) $ "RCN|RDF|RTE|RFD".AND.xNodia ==''
						cQuery4 := "SELECT F1_NODIA "
						cQuery4 += "  FROM "+RetSqlName("SF1")
						cQuery4 += " WHERE F1_FILIAL='" + xFil +"'"
						cQuery4 += "   AND F1_DOC='"    + xDoc +"'"
						cQuery4 += "   AND D_E_L_E_T_=''"
						
						cQuery4 := ChangeQuery(cQuery4)
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery4),cAlias4,.T.,.T.)
		
						If (cAlias4)->(!Eof())
							xNodia	:= (cAlias4)->F1_NODIA
						EndIf		
						(cAlias4)->( dbCloseArea() )
		   Else
					if !lOk
							SF1->( dbSetOrder(1) )	// xSerie,xNumDoc,xTpDoc,xClifor,xLoja)
							//if SF1->( dbSeek( xFilial("SF1")+xNumDoc+xSerie+xClifor+xLoja ) ) 
							if SF1->( dbSeek( xFil + xNumDoc + xSerie + xClifor + xLoja ) )		
								xNodia := alltrim(SF1->F1_NODIA)
							endif
							lOk := .f.
					endif
		   EndIf
	// -----------------------------------------------------------------------------------------------------

	RestArea(_aArea)
Return(xNodia)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ZMATR263  ºAutor  ³Microsiga           ºFecha ³  06/20/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function getSerie2(cDocEsp)

	local cRetSerie := CriaVar("FP_YSERIE")
	local aEspecies	:= {}

	if len(cDocEsp)==1
		Aadd( aEspecies, cDocEsp )
	else
		aEspecies := StrTokArr2( cDocEsp, "/" )
	endif
	
	SFP->( dbSetOrder(5) )	//FP_FILIAL, FP_FILUSO, FP_SERIE, FP_ESPECIE
	
	for nX := 1 to len(aEspecies)

		If SFP->( dbSeek( xFilial("SFP")+TRB->FILIAL+TRB->SERIE+aEspecies[nX] ) )

			If !Empty(SFP->FP_YSERIE)
				cRetSerie := Alltrim(SFP->FP_YSERIE)
			else
				cRetSerie := Alltrim(SFP->FP_SERIE2)
			EndIf

			exit

		Endif	

	next nX
	
Return(alltrim(cRetSerie))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ZMATR263  ºAutor  ³Microsiga           ºFecha ³  06/27/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RetiraChar(cparam)

	local cpar18 := ""
	
	cpar18 := Replace(ALLTRIM(cparam),"-","/")
	cpar18 := Replace(cpar18,"|","/")
	cpar18 := Replace(cpar18,",","/")
	cpar18 := Replace(cpar18,";","/")
	cpar18 := Replace(cpar18,"'","/")
	cpar18 := Replace(cpar18,"=","/")
	cpar18 := Replace(cpar18,"_","/")
	cpar18 := Replace(cpar18,"\","/")
	cpar18 := Replace(cpar18,"#","/")
	cpar18 := Replace(cpar18,"$","/")
	cpar18 := Replace(cpar18,"%","/")
	cpar18 := Replace(cpar18,"^","/")
	cpar18 := Replace(cpar18,"&","/")
	cpar18 := Replace(cpar18,"*","/")

Return(cpar18)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ZMATR263  ºAutor  ³Microsiga           ºFecha ³  06/30/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fCalcEst(cCod,cLocal,dData,cFilAux,lConsTesTerc,lCusRep)

	#define F_SB9  1
	#define F_SD1  2
	#define F_SD2  3
	#define F_SD3  4
	#define F_SF4  5
	#define F_SF5  6
	
	Local _aarea := getArea()
	Local nReg,nReg1,nOrd,nOrd1,dDtVai
	Local lHasRec := .F.
	Local aSaldo     := { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
	Local cLocProc   := GETMV("MV_LOCPROC")
	Local cArq       := Alias()
	Local nCnt01     := 0
	
	Local aFilial  := { xFilial( "SB9" ),;
	                    xFilial( "SD1" ),;
	                    xFilial( "SD2" ),;
	                    xFilial( "SD3" ),;
	                    xFilial( "SF4" ),;
	                    xFilial( "SF5" ) }
	
	Local lRemInt  := SuperGetMv("MV_REMINT",.F.,.F.)
	Local nSizeFil := 2 
	Local lUsaD2DIG  := UsaD2DTDIG()
	Local cFiltroSF5 :=	SF5->(DbFilter())
	
	DEFAULT lConsTesTerc := .F.
	DEFAULT lCusRep      := .F.
	DEFAULT dData        := dDataBase
	SF5->(DBClearFilter())
	
	dData	 := If(Empty(dData),Ctod( "01/01/80","ddmmyy" ),dData)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de partida para compor o saldo inicial.        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea( "SB9" )
	//DbSeek(aFilial[ F_SB9 ]+cCod+cLocal)
	DbSeek(cFilAux+cCod+cLocal)
	
	lHasRec := .f.
	While !Eof() .and. (cFilAux+cCod+cLocal == B9_FILIAL+B9_COD+B9_Local)
		If B9_DATA >= dData .and. lHasRec
			Exit
		Else
			lHasRec := .t.
		EndIf
	
		DbSkip()
	End	
	If lHasRec
		DbSkip(-1)
	EndIf
	
	If ((cFilAux+cCod+cLocal == SB9->B9_FILIAL+SB9->B9_COD+SB9->B9_Local) .And. ;
		(SB9->B9_DATA < dData))
	
		aSaldo[01] := SB9->B9_QINI
		aSaldo[02] := SB9->B9_VINI1
		aSaldo[03] := SB9->B9_VINI2
		aSaldo[04] := SB9->B9_VINI3
		aSaldo[05] := SB9->B9_VINI4
		aSaldo[06] := SB9->B9_VINI5
		aSaldo[07] := SB9->B9_QISEGUM
		aSaldo[08] := SB9->B9_CM1
		aSaldo[09] := SB9->B9_CM2
		aSaldo[10] := SB9->B9_CM3
		aSaldo[11] := SB9->B9_CM4
		aSaldo[12] := SB9->B9_CM5
	
		If lCusRep
			aSaldo[13] := SB9->B9_CMRP1
			aSaldo[14] := SB9->B9_CMRP2
			aSaldo[15] := SB9->B9_CMRP3
			aSaldo[16] := SB9->B9_CMRP4
			aSaldo[17] := SB9->B9_CMRP5
			aSaldo[18] := SB9->B9_VINIRP1
			aSaldo[19] := SB9->B9_VINIRP2
			aSaldo[20] := SB9->B9_VINIRP3
			aSaldo[21] := SB9->B9_VINIRP4
			aSaldo[22] := SB9->B9_VINIRP5
		EndIf
		dDtVai    := SB9->B9_DATA+1
	Else
		dDtVai    := Ctod( "01/01/80","ddmmyy" )
	EndIf
	
	restArea(_aarea)
	
Return(aSaldo)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ZMATR263  ºAutor  ³Microsiga           ºFecha ³  12/16/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fSaldoIni(cCodProd,cCodeSuc)

Local aAreaSb9	:= GetArea()
Local cFilProd	:= ""
Local cLin		:= ""
Local cSep		:= "|"
Local nX		:= 0
Local ny		:= 0
Local cAlias	:= getNextAlias()

cQuantTo := 0
nCustoTo := 0

For nX := 1 To Len(aSelFil)

	//if Ascan( aFilImpre, aSelFil[nX] ) <= 0
	//if alltrim(aSelFil[nX]) == alltrim(cCodeSuc)

	aSalAtu   := {0,0,0,0,0,0,0}
	nQtini :=0
	nSalIni:=0
	cFilProd := ""
	cEstmento := ""
	
	cQry := "SELECT NNR_IDSUNA,NNR_TIPOES,NNR_CODIGO "
	cQry += "  FROM "+RetSqlName("NNR")
	cQry += " WHERE NNR_IDSUNA='" + cCodeSuc +"'"
	cQry += "   AND D_E_L_E_T_=''"
	cQry += "   AND NNR_CODIGO IN "+mv_par07+""
	cQry += " ORDER BY NNR_IDSUNA,NNR_CODIGO"
						
	cQry := ChangeQuery(cQry)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAlias,.T.,.T.)
		
	If (cAlias)->(!Eof())
	
		cFilProd := (cAlias)->NNR_IDSUNA
		cEstmento := (cAlias)->NNR_IDSUNA

		While (cAlias)->(!Eof())

		    //aLocalFiR := LocFilial(mv_par07,aSelFil[nX],cCodProd)
		    //aLocalFiR := LocFilial(mv_par07,cCodeSuc,cCodProd)
			     
			//For ny:=1 To Len(aLocalFiR)
				//IF aLocalFiR[ny,1]
				   aSalatu1:=fCalcEst(cCodProd,(cAlias)->NNR_CODIGO,MV_PAR05,aSelFil[nX])
				   //aSalatu1:=fCalcEst(cCodProd,aLocalFiR[ny,2],MV_PAR05,aSelFil[nX])
				   //aSalatu1:=fCalcEst(cCodProd,aLocalFiR[ny,2],MV_PAR05,cCodeSuc)
				   nQtIni +=aSalAtu1[1]           // QUANTIDADE 
				   nSalIni+=aSalAtu1[MV_PAR10+1]  // VALOR 
				//ENDIF
			//Next     
			
		    (cAlias)->( dbSkip() )
		    
		Enddo
		
	endif
	
	(cAlias)->( dbCloseArea() )
			
			aSalAtu[1]         +=nQtIni
			aSalAtu[mv_par10+1]+=nSalIni
		
			If nQtIni <> 0
		
				cLin:=""
				/*
				If (cFilProd <> (cAlias)->NNR_IDSUNA)
					cFilProd := (cAlias)->NNR_IDSUNA
					cEstmento := (cAlias)->NNR_IDSUNA
				EndIF	
				*/
		
				nCusto := 0
				nCusIni  := nSalIni
						
				// - 01 Periodo
				cLin += SubStr(DTOS(MV_PAR05),1,6)+"00"
				cLin += cSep
						
				// - 02 Código Único de la Operación (CUO)									
				cLin += AllTrim("SLDINI")
				cLin += cSeP
							
				// - 03 correlativo 				
				cLin += "M"+StrZero(++nInd,5)
				cLin += cSeP
							
				// - 04 Estabelecimento		
				cLin += AllTrim(cEstmento)
				cLin += cSep
								
				// - 05 Código del catálogo utilizado tabela 13 -  USAR 3(EAN) OU 9(OUTROS)			 	
			 	lCodBar:=.F. 
			 	SB1->(DbSetOrder(1)) //B1_FILIAL+B1_COD
				SB1->(MsSeek(xFilial("SB1") + cCodProd))
			 	If SB1->B1_CODBAR <> " " .AND. lUsaCodBar
					lCodBar:=.T.
					cLin += "3"
				Else
					cLin += "9"	
				EndIf	
				cLin += cSep	 
				
				// - 06 Tipo de existencia  - tabela 5, Creado en el UPDEST43						  
				cLin += AllTrim(SB1->B1_TIPOEX)					
				cLin += cSeP  
						  
				// - 07 Código propio de la existencia correspondiente al catálogo señalado en el campo 5. 					  
				If lCodBar
					cLin += AllTrim(SB1->B1_CODBAR)
				Else
					cLin += AllTrim(cCodProd)
				EndIf	
				cLin += cSep
				
				// - 08 Código de la existencia, de acuerdo al Catálogo de Bienes, Servicios y Obras (*) - UPDEST43					  
				/*
				If SB5->(FieldPos("B5_CODEXIS")) > 0
					SB5->(DbSetOrder(1)) //B1_FILIAL+B1_COD
					If ALLTRIM(xFilial("SB5")) <> ""
						SB5->(DbSeek(aSelFil[nX]+cCodProd))
					Else
						SB5->(DbSeek(xFilial("SB5")+cCodProd))										
					EndIF
					cLin += ALLTRIM(SB5->B5_CODEXIS)
				else
					cLin += ""
				endif
				cLin += cSep
				*/
				If SB1->(FieldPos("B1_PRODSAT")) > 0
					cLin += ALLTRIM(SB1->B1_PRODSAT)+"00000000"
				Else
					cLin += ""
				EndIf
				cLin += cSep
			
				// - 09 Fecha de emisión del documento de traslado, comprobante de pago, documento interno o similar								
				cLin += SubStr(DTOC(MV_PAR05),1,6)+SubStr(DTOS(MV_PAR05),1,4)
				cLin += cSeP    
					
				// - 10 Tipo del documento de traslado, comprobante de pago, documento interno o similar TABELA 10			  			  
				cLin +="00"
				cLin += cSeP 
				  		
				// - 11 Número de serie del documento de traslado, comprobante de pago, documento interno o similar
				cLin += "0"
				cLin += cSeP 
																						  																						  
				// - 12 Número del documento de traslado, comprobante de pago, documento interno o similar 			
				cLin += "0"	
				cLin += cSeP					  
										  
				// - 13 Tipo de operación efectuada - TABELA 12, Creado en el UPDEST43			  				  
				cLin +="16"
				cLin += cSeP
				
				// - 14 Descripción de la existencia P7 - Tabela 05 da Existencia, Creado en el UPDEST43  						 				
				SX5->(DBSetOrder(1))
				SX5->(MsSeek(xFilial("SX5")+"P7"+SB1->B1_TIPOEX))
		
				If lusaTsx5
					cExisten := IIf(SX5->(Found()),Trim(X5Descri())," ")  
				Else
					cExisten := SUBSTR(SB1->B1_DESC,1,80)
				EndIf
				cLin += cExisten
				cLin += cSeP 
				  
				// - 15 Código Unidade de Medida TABELA 6, Creado en el UPDEST43	  												
				cLin += alltrim(Posicione("SAH",1,xFilial("SAH")+SB1->B1_UM,"AH_CODERP"))				// AllTrim(SB5->B5_UNSUNAT)					
				cLin += cSeP 
										
				// - 16 Código del Método de valuación de existencias aplicado - tabela 14	
				cLin += AllTrim(STR(VAL(MV_PAR13)))	
				cLin += cSeP 
			
				// - 17 Cantidad de unidades físicas del bien ingresado
				If nQtIni <> 0										
					cLin += AllTrim(StrTran(Transform(nQtIni,"@E 99999999.99"),",","."))
				Else
					cLin += "0.00"
				Endif	
				cLin += cSeP 
			
				// - 18 Costo unitario del bien ingresado. 1.	Obligatorio si campo 17 <> '0.00' / 2.	Positivo o '0.00'
				SB1->(DbSetOrder(1)) //B1_FILIAL+B1_COD
				SB1->(MsSeek(xFilial("SB1")+ cCodProd))
				If nQtIni != 0		       	
					nCusto := round(Round(nSalIni,aTamT[2])/nQtIni,aTamT[2])
					cLin += AllTrim(StrTran(Transform(nCusto,"@E 99999999.99"),",","."))
				Else
					cLin += "0.00"	
				EndIf	
				
				cLin += cSeP
				
				// - 19 Costo total del bien ingresado, 2.	Producto del campo 17 y del campo 18
				If nQtIni != 0
					cLin += AllTrim(StrTran(Transform(nSalIni,"@E 99999999.99"),",","."))
				Else
					cLin += "0.00"
				Endif	
				cLin += cSeP
				
				// - 20 Cantidad de unidades físicas del bien retirado. 2.	Negativo o '0.00' // validar se a TES atualiza estouque ou não
				cLin += "0.00"
				cLin += cSeP
				
				// - 21 Costo unitario del bien retirado. 1.	Obligatorio si campo 20 <> '0.00'	
				cLin += "0.00"
				cLin += cSeP
		
				// - 22 Costo total del bien retirado. 2.	Producto del campo 20 y del campo 21. 3.	Excepcionalmente puede ser positivo
				cLin += "0.00"
				cLin += cSeP 
								
				// - 23 Cantidad de unidades físicas del saldo final. Excepcionalmente puede ser negativo
				cQuantT  := round(nQtIni,aTamT[2])
				cCusInic := round(nSalIni,aTamT[2])
				
				cQuantTo += cQuantT 
				nCustoTo  += cCusInic
				cLin += AllTrim(StrTran(Transform(cQuantTo,"@E 99999999.99"),",","."))
			 	cLin += cSeP
			 					
			 	// - 24 Costo unitario del saldo final. Obligatorio si campo 23 <> '0.00' . Positivo o '0.00'
				nCustoUniT := round(round(nCustoTo,aTamT[2])/cQuantTo,aTamT[2])
			 	cLin += AllTrim(StrTran(Transform( nCustoUniT,"@E 99999999.99"),",","."))			 		
			 	cLin += cSeP	
			 				
			 	// - 25 Costo total del saldo final. Producto del campo 23 y del campo 24. Excepcionalmente puede ser negativo
			 	cLin += AllTrim(StrTran(Transform(nCustoTo,"@E 99999999.99"),",","."))						 	
		
			 	cLin += cSeP 		
			 		 				  					
				// - 26 Indica el estado de la operación
				//	'1' cuando la operación corresponde al periodo Registrar 
				//	'8' cuando la operación corresponde a un periodo anterior y NO ha sido anotada en dicho periodo 
				//	'9' cuando la operación corresponde a un periodo anterior y SI ha sido anotada en dicho periodo."
				cLin += "1"
				cLin += cSeP 						
				cLin += chr(13)+chr(10) // QUEBRA LINHA 
		
				fWrite(nHdl,cLin)
		    
		    EndIf
	
	
Next

RestArea(aAreaSb9)

Return
