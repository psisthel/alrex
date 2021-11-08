#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M030Alt  ºAutor  ³RVillasenor          ºFecha ³  09/06/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Validacion para que se alimente correctamente los campos º±±
±±º          ³  de NIT y de Cedula Identidad/Extranjeria al momento de la º±±
                inclusion de clientes
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MA030TOK()

Local lRet:=.T.           
Local flg

IF alltrim(M->A1_TIPDOC)$"6|06" //Tipo de Documento de Indetificacion NIT
	
	IF EMPTY(M->A1_CGC)	                                          
	    ALERT("Se debe indicar el campo RUC del Proveedor")
   		lRet:=.F.
    Endif              
    IF !EMPTY(M->A1_PFISICA)
    	ALERT("El campo RG/Ced Ext, debe estar Vacio")
    	lRet:=.F.
    endif
Else
    IF !EMPTY(M->A1_CGC)	                                          
    	ALERT("El campo RUC del Proveedor, debe estar Vacio")
    	lRet:=.F.
    Endif              
    IF EMPTY(M->A1_PFISICA)
    	ALERT("Se debe indicar el campo RG/Ced Ext")
    	lRet:=.F.
    endif
	    
Endif


IF lRet
	flg := 0   
	   
		DbSelectArea("CV0")
		DbSetOrder(2)
		If DbSeek(xFilial("CV0")+SA1->A1_CGC) .OR. DbSeek(xFilial("CV0")+M->A1_PFISICA)
			RecLock("CV0",.F.)
		Else
		    cQryI :="SELECT MAX(CV0_ITEM) Itm"
		   	cQryI +=" FROM "+RetSqlName("CV0")
		   	cQryI +=" WHERE  D_E_L_E_T_<>'*' "
		   
			cQryI  := ChangeQuery(cQryI )
   			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryI),"QRYITM",.F.,.T.)
		  
		    if !QRYITM->(EOF())
		    	cItm:=IIF(VAL(QRYITM->Itm)>0,soma1(QRYITM->Itm),"000001")
		    	QRYITM->(dbCloseArea()) 
	   	    Else   		    
		    	MsgAlert("Verifique la Tabla CV0, debido a que no se logro resolver el numero de Item Los Terceros no Fueron Actualizados")
		    	QRYITM->(dbCloseArea()) 
		    	Return lRet
		    Endif
			                                                     
			flg:=1
				
		    RecLock("CV0",.T.)
			
		Endif
		    
	   		     
	   	If flg == 1     
		   	
		   	CV0->CV0_FILIAL :=xFilial("CV0")
		  	CV0->CV0_PLANO  :="01"
		  	CV0->CV0_ITEM   :=cItm
		  	CV0->CV0_CLASSE  := "2"
		  	CV0->CV0_NORMAL := "1"
		  	CV0->CV0_DTIEXI := dDatabase          
		
	   Endif
		   CV0->CV0_DESC   := M->A1_NOME
		   CV0->CV0_CODIGO := IIF(alltrim(M->A1_TIPDOC)$"6|06",M->A1_CGC,M->A1_PFISICA)
		   MsUnlock()	   
Endif             

Return lRet