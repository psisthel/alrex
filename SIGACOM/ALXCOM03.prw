#Include "Rwmake.ch"
#Include "Protheus.ch"
#include "fileio.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALXCOM03  ºAutor  ³Percy Arias,SISTHEL º Data ³  03/27/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importa itens del archivo Excel para el PC de Importacion  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ALXCOM03()

	Local _aArea	:= getArea()
	Local aPergs    := {}
	Private aResps  := {}
 
    aAdd(aPergs,{6,"Archivo: ",Space(150),"",'.T.','.T.',80,.F.,"archivos (*.csv) |*.csv"})

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
    local nPosProd	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C1_PRODUTO" })
    local nPosQtde	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C1_QUANT" })
    local nPosPrec	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C1_PRECO" })
    local nPosTota	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C1_TOTAL" })
    local nPosItem	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C1_ITEM" })
	local nZ        := len(aCols)
	local nUsado    := len(aHeader)
	local alColsAux	:= {}
	local nX		:= 0
	local nW		:= 0
	local nl		:= 0

   	ProcRegua(len(_aData))

    for nl := 1 to len(_aData)

		IncProc( "Importando producto " + alltrim(_aData[nl][1]) )
		
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
			if (aHeader[nW,2] <> "C1_REC_WT") .And. (aHeader[nW,2] <> "C1_ALI_WT")
				aCols[nZ,nW] := CriaVar(aHeader[nW,2])
			endif
			if aHeader[nW,2] == "C1_REC_WT"
				aCols[nZ,nW] := 0
			endif
		next nW
	
		aCols[nZ,nUsado+1] := .F.
		aCols[nZ,nPosItem] := cItem
		aCols[nZ,nPosProd] := u_FINDPRD(_aData[nl][1],"")
		
		U_EnterCpo("C1_PRODUTO",aCols[nZ][nPosProd], nZ)

		aCols[nZ,nPosQtde] := val(_aData[nl][3])
		
		U_EnterCpo("C1_QUANT",aCols[nZ][nPosQtde], nZ)
		
		aCols[nZ,nPosPrec] := val(_aData[nl][4])
		
		U_EnterCpo("C1_PRECO",aCols[nZ][nPosPrec], nZ)
		
		Eval(bRefresh)
		//Eval(bGDRefresh)
					
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
