
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCT105QRY  บAutor  ณPercy Arias,SISTHEL บ Data ณ  01/14/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CT105QRY()

	Local xArea:= GetArea()
	local xSql := PARAMIXB[1]
	local lSql := PARAMIXB[2]
	
	local a2Totais	:={}
	local nValDeb:= 0
	Local nValCrd:= 0                        
	Local cSimMon:= Posicione("CTO",1,xFilial("CTO")+"02","CTO_SIMB")
	Local cEtiqCar:= "Tot Cargo "+cSimMon
	Local cEtiqDeb:= "Tot Abono "+cSimMon
	Local aSize := MsAdvSize( .F. )
	Local __cContaDebi := SuperGetMV("MV_CTBREDD",.F.,"")	//"471406000011"
	Local __cContaCred := SuperGetMV("MV_CTBREDC",.F.,"")  //"101214010001"
    Local _lDifSol := .T. 
    Local _lDifSo2 := .T. 
    Local _nRes  := 0
    Local _nRes2 := 0 
    Local _nTipo := 0
    Local nLimDifTit := SuperGetMv("MV_LIMDIFT" ,.F.,0.20)  
    Local _aTotUS := {}		// add por sisthel - 25-03-2018

	Private oDebUSD,oCredUSD
    Private __cCcdebCre := SuperGetMV("MV_CTBCCDC",.F.,"")  //"101214010001"
    Private __cItdebCre := SuperGetMV("MV_CTBITDC",.F.,"")  //"101214010001"    
    Private __cCvdebCre := SuperGetMV("MV_CTBCVDC",.F.,"")  //"101214010001"    
    
    If Alltrim(FUNNAME())=="FINA088"		// Anular Cobros Diversos
		__cContaDebi := SuperGetMV("MV_2CTBRED",.F.,"")
		__cContaCred := SuperGetMV("MV_2CTBREC",.F.,"")
    EndIf
    
    If Alltrim(FUNNAME())=="FINA086"		// Anular Orden de Pago
		__cContaDebi := SuperGetMV("MV_2CTBRED",.F.,"")
		__cContaCred := SuperGetMV("MV_2CTBREC",.F.,"")
    EndIf
    
    If Alltrim(FUNNAME())=="MATA101N"		// Anular Factura de Entrada
    	If __nOpcx==5
			__cContaDebi := SuperGetMV("MV_2CTBRED",.F.,"")
			__cContaCred := SuperGetMV("MV_2CTBREC",.F.,"")
		EndIf
    EndIf

    If Alltrim(FUNNAME())=="MATA466N"		// Anular Factura de Entrada
    	If __nOpcx==5
			__cContaDebi := SuperGetMV("MV_2CTBRED",.F.,"")
			__cContaCred := SuperGetMV("MV_2CTBREC",.F.,"")
		EndIf
    EndIf

    If Alltrim(FUNNAME())=="MATA467N"		// Anular Factura de Salida
    	If __nOpcx==5
			__cContaDebi := SuperGetMV("MV_2CTBRED",.F.,"")
			__cContaCred := SuperGetMV("MV_2CTBREC",.F.,"")
		EndIf
    EndIf

    If Alltrim(FUNNAME())=="MATA465N"		// Anular Factura de Entrada
    	If __nOpcx==5
			__cContaDebi := SuperGetMV("MV_2CTBRED",.F.,"")
			__cContaCred := SuperGetMV("MV_2CTBREC",.F.,"")
		EndIf
    EndIf

	If Empty(cSimMon)
		cSimMon:= ""
	Endif
	
    _nTipo := 1

		_nRes := U_NEOFUN10(1,"999")
	  
		If _nRes < 0
			fGeneraCTK( Abs(_nRes), __cContaDebi,1 , _nTipo )
		Else
			fGeneraCTK( Abs(_nRes), __cContaCred,2 , _nTipo )
		EndIf                         
		
		if !lSql	
			xSql := Substr( xSql,1,at("ORDER",xSql)-2) + " ORDER BY CTK_LP, CTK_LPSEQ, CTK_FILIAL,CTK_SEQUEN, CTK_TABORI, CTK_RECORI, R_E_C_N_O_"
		endif
		//xSql := Substr( xSql,1,at("ORDER",xSql)-2) + " ORDER BY CTK_LP, CTKLPLPSEQ, CTK_FILIAL,CTK_SEQUEN, CTK_TABORI, CTK_RECORI, R_E_C_N_O_"
	
	RestArea(xArea)
		
