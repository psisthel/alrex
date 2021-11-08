#include "TOTVS.CH"
#Include "RWMAKE.CH"
#Include "RESTFUL.CH"

WSRESTFUL STHFIN02 DESCRIPTION "Movimientos Bancarios" FORMAT APPLICATION_JSON
    WSDATA fechaini            AS STRING OPTIONAL
    WSDATA fechafim            AS STRING OPTIONAL
    WSDATA cuentabco           AS STRING OPTIONAL
    //Endereço para pegar os dados
    //http://localhost:8082/rest/api/v1/spcliente
    WSMETHOD GET movbancarios DESCRIPTION 'FIN02 Movimientos Bancarios' WSSYNTAX '/api/v1/sthfin02' PATH '/api/v1/sthfin02' PRODUCES APPLICATION_JSON
END WSRESTFUL

WSMETHOD GET movbancarios WSRECEIVE fechaini, fechafim, cuentabco WSREST STHFIN02
    Local lRet:= .T.
    lRet := movbancarios( self )
Return( lRet )

Static Function movbancarios( oSelf )
    Local aListSE5  := {}
    Local cJsonCli  := ''
    Local oJsonCli  := JsonObject():New()
    Local cAlias    := GetNextAlias()
    Local cAliasM2  := GetNextAlias()
    Local nAux      := 0

    Default oself:fechaini  := ''
    Default oself:fechafim  := ''
    Default oself:cuentabco := ''

    csql := "SELECT E5_BANCO,E5_AGENCIA,E5_CONTA,E5_NUMERO,E5_DOCUMEN,E5_DATA,E5_CLIFOR,E5_LOJA,E5_BENEF,E5_TIPO,E5_HISTOR,E5_MOTBX,E5_TXMOEDA,"
    csql += "       CASE WHEN E5_RECPAG='R' THEN  E5_VALOR ELSE 0 END ENTRADAS,"
    csql += "       CASE WHEN E5_RECPAG='P' THEN  E5_VALOR ELSE 0 END SALIDAS,"
    csql += "       R_E_C_N_O_ AS NREC"
    csql += "  FROM SE5020 "
    csql += " WHERE E5_FILIAL='01'"
    csql += "   AND E5_DATA BETWEEN '" + oself:fechaini + "' AND '" + oself:fechafim + "'"
    if !empty(oself:cuentabco)
        csql += " AND E5_CONTA='" + oself:cuentabco + "'"
    endif
    csql += "   AND D_E_L_E_T_=''"
    csql += "   AND E5_BANCO<>''"
    csql += " ORDER BY E5_BANCO,E5_AGENCIA,E5_CONTA,R_E_C_N_O_"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,csql),cAlias, .F., .T.)
	
    If ( cAlias )->( ! Eof() )

        While ( cAlias )->( ! Eof() )

            nTipoCambio := ( cAlias )->E5_TXMOEDA

            if nTipoCambio <= 1 

                xsql := "SELECT M2_MOEDA2"
                xsql += "  FROM SM2020"
                xsql += " WHERE M2_DATA='" + ( cAlias )->E5_DATA + "'"

                dbUseArea(.T., "TOPCONN", TCGenQry(,,xsql),cAliasM2, .F., .T.)
                
                If ( cAliasM2 )->( ! Eof() )
                    nTipoCambio := ( cAliasM2 )->M2_MOEDA2
                Endif

                (cAliasM2)->( DBCloseArea())

            endif

            nAux++
            aAdd( aListSE5 , JsonObject():New() )
            aListSE5[nAux]['E5_BANCO']      := ( cAlias )->E5_BANCO
            aListSE5[nAux]['E5_AGENCIA']    := ( cAlias )->E5_AGENCIA
            aListSE5[nAux]['E5_CONTA']      := ( cAlias )->E5_CONTA
            aListSE5[nAux]['E5_NUMERO']     := ( cAlias )->E5_NUMERO
            aListSE5[nAux]['E5_DOCUMEN']    := EncodeUTF8(( cAlias )->E5_DOCUMEN,"cp1251")
            aListSE5[nAux]['E5_DATA']       := ( cAlias )->E5_DATA
            aListSE5[nAux]['E5_CLIFOR']     := ( cAlias )->E5_CLIFOR
            aListSE5[nAux]['E5_LOJA']       := ( cAlias )->E5_LOJA
            aListSE5[nAux]['E5_BENEF']      := EncodeUTF8(( cAlias )->E5_BENEF,"cp1251")
            aListSE5[nAux]['E5_TIPO']       := ( cAlias )->E5_TIPO
            aListSE5[nAux]['E5_HISTOR']     := EncodeUTF8(( cAlias )->E5_HISTOR,"cp1251")
            aListSE5[nAux]['E5_MOTBX']      := ( cAlias )->E5_MOTBX
            aListSE5[nAux]['E5_TXMOEDA']    := nTipoCambio
            aListSE5[nAux]['ENTRADAS']      := ( cAlias )->ENTRADAS
            aListSE5[nAux]['SALIDAS']       := ( cAlias )->SALIDAS
            aListSE5[nAux]['NREC']          := ( cAlias )->NREC

            ( cAlias )->( DBSkip() )
        End
    Endif

    ( cAlias )->( DBCloseArea() )

    oJsonCli['results'] := aListSE5
    //-------------------------------------------------------------------
    // Serializa objeto Json
    //-------------------------------------------------------------------
    cJsonCli:= FwJsonSerialize( oJsonCli )
    //cJsonCli:= FwJsonSerialize( aListSE5 )
    //-------------------------------------------------------------------
    // Elimina objeto da memoria
    //-------------------------------------------------------------------
    FreeObj(oJsonCli)
    oself:SetResponse( cJsonCli ) //-- Seta resposta

Return .T.
