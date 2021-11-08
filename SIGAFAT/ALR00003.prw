#INCLUDE "PROTHEUS.ch"
#INCLUDE "ALRICL01.ch"

/*/{Protheus.doc} ALR00003
Função de cadastro de parâmetros
@author Sergio
@since 30/04/2016
@version undefined
@param nlOpc, numeric, opcao a ser executada
@param uParam, undefined, parametros para a a opcao a ser executada
@type function
/*/
User Function ALR00003( nlOpc, uParam )

	local uRet
	
	default nlOpc = 0
	default uParam = Nil

	do Case
	
		case nlOpc == 0
			uRet := getCadastro()
			
		case nlOpc == 1
			uRet := vldCodVar()
			
		case nlOpc == 2
			uRet := getDelCad()
	
	endCase

Return uRet

/*/{Protheus.doc} getCadastro
Função de cadastro de parâmetros
@author Sergio
@since 30/04/2016
@version undefined

@type function
/*/
Static Function getCadastro()

	local clAlias	:= "ZZB"
	private cCadastro 	:= "Parametros"
	private aRotina := {	{ STR0019,"AxPesqui",0,1} ,; // "Pesquisar"
							{ STR0010,"AxVisual",0,2} ,; // "Visualizar"
	             		 	{ STR0020,"AxInclui",0,3} ,; // "Incluir"
	             		 	{ STR0021,"AxAltera",0,4} ,; // "Alterar"	             		 	
 	             		 	{ STR0022,"U_ALR00003(2)",0,5} }  // "Excluir"

 	chkFile( clAlias )
	dbSelectArea( clAlias )
	dbSetOrder(1)
	dbGoTop()
	
	mBrowse( 6, 1, 22, 75, clAlias)

Return

/*/{Protheus.doc} vldCodVar
Funcao de validacao de preenchimento do codigo da variavel
@author Sergio
@since 15/05/2016
@version undefined

@type function
/*/
Static Function vldCodVar()

	local llRet		:= .T.
	local clVar		:= AllTrim( &( readVar() ) )
	local clPrefix	:= "V_"
	local nlTamPref	:= len( clPrefix )
	
	if !( len( clVar ) < nlTamPref .or. clPrefix == subs(clVar,1,nlTamPref) )
		llRet := .F.
		Alert(STR0052 + clPrefix) // "O prefixo da variável deve ser "
	endif
	
	if ( llRet .and. existParam( M->ZZB_GRUPO, clVar, INCLUI ) )
		llRet := .F.
		Alert(STR0060) // "Variavel já cadastrada. Escolha outro nome!"
	endif

Return llRet

/*/{Protheus.doc} existParam
Função responsavel por checar se a variavel digitada pelo usuario ja existe dentro da familia.
Nao pode acontecer pois estas variaveis sao criadas como private para poderem ser utilizadas nas formulas, entao deve ser
unicas para uma nao sobrepor a outra
@author Sergio
@since 21/05/2016
@version undefined
@param clCodGrp, characters, descricao
@param clParam, characters, descricao
@param llInclusao, logical, descricao
@type function
/*/
Static Function existParam( clCodGrp, clParam, llInclusao )

	local clCodFam	:= getFamilia( clCodGrp )
	local clAlias	:= getNextAlias()
	local clCondAlt	:= "%" + iif(llInclusao,"0 = 0","ZZB.R_E_C_N_O_ <> " + allTrim( str( ZZB->( recno() ) ) ) + "") + "%" // Condicao quando alteracao de cadastro
	local llRet		:= .F.
	
	BEGINSQL ALIAS clAlias
	
		SELECT
			DISTINCT
			ZZA_GRUPO
			, ZZA_DESCRI
		
		FROM 
			%TABLE:ZZA% ZZA
		
		INNER JOIN
			%TABLE:ZZB% ZZB ON
			ZZB_FILIAL = %XFILIAL:ZZB%
			AND ZZB.%NOTDEL%
			AND ZZB_GRUPO = ZZA_GRUPO
		
		WHERE
			ZZA_FILIAL = %XFILIAL:ZZA%
			AND ZZA.%NOTDEL%
			AND ZZA_FAMILI = %EXP:clCodFam%
			AND ZZB_PARAM = %EXP:clParam%
			AND %EXP:clCondAlt%
		
	ENDSQL
	
	if ( .not. ( clAlias )->( eof() ) )
		llRet := .T.
	endif
	( clAlias )->( dbCloseArea() )

Return llRet

/*/{Protheus.doc} getFamilia
Função responsavel por identificar a familia do grupo em questao
@author Sergio
@since 21/05/2016
@version undefined
@param clCodGrp, characters, descricao
@type function
/*/
Static Function getFamilia( clCodGrp )

	local clAlias	:= getNextAlias()
	local clCodFam	:= ""
	
	default clCodGrp := ""

	BEGINSQL ALIAS clAlias
	
		SELECT
			DISTINCT 
			ZZD_CODIGO
			, ZZD_DESCRI
		
		FROM 
			%TABLE:ZZB% ZZB
		
		INNER JOIN
			%TABLE:ZZA% ZZA ON
			ZZA_FILIAL = %XFILIAL:ZZA%
			AND ZZA.%NOTDEL%
			AND ZZA_GRUPO = ZZB_GRUPO
		
		INNER JOIN
			%TABLE:ZZD% ZZD ON
			ZZD_FILIAL = %XFILIAL:ZZD%
			AND ZZD.%NOTDEL%
			AND ZZD_CODIGO = ZZA_FAMILI
		
		WHERE
			ZZB_FILIAL = %XFILIAL:ZZB%
			AND ZZB.%NOTDEL%
			AND ZZB_GRUPO = %EXP:clCodGrp%
		
	ENDSQL
	
	if ( .not. ( clAlias )->( eof() ) )
		clCodFam := ( clAlias )->ZZD_CODIGO
	endif
	( clAlias )->( dbCloseArea() )
		
Return clCodFam

/*/{Protheus.doc} getDelCad
Função para validar a exclusão do registro posicionado
@author Sergio
@since 27/05/2016
@version undefined

@type function
/*/
Static Function getDelCad()

	dbSelectArea("ZZC")
	ZZC->( dbSetOrder( 1 ) )
	if ( ZZC->( dbSeek( xFilial("ZZC") + ZZB->ZZB_GRUPO + ZZB->ZZB_PARAM ) ) )
		Alert(STR0077) // "Não é possível excluir parâmetros que estejam sendo utilizados pelo cadastro de opções de parâmetros!"
	elseif (  U_isRegCfg( 2, ZZB->ZZB_PARAM ) )
		Alert(STR0080) // "Não é possível excluir parâmetros que estejam sendo utilizados em configuração que já gerou estrutura de produtos!"
	else
		axDeleta("ZZB", ZZB->( recno() ), 5)
	endif

Return