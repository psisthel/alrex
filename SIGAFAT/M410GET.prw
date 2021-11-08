#include "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Function  �M410GET   � Autor �Percy Arias,SISTHEL    � Date � 17.07.18 ���
�������������������������������������������������������������������������Ĵ��
���Descript. �Punto de Entrada que actualiza el campo especifico de precio���
�������������������������������������������������������������������������Ĵ��
��� Use      �ALREX - Peru                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function M410GET()

	local lRet		:= .T.
 	local aArea		:= getArea()
	local nPosDelet	:= Len( aHeader ) + 1
	local nlPosPrc	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRUNIT" })
	local nlPrecio	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_YPRECIO" })
	local nX		:= 0

	For nX := 1 To Len( aCols )
		If !aCols[nX][nPosDelet]
			aCols[nX][nlPrecio] := aCols[nX][nlPosPrc]
		EndIf
	Next

	Restarea(aArea)
	
Return(lRet)
