#INCLUDE 'protheus.ch'
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FONT.CH"
#INCLUDE "M486XMLPDF.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALRFAT08  ºAutor  ³Microsiga           º Data ³  12/14/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impresion de la DANFE o comprobante del documento          º±±
±±º          ³ electronico.                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ALRFAT08( cEspecie )

	Private cSerie := ""
	Private cDocIni := ""
	Private cDocFin := ""
	Private cFormato := ""
	//Private cPath := &(SuperGetmv( "MV_CFDDOCS" , .F. , "'cfd\recibos\'" )) + "\Autorizados\"
	//Private cPath := &(SuperGetmv( "MV_CFDDOCS" , .F. , "'sunat\'" ))
	Private cPath := getNewPar( "MV_CFDDOCS" ,"sunat\" )
	Private oXML   := Nil
	Private nTotPag := 0
	Private oFont1 := TFont():New( "ARIAL", , 7, .F., .F.)
	Private oFont2 := TFont():New( "ARIAL", , 8, .F., .F.) 
	Private oFont3 := TFont():New( "ARIAL", , 10, .T., .T.)
	Private oFont4 := TFont():New( "ARIAL", , 8, .F., .T.) //Negrita - 8
	Private oFont5 := TFont():New( "ARIAL", , 12, .F., .T.) //Negrita - 12
	Private olFont10 := TFont():New("Calibri", ,7,.T.,.F.,5,.T.,5,.T.,.F.)
	Private nLinea	:= 0
	Private cPicture := "999,999,999.99"
	
	Default cEspecie := "NF "
	
	//cPath := Replace( cPath, "\\", "\" )

	cSerie := MV_PAR01
	cDocIni := MV_PAR02
	cDocFin := MV_PAR03
	cFormato := MV_PAR04

	Processa({|| ImpXmlPDF(cEspecie)},"Espere ...", "Generando impresión de documento autorizado")
	
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpXmlPDF  ³ Autor ³ Luis Enriquez         ³ Data ³ 06.07.17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Llamado de funciones para impresión de reporte PDF (PERU).   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpXmlPDF(cEspecie)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cEspecie .- Especie del documento.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ No aplica.                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ M486XMLPDF                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpXmlPDF(cEspecie)

	Local cCampos := ""
	Local cTablas := ""
	Local cCond   := ""
	Local cOrder  := ""
	// Local aFiles := {}
	Local nI     := 0
	// Local cAviso			:= ""
	// Local cErro			:= ""		
	Local oPrinter 
	// Local cFile := ""
	Local cFileGen := ""
	Local nDec := 0
	Local aItens := {}
	Local aFileAux := {}
	Local cFileAux := ""
	Local cEmailCli := ""	
	// Local cImpTot := ""
	Local aOpcDoc := {}
	Local lImpRef := .F.
	Local nRegProc := 0
	Local nRegEnv := 0	
	Local lEnvOK := .F.
	Local cCRLF	 := (chr(13)+chr(10))
	Local _xAlias := getNextAlias()

	Private _aDocOrig := {}
	Private cLetFac := ""
	Private cSubject := ""
	Private cLetPie := ""
	Private cBody := ""
	Private cTpoDocSA1 := ""
	Private aDoc := {}	
	Private nRef := 0
	Private cAliasPDF := getNextAlias()
	
	If alltrim(cEspecie) $ "NF|NDC"		
		cCampos  := "% SF2.F2_FILIAL, SF2.F2_SERIE SERIE, SF2.F2_DOC DOCUMENTO, SF2.F2_ESPECIE ESPECIE, SF2.F2_CLIENTE CLIENTE, SF2.F2_LOJA LOJA, SF2.F2_SERIE2, SF2.F2_TPDOC TPDOC, SF2.F2_YHASH HASH, SF2.R_E_C_N_O_ NREC %" //, SF2.F2_FLFTEXT   %"
		cTablas  := "% " + RetSqlName("SF2") + " SF2 %"
		cCond    := "% SF2.F2_SERIE = '"  + cSerie + "'"
		cCond    += " AND SF2.F2_DOC >= '"  + cDocIni + "'"
		cCond    += " AND SF2.F2_DOC <= '"  + cDocFin + "'"
		cCond    += " AND SF2.F2_ESPECIE = '"  + cEspecie + "'"
		//cCond    += " AND SF2.F2_FLFTEX = '6'"
		//cCond    += " AND SF2.F2_YHASH <> ' '"
		cCond	 += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"
		cCond	 += " AND SF2.D_E_L_E_T_  = ' ' %"
		cOrder := "% SF2.F2_FILIAL, SF2.F2_SERIE, SF2.F2_DOC %"
	ElseIf alltrim(cEspecie) $ "NCC"
		cCampos  := "% SF1.F1_FILIAL, SF1.F1_SERIE SERIE, SF1.F1_DOC DOCUMENTO, SF1.F1_ESPECIE ESPECIE, SF1.F1_FORNECE CLIENTE, SF1.F1_LOJA LOJA, SF1.F1_SERIE2, SF1.F1_TPDOC TPDOC, SF1.F1_YHASH HASH, SF1.R_E_C_N_O_ NREC %" //, SF2.F2_FLFTEXT   %"
		cTablas  := "% " + RetSqlName("SF1") + " SF1 %"
		cCond    := "% SF1.F1_SERIE = '"  + cSerie + "'"
		cCond    += " AND SF1.F1_DOC >= '"  + cDocIni + "'"
		cCond    += " AND SF1.F1_DOC <= '"  + cDocFin + "'"
		cCond    += " AND SF1.F1_ESPECIE = '"  + cEspecie + "'"
		//cCond    += " AND SF1.F1_FLFTEX = '6'"
		//cCond    += " AND SF1.F1_YHASH <> ' '"
		cCond	 += " AND SF1.F1_FILIAL = '" + xFilial("SF1") + "'"
		cCond	 += " AND SF1.D_E_L_E_T_  = ' ' %"
		cOrder := "% SF1.F1_FILIAL, SF1.F1_SERIE, SF1.F1_DOC %"				
	EndIf		
		
	BeginSql alias cAliasPDF
		SELECT %exp:cCampos%
		FROM  %exp:cTablas%
		WHERE %exp:cCond%
		ORDER BY %exp:cOrder%
	EndSql
	
	Count to nRegProc
	
	dbSelectArea(cAliasPDF)

	(cAliasPDF)->(DbGoTop())

	While (cAliasPDF)->(!Eof())

		If alltrim((cAliasPDF)->ESPECIE) $ "NF|NDC"
			SF2->( dbGoto( (cAliasPDF)->NREC) )
		ElseIf alltrim((cAliasPDF)->ESPECIE) $ "NCC"
			SF1->( dbGoto( (cAliasPDF)->NREC) )
		EndIf
		
		if empty((cAliasPDF)->HASH)
			if !fChkHash(u_PuxaSer2((cAliasPDF)->SERIE),(cAliasPDF)->DOCUMENTO,(cAliasPDF)->TPDOC)
				nRegProc := 0
				exit 
			endif
		endif
	
		If alltrim(cEspecie) $ "NF|NDC"

			cQry := "SELECT COUNT(*) NCONT" 
			cQry += "  FROM " + RetSqlName("SD2")
			cQry += " WHERE D2_DOC='" + (cAliasPDF)->DOCUMENTO + "'"
			cQry += "   AND D2_SERIE='" + (cAliasPDF)->SERIE + "'"
			cQry += "   AND D2_CLIENTE='" + (cAliasPDF)->CLIENTE + "'"
			cQry += "   AND D_E_L_E_T_=' '" 
			cQry += " GROUP BY D2_DOC,D2_SERIE"
		
		else

			cQry := "SELECT COUNT(*) NCONT" 
			cQry += "  FROM " + RetSqlName("SD1")
			cQry += " WHERE D1_DOC='" + (cAliasPDF)->DOCUMENTO + "'"
			cQry += "   AND D1_SERIE='" + (cAliasPDF)->SERIE + "'"
			cQry += "   AND D1_FORNECE='" + (cAliasPDF)->CLIENTE + "'"
			cQry += "   AND D_E_L_E_T_=' '" 
			cQry += " GROUP BY D1_DOC,D1_SERIE"
		
		Endif

		DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQry),_xAlias, .F., .T.)
			
		nTotPag := (_xAlias)->NCONT
		
		(_xAlias)->( dbCloseArea() )
	
		If alltrim(cEspecie) $ "NF|NDC"
			SA1->( MsSeek( xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA ) )
		else
			SA1->( MsSeek( xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA ) )
		endif

		cFileGen := RTRIM((cAliasPDF)->SERIE) + RTRIM((cAliasPDF)->DOCUMENTO) + RTRIM((cAliasPDF)->ESPECIE)
		oPrinter := FWMSPrinter():New(cFileGen,6,.F.,GetClientDir(),.T.,,,,,.F.)

		If alltrim((cAliasPDF)->ESPECIE) $ "NF|NDC"
			If alltrim((cAliasPDF)->ESPECIE) == "NF"
				//cTpoDocSA1 := DescSX5('TB',SA1->A1_TIPDOC)
				cTpoDocSA1 := SA1->A1_TIPDOC
				aDoc := { SF2->F2_SERIE2,SF2->F2_DOC }
				//aOpcDoc := {"_CAC_INVOICELINE","_CBC_INVOICEDQUANTITY","_CAC_LEGALMONETARYTOTAL"}
				//nTotPag := IIf(ValType(oXml:_CAC_INVOICELINE) == "A",Len(oXml:_CAC_INVOICELINE) / 63, 1)						
				nTotPag := round(nTotPag / 12,1)
				If Alltrim((cAliasPDF)->ESPECIE) == "NF" .AND. Substr(aDoc[1],1,1) $ 'F' // Factura
					//cSubject:= "FACTURA ELECTRONICA "+(cAliasPDF)->F2_SERIE2+"-"+(cAliasPDF)->DOCUMENTO+"-Referencia: "+PedidoRef( (cAliasPDF)->DOCUMENTO,(cAliasPDF)->SERIE )
					cSubject:= "FACTURA ELECTRONICA "+(cAliasPDF)->F2_SERIE2+"-"+alltrim((cAliasPDF)->DOCUMENTO)+" | ANDERS ZIEDEK WERNER HANS"
					cLetFac := "FACTURA ELECTRÓNICA"
					cLetPie := "Representación impresa de la FACTURA ELECTRÓNICA"
					cBody := xMsgBody()
				ElseIf Alltrim(cEspecie) == "NF" .AND. Substr(aDoc[1],1,1) $ 'B' //.AND. cTpoDocSA1 # "06" // Boleta de Venta
					//cSubject:= "BOLETA ELECTRONICA "+(cAliasPDF)->F2_SERIE2+"-"+(cAliasPDF)->DOCUMENTO+"-Referencia: "+PedidoRef( (cAliasPDF)->DOCUMENTO,(cAliasPDF)->SERIE )
					cSubject:= "BOLETA ELECTRONICA "+(cAliasPDF)->F2_SERIE2+"-"+alltrim((cAliasPDF)->DOCUMENTO)+" | ANDERS ZIEDEK WERNER HANS"
					cLetFac := "BOLETA ELECTRÓNICA"
					cLetPie := "Representación impresa de la BOLETA ELECTRÓNICA"
					cBody := xMsgBody()
				EndIf	
				lImpRef := .F.					
			ElseIf alltrim((cAliasPDF)->ESPECIE) == "NDC"		
				/*
				oXML    := oXml:_DEBITNOTE
				aOpcDoc := {"_CAC_DEBITNOTELINE","_CBC_DEBITEDQUANTITY","_CAC_REQUESTEDMONETARYTOTAL"}
				nRef    := IIf(ValType(oXml:_CAC_DISCREPANCYRESPONSE) == "A",Len(oXml:_CAC_DISCREPANCYRESPONSE),1)
				nTotPag := IIf(ValType(oXml:_CAC_DEBITNOTELINE) == "A",(Len(oXml:_CAC_DEBITNOTELINE) + nRef) / 63, 1)
					
				cSubject:= "NOTA DE DEBITO ELECTRONICA "+(cAliasPDF)->F2_SERIE2+"-"+(cAliasPDF)->DOCUMENTO+"-Referencia: "+PedidoRef( (cAliasPDF)->DOCUMENTO,(cAliasPDF)->SERIE )
				cLetFac := "NOTA DE DÉBITO ELECTRÓNICA"
				cLetPie := ""
				cLetPie := "Representación impresa de la NOTA DE DÉBITO ELECTRÓNICA"
				cBody := xMsgBody()
				lImpRef := .T.
				*/
			EndIf													
		ElseIf alltrim((cAliasPDF)->ESPECIE) $ "NCC"
			/*
			oXML := oXml:_CREDITNOTE
			nRef    := IIf(ValType(oXml:_CAC_DISCREPANCYRESPONSE) == "A",Len(oXml:_CAC_DISCREPANCYRESPONSE),1)
			nTotPag := IIf(ValType(oXml:_CAC_CREDITNOTELINE) == "A",(Len(oXml:_CAC_CREDITNOTELINE) + nRef) / 63, 1)				
			aOpcDoc := {"_CAC_CREDITNOTELINE","_CBC_CREDITEDQUANTITY","_CAC_LEGALMONETARYTOTAL"}
			cSubject:= "NOTA DE CREDITO ELECTRONICA "+(cAliasPDF)->SERIE+"-"+(cAliasPDF)->DOCUMENTO
			cLetFac  := STR0003 //"NOTA DE CRÉDITO ELECTRÓNICA"
			cLetPie := STR0031  //"Representación impresa de la NOTA DE CRÉDITO ELECTRÓNICA"
			cBody := xMsgBody()
			lImpRef := .T.
			*/
			cTpoDocSA1 := SA1->A1_TIPDOC
			aDoc := { SF1->F1_SERIE2,SF1->F1_DOC }
			nTotPag := round(nTotPag / 12,1)
			//cSubject:= "NOTA DE CREDITO ELECTRONICA "+(cAliasPDF)->SERIE+"-"+(cAliasPDF)->DOCUMENTO+"-Referencia: "+PedidoRef( (cAliasPDF)->DOCUMENTO,(cAliasPDF)->SERIE )
			cSubject:= "NOTA DE CREDITO ELECTRONICA "+(cAliasPDF)->F1_SERIE2+"-"+alltrim((cAliasPDF)->DOCUMENTO)+" | ANDERS ZIEDEK WERNER HANS"
			cLetFac := "NOTA DE CRÉDITO ELECTRÓNICA"
			cLetPie := "Representación impresa de la NOTA DE CRÉDITO ELECTRÓNICA"
			lImpRef := .T.
			_aDocOrig := u_xGetNFOrig(SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA)
		EndIf
			
		nDec := nTotPag - Int(nTotPag)
		If nDec > 0
			nTotPag := Int(nTotPag) + 1
		EndIf	
						
		oPrinter:setDevice(IMP_PDF)
		oPrinter:SetLandscape()
		oPrinter:setPaperSize(9)
		oPrinter:cPathPDF := GetClientDir() 
		oPrinter:StartPage() 
		ImpEnc(oPrinter)           //Encabezado
		DetFact(oPrinter)  //Detalle
		If lImpRef
			ImpRef(oPrinter,oXml,_aDocOrig)       //Referencia
		EndIf
		ImpPie(oPrinter,oXML,aOpcDoc)           //Pie 			     
		oPrinter:EndPage()			
			
		oPrinter:Print()
			
		cFileAux := GetClientDir()  + cFileGen +".pdf"
		CpyT2S(cFileAux, cPath)
								
		If cFormato == 2 

			If Right(Alltrim(mv_par06),1)="\"
				If alltrim((cAliasPDF)->ESPECIE) $ "NCC"
					cArqOrig := Alltrim(mv_par06)+"xml_zip_base64-"+lower(Alltrim(SF1->F1_SERIE))+"-"+Alltrim(SF1->F1_DOC)+".zip"
				else
					cArqOrig := Alltrim(mv_par06)+"xml_zip_base64-"+lower(Alltrim(SF2->F2_SERIE))+"-"+Alltrim(SF2->F2_DOC)+".zip"
				endif
			else
				If alltrim((cAliasPDF)->ESPECIE) $ "NCC"
					cArqOrig := Alltrim(mv_par06)+"\xml_zip_base64-"+lower(Alltrim(SF1->F1_SERIE))+"-"+Alltrim(SF1->F1_DOC)+".zip"
				else
					cArqOrig := Alltrim(mv_par06)+"\xml_zip_base64-"+lower(Alltrim(SF2->F2_SERIE))+"-"+Alltrim(SF2->F2_DOC)+".zip"
				endif
			endif
		
			aFileAux := {}
			aItens := {}
			aAdd( aItens, cPath + cFileGen + ".pdf" ) 
			if CpyT2S(cArqOrig, cPath )
				If alltrim((cAliasPDF)->ESPECIE) $ "NCC"
					aAdd( aItens,cPath + "xml_zip_base64-"+lower(Alltrim(SF1->F1_SERIE))+"-"+Alltrim(SF1->F1_DOC)+".zip" )
				else
					aAdd( aItens,cPath + "xml_zip_base64-"+lower(Alltrim(SF2->F2_SERIE))+"-"+Alltrim(SF2->F2_DOC)+".zip" )
				endif
			endif
			FZip(cPath + cFileGen + ".zip",aItens, cPath )
			aAdd(aFileAux, StrTran( upper(cPath + cFileGen + ".zip"), upper(GetSrvProfString('rootpath','')))) 	 	
			cEmailCli := ObtEmail((cAliasPDF)->CLIENTE,(cAliasPDF)->LOJA) 
			lEnvOK := EnvioMail(cEmailCli,aFileAux)	
			If lEnvOK
				nRegEnv += 1
			EndIf
			For nI := 1 To Len(aFileAux)
				FErase(aFileAux[nI])
			Next nI				
		EndIf				

		FreeObj(oPrinter)
		oPrinter := Nil	

		(cAliasPDF)->(dbskip())
	EndDo	
	
	//If Len(aFiles) == 0
	//	APMSGINFO(STR0036, STR0037) //"No se localizaron archivos XML autorizados, para generacion de reporte." "Aviso" 
	//Else
		APMSGINFO(STR0043 + cCRLF + ; //"Generación Representación Impresa Finalizada"
				  STR0044 + Str(nRegProc) + cCRLF + ; //"Registros procesados: "
		          STR0045 + Str(nRegEnv) , STR0037) //"Registros enviados: "
	//EndIf 
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpEnc     ³ Autor ³ Luis Enriquez         ³ Data ³ 06.07.17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime encabezado de factura a partir de XML (PERU).        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpEnc(oPrinter,oXml)                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oPrinter .- Objeto creado por FWMSPrinter.                   ³±±
±±³          ³ oXml .- Objeto con estructura de archivo XML.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ No aplica.                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ M486XMLPDF                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpEnc(oPrinter)

	Local oBrush
	Local cFileLogo	:= ""
	//Local cRUCEmi  := "R.U.C. N° "+Alltrim(SM0->M0_CGC)
	Local cRUCEmi  := "R.U.C. N° 10077763851"
	Local cNoDoc   := "N° " + If(alltrim((cAliasPDF)->ESPECIE)$"NF|NDC",SF2->F2_SERIE2+"-"+SF2->F2_DOC,SF1->F1_SERIE2+"-"+SF1->F1_DOC)
	Local cNomEmi  := ""
	Local cDirEmi  := Alltrim(SM0->M0_ENDCOB)
	Local cCiuEmi  := Alltrim(SM0->M0_CIDCOB)
	Local cDistEmi := Alltrim(SM0->M0_BAIRCOB)
	Local cNomRec  := alltrim(SA1->A1_NOME)
	Local cDirRec  := ""
	Local cRUCRec  := Iif(empty(SA1->A1_CGC),SA1->A1_PFISICA,SA1->A1_CGC)
	Local cMonXML  := If(alltrim((cAliasPDF)->ESPECIE)$"NF|NDC",if(SF2->F2_MOEDA==1,"PEN","USD"),if(SF1->F1_MOEDA==1,"PEN","USD"))
	Local cMonAux  := If(alltrim((cAliasPDF)->ESPECIE)$"NF|NDC",str(SF2->F2_MOEDA),str(SF1->F1_MOEDA))
	Local cMonLetra := ""
	Local cPagina := Alltrim(Str(oPrinter:nPageCount)) + "/" + Alltrim(Str(nTotPag))
	
	//cNomEmi := Alltrim(SM0->M0_NOME)
	cNomEmi := "ANDERS ZIEDEK WERNER HANS"
	cDirRec1 :=	alltrim(SA1->A1_END)+" "+alltrim(SA1->A1_YNRODIR)
	cDirRec2 :=	alltrim(SA1->A1_MUN)+" "+alltrim(SA1->A1_BAIRRO)

	If !Empty(GetMV("MV_MOEDA"+AllTrim(cMonAux)))
		if AllTrim(cMonAux)=="2"
			cMonLetra := "DOLARES AMERICANOS"
		else
			cMonLetra := GetMV("MV_MOEDA" + AllTrim(cMonAux))
		endif
	EndIf 		
    
	// oPrinter:Box( 25, 630, 95, 830, "-4")
	oPrinter:Box( 25, 630, 95, 830, "-4")
	
	cFileLogo := CargaLogo()
	
	nLinea := 10
	If File(cFilelogo)
		oPrinter:SayBitmap(nLinea+10,20,cFileLogo,80,80) // Impresion de logotipo
	EndIf
	nLinea += 40
	oPrinter:SayAlign(nLinea-17,140,cNomEmi,oFont5,160,5,CLR_BLACK, 0, 2 )
	oPrinter:SayAlign(nLinea-7,140,upper(alltrim(cDirEmi))+" "+upper(alltrim(SM0->M0_COMPENT)),oFont5,160,5,CLR_BLACK, 0, 2 )
	nLinea += 10
	oPrinter:SayAlign(nLinea-7,140,alltrim(cDistEmi)+" - "+alltrim(cCiuEmi)+" - LIMA - PERU",oFont5,160,5,CLR_BLACK, 0, 2 )
	nLinea += 10
	
	//oPrinter:SayAlign(nLinea+5,15,cNomEmi,oFont3,160,5,CLR_BLACK, 0, 2 )
	//oPrinter:SayAlign(nLinea-7,140,alltrim(cCiuEmi)+" - LIMA - PERU",oFont3,160,5,CLR_BLACK, 0, 2 )
	
	oPrinter:SayAlign(30,660,cRUCEmi,oFont3,160,5,CLR_BLACK, 2, 2 ) //R.U.C. EMISOR
	oPrinter:SayAlign(50,660,cLetFac,oFont3,160,5,CLR_BLACK, 2, 2 ) //FACTURACION ELECTRONICA
	oPrinter:SayAlign(70,660,cNoDoc,oFont3,160,5,CLR_BLACK, 2, 2 )  //NO. FACTURA
	
	nLinea += 50
	oPrinter:Say(nLinea,15,"Cliente",oFont4)
	oPrinter:Say(nLinea,60,":",oFont4)
	oPrinter:Say(nLinea,65,cNomRec,oFont4)
	
	oPrinter:Say(nLinea,500,"Fecha emisión",oFont4)
	oPrinter:Say(nLinea,570,":",oFont4)
	oPrinter:Say(nLinea,575,replace(dtoc(If(alltrim((cAliasPDF)->ESPECIE)$"NF|NDC",SF2->F2_EMISSAO,SF1->F1_EMISSAO)),"/","-"),oFont4)

	nLinea += 10
	oPrinter:Say(nLinea,15,"Dirección",oFont4)
	oPrinter:Say(nLinea,60,":",oFont4)
	oPrinter:Say(nLinea,65,cDirRec1,oFont4)

	oPrinter:Say(nLinea,500,"Fecha vencimiento",oFont4)
	oPrinter:Say(nLinea,570,":",oFont4)
	If alltrim((cAliasPDF)->ESPECIE)$"NF|NDC"
		oPrinter:Say(nLinea,575,u_getUltCuota(.f.,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA),oFont4)
	else
		oPrinter:Say(nLinea,575,u_getUltCuota(.t.,SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA),oFont4)
	endif


	nLinea += 10
	oPrinter:Say(nLinea,65,cDirRec2,oFont4)

	oPrinter:Say(nLinea,500,"Tipo de moneda",oFont4)
	oPrinter:Say(nLinea,570,":",oFont4)
	oPrinter:Say(nLinea,575,cMonLetra,oFont4)

	nLinea += 10
	//oPrinter:Say(nLinea,15,"R.U.C.",oFont4)
	oPrinter:Say(nLinea,15,Iif(empty(SA1->A1_CGC),"DNI","R.U.C."),oFont4)
	oPrinter:Say(nLinea,60,":",oFont4)
	oPrinter:Say(nLinea,65,cRUCRec,oFont4)

	If alltrim((cAliasPDF)->ESPECIE)$"NF|NDC"
		oPrinter:Say(nLinea,500,"N° Pedido",oFont4)
		oPrinter:Say(nLinea,570,":",oFont4)
		oPrinter:Say(nLinea,575,SF2->F2_YCOD,oFont4)
	endif

	nLinea += 10

	oPrinter:Say(nLinea,15,"Cond.Pago",oFont4)
	oPrinter:Say(nLinea,60,":",oFont4)
	If alltrim((cAliasPDF)->ESPECIE)$"NF|NDC"
		cCondPago := SF2->F2_COND
	else
		cCondPago := SF1->F1_COND
	endif
	oPrinter:Say(nLinea,65,Alltrim(Posicione("SE4",1,xFilial("SE4")+cCondPago,"E4_DESCRI")),oFont4)

	If alltrim((cAliasPDF)->ESPECIE)$"NF|NDC"
		SD2->( dbSetOrder(3) )		// D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_COD, D2_ITEM, R_E_C_N_O_, D_E_L_E_T_
		If SD2->( dbSeek( xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA ) )
			_ajguias := {}
			hguias := ""
			while SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA==SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA .AND. SD2->( !Eof() )
				nnk := aScan( _ajguias, alltrim(SD2->D2_SERIREM)+"-"+alltrim(SD2->D2_REMITO) )
				if nnk <= 0
					Aadd( _ajguias, alltrim(SD2->D2_SERIREM)+"-"+alltrim(SD2->D2_REMITO) )
					hguias += alltrim(SD2->D2_SERIREM)+"-"+alltrim(SD2->D2_REMITO) + " / "
				endif
				SD2->( dbSkip() )
			end
			
			if !empty(hguias)
				hguias := substr(hguias,1,len(hguias)-2)
			endif
		
			oPrinter:Say(nLinea,500,"Guia Remision",oFont4)
			oPrinter:Say(nLinea,570,":",oFont4)	
			oPrinter:Say(nLinea,575,hguias	/*alltrim(SD2->D2_SERIREM)+" "+alltrim(SD2->D2_REMITO)*/,oFont4)
			oPrinter:Say(nLinea,750,"Página:",oFont4)
			oPrinter:Say(nLinea,800,cPagina,oFont4)
		else
			oPrinter:Say(nLinea,500,"Página",oFont4)
			oPrinter:Say(nLinea,570,":",oFont4)	
			oPrinter:Say(nLinea,575,cPagina,oFont4)
		endif
	else
		oPrinter:Say(nLinea,500,"Página",oFont4)
		oPrinter:Say(nLinea,570,":",oFont4)	
		oPrinter:Say(nLinea,575,cPagina,oFont4)
	endif
	//Cuadro gris 3 (Encabezado detalle)
	oBrush := TBrush():New( , CLR_LIGHTGRAY )  
    // oPrinter:FillRect( {155, 10, 170, 830}, oBrush )
    oPrinter:FillRect( {170, 10, 185, 830}, oBrush )
    
    //Lineas de marco gris
    // oPrinter:Line(155,10,155,830,,"-4")    
    // oPrinter:Line(170,10,170,830,,"-4")
    oPrinter:Line(170,10,170,830,,"-4")    
    oPrinter:Line(185,10,185,830,,"-4")
       
    nLinea += 18
	oPrinter:Say(nLinea,15,"CANTIDAD",oFont4)
	oPrinter:Say(nLinea,70,"UNIDAD",oFont4)
	oPrinter:Say(nLinea,110,"DESCRIPCIÓN DEL PRODUCTO",oFont4)
	//oPrinter:Say(nLinea,200,"",oFont4)
	//oPrinter:Say(nLinea,340,"PRECIO UNITARIO",oFont4)
	//oPrinter:Say(nLinea,430,"VALOR UNITARIO",oFont4)
	//oPrinter:Say(nLinea,530,"TOTAL",oFont4)
	oPrinter:Say(nLinea,720,"PRC.UNIT.",oFont4)
	oPrinter:Say(nLinea,790,"TOTAL",oFont4)
	
	// nLinea := 170
	nLinea := 180
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ DetFact    ³ Autor ³ Luis Enriquez         ³ Data ³ 06.07.17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime detalle de factura a partir de XML (PERU).           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ DetFact(oPrinter,oXml)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oPrinter .- objeto creado por FWMSPrinter.                   ³±±
±±³          ³ oXml .- Objeto con estructura de archivo XML.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ No aplica.                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ M486XMLPDF                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function DetFact(oPrinter)

	// Local cArqTrb	:= getNextAlias()
	Local cAlias	:= getNextAlias()
	Local cMonXML	:= If(alltrim((cAliasPDF)->ESPECIE)$"NF|NDC",if(SF2->F2_MOEDA==1,"PEN","USD"),if(SF1->F1_MOEDA==1,"PEN","USD"))
	Local nX		:= 1
	
	cMonXML := ALLTRIM(cMonXML)

	If alltrim((cAliasPDF)->ESPECIE)$"NF|NDC"
		cQry := "SELECT D2_DOC DDOC,D2_SERIE DSERIE,D2_PEDIDO DPEDIDO,D2_COD DCOD,D2_UM DUM,D2_ITEM DITEM,D2_PRCVEN DPRCVEN,D2_ITEMPV DITEMPV," 
		cQry += "  SUM(D2_QUANT) DQUANT,SUM(D2_TOTAL) DTOTAL,SUM(D2_BASIMP1) DBASIMP1, SUM(D2_VALIMP1) DVALIMP1,SUM(D2_VALIMP4) DVALIMP4" 
		cQry += "  FROM " + RetSqlName("SD2")
		cQry += " WHERE D2_DOC='" + SF2->F2_DOC + "'"
		cQry += "   AND D2_SERIE='" + SF2->F2_SERIE + "'"
		cQry += "   AND D2_CLIENTE='" + SF2->F2_CLIENTE + "'"
		cQry += "   AND D_E_L_E_T_=' '" 
		cQry += " GROUP BY D2_DOC,D2_SERIE,D2_PEDIDO,D2_COD,D2_UM,D2_ITEM,D2_PRCVEN,D2_ITEMPV"
		cQry += " ORDER BY D2_ITEMPV"
	else
		cQry := "SELECT D1_DOC DDOC,D1_SERIE DSERIE,D1_PEDIDO DPEDIDO,D1_COD DCOD,D1_UM DUM,D1_ITEM DITEM,D1_VUNIT DPRCVEN,D1_ITEMPV DITEMPV," 
		cQry += "  SUM(D1_QUANT) DQUANT,SUM(D1_TOTAL) DTOTAL,SUM(D1_BASIMP1) DBASIMP1, SUM(D1_VALIMP1) DVALIMP1,SUM(D1_VALIMP4) DVALIMP4" 
		cQry += "  FROM " + RetSqlName("SD1")
		cQry += " WHERE D1_DOC='" + SF1->F1_DOC + "'"
		cQry += "   AND D1_SERIE='" + SF1->F1_SERIE + "'"
		cQry += "   AND D1_FORNECE='" + SF1->F1_FORNECE + "'"
		cQry += "   AND D_E_L_E_T_=' '" 
		cQry += " GROUP BY D1_DOC,D1_SERIE,D1_PEDIDO,D1_COD,D1_UM,D1_ITEM,D1_VUNIT,D1_ITEMPV"
		cQry += " ORDER BY D1_ITEMPV"
	endif
	
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQry),cAlias, .F., .T.)  
		
	While (cAlias)->(!Eof())
		
		SC6->( dbSetOrder(2) )
		//SC6->( MsSeek( xFilial("SC6")+(cAlias)->D2_PEDIDO+(cAlias)->D2_ITEMPV ) )
		//SC6->( MsSeek( xFilial("SC6")+(cAlias)->DPEDIDO+(cAlias)->DITEMPV ) )
		SC6->( MsSeek( xFilial("SC6")+(cAlias)->DCOD+(cAlias)->DPEDIDO ) )		// C6_FILIAL, C6_PRODUTO, C6_NUM, C6_ITEM, R_E_C_N_O_, D_E_L_E_T_
	
 		If nLinea >=540
			SaltoPag(oPrinter,oXml)
		EndIf
		
		_aMemo := {}
		_cMemo := ""
		_cMemo := SC6->C6_YSTRUCT
		_cMemo := replace( _cMemo,":"," " )
		_cMemo := replace( _cMemo,"-",": " )
		_aMemo := StrTokArr( _cMemo , ";" )
		
		If Empty(_cMemo)

			nLinea += 5
			oPrinter:SayAlign(nLinea,10,TRANSFORM((cAlias)->DQUANT,"999,999,999.999"),oFont2,45,10,CLR_BLACK, 1, 2 )		//CANTIDAD
			oPrinter:SayAlign(nLinea,70,alltrim(Posicione("SAH",1,xFilial("SAH")+(cAlias)->DUM,"AH_YUMFE")),oFont2,27,10,CLR_BLACK, 2, 0 )								//UNIDAD
			oPrinter:SayAlign(nLinea,110,alltrim((cAlias)->DCOD)+" - "+Alltrim(Posicione("SB1",1,XFILIAL("SB1")+(cAlias)->DCOD,"B1_DESC")),oFont2,400,10,CLR_BLACK, 0, 0 )							//CÓDIGO DEL PRODUCTO
			//oPrinter:SayAlign(nLinea,200,Alltrim(Posicione("SB1",1,XFILIAL("SB1")+(cAlias)->DCOD,"B1_DESC")),oFont2,130,10,CLR_BLACK, 0, 0 )							//DESCRIPCIÓN
			oPrinter:SayAlign(nLinea,690,TRANSFORM((cAlias)->DPRCVEN,cPicture),oFont2,58,10,CLR_BLACK, 1, 0 ) //PRECIO UNITARIO
			oPrinter:SayAlign(nLinea,760,TRANSFORM((cAlias)->DTOTAL,cPicture),oFont2,58,10,CLR_BLACK, 1, 0 ) //TOTAL 
			
		else

			_aItns	:= {}
			_aItm	:= {}
			_cItm	:= ""
			xLin	:= 0
			nLinea	+= 10

			if len(_aMemo) > 0
				for nX := 1 to len(_aMemo)
					_cItm := _aMemo[nX]
					_aItm := StrTokArr( _cItm, "|" )
					Aadd(_aItns,_aItm)
				next nX
			endif

			aSort( _aItns,1,, { |x, y| x[1] < y[1] } )

			if len(_aItns) > 0
				nlCol := 110
				for nX := 1 to len(_aItns)
					nlCol += 110
					if nlCol > 600
						xLin += 10
						nlCol := 110
					endif
				next nX
				xLin += 10
			endif
			
			if (nLinea+xLin)>=540
				SaltoPag(oPrinter,oXml)
			endif

			oPrinter:SayAlign(nLinea,10,TRANSFORM((cAlias)->DQUANT,"999,999,999.999"),oFont2,45,10,CLR_BLACK, 1, 2 )		//CANTIDAD
			oPrinter:SayAlign(nLinea,70,alltrim(Posicione("SAH",1,xFilial("SAH")+(cAlias)->DUM,"AH_YUMFE")),oFont2,27,10,CLR_BLACK, 2, 0 )								//UNIDAD
			//oPrinter:SayAlign(nLinea,110,(cAlias)->D2_COD,oFont2,73,10,CLR_BLACK, 0, 0 )							//CÓDIGO DEL PRODUCTO
			oPrinter:SayAlign(nLinea,110,Alltrim(Posicione("ZZD",1,XFILIAL("ZZD")+SC6->C6_YCODF,"ZZD_DESCRI")),oFont2,130,10,CLR_BLACK, 0, 0 )							//DESCRIPCIÓN
			//oPrinter:SayAlign(nLinea,690,TRANSFORM((cAlias)->DBASIMP1+(cAlias)->DVALIMP1,cPicture),oFont2,58,10,CLR_BLACK, 1, 0 ) //PRECIO UNITARIO
			//oPrinter:SayAlign(nLinea,428,TRANSFORM((cAlias)->D2_BASIMP1,cPicture),oFont2,58,10,CLR_BLACK, 1, 0 ) //VALOR UNITARIO
			//oPrinter:SayAlign(nLinea,760,TRANSFORM((cAlias)->DTOTAL,cPicture),oFont2,58,10,CLR_BLACK, 1, 0 ) //TOTAL 
			oPrinter:SayAlign(nLinea,690,TRANSFORM((cAlias)->DPRCVEN,cPicture),oFont2,58,10,CLR_BLACK, 1, 0 ) //PRECIO UNITARIO
			oPrinter:SayAlign(nLinea,760,TRANSFORM((cAlias)->DTOTAL,cPicture),oFont2,58,10,CLR_BLACK, 1, 0 ) //TOTAL 
			
			nLinea	+= 10

			if len(_aItns) > 0
				nlCol := 110
				for nX := 1 to len(_aItns)
					oPrinter:SayAlign(nLinea,nlCol,Alltrim(_aItns[nX][2]),olFont10,130,10,CLR_BLACK, 0, 0 )							//DESCRIPCIÓN
					nlCol += 110
					if nlCol > 600
						nLinea +=10
						nlCol := 110
					endif
				next nX
			endif
	
		EndIf						  

		nLinea += 10

		(cAlias)->( dbSkip() )

	End
	
	//oPrinter:Line(nLinea,10,nLinea,830,,"-4")  //Linea final detalle
	/*
	oPrinter:Line(155,10,nLinea,10,,"-4")    //Linea 1
	oPrinter:Line(155,60,nLinea,60,,"-4")    //Linea 2
	oPrinter:Line(155,105,nLinea,105,,"-4")  //Linea 3
	oPrinter:Line(155,190,nLinea,190,,"-4")  //Linea 4
	oPrinter:Line(155,700,nLinea,700,,"-4")  //Linea 5
	oPrinter:Line(155,760,nLinea,760,,"-4")  //Linea 6
	oPrinter:Line(155,830,nLinea,830,,"-4")  //Linea 7
	*/
	
	
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpRef     ³ Autor ³ Luis Enriquez         ³ Data ³ 10.07.17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime docs de referencia para notas de debito/credito(PERU)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpRef(oPrinter,oXml)                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oPrinter .- objeto creado por FWMSPrinter.                   ³±±
±±³          ³ oXml .- Objeto con estructura de archivo XML.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ No aplica.                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ M486XMLPDF                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpRef(oPrinter,oXml)
	Local cTipoDoc := ""
	
	If nLinea > 815
 		SaltoPag(oPrinter,oXml)
	EndIf
	
	nLinea += 10
	
	oPrinter:Box(nLinea + (nRef * 10), 10, nLinea, 580, "-4")
	oPrinter:SayAlign(nLinea,20,"TIPO DOCUMENTO",oFont4,100,5,CLR_BLACK, 0, 2 ) //"TIPO DOCUMENTO"
	oPrinter:SayAlign(nLinea,130,"N° DOCUMENTO REF.",oFont4,100,5,CLR_BLACK, 0, 2 ) //"N° DOCUMENTO REF."
	oPrinter:SayAlign(nLinea,240,"MOTIVO DE EMISION",oFont4,100,5,CLR_BLACK, 0, 2 ) //"MOTIVO REFERENCIA"
	
	oPrinter:Line(nLinea,105,nLinea + 10,105,,"-4")  
	oPrinter:Line(nLinea,230,nLinea + 10,230,,"-4")  
	
	nLinea += 10		
	oPrinter:Line(nLinea,10,nLinea + 10,10,,"-4")
	oPrinter:Line(nLinea,105,nLinea + 10,105,,"-4")  
	oPrinter:Line(nLinea,230,nLinea + 10,230,,"-4")
	oPrinter:Line(nLinea,580,nLinea + 10,580,,"-4")
	
	//If oXml:_CAC_BILLINGREFERENCE:_CAC_INVOICEDOCUMENTREFERENCE:_CBC_DOCUMENTTYPECODE:TEXT == '01'
	If cTipoDoc == '01'
		cTipoDoc := "FACTURA"
	//ElseIf oXml:_CAC_BILLINGREFERENCE:_CAC_INVOICEDOCUMENTREFERENCE:_CBC_DOCUMENTTYPECODE:TEXT== "03"//oXml:_CAC_BILLINGREFERENCE:_CBC_DOCUMENTTYPECODE:TEXT == '03'
	ElseIf cTipoDoc == '03'
		cTipoDoc := "BOLETA"
	EndIf
	oPrinter:SayAlign(nLinea,20,iif(left(alltrim(_aDocOrig[1][3]),1)=="F","01","03"),oFont2,70,5,CLR_BLACK, 2, 2 )
	oPrinter:SayAlign(nLinea,110,alltrim(_aDocOrig[1][3] + "-" + _aDocOrig[1][1]),oFont2,110,5,CLR_BLACK, 2, 2 )
	oPrinter:SayAlign(nLinea,240,alltrim(SF1->F1_MOTIVO),oFont2,150,5,CLR_BLACK, 0, 2 )
	
	nLinea += 10
	oPrinter:Line(nLinea,10,nLinea,580,,"-4")  //Linea final detalle
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpPie     ³ Autor ³ Luis Enriquez         ³ Data ³ 06.07.17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprimir pie de reporte de factura a partir de XML (PERU).   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpPie(oPrinter,oXml,cCodBar)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oPrinter .- objeto creado por FWMSPrinter.                   ³±±
±±³          ³ oXml .- Objeto con estructura de archivo XML.                ³±±
±±³          ³ cCodBar .- String de texto para código de barra.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ No aplica.                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ M486XMLPDF                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpPie(oPrinter,oXml,aOpcDoc)	

	Local cMontoStr := ""
	Local nI := 0
	Local aAdic := {}
	Local nPos := 0
	Local cCodBarra := ""
	Local cMonXML  := ""

	If alltrim((cAliasPDF)->ESPECIE)$"NF|NDC"
		cMonXML := if(SF2->F2_MOEDA==1,"PEN","USD")
	else
		cMonXML := if(SF1->F1_MOEDA==1,"PEN","USD")
	endif

	FR3->( dbSetOrder(1) )
	
	cMonXML := ALLTRIM(cMonXML)
	
	If alltrim((cAliasPDF)->ESPECIE)$"NF|NDC"
		if FR3->( dbSeek( xFilial("FR3")+"R"+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_YCOD ) )
			cMontoStr := "IMPORTE EN LETRAS: " + Extenso(SF2->F2_VALFAT,.f.,SF2->F2_MOEDA,,"2",.t.,.t.)
		else
			cMontoStr := "IMPORTE EN LETRAS: " + Extenso(SF2->F2_VALMERC,.f.,SF2->F2_MOEDA,,"2",.t.,.t.)
		endif

		cCodBarra := alltrim(SF2->F2_YQR) 	// GenCodBar(oXml,aOpcDoc)

	else
		cMontoStr := "IMPORTE EN LETRAS: " + Extenso(SF1->F1_VALMERC,.f.,SF1->F1_MOEDA,,"2",.t.,.t.)
	endif

	if At("AMERICA",cMontoStr)<=0
		cMontoStr := alltrim(cMontoStr)+" AMERICANOS"
	endif
	
	If alltrim((cAliasPDF)->ESPECIE)$"NF|NDC"
		if FR3->( dbSeek( xFilial("FR3")+"R"+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_YCOD ) )
			nLinea := 520
		else
			nLinea := 525
		Endif
	else
		nLinea := 525
	endif

	oPrinter:Line(nLinea,10,nLinea,830,,"-4")
	//oPrinter:Box( nLinea + 115, 330, nLinea, 580, "-4")
	nLinea += 20

	If alltrim((cAliasPDF)->ESPECIE)$"NF|NDC"
	
		if FR3->( dbSeek( xFilial("FR3")+"R"+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_YCOD ) )
			oPrinter:Say(nLinea,050,"ANTICIPO (-):   "+cMonXML+" "+TRANSFORM(SF2->F2_VALFAT,cPicture),oFont5)
			oPrinter:Say(nLinea,220,"OPERACIÓN GRAVADA:   "+cMonXML+" "+TRANSFORM(SF2->F2_BASIMP1,cPicture),oFont5)
			oPrinter:Say(nLinea,480,"I.G.V. (18%):   "+cMonXML+" "+TRANSFORM(SF2->F2_VALIMP1,cPicture),oFont5)
			//oPrinter:Say(nLinea,650,"IMPORTE TOTAL:   "+cMonXML+" "+TRANSFORM(SF2->F2_VALMERC,cPicture),oFont5)		
			oPrinter:Say(nLinea,650,"IMPORTE TOTAL:   "+cMonXML+" "+TRANSFORM(0,cPicture),oFont5)		
		else
			oPrinter:Say(nLinea,100,"OPERACIÓN GRAVADA:   "+cMonXML+" "+TRANSFORM(SF2->F2_BASIMP1,cPicture),oFont5)
			oPrinter:Say(nLinea,350,"I.G.V. (18%):   "+cMonXML+" "+TRANSFORM(SF2->F2_VALIMP1,cPicture),oFont5)
			oPrinter:Say(nLinea,600,"IMPORTE TOTAL:   "+cMonXML+" "+TRANSFORM(SF2->F2_VALMERC,cPicture),oFont5)	
		endif 
	
	else

		oPrinter:Say(nLinea,100,"OPERACIÓN GRAVADA:   "+cMonXML+" "+TRANSFORM(SF1->F1_BASIMP1,cPicture),oFont5)
		oPrinter:Say(nLinea,350,"I.G.V. (18%):   "+cMonXML+" "+TRANSFORM(SF1->F1_VALIMP1,cPicture),oFont5)
		oPrinter:Say(nLinea,600,"IMPORTE TOTAL:   "+cMonXML+" "+TRANSFORM(SF1->F1_VALMERC,cPicture),oFont5)	

	endif

	nLinea += 5
	oPrinter:SayAlign(nLinea,10,cMontoStr,oFont5,830,10,CLR_BLACK, 2, 0 )

	If alltrim((cAliasPDF)->ESPECIE)$"NF|NDC"
		if FR3->( dbSeek( xFilial("FR3")+"R"+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_YCOD ) )
			nLinea += 10
			oPrinter:SayAlign(nLinea,10,"COMPENSACION DE ANTICIPO REF. AL DOC: "+Alltrim( u_PuxaSer2( FR3->FR3_PREFIX ) )+" "+right(alltrim(FR3->FR3_NUM),7),oFont5,830,10,CLR_BLACK, 2, 0 )
		endif
	endif
	
	nLinea += 15
	oPrinter:Line(nLinea,10,nLinea,830,,"-4")
	oPrinter:SayAlign(nLinea,10,cLetPie+". Podrá ser consultada en www.nubefact.com/10077763851",oFont4,830,10,CLR_BLACK, 2, 0 )  //"Representación impresa de FACTURA ELECTRÓNICA/NOTA DE DÉBITO ELECTRÓNICA/NOTA DE CRÉDITO ELECTRÓNICA"
	nLinea += 10
	oPrinter:SayAlign(nLinea,10,"Autorizado mediante Resolución de Intendencia N° 034-005-0005315",oFont4,830,10,CLR_BLACK, 2, 0 )
	nLinea += 10
	If alltrim((cAliasPDF)->ESPECIE)$"NF|NDC"
		oPrinter:SayAlign(nLinea,10,"Resumen: "+alltrim(SF2->F2_YHASH),oFont4,830,10,CLR_BLACK, 2, 0 )
	else
		oPrinter:SayAlign(nLinea,10,"Resumen: "+alltrim(SF1->F1_YHASH),oFont4,830,10,CLR_BLACK, 2, 0 )
	endif
	

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ EnvioMail  ³ Autor ³ Luis Enriquez         ³ Data ³ 06.07.17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Carga logo de la empresa (PERU).                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ EnvioMail(cEmailC, aAnexo)                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cEmailC .- Email del cliente para envio de archivo XML/PDF.  ³±±
±±³          ³ aAnexo .- Arreglo con archivos adjuntos.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ lResult .- Valor lógico .T. envio exitoso, .F. error de envio³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ M486XMLPDF                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function EnvioMail(cEmailC, aAnexo)

	Local lResult := .F.
	//Local cServer	:= GetMV( "MV_RELSERV",,"" ) //Nombre de servidor de envio de E-mail utilizado en los informes.
	Local cEmail	:= GetMV( "MV_RELACNT",,"" ) //Cuenta a ser utilizada en el envio de E-Mail para los informes
	//Local cPassword	:= GetMV( "MV_RELPSW",,""  ) //Contrasena de cta. de E-mail para enviar informes
	Local cAttach  := aAnexo[1]
	Local nI := 0

	//For nI:= 1 to Len(aAnexo)
	//	cAttach += aAnexo[nI] + "; "
	//Next nI	

	/*
	CONNECT SMTP SERVER cServer ACCOUNT cEmail PASSWORD cPassword RESULT lResult

	If lResult .And. !Empty(cEmailC)
		For nI:= 1 to Len(aAnexo)
			cAttach += aAnexo[nI] + "; "
		Next nI	
		SEND MAIL FROM cEmail ;
		TO      	alltrim(cEmailC);
		BCC     	"";
		SUBJECT 	cSubject;
		BODY    	cBody;
		ATTACHMENT  cAttach  ;
		RESULT lResult
		DISCONNECT SMTP SERVER
	EndIf
	*/
	
	lResult := u_FBEMail(	alltrim(cEmailC)	,;	// Para
							cSubject			,;	// Assunto
							cBody				,;	// Corpo do E-mail
							cAttach				,;	// Anexo
							""					,;	// E-mail en copia
							cEmail				;	// E-mail de envio (del usuario logado)
				) 

