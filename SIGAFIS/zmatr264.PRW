#INCLUDE "PROTHEUS.CH"
#INCLUDE "MATR264.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR264  ³ Autor ³Bruno Schmidt			      ³ Data ³ 10/10/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ REGISTRO DE INVENTARIO PERMANENTE EN UNIDADES FISICAS            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³Data    ³ BOPS       ³ Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³L.Enríquez  ³21/12/16³SERINN001   ³ Se realizó merge contra los cambios      ³±±
±±³            ³        ³-375        ³ hechos para dejar de usar CriaTrab y     ³±±
±±³            ³        ³            ³ utilizar clase FWTemporaryTable.         ³±±
±±³  Marco A.  ³16/04/18³ DMINA-2310 ³Se remueven sentencias CriaTrab y se apli-³±±
±±³            ³        ³            ³ca FWTemporaryTable(), para el manejo de  ³±±
±±³            ³        ³            ³las tablas temporales.                    ³±±
±±³Alf Medrano ³27/04/18³ DMINA-1035 ³ se asigna funcionalida para serie 2 y 3 -³±±
±±³            ³        ³            ³ modifican las fun ReportDef, ReportPrint ³±± 
±±³            ³        ³            ³ MATR264FillTrb y GerArq para Perú        ³±±
±±³LuisEnríquez³10/07/19³ DMINA-6847 ³ Se compatibiliza rutina con v11.8 usando ³±±
±±³            ³        ³            ³ funcion MATR264CT para creación de tabla ³±±
±±³            ³        ³            ³ temporal. (PER)                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function zMATR264()
	Local oReport	:= Nil
	Local lImpR4	:= FindFunction( "TRepInUse" ) .And. TRepInUse()
	
	Private oTmpTable	:= Nil
	Private titulo		:= ""
	Private nomeprog	:= STR0005 //" Tipo de producto"
	Private cPosCpo     := IIf(cVersao=="11", "FieldPos", "ColumnPos")

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
±±³Programa  ³ReportDef ³ Autor ³Bruno Schmidt		    ³ Data ³ 10/10/11 ³±±
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
	Local cPicD1Qt  := PesqPict("SD1","D1_QUANT" ,18)
	Local cPicD2Qt  := PesqPict("SD2","D2_QUANT" ,18)
	Local cPicB2Qt  := PesqPictQt("B2_QATU",18)
	Local oSection1
	Local oSection2
	Local oSection3
	Local oReport        
	Local cDesc1 := ""
	Local cDesc2 := ""
	Local cDesc3 := ""
	
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
	//oReport := TReport():New("MATR264",substr(STR0001,1,94),"MTR264",{|oReport| IIf (Len(Alltrim(MV_PAR10)) >= 4 .And. Len(Alltrim(MV_PAR10)) < 8 ,ReportPrint(oReport),VerPar())},cDesc1+cDesc2+cDesc3)//validação 4 digitos na pergunta estabelecimento
	oReport := TReport():New("MATR264",substr(STR0001,1,94),"MTR264",{|oReport| /*IIf (Len(Alltrim(MV_PAR10)) >= 4 .And. Len(Alltrim(MV_PAR10)) < 8,*/ReportPrint(oReport)/*,VerPar())*/},cDesc1+cDesc2+cDesc3)
	oReport:SetTotalInLine(.F.)
	
	Pergunte("MTR264",.F.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao da Sessao 1 - Dados do Produto                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection1 := TRSection():New(oReport,STR0063,{"SA1","SA2"}) //"Cabecalio"
	oSection1 :SetTotalInLine(.F.)
	oSection1 :SetReadOnly()
	oSection1 :SetLineStyle()
	oSection1 :SetHeaderPage()
	oSection1 :NCOLS:=1
	TRCell():New(oSection1,"CODIGO"	,"",STR0071	,/*Picture*/,TAMSX3("B1_COD")[1] ,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"TIPO"	,"",STR0025 ,/*Picture*/,10         		 ,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"DESC"	,"",STR0072	,/*Picture*/,TAMSX3("B1_DESC")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"CODUN"  ,"",STR0073	,/*Picture*/,50         	     ,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"ESTABL" ,"","CODIGO DEL ESTABLECIMIENTO" ,/*Picture*/,50,/*lPixel*/,/*{|| code-block de impressao }*/)		// "cODIGO DEL ESTABLECIMIENTO
	
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
	TRCell():New(oSection1," "	,"",Replicate("_",77),/*Picture*/,80,/*lPixel*/,/*{|| code-block de impressao }*/) 
	TRCell():New(oSection1," "	,"",STR0084+CRLF+Replicate("_",77),/*Picture*/,80,/*lPixel*/,/*{|| code-block de impressao }*/) //"DOCUMENTO DE TRASLADO, COMPROBANTE DE PAGO, DOCUMENTO INTERNO O SIMILAR      :"
	oSection3 :NCOLS:=0
	TRCell():New(oSection3,"dDtMov"		,"   ",STR0040				,/*Picture*/,13         ,/*lPixel*/,/*{|| code-block de impressao }*/) //" (Tabla 10)"
	TRCell():New(oSection3,"Tipo"		,"   ",STR0058+STR0085,"@!"		,18			,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"cCF"		,"   "," "					,"@!"		,04         ,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"SERIE"		,"   ",STR0074				,"@!"		,20/*10*/			,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"cDoc"		,"   ",STR0044				,"@!"		,29			,/*lPixel*/,/*{|| code-block de impressao }*/) 
	TRCell():New(oSection3,"cTraco1"	,"   ","|"+CRLF+"|"			,/*Picture*/,1			,/*lPixel*/,{|| "|" })
	TRCell():New(oSection3,"Tp Oper"	,"   ",STR0075 				,"@!"		,32			,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"cTraco1"	,"   ","|"+CRLF+"|"			,/*Picture*/,1			,/*lPixel*/,{|| "|" })
	TRCell():New(oSection3,"nENTQtd"	,"   ",STR0045				,cPicD1Qt	,20			,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"cTraco2"	,"   ","|"+CRLF+"|"			,/*Picture*/,1			,/*lPixel*/,{|| "|" })
	TRCell():New(oSection3,"nSAIQtd"	,"   ",STR0050	   			,cPicD2Qt	,20			,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"cTraco6"	,"   ","|"+CRLF+"|"			,/*Picture*/,1			,/*lPixel*/,{|| "|" })
	TRCell():New(oSection3,"nSALDQtd"	,"   ",STR0051	   			,cPicD1Qt	,20			,/*lPixel*/,/*{|| code-block de impressao }*/)
	       
	TRFunction():New(oSection3:Cell("nENTQtd"),NIL,"SUM",/*oBreak*/,"",cPicD1Qt	,/*uFormula*/,.T.,.F.) 
	
	TRFunction():New(oSection3:Cell("nSAIQtd"),NIL,"SUM",/*oBreak*/,"",cPicD2Qt	,/*uFormula*/,.T.,.F.) 
	
	TRFunction():New(oSection3:Cell("nSALDQtd"),NIL,"ONPRINT",/*oBreak*/,"",cPicB2Qt  ,{|| oSection3:Cell("nSALDQtd"):GetValue(.T.) },.T.,.F.) 
Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³Bruno Schmidt		    ³ Data ³ 10/10/11 ³±±
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
	Local oSection1		:= oReport:Section(1) 
	Local oSection2		:= oReport:Section(1):Section(1)  
	Local oSection3		:= oReport:Section(1):Section(1):Section(1) 
	Local cWhereRE		:= ''
	Local cAlias		:= ''
	Local cPERIODO		:= ''
	Local CprodAux		:= ''
	Local nEntradas		:= 0
	Local aSalAtu		:= {0,0,0,0,0,0,0}
	Local lQuery		:= .F. 
	//Local lSB9ok		:= .F.
	Local nTamCod		:= TamSX3("B1_COD")[1]
	Local lUsaD2DIG		:= IIF(FindFunction("UsaD2DTDIG"), UsaD2DTDIG(), .F.)
	Local cDepTrf		:= SuperGetMv("MV_DEPTRANS",.F.,"95")	// Dep.transferencia
	Local aArea			:= GetArea()
	Local lTranSB2		:= SuperGetMv("MV_TRANSB2" ,.F.,.F.)	// Atualiza saldos de transferencia
	Local cTP			:= ""
	Local cSerKINV		:= SuperGetMv("MV_SERKINV" ,.F.,.F.)    
	Local cSerKTM		:= SuperGetMv("MV_SERKTM" ,.F.,.F.) 	  
	Local cYSerieF1     := ""
	Local cYSerieF2     := "" 
	Local cGroupF1      := ""	
	Local cGroupF2      := ""
	Local aCodsPrds		:= {}
	Local nMesAnt		:= 0
	Local nAnoAnt		:= 0
	Local cTIPODOC		:= ""
	Local cEstabProd	:= ""
	
	#IFNDEF TOP
		Local cCondicao := ''
	#ELSE
		Local cAliasTop := ''
	#ENDIF
	
	titulo	:= oReport:Title()
	
	oReport:SetCustomText( {|| Cabec264( oReport ) })
	
	Private bBloco := { |nV,nX| Trim(nV)+IIf(Valtype(nX)='C',"",Str(nX,1)) }
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³MV_CUSREP - Parametro utilizado para habilitar o calculo do   ³
	//³            Custo de Reposicao.                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private lCusRep  := SuperGetMv("MV_CUSREP",.F.,.F.) .And. (FindFunction("MA330AvRep") .And. MA330AvRep())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Genera segundo arquivo de Trabalho                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB1")
	SB1->(dbSetOrder(1)) //B1_FILIAL+B1_COD
	Set Softseek On
	dbseek(cFilial+mv_par01)
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
	AADD(aCampos,{"PRODUTO"  ,"C",nTamCod,0})
	AADD(aCampos,{"EMISSAO"  ,"D",08,0})
	AADD(aCampos,{"SEQCALC"  ,"C",14,0})
	AADD(aCampos,{"TES"      ,"C",03,0})
	AADD(aCampos,{"CF"       ,"C",aTamX[1],aTamX[2]})
	AADD(aCampos,{"TIPODOC"  ,"C",03,0})
	AADD(aCampos,{"NUMDOC"   ,"C",TamSX3('D1_DOC')[1],0})
	AADD(aCampos,{"SERIE"    ,"C",03,0})
	AADD(aCampos,{"QUANT"    ,"N",aTamQ[1],aTamQ[2]})
	AADD(aCampos,{"CLIFOR"   ,"C",aTamF[1],aTamF[2]})
	AADD(aCampos,{"LOJA"     ,"C",aTamL[1],aTamL[2]})
	AADD(aCampos,{"UM"       ,"C",03,0})
	AADD(aCampos,{"DTDIGIT"  ,"D",08,0})
	AADD(aCampos,{"NODIA"    ,"C",10,0})
	AADD(aCampos,{"SERIE3"   ,"C",20,0})
	AADD(aCampos,{"SERIE2"   ,"C",04,0})
	AADD(aCampos,{"FILIAL"   ,"C",aTamP[1],aTamP[2]})
	AADD(aCampos,{"XLOCAL"   ,"C",TamSX3('B2_LOCAL')[1],0})
	AADD(aCampos,{"XTPESTAB" ,"C",TamSX3('NNR_TIPOES')[1],0})
	AADD(aCampos,{"XIDESTAB" ,"C",TamSX3('NNR_IDSUNA')[1],0})
	AADD(aCampos,{"XITEM" 	 ,"C",10,0})
	
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
	If SF1->&(cPosCpo + '("F1_YSERIE")') > 0
		cYSerieF1 := "% F1_YSERIE %"
		cGroupF1  := "% F1_FILIAL,B1_TIPO,D1_COD,D1_SEQCALC,D1_DTDIGIT,D1_TES,D1_CF,D1_ESPECIE,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_UM,D1_DTDIGIT,F1_NODIA,F1_YSERIE,F1_SERIE2,D1_LOCAL,D1_ITEM %"
	Else
		cYSerieF1 := "% ' ' %"
		cGroupF1  := "% F1_FILIAL,B1_TIPO,D1_COD,D1_SEQCALC,D1_DTDIGIT,D1_TES,D1_CF,D1_ESPECIE,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_UM,D1_DTDIGIT,F1_NODIA,F1_SERIE2,D1_LOCAL,D1_ITEM %"
	EndIf

	cWhereD1 := "%" 
	if alltrim(mv_par07)=="*" .Or. alltrim(mv_par07)=="**"
		cWhereD1 += " SD1.D1_LOCAL BETWEEN ' ' AND 'ZZZZ' AND "
	else
		cWhereD1 += " SD1.D1_LOCAL ='"+mv_par07+"' AND "
	endif
	cWhereD1 += "%"	
		
	If SF2->&(cPosCpo + '("F2_YSERIE")') > 0
		cYSerieF2 := "% F2_YSERIE %"
		cGroupF2 := "% F2_FILIAL,B1_TIPO,D2_COD,D2_SEQCALC,D2_EMISSAO,D2_TES,D2_CF,D2_ESPECIE,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,D2_UM,D2_DTDIGIT,F2_NODIA,F2_YSERIE,F2_SERIE2,D2_LOCAL,D2_ITEM %"
	Else
		cYSerieF2 := "% ' ' %"
		cGroupF2  := "% F2_FILIAL,B1_TIPO,D2_COD,D2_SEQCALC,D2_EMISSAO,D2_TES,D2_CF,D2_ESPECIE,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,D2_UM,D2_DTDIGIT,F2_NODIA,F2_SERIE2,D2_LOCAL,D2_ITEM %"
	EndIf

    If lUsaD2DIG
    	cD2EMISSAO := "% D2_DTDIGIT EMISSAO,%"
    Else
    	cD2EMISSAO := "% D2_EMISSAO EMISSAO,%"
    EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Complemento do Where da tabela SD2                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	cWhereD2 := "%" 
	if alltrim(mv_par07)=="*" .Or. alltrim(mv_par07)=="**"
		cWhereD2 += " SD2.D2_LOCAL BETWEEN ' ' AND 'ZZZZ' AND "
	else
		cWhereD2 += " SD2.D2_LOCAL ='"+mv_par07+"' AND "
	endif
	
	// Verifica se usa o campo D2_DTDIGIT ou nao, de acordo com a funcao UsaD2DTDIG
    If lUsaD2DIG
		cWhereD2 += " SD2.D2_DTDIGIT >= '"+Dtos(mv_par05)+"' AND "
		cWhereD2 += " SD2.D2_DTDIGIT <= '"+Dtos(mv_par06)+"' AND "
	Else
		cWhereD2 += " SD2.D2_EMISSAO >= '"+Dtos(mv_par05)+"' AND "
		cWhereD2 += " SD2.D2_EMISSAO <= '"+Dtos(mv_par06)+"' AND "
	EndIf
	cWhereD2 += "%"    
	
	cWhereRE := "%" 
	cWhereRE += " (SD2.D2_REMITO   = '" + Space(TamSx3('D2_REMITO')[1]) + "' OR SD2.D2_TPDCENV IN ('1','A')) "	
	cWhereRE += "%" 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Complemento do WHERE da tabela SD3                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    cWhereD3 := "%"
	if alltrim(mv_par07)=="*" .Or. alltrim(mv_par07)=="**"
		cWhereD3 += " SD3.D3_LOCAL BETWEEN ' ' AND 'ZZZZ' AND "
	else
		cWhereD3 += " SD3.D3_LOCAL ='"+mv_par07+"' AND" 
	endif
  	   	
	If !lTranSB2 
		cWhereD3 += " SD3.D3_LOCAL <> '"+cDepTrf+"' AND"
	EndIf
   	If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
   		cWhereD3 += " SD3.D3_ESTORNO <> 'S' AND"
   	EndIf  
	If SuperGetMV('MV_D3SERVI', .F., 'N') == 'N' .And. IntDL()
		cWhereD3 += " ( (D3_SERVIC = '   ') OR (D3_SERVIC <> '   ' AND D3_TM <= '500' AND D3_STSERV = '3') ) AND"
	EndIf		      	
	cWhereD3 += "%"	

	cOrder := "%"
	If UPPER(TcGetDB()) != "INFORMIX"
		cOrder += " PRODUTO, EMISSAO, TES, UM,DTDIGIT" 	 	
	Else
		cOrder += " 2, 5, 4, 6"
	EndIf

	cOrder += "%"
	
	BeginSql Alias cAliasTop
		SELECT 	 F1_FILIAL FILIAL,
				 B1_TIPO TIPO, 				
		         D1_COD PRODUTO,
		         D1_SEQCALC SEQCALC,
		         D1_DTDIGIT EMISSAO,
		         D1_TES TES,
		         D1_CF CF, 
		         D1_ESPECIE TIPODOC,
		         D1_DOC NUMDOC,
		         D1_SERIE SERIE,
		         sum(D1_QUANT) QUANT,
		         D1_FORNECE CLIFOR,
		         D1_LOJA LOJA,
		         D1_UM UM,
		         D1_DTDIGIT DTDIGIT,
		         F1_NODIA NODIA,
		         F1_SERIE2 SERIE2,
		         %exp:cYSerieF1% SERIE3,
		         D1_LOCAL XLOCAL,
		         D1_ITEM XITEM
		         
	
		FROM %table:SD1% SD1,%table:SF4% SF4,%table:SB1% SB1,%table:SF1% SF1
		//SD1.D1_LOCAL   =  %Exp:mv_par07%  AND
		WHERE SD1.D1_FILIAL  =  %xFilial:SD1%	AND
              SD1.D1_COD     >= %Exp:mv_par01% 	AND
              SD1.D1_COD     <= %Exp:mv_par02%  AND
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
			  SB1.B1_COD     = SD1.D1_COD 		AND
              SB1.B1_TIPO    >= %Exp:mv_par03% 	AND
              SB1.B1_TIPO    <= %Exp:mv_par04% 	AND          			  
              SB1.%NotDel%     						AND         
				SF1.F1_FILIAL = %xFilial:SF1%  AND 
				SF1.F1_DOC = SD1.D1_DOC   AND
				SF1.F1_SERIE = SD1.D1_SERIE AND 
				SF1.F1_FORNECE = SD1.D1_FORNECE  AND 
				SF1.F1_LOJA = SD1.D1_LOJA      AND   	 		
				SF1.F1_TIPO = SD1.D1_TIPO      AND  
              SF1.%NotDel%                     	         
              
    		  GROUP BY %exp:cGroupF1%         
	    UNION
   		SELECT 	F2_FILIAL FILIAL,
   				B1_TIPO TIPO,
		        D2_COD PRODUTO,
		        D2_SEQCALC SEQCALC,
		        %Exp:cD2EMISSAO%
		        D2_TES TES,
		        D2_CF CF,
		        D2_ESPECIE TIPODOC,
		        D2_DOC NUMDOC,
		        D2_SERIE SERIE,
		        sum(D2_QUANT) QUANT,
		        D2_CLIENTE CLIFOR,
		        D2_LOJA LOJA,
		        D2_UM UM, 
		        D2_DTDIGIT DTDIGIT, 
		        F2_NODIA NODIA,
		        F2_SERIE2 SERIE2,
		        %exp:cYSerieF2% SERIE3,
		        D2_LOCAL XLOCAL,
		        D2_ITEM XITEM

		FROM %table:SD2% SD2,%table:SF4% SF4,%table:SB1% SB1,%table:SF2% SF2

		WHERE SD2.D2_FILIAL  =  %xFilial:SD2%	AND
              SD2.D2_COD     >= %Exp:mv_par01% 	AND
              SD2.D2_COD     <= %Exp:mv_par02% AND          
		      %Exp:cWhereD2%
			  SD2.D2_ORIGLAN <> 'LF'           	AND
			  %Exp:cWhereRE%                   	AND
			  SD2.%NotDel%						AND
			  SF4.F4_FILIAL  =  %xFilial:SF4%	AND 	
			  SF4.F4_CODIGO  = SD2.D2_TES 		AND
			  SF4.F4_ESTOQUE = 'S' 				AND
			  SF4.%NotDel%                     	AND      
			  SB1.B1_FILIAL  =  %xFilial:SB1%	AND 	
			  SB1.B1_COD     = SD2.D2_COD 		AND
              SB1.B1_TIPO    >= %Exp:mv_par03% 	AND
              SB1.B1_TIPO    <= %Exp:mv_par04% 	AND          			  
              SB1.%NotDel%                      AND
				SF2.F2_FILIAL = %xFilial:SF2%  AND 
				SF2.F2_DOC = SD2.D2_DOC   AND 
				SF2.F2_SERIE = SD2.D2_SERIE AND 
				SF2.F2_CLIENTE = SD2.D2_CLIENTE  AND 
				SF2.F2_LOJA = SD2.D2_LOJA      AND 	
				SF2.F2_TIPO = SD2.D2_TIPO      AND	  
              SF2.%NotDel%                     	             			  

              GROUP BY %exp:cGroupF2%           	             			  
		UNION		
   		SELECT 	D3_FILIAL FILIAL,
   				B1_TIPO TIPO,
		        D3_COD PRODUTO,
		        D3_SEQCALC SEQCALC,
		        D3_EMISSAO EMISSAO, 
		        D3_TM TES, 
		        D3_CF CF, 
		        D3_CF TIPODOC,
		        D3_DOC NUMDOC,
		        ' ' SERIE,
		        sum(D3_QUANT) QUANT,
				' ' CLIFOR,
				' ' LOJA,	
				D3_UM UM,
				D3_EMISSAO DTDIGIT, 
				D3_NODIA NODIA, 
				' ' SERIE3,
				' ' SERIE2,
				D3_LOCAL XLOCAL,
				' ' XITEM
				
		FROM %table:SD3% SD3,%table:SB1% SB1

		WHERE SD3.D3_FILIAL  =  %xFilial:SD3%	AND
              SD3.D3_COD     >= %Exp:mv_par01% 	AND
              SD3.D3_COD     <= %Exp:mv_par02% AND
		      SD3.D3_EMISSAO >= %Exp:mv_par05% 	AND
			  SD3.D3_EMISSAO <= %Exp:mv_par06%	AND
			  %Exp:cWhereD3%                      
			  SD3.%NotDel%						AND
			  SB1.B1_FILIAL  =  %xFilial:SB1%	AND 	
			  SB1.B1_COD     = SD3.D3_COD 		AND
              SB1.B1_TIPO    >= %Exp:mv_par03% 	AND
              SB1.B1_TIPO    <= %Exp:mv_par04% 	AND          			  
              SB1.%NotDel%                     	                       

          GROUP BY D3_FILIAL,B1_TIPO,D3_COD,D3_SEQCALC,D3_EMISSAO,D3_TM,D3_CF,D3_CF,D3_DOC,D3_UM,D3_EMISSAO,D3_NODIA,D3_LOCAL
		ORDER BY %Exp:cOrder%
		
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
	
	aEval(aCampos, {|e| If(e[2]!= "C", TCSetField("TRC", e[1], e[2],e[3],e[4]),Nil)})
	MTR264FillTrb(aCampos)	
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicio da impressao do fluxo do relatório                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SB9->(dbSetOrder(1)) //B9_FILIAL, B9_COD, B9_LOCAL, B9_DATA
	//xLocal := alltrim(mv_par07)
	
	dbSelectArea("SB1") 
	SB1->(dbSetOrder(1)) //B1_FILIAL+B1_COD
	SB1->(dbSeek(xFilial()+mv_par01,.T.))
	
	dbSelectArea("TRB")
	oReport:SetMeter(TRB->(LastRec()))
	dbGoTop()
	
	CFilialProd := ""
	cEstabProd	:= ""
	aLocalFiR	:= {}
	aLocalFiR	:= {}
		 
	While !oReport:Cancel() .And. TRB->(!Eof())
		
		nEntradas := 0
		nSalidas  := 0
		lImpCabec := .T.
	    //lSB9ok    := .F.
		cProduto  := TRB->PRODUTO
		zLocal := TRB->XLOCAL 
		CprodAux := ""
		
		If TRB->FILIAL <> cFilialProd
			cFilialProd := TRB->FILIAL
			aLocalFiR := LocFilial(zLocal,TRB->FILIAL,TRB->PRODUTO)
	    EndIF 

		If TRB->XIDESTAB <> cEstabProd
			cEstabProd := TRB->XIDESTAB
	    EndIF 

		SB1->(MsSeek(xFilial("SB1")+TRB->PRODUTO))
		SB5->(MsSeek(xFilial("SB5")+TRB->PRODUTO))  
		
		If oReport:Cancel()
			Exit
		EndIf
			
		oSection3:Cell("nSALDQtd"):SetValue(0)
		oSection3:Cell("nENTQtd") :SetValue(0)
		oSection3:Cell("nSAIQtd") :SetValue(0)  
		
		if TRB->NUMDOC == "*SINMOV*"
	
			aSalAtu   := {0,0,0,0,0,0,0}
			nQtini :=0
			nSalIni:=0
				
			For nX:=1 To Len(aLocalFiR)
				IF aLocalFiR[nX,1]
				   aSalatu1:=fCalcEst(SB1->B1_COD,aLocalFiR[nX,2],MV_PAR05,TRB->FILIAL)
				   nQtIni +=aSalAtu1[1]           // QUANTIDADE 
				   //nSalIni+=aSalAtu1[MV_PAR10+1]  // VALOR 
				ENDIF
			Next     
				
			if nQtini == 0
				TRB->(dbSkip())
				loop
			endif
				
			aSalAtu[1]         +=nQtIni
			//aSalAtu[mv_par10+1]+=nSalIni
	
			oSection1:Init()
			oSection1:Cell("CODIGO"):SetValue(SB1->B1_COD)    
			oSection1:Cell("TIPO")  :SetValue(SB1->B1_TIPOEX)
			oSection1:Cell("DESC")  :SetValue(SB1->B1_DESC)
			oSection1:Cell("CODUN") :SetValue(fTabla6(SB1->B1_UM))
			oSection1:Cell("ESTABL") :SetValue(TRB->XIDESTAB+' - '+Posicione("SX5",1,xFilial("SX5")+"XZ"+TRB->XTPESTAB,"SX5->X5_DESCSPA") )

			oSection1:PrintLine()
			oSection1:Finish()
				
			oSection3:Init()
			oSection3:Cell("dDtMov")  :SetValue(MV_PAR05)
			oSection3:Cell("Tp Oper") :SetValue('16')
			oSection3:Cell("nENTQtd") :Show()
			oSection3:Cell("nENTQtd") :SetValue(nQtini)
			oSection3:Cell("nSALDQtd"):SetValue(nQtini)
			oSection3:Cell("cCF")     :Hide()
			oSection3:Cell("SERIE")   :Hide()
			oSection3:Cell("cDoc")    :Hide()
	   		oSection3:Cell("TIPO")    :Hide()
			oSection3:PrintLine()
			oReport:PrintText("NO HUBO MOVIMIENTO PARA ESTE PRODUCTO")
			oSection3:Finish()
			oReport:ThinLine()
	
			TRB->(dbSkip())
			loop

		endif
		
		If !lQuery .Or. (lQuery .And. TRB->PRODUTO == cProduto /*SB1->B1_COD*/)
		
			CprodAux := ""

			While TRB->(!Eof()) .And. TRB->PRODUTO == cProduto .and. TRB->XIDESTAB == cEstabProd
		
				If oReport:Cancel()
					Exit
				EndIf				
				
				zLocal := TRB->XLOCAL
				
				oReport:IncMeter()  
				
				If CprodAux <> TRB->PRODUTO		//SB1->B1_COD
					oSection1:Init()
					oSection1:Cell("CODIGO"):SetValue(SB1->B1_COD)    
					oSection1:Cell("TIPO")  :SetValue(SB1->B1_TIPOEX)
					oSection1:Cell("DESC")  :SetValue(SB1->B1_DESC)
					oSection1:Cell("CODUN") :SetValue(fTabla6(SB1->B1_UM))
					oSection1:Cell("ESTABL") :SetValue(TRB->XIDESTAB+' - '+Posicione("SX5",1,xFilial("SX5")+"XZ"+TRB->XTPESTAB,"SX5->X5_DESCSPA") )
					oSection1:PrintLine()
					CprodAux:= TRB->PRODUTO		//SB1->B1_COD

	                nQtini :=0
	                nSalIni:=0

					For nX:=1 To Len(aLocalFiR)
						IF aLocalFiR[nX,1]
						   aSalatu1:=fCalcEst(SB1->B1_COD,aLocalFiR[nX,2],MV_PAR05,TRB->FILIAL)
						   nQtIni +=aSalAtu1[1]           // QUANTIDADE 
						   //nSalIni+=aSalAtu1[MV_PAR10+1]  // VALOR 
						ENDIF
					Next     
			            
		            oSection3:Init()
		           	cTP:=""
					cTP:="16"
					oSection3:Cell("dDtMov")  :SetValue(MV_PAR05)
					oSection3:Cell("Tp Oper") :SetValue(cTP)
					oSection3:Cell("nENTQtd") :Show()
					oSection3:Cell("nENTQtd") :SetValue(nQtini)
					oSection3:Cell("nSALDQtd"):SetValue(nQtini)
					/*
					oSection3:Cell("nSAIQtd") :Hide()
					oSection3:Cell("dDtMov")  :Hide() 
					oSection3:Cell("cCF")     :Hide() 				
					oSection3:Cell("SERIE")   :Hide() 																
					oSection3:Cell("cDoc")    :Hide()
			   		oSection3:Cell("TIPO")    :Hide()	
					oSection3:PrintLine()
					*/
					//oSection3:Cell("nSALDQtd"):SetValue(0)
					//oSection3:Cell("nSAIQtd") :SetValue(0)
					//oSection3:Cell("nSAIQtd") :Show()
					oSection3:Cell("cCF")     :Hide()
					oSection3:Cell("SERIE")   :Hide()
					oSection3:Cell("cDoc")    :Hide()
			   		oSection3:Cell("TIPO")    :Hide()
			   		oSection3:PrintLine()
			   		
	            EndIf
	            
				dbSelectArea("TRB")
		
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica la fecha para productos sin movimientos        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cTIPODOC := TRB->TIPODOC
				If lQuery
				 	If alltrim(TRB->TIPODOC) $ "FT/NF/"
				    	cTIPODOC := "FAC"
				 	EndIf
			  	EndIf
				//If CtoD("  /  /  ") != EMISSAO

					oSection3:Cell("dDtMov"):Show()
					oSection3:Cell("dDtMov"):SetValue(EMISSAO)
					
					oSection3:Cell("cCF")   :Show()
					oSection3:Cell("cCF")   :SetValue(cTIPODOC)
				
					// ----------------------------------------------------------------------------------- //
					// Adicionado por SISTHEL para impresion de la serie 3 ( campo customizado )		   //
					// ----------------------------------------------------------------------------------- //
					_cSerieNf := SERIE

					If TES > "500" // Documentos de Salida
						SFP->(dbSetOrder(5)) //FP_FILIAL+FP_FILUSO+FP_SERIE+FP_ESPECIE
						If SFP->( dbSeek( xFilial("SFP")+cFilAnt+_cSerieNf+"1" ) )
							If SFP->&(cPosCpo + '("FP_YSERIE")') > 0 .And. !Empty(SFP->FP_YSERIE)
								_cSerieNf := Alltrim(SFP->FP_YSERIE)
							EndIf
						Else
							If SFP->( dbSeek( xFilial("SFP")+cFilAnt+_cSerieNf+"6" ) )
								If SFP->&(cPosCpo + '("FP_YSERIE")') > 0 .And. !Empty(SFP->FP_YSERIE)
									_cSerieNf := Alltrim(SFP->FP_YSERIE)
								EndIf
							EndIf
						EndIf
					Else 
						If !Empty(SERIE3)
							_cSerieNf := Alltrim(SERIE3)
						EndIf
					EndIf
					
					If !Empty(SERIE2)
						_cSerieNf := Alltrim(SERIE2)
					EndIf
					
					If Alltrim(TRB->NUMDOC) $ "INVENT" .AND. Alltrim(TRB->CF) $ "DE0|RE0"
						_cSerieNf :=  Alltrim(cSerKINV)
					Elseif Alltrim(TRB->CF) $ "DE0|DE1|DE4|DE6|ER0|PR0|RE0|RE1|RE4|RE6"
						_cSerieNf :=  Alltrim(cSerKTM)
					EndIf
				
					oSection3:Cell("SERIE") :Show()
					oSection3:Cell("SERIE") :SetValue(_cSerieNf)
					
					oSection3:Cell("cDoc")  :Show()
					oSection3:Cell("cDoc")  :SetValue(Right(NUMDOC,8))
	
					If TES <= "500" 
						oSection3:Cell("nENTQtd"):Show()
						oSection3:Cell("nENTQtd"):SetValue(QUANT)
						
						aSalAtu[1]:= aSalAtu[1]+ QUANT
						
						oSection3:Cell("nSAIQtd"):SetValue(0)				            
						oSection3:Cell("nSAIQtd"):Hide() 
					Else                
						oSection3:Cell("nSAIQtd"):Show()
						oSection3:Cell("nSAIQtd"):SetValue(QUANT)

						aSalAtu[1]:= aSalAtu[1] - QUANT

						oSection3:Cell("nENTQtd"):SetValue(0)										            
						oSection3:Cell("nENTQtd"):Hide()
					EndIf	         
		
			        If aSalAtu[1] != 0
						oSection3:Cell("nSALDQtd"):Show()
						oSection3:Cell("nSALDQtd"):SetValue(aSalAtu[1])			
		        	Else
						//oSection3:Cell("nSALDQtd"):Hide()
						oSection3:Cell("nSALDQtd"):Show()
						oSection3:Cell("nSALDQtd"):SetValue(aSalAtu[1])
		        	EndIf
	
					cMovto := ""
		
					If TRB->TES > "500" .And. ALLTRIM(TRB->TIPODOC) $ "REM|NF|FAC|RFN"
						cMovto := OemToAnsi(STR0030) //"CLI"
					ElseIf TRB->TES > "500" .And. ALLTRIM(TRB->TIPODOC) $ "RE0|DE0|RE8|DE8"
						cMovto := OemToAnsi(STR0032) //"CC"
					ElseIf TRB->TES <= "500" .And. ALLTRIM(TRB->TIPODOC) $ "RE6|DE6"
						cMovto := OemToAnsi(STR0034) //"MAN"
					ElseIf TRB->TES <= "500" .And. ALLTRIM(TRB->TIPODOC) $ "RE8|DE8"
						cMovto := OemToAnsi(STR0032) //"CC"
					ElseIf TRB->TES <= "500" .And. ALLTRIM(TRB->TIPODOC) $ "REM|NF|FAC|RFN"
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
						oSection3:Cell("Tp Oper"):Show()
						oSection3:Cell("Tp Oper"):SetValue(cTP)
					ElseIf ALLTRIM(TRB->TIPODOC) $ "REM|NF|FAC|RCN|RFN"
						DbSelectArea("SF4")
						SF4->(dbSetOrder(1)) //F4_FILIAL+F4_CODIGO
						If dbseek(cFilial+TRB->TES)
							oSection3:Cell("Tp Oper"):Show()
							oSection3:Cell("Tp Oper"):SetValue(SF4->F4_TPOP)
						EndIf 
					Else
						cTP:=""
					    cTP:="99"
					    oSection3:Cell("Tp Oper"):Show()
					 	oSection3:Cell("Tp Oper"):SetValue(cTP)
					EndIf
			        RestArea(aArea)
		           	
		           	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Carrega os Tipos de Operacao ref. a tabela 10 da lei    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					oSection3:Cell("TIPO"):Show()
		            If ALLTRIM(TRB->TIPODOC) $ "NDI" 
		           		oSection3:Cell("TIPO"):SetValue("07")
		           	ElseIf ALLTRIM(TRB->TIPODOC) $ "FAC" 
		           		oSection3:Cell("TIPO"):SetValue("01")
		           	ElseIf ALLTRIM(TRB->TIPODOC) $ "RCN/RTS/RTE/RFN/RCD" 
		           		oSection3:Cell("TIPO"):SetValue("09")
		            ElseIf ALLTRIM(TRB->TIPODOC) $ "NCC" 
		           		oSection3:Cell("TIPO"):SetValue("08")
		           	Else
		           		oSection3:Cell("TIPO"):SetValue("00")
		            EndIf
		
					nEntradas += Iif(TES <= "500",QUANT,0)
		         	nSalidas  += Iif(TES >  "500",QUANT,0)
	
					oSection3:PrintLine()
				//EndIf
		     	dbSelectArea("TRB")
				dbSkip()
			EndDo
		EndIf
		
		If (nEntradas + nSalidas) > 0
		   	oSection1:Finish()
			oSection2:Finish()
			oSection3:Finish()
			aSalAtu[1]:= 0
			oReport:ThinLine()		
	
		   	/*
		   	If lQuery
				SB1->(DbSkip())
			EndIf   
			*/
		Else
			//SB1->(DbSkip())
		EndIf
	EndDo
	
	dbSelectArea("SB1")
	DbClearFilter()
	SB1->(dbSetOrder(1)) //B1_FILIAL+B1_COD
	
	If MV_PAR11 == 1  // - IMPRESSÃO DO ARQUIVO MAGNETICO
		IF MSGYESNO(STR0086) //"¿Genera Archivo Magnético?"
		   Processa({|| GerArq(AllTrim(MV_PAR12))},,STR0086) //"¿Genera Archivo Magnético?"
		Endif   
	EndIf
	dbSelectArea("TRB")
	dbCloseArea()
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MTR264val³ Autor ³ Paulo Boschetti       ³ Data ³ 22.12.92 ³±±LA
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Mtr264val()
	If mv_par09 > 0 .And. mv_par09 < 3
	   Return .T.
	EndIf
Return .T.

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MTR264Dev³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 17/07/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Avalia se item pertence a uma nota de devolu‡ao             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR264                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MTR264Dev()
	Local cAlias:=Alias(),lRet:=.F.
	
	If cAlias == "SD1"
	   dbSelectArea("SF1")
	   dbSeek(cFilial+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA)
	   If SF1->F1_TIPO == "D"
	      lRet:=.T.
	   EndIf
	ElseIf cAlias == "SD2"
	   dbSelectArea("SF2")
	   dbSeek(cFilial+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA)
	   If SF2->F2_TIPO == "D"
	      lRet:=.T.
	   EndIf
	EndIf
	dbSelectArea(cAlias)
Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MTR264NFExp ³ Autor ³Lucas				 ³ Data ³18/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Carrega arquivo TRB com resultado da Query                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR264                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MTR264FillTrb(aCampos)

	Local cNomeArq:=CriaTrab(aCampos)
	Local aCodsPrds := {}
	Local _cAlias := getNextAlias()
	Local cNoProds := ""
	
	If Select("TRB") > 0		
		TRB->(DbCloseArea())
	EndIf
	
	NNR->( dbSetOrder(1) )
	
	//MATR264CT()

	dbUseArea( .T., __cRDDNTTS, cNomeArq, "TRB", if(.F. .Or. .F., !.F., NIL), .F. )
	//IndRegua("TRB",cNomeArq,'PRODUTO+XLOCAL+FILIAL+Dtos(EMISSAO)+NODIA+TES',,,STR0019)  //"Selecionando Registros..."
	IndRegua("TRB",cNomeArq,'PRODUTO+XIDESTAB+XLOCAL+XTPESTAB+FILIAL+Dtos(EMISSAO)+NODIA+TES',,,STR0019)  //"Selecionando Registros..."
			
	DbSelectArea("TRC")
	DbGoTop()
	While !Eof()
	
		if TRC->QUANT==0
			DbSelectArea("TRC")
			DbSkip()
			Loop
		endif
		
		NNR->( MsSeek( xFilial("NNR")+TRC->XLOCAL ) )
	
		DbSelectArea("TRB")
		Reclock("TRB",.T.)
		Replace 	PRODUTO 	With	TRC->PRODUTO
		Replace 	EMISSAO 	With	TRC->EMISSAO
		Replace 	SEQCALC 	With	TRC->SEQCALC
		Replace 	TES 		With	TRC->TES        
		Replace 	CF 			With	TRC->CF
		Replace 	TIPODOC 	With	If(AllTrim(TRC->TIPODOC) $ "FT|NF","FAC",TRC->TIPODOC)
		Replace 	NUMDOC 		With	TRC->NUMDOC
		Replace 	SERIE 		With	TRC->SERIE
		Replace 	QUANT 		With	TRC->QUANT
		Replace 	CLIFOR	 	With	TRC->CLIFOR
		Replace 	LOJA		With	TRC->LOJA
		Replace 	UM			With	TRC->UM 
		Replace 	DTDIGIT		With	TRC->DTDIGIT 
		Replace 	NODIA		With	getNodiaOrig(TRC->SERIE,Right(AllTrim(TRC->NUMDOC),8),TRC->TIPODOC,TRC->CLIFOR,TRC->LOJA,TRC->NUMDOC,TRC->FILIAL)	//TRC->NODIA
		Replace 	SERIE3 		With	TRC->SERIE3
		Replace 	SERIE2 		With	TRC->SERIE2
		Replace 	FILIAL 		With	TRC->FILIAL
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
	EndDo
	
	// --------------------------------- //
	// adiciona productos sin movimiento //
	// --------------------------------- //
	
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
	cQuery += "   AND B9_QINI<>0"+CRLF

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAlias,.T.,.T.)
	
	if (_cAlias)->( !eof() )
	
		While (_cAlias)->( !Eof() )
	
			//if Ascan( aCodsPrds, (_cAlias)->B9_COD ) == 0
			
				NNR->( MsSeek( xFilial("NNR")+(_cAlias)->B9_LOCAL ) )

				DbSelectArea("TRB")
				TRB->(Reclock("TRB",.T.))
				Replace 	TRB->PRODUTO 	With	(_cAlias)->B9_COD
				Replace 	TRB->EMISSAO 	With	dDataAnt
				Replace 	TRB->NUMDOC 	With	"*SINMOV*"
				Replace 	TRB->DTDIGIT	With	dDataAnt
				Replace 	TRB->FILIAL 	With	(_cAlias)->B9_FILIAL
				Replace 	TRB->XLOCAL 	With	(_cAlias)->B9_LOCAL
				Replace 	TRB->XTPESTAB	With	NNR->NNR_TIPOES
				Replace 	TRB->XIDESTAB	With	NNR->NNR_IDSUNA
				TRB->(MsUnLock())

			//Endif
			
			(_cAlias)->( dbSkip() )
			
		Enddo
		
	EndIf
	
	(_cAlias)->( dbCloseArea() )
		
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Cabec264   ³ Autor ³ Bruno Schmidt       ³ Data ³ 15/06/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±ºDesc.     ³Cria o cabecalio da rotia		                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATR262                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Cabec264( oReport )
	Local aArea		:= GetArea()
	Local aCabec	:= {}
	Local cChar		:= chr(160)  // caracter dummy para alinhamento do cabeçalho
	Local cPERIODO	:= ""
	
	SX3->( DbSetOrder(2) )
	SX3->( MsSeek( "A1_CGC" , .T.))
	
	cPERIODO := dtoC(mv_par05)+" "+STR0079+" "+DtoC(mv_par06) 
	 
	If SM0->(Eof())                                
		SM0->( MsSeek( cEmpAnt + cFilAnt , .T. ))
	Endif
	
	aCabec := {	"__LOGOEMP__" , cChar + "         " ;
		      + "         " + cChar + RptFolha+ TRANSFORM(oReport:Page(),'999999');
	          , cChar + "         " ;
	          + "         " + cChar ;
	          , "SIGA /" + 'MATR264' + " /v." + cVersao ; 
	          + "         " + cChar + UPPER(AllTrim(titulo)) ;
	          + "         " + cChar;
	          , RptHora + " " + time() + Iif(__Language=="SPANISH",  "         " + cChar + SubStr(STR0001,95,50)," ") + "         " + cChar + RptEmiss + " " + Dtoc(dDataBase),;
	          + "  ",;
	          + STR0087 + cPERIODO,; //"PERIODO :"
	          + STR0088 + SM0->M0_CGC,; //" RUC.: "
	          + (STR0089 +Trim(SM0->M0_NOMECOM)),; //"APELLIDOS Y NOMBRES, DENOMINACIÓN O RAZÓN SOCIAL: "
	          + "  "}
	          
	          //+ "__NOTRANSFORM__"+ STR0090 + Alltrim( MV_PAR10 )+cChar,; //"ESTABLECIMIENTO: "
	          //+ (STR0089 +Trim(SM0->M0_NOME) + "/" + Trim(SM0->M0_FILIAL)),; //"APELLIDOS Y NOMBRES, DENOMINACIÓN O RAZÓN SOCIAL: "
	
	RestArea( aArea ) 
