#INCLUDE "PROTHEUS.CH"
#INCLUDE "ALRICL01.CH"

/*/{Protheus.doc} ALR00001
Rotina de controle de vendas
@author Sergio
@since 13/04/2016
@version undefined
@param nlOpc, numeric, opcao a ser executada
@type function
/*/
User Function ALR00001( nlOpc, uParam )

	local uRet
	private _lModifPedido := .f.
	
	default nlOpc = 0
	default uParam = Nil

	do Case
	
		case nlOpc == 0
			uRet := addBtnOnPV( uParam )
			
		case nlOpc == 1
		
			SetKey(VK_F5, )
			
			If INCLUI
				uRet := callDlgPrd( uParam )
			else
				if SC5->C5_YSTATUS=='9' .Or. SC5->C5_YSTATUS=='7'
					alert("Pedido no puede ser modificado, anule el apunte de produccion y retorne a esta rutina!")
				else
					uRet := callDlgPrd( uParam )
				endif
			endif
			
			SetKey(VK_F5,{|| U_ALR00001(1) } )
			
		case nlOpc == 2
			msgRun("Generando orden de producción prevista...", "Procesando...",{|| uRet := createSC2(uParam) }) // "Gerando ordem de produção prevista..." "Processando..."
			if ( uRet )
				SetKey(VK_F5, )
			endif
			
		case nlOpc == 3
			uRet := getPrcUnit( uParam ) 
			
		case nlOpc == 4
			uRet := getPrcTot( uParam )
			
		case nlOpc == 5
			uRet := getSXBdin( uParam )
		case nlOpc == 6
			uRet := setPedVen( uParam )
	
	endCase  
	
Return uRet

/*/{Protheus.doc} addBtnOnPV
Função de controle de botões a ser adicionado no ações relacionadas da manutenção de pedido de venda
@author Sergio
@since 13/04/2016
@version undefined
@type function
/*/
Static Function addBtnOnPV( alButtons )
	AADD(alButtons , {"AUTOM" ,{|| U_ALR00001(1) },STR0001, STR0001 + " (F5)"} ) // Vendas
	SetKey(VK_F5,{|| U_ALR00001(1) } )
Return

/*/{Protheus.doc} callDlgPrd
Controle da interface de vendas
@author Sergio
@since 15/04/2016
@version undefined

@type function
/*/
Static Function callDlgPrd()

	local alArea		:= getArea()
	local oSZVEnch	
	local xOpc			:= 0
	local cTitOdlg		:= "Configuración del Producto"	//STR0002 // "Configuração de Produto"
	local nRec1			:= ZZF->( RECNO() )
	local nOpc			:= 3
	local olGroup
	local oPanel
	local oSplitter2
	local oBtn1
	local oBtn2
	local oBtn3
	local oBtn4
	local aPosE1
	local olSay1
	local olSay2	
	local olGet2
	local bWhenCodFam	:= {|| .T. }
	local llWritePrms	:= .F.
	local nlPosItm		:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_ITEM" })
	
	private opGetFam
	private oDlg  
	private oFld
	private nList
	private aSize    	:= MsAdvSize()
	private aObjects 	:= {}
	//private aInfo    	:= {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
	private aInfo    	:= {0,0,aSize[3],aSize[4],3,3}
	private aPosObj  	:= {}
	private aPosGet  	:= {}
	private aGets	 	:= {}
	private bOk			:= {|| iif(vldParams(), iif(showEstru(.T.),( xOpc := 1, oDlg:End() ), Nil ), Nil ) }
	private bCancel 	:= {|| xOpc := 0, oDlg:End() }
	private aBotoes		:= {}
	private cpCodFam
	private cpFamAnt	:= space( tamSX3("ZZD_CODIGO")[1] )
	private cpDesFAnt	:= space( tamSX3("ZZD_DESCRI")[1] )
	private cpDesFam
	private cpLote
	private apVariables	:= {} // Armazena variaveis que podem ser alteradas pelo usuario
	private apComps		:= {} // Armazena os componentes amarrado a familia (Produtos SB1 filtrado por Materia Prima MP)
	private cpCodPrPai	:= getPrdPos()
	private cpIdConfig
	private apDados		:= {}
	
	clearCab()
	if ( .not. empty( cpCodPrPai ) )
	
		_lModifPedido := .t.
	
		if ( isEstrToPV( cpCodPrPai ) )
			llWritePrms := .T.
			bWhenCodFam	:= {|| .F. }
			cpIdConfig	:= ZZF->ZZF_IDCFG
			cpCodFam	:= ZZF->ZZF_FAMILI
			cpDesFam	:= AllTrim( posicione("ZZD",1,xFilial("ZZD")+cpCodFam,"ZZD_DESCRI") )
		else
			Alert("El producto posicionado puede ser utilizado en el pedido de venta pero no puede ser modificada su configuracion devido a que fue generado por otro pedido de venta!")
			Return
		endif
	
	endif
	
	AADD( aObjects, { 100, 40, .T., .F. } )
	AADD( aObjects, { 100, 100, .T., .T. } )
	AADD( aObjects, { 100, 10, .T., .F. } )
	
	aPosObj := MsObjSize(aInfo,aObjects)	
	
	criaSxb()
	
	oDlg := TDialog():New(aSize[7],0,((aSize[6]/100)*98),((aSize[5]/100)*99),cTitOdlg,,,,,,,,oMainWnd,.T.)
	
		oDlg:lEscClose := .F. // Nao permite sair ao se pressionar a tecla ESC.

		dbSelectArea("ZZF")
			
		olGroup		:= TGroup():New(aPosObj[1,1], aPosObj[1,2], aPosObj[1,3], (((aPosObj[1,4]-aPosObj[1,1])/100)*99)," Datos Iniciales "/*STR0003*/,oDlg,,,.T.) // " Dados Iniciais "
		
		olSay1		:= TSay():New( aPosObj[1,1]+10,aPosObj[1,2]+5,{|| STR0004 },oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008) // "Familia"
		opGetFam      := TGet():New( aPosObj[1,1]+20,aPosObj[1,2]+5, {|u| if( Pcount() > 0, cpCodFam := u, cpCodFam) },oDlg,048,008,'@!',{|| trigger(1) },CLR_BLACK,CLR_WHITE,,,,.T.,"",,bWhenCodFam,.F.,.F.,,.F.,.F.,"ZZD","",,)
		
		olSay2		:= TSay():New( aPosObj[1,1]+10,aPosObj[1,2]+65,{|| "Descripción" /*STR0005*/ },oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,008) // "Descrição"
		olGet2      := TGet():New( aPosObj[1,1]+20,aPosObj[1,2]+65,{|u| if( Pcount() > 0, cpDesFam := u, cpDesFam) },oDlg,200,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|| .F. },.F.,.F.,,.F.,.F.,"","",,)
		
		initFolder()
								
		//oPanel := TPanel():New(aPosObj[3,1],aPosObj[3,2],'',oDlg,, .T., .T.,, ,(aPosObj[3,4]-10),012,.F.,.F. )
		oPanel := TPanel():New(aPosObj[3,1]-20,aPosObj[3,2],'',oDlg,, .T., .T.,, ,(aPosObj[3,4]-10),012,.F.,.F. )
		
		if ( llWritePrms )
			dbSelectArea("ZZF")
			ZZF->( dbSetOrder( 3 ) )
			if ( dbSeek( xFilial("ZZF") + M->C5_NUM + cpCodPrPai ) )
				trigger(1)
				createVars( cpIdConfig, .T. )
				refreshAll()
				
			endif
		endif 
		
		oBtn3		:= TButton():New( 002, 002, "Cancelar" /*STR0011*/,oPanel,bCancel, 55,10,,,.F.,.T.,.F.,,.F.,,,.F. ) // "Cancelar"
		oBtn3:Align	:= CONTROL_ALIGN_RIGHT
		
		oSplitter2 	:= TSplitter():New( 01,01,oPanel,005,01 )
		oSplitter2:Align	:= CONTROL_ALIGN_RIGHT
		
		oBtn4		:= TButton():New( 002, 002, "Confirmar" /*STR0012*/,oPanel,bOk, 55,10,,,.F.,.T.,.F.,,.F.,,,.F. ) // "Confirmar"
		oBtn4:Align	:= CONTROL_ALIGN_RIGHT

		oSplitter3 	:= TSplitter():New( 01,01,oPanel,005,01 )
		oSplitter3:Align	:= CONTROL_ALIGN_LEFT

		if nlPosItm > 0
			olSay3	:= TSay():New( 002,002,{|| "Editando Item: " + aCols[n][nlPosItm] },oPanel,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
		endif
									
	oDlg:Activate()
	
	if ( xOpc == 1 )
	
		__lRetAl := .t.

		// -------------------------------------------------------------------- //
		// PE para tratamento de validaciones extras para el personal de Alrex  //
		// -------------------------------------------------------------------- //
		If ExistBlock("XLR0098")
			__lRetAl := ExecBlock("XLR0098",.F.,.F.)
		EndIf
		
		If __lRetAl
			execSteps( _lModifPedido ) // envia parametro para identificar se o pedido de venda vai ser alterado.
		EndIf

	endif
	
	restArea( alArea )
	
Return

/*/{Protheus.doc} isEstrToPV
Função responsavel por identificar se o codigo de produto pai foi gerado pelo pedido de venda corrente
@author Sergio
@since 17/05/2016
@version undefined
@param clCodPrd, characters, descricao
@type function
/*/
Static Function isEstrToPV( clCodPrd )
	
	local llRet := .F.
	
	dbSelectArea("ZZF")
	ZZF->( dbSetOrder( 3 ) )
	llRet := ZZF->( dbSeek( xFilial("ZZF") + M->C5_NUM + PADR(clCodPrd, tamSX3("ZZF_CODPAI")[1] ) ) )
	
Return llRet

/*/{Protheus.doc} trigger
Funcao auxiliar para gerenciamento de validações e trigger dos campos da interface
@author Sergio
@since 14/05/2016
@version undefined
@param nlOpc, numeric, descricao
@type function
/*/
Static Function trigger( nlOpc )

	local uRet

	do Case
	
		Case nlOpc == 1
			uRet := checkFam()
			
	end Case

Return uRet

/*/{Protheus.doc} checkFam
Processamento que deve ser executado no evento de preenchimento do codigo da familia
@author Sergio
@since 14/05/2016
@version undefined

@type function
/*/
Static Function checkFam()

	local llRet	:= .T.

	if ( empty( cpCodFam ) .or. .not. ( cpFamAnt == cpCodFam ) )
	
		llRet := getDescFun("ZZD", 1, xFilial("ZZD")+cpCodFam, "ZZD_DESCRI", @cpDesFam)
		
		if ( llRet )
			cpFamAnt := cpCodFam
			cpDesFAnt := cpDesFam
			msgRun(STR0071, STR0072,{|| llRet := refreshVnd(cpCodFam) }) //  "Atualizando interface..." "Aguarde..."
		else
			cpCodFam	:= cpFamAnt
			cpDesFam	:= cpDesFAnt
			refreshAll() 
		endif

	endif
		
Return llRet

/*/{Protheus.doc} clearDlg
Função responsavel por limpar dados da interface
@author Sergio
@since 12/05/2016
@version undefined

@type function
/*/
Static Function clearDlg()

	clearCab()
	refreshVnd()

Return

/*/{Protheus.doc} clearCab
Função responsavel por limpar variaveis do cabeçalho
@author Sergio
@since 12/05/2016
@version undefined

@type function
/*/
Static Function clearCab()

	if ( empty( cpCodFam ) )
		cpCodFam	:= Space( tamSX3("ZZD_CODIGO")[1] )
		cpDesFam	:= Space( tamSX3("ZZD_DESCRI")[1] )
	endif
	cpDesPrd	:= Space( tamSX3("B1_DESC")[1] )
	cpLote		:= Space( tamSX3("B8_LOTECTL")[1] )
	
Return

/*/{Protheus.doc} execSteps
Funcao de execução da formula de preço e etapas para inclusao de estrutura de produtos e item no pedido de venda
@author Sergio
@since 10/05/2016
@version undefined

@type function
/*/
Static Function execSteps( _lAltPedido )

	local llProcess	:= .F.
	local alArea	:= getArea()
		
	private lpInclusao	:= .T.
	default _lAltPedido := .f.	//se o pedido de venda nao e alterado
	
	begin transaction
	
		msgRun(STR0074, STR0024,{|| addPrdConf() }) //  "Criando configuração..." "Processando..."
	
		if ( empty( cpCodPrPai ) )
			msgRun(STR0025, STR0024,{|| llProcess := createSB1() }) //  "Criando produto pai da estrutura..." "Processando..."
		else
			msgRun(STR0026,STR0024,{|| llProcess := incCodPai() }) // "Processando registros de configurações do produto..." "Processando..."
			lpInclusao := .F.
			if _lAltPedido	// adicionado em 24/09
				msgRun(STR0028,STR0024,{|| llProcess := altPrdToPv()() }) // "Altera o item no pedido de venda..." "Processando..."
			endif
		endif
	
		if ( llProcess )
			msgRun("Generando estructura de productos...","Procesando...",{|| llProcess := createSG1() }) // "Gerando estrutura de produtos..." "Processando..."
		endif

		if ( llProcess .and. lpInclusao)
			msgRun("Adicionado item al pedido de venta...","Procesando...",{|| llProcess := addPrdToPv()() }) // "Adicionado o item no pedido de venda..." "Processando..."
		endif
	
	end transaction
		
	restArea( alArea )
	
Return

/*/{Protheus.doc} incCodPai
Função responsavel por alimentar o codigo pai nos registros de caracteristicas da estrutura de produtos do item do pedido de venda
@author Sergio
@since 13/05/2016
@version undefined

@type function
/*/
Static Function incCodPai()

	local llRet	:= .T.
	local clUpd	:= ""
	
	clUpd += "UPDATE " + retSQLName("ZZF") + " SET ZZF_CODPAI = '" + cpCodPrPai + "' "
	clUpd += "WHERE ZZF_FILIAL = '" + xFilial("ZZF") + "' "
	clUpd += "AND D_E_L_E_T_ = ' ' "
	clUpd += "AND ZZF_CODPED = '" + M->C5_NUM + "' "
	clUpd += "AND ( ZZF_CODPAI = ' ' OR ZZF_CODPAI IS NULL ) "
	
	if ( tcSQLExec( clUpd ) ) < 0
		llRet := .F.
		Alert( STR0030 + tcSQLError() ) // "Falha de integridade de dados: "
	endif

Return llRet

/*/{Protheus.doc} setPedVen
Responsavel por atualizar o codigo do pedido nas tabelas de configuracao
@author Sergio Artero
@since 04/10/2018
@version 1.0
@type function
/*/
Static Function setPedVen( alIdsCfg )

	local clUpd		:= ""
	local clIDsIn	:= ""
	
	default alIdsCfg	:= {}
	
	if ( len( alIdsCfg ) > 0 )
	
		aEval( alIdsCfg, {|x| clIDsIn += allTrim( x ) + "/" } )
		clIDsIn := subs( clIDsIn, 1, len( clIDsIn ) - 1 )
		clIDsIn := formatIn( clIDsIn, "/" )
		
		clUpd += "UPDATE " + retSQLName("ZZF") + " SET ZZF_CODPED = '" + M->C5_NUM + "' "
		clUpd += "WHERE ZZF_FILIAL = '" + xFilial("ZZF") + "' "
		clUpd += "AND D_E_L_E_T_ = ' ' "
		clUpd += "AND ZZF_IDCFG IN " + clIDsIn
		
		if ( tcSQLExec( clUpd ) ) < 0
			Alert( STR0030 + tcSQLError() ) // "Falha de integridade de dados: "
		endif
		
	endif

Return
/*/{Protheus.doc} getPrdPos
Função responsavel por identificar o codigo do produto pai posicionado no item do pedido de venda
@author Sergio
@since 13/05/2016
@version undefined

@type function
/*/
Static Function getPrdPos()

	local clCodPrd	:= ""
	local nlPosPrd	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO" })

	if ( nlPosPrd > 0 .and. N > 0 .and. type("aCols") == "A" .and. len( aCols ) > 0 .and. .not. empty( aCols[N][nlPosPrd] ) .and. isPrdEstru( aCols[N][nlPosPrd] ) )
		clCodPrd := aCols[N][nlPosPrd]
	endif

Return clCodPrd

/*/{Protheus.doc} createSB1
Função responsável por gerar o produto pai da estrutura de produtos
@author Sergio
@since 13/05/2016
@version undefined

@type function
/*/
Static Function createSB1()

	local alVetor	:= {}
	local llProcess	:= .T.
	
	private lMsErroAuto := .F. 
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	MsSeek( xFilial("SB1")+cpCodFam )
	
	cpCodPrPai := getNewPPai()
		
	if ( .not. empty( cpCodPrPai ) )
	
		alVetor:= {	{"B1_COD"		,cpCodPrPai				,NIL},;                    
		 			{"B1_DESC"		,STR0031 + M->C5_NUM	,NIL},; // "PRODUTO ACABADO - "                     
		 			{"B1_TIPO"		,SB1->B1_TIPO			,Nil},;                   
		 			{"B1_UM"		,SB1->B1_UM				,Nil},;                   
		 			{"B1_LOCPAD"	,SB1->B1_LOCPAD			,Nil},;                  
		 			{"B1_PICM"		,0						,Nil},;                   
		 			{"B1_IPI"		,0						,Nil},;                   
		 			{"B1_CONTRAT"	,"N"					,Nil},;
		 			{"B1_YCODALR"	,AllTrim( posicione("ZZD",1,xFilial("ZZD")+cpCodFam,"ZZD_CODALR") )	,Nil},;
		 			{"B1_TS"		,SB1->B1_TS				,Nil},;
		 			{"B1_GRUPO"		,SB1->B1_GRUPO			,Nil},;
		 			{"B1_YDESLAR"	,SB1->B1_YDESLAR		,Nil},;
		 			{"B1_GARANT"	,SB1->B1_GARANT			,Nil},;
		 			{"B1_CONTA"		,SB1->B1_CONTA			,Nil},;
		 			{"B1_YCTADD"	,SB1->B1_YCTADD			,Nil},;
		 			{"B1_YCTADC"	,SB1->B1_YCTADC			,Nil},;
		 			{"B1_YCTAVTA"	,SB1->B1_YCTAVTA		,Nil},;
		 			{"B1_XCTABON"	,SB1->B1_XCTABON		,Nil},;
		 			{"B1_LOCALIZ"	,SB1->B1_LOCALIZ		,Nil}}				 
		 			
		MSExecAuto({|x,y| Mata010(x,y)}, alVetor, 3) 
	
		if lMsErroAuto
			llProcess := .F.
			MostraErro()
			disarmTransaction()
		else
			if ( !incCodPai() )
				llProcess := .F.
				disarmTransaction()
			else
				llProcess := .T.
			endif
		endif
		
	else
		llProcess := .F.
		Alert(STR0032) // "Falha na criação do produto pai para estrutura de produtos"
	endif
	
Return llProcess

/*/{Protheus.doc} getNewPPai
Função responsavel por gerar o código do produto pai para estrutura de produtos
@author Sergio
@since 13/05/2016
@version undefined

@type function
/*/
Static Function getNewPPai()

	local clPrefix	:= AllTrim( getMv("ES_PREFPRD",,"ALR") )
	local clTypeSGBD:= AllTrim( tcGetDB() )
	local nlTamPref	:= len( clPrefix )
	local clSQL		:= ""
	local clSintxSub
	local clAlias	:= getNextAlias()
	local clNewCode	:= clPrefix + strZero(1, ( tamSX3("B1_COD")[1] - nlTamPref ) )
	
	if (  clTypeSGBD == "ORACLE" )
		clSintxSub := "SUBSTR"
	else
		clSintxSub := "SUBSTRING"
	endif
	
	clSQL += "SELECT " 
	clSQL += "		MAX(B1_COD) CODE " 
	clSQL += "	FROM "
	clSQL += "		" + retSQLName("SB1") + " SB1 "
	clSQL += "	WHERE "
	clSQL += "		B1_FILIAL = '" + xFilial("SB1") + "' "
//	clSQL += "		AND SB1.D_E_L_E_T_ = ' ' " // NAO CONSIDERA DELETADO PARA EVITAR ERRO DE CHAVE DUPLICADA NO BANCO DE DADOS
	clSQL += "		AND " + clSintxSub + "(B1_COD,1," + AllTrim( Str( nlTamPref ) ) + ") = '" + clPrefix + "' "
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,clSQL),clAlias, .F., .T.)
	
	if ( .not. ( clAlias )->( eof() ) .and. .not. empty( ( clAlias )->CODE ) )
		clNewCode := soma1( ( clAlias )->CODE )
	endif
	 ( clAlias )->( dbCloseArea() )

