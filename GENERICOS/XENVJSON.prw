#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
#Include "ApWebSrv.ch"
#Include 'ApWebex.ch'
#Include "Totvs.Ch"
#Include "RESTFUL.Ch"
#Include "FWMVCDef.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXENVJSON  บAutor  ณMicrosiga           บ Data ณ  01/09/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ HttpPost( < cUrl >, [ cGetParms ], [ cPostParms ],         บฑฑ
ฑฑบ			 ณ [ nTimeOut ], [ aHeadStr ], [ @cHeaderGet ] )              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function XENVJSON( cArqJson )

	//Local cUrl		:= "https://demo.nubefact.com/api/v1/03989d1a-6c8c-4b71-b1cd-7d37001deaa0"
	Local cUrl		:= Alltrim(getNewPar("AL_URLNFE","https://www.nubefact.com/api/v1/186dd3ef-42a0-4669-9897-5ab8b65033e2"))
	//Local cToken	:= "d0a80b88cde446d092025465bdb4673e103a0d881ca6479ebbab10664dbc5677"
	Local cToken	:= Alltrim(getNewPar("AL_TKNNFE","19610a168b7c4ca8ac0917feef6c4ba41d72b53b8409470796ebfdd08b066a21"))
	Local nTimeOut	:= 200
	Local aHeadOut	:= {}
	Local cHeadRet	:= ""
	Local sPostRet	:= ""
	//Local cJson		:= FWJsonSerialize(cArqJson,.T.,.T.)
	Local cParam	:= cArqJson //"token="+cTohen
	
	/*
	Local oRest
	Local aRest	:= {}
	Local clMetodo := "/api/v1/"
	
	oRest := FWREST():New( cUrl ) //Defino o Host que vou consumir	
	oRest:SetPath(clMetodo) // Defino o m้todo que vai ser consumido.
	
	aadd(aRest,"Authorization: Token token=" + cToken)
	aadd(aRest,"Content-Type: application/json")

	oRest:SetPostParams( cArqJson )
	lRet := oRest:Post(aRest)
	if lRet
		ConOut("POST", oRest:GetResult())
	else
		ConOut("POST", oRest:GetLastError())
	endif
	*/

	aadd(aHeadOut,"Content-Type: application/json")
	//aadd(aHeadOut,"Content-Type:application/json;charset=utf-8")
	aadd(aHeadOut,"Authorization: Token token=" + cToken)
	
	sPostRet := HttpPost(cUrl,"",cParam,nTimeOut,aHeadOut,@cHeadRet) 

	if !empty(sPostRet)
		conout("HttpPost Ok")
		varinfo("WebPage", sPostRet)
	else
		conout("HttpPost Failed.")
		varinfo("Header", cHeadRet)
	Endif
	
Return(sPostRet)