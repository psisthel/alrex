#include "protheus.ch"
#INCLUDE "RWMAKE.CH"
#Include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALRFIN01  ºAutor  ³Percy Arias,SISTHEL º Data ³  09/13/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Genera RA a partir del PV                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ALRFIN01(cPedido,nSeq,dFechaEfect,nValEfect)

	local aDocs := {}

	private _cReciboSEL := ""

	SC5->( dbSetOrder(1) )
	SC5->( MsSeek(xFilial("SC5")+cPedido) )

	ZZW->( dbSetOrder(5) )
	if ZZW->( dbSeek( xFilial("ZZW")+cPedido+nSeq ) )

		ZZW->( RecLock("ZZW",.F.) )
		ZZW->ZZW_DATAEF	:= dFechaEfect
		ZZW->ZZW_VALEFE	:= nValEfect
		ZZW->( MsUnlock() )
	
		dFecha := dtos(ZZW->ZZW_DATAEF)

		SM2->(dbSetOrder(1))
		SM2->(MsSeek(dFecha))

	    aadd(	aDocs,	{	ZZW->ZZW_PEDIDO		,;		// 01 - numero del documento
	      					''					,;		// 02 - serie
	      					ZZW->ZZW_TIPDOC		,;		// 03 - tipo 
	      					"REC"				,;		// 04 - prefixo
	      					''					,;		// 05 - cuota
	      					"RA"				,;		// 06 - tipo documento
	      					dFecha				,;		// 07 - emission
	      					ZZW->ZZW_MOEDA		,;		// 08 - moneda
	      					ZZW->ZZW_VALEFE		,;		// 09 - Valor 
	      					ZZW->ZZW_BANCO		,;		// 10 - banco
					      	ZZW->ZZW_CLIENT		,;		// 11 - cliente
					      	SM2->M2_MOEDA2		,;		// 12 - Taxa Moneda
					      	SC5->C5_NATUREZ		,;		// 13 - Modalidad
							ZZW->ZZW_CONTA		,;		// 14 - Cta Bancaria
							ZZW->ZZW_LOJA		,;		// 15 - loja del cliente
							xFilial("SEL")		,;		// 16 - filial
							ZZW->ZZW_NOMCLI		;		// 17
						};
		)

		if GeneraSE1(aDocs)
			ZZW->( RecLock("ZZW",.F.) )
			ZZW->ZZW_STATUS	:= "1"
			ZZW->ZZW_RECIBO := _cReciboSEL
			ZZW->( MsUnlock() )

			cSEL := GeraSEL(_cReciboSEL)

		endif

	else
		Alert("Nro del pedido no encontrado")
	endif

Return

// ----------------------------------------------------- //

