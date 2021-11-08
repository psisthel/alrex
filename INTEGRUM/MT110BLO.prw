User Function MT110BLO()

Local lContinua := .T.

If PARAMIXB[1] == 1 .OR. PARAMIXB[1] == 2 .OR. PARAMIXB[1] == 3     // 1 = Aprovar; 2 = Rejeitar; 3 = Bloquear
     
     _IdUser   := RetCodUsr()               //Id do usuário ativo       
     PswOrder(2)                                    // Ordem de nome 
     PswSeek(SC1->C1_SOLICIT,.T.)              //Busca usuário que incluiu a SC
   _aRetUser := PswRet(1)
   _IdSup    := substr(upper(alltrim(_aRetUser[1,11])),1,6)   //ID do Superior
   
   If _IdSup <> _IdUser //Se o usuário ativo não for o superior do soliciante
      MSGALERT("Verificar con su Superior", "Sin Acceso" )
     lContinua := .F.
   Endif
Endif

Return ( lContinua )