#Include "RwMake.ch"
#Include "TopConn.ch"    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALR003    ºAutor  ³Microsiga           º Data ³  08/20/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ALR003()

	Local cString		:= "SF2"
	Local Titulo		:= PadC("Emisión de las Guías de Remisión" ,74)
	Local NomeProg		:= "REM"
	Local Tamanho		:= 'M'
	Local cPerg			:= PADR("IMPGUIA",10)
	
	Private wnrel		
	Private aReturn	:= {"Zebrado", 1,"Administracao", 2, 2, 1, "",1}
	
	dbSelectArea("SX1")
	dbSetOrder(1)

	If dbSeek(cPerg+"01")
		SX1->( RecLock("SX1",.F.) )
		SX1->X1_CNT01 := SF2->F2_SERIE
		SX1->( MsUnlock() )
	EndIf

	If dbSeek(cPerg+"02")
		SX1->( RecLock("SX1",.F.) )
		SX1->X1_CNT01 := SF2->F2_DOC
		SX1->( MsUnlock() )
	EndIf

	If dbSeek(cPerg+"03")
		SX1->( RecLock("SX1",.F.) )
		SX1->X1_CNT01 := SF2->F2_DOC
		SX1->( MsUnlock() )
	EndIf
	
	if Pergunte(cPerg,.T.) 
	
		wnrel	:= SetPrint(cString,NomeProg,cPerg,@Titulo,"","","",.F.,.F.,.F.,Tamanho,,.T.)
	
		cSerie	:= MV_PAR01
		cFatIni	:= MV_PAR02
		cFatFin	:= MV_PAR03

		If nLastKey!=27
	
			SetDefault(aReturn, cString)
			
			If nLastKey!=27
				VerImp()
				//RptStatus({|lEnd| RptNota()})
				RptStatus({|lEnd| RptNota(@lEnd,wnRel,cString,Tamanho,NomeProg)},Titulo)
			EndIf
	
		EndIf   
		
	endif
	
