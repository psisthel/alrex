#include "protheus.ch"
#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA651FIL  �Autor  �Percy Arias,SISTHEL � Data �  07/03/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Filtro en la OP Prevista para buscar pedidos de venta      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA651FIL

	local _aArea	:= getArea()
	local _cString	:= PARAMIXB[1]
	local _cPerg	:= "ALREST01"
	local _aMvPar	:= {}
	local _nMv		:= 0
	
	For _nMv := 1 To 40
   		aAdd( _aMvPar, &( "MV_PAR" + StrZero( _nMv, 2, 0 ) ) )
	Next _nMv

	if Pergunte(_cPerg,.t.)
		_cString := _cString + " .And. C2_PEDIDO >= '" + mv_par01 + "' .And. C2_PEDIDO <= '" + mv_par02 + "'"
	endif

	For _nMv := 1 To Len( _aMvPar )
	   &( "MV_PAR" + StrZero( _nMv, 2, 0 ) ) := _aMvPar[ _nMv ]
	Next _nMv
	
	RestArea( _aArea )	

Return( _cString )