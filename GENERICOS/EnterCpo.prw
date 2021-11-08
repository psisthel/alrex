#Include "Rwmake.ch"
#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ENTERCPO  �Autor  �Microsiga           � Data �  03/27/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function EnterCpo(cCampo,ValorDoCampo,n)

	Local aArea    := GetArea()
	Local cVarAtu  := ReadVar()
	Local lRet     := .T.
	Local cPrefixo := "M->"
	Local bValid
	
	//������������������������������������������������������������������������������������������Ŀ
	//� A variavel __ReadVar e padrao do sistema, ela identifica o campo atualmente posicionado. �
	//� Mude o conteudo desta variavel para disparar as validacoes e gatilhos do novo campo.     �
	//� Nao esquecer de voltar o conteudo original no final desta funcao.                        �
	//��������������������������������������������������������������������������������������������
	__ReadVar := cPrefixo+cCampo
	 
	//�����������������������������������������������������Ŀ
	//� Valoriza o campo atual "Simulado".                  �
	//�������������������������������������������������������
	&(cPrefixo+cCampo) := ValorDoCampo
	 
	//�����������������������������������������������������Ŀ
	//� Carrega validacoes do campo.                        �
	//�������������������������������������������������������
	SX3->( dbSetOrder(2) )
	SX3->( dbSeek(cCampo) )
	bValid := "{|| "+IIF(!Empty(SX3->X3_VALID),Rtrim(SX3->X3_VALID)+IIF(!Empty(SX3->X3_VLDUSER),".And.",""),"")+Rtrim(SX3->X3_VLDUSER)+" }"
	 
	//�����������������������������������������������������Ŀ
	//� Executa validacoes do campo.                        �
	//�������������������������������������������������������
	lRet := Eval( &(bValid) )
	 
	IF lRet
	 //�����������������������������������������������������Ŀ
	 //� Executa gatilhos do campo.                          �
	 //�������������������������������������������������������
	 SX3->(DbSetOrder(2))
	 SX3->(DbSeek(cCampo))
	 IF ExistTrigger(cCampo)
	  RunTrigger(2,n)
	 EndIF
	EndIF
	 
	//�����������������������������������������������������Ŀ
	//� Retorna __ReadVar com o valor original.             �
	//�������������������������������������������������������
	__ReadVar := cVarAtu
	 
	RestArea(aArea)
	
Return(lRet)
