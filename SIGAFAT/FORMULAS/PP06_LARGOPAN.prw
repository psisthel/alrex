USER FUNCTION PP06_LARGOPAN()

lnResul := 0

DO CASE
   CASE V_ALTO > 2.18 .OR. (V_ALTO < 1.09 .AND. V_ALTO > 1.24)   
      	lnResul := 8

   OTHERWISE
	lnresul := 7
	
ENDCASE

RETURN (lnResul)