Return lResult

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fCarLogo   ³ Autor ³ Luis Enriquez         ³ Data ³ 06.07.17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Carga logo de la empresa (PERU).                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CargaLogo()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ No aplica.                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ cLogo .- Retorna url de ubicación de logo de empresa.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ M486XMLPDF                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CargaLogo()
	Local  cStartPath:= GetSrvProfString("Startpath","")

	//cLogo	:= cStartPath + "ADMIN	"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP" // Empresa+Filial
	cLogo	:= cStartPath + "\lgmid02.png" // Empresa+Filial
	//-- Logotipo da Empresa
	/*
	If !File( cLogo )
		cLogo := cStartPath + "LGRL"+SM0->M0_CODIGO+".BMP" // Empresa
	EndIf
	*/
Return cLogo

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ SaltoPag   ³ Autor ³ Luis Enriquez         ³ Data ³ 06.07.17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Genera salto de página en reporte (PERU).                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ SaltoPag(oPrinter)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oPrinter .- objeto creado por FWMSPrinter.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ No aplica.                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ M486XMLPDF                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SaltoPag(oPrinter)	
	
	/*
	oPrinter:Line(175,10,nLinea,10,,"-4")  //Linea 1
	oPrinter:Line(175,60,nLinea,60,,"-4")  //Linea 2
	oPrinter:Line(175,105,nLinea,105,,"-4")  //Linea 3
	oPrinter:Line(175,190,nLinea,190,,"-4")  //Linea 4
	oPrinter:Line(175,330,nLinea,330,,"-4")  //Linea 5
	oPrinter:Line(175,415,nLinea,415,,"-4")  //Linea 6
	oPrinter:Line(175,505,nLinea,505,,"-4")  //Linea 7
	oPrinter:Line(175,580,nLinea,580,,"-4")  //Linea 8
	
	oPrinter:Line(nLinea,10,820,580,,"-4")
	*/
			
	oPrinter:EndPage()
	
	oPrinter:StartPage()
	ImpEnc(oPrinter)	
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ DescSX5    ³ Autor ³ Luis Enriquez         ³ Data ³ 06.07.17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Obtiene clave a partir de descripción de SX5 (PERU).         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ DescSX5(cTabela,cDesc)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cTabela .- Nombre de tabla generica (X5_TABELA).             ³±±
±±³          ³ cDesc .- Valor de descripción en tabla generica X5_DESCSPA.  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ cCveMon .- Valor de clave de tabla generica (X5_CHAVE).      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ M486XMLPDF                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function DescSX5(cTabela,cDesc)	
	Local cCveMon := ""
	Local cMonLetra := ""
	Local cCampos := ""
	Local cTablas := ""
	Local cCond := ""
	Local cAliasSX5 := getNextAlias()
	
	cCampos  := "% SX5.X5_CHAVE %"
	cTablas  := "% " + RetSqlName("SX5") + " SX5 %"
	cCond    := "% SX5.X5_TABELA = '" + cTabela + "'"
	cCond    += " AND SX5.X5_DESCSPA = '"  + cDesc + "'"
	cCond	 += " AND SX5.X5_FILIAL = '" + xFilial("SX5") + "'"
	cCond	 += " AND SX5.D_E_L_E_T_  = ' ' %"
	
	BeginSql alias cAliasSX5
		SELECT %exp:cCampos%
		FROM  %exp:cTablas%
		WHERE %exp:cCond%
	EndSql	
	
	dbSelectArea(cAliasSX5)

	(cAliasSX5)->(DbGoTop())

	While (cAliasSX5)->(!Eof())
		cCveMon := (cAliasSX5)->X5_CHAVE
		(cAliasSX5)->(dbskip())
	EndDo			