return              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALR003    ºAutor  ³Microsiga           º Data ³  08/20/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                        
Static Function RptNota()

	Local nTotImp, nTotItem, cLin, nIndSF2, nIndSD2
	Local aArea 	:= GetArea()
	Local nTotal	:= 0
	Local nTotIGV	:= 0
	Local nTotPer	:= 0
	Local nPercPer	:= 0
	Local cDescProd	:= Space(TamSx3("B1_DESC")[1])
	Local aObs1 	:= {}
	Local cYObs1 	:= "" 
	Local cMes      := ""
	
	private _xAlias	:= getNextAlias()
	
	nLin := 0
	                  
	DbSelectArea("SB1")
	DbSetOrder(1)
	
	DbSelectArea("SA1")
	DbSetOrder(1)
	
	DbSelectArea("SD2")
	nIndSD2 := IndexOrd()
	DbSetOrder(3)
	
	DbSelectArea("SF2")         
	nIndSF2 := IndexOrd()
	DbSetOrder(1)
	If !(DbSeek(xFilial("SF2") + cFatIni + cSerie, .T.))
		Alert("Nro de la guia inicial no existe!")
		return
	EndIf

	cSql := "SELECT *" 
	cSql += "  FROM " + RetSqlName("SF2")
	cSql += " WHERE F2_FILIAL='"+xFilial("SF2")+"'"
	cSql += "   AND F2_DOC BETWEEN '"+cFatIni+"' AND '"+cFatFin+"'"
	cSql += "   AND F2_SERIE='" + cSerie + "'"
	cSql += "   AND D_E_L_E_T_=' '" 
	cSql += "   AND F2_ESPECIE='RFN'" 
	cSql += " ORDER BY F2_DOC"
		
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cSql),_xAlias, .F., .T.)  
		
	While (_xAlias)->(!Eof())
	
		xCabecGR()
	
		cQry := "SELECT D2_DOC,D2_SERIE,D2_PEDIDO,D2_COD,D2_ITEM,D2_PRCVEN,D2_ITEMPV," 
		cQry += "  SUM(D2_QUANT) D2_QUANT,SUM(D2_TOTAL) D2_TOTAL,SUM(D2_VALIMP1) D2_VALIMP1,SUM(D2_VALIMP4) D2_VALIMP4" 
		cQry += "  FROM " + RetSqlName("SD2")
		cQry += " WHERE D2_DOC='" + (_xAlias)->F2_DOC + "'"
		cQry += "   AND D2_SERIE='" + (_xAlias)->F2_SERIE + "'"
		cQry += "   AND D2_CLIENTE='" + (_xAlias)->F2_CLIENTE + "'"
		cQry += "   AND D_E_L_E_T_=' '" 
		cQry += "   AND D2_ESPECIE='RFN'" 
		cQry += " GROUP BY D2_DOC,D2_SERIE,D2_PEDIDO,D2_COD,D2_ITEM,D2_PRCVEN,D2_ITEMPV"
		cQry += " ORDER BY D2_ITEMPV"
		
		cAlias := CriaTrab(Nil,.F.)
		DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQry),cAlias, .F., .T.)  
		
		While (cAlias)->(!Eof())
		
			SC6->( MsSeek( xFilial("SC6")+(cAlias)->D2_PEDIDO+(cAlias)->D2_ITEMPV ) )
		
			_aMemo := {}
			_cMemo := ""
			_cMemo := SC6->C6_YSTRUCT
			_cMemo := replace( _cMemo,":"," " )
			_cMemo := replace( _cMemo,"-",": " )
			_aMemo := StrTokArr( _cMemo , ";" )
	                
		  	@ nLin,005 PSAY (cAlias)->D2_QUANT  picture "999.999.999"  
		  	//@ nLin,020 PSAY ALLTRIM((cAlias)->D2_COD)
			//@ nLin,047 PSAY Posicione("SB1",1,XFILIAL("SB1")+(cAlias)->D2_COD,"B1_UM")
			@ nLin,020 PSAY Posicione("SB1",1,XFILIAL("SB1")+(cAlias)->D2_COD,"B1_UM")

			xLin := 1
			
			If Empty(_cMemo)
				@ nLin,030 PSAY ALLTRIM((cAlias)->D2_COD)
				@ nLin,070 PSAY Alltrim(Posicione("SB1",1,XFILIAL("SB1")+(cAlias)->D2_COD,"B1_DESC")) 
			else
				@ nLin,030 PSAY ALLTRIM((cAlias)->D2_COD) + " " + Alltrim(Posicione("ZZD",1,XFILIAL("ZZD")+SC6->C6_YCODF,"ZZD_DESCRI")) 
				nLin++

				_aItns	:= {}
				_aItm	:= {}
				_cItm	:= ""

				if len(_aMemo) > 0
					for nX := 1 to len(_aMemo)
						_cItm := _aMemo[nX]
						_aItm := StrTokArr( _cItm, "|" )
						Aadd(_aItns,_aItm)
					next nX
				endif
				
				aSort( _aItns,1,, { |x, y| x[1] < y[1] } )

				if len(_aItns) > 0
					nlCol := 030
					for nX := 1 to len(_aItns)
						nlCol += 50
						if nlCol > 130
							xLin ++
							nlCol := 030
						endif
					next nX
				endif
				
				if (nLin+xLin)>60
					eject
					xCabecGR()
				endif
	
				if len(_aItns) > 0
					nlCol := 030
					for nX := 1 to len(_aItns)
						@ nLin, nlCol PSAY _aItns[nX][2]
						nlCol += 50
						if nlCol > 130
							nLin ++
							nlCol := 030
						endif
					next nX
				endif
		
			EndIf						  
			
			nLin++
			
			(cAlias)->(DbSkip())    

		enddo
		
		(cAlias)->( dbCloseArea() )
		
		eject
		(_xAlias)->( dbSkip() )
		
	Enddo
	
	(_xAlias)->( dbCloseArea() )

	Set Device To Screen
	                             
	If aReturn[5] == 1
		Set Printer TO
		DbCommitAll()
		OurSpool(wnrel)
	EndIf
	
	SetPgEject(.F.)
	Ms_Flush()
	          
	DbSelectArea("SF2")
	DbSetOrder(nIndSF2)
	DbSelectArea("SD2")
	DbSetOrder(nIndSD2)
	
	RestArea(aArea)
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO3     ºAutor  ³Microsiga           ºFecha ³  11/21/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 

