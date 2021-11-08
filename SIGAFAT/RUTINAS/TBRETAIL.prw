#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TBRETAIL  ºAutor  ³Percy Arias,SISTHEL º Data ³  08/30/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Lista de precios retail, especifico                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TBRETAIL()

	local xArea		:= getArea()
	local lTem		:= .f.
	local cCodePrd	:= M->C6_PRODUTO
	local cCodeCli	:= M->C5_CLIENTE
	local nlPPUnit	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRUNIT" })
	local nlPPVend	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRCVEN" })
	local nlPrecio	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_YPRECIO" })
	local nlProdto	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO" })
	local nRetPrc	:= 0
	
	local cTipoCliPA	:= "1"
	local cTipoCliMP	:= "1"
	local cGrpCLiente	:= ""

	//if !empty(cCodePrd)
		cCodePrd := aCols[n][nlProdto]
		//M->C6_PRODUTO := cCodePrd
	//endif
	
	if Left(alltrim(cCodePrd),3)<>"ALR"
		
		if !empty(cCodeCli)
	
			SA1->( dbSetOrder(1) )
			if SA1->( MsSeek( xFilial("SA1")+cCodeCli ) )
			
				cTipoCliPA	:= SA1->A1_YTIPDES
				cTipoCliMP	:= SA1->A1_YTDSCMP
				cGrpCLiente := SA1->A1_GRPVEN
				
			endif
			
		endif
			
		if !empty(cCodePrd)
		
			ZZ6->( dbSetOrder(1) )
			If ZZ6->( dbSeek( xFilial("ZZ6")+cCodePrd ) )
				
				While ( xFilial("ZZ6")+aCols[n][nlProdto] ) == ZZ6->( xFilial("ZZ6")+ZZ6->ZZ6_PRODUC ) .AND. ZZ6->( !Eof() )
					
					if M->C5_EMISSAO>=ZZ6->ZZ6_INICIO .And. empty(ZZ6->ZZ6_FIM)
							
						nRetPrc := ZZ6->ZZ6_PRC001
				
						if cTipoCliMP=="2"
							nRetPrc := ZZ6->ZZ6_PRC002
						elseif cTipoCliMP=="3"
							nRetPrc := ZZ6->ZZ6_PRC003
						elseif cTipoCliMP=="4"
							nRetPrc := ZZ6->ZZ6_PRC004
						elseif cTipoCliMP=="5"       
							nRetPrc := ZZ6->ZZ6_PRC005
						elseif cTipoCliMP=="6"
							nRetPrc := ZZ6->ZZ6_PRC006
						elseif cTipoCliMP=="7"
							nRetPrc := ZZ6->ZZ6_PRC007
						elseif cTipoCliMP=="8"
							nRetPrc := ZZ6->ZZ6_PRC008
						elseif cTipoCliMP=="9"
							nRetPrc := ZZ6->ZZ6_PRC009
						elseif cTipoCliMP=="A"
							nRetPrc := ZZ6->ZZ6_PRC010
						elseif cTipoCliMP=="B"
							nRetPrc := ZZ6->ZZ6_PRC011
						elseif cTipoCliMP=="C"
							nRetPrc := ZZ6->ZZ6_PRC012
						elseif cTipoCliMP=="D"
							nRetPrc := ZZ6->ZZ6_PRC013
						endif
							
					endif
							
					ZZ6->( dbSkip() )
						
				End
					
			endif
			
			if nRetPrc <= 0
			
				if SB1->( dbSeek( xFilial("SB1")+cCodePrd ) )
					nRetPrc := SB1->B1_PRV1
				endif
			
			endif
			
			aCols[n][nlPPUnit] := Round(nRetPrc,4)
			aCols[n][nlPPVend] := Round(nRetPrc,4)
			aCols[n][nlPrecio] := Round(nRetPrc,4)

			A410MultT()
			a410Refr("C6_QTDVEN")			
			//if ExistTrigger("C6_PRUNIT")
			//	RunTrigger(2,N,Nil,,"C6_PRUNIT")
			//endif
			
		endif
	
	endif
	
	RestArea( xArea )

Return(.T.)
