#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALRPRD01  ºAutor  ³Microsiga           º Data ³  01/16/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ALRPRD01()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Declaracao de variaveis                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private oReport  := Nil
	Private oSecCab	 := Nil
	Private cPerg 	 := PadR ("ALPRD01", Len (SX1->X1_GRUPO))

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
±±ºPrograma  ³ALRPRD01  ºAutor  ³Microsiga           º Data ³  01/16/20   º±±
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

	oReport := TReport():New(cPerg,"Informe de Produccion por Familia",cPerg,{|oReport| PrintReport(oReport)},"Informe de Produccion por Familia")
	oReport:SetLandscape(.T.)
	oReport:SetTotalInLine(.F.)
	oReport:SetTotalText("Totales ")

	/*
	oSection1:= TRSection():New(oReport, "FAMILIA", {}) //, , .F., .T.)
	TRCell():New(oSection1,"C6_YCODF"	, "QRY","FAMILIA"		,"@!",30)
	TRCell():New(oSection1,"NOMFAMIL"	, "QRY","DESCRIPCION"	,"@!",60)
	*/
	
	oSection2 := TRSection():New( oReport , "Informe de Produccion por Familia", {"QRY"} )
	TRCell():New( oSection2, "C2_PEDIDO"		, "QRY","Pedido"			,"@!",10)
	TRCell():New( oSection2, "C2_NUM"			, "QRY","O.P."				,"@!",10)
	TRCell():New( oSection2, "A1_NOME"			, "QRY","CLIENTE"			,"@!",70)
	TRCell():New( oSection2, "B1_YCODALR"		, "QRY","FAMILIA"			,"@!",10)
	TRCell():New( oSection2, "C2_PRODUTO"		, "QRY","PRODUCTO"			,"@!",25)
	TRCell():New( oSection2, "C2_EMISSAO"		, "QRY","EMISIÓN"			,,15)
	TRCell():New( oSection2, "C2_DATRF"			, "QRY","APUNTE"			,,15)
	TRCell():New( oSection2, "C2_YHREMIS"		, "QRY","HOR.APUNTE"		,,15)
	TRCell():New( oSection2, "C2_LOCAL"			, "QRY","ALMACEN"			,,10)
	//TRCell():New( oSection2, "G1_COMP"			, "QRY","COMPONENTE"		,"@!",25)
	//TRCell():New( oSection2, "G1_QUANT"			, "QRY","CANT.UTILZ"		,"9,999.99",10,,,"RIGHT",,"RIGHT")
	TRCell():New( oSection2, "C2_QUANT"			, "QRY","TOTAL"				,"9,999.99",10,,,"RIGHT",,"RIGHT")
	TRCell():New( oSection2, "C2_QUJE"			, "QRY","ENTREGADOS"		,"9,999.99",10,,,"RIGHT",,"RIGHT")
	TRCell():New( oSection2, "PENDIENTES"		, "QRY","PENDIENTES"		,"9,999.99",10,,,"RIGHT",,"RIGHT")

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
	SA1->( dbSetOrder(1) )

	/*
	cQry += "SELECT B1_YCODALR,C2_EMISSAO,C2_DATRF,C2_YHREMIS,C2_PEDIDO,C2_NUM,C2_PRODUTO,C2_LOCAL,G1_COMP,G1_QUANT,C2_QUANT,C2_QUJE "+CRLF
	cQry += "  FROM "+RetSqlName("SC2")+" SC2,"+RetSqlName("SG1")+" SG1,"+RetSqlName("SB1")+" SB1"+CRLF
	cQry += " WHERE C2_EMISSAO BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"'"+CRLF 
	cQry += "   AND C2_PEDIDO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"+CRLF 
	cQry += "   AND C2_NUM BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"+CRLF 
	cQry += "   AND C2_PRODUTO=G1_COD"+CRLF
	cQry += "   AND C2_PRODUTO=B1_COD"+CRLF
	cQry += "   AND G1_COD=B1_COD"+CRLF
	cQry += "   AND SC2.D_E_L_E_T_=''"+CRLF
	cQry += "   AND SG1.D_E_L_E_T_=''"+CRLF
	cQry += "   AND SB1.D_E_L_E_T_=''"+CRLF
	cQry += " ORDER BY C2_EMISSAO,C2_PEDIDO,C2_PRODUTO"+CRLF
	*/

	cQry += "SELECT B1_YCODALR,C2_EMISSAO,C2_DATRF,C2_YHREMIS,C2_PEDIDO,C2_NUM,C2_PRODUTO,C2_LOCAL,C2_QUANT,C2_QUJE "+CRLF
	cQry += "  FROM "+RetSqlName("SC2")+" SC2,"+RetSqlName("SB1")+" SB1"+CRLF
	cQry += " WHERE C2_EMISSAO BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04)+"'"+CRLF 
	cQry += "   AND C2_DATRF BETWEEN '"+dtos(MV_PAR05)+"' AND '"+dtos(MV_PAR06)+"'"+CRLF 
	cQry += "   AND C2_PEDIDO BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'"+CRLF 
	cQry += "   AND C2_NUM BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"'"+CRLF 
	cQry += "   AND B1_YCODALR BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"+CRLF 
	cQry += "   AND C2_PRODUTO=B1_COD"+CRLF
	cQry += "   AND SC2.D_E_L_E_T_=''"+CRLF
	cQry += "   AND SB1.D_E_L_E_T_=''"+CRLF
	cQry += " ORDER BY C2_PEDIDO,C2_DATRF,C2_PRODUTO"+CRLF
	
	cQry := ChangeQuery(cQry)
	
	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbClosearea())
	EndIf
	
	TcQuery cQry New Alias "QRY"
	
	If QRY->( !Eof() )
	
		oReport:SetMeter(QRY->(RecCount()))
		//oSection1:Init()
		oSection2:Init()
		
		While QRY->( !Eof() )
		
			If oReport:Cancel()		
				Exit	
			EndIf
			
			SC5->( MsSeek( xFilial("SC5")+QRY->C2_PEDIDO ) )
			SA1->( MsSeek( xFilial("SA1")+SC5->C5_CLIENT ) )

			oSection2:Cell("C2_PEDIDO"):Show()
			oSection2:Cell("C2_NUM"):Show()
			oSection2:Cell("A1_NOME"):SetValue(SA1->A1_NOME)
			oSection2:Cell("B1_YCODALR"):Show()
			oSection2:Cell("C2_PRODUTO"):Show()
			oSection2:Cell("C2_EMISSAO"):SetValue(stod(QRY->C2_EMISSAO))
			oSection2:Cell("C2_DATRF"):SetValue(stod(QRY->C2_DATRF))
			oSection2:Cell("C2_YHREMIS"):SetValue(QRY->C2_YHREMIS)
			oSection2:Cell("C2_LOCAL"):Show()
			//oSection2:Cell("G1_COMP"):Show()
			//oSection2:Cell("G1_QUANT"):Show()
			oSection2:Cell("C2_QUANT"):Show()
			oSection2:Cell("C2_QUJE"):Show()
			oSection2:Cell("PENDIENTES"):SetValue(QRY->C2_QUANT-QRY->C2_QUJE)
			
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

