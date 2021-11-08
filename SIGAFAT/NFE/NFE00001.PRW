#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "FONT.CH"
#include "fileio.ch"
#define CRLF chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NFE00001  ºAutor  ³Percy Arias, SISTHELº Data ³  27/12/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Genera el archivo JSON a ser enviado a la sunat		      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ALREX - Peru                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NFE001( lAuto,lNcc )

	Local _aArea	:= getArea()
	Local _nOpc		:= 0
	Local oDlg
	Local cTitulo	:= "Facturacion Electronica"
	Local cPerg		:= PADR("NFE001",Len(SX1->X1_GRUPO))
	Local lRet		:= .t.
	
	Default lAuto	:= .f.

	Private cNomArq	:= "log_"+dtos(date())+"_"+replace(time(),":","")+".log"
	Private cArqLog	:= "\log\"+cNomArq
	Private cArqTmp
	Private cArqDec
	Private oFont6  := NIL
	Define FONT oFont6 NAME "Arial"
	
	if !lAuto
		ValidPerg(cPerg)
		If Pergunte(cPerg,.t.)
	
			DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
		
			@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL
			
			@ 015,017 SAY "Esta rotina tiene por objetivo enviar el archivo Json"	OF oDlg PIXEL Size 150,010 FONT oFont6 
			@ 025,017 SAY "de los documentos electronicos."	OF oDlg PIXEL Size 150,010 FONT oFont6 
			
			@ 04,167 BUTTON "&Parametros"	SIZE 036,012 ACTION Pergunte(cPerg,.t.)		OF oDlg PIXEL
			@ 22,167 BUTTON "&Continuar"	SIZE 036,012 ACTION (_nOpc:=1,oDlg:END())	OF oDlg PIXEL
			@ 58,167 BUTTON "Sali&r"    	SIZE 036,012 ACTION (_nOpc:=2,oDlg:END())	OF oDlg PIXEL
			
			ACTIVATE MSDIALOG oDlg CENTERED
			
		EndIf
	
	else
		
		dbSelectArea("SX1")
		dbSetOrder(1)

		If dbSeek(cPerg+"01")
			SX1->( RecLock("SX1",.F.) )
			SX1->X1_CNT01 := iif(lNcc,SF1->F1_SERIE,SF2->F2_SERIE)
			SX1->( MsUnlock() )
		EndIf
		
		If dbSeek(cPerg+"02")
			SX1->( RecLock("SX1",.F.) )
			SX1->X1_CNT01 := iif(lNcc,SF1->F1_DOC,SF2->F2_DOC)
			SX1->( MsUnlock() )
		EndIf

		If dbSeek(cPerg+"03")
			SX1->( RecLock("SX1",.F.) )
			SX1->X1_CNT01 := iif(lNcc,SF1->F1_DOC,SF2->F2_DOC)
			SX1->( MsUnlock() )
		EndIf

		If dbSeek(cPerg+"04")
			SX1->( RecLock("SX1",.F.) )
			SX1->X1_CNT01 := dtos(ctod("01/01/"+alltrim(str(year(date())))))
			SX1->( MsUnlock() )
		EndIf

		If dbSeek(cPerg+"05")
			SX1->( RecLock("SX1",.F.) )
			SX1->X1_CNT01 := dtos(ctod("31/12/"+alltrim(str(year(date())))))
			SX1->( MsUnlock() )
		EndIf

		If dbSeek(cPerg+"06")
			SX1->( RecLock("SX1",.F.) )
			SX1->X1_CNT01 := GetNewPar("AL_DIRNFE","C:\Temp")
			SX1->( MsUnlock() )
		EndIf

		_nOpc := 1
		Pergunte(cPerg,.f.)
		
	endif
	
	If _nOpc == 1
		MsgRun( "Aguarde, generando documento(s) electronico(s)..." ,, {|| lRet := GenArchivo( lNcc ) } )
	Endif

	RestArea( _aArea )
	