Return aCabec

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao     ³ GerArq   ³ Autor ³                     ³ Data ³ 04.01.2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao  ³ Gera o arquivo magnético do Registro de Inventário         ³±±
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
	Local dEmiss		:= CTOD("  /  /  ")
	Local nCont			:= 0
	Local cArq			:= ""
	Local dDtDigit		:= CTOD("  /  /  ")
	Local cExisten		:= " "
	Local cSerKINV		:= SuperGetMv("MV_SERKINV" ,.F.,.F.)    
	Local cSerKTM		:= SuperGetMv("MV_SERKTM" ,.F.,.F.)    
	Local lUsaCodBar	:= SuperGetMv("MV_USACBAR" ,.F.,.F.) 
	Local lusaTsx5		:= SuperGetMv("MV_USATSX5" ,.F.,.F.) 
	Local cFilialProd	:= ""
	Local cNodiaAnt		:= "XX"
	Local cProd			:= ""

	Private lSerie2		:= GetNewPar("MV_LSERIE2",.T.)
	private nCorr		:= 1
	Private aSelFil		:= {}
	Private nHdl		:= 0
	private nInd		:= 0
	
	aSelFil := {cFilAnt} 
	
	FOR nCont:=LEN(ALLTRIM(cDir)) TO 1 STEP -1
		IF SUBSTR(cDir,nCont,1)=='\'
			cDir:=Substr(cDir,1,nCont)
			EXIT
		ENDIF
	NEXT
	
	// Nome do arquivo TXT a ser impresso
	cArq += "LE"                            // Fixo  'LE'
	cArq +=  AllTrim(SM0->M0_CGC)           // Ruc
	cArq +=  AllTrim(Str(Year(MV_PAR06)))   // Ano
	cArq +=  AllTrim(Strzero(Month(MV_PAR06),2))  // Mes
	cArq +=  "00"                            // Fixo '00'
	cArq += "120100"                         // Fixo '120100' 
	cArq += "00"                             // Fixo '00'
	cArq += "1"
	cArq += "1"
	cArq += "1"
	cArq += "1"
	cArq += ".TXT" // Extensao
	
	nHdl := fCreate(cDir+UPPER(cArq),Nil,Nil,.F.)
	If nHdl <= 0
		ApMsgStop(STR0091) //"Ha ocurrido un error al crear el archivo. Intente nuevamente."
	Else
		dbSelectArea("TRB")
		TRB->(dbGoTop())
		Do While TRB->(!EOF())
		
			if TRB->QUANT==0
				TRB->( dbSkip() )
				Loop
			endif
			
			if alltrim(TRB->NUMDOC)=="*SINMOV*"
				TRB->( dbSkip() )
				Loop
			endif
		
			dEmiss		:= TRB->EMISSAO
			dDtDigit	:= TRB->DTDIGIT	
			cLin		:= ""	// Limpa conteúdo CLin

			//If ((cFilialProd <> TRB->FILIAL).Or.(AllTrim(TRB->PRODUTO) <> AllTrim(cProd)))
			If ((cFilialProd <> TRB->XIDESTAB).Or.(AllTrim(TRB->PRODUTO) <> AllTrim(cProd)))
				//GenSldIni(TRB->PRODUTO,TRB->FILIAL)
				fSaldoIni(TRB->PRODUTO,TRB->XIDESTAB)
				cFilialProd := TRB->XIDESTAB
				cProd := TRB->PRODUTO
				//cEstmento := RetEstable()
				//cEstmento := RetEstable(cFilialProd)
				cEstmento := TRB->XIDESTAB
			EndIF	
					
			// - 01 Periodo
			cLin += SubStr(DTOS(dEmiss),1,6)+"00"
			cLin += cSep
						
			// - 02 Código Único de la Operación (CUO)			
			//cLin += ALLTRIM(TRB->NODIA)
			//cLin += cSeP
			// - 02 Código Único de la Operación (CUO)
			if empty(TRB->NODIA)
				/*
				If TRB->TES >= "500" // Documentos de Salida
					SF2->( DbSetOrder(1) ) //F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
					SF2->( MsSeek(TRB->FILIAL+TRB->NUMDOC+TRB->SERIE+TRB->CLIFOR+TRB->LOJA) )
					if empty(SF2->F2_NODIA)
						cLin += getSegofi(SF2->F2_NODIA,SF2->F2_MOEDA)
					else
						cLin += "CUO-VACIO"
					endif
				elseIf TRB->TES < "500" // Documentos de Salida
					SF1->( DbSetOrder(1) ) //F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
					SF1->( MsSeek(TRB->FILIAL+TRB->NUMDOC+TRB->SERIE+TRB->CLIFOR+TRB->LOJA) )
					if empty(SF2->F2_NODIA)
						cLin += getSegofi(SF1->F1_NODIA,SF1->F1_MOEDA)
					else
						cLin += "CUO-VACIO"
					endif
				else
					cLin += "CUO-VACIO"		//getNodiaOrig(TRB->SERIE,Right(AllTrim(TRB->NUMDOC),8))
				endif
				*/
				cLin += "CUO-VACIO"
			else
				cLin += AllTrim(TRB->NODIA)
			endif
			cLin += cSeP
	
							
			// - 03 correlativo
			/*
			If !Empty (AllTrim(TRB->NODIA)) .and. cNodiaAnt <> AllTrim(TRB->NODIA)
				cNodiaAnt := AllTrim(TRB->NODIA)
				nSecNodia := 0
				cLin += "M"+StrZero(++nSecNodia,5)
			ElseIf !Empty (AllTrim(TRB->NODIA)) .and. cNodiaAnt == AllTrim(TRB->NODIA)
				cLin += "M"+StrZero(++nSecNodia,5)
			Else
				cLin += "000000"	
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
			//cLin += AllTrim(MV_PAR10)
			cLin += AllTrim(cEstmento)
			cLin += cSep
								
			// - 05 Código del catálogo utilizado tabela 13 -  USAR 3(EAN) OU 9(OUTROS)	
		 	lCodBar:=.F. 
		 	SB1->(DbSetOrder(1)) //B1_FILIAL+B1_COD
			SB1->(MsSeek(xFilial("SB1")+TRB->PRODUTO))
			If SB1->B1_CODBAR <> " "  .and. lUsaCodBar
				lCodBar:=.T.
				cLin += "3"
			Else
				cLin += "9"	
			EndIf	
			cLin += cSep	 
				
			// - 06 Tipo de existencia  - tabela 5, Creado en el UPDEST43	
			cLin += ALLTRIM(SB1->B1_TIPOEX)					
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
				SB5->(DbSetOrder(1)) //B5_FILIAL+B5_COD
				If ALLTRIM(xFilial("SB5")) <> ""
					SB5->(DbSeek(TRB->FILIAL+TRB->PRODUTO))
				Else
					SB5->(DbSeek(xFilial("SB5")+TRB->PRODUTO))
				EndIF
				cLin += ALLTRIM(SB5->B5_CODEXIS)
			Else
				cLin += ""
			EndIf
			cLin += cSep
			*/
			If SB1->(FieldPos("B1_PRODSAT")) > 0
				cLin += ALLTRIM(SB1->B1_PRODSAT)+"00000000"
			Else
				cLin += ""
			EndIf
			cLin += cSep
				
			// - 09 Fecha de emisión del documento de traslado, comprobante de pago, documento interno o similar
			cLin += SubStr(DTOC(dEmiss),1,6)+SubStr(DTOS(dEmiss),1,4)
			cLin += cSeP     
					
			// - 10 Tipo del documento de traslado, comprobante de pago, documento interno o similar TABELA 10			  
			If ALLTRIM(TRB->TIPODOC) $ "NDI"
				cLin +="07"
			ElseIf ALLTRIM(TRB->TIPODOC) $ "FAC"
				// ----------------------------------------------------------------------------------- //
				// Adicionado por SISTHEL para impresion de la serie 3 ( campo customizado )		   //
				// Adicionada a serie 12 para series de etiquetadoras								   //
				// ----------------------------------------------------------------------------------- //
				If TRB->TES > "500" // Documentos de Salida
					SFP->( dbSetOrder(5) ) //FP_FILIAL+FP_FILUSO+FP_SERIE+FP_ESPECIE
					If SFP->( dbSeek( xFilial("SFP")+cFilAnt+TRB->SERIE+"1" ) )
						If SFP->&(cPosCpo + '("FP_YSERIE")') > 0
							If Len(Alltrim((SFP->FP_YSERIE))) <= 4
								cLin +="01"
							Else
								cLin +="12"
							EndIf
						EndIf
					Else
						If SFP->( dbSeek( xFilial("SFP")+cFilAnt+TRB->SERIE+"6" ) )
							If SFP->&(cPosCpo + '("FP_YSERIE")') > 0
								If Len(Alltrim((SFP->FP_YSERIE))) <= 4
									cLin +="01"
								Else
									cLin +="12"
								EndIf
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
			ElseIf ALLTRIM(TRB->TIPODOC) $ "RCN/RTS/RTE/RFN/RCD" 
				cLin +="09"
	        ElseIf AllTrim(TRB->TIPODOC) $ "NDC" 
	          cLin +="08"		      
	        ElseIf AllTrim(TRB->TIPODOC) $ "NCC" 
	          cLin +="07"
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
					_cSerieNf := "0"
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
			If ALLTRIM(TRB->TIPODOC) $ "REM|NF|FAC|RCN|RFN"
				DbSelectArea("SF4")
				SF4->(dbSetOrder(1)) //F4_FILIAL+F4_CODIGO
				If dbseek(cFilial+TRB->TES)
					cLin += ALLTRIM(SF4->F4_TPOP)
				EndIf 
			Else
				cLin +="99"
			EndIf
			RestArea(aArea)	
				
			cLin += cSeP 
				
			// - 14 Descripción de la existencia P7 - Tabela 05 da Existencia, Creado en el UPDEST43
			SX5->(dbSetOrder(1)) //X5_FILIAL+X5_TABELA+X5_CHAVE
			SX5->(MsSeek(xFilial("SX5")+"P7"+SB1->B1_TIPOEX))
			if lusaTsx5
				cExisten := IIf(SX5->(Found()),Trim(X5Descri())," ")
			else
				cExisten := SUBSTR(SB1->B1_DESC,1,80)
			EndIf
			cLin += cExisten
			cLin += cSeP  
				  
			// - 15 Código Unidade de Medida TABELA 6, Creado en el UPDEST43
			cLin += alltrim(Posicione("SAH",1,xFilial("SAH")+SB1->B1_UM,"AH_CODERP"))			//ALLTRIM(SB5->B5_UNSUNAT)					
			cLin += cSeP  
	
			// - 16 Entradas de las unidades físicas (la primera tupla corresponde al saldo inicial)
			If ALLTRIM(TRB->TES) < "500" 										
				cLin += AllTrim(StrTran(Transform(TRB->QUANT,"@E 99999999.99"),",","."))			
			Else
				cLin += "0.00"
			Endif	
			cLin += cSeP 
			
			// - 17 Salidas de las unidades físicas. Somente negativo ou 0.00
			If ALLTRIM(TRB->TES) >= "500"	
				cLin += "-"+(AllTrim(StrTran(Transform(TRB->QUANT,"@E 99999999.99"),",",".")))					
			Else
				cLin += "0.00"
			Endif	
			cLin += cSeP
			
			// - 18 Indica el estado de la operación
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
			
		EndDo	
		fClose(nHdl)
		MsgAlert(STR0080,STR0092) //"Archivo"
	EndIf
Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ VerPar   ³ Autor ³                       ³ Data ³14.01.2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validar código do estabelecimento                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Fiscal Peru - Registro de Inventário - Arquivo Magnetico   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function VerPar()
	Local oReport
	
	Aviso(STR0081,STR0082,{STR0083},2)