Return cCveMon

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ObtEmail   ³ Autor ³ Luis Enriquez         ³ Data ³ 06.07.17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Obtiene valor de impuesto IGV de XML (PERU).                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ObtEmail(cCliente,cLoja)                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cCliente .- Código de cliente.                               ³±±
±±³          ³ cLoja .- Tienda de cliente.                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ cEmailCli .- Email configurado para cliente (A1_EMAIL).      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ M486XMLPDF                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ObtEmail(cCliente,cLoja)
	Local cEmailCli := ""
	Local aArea 	:= getArea()
	dbSelectArea("SA1")
	SA1->(dbSetOrder(1)) //A1_FILIAL+A1_COD+A1_LOJA                                                                                                                                                 
	If SA1->(dbSeek(xFilial("SA1") + cCliente + cLoja))
		cEmailCli := SA1->A1_EMAIL
	EndIf
	RestArea(aArea)	
Return cEmailCli

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ObtIGV     ³ Autor ³ Luis Enriquez         ³ Data ³ 06.07.17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Obtiene valor de impuesto IGV de XML (PERU).                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ObtIGV(oXml,cImp)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oXml .- Objeto con estructura de archivo XML.                ³±±
±±³          ³ cImp .- String con el nombre de impuesto a obtener de XML.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ cValImp .- Valor de importe contenido en archivo XML.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ M486XMLPDF                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ObtIGV(oXml,cImp)
	Local aImptosAux := {}
	Local aImptos    := {}
	Local nPos       := 0
	Local cValImp    := ""
	Local nI := 0
	Local lTaxTotal  := XmlChildEx( oXML, "_CAC_TAXTOTAL" ) <> Nil
	
	If lTaxTotal
		aImptosAux := oXml:_CAC_TAXTOTAL
	
		If ValType(aImptosAux) == "A"
			For nI := 1 To Len(aImptosAux)
				aAdd(aImptos, {aImptosAux[1]:_CAC_TAXSUBTOTAL:_CAC_TAXCATEGORY:_CAC_TAXSCHEME:_CBC_NAME:TEXT,aImptosAux[1]:_CBC_TAXAMOUNT:TEXT}) 
			Next nI
		Else
			aAdd(aImptos, {oXml:_CAC_TAXTOTAL:_CAC_TAXSUBTOTAL:_CAC_TAXCATEGORY:_CAC_TAXSCHEME:_CBC_NAME:TEXT,;
							oXml:_CAC_TAXTOTAL:_CBC_TAXAMOUNT:TEXT})
		EndIf
		
		nPos := aScan(aImptos,{|x| x[1] == cImp })
		
		cValImp := IIf(nPos > 0,aImptos[nPos][2],"0.00")
	EndIf	
