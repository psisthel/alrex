#include "TOTVS.CH"
#Include "RWMAKE.CH"
#Include "RESTFUL.CH"
#INCLUDE "Topconn.ch"

WSRESTFUL STHFAT05 DESCRIPTION "Estatus de Pedidos de Ventas" FORMAT APPLICATION_JSON
    WSDATA fechaini            AS STRING   OPTIONAL
    WSDATA fechafim            AS STRING   OPTIONAL
    WSDATA cfamiIni            AS STRING   OPTIONAL
    WSDATA cfamiFim            AS STRING   OPTIONAL
    WSDATA cPedidoIni          AS STRING   OPTIONAL
    WSDATA cPedidoFim          AS STRING   OPTIONAL
    WSDATA cClienteIni         AS STRING   OPTIONAL
    WSDATA cClienteFim         AS STRING   OPTIONAL

    WSMETHOD GET pedidoventa DESCRIPTION 'FAT05 Posicion Ped. Ventas' WSSYNTAX '/api/v1/sthfat05' PATH '/api/v1/sthfat05' PRODUCES APPLICATION_JSON
END WSRESTFUL

WSMETHOD GET pedidoventa WSRECEIVE fechaini, fechafim, cfamiIni, cfamiFim, cPedidoIni, cPedidoFim, cClienteIni, cClienteFim WSREST STHFAT05
    Local lRet:= .T.
    lRet := pedidoventa( self )
Return( lRet )

