#include "TOTVS.CH"
#Include "RWMAKE.CH"
#Include "RESTFUL.CH"
#INCLUDE "Topconn.ch"

WSRESTFUL STHFAT04 DESCRIPTION "Estatus de Pedidos de Ventas" FORMAT APPLICATION_JSON
    WSDATA fechaini            AS STRING   OPTIONAL
    WSDATA fechafim            AS STRING   OPTIONAL
    WSDATA cfamiIni            AS STRING   OPTIONAL
    WSDATA cfamiFim            AS STRING   OPTIONAL
    WSDATA cPedidoIni          AS STRING   OPTIONAL
    WSDATA cPedidoFim          AS STRING   OPTIONAL
    WSDATA cClienteIni         AS STRING   OPTIONAL
    WSDATA cClienteFim         AS STRING   OPTIONAL

    WSMETHOD GET famcomponente DESCRIPTION 'FAT04 Estatus de Ped. Ventas' WSSYNTAX '/api/v1/sthfat04' PATH '/api/v1/sthfat04' PRODUCES APPLICATION_JSON
END WSRESTFUL

WSMETHOD GET famcomponente WSRECEIVE fechaini, fechafim, cfamiIni, cfamiFim, cPedidoIni, cPedidoFim, cClienteIni, cClienteFim WSREST STHFAT04
    Local lRet:= .T.
    lRet := famcomponente( self )
Return( lRet )

