#INCLUDE "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M468MKB   �Autor  �Percy Arias,SISTHEL � Data �  07/04/19   ���
�������������������������������������������������������������������������͹��
���Desc.     � Filtra por el nro del pedido de venta al generar la        ���
���          � factura                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function M468MKB

	local _cId		:= PARAMIXB[1]
	local _cstr		:= ""
	local _aPergs	:= {}
	local _aRet		:= {}
	local _cPedIni	:= Space(TamSX3("C5_NUM")[1])
	local _cPedFin	:= "ZZZZZZ"
	
	if _cId=="Q"
	
		aAdd( _aPergs ,{1,"de Pedido",_cPedIni,"",,,,80,.F.})
		aAdd( _aPergs ,{1,"Hasta Pedido",_cPedFin,"",,,,80,.F.})
			
		if ParamBox(_aPergs ,"Alrex",_aRet)
			
			_cPedIni := _aRet[1]
			_cPedFin := _aRet[2]
			
			_cstr := " AND D2_PEDIDO BETWEEN '" + _cPedIni + "' AND '" + _cPedFin + "'"
			
		endif
	
	endif

Return( _cstr )