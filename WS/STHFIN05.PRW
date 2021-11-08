#include "TOTVS.CH"
#Include "RWMAKE.CH"
#Include "RESTFUL.CH"

WSRESTFUL STHFIN05 DESCRIPTION "Recibos por Cobrar" FORMAT APPLICATION_JSON
    WSDATA crecibo            AS STRING OPTIONAL
    WSDATA cnumero            AS STRING OPTIONAL
    WSDATA ccliente           AS STRING OPTIONAL
    WSDATA cloja              AS STRING OPTIONAL

    //Endereço para pegar os dados
    //http://localhost:8082/rest/api/v1/spcliente
    WSMETHOD GET recibos_cc DESCRIPTION 'FIN05 Recibos por Cobrar' WSSYNTAX '/api/v1/sthfin05' PATH '/api/v1/sthfin05' PRODUCES APPLICATION_JSON
END WSRESTFUL

WSMETHOD GET recibos_cc WSRECEIVE crecibo, cnumero, ccliente, cloja WSREST STHFIN05
    Local lRet:= .T.
    lRet := recibos_cc( self )
Return( lRet )

Static Function recibos_cc( oSelf )

    Local aListCli  := {}
    Local cJsonCli  := ''
    Local oJsonCli  := JsonObject():New()
    Local cAlias    := GetNextAlias()
    Local nAux      := 0

    Default oself:crecibo  := ''
    Default oself:cnumero  := ''
    Default oself:ccliente := ''
    Default oself:cloja    := ''

    csql := "SELECT EL_RECIBO,EL_CLIENTE,EL_LOJA,EL_TIPO,EL_TIPODOC,EL_PREFIXO,EL_NUMERO,EL_VALOR,"
    csql += "       EL_MOEDA,EL_CONTA,EL_TXMOE02,EL_VLMOED1,EL_EMISSAO"
    csql += "  FROM SEL020 SEL"
    csql += " WHERE EL_FILIAL='01'"
    csql += "   AND (EL_RECIBO='" + oself:crecibo + "' OR EL_NUMERO='" + oself:cnumero + "')"
    //csql += "   AND EL_RECIBO='" + oself:crecibo + "'"
    csql += "   AND EL_CLIENTE='" + oself:ccliente + "'"
    csql += "   AND EL_LOJA='" + oself:cloja + "'"
    csql += "   AND SEL.D_E_L_E_T_=''"
    csql += "   AND EL_CANCEL='F'"
    csql += " ORDER BY SEL.R_E_C_N_O_"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,csql),cAlias, .F., .T.)
	
    If ( cAlias )->( ! Eof() )

        While ( cAlias )->( ! Eof() )

            nAux++
            aAdd( aListCli , JsonObject():New() )
            aListCli[nAux]['EL_RECIBO']     := ( cAlias )->EL_RECIBO
            aListCli[nAux]['EL_CLIENTE']    := ( cAlias )->EL_CLIENTE
            aListCli[nAux]['EL_LOJA']       := ( cAlias )->EL_LOJA
            aListCli[nAux]['EL_TIPO']       := ( cAlias )->EL_TIPO
            aListCli[nAux]['EL_TIPODOC']    := ( cAlias )->EL_TIPODOC
            aListCli[nAux]['EL_PREFIXO']    := ( cAlias )->EL_PREFIXO
            aListCli[nAux]['EL_NUMERO']     := ( cAlias )->EL_NUMERO
            aListCli[nAux]['EL_VALOR']      := ( cAlias )->EL_VALOR
            aListCli[nAux]['EL_MOEDA']      := ( cAlias )->EL_MOEDA
            aListCli[nAux]['EL_CONTA']      := ( cAlias )->EL_CONTA
            aListCli[nAux]['EL_TXMOE02']    := ( cAlias )->EL_TXMOE02
            aListCli[nAux]['EL_VLMOED1']    := ( cAlias )->EL_VLMOED1
            aListCli[nAux]['EL_EMISSAO']    := ( cAlias )->EL_EMISSAO

            ( cAlias )->( DBSkip() )
        End
    Endif

    ( cAlias )->( DBCloseArea() )

    oJsonCli['recibos_cc'] := aListCli
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