Return clNewCode

/*/{Protheus.doc} createSG1
Função de gravação de dados na SG1
@author Sergio
@since 15/04/2016
@version undefined

@type function
/*/
Static Function createSG1()

	local alCab		:= {}
	local alItns	:= {}
	local alItem
	local nI
	local llProcess	:= .T.
	local nlTamTRT	:= TamSX3("G1_TRT")[1]
	local nlQtd
	local clCondic
	local clFormul
	local clAlias	:= getNextAlias()
	local __lTemG1	:= .f.
	local cQry		:= ""
	local clAlias01	:= getNextAlias()
	
	private lMsErroAuto	:= .F.
	
	dbSelectArea("SB1")
	SB1->( dbSetOrder( 1 ) )
	
	dbSelectArea("SG1")
	SG1->( dbSetOrder( 1 ) ) // G1_FILIAL, G1_COD, G1_COMP, G1_TRT, R_E_C_N_O_, D_E_L_E_T_
	
	dbSelectArea("ZZE")
	ZZE->( dbSetOrder( 1 ) )
	if ( ZZE->( dbSeek( xFIlial("ZZE") + cpCodFam ) ) )
	
		alCab := {	{"G1_COD"		, cpCodPrPai	,NIL},;
					{"G1_QUANT"		, 1				,NIL},;					
					{"NIVALT"		, "N"			,NIL}}
	
		/*				
		cQry := "SELECT *,ISNULL(CONVERT(VARCHAR(1024),CONVERT(VARBINARY(1024),[ZZE].[ZZE_FORMUL])),'') AS XMEMO"
		cQry += "  FROM " + RetSqlName("ZZE") + " ZZE"
		cQry += " WHERE ZZE.ZZE_FILIAL = '"+xFilial("ZZE")+"'"
		cQry += "   AND ZZE.ZZE_FAMILI = '"+cpCodFam+"'"
		cQry += "   AND ZZE.D_E_L_E_T_ = ' '"
		cQry += "   AND ISNULL(CONVERT(VARCHAR(1024),CONVERT(VARBINARY(1024),[ZZE].[ZZE_FORMUL])),'')<>' '"
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry),clAlias01, .F., .T.)
	   
		while	.not. (clAlias01)->( eof() )
		*/

		while	.not. ZZE->( eof() );
				.and. ZZE->ZZE_FILIAL == xFIlial("ZZE");
				.and. ZZE->ZZE_FAMILI == cpCodFam
				
			//---------------------------------------
			//- Buscando a quantidade do componente -
			//---------------------------------------
			nlQtd := 0
				
			clCondic := AllTrim( ZZE->ZZE_CONDIC )
			clFormul := AllTrim( strTran(strTran(ZZE->ZZE_FORMUL,CHR(13),""),CHR(10),"") )
			//clFormul := AllTrim( strTran(strTran((clAlias01)->XMEMO,CHR(13),""),CHR(10),"") )
			
			If !Empty(clFormul)
				if ( .not. empty( clCondic ) .and. &( clCondic ) )
					nlQtd := &( clFormul )
				elseif ( .not. empty( clFormul ) )
					nlQtd := &( clFormul )
				//elseif ( ZZE->ZZE_QUANT > 0 )
				//	nlQtd := ZZE->ZZE_QUANT
				endif
			EndIf
			
			If ( ZZE->ZZE_QUANT > 0 )
				nlQtd := ZZE->ZZE_QUANT
			EndIf

			If nlQtd > 0
					
				alItem := {}
				AADD(alItem,	{"G1_COD"		, cpCodPrPai					,NIL})
				AADD(alItem,	{"G1_COMP"		, ZZE->ZZE_COMP					,NIL})
				AADD(alItem,	{"G1_XIDCFG"	, cpIdConfig					,NIL})
				AADD(alItem,	{"G1_TRT"		, space( nlTamTRT )				,NIL})
				AADD(alItem,	{"G1_QUANT"		, nlQtd							,NIL})
				AADD(alItem,	{"G1_PERDA"		, 0								,NIL})
				AADD(alItem,	{"G1_INI"		, CtoD("01/01/01")				,NIL})
				AADD(alItem,	{"G1_FIM"		, CtoD("31/12/49")				,NIL})
				AADD(alItns,alItem)
				
			EndIf
			
			ZZE->( dbSkip() )
		
		endDo
		
		//(clAlias01)->( dbCloseArea() )
	
	endif
	
	
	/*
	BEGINSQL ALIAS clAlias
	
		SELECT
			COUNT(*) QTD
			
		FROM
			%TABLE:SG1% SG1

		WHERE
			SG1.G1_FILIAL = %XFILIAL:SG1%
		AND SG1.%NOTDEL%
		AND SG1.G1_XIDCFG=%EXP:cpIdConfig%
			
	ENDSQL
	*/

	cQry := "SELECT COUNT(*) QTD "
	cQry += "  FROM " + retSQLName("SG1") + " SG1"
	cQry += " WHERE SG1.D_E_L_E_T_ = ' '"
	cQry += "   AND SG1.G1_FILIAL = '" + xFilial("SG1") + "'"
	cQry += "   AND SG1.G1_XIDCFG = '" + cpIdConfig + "'"
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry),clAlias, .F., .T.)
	
	if ( .not. ( clAlias )->( eof() ) .and. ( clAlias )->QTD > 0 )
		__lTemG1 := .T.
	endif
	
	( clAlias )->( dbCloseArea() )

    If __lTemG1

		BEGINSQL ALIAS clAlias
		
			SELECT
				SG1.R_E_C_N_O_ NREC
				
			FROM
				%TABLE:SG1% SG1
	
			WHERE
				SG1.G1_FILIAL = %XFILIAL:SG1%
			AND SG1.%NOTDEL%
			AND SG1.G1_XIDCFG=%EXP:cpIdConfig%
				
		ENDSQL
		
		if .not. ( clAlias )->( eof() ) 

			while .not. ( clAlias )->( eof() ) 

				SG1->( dbGoto( (clAlias)->NREC ) )
				SG1->( RecLock("SG1",.f.) )
				SG1->( dbDelete() )
				SG1->( MsUnlock() )
				
				( clAlias )->( dbSkip() )
				
			End
		
		endif
		
		( clAlias )->( dbCloseArea() )
	    
    EndIf
    
	if ( len( alItns ) > 0 )
		//MsExecAuto({|x,y,z| MATA200(x,y,z)},alCab,alItns,iif(lpInclusao, 3, 4))
		MsExecAuto({|x,y,z| MATA200(x,y,z)},alCab,alItns,3)
	endif
	
	if ( lMsErroAuto )
		llProcess := .F.
		mostraErro()
		disarmTransaction()
	else
		llProcess := .T.
	endif
	
