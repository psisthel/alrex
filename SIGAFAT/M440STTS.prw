#Include "Rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M440STTS  ºAutor  ³Percy Arias,SISTHEL º Data ³  09/12/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Liberacion del pedido de venta                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M440STTS

	Local _aArea	:= getArea()
	Local lRet		:= .t.
	//Local _cPerg	:= PADR("XDOCRA",10)
	local alIDs		:= {}
	Local aPosObj   := {} 
	Local aObjects  := {}
	Local aSize     := MsAdvSize( .F. ) 
	Local aNoFields	:= {}
	Local nOpc		:= 3
	Local nPos		:= 1
	local olFont	:= TFont():New('Arial',,-16,.T.)

	// Private aHeader	:= {}
	// Private aCols	:= {}
	Private oGetD	:= Nil
	Private oDlg	:= Nil	

	SC6->( dbSetOrder(1) )
	SC6->( MsSeek( xFilial("SC6")+SC5->C5_NUM ) )

	SC2->( dbSetOrder( 2 ) ) // C2_FILIAL, C2_PRODUTO, C2_DATPRF
	if SC2->( dbSeek( xFilial("SC2") + SC6->C6_PRODUTO ) )
		//if SC2->C2_QUJE>0
			alert("Pedido ya fue liberado, para poder hacer una nueva liberacion, anule la liberación del pedido y liberelo nuevamente!")
			lRet := .f.
		//else
		//	SC2->( delete() )
		//endif
	endif
	
	if lRet

		SC6->( dbSetOrder(1) )
		SC6->( MsSeek( xFilial("SC6")+SC5->C5_NUM ) )

		SC2->( dbSetOrder( 2 ) ) // C2_FILIAL, C2_PRODUTO, C2_DATPRF
		SC2->( MsSeek( xFilial("SC2") + SC6->C6_PRODUTO ) )
	
		while ( .not. SC6->( eof() ) .and. SC6->C6_FILIAL == xFilial( "SC6" ) .and. SC6->C6_NUM = SC5->C5_NUM )
			AADD( alIDs, SC6->C6_XIDZZF )
			SC6->( dbSkip() )
		endDo
		
		U_ALR00001(6, alIDs)
		U_ALR00001(2, Nil)

		u_ChangeLC(SC5->C5_CLIENTE,SC5->C5_LOJACLI,SC5->C5_CONDPAG,2)

		// -----------------------------------------------------------------------------

		if SC5->C5_YTIPOPG=="EF"
		
			aHeader	:= {}
			aCols	:= {}

			dbSelectArea("ZZW")

			aNoFields := {"ZZW_RECIBO","ZZW_PEDIDO","ZZW_STATUS","ZZW_CLIENT","ZZW_LOJA","ZZW_NOMCLI","ZZW_VALEFE","ZZW_DATAEF","ZZW_USUINC","ZZW_USUALT","ZZW_DATINC","ZZW_DATALT"}
			
			If Len(aHeader) == 0 .AND. Len(aCols) == 0
				FillGetDados(	nOpc			,"ZZW"			,1				,/*cSeek*/		,;
								/*{||cWhile}*/	,{|| .T. }		,aNoFields		,/*aYesFields*/	,; 
								/*lOnlyYes*/	,/*cQuery*/		,/*bMontCols*/	,.T.			,;
								/*aHeaderAux*/	,/*aColsAux*/	,/*bAfterCols*/	,/*bBeforeCols*/)
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

			//DEFINE MSDIALOG oDlg TITLE "Generar Adelantos" FROM aSize[7]+170,20 TO aSize[6]-120,aSize[5] PIXEL // linha, columna

			oDlg := TDialog():New(aSize[7],0,((aSize[6]/100)*98),((aSize[5]/100)*99),"Generar Anticipos",,,,,,,,oMainWnd,.T.)
			
			TSay():New( aPosObj[1,1]-25,aPosObj[1,2],{|| "Pedido : "+SC5->C5_NUM },oDlg,,olFont,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,300,020)
			TSay():New( aPosObj[1,1]-15,aPosObj[1,2],{|| "Cliente: "+SC5->C5_CLIENTE+" - "+SC5->C5_YNOMCLI },oDlg,,olFont,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,300,020)
			//oGetd := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"","","+ZZW_SEQ",.T.,{"ZZW_TIPDOC","ZZW_BANCO","ZZW_DOC","ZZW_VALOR"})
			oGetd := MsGetDados():New(aPosObj[2,1]-35,aPosObj[2,2],aPosObj[2,3]+150,aPosObj[2,4],3,"AllwaysTrue()","AllwaysTrue()","+ZZW_SEQ",.T.,{"ZZW_TIPDOC","ZZW_DATA","ZZW_MOEDA","ZZW_VALOR","ZZW_BANCO","ZZW_AGEN","ZZW_CONTA","ZZW_DOC","ZZW_ALI_WT","ZZW_REC_WT"})
		
			//ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,If(oGetd:TudoOk(),oDlg:End(),nOpcA:=0)},{||oDlg:End()}) Centered

			olPanel := TPanel():New(aPosObj[1,1]-28,aPosObj[1,2]+100,'',oDlg,, .T., .T.,, ,(aPosObj[3,4]-110),012,.F.,.F. )
			
			olBtn1		 := TButton():New( 002, 002, "Confirmar", olPanel,{|| u_GravaZZW(),oDlg:End() }, 55,10,,,.F.,.T.,.F.,,.F.,,,.F. ) // "Ok"
			olBtn1:Align := CONTROL_ALIGN_RIGHT
				
			olSplitter1 := TSplitter():New( 01,01,olPanel,005,01 )
			olSplitter1:Align := CONTROL_ALIGN_RIGHT
					
			// oBtn2		:= TButton():New( 002, 002, "Salir",olPanel,{|| oDlg:End() }, 55,10,,,.F.,.T.,.F.,,.F.,,,.F. ) // "Retornar"
			// oBtn2:Align	:= CONTROL_ALIGN_RIGHT

			olSplitter2	:= TSplitter():New( 01,01,olPanel,005,01 )
			olSplitter1:Align := CONTROL_ALIGN_RIGHT

			// oBtn3		:= TButton():New( 002, 002, "Entregar",olPanel,{|| llRet := fEntrega(apDatos[olChkLst:nAt][10]), oDlg:End() }, 55,10,,,.F.,.T.,.F.,,.F.,,,.F. ) // "Retornar"
			// oBtn3:Align	:= CONTROL_ALIGN_RIGHT

			Activate MSDialog oDlg Centered

		endif

	Endif

	RestArea( _aArea )

