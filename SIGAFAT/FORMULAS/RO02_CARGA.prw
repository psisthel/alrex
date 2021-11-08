USER FUNCTION RO02_CARGA(SIST)

lnResul := 0
cargaS11:= 0
cargaM11:= 0
cargaM13:= 0
cargaL13:= 0

dbSelectArea("ZYB")
dbSetOrder(1)
cCod := V_TUBO
If dbSeek(xFilial("ZYB") + cCod)
   cargaS11:= ZYB->ZYB_S11
   cargaM11:= ZYB->ZYB_M11
   cargaM13:= ZYB->ZYB_M13
   cargaL13:= ZYB->ZYB_L13
   
 Else
   MsgAlert("No se encuentran parámetros para el tubo " + cCod)
EndIf

DO CASE
	CASE SIST == "S11"
		lnResul := cargaS11

	CASE SIST == "M11"
		lnResul := cargaM11

	CASE SIST == "M13"
		lnResul := cargaM13

	CASE SIST == "L13"
		lnResul := cargaL13
	
ENDCASE

RETURN (lnResul)