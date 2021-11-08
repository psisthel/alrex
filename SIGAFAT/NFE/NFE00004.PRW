#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "FONT.CH"
#include "fileio.ch"
#define CRLF chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNFE00004  บAutor  ณPercy Arias,SISTHEL บFecha ณ  07/25/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Genera archivo de Anulacion de documentos Electronicos     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function NFE004( lAuto,lNcc )

	Local _aArea	:= getArea()
	Local _nOpc		:= 0
	Local oDlg
	Local cTitulo	:= "Facturacion Electronica"
	Local cPerg		:= PADR("NFE001",Len(SX1->X1_GRUPO))
	Local lRet		:= .t.
	
	Default lAuto	:= .f.

	//Private cNomArq	:= "log_"+dtos(date())+"_"+replace(time(),":","")+"_anulado.log"
	//Private cArqLog	:= "\log\"+cNomArq
	//Private cArqTmp
	//Private cArqDec
	Private oFont6  := NIL
	Define FONT oFont6 NAME "Arial"
	
	if !lAuto
		//ValidPerg(cPerg)
		If Pergunte(cPerg,.t.)
	
			DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
		
			@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL
			
			@ 015,017 SAY "Esta rotina tiene por objetivo transmitir los documentos"	OF oDlg PIXEL Size 150,010 FONT oFont6 
			@ 025,017 SAY "documentos electronicos anulados a SUNAT."					OF oDlg PIXEL Size 150,010 FONT oFont6 
			
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
			SX1->X1_CNT01 := GetNewPar("AA_DIRNFE","C:\Temp")
			SX1->( MsUnlock() )
		EndIf

		_nOpc := 1
		Pergunte(cPerg,.f.)
		
	endif
	
	If _nOpc == 1
		MsgRun( "Aguarde, generando documento(s) electronico(s)..." ,, {|| lRet := GenAnulcion( lNcc ) } )
	Endif

	RestArea( _aArea )
	
Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNFE00004  บAutor  ณMicrosiga           บFecha ณ  07/25/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GenAnulcion( lNcc )

	Local cJSON
	Local oParseJSON
	Local lRet		:= .f.
	Local cMsgErr	:= ""
	Local cMsgOk	:= ""
	Local cNomArq	:= "log_"+dtos(date())+"_"+replace(time(),":","")+"_anulado.log"
	Local cArqLog	:= "\log\"+cNomArq
	Local cMotivo	:= "INFORME EL MOTIVO DE LA ANULACION"
	Local _cAlias01	:= getNextAlias()
	Local cQuery	:= ""
	Local cArqTmp	:= ""
	
	if lNcc
		cQuery := "SELECT * FROM " + InitSQLName("SF1")
		cQuery += " WHERE F1_FILIAL = '" + xFilial('SF1') + "'"
		cQuery += "   AND F1_DOC BETWEEN '" + mv_par02 + "' AND '" + mv_par03 + "'"
		cQuery += "   AND F1_SERIE = '" + mv_par01 + "'"
		cQuery += "   AND F1_EMISSAO BETWEEN '" + DtoS(mv_par04) + "' AND '" + DtoS(mv_par05) + "'"
		cQuery += "   AND F1_ESPECIE='NCC'"
		cQuery += "   AND D_E_L_E_T_ = '*'"
		cQuery += "   AND F1_YHASH <> ' '"
		cQuery += "   AND F1_YQR <> ' '"
		cQuery += "   AND F1_YLINK <> ' '"
		cQuery += " ORDER BY F1_DOC"
	else
		cQuery := "SELECT * FROM " + InitSQLName("SF2")
		cQuery += " WHERE F2_FILIAL = '" + xFilial('SF2') + "'"
		cQuery += "   AND F2_DOC BETWEEN '" + mv_par02 + "' AND '" + mv_par03 + "'"
		cQuery += "   AND F2_SERIE = '" + mv_par01 + "'"
		cQuery += "   AND F2_EMISSAO BETWEEN '" + DtoS(mv_par04) + "' AND '" + DtoS(mv_par05) + "'"
		cQuery += "   AND D_E_L_E_T_ = '*'"
		cQuery += "   AND F2_YHASH <> ' '"
		cQuery += "   AND F2_YQR <> ' '"
		cQuery += "   AND F2_YLINK <> ' '"
		cQuery += " ORDER BY F2_DOC"
	endif
	
	dbUseArea( .T., "TOPCONN", tcGenQry(,,cQuery), _cAlias01 )
	
	If (_cAlias01)->( !Eof() )
	
		cMotivo := getMotivo( cMotivo )
		cPasta := Alltrim(GetNewPar("AA_DIRNFE","C:\Temp"))
	
		While (_cAlias01)->( !Eof() )
			
			cRUCEmp	:= Alltrim(SM0->M0_CGC)
			cSeirSFP := Alltrim( u_PuxaSer2( if(lNcc,(_cAlias01)->F1_SERIE,(_cAlias01)->F2_SERIE ) ) )
			cSeirSFP := If( cSeirSFP=="","F"+if(lNcc,(_cAlias01)->F1_SERIE,(_cAlias01)->F2_SERIE),cSeirSFP )
	
			If Right(Alltrim(cPasta),1)="\"
				cNomeArq := Alltrim(cPasta)+;
							Strzero(Day(dDataBase),2)+Strzero(Month(dDataBase),2)+Strzero(Year(dDataBase),4)+;
							"-"+cRUCEmp+"-01-"+cSeirSFP+"-"+Right(Alltrim( if(lNcc, (_cAlias01)->F1_DOC, (_cAlias01)->F2_DOC ) ),8)+"_anulado.json"
			Else
				cNomeArq := Alltrim(cPasta)+"\"+;
							Strzero(Day(dDataBase),2)+Strzero(Month(dDataBase),2)+Strzero(Year(dDataBase),4)+;
							"-"+cRUCEmp+"-01-"+cSeirSFP+"-"+Right(Alltrim( if(lNcc, (_cAlias01)->F1_DOC, (_cAlias01)->F2_DOC ) ),8)+"_anulado.json"
			EndIf
		
			If File(cNomeArq)
	
				If Alert("O arquivo "+ Alltrim(cNomeArq)+" ya fue generado!"+CRLF+"Serแ substituido!")
					If FERASE(Alltrim(cNomeArq)) == -1
						MsgStop('Falla al borrar el archivo!')
					Endif
				EndIf
			
			EndIf
	
			cNomeArq := Upper(cNomeArq)
			
			__cSerie2 := Alltrim( u_PuxaSer2( if(lNcc, (_cAlias01)->F1_SERIE,(_cAlias01)->F2_SERIE ) ) )
				
			cHeadJson := ""
			cHeadJson += '{'
			cHeadJson += '"operacion": "generar_anulacion",'
			if lNcc
				if (_cAlias01)->F1_TPDOC=="01"	// factura
					cHeadJson += '"tipo_de_comprobante": 1,'
				elseif (_cAlias01)->F1_TPDOC=="03"	// boleta
					cHeadJson += '"tipo_de_comprobante": 2,'
				elseif (_cAlias01)->F1_TPDOC=="07"	// nota de credito
					cHeadJson += '"tipo_de_comprobante": 3,'
				elseif (_cAlias01)->F1_TPDOC=="08"	// nota de debito
					cHeadJson += '"tipo_de_comprobante": 4,'
				endif
			else
				if (_cAlias01)->F2_TPDOC=="01"	// factura
					cHeadJson += '"tipo_de_comprobante": 1,'
				elseif (_cAlias01)->F2_TPDOC=="03"	// boleta
					cHeadJson += '"tipo_de_comprobante": 2,'
				elseif (_cAlias01)->F2_TPDOC=="07"	// nota de credito
					cHeadJson += '"tipo_de_comprobante": 3,'
				elseif (_cAlias01)->F2_TPDOC=="08"	// nota de debito
					cHeadJson += '"tipo_de_comprobante": 4,'
				endif
			endif
			cHeadJson += '"serie": "' + __cSerie2 + '",'
			if lNcc
				cHeadJson += '"numero": "' + strzero(val((_cAlias01)->F1_DOC),8) + '",'
			else
				cHeadJson += '"numero": "' + strzero(val((_cAlias01)->F2_DOC),8) + '",'
			endif
			cHeadJson += '"motivo": "' + cMotivo + '",'
			cHeadJson += '"codigo_unico": ""'
			cHeadJson += '}'
			
			u_XGRVLOG( cNomeArq,cHeadJson,.T. )
				
			cJson := u_XENVJSON( cHeadJson )
			If FWJsonDeserialize(cJson,@oParseJSON)
			Endif
				
			if at("errors",cJson) > 0
				
				If Right(Alltrim(cPasta),1)="\"
					cArqTmp := Alltrim(cPasta)+cNomArq
				Else
					cArqTmp := Alltrim(cPasta)+"\"+cNomArq
				EndIf
					
				cMsgErr := "Existen errores en la trasmision de los documentos, verifique archivo de log!"
				u_XGRVLOG( cArqLog,Alltrim( if( lNcc,(_cAlias01)->F1_SERIE,(_cAlias01)->F2_SERIE ) )+"-"+Alltrim( if(lNcc,(_cAlias01)->F1_DOC,(_cAlias01)->F2_DOC ) ),.T. )
				u_XGRVLOG( cArqLog,oParseJSON:errors,.T. )
				u_XGRVLOG( cArqLog,"----------------------------------------------------",.T. )
				lRet := .f.
					
				__CopyFile( cArqLog, cArqTmp )
					
			else
				
				cPDecode64 := ""
				cXDecode64 := ""
				cCDecode64 := ""
						
				cPDecode64 := Decode64(oParseJSON:pdf_zip_base64,"",.T.)
				cXDecode64 := Decode64(oParseJSON:xml_zip_base64,"",.T.)
				//cCDecode64 := Decode64(oParseJSON:cdr_zip_base64,"C:\\Temp\\tst_3.cdr",.T.)
				cLinkPDF := Alltrim(oParseJSON:enlace)+".pdf"

				cJsonNum := alltrim(str(oParseJSON:numero))
				cJsonTik := oParseJSON:sunat_ticket_numero
				cJsonDes := if(oParseJSON:sunat_description==Nil,"",oParseJSON:sunat_description)
				cJsonNot := if(oParseJSON:sunat_note==Nil,"",oParseJSON:sunat_note)
				cJsonRsp := if(oParseJSON:sunat_responsecode==Nil,"",oParseJSON:sunat_responsecode)

				if lNcc
					cQuery := "UPDATE " + InitSQLName("SF1")
					cQuery += " F1_YCANNUM="+cJsonNum+","
					cQuery += " F1_YCANLNK='"+cLinkPDF+"',"
					cQuery += " F1_YCANSUN='"+cJsonTik+"',"
					cQuery += " F1_YCANPDF='"+cPDecode64+"',"
					cQuery += " F1_YCANXML='"+cXDecode64+"',"
					cQuery += " F1_YCANCDR='"+cCDecode64+"',"
					cQuery += " F1_YERRDES='"+cJsonDes+"',"
					cQuery += " F1_YERRNOT='"+cJsonNot+"',"
					cQuery += " F1_YERRCOD='"+cJsonRsp+"',"
					cQuery += " F1_YCANUSR='"+Upper(cUserName)+"',"
					cQuery += " F1_YCANDAT='"+dtos(dDataBase)+"',"
					cQuery += " F1_YCANHOR='"+time()+"',"
					cQuery += " F1_YMOTANU='"+cMotivo+"',"
					cQuery += " F1_YLOG='"+cNomArq+"'"
					cQuery += " WHERE F1_FILIAL = '" + xFilial('SF1') + "'"
					cQuery += "   AND F1_DOC BETWEEN '" + mv_par02 + "' AND '" + mv_par03 + "'"
					cQuery += "   AND F1_SERIE = '" + mv_par01 + "'"
					cQuery += "   AND F1_EMISSAO BETWEEN '" + DtoS(mv_par04) + "' AND '" + DtoS(mv_par05) + "'"
					cQuery += "   AND F1_ESPECIE='NCC'"
					cQuery += "   AND D_E_L_E_T_ = '*'"
					cQuery += "   AND F1_YHASH = ' '"
					cQuery += "   AND F1_YQR = ' '"
					cQuery += "   AND F1_YLINK = ' '"
				else
					cQuery := "UPDATE " + InitSQLName("SF2") + " SET"
					cQuery += " F2_YCANNUM="+cJsonNum+","
					cQuery += " F2_YCANLNK='"+cLinkPDF+"',"
					cQuery += " F2_YCANSUN='"+cJsonTik+"',"
					cQuery += " F2_YCANPDF='"+cPDecode64+"',"
					cQuery += " F2_YCANXML='"+cXDecode64+"',"
					cQuery += " F2_YCANCDR='"+cCDecode64+"',"
					cQuery += " F2_YERRDES='"+cJsonDes+"',"
					cQuery += " F2_YERRNOT='"+cJsonNot+"',"
					cQuery += " F2_YERRCOD='"+cJsonRsp+"',"
					cQuery += " F2_YCANUSR='"+Upper(cUserName)+"',"
					cQuery += " F2_YCANDAT='"+dtos(dDataBase)+"',"
					cQuery += " F2_YCANHOR='"+time()+"',"
					cQuery += " F2_YMOTANU='"+cMotivo+"',"
					cQuery += " F2_YLOG='"+cNomArq+"'"
					cQuery += " WHERE F2_FILIAL = '" + xFilial('SF2') + "'"
					cQuery += "   AND F2_DOC BETWEEN '" + mv_par02 + "' AND '" + mv_par03 + "'"
					cQuery += "   AND F2_SERIE = '" + mv_par01 + "'"
					cQuery += "   AND F2_EMISSAO BETWEEN '" + DtoS(mv_par04) + "' AND '" + DtoS(mv_par05) + "'"
					cQuery += "   AND D_E_L_E_T_ = '*'"
					cQuery += "   AND F2_YHASH = ' '"
					cQuery += "   AND F2_YQR = ' '"
					cQuery += "   AND F2_YLINK = ' '"
				endif
				/*
				SF2->( RecLock("SF2",.f.) )
				SF2->F2_YCANNUM	:= oParseJSON:numero
				SF2->F2_YCANLNK	:= cLinkPDF
				SF2->F2_YCANSUN	:= oParseJSON:sunat_ticket_numero
				SF2->F2_YCANPDF	:= cPDecode64
				SF2->F2_YCANXML	:= cXDecode64
				SF2->F2_YCANCDR	:= cCDecode64
				SF2->F2_YERRDES	:= oParseJSON:sunat_description
				SF2->F2_YERRNOT	:= oParseJSON:sunat_note
				SF2->F2_YERRCOD	:= oParseJSON:sunat_responsecode
				SF2->F2_YCANUSR	:= Upper(cUserName)
				SF2->F2_YCANDAT	:= dDataBase
				SF2->F2_YCANHOR	:= time()
				SF2->F2_YMOTANU	:= cMotivo
				SF2->( MsUnlock() )
				*/
				cMsgOk := "Documento(s) enviado(s) correctamente!"
				lRet := .t.
					
			endif
				
			If !Empty(cMsgErr)
				alert(cMsgErr)
				shellExecute( "Open", "C:\Windows\System32\notepad.exe", cArqTmp , "C:\", 1 )
			else
				MsgInfo(cMsgOk,"GT")
				ShellExecute( "Open", cLinkPDF, "", "C:\", 1 )
			EndIf
			
			(_cAlias01)->( dbSkip() )
			
		End
	
	Else
	
		MsgInfo("ก Documento Electronoico No consta en SUNAT !"+CRLF+"ก Anulaci๓n Invalida !","GT")
			
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLOCXPE27  บAutor  ณMicrosiga           บ Data ณ  01/24/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function getMotivo( cMotivo )

	Local oDlg
	Local cTexto := cMotivo
	Local oMemo 
	Local oBtnOk
	Local nOpc := 0

	While nOpc==0

		DEFINE MSDIALOG oDlg TITLE "Motivo de Anulaci๓n" FROM 0,0 TO 250,450 PIXEL 
		@ 020,005 GET oMemo VAR cTexto MEMO SIZE 215,100 VALID !empty(cTexto) OF oDlg PIXEL 
	
		DEFINE SBUTTON oBtnOk FROM 005,005 TYPE 1 ACTION( nOpc:=1,oDlg:End() ) ENABLE OF oDlg
	      
		ACTIVATE MSDIALOG oDlg CENTERED 
		
		if nOpc == 1
			if len(cTexto) > 100
				Alert("Motivo de la anulaci๓n ultrapasa el limite de 100 caracteres solicitados por SUNAT!")
				nOpc := 0
				loop
			endif
			if empty(cTexto)
				Alert("Motivo de la anulaci๓n NO puede estar en blanco!")
				nOpc := 0
				loop
			endif
		endif
		
	End
		
Return( cTexto )
