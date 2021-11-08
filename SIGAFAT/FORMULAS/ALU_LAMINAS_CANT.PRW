#INCLUDE "PROTHEUS.CH"
USER FUNCTION ALU_LAMINAS_CANT()

lnResul := 0
lnIntervalo := 0
lnAltCabezal := 0

DO CASE
   CASE V_LAM == "16"   // solo hay para V_MODEL == "FAB", "TUR", "SLI"
      lnIntervalo := 13.2

   CASE V_LAM == "25"   // solo hay para V_MODEL == "FAB", "TUR", "SLI"
      lnIntervalo := 21.5

   CASE V_LAM == "25PRI"   // solo hay para V_MODEL == "FAB", "TUR", "SLI"
      lnIntervalo := 18.0

   CASE V_LAM == "50"   // solo hay para V_MODEL == "UNI"
      lnIntervalo := 43.0

ENDCASE

DO CASE
   CASE V_MODELO == "FAB"
      lnAltCabezal := 25

   CASE V_MODELO == "TUR" .OR. V_MODELO == "SLI"
      lnAltCabezal := 19

   CASE V_MODELO== "UNI"
      lnAltCabezal := 38.4

ENDCASE

lnAltRielInf := 12
lnSoporteyTapon := 2.5
lnMargen := 3.0

lnResul := (V_ALTO - lnAltCabezal - lnAltRielInf - lnSoporteyTapon - lnMargen - 0.2) / lnIntervalo + 2
lnResul := INT(lnResul)  // INT() trunca el número para que sean láminas enteras

RETURN (lnResul)