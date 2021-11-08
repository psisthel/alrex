#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA450MNU  ºAutor  ³Microsiga           º Data ³  08/23/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MA450MNU

	Aadd( aRotina, {"Cta.Entrega","u_CTAENTGA", 0 , 5,0,.F.} )

Return( aRotina )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA450MNU  ºAutor  ³Percy Arias,SISTHEL º Data ³  08/23/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE para poder liberar el credito de las condiciones de     º±±
±±º          ³ pago contra entrega. Depende liberar para poder generar GR º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CTAENTGA

	local oDlg
	local oSatGet
	local oSatGet1
	local oSatGet2
	local lVarMat
	local oGet
	
	private apItens := {}
	private olItens
	private nList := 0
	
	GetQuery()
	
	If Len( apItens ) > 0
	
		//While .t.
		
			iif(nList = 0,nList := 1,nList)
	
			Define MsDialog oDlg Title "Pedidos Contra Entrega" FROM 0,0 TO 450,1000 PIXEL
	
			@ 20,5 LISTBOX olItens VAR lVarMat Fields HEADER "Pedido","Cliente","Nombre del Cliente","Emisión","Entrega","Total","Usuario","Id";
				  	SIZE 495,190 /*On DblClick( ConfChoice(olItens:nAt, @apItens),oDlg:End() )*/ OF oDlg PIXEL
	
			olItens:setArray( apItens )
			olItens:nAt := nList
			olItens:bLine	:= { || { apItens[olItens:nAt][1], apItens[olItens:nAt][2], apItens[olItens:nAt][3], apItens[olItens:nAt][4], apItens[olItens:nAt][5], apItens[olItens:nAt][6], apItens[olItens:nAt][7], apItens[olItens:nAt][8] } }
	
			oTButton2 := TButton():New( 005,005, "Salir",oDlg,{|| nOpc := 0, oDlg:End() }, 50,12,,,.F.,.T.,.F.,,.F.,,,.F. )   
			oTButton1 := TButton():New( 005,060, "Confirmar",oDlg,{|| 	nOpc := 1,;
					msgRun("Aguarde, confirmando pago...", "ALREX", {|| AtuCredito( apItens[olItens:nAt][8] ),;
					GetQuery(),;
					@apItens,;
					olItens:setArray(apItens),;
					olItens:nAt := nList,;
					olItens:bLine	:= { || { apItens[olItens:nAt][1], apItens[olItens:nAt][2], apItens[olItens:nAt][3], apItens[olItens:nAt][4], apItens[olItens:nAt][5], apItens[olItens:nAt][6], apItens[olItens:nAt][7], apItens[olItens:nAt][8] } },;
					olItens:Refresh() } ),;
					}, 50,12,,,.F.,.T.,.F.,,.F.,,,.F. )
	
			Activate MSDialog oDlg Centered
			
			//if nOpc==0
				//exit
			//endif
			
		//End
				
	else
	
		alert("¡No existen clientes contra entrega a liberar!")
	
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA450MNU  ºAutor  ³Microsiga           º Data ³  08/25/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuCredito( _nRec )

	SC5->( dbgoto( _nRec ) )
	SC5->( RecLock("SC5",.f.) )
	SC5->C5_YLIBCRD := "X"
	SC5->( MsUnlock() )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA450MNU  ºAutor  ³Microsiga           º Data ³  08/25/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetQuery()

	local cAlias	:= getNextAlias()
	local cCondPag	:= getNewPar("AL_FILCRD","000|002")		// CONTRAENTREGA
	local cSql		:= ""
	
	apItens := {}
	cCondPag := replace(cCondPag,"|","','")

	cSql := "SELECT SC5.C5_NUM,SC5.C5_CLIENTE,SC5.C5_YNOMCLI,SC5.C5_EMISSAO,SC5.C5_SUGENT,SC5.C5_LOGINCL,SC5.R_E_C_N_O_ NREC,SUM(SC6.C6_VALOR) TOTAL"
	cSql += "  FROM "+RetSqlName("SC5") + " SC5,"+RetSqlName("SC6")+ " SC6"
	cSql += " WHERE SC5.C5_FILIAL='"+xFilial("SC5")+"'"
	cSql += "   AND SC6.C6_FILIAL='"+xFilial("SC6")+"'"
	cSql += "   AND SC5.D_E_L_E_T_=' '"
	cSql += "   AND SC6.D_E_L_E_T_=' '"
	cSql += "   AND SC5.C5_CONDPAG IN ('"+cCondPag+"')"
	cSql += "   AND SC5.C5_NUM = SC6.C6_NUM"
	cSql += "   AND SC5.C5_YLIBCRD=' '"
	cSql += "   AND SC5.C5_LIBEROK='S'"
	cSql += "   AND SC5.C5_NOTA=' '"
	cSql += " GROUP BY SC5.C5_NUM,SC5.C5_CLIENTE,SC5.C5_YNOMCLI,SC5.C5_EMISSAO,SC5.C5_SUGENT,SC5.C5_LOGINCL,SC5.R_E_C_N_O_"
	cSql += " ORDER BY SC5.C5_NUM DESC"
	 
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cAlias,.T.,.T.)
	
	if (cAlias)->( !eof() )
		while (cAlias)->( !eof() )
			Aadd( apItens, {	(cAlias)->C5_NUM							,;
								(cAlias)->C5_CLIENTE						,;
								(cAlias)->C5_YNOMCLI						,;
								STOD((cAlias)->C5_EMISSAO)					,;
								STOD((cAlias)->C5_SUGENT)					,;
								transform((cAlias)->TOTAL,"999,999.99")		,;
								Upper((cAlias)->C5_LOGINCL)					,;
								(cAlias)->NREC								;
							} )

			(cAlias)->( dbSkip() )
		end
	endif
	
	(cAlias)->( dbCloseArea() )

Return