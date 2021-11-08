#INCLUDE "PROTHEUS.CH"
#INCLUDE "ALRICL01.CH"

/*/{Protheus.doc} ALR00005
Função de cadastro de Familia x Componente
@author Sergio
@since 21/05/2016
@version undefined
@param nlOpc, numeric, opcao a ser executada
@param uParam, undefined, parametros para a a opcao a ser executada
@type function
/*/
User Function ALR00006( nlOpc, uParam )

	local uRet
	
	default nlOpc = 0
	default uParam = Nil

	do Case
	
		case nlOpc == 0
			uRet := getCadastro()
			
		case nlOpc == 1
			uRet := vldComp()
			
		case nlOpc == 2
			getDelCad()
			
	endCase

Return uRet

/*/{Protheus.doc} getCadastro
Função de cadastro de parâmetros
@author Sergio
@since 21/05/2016
@version undefined

@type function
/*/
Static Function getCadastro()

	local clAlias	:= "ZZE"
	private cCadastro 	:= STR0067 // "Familia x Componente"
	private aRotina := {	{ STR0019,"AxPesqui",0,1} ,; // "Pesquisar"
							{ STR0010,"AxVisual",0,2} ,; // "Visualizar"
	             		 	{ STR0020,"AxInclui",0,3} ,; // "Incluir"
	             		 	{ STR0021,"AxAltera",0,4} ,; // "Alterar"	             		 	
 	             		 	{ STR0022,"U_ALR00006(2)",0,5} }  // "Excluir"

 	chkFile( clAlias )
	dbSelectArea( clAlias )
	dbSetOrder(1)
	dbGoTop()
	
	mBrowse( 6, 1, 22, 75, clAlias)

Return

/*/{Protheus.doc} vldComp
~Função de validações do campo de componentes (ZZE_COMP)
@author Sergio
@since 21/05/2016
@version undefined

@type function
/*/
Static Function vldComp()

	local alArea	:= getArea()
	local llRet		:= .T.
	
	dbSelectArea("ZZE")
	ZZE->( dbSetOrder( 1 ) )
	if ( ZZE->( dbSeek( xFilial("ZZE") + M->ZZE_FAMILI + M->ZZE_COMP ) ) )
		llRet := .F.
		Alert( STR0068 + M->ZZE_DESCFA ) // "Componente já cadastrado para a família "
	endif
	
	restArea( alArea )

Return llRet

/*/{Protheus.doc} getDelCad
Função para validar a exclusão do registro posicionado
@author Sergio
@since 27/05/2016
@version undefined

@type function
/*/
Static Function getDelCad()

	dbSelectArea("ZZA")
	ZZA->( dbSetOrder( 3 ) )
	if ( ZZA->( dbSeek( xFilial("ZZA") + ZZE->ZZE_FAMILI ) ) )
		Alert(STR0078) // "Não é possível excluir Familia que esteja sendo utilizada pelo cadastro de grupo parâmetros!"
	elseif (  U_isRegCfg( 3, ZZE->ZZE_FAMILI ) )
		Alert(STR0081) // "Não é possível excluir Familia que esteja sendo utilizada em configuração que já gerou estrutura de produtos!"
	else
		axDeleta("ZZE", ZZE->( recno() ), 5)
	endif

Return