Static Function GeneraSE1(aDocs)

	local _aAlias10 := {}
	local _xAlias11 := getnextAlias()
	local j := 0
	local lok := .f.
	local clLogAuto	:= ""

	DbSelectArea("SA1")
	DbSetOrder(1)

	_aAlias10 := aDocs

	For j:= 1 to Len( _aAlias10 )

		lOk := .f.
		clLogAuto := "\log\log_cdiversos_"+_aAlias10[j][1]+replace(time(),":","")+".txt"
	
		_cFechaEms	:= stod(_aAlias10[j][7])
		_cNroDaFac	:= padr( alltrim(_aAlias10[j][1]), TAMSX3("E1_NUM")[1] )
		_cCodClient	:= Alltrim( _aAlias10[j][11] ) + Space( TAMSX3("E1_CLIENTE")[1] - Len( Alltrim( _aAlias10[j][11] ) ) )
		_cLojClient	:= Alltrim( _aAlias10[j][15] ) + Space( TAMSX3("E1_LOJA")[1] - Len( Alltrim( _aAlias10[j][15] ) ) )
		nPagoCte	:= 0

		// _cReciboSEL	:= GetSxeNum("SEL","EL_RECIBO")
		// _cReciboSEL	:= Strzero( Val(_cReciboSEL),TAMSX3("EL_RECIBO")[1] )
		// ConfirmSx8()

		DbSelectArea("SE1") 
		DbSetOrder(2)    // E1_FILIAL, E1_CLIENTE, E1_LOJA, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO
		If !dbSeek( xFilial("SE1")+_cCodClient+_cLojClient+Substr(_aAlias10[j][4],1,TamSX3("E1_PREFIXO")[1])+_cNroDaFac+PADR(_aAlias10[j][5],TamSX3("E1_PARCELA")[1])+PADR(_aAlias10[j][6],TamSX3("E1_TIPO")[1]))

			_cReciboSEL	:= GeraSEL("")
			lOk := .t.

			SE1->( RecLock("SE1",.T.) )
			SE1->E1_FILIAL	:= xFilial("SE1")
			SE1->E1_PREFIXO	:= _aAlias10[j][4]
			SE1->E1_NUM		:= _cReciboSEL
			SE1->E1_PARCELA	:= _aAlias10[j][5]
			SE1->E1_TIPO	:= _aAlias10[j][6]
			SE1->E1_NATUREZ	:= _aAlias10[j][13]
			SE1->E1_CLIENTE	:= _aAlias10[j][11]
			SE1->E1_LOJA	:= _aAlias10[j][15]
			SE1->E1_NOMCLI	:= _aAlias10[j][17]
			SE1->E1_EMISSAO	:= _cFechaEms
			SE1->E1_VENCTO	:= _cFechaEms
			SE1->E1_VENCREA	:= _cFechaEms
			SE1->E1_VALOR	:= _aAlias10[j][9]
			SE1->E1_EMIS1	:= _cFechaEms
			SE1->E1_LA		:= "S"
			SE1->E1_SITUACA	:= "0"
			SE1->E1_SALDO	:= _aAlias10[j][9]
			SE1->E1_MOEDA	:= _aAlias10[j][8]
			if _aAlias10[j][8]==2
				SE1->E1_VLCRUZ	:= _aAlias10[j][9] * _aAlias10[j][12]
			else
				SE1->E1_VLCRUZ	:= _aAlias10[j][9]
			endif
			SE1->E1_STATUS	:= "A"
			SE1->E1_ORIGEM	:= "FINA087A"
			SE1->E1_RECIBO	:= _cReciboSEL
			SE1->E1_FILORIG	:= xFilial("SE1")
			SE1->E1_TXMOEDA	:= _aAlias10[j][12]
			SE1->E1_MSFIL	:= xFilial("SE1")
			SE1->E1_MSEMP	:= "02"
			SE1->E1_SERREC	:= "UNI"
			SE1->E1_PEDIDO	:= _aAlias10[j][1]
			SE1->( MsUnlock() )
		EndIf	

		If lOk
			
			// EL_FILIAL, EL_PREFIXO, EL_NUMERO, EL_PARCELA, EL_TIPO, EL_CLIORIG, EL_LOJORIG
			SEL->( dbSetOrder(2) )
			If SEL->( !( dbSeek( xFilial("SEL")+Substr(_aAlias10[j][4],1,TamSX3("E1_PREFIXO")[1])+_cNroDaFac ) ) )

				_nBaixado := 0
				_cBcoMN := ""
				_cAgeMN := ""
				_cConMN := ""
				_cNomMN := ""
				
				cQry := "SELECT *"+CRLF
				cQry += "  FROM "+RetSqlname("SA6")+CRLF
				cQry += " WHERE A6_FILIAL='"+xFilial("SA6")+"'"+CRLF
				cQry += "   AND D_E_L_E_T_=' '"+CRLF
				cQry += "   AND A6_COD='" + _aAlias10[j][10] + "'"+CRLF
				cQry += "   AND A6_NUMCON='" + _aAlias10[j][14] + "'"+CRLF
				
				dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQry), _xAlias11, .F., .T.)
						
				If (_xAlias11)->( !Eof() )
					_cBcoMN := (_xAlias11)->A6_COD
					_cAgeMN := (_xAlias11)->A6_AGENCIA
					_cConMN := (_xAlias11)->A6_NUMCON
					_cNomMN := (_xAlias11)->A6_NOME
				EndIf
				
				(_xAlias11)->( dbCloseArea() )
					
				if !empty(_cBcoMN) .And. !empty(_cConMN)
			
					_nValM02	:= Iif(_aAlias10[j][8]==2,(_aAlias10[j][9]*_aAlias10[j][12]),_aAlias10[j][9])
					_nValor		:= _aAlias10[j][9]
					_nBaixado	:= _nBaixado + _nValor
			
					SEL->( RecLock("SEL",.T.) )
					SEL->EL_FILIAL	:= xFilial("SEL")
					SEL->EL_RECIBO	:= _cReciboSEL
					SEL->EL_CLIORIG	:= SE1->E1_CLIENTE
					SEL->EL_LOJORIG	:= SE1->E1_LOJA
					SEL->EL_TIPO	:= _aAlias10[j][3]
					SEL->EL_NATUREZ	:= _aAlias10[j][13]
					SEL->EL_TIPODOC	:= _aAlias10[J][3]
					SEL->EL_PREFIXO	:= ""
					SEL->EL_NUMERO	:= _aAlias10[j][1]
					SEL->EL_PARCELA	:= ""
					SEL->EL_VALOR	:= _nValor
					SEL->EL_MOEDA	:= Alltrim(Str(_aAlias10[j][8]))
					SEL->EL_EMISSAO	:= _cFechaEms
					SEL->EL_DTVCTO	:= _cFechaEms
					SEL->EL_TPCRED	:= "1"
					SEL->EL_VLMOED1	:= _nValM02
					SEL->EL_BANCO	:= _cBcoMN
					SEL->EL_AGENCIA	:= _cAgeMN
					SEL->EL_CONTA	:= _cConMN
					SEL->EL_ACREBAN	:= "1"
					SEL->EL_TERCEIR	:= "1"
					//SEL->EL_CANCEL	:= "F"
					SEL->EL_DTDIGIT	:= _cFechaEms
					SEL->EL_DESCONT	:= 0
					SEL->EL_CLIENTE	:= SE1->E1_CLIENTE
					SEL->EL_LOJA	:= SE1->E1_LOJA
					SEL->EL_SERIE	:= "UNI"
					SEL->EL_TXMOE02	:= Iif(_aAlias10[j][12]<=0,1,_aAlias10[j][12])
					SEL->EL_DIACTB	:= "99"
					SEL->EL_VERSAO	:= "00"
					SEL->EL_ENDOSSA	:= "2"
					SEL->EL_TRANSIT	:= "2"
					SEL->EL_SELDOC	:= "2"
					SEL->( MsUnlock() )

					cChaveFK5 := FWUUIDV4()
	
					SE5->( Reclock("SE5",.T.) )
					SE5->E5_FILIAL		:= xFilial("SE5")
					SE5->E5_DATA		:= _cFechaEms
					SE5->E5_TIPO		:= _aAlias10[j][3]
					SE5->E5_MOEDA		:= Strzero(_aAlias10[j][8],2)
					SE5->E5_VALOR		:= _aAlias10[j][9]
					SE5->E5_NATUREZ		:= _aAlias10[j][13]
					SE5->E5_BANCO		:= _cBcoMN
					SE5->E5_AGENCIA		:= _cAgeMN
					SE5->E5_CONTA		:= _cConMN
					SE5->E5_VENCTO		:= _cFechaEms
					SE5->E5_RECPAG		:= "R"
					SE5->E5_HISTOR		:= "Valor cobrado por Recibo "+_cReciboSEL
					SE5->E5_TIPODOC		:= "VL"
					if _aAlias10[j][8]==2
						SE5->E5_VLMOED2	:= _aAlias10[j][9]
					else
						SE5->E5_VLMOED2	:= _aAlias10[j][9]/_aAlias10[j][12]
					endif
					SE5->E5_LA			:= "S"
					SE5->E5_NUMERO		:= _aAlias10[j][1]
					SE5->E5_CLIFOR		:= _aAlias10[j][11]
					SE5->E5_LOJA		:= _aAlias10[j][15]
					SE5->E5_DTDIGIT		:= _cFechaEms
					SE5->E5_RATEIO		:= "N"
					SE5->E5_SEQ			:= "01"
					SE5->E5_DTDISPO		:= _cFechaEms
					SE5->E5_ORDREC		:= _cReciboSEL
					SE5->E5_FILORIG		:= xFilial("SE5")
					SE5->E5_TXMOEDA		:= _aAlias10[j][12]
					SE5->E5_SERREC		:= "UNI"
					SE5->E5_ORIGEM		:= "FINA087A"
					SE5->E5_MOVFKS		:= "S"
					SE5->E5_IDORIG		:= cChaveFK5
					SE5->E5_TABORI		:= "FK5"
					SE5->( Msunlock() )

					FK5->( RecLock("FK5",.T.) )
					FK5->FK5_FILIAL	:= xFilial("FK5")
					FK5->FK5_IDMOV	:= cChaveFK5
					FK5->FK5_DATA	:= _cFechaEms
					FK5->FK5_VALOR	:= SE5->E5_VALOR
					FK5->FK5_MOEDA	:= SE5->E5_MOEDA
					FK5->FK5_NATURE	:= SE5->E5_NATUREZ
					FK5->FK5_RECPAG	:= SE5->E5_RECPAG
					FK5->FK5_TPDOC	:= SE5->E5_TIPODOC
					FK5->FK5_FILORI	:= SE5->E5_FILORIG
					FK5->FK5_ORIGEM	:= SE5->E5_ORIGEM
					FK5->FK5_BANCO	:= SE5->E5_BANCO
					FK5->FK5_AGENCI	:= SE5->E5_AGENCIA
					FK5->FK5_CONTA	:= SE5->E5_CONTA
					FK5->FK5_NUMCH	:= ""
					FK5->FK5_DOC	:= ""
					FK5->FK5_HISTOR	:= SE5->E5_HISTOR
					FK5->FK5_VLMOE2	:= SE5->E5_VLMOED2
					FK5->FK5_DTDISP	:= SE5->E5_DTDISPO
					FK5->FK5_TERCEI	:= "2"
					FK5->FK5_TPMOV	:= "1"
					FK5->FK5_STATUS	:= "1"
					FK5->FK5_RATEIO	:= "2"
					FK5->FK5_SEQ	:= "01"
					FK5->FK5_LA		:= "S"
					FK5->FK5_TXMOED	:= SE5->E5_TXMOEDA
					FK5->FK5_ORDREC	:= SE5->E5_ORDREC
					FK5->( MsUnLock() )

					// -------------------------------------------------- //

					SEL->( RecLock("SEL",.T.) )
					SEL->EL_FILIAL	:= xFilial("SEL")
					SEL->EL_RECIBO	:= _cReciboSEL
					SEL->EL_CLIORIG	:= SE1->E1_CLIENTE
					SEL->EL_LOJORIG	:= SE1->E1_LOJA
					SEL->EL_TIPO	:= _aAlias10[j][6]
					SEL->EL_NATUREZ	:= _aAlias10[j][13]
					SEL->EL_TIPODOC	:= _aAlias10[J][6]
					SEL->EL_PREFIXO	:= _aAlias10[J][4]
					SEL->EL_NUMERO	:= _cReciboSEL
					SEL->EL_PARCELA	:= ""
					SEL->EL_VALOR	:= _nValor
					SEL->EL_MOEDA	:= Strzero(_aAlias10[j][8],2)
					SEL->EL_EMISSAO	:= _cFechaEms
					SEL->EL_DTVCTO	:= _cFechaEms
					SEL->EL_TPCRED	:= ""
					SEL->EL_VLMOED1	:= _nValM02
					SEL->EL_BANCO	:= ""
					SEL->EL_AGENCIA	:= ""
					SEL->EL_CONTA	:= ""
					SEL->EL_ACREBAN	:= ""
					SEL->EL_TERCEIR	:= ""
					//SEL->EL_CANCEL	:= "F"
					SEL->EL_DTDIGIT	:= _cFechaEms
					SEL->EL_DESCONT	:= 0
					SEL->EL_CLIENTE	:= SE1->E1_CLIENTE
					SEL->EL_LOJA	:= SE1->E1_LOJA
					SEL->EL_SERIE	:= "UNI"
					SEL->EL_TXMOE02	:= Iif(_aAlias10[j][12]<=0,1,_aAlias10[j][12])
					SEL->EL_DIACTB	:= "99"
					SEL->EL_VERSAO	:= ""
					SEL->EL_ENDOSSA	:= ""
					SEL->EL_TRANSIT	:= ""
					SEL->EL_SELDOC	:= ""
					SEL->( MsUnlock() )

					DbSelectArea("SE5")
					AtuSalBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,SE5->E5_DATA,SE5->E5_VALOR,"+")

					cTxt := "DOCUMENTO PROCESADO"+CRLF
					cTxt += "-------------------------------------------------------"+CRLF
					cTxt += "E1_FILIAL		: "+xFilial("SE1")+CRLF
					cTxt += "E1_CLIENTE		: "+_cCodClient+CRLF
					cTxt += "E1_LOJA		: "+_cLojClient+CRLF
					cTxt += "E1_PREFIXO		: "+Substr(_aAlias10[j][4],1,TamSX3("E1_PREFIXO")[1])+CRLF
					cTxt += "E1_NUM			: "+_cNroDaFac+CRLF
					cTxt += "E1_PARCELA		: "+PADR(_aAlias10[j][5],TamSX3("E1_PARCELA")[1])+CRLF
					cTxt += "E1_TIPO		: "+PADR(_aAlias10[j][6],TamSX3("E1_TIPO")[1])+CRLF
					cTxt += "-------------------------------------------------------"+CRLF
					
					u_XGRVLOG(clLogAuto, cTxt, .T. )
					
				else

					cTxt := "DATOS BANCARIOS NO ENCONTRADOS"+CRLF
					cTxt += "-------------------------------------------------------"+CRLF
					cTxt += "E1_FILIAL		: "+xFilial("SE1")+CRLF
					cTxt += "E1_CLIENTE		: "+_cCodClient+CRLF
					cTxt += "E1_LOJA		: "+_cLojClient+CRLF
					cTxt += "E1_PREFIXO		: "+Substr(_aAlias10[j][4],1,TamSX3("E1_PREFIXO")[1])+CRLF
					cTxt += "E1_NUM			: "+_cNroDaFac+CRLF
					cTxt += "E1_PARCELA		: "+PADR(_aAlias10[j][5],TamSX3("E1_PARCELA")[1])+CRLF
					cTxt += "E1_TIPO		: "+PADR(_aAlias10[j][6],TamSX3("E1_TIPO")[1])+CRLF
					cTxt += "-------------------------------------------------------"+CRLF
					
					u_XGRVLOG(clLogAuto, cTxt, .T. )
				
				endif
                					
			Else		// encontre na SEL, baixar SE1
			
				cTxt := "DOCUMENTO PROCESADO ANTERIORMENTE"+CRLF
				cTxt += "-------------------------------------------------------"+CRLF
				cTxt += "E1_FILIAL		: "+xFilial("SE1")+CRLF
				cTxt += "E1_CLIENTE		: "+_cCodClient+CRLF
				cTxt += "E1_LOJA		: "+_cLojClient+CRLF
				cTxt += "E1_PREFIXO		: "+Substr(_aAlias10[j][4],1,TamSX3("E1_PREFIXO")[1])+CRLF
				cTxt += "E1_NUM			: "+_cNroDaFac+CRLF
				cTxt += "E1_PARCELA		: "+PADR(_aAlias10[j][5],TamSX3("E1_PARCELA")[1])+CRLF
				cTxt += "E1_TIPO		: "+PADR(_aAlias10[j][6],TamSX3("E1_TIPO")[1])+CRLF
				cTxt += "-------------------------------------------------------"+CRLF
				
				u_XGRVLOG(clLogAuto, cTxt, .T. )
	
			EndIf
			
		Else		// DOCUMENTO COM SALDO 0, SE1
	
			cTxt := "DOCUMENTO NO ENCONTRADO"+CRLF
			cTxt += "-------------------------------------------------------"+CRLF
			cTxt += "E1_FILIAL		: "+xFilial("SE1")+CRLF
			cTxt += "E1_CLIENTE		: "+_cCodClient+CRLF
			cTxt += "E1_LOJA		: "+_cLojClient+CRLF
			cTxt += "E1_PREFIXO		: "+Substr(_aAlias10[j][4],1,TamSX3("E1_PREFIXO")[1])+CRLF
			cTxt += "E1_NUM			: "+_cNroDaFac+CRLF
			cTxt += "E1_PARCELA		: "+PADR(_aAlias10[j][5],TamSX3("E1_PARCELA")[1])+CRLF
			cTxt += "E1_TIPO		: "+PADR(_aAlias10[j][6],TamSX3("E1_TIPO")[1])+CRLF
			cTxt += "-------------------------------------------------------"+CRLF
			
			u_XGRVLOG(clLogAuto, cTxt, .T. )
		
		EndIf
		
	Next


Return(lOk)



Static Function GeraSEL(cCorrel)

	local _ab_area := getArea()

	SX5->( dbSetOrder(1) )
	If SX5->( MsSeek( xFilial("SX5")+"RN"+"UNI" ) )

		if empty(cCorrel)
			cCorrel := alltrim(SX5->X5_DESCSPA)
			cCorrel := Strzero( Val(cCorrel),TAMSX3("EL_RECIBO")[1] )
		else
			cCorrel := alltrim(SX5->X5_DESCSPA)
			cCorrel := Strzero( Val(cCorrel)+1,TAMSX3("EL_RECIBO")[1] )

			SX5->( RecLock("SX5",.f.) )
			SX5->X5_DESCRI := 	cCorrel
			SX5->X5_DESCSPA := 	cCorrel
			SX5->X5_DESCENG := 	cCorrel
			SX5->( MsUnlock() )
		endif

	endif

	restArea(_ab_area)

Return(cCorrel)