Return cValImp

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ObtFecEmi  ³ Autor ³ Luis Enriquez         ³ Data ³ 06.07.17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Obtiene valor de fecha de emision de XML (PERU)              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ObtFecEmi(oXml)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oXml .- Objeto con estructura de archivo XML.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ cFecEmi .- Valor string con la fecha de emision.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ M486XMLPDF                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ObtFecEmi(oXml)
	Local cFecEmi  := Replace(oXml:_CBC_ISSUEDATE:TEXT,"-","")
	cFecEmi  := Substr(cFecEmi,7,2) + "-" + Substr(cFecEmi,5,2) + "-" +;		
		               Substr(cFecEmi,0,4)
Return cFecEmi

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GenCodBar  ³ Autor ³ Luis Enriquez         ³ Data ³ 07.07.17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Genera código de barras reporte de factura (PERU)            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GenCodBar(oXml)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oXml .- Objeto con estructura de archivo XML.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ cCodBarra .- Cadena de caracteres que seran mostrados en el  ³±±
±±³          ³ codigo de barras.                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ M486XMLPDF                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GenCodBar(oXml,aOpcDoc)
	Local cValFirma := ""
	Local cRucEmiso := ""
	Local cRUCRecep := ""
	Local cTpoDoc := ""
	Local cCodBarra := ""	

	aDoc := StrTokArr( oXml:_CBC_ID:TEXT, "-" )
	cValFirma := ValorNodo("oXml:_EXT_UBLEXTENSIONS:_EXT_UBLEXTENSION[2]:_EXT_EXTENSIONCONTENT","_SIGNATURE","_SIGNATUREVALUE:TEXT")
	cImpTot := &("oXml:" + aOpcDoc[3] + ":_CBC_PAYABLEAMOUNT:TEXT")
	cRucEmiso := oXml:_CAC_ACCOUNTINGSUPPLIERPARTY:_CBC_CUSTOMERASSIGNEDACCOUNTID:TEXT
	cRUCRecep := oXml:_CAC_ACCOUNTINGCUSTOMERPARTY:_CBC_CUSTOMERASSIGNEDACCOUNTID:TEXT
	cTpoDocSA1 := DescSX5('XN',oXml:_CAC_ACCOUNTINGCUSTOMERPARTY:_CBC_ADDITIONALACCOUNTID:TEXT)
	If Alltrim(cEspecie) == "NF" .AND. Substr(aDoc[1],1,1) $ 'F' // Factura
		cTpoDoc := '01'
	ElseIf Alltrim(cEspecie) == "NF" .AND. Substr(aDoc[1],1,1) $ 'B' //.AND. cTpoDocSA1 # "06" // Boleta de Venta
		cTpoDoc := '03'
	ElseIf Alltrim(cEspecie) == "NCC"
		cTpoDoc := '07'
	ElseIf Alltrim(cEspecie) == "NDC"
		cTpoDoc := '08'
	EndIf					
	 					 				
	cCodBarra := Alltrim(cRucEmiso) + ;
		"|" + Alltrim(cTpoDoc) + "|" + Alltrim(Substr(aDoc[1],1,1)) + "|" + Alltrim(aDoc[2]) + ;
		"|" + Alltrim(ObtIGV(oXml,'IGV')) + "|" + Alltrim(cImpTot) + "|" + Alltrim(ObtFecEmi(oXml)) + ;
		"|" + Alltrim(cTpoDocSA1) + "|" + Alltrim(cRUCRecep) + "|" + Alltrim(cValFirma)
