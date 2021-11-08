#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M410STTS  �Autor  �Microsiga           � Data �  04/25/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Imprime el P.V. para el cliente                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function M410STTS

	local _aArea := getArea()
	local lCustom := .f.
	
	if INCLUI

		SC6->( dbSetOrder(1) )
		if SC6->( dbseek( xFilial("SC6")+SC5->C5_NUM ) )
		
			While xFilial("SC6")+SC6->C6_NUM==xFilial("SC5")+SC5->C5_NUM .And. SC6->( !eof() )

				if !empty(SC6->C6_YSTRUCT)
					lCustom := .t.
					exit
				endif

				SC6->( dbSkip() )

			enddo
		
		endif

		if lCustom
			u_ALRFAT01(1)
		else
			u_ALRFAT01(2)
		endif

	endif
	
	RestArea(_aArea)

Return