Return( xSql )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCT105QRY  บAutor  ณMicrosiga           บ Data ณ  01/14/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGeneraCTK( _nVal, _cCuenta, _nX , _cTipSal )

	local _aArea		:= getArea()
	local _nSequen		:= CTK->CTK_SEQUEN
	local _ckEY 		:= CTK->CTK_KEY
	local __cTipo		:= CTK->CTK_DC
	local __cCtaDebito	:= CTK->CTK_DEBITO
	local __cCtaCredito	:= CTK->CTK_CREDIT
	local __nValor		:= CTK->CTK_VLR01
	local _nRecOri 		:= CTK->CTK_RECORI
	local _cSLote		:= CTK->CTK_SBLOTE
	local _cTabOri		:= CTK->CTK_TABORI
	local _cLote		:= CTK->CTK_LOTE
	local _cDiaCTB		:= CTK->CTK_DIACTB
	local _cMtSld		:= CTK->CTK_MLTSLD
	local _cMonedas		:= CTK->CTK_MOEDAS
	local _cInterc		:= CTK->CTK_INTERC
	local _cContab		:= CTK->CTK_CONTAB
	local _cxRutina		:= CTK->CTK_ROTINA
	
	CTK->( RecLock("CTK",.T.) )
	CTK->CTK_FILIAL		:= xFilial("CTK")
	CTK->CTK_CODCLI		:= ""
	CTK->CTK_CODFOR		:= ""
	CTK->CTK_SEQUEN		:= _nSequen
	if _nX==2
		CTK->CTK_DC			:= "2"
		CTK->CTK_DEBITO		:= space(TamSx3("CTK_DEBITO")[1])
		CTK->CTK_CREDIT		:= _cCuenta
	else
		CTK->CTK_DC			:= "1"
		CTK->CTK_DEBITO		:= _cCuenta
		CTK->CTK_CREDIT		:= space(TamSx3("CTK_CREDIT")[1])
	endif
	CTK->CTK_VLR01		:= _nVal
	//CTK->CTK_VLR02		:= _nVal		//xMoeda( _nVal, 1,2, dDataBase, 2,  )
	CTK->CTK_MOEDAS		:= _cMonedas
	CTK->CTK_HIST		:= "AJUSTE POR REDONDEO SOLES"
	CTK->CTK_INTERC		:= _cInterc
	CTK->CTK_LP			:= SuperGetMV("AA_LPREDON",.F.,"999")
	CTK->CTK_LPSEQ		:= "999"
	CTK->CTK_ORIGEM		:= "999-999"
	CTK->CTK_CONTAB		:= _cContab
	CTK->CTK_KEY 		:= _ckEY
	CTK->CTK_ROTINA		:= _cxRutina
	CTK->CTK_TPSALD		:= alltrim(Str(_cTipSal))
	CTK->CTK_SBLOTE		:= _cSLote
	CTK->CTK_DATA		:= DDATABASE
	CTK->CTK_TABORI		:= _cTabOri
	CTK->CTK_LOTE		:= _cLote
	CTK->CTK_RECORI		:= _nRecOri
	CTK->CTK_HAGLUT		:= "AJUSTE POR REDONDEO SOLES"
	CTK->CTK_DIACTB		:= _cDiaCTB
	CTK->CTK_MLTSLD		:= _cMtSld
	CTK->( MsUnlock() )
	
	//U_yIncluiLcto( CTK->CTK_DEBITO,CTK->CTK_CREDIT,Strzero( TMP->( Reccount() )+1,3 ),dDataBase,_cLote,_cSLote,"",_nVal)
	
