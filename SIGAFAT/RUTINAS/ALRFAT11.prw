#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALRFAT11  ºAutor  ³Percy Arias,SISTHEL º Data ³  13/06/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Informe de stock personalizado                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ALRFAT11()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Declaracao de variaveis                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private oReport  := Nil
	Private oSecCab	 := Nil
	Private cPerg 	 := PadR ("ALFAT11", Len (SX1->X1_GRUPO))

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
±±ºPrograma  ³ALRFAT11  ºAutor  ³Microsiga           º Data ³  06/13/19   º±±
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

	oReport := TReport():New(cPerg,"Informe de Stock",cPerg,{|oReport| PrintReport(oReport)},"Informe de Stock")
	oReport:SetLandscape(.F.)
	oReport:SetTotalInLine(.F.)
	oReport:SetTotalText("Totales ")

	oSection2 := TRSection():New( oReport , "Informe de Stock", {"QRY"} )
	TRCell():New( oSection2, "B1_COD"			, "QRY","PRODUCTO"			,"@!",30)
	TRCell():New( oSection2, "B1_DESC"			, "QRY","DESCRIPCION"		,"@!",30)
	TRCell():New( oSection2, "B1_YDESLAR"		, "QRY","DESCRIPCION ALREX"	,"@!",40)
	TRCell():New( oSection2, "B1_TIPO"			, "QRY","TIPO"				,"@!",10)
	TRCell():New( oSection2, "B2_LOCAL"			, "QRY","LOCAL"				,,20)
	TRCell():New( oSection2, "B2_QATU"			, "QRY","CANTIDAD"			,"9,999.99",15,,,"RIGHT",,"RIGHT")
	TRCell():New( oSection2, "B1_UM"			, "QRY","UM"				,,20)
	TRCell():New( oSection2, "A5_FORNECE"		, "QRY","PROVEEDOR"			,,15)
	TRCell():New( oSection2, "A5_CODPRF"		, "QRY","PROD.PROVEEDOR"	,,40)

	oSection2:SetTotalText("----------")
	oSection2:SetTotalInLine(.T.)

	
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

	cQry += "SELECT B1_COD,B1_DESC,B1_YDESLAR,B1_TIPO,B2_LOCAL,B2_QATU,B1_UM,A5_FORNECE,A5_LOJA,A5_NOMEFOR,A5_PRODUTO,A5_NOMPROD,A5_CODPRF,A5_REFGRD,A5_YPRDFOR,A5_DESREF"+CRLF
	cQry += "  FROM "+RetSqlname("SB1")+" B1"+CRLF
	cQry += "  LEFT JOIN "+RetSqlname("SA5")+" A5"+CRLF
	cQry += "    ON B1.B1_COD=A5.A5_PRODUTO"+CRLF
	cQry += "   AND A5.D_E_L_E_T_=' '"+CRLF
	cQry += "   AND A5.A5_FILIAL='"+xFilial("SA5")+"'"+CRLF
	cQry += "  LEFT JOIN "+RetSqlname("SB2")+" B2"+CRLF
	cQry += "    ON B1.B1_COD=B2.B2_COD"+CRLF
	if !empty(MV_PAR04)
		cQry += "   AND B2.B2_LOCAL IN ('"+alltrim(MV_PAR04)+"')"+CRLF
	endif
	cQry += "   AND B2.D_E_L_E_T_=' '"+CRLF
	cQry += "   AND B2.B2_FILIAL='"+xFilial("SB2")+"'"+CRLF
	cQry += " WHERE B1.B1_FILIAL='"+xFilial("SB1")+"'"+CRLF
	cQry += "   AND B1.D_E_L_E_T_=' '"+CRLF
	if !empty(MV_PAR03)
		cQry += "   AND B1.B1_TIPO IN ('"+alltrim(MV_PAR03)+"')"+CRLF
	endif
	cQry += "   AND B1.B1_COD BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'"+CRLF
	cQry += " ORDER BY B1.B1_COD"+CRLF
	
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
			
			oSection2:Cell("B1_COD"):Show()
			oSection2:Cell("B1_DESC"):Show()
			oSection2:Cell("B1_YDESLAR"):Show()
			oSection2:Cell("B1_TIPO"):Show()
			oSection2:Cell("B2_LOCAL"):Show()
			oSection2:Cell("B2_QATU"):Show()
			oSection2:Cell("B1_UM"):Show()
			oSection2:Cell("A5_FORNECE"):SetValue(QRY->A5_FORNECE+" "+QRY->A5_LOJA+" "+QRY->A5_NOMEFOR)
			oSection2:Cell("A5_CODPRF"):SetValue( QRY->A5_CODPRF+" "+QRY->A5_YPRDFOR )
			
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

