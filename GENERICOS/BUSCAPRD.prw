#Include "Rwmake.ch"
#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BUSCAPRD  ºAutor  ³Percy Arias,SISTHEL º Data ³  08/29/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca relacion del producto x proveedor para carga masiva  º±±
±±º          ³ de productos para importacion y compras nacionales.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FINDPRD(cProdFor,cProvee)

	local _darea := getArea()
	local _cProd := Space(TAMSX3("C7_PRODUTO")[1])
	local _cQry  := ""
	local _cAlias := getNextAlias()
	
	cProdFor := Padr(Alltrim(cProdFor),TAMSX3("A5_CODPRF")[1])
	
	_cQry := "SELECT TOP 1 A5_PRODUTO "
	_cQry += "  FROM " + RetSqlName("SA5")
	_cQry += " WHERE A5_FILIAL='"+xFilial("SA5")+"'"
	_cQry += "   AND A5_CODPRF='"+cProdFor+"'"
	if !empty(cProvee)
		_cQry += " AND A5_FORNECE='"+cProvee+"'"
	endif
	_cQry += "   AND D_E_L_E_T_=''"
	_cQry += "   AND R_E_C_N_O_ > 0"
	
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,_cQry),_cAlias, .F., .T.)
	 
	if (_cAlias)->( !Eof() )
		_cProd := (_cAlias)->A5_PRODUTO
	endif
	
	(_cAlias)->( dbCloseArea() )
	
	If empty(_cProd)
	
		cProdFor := Padr(Alltrim(cProdFor),TAMSX3("A5_PRODUTO")[1])

		_cQry := "SELECT TOP 1 A5_PRODUTO "
		_cQry += "  FROM " + RetSqlName("SA5")
		_cQry += " WHERE A5_FILIAL='"+xFilial("SA5")+"'"
		_cQry += "   AND A5_PRODUTO='"+cProdFor+"'"
		if !empty(cProvee)
			_cQry += " AND A5_FORNECE='"+cProvee+"'"
		endif
		_cQry += "   AND D_E_L_E_T_=''"
		_cQry += "   AND R_E_C_N_O_ > 0"
		
		DbUseArea(.T.,"TOPCONN", TCGENQRY(,,_cQry),_cAlias, .F., .T.)
		 
		if (_cAlias)->( !Eof() )
			_cProd := (_cAlias)->A5_PRODUTO
		endif
		
		(_cAlias)->( dbCloseArea() )
			
	EndIf
	
	restArea(_darea)

Return( _cProd )