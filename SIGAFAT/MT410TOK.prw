/*/{Protheus.doc} MT410TOK
Este ponto de entrada � executado ao clicar no bot�o OK e pode ser usado para validar a confirma��o das opera��es: incluir,  alterar, 
copiar e excluir.Se o ponto de entrada retorna o conte�do .T., o sistema continua a opera��o, caso contr�rio, volta para a tela do pedido.
@author Sergio
@since 13/05/2016
@version undefined

@type function
/*/
User Function MT410TOK()
	
	local llRet		:= .T.			// Conteudo de retorno
	local nlOpc		:= PARAMIXB[1]	// Opcao de manutencao
//	Local alRecTiAdt	:= PARAMIXB[2]	// Array com registros de adiantamentoc
	local nPosPrd	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO" })
	local cCodPrd	:= space(tamSX3("C6_PRODUTO")[1])
	local nX, nY
	local nCont		:= 0
	local nPosDelet	:= Len( aHeader ) + 1

	if nlOpc==3 .Or. nlOpc==4

		for nX := 1 to len(aCols)
		    
			If !aCols[nX][nPosDelet]
		
				cCodPrd := aCols[nX][nPosPrd]
				nCont := 0
				
				if Left(cCodPrd,3)=="ALR"
				
					for nY := 1 to len(aCols)
					
						If !aCols[nY][nPosDelet]
							if cCodPrd == aCols[nY][nPosPrd]
								nCont++
							endif
						endif
						
					next nY
					
					if nCont>1
						exit
					endif
				
				endif
				
			endif
				
		next nX
	
		//--------------------------------------------------------------------------------
		//- Veririca��o de estrutura de produtos nos itens do pedido e em caso positivo, - 
		//- inclui ordem de produ��o prevista.                                           -
		//--------------------------------------------------------------------------------
		if nCont <= 1
			llRet := U_ALR00001(2, nlOpc)
		else
			llRet := .f.
			Alert("�Existen items duplicados en su pedido, por favor verifique!")
		endif
		
	else
		llRet := U_ALR00001(2, nlOpc)
	endif
	
Return llRet