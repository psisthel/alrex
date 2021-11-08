#INCLUDE "RWMAKE.CH"
/*          
----------------------------------------------------------------------------------
Funcion     : NEOFUN10
Descripcion :         
Parametros  : nDC1
              		cLP1 => Codigo del Asiento Estandar que genero el asiento contable     
----------------------------------------------------------------------------------
*/                                       
User Function NEOFUN10(nDC1,cLP1)
/*
Local aSaveArea := GetArea()
Local cLP1      := ""
*/
Local lRet                := .T.  
Local nCont
Local nValDeb   := 0       //ParamIxb[1]
Local nValCrd   := 0       //ParamIxb[2]
Local cLote1    := ""
Local cSblote1  := ""
Local dFecha1   := Ctod("  /  /  ")
Local cDoc1     := ""
Local cSequen1  := ""
Local mvdifpes  := 5
Local nDif1     := 0  

//Verifica y crea parametro para manejar correlativo de certificados 
DbSelectArea("SX6")
DbSetOrder(1)
IF !DbSeek("  "+"MV_DIFPES")
   RecLock("SX6",.T.)
   Replace SX6->X6_FIL      With "  "
   Replace SX6->X6_VAR      With "MV_DIFPES"
   Replace SX6->X6_TIPO     With "N"
   Replace SX6->X6_DESCRIC  With "Valor limite para validar diferencias"
   Replace SX6->X6_DSCSPA   With "Valor limite para validar diferencias"
   Replace SX6->X6_DSCENG   With "Valor limite para validar diferencias"
   Replace SX6->X6_DESC1    With "en asientos contables"
   Replace SX6->X6_DSCSPA1  With "en asientos contables"
   Replace SX6->X6_DSCENG1  With "en asientos contables"
   Replace SX6->X6_CONTEUD  With "5"
   Replace SX6->X6_CONTSPA  With "5"
   Replace SX6->X6_CONTENG  With "5"
   Replace SX6->X6_PROPRI   With "U"
   SX6->(MsUnlock())
ENDIF   


// CTK => Archivo de Contramuestra           
mvdifpes := GETMV("MV_DIFPES")
nrecctk  := CTK->(RECNO())
nordctk  := CTK->(IndexOrd())
cSequen1 := CTK->CTK_SEQUEN

/*IIF cLP1 != NIL
   cLP1 := IIF(empty(cLP1),CTK->CTK_LP,cLP1)
ELSE
   cLP1 := CTK->CTK_LP
ENDIF   
          */
/*
CTK_DC    => Tipo de Asiento : 1 = Debito, 2 = Credito, 3 = Partida Doble
CTK_VLR01 => Valor en Moneda 01
*/
                                                                                                                                                    
DbSelectArea("CTK")
Dbseek(xFilial("CTK")+cSequen1)
While !CTK->(Eof()) .and. CTK->CTK_SEQUEN=cSequen1  //.and. CTK->CTK_LP $ cLP1
   If CTK->CTK_DC == "1" .Or. CTK->CTK_DC == "3"
      nValDeb += CTK->CTK_VLR01
   EndIf
   If CTK->CTK_DC == "2" .Or. CTK->CTK_DC == "3"
      nValCrd += CTK->CTK_VLR01
   EndIf                  
   CTK->(DbSkip())
EndDo  
                
IF NoRound(Round(nValDeb,3)) != NoRound(Round(nValCrd,3))
   
   nDif1:=NoRound(Round(nValDeb,3)) - NoRound(Round(nValCrd,3))

	IF nDif1 < 0 .and. nDif1 >= -mvdifpes .and. nDC1=1      
      nDif1:=nDif1*-1
//    MSGBOX("Este asiento tiene una diferencia de "+transform(nDif1,"@E 999,999")+" Pesos, "+chr(13)+"Se agregará una linea con la diferencia para ajustar el asiento.","Asiento con diferencia","INFO")
    ELSEIF nDif1 > 0 .and.  nDif1 <= mvdifpes    .and. nDC1=2
//    MSGBOX("Este asiento tiene una diferencia de "+transform(nDif1,"@E 999,999")+" Pesos, "+chr(13)+"Se agregará una linea con la diferencia para ajustar el asiento.","Asiento con diferencia","INFO")
   ELSE
     nDif1:=0
   ENDIF
ENDIF
                
CTK->(DbSetOrder(nordctk))           
CTK->(Dbgoto(nrecctk))