Return( lRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NFE00001  ºAutor  ³Microsiga           º Data ³  01/07/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidPerg(cPerg)

	Local aHelpPor01 := {'Digite la serie del documento fiscal.'}
	Local aHelpPor02 := {'Digite el numero inicial de la factura.'}
	Local aHelpPor03 := {'Digite el numero final de la factura.'}
	Local aHelpPor04 := {'Escoja la carpeta a guardar el archivo.'}
	Local aHelpPor05 := {'Digite la fecha inicial de emision de la factura.'}
	Local aHelpPor06 := {'Digite la fecha final de emision de la factura.'}

	PutSx1(cPerg,"01","","Serie"				,"","mv_ch1","C",TamSX3("F2_SERIE")[1],0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor01,aHelpPor01,aHelpPor01)	
	PutSx1(cPerg,"02","","De Factura"			,"","mv_ch2","C",TamSX3("F2_DOC")[1],0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor02,aHelpPor02,aHelpPor02)
	PutSx1(cPerg,"03","","Hasta Factura"		,"","mv_ch3","C",TamSX3("F2_DOC")[1],0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",aHelpPor03,aHelpPor03,aHelpPor03)
	PutSx1(cPerg,"04","","De Emision"			,"","mv_ch4","D",08,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",aHelpPor04,aHelpPor04,aHelpPor04)
	PutSx1(cPerg,"05","","Hasta Emision"		,"","mv_ch5","D",08,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","",aHelpPor05,aHelpPor05,aHelpPor05)
	PutSx1(cPerg,"06","","Carpeta Destino"		,"","mv_ch6","C",30,0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","",aHelpPor06,aHelpPor06,aHelpPor06)
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NFE00001  ºAutor  ³Microsiga           º Data ³  01/07/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GenArchivo( lNcc )

	Local dEmissao	:= Ctod(space(8))
	Local dVencimento := Ctod(space(8))
	Local cLin		:= ""
	Local cRazEmp	:= ""
	Local cNomEmp	:= ""
	Local cEndEmp	:= ""
	Local cProEmp	:= ""
	Local cDepEmp	:= ""
	Local cDisEmp	:= ""
	Local cRUCEmp	:= ""
	Local cNomeCli	:= ""
	Local cRazaoCli	:= ""
	Local cRUCCli	:= ""
	Local cTipoDoc	:= ""
	Local cUbigCli	:= ""
	Local cEndCli	:= ""
	Local cProvCli	:= ""
	Local cDepaCli	:= ""
	Local cDistCli	:= ""
	Local cMailCli	:= ""
	Local cNomeArq	:= ""
	// Local _cCodUser	:= RetCodUsr()
	// Local aPswDet	:= {}
	// Local _cMailUsr	:= ""
	// Local _cLogUser	:= ""
	Local cQuery	:= ""
	Local _cAlias01	:= getNextAlias()
	Local _cAlias02	:= getNextAlias()
	Local _cAlias03	:= getNextAlias()
	Local cJSON
	Local oParseJSON
	Local lRet		:= .f.
	Local cMsgErr	:= ""
	Local cMsgOk	:= ""
	Local _aDocOrig	:= {}
	Local _cPedido	:= ""
	Local _aNroGuia := {}
	// Local nCero		:= 0
	Local cLinkPDF	:= ""
	Local cObserva	:= ""
	Local cTxtBas1	:= alltrim(getNewPar("AA_TXTMSG1",""))
	Local cTxtBas2	:= alltrim(getNewPar("AA_TXTMSG2",""))
	Local cTxtBco1	:= alltrim(getNewPar("AA_TXTBCO1",""))
	Local cTxtBco2	:= alltrim(getNewPar("AA_TXTBCO2",""))
	Local cTxtBco3	:= alltrim(getNewPar("AA_TXTBCO3",""))
	Local cTxtBco4	:= alltrim(getNewPar("AA_TXTBCO4",""))
	// Local nPIGV		:= GetMv("MV_ICMPAD")
	Local lEnvMail	:= GetMv("AL_ENVMAIL")
	Local cCodDelProdAnt := alltrim(getNewPar("AA_PRODANT","SRVANT"))
	Local cDesDelProdAnt := alltrim(getNewPar("AA_DESCANT","ANTICIPOS DE CLIENTES"))

	// Local strJson := Nil
	// Local lenStrJson := 0
	// Local jsonfields := Nil
	// Local nRetParser := 0
	// Local lRet := .F.

	Local lCreditoFE := .f.
	Local aCuotas	:= {}
	Local cCondPago := ""
	Local nX		:= 1
	Local nXi		:= 1


	if !FM_Direct( mv_par06	, .f., .f. )
		alert("¡ Carpeta de destino no encontrada, verifique el parametro (6) de las opciones !")
		return(.f.)
	endif
	
	cRazEmp	:= Alltrim(SM0->M0_NOME)
	cNomEmp	:= Alltrim(SM0->M0_NOMECOM)
	cEndEmp	:= Alltrim(SM0->M0_ENDCOB)
	cProEmp	:= Alltrim(SM0->M0_CIDCOB)
	cDepEmp	:= "LIMA" //Alltrim(SM0->M0_ESTCOB)
	cDisEmp	:= Alltrim(SM0->M0_BAIRCOB)
	cRUCEmp	:= Alltrim(SM0->M0_CGC)
	
	if lNcc
		cQuery := "SELECT * FROM " + InitSQLName("SF1")
		cQuery += " WHERE F1_FILIAL = '" + xFilial('SF1') + "'"
		cQuery += "   AND F1_DOC BETWEEN '" + mv_par02 + "' AND '" + mv_par03 + "'"
		cQuery += "   AND F1_SERIE = '" + mv_par01 + "'"
		cQuery += "   AND F1_EMISSAO BETWEEN '" + DtoS(mv_par04) + "' AND '" + DtoS(mv_par05) + "'"
		cQuery += "   AND F1_ESPECIE='NCC'"
		cQuery += "   AND D_E_L_E_T_ <> '*'"
		cQuery += "   AND F1_YHASH = ' '"
		cQuery += "   AND F1_YQR = ' '"
		cQuery += "   AND F1_YLINK = ' '"
		cQuery += " ORDER BY F1_DOC"
	else
		cQuery := "SELECT * FROM " + InitSQLName("SF2")
		cQuery += " WHERE F2_FILIAL = '" + xFilial('SF2') + "'"
		cQuery += "   AND F2_DOC BETWEEN '" + mv_par02 + "' AND '" + mv_par03 + "'"
		cQuery += "   AND F2_SERIE = '" + mv_par01 + "'"
		cQuery += "   AND F2_EMISSAO BETWEEN '" + DtoS(mv_par04) + "' AND '" + DtoS(mv_par05) + "'"
		cQuery += "   AND D_E_L_E_T_ <> '*'"
		//cQuery += "   AND F2_YHASH = ' '"
		//cQuery += "   AND F2_YQR = ' '"
		//cQuery += "   AND F2_YLINK = ' '"
		cQuery += " ORDER BY F2_DOC"
	endif
	
	dbUseArea( .T., "TOPCONN", tcGenQry(,,cQuery), _cAlias01 )
	
	If (_cAlias01)->( !Eof() )
	
		(_cAlias01)->(dbGoTop())
		
		While (_cAlias01)->( !Eof() )
		
			FR3->( dbSetOrder(1) )
			SA1->( dbSetOrder(1) )
			
			if lNcc
				cdbSeek := (_cAlias01)->F1_FORNECE + (_cAlias01)->F1_LOJA
			else
				SC5->( MsSeek( xFilial("SC5")+(_cAlias01)->F2_YCOD ) )
				cdbSeek := (_cAlias01)->F2_CLIENTE + (_cAlias01)->F2_LOJA
			endif
			
			If SA1->( dbSeek( xFilial("SA1") + cdbSeek ) )
				cNomeCli	:= u_retirach(Alltrim(SA1->A1_NREDUZ))
				cRazaoCli	:= u_retirach(Alltrim(SA1->A1_NOME))
				cRUCCli		:= Alltrim(SA1->A1_CGC)
				cDNICli		:= Alltrim(SA1->A1_PFISICA)
				cTipoDoc	:= Alltrim(Str(Val(SA1->A1_TIPDOC)))
				cUbigCli	:= u_retirach(Alltrim(SA1->A1_BAIRRO))
				cEndCli		:= u_retirach(Alltrim(SA1->A1_END))
				cProvCli	:= u_retirach(Alltrim(SA1->A1_MUN))
				cDepaCli	:= u_retirach(Alltrim(SA1->A1_EST))
				cDistCli	:= u_retirach(Alltrim(SA1->A1_BAIRRO))
				cMailCli	:= Lower(Alltrim(SA1->A1_EMAIL))
			EndIf
			
			// ----------------------------------------------- //
			// | Acumula totales para posterior impresion      |
			// ----------------------------------------------- //
			SX5->( dbSetOrder(1) )
			SX5->( MsSeek( xFilial("SX5")+"12"+cDepaCli ) )
			
			if lNcc
				cSeirSFP := Alltrim( u_PuxaSer2( (_cAlias01)->F1_SERIE ) )
				cSeirSFP := If( cSeirSFP=="","N"+(_cAlias01)->F1_SERIE,cSeirSFP )
			else
				cSeirSFP := Alltrim( u_PuxaSer2( (_cAlias01)->F2_SERIE ) )
				cSeirSFP := If( cSeirSFP=="","F"+(_cAlias01)->F2_SERIE,cSeirSFP )
			endif
						
			If Right(Alltrim(mv_par06),1)="\"
				cNomeArq := Alltrim(mv_par06)+;
							Strzero(Day(dDataBase),2)+Strzero(Month(dDataBase),2)+Strzero(Year(dDataBase),4)+;
							"-"+cRUCEmp+iif(lNcc,"-07-","-01-")+cSeirSFP+"-"+Right(Alltrim(iif(lNcc,(_cAlias01)->F1_DOC,(_cAlias01)->F2_DOC)),8)+".json"
			Else
				cNomeArq := Alltrim(mv_par06)+"\"+;
							Strzero(Day(dDataBase),2)+Strzero(Month(dDataBase),2)+Strzero(Year(dDataBase),4)+;
							"-"+cRUCEmp+iif(lNcc,"-07-","-01-")+cSeirSFP+"-"+Right(Alltrim(iif(lNcc,(_cAlias01)->F1_DOC,(_cAlias01)->F2_DOC)),8)+".json"
			EndIf
			
			If File(cNomeArq)
		
				If MsgBox("O arquivo "+ Alltrim(cNomeArq)+" ya fue generado!"+CRLF+"Desea substituirlo?", "ALREX", "YESNO")
				
					If FERASE(Alltrim(cNomeArq)) == -1
						MsgStop('Falla al borrar el archivo!')
						(_cAlias01)->( dbSkip() )
						Loop
					Endif
				
				Else
					(_cAlias01)->( dbSkip() )
					Loop
				EndIf
				
			EndIf
	
			cNomeArq := Upper(cNomeArq)
			if lNcc
				dEmissao := Substr((_cAlias01)->F1_EMISSAO,1,4)+"-"+Substr((_cAlias01)->F1_EMISSAO,5,2)+"-"+Substr((_cAlias01)->F1_EMISSAO,7,2)
				__cSerie2 := Alltrim( u_PuxaSer2( (_cAlias01)->F1_SERIE ) )
				_aDocOrig := u_xGetNFOrig((_cAlias01)->F1_DOC,(_cAlias01)->F1_SERIE,(_cAlias01)->F1_FORNECE,(_cAlias01)->F1_LOJA)
			else
				dEmissao := Substr((_cAlias01)->F2_EMISSAO,1,4)+"-"+Substr((_cAlias01)->F2_EMISSAO,5,2)+"-"+Substr((_cAlias01)->F2_EMISSAO,7,2)
				__cSerie2 := Alltrim( u_PuxaSer2( (_cAlias01)->F2_SERIE ) )
				_aDocOrig := xGetNFDeb((_cAlias01)->F2_DOC,(_cAlias01)->F2_SERIE,(_cAlias01)->F2_CLIENTE,(_cAlias01)->F2_LOJA)
			endif
			lDebito := .f.

			//-------------------------------------------------------------//
			cHeadJson := ""
			cHeadJson += '{'
			cHeadJson += '"operacion": "generar_comprobante",'
			if lNcc
				if (_cAlias01)->F1_TPDOC=="07"	// nota de credito
					cHeadJson += '"tipo_de_comprobante": 3,'
				endif
			else
				if (_cAlias01)->F2_TPDOC=="01"	// factura
					cHeadJson += '"tipo_de_comprobante": 1,'
				elseif (_cAlias01)->F2_TPDOC=="03"	// boleta
					cHeadJson += '"tipo_de_comprobante": 2,'
				elseif (_cAlias01)->F2_TPDOC=="08"	// nota de debito
					cHeadJson += '"tipo_de_comprobante": 4,'
					lDebito := .t.
				endif
			endif
			cHeadJson += '"serie": "' + __cSerie2 + '",'
			cHeadJson += '"numero": "' + strzero(val( iif(lNcc,(_cAlias01)->F1_DOC,(_cAlias01)->F2_DOC) ),8) + '",'
			if alltrim(cDepaCli)=="EX"
				cHeadJson += '"sunat_transaction": 2,'
			else
				if !lNcc
					if (_cAlias01)->F2_TIPO=="A"
						cHeadJson += '"sunat_transaction": 4,'
					else
						if FR3->( dbSeek( xFilial("FR3")+"R"+(_cAlias01)->F2_DOC+(_cAlias01)->F2_SERIE+SC5->C5_NUM ) )
							cHeadJson += '"sunat_transaction": 4,'
						else
							cHeadJson += '"sunat_transaction": 1,'
						endif
					endif
				else
					cHeadJson += '"sunat_transaction": 1,'
				endif
			endif
			cHeadJson += '"cliente_tipo_de_documento": "' + cTipoDoc + '",'
			If cTipoDoc=="6"
				cHeadJson += '"cliente_numero_de_documento": "' + cRUCCli + '",' 
			Else
				cHeadJson += '"cliente_numero_de_documento": "' + cDNICli + '",' 
			EndIf
			cHeadJson += '"cliente_denominacion": "' + cRazaoCli + '",'
			cHeadJson += '"cliente_direccion": "' + cEndCli + " " + cProvCli + " " + cDistCli + " " + cDepaCli + '",'
			cHeadJson += '"cliente_email": "' + cMailCli + '",'
			cHeadJson += '"cliente_email_1": "",'
			cHeadJson += '"cliente_email_2": "",'
			cHeadJson += '"fecha_de_emision": "' + dEmissao + '",'

			if lNcc
				dVencimento := u_getUltCuota(.t.,(_cAlias01)->F1_DOC,(_cAlias01)->F1_SERIE,(_cAlias01)->F1_FORNECE,(_cAlias01)->F1_LOJA)
			else
				dVencimento := u_getUltCuota(.f.,(_cAlias01)->F2_DOC,(_cAlias01)->F2_SERIE,(_cAlias01)->F2_CLIENTE,(_cAlias01)->F2_LOJA)
			endif

			cHeadJson += '"fecha_de_vencimiento": "' + dVencimento + '",'
			cHeadJson += '"moneda": "' + alltrim(str(iif(lNcc,(_cAlias01)->F1_MOEDA,(_cAlias01)->F2_MOEDA))) + '",'
			if lNcc
				if (_cAlias01)->F1_MOEDA==2
					cHeadJson += '"tipo_de_cambio": "' + alltrim(str((_cAlias01)->F1_TXMOEDA)) + '",'
				else
					cHeadJson += '"tipo_de_cambio": "1",'
				endif
			else
				if (_cAlias01)->F2_MOEDA==2
					cHeadJson += '"tipo_de_cambio": "' + alltrim(str((_cAlias01)->F2_TXMOEDA)) + '",'
				else
					cHeadJson += '"tipo_de_cambio": "1",'
				endif
			endif
			cHeadJson += '"porcentaje_de_igv": "' + alltrim(Transform(GetMv("MV_ICMPAD"),"@E 999.99")) + '",'
			//cHeadJson += '"descuento_global": "' + alltrim(str(iif(lNcc,(_cAlias01)->F1_DESCONT,(_cAlias01)->F2_DESCONT))) + '",'
			//cHeadJson += '"total_descuento": "' + alltrim(str(iif(lNcc,(_cAlias01)->F1_DESCONT,(_cAlias01)->F2_DESCONT))) + '",'
			cHeadJson += '"descuento_global": "",'
			cHeadJson += '"total_descuento": "",'
			if !lNcc
				if alltrim(cDepaCli)<>"EX"
					//if (_cAlias01)->F2_VALADI > 0
					if FR3->( dbSeek( xFilial("FR3")+"R"+(_cAlias01)->F2_DOC+(_cAlias01)->F2_SERIE+(_cAlias01)->F2_YCOD ) )
						cHeadJson += '"total_anticipo": "' + alltrim(str( (_cAlias01)->F2_VALFAT )) + '",'
						cHeadJson += '"total_gravada": "0",'
						cHeadJson += '"total_inafecta": "",'
						cHeadJson += '"total_exonerada": "",'
					else
						if (_cAlias01)->F2_BASIMP1>0
							cHeadJson += '"total_anticipo": "",'
							cHeadJson += '"total_gravada":  "' + alltrim(str( (_cAlias01)->F2_BASIMP1 )) + '",'
							cHeadJson += '"total_inafecta": "",'
							cHeadJson += '"total_exonerada": "",'
						else
							cHeadJson += '"total_anticipo": "",'
							cHeadJson += '"total_gravada": "",'
							if (_cAlias01)->F2_VALFAT > 0
								cHeadJson += '"total_inafecta": "' + alltrim(str( (_cAlias01)->F2_VALFAT )) + '",'
							else
								cHeadJson += '"total_inafecta": "' + alltrim(str( (_cAlias01)->F2_VALBRUT )) + '",'
							endif
							cHeadJson += '"total_exonerada": "",'
						endif
					endif
				else                                        
					cHeadJson += '"total_anticipo": "",'
					cHeadJson += '"total_gravada": "",'
					cHeadJson += '"total_inafecta": "' + alltrim(str( (_cAlias01)->F2_VALBRUT )) + '",'
					cHeadJson += '"total_exonerada": "",'
				endif
			else
				cHeadJson += '"total_anticipo": "",'
				if alltrim(cDepaCli)=="EX"
					cHeadJson += '"total_gravada": "",'
					cHeadJson += '"total_inafecta": "' + alltrim(str( (_cAlias01)->F2_VALBRUT )) + '",'
					cHeadJson += '"total_exonerada": "",'
				else
					if (_cAlias01)->F1_BASIMP1>0
						cHeadJson += '"total_gravada":  "' + alltrim(str( (_cAlias01)->F1_BASIMP1 )) + '",'
						cHeadJson += '"total_inafecta": "",'
						cHeadJson += '"total_exonerada": "",'
					else
						cHeadJson += '"total_gravada": "",'
						cHeadJson += '"total_inafecta": "' + alltrim(str( (_cAlias01)->F1_VALBRUT )) + '",'
						cHeadJson += '"total_exonerada": "",'
					endif
				endif
			endif
			
			//cHeadJson += '"total_exonerada": "",'
			if lNcc
				if (_cAlias01)->F1_VALIMP1>0
					cHeadJson += '"total_igv":  "' + alltrim(str( (_cAlias01)->F1_VALIMP1 )) + '",'
				else
					cHeadJson += '"total_igv":  "' + alltrim(str( (_cAlias01)->F1_VALIMP6 )) + '",'
				endif
			else
				if (_cAlias01)->F2_VALIMP1>0
					cHeadJson += '"total_igv":  "' + alltrim(str( (_cAlias01)->F2_VALIMP1 )) + '",'
				else
					cHeadJson += '"total_igv":  "' + alltrim(str( (_cAlias01)->F2_VALIMP6 )) + '",'
				endif
			endif
			cHeadJson += '"total_gratuita": "",'
			cHeadJson += '"total_otros_cargos": "",'
			//if (_cAlias01)->F2_VALADI > 0
			if !lNcc
				if FR3->( dbSeek( xFilial("FR3")+"R"+(_cAlias01)->F2_DOC+(_cAlias01)->F2_SERIE+(_cAlias01)->F2_YCOD ) )
					cHeadJson += '"total": "0",'
				else 
					cHeadJson += '"total":  "' + alltrim(str(iif(lNcc,(_cAlias01)->F1_VALBRUT,(_cAlias01)->F2_VALFAT))) + '",'
				endif
			else
				cHeadJson += '"total":  "' + alltrim(str(iif(lNcc,(_cAlias01)->F1_VALBRUT,(_cAlias01)->F2_VALFAT))) + '",'
			endif

			cHeadJson += '"percepcion_tipo": "",'
			cHeadJson += '"percepcion_base_imponible": "",'
			cHeadJson += '"total_percepcion": "",'
			cHeadJson += '"total_incluido_percepcion": "",'
			if lNcc
				if (_cAlias01)->F1_VALIMP5>0
					cHeadJson += '"detraccion": "true",'
				else
					cHeadJson += '"detraccion": "false",'
				endif
			else
				if (_cAlias01)->F2_VALIMP5>0
					cHeadJson += '"detraccion": "true",'
				else
					cHeadJson += '"detraccion": "false",'
				endif
			endif
			
			cObserva := ""
			if !empty(cTxtBco1)
				cObserva += cTxtBco1
			endif
			if !empty(cTxtBco2)
				cObserva += "\n" + cTxtBco2
			endif
			if !empty(cTxtBco3)
				cObserva += "\n" + cTxtBco3
			endif
			if !empty(cTxtBco4)
				cObserva += "\n" + cTxtBco4
			endif
			if !empty(cTxtBas1)
				cObserva += "\n\n" + cTxtBas1
			endif
			if !empty(cTxtBas2)
				cObserva += "\n" + cTxtBas2
			endif

			// ------------------------------------------ //
			// PE para tratamento de validaciones extras  //
			// ------------------------------------------ //
			If ExistBlock("STHPE000")
				cObserva += "\n\n" + ExecBlock("STHPE000",.F.,.F.)
			EndIf
			if SF2->(FieldPos("F2_YOBS")) > 0 .And. SF2->(FieldPos("F2_YORDCOM")) > 0 .And. SF2->(FieldPos("F2_YGUIA")) > 0 .And. SF2->(FieldPos("F2_YFRECEP")) > 0
				if !lNcc
					_cOrdCompra := ""
					_cNroRemiss := ""
					_DtRecepcio := ""
					if !empty((_cAlias01)->F2_YORDCOM)
						_cOrdCompra := "ORDEN DE COMPRA: "+alltrim((_cAlias01)->F2_YORDCOM)
					endif
					if !empty((_cAlias01)->F2_YGUIA)
						_cNroRemiss := "GUIA DE REMISION: "+alltrim((_cAlias01)->F2_YGUIA)
					endif
					if !empty((_cAlias01)->F2_YFRECEP)
						_DtRecepcio := "FECHA DE RECEPCION: "+dtoc(stod((_cAlias01)->F2_YFRECEP))
					endif

					//cHeadJson += '"observaciones": "' + alltrim((_cAlias01)->F2_YOBS) + if(empty(_cOrdCompra),"","\n"+_cOrdCompra+"\n") + if(empty(_cNroRemiss),"",_cNroRemiss+"\n") + if(empty(_DtRecepcio),"",_DtRecepcio+"\n") + "\n\n"+ cTxtBco1 + "\n" + cTxtBco2 + "\n" +  cTxtBco3 + "\n" + cTxtBco4 + "\n\n" + cTxtBas1 + "\n" + cTxtBas2 + '",'
					cHeadJson += '"observaciones": "' + alltrim((_cAlias01)->F2_YOBS) + if(empty(_cOrdCompra),"","\n"+_cOrdCompra) + if(empty(_cNroRemiss),"","\n"+_cNroRemiss) + if(empty(_DtRecepcio),"","\n"+_DtRecepcio) + "\n\n"+ cObserva + '",'
				else
					cHeadJson += '"observaciones": "",'
				endif
			else
				if !lNcc
					cHeadJson += '"observaciones": "' + cObserva + '",'
				else
					cHeadJson += '"observaciones": "",'
				endif
			endif
			if lNcc
				if len(_aDocOrig)>0
					cHeadJson += '"documento_que_se_modifica_tipo": "' + iif(left(alltrim(_aDocOrig[1][3]),1)=="F","1","2") + '",'
					cHeadJson += '"documento_que_se_modifica_serie": "' + alltrim(_aDocOrig[1][3]) + '",'
					cHeadJson += '"documento_que_se_modifica_numero": "' + alltrim(_aDocOrig[1][1]) + '",'
					cHeadJson += '"tipo_de_nota_de_credito": "' + (_cAlias01)->F1_YTPNCC + '",'
				else
					cHeadJson += '"documento_que_se_modifica_tipo": "",'
					cHeadJson += '"documento_que_se_modifica_serie": "",'
					cHeadJson += '"documento_que_se_modifica_numero": "",'
					cHeadJson += '"tipo_de_nota_de_credito": "",'
				endif
			else
				if lDebito
					cHeadJson += '"documento_que_se_modifica_tipo": "' + iif(left(alltrim(_aDocOrig[1][2]),1)=="F","1","2") + '",'
					cHeadJson += '"documento_que_se_modifica_serie": "' + alltrim(_aDocOrig[1][3]) + '",'
					cHeadJson += '"documento_que_se_modifica_numero": "' + alltrim(_aDocOrig[1][1]) + '",'
					cHeadJson += '"tipo_de_nota_de_debito": "' + (_cAlias01)->F2_YTPNDC + '",'
				else
					cHeadJson += '"documento_que_se_modifica_tipo": "",'
					cHeadJson += '"documento_que_se_modifica_serie": "",'
					cHeadJson += '"documento_que_se_modifica_numero": "",'
					cHeadJson += '"tipo_de_nota_de_debito": "",'
				endif
			endif
			cHeadJson += '"enviar_automaticamente_a_la_sunat": "true",'
			cHeadJson += '"enviar_automaticamente_al_cliente": "false",'
			cHeadJson += '"codigo_unico": "",'

			// if lNcc
			// 	cHeadJson += '"condiciones_de_pago": "' + Alltrim(Posicione("SE4",1,xFilial("SE4")+(_cAlias01)->F1_COND,"E4_DESCRI")) + '",'
			// else
			// 	cHeadJson += '"condiciones_de_pago": "' + Alltrim(Posicione("SE4",1,xFilial("SE4")+(_cAlias01)->F2_COND,"E4_DESCRI")) + '",'
			// endif

			lCreditoFE := .f.

			if lNcc
			
				if Posicione("SE4",1,xFilial("SE4")+(_cAlias01)->F1_COND,"E4_YCREDFE")=='S'
					lCreditoFE := .t.
					aCuotas := getCuotas(lNcc,(_cAlias01)->F1_DOC,(_cAlias01)->F1_SERIE,(_cAlias01)->F1_FORNECE,(_cAlias01)->F1_LOJA)
				endif

				cHeadJson += '"condiciones_de_pago": "' + Alltrim(Posicione("SE4",1,xFilial("SE4")+(_cAlias01)->F1_COND,"E4_DESCRI")) + '",'

			else

				if Posicione("SE4",1,xFilial("SE4")+(_cAlias01)->F2_COND,"E4_YCREDFE")=='S'
					lCreditoFE := .t.
					aCuotas := getCuotas(lNcc,(_cAlias01)->F2_DOC,(_cAlias01)->F2_SERIE,(_cAlias01)->F2_CLIENTE,(_cAlias01)->F2_LOJA)
				endif
				
				cHeadJson += '"condiciones_de_pago": "' + Alltrim(Posicione("SE4",1,xFilial("SE4")+(_cAlias01)->F2_COND,"E4_DESCRI")) + '",'

			endif

			if lCreditoFE

				cCondPago := "CREDITO -"

				for nX := 1 to len(aCuotas)

					cCondPago += " CUOTA "+aCuotas[nX][1]+": FECHA DE PAGO: "+aCuotas[nX][2]+" - IMPORTE: "+aCuotas[nX][3]
					cCondPago += " / "

				next nX

				cCondPago := substr(cCondPago,1,len(alltrim(cCondPago))-1)

				cHeadJson += '"medio_de_pago": "' + cCondPago + '",'

			else
				cHeadJson += '"medio_de_pago": "",'
			endif


			cHeadJson += '"medio_de_pago": "",'
			cHeadJson += '"placa_vehiculo": "",'
			cHeadJson += '"orden_compra_servicio": "",'
			cHeadJson += '"tabla_personalizada_codigo": "",'
			cHeadJson += '"formato_de_pdf": "",'
			
			u_XGRVLOG( cNomeArq,cHeadJson,.T. )
			
			// -----------------------------------------------//
			// Generar el Detalle de las facturas             //
			// -----------------------------------------------//
			if lNcc
			 	cQuery := "SELECT * FROM " + InitSQLName("SD1")
				cQuery += " WHERE D1_FILIAL = '" + xFilial('SD1') + "'"
				cQuery += "   AND D1_DOC = '" + (_cAlias01)->F1_DOC + "'"
				cQuery += "   AND D1_SERIE = '" + (_cAlias01)->F1_SERIE + "'"
				cQuery += "   AND D1_FORNECE = '" + (_cAlias01)->F1_FORNECE + "'"
				cQuery += "   AND D1_LOJA = '" + (_cAlias01)->F1_LOJA + "'"
				cQuery += "   AND D_E_L_E_T_ <> '*'"
				cQuery += " ORDER BY D1_ITEM"
			else
			 	cQuery := "SELECT * FROM " + InitSQLName("SD2")
				cQuery += " WHERE D2_FILIAL = '" + xFilial('SD2') + "'"
				cQuery += "   AND D2_DOC = '" + (_cAlias01)->F2_DOC + "'"
				cQuery += "   AND D2_SERIE = '" + (_cAlias01)->F2_SERIE + "'"
				cQuery += "   AND D2_CLIENTE = '" + (_cAlias01)->F2_CLIENTE + "'"
				cQuery += "   AND D2_LOJA = '" + (_cAlias01)->F2_LOJA + "'"
				cQuery += "   AND D_E_L_E_T_ <> '*'"
				cQuery += " ORDER BY D2_ITEM"
			endif
			
			If Select(_cAlias02) > 0
		   		(_cAlias02)->( dbCloseArea() )
			EndIf   
			
			dbUseArea(.T., "TOPCONN", tcGenQry(,,cQuery), _cAlias02 )

			If (_cAlias02)->( !Eof() )

				(_cAlias02)->( dbGoTop() )
				
				FR3->( dbSetOrder(1) )
				SC6->( dbSetOrder(2) )
			 	SAH->( dbSetOrder(1) )
			 	
				cDocDeAnticipo := ""
				cSerDeAnticipo := ""
				cCodDelProdAnt := ""
				cDesDelProdAnt := ""
				ltemAnticipo := .f.

			 	cArqJson := ""
				cArqJson += '"items":'
				cArqJson += '['
			 	
			 	While (_cAlias02)->( !Eof() )
			 	
			 		if lNcc
			 			cSeekAH := (_cAlias02)->D1_UM
			 		else
			 			cSeekAH := (_cAlias02)->D2_UM
			 		endif
			 	
					If SAH->( dbSeek( xFilial("SAH")+cSeekAH ) )
			 			If Empty(Alltrim(SAH->AH_YUMFE))
			 				cLin := "NIU"
			 			Else
							cLin := Alltrim(SAH->AH_YUMFE)
						EndIf
					Else
						cLin := Alltrim(cSeekAH)
					EndIf
					
					_cComple := ""
					
					if !lNcc

						_cPedido := (_cAlias02)->D2_PEDIDO
					
						if SC6->(fieldpos("C6_YSTRUCT")) > 0
							if !empty(_cPedido)
								if SC6->( dbSeek( xFilial("SC6")+(_cAlias02)->D2_COD+_cPedido ) )
									_nLin := MLCount(SC6->C6_YSTRUCT,70)                                           
									for nXi := 1 to _nLin
								        _cTxt := Alltrim(MemoLine(SC6->C6_YSTRUCT,70,nXi))
								        if !empty(_cTxt)
								        	if at(":",_cTxt) <= 0
									        	_cComple += _cTxt
									        endIf
										endif
									next nXi
								endif
							endif
						endif
						
					endif
					
					if !empty(_cComple)
						_cComple := replace(_cComple,";","\n")
						_cComple := "\n" + _cComple
						_cComple := u_XACENTOS(_cComple)
					endif
					
					if lNcc
						//if (_cAlias02)->D1_QUANT>1
						//	nVIGVUnit := Round( ( ( (_cAlias02)->D1_VUNIT*nPIGV ) / 100 ),2 )
						//else
							if (_cAlias02)->D1_BASIMP1>0
								nVIGVUnit :=  ((_cAlias02)->D1_VALIMP1/(_cAlias02)->D1_QUANT)
							else
								nVIGVUnit :=  ((_cAlias02)->D1_VALIMP6/(_cAlias02)->D1_QUANT)
							endif
						//endif
					else
						//if (_cAlias02)->D2_QUANT>1
						//	nVIGVUnit := Round( ( ( (_cAlias02)->D2_PRCVEN*nPIGV ) / 100 ),2 )
						//else
							if (_cAlias02)->D2_BASIMP1>0
								nVIGVUnit :=  ((_cAlias02)->D2_VALIMP1/(_cAlias02)->D2_QUANT)
							else
								nVIGVUnit :=  ((_cAlias02)->D2_VALIMP6/(_cAlias02)->D2_QUANT)
							endif
						//endif
					endif
					cArqJson += '{'
					cArqJson += '"unidad_de_medida": "' + cLin + '",'
					cArqJson += '"codigo": "' + Alltrim(iif(lNcc,(_cAlias02)->D1_COD,(_cAlias02)->D2_COD)) + '",'
					if SD2->(fieldpos("D2_YDESCRI")) > 0 .And. SD1->(fieldpos("D1_YDESCRI")) > 0
						cArqJson += '"descripcion": "' + Alltrim(iif(lNcc,(_cAlias02)->D1_YDESCR,(_cAlias02)->D2_YDESCRI)) + _cComple + '",'
					else
						cArqJson += '"descripcion": "' + Alltrim(iif(lNcc,Posicione("SB1",1,xFilial("SB1")+(_cAlias02)->D1_COD,"B1_DESC"),Posicione("SB1",1,xFilial("SB1")+(_cAlias02)->D2_COD,"B1_DESC") )) + _cComple + '",'
					endif
					cArqJson += '"cantidad": "' + alltrim(str(iif(lNcc,(_cAlias02)->D1_QUANT,(_cAlias02)->D2_QUANT))) + '",'
					cArqJson += '"valor_unitario": "' + alltrim(str(iif(lNcc,(_cAlias02)->D1_VUNIT-nVIGVUnit,(_cAlias02)->D2_PRCVEN-nVIGVUnit))) + '",'
					//if (_cAlias02)->D2_VALADI > 0
						//cArqJson += '"precio_unitario": "' + alltrim(str(iif(lNcc,(_cAlias02)->D1_VUNIT,( (_cAlias02)->D2_BASIMP1+(_cAlias02)->D2_VALIMP1/(_cAlias02)->D2_QUANT ) ))) + '",'
					//else
						cArqJson += '"precio_unitario": "' + alltrim(str(iif(lNcc,(_cAlias02)->D1_VUNIT,(_cAlias02)->D2_PRCVEN))) + '",'
					//endif
					cArqJson += '"descuento": "",
					
					//cArqJson += '"subtotal": "' + alltrim(str(iif(lNcc,(_cAlias02)->D1_TOTAL,(_cAlias02)->D2_TOTAL))) + '",'
					if !lNcc
						//if (_cAlias02)->D2_VALADI > 0
						if FR3->( dbSeek( xFilial("FR3")+"R"+(_cAlias01)->F2_DOC+(_cAlias01)->F2_SERIE+(_cAlias01)->F2_YCOD ) )
							//cArqJson += '"subtotal": "' + alltrim(str((_cAlias02)->D2_TOTAL/1.18)) + '",'
							cArqJson += '"subtotal": "' + alltrim(str((_cAlias02)->D2_TOTAL)) + '",'
						else
							if (_cAlias02)->D2_BASIMP1 > 0
								cArqJson += '"subtotal": "' + alltrim(str((_cAlias02)->D2_BASIMP1)) + '",'
							else
								cArqJson += '"subtotal": "' + alltrim(str((_cAlias02)->D2_TOTAL)) + '",'
							endif
						endif
					else
						cArqJson += '"subtotal": "' + alltrim(str((_cAlias02)->D1_BASIMP1)) + '",'
					endif
					/*
					if lNcc
						if (_cAlias02)->D1_BASIMP1>0
							cArqJson += '"subtotal": "' + alltrim(str( (_cAlias02)->D1_BASIMP1 )) + '",'
						else
							cArqJson += '"subtotal": "' + alltrim(str( (_cAlias02)->D1_BASIMP6 )) + '",'
						endif
					else
						if (_cAlias02)->D2_BASIMP1>0
							cArqJson += '"subtotal": "' + alltrim(str( (_cAlias02)->D2_BASIMP1 )) + '",'
						else
							cArqJson += '"subtotal": "' + alltrim(str( (_cAlias02)->D2_BASIMP6 )) + '",'
						endif
					endif
					*/
					
					if alltrim(cDepaCli)=="EX"
						cArqJson += '"tipo_de_igv": "16",'
					else
						if !lNcc
							if (_cAlias02)->D2_VALIMP1>0
								cArqJson += '"tipo_de_igv": "1",'
							else
								cArqJson += '"tipo_de_igv": "9",'
							endif
						else
							if (_cAlias02)->D1_VALIMP1>0
								cArqJson += '"tipo_de_igv": "1",'
							else
								cArqJson += '"tipo_de_igv": "9",'
							endif
						endif
					endif
					
					if alltrim(cDepaCli)=="EX"
						cArqJson += '"igv": "0",'
					else
						if lNcc
							if (_cAlias02)->D1_VALIMP1>0
								cArqJson += '"igv": "' + alltrim(str( (_cAlias02)->D1_VALIMP1 )) + '",'
							else
								cArqJson += '"igv": "' + alltrim(str( (_cAlias02)->D1_VALIMP6 )) + '",'
							endif
						else
							if (_cAlias02)->D2_VALIMP1>0
								cArqJson += '"igv": "' + alltrim(str( (_cAlias02)->D2_VALIMP1 )) + '",'
							else
								cArqJson += '"igv": "' + alltrim(str( (_cAlias02)->D2_VALIMP6 )) + '",'
							endif
						endif
					endif
					
					if !lNcc
						if (_cAlias02)->D2_VALADI>0
							//cArqJson += '"total": "' + alltrim(str(iif(lNcc,(_cAlias02)->D1_BASIMP1+(_cAlias02)->D1_VALIMP1,(_cAlias02)->D2_BASIMP1+(_cAlias02)->D2_VALIMP1))) + '",'
							cArqJson += '"total": "' + alltrim(str(iif(lNcc,(_cAlias02)->D1_TOTAL,(_cAlias02)->D2_TOTAL))) + '",'
						else
							cArqJson += '"total": "' + alltrim(str(iif(lNcc,(_cAlias02)->D1_TOTAL,(_cAlias02)->D2_TOTAL))) + '",'
						//else
							//cArqJson += '"total": "' + alltrim(str(iif(lNcc,(_cAlias02)->D1_TOTAL+(_cAlias02)->D1_VALIMP6,(_cAlias02)->D2_TOTAL+(_cAlias02)->D2_VALIMP6))) + '",'
						endif
					else
						//if (_cAlias02)->D1_VALIMP1>0
							//cArqJson += '"total": "' + alltrim(str(iif(lNcc,(_cAlias02)->D1_TOTAL+(_cAlias02)->D1_VALIMP1,(_cAlias02)->D2_TOTAL+(_cAlias02)->D2_VALIMP1))) + '",'
							cArqJson += '"total": "' + alltrim(str(iif(lNcc,(_cAlias02)->D1_TOTAL,(_cAlias02)->D2_TOTAL))) + '",'
						//else
							//cArqJson += '"total": "' + alltrim(str(iif(lNcc,(_cAlias02)->D1_TOTAL+(_cAlias02)->D1_VALIMP6,(_cAlias02)->D2_TOTAL+(_cAlias02)->D2_VALIMP6))) + '",'
						//endif
					endif
					
					//-------------------//
					// verifica anticipos
					//-------------------//
					if !lNcc
						if FR3->( dbSeek( xFilial("FR3")+"R"+(_cAlias02)->D2_DOC+(_cAlias02)->D2_SERIE+(_cAlias02)->D2_PEDIDO ) )

							If !ltemAnticipo

								cSerDeAnticipo := Alltrim( u_PuxaSer2( FR3->FR3_PREFIX ) )
								cDocDeAnticipo := right(alltrim(FR3->FR3_NUM),7)

								SD2->( dbSetOrder(3) ) // D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_COD, D2_ITEM
								If SD2->( MsSeek( xFilial("SD2")+FR3->FR3_NUM+FR3->FR3_PREFIX+(_cAlias01)->F2_CLIENTE+(_cAlias01)->F2_LOJA ) )
									cCodDelProdAnt := SD2->D2_COD
									cDesDelProdAnt := Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"SB1->B1_DESC")
								Endif

								ltemAnticipo := .t.

							Endif

							cArqJson += '"anticipo_regularizacion": "false",'
							cArqJson += '"anticipo_documento_serie": "",'
							cArqJson += '"anticipo_documento_numero": ""'
							/*
							cArqJson += '"anticipo_regularizacion": "true",'
							cArqJson += '"anticipo_documento_serie": "' + Alltrim( u_PuxaSer2( FR3->FR3_PREFIX ) ) + '",'
							cArqJson += '"anticipo_documento_numero": "' + right(alltrim(FR3->FR3_NUM),7) + '"'
							*/
						else
							cArqJson += '"anticipo_regularizacion": "false",'
							cArqJson += '"anticipo_documento_serie": "",'
							cArqJson += '"anticipo_documento_numero": ""'
						endif
					else
						cArqJson += '"anticipo_regularizacion": "false",'
						cArqJson += '"anticipo_documento_serie": "",'
						cArqJson += '"anticipo_documento_numero": ""'
					endif
					cArqJson += '},'
					
					if !lNcc
						if !empty((_cAlias02)->D2_REMITO)
							nNx := aScan( _aNroGuia, { |x| x[2] == alltrim((_cAlias02)->D2_REMITO) } )
							if nNx <= 0 //ascan( _aNroGuia, alltrim((_cAlias02)->D2_REMITO) ) <= 0
								Aadd( _aNroGuia, { alltrim((_cAlias02)->D2_SERIREM), alltrim((_cAlias02)->D2_REMITO) } )
							endif
						endif
					endif
					
					(_cAlias02)->( dbSkip() )
				
				EndDo

				// ---------------------------------------------------------------------------------------------------------------//
				// generar el item referente a los anticipos, segun nubefact se tiene que enviar el item del documento principal  //
				// referente a los anticipos                                                                                      //
				// ---------------------------------------------------------------------------------------------------------------//

				if ltemAnticipo .And. !lNcc
					
					cLin := "ZZ"
					nCant := "1"

					cArqJson += '{'
					cArqJson += '"unidad_de_medida": "' + cLin + '",'
					cArqJson += '"codigo": "' + Alltrim(cCodDelProdAnt) + '",'
					cArqJson += '"descripcion": "' + Alltrim(cDesDelProdAnt) + '",'
					cArqJson += '"cantidad": "' + nCant  + '",'
					cArqJson += '"valor_unitario": "' + alltrim(str((_cAlias01)->F2_VALFAT)) + '",'
					cArqJson += '"precio_unitario": "' + alltrim(str((_cAlias01)->F2_VALFAT)) + '",'
					cArqJson += '"descuento": "",
					cArqJson += '"subtotal": "' + alltrim(str((_cAlias01)->F2_VALFAT)) + '",'
					cArqJson += '"tipo_de_igv": "9",'
					cArqJson += '"igv": "0",'
					cArqJson += '"total": "' + alltrim(str((_cAlias01)->F2_VALFAT)) + '",'
					cArqJson += '"anticipo_regularizacion": "true",'
					cArqJson += '"anticipo_documento_serie": "' + Alltrim( u_PuxaSer2( cSerDeAnticipo ) ) + '",'
					cArqJson += '"anticipo_documento_numero": "' + right(alltrim(cDocDeAnticipo),7) + '"'
					cArqJson += '},'

				Endif
				
				cArqJson := substr(cArqJson,1,len(cArqJson)-1)

				lguiaok := .f.
				for nXi := 1 to len(_aNroGuia)
					if alltrim(_aNroGuia[nXi][1])=="G01"
						lguiaok := .t.
					endif
				next nXi
				
				if len(_aNroGuia) > 0 .and. lguiaok
					cSerie := ""
					cNGuia := ""
					cArqJson += '],'
					cArqJson += '"guias":'
					cArqJson += '['
					for nXi := 1 to len(_aNroGuia)
						if cSerie<>_aNroGuia[nXi][1] .And. cNGuia<>_aNroGuia[nXi][2]
							cSerie := _aNroGuia[nXi][1]
							cNGuia := _aNroGuia[nXi][2]
							cArqJson += '{'
							cArqJson += '"guia_tipo": "1",'
							cArqJson += '"guia_serie_numero": "' + u_PuxaSer2(_aNroGuia[nXi][1]) + "-" + _aNroGuia[nXi][2] + '"'
							cArqJson += '},'
						endif
					next nXi
					cArqJson := substr(cArqJson,1,len(cArqJson)-1)
					// cArqJson += ']'
				// else
				// 	cArqJson += ']'
				endif

				if lCreditoFE

					if lNcc
						cQuery := "SELECT E1_PARCELA AS PARCELA,
						cQuery += "		  E1_VENCREA AS VENCIMENTO,
						cQuery += "		  E1_SALDO AS SALDO
						cQuery += "  FROM " + InitSQLName("SE1")
						cQuery += " WHERE E1_FILIAL = '" + xFilial('SE1') + "'"
						cQuery += "   AND E1_NUM = '" + (_cAlias01)->F1_DOC + "'"
						cQuery += "   AND E1_PREFIXO = '" + (_cAlias01)->F1_SERIE + "'"
						cQuery += "   AND E1_CLIENTE = '" + (_cAlias01)->F1_FORNECE + "'"
						cQuery += "   AND E1_LOJA = '" + (_cAlias01)->F1_LOJA + "'"
						cQuery += "   AND D_E_L_E_T_ <> '*'"
						cQuery += " ORDER BY E1_NUM,E1_PARCELA"
					else
						cQuery := "SELECT E1_PARCELA AS PARCELA,
						cQuery += "		  E1_VENCREA AS VENCIMENTO,
						cQuery += "		  E1_SALDO AS SALDO
						cQuery += "  FROM " + InitSQLName("SE1")
						cQuery += " WHERE E1_FILIAL = '" + xFilial('SE1') + "'"
						cQuery += "   AND E1_NUM = '" + (_cAlias01)->F2_DOC + "'"
						cQuery += "   AND E1_PREFIXO = '" + (_cAlias01)->F2_SERIE + "'"
						cQuery += "   AND E1_CLIENTE = '" + (_cAlias01)->F2_CLIENTE + "'"
						cQuery += "   AND E1_LOJA = '" + (_cAlias01)->F2_LOJA + "'"
						cQuery += "   AND D_E_L_E_T_ <> '*'"
						cQuery += " ORDER BY E1_NUM,E1_PARCELA"
					endif

					If Select(_cAlias03) > 0
						(_cAlias03)->( dbCloseArea() )
					EndIf   
					
					dbUseArea(.T., "TOPCONN", tcGenQry(,,cQuery), _cAlias03 )

					If (_cAlias03)->( !Eof() )

						cArqJson += '],'
						cArqJson += '"venta_al_credito":'
						cArqJson += '['

						While (_cAlias03)->( !Eof() )

							cArqJson += '{'
							cArqJson += '"cuota": "' + if(empty((_cAlias03)->PARCELA),"1",(_cAlias03)->PARCELA) + '",'
							cArqJson += '"fecha_de_pago": "' + dtoc(stod((_cAlias03)->VENCIMENTO)) + '",'
							cArqJson += '"importe": "' + alltrim(str((_cAlias03)->SALDO)) + '"'
							cArqJson += '},'

							(_cAlias03)->( dbSkip() )

						EndDo

					EndIf

					(_cAlias03)->( dbCloseArea() )

					cArqJson := substr(cArqJson,1,len(cArqJson)-1)
					cArqJson += ']'

				else
					cArqJson += ']'
				endif

				
				u_XGRVLOG( cNomeArq,cArqJson,.T. )
				
				cHeadJson := cHeadJson + cArqJson
			
			EndIf
			
			cArqJson := '}'
			u_XGRVLOG( cNomeArq,cArqJson,.T. )
			
			cHeadJson := cHeadJson + cArqJson
			
			(_cAlias02)->( dbCloseArea() )
			
			cEncodeUTF8 := EncodeUTF8(cHeadJson, "cp1251")
			
			// ------------------------------------------------ //
			// Enviar arquivo Json cuando sao enviados en lote  //
			// ------------------------------------------------ //
			//cJson := u_XENVJSON( cHeadJson )
			cJson := u_XENVJSON( cEncodeUTF8 )
			
			If FWJsonDeserialize(cJson,@oParseJSON)
				//MsgStop(oParseJSON:menu:popup:menuitem[3]:onclick) //Será exibida a mensagem 'CloseDoc()'
			Endif
			
			cPDecode64 := ""
			cXDecode64 := ""
			cCDecode64 := ""
			_lError := .f.

			if lNcc
				SF1->( dbSetOrder(1) )
				SF1->( MsSeek( xFilial("SF1")+(_cAlias01)->F1_DOC+(_cAlias01)->F1_SERIE+(_cAlias01)->F1_FORNECE+(_cAlias01)->F1_LOJA ) )
			else
				SF2->( dbSetOrder(1) )
				SF2->( MsSeek( xFilial("SF2")+(_cAlias01)->F2_DOC+(_cAlias01)->F2_SERIE+(_cAlias01)->F2_CLIENTE+(_cAlias01)->F2_LOJA ) )
			endif
			
			if cJson<>NIL
			
				if at("errors",cJson) > 0
				
					_lError := .t.
				
					If Right(Alltrim(mv_par06),1)="\"
						cArqTmp := Alltrim(mv_par06)+cNomArq
					Else
						cArqTmp := Alltrim(mv_par06)+"\"+cNomArq
					EndIf
					
					cMsgErr := "Existen errores en la trasmision de los documentos, verifique archivo de log!"
					if lNcc
						u_XGRVLOG( cArqLog,Alltrim(SF1->F1_SERIE)+"-07-"+Alltrim(SF1->F1_DOC),.T. )
					else
						u_XGRVLOG( cArqLog,Alltrim(SF2->F2_SERIE)+"-01-"+Alltrim(SF2->F2_DOC),.T. )
					endif
					u_XGRVLOG( cArqLog,oParseJSON:errors,.T. )
					u_XGRVLOG( cArqLog,"----------------------------------------------------",.T. )
					lRet := .f.
					
					__CopyFile( cArqLog, cArqTmp )
					
				else
				
					_lError := .f.
					
					// aqui desactivar, caso error
					if oParseJSON:pdf_zip_base64<>Nil
						If Right(Alltrim(mv_par06),1)="\"
							cPDecode64 := Decode64(oParseJSON:pdf_zip_base64,Alltrim(mv_par06)+"pdf_zip_base64.zip",.T.)
							cArqDec := Alltrim(mv_par06)+"pdf_zip_base64"
						Else
							cPDecode64 := Decode64(oParseJSON:pdf_zip_base64,Alltrim(mv_par06)+"\pdf_zip_base64.zip",.T.)
							cArqDec := Alltrim(mv_par06)+"\pdf_zip_base64"
						EndIf	
						u_XGRVLOG( cArqDec+".txt",cPDecode64,.T. )
						FRename( cArqDec+".txt", cArqDec+"-"+Alltrim(SF2->F2_SERIE)+"-"+Alltrim(SF2->F2_DOC)+".zip", Nil, .T. )
					endif
					if oParseJSON:xml_zip_base64<>Nil
						If Right(Alltrim(mv_par06),1)="\"
							cXDecode64 := Decode64(oParseJSON:xml_zip_base64,Alltrim(mv_par06)+"xml_zip_base64.zip",.T.)
							cArqDec := Alltrim(mv_par06)+"xml_zip_base64"
						Else
							cXDecode64 := Decode64(oParseJSON:xml_zip_base64,Alltrim(mv_par06)+"\xml_zip_base64.zip",.T.)
							cArqDec := Alltrim(mv_par06)+"\xml_zip_base64"
						EndIf	
						u_XGRVLOG( cArqDec+".txt",cXDecode64,.T. )
						FRename( cArqDec+".txt", cArqDec+"-"+Alltrim(SF2->F2_SERIE)+"-"+Alltrim(SF2->F2_DOC)+".zip", Nil, .T. )
					endif
					if oParseJSON:cdr_zip_base64<>Nil
						If Right(Alltrim(mv_par06),1)="\"
							cCDecode64 := Decode64(oParseJSON:cdr_zip_base64,Alltrim(mv_par06)+"cdr_zip_base64.zip",.T.)
							cArqDec := Alltrim(mv_par06)+"cdr_zip_base64"
						Else
							cCDecode64 := Decode64(oParseJSON:cdr_zip_base64,Alltrim(mv_par06)+"\cdr_zip_base64.zip",.T.)
							cArqDec := Alltrim(mv_par06)+"\cdr_zip_base64"
						EndIf	
						u_XGRVLOG( cArqDec+".txt",cCDecode64,.T. )
						FRename( cArqDec+".txt", cArqDec+"-"+Alltrim(SF2->F2_SERIE)+"-"+Alltrim(SF2->F2_DOC)+".zip", Nil, .T. )
					endif

					cLinkPDF := Alltrim(oParseJSON:enlace)+".pdf"
					
					if lNcc
						SF1->( RecLock("SF1",.f.) )
						SF1->F1_YPDF	:= cPDecode64
						SF1->F1_YXML	:= cXDecode64
						SF1->F1_YCDR	:= cCDecode64
						SF1->F1_YQR		:= oParseJSON:cadena_para_codigo_qr
						SF1->F1_YHASH	:= oParseJSON:codigo_hash
						SF1->F1_YUSER	:= Upper(cUserName)
						SF1->F1_YDATA	:= dDataBase
						SF1->F1_YHORA	:= time()
						SF1->F1_YLINK	:= cLinkPDF
						SF1->( MsUnlock() )
					else
						SF2->( RecLock("SF2",.f.) )
						SF2->F2_YPDF	:= cPDecode64
						SF2->F2_YXML	:= cXDecode64
						SF2->F2_YCDR	:= cCDecode64
						SF2->F2_YQR		:= oParseJSON:cadena_para_codigo_qr
						SF2->F2_YHASH	:= oParseJSON:codigo_hash
						SF2->F2_YUSER	:= Upper(cUserName)
						SF2->F2_YDATA	:= dDataBase
						SF2->F2_YHORA	:= time()
						SF2->F2_YLINK	:= cLinkPDF
						SF2->( MsUnlock() )
					endif

					cArqTmp := ""
					
					cMsgOk := "Documento(s) enviado(s) correctamente!"
					lRet := .t.
				
				endif
	
			else
                
				_lError := .t.
				
				If Right(Alltrim(mv_par06),1)="\"
					cArqTmp := Alltrim(mv_par06)+cNomArq
				Else
					cArqTmp := Alltrim(mv_par06)+"\"+cNomArq
				EndIf
					
				cMsgErr := "Existen errores en la trasmision de los documentos, verifique archivo de log!"
				if lNcc
					u_XGRVLOG( cArqLog,Alltrim(SF1->F1_SERIE)+"-07-"+Alltrim(SF1->F1_DOC),.T. )
				else
					u_XGRVLOG( cArqLog,Alltrim(SF2->F2_SERIE)+"-01-"+Alltrim(SF2->F2_DOC),.T. )
				endif
				u_XGRVLOG( cArqLog,"Erro de comunicacion con Nubefact!, tente nuevamente de forma manual!",.T. )
				u_XGRVLOG( cArqLog,"----------------------------------------------------",.T. )
				lRet := .f.
					
				__CopyFile( cArqLog, cArqTmp )
			
			endif
			// ------------------------------------------------ //
			
			if _lError

				if lNcc
					SF1->( RecLock("SF1",.f.) )
					SF1->F1_YLOG := cNomArq
					SF1->( MsUnlock() )
				else
					SF2->( RecLock("SF2",.f.) )
					SF2->F2_YLOG := cNomArq
					SF2->( MsUnlock() )
				endif
			
			else

				if lNcc
					SF1->( RecLock("SF1",.f.) )
					SF1->F1_YLOG := ""
					SF1->( MsUnlock() )
				else
					SF2->( RecLock("SF2",.f.) )
					SF2->F2_YLOG := ""
					SF2->( MsUnlock() )
				endif
				
				// --------------------------------------- //
				// envia correo automaticamente al cliente //
				// --------------------------------------- //
				if lEnvMail
					u_IMPPDF(.f.,lNcc)
				endif
			
			endif
			
			(_cAlias01)->( dbSkip() )
	
		EndDo
		
	EndIf
	
	(_cAlias01)->( dbCloseArea() )
	
	If !Empty(cMsgErr)
		alert(cMsgErr)
		shellExecute( "Open", "C:\Windows\System32\notepad.exe", cArqTmp , "C:\", 1 )
	else
		if !empty(cLinkPDF)
			MsgInfo(cMsgOk,"ALREX")
			//ShellExecute( "Open", cLinkPDF, "", "C:\", 1 )
			//u_IMPPDF()
		else
			alert("Error al tentar transmitir el documento electronico!")
		endif
	EndIf
	
Return( lRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NFE00001  ºAutor  ³Microsiga           º Data ³  01/26/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function xGetNFOrig(_cNumDoc,_cSerDoc,_cCliDoc,_cLojDoc)

	Local cQry := ""
	Local _cAlias03 := getNextAlias()
	Local _aRet := {}
	Local __cSerie := ""
	Local __lTem := .f.

	SFP->( dbSetOrder(5) )	//FP_FILIAL, FP_FILUSO, FP_SERIE, FP_ESPECIE, R_E_C_N_O_, D_E_L_E_T_
	
	cQry := "SELECT D1_NFORI,D1_SERIORI"+CRLF
	cQry += "  FROM "+RetSqlname("SD1")+CRLF
	cQry += " WHERE D1_FILIAL='"+xFilial("SD1")+"'"+CRLF
	cQry += "   AND D1_ESPECIE='NCC'"+CRLF
	cQry += "   AND D1_DOC='"+_cNumDoc+"'"+CRLF
	cQry += "   AND D1_SERIE='"+_cSerDoc+"'"+CRLF
	cQry += "   AND D1_FORNECE='"+_cCliDoc+"'"+CRLF
	cQry += "   AND D1_LOJA='"+_cLojDoc+"'"+CRLF
	cQry += "   AND D_E_L_E_T_=''"+CRLF
	   
	dbUseArea(.T., "TOPCONN", tcGenQry(,,cQry), _cAlias03 )

	If (_cAlias03)->( !Eof() )

		(_cAlias03)->( dbGoTop() )

	 	While (_cAlias03)->( !Eof() )
	 	
			If SFP->( dbSeek( xFilial("SFP")+cFilAnt+(_cAlias03)->D1_SERIORI+"1" ) )
				__cSerie := Alltrim(SFP->FP_SERIE2)
				__lTem := .t.
			EndIf
			
			if !__lTem
				If SFP->( dbSeek( xFilial("SFP")+cFilAnt+(_cAlias03)->D1_SERIORI+"3" ) )
					__cSerie := Alltrim(SFP->FP_SERIE2)
					__lTem := .t.
				endif
			EndIf

	 		Aadd( _aRet, { (_cAlias03)->D1_NFORI,(_cAlias03)->D1_SERIORI,__cSerie } )
	 		
	 		(_cAlias03)->( dbSkip() )
	 	End
	 	
	EndIf
	
	(_cAlias03)->( dbCloseArea() )
		
Return( _aRet )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NFE00001  ºAutor  ³Microsiga           ºFecha ³  07/24/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xGetNFDeb(_cNumDoc,_cSerDoc,_cCliDoc,_cLojDoc)

	Local cQry := ""
	Local _cAlias03 := getNextAlias()
	Local _aRet := {}
	Local __cSerie := ""
	Local __lTem := .f.

	SFP->( dbSetOrder(5) )	//FP_FILIAL, FP_FILUSO, FP_SERIE, FP_ESPECIE, R_E_C_N_O_, D_E_L_E_T_
	
	cQry := "SELECT D2_NFORI,D2_SERIORI"+CRLF
	cQry += "  FROM "+RetSqlname("SD2")+CRLF
	cQry += " WHERE D2_FILIAL='"+xFilial("SD2")+"'"+CRLF
	cQry += "   AND D2_ESPECIE='NDC'"+CRLF
	cQry += "   AND D2_DOC='"+_cNumDoc+"'"+CRLF
	cQry += "   AND D2_SERIE='"+_cSerDoc+"'"+CRLF
	cQry += "   AND D2_CLIENTE='"+_cCliDoc+"'"+CRLF
	cQry += "   AND D2_LOJA='"+_cLojDoc+"'"+CRLF
	cQry += "   AND D_E_L_E_T_=''"+CRLF
	   
	dbUseArea(.T., "TOPCONN", tcGenQry(,,cQry), _cAlias03 )

	If (_cAlias03)->( !Eof() )

		(_cAlias03)->( dbGoTop() )

	 	While (_cAlias03)->( !Eof() )
	 	
			If SFP->( dbSeek( xFilial("SFP")+cFilAnt+(_cAlias03)->D2_SERIORI+"1" ) )
				If !Empty(SFP->FP_YSERIE)
					__cSerie := Alltrim(SFP->FP_YSERIE)
					__lTem := .t.
				EndIf
			EndIf

	 		Aadd( _aRet, { (_cAlias03)->D2_NFORI,(_cAlias03)->D2_SERIORI,__cSerie } )
	 		
	 		(_cAlias03)->( dbSkip() )
	 	End
	 	
	EndIf
	
	(_cAlias03)->( dbCloseArea() )
		
Return( _aRet )

Static Function getCuotas(lNcc,xDoc,xSerie,xCliFor,xLoja)

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

Return( aret )
