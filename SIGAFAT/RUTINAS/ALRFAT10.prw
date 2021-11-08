#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALRFAT10  ºAutor  ³Percy Arias,SISTHEL º Data ³  09/03/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Informe de Ventas considerando los siguientes opciones     º±±
±±º          ³ fechas de: inclusion, liberacion credito y apunte prod.    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ALRFAT10()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Declaracao de variaveis                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private oReport  := Nil
	Private oSecCab	 := Nil
	Private cPerg 	 := PadR ("ALFAT10", Len (SX1->X1_GRUPO))

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

	local oSection1 := Nil
	local oSection2 := Nil

	oReport := TReport():New(cPerg,"Informe de Ventas por Familia",cPerg,{|oReport| PrintReport(oReport)},"Informe de Ventas por Familia")
	oReport:SetLandscape(.T.)
	oReport:SetTotalInLine(.F.)
	oReport:SetTotalText("Totales ")

	/*
	oSection1:= TRSection():New(oReport, "FAMILIA", {}) //, , .F., .T.)
	TRCell():New(oSection1,"C6_YCODF"	, "QRY","FAMILIA"		,"@!",30)
	TRCell():New(oSection1,"NOMFAMIL"	, "QRY","DESCRIPCION"	,"@!",60)
	*/
	
	oSection2 := TRSection():New( oReport , "Informe de Ventas por Familia", {"QRY"} )
	TRCell():New( oSection2, "C6_YCODF"			, "QRY","FAMILIA"			,"@!",10)
	TRCell():New( oSection2, "C5_NUM"			, "QRY","PEDIDO"			,"@!",10)
	TRCell():New( oSection2, "C5_CLIENTE"		, "QRY","R.U.C."	   		,"@!",15)
	TRCell():New( oSection2, "C5_YNOMCLI"		, "QRY","NOMBRE CLIENTE"	,"@!",55)
	TRCell():New( oSection2, "C5_EMISSAO"		, "QRY","EMISIÓN"			,,15)
	TRCell():New( oSection2, "C5_YHOREMI"		, "QRY","HORA EMIS"			,,15)
	TRCell():New( oSection2, "C9_DATALIB"		, "QRY","LIB PEDIDO"		,,15)
	TRCell():New( oSection2, "C9_YHORLIB"		, "QRY","HORA LIB.PV"		,,15)
	TRCell():New( oSection2, "C9_YDATCRD"		, "QRY","LIB CREDITO"		,,15)
	TRCell():New( oSection2, "C9_YHORCRD"		, "QRY","HORA LIB.CR"		,,15)
	TRCell():New( oSection2, "C2_YDTFIRM"		, "QRY","EN FIRME"			,,15)
	TRCell():New( oSection2, "C2_YHRFIRM"		, "QRY","HORA FIRME"		,,15)
	TRCell():New( oSection2, "C2_DATRF"			, "QRY","APUNTE"			,,15)
	TRCell():New( oSection2, "C2_YHREMIS"		, "QRY","HOR.APUNTE"		,,15)
	TRCell():New( oSection2, "QTDE"				, "QRY","EN FACT."			,"9,999.99",10,,,"RIGHT",,"RIGHT")
	TRCell():New( oSection2, "PRODUCCION"		, "QRY","EN PROD."			,"9,999.99",10,,,"RIGHT",,"RIGHT")
	TRCell():New( oSection2, "APUNTE"			, "QRY","APUNTADOS"			,"9,999.99",10,,,"RIGHT",,"RIGHT")
	TRCell():New( oSection2, "AVANCE"			, "QRY","AVANCE %"			,"999",10,,,"RIGHT",,"RIGHT")

	oSection2:SetTotalText("----------")
	oSection2:SetTotalInLine(.T.)
	
	//oSection1:SetTotalText("Cantidad por Familia")
	//oSection1:SetTotalInLine(.T.)

	
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
	//Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(1)
	
	Pergunte(cPerg,.F.)
	
	SC2->( dbSetOrder(1) )
	SC5->( dbSetOrder(1) )
	SC6->( dbSetOrder(1) )
	SC9->( dbSetOrder(1) )

	cQry += "SELECT C6_YCODF,C5_NUM,C5_CLIENTE,C5_YNOMCLI,C5_EMISSAO,C9.C9_DATALIB,SUM(C6_QTDVEN) QTDE"+CRLF
	cQry += "  FROM "+RetSqlName("SC5")+ " C5"+CRLF
	cQry += "  LEFT JOIN "+RetSqlName("SC6")+" C6"+CRLF
	cQry += "    ON C5_NUM=C6_NUM"+CRLF
	cQry += "   AND C5_CLIENTE=C6_CLI"+CRLF
	cQry += " INNER JOIN "+RetSqlName("SC9")+" C9"+CRLF
	cQry += "    ON C9_PEDIDO=C6_NUM"+CRLF
	cQry += "   AND C9_ITEM=C6_ITEM"+CRLF
	cQry += " WHERE C5_FILIAL='"+xFilial("SC5")+"'"+CRLF 
	cQry += "   AND C6_FILIAL='"+xFilial("SC6")+"'"+CRLF 
	cQry += "   AND C9_FILIAL='"+xFilial("SC9")+"'"+CRLF 
	cQry += "   AND C5.D_E_L_E_T_=' '"+CRLF 
	cQry += "   AND C6.D_E_L_E_T_=' '"+CRLF 
	cQry += "   AND C9.D_E_L_E_T_=' '"+CRLF 
	cQry += "   AND C5_EMISSAO BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"'"+CRLF 
	cQry += "   AND C6_YCODF BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"+CRLF 
	cQry += "   AND C5_NUM BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"+CRLF 
	cQry += "   AND C5_CLIENTE BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'"+CRLF 
	cQry += " GROUP BY C6_YCODF,C5_NUM,C5_CLIENTE,C5_YNOMCLI,C5_EMISSAO,C9.C9_DATALIB"
	cQry += " ORDER BY C6_YCODF,C5_NUM,C5_CLIENTE,C5_YNOMCLI,C5_EMISSAO,C9.C9_DATALIB"

	cQry := ChangeQuery(cQry)
	
	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbClosearea())
	EndIf
	
	TcQuery cQry New Alias "QRY"
	
	If QRY->( !Eof() )
	
		cFam := ""
	
		oReport:SetMeter(QRY->(RecCount()))
		//oSection1:Init()
		oSection2:Init()
		
		While QRY->( !Eof() )
		
			If oReport:Cancel()		
				Exit	
			EndIf
			
			/*
			if cFam <> QRY->C6_YCODF

				cFam := QRY->C6_YCODF
				oSection1:Cell("C6_YCODF"):Show()
				oSection1:Cell("NOMFAMIL"):SetValue( Posicione("ZZD",1,xFilial("ZZD")+QRY->C6_YCODF,"ZZD->ZZD_DESCRI") )
				
				oSection1:PrintLine()
				oReport:ThinLine()
				
			endif
			*/
			
			cHrLib := ""
			cDtLib := ""
			aInfo := {}
			aInfo := retStatus(QRY->C5_NUM,QRY->C6_YCODF)
			
			SC5->( MsSeek( xFilial("SC5")+QRY->C5_NUM) )
			SC9->( MsSeek( xFilial("SC9")+QRY->C5_NUM) )

			xSql := "SELECT C9_YHORLIB,C9_DATALIB"+CRLF
			xSql += "  FROM "+RetSqlName("SC9")+CRLF
			xSql += " WHERE C9_FILIAL='"+xFilial("SC9")+"'"+CRLF
			xSql += "   AND C9_PEDIDO='"+QRY->C5_NUM+"'"+CRLF
			xSql += "   AND C9_DATALIB<>''"+CRLF
			xSql += "   AND D_E_L_E_T_='*'"+CRLF
			 
			xSql := ChangeQuery(xSql)
			
			If Select("XQRY") > 0
				XQRY->( dbClosearea() )
			EndIf
			
			TcQuery xSql New Alias "XQRY"
			
			If XQRY->( !Eof() )
				cDtLib := XQRY->C9_DATALIB
				cHrLib := XQRY->C9_YHORLIB
			Endif
			XQRY->( dbCloseArea() )
		
			oSection2:Cell("C6_YCODF"):Show()
			oSection2:Cell("C5_NUM"):Show()
			oSection2:Cell("C5_CLIENTE"):Show()
			oSection2:Cell("C5_YNOMCLI"):Show()
			oSection2:Cell("C5_EMISSAO"):SetValue(stod(QRY->C5_EMISSAO))
			oSection2:Cell("C5_YHOREMI"):SetValue(left(SC5->C5_YHOREMI,5))
			oSection2:Cell("C9_DATALIB"):SetValue(stod(cDtLib))
			oSection2:Cell("C9_YHORLIB"):SetValue(left(cHrLib,5))
			oSection2:Cell("C9_YDATCRD"):SetValue(SC9->C9_YDATCRD)
			oSection2:Cell("C9_YHORCRD"):SetValue(left(SC9->C9_YHORCRD,5))
			oSection2:Cell("C2_YDTFIRM"):SetValue(stod(aInfo[5]))
			oSection2:Cell("C2_YHRFIRM"):SetValue(left(aInfo[6],5))
			if empty(aInfo[1])
				oSection2:Cell("C2_DATRF"):SetValue("")
				oSection2:Cell("C2_YHREMIS"):SetValue("")
			else
				oSection2:Cell("C2_DATRF"):SetValue(stod(aInfo[1]))
				oSection2:Cell("C2_YHREMIS"):SetValue(left(aInfo[4],5))
			endif
			oSection2:Cell("QTDE"):Show()
			oSection2:Cell("PRODUCCION"):SetValue(aInfo[2])
			oSection2:Cell("APUNTE"):SetValue(aInfo[3])
			oSection2:Cell("AVANCE"):SetValue( alltrim( str( round( ( aInfo[3]*100/aInfo[2] ),0 ) ) ) )
			
			oSection2:PrintLine()
		
			QRY->( dbSkip() )
			oReport:IncMeter()
			
		End
		
		//oSection1:Finish()
		oSection2:Finish()
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
Static Function retStatus( _cNumPed,_cNomFam )

	local xSql		:= ""
	local _aRet		:= {}

	xSql := "SELECT C2_PEDIDO,C6_YCODF,MAX(C2_DATRF) FECHA,MAX(C2_YHREMIS) HORA, SUM(C2_QUANT) TOTAL, SUM(C2_QUJE) APUNTE,"+CRLF
	xSql += "		MAX(C2_YDTFIRM) DT_FIRME, MAX(C2_YHRFIRM) HR_FIRME"+CRLF
	xSql += "  FROM "+RetSqlName("SC2") +" C2,"+RetSqlName("SC6")+" C6"+CRLF
	xSql += " WHERE C2_FILIAL='"+xFilial("SC2")+"'"+CRLF
	xSql += "   AND C6_FILIAL='"+xFilial("SC6")+"'"+CRLF
	xSql += "   AND C2_PEDIDO='"+_cNumPed+"'"+CRLF
	xSql += "   AND C6_YCODF='"+_cNomFam+"'"+CRLF
	xSql += "   AND C6_NUM=C2_PEDIDO"+CRLF
	xSql += "   AND C6_ITEM=C2_ITEMPV"+CRLF
	xSql += "   AND C2.D_E_L_E_T_=' '"+CRLF
	xSql += "   AND C6.D_E_L_E_T_=' '"+CRLF
	xSql += " GROUP BY C2_PEDIDO,C6_YCODF"+CRLF
	 
	xSql := ChangeQuery(xSql)
	
	If Select("XQRY") > 0
		XQRY->( dbClosearea() )
	EndIf
	
	TcQuery xSql New Alias "XQRY"
	
	If XQRY->( !Eof() )
		aadd( _aRet,XQRY->FECHA )
		aadd( _aRet,XQRY->TOTAL )
		aadd( _aRet,XQRY->APUNTE )
		aadd( _aRet,XQRY->HORA )
		aadd( _aRet,XQRY->DT_FIRME )
		aadd( _aRet,XQRY->HR_FIRME )
	else
		aadd( _aRet,"" )
		aadd( _aRet,0 )
		aadd( _aRet,0 )	
		aadd( _aRet,"" )
		aadd( _aRet,"" )
		aadd( _aRet,"" )
	Endif
	XQRY->( dbCloseArea() )

Return( _aRet )
