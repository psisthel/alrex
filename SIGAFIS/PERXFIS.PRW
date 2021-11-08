#Include "PROTHEUS.Ch"
/*
Inicio: libro diario
*/
User Function fFindA12( cForCte,cLoj,cTpp )
	
	local _aInfo := {}
	local _lTem := .f.
	
	if cTpp=="V"
		SA1->( dbSetOrder(1) )//A1_FILIAL+A1_COD+A1_LOJA
		If SA1->( dbSeek( xFilial("SA1")+cForCte+cLoj) )
			Aadd( _aInfo, { alltrim(str(val(SA1->A1_TIPDOC))),SA1->A1_PFISICA,SA1->A1_CGC,"" } )
			_lTem := .t.
		EndIf
	endif
	
	if cTpp=="C"
		If !_lTem
			SA2->( dbSetOrder(1) )//A2_FILIAL+A2_COD+A2_LOJA 
			If SA2->( dbSeek( xFilial("SA2")+cForCte+cLoj) )
				Aadd( _aInfo, { alltrim(str(val(SA2->A2_TIPDOC))),SA2->A2_PFISICA,SA2->A2_CGC,SA2->A2_DOMICIL } )
				_lTem := .t.
			EndIf
		EndIf
	endif
	
	if cTpp=="5"
		If !_lTem
			SA6->( dbSetOrder(3) )//A6_FILIAL, A6_COD, A6_AGENCIA, A6_NUMCON
			If SA6->( dbSeek( xFilial("SA6")+cForCte ) )
				if !empty(SA6->A6_CGC)
					Aadd( _aInfo, { "6","",SA6->A6_CGC,"" } )
				else
					Aadd( _aInfo, { "0","","00000000000","" } )
				endif
				_lTem := .t.
			EndIf
		EndIf
	endif
	
	if len(_aInfo)==0
		Aadd( _aInfo, { "","","","" } )
	endif

Return(_aInfo)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PERXFIS   ºAutor  ³Microsiga           ºFecha ³  12/16/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fDocOri(cCTK_KEY, cCTL_ALIAS,cCTL_ORDER,_pLp)
Local vArea := getArea()
Local cDoc:=''
Local cSer:=''
Local cFor:=''
Local cLoj:=''
Local cSe2:=''
Local cSe3:=''
Local cTp :=''
Local cTpD:=''
Local cEmi:=''
Local aRet:={}