Static Function pedidoventa( oSelf )

    Local aListCli  := {}
    Local cJsonCli  := ''
    Local oJsonCli  := JsonObject():New()
    Local cAlias    := GetNextAlias()
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

	cQry := "SELECT C5_NUM,C6_ITEM,C5_CLIENTE,C5_YNOMCLI,C6_YCODF,UPPER(C5_LOGINCL) C5_LOGINCL,C5_EMISSAO,C5_YFVIGEN,C5_SUGENT,"+CRLF
	cQry += "SUM(C6_QTDVEN) QTDE"+CRLF
	cQry += "  FROM "+RetSqlName("SC5")+" C5"+CRLF
	cQry += "  LEFT JOIN "+RetSqlName("SC6")+" C6"+CRLF 
	cQry += "    ON C5_NUM=C6_NUM"+CRLF
	cQry += "   AND C5_CLIENTE=C6_CLI"+CRLF
	cQry += " WHERE C5_FILIAL='"+xFilial("SC5")+"'"+CRLF
	cQry += "   AND C6_FILIAL='"+xFilial("SC6")+"'"+CRLF
	cQry += "   AND C5.D_E_L_E_T_=''"+CRLF
	cQry += "   AND C6.D_E_L_E_T_=''"+CRLF
	cQry += "   AND C5_NUM BETWEEN '"+ oself:cPedidoIni +"' AND '"+ oself:cPedidoFim +"'"+CRLF
	cQry += "   AND C5_CLIENTE BETWEEN '"+ oself:cClienteIni +"' AND '"+ oself:cClienteFim +"'"+CRLF
	cQry += "   AND C5_EMISSAO BETWEEN '"+ oself:fechaini +"' AND '"+ oself:fechafim +"'"+CRLF
    cQry += "   AND C6_YCODF BETWEEN '"+ oself:cfamiIni +"' AND '"+ oself:cfamiFim +"'"+CRLF
	cQry += " GROUP BY C5_NUM,C6_ITEM,C5_CLIENTE,C5_YNOMCLI,C6_YCODF,C5_LOGINCL,C5_EMISSAO,C5_YFVIGEN,C5_SUGENT"+CRLF
	cQry += " ORDER BY C5_NUM,C6_ITEM,C5_CLIENTE,C5_YNOMCLI,C6_YCODF,C5_LOGINCL,C5_EMISSAO,C5_YFVIGEN,C5_SUGENT"+CRLF

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry),cAlias, .F., .T.)
	
    If ( cAlias )->( ! Eof() )

        While ( cAlias )->( ! Eof() )

			SC6->( MsSeek( xFilial("SC6")+(cAlias)->C5_NUM+(cAlias)->C6_ITEM ) )

			cDtLib := ""
			cHrLib := ""
			cBlqCre := ""
			cBlqStk := ""
		
			xSql := "SELECT C9_YHORLIB,C9_DATALIB,C9_BLEST,C9_BLCRED"+CRLF
			xSql += "  FROM "+RetSqlName("SC9")+CRLF
			xSql += " WHERE C9_FILIAL='"+xFilial("SC9")+"'"+CRLF
			xSql += "   AND C9_PEDIDO='"+(cAlias)->C5_NUM+"'"+CRLF
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
			xSql += "   AND C2_PEDIDO='"+(cAlias)->C5_NUM+"'"+CRLF
			xSql += "   AND D_E_L_E_T_=' '"+CRLF
			 
			xSql := ChangeQuery(xSql)
			
			If Select("XQRY") > 0
				XQRY->( dbClosearea() )
			EndIf
			
			TcQuery xSql New Alias "XQRY"
			
			If XQRY->( !Eof() )
				if empty(XQRY->C2_YDTFIRM) .And. empty(XQRY->C2_DATRF) .AND. XQRY->C2_TPOP=='P'
					cFechaFP := XQRY->C2_EMISSAO
				elseif !empty(XQRY->C2_YDTFIRM) .And. empty(XQRY->C2_DATRF) .And. XQRY->C2_QUJE<=0 .And. XQRY->C2_TPOP=='F'
					cFechaFP := XQRY->C2_YDTFIRM
				elseIF !empty(XQRY->C2_DATRF) .And. XQRY->C2_TPOP='F' .And. XQRY->C2_QUJE>0
					cFechaFP := XQRY->C2_DATRF
				else
					cFechaFP := XQRY->C2_YDTFIRM
				endif
			Endif
			XQRY->( dbCloseArea() )

            nAux++
            aAdd( aListCli , JsonObject():New() )
            aListCli[nAux]['C5_NUM']        := ( cAlias )->C5_NUM
            aListCli[nAux]['C6_ITEM']       := ( cAlias )->C6_ITEM
            aListCli[nAux]['C5_CLIENTE']    := ( cAlias )->C5_CLIENTE
            aListCli[nAux]['C5_YNOMCLI']    := EncodeUTF8(( cAlias )->C5_YNOMCLI,"cp1251")
            aListCli[nAux]['C6_YCODF']      := ( cAlias )->C6_YCODF
            aListCli[nAux]['C5_LOGINCL']    := ( cAlias )->C5_LOGINCL
            aListCli[nAux]['C5_EMISSAO']    := ( cAlias )->C5_EMISSAO
            aListCli[nAux]['C5_YFVIGEN']    := ( cAlias )->C5_YFVIGEN
            aListCli[nAux]['C5_SUGENT']     := ( cAlias )->C5_SUGENT
            aListCli[nAux]['C5_SUGENT']     := ( cAlias )->C5_SUGENT
			if !empty(cBlqCre)
				aListCli[nAux]['C9_DATALIB']    := cBlqCre
			elseif !empty(cBlqStk)
				aListCli[nAux]['C9_DATALIB']    := cBlqStk
			else
				aListCli[nAux]['C9_DATALIB']    := cDtLib
			endif
            aListCli[nAux]['C2_EMISSAO']    := cFechaFP
            aListCli[nAux]['QTDE']          := ( cAlias )->QTDE
            aListCli[nAux]['ESTATUS']       := retStatus(( cAlias )->C5_NUM,( cAlias )->C6_ITEM)
            aListCli[nAux]['DOCUMENTO']     := retNFiscal(( cAlias )->C5_NUM,SC6->C6_PRODUTO)

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
