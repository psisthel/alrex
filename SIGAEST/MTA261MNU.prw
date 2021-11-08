#INCLUDE "rwmake.ch"    
#Include "protheus.ch"          

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA261MNU �Autor  �Microsiga           � Data �  03/05/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Adiciona item de menu para re-impresion del comprobante    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MTA261MNU()

	Aadd( aRotina, {"Imprime Comprobante", 'u_xImpNow', 0 , 8,0,.F.} )

Return

User Function xImpNow()
	U_ALRP01A( SD3->D3_FILIAL, SD3->D3_DOC, SD3->D3_TM )
Return
