#include "TOTVS.CH"
#Include "RWMAKE.CH"
#Include "RESTFUL.CH"

WSRESTFUL STHFAT03 DESCRIPTION "Ventas Familia x Componente" FORMAT APPLICATION_JSON
    WSDATA fechaini            AS STRING   OPTIONAL
    WSDATA fechafim            AS STRING   OPTIONAL
    WSDATA cfamilia            AS STRING   OPTIONAL
    //Endereço para pegar os dados
    //http://localhost:8082/rest/api/v1/spcliente
    WSMETHOD GET famcomponente DESCRIPTION 'FAT03 ventas Familia x componente' WSSYNTAX '/api/v1/sthfat03' PATH '/api/v1/sthfat03' PRODUCES APPLICATION_JSON
END WSRESTFUL

WSMETHOD GET famcomponente WSRECEIVE fechaini, fechafim, cfamilia WSREST STHFAT03
    Local lRet:= .T.
    lRet := famcomponente( self )
Return( lRet )

Static Function famcomponente( oSelf )

    Local aListCli  := {}
    Local cJsonCli  := ''
    Local oJsonCli  := JsonObject():New()
    Local cAlias    := GetNextAlias()
    Local nAux      := 0

    Default oself:fechaini  := ''
    Default oself:fechafim  := ''
    Default oself:cfamilia  := ''

    SB1->(DBSetOrder(1))

    csql := "SELECT ZZE_FAMILI,ZZE_COMP,D2_UM,D2_EMISSAO,D2_QTDE"
    csql += "  FROM STHFAT01"
    csql += " WHERE D2_EMISSAO BETWEEN '" + oself:fechaini + "' AND '" + oself:fechafim + "'"

    if !empty(oself:cfamilia)
        csql += " AND ZZE_FAMILI = '" + oself:cfamilia + "'"
    endif

    csql += " ORDER BY ZZE_FAMILI,ZZE_COMP,D2_EMISSAO"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,csql),cAlias, .F., .T.)
	
    If ( cAlias )->( ! Eof() )

        While ( cAlias )->( ! Eof() )

            SB1->( MsSeek( xFilial("SB1")+( cAlias )->ZZE_COMP ) )

            nAux++
            aAdd( aListCli , JsonObject():New() )
            aListCli[nAux]['FAMILIA']       := ( cAlias )->ZZE_FAMILI
            aListCli[nAux]['COMPONENTE']    := ( cAlias )->ZZE_COMP
            aListCli[nAux]['DESCOMP']       := FwNoAccent(SB1->B1_DESC)
            aListCli[nAux]['UM']            := ( cAlias )->D2_UM
            aListCli[nAux]['EMISSAO']       := ( cAlias )->D2_EMISSAO
            aListCli[nAux]['QTDE']          := ( cAlias )->D2_QTDE
            aListCli[nAux]['SALDO']         := fgetSaldo(( cAlias )->ZZE_COMP)

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

Static Function fgetSaldo(cIdProd)

	local v_area := getArea()
	local n_saldo := 0
    local xAlias := GetNextAlias()

    vqry := "SELECT B2_FILIAL,B2_COD,SUM(B2_QATU) B2_QATU "
    vqry += "  FROM SB2020 "
    vqry += " WHERE D_E_L_E_T_=''"
    vqry += "   AND B2_COD='" + cIdProd + "'"
    vqry += " GROUP BY B2_FILIAL,B2_COD"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,vqry),xAlias, .F., .T.)
	
    If ( xAlias )->( ! Eof() )
        n_saldo := ( xAlias )->B2_QATU
    Endif

    ( xAlias )->( DBCloseArea() )

	restArea(v_area)

Return( n_saldo )