Return llProcess

/*/{Protheus.doc} createSC2
Função responsável por gerar a ordem de produção prevista
@author Sergio
@since 13/05/2016
@version undefined

@type function
/*/
Static Function createSC2( nlOpc )

	local nlPProd	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO" })
	local nlItemPV	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_ITEM" })
	local nlPQtdLib	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDLIB" })
	local nlPQtd	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN" })
	local nlx
	local clCodPrd
	local llPrdEstru	:= .F.
	local llIncSC2		:= .F.
	local llProcOk		:= .T.
	local clCodSC2
	local alMata650
	local alMata651
	local nlQtdLib
	local nlQtd
	local llProcOk	:= .T.
	local llCanSC2	:= .T.
	local aInfPrd	:= {}
	local nlPcdFam	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_YCODF" })
	local _nRecSB1	:= 1
	
	private lMsErroAuto	:= .F.
	
	dbSelectArea("SC6")
	
	for nlx := 1 to len( aCols )
	
		clCodPrd	:= aCols[nlx][nlPProd]
		llPrdEstru	:= isPrdEstru( clCodPrd )
	
		if llPrdEstru
		
			dbSelectArea("SB1")
			dbSetOrder( 1 )
			if SB1->( dbSeek( xFilial("SB1") + clCodPrd ) )

				//--------------------------------------------//
				// Modificando el Local padrao do componente  //
				//--------------------------------------------//
				_nRecSB1 := SB1->( Recno() )
				dbSelectArea("SG1")
				dbSetOrder(1)
				if SG1->( dbSeek( xFilial("SG1")+clCodPrd ) )
					while SG1->G1_COD==clCodPrd .and. SG1->( !Eof() )
						If ZZE->( dbSeek( xFilial("ZZE")+aCols[nlx][nlPcdFam]+SG1->G1_COMP ) )
							If Alltrim(ZZE->ZZE_LOCAL)<>""
								if SB1->( dbSeek( xFilial("SB1") + SG1->G1_COMP ) )
									Aadd( aInfPrd, { SB1->B1_COD, SB1->B1_LOCPAD } )
									SB1->( RecLock("SB1",.f.) )
									SB1->B1_LOCPAD := ZZE->ZZE_LOCAL
									SB1->( MsUnlock() )
								endif
							EndIf
						EndIf
						SG1->( dbSkip() )
					end
				endif
				SB1->( dbgoto(_nRecSB1) )
				//--------------------------------------------//
				
				nlQtd		:= aCols[nlx][nlPQtd]
				nlQtdLib	:= aCols[nlx][nlPQtdLib]
		
				dbSelectArea("SC2")
				llIncSC2 := !existSC2(M->C5_NUM, aCols[nlx][nlItemPV], @clCodSC2)
				
				llCanSC2 := nlQtdLib > 0
				//llCanSC2 := nlQtd > 0
				
				if llIncSC2					
					
					if ( llCanSC2 )
						clCodSC2 	:= getNumSC2()
					endif
					
				else
				
					//------------------------------------------------------------
					//- Se alteracao ou exclusao, deve-se posicionar no registro -      
					//- da SC2 antes de executar a rotina automatica             -    
					//------------------------------------------------------------
					SC2->( dbSetOrder( 1 ) ) // FILIAL + NUM + ITEM + SEQUEN + ITEMGRD
					if ( SC2->( dbSeek(xFilial("SC2") + clCodSC2 + PADR("01", tamSX3("C2_ITEM")[1] ) + PADR("001", tamSX3("C2_SEQUEN")[1] ) ) ) )
					
						//-----------------------------------------------------------------------------------------------------------
						//- Se existir o item em ordem de produção prevista, deve ser checado se a quantidade liberada continua > 0 -
						//- Caso contrário, o item deve ser excluído.                                                               -
						//-----------------------------------------------------------------------------------------------------------
						if ( !llCanSC2 )
						
							//-------------------------------------------------
							//- Opção a ser executada pela rotina automática. -
							//- 1 = Pesquisar                                 -
							//- 4 = Firma OPs                                 -
							//- 5 = Exclui OPs                                -
							//-------------------------------------------------
							alMata651 := {	{"MV_PAR01", clCodPrd},;
											{"MV_PAR02", clCodPrd},;
											{"MV_PAR03", SC2->C2_NUM},;
											{"MV_PAR04", SC2->C2_NUM},;
											{"MV_PAR05", SC2->C2_DATPRI},;
											{"MV_PAR06", SC2->C2_DATPRF},;
											{"MV_PAR07", SC2->C2_DATPRI},;
											{"MV_PAR08", SC2->C2_DATPRF},;
											{"MV_PAR09", 2 }}
										
							msgRun(STR0033,,{|| MSExecAuto({|x,y| Mata651(x,y)},alMata651, 5) }) // "Excluindo OP prevista..."					
							
							if lMsErroAuto  
								llProcOk := .F.
								mostraErro()
								disarmTransaction()
							endif 
							
						endif
										
					endif
					
				endif
			
				if ( llCanSC2 )
					
					if ( !llIncSC2 )	// 4

						SC2->( dbSetOrder( 1 ) ) // FILIAL + NUM + ITEM + SEQUEN + ITEMGRD
						if SC2->( dbSeek( xFilial("SC2") + clCodSC2 + PADR("01", tamSX3("C2_ITEM")[1] ) + PADR("001", tamSX3("C2_SEQUEN")[1] ) ) )
							SC2->( RecLock("SC2",.f.) )
							SC2->( dbDelete() )
							SC2->( MsUnlock() )
							clCodSC2 := getNumSC2()
						endif
						
					endif
					
					alMata650  := {	{'C2_NUM'		, clCodSC2									, NIL},;
									{'C2_ITEM'		, "01"				         				, NIL},;
									{'C2_SEQUEN'	, "001"										, NIL},;
									{'C2_PRODUTO'	, SB1->B1_COD								, NIL},;
									{'C2_LOCAL'		, RetFldProd(SB1->B1_COD,"B1_LOCPAD")		, NIL},;
									{'C2_QUANT'		, aCols[nlx][nlPQtdLib]						, NIL},;
									{'C2_UM'		, SB1->B1_UM				   				, NIL},;
									{'C2_CC'		, SB1->B1_CC					  			, NIL},;
									{'C2_SEGUM'		, SB1->B1_SEGUM  				 			, NIL},;
									{'C2_DATPRI'	, dDataBase									, NIL},;
									{'C2_DATPRF'	, dDataBase									, NIL},;
									{'C2_REVISAO'	, SB1->B1_REVATU							, NIL},;
									{'C2_TPOP'		, "P"										, NIL},;
									{'C2_EMISSAO'	, dDataBase					   				, NIL},;
									{'C2_ROTEIRO'	, SB1->B1_OPERPAD							, NIL},;
									{'C2_OBS'		, "OP generada por pedido: " + M->C5_NUM	, NIL},; // "OP gerado a partir do pedido: "
									{'C2_PEDIDO'	,  M->C5_NUM								, NIL},;
									{'C2_ITEMPV'	,  aCols[nlx][nlItemPV]						, NIL},;
									{'AUTEXPLODE'	, "S"										, NIL}}
					
					//MsExecAuto({|x,y| mata650(x,y)}, alMata650, iif( llIncSC2, 3, 4) )
					MsExecAuto( { |x,y| mata650(x,y) }, alMata650, 3 )
					
					if lMsErroAuto  
						conout(dtoc(ddatabase)+" "+time()+" - Erro al incluir la OP, PV -> "+M->C5_NUM+" "+SB1->B1_COD)
						llProcOk := .F.
						mostraErro()
						disarmTransaction()
					endif
					
				endif
				
			endif
			
		endif
		
	next nlx
	
	if Len(aInfPrd) > 0

		//--------------------------------------------//
		// Modificando el Local padrao do componente  //
		//--------------------------------------------//
		for i:=1 to len(aInfPrd)
			If SB1->( dbSeek( xFilial("SB1")+aInfPrd[i][1] ) )
				SB1->( RecLock("SB1",.f.) )
				SB1->B1_LOCPAD := "A01"		//aInfPrd[i][2]
				SB1->( MsUnlock() )
			EndIf
		next
			
	endif
	
Return llProcOk

/*/{Protheus.doc} existSC2
Verifica se ja existe o item do pedido de venda na em alguma ordem de produção prevista
@author Sergio
@since 13/05/2016
@version undefined
@param clPedido, characters, descricao
@param clItemPv, characters, descricao
@param clCodSC2, characters, descricao
@type function
/*/
Static Function existSC2( clPedido, clItemPv, clCodSC2 )

	local clAlias	:= getNextAlias()
	local llRet		:= .F.

	BEGINSQL ALIAS clAlias
	
		SELECT 
			C2_NUM
		
		FROM 
			%TABLE:SC2% SC2
		
		WHERE
			C2_FILIAL = %XFILIAL:SC2%
			AND SC2.%NOTDEL%
			AND C2_TPOP = 'P'
			AND C2_PEDIDO = %EXP:clPedido%
			AND C2_ITEMPV = %EXP:clItemPv%
			
	ENDSQL
	
	if ( .not. ( clAlias )->( eof() ) )
		clCodSC2 := ( clAlias )->C2_NUM
		llRet := .T.
	endif
	( clAlias )->( dbCloseArea() )

Return llRet

/*/{Protheus.doc} isPrdEstru
Verifica se o produto enviado como parametro é codigo pai de uma estrutura de produtos
@author Sergio
@since 13/05/2016
@version undefined
@param clCodPrd, characters, descricao
@type function
/*/
Static Function isPrdEstru( clCodPrd )

	local alArea	:= getArea()
	local llRet		:= .F.
	local clPrefix	:= AllTrim( getMv("ES_PREFPRD",,"ALR") )
	
	if ( clPrefix $ clCodPrd )
	
		dbSelectArea("SG1")
		SG1->( dbSetOrder( 1 ) ) // G1_FILIAL, G1_COD, G1_COMP, G1_TRT, R_E_C_N_O_, D_E_L_E_T_
		llRet := SG1->( dbSeek( xFilial("SG1") + clCodPrd ) )
	
	endif
	
	restArea( alArea )

Return llRet
		