Return(oReport)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ZMATR264  ºAutor  ³Microsiga           ºFecha ³  11/24/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RetEstable()

	Local cEstab := ""
	
	If SM0->( DbSeek(cEmpAnt+TRB->FILIAL) )
		IF ALLTRIM(SM0->M0_INSC)<>""
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
±±ºPrograma  ³ZMATR264  ºAutor  ³Microsiga           ºFecha ³  11/26/19   º±±
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
±±ºPrograma  ³ZMATR264  ºAutor  ³Microsiga           ºFecha ³  11/26/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function getSegofi(cNodia,cMoeda)

	local cgofi := cNodia
	local _cAlias := getNextAlias()
	local cSql := ""
	local cLp := ""
	local cKeyArr := ""
	local cKeyOri := ""
	local aCampos := {}
	local cTabla := ""
	         
	cSql := " SELECT CT2_LP,CT2_SEGOFI,CT2_KEY"
	cSql += "   FROM "+ RetSqlName("CT2")
	cSql += "  WHERE CT2_FILIAL = '"+xFilial("CT2")+"'"
	cSql += "    AND CT2_MOEDLC='"+strzero(cMoeda,2)+"'"
	cSql += "    AND CT2_NODIA='"+cgofi+"'"
	cSql += "    AND D_E_L_E_T_ = '' "	
	
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cSql ), _cAlias,.T.,.T.)

	If (_cAlias)->( !eof() )
		cLp := (_cAlias)->CT2_LP
	EndIf
		
	(_cAlias)->( dbCloseArea() )
	
	dbSelectArea("CTL")
	dbSetOrder(1) //CTL_FILIAL + CTL_LP
	
	If CTL->(dbSeek(xFilial("CTL") + cLp))
		cKeyArr := CTL->CTL_KEY
		cTabla := CTL->CTL_ALIAS
	EndIf
	
	If !Empty(cKeyArr) 
	
		aCampos := StrTokArr( cKeyArr, "+" )
		For nX := 1 To Len(aCampos)
			//cKeyOri += SF1->(&(aCampos[nX]))
			cKeyOri += (cTabla)->(&(aCampos[nX]))
		Next nX
	
		cSql := "SELECT TOP 1 CT2_SEGOFI"
		cSql += "  FROM "+ RetSqlName("CT2")
		cSql += " WHERE CT2_KEY='"+cKeyOri+"'"
		cSql += "   AND D_E_L_E_T_=''"
		cSql += "   AND CT2_MOEDLC='"+strzero(cMoeda,2)+"'"

		dbUseArea( .T., "TOPCONN", TcGenQry( ,, cSql ), _cAlias,.T.,.T.)
	
		If (_cAlias)->( !eof() )
			cgofi := (_cAlias)->CT2_SEGOFI
		EndIf
			
		(_cAlias)->( dbCloseArea() )

	EndIf
	
