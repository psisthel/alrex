#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M469ITEM  �Autor  �Percy Arias,SISTHEL � Data �  09/18/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � verifica si existen RA ja generados y no deja anular la    ���
���          � liberacion del pedido                                      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function M469ITEM

	local _cArea	:= getArea()
	local _lRet		:= .t.
	local _cNumPed	:= TRB->PEDIDO
	
	ZZW->( dbSetOrder(1) )
	if ZZW->( dbSeek( xFilial("ZZW")+_cNumPed ) )
	
		if ZZW->ZZW_STATUS=="1"
			//alert("�Existen documentos financieros de adelantos (RAs) vinculados a este pedido, anule los RAs y retorne a esta rutina!")
			MsgInfo("�Existen documentos financieros de adelantos (RAs) vinculados a este pedido, el sistema anulara la liberaci�n del PV. !","ALREX")
			//_lRet := .f.
		endif
	
	endif
	
	RestArea(_cArea)

Return( _lRet )