USER FUNCTION PP10_PANELGRA10()

lnResul := 0

DO CASE
   CASE V_TIPO == "PAR"   
      	ty1 := 0.538
		LAM := 0.296
		panelg := INT((V_ANCHO - ty1)/LAM) * 2
   		an2 := V_ANCHO - ty1 - INT((V_ANCHO - ty1)/LAM)*LAM
		DO CASE
			CASE an2 >= 0.174			// MENOS DE 40MM SE LE AGREGAN 2 JAMBAS
				lnResul := panelg + 1
			OTHERWISE
            	lnresul := panelg
		ENDCASE

   CASE V_TIPO == "DER" .OR. V_TIPO == "IZQ"   
      	ty1 := 0.280
		LAM := 0.148
		panelg := INT((V_ANCHO - ty1)/LAM)
		an2 := V_ANCHO - ty1 - INT((V_ANCHO - ty1)/LAM)*LAM
		DO CASE
			CASE an2 >= 0.087			// MENOS DE 87MM SE LE AGREGAN 1 JAMBAS O 1 MEDIO PANEL
				lnResul := panelg + 1
			OTHERWISE
            	lnresul := panelg
		ENDCASE

   CASE V_TIPO == "CLO"   
      	ty1 := 0.365
		LAM := 0.148
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