Static Function famcomponente( oSelf )

    Local aListCli  := {}
    Local cJsonCli  := ''
    Local oJsonCli  := JsonObject():New()
    Local cAlias    := GetNextAlias()
    Local cAlias01  := GetNextAlias()
    Local nAux      := 0

    Default oself:fechaini  := ''
    Default oself:fechafim  := ''
    Default oself:cfamiIni  := ''
    Default oself:cfamiFim  := 'ZZZZZZ'
    Default oself:cPedidoIni  := ''
    Default oself:cPedidoFim  := 'ZZZZZZ'
    Default oself:cClienteIni  := ''
    Default oself:cClienteFim  := 'ZZZZZZZZZZZ'


	SC2->( dbSetOrder(1) )
	SC5->( dbSetOrder(1) )
	SC6->( dbSetOrder(1) )
	SC9->( dbSetOrder(1) )

    cQry := ""
	cQry += "SELECT C6_YCODF,C5_NUM,C5_CLIENTE,C5_YNOMCLI,C5_EMISSAO,C9.C9_DATALIB,SUM(C6_QTDVEN) QTDE"
	cQry += "  FROM "+RetSqlName("SC5")+ " C5"
	cQry += "  LEFT JOIN "+RetSqlName("SC6")+" C6"
	cQry += "    ON C5_NUM=C6_NUM"
	cQry += "   AND C5_CLIENTE=C6_CLI"
	cQry += " INNER JOIN "+RetSqlName("SC9")+" C9"
	cQry += "    ON C9_PEDIDO=C6_NUM"
	cQry += "   AND C9_ITEM=C6_ITEM"
	cQry += " WHERE C5_FILIAL='"+xFilial("SC5")+"'"
	cQry += "   AND C6_FILIAL='"+xFilial("SC6")+"'"
	cQry += "   AND C9_FILIAL='"+xFilial("SC9")+"'"
	cQry += "   AND C5.D_E_L_E_T_=' '"
	cQry += "   AND C6.D_E_L_E_T_=' '"
	cQry += "   AND C9.D_E_L_E_T_=' '"
	cQry += "   AND C5_EMISSAO BETWEEN '"+ oself:fechaini +"' AND '"+ oself:fechafim +"'"
    cQry += "   AND C6_YCODF BETWEEN '"+ oself:cfamiIni +"' AND '"+ oself:cfamiFim +"'"
	cQry += "   AND C5_NUM BETWEEN '"+ oself:cPedidoIni +"' AND '"+ oself:cPedidoFim +"'"
	cQry += "   AND C5_CLIENTE BETWEEN '"+ oself:cClienteIni +"' AND '"+ oself:cClienteFim +"'"
	cQry += " GROUP BY C6_YCODF,C5_NUM,C5_CLIENTE,C5_YNOMCLI,C5_EMISSAO,C9.C9_DATALIB"
	cQry += " ORDER BY C6_YCODF,C5_NUM,C5_CLIENTE,C5_YNOMCLI,C5_EMISSAO,C9.C9_DATALIB"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry),cAlias, .F., .T.)
	
    If ( cAlias )->( ! Eof() )

        While ( cAlias )->( ! Eof() )

			cHrLib := ""
			cDtLib := ""
			cDtCrd := ""
			cHrCrd := ""

			aInfo := {}
			aInfo := retStatus((cAlias)->C5_NUM,(cAlias)->C6_YCODF)
			
			SC5->( MsSeek( xFilial("SC5")+(cAlias)->C5_NUM) )
			
			if SC9->( MsSeek( xFilial("SC9")+(cAlias)->C5_NUM) )
				cDtCrd := dtos(SC9->C9_YDATCRD)
            	cHrCrd := SC9->C9_YHORCRD
			endif

			xSql := "SELECT C9_YHORLIB,C9_DATALIB"+CRLF
			xSql += "  FROM "+RetSqlName("SC9")+CRLF
			xSql += " WHERE C9_FILIAL='"+xFilial("SC9")+"'"+CRLF
			xSql += "   AND C9_PEDIDO='"+(cAlias)->C5_NUM+"'"+CRLF
			xSql += "   AND C9_DATALIB<>''"+CRLF
			xSql += "   AND D_E_L_E_T_='*'"+CRLF
			 
			xSql := ChangeQuery(xSql)

            dbUseArea(.T., "TOPCONN", TCGenQry(,,xSql),cAlias01, .F., .T.)
            
            If (cAlias01)->( ! Eof() )
				cDtLib := (cAlias01)->C9_DATALIB
				cHrLib := (cAlias01)->C9_YHORLIB
			Endif

			(cAlias01)->( dbCloseArea() )
		
            nAux++
            aAdd( aListCli , JsonObject():New() )
            aListCli[nAux]['C6_YCODF']      := ( cAlias )->C6_YCODF
            aListCli[nAux]['C5_NUM']        := ( cAlias )->C5_NUM
            aListCli[nAux]['C5_CLIENTE']    := ( cAlias )->C5_CLIENTE
            aListCli[nAux]['C5_YNOMCLI']    := EncodeUTF8(( cAlias )->C5_YNOMCLI,"cp1251")	//FwNoAccent(( cAlias )->C5_YNOMCLI)
            aListCli[nAux]['C5_EMISSAO']    := ( cAlias )->C5_EMISSAO
            aListCli[nAux]['C5_YHOREMI']    := SC5->C5_YHOREMI
            aListCli[nAux]['C9_DATALIB']    := cDtLib
            aListCli[nAux]['C9_YHORLIB']    := cHrLib
            aListCli[nAux]['C9_YDATCRD']    := cDtCrd
            aListCli[nAux]['C9_YHORCRD']    := cHrCrd
            aListCli[nAux]['C2_YDTFIRM']    := aInfo[5]
            aListCli[nAux]['C2_YHRFIRM']    := aInfo[6]
            if empty(aInfo[1])
                aListCli[nAux]['C2_DATRF']      := ""
                aListCli[nAux]['C2_YHREMIS']    := ""
            else
                aListCli[nAux]['C2_DATRF']      := aInfo[1]
                aListCli[nAux]['C2_YHREMIS']    := aInfo[4]
            Endif
            aListCli[nAux]['QTDE']          := ( cAlias )->QTDE
            aListCli[nAux]['PRODUCCION']    := aInfo[2]
            aListCli[nAux]['APUNTE']        := aInfo[3]
            aListCli[nAux]['AVANCE']        := alltrim( str( round( ( aInfo[3]*100/aInfo[2] ),0 ) ) )

            ( cAlias )->( DBSkip() )
        
        End

    Endif

    ( cAlias )->( DBCloseArea() )

    aListCli := ASORT(aListCli)

    oJsonCli['results'] := aListCli
    //-------------------------------------------------------------------
    // Serializa objeto Json
    //-------------------------------------------------------------------
    cJsonCli:= FwJsonSerialize( oJsonCli )
    //cJsonCli:= FwJsonSerialize( aListCli )
    //-------------------------------------------------------------------
    // Elimina objeto da memoria
    //-------------------------------------------------------------------
    //FreeObj(oJsonCli)
    oself:SetResponse( cJsonCli ) //-- Seta resposta

Return .T.


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
