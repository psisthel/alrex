#include "protheus.ch"
#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A085DEFS  �Autor  �Percy Arias,SISTHEL �Fecha �  09/20/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Lleva para la OP la modalidad de la factura de entrada     ���
���          �  para evitar redigitacion.                                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function A085DEFS()

	Local _xArea := getArea()
	
	cNatureza := SE2->E2_NATUREZ
	
	RestArea(_xArea)

Return