#include "protheus.ch"
#include "rwmake.ch"
                      
/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?MT462MNU  ?Autor  ?Percy Arias,SISTHEL ?Fecha ?  05/08/15   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ? Adiciona boton para impression de remito direto del        ???
???          ? menu de acciones relacionadas.                             ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? AP                                                         ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/

User Function MT462MNU
               
	If FUNNAME() == 'MATA467N' 
		Aadd(aRotina,{'Transmision Manual','U_XENVIA1', 0 , 5,0,NIL} ) 
		Aadd(aRotina,{'Imp. Comprobante Fiscal','U_XENVIA3', 0 , 5,0,NIL} ) 
 	EndIf	       

	IF FUNNAME() == 'MATA462N'  	
		//Aadd(aRotina,{'Imprime G.R.','U_ALR003',0,5,0,NIL} ) 
		Aadd(aRotina,{'Imprime G.R.','U_ALRFAT09',0,5,0,NIL} ) 
 	ENDIF	                                                      
 	
 	IF FUNNAME() == 'MATA465N'  //NOTA DE CREDITO 
		//Aadd(aRotina,{'Transmitir','U_XENVIA2' , 0 , 5, 0, NIL} ) 
	ENDIF 

Return

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?NOVO3     ?Autor  ?Microsiga           ?Fecha ?  06/21/18   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?                                                            ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? AP                                                        ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
User Function XENVIA1()
	u_NFE001( .f.,.f. )
Return

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?MT462MNU  ?Autor  ?Microsiga           ?Fecha ?  06/21/18   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?                                                            ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? AP                                                        ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
User Function XENVIA2()
	u_NFE001( .f.,.t. )
Return

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?MT462MNU  ?Autor  ?Microsiga           ? Data ?  12/14/18   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?                                                            ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? AP                                                        ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
User Function XENVIA3()
	u_IMPPDF()
Return