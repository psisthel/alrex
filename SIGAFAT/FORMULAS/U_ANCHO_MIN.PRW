#INCLUDE "PROTHEUS.CH"
user function ANCHO_MIN()
lnResult := V_ANCHO
IF lnResult  < 1.000
     lnResult := 1.000
ENDIF
RETURN lnResult