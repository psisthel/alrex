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
±±ºPrograma  ³ALRFAT01  ºAutor  ³Percy Arias,SISTHEL º Data ³  04/19/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime el PV en formato PDF y envia email para el cliente º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ALRFAT01(nOpc)

	Local aArea			:= GetArea()
	Local clPathCli		:= GetTempPath()
	Local nlLin			:= 80
	Local Titulo		:= "Pedido de Venta"

	Private oPrint
	Private cpNameArq	:= "PV_"+ DtoS(Date()) + "_" + Strtran(Time(), ":", "")
	Private cpPathServ	:= "\Relato"
	Private cString 	:= "SC5"
	private lPedido		:= .t.
	
	dbSelectArea(cString)
	dbSetOrder(1)
	
	oPrint := FWMSPrinter():New(cpNameArq, IMP_PDF,.T., /*clPathServer*/,.T.,,,,, /*[ lPDFAsPNG]*/,, .T./*[ lViewPDF]*/, )
		
	oPrint:SetResolution(72)
	if nOpc==1
		oPrint:SetLandscape()
	else
		oPrint:SetPortrait()
	endif
	oPrint:setPaperSize(9)
	oPrint:cPathPDF := clPathCli

	RptStatus({|| RunReport1(nlLin,nOpc) },Titulo)
	
	RestArea( aArea )

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALRFAT01  ºAutor  ³Microsiga           º Data ³  04/19/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RunReport1( nlLin,nOpc )

	Local nQuant     	:= 1
	Local nomeprog   	:= "ALRFAT01"
	Local cPedido   	:= SC5->C5_NUM
	Local cQtd,i,nBegin
	Local cIndSC2    	:= CriaTrab(NIL,.F.), nIndSC2
	Local cItemOP    	:= ""
	Local olFont01		:= TFont():New("Calibri",	9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	Local olFont02		:= TFont():New("Calibri",	9,12,.T.,.F.,5,.T.,5,.T.,.F.)
	Local olFont03		:= TFont():New("Calibri",	9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	Local olFont04		:= TFont():New("Calibri",	9,18,.T.,.T.,5,.T.,5,.T.,.F.)
	Local olFont16		:= TFont():New("Calibri",	9,16,.T.,.F.,5,.T.,5,.T.,.F.)
	Local nlPag			:= 1
	Local nTotMoney		:= 0
	Local alCliente		:= {}
	Local cMailDe		:= GetNewPar("AL_MAILENV","ventas@alrex.com.pe")
	Local _cCodUser		:= RetCodUsr()
	Local aPswDet		:= {}
	
	Private cAlias		:= getNextAlias()

	cQuery := "SELECT COUNT(*) NQTD"
	cQuery += "  FROM "+RetSqlName("SC6")+" SC6"
	cQuery += " WHERE C6_FILIAL='"+xFilial("SC6")+"'"
	cQuery += "   AND SC6.D_E_L_E_T_=' '"
	cQuery += "   AND C6_NUM='" + cPedido + "'"
	cQuery += " GROUP BY C6_NUM"

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
	_nItns := (cAlias)->NQTD
	(cAlias)->( dbCloseArea() )
	
	SetRegua(_nItns)

	SC6->( dbSetOrder(1) )
	if SC6->( dbSeek( xFilial("SC6")+cPedido) )

		if nOpc==1
			nlLin := cabecOp(nlLin, olFont03, olFont04, nlPag, olFont16)
		else
			nlLin := cabecPV(nlLin, olFont03, olFont04, nlPag, olFont16)
		endif

		While SC6->( !Eof() ) .And. SC6->C6_NUM==SC5->C5_NUM
		
			IncRegua()
			
			if nOpc==1
			
				if (nlLin+80) > 2000 
					nlLin += 30
					oPrint:Line	(nlLin,0000,nlLin,3000)
					nlLin += 30
					oPrint:Say	(nlLin, 2900, "Pg."+alltrim(str(nlPag)), olFont01)
					nlPag++
					oPrint:EndPage()
					nlLin := cabecOp(nlLin, olFont03, olFont04, nlPag, olFont16)
				endif
			
				_aMemo := {}
				_cMemo := ""
				_cMemo := SC6->C6_YSTRUCT
				_cMemo := replace( _cMemo,":"," " )
				_cMemo := replace( _cMemo,"-",": " )
				_aMemo := StrTokArr( _cMemo , ";" )
				
				dbSelectArea("SB1")
				dbSeek(xFilial()+SC6->C6_PRODUTO)
		
				if len(_aMemo)<=0
					oPrint:Say	(nlLin, 0050, SC6->C6_ITEM+" "+SC6->C6_PRODUTO+" "+SC6->C6_DESCRI, olFont02)
				else
					oPrint:Say	(nlLin, 0050, SC6->C6_ITEM+" "+SC6->C6_YCODF + " " + Posicione("ZZD",1,xFilial("ZZD")+SC6->C6_YCODF,"ZZD->ZZD_DESCRI"), olFont03)
				endif
				oPrint:Say	(nlLin, 1000, Transform( SC6->C6_QTDVEN,"@E 9999.999"), olFont01)
				oPrint:Say	(nlLin, 1200, Transform( SC6->C6_PRUNIT,"@E 999999.9999" ), olFont01)
				oPrint:Say	(nlLin, 1500, Transform( SC6->C6_VALDESC,"@E 9999.99" ), olFont01)
				oPrint:Say	(nlLin, 1750, Transform( SC6->C6_PRCVEN,"@E 999999.9999" ), olFont01)
				oPrint:Say	(nlLin, 2000, Transform( SC6->C6_VALOR,"@E 999999.99" ), olFont01)

				nlLin+=40
				nTotMoney += SC6->C6_VALOR
	
				_aItns	:= {}
				_aItm	:= {}
				_cItm	:= ""
				
				if len(_aMemo) > 0
					for nX := 1 to len(_aMemo)
						_cItm := _aMemo[nX]
						if at("|",_cItm)>0
							_aItm := StrTokArr( _cItm, "|" )
						else
							_aItm := { strzero(nX,3),_cItm }
						endif
						Aadd(_aItns,_aItm)
					next nX
				endif
				
				aSort( _aItns,1,, { |x, y| x[1] < y[1] } )
				nlCol := 0050
	
				if len(_aItns) > 0
					for nX := 1 to len(_aItns)
						oPrint:Say (nlLin, nlCol, _aItns[nX][2], olFont02)
						nlCol += 650
						if nlCol > 2500
							nlLin += 040
							nlCol := 050
						endif
					next nX
				endif
				
				if nlCol > 050
					nlLin += 80
				else
					nlLin += 40
				endif
				
			else

				oPrint:Say	(nlLin, 0100, SC6->C6_ITEM+" "+LEFT(SC6->C6_PRODUTO,20)+" "+SC6->C6_DESCRI, olFont02)
				oPrint:Say	(nlLin, 1100, Transform( SC6->C6_QTDVEN,"@E 9999.999"), olFont02)
				oPrint:Say	(nlLin, 1300, Transform( SC6->C6_PRUNIT,"@E 999999.9999" ), olFont02)
				oPrint:Say	(nlLin, 1550, Transform( SC6->C6_VALDESC,"@E 9999.99" ), olFont02)
				oPrint:Say	(nlLin, 1750, Transform( SC6->C6_PRCVEN,"@E 999999.9999" ), olFont02)
				oPrint:Say	(nlLin, 2050, Transform( SC6->C6_VALOR,"@E 999999.99" ), olFont02)

				nTotMoney += SC6->C6_VALOR
				nlLin += 40
				
				if nlLin > 4500
					oPrint:EndPage()
					nlLin := cabecPV(nlLin, olFont03, olFont04, nlPag, olFont16)
				endif
		
		    endif
		    
			SC6->( dbSkip() )
			
		EndDO
		
	endif

	if (nlLin+500) > 2000 
		nlLin += 30
		oPrint:Line	(nlLin,0000,nlLin,3000)
		nlLin += 25
		oPrint:Say	(nlLin, 2900, "Pg."+alltrim(str(nlPag)), olFont01)
		nlPag++
		oPrint:EndPage()
		nlLin := cabecOp(nlLin, olFont03, olFont04, nlPag, olFont16)
	else
	
	endif
	
	nlLin += 10
	
	oPrint:Line	(nlLin,0000,nlLin,3000)
	
	nlLin += 40
	
	oPrint:Say	(nlLin, 0100, "Total de Itens: "+Transform(_nItns,"@E 99999.99"), olFont03)
	oPrint:Say	(nlLin, 1700, "Total "+if(SC5->C5_MOEDA==1,"S/","US$")+":", olFont03)
	oPrint:Say	(nlLin, 1960, Transform(nTotMoney,"@E 999999.99"), olFont03)
	
	nlLin += 40
	
	oPrint:Line	(nlLin,0000,nlLin,3000)
	
	nlLin += 25
	
	oPrint:Say	(nlLin, 2900, "Pg."+alltrim(str(nlPag)), olFont01)
	
	nlLin += 250
	
	if nOpc==1
		oPrint:Say	(nlLin, 0200, "__________________________________________", olFont03)
	endif
	oPrint:Say	(nlLin, 1300, "__________________________________________", olFont03)
	
	nlLin += 40
	
	if nOpc==1
		oPrint:Say	(nlLin, 0450, "JEFE DE VENTAS", olFont03)
	endif
	oPrint:Say	(nlLin, 1600, "V.B. DEL CLIENTE", olFont03)
	
	SET DEVICE TO SCREEN	
	oPrint:Preview()
	
	//----------------------------------------------------------------------------------------------
	
	alCliente := {}
	alCliente := u_FGETCLIE( SC5->C5_CLIENTE )
		
	if !ExistDir(cpPathServ)
		MakeDir(cpPathServ)
	endif
		
	clArquivo	:= cpNameArq+".pdf"
	clArqOri	:= oPrint:cPathPDF + clArquivo
	clArqDest	:= cpPathServ + "\" + clArquivo

	PswOrder(1)
	If PswSeek( _cCodUser, .T. )  
		aPswDet := PswRet()
	EndIf
			
	If Len(aPswDet) > 0
		cMailDe := Lower(aPswDet[1][14])
	EndIf
		
	If CpyT2S(clArqOri, cpPathServ )

		If MsgYesNo("Enviar correo "+if(lPedido,"del pedido","de la cotización")+" para el Cliente " + AllTrim( alCliente[1] ) + " ? (" + AllTrim( alCliente[11] ) + ")")
				
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Busca e-mails dos contatos do Fornecedor.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			clCc := U_GETCCSA1( alCliente[12], alCliente[13] )
				
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Mensagem padrão que ira compor o corpo do e-mail.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			clMensPadrao := "Cotización de Venta" + CRLF
			clMensPadrao += "Detalle de los itens en el archivo anexo" + CRLF + CRLF
			clMensPadrao += "Cliente: " + AllTrim( alCliente[1] ) + CRLF
			clMensPadrao += "Fecha: " + DtoC( Date() ) + CRLF
			if lPedido
				clMensPadrao += "Número del Pedido: " + SC5->C5_NUM + CRLF + CRLF
			else
				clMensPadrao += "Número de la Cotización: " + SC5->C5_NUM + CRLF + CRLF
			endif
			clMensPadrao += Upper(Alltrim(SC5->C5_LOGINCL)) + CRLF

			if !empty(cMailDe)
		
				alRetMail := U_SBMAILDLG(AllTrim(cMailDe), AllTrim( alCliente[11] ), clCc, +if(lPedido,"Pedido ","Cotización ")+" - nº " + SC5->C5_NUM, clMensPadrao)
					
				if	Len( alRetMail ) > 0 .And.;
					u_FBEMail(	AllTrim( alRetMail[2] )	,;	// Para
								AllTrim( alRetMail[4] )	,;	// Assunto
								AllTrim( alRetMail[5] )	,;	// Corpo do E-mail
								clArqDest				,;	// Anexo
								AllTrim( alRetMail[3] )	,;	// E-mail en copia
								AllTrim( cMailDe )		,;	// E-mail de envio (del usuario logado)
								AllTrim( alRetMail[6] )	;	// psw de envio
								) 
	
					/*
					u_SBSEnvMail(	AllTrim( alRetMail[2] ),;	// Para
									AllTrim( alRetMail[4] ),;	// Assunto
									AllTrim( alRetMail[5] ),;	// Corpo do E-mail
									AllTrim( alRetMail[3] ),;	// E-mails em Copia
									clArqDest,; 			  	// Anexo	
									AllTrim( alRetMail[1] ))  	// De
					*/
	
					//FBEMail(cPara,cAssunto,cMensagem,aArquivos)
	
					clUpdate := "UPDATE " + RetSQLName("SC5")
					clUpdate += " SET C5_YSTATUS = '8' "
					clUpdate += " WHERE D_E_L_E_T_ = ' ' "
					clUpdate += " AND C5_FILIAL = '" + XFILIAL("SC5") + "'"
					clUpdate += " AND C5_NUM = '" + SC5->C5_NUM + "'"
								
					if ( TCSQLExec( clUpdate ) < 0 )
						Aviso("AVISO", "No fue posíble modificar el status de este registro para informar que el correo ya fue enviado!", {"&Ok"}, 3)
					else
						MsgInfo("E-mail enviado con suceso!")
						FERASE(clArqDest)
					endif
				else
					MsgInfo("E-mail NO enviado!")
				endif
			else
				Aviso("AVISO", "No fue posíble enviar el correo para el cliente, correo de envio invalido, verifique con el administrador!", {"&Ok"}, 3)
			endif
			
		else
			if Aviso("E-MAIL", "El sistema no envio el e-mail para el Cliente. Abrir archivo y enviar manualmente ?", {"Si", "No"}, 3) == 1
				ShellExecute("Open",oPrint:cPathPDF+cpNameArq+".pdf","","",1)
			endif
		endif 

	endif
	
	MS_FLUSH()	
	
Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PRINTOP   ºAutor  ³Microsiga           ºFecha ³  09/18/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CabecOp(nlLin, olFont03, olFont04, nlPg, olFont16)
                                                                  
	Local nBegin
	
	oPrint:StartPage()
	nlLin := 0010

	//SA1->( MsSeek( xFilial("SA1")+SC6->C6_CLI ) )

	//oPrint:Line	(nlLin,0000,nlLin,3500)
	nlLin += 10
	oPrint:SayBitmap( (nlLin+50), 0060, "\system\lgmid02.png", 320, 300)
	nlLin += 105

	//oPrint:Say	(nlLin, 0500, Upper(SM0->M0_NOMECOM), olFont04)	
	oPrint:Say	(nlLin, 0500, "ANDERS ZIEDEK WERNER HANS", olFont04)	
	if Empty(SC5->C5_LIBEROK) .And. Empty(SC5->C5_NOTA) .And. Empty(SC5->C5_BLQ)
		oPrint:Say	(nlLin, 2100, "Nro Cotizacion: " + SC5->C5_NUM, olFont04)
		lPedido := .f.
	else
		oPrint:Say	(nlLin, 2100, "Nro Pedido: " + SC5->C5_NUM, olFont04)
		lPedido := .t.
	endif
	nlLin += 50

	oPrint:Say	(nlLin, 0500, Upper(SM0->M0_ENDENT), olFont03)
	oPrint:Say	(nlLin, 2100, "Emisión: " + Dtoc(SC5->C5_EMISSAO)+" a las "+SC5->C5_YHOREMI, olFont03)
	nlLin += 50
	//oPrint:Say	(nlLin, 0500, "R.U.C. "+SM0->M0_CGC, olFont03)
	oPrint:Say	(nlLin, 0500, "R.U.C. 10077763851", olFont03)
	oPrint:Say	(nlLin, 2100, "Entrega: "+Dtoc(SC5->C5_SUGENT), olFont03)
	nlLin += 50
	oPrint:Say	(nlLin, 2100, "Cond.Pago: "+SC5->C5_CONDPAG+" - "+POSICIONE("SE4",1,XFILIAL("SE4")+SC5->C5_CONDPAG,"SE4->E4_DESCRI"), olFont03)

	nlLin += 50
	oPrint:Say	(nlLin, 0500, "CLIENTE: "+SC5->C5_YNOMCLI, olFont03)
	oPrint:Say	(nlLin, 2100, "Recibido: "+Alltrim(Transform( SC5->C5_YPORADE,"@E 999.99")) + " %", olFont03)
	nlLin += 50
	oPrint:Say	(nlLin, 0500, "DIRECCION: "+Alltrim(SC5->C5_YENDENT)+" "+Alltrim(SC5->C5_YCOMDIR)+" "+Alltrim(SC5->C5_YDISENT)+" "+Alltrim(SC5->C5_YPROENT)+" "+Alltrim(SC5->C5_YDPTENT), olFont03)
	oPrint:Say	(nlLin, 2100, "Atendido por: "+SC5->C5_LOGINCL, olFont03)
	nlLin += 50
	//oPrint:Say	(nlLin, 0720, ""+Alltrim(SC5->C5_YDISENT)+" "+Alltrim(SC5->C5_YPROENT)+" "+Alltrim(SC5->C5_YDPTENT), olFont03)
	oPrint:Say	(nlLin, 0500, "R.U.C.: "+SC5->C5_CLIENTE, olFont03)

	nlLin += 40
	oPrint:Line	(nlLin,0000,nlLin,3000)
	nlLin += 40

	oPrint:Say	(nlLin, 0050, "DESCRIPCION DEL PRODUCTO", olFont03)
	oPrint:Say	(nlLin, 1000, "CANTIDAD", olFont03)
	oPrint:Say	(nlLin, 1200, "PRC.UNIT.", olFont03)
	oPrint:Say	(nlLin, 1500, "DESC", olFont03)
	oPrint:Say	(nlLin, 1750, "PRC.VENDA", olFont03)
	oPrint:Say	(nlLin, 2000, "TOT.ITEM", olFont03)

	nlLin += 40
	oPrint:Line	(nlLin,0000,nlLin,3000)
	nlLin += 40
	
Return nlLin

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALRFAT01  ºAutor  ³Microsiga           º Data ³  04/26/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CabecPV(nlLin, olFont03, olFont04, nlPg, olFont16)
                                                                  
	oPrint:StartPage()
	nlLin := 0010
	
	//SA1->( MsSeek( xFilial("SA1")+SC6->C6_CLI ) )

	nlLin += 10
	oPrint:SayBitmap( (nlLin+50), 0060, "\system\lgmid02.png", 320, 300)
	nlLin += 105
	//oPrint:Say	(nlLin, 0500, Upper(SM0->M0_NOMECOM), olFont04)	
	oPrint:Say	(nlLin, 0500, "ANDERS ZIEDEK WERNER HANS", olFont04)	
	if Empty(SC5->C5_LIBEROK) .And. Empty(SC5->C5_NOTA) .And. Empty(SC5->C5_BLQ)
		oPrint:Say	(nlLin, 1700, "Nro Cotizacion: " + SC5->C5_NUM, olFont04)
		lPedido := .f.
	else
		oPrint:Say	(nlLin, 1700, "Nro Pedido: " + SC5->C5_NUM, olFont04)
		lPedido := .t.
	endif
	nlLin += 50
	oPrint:Say	(nlLin, 0500, Upper(SM0->M0_ENDENT), olFont03)
	oPrint:Say	(nlLin, 1700, "Emisión: " + Dtoc(SC5->C5_EMISSAO)+" - "+Time(), olFont03)
	nlLin += 50
	//oPrint:Say	(nlLin, 0500, "R.U.C. "+SM0->M0_CGC, olFont03)
	oPrint:Say	(nlLin, 0500, "R.U.C. 10077763851", olFont03)
	oPrint:Say	(nlLin, 1700, "Entrega: "+Dtoc(SC5->C5_SUGENT), olFont03)
	nlLin += 50
	oPrint:Say	(nlLin, 1700, "Cond.Pago: "+SC5->C5_CONDPAG+" - "+POSICIONE("SE4",1,XFILIAL("SE4")+SC5->C5_CONDPAG,"SE4->E4_DESCRI"), olFont03)

	nlLin += 50
	oPrint:Say	(nlLin, 0500, "CLIENTE: "+SC5->C5_YNOMCLI, olFont03)
	oPrint:Say	(nlLin, 1700, "Recibido: "+Alltrim(Transform( SC5->C5_YPORADE,"@E 999.99")) + " %", olFont03)
	nlLin += 50
	oPrint:Say	(nlLin, 0500, "DIRECCION: "+Alltrim(SC5->C5_YENDENT)+" "+Alltrim(SC5->C5_YCOMDIR), olFont03)
	oPrint:Say	(nlLin, 1700, "Atendido por: "+SC5->C5_LOGINCL, olFont03)
	nlLin += 50
	//oPrint:Say	(nlLin, 0720, ""+Alltrim(SC5->C5_YDISENT)+" "+Alltrim(SC5->C5_YPROENT)+" "+Alltrim(SC5->C5_YDPTENT), olFont03)
	oPrint:Say	(nlLin, 0500, "R.U.C.: "+SC5->C5_CLIENTE, olFont03)

	nlLin += 40
	oPrint:Line	(nlLin,0000,nlLin,2500)
	nlLin += 40

	oPrint:Say	(nlLin, 0100, "DESCRIPCION DEL PRODUCTO", olFont03)
	oPrint:Say	(nlLin, 1100, "CANTIDAD", olFont03)
	oPrint:Say	(nlLin, 1300, "PRC.UNIT.", olFont03)
	oPrint:Say	(nlLin, 1600, "DESC", olFont03)
	oPrint:Say	(nlLin, 1750, "PRC.VENDA", olFont03)
	oPrint:Say	(nlLin, 2050, "TOT.ITEM", olFont03)

	nlLin += 40
	oPrint:Line	(nlLin,0000,nlLin,2500)
	nlLin += 40
	
Return nlLin