Return cCodBarra			

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ValorNodo  ³ Autor ³ Luis Enriquez         ³ Data ³ 11.07.17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Obtiene valor de nodo de XML validando existencia (PERU)     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ValorNodo(cXML,cBusca,cValor)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cXML .- Cadena del objeto donde se realizara busqueda XML.   ³±±
±±³Parametros³ cBusca .- Cadena de objeto a ser buscada.                    ³±±
±±³Parametros³ cValor .- Valor del objeto a ser devuelto.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ cResultado .- Valor obtenido del objeto XML.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ M486XMLPDF                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValorNodo(cXML,cBusca,cValor)
	Local cResultado := ""
	
	If AttIsMemberOf(&(cXML), cBusca)
		If Valtype(&(cXML + ":" + cBusca )) <> "A"
			cResultado := &(cXML + ":" + cBusca + ":" + cValor)
		Else
			cResultado := &(cXML + ":" + cBusca + "[1]:" + cValor)
		EndIf
	EndIf
Return	cResultado		

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M486PDFGENºAutor  ³Microsiga           º Data ³  09/21/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PedidoRef( xDocumento,xSerie )

	local cCpo := ""
	local cTab := ""
	local cQry := ""
	local xAlias := getNextAlias()
	local xRef := ""
	
	cCpo := "% SC5.C5_NUM,SC5.R_E_C_N_O_ XREC %"
	cTab := "% " + RetSQLName("SC5") + " SC5, " + RetSQLName("SC6") + " SC6 %"
	cQry := "% SC5.C5_FILIAL='" + xFilial("SC5") + "'" 
	cQry += "   AND SC6.C6_FILIAL='" + xFilial("SC6") + "'" 
	cQry += "   AND SC6.C6_NOTA='"+xDocumento+"'"
	cQry += "   AND SC6.C6_SERIE='"+xSerie+"'"
	cQry += "   AND SC6.C6_NUM=SC5.C5_NUM"
	cQry += "   AND SC5.D_E_L_E_T_=''"
	cQry += "   AND SC6.D_E_L_E_T_='' %"
			
	BeginSql alias xAlias
		SELECT %exp:cCpo%
		FROM  %exp:cTab%
		WHERE %exp:cQry%
	EndSql

	if (xAlias)->( !eof() )
		SC5->( dbgoto( (xAlias)->XREC ) )
		xRef := SC5->C5_NUM
	endif
	
	(xAlias)->( dbCloseArea() )
	