/*/{Protheus.doc} addPrdToPv
Função responsavel por adicional o produto pai no item do pedido de venda
@author Sergio
@since 13/05/2016
@version undefined

@type function
/*/
Static Function addPrdToPv()

	local aArea		:= getArea()
	local nW		:= 0
	local nX		:= 0
	local aColsGrd	:= {}
	local nZ        := len(aCols)
	local nUsado    := len(aHeader)
	local nPProd    := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO" })
	local nPQtdVen  := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN" })
	local nPPrcVen  := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRCVEN" })
	local nPValor   := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_VALOR" })
	local nPTES		:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_TES" })                
	local nPItem	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_ITEM" })
	local nlPosPar	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_XPARAMS" })
	local nlPosIdZZF:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_XIDZZF" })
	local nlPosMemo	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_YSTRUCT" })
	local nPosQtLib	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDLIB" })
	local cItem		:= aCols[nZ,nPItem]
	local clTextPar	:= ""
	local nlx
	local clGrp		:= ""
	local clTes		:= ""
	local alColsAux	:= {}
	local oDlgPdr	:= GetWndDefault()
	local nPosPrUni	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRUNIT" }) 
	local n2PosPar	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_XPARAM2" })

	//---------------------------------------------------------------------
	//- Tratamento para quando houver linhas sem preenchimento de produto -
	//---------------------------------------------------------------------
	for nX := 1 to nZ
		if ( .not. empty( aCols[nX][nPProd] ) )
			AADD(alColsAux, aClone(aCols[nX]) )
		endif
	next nX
	
	aCols := {}
	if ( len(alColsAux) > 0 )
		aCols := aClone( alColsAux )
	endif
	
	nZ := len(aCols)
	if ( nZ == 0 )
		cItem := "00"
	else
		cItem := aCols[nZ,nPItem]
	endif
	
	//-----------------------------------------------------
	//- Adicionando produtos nos itens do pedido de venda -
	//-----------------------------------------------------
	cItem := Soma1(cItem)
	AADD(aCols, Array( nUsado + 1 ) )
	
	nZ++
	N := nZ
	
	for nW := 1 to nUsado
		if (aHeader[nW,2] <> "C6_REC_WT") .And. (aHeader[nW,2] <> "C6_ALI_WT")
			aCols[nZ,nW] := CriaVar(aHeader[nW,2],.T.)
		endif	
	next nW

	//-------------------------
	//- Adicionando o produto -
	//-------------------------
	aCols[nZ,nUsado+1] := .F.
	aCols[nZ,nPItem  ] := cItem
	A410Produto(cpCodPrPai,.F.)
	A410MultT("M->C6_PRODUTO",cpCodPrPai)
	A410MultT("M->C6_QTDVEN",1) // TODO QUESTIONAR PERCY - QUANTIDADE DO PRODUTO DA ESTRUTURA DEVE SER INFORMADO NA INTERFACE DE VENDAS ?
	if ( .not. empty( clTes ) ) // EM REUNIAO COM PERCY EM 15/05/2016 FOI SOLICITADO AGUARDAR O PROCESSO DE ESTOQUE PARA DEFINIR COMO SERA AS QUANTIDADES
		A410MultT("M->C6_TES", clTes)
	endif
	aCols[nZ,nPProd  ] := cpCodPrPai
	
	//------------------------------------------------------------------------------
	//- Executando gatilho do campo de produto da grid de itens do pedido de venda -
	//------------------------------------------------------------------------------
	if ExistTrigger("C6_PRODUTO")
		RunTrigger(2, len( aCols ) )
	endif
	
	//---------------------------------------------------------------------------------
	//- Executando gatilho do campo de QUANTIDADE da grid de itens do pedido de venda -
	//---------------------------------------------------------------------------------
	aCols[nZ,nPQtdVen] := 0 // colocar UNO - QUANTIDADE DO PRODUTO DA ESTRUTURA DEVE SER INFORMADO NA INTERFACE DE VENDAS ?
	A410SegUm(.T.)			// EM 15/05/2016 FOI SOLICITADO AGUARDAR O PROCESSO DE ESTOQUE PARA DEFINIR COMO SERA AS QUANTIDADES
	if ExistTrigger("C6_QTDVEN ")
		RunTrigger(2,N,Nil,,"C6_QTDVEN ")
	endif
	
	aCols[nZ,nPPrcVen] := getPrcUnit( nZ )		
		
	if ( aCols[nZ,nPPrcVen] == 0 )
		aCols[nZ,nPPrcVen] := 1
		aCols[nZ,nPValor ] := aCols[nZ,nPQtdVen]
	else
		aCols[nZ,nPValor ] := A410Arred(aCols[nZ,nPQtdVen]*aCols[nZ,nPPrcVen],"C6_VALOR")
	endif
	
	// ----------------------------------------------------- //
	// Modificacion hecha para actualizar el precio de lista //
	// ----------------------------------------------------- //
	aCols[nZ,nPosPrUni ] := aCols[nZ,nPPrcVen]
	
	if ( .not. empty( clTes ) )						
	
		aCols[nZ,nPTES] := clTes
		
		//--------------------------------------------------------------------------
		//- Executando gatilho do campo de TES da grid de itens do pedido de venda -
		//--------------------------------------------------------------------------
		if ExistTrigger("C6_TES")
			RunTrigger(2, len( aCols ) )
		endif
		
	endif
	
	if ( nlPosPar > 0 .and. len( apVariables ) > 0 )
	
		clTextPar := ""
	
		//---------------------------------
		//- Ordena as variaveis por grupo -
		//---------------------------------
		//apVariables := aSort(apVariables,,, { |x,y| x[1] < y[1] } )
		apVariables := aSort(apVariables,,, { |x,y| x[12] < y[12] } )
	
		ZZA->( dbSetOrder(1) )
		
		for nlx := 1 to len( apVariables )
		
			cConteudo := (  &( apVariables[nlx][3] ) )

			If !Empty( cConteudo )
		
				/*
				if ( nlx == 1 )
					clGrp := apVariables[nlx][1]
				endif
				
				if ( clGrp # apVariables[nlx][1] )
					clGrp := apVariables[nlx][1]
					clTextPar += subs(clTextPar, 1, ( len(clTextPar)-1 ) )
					clTextPar += "|"
				endif
				*/
				/* 25-04-2018
				if ( clGrp # apVariables[nlx][1] )
					if !empty(clGrp)
						clTextPar += '|'
					endif
					ZZA->( Msseek( xFilial('ZZA')+apVariables[nlx][1]) )
					clGrp := apVariables[nlx][1]
					clTextPar += Upper(Alltrim(ZZA->ZZA_DESCRI))+':'		//+ CRLF
				endif
				*/
				
				if	(	( apVariables[nlx][4] == "N" .and. ( &( apVariables[nlx][3] ) ) > 0 ); 
						.or. ( apVariables[nlx][4] == "C" .and. .not. empty( apVariables[nlx][3] ) ); 
					)
					
					clTextPar += Strzero(apVariables[nlx][12],3)+"|"
					clTextPar += iif( apVariables[nlx][4] == "N",;
										 AllTrim( Upper(Alltrim(apVariables[nlx][9])) + '-' + Transform( &( apVariables[nlx][3] ), getPict(apVariables[nlx][5], apVariables[nlx][6]) ) ),;
										 AllTrim( Upper(Alltrim(apVariables[nlx][9])) + '-' + AllTrim( posicione("ZZC",2,xFilial("ZZC") + apVariables[nlx][1] + apVariables[nlx][2] + &(apVariables[nlx][3]), "ZZC_DESCOP" ) ) ) ) + ";" //+ CRLF	// 16/03/18 - SISTHEL - &( apVariables[nlx][3] ) ) ) + ";" + CRLF
				endif
				
			endif
				
		next nlx
	
		clTextPar := subs(clTextPar, 1, ( len(clTextPar)-1 ) )
		aCols[nZ,nlPosPar] := substr(clTextPar,1,250)
		aCols[nZ,n2PosPar] := substr(clTextPar,251,250)
		aCols[nZ,nlPosMemo] := clTextPar
		aCols[nZ,nPosQtLib] := 0	//aCols[nZ,nPQtdVen]

	endif
	
	SB1->( dbSetOrder(1) )
	if SB1->( dbseek( xFilial("SB1")+aCols[nZ,nPProd] ) )
		SB1->( RecLock("SB1",.f.) )
		SB1->B1_PRV1 := aCols[nZ,nPPrcVen]
		SB1->( MsUnlock() )
	endif

	//---------------------------------------------------------------------
	// Garante o vinculo do ID de configuracao com o item Pedido de venda -
	//---------------------------------------------------------------------
	//aCols[nZ][nlPosIdZZF] := 1 := cpIdConfig
	aCols[nZ][nlPosIdZZF] := cpIdConfig
	
	N := len( aCols )
	oGetDad:ForceRefresh()
	Ma410Rodap(oGetDad)
	oDlgPdr:refresh()
	
	restArea(aArea)
	
Return .T.

/*/{Protheus.doc} getPrcUnit
Função responsavel por recuperar o preço unitario do produto pai
@author Sergio
@since 13/05/2016
@version undefined

@type function
/*/
Static Function getPrcUnit( nlLinAtu )

	local alArea	:= getArea()
	local nlPosPrc	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRCVEN" })
	local nlPosPrd	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO" })	
	local nPQtdVen  := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN" })
	local nlPrcTot	:= 0
	local clAlias
	local clFormul
	local clVar
	local uConteu
	local llFirst	:= .T.
	local nlPrecio	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_YPRECIO" })
	local nlPPUnit	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRUNIT" })
	
	default nlLinAtu := N	
	
	if ( nlLinAtu > 0 .and. nlPosPrd > 0 .and. isPrdEstru( aCols[nlLinAtu][nlPosPrd] ) )
	
		//--------------------------------------------------------------------------------------------------
		//- Identifica a formula de calculo de preco a ser utilizada, conforme configuração do produto pai -
		//--------------------------------------------------------------------------------------------------
		dbSelectArea("ZZF")
		ZZF->( dbSetOrder( 3 ) )
		if ( dbSeek( xFilial("ZZF") + M->C5_NUM + aCols[N][nlPosPrd] ) )
		
			while	.not. ZZF->( eof() );
					.and. ZZF->ZZF_FILIAL == xFilial("ZZF");
					.and. ZZF->ZZF_CODPED == M->C5_NUM;
					.and. ZZF->ZZF_CODPAI == aCols[nlLinAtu][nlPosPrd]

				//---------------------------------------------------------------
				//- Criando variaveis para serem utilizadas no calculo de preço -
				//- conforme parametros configurados dos componentes            -
				//---------------------------------------------------------------
				createVars( ZZF->ZZF_IDCFG, !llFirst )
				llFirst := .F.
				
				dbSelectArea("ZZD")
				ZZD->( dbSetOrder( 1 ) )
				if ( msSeek( xFilial("ZZD") + ZZF->ZZF_FAMILI ) )
					clFormul := AllTrim( strTran(strTran(ZZD->ZZD_FORMUL,CHR(13),""),CHR(10),"") )
					nlPrcTot += &( clFormul )
				endif
				
				nlPrcTot := u_ALFAT001( ZZF->ZZF_FAMILI, ZZF->ZZF_IDCFG )				// adicionado en 28-05-2018 - sisthel - calculo de precios.
					
				ZZF->( dbSkip() )
			endDo 
		
		endif
		
		if ( nlPrcTot > 0 )
			aCols[nlLinAtu][nlPosPrc] := nlPrcTot
			aCols[nlLinAtu][nlPrecio] := nlPrcTot
			aCols[nlLinAtu][nlPPUnit] := nlPrcTot
		endif
				
	endif
	
	restArea( alArea )

Return nlPrcTot

/*/{Protheus.doc} createVars
Função responsavel por criar as variaveis para serem utilizadas em formulas
@author Sergio
@since 23/05/2016
@version undefined
@param clIdCfg, characters, descricao
@type function
/*/
Static Function createVars( clIdCfg, isVarExist )

	local clVar
	local uConteu
		
	default isVarExist := .F.

	dbSelectArea("ZZG")
	ZZG->( dbSetOrder( 1 ) )
	if ( dbSeek( xFilial("ZZG") + clIdCfg ) )
	
		//while ZZG->ZZG_FILIAL == xFilial("SG1") .and. ZZG->ZZG_IDCFG == clIdCfg
		while ZZG->ZZG_FILIAL == xFilial("ZZG") .and. ZZG->ZZG_IDCFG == clIdCfg
			
			dbSelectArea("ZZB")
			ZZB->( dbSetOrder( 1 ) )
			if ( dbSeek( xFilial("ZZB") + ZZG->ZZG_GRUPO + ZZG->ZZG_PARAM ) )
				clVar	:= AllTrim( ZZB->ZZB_PARAM )
				uConteu	:= getInfFmt( ZZB->ZZB_TIPO, ZZG->ZZG_CONTEU )
				
				if ( isVarExist )
					&( clVar ) := uConteu
				else				
					_SetNamedPrvt( clVar, uConteu, "U_ALR00001" )
				endif
				
			endif
			
			ZZG->( dbSkip() )
		endDo
		
	endif
	
	//---------------------------------------------------------------
	//- Criando variaveis para serem utilizadas no calculo de preço -
	//- conforme tabela ZV do cadastro de tabelas SX5               -
	//---------------------------------------------------------------
	createVSX5( isVarExist )
		
Return

/*/{Protheus.doc} createVSX5
Cria variaveis conforme tabela SX5 definida por parametro 
@author Sergio
@since 23/05/2016
@version undefined
@type function
/*/
Static Function createVSX5( isVarExist )

	local clTabSX5	:= AllTrim( getMv("ES_PRCTAB",,"ZV") )
	default isVarExist := .F.
	
	dbSelectArea("SX5")
	SX5->( dbSetOrder(1) )
	if SX5->( dbSeek( xFilial("SX5") + clTabSX5 ) )
	
		while	.not. SX5->( eof() );
				.and. SX5->X5_FILIAL == xFilial("SX5");
				.and. SX5->X5_TABELA == clTabSX5
			
			clVar	:= AllTrim( SX5->X5_CHAVE )
			
			#ifdef SPANISH
				uConteu	:= &( strTran( SX5->X5_DESCSPA,",",".") )
			#else			
				#ifdef ENGLISH
					uConteu	:= &( strTran( SX5->X5_DESCENG,",",".") )
				#else
					uConteu	:= &( strTran( SX5->X5_DESCRI,",",".") )
				#endif
			#endif
			
			if ( isVarExist )
				&( clVar ) := uConteu
			else				
				_SetNamedPrvt( clVar, uConteu, "U_ALR00001" )
			endif
			
			SX5->( dbSkip() )
		endDo
		
	endif
	
Return

