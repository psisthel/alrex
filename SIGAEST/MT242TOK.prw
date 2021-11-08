#INCLUDE "rwmake.ch"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT242TOK  �Autor  �Percy Arias, SISTHEL� Data �  01/09/20   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida cantidad informada en el encabezado X itens         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT242TOK

	local nX := 0
	local nPosQ := aScan(aHeader,{|x| AllTrim(x[2]) == "D3_QUANT" })
	local nsum := 0            
	local lret := .t.
	local nPosDelet	:= Len( aHeader ) + 1
	
	for nX := 1 to len(aCols)
		If !aCols[nX][nPosDelet]
			nsum += aCols[nX][nPosQ]
		endif
	next nX
	
	if nQtdOrig<>nsum
		lret := .f.
	endif
	
	if !lret
		alert("Suma de los itens no coincide con la cantidad informada!")
	endif

Return(lret)