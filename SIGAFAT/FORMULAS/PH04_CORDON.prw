USER FUNCTION PH04_CORDON(TIPO)

LNRESULT :=0

IF V_CORDON==0
	CORDON1 := 1.3 + MAX(V_ALTO - 2.4 ,0)		// LARGO DE CORDON MINIMO 1.3m
ELSE
	CORDON1 := V_CORDON
ENDIF


IF TIPO=="COR"									// PARA CORDON
	LNRESULT := (V_ALTO + V_ANCHO/2 + CORDON1) * U_PH01_BAJADAS("CORDON") 
ELSE										// PARA VARIADOR
	LNRESULT:= CORDON1 * 2
ENDIF


 
RETURN (LNRESULT)