Return(cgofi)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ZMATR264  ºAutor  ³Microsiga           ºFecha ³  11/27/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
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
±±ºPrograma  ³ZMATR264  ºAutor  ³Microsiga           ºFecha ³  01/06/20   º±±
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
Local cNodiaAnt	:= "XX"
Local cSerKINV		:= SuperGetMv("MV_SERKINV" ,.F.,.F.)    
Local cSerKTM		:= SuperGetMv("MV_SERKTM" ,.F.,.F.)    
Local lUsaCodBar	:= SuperGetMv("MV_USACBAR" ,.F.,.F.) 
Local lusaTsx5		:= SuperGetMv("MV_USATSX5" ,.F.,.F.) 
Local cAlias		:= getNextAlias()

cQuantTo := 0
nCustoTo := 0

For nX := 1 To Len(aSelFil)

	//if Ascan( aFilImpre, aSelFil[nX] ) <= 0
	//if alltrim(aSelFil[nX]) == alltrim(cCodeSuc)

	cQry := "SELECT NNR_IDSUNA,NNR_TIPOES,NNR_CODIGO "
	cQry += "  FROM "+RetSqlName("NNR")
	cQry += " WHERE NNR_IDSUNA='" + cCodeSuc +"'"
	cQry += "   AND D_E_L_E_T_=''"
	cQry += " ORDER BY NNR_IDSUNA,NNR_CODIGO"
						
	cQry := ChangeQuery(cQry)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAlias,.T.,.T.)
		
	If (cAlias)->(!Eof())
	
		While (cAlias)->(!Eof())

			aSalAtu   := {0,0,0,0,0,0,0}
			nQtini :=0
			nSalIni:=0
		
		    //aLocalFiR := LocFilial(mv_par07,aSelFil[nX],cCodProd)
		    //aLocalFiR := LocFilial(mv_par07,cCodeSuc,cCodProd)
		    aLocalFiR := LocFilial((cAlias)->NNR_CODIGO,aSelFil[nX],cCodProd)
			     
			For ny:=1 To Len(aLocalFiR)
				IF aLocalFiR[ny,1]
				   aSalatu1:=fCalcEst(cCodProd,aLocalFiR[ny,2],MV_PAR05,aSelFil[nX])
				   //aSalatu1:=fCalcEst(cCodProd,aLocalFiR[ny,2],MV_PAR05,cCodeSuc)
				   nQtIni +=aSalAtu1[1]           // QUANTIDADE 
				   nSalIni+=aSalAtu1[2] 		 // VALOR 
				ENDIF
			Next     
			
			aSalAtu[1]      +=nQtIni
			aSalAtu[2]		+=nSalIni
		
			If nQtIni <> 0
		
				cLin:=""
				If (cFilProd <> (cAlias)->NNR_IDSUNA)
					cFilProd := (cAlias)->NNR_IDSUNA
					cEstmento := (cAlias)->NNR_IDSUNA
				EndIF	
			
				nCusto := 0
				nCusIni  := nSalIni
						
	
				// - 01 Periodo
				cLin += SubStr(DTOS(TRB->EMISSAO),1,6)+"00"
				cLin += cSep
							
				// - 02 Código Único de la Operación (CUO)			
				cLin += AllTrim("SLDINI")
				cLin += cSeP
		
				// - 03 correlativo
				cLin += "M"+StrZero(++nInd,5)
				cLin += cSeP
								
				// - 04 Estabelecimento		
				//cLin += AllTrim(MV_PAR10)
				cLin += AllTrim(cEstmento)
				cLin += cSep
									
				// - 05 Código del catálogo utilizado tabela 13 -  USAR 3(EAN) OU 9(OUTROS)	
			 	lCodBar:=.F. 
			 	SB1->(DbSetOrder(1)) //B1_FILIAL+B1_COD
				SB1->(MsSeek(xFilial("SB1")+TRB->PRODUTO))
				If SB1->B1_CODBAR <> " "  .and. lUsaCodBar
					lCodBar:=.T.
					cLin += "3"
				Else
					cLin += "9"	
				EndIf	
				cLin += cSep	 
					
				// - 06 Tipo de existencia  - tabela 5, Creado en el UPDEST43	
				cLin += ALLTRIM(SB1->B1_TIPOEX)					
				cLin += cSeP 
							  
				// - 07 Código propio de la existencia correspondiente al catálogo señalado en el campo 5. 
				If lCodBar
					cLin += AllTrim(SB1->B1_CODBAR)
				Else
					cLin += AllTrim(TRB->PRODUTO)	
				EndIf	
				cLin += cSep
									
				// - 08 Código de la existencia, de acuerdo al Catálogo de Bienes, Servicios y Obras (*) - UPDEST43
				If SB1->(FieldPos("B1_PRODSAT")) > 0
					cLin += ALLTRIM(SB1->B1_PRODSAT)+"00000000"
				Else
					cLin += ""
				EndIf
				cLin += cSep
					
				// - 09 Fecha de emisión del documento de traslado, comprobante de pago, documento interno o similar
				cLin += SubStr(DTOC(TRB->EMISSAO),1,6)+SubStr(DTOS(TRB->EMISSAO),1,4)
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
				SX5->(dbSetOrder(1)) //X5_FILIAL+X5_TABELA+X5_CHAVE
				SX5->(MsSeek(xFilial("SX5")+"P7"+SB1->B1_TIPOEX))
				if lusaTsx5
					cExisten := IIf(SX5->(Found()),Trim(X5Descri())," ")
				else
					cExisten := SUBSTR(SB1->B1_DESC,1,80)
				EndIf
				cLin += cExisten
				cLin += cSeP  
					  
				// - 15 Código Unidade de Medida TABELA 6, Creado en el UPDEST43
				cLin += alltrim(Posicione("SAH",1,xFilial("SAH")+SB1->B1_UM,"AH_CODERP"))			//ALLTRIM(SB5->B5_UNSUNAT)					
				cLin += cSeP  
		
				// - 16 Entradas de las unidades físicas (la primera tupla corresponde al saldo inicial)
				cLin += AllTrim(StrTran(Transform(nQtIni,"@E 99999999.99"),",","."))			
				cLin += cSeP 
				
				// - 17 Salidas de las unidades físicas. Somente negativo ou 0.00
				cLin += "0.00"
				cLin += cSeP
				
				// - 18 Indica el estado de la operación
				//	'1' cuando la operación corresponde al periodo Registrar 
				//	'8' cuando la operación corresponde a un periodo anterior y NO ha sido anotada en dicho periodo 
				//	'9' cuando la operación corresponde a un periodo anterior y SI ha sido anotada en dicho periodo."
				cLin += "1"
				cLin += cSeP 
	
				cLin += chr(13)+chr(10) // QUEBRA LINHA 
		
				fWrite(nHdl,cLin)
		    
		    EndIf
		    
		    (cAlias)->( dbSkip() )
		    
		Enddo

	EndIf		
	
	(cAlias)->( dbCloseArea() )

Next

RestArea(aAreaSb9)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ZMATR264  ºAutor  ³Microsiga           ºFecha ³  01/06/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
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
cSql003+= " AND SB2.B2_LOCAL = '"+cLocal1+"'"
cSql003+= " AND SB2.B2_COD='"+cProd+"'"
	
cSql003+= " UNION "
cSql003+= " SELECT DISTINCT B9_LOCAL LOCAL1  "
cSql003+= " FROM "+ RetSqlName("SB9") + " SB9"
cSql003+= " WHERE SB9.B9_FILIAL = '" + cFilsel + "'"
cSql003+= " AND SB9.D_E_L_E_T_ = ' ' "
cSql003+= " AND SB9.B9_LOCAL = '"+cLocal1+"'"
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
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ZMATR264  ºAutor  ³Microsiga           ºFecha ³  01/06/20   º±±
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
	
Return(aSaldo)

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