Return( xRef )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M486PDFGENºAutor  ³Microsiga           º Data ³  09/21/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xMsgBody()
	
	local cTexto	:= ""
	local xCRLF		:= (chr(13)+chr(10))
	Local cMonXML  := If(alltrim((cAliasPDF)->ESPECIE)$"NF|NDC",if(SF2->F2_MOEDA==1,"PEN","USD"),if(SF1->F1_MOEDA==1,"PEN","USD"))
	
	/*
	cTexto := "Estimado Cliente,"+ xCRLF
	cTexto += "Enviamos detalle correspondiente a la factura del mes en curso."+ xCRLF
	cTexto += "Ante cualquier Consulta, favor contactar enviado un correo a:"+ xCRLF
	cTexto += "facturacion@alrex.com.pe"+ xCRLF
	cTexto += "Para accesar su documento electronico, visite: http://www.nubefact.com/10077763851"+ xCRLF+ xCRLF
	*/
	
	cTexto := "<table border='0' width='80%'>
	cTexto += "<tr><td><h2><font color='#FF8000'>"+cLetFac+" "+(cAliasPDF)->F2_SERIE2+"-"+alltrim((cAliasPDF)->DOCUMENTO)+"</h2></td></tr>"
	cTexto += "<tr><td><hr width='100%'></td></tr>"
	cTexto += "<tr><td>&nbsp;</td></tr>"
	cTexto += "<tr><td>Estimados "+alltrim(SA1->A1_NOME)+"</td></tr>"
	cTexto += "<tr><td>&nbsp;</td></tr>"
 	cTexto += "<tr><td>Se adjunta en este mensaje una "+cLetFac+"</td></tr>"
	cTexto += "<tr><td><li><b>"+cLetFac+": "+(cAliasPDF)->F2_SERIE2+"-"+alltrim((cAliasPDF)->DOCUMENTO)+"</b></td></tr>"
	cTexto += "<tr><td><li><b>Fecha de emisión: "+DTOC(SF2->F2_EMISSAO)+"</b></td></tr>"
	cTexto += "<tr><td><li><b>Total: "+cMonXML+" "+alltrim(transform(SF2->F2_VALMERC,"9,999,999.99"))+"</b></td></tr>"
	cTexto += "<tr><td>&nbsp;</td></tr>"
	cTexto += "<tr><td>Se adjunta en este mensaje el documento electrónico en formato PDF. La representación impresa en PDF tiene la misma validez que una emitida de manera tradicional. También puedes ver el documento visitando el siguiente link.</td></tr>"
	cTexto += "<tr><td><a href='http://www.nubefact.com/10077763851'>VER "+cLetFac+"</a></td></tr>"
	cTexto += "<tr><td>&nbsp;</td></tr>"
	cTexto += "<tr><td>Si el link no funciona, usa el siguiente enlace en tu navegador:</td></tr>"
	cTexto += "<tr><td>http://www.nubefact.com/10077763851</td></tr>"
	cTexto += "<tr><td>&nbsp;</td></tr>"
	cTexto += "<tr><td>Atentamente,</td></tr>"
	cTexto += "<tr><td><b>ANDERS ZIEDEK WERNER HANS</b></td></tr>"
	cTexto += "<tr><td><b>RUC 10077763851</b></td></tr>"
	cTexto += "</table>"

