#INCLUDE "rwmake.ch"    
#Include "protheus.ch"          
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA261TRD3 �Autor  �ALREX	           �Fecha �  201801     ���
�������������������������������������������������������������������������͹��
���Desc.     � Llama la rutina de impresion de comprobante de movimiento  ���
���          � al finalizar la grabacion                                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION MA261TRD3()

	Local _aArea	:= getArea()
	Local aRecSD3	:= PARAMIXB[1]

	SD3->(DbGoto(aRecSD3[1][1])) // Requisicao RE4
	
	//If Alltrim(FunName())=="MATA311"
		U_ALRP01A( SD3->D3_FILIAL, SD3->D3_DOC, SD3->D3_TM )
	//Else
		//U_ALRP01A( SD3->D3_FILIAL, SD3->D3_DOC, SD3->D3_TM )
		//U_ALRP001( SD3->D3_FILIAL, SD3->D3_DOC, SD3->D3_TM )
	//EndIf
	
	RestArea(_aArea)
Return
