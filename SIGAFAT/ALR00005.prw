#INCLUDE "PROTHEUS.CH"
#INCLUDE "ALRICL01.CH"

/*/{Protheus.doc} ALR00005
Função de cadastro de Familia de Productos
@author Sergio
@since 30/04/2016
@version undefined
@param nlOpc, numeric, opcao a ser executada
@param uParam, undefined, parametros para a a opcao a ser executada
@type function
/*/
User Function ALR00005( nlOpc, uParam )

	local uRet
	
	default nlOpc = 0
	default uParam = Nil

	do Case
	
		case nlOpc == 0
			getCadastro()
			
		case nlOpc == 1
			getDelCad()
			
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

	local clAlias	:= "ZZD"
	private cCadastro 	:= "Familia de Productos"
	private aRotina := {	{ STR0019,"AxPesqui",0,1} ,; // "Pesquisar"
							{ STR0010,"AxVisual",0,2} ,; // "Visualizar"
	             		 	{ STR0020,"AxInclui",0,3} ,; // "Incluir"
	             		 	{ STR0021,"AxAltera",0,4} ,; // "Alterar"	             		 	
 	             		 	{ STR0022,"U_ALR00005(1)",0,5} }  // "Excluir"

 	chkFile( clAlias )
	dbSelectArea( clAlias )
	dbSetOrder(1)
	dbGoTop()
	
	mBrowse( 6, 1, 22, 75, clAlias)

Return

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
	if ( ZZA->( dbSeek( xFilial("ZZA") + ZZD->ZZD_CODIGO ) ) )
		Alert(STR0078) // "Não é possível excluir Familia que esteja sendo utilizada pelo cadastro de grupo parâmetros!"
	elseif (  U_isRegCfg( 3, ZZD->ZZD_CODIGO ) )
		Alert(STR0081) // "Não é possível excluir Familia que esteja sendo utilizada em configuração que já gerou estrutura de produtos!"
	else
		axDeleta("ZZD", ZZD->( recno() ), 5)
	endif

Return