Return(nDif1)     
                  
/*          
----------------------------------------------------------------------------------
Funcion     : NEOFUN11
Descripcion :         
Parametros  : nDC1
              		cLP1 => Codigo del Asiento Estandar que genero el asiento contable     
----------------------------------------------------------------------------------
*/

User Function NEOFUN11(nDC1,cLP1)
/*
Local aSaveArea := GetArea()
Local cLP1      := ""
*/
Local lRet                := .T.  
Local nCont
Local nValDeb   := 0       //ParamIxb[1]
Local nValCrd   := 0       //ParamIxb[2]
Local cLote1    := ""
Local cSblote1  := ""
Local dFecha1   := Ctod("  /  /  ")
Local cDoc1     := ""
Local cSequen1  := ""
Local mvdifpes  := 5
Local nDif1     := 0  

//Verifica y crea parametro para manejar correlativo de certificados 
DbSelectArea("SX6")
DbSetOrder(1)
IF !DbSeek("  "+"MV_DIFPES")
   RecLock("SX6",.T.)
   Replace SX6->X6_FIL      With "  "
   Replace SX6->X6_VAR      With "MV_DIFPES"
   Replace SX6->X6_TIPO     With "N"
   Replace SX6->X6_DESCRIC  With "Valor limite para validar diferencias"
   Replace SX6->X6_DSCSPA   With "Valor limite para validar diferencias"
   Replace SX6->X6_DSCENG   With "Valor limite para validar diferencias"
   Replace SX6->X6_DESC1    With "en asientos contables"
   Replace SX6->X6_DSCSPA1  With "en asientos contables"
   Replace SX6->X6_DSCENG1  With "en asientos contables"
   Replace SX6->X6_CONTEUD  With "5"
   Replace SX6->X6_CONTSPA  With "5"
   Replace SX6->X6_CONTENG  With "5"
   Replace SX6->X6_PROPRI   With "U"
   SX6->(MsUnlock())
ENDIF   


// CTK => Archivo de Contramuestra           
mvdifpes := GETMV("MV_DIFPES")
nrecctk  := CTK->(RECNO())
nordctk  := CTK->(IndexOrd())
cSequen1 := CTK->CTK_SEQUEN

/*IIF cLP1 != NIL
   cLP1 := IIF(empty(cLP1),CTK->CTK_LP,cLP1)
ELSE
   cLP1 := CTK->CTK_LP
ENDIF   
          */
/*
CTK_DC    => Tipo de Asiento : 1 = Debito, 2 = Credito, 3 = Partida Doble
CTK_VLR01 => Valor en Moneda 01
*/
                                                                                                                                                    
DbSelectArea("CTK")
Dbseek(xFilial("CTK")+cSequen1)
While !CTK->(Eof()) .and. CTK->CTK_SEQUEN=cSequen1  //.and. CTK->CTK_LP $ cLP1
   If CTK->CTK_DC == "1" .Or. CTK->CTK_DC == "3"
      nValDeb += CTK->CTK_VLR02
   EndIf
   If CTK->CTK_DC == "2" .Or. CTK->CTK_DC == "3"
      nValCrd += CTK->CTK_VLR02
   EndIf                  
   CTK->(DbSkip())
EndDo  
                
IF NoRound(Round(nValDeb,3)) != NoRound(Round(nValCrd,3))
   
   nDif1:=NoRound(Round(nValDeb,3)) - NoRound(Round(nValCrd,3))

	IF nDif1 < 0 .and. nDif1 >= -mvdifpes .and. nDC1=1      
      nDif1:=nDif1*-1
//    MSGBOX("Este asiento tiene una diferencia de "+transform(nDif1,"@E 999,999")+" Pesos, "+chr(13)+"Se agregará una linea con la diferencia para ajustar el asiento.","Asiento con diferencia","INFO")
    ELSEIF nDif1 > 0 .and.  nDif1 <= mvdifpes    .and. nDC1=2
//    MSGBOX("Este asiento tiene una diferencia de "+transform(nDif1,"@E 999,999")+" Pesos, "+chr(13)+"Se agregará una linea con la diferencia para ajustar el asiento.","Asiento con diferencia","INFO")
   ELSE
     nDif1:=0
   ENDIF
ENDIF
                
CTK->(DbSetOrder(nordctk))           
CTK->(Dbgoto(nrecctk))

Return(nDif1)