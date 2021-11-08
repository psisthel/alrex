#include "TOTVS.CH"
#Include "RWMAKE.CH"
#Include "RESTFUL.CH"

WSRESTFUL STHFIN03 DESCRIPTION "Cuentas por Pagar" FORMAT APPLICATION_JSON
    WSDATA fechaini            AS STRING OPTIONAL
    WSDATA fechafim            AS STRING OPTIONAL
    WSDATA cstatus             AS STRING OPTIONAL
    //Endereço para pegar os dados
    //http://localhost:8082/rest/api/v1/spcliente
    WSMETHOD GET cpagar DESCRIPTION 'FIN03 Cuentas por Pagar' WSSYNTAX '/api/v1/sthfin03' PATH '/api/v1/sthfin03' PRODUCES APPLICATION_JSON
END WSRESTFUL

WSMETHOD GET cpagar WSRECEIVE fechaini, fechafim, cstatus WSREST STHFIN03
    Local lRet:= .T.
    lRet := cpagar( self )
Return( lRet )

Static Function cpagar( oSelf )
    Local aListCli  := {}
    Local cJsonCli  := ''
    Local oJsonCli  := JsonObject():New()
    Local cAlias    := GetNextAlias()
    Local cAliasM2  := GetNextAlias()
    Local nAux      := 0

    Default oself:fechaini  := ''
    Default oself:fechafim  := ''
    Default oself:cstatus   := "T"

    csql := "SELECT E2_NUM,E2_PREFIXO,E2_FORNECE,E2_LOJA,E2_NOMFOR,E2_EMISSAO,E2_VENCTO,E2_VENCREA,E2_MOEDA,E2_TXMOEDA,E2_VALOR,"
    csql += "       E2_VLCRUZ,E2_VALLIQ,E2_SALDO,E2_TIPO,E2_BAIXA,R_E_C_N_O_ AS E2_ID,E2_ORDPAGO"
    csql += "  FROM SE2020"
    csql += " WHERE E2_FILIAL='01'"
    csql += "   AND E2_VENCREA BETWEEN '" + oself:fechaini + "' AND '" + oself:fechafim + "'"
    if oself:cstatus=="C"
        csql += "   AND E2_VALLIQ>0"
    elseif oself:cstatus=="P"
        csql += "   AND E2_SALDO>0"
    endif
    csql += "   AND D_E_L_E_T_=''"
    //csql += "   AND E1_TIPO='NF'"
    csql += " ORDER BY E2_VENCREA,E2_FORNECE"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,csql),cAlias, .F., .T.)
	
    If ( cAlias )->( ! Eof() )

        While ( cAlias )->( ! Eof() )

            nTipoCambio = ( cAlias )->E2_TXMOEDA

            if nTipoCambio <= 1 

                xsql := "SELECT M2_MOEDA2"
                xsql += "  FROM SM2020"
                xsql += " WHERE M2_DATA='" + ( cAlias )->E2_EMISSAO + "'"

                dbUseArea(.T., "TOPCONN", TCGenQry(,,xsql),cAliasM2, .F., .T.)
                
                If ( cAliasM2 )->( ! Eof() )
                    nTipoCambio := ( cAliasM2 )->M2_MOEDA2
                Endif

                (cAliasM2)->( DBCloseArea())

            endif


            nAux++
            aAdd( aListCli , JsonObject():New() )
            aListCli[nAux]['E2_PREFIXO']    := ( cAlias )->E2_PREFIXO
            aListCli[nAux]['E2_NUM']        := ( cAlias )->E2_NUM
            aListCli[nAux]['E2_FORNECE']    := ( cAlias )->E2_FORNECE
            aListCli[nAux]['E2_LOJA']       := ( cAlias )->E2_LOJA
            aListCli[nAux]['E2_NOMFOR']     := EncodeUTF8(( cAlias )->E2_NOMFOR,"cp1251")
            aListCli[nAux]['E2_EMISSAO']    := ( cAlias )->E2_EMISSAO
            aListCli[nAux]['E2_VENCTO']     := ( cAlias )->E2_VENCTO
            aListCli[nAux]['E2_VENCREA']    := ( cAlias )->E2_VENCREA
            aListCli[nAux]['E2_MOEDA']      := ( cAlias )->E2_MOEDA
            aListCli[nAux]['E2_TXMOEDA']    := nTipoCambio
            aListCli[nAux]['E2_VALOR']      := ( cAlias )->E2_VALOR
            aListCli[nAux]['E2_VLCRUZ']     := ( cAlias )->E2_VLCRUZ
            aListCli[nAux]['E2_VALLIQ']     := ( cAlias )->E2_VALLIQ
            aListCli[nAux]['E2_SALDO']      := ( cAlias )->E2_SALDO
            aListCli[nAux]['E2_TIPO']       := ( cAlias )->E2_TIPO
            aListCli[nAux]['E2_BAIXA']      := ( cAlias )->E2_BAIXA
            aListCli[nAux]['E2_ID']         := ( cAlias )->E2_ID
            aListCli[nAux]['E2_ORDPAGO']    := ( cAlias )->E2_ORDPAGO

            ( cAlias )->( DBSkip() )
        End
    Endif

    ( cAlias )->( DBCloseArea() )

    oJsonCli['cpagar'] := aListCli
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
