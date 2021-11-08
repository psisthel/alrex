#Include "Rwmake.ch"
#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LOCXVLDDEL�Autor  �Percy Arias,SISTHEL � Data �  02/17/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Integracion para el borrado de las facturas de entrada y   ���
���          � las transferencias de sucursales                           ���
�������������������������������������������������������������������������͹��
���Uso       � FUSAC - Peru                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LOCXVLDDEL

	Local _aArea			:= GetArea()
	Local _lRet				:= .t.
	Local cUsrNoPermision	:= GetMv("AL_USRDOC")
	local dEmissao 			:= ctod(space(8))
	local dFechaActual 		:= date()
	local nDias 			:= 0
	Local nPlazo			:= GetNewpar("AL_PLAZO",7)
   
	If Alltrim(FUNNAME())$"MATA462N|MATA467N|MATA465N"	// guia de remision manual o factura manual
	
		If Alltrim(cUserName)$cUsrNoPermision
			Alert("�Usuario sin permiso para borrar documentos fiscales!")
			_lRet := .f.
		Endif

 		if Alltrim(FUNNAME())=="MATA467N"
			dEmissao := M->F2_EMISSAO
			nDias := DateDiffDay( dEmissao , dFechaActual )
		endif
	
	EndIf
	
	RestArea(_aArea)
	
	if nDias > nPlazo
		_lRet := .f.
		Alert("Documento NO puede ser anulado, la fecha de emision ultrapaso los "+alltrim(str(nPlazo))+" dias autorizados por SUNAT. Genere una Nota de Credito")
	endif
	
Return(	_lRet )
