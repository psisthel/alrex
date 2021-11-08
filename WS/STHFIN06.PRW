#include "TOTVS.CH"
#Include "RWMAKE.CH"
#Include "RESTFUL.CH"

WSRESTFUL STHFIN06 DESCRIPTION "Posicion Pedidos x Cobros" FORMAT APPLICATION_JSON
    WSDATA fecha_ini    AS STRING OPTIONAL
    WSDATA fecha_fim    AS STRING OPTIONAL

    WSMETHOD GET pedidos_x_cobros DESCRIPTION 'FIN06 Pedidos por Cobrar' WSSYNTAX '/api/v1/sthfin06' PATH '/api/v1/sthfin06' PRODUCES APPLICATION_JSON
END WSRESTFUL

WSMETHOD GET pedidos_x_cobros WSRECEIVE fecha_ini, fecha_fim WSREST STHFIN06
    Local lRet:= .T.
    lRet := pedidos_x_cobros( self )
Return( lRet )

Static Function pedidos_x_cobros( oSelf )

    Local aListCli  := {}
    Local cJsonCli  := ''
    Local oJsonCli  := JsonObject():New()
    Local cAlias    := GetNextAlias()
    Local nAux      := 0

    Default oself:fecha_ini  := ''
    Default oself:fecha_fim  := ''

    csql := "SELECT C5_NUM AS PEDIDO,"
    csql += "        C5_EMISSAO AS FECHA_EMISION,"
    csql += "        EL_EMISSAO AS FECHA_COBRANZA,"
    csql += "        C5_CLIENTE AS RUC_RG,"
    csql += "        C5_YNOMCLI AS NOMBRE_CLIENTE,"
    csql += "        EL_BANCO AS BANCO,"
    csql += "        EL_CONTA AS CUENTA,"
    csql += "        EL_MOEDA AS MONEDA,"
    csql += "        EL_TXMOE02 AS TP_CAMBIO,"
    csql += "        EL_VALOR AS VALOR_ORIGEN,"
    csql += "        EL_VLMOED1 AS VALOR_SOLES"
    csql += "  FROM SC5020 SC5 "
    csql += "  LEFT JOIN SEL020 SEL ON RTRIM(LTRIM(SC5.C5_NUM))=RTRIM(LTRIM(SEL.EL_NUMERO))"
    csql += "   AND SEL.EL_CANCEL='F'"
    csql += "   AND SEL.D_E_L_E_T_=''"
    csql += "   AND SEL.EL_FILIAL='01'"
    csql += " WHERE SC5.D_E_L_E_T_=''"
    csql += "   AND SC5.C5_EMISSAO BETWEEN '" + oself:fecha_ini + "' AND '" + oself:fecha_fim + "'"
    csql += "   AND SC5.C5_FILIAL='01'"
    csql += " ORDER BY SC5.C5_NUM DESC"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,csql),cAlias, .F., .T.)
	
    If ( cAlias )->( ! Eof() )

        While ( cAlias )->( ! Eof() )

            nAux++
            aAdd( aListCli , JsonObject():New() )
            aListCli[nAux]['PEDIDO']            := ( cAlias )->PEDIDO
            aListCli[nAux]['FECHA_EMISION']     := ( cAlias )->FECHA_EMISION
            aListCli[nAux]['FECHA_COBRANZA']    := ( cAlias )->FECHA_COBRANZA
            aListCli[nAux]['RUC_RG']            := ( cAlias )->RUC_RG
            aListCli[nAux]['NOMBRE_CLIENTE']    := ( cAlias )->NOMBRE_CLIENTE
            aListCli[nAux]['BANCO']             := ( cAlias )->BANCO
            aListCli[nAux]['CUENTA']            := ( cAlias )->CUENTA
            aListCli[nAux]['MONEDA']            := ( cAlias )->MONEDA
            aListCli[nAux]['TP_CAMBIO']         := ( cAlias )->TP_CAMBIO
            aListCli[nAux]['VALOR_ORIGEN']      := ( cAlias )->VALOR_ORIGEN
            aListCli[nAux]['VALOR_SOLES']       := ( cAlias )->VALOR_SOLES

            ( cAlias )->( DBSkip() )
        End
    Endif

    ( cAlias )->( DBCloseArea() )

    oJsonCli['pedidos_x_cobros'] := aListCli
    //-------------------------------------------------------------------
    // Serializa objeto Json
    //-------------------------------------------------------------------
    cJsonCli:= FwJsonSerialize( oJsonCli )
    //cJsonCli:= FwJsonSerialize( aListCli )
    //-------------------------------------------------------------------
    // Elimina objeto da memoria
    //-------------------------------------------------------------------
    FreeObj(oJsonCli)
    oself:SetResponse( cJsonCli ) //-- Seta resposta

Return .T.