if !empty(_pLp)

	if !empty(cCTK_KEY) .and. !empty(cCTL_ALIAS)

		DBSELECTAREA(cCTL_ALIAS)
		DBSETORDER(VAL(cCTL_ORDER))

		IF MsSEEK(alltrim(cCTK_KEY))
			 Do Case
			  	Case cCTL_ALIAS$"SF1/SD1"
			  		
			  		if cCTL_ALIAS=="SD1"
			  		
						SF1->(DBSETORDER(1))//F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA
		   		        if SF1->(!MsSEEK(xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA))
		
				   		     cDoc:=SD1->D1_DOC
				   		     cSer:=SD1->D1_SERIE
				   		     cSe2:=''
				   		     cFor:=SD1->D1_FORNECE
							 cLoj:=SD1->D1_LOJA
							 cEmi:=dtos(SD1->D1_EMISSAO)
							 cSe3:=SD1->D1_SERIE
							 cTpD:=''
							 cTp:="C"
		   		        
		   		        else
		
				   		     cDoc:=SF1->F1_DOC
				   		     cSer:=SF1->F1_SERIE
				   		     cSe2:=SF1->F1_SERIE2
				   		     cFor:=SF1->F1_FORNECE
							 cLoj:=SF1->F1_LOJA
							 cEmi:=dtos(SF1->F1_EMISSAO)
							 cSe3:=SF1->F1_SERIE
							 cTpD:=SF1->F1_TPDOC
							 cTp:="C"
							
							 if alltrim(SF1->F1_ESPECIE)=="NCC"
								cSe2 := PuxaSer2(cSer)
								cTp:="V"
							 endif
			   		        
		   		        endif
		   		        
		   			else
	
			   		     cDoc:=SF1->F1_DOC
			   		     cSer:=SF1->F1_SERIE
			   		     cSe2:=SF1->F1_SERIE2
			   		     cFor:=SF1->F1_FORNECE
						 cLoj:=SF1->F1_LOJA
						 cEmi:=dtos(SF1->F1_EMISSAO)
						 
						 cSe3:=SF1->F1_SERIE
						 cTpD:=SF1->F1_TPDOC
						 cTp:="C"
						
						 if alltrim(SF1->F1_ESPECIE)=="NCC"
							cSe2 := u_PuxaSer2(cSer)
							cTp:="V"
						 endif
						 
					endif
						
				Case cCTL_ALIAS$"SF2/SD2"
		
			  		if cCTL_ALIAS=="SD2"
						SF2->(DBSETORDER(1))//F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO 
		   		        if SF2->(!MsSEEK(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA))
				   		     cDoc:=SD2->D2_DOC
				   		     cSer:=SD2->D2_SERIE
				   		     cSe2:=''
				   		     cFor:=SD2->D2_CLIENTE
							 cLoj:=SD2->D2_LOJA
							 cEmi:=dtos(SD2->D2_EMISSAO)
							 cSe3:=SD2->D2_SERIE
							 cTpD:=''
							 cTp:="V"
						else
				   		     cDoc:=SF2->F2_DOC
				   		     cSer:=if(empty(SF2->F2_SERIE),SF2->F2_SERIE,PuxaSer2(SF2->F2_SERIE))
				   		     cSe2:=SF2->F2_SERIE2
				   		     cFor:=SF2->F2_CLIENTE
							 cLoj:=SF2->F2_LOJA
							 cEmi:=dtos(SF2->F2_EMISSAO)
							 cSe3:=cSer
							 cTpD:=SF2->F2_TPDOC
							 cTp:="V"
			
							 if alltrim(SF2->F2_ESPECIE)=="NCP"
								cTp:="C"
							 endif
		   		        endif
		
		   			else
		            
			   		     cDoc:=SF2->F2_DOC
			   		     cSer:=if(empty(SF2->F2_SERIE),SF2->F2_SERIE,u_PuxaSer2(SF2->F2_SERIE))
			   		     cSe2:=SF2->F2_SERIE2
			   		     cFor:=SF2->F2_CLIENTE
						 cLoj:=SF2->F2_LOJA
						 cEmi:=dtos(SF2->F2_EMISSAO)
						 cSe3:=cSer
						 cTpD:=SF2->F2_TPDOC
						 cTp:="V"
		
						 if alltrim(SF2->F2_ESPECIE)=="NCP"
							cTp:="C"
						 endif
					
					endif
						
			   	Case cCTL_ALIAS="SEL"
			   		     cDoc:=EL_NUMERO
			   		     cSer:=EL_PREFIXO
			   		     cFor:=EL_CLIENTE
			   		     cLoj:=EL_LOJA
			   		     cEmi:=""
			   		     
			   		     If EL_TIPO == "NCC"
			   		        SF1->(DBSETORDER(1))//F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO 
			   		        IF SF1->(MsSEEK(xFilial("SF1")+cDoc+cSer+cFor+cLoj))
					   		     cSe3:=SF1->F1_SERIE
					   		     IF EMPTY(SF1->F1_SERIE)
					   		     	cSe2:=SF1->F1_SERIE2
					   		     ELSE
					   		     	cSe2:=u_PuxaSer2(SF1->F1_SERIE)
					   		     ENDIF
					   		     cTpD:=SF1->F1_TPDOC
					   		     cTp:="V"
					   		     dEmi:=SF1->F1_EMISSAO
							ELSE
								 cTpD:='00'
								 cTp:="F"
								 cSe3:=""
								 cLoj:=""
							ENDIF
										
		
						Else
							SF2->(DBSETORDER(1))//F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO 
			   		        IF SF2->(MsSEEK(xFilial("SF2")+cDoc+cSer+cFor+cLoj))
			   		         	
			   		         	cSer:=SF2->F2_SERIE
			   		         	IF EMPTY(SF2->F2_SERIE)
					   		     	cSe2:=SF2->F2_SERIE2
					   		     ELSE
					   		     	cSe2:=u_PuxaSer2(SF2->F2_SERIE)
					   		     ENDIF
					   		     cTpD:=SF2->F2_TPDOC
					   		     cTp:="V"
					   		     dEmi:=SF2->F2_EMISSAO
					   		ELSE
					   		 	 cTpD:='00'
								 cTp:="F"
								 cSe3:=""
								 cLoj:=""
					   		ENDIF     
						ENDIF
							
							   		     
			   		     
			  	Case cCTL_ALIAS="SEK"
			   		    cDoc:=EK_NUM
			   		    cSer:=EK_PREFIXO
			   		    cFor:=EK_FORNECE
			   		    cLoj:=EK_LOJA
		
			   		     If EK_TIPO == "NCP"
			   		        SF2->(DBSETORDER(1))//F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO 
			   		        IF SF2->(MsSEEK(xFilial("SF2")+cDoc+cSer+cFor+cLoj))
					   		     cSe3:=SF2->F2_SERIE
					   		     IF EMPTY(SF2->F2_SERIE)
					   		     	cSe2:=SF2->F2_SERIE2
					   		     ENDIF
					   		     cTpD:=SF2->F2_TPDOC
					   		     cTp:="C"
					   		     dEmi:=SF2->F2_EMISSAO
							ELSE
								 cTpD:='00'
								 cTp:="F"
								 cSe3:=""
								 cLoj:=""
							ENDIF
						
						ELSE
		
				   		    SF1->(DBSETORDER(1))//F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO 
				   		    IF SF1->(MsSEEK(xFilial("SF1")+cDoc+cSer+cFor+cLoj))
				   		         	 cSer:=SF1->F1_SERIE
						   		     cSe3:=SF1->F1_SERIE
						   		     IF EMPTY(SF1->F1_SERIE)
						   		     	cSe2:=SF1->F1_SERIE2
						   		     ENDIF
						   		     cTpD:=SF1->F1_TPDOC
						   		     cTp:="C"
						   		     dEmi:=SF1->F1_EMISSAO
							ELSE
									 cTpD:='00'
									 cTp:="F"
									 cSe3:=""
									 cLoj:=""
							ENDIF
				   		   
			   		     ENDIF
			   		     
			 	Case cCTL_ALIAS="SE5"
			   		    cSer:=E5_PREFIXO
						cDoc:= alltrim(Iif( empty(E5_NUMCHEQ),E5_DOCUMEN,E5_NUMCHEQ ))
						cFor:=E5_CLIFOR
						cTpD:='00'
						cTp:="5"
						cSe3:=""
						cLoj:=E5_LOJA
						cEmi:=""
						
						if empty(cFor)			// A6_FILIAL, A6_COD, A6_AGENCIA, A6_NUMCON
							SA6->( dbSetOrder(1) )
							if SA6->( dbSeek( xFilial("SA6")+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA ) )
								if !empty(SA6->A6_CGC)
									cFor := SA6->A6_CGC
								else
									cFor := ""
								endif
							endif
						endif
						
			EndCase
		ENDIF
	endif
