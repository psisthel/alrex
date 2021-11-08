#include "protheus.ch"
#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LXDORIG   �Autor  �Percy Arias,SISTHEL � Data �  12/01/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Adiciona el codigo del producto en la nota de credito      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � FUSAC - Peru                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LXDORIG

	Local nLinaCols	:= Len(aCols)
	Local nPosDesc	:= AScan( aHeader, { |x| AllTrim( x[2] ) == "D1_YDESCR" } )
	Local nPosCod	:= AScan( aHeader, { |x| AllTrim( x[2] ) == "D1_COD" } )
	
	aCols[nLinAcols][nPosDesc] := Posicione("SB1",1,xFilial("SB1")+aCols[nLinAcols][nPosCod],"SB1->B1_DESC")

Return