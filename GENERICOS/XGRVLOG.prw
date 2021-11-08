#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �XGRVLOG   �Autor  �Microsiga           �Fecha �  03/12/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function XGRVLOG( cArq, cTexto, llWrap, lUpp )

	Local nHandle := 0
	Default llWrap := .F.
	Default lUpp := .t.
	
	/*
	cDrive := ""
	cDir := ""
	cNome:=""
	cExt:=""

	SplitPath( cArq, @cDrive, @cDir, @cNome, @cExt )

	cNovArq := cDrive+cDir+Upper(cNome)+cExt
	*/
	
	If !File( cArq )
		nHandle := FCreate( cArq,Nil,Nil,lUpp )
		FClose( nHandle )
	Endif
	
	If File( cArq )
		nHandle := FOpen( cArq, 2 )
		FSeek( nHandle, 0, 2 )	// Posiciona no final do arquivo
		FWrite( nHandle, cTexto + iif(llWrap, Chr(13) + Chr(10), Space(2) ), Len(cTexto)+ iif(llWrap, 2, 0) )
		FClose( nHandle) 
	Endif
	
Return
