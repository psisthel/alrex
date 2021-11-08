#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALRFAT04  ºAutor  ³Percy Arias,SISTHEL º Data ³  09/03/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Informe de Ventas General                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ALRFAT04()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Declaracao de variaveis                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private oReport  := Nil
	Private oSecCab	 := Nil
	Private cPerg 	 := PadR ("ALFAT04", Len (SX1->X1_GRUPO))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Definicoes/preparacao para impressao      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ReportDef()
	oReport:PrintDialog()	
	
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³JLTR001   ºAutor  ³Microsiga           º Data ³  09/08/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportDef()

	oReport := TReport():New(cPerg,"Informe de Ventas",cPerg,{|oReport| PrintReport(oReport)},"Informe de Ventas")
	oReport:SetLandscape(.T.)
	oReport:SetTotalInLine(.F.)
	oReport:SetTotalText("Totales ")

	//oSecCab := TRSection():New( oReport , "Informe de Ventas, periodo de "+mv_par01+" hasta "+mv_par02+" en SOLES", {"QRY"} )
	oSecCab := TRSection():New( oReport , "Informe de Ventas", {"QRY"} )

	TRCell():New( oSecCab, "C5_NUM"			, "QRY","PEDIDO"			,"@!",20)
	TRCell():New( oSecCab, "C6_ITEM"		, "QRY","ITEM"				,"@!",10)
	TRCell():New( oSecCab, "C5_CLIENTE"		, "QRY","R.U.C."	   		,"@!",20)
	TRCell():New( oSecCab, "C5_YNOMCLI"		, "QRY","NOMBRE CLIENTE"	,"@!",70)
	TRCell():New( oSecCab, "C6_YCODF"		, "QRY","FAMILIA"			,"@!",30)
	TRCell():New( oSecCab, "C5_LOGINCL"		, "QRY","USUARIOS"			,"@!",50)
	TRCell():New( oSecCab, "C5_EMISSAO"		, "QRY","EMISIÓN"			,,20)
	TRCell():New( oSecCab, "C5_YFVIGEN"		, "QRY","PREVISION"			,,20)
	TRCell():New( oSecCab, "C5_SUGENT"		, "QRY","ENTREGA SUG"		,,20)
	TRCell():New( oSecCab, "C9_DATALIB"		, "QRY","APROBACON"			,,20)
	TRCell():New( oSecCab, "C2_EMISSAO"		, "QRY","PRODUCCION"		,,20)
	TRCell():New( oSecCab, "QTDE"			, "QRY","CANTIDAD"			,"9,999.99",15,,,"RIGHT",,"RIGHT")
	TRCell():New( oSecCab, "ESTATUS"		, "QRY","ESTATUS"			,"@!",30)
	TRCell():New( oSecCab, "DOCUMENTO"		, "QRY","DOCUMENTO"			,"@!",15)
	
	
	//TRFunction():New(/*Cell*/             ,/*cId*/,/*Function*/,/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,/*lEndSection*/,/*lEndReport*/,/*lEndPage*/,/*Section*/)
	//TRFunction():New(oSecCab:Cell("F3_BASIMP1"),/*cId*/,"SUM"     ,/*oBreak*/,/*cTitle*/,PesqPict("SF3","F3_VALCONT"),/*uFormula*/,.F.,.T.,.F.,oSecCab)
	//TRFunction():New(oSecCab:Cell("F3_VALIMP1"),/*cId*/,"SUM"     ,/*oBreak*/,/*cTitle*/,PesqPict("SF3","F3_VALCONT"),/*uFormula*/,.F.,.T.,.F.,oSecCab)
	//TRFunction():New(oSecCab:Cell("INAFECTA"),/*cId*/,"SUM"     ,/*oBreak*/,/*cTitle*/,PesqPict("SF3","F3_VALCONT"),/*uFormula*/,.F.,.T.,.F.,oSecCab)
	//TRFunction():New(oSecCab:Cell("F3_VALCONT"),/*cId*/,"SUM"     ,/*oBreak*/,/*cTitle*/,PesqPict("SF3","F3_VALCONT"),/*uFormula*/,.F.,.T.,.F.,oSecCab)
	
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³JLTR001   ºAutor  ³Microsiga           º Data ³  09/08/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PrintReport(oReport)

	Local cQry := ""
	Local oSection := oReport:Section(1)
	
	Pergunte(cPerg,.F.)

	cQry += "SELECT C5_NUM,C6_ITEM,C5_CLIENTE,C5_YNOMCLI,C6_YCODF,UPPER(C5_LOGINCL) C5_LOGINCL,C5_EMISSAO,C5_YFVIGEN,C5_SUGENT,"+CRLF
	cQry += "SUM(C6_QTDVEN) QTDE"+CRLF
	cQry += "  FROM "+RetSqlName("SC5")+" C5"+CRLF
	cQry += "  LEFT JOIN "+RetSqlName("SC6")+" C6"+CRLF 
	cQry += "    ON C5_NUM=C6_NUM"+CRLF
	cQry += "   AND C5_CLIENTE=C6_CLI"+CRLF

	if MV_PAR01=="02" .Or. MV_PAR01=="03" .Or. MV_PAR01=="04"		// prevista o firme o apunte
		cQry += "  LEFT JOIN "+RetSqlName("SC2")+" C2"+CRLF
		cQry += "    ON C6_NUM=C2_PEDIDO"+CRLF
		cQry += "   AND C6_ITEM=C2_ITEMPV"+CRLF
	endif

	cQry += " WHERE C5_FILIAL='"+xFilial("SC5")+"'"+CRLF
	cQry += "   AND C6_FILIAL='"+xFilial("SC6")+"'"+CRLF

	if MV_PAR01=="02" .Or. MV_PAR01=="03" .Or. MV_PAR01=="04"		// prevista o firme o apunte
		cQry += "   AND C2_FILIAL='"+xFilial("SC2")+"'"+CRLF
	endif

	cQry += "   AND C5.D_E_L_E_T_=''"+CRLF
	cQry += "   AND C6.D_E_L_E_T_=''"+CRLF

	if MV_PAR01=="02" .Or. MV_PAR01=="03" .Or. MV_PAR01=="04"		// prevista o firme o apunte
		cQry += "   AND C2.D_E_L_E_T_=''"+CRLF
	endif
	if MV_PAR01=="01"		// cotizacion
		cQry += "   AND C5.C5_LIBEROK=' '"+CRLF
	endif
	if MV_PAR01=="02"		// pevista
		cQry += "   AND C2_TPOP='P'"+CRLF
	endif
	if MV_PAR01=="03"		// firme
		cQry += "   AND C2_TPOP='F'"+CRLF
	endif
	if MV_PAR01=="04"		// apunte
		cQry += "   AND C2_QUJE>0"+CRLF
	endif
	if MV_PAR01=="05"		// guiada
		cQry += "   AND C6_DATFAT=' '"+CRLF
		cQry += "   AND C6_NOTA='REMITO'"+CRLF
	endif
	if MV_PAR01=="06"		// facturada
		cQry += "   AND C6_DATFAT<>' '"+CRLF
		cQry += "   AND C6_NOTA<>'REMITO'"+CRLF
	endif
	cQry += "   AND C5_NUM BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"'"+CRLF
	cQry += "   AND C5_CLIENTE BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"'"+CRLF
	if !empty(MV_PAR06)		// usuarios
		cQry += "   AND C5_LOGINCL='"+MV_PAR06+"'"+CRLF
	endif
	cQry += "   AND C5_EMISSAO BETWEEN '"+dtos(MV_PAR07)+"' AND '"+dtos(MV_PAR08)+"'"+CRLF
	cQry += " GROUP BY C5_NUM,C6_ITEM,C5_CLIENTE,C5_YNOMCLI,C6_YCODF,C5_LOGINCL,C5_EMISSAO,C5_YFVIGEN,C5_SUGENT"+CRLF
	cQry += " ORDER BY C5_NUM,C6_ITEM,C5_CLIENTE,C5_YNOMCLI,C6_YCODF,C5_LOGINCL,C5_EMISSAO,C5_YFVIGEN,C5_SUGENT"+CRLF

	cQry := ChangeQuery(cQry)
	
	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbClosearea())
	EndIf
	
	TcQuery cQry New Alias "QRY"
	
	If QRY->( !Eof() )
	
		oReport:SetMeter(QRY->(RecCount()))
		oSection:Init()	
		
		//SC6->( dbSetOrder(1) )
	
		While QRY->( !Eof() )
		
			If oReport:Cancel()		
				Exit	
			EndIf

			cDtLib := ""
			cHrLib := ""
			cBlqCre := ""
			cBlqStk := ""
		
			xSql := "SELECT C9_YHORLIB,C9_DATALIB,C9_BLEST,C9_BLCRED"+CRLF
			xSql += "  FROM "+RetSqlName("SC9")+CRLF
			xSql += " WHERE C9_FILIAL='"+xFilial("SC9")+"'"+CRLF
			xSql += "   AND C9_PEDIDO='"+QRY->C5_NUM+"'"+CRLF
			xSql += "   AND C9_DATALIB<>''"+CRLF
			xSql += "   AND D_E_L_E_T_=' '"+CRLF
			 
			xSql := ChangeQuery(xSql)
			
			If Select("XQRY") > 0
				XQRY->( dbClosearea() )
			EndIf
			
			TcQuery xSql New Alias "XQRY"
			
			If XQRY->( !Eof() )
				cDtLib := XQRY->C9_DATALIB
				cHrLib := XQRY->C9_YHORLIB
				
				if !empty(XQRY->C9_BLCRED)
					//cBlqCre := "BLQ CRED"
				endif

				if !empty(XQRY->C9_BLEST)
					//cBlqStk := "BLQ ESTQ"
				endif

			Endif
			XQRY->( dbCloseArea() )

			cFechaFP := ""

			xSql := "SELECT C2_TPOP,C2_DATRF,C2_YDTFIRM,C2_EMISSAO,C2_QUJE,C2_QUANT"+CRLF
			xSql += "  FROM "+RetSqlName("SC2")+CRLF
			xSql += " WHERE C2_FILIAL='"+xFilial("SC2")+"'"+CRLF
			xSql += "   AND C2_PEDIDO='"+QRY->C5_NUM+"'"+CRLF
			xSql += "   AND D_E_L_E_T_=' '"+CRLF
			 
			xSql := ChangeQuery(xSql)
			
			If Select("XQRY") > 0
				XQRY->( dbClosearea() )
			EndIf
			
			TcQuery xSql New Alias "XQRY"
			
			If XQRY->( !Eof() )
				if empty(XQRY->C2_YDTFIRM) .And. empty(XQRY->C2_DATRF) .AND. XQRY->C2_TPOP=='P'
					cFechaFP := dtoc(stod(XQRY->C2_EMISSAO))
				elseif !empty(XQRY->C2_YDTFIRM) .And. empty(XQRY->C2_DATRF) .And. XQRY->C2_QUJE<=0 .And. XQRY->C2_TPOP=='F'
					cFechaFP := dtoc(stod(XQRY->C2_YDTFIRM))
				elseIF !empty(XQRY->C2_DATRF) .And. XQRY->C2_TPOP='F' .And. XQRY->C2_QUJE>0
					cFechaFP := dtoc(stod(XQRY->C2_DATRF))
				else
					cFechaFP := dtoc(stod(XQRY->C2_YDTFIRM))
				endif
			Endif
			XQRY->( dbCloseArea() )


			oSection:Cell("C5_NUM"):Show()
			oSection:Cell("C6_ITEM"):Show()
			oSection:Cell("C5_CLIENTE"):Show()
			oSection:Cell("C5_YNOMCLI"):Show()
			oSection:Cell("C6_YCODF"):Show()
			oSection:Cell("C5_LOGINCL"):Show()
			oSection:Cell("C5_EMISSAO"):SetValue(stod(QRY->C5_EMISSAO))		// emision
			oSection:Cell("C5_YFVIGEN"):SetValue(stod(QRY->C5_YFVIGEN))		// prevision
			oSection:Cell("C5_SUGENT"):SetValue(stod(QRY->C5_SUGENT))		// sugerencia de entrega
			oSection:Cell("C5_SUGENT"):Show()		//fFindEntrega()
			if !empty(cBlqCre)
				oSection:Cell("C9_DATALIB"):SetValue(cBlqCre)
			elseif !empty(cBlqStk)
				oSection:Cell("C9_DATALIB"):SetValue(cBlqStk)
			else
				oSection:Cell("C9_DATALIB"):SetValue(stod(cDtLib))
			endif
			oSection:Cell("C2_EMISSAO"):SetValue(cFechaFP)
			oSection:Cell("QTDE"):Show()
			oSection:Cell("ESTATUS"):SetValue(retStatus(QRY->C5_NUM,QRY->C6_ITEM))
			oSection:Cell("DOCUMENTO"):SetValue(retNFiscal(QRY->C5_NUM,SC6->C6_PRODUTO))
			oSection:PrintLine()
		
			QRY->( dbSkip() )
			oReport:IncMeter()
			
		End
		
		oSection:Finish()
		oReport:SkipLine()	
	
	EndIf
	
	QRY->(DbClosearea())
	
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALRFAT04  ºAutor  ³Microsiga           º Data ³  09/11/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function retStatus( _cNumPed,_cItmPed )

	local cStatus	:= "¡ERRO!"
	local xSql		:= ""
	local lLibrado	:= .f.

	SC5->( dbSetOrder(1) )
	If SC5->( dbSeek( xFilial("SC5")+_cNumPed ) )
		if empty(SC5->C5_LIBEROK)
			lLibrado := .f.
		else
			lLibrado := .t.
		endif
	endif
	
	xSql := "SELECT C2_PEDIDO,C2_ITEMPV,C2_TPOP,C2_QUJE"+CRLF
	xSql += "  FROM "+RetSqlName("SC2")
	xSql += " WHERE C2_FILIAL='"+xFilial("SC2")+"'"+CRLF
	xSql += "   AND C2_PEDIDO='"+_cNumPed+"'"+CRLF
	xSql += "   AND C2_ITEMPV='"+_cItmPed+"'"+CRLF
	xSql += "   AND D_E_L_E_T_=''"

	xSql := ChangeQuery(xSql)
	
	If Select("XQRY") > 0
		XQRY->( dbClosearea() )
	EndIf
	
	TcQuery xSql New Alias "XQRY"
	
	If XQRY->( !Eof() )
		if XQRY->C2_TPOP='P'
			cStatus := "OP PREVISTA"
		elseif XQRY->C2_TPOP='F' .And. XQRY->C2_QUJE>0
			cStatus := "EN APUNTE"
		elseif XQRY->C2_TPOP='F' .And. XQRY->C2_QUJE<=0
			cStatus := "APROBADO - OP FIRME"
		endif
	else
		if lLibrado
			cStatus := "APROBADO"
		else
			cStatus := "EN COTIZACION"
		endif
	Endif
	XQRY->( dbCloseArea() )

	SC6->( dbSetOrder(1) )
	If SC6->( dbSeek( xFilial("SC6")+_cNumPed+_cItmPed ) )
		if empty(SC6->C6_DATFAT) .And. SC6->C6_NOTA='REMITO'
			cStatus := "REMITO"
		elseif !empty(SC6->C6_DATFAT) .And. SC6->C6_NOTA<>'REMITO'
			cStatus := "FACTURADO"
		endif
	endif

