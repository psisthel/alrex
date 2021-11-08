#include "protheus.ch"

User Function STHCTB01()

    Local aParamBox := {}
    Local aRet	:= {}
    Local lModif := .f.

    Private oOk    	:= LoadBitMap(GetResources(), "LBOK")
    Private oNo	    := LoadBitMap(GetResources(), "LBNO")

    AADD(aParamBox,{1,"Serie"   		,Space(TamSX3("F2_SERIE")[1]),"","","","",0,.T.})
    AADD(aParamBox,{1,"Documento"		,Space(TamSX3("F2_DOC")[1]),"","","","",0,.T.})
    AADD(aParamBox,{1,"Cliente"     	,Space(TamSX3("A1_COD")[1]),"","","SA1","",0,.T.})
    AADD(aParamBox,{1,"Tienda"	        ,Space(TamSX3("A1_LOJA")[1]),"","","","",0,.T.})

    If ParamBox(aParamBox,"Parametros",@aRet,,,,,,,"",.T.,.T.)

        SF2->( dbSetOrder(1) )      // F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_FORMUL, F2_TIPO
        if( SF2->( dbSeek( xFilial("SF2")+aRet[2]+aRet[1]+aRet[3]+aRet[4] )) )
            if empty(SF2->F2_NODIA) .and. !empty(SF2->F2_DTLANC)

                lModif := .t.

                SF2->(RecLock("SF2",.f.))
                SF2->F2_DTLANC := ctod(space(8))
                SF2->(MsUnlock())

            else

                lModif := .t.

            endif
        endif

    endif

    if lModif 
        MsgInfo("Documento liberado para contabilizacion !","ALREX")
    else
        alert("Ningun documento encontrado!")
    endif

Return
