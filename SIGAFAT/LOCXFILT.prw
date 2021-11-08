#include "protheus.ch"
#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LOCXFILT  �Autor  �Percy Arias,SISTHEL � Data �  07/31/19   ���
�������������������������������������������������������������������������͹��
���Desc.     � Filtra las guias de remision por pedido                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LOCXFILT()

	Local cAliasLocx	:= PARAMIXB[1]              
	Local cTipo      	:= PARAMIXB[2]
	Local cFiltroLocx	:= PARAMIXB[3] 
	local _aPergs		:= {}
	local _aRet			:= {}
	local _cPedIni		:= Space(6)
	local _cPedFin		:= "ZZZZZZ"
	Local _cstr			:= ""
	
	If cAliasLocx=="F2" .And. cTipo=="50/52"

		aAdd( _aPergs ,{1,"de Pedido",_cPedIni,"",,,,80,.F.})
		aAdd( _aPergs ,{1,"Hasta Pedido",_cPedFin,"",,,,80,.F.})
			
		if ParamBox(_aPergs ,"Alrex",_aRet)
			
			_cPedIni := _aRet[1]
			_cPedFin := _aRet[2]
			
			_cstr := " F2_YCOD >='" + _cPedIni + "' .AND. F2_YCOD <= '" + _cPedFin + "'"
			
		endif
		
	EndIf

Return( _cstr )
