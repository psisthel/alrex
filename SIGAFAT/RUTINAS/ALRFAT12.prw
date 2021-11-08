#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALRFAT12  ºAutor  ³Microsiga           º Data ³  08/05/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Listas de Precios Especificas                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ALRFAT12()

	Local aCores	:=	{	{ 'ZZ4->ZZ4_ACTIVO=="S"' , 'ENABLE'		},;
							{ 'ZZ4->ZZ4_ACTIVO=="N"',  'DISABLE'	}}
							
	Local aIndex	:= {} 
	Local cFiltro	:= ""

	Private cCadastro 	:= "Tablas de Precios" 
	Private aRotina 	:= MenuDef()
	Private bFiltraBrw	:= { || FilBrowse( "ZZ4" , @aIndex , @cFiltro ) } 
	Private nNroTela	:= 1
	
	Define font oFont Name "Arial" SIZE 16,20
		
	Eval( bFiltraBrw )

	dbSelectArea("ZZ5")
	dbSetOrder(1)

	dbSelectArea("ZZ4")
	dbSetOrder(1)

	mBrowse( 6, 1,22,75,"ZZ4",,,,,,aCores)

	dbSelectArea("ZZ4")
	dbSetOrder(1)
	
	EndFilBrw( "ZZ4" , @aIndex ) //Finaliza o Filtro 
	
	Set Key VK_F12 To
	
	//-------------------------------------------------
	
Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALRFAT12  ºAutor  ³Microsiga           º Data ³  08/05/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MenuDef()

	aRotina := {}
	
	AADD(aRotina, {"Pesquisar"		, "AxPesqui",0,1})
	AADD(aRotina, {"Visualizar"		, "u_MANLTPRC",0,2})
	AADD(aRotina, {"Importar"		, "u_IMPORTAR",0,6})
	AADD(aRotina, {"Incluir"		, "u_MANLTPRC",0,3})
	AADD(aRotina, {"Modificar"		, "u_MANLTPRC",0,4})
	AADD(aRotina, {"Borrar"			, "u_MANLTPRC",0,5})
	
