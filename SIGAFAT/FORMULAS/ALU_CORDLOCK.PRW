#INCLUDE "PROTHEUS.CH"
USER FUNCTION ALU_CORDLOCK()

lnResul:=0

DO CASE
   CASE V_MODELO == "FAB"

      If V_ANCHO > 1500
         lnResult := 1
      ENDIF
ENDCASE
