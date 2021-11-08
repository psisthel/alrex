USER FUNCTION PP09_PANELGRA()

lnResul := 0

DO CASE
   CASE V_TIPO == "PAR"   
      	ty1 := 0.412
		LAM := 0.226
		panelg := INT((V_ANCHO - ty1)/LAM) * 2
		an2 := V_ANCHO - ty1 - INT((V_ANCHO - ty1)/LAM)*LAM
		DO CASE
			CASE an2 >= 0.154			// MENOS DE 40MM SE LE AGREGAN 2 JAMBAS Y 2 MED PANEL
				lnResul := panelg + 1
			OTHERWISE
    	      	lnresul := panelg
		ENDCASE

   CASE V_TIPO == "DER" .OR. V_TIPO == "IZQ"
		ty1 := 0.211
		LAM := 0.113
		panelg := INT((V_ANCHO - ty1)/LAM)
		an2 := V_ANCHO - ty1 - INT((V_ANCHO - ty1)/LAM)*LAM
		DO CASE
			CASE an2 >= 0.077			// MENOS DE 77MM SE LE AGREGAN 1 JAMBA O 1 MEDIO PANEL
				lnResul := panelg + 1
			OTHERWISE
            	lnresul := panelg
		ENDCASE

   CASE V_TIPO == "CLO"   
      	ty1 := 0.243
		LAM := 0.113
		panelg := INT((V_ANCHO - ty1)/LAM)
		an2 := V_ANCHO - ty1 - INT((V_ANCHO - ty1)/LAM)*LAM
		DO CASE
			CASE an2 >0			// 
				lnResul := panelg + 1
			OTHERWISE
            	lnresul := panelg
		ENDCASE

ENDCASE

RETURN (lnResul)
