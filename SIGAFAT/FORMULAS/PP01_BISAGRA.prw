USER FUNCTION PP01_BISAGRA()

lnResul := 0

DO CASE
   CASE V_TIPO == "PAR"   
      lnBIS := 2
   OTHERWISE
      lnBIS := 1
ENDCASE

DO CASE
	CASE V_MODELO == "LISO"
		lnResul := lnBIS + u_PP09_PANELGRA() + u_PP08_MEDIOPAN()
	OTHERWISE
		lnResul := lnBIS + u_PP10_PANELGRA10() + u_PP08_MEDIOPAN()
ENDCASE

RETURN (lnResul)