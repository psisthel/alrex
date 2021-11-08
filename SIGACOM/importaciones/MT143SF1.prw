/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �MT143SF1 �Autor �Juan Pablo Astorga        �Fecha � 06/10/17 ���
�������������������������������������������������������������������������͹��
���Desc. � Grabacion de Tipo de comprobante , Codigo Diario y Serie de 4  ���
��� � Caracteres para documentos CIF y FOB								  ���
��� � 																	  ���
�������������������������������������������������������������������������͹��
���Uso � MSExecAuto/MATA143 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT143SF1()

	Local aRetSF1	:= ParamIXB[1]
	Local _aAREA	:= GETAREA()       
	Local cSerie	:= DBB->DBB_SERIE
	Local cSerie2	:= DBB->DBB_XSER2
	local _cModal	:= getNewPar("AL_MODFOR","0900001")

	AADD(aRetSF1,{"F1_TPDOC" , DBB->DBB_XTPDOC,NIL})	
	AADD(aRetSF1,{"F1_DIACTB", "08",NIL})   
	Aadd(aRetSF1,{"F1_NATUREZ", _cModal,NIL})

	IF POSICIONE("SA2",1,XFILIAL("SA2")+DBB->DBB_FORNECE+DBB->DBB_LOJA,"A2_DOMICIL")=='2'	
		AADD(aRetSF1,{"F1_TPRENTA",DBB->DBB_XTPREN,NIL})                     
	EndIf
	
	RestArea(_aArea)

Return(aRetSF1)