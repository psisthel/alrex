#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FGETCLIE  �Autor  �Microsiga           � Data �  05/02/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna Array con informaciones del cliente                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FGETCLIE( clCodClie )

	Local alInfo	:= {}
	Local alAreaSA1	:= {}
	
	dbSelectArea("SA1")
	alAreaSA1 := SA1->( GetArea() )
	
	SA1->( dbSetOrder( 1 ) )
	SA1->( dbGoTop() )
	if SA1->( dbSeek( xFilial("SA1") + PADR( clCodClie, TAMSX3("A1_COD")[1]) ) )
	
		AADD(alInfo, SA1->A1_NOME )
		AADD(alInfo, SA1->A1_CGC )
		AADD(alInfo, SA1->A1_END )
		AADD(alInfo, SA1->A1_BAIRRO )
		AADD(alInfo, Posicione("SX5",1,xFilial("SX5")+"12 "+SA1->A1_EST,"X5_DESCSPA" ) ) 
		AADD(alInfo, SA1->A1_MUN )
		AADD(alInfo, SA1->A1_CEP )
		AADD(alInfo, SA1->A1_INSCR )
		AADD(alInfo, SA1->A1_TEL )
		AADD(alInfo, SA1->A1_CONTATO )
		AADD(alInfo, SA1->A1_EMAIL )
		AADD(alInfo, SA1->A1_COD )
		AADD(alInfo, SA1->A1_LOJA )
		AADD(alInfo, SA1->A1_TIPO )
	
	endif
	
	RestArea( alAreaSA1 )

Return alInfo
