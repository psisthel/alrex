USER FUNCTION RO01_FLEXION(TUBO,FAM)

lnResul := .F.

clase := ""
grmtela := 0
grmriel := 0
grmtubo := 0
constante :=0
flexmax :=0
cargaman :=0
cargamot :=0
                                                                         

dbSelectArea("ZYC")
dbSetOrder(1)
cCod := V_TELA
If dbSeek(xFilial("ZYC") + cCod)
   grmtela := ZYC->ZYC_GRMAJE
   clase := ZYC->ZYC_CLASE
 Else
   MsgAlert("No se encuentran parámetros para la tela " + cCod)
EndIf

dbSelectArea("ZYE")
dbSetOrder(1)
cCod := U_RO03_RIEL(FAM)
If dbSeek(xFilial("ZYE") + cCod)
   grmriel := ZYE->ZYE_GMJBAS
 Else
   MsgAlert("No se encuentran parámetros para el riel " + cCod)
EndIf

dbSelectArea("ZYB")
dbSetOrder(1)
cCod := TUBO
If dbSeek(xFilial("ZYB") + cCod)
   grmtubo := ZYB->ZYB_GRMAJE
   constante := ZYB->ZYB_CONTTE
   flexmax := ZYB->ZYB_FLEXIO
   cargaman := ZYB->ZYB_CMAXMA
   cargamot := ZYB->ZYB_CMAXMO
 Else
   MsgAlert("No se encuentran parámetros para el tubo " + cCod)
EndIf


peso := V_ANCHO * V_ALTO * grmtela + V_ANCHO * grmriel
 //clase := {clase de tela segun BD}

if clase = "BO"
	coefBO := 0.8
else
	coefBO := 1
endif

wa := (grmriel/100000+grmtela * V_ALTO/100000 + grmtubo/100000)
wb := (V_ANCHO * 1000)**4
wc := (384*constante*68000)

Flexion := 5 * wa * wb / wc

if Flexion <= flexmax * coefBO
	if V_ACCION == "MANU"
		if cargaman >= peso
			lnResul := .T.
		else
			lnResul := .F.
		endif
	else
		if cargamot >= peso
			lnResul := .T.
		else
			lnResul := .F.
		endif
	endif
else
	lnResul := .F.
endif

RETURN (lnResul)

