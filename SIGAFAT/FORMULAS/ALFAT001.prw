#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} ALFAT001
Rutina pra calcular precio de venta unitario
@author 
@since 13/03/2018
@version undefined
@param pFamilia
@param uParam, undefined, parametros para a a opcao a ser executada
@type function
/*/

User Function ALFAT001( pFamilia, pItem )

	local alArea	:= getArea()
	local nlwPrecio := 0
	local nlPrcUni	:= 0
	local nlFacDes	:= 0
	local nlFormul := 0
	local nlMinimo := 0
	local clCondic	:= ""
	local clCondic2	:= ""
	local clTipoDes := " "
	local clFormul1 := ""
	local clFormul2 := ""
	local clMinimo := ""
	local llFirst	:= .T.
	local llError	:= .F.
	
	createVars( pItem, !llFirst )
	llFirst := .F.

	dbSelectArea("SA1")
	dbSetOrder(1)
	If dbSeek(xFilial("SA1") + M->C5_CLIENTE)
	    clTipoDes := SA1->A1_YTIPDES
	EndIf

	dbSelectArea("ZY3")
	ZY3->( dbSetOrder( 1 ) )
	IF ( dbSeek( xFilial("ZY3") + pFamilia ) )
		nlPrcUni := 0
		WHILE .not. ZY3->( eof() );
		.and. ZY3->ZY3_FILIAL == xFilial("ZY3");
		.and. ZY3->ZY3_FAMILI == pFamilia
				
			nlwPrecio := 0
			clCondic := AllTrim( ZY3->ZY3_CONDIC )
			IF ( .not. empty( clCondic ) .and. &( clCondic ) )
				//clFormul1 := AllTrim( strTran(strTran(ZY3->ZY3_FORMU1,CHR(13),""),CHR(10),"") )
				clFormul1 := AllTrim( strTran(strTran(ZY3->ZY3_FORMUL,CHR(13),""),CHR(10),"") )
				IF Empty(clFormul1)
					clFormul1 := "1"
				ENDIF
				clFormul2 := AllTrim( strTran(strTran(ZY3->ZY3_FORMU2,CHR(13),""),CHR(10),"") )
				IF Empty(clFormul2)
					clFormul2 := "1"
				ENDIF
				clMinimo := AllTrim( strTran(strTran(ZY3->ZY3_MINIMO,CHR(13),""),CHR(10),"") )
				IF Empty(clMinimo)
					clMinimo := "0"
				ENDIF
				nlFormul := &( clFormul1 ) * &( clFormul2 )  	
				nlMinimo := &( clMinimo )
				IF nlFormul < nlMinimo
					nlFormul := nlMinimo
				ENDIF			
				//nlFacDes := 1
				nlFacDes := ZY3->ZY3_PRECIO												// SISTHEL 08/08/2019
				DO CASE 
					CASE clTipoDes == "1"
						//nlFacDes := 1 - ZY3->ZY3_DESCT1 / 100
						nlFacDes := ZY3->ZY3_DESCT1										// SISTHEL 08/08/2019
					CASE clTipoDes == "2"
						//nlFacDes := 1 - ZY3->ZY3_DESCT2 / 100
						nlFacDes := ZY3->ZY3_DESCT2										// SISTHEL 08/08/2019
					CASE clTipoDes ==  "3"
						//nlFacDes := 1 - ZY3->ZY3_DESCT3 / 100
						nlFacDes := ZY3->ZY3_DESCT3										// SISTHEL 08/08/2019
					CASE clTipoDes == "4"
						//nlFacDes := 1 - ZY3->ZY3_DESCT4 / 100
						nlFacDes := ZY3->ZY3_DESCT4										// SISTHEL 08/08/2019
					CASE clTipoDes == "5"
						//nlFacDes := 1 - ZY3->ZY3_DESCT5 / 100
						nlFacDes := ZY3->ZY3_DESCT5										// SISTHEL 08/08/2019
				ENDCASE						
					
				//nlwPrecio := ROUND(ZY3->ZY3_PRECIO * nlFormul * nlFacDes, 2)
				nlwPrecio := nlFacDes * nlFormul										// SISTHEL 08/08/2019
										
				dbSelectArea("ZY4")
				ZY4->( dbSetOrder( 2 ) )
				IF ( dbSeek( xFilial("ZY4") + ZY3->ZY3_CODPRE ) )
					
					WHILE .not. ZY4->( eof() );
					.and. ZY4->ZY4_FILIAL == xFilial("ZY4");
			     	.and. ZY4->ZY4_CODPRE == ZY3->ZY3_CODPRE
				     	
				     	clCondic2 := AllTrim( ZY4->ZY4_CONDIC )      	
				     	IF ZY4->ZY4_FECINI <= DATE() .AND. ZY4->ZY4_FECFIN >= DATE();
				     	.AND. ( .not. empty( clCondic2 ) .and. &( clCondic2 ) )
				     		IF AT(clTipoDes, AllTrim(ZY4->ZY4_APLICA)) > 0
				     	 		IF ZY4->ZY4_PRECIO > 0
				     	      		nlwPrecio := ZY4->ZY4_PRECIO
				     	      	ELSE
				     	      		nlwPrecio := nlwPrecio * (1 - ZY4->ZY4_DESADI / 100)
				     	      	ENDIF
				     	   	ENDIF		
				   		ENDIF
				     	ZY4->( dbSkip() )
				  	ENDDO
					  	
				ENDIF
				
				IF M->(C5_MOEDA) <> ZY3->ZY3_MONEDA
					dbSelectArea("SM2")
					dbSetOrder(1)
					IF dbSeek(M->C5_EMISSAO)
						IF SM2->M2_MOEDA2 > 0 
							DO CASE
								CASE M->(C5_MOEDA) = 1
		       						nlwPrecio := nlwPrecio * SM2->M2_MOEDA2
		       					CASE M->(C5_MOEDA) = 2
		       						nlwPrecio := nlwPrecio / SM2->M2_MOEDA2
		       				ENDCASE
						ELSE
				   			MsgStop("Tipo de cambio no válido, para la fecha " + DTOC(M->C5_EMISSAO))
				   			nlwPrecio := 0
				   			llError := .T.
						ENDIF
					ELSE
				   		MsgStop("No se encuentra tipo de cambio para la fecha " + M->C5_EMISSAO)
				   		nlwPrecio := 0
				   		llError := .T.
					ENDIF
				ENDIF
				nlPrcUni += nlwPrecio
			ENDIF
			ZY3->( dbSkip() )
			
		ENDDO 
		
		nlPrcUni := Round(nlPrcUni,2)
		
	 	IF llError
	 		nlPrcUni := 0
	 	ENDIF
	 	
	ENDIF
	
	restArea( alArea )

Return(if(nlPrcUni<=1,0,nlPrcUni))


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
	
		while	ZZG->ZZG_FILIAL == xFilial("SG1");
				.and. ZZG->ZZG_IDCFG == clIdCfg
			
			dbSelectArea("ZZB")
			ZZB->( dbSetOrder( 1 ) )
			if ( dbSeek( xFilial("ZZB") + ZZG->ZZG_GRUPO + ZZG->ZZG_PARAM ) )
				clVar	:= AllTrim( ZZB->ZZB_PARAM )
				uConteu	:= getInfFmt( ZZB->ZZB_TIPO, ZZG->ZZG_CONTEU )
				
				if ( isVarExist )
					&( clVar ) := uConteu
				else				
					_SetNamedPrvt( clVar, uConteu, "U_ALFAT001" )
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
@param isVarExist, , descricao
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
				_SetNamedPrvt( clVar, uConteu, "U_ALFAT001" )
			endif
			
			SX5->( dbSkip() )
		endDo
		
	endif
	
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
		uRet := iif( clTipo == "N", &( strTran( uConteu,",",".") ), AllTrim( uConteu ) )
	endif
	
Return uRet
