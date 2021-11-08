#Include "PROTHEUS.Ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"
#DEFINE ENTER chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NFE0001A  ºAutor  ³Microsiga           º Data ³  02/19/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Enviar Anulacion de la factura para Nubefact               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NFE01A( xSerie,xDoc,xCliente,xLoja )

	Local _xAlias01 := getNextAlias()
	Local _xAlias02 := getNextAlias()
	Local cQry		:= ""
	
	cQry := "SELECT *"+CRLF
	cQry += "  FROM "+RetSqlName("SF2")+CRLF
	cQry += " WHERE F2_FILIAL='"+xFilial("SF2")+"'"+CRLF
	cQry += "   AND F2_DOC='"+xDoc+"'"+CRLF
	cQry += "   AND F2_SERIE='"+xSerie+"'"+CRLF
	cQry += "   AND F2_CLIENTE='"+xCliente+"'"+CRLF
	cQry += "   AND F2_LOJA='"+xLoja+"'"+CRLF
				
	dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQry), _xAlias01, .F., .T.)
												
	If (_xAlias01)->( !Eof() )
	
		While (_xAlias01)->( !Eof() )
		
			SF2->( dbSetOrder(1) )	// F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA
			If SF2->( ( dbSeek( xFilial("SF2")+(_xAlias01)->F2_DOC+(_xAlias01)->F2_SERIE+(_xAlias01)->F2_CLIENTE+(_xAlias01)->F2_LOJA ) ) )
				
				aCab := {}
				Aadd ( aCab,	{"F2_FILIAL"	, xFilial("SF2")															, Nil } )
				Aadd ( aCab,	{"F2_CLIENTE"	, SF2->F2_CLIENTE															, Nil } )
				Aadd ( aCab,	{"F2_LOJA"		, SF2->F2_LOJA																, Nil } )
				Aadd ( aCab,	{"F2_SERIE"		, SF2->F2_SERIE																, Nil } )
				Aadd ( aCab,	{"F2_DOC"		, SF2->F2_DOC																, Nil } )
				Aadd ( aCab,	{"F2_EMISSAO"	, SF2->F2_EMISSAO 															, Nil } )
				Aadd ( aCab,	{"F2_COND"		, SF2->F2_COND																, Nil } )
				Aadd ( aCab,	{"F2_TIPO"		, SF2->F2_TIPO																, Nil } )
				Aadd ( aCab,	{"F2_ESPECIE"	, SF2->F2_ESPECIE															, Nil } )
				Aadd ( aCab,	{"F2_PREFIXO"	, SF2->F2_PREFIXO															, Nil } )
				Aadd ( aCab,	{"F2_MOEDA"		, SF2->F2_MOEDA																, Nil } )
				Aadd ( aCab,	{"F2_TXMOEDA"	, SF2->F2_TXMOEDA															, Nil } )
				Aadd ( aCab,	{"F2_TIPODOC"	, SF2->F2_TIPODOC															, Nil } )
				Aadd ( aCab,	{"F2_TPDOC"		, SF2->F2_TPDOC																, Nil } )
				
				cQry := "SELECT *"+CRLF
				cQry += "  FROM "+RetSqlName("SD2")+CRLF
				cQry += " WHERE D2_FILIAL='"+xFilial("SD2")+"'"+CRLF
				cQry += "   AND D2_DOC='"+SF2->F2_DOC+"'"+CRLF
				cQry += "   AND D2_SERIE='"+SF2->F2_SERIE+"'"+CRLF
				cQry += "   AND D2_CLIENTE='"+SF2->F2_CLIENTE+"'"+CRLF
				cQry += "   AND D2_LOJA='"+SF2->F2_LOJA+"'"+CRLF
				
				dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQry), _xAlias02, .F., .T.)
												
				If (_xAlias02)->( !Eof() )
						
					aItens := {}
					
					(_xAlias02)->( dbGotop() )
						
					While (_xAlias02)->( !Eof() )
							
						aLinha := {}
								
						AAdd( aLinha, { "D2_FILIAL"		, xFilial("SD2")										, Nil } )
						AAdd( aLinha, { "D2_ITEM"    	, (_xAlias02)->D2_ITEM									, Nil } )
						AAdd( aLinha, { "D2_COD"    	, (_xAlias02)->D2_COD									, Nil } )
						AAdd( aLinha, { "D2_QUANT"  	, (_xAlias02)->D2_QUANT									, Nil } )
						AAdd( aLinha, { "D2_PRCVEN"  	, (_xAlias02)->D2_PRCVEN								, Nil } )
						AAdd( aLinha, { "D2_TOTAL"  	, (_xAlias02)->D2_TOTAL									, Nil } )
						AAdd( aLinha, { "D2_TES" 		, (_xAlias02)->D2_TES									, Nil } )
						AAdd( aLinha, { "D2_ESPECIE"	, (_xAlias02)->D2_ESPECIE								, Nil } )
						AAdd( aLinha, { "D2_LOCAL"	  	, (_xAlias02)->D2_LOCAL									, Nil } )
						AAdd( aLinha, { "D2_DESC"	  	, (_xAlias02)->	D2_DESC								 	, Nil } )
						AAdd( aLinha, { "D2_PRUNIT"	  	, (_xAlias02)->	D2_PRUNIT								, Nil } )

						AAdd( aItens, aLinha )
								
						(_xAlias02)->( dbSkip() )	

					Enddo

					(_xAlias02)->( dbCloseArea() )
			
					lMsErroAuto := .F.
			
					MSExecAuto( { |x,y,z| Mata467n(x,y,z) }, aCab, aItens, 5 )		// 6-Anulado / 5-borrar
					
					If lMsErroAuto
					
						MostraErro()
					
					EndIf
					
				EndIf

            EndIf
            
            (_xAlias01)->( dbSkip() )
            
		EndDo

	EndIf
	
	(_xAlias01)->( dbCloseArea() )
	
Return
