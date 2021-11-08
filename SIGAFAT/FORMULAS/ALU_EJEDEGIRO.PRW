#INCLUDE "PROTHEUS.CH"
USER FUNCTION ALU_EJEDEGIRO()

Local lnDescuento := 0
Local lnResul := 0

DO CASE 
   CASE V_MODELO == "FAB" .OR. V_MODELO == "TUR" .OR. V_MODELO == "SLI"

      DO CASE
  CASE V_ANCHO <= 245
         lnDescuento := 40                      // 40mm

  CASE V_ANCHO >= 246 .AND. V_ANCHO <= 305
         lnDescuento := 60                      // 60mm

  CASE V_ANCHO >= 306 .AND. V_ANCHO <= 405
         lnDescuento := 90                      // 90mm

  CASE V_ANCHO >= 406 .AND. V_ANCHO <= 500
         lnDescuento := 125                     // 125mm

      OTHERWISE
         lnDescuento := 150                     // 150mm
      
      ENDCASE
lnResul := (V_ANCHO - lnDescuento) / 1000    // devuelve el resultado total despues de calcular los descuentos para c/caso
  
  
  CASE V_MODELO == "UNI"
   
lnResul := (V_ANCHO - 100)/1000
     
  ENDCASE

RETURN (lnResul)
