#INCLUDE "PROTHEUS.CH"

USER FUNCTION XALU_CORDON() 

Local lnResul := 0

DO CASE
   CASE V_MODELO == "FAB" .OR. V_MODELO == "TUR" .OR. V_MODELO == "SLI"

      DO CASE
         CASE V_ANCHO <= 245
            lnResul := ((V_ANCHO - 40) + V_ALTO * 2 + U_ALU_BASTON() * 2 / 1000)

 CASE V_ANCHO >= 246 .AND. V_ANCHO <= 305
            lnResul := ((V_ANCHO - 60) + V_ALTO * 2 + U_ALU_BASTON() * 2 / 1000)

 CASE V_ANCHO >= 306 .AND. V_ANCHO <= 405
            lnResul := ((V_ANCHO - 90) + V_ALTO * 2 + U_ALU_BASTON() * 2 / 1000)

 CASE V_ANCHO >= 406 .AND. V_ANCHO <= 500
            lnResul := ((V_ANCHO - 125) + V_ALTO * 2 + U_ALU_BASTON() * 2 / 1000)

 CASE V_ANCHO >= 501 .AND. V_ANCHO <= 1500
            lnResul := ((V_ANCHO - 150) + V_ALTO * 2 + U_ALU_BASTON() * 2 / 1000)

         OTHERWISE
            //lnResul := ((V_ANCHO - 150) + V_ALTO * 4 + ALU_BASTON() * 2 / 1000)
            lnResul := (V_ANCHO + (V_ANCHO - 300) + V_ALTO * 4 + U_ALU_BASTON() * 4 / 1000)

      ENDCASE


   CASE V_MODELO == "UNI"

      DO CASE
      CASE V_ANCHO <= 245
         lnResul := ((V_ANCHO - 40) + V_ALTO * 2 + U_ALU_BASTON() * 2 / 1000)

  CASE V_ANCHO >= 246 .AND. V_ANCHO <= 305
         lnResul := ((V_ANCHO - 60) + V_ALTO * 2 + U_ALU_BASTON() * 2 / 1000)

  CASE V_ANCHO >= 306 .AND. V_ANCHO <= 405
         lnResul := ((V_ANCHO - 90) + V_ALTO * 2 + U_ALU_BASTON() * 2 / 1000)

  CASE V_ANCHO >= 406 .AND. V_ANCHO <= 500
         lnResul := ((V_ANCHO - 125) + V_ALTO * 2 + U_ALU_BASTON() * 2 / 1000)

  CASE V_ANCHO >= 501 .AND. V_ANCHO <= 1500
         lnResul := ((V_ANCHO - 150) + V_ALTO * 2 + U_ALU_BASTON() * 2 / 1000)

      OTHERWISE
         lnResul := ((V_ANCHO - 150) + V_ALTO * 4 + U_ALU_BASTON() * 2 / 1000)

      ENDCASE


ENDCASE

RETURN (lnResul)
