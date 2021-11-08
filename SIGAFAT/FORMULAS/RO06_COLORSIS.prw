USER FUNCTION RO06_COLORSIS()

lnResul := ""


colrollease := " "
colcoulisse := ""

dbSelectArea("ZYD")                     
dbSetOrder(1)
cCod := V_COLOR
If dbSeek(xFilial("ZYD") + cCod)
   colrollease := ZYD->ZYD_ROLLSE
   colcoulisse := ZYD->ZYD_COULIS
 Else
   MsgAlert("No se encuentran parámetros para la tela-color " + cCod)
EndIf

IF alltrim(V_COLSIS) == ""
	IF V_MARCA=="COU"
		lnResul := colcoulisse
	ELSE
		lnResul := colrollease
	ENDIF
ELSE
	lnResul := V_COLSIS
ENDIF


RETURN (lnResul)

