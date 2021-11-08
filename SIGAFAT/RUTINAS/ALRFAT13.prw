#Include "Rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALRFAT13  ºAutor  ³Percy Arias,SISTHEL º Data ³  08/22/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Informar el Anticipo despues de liberado el PV             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ALRFAT13()

	Local _aArea	:= getArea()
	Local aPosObj   := {} 
	Local aObjects  := {}
	Local aSize     := MsAdvSize( .F. ) 
	Local aNoFields	:= {}
	Local nOpc		:= 4
	Local nPos		:= 1
	local olFont	:= TFont():New('Arial',,-16,.T.)

	// Private aHeader	:= {}
	// Private aCols	:= {}
	Private oGetD	:= Nil
	Private oDlg	:= Nil	

	aHeader	:= {}
	aCols	:= {}

	dbSelectArea("ZZW")

	aNoFields := {"ZZW_RECIBO","ZZW_PEDIDO","ZZW_STATUS","ZZW_CLIENT","ZZW_LOJA","ZZW_NOMCLI","ZZW_VALEFE","ZZW_DATAEF","ZZW_USUINC","ZZW_USUALT","ZZW_DATINC","ZZW_DATALT"}

	cQuery := "SELECT *"
	cQuery += "  FROM " + RetSQLName("ZZW")
	cQuery += " WHERE ZZW_FILIAL ='" + xFilial("ZZW") + "'" 
	cQuery += "   AND D_E_L_E_T_= ' '"
	cQuery += "   AND ZZW_PEDIDO='" + SC5->C5_NUM + "'"
		
	cSeek		:= xFilial("ZZW")+ZZW->ZZW_PEDIDO
	bWhile		:= {|| ZZW->ZZW_FILIAL+ZZW->ZZW_PEDIDO }

	If Len(aHeader) == 0 .AND. Len(aCols) == 0

		If !FillGetDados(	nOpc			,"ZZW"		   	,1				,cSeek			,;
	   		  				bWhile			,{|| .T. }		,aNoFields		,/*aYesFields*/	,; 
							/*lOnlyYes*/	,cQuery			,/*bMontCols*/	,/*lEmpty*/		,;
							/*aHeaderAux*/	,/*aColsAux*/	,/*bAfterCols*/	,/*bBeforeCols*/)
		Endif
		
	Endif

	nUsado := 0

	aCols[1][nUsado+1] := .F. 
	nPos := aScan(aHeader,{|x| AllTrim(x[2])=="ZZW_SEQ" })
	aCols[1][nPos] := "01"

	AAdd( aObjects, { 100, 32, .t., .F. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AADD( aObjects, { 100, 10, .T., .F. } )

	aInfo   := { aSize[ 1 ], 30, aSize[ 3 ], aSize[ 4 ]-150, 3, 2 } 
	aPosObj := MsObjSize( aInfo, aObjects ) 

	oDlg := TDialog():New(aSize[7],0,((aSize[6]/100)*98),((aSize[5]/100)*99),"Generar Anticipos",,,,,,,,oMainWnd,.T.)
			
	TSay():New( aPosObj[1,1]-25,aPosObj[1,2],{|| "Pedido : "+SC5->C5_NUM },oDlg,,olFont,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,300,020)
	TSay():New( aPosObj[1,1]-15,aPosObj[1,2],{|| "Cliente: "+SC5->C5_CLIENTE+" - "+SC5->C5_YNOMCLI },oDlg,,olFont,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,300,020)

	oGetd := MsGetDados():New(aPosObj[2,1]-35,aPosObj[2,2],aPosObj[2,3]+150,aPosObj[2,4],3,"AllwaysTrue()","AllwaysTrue()","+ZZW_SEQ",.T.,{"ZZW_TIPDOC","ZZW_DATA","ZZW_MOEDA","ZZW_VALOR","ZZW_BANCO","ZZW_AGEN","ZZW_CONTA","ZZW_DOC","ZZW_ALI_WT","ZZW_REC_WT"})
		
	olPanel := TPanel():New(aPosObj[1,1]-28,aPosObj[1,2]+100,'',oDlg,, .T., .T.,, ,(aPosObj[3,4]-110),012,.F.,.F. )
			
	olBtn1		 := TButton():New( 002, 002, "Confirmar", olPanel,{|| u_GravaZZW(),oDlg:End() }, 55,10,,,.F.,.T.,.F.,,.F.,,,.F. ) // "Ok"
	olBtn1:Align := CONTROL_ALIGN_RIGHT
				
	olSplitter1 := TSplitter():New( 01,01,olPanel,005,01 )
	olSplitter1:Align := CONTROL_ALIGN_RIGHT
					
	olSplitter2	:= TSplitter():New( 01,01,olPanel,005,01 )
	olSplitter1:Align := CONTROL_ALIGN_RIGHT

	Activate MSDialog oDlg Centered

	restArea(_aArea)
	
Return