Return( cStatus )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALRFAT04  ºAutor  ³Microsiga           º Data ³  11/06/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function retNFiscal(cNroPed,cCodItm)

	local xArea 	:= getArea()
	local cret		:= ""
	local xAlias	:= getNextAlias()

	xSql := "SELECT D2_SERIE,D2_DOC"+CRLF
	xSql += "  FROM "+RetSqlName("SD2")
	xSql += " WHERE D2_FILIAL='"+xFilial("SD2")+"'"+CRLF
	xSql += "   AND D2_PEDIDO='"+cNroPed+"'"+CRLF
	xSql += "   AND D2_COD='"+cCodItm+"'"+CRLF
	xSql += "   AND SUBSTRING(D2_SERIE,1,1) IN ('B','F','X','Z')"+CRLF
	xSql += "   AND D_E_L_E_T_=''"

	xSql := ChangeQuery(xSql)
	
	dbUseArea(.T., 'TOPCONN', TCGenQry(,,xSql), xAlias, .F., .T.)
	
	If (xAlias)->( !Eof() )
		cret := u_PuxaSer2((xAlias)->D2_SERIE)+"-"+alltrim((xAlias)->D2_DOC)
	endif 
	
	(xAlias)->( dbCloseArea() )
	
	restArea(xArea)

Return(cret)
