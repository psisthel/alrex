#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M462NFLT  ºAutor  ³Percy Arias,SISTHEL º Data ³  08/25/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE para poder hacer filtro de las guias de remision por    º±±
±±º          ³ usuario                                                    º±±
±±º          ³ Condiciones acceptadas: 000 y 002                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M462NFLT

	local _xQry		:= ""
	local _cPerg	:= PADR("XFILTRAGR",10)
	local _cSql		:= ""
	local _clAlias	:= getNextAlias()
	local _cPedidos := ""
	local _xNomUser := ""
	local cCondPag	:= getNewPar("AL_FILCRD","000|002")		// CONTRAENTREGA
	local aPswDet	:= {}

	if Pergunte(_cPerg,.t.)

		PswOrder(1)
		If PswSeek( MV_PAR01, .T. )  
			aPswDet := PswRet()
		EndIf
		
		If Len(aPswDet) > 0
			_xNomUser := Lower(aPswDet[1][2])
		EndIf
		
		//if MV_PAR02==3		// todos
		
			if !empty(MV_PAR01)
				_xQry := " LOWER(C5_LOGINCL)='"+_xNomUser+"' AND " 
			endif
			
			_xQry += " ( C5_YLIBCRD=' ' AND C5_CONDPAG NOT IN ('"+cCondPag+"')
			_xQry += "  OR C5_YLIBCRD='X' AND C5_CONDPAG IN ('"+cCondPag+"') )"

		
		/*
		
		else
		
			_cSql := "SELECT C2_PEDIDO,SUM(C2_QUANT) PEDIDOS,SUM(C2_QUJE ) ENTREGUES"
			_cSql += "  FROM "+RetSqlName("SC2")
			_cSql += " WHERE C2_FILIAL='"+xFilial("SC2")+"'"
			if MV_PAR02==1		// totales
				_cSql += "   AND C2_QUANT=C2_QUJE"
			elseif MV_PAR02==2	// parciales
				_cSql += "   AND C2_QUANT<>C2_QUJE"
			endif
			_cSql += "   AND D_E_L_E_T_=''"
			_cSql += " GROUP BY C2_PEDIDO"
			_cSql += " ORDER BY C2_PEDIDO DESC"
			
			dbUseArea(.T., "TOPCONN", TCGenQry(,,_cSql),_clAlias, .F., .T.)
			
			if (_clAlias)->( !eof() )
				_cPedidos := "('"
				while (_clAlias)->( !eof() )
					_cPedidos += (_clAlias)->C2_PEDIDO + "','"
					(_clAlias)->( dbSkip() )
				end
				_cPedidos := substr(_cPedidos,1,len(_cPedidos)-2)+")"
			endif
			(_clAlias)->( dbCloseArea() )
			
			if !empty(_cPedidos)
				_xQry := "C5_NUM IN "+ _cPedidos
				_xQry += " AND LOWER(C5_LOGINCL)='"+_xNomUser+"'" 
			else
				_xQry := " LOWER(C5_LOGINCL)='"+_xNomUser+"'" 
			endif

			_xQry += " AND ( C5_YLIBCRD=' ' AND C5_CONDPAG NOT IN ('"+cCondPag+"')
			_xQry += "  OR C5_YLIBCRD='X' AND C5_CONDPAG IN ('"+cCondPag+"') )"
		
		endif
		*/
		
	endif
	
	//conout(_xQry)
	
Return( _xQry )