Return

User Function GravaZZW()

	local lRet := .t.
	local _ni := 1
	local nPosSeq := aScan(aHeader,{|x| AllTrim(x[2])=="ZZW_SEQ" })
	local nPosTip := aScan(aHeader,{|x| AllTrim(x[2])=="ZZW_TIPDOC" })
	local nPosBco := aScan(aHeader,{|x| AllTrim(x[2])=="ZZW_BANCO" })
	local nPosAge := aScan(aHeader,{|x| AllTrim(x[2])=="ZZW_AGEN" })
	local nPosCon := aScan(aHeader,{|x| AllTrim(x[2])=="ZZW_CONTA" })
	local nPosMoe := aScan(aHeader,{|x| AllTrim(x[2])=="ZZW_MOEDA" })
	local nPosDoc := aScan(aHeader,{|x| AllTrim(x[2])=="ZZW_DOC" })
	local nPosDat := aScan(aHeader,{|x| AllTrim(x[2])=="ZZW_DATA" })
	local nPosVal := aScan(aHeader,{|x| AllTrim(x[2])=="ZZW_VALOR" })
	local nUsado := Len(aHeader)

	ZZW->( dbSetOrder(5) )

	For _ni := 1 to len(aCols)

		if !empty(aCols[_ni][nPosBco]) .and. aCols[_ni][nPosVal]>0

			if !aCols[_ni][nUsado+1]

				If ZZW->( MsSeek( xFilial("ZZW")+SC5->C5_NUM+aCols[_ni][nPosSeq] ) )
					ZZW->( RecLock("ZZW",.f.) )
					ZZW->ZZW_USUALT	:= Upper(cUserName)
					ZZW->ZZW_DATALT	:= dDatabase
				Else
					ZZW->( RecLock("ZZW",.t.) )
					ZZW->ZZW_SEQ := aCols[_ni][nPosSeq]
					ZZW->ZZW_USUINC	:= Upper(cUserName)
					ZZW->ZZW_DATINC	:= dDatabase
				Endif

				ZZW->ZZW_CLIENT	:= SC5->C5_CLIENTE
				ZZW->ZZW_LOJA	:= SC5->C5_LOJACLI
				ZZW->ZZW_NOMCLI	:= SC5->C5_YNOMCLI
				ZZW->ZZW_PEDIDO	:= SC5->C5_NUM
				ZZW->ZZW_TIPDOC	:= aCols[_ni][nPosTip]
				ZZW->ZZW_BANCO	:= aCols[_ni][nPosBco]
				ZZW->ZZW_AGEN	:= aCols[_ni][nPosAge]
				ZZW->ZZW_CONTA	:= aCols[_ni][nPosCon]
				ZZW->ZZW_MOEDA	:= aCols[_ni][nPosMoe]
				ZZW->ZZW_DOC	:= aCols[_ni][nPosDoc]
				ZZW->ZZW_DATA	:= aCols[_ni][nPosDat]
				ZZW->ZZW_VALOR	:= aCols[_ni][nPosVal]
				ZZW->ZZW_STATUS	:= "0"
				ZZW->( MsUnlock() )

			else

				If ZZW->( MsSeek( xFilial("ZZW")+SC5->C5_NUM+aCols[_ni][nPosSeq] ) )
					ZZW->( RecLock("ZZW",.f.) )
					ZZW->( DBDelete() )
					ZZW->( MsUnlock() )
				endif

			endif
		
		endif

	Next

Return(lRet)

