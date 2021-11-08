#INCLUDE "PROTHEUS.CH"
#include 'Ap5Mail.ch'

/********************************************************
Utilizando classe TMailMessage
********************************************************/
User Function FBEMail(cPara,cAssunto,cMensagem,aArquivos,cToCC,cMailConta,cMailSenha)

	Local cMsg := ""
	Local xRet
	Local oServer, oMessage
	Local lMailAuth	:= SuperGetMv("MV_RELAUTH",,.F.)
	Local nPorta := SuperGetMv("AL_SMTP",,587) //informa a porta que o servidor SMTP ir� se comunicar, podendo ser 25 ou 587

	//A porta 25, por ser utilizada h� mais tempo, possui uma vulnerabilidade maior a 
	//ataques e intercepta��o de mensagens, al�m de n�o exigir autentica��o para envio 
	//das mensagens, ao contr�rio da 587 que oferece esta seguran�a a mais.
			
	Private cMailServer	:= "SEUIP" //Provis�rio, pois no parametro j� existe a porta
	Private cMailSenha	:= NIL
	
	//Default cMailConta	:= NIL
	//Default cMailSenha  := alltrim(SuperGetMv("AL_PWSMAL",,"Humboldt123"))
	Default cMailSenha  := alltrim(SuperGetMv("AL_PWSMAL",,"@LR3x4lrEX!"))
	
	//Default aArquivos := {}

	cMailConta  := alltrim(GETMV("MV_RELACNT"))   		        //Conta utilizada para envio do email
	cMailServer := alltrim(SuperGetMv("AL_SRVMAL",,"smtp.gmail.com"))									//alltrim(If(cMailServer == NIL,GETMV("MV_RELSERV"),cMailServer))           //Servidor SMTP
	//cMailSenha  := alltrim(cMailSenha)															//alltrim(If(cMailSenha == NIL,GETMV("MV_RELPSW"),cMailSenha))             //Senha da conta de e-mail utilizada para envio
	cMailSenha  := alltrim(GETMV("MV_RELPSW"))             //Senha da conta de e-mail utilizada para envio
   	oMessage	:= TMailMessage():New()
	oMessage:Clear()
   
	oMessage:cDate	 := cValToChar( Date() )
	oMessage:cFrom 	 := alltrim(cMailConta)
	oMessage:cTo 	 := alltrim(cPara)
	oMessage:cCc 	 := alltrim(cToCC)
	oMessage:cSubject:= cAssunto
	oMessage:cBody 	 := replace(cMensagem,chr(13)+chr(10),"<br>")
	
	oMessage:MsgBodyType( "text/html" )
	oMessage:AttachFile( aArquivos )
	
	/*
	If Len(aArquivos) > 0
		For nArq := 1 To Len(aArquivos)
			xRet := oMessage:AttachFile( aArquivos[nArq] )
			if xRet < 0
				cMsg := "O arquivo " + aArquivos[nArq] + " n�o foi anexado!"
				alert( cMsg )
				return
			endif
		Next nArq
	EndIf		
	*/
	   
	oServer := tMailManager():New()
	oServer:SetUseTLS( .T. ) //Indica se ser� utilizar� a comunica��o segura atrav�s de SSL/TLS (.T.) ou n�o (.F.)
   
	xRet := oServer:Init( "", cMailServer, cMailConta, cMailSenha, 0, nPorta ) //inicilizar o servidor
	if xRet != 0
		alert("El servidor SMTP no fue iniciado: " + oServer:GetErrorString( xRet ) )
		return(.f.)
	endif
   
	xRet := oServer:SetSMTPTimeout( 120 ) //Indica o tempo de espera em segundos.
	if xRet != 0
		alert("No fue posible definir " + cProtocol + " tiempo limite para " + cValToChar( nTimeout ))
		return(.f.)
	endif
   
	xRet := oServer:SMTPConnect()
	if xRet <> 0
		alert("No fue posible conectar al servidor SMTP: " + oServer:GetErrorString( xRet ))
		return(.f.)
	endif
   
	if lMailAuth
		//O m�todo SMTPAuth ao tentar realizar a autentica��o do 
		//usu�rio no servidor de e-mail, verifica a configura��o 
		//da chave AuthSmtp, na se��o [Mail], no arquivo de 
		//configura��o (INI) do TOTVS Application Server, para determinar o valor.
		xRet := oServer:SmtpAuth( cMailConta, cMailSenha )
		if xRet <> 0
			cMsg := "SMTP server no fue autenticado: " + oServer:GetErrorString( xRet )
			alert( cMsg )
			oServer:SMTPDisconnect()
			return(.f.)
		endif
   	Endif
	xRet := oMessage:Send( oServer )
	if xRet <> 0
		alert("No fue posible enviar mensaje: " + oServer:GetErrorString( xRet ))
		return(.f.)
	endif
   
	xRet := oServer:SMTPDisconnect()
	if xRet <> 0
		alert("No fue posible desconectar el servidor SMTP: " + oServer:GetErrorString( xRet ))
		return(.f.)
	endif
	
return( .t. )