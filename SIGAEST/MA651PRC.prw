#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA651PRC  ºAutor  ³Microsiga           º Data ³  04/04/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida credito del cliente antes de transformar la OP      º±±
±±º          ³ prevista para firme.                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MA651PRC()

	local _aArea	:= getArea()
	local _lRet		:= .f.
	local _lRetCre	:= .f.
	local _lRetPrd	:= .f.
	local _cAlias	:= getNextAlias()
    local cQry		:= ""
    local _aNumPed	:= {}
    local _cNroPed	:= ""
    local _xMark	:= PARAMIXB[1]
    local _arecs	:= {}
          
	cQry := "SELECT C2_PEDIDO,C2_ITEMPV,C2_PRODUTO,R_E_C_N_O_ AS NREC "
	cQry += "  FROM "+RetSqlName("SC2")
	cQry += " WHERE C2_FILIAL='"+xFilial("SC2")+"'"
	cQry += "   AND C2_TPOP='P'"
	cQry += "   AND C2_OK='"+_xMark+"'"
	cQry += "   AND D_E_L_E_T_=' '"
	
	cQry := ChangeQuery(cQry)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),_cAlias,.T.,.T.)

	dbSelectArea(_cAlias)
	if (_cAlias)->( !Eof() )
	
		SC9->( dbSetOrder(1) )
	
		Do While (_cAlias)->( !Eof() )
		
			aadd( _arecs, (_cAlias)->NREC )
		
			if SC9->( dbSeek( xFilial("SC9")+(_cAlias)->C2_PEDIDO+(_cAlias)->C2_ITEMPV+"01"+(_cAlias)->C2_PRODUTO ) )
			
				if alltrim(SC9->C9_BLCRED)<>"" .And. alltrim(SC9->C9_BLCRED)<>"10"
					if Ascan( _aNumPed, SC9->C9_PEDIDO ) <= 0
						Aadd( _aNumPed, SC9->C9_PEDIDO )
					endif
				endif
			
			endif
		
			(_cAlias)->( dbSkip() )
			
		EndDo
	endif

	(_cAlias)->( dbclosearea() )
	
	if len(_aNumPed) > 0
	
		for nX := 1 to len(_aNumPed)
			_cNroPed += _aNumPed[nX]+","
		next nX
		
		_cNroPed := substr(_cNroPed,1,len(_cNroPed)-1 )
		
		if len(_cNroPed)>6
			Alert("Los pedidos "+alltrim(_cNroPed)+" no fueron liberados por credito, informe a la tesoreria!")
		else
			Alert("El pedido "+alltrim(_cNroPed)+" no fue liberado por credito, informe a la tesoreria!")
		endif
	
	else
	
		if len(_arecs) > 0
			for vX := 1 to len(_arecs)
				SC2->( dbgoto( _arecs[vX] ) )
				SC2->( RecLock("SC2",.f.) )
				SC2->C2_YDTFIRM := dDataBase
				SC2->C2_YHRFIRM := time()
				SC2->( MsUnLock() )
			next vX
		endif
		
		_lRet := .t.
		
	endif
	
	//_lRetPrd := .t.
	
	RestArea( _aArea )
	
	/*
	if _lRetCre .and. _lRetPrd
		_lRet := .t.
	endif
	*/

Return( _lRet )