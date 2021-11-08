#INCLUDE "PROTHEUS.CH"
#INCLUDE "ALRICL01.CH"

/*/{Protheus.doc} ALR00002
Fun��o de cadastro de grupo de par�metros
@author Sergio
@since 30/04/2016
@version undefined
@param nlOpc, numeric, opcao a ser executada
@param uParam, undefined, parametros para a a opcao a ser executada
@type function
/*/
User Function ALR00002( nlOpc, uParam )

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
Fun��o de cadastro de grupo de parametros
@author Sergio
@since 30/04/2016
@version undefined

@type function
/*/
Static Function getCadastro()

	local clAlias	:= "ZZA"
	private cCadastro 	:= STR0014 // "Grupo de Parametros"
	private aRotina := {	{ STR0019,"AxPesqui",0,1} ,; // "Pesquisar"
							{ STR0010,"AxVisual",0,2} ,; // "Visualizar"
	             		 	{ STR0020,"AxInclui",0,3} ,; // "Incluir"
	             		 	{ STR0021,"AxAltera",0,4} ,; // "Alterar"	             		 	
 	             		 	{ STR0022,"U_ALR00002(1)",0,5} }  // "Excluir"

 	chkFile( clAlias )
	dbSelectArea( clAlias )
	dbSetOrder(1)
	dbGoTop()
	
	mBrowse( 6, 1, 22, 75, clAlias)

Return

/*/{Protheus.doc} getDelCad
Fun��o para validar a exclus�o do registro posicionado
@author Sergio
@since 27/05/2016
@version undefined

@type function
/*/
Static Function getDelCad()

	dbSelectArea("ZZB")
	ZZB->( dbSetOrder( 1 ) )
	if ( ZZB->( dbSeek( xFilial("ZZB") + ZZA->ZZA_GRUPO ) ) )
		Alert(STR0076) // "N�o � poss�vel excluir grupo de par�metros que esteja sendo utilizado por cadastro de par�metros!"
	elseif (  U_isRegCfg( 1, ZZA->ZZA_GRUPO ) )
		Alert(STR0079) // "N�o � poss�vel excluir grupo de par�metros que esteja sendo utilizado em configura��o que j� gerou estrutura de produtos!"
	else
		axDeleta("ZZA", ZZA->( recno() ), 5)
	endif

Return