/*/{Protheus.doc} getPrcTot
Função responsavel por recuperar o preço unitario do produto pai
@author Sergio
@since 14/05/2016
@version undefined

@type function
/*/
Static Function getPrcTot()

	local nlPosPrc	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRCVEN" })
	local nlPosTot	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_VALOR" })
	local nlPosQtd	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN" })	
	local nlPosPrd	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO" })	
	local nlPrcTot	:= iif( N > 0 .and. nlPosTot > 0, aCols[N][nlPosTot], 0)
	
	if ( N > 0 .and. nlPosPrd > 0 .and. isPrdEstru( aCols[N][nlPosPrd] ) )	
		nlPrcTot := A410Arred(aCols[N][nlPosPrc] * aCols[N][nlPosQtd],"C6_VALOR")
		aCols[N,nlPosTot] := nlPrcTot
	endif

Return nlPrcTot

/*/{Protheus.doc} showEstru
Função responsavel por mostrar a estrutura do item posicionado do pedido de venda
@author Sergio
@since 13/05/2016
@version undefined

@type function
/*/
Static Function showEstru( llFinish )

	local clTitulo	:= "Estructura de Productos"	//STR0035 // "Estrutura de Produtos"
	local olChkLst
	local olPanel
	local olSplitter1
	local olBtn1
	local olDlg
	local olFont	:= TFont():New('Courier new',,-34,.T.)
	local llRet		:= .F.
	local clTitleCab
	local nlPosTCab
	
	private aSize    	:= MsAdvSize()
	private aObjects 	:= {}
	//private aInfo    	:= {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
	private aInfo    	:= {0,0,aSize[3],aSize[4],3,3}
	private aPosObj  	:= {}
	
	default llFinish	:= .F.
	
	AADD( aObjects, { 100, 20, .T., .F. } )
	AADD( aObjects, { 100, 100, .T., .T. } )
	AADD( aObjects, { 100, 10, .T., .F. } )
	
	aPosObj := MsObjSize(aInfo,aObjects)	
	
	getDataEst()
	if ( len( apDados ) > 0 ) 
	
		olDlg := TDialog():New(aSize[7],0,((aSize[6]/100)*98),((aSize[5]/100)*99),clTitulo,,,,,,,,oMainWnd,.T.)
		
			if ( llFinish )
				clTitleCab := "Configuración de Productos. Confirmar ?"
				nlPosTCab := 50
			else
				clTitleCab := "Configuración de Productos" 
				nlPosTCab := 150
			endif
		
			TSay():New( aPosObj[1,1],aPosObj[1,2]+nlPosTCab,{|| clTitleCab },olDlg,,olFont,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,400,020)
			@ aPosObj[2,1], aPosObj[2,2] LISTBOX olChkLst FIELDS COLSIZES 100,100,100,100,100 HEADER  STR0004, STR0038, STR0039, "Descripción", STR0040, "Descripción" SIZE (aPosObj[2,4]-7), (aPosObj[2,3]-30) OF olDlg PIXEL // "Familia", "Grupo", "Parametro", "Conteudo"
			olChkLst:setArray( apDados )
			olChkLst:bLine	:= { || {apDados[olChkLst:nAt][1], apDados[olChkLst:nAt][2], apDados[olChkLst:nAt][3], apDados[olChkLst:nAt][4], apDados[olChkLst:nAt][5], apDados[olChkLst:nAt][6] } }
			
			//olPanel := TPanel():New(aPosObj[3,1],aPosObj[3,2],'',olDlg,, .T., .T.,, ,(aPosObj[3,4]-10),012,.F.,.F. )
			olPanel := TPanel():New(aPosObj[3,1]-7,aPosObj[3,2],'',olDlg,, .T., .T.,, ,(aPosObj[3,4]-10),012,.F.,.F. )
			
			if ( llFinish )
				olBtn1		 := TButton():New( 002, 002, STR0041, olPanel,{|| llRet := .T., olDlg:End() }, 55,10,,,.F.,.T.,.F.,,.F.,,,.F. ) // "Ok"
				olBtn1:Align := CONTROL_ALIGN_LEFT
				
				olSplitter1 	:= TSplitter():New( 01,01,olPanel,005,01 )
				olSplitter1:Align	:= CONTROL_ALIGN_LEFT
				
				oBtn2		:= TButton():New( 002, 002, STR0042,olPanel,{|| llRet := .F., olDlg:End() }, 55,10,,,.F.,.T.,.F.,,.F.,,,.F. ) // "Retornar"
				oBtn2:Align	:= CONTROL_ALIGN_LEFT
			else
				olBtn1		 := TButton():New( 002, 002, STR0043, olPanel,{|| llRet := .T., olDlg:End() }, 55,10,,,.F.,.T.,.F.,,.F.,,,.F. ) // "Fechar"
				olBtn1:Align := CONTROL_ALIGN_LEFT
			endif
		
		olDlg:Activate() 
		
		if ( llFinish )
		
			if llRet

				// ------------------------------------------------------------------------------ //
				// PE para tratamento de validaciones extras para el personal de Alrex - 17/10/17 //
				// ------------------------------------------------------------------------------ //
				If ExistBlock("ALR0099")
					llRet := ExecBlock("ALR0099",.F.,.F.)
				EndIf
				
			endif
			
		endif

	else 
		Alert(STR0044) // "Não foi encontrada estrutura de produtos configurada!"
	endif

Return llRet

/*/{Protheus.doc} getDataEst
Funcao responsavel por consultar os dados da estrutura de produtos criada para o item posicionado do pedido de venda
@author Sergio
@since 13/05/2016
@version undefined

@type function
/*/
Static Function getDataEst()

	getDtEstVr()

Return

/*/{Protheus.doc} getDtEstVr
Mostra estrutura
@author Sergio
@since 26/05/2016
@version undefined

@type function
/*/
Static Function getDtEstVr()
	
	local nlx
	local clFamilia
	local clProduto
	local clGrupo
	local clAux
	local clCodFam
	local clDesProd
	local clGrpDesc
	local clParam
	local clConteu
	
	apDados := {}
	for nlx := 1 to len ( apVariables )
	
		if nlx == 1
		
			clFamilia	:= cpCodFam
			clProduto	:= "NOTEXIST"
			clGrupo		:= apVariables[nlx][1]
			clGrpDesc	:= AllTrim( posicione("ZZA",1,xFilial("ZZA") + clGrupo, "ZZA_DESCRI" ) )
			clConteu	:= getInfFmt( apVariables[nlx][4], &( apVariables[nlx][3] ) )
			
			clAuxParam := AllTrim( posicione("ZZB",1,xFilial("ZZB") + clGrupo + apVariables[nlx][2], "ZZB_DESCRI" ) )	// 21/02/18 - SISTHEL
			clDesOpcion := AllTrim( posicione("ZZC",2,xFilial("ZZC") + clGrupo + apVariables[nlx][2] + clConteu, "ZZC_DESCOP" ) )	// 16/03/18 - SISTHEL
			
			setApDados( cpDesFam,;
						clGrpDesc,;
						apVariables[nlx][2],;
						clAuxParam,;
						clConteu,;
						iif(empty(clConteu),"",clDesOpcion) )
						//getInfFmt( apVariables[nlx][4], &( apVariables[nlx][3] ) ) )
						
		else //endif
		
			if ( clFamilia == cpCodFam )
				clAux := ""
			else
				clAux := AllTrim( cpDesFam )
				clFamilia := cpCodFam
			endif
			clCodFam := clAux
			
			if ( clProduto == "NOTEXIST" )
				clAux := ""
			else
				clAux := STR0075 // "PRODUTO AINDA NÃO FOI CRIADO"
				clProduto := clProduto
			endif
			clDesProd := clAux
			
			if ( clGrupo == apVariables[nlx][1] )
				clAux := ""
			else			
				clGrupo := apVariables[nlx][1]
				clAux := AllTrim( posicione("ZZA",1,xFilial("ZZA") + clGrupo, "ZZA_DESCRI" ) )
			endif
			clGrpDesc := clAux
			clParam := apVariables[nlx][2]
			clAuxParam := AllTrim( posicione("ZZB",1,xFilial("ZZB") + clGrupo + clParam, "ZZB_DESCRI" ) )	// 21/02/18 - SISTHEL
			clConteu := getInfFmt( apVariables[nlx][4], &( apVariables[nlx][3] ) ) 
			clDesOpcion := AllTrim( posicione("ZZC",2,xFilial("ZZC") + clGrupo + clParam + clConteu, "ZZC_DESCOP" ) )	// 16/03/18 - SISTHEL
			
			setApDados( clCodFam, clGrpDesc, clParam, clAuxParam, clConteu, iif(empty(clConteu),"",clDesOpcion) )
		
		endif
		
	next nlx
	
Return

/*/{Protheus.doc} getInfFmt
Função auxiliar para formatar o conteudo das variaveis
@author Sergio
@since 26/05/2016
@version undefined
@param clTipo, characters, descricao
@param clConteu, characters, descricao
@type function
/*/
Static Function getInfFmt( clTipo, uConteu )

	local uRet
	
	if ( valType( uConteu ) == "N" )
		uRet := AllTrim( Str( uConteu ) )
	else
		if empty(uConteu)
			uRet := iif( clTipo == "N", &( strTran( uConteu,",",".") ), uConteu := space(ZZB->ZZB_INTEIR) )
		else
			uRet := iif( clTipo == "N", &( strTran( uConteu,",",".") ), AllTrim( uConteu ) )
		endif
	endif
	
Return uRet

/*/{Protheus.doc} setApDados
Funcao auxiliar para adicionar dados no array base para a interface responsavel por visualizar as configurações adicionadas 
@author Sergio
@since 26/05/2016
@version undefined
@param clCodFam, characters, descricao
@param clDesProd, characters, descricao
@param clGrpDesc, characters, descricao
@param clParam, characters, descricao
@param clConteu, characters, descricao
@type function
/*/
Static Function setApDados( clCodFam, clGrpDesc, clParam, clDescParam, clConteu, clDesOpcion )
	AADD(apDados, { clCodFam, clGrpDesc, clParam, clDescParam, clConteu, clDesOpcion } )
Return

/*/{Protheus.doc} buscaPrdEs
Função responsavel por consultar os produtos da estrutura de produtos referente ao item posicionado do pedido de venda
@author Sergio
@since 13/05/2016
@version undefined

@type function
/*/
Static Function buscaPrdEs()

	local clAlias	:= getNextAlias()
	
	BEGINSQL ALIAS clAlias
	
		SELECT
			DISTINCT 
			B1_COD
			, ZZF_IDCFG
			, ZZF_FAMILI
		
		FROM
			%TABLE:ZZF% ZZF
		
		INNER JOIN
			%TABLE:ZZG% ZZG ON
			ZZG_FILIAL = %XFILIAL:ZZG%
			AND ZZG.%NOTDEL%
			AND ZZG_IDCFG = ZZF_IDCFG
		
		INNER JOIN
			%TABLE:SB1% SB1 ON
			B1_FILIAL = %XFILIAL:SB1%
			AND SB1.%NOTDEL%
			AND B1_COD = ZZF_CODPAI
		
		INNER JOIN
			%TABLE:ZZA% ZZA ON
			ZZA_FILIAL = %XFILIAL:ZZA%
			AND ZZA.%NOTDEL%
			AND ZZA_GRUPO = ZZG_GRUPO
			
		INNER JOIN
			%TABLE:ZZD% ZZD ON
			ZZD_FILIAL = %XFILIAL:ZZD%
			AND ZZD.%NOTDEL%
			AND ZZD_CODIGO = ZZF_FAMILI
		
		WHERE
			ZZF.%NOTDEL%
			AND ZZF_CODPED = %EXP:M->C5_NUM%
			AND ZZF_CODPAI = %EXP:cpCodPrPai%
		
	ENDSQL
	
	( clAlias )->( dbGoTop() )
	if ( ( clAlias )->( eof() ) )
		( clAlias )->( dbCloseArea() )
		clAlias := ""
	endif
	
Return clAlias

/*/{Protheus.doc} vldParams
Funcao responsavel pela validação de preenchimento dos paramentros
@author Sergio
@since 12/05/2016
@version undefined

@type function
/*/
Static Function vldParams()

	local llRet	:= .T.
	local nlx
	local clObriga
	local uConteudo
	local clTitle
	local clMsg		:= ""
	local cRetValid := ""
	
	if ( empty( cpCodFam ) )
		llRet := .F.
		clMsg += STR0045 + STR0004 + STR0046 + CRLF // "- Campo [Familia] deve ser preenchido!"
	endif
	
	for nlx := 1 to len ( apVariables )
	
		clTitle		:= apVariables[nlx][9]
		clObriga	:= apVariables[nlx][7]
		uConteudo	:= &(apVariables[nlx][3])
		cRetValid	:= if(empty(apVariables[nlx][8]),"1==1",Alltrim(apVariables[nlx][8]))		// ADICIONADO EN 17/10/17
	
		if &(cRetValid)																			// ADICIONADO EN 17/10/17
			if ( clObriga == "S" .and. empty( uConteudo ) )
				llRet := .F.
				clMsg += STR0045 + clTitle + STR0046 + CRLF // "- Campo [" + clTitle + "] deve ser preenchido!"
			endif
		endif
	
	next nlx
	
	if ( !llRet )
		Aviso(STR0048, clMsg, {STR0043}, 3) // "ATENÇÃO!" "Fechar"
	endif
	
