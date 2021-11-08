#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SBMAILDLG ºAutor  ³Microsiga           º Data ³  05/02/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Arma dialog para envio de correo electronico               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SBMAILDLG(cPDe, cPPara, cPCc, cPAssunt, cPMensag, llDeRead)

	Local olEnviar
	Local olCancelar
	Local nlTamanho	 := 200
	Local clAssunto  := Space(nlTamanho)
	Local clCc       := Space(nlTamanho)
	Local clDe       := Space(nlTamanho)
	Local clMensagem
	Local clPara     := Space(nlTamanho)
	Local clPw		 := SuperGetMv("AL_PWSMAL",,"humboldt123")
	Local oDlg1
	Local oGrp1
	Local oSay1
	Local oSay2
	Local oSay3
	Local oSay4
	Local oSay5
	Local opAssunto
	Local opCc
	Local opPara
	Local opDe
	Local oGrp2
	Local alRet := {}
	Local llOk	:= .F.
	Local opPsw
	
	Default llDeRead := .T.
	
	if !Empty( cPDe )
		clDe := PADR( AllTrim( cPDe ), nlTamanho )
	endif
	
	if !Empty( cPPara )
		clPara := PADR( AllTrim( cPPara ), nlTamanho ) 
	endif
	
	if !Empty( cPCc )
		clCc := PADR( AllTrim( cPCc ), nlTamanho ) 
	endif
	
	if !Empty( cPAssunt )
		clAssunto := PADR( AllTrim( cPAssunt ), nlTamanho ) 
	endif
	
	if !Empty( cPMensag )
		clMensagem := cPMensag 
	endif
	
	oDlg1      := MSDialog():New( 091,236,623,936,"Envio de e-mail para el Cliente",,,.F.,,,,,,.T.,,,.T. )
	oGrp1      := TGroup():New( 003,004,076,344,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay1      := TSay():New( 024,008,{||"Para"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
	oSay2      := TSay():New( 008,008,{||"De"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
	oSay3      := TSay():New( 044,008,{||"C.c."},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
	oSay4      := TSay():New( 060,008,{||"Asunto"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
	oSay5      := TSay():New( 036,032,{||"Ej.: email1@prueba;email2@prueba"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,184,008)
	opDe       := TGet():New( 008,032,{|u| If(PCount()>0,clDe:=u,clDe)},oGrp1,180,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,llDeRead,.F.,"","clDe",,)
	opPsw      := TGet():New( 008,232,{|u| If(PCount()>0,clPw:=u,clPw)},oGrp1,108,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.T.,"","clPw",,)
	opPara     := TGet():New( 024,032,{|u| If(PCount()>0,clPara:=u,clPara)},oGrp1,308,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","clPara",,)
	opCc       := TGet():New( 044,032,{|u| If(PCount()>0,clCc:=u,clCc)},oGrp1,308,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","clCc",,)
	opAssunto  := TGet():New( 060,032,{|u| If(PCount()>0,clAssunto:=u,clAssunto)},oGrp1,308,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","clAssunto",,)
	oGrp2      := TGroup():New( 080,004,248,344,"Mensaje",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	opMensagem := TMultiGet():New( 088,008,{|u| If(PCount()>0,clMensagem:=u,clMensagem)},oGrp2,332,156,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
	olEnviar   := TButton():New( 252,248,"&Enviar",oDlg1,{|| llOk := .T., oDlg1:End() },037,012,,,,.T.,,"",,,,.F. )
	olCancelar := TButton():New( 252,300,"&Cancelar",oDlg1,{|| oDlg1:End() },037,012,,,,.T.,,"",,,,.F. )

	oDlg1:Activate(,,,.T.)
	
	if llOk
		AADD(alRet, clDe)
		AADD(alRet, clPara)		
		AADD(alRet, clCc)
		AADD(alRet, clAssunto)
		AADD(alRet, clMensagem)		
		AADD(alRet, clPw)
	endif

Return alRet
