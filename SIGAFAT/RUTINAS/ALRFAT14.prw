#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ALRFAT14  �Autor  �Microsiga           � Data �  08/26/19   ���
�������������������������������������������������������������������������͹��
���Desc.     � Lista de Precios - Retail                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ALRFAT14()

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������
	
	Local aIndex	:= {} 
	Local cFiltro	:= ""
	
	Private cCadastro := "Lista de Precios - Retail"
	Private aRotina := MenuDef()
	//Private cDelFunc := ".F."
	Private cString := "ZZ6"
	Private aCores := {}

	dbSelectArea("ZZ6")
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
