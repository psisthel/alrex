#INCLUDE "PROTHEUS.CH"
#INCLUDE "ALRICL01.CH"

/*/{Protheus.doc} ALR00004
Função de cadastro de Opcoes de Parametros
@author Sergio
@since 30/04/2016
@version undefined
@param nlOpc, numeric, opcao a ser executada
@param uParam, undefined, parametros para a a opcao a ser executada
@type function
/*/
User Function ALR00004( nlOpc, uParam )

	local uRet
	
	default nlOpc = 0
	default uParam = Nil

	do Case
	
		case nlOpc == 0
			uRet := getCadastro()
			
		case nlOpc == 1
			uRet := trigger01()
			
		case nlOpc == 2
			uRet := vldOpcao()
	
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

	local clAlias	:= "ZZC"
	private cCadastro 	:= STR0014 // "Grupo de Parametros"
	private aRotina := {	{ STR0019,"AxPesqui",0,1} ,; // "Pesquisar"
							{ STR0010,"AxVisual",0,2} ,; // "Visualizar"
	             		 	{ STR0020,"AxInclui",0,3} ,; // "Incluir"
	             		 	{ STR0021,"AxAltera",0,4} ,; // "Alterar"	             		 	
 	             		 	{ STR0022,"AxDeleta",0,5} }  // "Excluir"

 	chkFile( clAlias )
	dbSelectArea( clAlias )
	dbSetOrder(1)
	dbGoTop()
	
	mBrowse( 6, 1, 22, 75, clAlias)

Return

/*/{Protheus.doc} trigger01
Rotina para tratar gatilho de preenchimento de grupo e descricao de grupo
@author Sergio
@since 03/05/2016
@version undefined

@type function
/*/
Static Function trigger01()

	local alArea	:= getArea()
	local clReadVar	:= readVar()
	local llRet		:= .T.

	if ( AllTrim(clReadVar) == "M->ZZC_PARAM" )
		dbSelectArea("ZZB")
		
		if ( .Not. ZZB->( eof() ) .And. ZZB->ZZB_PARAM == &(clReadVar) )
			M->ZZC_GRUPO	:= ZZB->ZZB_GRUPO
			M->ZZC_DESCGR	:= ZZB->ZZB_DESCRI
		else
			ZZB->( dbSetOrder( 2 ) )
			if ( msSeek( xFilial("ZZC") + &(clReadVar) ) )
				M->ZZC_GRUPO	:= ZZB->ZZB_GRUPO
				M->ZZC_DESCGR	:= ZZB->ZZB_DESCRI
			else
				llRet := .F.
				Alert(STR0066) // "Parâmetro inválido!"
			endif
		endif
	
	endif
	
	restArea( alArea )
	
Return llRet

/*/{Protheus.doc} vldOpcao
Função de validacao do campo opção (ZZC_OPCION) do cadastro de opções de parametro
@author Sergio
@since 21/05/2016
@version undefined

@type function
/*/
Static Function vldOpcao()

	local alArea	:= getArea()
	local llRet		:= .T.
	local clVar		:= AllTrim( &( readVar() ) )
	local nlTamInfo	:= len( AllTrim( clVar ) )
	local nlTamEstr
	
	//--------------------------------------------------------------------------------------------------------------
	//- Valida se o conteudo da opcao esta coerente com a estrutura do parametro definida no cadastro de parametro -
	//--------------------------------------------------------------------------------------------------------------
	dbSelectArea("ZZB")
	ZZB->( dbSetOrder( 1 ) )
	if ( ZZB->( dbSeek( xFilial("ZZB") + M->ZZC_GRUPO + M->ZZC_PARAM ) ) )
	
		nlTamEstr := ZZB->ZZB_INTEIR + iif( ZZB->ZZB_TIPO == "N", ZZB->ZZB_DECIMA + 1, 0 )
		
		if ( nlTamInfo > nlTamEstr )
			llRet := .F.
			Alert(	STR0061 + CRLF + CRLF +; // "Conteúdo inválido!"
					STR0062 + M->ZZC_PARAM + CRLF +; // "Foi definido a seguinte estrutura para o parametro "
					STR0063 + U_getDCBOX("ZZB_TIPO", ZZB->ZZB_TIPO) + CRLF +; // "Tipo = "
					STR0064 + AllTrim( Str( ZZB->ZZB_INTEIR ) ) + CRLF +; // "Inteiro = "
					STR0065 + AllTrim( Str( ZZB->ZZB_DECIMA ) ) ) // "Decimal = "
		endif
		
	else
		Alert(STR0066) // "Parâmetro inválido!"
	endif
	
	restArea( alArea )
	
Return llRet