/*
	if _nX==1		// debito, genera partida doble
	
		CTK->( RecLock("CTK",.T.) )
		CTK->CTK_FILIAL		:= xFilial("CTK")
		CTK->CTK_CODCLI		:= ""
		CTK->CTK_CODFOR		:= ""
		CTK->CTK_SEQUEN		:= _nSequen
		CTK->CTK_DC			:= "3"
		CTK->CTK_DEBITO		:= SuperGetMV("MV_CTBDSTD",.F.,"8888888888")
		CTK->CTK_CREDIT		:= SuperGetMV("MV_CTBDSTC",.F.,"9999999999")
		CTK->CTK_VLR01		:= _nVal
		CTK->CTK_MOEDAS		:= _cMonedas
		CTK->CTK_HIST		:= "AJUSTE POR REDONDEO SOLES"
		CTK->CTK_INTERC		:= _cInterc
		CTK->CTK_LP			:= "999"
		CTK->CTK_LPSEQ		:= "999"
		CTK->CTK_ORIGEM		:= "AJUSTE POR REDONDEO SOLES"
		CTK->CTK_CONTAB		:= _cContab
		CTK->CTK_KEY 		:= _ckEY
		CTK->CTK_ROTINA		:= _cxRutina
		CTK->CTK_TPSALD		:= alltrim(Str(_cTipSal))
		CTK->CTK_SBLOTE		:= _cSLote
		CTK->CTK_DATA		:= DDATABASE
		CTK->CTK_TABORI		:= _cTabOri
		CTK->CTK_LOTE		:= _cLote
		CTK->CTK_RECORI		:= _nRecOri
		CTK->CTK_HAGLUT		:= "AJUSTE POR REDONDEO SOLES"
		CTK->CTK_DIACTB		:= _cDiaCTB
		CTK->CTK_MLTSLD		:= _cMtSld
		CTK->( MsUnlock() )
		
	endif
*/	
	Restarea(_aArea)

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCT105QRY  บAutor  ณMicrosiga           บ Data ณ  01/28/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function yIncluiLcto(__cContaDebi,__cContaCred,__cLinha,dDat_aLct,_cLote,_cSLote,_cDocum,_nVal)

	Local __dData			:= dDat_aLct	//CT2->CT2_DATA
	Local __cLote			:= _cLote		//CT2->CT2_LOTE
	Local __cSubLote		:= _cSLote		//CT2->CT2_SBLOTE
	Local __cDoc			:= _cDocum		//CT2->CT2_DOC
	//Local __cLinha			:= CT2->CT2_LINHA
	Local __cFilOri			:= TMP->CT2_FILORI
	Local __cEmpOri			:= TMP->CT2_EMPORI
	Local __cTipo			:= Iif(Empty(__cContaDebi),"2","1")	//CT2->CT2_DC
	Local __cDebito			:= __cContaDebi	//CT2->CT2_DEBITO
	Local __cCredito		:= __cContaCred	//CT2->CT2_CREDIT
	Local __cMoeda			:= TMP->CT2_MOEDLC
	Local __nValor			:= _nVal		//TMP->CT2_VALOR
	Local __cHistPad		:= TMP->CT2_HP
	Local __cCustoDeb		:= Iif(Empty(__cContaDebi)," ",__cCcdebCre)//TMP->CT2_CCD
	Local __cCustoCrd		    := Iif(Empty(__cContaCred)," ",__cCcdebCre)//TMP->CT2_CCC
	Local __cItemDeb		    :=  Iif(Empty(__cContaDebi)," ",__cItdebCre) //TMP->CT2_ITEMD
	Local __cItemCrd		    :=  Iif(Empty(__cContaCred)," ",__cItdebCre)//TMP->CT2_ITEMC
	Local __cClVlDeb		    :=  Iif(Empty(__cContaDebi)," ",__cCvdebCre)//TMP->CT2_CLVLDB
	Local __cClVlCrd		    :=  Iif(Empty(__cContaCred)," ",__cCvdebCre)//TMP->CT2_CLVLCR
	Local __cDescricao		:= TMP->CT2_HIST
	Local __nContaLinhas	:= TMP->CT2_SEQHIST
	Local __cTpSald			:= TMP->CT2_TPSALD
	Local __cSeqLan			:= TMP->CT2_SEQLAN
	Local __cRotina			:= TMP->CT2_ROTINA
	Local __dDataLP			:= TMP->CT2_DTLP
	//Local __cSeqCorr		:= _cSeqCorr	// Space(TamSx3("CT2_NODIA")[1])
	//Local __cCodSeq			:= CtbRdia()
	Local __dDataTX			:= TMP->CT2_DATATX
	Local __cCtaDebito		:= __cContaDebi	//ZZ4->ZZ4_CONTA
	Local __cCtaCredito		:= __cContaCred	//__cConta
	
	//__cSeqCorr := CTBSQCor( "" ,__cCodSeq, __dData )
	//__cSeqCorr := CTBSQGrv( __cSeqCorr, __dData ) 
	
	//FreeUsedCode()  //libera codigos de correlativos reservados pela MayIUseCode()
	
	if __nValor > 0

		TMP->( RecLock("TMP",.t.) )
	
		TMP->CT2_FILIAL		:= xFilial("CT2")
		TMP->CT2_DATA		:= __dData
		TMP->CT2_LOTE		:= __cLote
		TMP->CT2_SBLOTE		:= __cSubLote
		TMP->CT2_DOC		:= __cDoc
		TMP->CT2_LINHA		:= Strzero(Val(__cLinha),3)
		TMP->CT2_FILORI		:= __cFilOri
		TMP->CT2_EMPORI		:= __cEmpOri
		TMP->CT2_DC			:= __cTipo
		TMP->CT2_DEBITO		:= __cCtaDebito
		TMP->CT2_CREDIT		:= __cCtaCredito
		TMP->CT2_MOEDLC		:= __cMoeda
		TMP->CT2_VALOR		:= __nValor
		TMP->CT2_VALR02		:= xMoeda( __nValor, 1,2, dDataBase, 2,  )
		TMP->CT2_HP			:= __cHistPad
		TMP->CT2_CCD		:= __cCustoDeb
		TMP->CT2_CCC		:= __cCustoCrd
		TMP->CT2_ITEMD		:= __cItemDeb
		TMP->CT2_ITEMC		:= __cItemCrd
		TMP->CT2_CLVLDB		:= __cClVlDeb
		TMP->CT2_CLVLCR		:= __cClVlCrd
	  //	TMP->CT2_HIST		:= __cDescricao
		TMP->CT2_SEQHIST	:= __nContaLinhas
		TMP->CT2_TPSALD		:= __cTpSald
		TMP->CT2_SEQLAN		:= __cSeqLan
		TMP->CT2_ROTINA		:= __cRotina			// Indica qual o programa gerador
		TMP->CT2_MANUAL		:= "1"				// Lancamento manual
		TMP->CT2_AGLUT		:= "2"				// Nao aglutina      
		TMP->CT2_INTERC		:= "1"
		TMP->CT2_DTLP		:= __dDataLP
		//TMP->CT2_DIACTB		:= __cCodSeq
		TMP->CT2_ATIVDE		:= _cDocum
		TMP->CT2_HIST		:= "AJUSTE POR REDONDEO SOLES"
		TMP->CT2_CONVER		:= "14"
		TMP->CT2_ORIGEM		:= "999-999"
		
		If CtbUso("CT2_DCD")
			If cDCD = Nil
				If CT2->CT2_DC $ "13"
					CT1->( MsSeek(xFilial() + __cDebito ))
					cDCD := CT1->CT1_DC
				Else
					cDCD := ""
				EndIf
			EndIf
			TMP->CT2_DCD := cDCD
		EndIf
		
		If CtbUso("CT2_DCC")
			If cDCC = Nil
				If CT2->CT2_DC $ "23"
					CT1->( MsSeek(xFilial() + __cCredito ))
					cDCC := CT1->CT1_DC
				Else
					cDCD := ""
				EndIf
			EndIf
			TMP->CT2_DCC := cDCC
		EndIf
		
		//TMP->CT2_SEGOFI	:= __cSeqCorr
		//TMP->CT2_NODIA 	:= __cSeqCorr
		
		If TMP->CT2_VALOR = 0 
			TMP->CT2_CRCONV := "5"
		Else
			TMP->CT2_CRCONV	:= "1"				
		EndIf
	
		TMP->CT2_DATATX	:= __dDataTX
		TMP->CT2_CTLSLD	:= "0"
		
		TMP->( MsUnlock() )
		
		TMP->( dbGotop() )
		
	endif
		
Return(.t.)
