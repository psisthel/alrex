#INCLUDE "PROTHEUS.CH"
USER FUNCTION ALU_CLIPS()

lnResul := 0

DO CASE
   CASE V_MODELO == "FAB" .OR. V_MODELO == "TUR" .OR. V_MODELO == "SLI"

      DO CASE
         CASE V_ANCHO <= 800
            lnResul := 2

         CASE (V_ANCHO >= 801 .AND. V_ANCHO <= 1500)
            lnResul := 3

         CASE (V_ANCHO >= 1501 .AND. V_ANCHO <= 2200)
            lnResul := 4

         CASE (V_ANCHO >= 2201 .AND. V_ANCHO <= 2900)
            lnResul := 5
            
         CASE (V_ANCHO >= 2901 .AND. V_ANCHO <= 3600)
            lnResul := 6

         CASE (V_ANCHO >= 3601 .AND. V_ANCHO <= 4300)
            lnResul := 7

         CASE (V_ANCHO >= 4301 .AND. V_ANCHO <= 5000)
            lnResul := 8

         OTHERWISE
            lnResul := 9

      ENDCASE


   CASE V_MODELO == "UNI"

      DO CASE
         CASE V_ANCHO <= 900
            lnResul := 2

         CASE (V_ANCHO >= 901 .AND. V_ANCHO <= 1400)
            lnResul := 3

         CASE (V_ANCHO >= 1401 .AND. V_ANCHO <= 1900)
            lnResul := 4

         CASE (V_ANCHO >= 1901 .AND. V_ANCHO <= 2400)
            lnResul := 5

         CASE (V_ANCHO >= 2401 .AND. V_ANCHO <= 2900)
            lnResul := 6

         CASE (V_ANCHO >= 2901 .AND. V_ANCHO <= 3400)
            lnResul := 7

         CASE (V_ANCHO >= 3401 .AND. V_ANCHO <= 3900)
            lnResul := 8

         CASE (V_ANCHO >= 3901 .AND. V_ANCHO <= 4400)
            lnResul := 9

         CASE (V_ANCHO >= 4401 .AND. V_ANCHO <= 4900)
            lnResul := 10

         CASE (V_ANCHO >= 4901 .AND. V_ANCHO <= 5400)
            lnResul := 11

         OTHERWISE
            lnResul := 12

      ENDCASE

ENDCASE

RETURN (lnResul)