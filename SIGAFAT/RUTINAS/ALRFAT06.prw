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
±±ºPrograma  ³ALRFAT06  ºAutor  ³Percy Arias,SISTHEL º Data ³  09/03/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Resumen de Ventas por Familia                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ALRFAT06()

	Local aArea			:= GetArea()
	Local clPathCli		:= GetTempPath()
	Local nlLin			:= 80
	Local Titulo		:= "Resumo de Ventas"

	Private oPrint
	Private cpNameArq	:= "RV_"+ DtoS(Date()) + "_" + Strtran(Time(), ":", "")
	Private cpPathServ	:= "\Relato"
	Private cPerg		:= PadR ("ALFAT06", Len (SX1->X1_GRUPO))
	
	if Pergunte(cPerg,.T.)	

		oPrint := FWMSPrinter():New(cpNameArq, IMP_PDF,.T., /*clPathServer*/,.T.,,,,, /*[ lPDFAsPNG]*/,, .T./*[ lViewPDF]*/, )
			
		oPrint:SetResolution(72)
		oPrint:SetLandscape()
		oPrint:setPaperSize(9)
		oPrint:cPathPDF := clPathCli
	
		RptStatus({|| RunReport2(nlLin) },Titulo)
	
	endif
	
	RestArea( aArea )
	
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³JLTR001   ºAutor  ³Microsiga           º Data ³  09/08/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RunReport2(nlLin)

	Local cQry			:= ""
	Local cNroDias 		:= getNewPar("AL_DIARPT",10)
	Local nomeprog   	:= "ALRFAT06"
	Local cIndSC2    	:= CriaTrab(NIL,.F.), nIndSC2
	Local olFont01		:= TFont():New("Calibri",	9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	Local olFont02		:= TFont():New("Calibri",	9,12,.T.,.F.,5,.T.,5,.T.,.F.)
	Local olFont03		:= TFont():New("Calibri",	9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	Local olFont04		:= TFont():New("Calibri",	9,18,.T.,.T.,5,.T.,5,.T.,.F.)
	Local olFont16		:= TFont():New("Calibri",	9,16,.T.,.F.,5,.T.,5,.T.,.F.)
	Local nlPag			:= 1
	Local dFechaAtu		:= ctod(space(8))
	
	if ( mv_par04-mv_par03)>cNroDias
		Alert("Periodo mayor que "+alltrim(str(cNroDias))+" dias!")
		return
	endif
	
	cQry := "SELECT C6_YCODF,C5_EMISSAO,SUM(C6_QTDVEN) NQTDE "
	cQry += "  FROM "+RetSqlName("SC5")+" SC5,"+RetSqlName("SC6")+" SC6"
	cQry += " WHERE C6_FILIAL='"+xFilial("SC6")+"'"
	cQry += "   AND C5_FILIAL='"+xFilial("SC5")+"'"
	cQry += "   AND SC5.D_E_L_E_T_=''"
	cQry += "   AND SC6.D_E_L_E_T_=''"
	cQry += "   AND C5_NUM=C6_NUM"
	cQry += "   AND C5_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"'"
	cQry += "   AND C6_YCODF BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cQry += " GROUP BY C6_YCODF,C5_EMISSAO"
	cQry += " ORDER BY C6_YCODF,C5_EMISSAO"
	
	If Select("PCY") > 0
		PCY->( dbCloseArea() )
	EndIf

	dFechaAtu = mv_par03
	aStruct := {}
	cArq := CriaTrab(Nil,.F.)

	AAdd( aStruct,{ "FAMILIA"		,"C",06,0	} )
	
	for nX := 1 to cNroDias
		AAdd( aStruct,{ "F_"+dtos(dFechaAtu)	,"N",10,0	} )
		dFechaAtu++
	next nX

	DbCreate(cArq , aStruct )
	DbUseArea(.T. ,, cArq ,"PCY",.T.,.F.)
	IndRegua("PCY" , cArq ,"FAMILIA",,,"Indexando registros..." , .T. )

	cQry := ChangeQuery(cQry)
	
	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbClosearea())
	EndIf
	
	TcQuery cQry New Alias "QRY"

	If QRY->( !Eof() )
	
		While QRY->( !Eof() )
            
            dFechaAtu := mv_par03
            
            if PCY->( dbSeek( QRY->C6_YCODF ) )
            	PCY->( RecLock("PCY",.F.) )
            else
            	PCY->( RecLock("PCY",.T.) )
            	PCY->FAMILIA := QRY->C6_YCODF
            endif
			for nX := 1 to cNroDias
				if QRY->C5_EMISSAO==dtos(dFechaAtu)
					PCY->&("F_"+dtos(dFechaAtu)) := PCY->&("F_"+dtos(dFechaAtu)) + fGetTotales(QRY->C6_YCODF,dtos(dFechaAtu))
				else
					PCY->&("F_"+dtos(dFechaAtu)) := fGetTotales(QRY->C6_YCODF,dtos(dFechaAtu))
				endif
				dFechaAtu++
			next nX
			PCY->( MsUnlock() )
		
			QRY->( dbSkip() )
			
		End
		
	EndIf

	QRY->(DbClosearea())

	PCY->( dbgotop() )
	
	If PCY->( !Eof() )
	
		ZZD->( dbSetOrder(1) )
		
		SetRegua(PCY->(lastrec()))
		nlLin := xcabec(nlLin, olFont03, olFont04, nlPag, olFont16)
		PCY->( dbgotop() )

		While PCY->( !Eof() )
		
			IncRegua()
			
			if ZZD->( !dbSeek( xFilial("ZZD")+PCY->FAMILIA ) )
				PCY->( dbSkip() )
				Loop
			endif
			
			if (nlLin+80) > 2000 
				nlLin += 30
				oPrint:Line	(nlLin,0000,nlLin,3000)
				nlLin += 30
				oPrint:Say	(nlLin, 2900, "Pg."+alltrim(str(nlPag)), olFont01)
				nlPag++
				oPrint:EndPage()
				nlLin := xcabec(nlLin, olFont03, olFont04, nlPag, olFont16)
			endif

			dFechaAtu := mv_par03

			oPrint:Say	(nlLin, 0050, PCY->FAMILIA+" "+Posicione("ZZD",1,xFilial("ZZD")+PCY->FAMILIA,"ZZD->ZZD_DESCRI"), olFont01)
			n_col := 800

			for nX := 1 to cNroDias
				oPrint:Say	(nlLin, n_col, transform(PCY->(&("F_"+dtos(dFechaAtu))),"9999.99"), olFont01 )
				dFechaAtu++
				n_col+=200
			next nX

			nlLin += 40
			PCY->( dbSkip() )
			
		End

		nlLin += 30
		oPrint:Line	(nlLin,0000,nlLin,3000)
		nlLin += 30
		oPrint:Say	(nlLin, 2900, "Pg."+alltrim(str(nlPag)), olFont01)
		nlPag++
		oPrint:EndPage()
		
	EndIf
	
	PCY->(DbClosearea())
	
	SET DEVICE TO SCREEN	
	oPrint:Preview()
	
	MS_FLUSH()	
	
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALRFAT06  ºAutor  ³Microsiga           º Data ³  09/24/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fGetTotales( cFam, cFech )

	local cQry := ""
	local nCant := 0

	cQry := "SELECT C6_YCODF,C5_EMISSAO,SUM(C6_QTDVEN) NQTDE "
	cQry += "  FROM "+RetSqlName("SC5")+" SC5,"+RetSqlName("SC6")+" SC6"
	cQry += " WHERE C6_FILIAL='"+xFilial("SC6")+"'"
	cQry += "   AND C5_FILIAL='"+xFilial("SC5")+"'"
	cQry += "   AND SC5.D_E_L_E_T_=''"
	cQry += "   AND SC6.D_E_L_E_T_=''"
	cQry += "   AND C5_NUM=C6_NUM"
	cQry += "   AND C5_EMISSAO='"+cFech+"'"
	cQry += "   AND C6_YCODF='"+cFam+"'"
	cQry += " GROUP BY C6_YCODF,C5_EMISSAO"
	cQry += " ORDER BY C6_YCODF,C5_EMISSAO"
	
	cQry := ChangeQuery(cQry)
	
	If Select("TTT") > 0
		Dbselectarea("TTT")
		TTT->(DbClosearea())
	EndIf
	
	TcQuery cQry New Alias "TTT"
	
	If TTT->( !Eof() )
		nCant := TTT->NQTDE
	EndIf
	
	TTT->( dbCloseArea() )

Return( nCant )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALRFAT06  ºAutor  ³Microsiga           º Data ³  09/24/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xcabec(nlLin, olFont03, olFont04, nlPg, olFont16 )
                                                                  
	oPrint:StartPage()
	nlLin := 0010

	nlLin += 10
	oPrint:SayBitmap( (nlLin+50), 0060, "\system\lgmid02.png", 320, 140)
	nlLin += 105
	oPrint:Say	(nlLin, 0500, Upper(SM0->M0_NOMECOM), olFont04)	
	nlLin += 50
	oPrint:Say	(nlLin, 0500, Upper(SM0->M0_ENDENT), olFont03)
	oPrint:Say	(nlLin, 2400, "Emisión: " + Dtoc(dDataBase), olFont03)
	nlLin += 50
	oPrint:Say	(nlLin, 0500, "R.U.C. "+SM0->M0_CGC, olFont03)
	oPrint:Say	(nlLin, 2400, "Periodo: " + Dtoc(mv_par03) + " a " + Dtoc(mv_par04), olFont03)
	nlLin += 40
	oPrint:Line	(nlLin,0000,nlLin,3000)
	nlLin += 40
	
	nlCol := 800
	
	for nX := 1 to PCY->( Fcount() )
		if PCY->( fieldName(nX) ) == "FAMILIA"
			oPrint:Say	(nlLin, 0050, PCY->(FieldName(nX)), olFont03)
		else
			oPrint:Say	(nlLin, nlCol, substr(PCY->(FieldName(nX)),9,2)+"/"+substr(PCY->(FieldName(nX)),7,2), olFont03)
			nlCol+=200
		endif
	next

	nlLin += 40
	oPrint:Line	(nlLin,0000,nlLin,3000)
	nlLin += 40
    
Return nlLin
