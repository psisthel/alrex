USER FUNCTION PP02_FILAVENT()

lnResul := 0

DO CASE
   CASE V_VENTANAS == "2"   
      	lnresul := 2

   CASE V_VENTANAS == "3"  
      	lnresul := 3

   CASE V_VENTANAS == "4"   
      	lnresul := 4

   CASE V_VENTANAS == "5"   
      	lnresul := 5

ENDCASE

RETURN (lnResul)