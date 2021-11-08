#INCLUDE "PROTHEUS.CH"
USER FUNCTION ALU_SOPORTES()

lnResul := 0

DO CASE
   CASE V_MODELO== "FAB" .OR. V_MODELO== "TUR" .OR. V_MODELO== "SLI"

      DO CASE
         CASE V_ANCHO <= 1200
            lnResul := 2

         CASE (V_ANCHO >= 1201 .AND. V_ANCHO <= 2100)
            lnResul := 3

         CASE (V_ANCHO >= 2101 .AND. V_ANCHO <= 3000)
            lnResul := 4

         CASE (V_ANCHO >= 3001 .AND. V_ANCHO <= 3900)
            lnResul := 5

         CASE (V_ANCHO >= 3901 .AND. V_ANCHO <= 4800)
            lnResul := 6

         OTHERWISE
            lnResul := 7

      ENDCASE


   CASE V_MODELO== "UNI"

      DO CASE
         CASE V_ANCHO <= 1000
            lnResul := 2

         CASE (V_ANCHO >= 1001 .AND. V_ANCHO <= 2000)
            lnResul := 3

         CASE (V_ANCHO >= 2101 .AND. V_ANCHO <= 3000)
            lnResul := 4

         CASE (V_ANCHO >= 3001 .AND. V_ANCHO <= 4000)
            lnResul := 5

         CASE (V_ANCHO >= 4001 .AND. V_ANCHO <= 5000)
            lnResul := 6

         OTHERWISE
            lnResul := 7

      ENDCASE


ENDCASE

RETURN (lnResul)