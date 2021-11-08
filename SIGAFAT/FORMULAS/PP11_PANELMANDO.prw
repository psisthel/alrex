USER FUNCTION PP11_PANELMANDO()

lnResul := 0

DO CASE
   CASE V_TIPO == "PAR"   
      	lnResul := 2

   CASE V_TIPO == "DER" .OR. V_TIPO == "IZQ"   
      	lnResul := 1
	
   CASE V_TIPO == "CLO"   
      	lnResul := 2
ENDCASE

RETURN (lnResul)