Return llRet

/*/{Protheus.doc} addPrdConf
Função responsavel por adicionar o produto e suas configurações em tabela no banco de dados
@author Sergio
@since 12/05/2016
@version undefined

@type function
/*/
Static Function addPrdConf( llInclui )
	
	local nlx
	local llProcessOk	:= .F.
	local llIncZZG
	
	default llInclui := .T.
	
	dbSelectArea("ZZF")
	ZZF->( dbSetOrder( 2 ) ) // FILIAL + PEDIDO + FAMILIA
	llInclui := !( ZZF->( dbSeek( xFilial("ZZF") + M->C5_NUM + cpCodFam + PADR(cpCodPrPai, tamSX3("ZZF_CODPAI")[1] ) ) ) )
	
	if ( llInclui )
		cpIdConfig	:= getSX8Num("ZZF","ZZF_IDCFG")
	else
		cpIdConfig	:= ZZF->ZZF_IDCFG
	endif
	
	begin transaction
	
		if ( llInclui .and. recLock("ZZF", .T.) )
			
			ZZF->ZZF_FILIAL	:= xFilial("ZZF")
			ZZF->ZZF_IDCFG	:= cpIdConfig
			ZZF->ZZF_CODPED	:= M->C5_NUM
			ZZF->ZZF_FAMILI	:= cpCodFam
//			ZZF->ZZF_LOTE	:= cpLote
			ZZF->ZZF_CODPAI	:= cpCodPrPai
			
			ZZF->( msUnLock() )
		endif
	
		dbSelectArea("ZZG")
		ZZG->( dbSetOrder( 1 ) )
		for nlx := 1 to len( apVariables )
		
			if !llInclui
				llIncZZG := !ZZG->( msSeek( xFilial("ZZG") + cpIdConfig + apVariables[nlx][1] + apVariables[nlx][2] ) )
			else
				llIncZZG := .T.
			endif
		
			if ( recLock("ZZG", llIncZZG) )
			
				ZZG->ZZG_FILIAL	:= xFilial("ZZG")
				ZZG->ZZG_IDCFG	:= cpIdConfig
				ZZG->ZZG_GRUPO	:= apVariables[nlx][1]
				ZZG->ZZG_PARAM	:= apVariables[nlx][2]
				ZZG->ZZG_CONTEU	:= iif( apVariables[nlx][4] == "N", AllTrim( Transform( &( apVariables[nlx][3] ), getPict(apVariables[nlx][5], apVariables[nlx][6]) ) ),&( apVariables[nlx][3] ) )
				
				ZZG->( msUnLock() )
			endif
		
		next nlx
		
		llProcessOk := .T.
		confirmSX8()
		
	end transaction
	
//	if ( llProcessOk )
	if ( !llProcessOk )	
//		msgInfo(STR0070) // "Componente gravado com sucesso!"
//	else
		rollBackSX8()
	endif
	
Return

/*/{Protheus.doc} getPict
Função responsavel por definir picture conforme numero de inteiros e decimais
@author Sergio
@since 15/05/2016
@version undefined
@param nlInteiro, numeric, descricao
@param nlDecimal, numeric, descricao
@type function
/*/
Static Function getPict( nlInteiro, nlDecimal )
Return "@9 " + replicate("9", nlInteiro) + iif( nlDecimal > 0, "." + replicate("9", nlDecimal), "")

/*/{Protheus.doc} refreshVnd
Função de controle de atualização dos folders conforme preenchimento do código da familia
@author Sergio
@since 09/05/2016
@version undefined

@type function
/*/
Static Function refreshVnd()

	local alArea	:= getArea()
	local qtyFld	:= 0
	local llProcOk	:= .T.

	private nXseq 	:= 1
	
	clearFold()	
	
	apVariables := {}
	apComps := {}  
	
	if ( .not. empty( cpCodFam ) )
	
		//----------------------------------------------------------------------
		//- Adicionando componentes no array da grid de componentes da familia -
		//----------------------------------------------------------------------
		dbSelectArea("ZZE")
		ZZE->( dbSetOrder( 1 ) )
		if ( ZZE->( dbSeek( xFilial("ZZE") + cpCodFam ) ) )
		
			while	ZZE->ZZE_FILIAL == xFilial("ZZE");
					.and. ZZE->ZZE_FAMILI == cpCodFam
				
				AADD(apComps,{ZZE->ZZE_COMP, AllTrim( posicione("SB1",1,xFilial("SB1") + ZZE->ZZE_COMP,"B1_DESC") )})
				
				ZZE->( dbSkip() )
			endDo
		
		endif
	
		//-----------------------------------------------------------------------
		//- Criando parametros agrupadas por tabs para preenchimento do usuário -
		//-----------------------------------------------------------------------
		if ( len( apComps ) > 0 )
		
			dbSelectArea("ZZA")
			ZZA->( dbSetOrder( 3 ) )
			if ( ZZA->( dbSeek( xFilial("ZZA") + cpCodFam ) ) )
			
				while	(	ZZA->( .not. eof() );
							.and. ZZA->ZZA_FILIAL == xFilial("ZZA");
							.and. ZZA->ZZA_FAMILI == cpCodFam;
				  		)
				  		
				  	qtyFld++
				  	oFld:addItem( Capital( ZZA->ZZA_DESCRI ), .T. )
				  	setParams( ZZA->ZZA_GRUPO, qtyFld )
				  		
				  	ZZA->( dbSkip() )
				endDo
				
				//---------------------------------------------------------------
				//- Criando variaveis para serem utilizadas no calculo de preço -
				//- conforme tabela ZV do cadastro de tabelas SX5               -
				//---------------------------------------------------------------
				createVSX5()
			
			endif
		
			if ( len( apVariables ) > 0 )
				refreshAll()
			else		
				llProcOk := .F.
				clearFold()
				Alert(STR0051) // "Não foram encontrados parametros para configuração!"
			endif
		else
			llProcOk := .F.
			Alert(STR0069 + cpCodFam + " - " + cpDesFam) // "Não foram encontrados componentes cadastrados para a familia "
		endif 
		
	endif
	
	restArea( alArea )

Return llProcOk

/*/{Protheus.doc} refreshAll
Funcao para atualizar os objetos principais da interface
@author Sergio
@since 27/05/2016
@version undefined

@type function
/*/
Static Function refreshAll()

	oFld:setOption(1)
	oFld:refresh()
	oDlg:refresh()
	
Return

/*/{Protheus.doc} clearFold
Funcao responsavel por limpar o folder
@author Sergio
@since 13/05/2016
@version undefined

@type function
/*/
Static Function clearFold()

	local nlx
	
	for nlx := 1 to Len( oFld:aPrompts )
		oFld:hidePage(nlx)
	next nlx
	
	oFld := Nil
	initFolder()
	
Return

/*/{Protheus.doc} clearGrid
Funcao responsavel por limpar a grid de componentes
@author Sergio
@since 21/05/2016
@version undefined

@type function
/*/
Static Function clearGrid()
	apComps := {}	
	AADD(apComps, {"",""})
	refreshGrid()
Return                  

/*/{Protheus.doc} setParams
Funcao para setar os parametros a serem preenchidos na interface de vendas
@author Sergio
@since 09/05/2016
@version undefined
@param clCodGrp, characters, descricao
@param nlNumDlg, numeric, descricao
@type function
/*/
Static Function setParams( clCodGrp, nlNumDlg )

	local nlLin			:= 10
	local nlCol			:= 10
	local nlQtyObj 		:= 1
	local nlQtyPerCol
	local qtyParams		:= 0
	local nlContVars	:= len(apVariables)
	local clVarAux01
	local clVarAux02
	local clPict
	local clTitle
	local clCondic
	local olFontObr		:= TFont():New('Arial',,-10,.T., .T.)
	local olFontN		:= TFont():New('Arial',,-10,.T., .F.)
	local nlTamTxt
	local nlFatorTam	:= 3.1
	local clOnChange

	dbSelectArea("ZZB")
	ZZB->( dbSetOrder( 3 ) ) // ZZB_FILIAL + ZZB_GRUPO + ZZB_ORDEM
	if ( ZZB->( dbSeek( xFilial("ZZB") + clCodGrp ) ) )
	
		&("oScr"+AllTrim(Str(nlNumDlg))) := TScrollBox():New(oFld:aDialogs[nlNumDlg],01,01,92,260,.T.,.T.,.T.)
		&("oScr"+AllTrim(Str(nlNumDlg))):align := CONTROL_ALIGN_ALLCLIENT
		
		nlQtyPerCol	:= getQPerCol(clCodGrp, @qtyParams)
				
		while	(	ZZB->( .not. eof() );
					.and. ZZB->ZZB_FILIAL == xFilial("ZZB");
					.and. ZZB->ZZB_GRUPO == clCodGrp;
		  		)
		  		
		  	/*
		  	if ZZB->ZZB_BLQ=='S'		// NO SE PUEDE BLOQUEAR POR QUE LAS VARIABLES DECLARADAS DE CADA CAMPO SIEMPRE HAY DEPENDENCIAS DE OTROS CAMPOS.
		  		ZZB->( dbSkip() )
		  		Loop
		  	endif
		  	*/
		  	
		  	nlContVars++
			clVarAux01	:= AllTrim( ZZB->ZZB_PARAM )
		  	clVarAux02	:= "opGet" + strZero(nlContVars,5)
		  	clTitle		:= Capital( AllTrim( ZZB->ZZB_DESCRI ) )
		  	clCondic	:= "{|| " + iif( empty( ZZB->ZZB_CONDIC ), ".T.", AllTrim(ZZB->ZZB_CONDIC)) + " }"
		  	clOnChange	:= "{|| lmpVariables(nlNumDlg) }"
		  	
		  	//--------------------------------------------------------------------
		  	//- Criando variaveis do tipo private no escopo da funcao callDlgPrd -
		  	//--------------------------------------------------------------------
		  	_SetNamedPrvt( clVarAux01, getDefInf(ZZB->ZZB_TIPO,ZZB->ZZB_INTEIR,ZZB->ZZB_DECIMA), "callDlgPrd" )
		 	_SetNamedPrvt( clVarAux02, Nil, "callDlgPrd" )
		 	
		  	setVars({	ZZB->ZZB_GRUPO,;	//[1]
  						ZZB->ZZB_PARAM,;	//[2]
  						clVarAux01,;		//[3]
  						ZZB->ZZB_TIPO,;		//[4]
  						ZZB->ZZB_INTEIR,;	//[5]
  						ZZB->ZZB_DECIMA,;	//[6]
  						ZZB->ZZB_OBRIGA,;	//[7]
  						ZZB->ZZB_CONDIC,;	//[8]
  						clTitle,;			//[9]
  						nlNumDlg,;			//[10]
  						clVarAux02,;		//[11]
  						nXseq;				//[12]		ZZB->ZZB_ORDEM
		  			})
		  	
		  	if ( ZZB->ZZB_OBRIGA == 'S' )
		  		nlTamTxt := len( clTitle )
		  		&("oSay"+AllTrim(Str(nlQtyObj))) := TSay():New( nlLin, nlCol, {|| },&("oScr"+AllTrim(Str(nlNumDlg))),,olFontObr,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,(nlTamTxt*nlFatorTam),008)
		  		&("oSay"+AllTrim(Str(nlQtyObj))):setText(  clTitle )
		  		&("oSay"+AllTrim(Str(nlQtyObj)+"N")) := TSay():New( nlLin, nlCol+((nlTamTxt*nlFatorTam) + 2), {|| " *"},&("oScr"+AllTrim(Str(nlNumDlg))),,olFontObr,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,010,008)	
		  	else
		  		&("oSay"+AllTrim(Str(nlQtyObj))) := TSay():New( nlLin, nlCol, {|| },&("oScr"+AllTrim(Str(nlNumDlg))),,olFontN,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,050,008)
		  		&("oSay"+AllTrim(Str(nlQtyObj))):setText( clTitle )	
		  	endif
		  	&("oSay"+AllTrim(Str(nlQtyObj))):ctrlRefresh()
		  	
		  	if ( ZZB->ZZB_TIPO == "N" )
		  		clPict := getPict(ZZB->ZZB_INTEIR, ZZB->ZZB_DECIMA)
		  	else
		  		clPict := "@!"
		  	endif
		  	
			&(clVarAux02) := TGet():New( nlLin+10, nlCol, &("{|u| if( Pcount() > 0, " + clVarAux01 + " := u, " + clVarAux01 + ") }"), &("oScr"+AllTrim(Str(nlNumDlg))),048,008,clPict,iif(existOpcao(ZZB->ZZB_GRUPO, ZZB->ZZB_PARAM),{||u_ALREX999( &(readVar()),readVar(),clCodGrp )},{||}),CLR_BLACK,CLR_WHITE,,,,.T.,"",,&( clCondic ),.F.,.F.,&(clOnChange),.F.,.F.,iif(existOpcao(ZZB->ZZB_GRUPO, ZZB->ZZB_PARAM),"ALRDIN",""),clVarAux01,,)
			
			//if empty(clPict) .And. !empty( ZZB->ZZB_CONDIC )
			//	&(clVarAux02):cText := ""
			//endif

		  	nlLin += 23
		  	if ( nlQtyObj == nlQtyPerCol )
		  		nlLin := 10
		  		nlCol += 100
		  		nlQtyObj := 0
		  	endif

		  	nlQtyObj++
			nXseq++

		  	ZZB->( dbSkip() )

		endDo
		
		&("oScr"+AllTrim(Str(nlNumDlg))):refresh()
	
	endif