Return(aRotina)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALRFAT12  ºAutor  ³Microsiga           º Data ³  08/05/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MANLTPRC(cAlias,nOpc,nOpx)

	Local _ni
	
	//+--------------------------------------------------------------+
	//| Opcoes de acesso para a Modelo 3                             |
	//+--------------------------------------------------------------+
	
	//cOpcao:="INCLUIR"
	
	nOpcE:=nOpx
	nOpcG:=nOpx
	
	//DbSelectArea("ZZ4")
	//DbSetOrder(1)
	//DbGotop()
	
	//+--------------------------------------------------------------+
	//| Cria variaveis M->????? da Enchoice                          |
	//+--------------------------------------------------------------+
	//RegToMemory("ZZ4",(cOpcao=="INCLUIR"))
	RegToMemory("ZZ4")
	
	//+--------------------------------------------------------------+
	//| Cria aHeader e aCols da GetDados                             |
	//+--------------------------------------------------------------+
	nUsado:=0
	
	dbSelectArea("SX3")
	DbSetOrder(1)
	DbSeek("ZZ5")
	
	aHeader:={}
	
	While !Eof().And.(x3_arquivo=="ZZ5")	
		If Alltrim(x3_campo)=="ZZ5_COD"		
			dbSkip()		
			Loop	
		Endif	
		If X3USO(x3_usado).And.cNivel>=x3_nivel    
			nUsado:=nUsado+1        
			Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;	         
							x3_tamanho, x3_decimal,"AllwaysTrue()",;    	     
							x3_usado, x3_tipo, x3_arquivo, x3_context } )	
		Endif    
		dbSkip()
	End
	
	If nOpx==4
		
		cTitulo:="Listas de Precios - [Incluir]"
		
		M->ZZ4_COD := GETSXENUM("ZZ4","ZZ4_COD")
		M->ZZ4_DESC := Space(tamSX3("ZZ4_DESC")[1])
		M->ZZ4_DTINI := dDataBase
		
		aCols:={Array(nUsado+1)}	
		aCols[1,nUsado+1]:=.F.	
		
		For _ni:=1 to nUsado		
			aCols[1,_ni]:=CriaVar(aHeader[_ni,2])	
		Next
	Else
	
		M->ZZ4_COD := ZZ4->ZZ4_COD
	
		if nOpx==5
			cTitulo:="Listas de Precios - [Modificar]"	
		elseif nOpx==6
			cTitulo:="Listas de Precios - [Borrar]"
		else
			cTitulo:="Listas de Precios - [Visualizar]"
		endif
		
		aCols:={}	
		dbSelectArea("ZZ5")	
		dbSetOrder(1)	
		dbSeek(xFilial()+M->ZZ4_COD)	
		While !eof().and. ZZ5->ZZ5_COD == M->ZZ4_COD		
			AADD(aCols,Array(nUsado+1))		
			For _ni:=1 to nUsado			
				aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))		
			Next 		
			aCols[Len(aCols),nUsado+1]:=.F.		
			dbSkip()	
		End
	Endif
	
	If Len(aCols)>0	
		//+--------------------------------------------------------------+	
		//| Executa a Modelo 3                                           |	
		//+--------------------------------------------------------------+	
		cAliasEnchoice:="ZZ4"	
		cAliasGetD:="ZZ5"	
		cLinOk:="AllwaysTrue()"	
		cTudOk:="AllwaysTrue()"	
		cFieldOk:="AllwaysTrue()"
		
		//aCpoEnchoice:={} 
		//{"C5_CLIENTE"}	
		_lRet:=Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk)	
		
		//+--------------------------------------------------------------+	
		//| Executar processamento                                       |	
		//+--------------------------------------------------------------+	
		If _lRet

			If nOpx==4 .Or. nOpx==5

				DbSelectArea("ZZ4")
				DbSetOrder(1)
				
				DbSelectArea("ZZ5")
				DbSetOrder(1)
				
				if nOpx==4
				    ZZ4->( Reclock("ZZ4",.T.) )
				    ZZ4->ZZ4_FILIAL	:= xFilial("ZZ4")
				    ZZ4->ZZ4_COD	:= M->ZZ4_COD
				else
					ZZ4->( Reclock("ZZ4",.F.) )
				endif
			    ZZ4->ZZ4_DESC	:= M->ZZ4_DESC
			    ZZ4->ZZ4_DTINI	:= M->ZZ4_DTINI
			    ZZ4->ZZ4_DTFIN	:= M->ZZ4_DTFIN
			    ZZ4->ZZ4_MONEDA	:= M->ZZ4_MONEDA
			    ZZ4->ZZ4_ACTIVO	:= M->ZZ4_ACTIVO
			 	ZZ4->( MsUnlock() )
			 	
			 	if nOpx==5
			 		If ZZ5->( dbSeek( xFilial("ZZ5")+M->ZZ4_COD ) )
			 			While M->ZZ4_COD==ZZ5->ZZ5_COD .And. ZZ5->( !Eof() )
			 				ZZ5->( Reclock("ZZ5",.F.) )
			 				ZZ5->( dbdelete() )
			 				ZZ5->( MsUnlock() )
			 				ZZ5->( dbSkip() )
			 			End
			 		endif
			 	endif
				
				For nX := 1 to Len(aCols)
					if .not. aCols[nX][4]
					    ZZ5->( Reclock("ZZ5",.T.) )
					    ZZ5->ZZ5_FILIAL	:= xFilial("ZZ5")
					    ZZ5->ZZ5_COD		:= M->ZZ4_COD
					    ZZ5->ZZ5_SEQ		:= aCols[nX][1]
					    ZZ5->ZZ5_PROD		:= aCols[nX][2]
				    	ZZ5->ZZ5_PRCLST		:= aCols[nX][3]
					    ZZ5->( MsUnlock() )
					endif
				Next nX
				
			Elseif nOpx==6

				If ZZ4->( dbSeek( xFilial("ZZ4")+M->ZZ4_COD ) )
					ZZ4->( Reclock("ZZ4",.F.) )
					ZZ4->( dbdelete() )
					ZZ4->( MsUnlock() )

			 		If ZZ5->( dbSeek( xFilial("ZZ5")+M->ZZ4_COD ) )
			 			While M->ZZ4_COD==ZZ5->ZZ5_COD .And. ZZ5->( !Eof() )
			 				ZZ5->( Reclock("ZZ5",.F.) )
			 				ZZ5->( dbdelete() )
			 				ZZ5->( MsUnlock() )
			 				ZZ5->( dbSkip() )
			 			End
				 	endif
	
				endif
				
		
		EndIf
			
		Endif
	Endif                 

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALRFAT12  ºAutor  ³Microsiga           º Data ³  08/05/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IMPORTAR

	Local _aArea	:= getArea()
	Local aPergs    := {}
	Private aResps  := {}
 
    aAdd(aPergs,{6,"Archivo: ",Space(150),"",'.T.','.T.',80,.F.,"archivos (*.csv) |*.csv"})

	If ParamBox(aPergs,"Parâmetros", @aResps)
    	Processa({|| ProcListas()})
	EndIf            
		
	Restarea(_aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALRFAT12  ºAutor  ³Microsiga           º Data ³  08/05/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ProcListas()
	
    local _cFile	:= AllTrim(aResps[1])
    local _aData	:= xLeArqTxt(_cFile) 
	local nl		:= 0

	_xHeader := _aData[1]
	_xCabece := _aData[2]
	
	if len(_xHeader)>0 .and. len(_xCabece)>0
	
	   	ProcRegua(len(_xHeader))
	
	    for nl := 1 to len(_xHeader)
	
			IncProc( "Importando lista de precios " + alltrim(_xHeader[nl][1]) )
			
			if ZZ4->( dbSeek( xFilial("ZZ4")+alltrim(_xHeader[nl][1]) ) )
				Alert("Tabla con codigo " + _xHeader[nl][1] + " ya esta registrada!")
				Return
			endif
			
		    ZZ4->( Reclock("ZZ4",.T.) )
		    ZZ4->ZZ4_FILIAL	:= xFilial("ZZ4")
		    ZZ4->ZZ4_COD	:= alltrim(_xHeader[nl][1])
		    ZZ4->ZZ4_DESC	:= alltrim(_xHeader[nl][2])
		    ZZ4->ZZ4_DTINI	:= ctod(alltrim(_xHeader[nl][3]))
		    if alltrim(_xHeader[nl][4])<>"-"
			    ZZ4->ZZ4_DTFIN	:= ctod(alltrim(_xHeader[nl][4]))
		   	endif
		    ZZ4->ZZ4_ACTIVO	:= alltrim(_xHeader[nl][5])
		    ZZ4->ZZ4_MONEDA	:= val(_xHeader[nl][6])
		 	ZZ4->( MsUnlock() )
		 	
		next
	
		ProcRegua(len(_xCabece))
		
	    for n2 := 1 to len(_xCabece)
	
			IncProc( "Importando lista de precios " + alltrim(_xCabece[n2][1]) )
			
			if SB1->( dbSeek( xFilial("SB1")+Padr(alltrim(_xCabece[n2][3]),TamSx3("B1_COD")[1]) ) )
				 	
			    ZZ5->( Reclock("ZZ5",.T.) )
			    ZZ5->ZZ5_FILIAL	:= xFilial("ZZ5")
			    ZZ5->ZZ5_COD		:= ZZ4->ZZ4_COD
			    ZZ5->ZZ5_SEQ		:= alltrim(_xCabece[n2][2])
			    ZZ5->ZZ5_PROD		:= alltrim(_xCabece[n2][3])
			    ZZ5->ZZ5_PRCLST	:= val(_xCabece[n2][4])
			    ZZ5->( MsUnlock() )
			
			endif
			
	    next n2
	    
	else
	
		Alert("Verifique e archivo, informaciones inconsistentes!")
	    
	endif
	    
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALRFAT12  ºAutor  ³Microsiga           º Data ³  08/05/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xLeArqTxt( cNomArchivo,xOp )

	Local cLinha := ""
	Local nX := 1
	Local _aCabec := {}
	Local _aItens := {}
	Local _aDetalle := {}
	Local _aHeader := {}

	FT_FUSE( cNomArchivo )
	   
	While !FT_FEOF()

		if nX>=3

			cLinha := Alltrim( FT_FREADLN() )
			cLinha := replace( cLinha,",",";")
			
			if nX==3 
				_aCabec := StrTokArr( cLinha, ";" )
				Aadd( _aHeader, _aCabec )
			else
				_aItens := StrTokArr( cLinha, ";" )
				Aadd( _aDetalle, _aItens )
			endif
		
		endif
		
		FT_FSKIP()
		nX++
	 
	EndDo
	
	FT_FUSE() 

Return( {_aHeader,_aDetalle} )
