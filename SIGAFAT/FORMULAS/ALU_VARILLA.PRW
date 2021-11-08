#INCLUDE "PROTHEUS.CH"
USER FUNCTION ALU_VARILLA()

Local lnResul := 0

DO CASE
   CASE V_MODELO == "FAB" .OR. V_MODELO == "TUR" .OR. V_MODELO == "SLI"

      DO CASE
      CASE V_ALTO < 2500
         lnResul := 1.0

      CASE (V_ALTO >= 2500 .AND. V_ALTO < 3000)
         lnResul := 1.2

      CASE (V_ALTO >= 3000 .AND. V_ALTO < 4000)
 lnResul := 1.5

      OTHERWISE
         lnResul := 2.0

      ENDCASE


   CASE V_MODELO == "UNI"

      DO CASE
      CASE V_ALTO < 1700
 lnResul := 1.0

      CASE (V_ALTO >= 1700 .AND. V_ALTO < 2500)
         lnResul := 1.2

      CASE (V_ALTO >= 2500 .AND. V_ALTO < 4000)
         lnResul := 1.5

      OTHERWISE
         lnResul := 2.0

      ENDCASE

ENDCASE

RETURN (lnResul)
