#include "TOTVS.CH"
#Include "RWMAKE.CH"
#Include "RESTFUL.CH"

WSRESTFUL STHFIN04 DESCRIPTION "Cuntas Banco" FORMAT APPLICATION_JSON
    WSMETHOD GET bancos DESCRIPTION 'FIN04 Cuentas Banco' WSSYNTAX '/api/v1/sthfin04' PATH '/api/v1/sthfin04' PRODUCES APPLICATION_JSON
END WSRESTFUL

WSMETHOD GET bancos WSREST STHFIN04
    Local lRet:= .T.
    lRet := bancos( self )
Return( lRet )

Static Function bancos( oSelf )
    Local aListCli  := {}
    Local cJsonCli  := ''
    Local oJsonCli  := JsonObject():New()
    Local cAlias    := GetNextAlias()
    Local nAux      := 0

    csql := "SELECT A6_COD,A6_AGENCIA,A6_NUMCON,A6_NOME,A6_NREDUZ,A6_END,A6_EST,A6_TEL,A6_CONTATO,A6_MOEDA"
    csql += "  FROM SA6020"
    csql += " WHERE A6_FILIAL='  '"
    csql += "   AND D_E_L_E_T_=''"
    csql += " ORDER BY A6_COD"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,csql),cAlias, .F., .T.)
	
    If ( cAlias )->( ! Eof() )

        While ( cAlias )->( ! Eof() )

            nAux++
            aAdd( aListCli , JsonObject():New() )
            aListCli[nAux]['A6_COD']        := ( cAlias )->A6_COD
            aListCli[nAux]['A6_AGENCIA']    := ( cAlias )->A6_AGENCIA
            aListCli[nAux]['A6_NUMCON']     := ( cAlias )->A6_NUMCON
            aListCli[nAux]['A6_NOME']       := EncodeUTF8(( cAlias )->A6_NOME,"cp1251")
            aListCli[nAux]['A6_NREDUZ']     := EncodeUTF8(( cAlias )->A6_NREDUZ,"cp1251")
            aListCli[nAux]['A6_END']        := EncodeUTF8(( cAlias )->A6_END,"cp1251")
            aListCli[nAux]['A6_TEL']        := ( cAlias )->A6_TEL
            aListCli[nAux]['A6_CONTATO']    := EncodeUTF8(( cAlias )->A6_CONTATO,"cp1251")
            aListCli[nAux]['A6_MOEDA']      := ( cAlias )->A6_MOEDA

            ( cAlias )->( DBSkip() )
        End
    Endif

    ( cAlias )->( DBCloseArea() )

    oJsonCli['bancos'] := aListCli
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
