#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GERALOTE  ºAutor  ³Percy Arias,SISTHEL º Data ³  05/09/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Genera el Lote Interno automaticamente bajo el siguiente   º±±
±±º          ³ formato: AAMMXX999, disparado por el campo producto        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ALREX                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GeraLote()

	local _aArea	:= getArea()
	local _cProv	:= Criavar("C1_FORNECE")
	local _dEmissao	:= Criavar("C1_EMISSAO")
	local _cCodProd	:= Criavar("D3_COD")
	local _cRet		:= ""
	local xAno		:= Criavar("ZZY_ANO")
	local xMes		:= Criavar("ZZY_MES")
	local xID		:= Criavar("ZZY_IDPROV")
	local xCorrel	:= Criavar("ZZY_CORREL")
	local nPos		:= aScan(aHeader,{|x| AllTrim(x[2]) == "D3_YCLIFOR" })
	
	if alltrim(FunName())=="MATA242" .Or. alltrim(FunName())=="MATA143"

		if alltrim(FunName())=="MATA143"
			_cProv		:= M->F1_FORNECE
			_dEmissao	:= M->F1_EMISSAO
			_cCodProd	:= M->D1_COD
		else
			_cProv		:= _jFornece
			_dEmissao	:= dEmis260
			_cCodProd	:= M->D3_COD
		endif
		
		SB1->( dbSetOrder(1) )
		if SB1->( dbSeek( xFilial("SB1")+ _cCodProd ) )
		
			if SB1->B1_RASTRO=="L"
	
				ZZY->( dbSetOrder(1) )
				if ZZY->( dbSeek( xFilial("ZZY")+_cProv ) )
				
					xAno	:= Alltrim(ZZY->ZZY_ANO)
					xMes	:= Alltrim(ZZY->ZZY_MES)
					xID		:= Alltrim(ZZY->ZZY_IDPROV)
					xCorrel	:= Alltrim(ZZY->ZZY_CORREL)
	
					if month(dDatabase)<>val(xMes)
						xCorrel := "1"
						//xMes := strzero(val(xMes) + 1,2)
						xMes := strzero(month(dDatabase),2)
						if val(xMes)>12
							xMes := "01"
							xAno := strzero(val(xAno) + 1,4)
						else
							if year(dDatabase)>val(xAno)
								xAno := strzero(val(xAno) + 1,4)
								xCorrel	:= "1"
							endif
						endif
					else
						if year(dDatabase)>val(xAno)
							xMes := "01"
							xAno := strzero(val(xAno) + 1,4)
							xCorrel	:= "1"
						endif
					endif
					
					_cRet := Right(xAno,2) + xMes + xID + strzero( val(xCorrel),tamSX3("ZZY_CORREL")[1] )
									
					xCorrel := strzero(val(xCorrel)+1,tamSX3("ZZY_CORREL")[1] )
			
					ZZY->( RecLock("ZZY",.f.) )
					ZZY->ZZY_ANO	:= xAno
					ZZY->ZZY_MES	:= xMes
					ZZY->ZZY_IDPROV	:= xID
					ZZY->ZZY_CORREL	:= xCorrel
					ZZY->( MsUnlock() )
			
				endif
				
				if alltrim(FunName())=="MATA242"
					aCols[n][nPos] := _cProv
					M->D3_YCLIFOR := _cProv
				endif
	    	
	    	endif
		
		endif
	
	endif
	
	RestArea( _aArea)

Return( _cRet )