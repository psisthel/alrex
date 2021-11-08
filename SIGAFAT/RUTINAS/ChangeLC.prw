#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CHANGELC  �Autor  �Percy Arias,SISTHEL � Data �  10/12/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Libera credito antes de la liberacion del PV por la condi- ���
���          � cion de pago E4_YCRED=S                                    ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ChangeLC( _cCodeCli, _cLojaCli, _cCondPag, _nOpx )

	local xArea	:= getArea()

	SA1->( dbSetOrder(1) )
	SE4->( dbSetOrder(1) )
	
	if SE4->( dbSeek( xFilial("SE4")+_cCondPag ) )
		
		if SE4->E4_YCRED=="S"
	
			if SA1->( dbSeek( xFilial("SA1")+_cCodeCli+_cLojaCli ) )
			
				SA1->( RecLock("SA1",.f.) )
				if _nOpx==1
					SA1->A1_YRISCO	:= SA1->A1_RISCO
					SA1->A1_RISCO	:= "A"
				else
					SA1->A1_RISCO	:= SA1->A1_YRISCO
					SA1->A1_YRISCO	:= ""
				endif
				SA1->( MsUnLock() )
			
			endif
			
		endif
	
	endif
	
	restArea( xArea )

Return Nil