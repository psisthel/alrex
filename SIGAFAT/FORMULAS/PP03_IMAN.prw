USER FUNCTION PP03_IMAN()

lnResul := 0

DO CASE
   CASE V_TIPO == "CLO"   
      MULT := 2

   OTHERWISE
      MULT := 1
ENDCASE

DO CASE
	CASE V_ALTO > 1.2 .AND. V_CHAPA == "N"
		IMAN := 3
	OTHERWISE
		IMAN := 2
ENDCASE

lnResul := IMAN * MULT

RETURN (lnResul)