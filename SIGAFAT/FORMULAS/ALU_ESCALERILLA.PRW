#INCLUDE "PROTHEUS.CH"
USER FUNCTION ALU_ESCALERILLA()

lnResul := 0
lnExtra := 0

DO CASE
   CASE V_MODELO == "FAB" .OR. V_MODELO == "TUR" .OR. V_MODELO == "SLI"
      lnExtra := 150     //    altura persiana mas 15cm adicional
   CASE V_MODELO == "UNI"
      lnResul := 200     //    altura persiana mas 20cm (???) adicional
ENDCASE

lnResul := U_ALU_CLIPS() * ( V_ALTO + lnExtra ) / 1000     //    altura persiana mas "lnExtra" adicional

RETURN (lnResul)