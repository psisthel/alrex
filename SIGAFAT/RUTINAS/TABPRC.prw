#INCLUDE "rwmake.ch"

User Function TABPRC()

	local xArea		:= getArea()
	local lTem		:= .f.
	local nVlDesc	:= M->C5_DESC1
	local nDescItem := 0
	local cCodePrd	:= M->C6_PRODUTO
	local cCodeTab	:= M->C5_YTBPREC
	local nlPPUnit	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRUNIT" })
	local nlPPVend	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRCVEN" })
	local nlProdto	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO" })
	local oDlgPdr	:= GetWndDefault()

	if !empty(cCodePrd)
		aCols[n][nlProdto]	:= cCodePrd
		M->C6_PRODUTO := cCodePrd
	endif
	
	ZZ5->( dbSetOrder(3) )
	If ZZ5->( dbSeek( xFilial("ZZ5")+cCodeTab+aCols[n][nlProdto] ) )
	
		While ZZ5->( xFilial("ZZ5")+cCodeTab+aCols[n][nlProdto] ) == ZZ5->( xFilial("ZZ5")+ZZ5->ZZ5_COD+ZZ5->ZZ5_PROD ) .AND. ZZ5->( !Eof() )
		
			if ZZ4->ZZ4_ACTIVO=="S"
				
				if ZZ4->ZZ4_DTINI>=M->C5_EMISSAO .And. empty(ZZ4->ZZ4_DTFIN)
	
					lTem := .t.
					aCols[n][nlPPUnit]	:= SB1->B1_PRV1
					M->C6_PRUNIT := SB1->B1_PRV1
					aCols[n][nlPPVend]	:= ZZ4->ZZ4_PRCLST
					M->C6_PRCVEN := ZZ4->ZZ4_PRCLST
					U_EnterCpo("C6_PRCVEN",aCols[n][nlPPVend], n)
				
				endif
				
			endif
			
			ZZ4->( dbSkip() )
			
		End
		
	endif
	
	if !lTem
		aCols[n][nlPPUnit]	:= SB1->B1_PRV1
		M->C6_PRUNIT := SB1->B1_PRV1
		aCols[n][nlPPVend]	:= SB1->B1_PRV1
		M->C6_PRCVEN := SB1->B1_PRV1
	endif
	
	if nVlDesc>0
		nDescItem := (aCols[n][nlPPVend]*nVlDesc)/100
		M->C6_PRCVEN := (aCols[n][nlPPVend]-nDescItem)
		aCols[n][nlPPVend]	:= (aCols[n][nlPPVend]-nDescItem)
		U_EnterCpo("C6_PRCVEN",aCols[n][nlPPVend], n)
	endif
	
	oGetDad:ForceRefresh()
	Ma410Rodap(oGetDad)
	oDlgPdr:refresh()
	
	RestArea( xArea )

Return(.t.)
