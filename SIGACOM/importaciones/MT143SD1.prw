#include "TOTVS.CH"
#Include "Rwmake.ch"
#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT143SD1  �Autor  �Percy Arias,SISTHEL � Data �  03/20/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT143SD1()

	Local _aArea	:= GETAREA()
	Local _aRetSD1	:= ParamIXB[1]
	Local _cDirec	:= DBC->DBC_YDIREC
    
    aAdd( _aRetSD1[Len(_aRetSD1)] , {"D1_LOCALIZ" , _cDirec , Nil})

	RestArea(_aArea)
	
Return(_aRetSD1)