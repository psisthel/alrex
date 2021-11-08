USER FUNCTION PP05_JAMBAREC()

lnResul := 0

DO CASE
   CASE V_TIPO == "PAR"   
      	lnresul := 2

   CASE V_TIPO == "IZQ" .OR. V_TIPO == "DER"
      	lnresul := 1

   CASE V_TIPO == "CLO"   
      	lnresul := 0

ENDCASE

RETURN (lnResul)