USER FUNCTION ZE01_ESPESOR(DIM,FAM)

lnResul := 0
espesor := 0
TUBO := 0  
PI := 3.1416

dbSelectArea("ZYC")
dbSetOrder(1)
cCod := V_TELA
If dbSeek(xFilial("ZYC") + cCod)
   espesor := ZYC->ZYC_ESPSOR
 Else
   MsgAlert("No se encuentran parámetros para la tela " + cCod)
EndIf

DO CASE
	CASE v_TUBO == "C28"
		TUBO := 28
	CASE V_TUBO == "C30"
		TUBO := 30
	CASE v_TUBO == "C35"
		TUBO := 35
	CASE V_TUBO == "C38"
		TUBO := 38
	CASE v_TUBO == "C42"
		TUBO := 42
	CASE V_TUBO == "C50"
		TUBO := 50
	CASE v_TUBO == "C65"
		TUBO := 65
	CASE V_TUBO == "C80"
		TUBO := 80
ENDCASE

ESPACIO := DIM - TUBO
VUELTAS := ESPACIO / (espesor * 1.05) / 2
ALTOMAX := VUELTAS * PI * ( TUBO + espesor * (VUELTAS - 1))

DO CASE
	CASE FAM=="ROLLER"
		MULT := 1
	CASE FAM=="ZEBRA"
		MULT := 2
ENDCASE

IF V_ALTO*1000*MULT < ALTOMAX
	lnResul := 1
ELSE
	lnResul := 0
ENDIF

RETURN (lnResul)