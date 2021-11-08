#Include "PROTHEUS.Ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"
#DEFINE ENTER chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTHFIN01  บAutor  ณMicrosiga           บ Data ณ  08/15/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STHFIN01()

	Private cPerg := "TXTCITI"
	
	If Pergunte(cPerg,.T.)                                                  
	
		MsgRun( "Aguarde, Leyendo informaciones de pagos ..." ,, {|| U_EXECITI() } )
				
	EndIf
	
Return Nil  

User Function EXECITI()

	Local aCpos 	:= {}
	Local aCampos 	:= {}
	Local aCores  	:= {}
	Local cQry1		:= ""
	Local _cAlias	:= GetNextAlias()
	Local _cOPs		:= ""
	Local nValor	:= 0

	Private aRotina 	:= {}
	Private cCadastro 	:= "Genera Pago Masivo Banco CitiBank"
	Private cMarcaSE2   := GetMark()    
	Private aTotales	:= {}
	Private aOrdenes	:= {}
	Private _cTipos		:= ""

	_cTipos := Alltrim(MV_PAR10)
	_cTipos := "'"+Replace(_cTipos,"/","','")
	_cTipos := Substr(_cTipos,1,Len(_cTipos)-2)
	
	AAdd ( aCores , { "TXEMP->EK_YFLAG <> ' '"  , "BR_AZUL"		} )
	AAdd ( aCores , { "TXEMP->EK_YFLAG = ' '" , "BR_VERDE"		} )
	
	If Select("TRB") > 0  
	   TRB->( dbCloseArea() )
	End   
	
	cQry1 := "SELECT EK_ORDPAGO,EK_BANCO,EK_AGENCIA,EK_CONTA,EK_VALOR,EK_EMISSAO,EK_VENCTO,EK_FORNECE,EK_MOEDA,EK_YFLAG,EK_LOJA"+CRLF
  	cQry1 += "  FROM "+RetSQLName('SEK')+CRLF
	cQry1 += " WHERE EK_FILIAL ='"+xFilial("SEK")+"'"+CRLF
	cQry1 += "   AND EK_VENCTO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"'"+CRLF
   	cQry1 += "   AND EK_TIPODOC='CP'"+CRLF
   	cQry1 += "   AND EK_CONTA='"+MV_PAR07+"'"+CRLF
   	cQry1 += "   AND EK_CANCEL<>'T'"+CRLF
	cQry1 += "   AND D_E_L_E_T_ <>'*' "+CRLF  	

	If MV_PAR12==2								// NO Generados
		cQry1 += " AND EK_YFLAG = ' '"
	ElseIf MV_PAR12==1							// Generados
		cQry1 += " AND EK_YFLAG <> ' '"
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry1),_cAlias,.T.,.T.) 
	
	_cOPs := "'"
	
	While (_cAlias)->( !Eof() )
	
		Aadd( aTotales, { (_cAlias)->EK_ORDPAGO,(_cAlias)->EK_VALOR } )
		Aadd( aOrdenes, { (_cAlias)->EK_ORDPAGO,(_cAlias)->EK_FORNECE,(_cAlias)->EK_VALOR,(_cAlias)->EK_EMISSAO,(_cAlias)->EK_VENCTO,(_cAlias)->EK_MOEDA,(_cAlias)->EK_YFLAG,(_cAlias)->EK_LOJA } )

		(_cAlias)->( dbSkip() )
		
	End 
	
	(_cAlias)->( dbCloseArea() )
	
	If Select("TRB") > 0
		TRB->( dbCloseArea() )
	EndIf

	If Select("TXEMP") > 0
		TXEMP->( dbCloseArea() )
	EndIf

	aStruct := {}
	cArq := CriaTrab(Nil,.F.)

	AAdd( aStruct,{ "E2_OK"				,"C",02,0	} )
	AAdd( aStruct,{ "E2_NUM"	   		,"C",40,0	} )
	AAdd( aStruct,{ "E2_TIPO"			,"C",03,0	} )
	AAdd( aStruct,{ "E2_FORNECE"		,"C",11,0	} )
	AAdd( aStruct,{ "E2_LOJA"			,"C",02,0	} )
	AAdd( aStruct,{ "E2_NOMFOR"			,"C",20,0	} )
	AAdd( aStruct,{ "EK_SALDO"			,"N",15,2	} )
	AAdd( aStruct,{ "E2_ORDPAGO"		,"C",06,0	} )
	AAdd( aStruct,{ "E2_EMISSAO"		,"D",08,0	} )
	AAdd( aStruct,{ "E2_VENCTO"			,"D",08,0	} )
	AAdd( aStruct,{ "E2_VALOR"			,"N",15,2	} )
	AAdd( aStruct,{ "EK_YFLAG"			,"C",01,0	} ) 
	AAdd( aStruct,{ "E2_MOEDA"			,"C",01,0	} ) 

	DbCreate(cArq , aStruct )
	DbUseArea(.T. ,, cArq ,"TXEMP",.T.,.F.)
	IndRegua("TXEMP" , cArq ,"E2_ORDPAGO",,,"Indexando registros ..." , .T. )
	
	For j := 1 to Len( aOrdenes )

		cQry1 := " SELECT E2_OK,E2_ORDPAGO,E2_NUM,E2_PREFIXO,E2_TIPO,R_E_C_N_O_ YRECNO"+CRLF
		cQry1 += "   FROM "+RetSQLName('SE2')+CRLF
		cQry1 += "  WHERE E2_FILIAL ='"+xFilial("SE2")+"'"+CRLF
	
		If !Empty(MV_PAR10)
			cQry1 += " AND E2_TIPO IN ("+_cTipos+")"+CRLF
		EndIf
	
		cQry1 += " AND E2_ORDPAGO='" + aOrdenes[j][1] + "'"+CRLF
		cQry1 += " AND E2_FORNECE='" + aOrdenes[j][2] + "'"+CRLF
		cQry1 += " AND E2_LOJA='" + aOrdenes[j][8] + "'"+CRLF
		cQry1 += " AND D_E_L_E_T_ <>'*' "+CRLF  	
	
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry1),"TRB",.T.,.T.) 
		
		cNums := ""
		cTips := ""
		
		If TRB->( !Eof() )
	
			While TRB->( !Eof() )
	    
	    		cNums := cNums + Alltrim(TRB->E2_NUM)+"/"
	    		cTips := cTips + Alltrim(TRB->E2_TIPO)+"/"
	    		TRB->( dbSkip() )
	    		
			End
			
		EndIf
		
		TRB->( DbCloseArea() )
				
		TXEMP->( RecLock("TXEMP",.T.) )
		TXEMP->E2_OK			:= Space(2)
		TXEMP->E2_NUM	 		:= cNums
		TXEMP->E2_TIPO			:= cTips
		TXEMP->E2_FORNECE		:= aOrdenes[j][2]
		TXEMP->E2_LOJA			:= aOrdenes[j][8]
		TXEMP->E2_NOMFOR		:= Posicione("SA2",1,xFilial("SA2")+aOrdenes[j][2]+aOrdenes[j][8],"SA2->A2_NOME")
		TXEMP->E2_ORDPAGO		:= aOrdenes[j][1]
		TXEMP->E2_EMISSAO		:= Stod(aOrdenes[j][4])
		TXEMP->E2_VENCTO		:= Stod(aOrdenes[j][5])
		TXEMP->E2_VALOR			:= aOrdenes[j][3]
		TXEMP->E2_MOEDA			:= aOrdenes[j][6]
		TXEMP->EK_YFLAG			:= aOrdenes[j][7]
		TXEMP->( MsUnLock() )

	Next j
				
	DbSelectArea("TXEMP")
	
	AADD(aRotina,{"Generar TXT","U_EXEC001(1)"		,0,3})
	AADD(aRotina,{"Verif.Totales","U_VerifTot"		,0,3})
	
	AADD(aCpos, "E2_OK" )  
	aCampos := {}
		
	AAdd( aCampos,{ "E2_OK"				,"","",					"@!"			} )
	AAdd( aCampos,{ "E2_ORDPAGO"		,"","Orden Pago",		"@!"			} )	
	AAdd( aCampos,{ "E2_NUM"			,"","Num.Titulo",		"@!"			} )
	AAdd( aCampos,{ "E2_TIPO"			,"","Tipo",				"@!"			} )
	AAdd( aCampos,{ "E2_FORNECE"		,"","Proveedor",		"@!"			} )
	AAdd( aCampos,{ "E2_LOJA"			,"","Tienda",			"@!"			} )
	AAdd( aCampos,{ "E2_NOMFOR"			,"","Nombre Proveedor",	"@!"			} )
	AAdd( aCampos,{ "E2_EMISSAO"		,"","Emision",			"@!"			} )
	AAdd( aCampos,{ "E2_VENCTO"			,"","Vencimiento",		"@!"			} )
	AAdd( aCampos,{ "E2_VALOR"			,"","Valor",			"9,999,999.99"	} )

	MarkBrow("TXEMP",aCpos[1],,aCampos,.F.,cMarcaSE2,"U_Mark01()",,,,'u_Mark02()',,,,aCores)
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTXTBBVA   บAutor  ณMicrosiga           บFecha ณ  12/07/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GETMOEDA(cCuenta)

	Local x_area	:= getArea()
	Local nMoeda	:= 0
	Local cQry2		:= ""
	Local cSQL2		:= GetNextAlias() 

	cQry2 := "SELECT A6_MOEDA "
	cQry2 += "  FROM " + RetSqlName("SA6")
	cQry2 += " WHERE A6_FILIAL='"+xFilial("SA6")+"'" 
	cQry2 += "   AND A6_NUMCON='"+ALLTRIM(cCuenta)+"'"
	cQry2 += "   AND D_E_L_E_T_<>'*'" 
						
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry2),cSQL2,.T.,.T.)
	
	nMoeda := (cSQL2)->A6_MOEDA           
	
	(cSQL2)->( dbCloseArea() )
	
	RestArea( x_area )

