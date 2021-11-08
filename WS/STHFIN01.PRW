#include "TOTVS.CH"
#Include "RWMAKE.CH"
#Include "RESTFUL.CH"

WSRESTFUL STHFIN01 DESCRIPTION "Cuentas por Cobrar" FORMAT APPLICATION_JSON
    WSDATA fechaini            AS STRING OPTIONAL
    WSDATA fechafim            AS STRING OPTIONAL
    //Endereço para pegar os dados
    //http://localhost:8082/rest/api/v1/spcliente
    WSMETHOD GET ccobrar DESCRIPTION 'FIN01 Cuentas por Cobrar' WSSYNTAX '/api/v1/sthfin01' PATH '/api/v1/sthfin01' PRODUCES APPLICATION_JSON
END WSRESTFUL
//-------------------------------------------------------------------
/*/{Protheus.doc} GET / cliente
Retorna a lista de clientes disponíveis.
@param  SearchKey       , caracter, chave de pesquisa utilizada em diversos campos
Page            , numerico, numero da pagina
PageSize        , numerico, quantidade de registros por pagina
byId            , logico, indica se deve filtrar apenas pelo codigo
@return cResponse       , caracter, JSON contendo a lista de clientes
@author rafael.goncalves
@since      Mar|2020
@version    12.1.27
/*/
//-------------------------------------------------------------------
WSMETHOD GET ccobrar WSRECEIVE fechaini, fechafim WSREST STHFIN01
    Local lRet:= .T.
    lRet := ccobrar( self )
Return( lRet )

Static Function ccobrar( oSelf )
    Local aListCli  := {}
    Local cJsonCli  := ''
    Local oJsonCli  := JsonObject():New()
    Local cAlias    := GetNextAlias()
    Local cAliasM2  := GetNextAlias()
    Local nAux      := 0

    Default oself:fechaini  := ''
    Default oself:fechafim  := ''

    csql := "SELECT E1_NUM,E1_PREFIXO,E1_CLIENTE,E1_LOJA,E1_NOMCLI,E1_EMISSAO,E1_VENCTO,E1_VENCREA,E1_MOEDA,E1_TXMOEDA,E1_VALOR,"
    csql += "       E1_VLCRUZ,E1_VALLIQ,E1_SALDO,E1_TIPO,E1_BAIXA,R_E_C_N_O_ AS E1_ID,E1_RECIBO"
    csql += "  FROM SE1020"
    csql += " WHERE E1_FILIAL='01'"
    csql += "   AND E1_VENCREA BETWEEN '" + oself:fechaini + "' AND '" + oself:fechafim + "'"
    //csql += "   AND E1_SALDO>0"
    csql += "   AND D_E_L_E_T_=''"
    //csql += "   AND E1_TIPO='NF'"
    csql += " ORDER BY E1_VENCREA,E1_CLIENTE"


	dbUseArea(.T., "TOPCONN", TCGenQry(,,csql),cAlias, .F., .T.)
	
    If ( cAlias )->( ! Eof() )

        While ( cAlias )->( ! Eof() )

            nTipoCambio = ( cAlias )->E1_TXMOEDA

            if nTipoCambio <= 1 

                xsql := "SELECT M2_MOEDA2"
                xsql += "  FROM SM2020"
                xsql += " WHERE M2_DATA='" + ( cAlias )->E1_EMISSAO + "'"

                dbUseArea(.T., "TOPCONN", TCGenQry(,,xsql),cAliasM2, .F., .T.)
                
                If ( cAliasM2 )->( ! Eof() )
                    nTipoCambio := ( cAliasM2 )->M2_MOEDA2
                Endif

                (cAliasM2)->( DBCloseArea())

            endif


            nAux++
            aAdd( aListCli , JsonObject():New() )
            aListCli[nAux]['E1_PREFIXO']    := ( cAlias )->E1_PREFIXO
            aListCli[nAux]['E1_NUM']        := ( cAlias )->E1_NUM
            aListCli[nAux]['E1_CLIENTE']    := ( cAlias )->E1_CLIENTE
            aListCli[nAux]['E1_LOJA']       := ( cAlias )->E1_LOJA
            aListCli[nAux]['E1_NOMCLI']     := EncodeUTF8(( cAlias )->E1_NOMCLI,"cp1251")
            aListCli[nAux]['E1_EMISSAO']    := ( cAlias )->E1_EMISSAO
            aListCli[nAux]['E1_VENCTO']     := ( cAlias )->E1_VENCTO
            aListCli[nAux]['E1_VENCREA']    := ( cAlias )->E1_VENCREA
            aListCli[nAux]['E1_MOEDA']      := ( cAlias )->E1_MOEDA
            aListCli[nAux]['E1_TXMOEDA']    := nTipoCambio
            aListCli[nAux]['E1_VALOR']      := ( cAlias )->E1_VALOR
            aListCli[nAux]['E1_VLCRUZ']     := ( cAlias )->E1_VLCRUZ
            aListCli[nAux]['E1_VALLIQ']     := ( cAlias )->E1_VALLIQ
            aListCli[nAux]['E1_SALDO']      := ( cAlias )->E1_SALDO
            aListCli[nAux]['E1_TIPO']       := ( cAlias )->E1_TIPO
            aListCli[nAux]['E1_BAIXA']      := ( cAlias )->E1_BAIXA
            aListCli[nAux]['E1_ID']         := ( cAlias )->E1_ID
            aListCli[nAux]['E1_RECIBO']     := ( cAlias )->E1_RECIBO

            ( cAlias )->( DBSkip() )
        End
    Endif

    ( cAlias )->( DBCloseArea() )

    oJsonCli['ccobrar'] := aListCli
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
