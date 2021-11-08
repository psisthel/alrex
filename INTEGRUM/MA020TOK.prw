#include "protheus.ch"

User Function MA020TOK()

Local lRet:=.T. 
Local flg

IF alltrim(M->A2_TIPDOC)$"6|06" //Tipo de Documento de Indetificacion NIT

	IF EMPTY(M->A2_CGC)	                                          
 	   ALERT("Se debe indicar el campo RUC del Proveedor")
    	lRet:=.F.
    Endif              
    
    IF !EMPTY(M->A2_PFISICA)
    	ALERT("El campo RG/Ced Ext, debe estara Vacio")
    	lRet:=.F.
    endif

ELSE
    
    IF !EMPTY(M->A2_CGC)	                                          
    	ALERT("El campo RUC del Proveedor, debe estara Vacio")
    	lRet:=.F.
    Endif              
    
    IF EMPTY(M->A2_PFISICA)
    	ALERT("Se debe indicar el campo RG/Ced Ext")
    	lRet:=.F.
    endif
    
Endif               

If lRet
	 
lg := 0   
	   
		DbSelectArea("CV0")
		DbSetOrder(2)
		If DbSeek(xFilial("CV0")+SA2->A2_CGC) .OR. DbSeek(xFilial("CV0")+M->A2_PFISICA)
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
		   CV0->CV0_DESC   := M->A2_NOME
		   CV0->CV0_CODIGO := IIF(alltrim(M->A2_TIPDOC)$"6|06",M->A2_CGC,M->A2_PFISICA)
		   MsUnlock()	   
Endif             

Return lRet		