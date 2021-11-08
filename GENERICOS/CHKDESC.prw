#include "RwMake.ch"
#Include "Protheus.ch"
#define CRLF chr(13)+chr(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CHKDESC   �Autor  �Microsiga           � Data �  04/03/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica porcentaje maximo de descuentos para el cliente   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function VALDDSC()

	local _aArea	:= getArea()
	local _nMaxDsc	:= GetNewPar("AL_DESMAX",5)
	local _lRet		:= .f.
	local _aPergs	:= {}
	local _cCodAdm	:= space(50)
	local _cPswAdm	:= space(50)
	local _aRet		:= {}
	local aPswDet	:= {}
	local aUsrSup	:= StrTokArr( alltrim(GetMV("AL_USRSUPE")), "|" )
	local nX		:= 0
	local lCont		:= .f.
	
	if M->C6_DESCONT > _nMaxDsc

		if MsgBox("Descuento NO permitido, maximo permitido de "+alltrim(str(_nMaxDsc))+"%"+CRLF+"�Desea informar la contrase�a del administrador para continuar?", "ALREX", "YESNO")
	
			aAdd( _aPergs ,{1,"Usu�rio Superior: ",_cCodAdm,"",,,,80,.F.})
			aAdd( _aPergs ,{8,"Se�a Superior: ",_cPswAdm,"",,,,80,.F.})
			
			if ParamBox(_aPergs ,"Alrex",_aRet)
			
				_cCodAdm := _aRet[1]
				_cPswAdm := _aRet[2]

				for nX := 1 to len(aUsrSup)
					if alltrim(aUsrSup[nX]) == alltrim(_cCodAdm)
						lCont := .t.
						exit
					endif
				next nX
				
				if lCont
				
					PswOrder(2)
					if PswSeek( _cCodAdm, .T. )  
						aPswDet := PswRet()
					endif
				
					if Len(aPswDet) > 0
						if PswName(_cPswAdm)
							_lRet := .t.
						endif
					endif
				
				endif
		
			endif		
			
		endif
	
	else
		_lRet := .t.
	endif
	
	RestArea(_aArea)
	
	/*
	if !_lRet
		alert("Usuario y/o contrase�a invalidas, por favor tente nuevamente!")
	endif
	*/

Return( _lRet )