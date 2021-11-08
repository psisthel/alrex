USER FUNCTION PA01_ANCHOTELA()

LNRESULT :=0
Nvtraslape = INT( VAL(V_TRASLAPE) )


IF ALLTRIM(V_TELA) <> ''

   dbSelectArea("ZYC")
   dbSetOrder(1)
   cCod := V_TELA
   If dbSeek(xFilial("ZYC") + cCod)
      clase := ZYC->ZYC_CLASE
   Else
      MsgAlert("No se encuentran parámetros para la tela " + cCod)
   EndIf

ENDIF


DO CASE			  // TRASLAPE
   CASE Nvtraslape > 0	
      TRASLAPE := Nvtraslape / 100

   CASE ALLTRIM(V_TELA) <> ''
      IF ALLTRIM(CLASE) == "BO"
         TRASLAPE := 0.06
      ENDIF

   CASE ALLTRIM(V_TELA) <> ''
      IF ALLTRIM(CLASE) <> "BO"
         TRASLAPE := 0.04
      ENDIF

   OTHERWISE
      TRASLAPE := 0.04

ENDCASE


LNRESULT := ROUND((V_ANCHO + ( VAL(V_PANOS) - 1) * TRASLAPE) / VAL(V_PANOS) , 3)

RETURN (LNRESULT)