Return

/*/{Protheus.doc} getDefInf
Função auxiliar de tratamento de dados default para as variaveis da interface
@author Sergio
@since 22/05/2016
@version undefined
@param clTipo, characters, descricao
@param nlInteiro, numeric, descricao
@param nlDecimal, numeric, descricao
@type function
/*/
Static Function getDefInf(clTipo, nlInteiro, nlDecimal)

	local uRet
	if ( clTipo == "N" )
		uRet := 0
	else
		uRet := space(nlInteiro + nlDecimal + iif( nlDecimal > 0, 1, 0) )
	endif
	
Return uRet

/*/{Protheus.doc} setVars
Função auxiliar para adicionar informações de variaveis em memoria
@author Sergio
@since 16/05/2016
@version undefined
@type function
/*/
Static Function setVars( alVars )

	AADD(apVariables, alVars)
	
Return

/*/{Protheus.doc} getQPerCol
Funcao para identificar quantidade de campos por coluna, considerando que a interface terá 2 colunas
@author Sergio
@since 09/05/2016
@version undefined
@param clCodGrp, characters, descricao
@type function
/*/
Static Function getQPerCol(clCodGrp, qtyParams)

	local nlFator	:= 0
	local qtyPerCol	:= 0
	local nlLimitCol:= 6
	
	default qtyParams := 0
	
	qtyParams := getQParams(clCodGrp)
	nlFator	:= int( qtyParams/2 )
	
	if ( qtyParams <= nlLimitCol )
		qtyPerCol := qtyParams
	elseif ( nlFator <= nlLimitCol )
		qtyPerCol := nlLimitCol
	elseif ( qtyParams%2 == 0 )
		qtyPerCol := nlFator
	else
		qtyPerCol := nlFator + 1
	endif

Return qtyPerCol

/*/{Protheus.doc} getQParams
Consulta para identificar a quantidade de parâmetros dentro de um grupo
@author Sergio
@since 09/05/2016
@version undefined

@type function
/*/
Static Function getQParams( clCodGrp )

	local nlQty		:= 0
	local clAlias	:= getNextAlias()
	local clSQL		:= "SELECT COUNT(ZZB_GRUPO) QTD FROM " + retSQLName("ZZB") + " WHERE D_E_L_E_T_ = ' ' AND ZZB_FILIAL = '" + xFilial("ZZB") + "' AND ZZB_GRUPO = '" + clCodGrp + "'"
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,clSQL),clAlias, .F., .T.)
	
	nlQty := ( clAlias )->QTD 
	( clAlias )->( dbCloseArea() )
	
Return nlQty

/*/{Protheus.doc} initFolder
Funcao para criação de folder na interface de vendas
@author Sergio
@since 07/05/2016
@version undefined

@type function
/*/
Static Function initFolder()
	//oFld := TFolder():New(	aPosObj[2,1], aPosObj[2,2],{},,oDlg,,,,.T.,.F.,(((aPosObj[2,4]-aPosObj[2,2])/100)*99),(((aPosObj[2,3]-aPosObj[2,1])/100)*99) ,)
	oFld := TFolder():New(	aPosObj[2,1], aPosObj[2,2],{},,oDlg,,,,.T.,.F.,(((aPosObj[2,4]-aPosObj[2,2])/100)*99),(((aPosObj[2,3]-aPosObj[2,1])/100)*90) ,)
Return

/*/{Protheus.doc} getDescFun
Funcao de retorno de campo conforme parametros indicados
@author Sergio
@since 06/05/2016
@version undefined
@param clCodFam, characters, descricao
@type function
/*/
Static Function getDescFun(clTabela, nlIndice, clChave, clCampoRet, clDesc)
	
	local alArea	:= getArea()
	local llRet		:= .T.
	default clDesc	:= ""
	
	if ( .not. empty( clTabela ) .And. nlIndice > 0 .And. .not. empty( clChave ) .And. .not. empty( clCampoRet ) )
		clDesc	:= Posicione(clTabela, nlIndice, clChave, clCampoRet)
		if ( empty( clDesc ) )
			llRet := .F.
			Alert(STR0013) // "Código não existe!"
		endif
	endif
	
	restArea(alArea)

Return llRet

/*/{Protheus.doc} getSXBdin
Funcao de controle de consulta padrao dinamica. Identifica as informações e chama a interface de consulta.
@author Sergio
@since 16/05/2016
@version undefined

@type function
/*/
Static Function getSXBdin()

	local nlNumDlg	:= oFld:nOption
	local clVar		:= AllTrim( readVar() )
	local nlTamVar	:= len( &(clVar) )
	local nlPos		:= 0
	
	//------------------------------------------------------
	//- Identifica que grupo e variavel esta sendo editado -
	//------------------------------------------------------
	nlPos := ASCAN(apVariables, {|x| x[10] == nlNumDlg .and. x[3] == clVar } )
	
	if ( nlPos > 0 )
		&( apVariables[nlPos][11] ):CTEXT := &("M->"+clVar) := PADR( getDlgSXB( apVariables[nlPos][1], apVariables[nlPos][2] ), nlTamVar )

		// ---------------------------//
		// adicionado en 17/10/2017   //
		// ---------------------------//
		//for nx := 1 to len(apVariables)
		for nx := nlPos+1 to len(apVariables)													// ADICIONADO EN 08/03/2018 - SISTHEL

			//cRetValid := if(empty(apVariables[nx][8]),"1==2",Alltrim(apVariables[nx][8]))		// ADICIONADO EN 17/10/17
			cRetValid := "1==2"																	// ADICIONADO EN 19/04/18
			
			if &(cRetValid)																		// ADICIONADO EN 17/10/17
			else
				cxVar := AllTrim( apVariables[nx][2] )

				if apVariables[nx][4]=="C"
					nTamVar := len( &(cxVar) )
					&( apVariables[nx][11] ):CTEXT := &("M->"+cxVar) := space(nTamVar)
				else
					&( apVariables[nx][11] ):CTEXT := &("M->"+cxVar) := 0
				endif
				
			endif
		next
		
	else
		Alert("#001 - Fail. Report to T.I. administration!") // Nao deve entrar neste if. Se entrar tem algo errado com o banco de dados ou a logica do programa
	endif
	
Return(.t.)

/*/{Protheus.doc} getDlgSXB
Constroi a interface de consulta dinamica
@author Sergio
@since 16/05/2016
@version undefined

@type function
/*/
Static Function getDlgSXB(clGrupo, clParam)

	local clRet		:= ""
	local olDlg
	local olPanel
	local alDados	:= getDatSXB(clGrupo, clParam)
	local llRet		:= .F.
	local olChkLst
	local blOk	:= {|| clRet := alDados[olChkLst:nAt][1], llRet := .T., olDlg:End() }
	local _cTexto := Space(40)
	//local xlOnChange	:= "{|| grbText(_cTexto) }"
		
	if ( len( alDados ) > 0 )
	
		DEFINE MSDIALOG olDlg TITLE "Selección de Opciones por Parametro" /*STR0054*/ FROM 001,001 TO 350,595 PIXEL of oMainWnd // "Seleção de Opções por Parametro"
	
		@ 005, 006 LISTBOX olChkLst FIELDS COLSIZES 50,50,100 HEADER  "Opción", "Parametro", "Permite?", "Condición" SIZE 288, 152 OF olDlg PIXEL; // "Opção", "Parametro", "Permite?", "Condição"
		ON DBLCLICK( eVal(blOk) )
		
		olChkLst:setArray( alDados )
		olChkLst:bLine	:= { || {alDados[olChkLst:nAt][1], alDados[olChkLst:nAt][2], alDados[olChkLst:nAt][3], alDados[olChkLst:nAt][4] } }
	
		olPanel := TPanel():New(160,005,'',olDlg,, .T., .T.,, ,288,012,.F.,.F. )
				
		olBtn1		 := TButton():New( 002, 002, STR0041, olPanel,blOk, 55,10,,,.F.,.T.,.F.,,.F.,,,.F. ) // "Ok"
		olBtn1:Align := CONTROL_ALIGN_LEFT
		
		olSplitter1 	:= TSplitter():New( 01,01,olPanel,005,01 )
		olSplitter1:Align	:= CONTROL_ALIGN_LEFT
		
		oBtn2		:= TButton():New( 002, 002, STR0043,olPanel,{|| llRet := .F., olDlg:End() }, 55,10,,,.F.,.T.,.F.,,.F.,,,.F. ) // "Fechar"
		oBtn2:Align	:= CONTROL_ALIGN_LEFT
		
		olSplitter2 	:= TSplitter():New( 01,01,olPanel,005,01 )
		olSplitter2:Align	:= CONTROL_ALIGN_LEFT
		
		oGet1 := TGet():New( 002,002,{|u| if( Pcount() > 0, _cTexto := u, _cTexto) },olPanel,150,010,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,/*&(xlOnChange)*/,.F.,.F.,,_cTexto,,,,)
		oGet1:Align	:= CONTROL_ALIGN_LEFT

		olSplitter3 	:= TSplitter():New( 01,01,olPanel,005,01 )
		olSplitter3:Align	:= CONTROL_ALIGN_LEFT
		
		oBtn3		:= TButton():New( 002, 002, "Buscar",olPanel,{|| alDados := getDatSXB(clGrupo, clParam, _cTexto),;
																	olChkLst:SetArray(alDados),;
																	olChkLst:bLine	:= { || {alDados[olChkLst:nAt][1], alDados[olChkLst:nAt][2], alDados[olChkLst:nAt][3], alDados[olChkLst:nAt][4] } } },;
												 45,10,,,.F.,.T.,.F.,,.F.,,,.F. ) // "Buscar"
		oBtn3:Align	:= CONTROL_ALIGN_RIGHT
				
		ACTIVATE MSDIALOG olDlg CENTERED
		
	else
		Alert("No fueron encontradas opciones para este parametro!") // "Não foi encontrado opções para este parâmetro!"
	endif

Return clRet

/*/{Protheus.doc} getDatSXB
Funcao de consulta de dados da consulta dinamica de opcoes de parametro
@author Sergio
@since 16/05/2016
@version undefined
@param clGrupo, characters, descricao
@param clParam, characters, descricao
@type function
/*/
Static Function getDatSXB(clGrupo, clParam, clTexto)

	local alDados	:= {}
	local clAlias	:= getNextAlias()
	local nlQtd		:= 0
	local clCondic
	local isCanAdd	:= .F.
	local llRetCond	:= .F.
	local cSql := ""
	
	default clGrupo := ""
	default clParam := ""
	default clTexto := ""
	
	cSql := "SELECT ZZC_OPCION, ZZC_DESCOP, ZZC_PERMIT, ZZC_CONDIC"
	cSql += "  FROM " +RetSqlName("ZZC")+" ZZC"
	cSql += " WHERE ZZC_FILIAL = '"+XFILIAL("ZZC")+"'"
	cSql += "   AND ZZC.D_E_L_E_T_=''"
	cSql += "   AND ZZC_GRUPO = '"+clGrupo+"'"
	cSql += "   AND ZZC_PARAM = '"+clParam+"'"
	
	if alltrim(clTexto)<>""
		cSql += " AND ZZC_DESCOP LIKE '%"+alltrim(clTexto)+"%'"
	endif
		
	cSql += " ORDER BY ZZC_DESCOP"
			
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cSql),clAlias, .F., .T.)
	
	while ( .not. ( clAlias )->( eof() ) )
	
		clCondic := AllTrim( ( clAlias )->ZZC_CONDIC )
		
		if ( .not. empty( clCondic ) )
			
			llRetCond := &( clCondic )
			
			if ( llRetCond .and. ( clAlias )->ZZC_PERMIT == "S" )
				isCanAdd := .T.
			elseif ( llRetCond .and. ( clAlias )->ZZC_PERMIT == "N" )
				isCanAdd := .F.
			elseif ( !llRetCond .and. ( clAlias )->ZZC_PERMIT == "S" )
				isCanAdd := .F.
			elseif ( !llRetCond .and. ( clAlias )->ZZC_PERMIT == "N" )
				isCanAdd := .T.
			else
				isCanAdd := .T.
			endif
			
		else
			isCanAdd := ( clAlias )->ZZC_PERMIT == "S"
		endif
		
		if ( isCanAdd )
			AADD(alDados,{	( clAlias )->ZZC_OPCION,;
							( clAlias )->ZZC_DESCOP,;
							U_getDCBOX("ZZC_PERMIT",( clAlias )->ZZC_PERMIT),;
							allTrim( ( clAlias )->ZZC_CONDIC )})
		endif
		
		( clAlias )->( dbSkip() )
	endDo
	
	( clAlias )->( dbCloseArea() )

