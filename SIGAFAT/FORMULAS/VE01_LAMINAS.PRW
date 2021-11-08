USER FUNCTION VE01_LAMINAS(FAM)

LNRESULT :=0
DESCUENTO := 0
PASO := 1
LAMINA := 0

IF FAM=="LUM" .OR. FAM=="STR"
	DESCUENTO := 10
	PASO := 79
	LAMINA := 89
ELSE
	IF V_PRODUCTO <> "LAM"
		DO CASE
			CASE V_SISTEMA == "ABS"		// sistema Coulisse
				DO CASE
					CASE V_MODELO == "P89" .OR. V_MODELO == "T89" .OR. V_MODELO == "R89" .OR. V_MODELO == "M89"
						DESCUENTO := 10
						PASO := 79
						LAMINA := 89
					OTHERWISE
						DESCUENTO := 10
						PASO := 43
						LAMINA := 50
				ENDCASE
			CASE V_SISTEMA == "STD"		// sistema Pantografo
				DO CASE
					CASE V_MODELO == "P89" .OR. V_MODELO == "T89" .OR. V_MODELO == "R89" .OR. V_MODELO == "M89"
						DESCUENTO := -4
						PASO := 79
						LAMINA := 89
					OTHERWISE
						DESCUENTO := 0
						PASO := 40
						LAMINA := 50
				ENDCASE
		ENDCASE
	ENDIF
	IF V_APER == "PAR"
		DESCUENTO := DESCUENTO + 5
	ENDIF
		
	LAM := INT((V_ANCHO * 1000 - DESCUENTO - LAMINA) / PASO + 1.99)

	IF (V_APER == "PAR" .OR. V_APER == "REC" .OR. (V_APER == "MUL" .AND. V_ANCHO1 = V_ANCHO/2)) .AND. LAM % 2 <> 0	// si es partida o multipaño de anchos iguales, la cantidad de láminas debe ser par
		LAM := LAM + 1
	ENDIF
	
	IF V_PRODUCTO == "LAM"
		LNRESULT := V_CANT
	ELSE
		LNRESULT := LAM
	ENDIF

ENDIF
 
RETURN (LNRESULT)

