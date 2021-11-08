#include "TOTVS.CH"
#Include "RWMAKE.CH"
#Include "RESTFUL.CH"
#INCLUDE "Topconn.ch"

WSRESTFUL STHCAD02 DESCRIPTION "Clientes" FORMAT APPLICATION_JSON
    WSDATA cCliente  AS STRING   OPTIONAL

    WSMETHOD GET getcliente DESCRIPTION 'Clientes' WSSYNTAX '/api/v1/sthcad02' PATH '/api/v1/sthcad02' PRODUCES APPLICATION_JSON
END WSRESTFUL

WSMETHOD GET getcliente WSRECEIVE cCliente WSREST STHCAD02
    Local lRet:= .T.
    lRet := getcliente( self )
Return( lRet )

Static Function getcliente( oSelf )

    Local aListCli  := {}
    Local cJsonCli  := ''
    Local oJsonCli  := JsonObject():New()
    Local cAlias    := GetNextAlias()
    Local nAux      := 0

    Default oself:cCliente  := ''

	SB2->( dbSetOrder(1) )

    cQry := ""
	cQry += "SELECT A1_COD,A1_LOJA,A1_NOME,A1_END,A1_BAIRRO,A1_MUN,A1_ESTADO,A1_EMAIL"
	cQry += "  FROM "+RetSqlName("SA1")+ " A1"
	cQry += " WHERE A1_FILIAL='"+xFilial("SA1")+"'"
	cQry += "   AND A1.D_E_L_E_T_=' '"
	cQry += "   AND A1_COD = '"+ oself:cCliente +"'"
	cQry += " ORDER BY A1_COD,A1_LOJA"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry),cAlias, .F., .T.)
	
    If ( cAlias )->( ! Eof() )

        While ( cAlias )->( ! Eof() )

            nAux++
            aAdd( aListCli , JsonObject():New() )
            aListCli[nAux]['A1_COD']      := ( cAlias )->A1_COD
            aListCli[nAux]['A1_LOJA']     := ( cAlias )->A1_LOJA
            aListCli[nAux]['A1_NOME']     := EncodeUTF8(( cAlias )->A1_NOME,"cp1251")
            aListCli[nAux]['A1_END']      := EncodeUTF8(( cAlias )->A1_END,"cp1251")
            aListCli[nAux]['A1_BAIRRO']   := EncodeUTF8(( cAlias )->A1_BAIRRO,"cp1251")
            aListCli[nAux]['A1_MUN']      := EncodeUTF8(( cAlias )->A1_MUN,"cp1251")
            aListCli[nAux]['A1_ESTADO']   := EncodeUTF8(( cAlias )->A1_ESTADO,"cp1251")
            aListCli[nAux]['A1_EMAIL']    := EncodeUTF8(( cAlias )->A1_EMAIL,"cp1251")
            aListCli[nAux]['A1_OK']       := .t.

            ( cAlias )->( DBSkip() )
        
        End
    else
        nAux++
        aAdd( aListCli , JsonObject():New() )
        aListCli[nAux]['A1_COD']      := "500"
        aListCli[nAux]['A1_LOJA']     := ""
        aListCli[nAux]['A1_NOME']     := ""
        aListCli[nAux]['A1_END']      := ""
        aListCli[nAux]['A1_BAIRRO']   := ""
        aListCli[nAux]['A1_MUN']      := ""
        aListCli[nAux]['A1_ESTADO']   := ""
        aListCli[nAux]['A1_EMAIL']    := ""
        aListCli[nAux]['A1_OK']       := .f.

    Endif

    ( cAlias )->( DBCloseArea() )

    //aListCli := ASORT(aListCli)

    oJsonCli['results'] := aListCli
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
