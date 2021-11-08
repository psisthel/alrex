#INCLUDE "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ALXCOM01  �Autor  �Microsiga           � Data �  02/15/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Maestro de Tipos de Renta No Domiciliados                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ALXCOM01()

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������
	
	Local aIndex	:= {} 
	Local cFiltro	:= ""
	
	Private cCadastro := "Tipos de Renta No Domiciliados"
	Private aRotina := MenuDef()
	//Private cDelFunc := ".F."
	Private cString := "ZZI"
	Private aCores := {}

	dbSelectArea("SB1")
	dbSetOrder(1)
	
	dbSelectArea(cString)
	mBrowse( 6,1,22,75,cString,,,,,,)
	
Return

Static Function MenuDef()
               
	aRotina := { 	{ "Buscar","AxPesqui"   	, 0, 1},;				
					{ "Visualizar","AxVisual"  	, 0, 2},;
					{ "Incluir","AxInclui"		, 0, 3},;     
					{ "Alterar","AxAltera"		, 0, 4},;				
					{ "Excluir","AxDeleta"		, 0, 5} }

Return(aRotina)
