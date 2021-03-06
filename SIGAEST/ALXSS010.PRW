#INCLUDE "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ALXSS010  �Autor  �Microsiga           � Data �  02/07/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Consulta general de stock para usuarios en general         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ALRSS010

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������
	
	Local aIndex	:= {} 
	Local cFiltro	:= "SB1->B1_LOCAL == 'A01' .And. SB1->B1_TIPO='MP'"
	
	Private cCadastro := "Saldo Actual - Productos"
	Private aRotina := MenuDef()
	Private cDelFunc := ".F."
	Private cString := "SB1"
	Private aCores := {}
	Private bFiltraBrw	:= { || FilBrowse( "SB1" , @aIndex , @cFiltro ) } 
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	
	dbSelectArea(cString)
	mBrowse( 6,1,22,75,cString,,,,,,)
	
	EndFilBrw( "SB1" , @aIndex ) //Finaliza o Filtro 

Return

Static Function MenuDef()
               
	Local aRotina  :=	{	{	"Buscar","AxPesqui"		,0,1	} ,;
				 		{		"Consultar","U_LLAMAF4()"	,0,6	}	}

Return(aRotina)

User Function LLAMAF4

	Local cFilBkp := cFilAnt

	If FWModeAccess("SB1")=="E"
		cFilAnt := SB1->B1_FILIAL
	EndIf
	
	MaViewSB2(SB1->B1_COD)
	
	cFilAnt := cFilBkp

Return Nil
