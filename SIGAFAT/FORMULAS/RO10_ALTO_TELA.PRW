USER FUNCTION RO10_ALTO_TELA()

LNRESULT :=0
PI := 3.1416
PERIMETRO := 0

DO CASE
CASE v_TUBO == "C28"
	PERIMETRO := 0.0880
CASE (V_TUBO == "C30" .OR. V_TUBO == "X30")
	PERIMETRO := 0.0942
CASE (v_TUBO == "C35" .OR. V_TUBO == "X35")
	PERIMETRO := 0.1100
CASE (V_TUBO == "C38" .OR. V_TUBO == "X38")
	PERIMETRO := 0.1194
CASE (V_TUBO == "C42" .OR. V_TUBO == "X42")
	PERIMETRO := 0.1319
CASE (V_TUBO == "C50" .OR. V_TUBO == "X50")
	PERIMETRO := 0.1571
CASE (V_TUBO == "C65" .OR. V_TUBO == "X65")
	PERIMETRO := 0.2042
CASE (V_TUBO == "C80" .OR. V_TUBO == "X80")
	PERIMETRO := 0.2513
CASE (V_TUBO == "R50" .OR. V_TUBO == "Z50")
	PERIMETRO := 0.1571
CASE (V_TUBO == "R38" .OR. V_TUBO == "Z38")
	PERIMETRO := 0.1194
ENDCASE


IF V_RIELINFE == "FOR"			// adicional para bases forradas
   ADICIONAL := 0.110
ELSE
   ADICIONAL := 0
ENDIF

LNRESULT := (V_ALTO + PERIMETRO * 1.5) + ADICIONAL

RETURN (LNRESULT)