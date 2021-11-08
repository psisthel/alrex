#include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LOCXPE11  ºAutor  ³Percy Arias,SISTHEL º Data ³  10/13/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Hace la Integracion con el sistema de Punto de Venta       º±±
±±º          ³ LOLFAR9000.                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FUSAC - Peru                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LOCXPE11

	local _aArea := GetArea()
	local nX := 0
	local _xNomCli := ""

	If Alltrim(Funname()) == 'MATA465N'		// nota de credito y debito del para el proveedor (salida de mercaderia del stock)
	
		//If cNFTipo=="C" .And. nNFTipo==9	// nota de credito proveddor
		If cNFTipo=="D" .And. nNFTipo==4	// nota de credito cliente
			U_NFE001( .T.,.T. )
		Endif
	
	ElseIf Alltrim(FUNNAME())=="MATA462AN"	.Or. Alltrim(FUNNAME())=="MATA468N"	// guia de remision de saida automatica o facrura automatica 
	
        _xNomCli := Alltrim(Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE,"SA1->A1_NOME"))
        _xNomCli := Left(_xNomCli,TamSX3("F2_YNOMCLI")[1])

        /*
        if empty(_xNomCli)
        	_xNomCli := Left(Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE,"SA1->A1_NREDUZ"),TamSX3("F2_YNOMCLI")[1])
        endif
        */
        
        SF2->( RecLock("SF2",.f.) )
        SF2->F2_YCOD	:= SC5->C5_NUM 
        SF2->F2_TRANSP	:= SC5->C5_TRANSP
        SF2->F2_YNOMCLI	:= _xNomCli			//Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENT,"SA1->A1_NREDUZ")
        SF2->( MsUnlock() )

        n_IndexOrd := SD2->( IndexOrd() )
        n_RecnoD2 := SD2->( Recno() )
        
        SD2->( dbSetOrder(3) ) // D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_COD, D2_ITEM
        If SD2->( dbSeek( xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA ) )
        
        	_cNroPed := SD2->D2_PEDIDO
        
        	While ( xFilial("SF2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA )==( xFilial("SD2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA ) .AND. SD2->( !Eof() )
        	
        		SD2->( RecLock("SD2",.f.) )
        		SD2->D2_YDESCRI := substr(Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"SB1->B1_DESC"),1,30)
        		SD2->D2_YNOMCLI := _xNomCli			//Left(Posicione("SA1",1,xFilial("SA1")+SD2->D2_CLIENTE,"SA1->A1_NREDUZ"),30)
        		SD2->( MsUnlock() )
        
        		SD2->( dbSkip() )
        	End
        
        EndIf
	
        SD2->( dbGoto( n_RecnoD2 ) )
        SD2->( dbSetOrder( n_IndexOrd ) )
        
        /*
        if Alltrim(FUNNAME())=="MATA462AN"
			EndEntrega(SC5->C5_NUM)
		endif
		*/
	
	ElseIf Alltrim(FUNNAME())=="MATA462N" .Or. Alltrim(FUNNAME()) == "MATA467N"		// guia de remision manual OR factura directa de saida
	
		_xNomCli := Left(Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE,"SA1->A1_NOME"),TamSX3("F2_YNOMCLI")[1])
		
		SF2->( RecLock("SF2",.f.) )
		SF2->F2_YNOMCLI	:= _xNomCli
		SF2->( MsUnlock() )
		
		SD2->( dbSetOrder(3) )
		If SD2->( dbSeek( xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA ) )
		
			While SF2->( xFilial("SF2")+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA ) == SD2->( xFilial("SD2")+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA ) .And.;
					SD2->( !Eof() )
				
				SD2->( RecLock("SD2",.f.) )
				SD2->D2_YNOMCLI := _xNomCli		//Posicione("SA1",1,xFilial("SA1")+SD2->D2_CLIENTE,"SA1->A1_NREDUZ")
				SD2->( MsUnlock() )
				SD2->( dbSkip() )
			
			End
			
		EndIf
		
		if Alltrim(FUNNAME()) == "MATA467N"
			//---------------------------------------------------//
			// borrar la factura que no fue autorizada por SUNAT //
			// --------------------------------------------------//
			//If Empty(SF2->F2_YQR) .And. Empty(SF2->F2_YHASH)
				//u_NFE01A( SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_CLIENTE,SF2->F2_LOJA )
			//EndIf
		endif
		
	EndIf

	RestArea(_aArea)

Return
