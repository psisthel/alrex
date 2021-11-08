#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"

User Function MT242SCR() 

	Local aArea		:= GetArea()
	Local oDlg		:= PARAMIXB[1]
	Local aPosGet	:= PARAMIXB[2]   
	Local nOpcx		:= PARAMIXB[3]    
	Local nRecPC	:= PARAMIXB[4]   
	Local lEdit 	:= IIF(nOpcx == 3 /*Inclusao*/ .Or. nOpcx == 4/*Alteracao*/ .Or. nOpcx == 6/*Copia*/,.T.,.F.) //#ECV20121126.o 
	
	public _jFornece	:= CriaVar("D3_YCLIFOR")

	@ 095,	aPosGet[1,1]-31 SAY "Proveedor" OF oDlg PIXEL SIZE 050,006
	@ 094,	aPosGet[1,2]+47 MSGET _jFornece WHEN lEdit PICTURE PesqPict('SD3','D3_YCLIFOR') OF oDlg PIXEL SIZE 105,010 F3 "SA2"

	//@ 045,	aPosGet[1,3] SAY Alltrim(RetTitle("C7_YARESOL"))OF oDlg PIXEL SIZE 050,006
	//@ 044,	aPosGet[1,4] MSGET _cAreaSol WHEN lEdit PICTURE PesqPict('SC7','C7_YARESOL') OF oDlg PIXEL SIZE 110,006
	
	restArea(aArea)

Return 