Return(nMoeda)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTXTBBVA   บAutor  ณMicrosiga           บFecha ณ  12/07/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Mark01()

	Local aArea  := GetArea()
	Local lMarca := Nil   
	
	TXEMP->( dbGotop() )
	While TXEMP->( !Eof() )
		
		If (lMarca == Nil)
			lMarca := (TXEMP->E2_OK == cMarcaSE2)
		EndIf
		
		TXEMP->( RecLock("TXEMP",.F.) )
		TXEMP->E2_OK := If( lMarca,"",cMarcaSE2 )
		TXEMP->( MsUnLock() )
		TXEMP->( dbSkip() )
		
	EndDo
	
	RestArea(aArea)
	MarkBRefresh()

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTXTBBVA   บAutor  ณMicrosiga           บFecha ณ  12/07/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function EXEC001(_op)

	Local aProdutos	:= {}
	Local cResultado:= ""
	Local cTitulo	:= ""
	Local cProv		:= ""
	Local cDesProv	:= ""
	Local nSaldo	:= ""
	Local cCtAbono	:= ""
	Local cFlag		:= ""
	Local cLoja		:= ""
	Local cSerie	:= ""
	Local cMoeda	:= ""
	
	local cCol01	:= ""
	local aInfCta	:= {}
	local cBcoPad	:= getNewPar("AA_BCOPAD","007")
	local cChqGer	:= getNewPar("AA_CHQPAD","CHQ")
	local nContad	:= 0
	local cNomProv	:= ""
	local cDirProv	:= ""
	local cCidProv	:= ""
	local _cTime	:= Time()
	local _cArq		:= ALLTRIM(MV_PAR11)+"CTB_"+DTOS(dDataBase)+"_"+SUBSTR(_cTime,1,2)+"-"+SUBSTR(_cTime,4,2)+"-"+SUBSTR(_cTime,7,2)+".TXT"
	local _nTotal	:= 0

	handle := FCREATE(_cArq)

	SA2->( dbSetOrder(1) )
	TXEMP->( dbGotop() )

	While TXEMP->( !Eof() )
		
		If !Empty(TXEMP->E2_OK)

			/*
			aAdd( aCuenta, {	(cSQL2)->FIL_BANCO	,;
								(cSQL2)->FIL_AGENCI	,;
								(cSQL2)->FIL_CONTA	,;
								(cSQL2)->FIL_TIPO	,;
								(cSQL2)->FIL_MOEDA	,;
								(cSQL2)->FIL_TIPCTA	;
			*/
				
			if SA2->( dbSeek( xFilial("SA2")+TXEMP->E2_FORNECE+TXEMP->E2_LOJA ) )
				cNomProv := padr(alltrim(SA2->A2_NOME),80)
				cDirProv := padr(alltrim(SA2->A2_END),35)
				cCidProv := padr(alltrim(SA2->A2_MUN),15)
			endif
			
			aInfCta	:= fCtaProv(TXEMP->E2_FORNECE)
			nSaldo	:= alltrim(replace(Transform( TXEMP->E2_VALOR,"@E 9999999999.99" ),".",""))
			nSaldo	:= replicate("0",15-len(nSaldo))+nSaldo
			cTpDePg	:= iif(aInfCta[1][1]==cBcoPad,"072",iif(aInfCta[1][1]==cChqGer,"073","071"))
			
			nContad++
			_nTotal += TXEMP->E2_VALOR
			
			cCol01	:= ""
		    cCol01	:= "PAY"				  																		// 01-tipo de registro
		    cCol01	+= "604"																						// 03-codigo del pais
		    cCol01	+= replicate("0",10-len(alltrim(MV_PAR07)))+alltrim(MV_PAR07)									// 13-cuenta del cliente
		    cCol01	+= right(dtos(TXEMP->E2_VENCTO),6)																// 12-fecha de vencimiento del pago
		    cCol01	+= cTpDePg																						// 08-tipo de pago
			cCol01	+= padr(alltrim(TXEMP->E2_ORDPAGO),15)															// 06-referencia del cliente
			cCol01	+= strzero(nContad,8)																			// 02-secuencial
			cCol01	+= padr(alltrim(TXEMP->E2_FORNECE),20)															// 05-identidad de impuestos
			cCol01	+= iif(aInfCta[1][5]==1,"PEN","USD")															// 10-codigo de la moneda
			cCol01	+= padr(alltrim(TXEMP->E2_FORNECE),20)															// 16-codigo do beneficiario
			cCol01	+= nSaldo																						// 11-monto a pagar
			cCol01	+= space(8)																						// 42-fecha de vencimiento
			cCol01	+= space(35)																					// 44-detalle del pago 1
			cCol01	+= space(35)																					// 45-detalle del pago 2
			cCol01	+= space(35)																					// 46-detalle del pago 3
			cCol01	+= space(35)																					// 47-detalle del pago 4
			cCol01	+= iif(cTpDePg=="073","00","22")																// 09-codigo transaccion local
			cCol01	+= "01"																	 						// 14-tipo de cuenta cliente 1=corr/2=ahorr
			cCol01	+= cNomProv																						// 20-nombre del beneficiario
			cCol01	+= cDirProv																						// 21-direccion del beneficiario l1
			cCol01	+= space(35)																					// 21B-direccion del beneficiario l2
			cCol01	+= cCidProv																						// 22-ciudad del beneficiario
			cCol01	+= space(2)																						// 24-estado del beneficiario
			cCol01	+= replicate("0",12)																			// 23-codigo postal
			cCol01	+= replicate("0",16)																			// 25-telefono del beneficiario
			cCol01	+= iif(aInfCta[1][1]<>cBcoPad,aInfCta[1][1],space(3))											// 26-codigo del banco beneficiario
			cCol01	+= iif(cTpDePg=="071","00000000",space(8))														// 27-agencia del beneficiario
			cCol01	+= iif(aInfCta[1][1]<>cBcoPad,padr(alltrim(aInfCta[1][3]),20),space(35))						// 60-codigo cuenta interbancaria
			cCol01	+= iif(aInfCta[1][6]=="1","01","02")															// 61-tipo cuenta,1=corr/2=ahorros
			cCol01	+= space(30)																					// 28-direccion del banco
			cCol01	+= space(2)																						// 29-entidad del banco
			cCol01	+= space(3)																						// 30-numero agencia del banco
			cCol01	+= space(14)																					// 31-nombre agencia del banco
			cCol01	+= space(3)																						// 32-numero sucursal pais
			cCol01	+= space(19)																					// 33-nombre sucursal pais
			cCol01	+= space(16)																					// 34-numero fax del beneficiario
			cCol01	+= space(20)																					// 35-persona de contacto beneficiario
			cCol01	+= space(15)																					// 36-departamento d beneficiario
			cCol01	+= if(aInfCta[1][1]==cBcoPad,padr(alltrim(aInfCta[1][3]),10),space(10))						// 62-cuemta citibank beneficiario
			cCol01	+= if(aInfCta[1][6]=="1","01","02")															// 63-tipo cuemta citibank beneficiario
			cCol01	+= if(cTpDePg=="071","099",if(cTpDePg=="072","001","004"))										// 19-sucursal de detino - tabla 4
			cCol01	+= space(50)																					// 37-collection title ID
			cCol01	+= space(5)																						// 38-codigo de la actividad beneficia.
			cCol01	+= space(50)																					// 49-e-mail del beneficia.
			cCol01	+= nSaldo																						// 64-valor maximo de pago
			cCol01	+= "2"																							// 65-tipo actualizacion - tabla 3
			cCol01	+= space(11)																					// 93-numero de cheque
			cCol01	+= space(1)																						// 150-chqeu impreso
			cCol01	+= space(1)																						// 151-encaje de pagos
			cCol01	+= space(254)																					// caracteres en blanco
			
			FWRITE(M->handle,cCol01+ENTER)
			
			cCol02	:= ""
			cCol02	+= "VOI"																						// 01-tipo de registro
			cCol02	+= "604"																						// 03-codigo del pais
			cCol02	+= replicate("0",10-len(alltrim(MV_PAR07)))+alltrim(MV_PAR07)									// 13-cuenta del cliente
			cCol02	+= padr(alltrim(TXEMP->E2_ORDPAGO),15)															// 06-referencia del cliente
			cCol02	+= strzero(nContad,8)																			// 02-secuencial
			cCol02	+= strzero(nContad,4)																			// 50-sub-secuencial
			cCol02	+= padr(alltrim(TXEMP->E2_ORDPAGO),80)															// 51-detalle,factura,o.pago
			cCol02	+= space(127)																					// reservado
			
			FWRITE(M->handle,cCol02+ENTER)
		
		endif
			
		TXEMP->( dbSkip() )
		
	End

	cCol03	:= ""
	cCol03	+= "TRL"																								// 01-tipo de registro
	cCol03	+= strzero(nContad,15)																					// 55-cantidad de registros
	cCol03	+= strzero((_nTotal * 100), 15)																		// 56-monto del pago
	cCol03	+= strzero(0,15)																						// 58-cantidad de registros benefici
	cCol03	+= strzero(nContad,15)																					// 59-cantidad de registros PAY-VOI-BEN
	cCol03	+= space(37)																							// reservado
	
	FWRITE(M->handle,cCol03+ENTER)
	
	FCLOSE(M->handle)
	
	If ALLTRIM( cResultado ) <> ""
		cResultado += ENTER + "Verifique antes de generar el archivo ..."
		mensaje(cResultado, "Inconsistencias encontradas ")
	Else
		CONFIRMA(aProdutos,_op)
    EndIf

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTXTBBVA   บAutor  ณMicrosiga           บFecha ณ  12/07/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CONFIRMA( aProds,_op )

	Local nSum		:=	0
	Local nCantidad	:=	0
	Local nChecksum	:=	VAL(MV_PAR03)	//(incluyendo la cuenta de cargo)
	Private nReg	:=	Len(aProds)
	
	For x:=1 to nReg
		nSum		:=	nSum + VAL(aProds[x][4])
   		//nChecksum	:=	nChecksum + VAL(aProds[x][5])
   		nCantidad	++	
	Next x

	If _op==1
		GraTXT(nSum, nCantidad, nChecksum, aProds)
	Else
		GraEXC(nSum, nCantidad, nChecksum, aProds)
	EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTXTBBVA   บAutor  ณMicrosiga           บ Data ณ  12/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GraTXT(nSum, nCantidad, nChecksum, aProds)
	
	Local _cTime	:= Time()
	Local _ARQUIVO	:= ALLTRIM(MV_PAR04)+"BBVA_"+DTOS(dDataBase)+"_"+SUBSTR(_cTime,1,2)+"-"+SUBSTR(_cTime,4,2)+"-"+SUBSTR(_cTime,7,2)+".TXT"
	Local _XARQ		:= "BBVA_"+DTOS(dDataBase)+"_"+SUBSTR(_cTime,1,2)+"-"+SUBSTR(_cTime,4,2)+"-"+SUBSTR(_cTime,7,2)+".TXT"

	If nReg >= 1

		handle := FCREATE(_ARQUIVO)
	
		For x := 1 to nReg
			
			DBSELECTAREA("SA2")
			DBSETORDER(1)
			DBSEEK( xFILIAL("SA2") + Alltrim(aProds[x][2])+Space( TamSX3("A2_COD")[1]-Len( Alltrim(aProds[x][2]) ) ) + aProds[x][7] )
	
			//DETALLE - PROVEEDORES
			
			_Conteudo := "002" 																	// DETALLE
			/*
			If Alltrim(SA2->A2_TIPDOC)=="06"
				_Conteudo += "R"							   									// R=RUC / L=DNI o CE
				_Conteudo += PADR(ALLTRIM(SA2->A2_CGC),12)	   									// NO RUC
			Else
				_Conteudo += "L"							   									// R=RUC / L=DNI o CE
				_Conteudo += PADR(ALLTRIM(SA2->A2_PFISICA),12)									// NO DNI
			EndIf
			*/
			If Alltrim(SA2->A2_TIPO)=="1"	// 1=Juridica; 2=Natural
				_Conteudo += "R"							   									// R=RUC / L=DNI o CE
				_Conteudo += PADR(ALLTRIM(SA2->A2_CGC),12)	   									// NO RUC
			Else
				_Conteudo += "L"							   									// R=RUC / L=DNI o CE
				_Conteudo += PADR(ALLTRIM(SA2->A2_PFISICA),12)									// NO DNI
			EndIf
			
			_Conteudo += "P"							   										// TIPO DE ABONO
			_Conteudo += LEFT(ALLTRIM(aProds[x][5]),20)										// CUENTA ABONO
			_Conteudo += PADR(ALLTRIM(SA2->A2_NOME),40)	   									// BENEFICIARIO
			_Conteudo += STRZERO((VAL(aProds[x][4]) * 100), 15 ) 								// MONTO
			_Conteudo += "F"							   										// TIPO DE RECIBO
			_Conteudo += PADR(aProds[x][1],12)						                   			// NO DOCUMENTO
			_Conteudo += "N"							   										// ABONO AGRUPADO
			_Conteudo += PADR( aProds[x][1] ,40)											    // REFERENCIA
			_Conteudo += "E"							   										// INDICADOR DE AVISO
			_Conteudo += PADR(ALLTRIM(UPPER(SA2->A2_EMAIL)),50)	   							// MAIL (EN MAYUSCULAS)
			_Conteudo += PADR(ALLTRIM(UPPER(SA2->A2_CONTATO)),30)								// CONTACTO (EN MAYUSCULAS)
			_Conteudo += "00000000000000000000000000000000"		 								// 
			_Conteudo += Space(18)
	
	        FWRITE(M->handle,_Conteudo+ENTER)
	        
	        /*
			updateSE2 := "UPDATE "+InitSqlName("SE2")+" "
			updateSE2 += "   SET E2_ENVBCO ='S' "
			updateSE2 += " WHERE E2_FILIAL='"+xFilial("SE2")+"'"
			updateSE2 += "   AND E2_NUM='"+Alltrim(aProds[x][1])+Space(TamSX3("E2_NUM")[1]-Len(Alltrim(aProds[x][1])))+"' "
			updateSE2 += "   AND E2_PREFIXO='"+Alltrim(aProds[x][10])+Space(TamSX3("E2_PREFIXO")[1]-Len(Alltrim(aProds[x][10])))+"' "
			updateSE2 += "   AND E2_TIPO IN ("+_cTipos+")"
			//updateSE2 += "   AND E2_MOEDA="+alltrim(str(GETMOEDA(ALLTRIM(MV_PAR03))))+" "
			updateSE2 += "   AND D_E_L_E_T_=' ' "
			TcSqlExec(updateSE2)
			*/
			updateSE2 := "UPDATE "+InitSqlName("SEK")+" "
			updateSE2 += "   SET EK_YFLAG='S', EK_YARQTXT='"+_XARQ+"'"
			updateSE2 += " WHERE EK_FILIAL='"+xFilial("SEK")+"'"
			updateSE2 += "   AND EK_ORDPAGO='"+aProds[x][11]+"'"
			updateSE2 += "   AND D_E_L_E_T_=' '"
			
			_nExec := TcSqlExec(updateSE2)
			
			If _nExec < 0
				Alert("Error en la gravacion de la tabla SEK!")
			EndIf

			ZZZ->( dbSetOrder(2) )
			If ZZZ->( !( dbSeek( xFilial("ZZZ")+Alltrim(_XARQ)+Space( TamSX3("ZZZ_DESC")[1]-Len( Alltrim(_XARQ) ) ) ) ) )
				ZZZ->( RecLock("ZZZ",.t.) )
				ZZZ->ZZZ_FILIAL	:= xFilial("ZZZ")
				ZZZ->ZZZ_ID		:= xSomaHum("ZZZ")
				ZZZ->ZZZ_SEQ	:= 1
				ZZZ->ZZZ_DESC	:= _XARQ
				ZZZ->ZZZ_OK		:= " "
				ZZZ->( MsUnlock() )
			EndIf
	
		Next x
		
		FCLOSE(M->handle)  

		TXEMP->( dbGotop() )
		While TXEMP->( !Eof() )
				
			TXEMP->( RecLock("TXEMP",.F.) )
			TXEMP->E2_OK := Space(2)
			TXEMP->( MsUnLock() )
			TXEMP->( dbSkip() )
				
		EndDo
	
		Aviso("Aviso","Layout generado con exito... ",{"OK"})
		shellExecute( "Open", "C:\Windows\System32\notepad.exe", _ARQUIVO , "C:\", 1 )
		
	EndIf
		
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTXTBBVA   บAutor  ณMicrosiga           บ Data ณ  12/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC Function Mensaje(cMensaje, ctitulo)

	Local cObserva := cMensaje
	Local oDlgMsj    
	
	define msDialog oDlgMsj title ctitulo from 00,00 to 400,600 pixel
	@ 003,003 GET oObserva VAR cObserva OF oDlgMsj MULTILINE SIZE 280,160 COLORS 0, 16777215 NO VSCROLL PIXEL	 
	@ 180, 250 BUTTON oBtCerrar PROMPT "Cerrar" SIZE 037, 012 OF oDlgMsj ACTION oDlgMsj:End() PIXEL
	ACTIVATE MSDIALOG oDlgMsj CENTERED  

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTXTBBVA   บAutor  ณMicrosiga           บ Data ณ  12/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Mark02()

	If IsMark( 'E2_OK', cMarcaSE2 )
		TXEMP->( RecLock( 'TXEMP', .F. ) )
		TXEMP->E2_OK := Space(2)
		TXEMP->( MsUnLock() )
	Else        
		TXEMP->( RecLock( 'TXEMP', .F. ) )
		TXEMP->E2_OK := cMarcaSE2
		TXEMP->( MsUnLock() )
	EndIf

Return 

User Function VerifTot

	Local cTotales := ""
	Local oDlgMsj
	Local nTotGeneral := 0
	
	For lk := 1 to Len(aTotales)
		
		cTotales := cTotales + "O.P. " + aTotales[lk][1] + " = " + Transform(aTotales[lk][2],"9,999,999.99") + ENTER
		nTotGeneral := nTotGeneral + aTotales[lk][2]
		
	Next lk
	
	cTotales := cTotales + "Total " + Transform(nTotGeneral,"9,999,999.99") + ENTER

	define msDialog oDlgMsj title "Totales - BBVA" from 00,00 to 400,600 pixel
	@ 003,003 GET oObserva VAR cTotales OF oDlgMsj MULTILINE SIZE 280,160 COLORS 0, 16777215 NO VSCROLL PIXEL	 
	@ 180, 250 BUTTON oBtCerrar PROMPT "Cerrar" SIZE 037, 012 OF oDlgMsj ACTION oDlgMsj:End() PIXEL
	ACTIVATE MSDIALOG oDlgMsj CENTERED  

Return

Static Function xSomaHum( _cTable )

	Local nNextCode := 1
	Local _cQry := ""
	Local _cAlias := getNextAlias()
	
	_cQry := "SELECT MAX(ZZZ_ID) AS XCODE"
	_cQry += "  FROM " + RetSqlName("ZZZ")
	_cQry += " WHERE ZZZ_FILIAL='" + xFilial("ZZZ") + "'"
	_cQry += "   AND D_E_L_E_T_=' '"
		
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cAlias,.T.,.T.) 
					
	If (_cAlias)->(XCODE) <= 0
		nNextCode := 1
	Else
		nNextCode := (_cAlias)->(XCODE) + 1
	EndIf

	(_cAlias)->( dbCloseArea() )

