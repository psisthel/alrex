USER FUNCTION PP08_MEDIOPAN()

lnResul := 0

DO CASE
   CASE V_TIPO == "PAR"   
      	lnMED := 4
	
		DO CASE
			CASE V_MODELO == "LISO"
				ty1 := 0.412     // 
				lam := 0.226			//    al ser doble se consireda laminas pares
				an2 := V_ANCHO - ty1 - INT((V_ANCHO - ty1)/lam)*lam
				DO CASE
					CASE (an2 < 0.154 .AND. an2 > 0.040)
						lnResul := lnMED + 2
					OTHERWISE
       		    		lnresul := lnMED
				ENDCASE
			OTHERWISE
				ty1 := 0.538    //
				lam := 0.296    		//     al ser doble se consireda laminas pares
				an2 := V_ANCHO - ty1 - INT((V_ANCHO - ty1)/lam)*lam
				DO CASE
					CASE (an2 < 0.174 .AND. an2 > 0.040)
						lnResul := lnMED + 2
					OTHERWISE
	     				lnresul := lnMED
				ENDCASE
		ENDCASE
		
   CASE V_TIPO == "DER" .OR. V_TIPO == "IZQ"
	
		lnMED := 2
		DO CASE
			CASE V_MODELO == "LISO"
				ty1 := 0.211
				lam := 0.113
				an2 := V_ANCHO - ty1 - INT((V_ANCHO - ty1)/lam)*lam
				DO CASE
					CASE (an2 < 0.077 .AND. an2 > 0.020)
						lnResul := lnMED + 1
					OTHERWISE
    	     			lnresul := lnMED
				ENDCASE
   			OTHERWISE
				ty1 := 0.275    //
				lam := 0.148    // 
				an2 := V_ANCHO - ty1 - INT((V_ANCHO - ty1)/lam)*lam
				DO CASE
					CASE (an2 < 0.087 .AND. an2 > 0.020)
						lnResul := lnMED + 1
					OTHERWISE
    	     			lnresul := lnMED
				ENDCASE
		ENDCASE

   CASE V_TIPO == "CLO"   
      	lnresul := 2

ENDCASE

RETURN (lnResul)