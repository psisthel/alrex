#include "protheus.ch"
#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ALRCTB01  �Autor  �ALREX IT            �Fecha �  09/05/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Amarracion de cuentas contables X Cuenta Destino           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ALREX                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User function ALRCTB01()

	Private cVldAlt := ".T."
	Private cVldExc := ".T."
	Private cString := "ZZZ"

	DbSelectArea("ZZZ")
	DbSetOrder(1)

	AxCadastro( cString ,"Cuentas Destino" , cVldAlt , cVldExc )

Return
