#include "protheus.ch"
#INCLUDE "RWMAKE.CH"
#include "fileio.ch"
#define CRLF CHR(13)+CHR(10)

User Function VERLOG(nOp)

	local cArqLog := "\log\"+if(nOp==1,alltrim(SF1->F1_YLOG),alltrim(SF2->F2_YLOG))
	local oDlg
	local cTexto := ""
	local oMemo 
	local oBtnOk
	local nOpc := 0
	
	if nOp==1
		cOpcao := SF1->F1_YLOG
	else	
		cOpcao := SF2->F2_YLOG
	endif
	
	if !empty(cOpcao)

		FT_FUSE( cArqLog )
	   
		While !FT_FEOF()
		
			cTexto := cTexto + Alltrim( FT_FREADLN() ) + CRLF
				
			FT_FSKIP()
		 
		EndDo
		
		FT_FUSE() 
		
		if !empty(cTexto)
	
			DEFINE MSDIALOG oDlg TITLE "Archivo de Log" FROM 0,0 TO 250,450 PIXEL 
			@ 020,005 GET oMemo VAR cTexto MEMO SIZE 215,100 OF oDlg PIXEL WHEN .F.
		
			DEFINE SBUTTON oBtnOk FROM 005,005 TYPE 1 ACTION( nOpc:=1,oDlg:End() ) ENABLE OF oDlg
		      
			ACTIVATE MSDIALOG oDlg CENTERED 
			
		else
			alert("¡ Error al abrir el archivo de log !")
		endif
		
	else
		MsgInfo("¡ No existe Log para esta factura !","ALREX")
	endif

Return
