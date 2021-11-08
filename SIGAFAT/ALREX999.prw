#INCLUDE "PROTHEUS.CH"

User Function ALREX999( _cVar,_cParam,_codGrp )

	Local _aArea := getArea()
	Local _lRet := .t.
	Local cQuery := ""
	Local _cAlias01 := getNextAlias()
	
	If !empty(_cVar)
		
		cQuery := "SELECT COUNT(*) NCONT FROM " + InitSQLName("ZZC")
		cQuery += " WHERE ZZC_FILIAL = '" + xFilial('ZZC') + "'"
		cQuery += "   AND ZZC_GRUPO='"+_codGrp+"'"
		cQuery += "   AND ZZC_PARAM='"+_cParam+"'"
		cQuery += "   AND ZZC_OPCION='"+_cVar+"'"
		cQuery += "   AND D_E_L_E_T_ <> '*'"
	
		dbUseArea( .T., "TOPCONN", tcGenQry(,,cQuery), _cAlias01 )
		
		If (_cAlias01)->NCONT <= 0
			_lRet := .f.
		EndIf
		
		(_cAlias01)->( dbCloseArea() )
	
	endif
	
	RestArea( _aArea )
	
	if !_lRet
		Alert("Información digita no encontrada para este parametros y/o componente.!")
	endif

Return( _lRet )