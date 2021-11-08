#include "TOTVS.CH"
#Include "RWMAKE.CH"
#Include "RESTFUL.CH"
#INCLUDE "Topconn.ch"

WSRESTFUL STHFAT06 DESCRIPTION "Parametros de Pedidos de Ventas" FORMAT APPLICATION_JSON
    WSDATA cPedido          AS STRING   OPTIONAL
    WSDATA cItem            AS STRING   OPTIONAL

    WSMETHOD GET pvparams DESCRIPTION 'FAT06 Parametros de Ped. Ventas' WSSYNTAX '/api/v1/sthfat06' PATH '/api/v1/sthfat06' PRODUCES APPLICATION_JSON
END WSRESTFUL

WSMETHOD GET pvparams WSRECEIVE cPedido, cItem WSREST STHFAT06
    Local lRet:= .T.
    lRet := pvparams( self )
Return( lRet )

Static Function pvparams( oSelf )

    Local aListCli  := {}
    Local cJsonCli  := ''
    Local oJsonCli  := JsonObject():New()
    Local cAlias    := GetNextAlias()
    Local nAux      := 0

    Default oself:cPedido  := ''
    Default oself:cItem  := ''

	SC5->( dbSetOrder(1) )
	SC6->( dbSetOrder(1) )

	cQry := "SELECT C6_XPARAMS,C6_XPARAM2"+CRLF
	cQry += "  FROM "+RetSqlName("SC6")+" C6"+CRLF
	cQry += " WHERE C6_FILIAL='"+xFilial("SC6")+"'"+CRLF
	cQry += "   AND C6.D_E_L_E_T_=''"+CRLF
	cQry += "   AND C6_NUM = '"+ oself:cPedido +"'"+CRLF
    cQry += "   AND C6_ITEM = '"+ oself:cItem +"'"+CRLF

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry),cAlias, .F., .T.)
	
    If ( cAlias )->( ! Eof() )

        aParams1 := StrTokArr(( cAlias )->C6_XPARAMS,";")
        aParams2 := StrTokArr(( cAlias )->C6_XPARAM2,";")
        cParams := ""

        for nX := 1 to len(aParams1)
            cParams += alltrim(substr(aParams1[nX],5,len(aParams1[nX]))) + "\n"
        next nX

        for nX := 1 to len(aParams2)
            cParams += alltrim(substr(aParams2[nX],5,len(aParams2[nX]))) + "\n"
        next nX

        nAux++
        aAdd( aListCli , JsonObject():New() )
        aListCli[nAux]['PARAMS'] := EncodeUTF8(cParams,"cp1251")

    Endif

    ( cAlias )->( DBCloseArea() )

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