Return( cTexto )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALRFAT08  ºAutor  ³Microsiga           º Data ³  12/26/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fChkHash(cSerie,cDocum,cTp)

	local cJson := ""
	Local xJson
	Local oParseJSON
	local lRet := .t.
	
	cJson += '{'
	cJson += '"operacion": "consultar_comprobante",'

	if alltrim(cTp)=="07"	// nota de credito
		cJson += '"tipo_de_comprobante": 3,'
	else
		if alltrim(cTp)=="01"	// factura
			cJson += '"tipo_de_comprobante": 1,'
		elseif alltrim(cTp)=="03"	// boleta
			cJson += '"tipo_de_comprobante": 2,'
		elseif alltrim(cTp)=="08"	// nota de debito
			cJson += '"tipo_de_comprobante": 4,'
		endif
	endif

	cJson += '"serie": "' + cSerie + '",'
	cJson += '"numero": "' + alltrim(cDocum) + '"'
	cJson += '}'

	xJson := u_XENVJSON( cJson )
	If FWJsonDeserialize(xJson,@oParseJSON)
	Endif
					
	if xJson<>NIL
					
		if at("errors",xJson) > 0
		
			Alert("No se puede imprimir el documento fiscal, no existe numero HASH valido, consulte Nubefact")
			lRet := .f.
		
		else
		
			lRet := .t.						

			if alltrim(cTp)=="07"	// nota de credito
				SF1->( RecLock("SF1",.f.) )
				SF1->F1_YQR		:= oParseJSON:cadena_para_codigo_qr
				SF1->F1_YHASH	:= oParseJSON:codigo_hash
				SF1->F1_YLINK	:= oParseJSON:enlace_del_pdf
				SF1->F1_YUSER	:= Upper(cUserName)
				SF1->F1_YDATA	:= dDataBase
				SF1->F1_YHORA	:= time()
				SF1->( MsUnlock() )
			else
				SF2->( RecLock("SF2",.f.) )
				SF2->F2_YQR		:= oParseJSON:cadena_para_codigo_qr
				SF2->F2_YHASH	:= oParseJSON:codigo_hash
				SF2->F2_YLINK	:= oParseJSON:enlace_del_pdf
				SF2->F2_YUSER	:= Upper(cUserName)
				SF2->F2_YDATA	:= dDataBase
				SF2->F2_YHORA	:= time()
				SF2->( MsUnlock() )
			endif
		endif
	
	endif

