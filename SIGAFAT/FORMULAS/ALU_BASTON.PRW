#INCLUDE "PROTHEUS.CH"

User Function ALU_BASTON()
lnResult := V_ALTVARI
IF lnResult  <= 0
     lnResult := 1.00
ENDIF
RETURN(lnResult)
