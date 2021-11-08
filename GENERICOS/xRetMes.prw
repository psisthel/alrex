#INCLUDE "rwmake.ch"    
#Include "protheus.ch"          

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �XRETMES   �Autor  �Microsiga           � Data �  04/30/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RetMes(nMes)

	nMes := strzero(nMes,2)
	
	IF nMes == '01'
		cMes := "ENERO" 
	ElseIf nMes == '02'
		cMes := "FEBRERO"
	ElseIf nMes == '03'
		cMes := "MARZO"
	ElseIf nMes == '04'
		cMes := "ABRIL"
	ElseIf nMes == '05'
		cMes := "MAYO"
	ElseIf nMes == '06'
		cMes := "JUNIO"
	ElseIf nMes == '07'
		cMes := "JULIO"
	ElseIf nMes == '08'
		cMes := "AGOSTO"
	ElseIf nMes == '09'
		cMes := "SETIEMBRE"
	ElseIf nMes == '10'
		cMes := "OCTUBRE"
	ElseIf nMes == '11'
		cMes := "NOVIEMBRE"
	ElseIf nMes == '12'
		cMes := "DICIEMBRE"
	EndIf
	
Return(cMes)