Return alDados

/*/{Protheus.doc} existOpcao
Funcao para identificar se determinado parametro tem opcoes previamente cadastradas
@author Sergio
@since 16/05/2016
@version undefined

@type function
/*/
Static Function existOpcao(clGrupo, clParam)

	local clAlias	:= getNextAlias()
	local nlQtd		:= 0
	
	default clGrupo := ""
	default clParam := ""
	
	BEGINSQL ALIAS clAlias
	
		SELECT 
			COUNT(ZZC_PARAM) QTD
		FROM 
			%TABLE:ZZC% ZZC
		
		WHERE 
			ZZC_FILIAL = %XFILIAL:ZZC%
			AND ZZC.%NOTDEL%
			AND ZZC_GRUPO = %EXP:clGrupo%
			AND ZZC_PARAM = %EXP:clParam%
			
	ENDSQL
	
	if ( .not. ( clAlias )->( eof() ) )
		nlQtd := ( clAlias )->QTD
	endif
	
	( clAlias )->( dbCloseArea() )

Return ( nlQtd > 0 )

/*/{Protheus.doc} CriaSxb
Função para criar consulta dinamica
@author Sergio
@since 16/05/2016
@version undefined

@type function
/*/
Static Function criaSxb()

	local aArea 	:= getArea()
	local alColsSxb	:= {}
	local nlSxb				:= 0
	local nlSxb2			:= 0
	 
	AADD(alColsSxb,{"ALRDIN","1","01","RE",STR0053,STR0053,STR0053,"ZZC",""}) // "Opções"
	AADD(alColsSxb,{"ALRDIN","2","01","01","                    ","                    ","                    ","U_ALR00001(5)"    		,""})
	AADD(alColsSxb,{"ALRDIN","5","01","  ",""					 ,""					,""					   ,"MV_PAR01   "      		,""})
	
	dbSelectArea("SXB")
	dbSetOrder(1)
	for nlSxb := 1 To Len(alColsSxb)
		
		if !dbSeek( PADR(alColsSxb[nlSxb][1], Len(SXB->XB_ALIAS)) + PADR(alColsSxb[nlSxb][2], Len(SXB->XB_TIPO)) + PADR(alColsSxb[nlSxb][3], Len(SXB->XB_SEQ)) + PADR(alColsSxb[nlSxb][4], Len(SXB->XB_COLUNA))  )
			
			if RecLock("SXB",.T.)
				
				for nlSxb2 := 1 To FCount()
					
					FieldPut(nlSxb2,alColsSxb[nlSxb][nlSxb2])
					
				next nlSxb2
				
				SXB->(MsUnlock())
			endif
		endif
		
	next nlSxb
	
	RestArea( aArea )
Return  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALR00001  ºAutor  ³Microsiga           ºFecha ³  09/24/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function altPrdToPv()

	local aArea		:= getArea()
	local nW		:= 0
	local nX		:= 0
	local aColsGrd	:= {}
	local nZ        := len(aCols)
	local nUsado    := len(aHeader)
	local nPProd    := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO" })
	local nPQtdVen  := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN" })
	local nPPrcVen  := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRCVEN" })
	local nPValor   := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_VALOR" })
	local nPTES		:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_TES" })                
	local nPItem	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_ITEM" })
	local nlPosPar	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_XPARAMS" })
	local nlPosMemo	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_YSTRUCT" })
	local nPosQtLib	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDLIB" })
	local cItem		:= aCols[nZ,nPItem]
	local clTextPar	:= ""
	local nlx
	local clGrp		:= ""
	local clTes		:= ""
	local alColsAux	:= {}
	local oDlgPdr	:= GetWndDefault()
	local nPosPrUni	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRUNIT" })
	local nlPcdFam	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_YCODF" })
	local nlPdsFam	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_YDESC" })
	local nlPosIdZZF:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_XIDZZF" })
	local n2PosPar	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_XPARAM2" })

	//---------------------------------------------------------------------
	//- Tratamento para quando houver linhas sem preenchimento de produto -
	//---------------------------------------------------------------------
	for nX := 1 to nZ
		if ( .not. empty( aCols[nX][nPProd] ) )
			AADD(alColsAux, aClone(aCols[nX]) )
		endif
	next nX
	
	aCols := {}
	if ( len(alColsAux) > 0 )
		aCols := aClone( alColsAux )
	endif
	
	nZ := n //len(aCols)
	if ( nZ == 0 )
		cItem := "00"
	else
		cItem := aCols[nZ,nPItem]
/*
		for nX := 1 to len(aCols)
			if alltrim(aCols[nX,nPProd])==alltrim(cpCodPrPai)
				cpCodPrPai := getNewPPai()
				exit 
			endif
		next nX
*/
	endif
	
	//-----------------------------------------------------
	//- Adicionando produtos nos itens do pedido de venda -
	//-----------------------------------------------------
	//cItem := Soma1(cItem)
	//AADD(aCols, Array( nUsado + 1 ) )
		
	//nZ++
	N := nZ
	
	for nW := 1 to nUsado
		if (aHeader[nW,2] <> "C6_REC_WT") .And. (aHeader[nW,2] <> "C6_ALI_WT")
			aCols[nZ,nW] := CriaVar(aHeader[nW,2],.T.)
		endif	
	next nW
	
	//-------------------------
	//- Adicionando o produto -
	//-------------------------
	aCols[nZ,nUsado+1] := .F.
	aCols[nZ,nPItem  ] := cItem
	A410Produto(cpCodPrPai,.F.)
	A410MultT("M->C6_PRODUTO",cpCodPrPai)
	A410MultT("M->C6_QTDVEN",1) // TODO QUESTIONAR PERCY - QUANTIDADE DO PRODUTO DA ESTRUTURA DEVE SER INFORMADO NA INTERFACE DE VENDAS ?
	if ( .not. empty( clTes ) ) // EM REUNIAO COM PERCY EM 15/05/2016 FOI SOLICITADO AGUARDAR O PROCESSO DE ESTOQUE PARA DEFINIR COMO SERA AS QUANTIDADES
		A410MultT("M->C6_TES", clTes)
	endif
	aCols[nZ,nPProd  ] := cpCodPrPai
	
	//------------------------------------------------------------------------------
	//- Executando gatilho do campo de produto da grid de itens do pedido de venda -
	//------------------------------------------------------------------------------
	if ExistTrigger("C6_PRODUTO")
		RunTrigger(2, len( aCols ) )
	endif
	
	//---------------------------------------------------------------------------------
	//- Executando gatilho do campo de QUANTIDADE da grid de itens do pedido de venda -
	//---------------------------------------------------------------------------------
	aCols[nZ,nPQtdVen] := 0 // colocar UNO - QUANTIDADE DO PRODUTO DA ESTRUTURA DEVE SER INFORMADO NA INTERFACE DE VENDAS ?
	A410SegUm(.T.)			// EM 15/05/2016 FOI SOLICITADO AGUARDAR O PROCESSO DE ESTOQUE PARA DEFINIR COMO SERA AS QUANTIDADES
	if ExistTrigger("C6_QTDVEN ")
		RunTrigger(2,N,Nil,,"C6_QTDVEN ")
	endif
	
	aCols[nZ,nPPrcVen] := getPrcUnit( nZ )		
		
	if ( aCols[nZ,nPPrcVen] == 0 )
		aCols[nZ,nPPrcVen] := 1
		aCols[nZ,nPValor ] := aCols[nZ,nPQtdVen]
	else
		aCols[nZ,nPValor ] := A410Arred(aCols[nZ,nPQtdVen]*aCols[nZ,nPPrcVen],"C6_VALOR")
	endif
	
	// ----------------------------------------------------- //
	// Modificacion hecha para actualizar el precio de lista //
	// ----------------------------------------------------- //
	aCols[nZ,nPosPrUni ] := aCols[nZ,nPPrcVen]
	
	if ( .not. empty( clTes ) )						
	
		aCols[nZ,nPTES   ] := clTes
		
		//--------------------------------------------------------------------------
		//- Executando gatilho do campo de TES da grid de itens do pedido de venda -
		//--------------------------------------------------------------------------
		if ExistTrigger("C6_TES")
			RunTrigger(2, len( aCols ) )
		endif
		
	endif
	
	if ( nlPosPar > 0 .and. len( apVariables ) > 0 )
	
		clTextPar := ""
	
		//---------------------------------
		//- Ordena as variaveis por grupo -
		//---------------------------------
		apVariables := aSort(apVariables,,, { |x,y| x[12] < y[12] } )
	
		ZZA->( dbSetOrder(1) )
		
		for nlx := 1 to len( apVariables )
		
			cConteudo := (  &( apVariables[nlx][3] ) )
			If !Empty( cConteudo )
		
				/*
				if ( nlx == 1 )
					clGrp := apVariables[nlx][1]
				endif
				
				if ( clGrp # apVariables[nlx][1] )
					clGrp := apVariables[nlx][1]
					clTextPar += subs(clTextPar, 1, ( len(clTextPar)-1 ) )
					clTextPar += "|"
				endif
				*/
				/* 25-04-2018
				if ( clGrp # apVariables[nlx][1] )
					if !empty(clGrp)
						clTextPar += '|'
					endif
					ZZA->( Msseek( xFilial('ZZA')+apVariables[nlx][1]) )
					clGrp := apVariables[nlx][1]
					clTextPar += Upper(Alltrim(ZZA->ZZA_DESCRI))+':'+ CRLF
				endif
				*/
				
				if	(	( apVariables[nlx][4] == "N" .and. ( &( apVariables[nlx][3] ) ) > 0 ); 
						.or. ( apVariables[nlx][4] == "C" .and. .not. empty( apVariables[nlx][3] ) ); 
					)
					
					//clTextPar += iif( apVariables[nlx][4] == "N",;
					//					 AllTrim( Upper(Alltrim(apVariables[nlx][9])) + '-' + Transform( &( apVariables[nlx][3] ), getPict(apVariables[nlx][5], apVariables[nlx][6]) ) ),;
					//					 AllTrim( Upper(Alltrim(apVariables[nlx][9])) + '-' + &( apVariables[nlx][3] ) ) ) + ";" + CRLF
					clTextPar += Strzero(apVariables[nlx][12],3)+"|"
					clTextPar += iif( apVariables[nlx][4] == "N",;
										 AllTrim( Upper(Alltrim(apVariables[nlx][9])) + '-' + Transform( &( apVariables[nlx][3] ), getPict(apVariables[nlx][5], apVariables[nlx][6]) ) ),;
										 AllTrim( Upper(Alltrim(apVariables[nlx][9])) + '-' + AllTrim( posicione("ZZC",2,xFilial("ZZC") + apVariables[nlx][1] + apVariables[nlx][2] + &(apVariables[nlx][3]), "ZZC_DESCOP" ) ) ) ) + ";" //+ CRLF	// 16/03/18 - SISTHEL - &( apVariables[nlx][3] ) ) ) + ";" + CRLF

				endif
				
			endif
				
		next nlx
	
		clTextPar := subs(clTextPar, 1, ( len(clTextPar)-1 ) )
		aCols[nZ,nlPosPar] := substr(clTextPar,1,254)
		aCols[nZ,n2PosPar] := substr(clTextPar,255,254)
		aCols[nZ,nlPosMemo] := clTextPar
		aCols[nZ,nPosQtLib] := 0	//aCols[nZ,nPQtdVen]
		aCols[nZ,nlPcdFam] := cpCodFam
		aCols[nZ,nlPdsFam] := AllTrim( posicione("ZZD",1,xFilial("ZZD")+cpCodFam,"ZZD_DESCRI") )

	endif
	
	SB1->( dbSetOrder(1) )
	if SB1->( dbseek( xFilial("SB1")+aCols[nZ,nPProd] ) )
		SB1->( RecLock("SB1",.f.) )
		SB1->B1_PRV1 := aCols[nZ,nPPrcVen]
		SB1->( MsUnlock() )
	endif

	//---------------------------------------------------------------------
	// Garante o vinculo do ID de configuracao com o item Pedido de venda -
	//---------------------------------------------------------------------
	//aCols[nZ][nlPosIdZZF] := 1 := cpIdConfig
	aCols[nZ][nlPosIdZZF] := cpIdConfig
	
	N := len( aCols )
	oGetDad:ForceRefresh()
	Ma410Rodap(oGetDad)
	oDlgPdr:refresh()
		
	restArea(aArea)
	
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALR00001  ºAutor  ³Microsiga           º Data ³  02/18/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function lmpVariables()

	local nlx := 1
	local llRet := .t.
	local clVar	:= AllTrim( readVar() )
	local gPos := ASCAN(apVariables, {|x| x[3] == clVar } )
	
	for nlx := gPos to len ( apVariables )
	
		if val(right(apVariables[nlx][11],5))>gPos

			cConteudo := (  &( apVariables[nlx][3] ) )
		
			if apVariables[nlx][4]=="C"
				If !Empty( cConteudo )
					&(apVariables[nlx][3]) := Space(len(cConteudo))
				endif
			endif
		
		endif
		
	next nlx
	
Return
