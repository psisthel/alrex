#include "protheus.ch"
#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LOCXPE35  �Autor  �Microsiga           � Data �  11/12/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � PE para mostrar la descripcion del produto en el momento   ���
���          � de jalar el remito de entrada                              ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LocxPE35
           
Local nPosCod := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_COD"})
Local nPosDesc:= ascan(aHeader,{|x| Alltrim(x[2]) == "D1_YDESCR"})     
Local cCod := ""
Local cCod := acols[len(acols),nPosCod]

	acols[len(acols),nPosDesc] := POSICIONE("SB1",1,XFILIAL("SB1")+cCod,"B1_DESC")  
	cCod  := acols[len(acols),nPosCod]     
		

return () 