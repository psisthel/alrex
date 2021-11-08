#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LOCXPE27  ºAutor  ³Microsiga           º Data ³  01/24/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Genera el archivo Json de la anulacion de la facrura de    º±±
±±º          ³ salida                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LOCXPE27

	Local c_area	:= getArea() 
	Local c_areac6	:= SC6->( getArea() )
	Local cJSON
	Local oParseJSON
	Local lRet		:= .f.
	Local cMsgErr	:= ""
	Local cMsgOk	:= ""
	Local cNomArq	:= "log_"+dtos(date())+"_"+replace(time(),":","")+"_anulado.log"
	Local cArqLog	:= "\log\"+cNomArq
	Local cMotivo	:= "INFORME EL MOTIVO DE LA ANULACION"

	If alltrim(FUNNAME())$'MATA467N/MATA465N'		// facrura de salida
		
		If __nOpcx==5 //.OR. __nOpcx==5			// Anulacion
			
			If SF2->(FieldPos("F2_YQR"))>0 .And. SF2->(FieldPos("F2_YHASH"))>0
		
				If !(Empty(SF2->F2_YQR)) .And. !(Empty(SF2->F2_YHASH))
			
					cMotivo := getMotivo( cMotivo )
				
					cRUCEmp	:= Alltrim(SM0->M0_CGC)
					cSeirSFP := Alltrim( u_PuxaSer2( SF2->F2_SERIE ) )
					cSeirSFP := If( cSeirSFP=="","F"+SF2->F2_SERIE,cSeirSFP )
					cPasta := Alltrim(GetNewPar("AL_DIRNFE","C:\Temp"))
		
					If Right(Alltrim(cPasta),1)="\"
						cNomeArq := Alltrim(cPasta)+;
									Strzero(Day(dDataBase),2)+Strzero(Month(dDataBase),2)+Strzero(Year(dDataBase),4)+;
									"-"+cRUCEmp+"-01-"+cSeirSFP+"-"+Right(Alltrim(SF2->F2_DOC),8)+"_anulado.json"
					Else
						cNomeArq := Alltrim(cPasta)+"\"+;
									Strzero(Day(dDataBase),2)+Strzero(Month(dDataBase),2)+Strzero(Year(dDataBase),4)+;
									"-"+cRUCEmp+"-01-"+cSeirSFP+"-"+Right(Alltrim(SF2->F2_DOC),8)+"_anulado.json"
					EndIf
					
					If File(cNomeArq)
				
						If Alert("O arquivo "+ Alltrim(cNomeArq)+" ya fue generado!"+CRLF+"Será substituido!")
							If FERASE(Alltrim(cNomeArq)) == -1
								MsgStop('Falla al borrar el archivo!')
							Endif
						EndIf
						
					EndIf
			
					cNomeArq := Upper(cNomeArq)
					
					__cSerie2 := Alltrim( u_PuxaSer2( SF2->F2_SERIE ) )
					
					cHeadJson := ""
					cHeadJson += '{'
					cHeadJson += '"operacion": "generar_anulacion",'
					if SF2->F2_TPDOC=="01"	// factura
						cHeadJson += '"tipo_de_comprobante": 1,'
					elseif SF2->F2_TPDOC=="03"	// boleta
						cHeadJson += '"tipo_de_comprobante": 2,'
					elseif SF2->F2_TPDOC=="07"	// nota de credito
						cHeadJson += '"tipo_de_comprobante": 3,'
					elseif SF2->F2_TPDOC=="08"	// nota de debito
						cHeadJson += '"tipo_de_comprobante": 4,'
					endif
					cHeadJson += '"serie": "' + __cSerie2 + '",'
					cHeadJson += '"numero": "' + strzero(val(SF2->F2_DOC),8) + '",'
					cHeadJson += '"motivo": "' + cMotivo + '",'
					cHeadJson += '"codigo_unico": ""'
					cHeadJson += '}'
					
					u_XGRVLOG( cNomeArq,cHeadJson,.T. )
					
					cJson := u_XENVJSON( cHeadJson )
					If FWJsonDeserialize(cJson,@oParseJSON)
					Endif
					
					if cJson<>NIL
					
						if at("errors",cJson) > 0
						
							If Right(Alltrim(cPasta),1)="\"
								cArqTmp := Alltrim(cPasta)+cNomArq
							Else
								cArqTmp := Alltrim(cPasta)+"\"+cNomArq
							EndIf
							
							cMsgErr := "Existen errores en la trasmision de los documentos, verifique archivo de log!"
							u_XGRVLOG( cArqLog,Alltrim(SF2->F2_SERIE)+"-"+Alltrim(SF2->F2_DOC),.T. )
							u_XGRVLOG( cArqLog,oParseJSON:errors,.T. )
							u_XGRVLOG( cArqLog,"----------------------------------------------------",.T. )
							lRet := .f.
							
							__CopyFile( cArqLog, cArqTmp )
							
							//alert(cMsg)
							
						else
						
							cPDecode64 := ""
							cXDecode64 := ""
							cCDecode64 := ""
								
							//cPDecode64 := Decode64(oParseJSON:pdf_zip_base64,"",.T.)
							//cXDecode64 := Decode64(oParseJSON:xml_zip_base64,"",.T.)
							//cCDecode64 := Decode64(oParseJSON:cdr_zip_base64,"C:\\Temp\\tst_3.cdr",.T.)
							cLinkPDF := Alltrim(oParseJSON:enlace)+".pdf"
							
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
						
							cMsgOk := "Documento(s) enviado(s) correctamente!"
							lRet := .t.
							
						endif
						
					else
						cMsgErr := "Error en la transmision con Nubefact"
					endif
						
					If !Empty(cMsgErr)
					
						SF2->( RecLock("SF2",.f.) )
						SF2->F2_YLOG := cArqTmp
						SF2->( MsUnlock() )
	
						alert(cMsgErr)
						shellExecute( "Open", "C:\Windows\System32\notepad.exe", cArqTmp , "C:\", 1 )
					else
						MsgInfo(cMsgOk,"ALREX")
						ShellExecute( "Open", cLinkPDF, "", "C:\", 1 )
					EndIf

				EndIf
				
			EndIf
			
		EndIf
		
	EndIf
	
	RestArea(c_area)
	SC6->( RestArea(c_areac6) )

REturn

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LOCXPE27  ºAutor  ³Microsiga           º Data ³  01/24/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function getMotivo( cMotivo )

	Local oDlg
	Local cTexto := cMotivo
	Local oMemo 
	Local oBtnOk
	Local nOpc := 0

	While nOpc==0

		DEFINE MSDIALOG oDlg TITLE "Motivo de Anulación" FROM 0,0 TO 250,450 PIXEL 
		@ 020,005 GET oMemo VAR cTexto MEMO SIZE 215,100 VALID !empty(cTexto) OF oDlg PIXEL 
	
		DEFINE SBUTTON oBtnOk FROM 005,005 TYPE 1 ACTION( nOpc:=1,oDlg:End() ) ENABLE OF oDlg
	      
		ACTIVATE MSDIALOG oDlg CENTERED 
		
		if nOpc == 1
			if len(cTexto) > 100
				Alert("Motivo de la anulación ultrapasa el limite de 100 caracteres solicitados por SUNAT!")
				nOpc := 0
				loop
			endif
			if empty(cTexto)
				Alert("Motivo de la anulación NO puede estar en blanco!")
				nOpc := 0
				loop
			endif
		endif
		
	End
		
Return( cTexto )