Return(lRet)


User Function getUltCuota(lNcc,xDoc,xSerie,xCliFor,xLoja)

	local cQuery := ""
	local aret := {}
	local _cAlias03	:= getNextAlias()
					
	if lNcc
		cQuery := "SELECT E1_PARCELA AS PARCELA,
		cQuery += "		  E1_VENCREA AS VENCIMENTO,
		cQuery += "		  E1_SALDO AS SALDO
		cQuery += "  FROM " + InitSQLName("SE1")
		cQuery += " WHERE E1_FILIAL = '" + xFilial('SE1') + "'"
		cQuery += "   AND E1_NUM = '" + xDoc + "'"
		cQuery += "   AND E1_PREFIXO = '" + xSerie + "'"
		cQuery += "   AND E1_CLIENTE = '" + xCliFor + "'"
		cQuery += "   AND E1_LOJA = '" + xLoja + "'"
		cQuery += "   AND D_E_L_E_T_ <> '*'"
		cQuery += " ORDER BY E1_NUM,E1_PARCELA"
	else
		cQuery := "SELECT E1_PARCELA AS PARCELA,
		cQuery += "		  E1_VENCREA AS VENCIMENTO,
		cQuery += "		  E1_SALDO AS SALDO
		cQuery += "  FROM " + InitSQLName("SE1")
		cQuery += " WHERE E1_FILIAL = '" + xFilial('SE1') + "'"
		cQuery += "   AND E1_NUM = '" + xDoc + "'"
		cQuery += "   AND E1_PREFIXO = '" + xSerie + "'"
		cQuery += "   AND E1_CLIENTE = '" + xCliFor + "'"
		cQuery += "   AND E1_LOJA = '" + xLoja + "'"
		cQuery += "   AND D_E_L_E_T_ <> '*'"
		cQuery += " ORDER BY E1_NUM,E1_PARCELA"
	endif

	If Select(_cAlias03) > 0
		(_cAlias03)->( dbCloseArea() )
	EndIf   
					
	dbUseArea(.T., "TOPCONN", tcGenQry(,,cQuery), _cAlias03 )

	If (_cAlias03)->( !Eof() )

		While (_cAlias03)->( !Eof() )

			aAdd(aret, {if(empty((_cAlias03)->PARCELA),"1",(_cAlias03)->PARCELA),dtoc(stod((_cAlias03)->VENCIMENTO)),alltrim(str((_cAlias03)->SALDO))})

			(_cAlias03)->( dbSkip() )

		EndDo

	EndIf

	(_cAlias03)->( dbCloseArea() )

	if len(aret) > 0
		cVcmto := replace(aret[len(aret)][2],"/","-")
	endif

Return( cVcmto )
