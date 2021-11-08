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
	Local nPorta := SuperGetMv("AL_SMTP",,587) //informa a porta que o servidor SMTP irá se comunicar, podendo ser 25 ou 587

	//A porta 25, por ser utilizada há mais tempo, possui uma vulnerabilidade maior a 
	//ataques e interceptação de mensagens, além de não exigir autenticação para envio 
	//das mensagens, ao contrário da 587 que oferece esta segurança a mais.
			
	Private cMailServer	:= "SEUIP" //Provisório, pois no parametro já existe a porta
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
				cMsg := "O arquivo " + aArquivos[nArq] + " não foi anexado!"
				alert( cMsg )
				return
			endif
		Next nArq
	EndIf		
	*/
	   
	oServer := tMailManager():New()
	oServer:SetUseTLS( .T. ) //Indica se será utilizará a comunicação segura através de SSL/TLS (.T.) ou não (.F.)
   
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
		//O método SMTPAuth ao tentar realizar a autenticação do 
		//usuário no servidor de e-mail, verifica a configuração 
		//da chave AuthSmtp, na seção [Mail], no arquivo de 
		//configuração (INI) do TOTVS Application Server, para determinar o valor.
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