endif

 Aadd( aRet, { cTpD,cSer,cSe2,cDoc,cFor,cTp,cEmi,cSe3,cLoj} )
//Sin uso cSe3, cTp

restArea(vArea)
				
Return(aRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PERXFIS   ºAutor  ³Microsiga           ºFecha ³  12/16/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fgenAnidado(cDocX,cFornece,dPFecIni,dPFecFin,cCodLibr,cSegofi,cContAux,cXFilial)

	local harea := getArea()
	local klin := ""
	local cParc := Padr(Alltrim(GetMV("MV_1DUP")),TamSX3("E2_PARCELA")[1])
	
	cTipDoc := ""
	cOserie := ""
	cTienda := ""
	cMovtip := ""
	cEspecie:= ""
	nDetra  := 0
	cFilSF3 := ""
	dFechsf3:= ctod("  /  /  ")
	cDctb   := ""
	cF1doc  := ""
	cOtienda:=''
	cOtienda := Posicione("SF3",6,xfilial("SF3")+cDocX,"F3_LOJA")  
	If 	empty(cOtienda)
		cOtienda:= Posicione("SA2",1,xfilial("SA2")+cFornece,"A2_LOJA")
	endif
	SF3->( dbSetOrder(4) ) //F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE
	SF1->( dbSetOrder(2) ) //F1_FILIAL+F1_FORNECE+F1_LOJA+F1_DOC   
	IF SF3->( MsSeek( xFilial("SF3")+cFornece+cOtienda+cDocX ) )
		cTipDoc := SF3->F3_TPDOC
		cOserie := SF3->F3_SERIE
	   cTienda := SF3->F3_LOJA
	   cMovtip := SF3->F3_TIPOMOV
	   cEspecie:= SF3->F3_ESPECIE
	   nDetra  := SF3->F3_VALIMP5
	   cFilSF3 := SF3->F3_FILIAL
	   dFechsf3:= SF3->F3_EMISSAO
	ENDIF
	IF SF1->( MsSeek( xFilial("SF1")+cFornece+cOtienda+cDocX ) )
	   cTipDoc := SF1->F1_TPDOC
	   cDctb   := SF1->F1_DIACTB
	   cF1doc  := SF1->F1_DOC
	ENDIF
	
	cMesInic := SUBSTR(DtoS(dPFecIni),5,2) //Mes Inicial Selecionado
	cAnoInic := SUBSTR(DtoS(dPFecIni),3,2) // Ano Incial Selecionado
	cMesFin  := SUBSTR(DtoS(dPFecFin),5,2) //Mes Final Selecionado
	cAnoFin  := SUBSTR(DtoS(dPFecFin),3,2) // Ano Final Selecionado
		
	If Alltrim(cMesInic) == "01"
		cMesInic := "12"
		cAnoInic := Str(Val(cAnoInic)-1)
	Else
		cMesInic :=	Strzero(Val(cMesInic)-1,2)
	EndIF
	
	dDUtilInic := RetDiaUtil(cMesInic, cAnoInic) //  Retorna o Quinto dia util do mes Inicial selecionado
	dDUtilFin  := RetDiaUtil(cMesFin, cAnoFin) //  Retorna o Quinto dia util do proximo mes Final selecionado
	SE2->(DbGoTop())
	SE2->(dbSetOrder(6))//E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO      
	If cMovtip="C" .And. alltrim(cEspecie)="NF" .And. cTipDoc="14"
		cFilSE2:=IIF(!EMPTY(xFilial('SE2')),cXFilial,XFILIAL('SE2'))		
		                                                                                                        
		If SE2->(Dbseek(cFilSE2+cFornece+cTienda+cOserie+cDocX)) //Procura o titulo TX no SE2, se encontrar deve imprimir
			cVcto := SE2->E2_VENCTO
			dBaixa:= SE2->E2_BAIXA
			If empty(dBaixa)
				klin := ""
			else
				If dBaixa>dPFecFin
					klin := ""
				Else
					klin := cCodLibr+"&"+SubStr(DTOS(dPFecIni),1,6)+"00&"+AllTrim(cSegofi)+"&"+cContAux
				endif
			EndIF
		EndIf	
								             
	ElseIf ALLTRIM(cMovtip)="C" .And. ALLTRIM(cEspecie)="NF" .And. nDetra>0
	
		cFilSE2:=IIF(!EMPTY(xFilial('SE2')),cXFilial,XFILIAL('SE2'))		
		SE2->(Dbseek(cFilSE2+cFornece+cTienda+cOserie+cDocX+cParc)) //Procura o titulo TX no SE2, se encontrar deve imprimir
		dBaixa:= SE2->E2_BAIXA					   
		aRet := u_DetIGVFn(cFornece,cTienda,(dDUtilInic-30),(dDUtilFin)) // Preenche o array aRet de acordo com a funcao 
		nPos :=Ascan(aRet,{|x| x[1]+x[2]+x[5] == SE2->E2_PREFIXO+SE2->E2_NUM+cMV_1DUP})
	
		If nPos>0 .and. dFechsf3 <= dPFecFin .AND. cEspecie='NF' .AND. dBaixa<= dPFecFin   
			cPrefixo := aRet[nPos,1]//Prefixo
			cNumero  := aRet[nPos,2]// Numero do Titulo
			cParcela := aRet[nPos,5]// Parcela
			cTipo := "TX"  			// Tipo que deve ser TX
			cFilSE2:=IIF(!EMPTY(xFilial('SE2')),cXFilial,XFILIAL('SE2'))
			dSfefecha:=Posicione("SFE",4,xfilial("SFE")+cFornece+cTienda+cNumero+cPrefixo,"FE_EMISSAO")  
	
			If ALLTRIM(cNumero) == ALLTRIM(cDocX)//Verifica se o titulo do aRet e o mesmo do TRB4
				cProve:= cFornece    						 
				SE2->(DbGoTop())
				SE2->(dbSetOrder(1))//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA  
				If SE2->(Dbseek(cFilSE2+cPrefixo+cNumero+cParcela+cTipo)) //Procura o titulo TX no SE2, se encontrar deve imprimir  
					SE2->(dbSetOrder(6))//E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO                                                                                                        
					If SE2->(Dbseek(cFilSE2+cProve+cTienda+cPrefixo+cNumero+cParcela+cTipo)) //Procura o titulo TX no SE2, se encontrar deve imprimir 
						dFecha:=SE2->E2_BAIXA
						If dBaixa<(dPFecIni) .AND. dFecha>(dDUtilInic) .AND. dFecha<=(dDUtilFin) .AND. (dFechsf3)>=(dPFecIni) 
							klin := cCodLibr+"&"+SubStr(DTOS(dPFecIni),1,6)+"00&"+AllTrim(cSegofi)+"&"+cContAux
						ElseIf (dBaixa)<(dPFecIni) .AND. dFecha>(dDUtilInic) .AND. dFecha<=(dDUtilFin) .AND. (dFechsf3)<(dPFecIni) .AND. (dSfefecha)>=(dPFecIni) .AND. Ctod(dSfefecha)<=(dPFecFin)							
							klin := cCodLibr+"&"+SubStr(DTOS(dPFecIni),1,6)+"00&"+AllTrim(cSegofi)+"&"+cContAux			
						ElseIf (dBaixa)>=(dPFecIni) .AND. dFecha>=(dPFecIni) .AND. dFecha<=(dDUtilFin) 
							If dFecha<=(dBaixa) .AND. (dFechsf3)>=(dPFecIni) .AND. (dFechsf3)<=(dPFecFin) .AND. (dBaixa)<=(dPFecFin)  
								klin := cCodLibr+"&"+SubStr(DTOS(dPFecIni),1,6)+"00&"+AllTrim(cSegofi)+"&"+cContAux			
							ElseIf dFecha<=(dBaixa) .AND. (dFechsf3)>=(dPFecIni) .AND. (dFechsf3)<=(dPFecFin) .AND. dFecha>=(dPFecIni) .AND. dFecha<=(dPFecFin) .AND. (dBaixa)>(dPFecFin)									 									 	
								klin := cCodLibr+"&"+SubStr(DTOS(dPFecIni),1,6)+"00&"+AllTrim(cSegofi)+"&"+cContAux			
							ElseIf (dBaixa)>(dDUtilInic) .AND. dFecha>(dDUtilInic) .AND. (dBaixa)<=(dPFecFin) .AND. dFecha<=(dDUtilFin) .AND. (dFechsf3)>=(dPFecIni) .AND. (dFechsf3)<=(dPFecFin)
								klin := cCodLibr+"&"+SubStr(DTOS(dPFecIni),1,6)+"00&"+AllTrim(cSegofi)+"&"+cContAux			
							ElseIf (dBaixa)>=(dPFecIni) .AND. dFecha>=(dPFecIni) .AND. (dBaixa)<=(dPFecFin) .AND. dFecha<=(dPFecFin).AND. (dFechsf3)<(dPFecIni-31)
								klin := cCodLibr+"&"+SubStr(DTOS(dPFecIni),1,6)+"00&"+AllTrim(cSegofi)+"&"+cContAux			
							ElseIf (dBaixa)<(dPFecIni) .AND. dFecha>=(dPFecIni) .AND. dFecha<=(dPFecFin) .AND. (dFechsf3)<(dPFecIni-31)							 	 									                             		 
								klin := cCodLibr+"&"+SubStr(DTOS(dPFecIni),1,6)+"00&"+AllTrim(cSegofi)+"&"+cContAux			
							ElseIf (dBaixa)>=(dPFecIni) .AND. dFecha>=(dPFecIni) .AND. dFecha<=(dDUtilFin) .AND. (dFechsf3)>=(dPFecIni) .AND. (dFechsf3)<=(dPFecFin) .AND. (dBaixa)<=(dPFecFin)
								klin := cCodLibr+"&"+SubStr(DTOS(dPFecIni),1,6)+"00&"+AllTrim(cSegofi)+"&"+cContAux			
							ElseIf (dBaixa)>=(dPFecIni) .AND. dFecha>=(dPFecIni) .AND. dFecha<=(dDUtilInic) .AND. (dBaixa)<=(dDUtilInic)  // F3_ENTRADA
								klin := cCodLibr+"&"+SubStr(DTOS(dPFecIni),1,6)+"00&"+AllTrim(cSegofi)+"&"+cContAux			
							ElseIf (dBaixa)>(dDUtilInic) .AND. dFecha>(dDUtilInic) .AND. dFecha<=(dDUtilFin) .AND. (dBaixa)<=(dPFecFin) .AND. (dFechsf3)>(dPFecIni-31) .AND. (dFechsf3)<=(dPFecFin)
								klin := cCodLibr+"&"+SubStr(DTOS(dPFecIni),1,6)+"00&"+AllTrim(cSegofi)+"&"+cContAux			
							ElseIf dFecha>(dDUtilInic) .AND. dFecha<=(dDUtilFin) .AND. (dFechsf3)>(dPFecIni-31) .AND. (dFechsf3)<(dPFecIni) .AND. (dBaixa)>(dDUtilInic) .AND. (dBaixa)<=(dPFecFin)
								klin := cCodLibr+"&"+SubStr(DTOS(dPFecIni),1,6)+"00&"+AllTrim(cSegofi)+"&"+cContAux			
							ElseIf dFecha>(dDUtilInic) .AND. dFecha<=(dDUtilFin) .AND. (dFechsf3)>(dPFecIni-31) .AND. (dFechsf3)<(dPFecIni) .AND. (dBaixa)>=(dPFecIni) .AND. (dBaixa)<=(dPFecFin)
								klin := cCodLibr+"&"+SubStr(DTOS(dPFecIni),1,6)+"00&"+AllTrim(cSegofi)+"&"+cContAux			
							Else	
								klin := ""
							EndIf   
						ElseIf (dBaixa)<(dPFecIni) .AND. dFecha>=(dPFecIni) .AND. dFecha<=(dPFecFin) .AND. (dFechsf3)<(dPFecIni-31)						
							klin := cCodLibr+"&"+SubStr(DTOS(dPFecIni),1,6)+"00&"+AllTrim(cSegofi)+"&"+cContAux			
						ElseIf dFecha>=(dPFecIni) .AND. dFecha<=(dPFecFin) .AND. (dFechsf3)>=(dPFecIni) .AND. (dFechsf3)<=(dPFecFin)							
							klin := cCodLibr+"&"+SubStr(DTOS(dPFecIni),1,6)+"00&"+AllTrim(cSegofi)+"&"+cContAux			
						ElseIf (dBaixa)<(dPFecIni) .AND. dFecha<=(dDUtilInic)
							klin := ""
						Else               
							klin := ""
						Endif
					Endif     
				EndIf
			Endif
									
		ElseIf nPos>0 .and. dFechsf3 <= dPFecFin .AND. cEspecie='NF' .AND. dBaixa > dPFecFin   
			cPrefixo := aRet[nPos,1]//Prefixo
			cNumero  := aRet[nPos,2]// Numero do Titulo
			cParcela := aRet[nPos,5]// Parcela
			cTipo := "TX"  			// Tipo que deve ser TX
			cFilSE2:=IIF(!EMPTY(xFilial('SE2')),cXFilial,XFILIAL('SE2'))
			dSfefecha:=Posicione("SFE",4,xfilial("SFE")+cFornece+cTienda+cNumero+cPrefixo,"FE_EMISSAO")  
	
			If ALLTRIM(cNumero) == ALLTRIM(cDocX) //Verifica se o titulo do aRet e o mesmo do TRB4
				cProve:= cFornece    						
				SE2->(DbGoTop())
				SE2->(dbSetOrder(1))//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA  
				If SE2->(Dbseek(cFilSE2+cPrefixo+cNumero+cParcela+cTipo)) //Procura o titulo TX no SE2, se encontrar deve imprimir  
					SE2->(dbSetOrder(6))//E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO                                                                                                       
					If SE2->(Dbseek(cFilSE2+cProve+cTienda+cPrefixo+cNumero+cParcela+cTipo)) //Procura o titulo TX no SE2, se encontrar deve imprimir 
						dFecha:=SE2->E2_BAIXA
						If dBaixa<(dPFecIni) .AND. dFecha>(dDUtilInic) .AND. dFecha<=(dDUtilFin) .AND. (dFechsf3)>=(dPFecIni) 
							klin := cCodLibr+"&"+SubStr(DTOS(dPFecIni),1,6)+"00&"+AllTrim(cSegofi)+"&"+cContAux			
						ElseIf (dBaixa)<(dPFecIni) .AND. dFecha>(dDUtilInic) .AND. dFecha<=(dDUtilFin) .AND. (dFechsf3)<(dPFecIni) .AND. (dSfefecha)>=(dPFecIni) .AND. Ctod(dSfefecha)<=(dPFecFin) //--ORIGINAL							
							klin := cCodLibr+"&"+SubStr(DTOS(dPFecIni),1,6)+"00&"+AllTrim(cSegofi)+"&"+cContAux			
						ElseIf (dBaixa)>=(dPFecIni) .AND. dFecha>=(dPFecIni) .AND. dFecha<=(dDUtilFin)
							If dFecha<=(dBaixa) .AND. (dFechsf3)>=(dPFecIni) .AND. (dFechsf3)<=(dPFecFin) .AND. (dBaixa)<=(dPFecFin)
								klin := cCodLibr+"&"+SubStr(DTOS(dPFecIni),1,6)+"00&"+AllTrim(cSegofi)+"&"+cContAux			
							ElseIf dFecha<=(dBaixa) .AND. (dFechsf3)>=(dPFecIni) .AND. (dFechsf3)<=(dPFecFin) .AND. dFecha>=(dPFecIni) .AND. dFecha<=(dPFecFin) .AND. (dBaixa)>(dPFecFin)							 									 	
								klin := cCodLibr+"&"+SubStr(DTOS(dPFecIni),1,6)+"00&"+AllTrim(cSegofi)+"&"+cContAux			
							ElseIF (dBaixa)>(dDUtilInic) .AND. dFecha>(dDUtilInic) .AND. (dBaixa)<=(dPFecFin) .AND. dFecha<=(dDUtilFin) .AND. (dFechsf3)>=(dPFecIni) .AND. (dFechsf3)<=(dPFecFin)
								klin := cCodLibr+"&"+SubStr(DTOS(dPFecIni),1,6)+"00&"+AllTrim(cSegofi)+"&"+cContAux			
							ElseIF (dBaixa)>=(dPFecIni) .AND. dFecha>=(dPFecIni) .AND. (dBaixa)<=(dPFecFin) .AND. dFecha<=(dPFecFin).AND. (dFechsf3)<(dPFecIni-31)
								klin := cCodLibr+"&"+SubStr(DTOS(dPFecIni),1,6)+"00&"+AllTrim(cSegofi)+"&"+cContAux			
							ElseIF (dBaixa)<(dPFecIni) .AND. dFecha>=(dPFecIni) .AND. dFecha<=(dPFecFin) .AND. (dFechsf3)<(dPFecIni-31)					 	 									                             		 
								klin := cCodLibr+"&"+SubStr(DTOS(dPFecIni),1,6)+"00&"+AllTrim(cSegofi)+"&"+cContAux			
							ElseIF (dBaixa)>=(dPFecIni) .AND. dFecha>=(dPFecIni) .AND. dFecha<=(dDUtilFin) .AND. (dFechsf3)>=(dPFecIni) .AND. (dFechsf3)<=(dPFecFin) .AND. (dBaixa)<=(dPFecFin)
								klin := cCodLibr+"&"+SubStr(DTOS(dPFecIni),1,6)+"00&"+AllTrim(cSegofi)+"&"+cContAux			
							ElseIF (dBaixa)>=(dPFecIni) .AND. dFecha>=(dPFecIni) .AND. dFecha<=(dDUtilInic) .AND. (dBaixa)<=(dDUtilInic)  // F3_ENTRADA
								klin := cCodLibr+"&"+SubStr(DTOS(dPFecIni),1,6)+"00&"+AllTrim(cSegofi)+"&"+cContAux			
							ElseIF (dBaixa)>(dDUtilInic) .AND. dFecha>(dDUtilInic) .AND. dFecha<=(dDUtilFin) .AND. (dBaixa)<=(dPFecFin) .AND. (dFechsf3)>(dPFecIni-31) .AND. (dFechsf3)<=(dPFecFin)
								klin := cCodLibr+"&"+SubStr(DTOS(dPFecIni),1,6)+"00&"+AllTrim(cSegofi)+"&"+cContAux			
							ElseIF dFecha>(dDUtilInic) .AND. dFecha<=(dDUtilFin) .AND. (dFechsf3)>(dPFecIni-31) .AND. (dFechsf3)<(dPFecIni) .AND. (dBaixa)>(dDUtilInic) .AND. (dBaixa)<=(dPFecFin)
								klin := cCodLibr+"&"+SubStr(DTOS(dPFecIni),1,6)+"00&"+AllTrim(cSegofi)+"&"+cContAux			
							ElseIF dFecha>(dDUtilInic) .AND. dFecha<=(dDUtilFin) .AND. (dFechsf3)>(dPFecIni-31) .AND. (dFechsf3)<(dPFecIni) .AND. (dBaixa)>=(dPFecIni) .AND. (dBaixa)<=(dPFecFin)
								klin := cCodLibr+"&"+SubStr(DTOS(dPFecIni),1,6)+"00&"+AllTrim(cSegofi)+"&"+cContAux			
							Else	
								klin := ""
							EndIf   
						ElseIf (dBaixa)<(dPFecIni) .AND. dFecha>=(dPFecIni) .AND. dFecha<=(dPFecFin) .AND. (dFechsf3)<(dPFecIni-31)								
							klin := cCodLibr+"&"+SubStr(DTOS(dPFecIni),1,6)+"00&"+AllTrim(cSegofi)+"&"+cContAux			
						ElseIf dFecha>=(dPFecIni) .AND. dFecha<=(dPFecFin) .AND. (dFechsf3)>=(dPFecIni) .AND. (dFechsf3)<=(dPFecFin)							
							klin := cCodLibr+"&"+SubStr(DTOS(dPFecIni),1,6)+"00&"+AllTrim(cSegofi)+"&"+cContAux			
						ElseIf (dBaixa)<(dPFecIni) .AND. dFecha<=(dDUtilInic)
							klin := ""
						Else               
							klin := ""
						Endif
					Endif     
				EndIf
			Endif
		EndIf
	ElseIf cMovtip="C" .And. cEspecie="NF" .And. cDctb<>"08"
		klin := ""
	ElseIf ALLTRIM(cF1doc)==ALLTRIM(cDocX) .And. cDctb="14" .And. cMovtip="C"
		klin := ""
	Else
		klin += cCodLibr+"&"+SubStr(DTOS(dPFecIni),1,6)+"00&"+AllTrim(cSegofi)+"&"+cContAux			
	EndIf
	
	restArea(harea)

Return(klin)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PERXFIS   ºAutor  ³Microsiga           ºFecha ³  12/16/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PuxaSer2( _cSerOri )

	Local __lTem := .f.
	Local __cSerieNf := _cSerOri
	local _vArea := getArea()
				
	SFP->( dbSetOrder(5) )	//FP_FILIAL, FP_FILUSO, FP_SERIE, FP_ESPECIE, R_E_C_N_O_, D_E_L_E_T_
	If SFP->( dbSeek( xFilial("SFP")+cFilAnt+_cSerOri+"1" ) )
		If !Empty(SFP->FP_SERIE2)
			__cSerieNf := Alltrim(SFP->FP_SERIE2)
		else
			__cSerieNf := Alltrim(SFP->FP_YSERIE)
		EndIf
		__lTem := .t.
	EndIf

	If !__lTem
		If SFP->( dbSeek( xFilial("SFP")+cFilAnt+_cSerOri+"2" ) )
			If !Empty(SFP->FP_SERIE2)
				__cSerieNf := Alltrim(SFP->FP_SERIE2)
			else
				__cSerieNf := Alltrim(SFP->FP_YSERIE)
			EndIf
			__lTem := .t.
		EndIf
	EndIf
				
	If !__lTem
		If SFP->( dbSeek( xFilial("SFP")+cFilAnt+_cSerOri+"3" ) )
			If !Empty(SFP->FP_SERIE2)
				__cSerieNf := Alltrim(SFP->FP_SERIE2)
			else
				__cSerieNf := Alltrim(SFP->FP_YSERIE)
			EndIf
			__lTem := .t.
		EndIf
	EndIf

	If !__lTem
		If SFP->( dbSeek( xFilial("SFP")+cFilAnt+_cSerOri+"6" ) )
			If !Empty(SFP->FP_SERIE2)
				__cSerieNf := Alltrim(SFP->FP_SERIE2)
			else
				__cSerieNf := Alltrim(SFP->FP_YSERIE)
			EndIf
			__lTem := .t.
		EndIf
	EndIf

	If Len(__cSerieNf)<=3
		__cSerieNf := Replicate("0",4-Len(_cSerOri))+_cSerOri
	EndIf
	
	restArea(_vArea)

Return( __cSerieNf )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PERXFIS   ºAutor  ³Microsiga           ºFecha ³  12/16/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DetIGVFn(cCodFor,cLojaFor,dDataIni,dDataFim)
Local aArea	:= GetArea()
Local cQry	:= GetNextAlias()
Local aRet	:= {}

	BeginSql Alias cQry
		SELECT
			SE5.E5_PREFIXO PREFIXO,
			SE5.E5_NUMERO NUMERO,
			SE5.E5_DATA DTMOV,
			SE5.E5_VALOR VALOR,   
			SE5.E5_PARCELA PARCELA,
			SEK.EK_PREFIXO PRFPAGO,
			SEK.EK_NUM NUMPAGO,
			SEK.EK_PARCELA,
			SEK.EK_TIPO TIPO,
			SEK.EK_VALOR VALPAGO
		
		FROM
			%Table:SE5% SE5 LEFT JOIN %Table:SEK% SEK ON SE5.E5_ORDREC = SEK.EK_ORDPAGO  AND SEK.EK_FILIAL = %Exp:xFilial('SEK')% AND      
			SEK.EK_TIPO = %Exp:'TX'% AND	SEK.%NotDel% 
		
		WHERE
			SE5.E5_FILIAL = %Exp:xFilial('SE5')% AND
			SE5.E5_TIPO = %Exp:'TX'% AND
			SE5.E5_DATA BETWEEN %Exp:DtoS(dDataIni)% AND %Exp:DtoS(dDataFim)% AND
			SE5.E5_CLIFOR = %Exp:cCodFor% AND
			SE5.E5_LOJA = %Exp:cLojaFor% AND
			SE5.%NotDel%

		ORDER BY 
			SE5.E5_PREFIXO,SE5.E5_NUMERO,SE5.E5_DATA
	EndSql
	
	(cQry)->(dbGoTop())

	While !(cQry)->(Eof())
		aAdd(aRet,{(cQry)->PREFIXO,(cQry)->NUMERO,(cQry)->DTMOV,(cQry)->VALOR, (cQry)->PARCELA ,{(cQry)->PRFPAGO,(cQry)->NUMPAGO,(cQry)->PARCELA,(cQry)->TIPO,(cQry)->VALPAGO}})
		(cQry)->(dbSkip())
	EndDo
	
	(cQry)->(dbCloseArea())

RestArea(aArea)
Return aRet
