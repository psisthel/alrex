/*/{Protheus.doc} getDesCBOX
Funcao para buscar a descricao de campo do tipo combobox
@author Sergio
@since 18/02/2016
@version undefined
@param clField, characters, Campo a ser pesquisado
@param clTpPrdEq, characters, Conteudo que representa a chave de busca da descricao
@type function
/*/ 
User Function getDCBOX( clField, clChoice )

	Local clDesc	:= ""
	Local alOptions	:= separa( allTrim( getSX3Cache(clField, "X3_CBOX" ) ), ";" )
	Local nlx
	
	for nlx := 1 to len( alOptions )
	
		if ( allTrim( clChoice ) == subs( allTrim( alOptions[nlx] ), 1,  at("=",alOptions[nlx])-1 ) )
			clDesc	:= subs(alOptions[nlx], at("=",alOptions[nlx])+1, len(allTrim(alOptions[nlx])))
			exit
		endif
	
	next nlx

Return clDesc

/*/{Protheus.doc} isRegCfg
Funcao para identificar se determinado codigo foi utilizado em alguma configuração de produto no sistema
@author Sergio
@since 28/05/2016
@version undefined
@param nlOpc, numeric, descricao
@param clCod, characters, descricao
@type function
/*/
User Function isRegCfg( nlOpc, clCod )

	local alArea	:= getArea()
	local clAlias	:= getNextAlias()
	local clCondic
	local llRet		:= .F.
	
	do Case
	
		case nlOpc == 1 // GRUPO DE PARAMETROS
			clCondic := "% ZZA_GRUPO = '" + clCod + "' %"
			
		case nlOpc == 2 // PARAMETROS
			clCondic := "% ZZB_PARAM = '" + clCod + "' %"
			
		case nlOpc == 3 // FAMILIA
			clCondic := "% ZZD_CODIGO = '" + clCod + "' %"
	
	end Case
	
	BEGINSQL ALIAS clAlias
	
		SELECT
			COUNT( ZZG_IDCFG ) QTD
			
		FROM
			%TABLE:ZZG% ZZG
		
		INNER JOIN
			%TABLE:ZZA% ZZA ON
			ZZA_FILIAL = %XFILIAL:ZZA%
			AND ZZA.%NOTDEL%
			AND ZZA_GRUPO = ZZG_GRUPO
		
		INNER JOIN
			%TABLE:ZZD% ZZD ON
			ZZD_FILIAL = %XFILIAL:ZZD%
			AND ZZD.%NOTDEL%
			AND ZZD_CODIGO = ZZA_FAMILI
		
		INNER JOIN
			%TABLE:ZZB% ZZB ON
			ZZB_FILIAL = %XFILIAL:ZZB%
			AND ZZB.%NOTDEL%
			AND ZZB_PARAM = ZZG_PARAM
		
		WHERE
			ZZG_FILIAL = %XFILIAL:ZZG%
			AND ZZG.%NOTDEL%
			AND %EXP:clCondic%
			
	ENDSQL
	
	if ( .not. ( clAlias )->( eof() ) .and. ( clAlias )->QTD > 0 )
		llRet := .T.
	endif
	 ( clAlias )->( dbCloseArea() )
	 
	 restArea( alArea )

Return llRet