Static Function VerImp()
	nLin:= 0         
	If aReturn[5]==2
		nOpc:= 1
		While .T.
			Eject
	      	DbCommitAll()
	      	SetPRC(0,0)
	       	If (MsgYesNo("Fomulario esta posicionado ? "))
	      		nOpc := 1
	      	ElseIf (MsgYesNo("Intenta Nuevamente ? "))
	      		nOpc := 2
	      	Else
	      		nOpc := 3
	      	EndIf
			Do Case
	        	Case nOpc == 1                                                       
	            	lContinua := .T.
	            	Exit
	        	Case nOpc == 2
	            	Loop
	         	Case nOpc == 3
	            	lContinua := .F.
	            	Return
	      	EndCase
	   End
	EndIf
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALR003    ºAutor  ³Microsiga           º Data ³  07/24/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xCabecGR

	nLin := 0
	SetPrc(00,00)
	@ 00,000 PSAY Chr(15)
	
	nLin := 9
	
	SD2->( dbSeek(xFilial("SD2") + (_xAlias)->F2_DOC + (_xAlias)->F2_SERIE + (_xAlias)->F2_CLIENTE + (_xAlias)->F2_LOJA) )
	
	cPedido := SD2->D2_PEDIDO
	
	SC5-> ( DbSeek(xFilial("SC5") + cPedido, .T.) )
	SC6-> ( DbSeek(xFilial("SC6") + cPedido, .T.) )
	
	If SA1->(DbSeek(xFilial('SA1')+(_xAlias)->(F2_CLIENTE+F2_LOJA)))
		cNome		:= SA1->A1_NOME
		cEnd  		:= SA1->A1_END
		cRuc  		:= SA1->A1_CGC
		cEmision 	:= SF2->F2_EMISSAO  
	    cDia		:= SubStr(DtoS(cEmision),7,2)
		nMes		:= SubStr(DtoS(cEmision),5,2)
		cAno		:= SubStr(DtoS(cEmision),1,4)          
		cCond 		:= (_xAlias)->F2_COND
	endif

	if !empty(SC5->C5_YENDENT)
		cEnd  := Alltrim(SC5->C5_YENDENT)+" "+Alltrim(SC5->C5_YDISENT)
		cEnd1 := Alltrim(SC5->C5_YPROENT)+"-"+Alltrim(SC5->C5_YDPTENT)
	endif
	
	
	@ nLin + 1 , 004 PSay "DOMICILIO DE PARTIDA"
	@ nLin + 1 , 030 PSay ": "+Alltrim(UPPER(SM0->M0_ENDENT))
	@ nLin + 1 , 140 PSay Alltrim(If(empty((_xAlias)->F2_SERIE2),(_xAlias)->F2_SERIE,(_xAlias)->F2_SERIE2)) + "-" + Alltrim((_xAlias)->F2_DOC)
	@ nLin + 2 , 004 PSay "DESTINATARIO"
	@ nLin + 2 , 030 PSay ": "+UPPER(cNome) 
	@ nLin + 2 , 140 PSay "PEDIDO Nº: " + Alltrim((_xAlias)->F2_YCOD)
	@ nLin + 3 , 004 PSay "DIRECCION"
	@ nLin + 3 , 030 PSay ": "+alltrim(UPPER(cEnd))+" "+alltrim(UPPER(cEnd1))
	//@ nLin + 4 , 030 PSay "  "+UPPER(cEnd1)
	@ nLin + 4 , 004 PSay "R.U.C."
	@ nLin + 4 , 030 PSay ": "+UPPER(cRuc)
	@ nLin + 5 , 004 PSay "TRANSPORTISTA"
	@ nLin + 5 , 030 PSay ": "+UPPER(Posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"A4_NOME"))
	@ nLin + 5 , 076 PSay "FECHA PARTIDA: "+DtoC(SC5->C5_YINITRA)
	@ nLin + 6 , 004 PSay "R.U.C."
	@ nLin + 6 , 030 PSay ": "+UPPER(Posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"A4_CGC"))
	@ nLin + 6 , 076 PSay "Nº DE PLACA  : " +UPPER(Posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"A4_PLACA"))
	@ nLin + 7 , 004 PSay "DOMICILIO"
	@ nLin + 7 , 030 PSay ": "+Alltrim(UPPER(Posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"A4_END")))
	@ nLin + 7 , 076 PSay "CHOFER       : " +Alltrim(UPPER(Posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"A4_NREDUZ")))
	
	@ nLin + 8, 004 PSAY Replicate("-",150)

	@ nLin + 9,  006 PSAY "CANTIDAD"
	@ nLin + 9,  018 PSAY "UNIDAD DE"
	@ nLin + 9,  030 PSAY "DESCRIPCION"
	@ nLin + 10, 019 PSAY "MEDIDA"
	
	@ nLin + 11, 004 PSAY Replicate("-",150)
	
	nLin := 21
	
Return