#include "TOTVS.CH"
#Include "RWMAKE.CH"
#Include "RESTFUL.CH"
//Exemplo de WS para retorno do cliente
//Para mais informações acesse: www.sempreju.com.br e/ou nosso GIT https://github.com/llrafaell/SemPreju-Exemplos
WSRESTFUL STHFAT02 DESCRIPTION "Ventas Familia x Mes" FORMAT APPLICATION_JSON
    WSDATA fechaini            AS STRING   OPTIONAL
    WSDATA fechafim            AS STRING   OPTIONAL
    //Endereço para pegar os dados
    //http://localhost:8082/rest/api/v1/spcliente
    WSMETHOD GET familiaxmes DESCRIPTION 'FAT02 ventas por Familia' WSSYNTAX '/api/v1/sthfat02' PATH '/api/v1/sthfat02' PRODUCES APPLICATION_JSON
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
WSMETHOD GET familiaxmes WSRECEIVE fechaini, fechafim WSREST STHFAT02
    Local lRet:= .T.
    lRet := familiaxmes( self )
Return( lRet )

Static Function familiaxmes( oSelf )
    Local aListCli  := {}
    Local cJsonCli  := ''
    Local oJsonCli  := JsonObject():New()
    Local cAlias    := GetNextAlias()
    Local nAux      := 0

    Default oself:fechaini  := ''
    Default oself:fechafim  := ''

    csql := "SELECT C6_YCODF,ZZD_DESCRI,ENERO,FEBRERO,MARZO,ABRIL,MAYO,JUNIO,JULIO,AGOSTO,SEPTIEMBRE,OCTUBRE,NOVIEMBRE,DICIEMBRE"
    csql += "  FROM STHFAT02"
    csql += " ORDER BY C6_YCODF"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,csql),cAlias, .F., .T.)
	
    If ( cAlias )->( ! Eof() )

        While ( cAlias )->( ! Eof() )
            nAux++
            aAdd( aListCli , JsonObject():New() )
            aListCli[nAux]['A']   := ( cAlias )->C6_YCODF
            aListCli[nAux]['B']   := ( cAlias )->ZZD_DESCRI
            aListCli[nAux]['C']   := ( cAlias )->ENERO
            aListCli[nAux]['D']   := ( cAlias )->FEBRERO
            aListCli[nAux]['E']   := ( cAlias )->MARZO
            aListCli[nAux]['F']   := ( cAlias )->ABRIL
            aListCli[nAux]['G']   := ( cAlias )->MAYO
            aListCli[nAux]['H']   := ( cAlias )->JUNIO
            aListCli[nAux]['I']   := ( cAlias )->JULIO
            aListCli[nAux]['J']   := ( cAlias )->AGOSTO
            aListCli[nAux]['K']   := ( cAlias )->SEPTIEMBRE
            aListCli[nAux]['L']   := ( cAlias )->OCTUBRE
            aListCli[nAux]['M']   := ( cAlias )->NOVIEMBRE
            aListCli[nAux]['N']   := ( cAlias )->DICIEMBRE

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