Return( nNextCode )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTHFIN01  บAutor  ณMicrosiga           บ Data ณ  08/16/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fTipPago(cCta, cProve)
	
	Local cQry1		:= ""
	Local cSQL2		:= GetNextAlias()
	Local cTipoCta	:= "0"
	
	cQry1 := "SELECT * "
	cQry1 += "  FROM " + RetSqlName( "FIL" ) + " "	
	cQry1 += " WHERE FIL_FILIAL='"+xFilial("FIL")+"' " 
	cQry1 += "   AND FIL_FORNEC='"+ALLTRIM(cProve)+"' " 
	cQry1 += "   AND FIL_CONTA='"+ALLTRIM(cCta)+"' "		//SELECCIONAR LA PRINCIPAL 
	cQry1 += "   AND D_E_L_E_T_<>'*' " 
				    
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry1),cSQL2,.T.,.T.)
	
	DO CASE
		CASE ALLTRIM((cSQL2)->FIL_BANCO) == "INT"
		//CASE ALLTRIM((cSQL2)->FIL_TIPCTA) == "3"	// INTERBANCARIA
			cTipoCta	:=	" "
		OTHERWISE
			cTipoCta	:=	"X"	
	END DO
	
	(cSQL2)->(Dbclosearea())
	
Return(cTipoCta)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTHFIN01  บAutor  ณMicrosiga           บ Data ณ  08/16/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fCtaProv(_cProv)
	
	Local cQry1		:= ""
	Local cSQL2		:= GetNextAlias() 
	Local aCuenta	:= {}
	
	cQry1 := "SELECT FIL_BANCO,FIL_AGENCI,FIL_CONTA,FIL_TIPO,FIL_MOEDA,FIL_TIPCTA"
	cQry1 += "  FROM " + RetSqlName("FIL")
	cQry1 += " WHERE FIL_FILIAL='"+xFilial("FIL")+"'" 
	cQry1 += "   AND FIL_FORNEC='"+_cProv+"'" 
	cQry1 += "   AND FIL_TIPO='1'"							//SELECCIONAR LA PRINCIPAL 
	cQry1 += "   AND D_E_L_E_T_<>'*'" 
				    
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry1),cSQL2,.T.,.T.)
	
	If (cSQL2)->( !Eof() )
		aAdd( aCuenta, {	(cSQL2)->FIL_BANCO	,;
							(cSQL2)->FIL_AGENCI	,;
							(cSQL2)->FIL_CONTA	,;
							(cSQL2)->FIL_TIPO	,;
							(cSQL2)->FIL_MOEDA	,;
							(cSQL2)->FIL_TIPCTA	;
						} )
	Endif
	
	(cSQL2)->(Dbclosearea())
	
Return(aCuenta)
