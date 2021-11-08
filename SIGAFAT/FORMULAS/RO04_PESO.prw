USER FUNCTION RO04_PESO(FAM)

lnResul := 0

grmtela := 0
grmriel := 0

dbSelectArea("ZYC")
dbSetOrder(1)
cCod := V_TELA
If dbSeek(xFilial("ZYC") + cCod)
   grmtela := ZYC->ZYC_GRMAJE
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

lnResul := V_ANCHO * V_ALTO * grmtela + V_ANCHO * grmriel

RETURN (lnResul)

