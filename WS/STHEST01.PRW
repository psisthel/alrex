#include "TOTVS.CH"
#Include "RWMAKE.CH"
#Include "RESTFUL.CH"
#INCLUDE "Topconn.ch"

WSRESTFUL STHEST01 DESCRIPTION "Situacion Actual de Stock" FORMAT APPLICATION_JSON
    WSDATA cProdutoIni  AS STRING   OPTIONAL
    WSDATA cProdutoFim  AS STRING   OPTIONAL
    WSDATA cLocal       AS STRING   OPTIONAL

    WSMETHOD GET stock DESCRIPTION 'EST01 Situacion Actual de Stock' WSSYNTAX '/api/v1/sthest01' PATH '/api/v1/sthest01' PRODUCES APPLICATION_JSON
END WSRESTFUL

WSMETHOD GET stock WSRECEIVE cProdutoIni, cProdutoFim, cLocal WSREST STHEST01
    Local lRet:= .T.
    lRet := stock( self )
Return( lRet )

Static Function stock( oSelf )

    Local aListCli  := {}
    Local cJsonCli  := ''
    Local oJsonCli  := JsonObject():New()
    Local cAlias    := GetNextAlias()
    Local nAux      := 0

    Default oself:cProdutoIni  := ''
    Default oself:cProdutoFim  := 'ZZZZZZZZZZZZZZZ'
    Default oself:cLocal := ''

	SB2->( dbSetOrder(1) )

    cQry := ""
	cQry += "SELECT B2_COD,B1_DESC,B2_LOCAL,B2_QATU,B1_UM"
	cQry += "  FROM "+RetSqlName("SB2")+ " B2"
	cQry += "  LEFT JOIN "+RetSqlName("SB1")+" B1"
	cQry += "    ON B2_COD=B1_COD"
	cQry += " WHERE B2_FILIAL='"+xFilial("SB2")+"'"
	cQry += "   AND B1_FILIAL='"+xFilial("SB1")+"'"
	cQry += "   AND B1.D_E_L_E_T_=' '"
	cQry += "   AND B2.D_E_L_E_T_=' '"
	cQry += "   AND B2_COD BETWEEN '"+ oself:cProdutoIni +"' AND '"+ oself:cProdutoFim +"'"
    if !empty(oself:cLocal)
        cQry += "   AND B2_LOCAL='" + oself:cLocal + "'"
    endif
	cQry += " ORDER BY B2_COD,B2_LOCAL"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry),cAlias, .F., .T.)
	
    If ( cAlias )->( ! Eof() )

        While ( cAlias )->( ! Eof() )

            nAux++
            aAdd( aListCli , JsonObject():New() )
            aListCli[nAux]['B2_COD']      := ( cAlias )->B2_COD
            aListCli[nAux]['B1_DESC']     := EncodeUTF8(( cAlias )->B1_DESC,"cp1251")
            aListCli[nAux]['B1_UM']       := ( cAlias )->B1_UM
            aListCli[nAux]['B2_LOCAL']    := ( cAlias )->B2_LOCAL
            aListCli[nAux]['B2_QATU']     := ( cAlias )->B2_QATU

            ( cAlias )->( DBSkip() )
        
        End

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
