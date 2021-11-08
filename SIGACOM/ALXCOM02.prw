#Include "Rwmake.ch"
#Include "Protheus.ch"
#include "fileio.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALXCOM02  ºAutor  ³Percy Arias,SISTHEL º Data ³  03/27/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importa itens del archivo Excel para el PC                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ALXCOM02()

	Local _aArea	:= getArea()
	Local aPergs    := {}
	Private aResps  := {}
 
    aAdd(aPergs,{6,"Archivo: ",Space(150),"",'.T.','.T.',80,.F.,"archivos (*.csv) |*.csv"})
	//aAdd(aPergs,{2,"Valida Proveedor",1,{"Si","No"}, 50,'.T.',.T.})

	If ParamBox(aPergs,"Parâmetros", @aResps)
    	Processa({|| ProcMovs()})
	EndIf            
		
	Restarea(_aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALXCOM02  ºAutor  ³Microsiga           º Data ³  03/27/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ProcMovs()
	
    local _cFile	:= AllTrim(aResps[1])
    local _aData	:= xLeArqTxt(_cFile) 
    local nPosProd	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_PRODUTO" })
    local nPosQtde	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_QUANT" })
    local nPosPrec	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_PRECO" })
    local nPosTota	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_TOTAL" })
    local nPoscTES	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_TES" })
    local nPosItem	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_ITEM" })
	local nZ        := len(aCols)
	local nUsado    := len(aHeader)
	local alColsAux	:= {}
	local nX		:= 0
	local nW		:= 0
	local nl		:= 0

   	ProcRegua(len(_aData))

    for nl := 1 to len(_aData)

		IncProc( "Importando producto " + alltrim(_aData[nl][1]) )
		
		// ----------------- //
		// validar proveedor //
		// ----------------- //
		/*
		if aResps[2]==1
			SA5->( dbSetOrder(2) )
			if SA5->( dbSeek( xFilial("SA5")+CA120FORN ) )
			endif
		endif
		*/
		
		alColsAux := {}
		for nX := 1 to nZ
			if ( .not. empty( aCols[nX][nPosProd] ) )
				AADD(alColsAux, aClone(aCols[nX]) )
			endif
		next nX
		
		aCols := {}
		if ( len(alColsAux) > 0 )
			aCols := aClone( alColsAux )
		endif
		
		nZ := len(aCols)
		if ( nZ == 0 )
			cItem := "0000"
		else
			cItem := aCols[nZ,nPosItem]
		endif
		
		cItem := Soma1(cItem)
		AADD(aCols, Array( nUsado + 1 ) )
	
		nZ++
		N := nZ
	    
		for nW := 1 to nUsado
			if (aHeader[nW,2] <> "C7_REC_WT") .And. (aHeader[nW,2] <> "C7_ALI_WT")
				//aCols[nZ,nW] := CriaVar(aHeader[nW,2],.T.)
				aCols[nZ,nW] := CriaVar(aHeader[nW,2])
			endif
			if aHeader[nW,2] == "C7_REC_WT"
				aCols[nZ,nW] := 0
			endif
		next nW
	
		aCols[nZ,nUsado+1] := .F.
		aCols[nZ,nPosItem] := cItem
		aCols[nZ,nPosProd] := u_FINDPRD(_aData[nl][1],CA120FORN)
		
		U_EnterCpo("C7_PRODUTO",aCols[nZ][nPosProd], nZ)

		aCols[nZ,nPosQtde] := val(_aData[nl][3])
		
		U_EnterCpo("C7_QUANT",aCols[nZ][nPosQtde], nZ)
		
		aCols[nZ,nPosPrec] := val(_aData[nl][4])
		
		U_EnterCpo("C7_PRECO",aCols[nZ][nPosPrec], nZ)
		
		//aCols[nZ,nPosTota] := _aData[nl][5]
		//aCols[nZ,nPoscTES] := Alltrim(_aData[nl][6])

		Eval(bRefresh)
		Eval(bGDRefresh)
					
    next nl
    
	//Eval(bRefresh)
	//Eval(bGDRefresh)
	//Eval(bListRefresh)
		
	//A120REFRESH(@AVALORES)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALXCOM02  ºAutor  ³Microsiga           º Data ³  03/27/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xLeArqTxt( cNomArchivo )

	Local cLinha := ""
	Local nX := 1
	Local _aItens := {}
	Local _aDetalle := {}

	FT_FUSE( cNomArchivo )
	   
	While !FT_FEOF()
	
		if nX>=3
		
			cLinha := Alltrim( FT_FREADLN() )
			
			if len(cLinha) > 5
				
				cLinha := replace( cLinha,",",";")
				_aItens := StrTokArr( cLinha, ";" )
				Aadd( _aDetalle, _aItens )
				
			endif
			
		endif
		
		FT_FSKIP()
		nX++
	 
	EndDo
	
	FT_FUSE() 

Return( _aDetalle )
