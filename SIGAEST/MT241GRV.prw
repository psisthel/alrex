#INCLUDE "PROTHEUS.CH"

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?MT241GRV  ?Autor  ?Microsiga           ? Data ?  02/07/18   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ? Muestra campo de Obs. en los movimientos Multiples         ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? AP                                                         ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/

User Function MT241GRV()

	Local _aLinhas := aClone(PARAMIXB[2])

	For X = 1 TO Len(_aLinhas)
    	If RecLock("SD3",.F.) 
			SD3->D3_YOBS := PARAMIXB[2][1][2]
       		SD3->( MsUnlock() )
    	EndIf
	Next

Return Nil