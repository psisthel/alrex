#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "FONT.CH"
#include "fileio.ch"

User Function FM_Direct( cPath, lDrive, lMSg )

	Local aDir
	Local lRet:=.T.
	Default lMSg := .T.
	
	If Empty(cPath)
		Return lRet
	EndIf
	
	lDrive := If(lDrive == Nil, .T., lDrive)
	
	cPath := Alltrim(cPath)
	If Subst(cPath,2,2) <> ":" .AND. lDrive
		MsgInfo("Unidad de drive no especificada") //Unidade de drive n?o especificada
		lRet:=.F.
	Else
		cPath := If(Right(cPath,1) == "", Left(cPath,Len(cPath)-1), cPath)
		aDir  := Directory(cPath,"D")
		If Len(aDir) = 0
			If lMSg
				If MsgYesNo("¿ Directorio - "+cPath+" - no encontrado, desea crearlo ?" ) //Diretorio  -  nao encontrado, deseja cria-lo
					If MakeDir(cPath) <> 0
						Help(" ",1,"NOMAKEDIR")
						lRet := .F.
					EndIf
				EndIf
			Else
				If MakeDir(cPath) <> 0
					Help(" ",1,"NOMAKEDIR")
					lRet := .F.
				EndIf
			EndIF
		EndIf
	EndIf
Return lRet