#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"  
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "Font.ch"
#define CRLF chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SBSENVMAILºAutor  ³Microsiga           º Data ³  05/02/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Envia correo de confirmacion del PV                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SBSEnvMail(clEmailTo, clAssunto, clMensagem, clEmailCc, clAnexos, cAccount, cPassword, llJob)

	Local lRet 		:= .T.   
	Local cServer   := alltrim(GetNewPar("AL_SERVER","smtp.gmail.com:465"))
	Local lMailAuth := GetNewPar("AL_AUTHEN",.F.)
	Local clMsgErro	:= ""
	Local _cErro	:= ""
	Local cAccount	:= alltrim(GetNewPar("AL_MAILENV","ventas@alrex.com.pe"))
	Local cPassword	:= alltrim(GetNewPar("AL_PASSENV","Humboldt123"))
	
	Default clEmailTo 	:= ""
	Default clAssunto 	:= "Sin Asunto"
	Default clMensagem	:= ""
	Default clEmailCc	:= ""
	Default clAnexos	:= ""
	Default llJob		:= .F.
	           
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se os parâmetros foram preenchidos corretamente³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if Empty(clEmailTo)
		lRet := .F.
		clMsgErro += "Parâmetro de e-mail del destinatário no está digitado!" + CRLF
	endif
	
	if Empty(clMensagem)
		lRet := .F.
		clMsgErro += "Parâmetro de mensaje del E-mail no está digitado!" + CRLF
	endif
	
	if Empty( cAccount )
		lRet := .F.
		clMsgErro += "Parâmetro de la cuenta de E-mail o Contrasena no está digitado!" + CRLF
	endif
	         
	if lRet
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Realiza a Conexão com o Servidor de E-mail³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		CONNECT SMTP SERVER cServer;
		ACCOUNT cAccount;
		PASSWORD cPassword;
		RESULT _lOK
		                    
		if _lOk
			
			if lMailAuth
			 	MailAuth(cAccount,cPassword)
			endif
		
			SEND MAIL FROM cAccount; 
			TO clEmailTo;
			CC clEmailCc;
			SUBJECT clAssunto; 
			BODY clMensagem;
			ATTACHMENT clAnexos;
			RESULT _lOk	
				                            
			if !_lOk
				GET MAIL ERROR _cErro
				clMsgErro += "Erro durante el Envio del E-mail -> " + _cErro + CRLF
			endif
			
			DISCONNECT SMTP SERVER RESULT _lOK
			
			if !_lOk
				GET MAIL ERROR _cErro
				clMsgErro += "Erro durante el Envio del E-mail -> " + _cErro + CRLF
			endif
		else
			clMsgErro += "Erro durante el Envio del E-mail -> No fue posible conectar con el servidor de e-mail. Verifique los parâmetros del sistema abajo:" + CRLF
			clMsgErro += "AL_SERVER (Servidor) = " + cServer + CRLF
			clMsgErro += "Cuenta del E-mail del usuario = " + cAccount + CRLF
			clMsgErro += "(Contrasena) "
		endif
		
	endif
	
	if !Empty( clMsgErro )
		lRet := .F.
		
		//U_SBGRVTXT( "\log_FUEnvMail_"+DtoS(Date())+"_"+Strtran(Time(), ":", "")+".txt", clMsgErro )
		
		if !llJob
			Aviso( "Erros durante el Envio de E-mail", clMsgErro , {"&Ok"}, 3)
		endif

	endif

Return lRet
