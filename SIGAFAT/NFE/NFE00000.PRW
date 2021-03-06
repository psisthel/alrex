#include "protheus.ch"
#INCLUDE "RWMAKE.CH"
#Include "TopConn.ch"
#INCLUDE "TBICONN.CH" 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NFE00000  �Autor  �Percy Arias,SISTHEL � Data �  07/03/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function NFE000(cCodSer)

	Local gArea		:= getArea()
	Local aCores	:=	{	{ 'Empty(SF2->F2_YHASH) .And. Empty(SF2->F2_YLOG)'	, 'ENABLE'		},;	// Factura Pendiente
							{ '!Empty(SF2->F2_YHASH) .And. Empty(SF2->F2_YLOG)'	, 'DISABLE'		},;	// Factura Enviada
							{ '!Empty(SF2->F2_YLOG)'							, 'BR_AZUL'		}}	// Factura Enviada
	Local aIndex	:= {} 
	private cFiltro	:= "SF2->F2_SERIE='"+cCodSer+"'"

	Private cCadastro 	:= "Documentos Electronicos - Facturas y/o Boletas" 
	Private aRotina 	:= MenuDef()
	Private bFiltraBrw	:= { || FilBrowse( "SF2" , @aIndex , @cFiltro ) } 

	Define font oFont Name "Arial" SIZE 16,20
		
	Eval( bFiltraBrw )
	
	mBrowse( 6, 1,22,75,"SF2",,,,,,aCores)
	//mBrowse( 6, 1, 22, 75, "SF2", , , , , , aCores, , , ,{|x| AutoRefresh(x)})

	EndFilBrw( "SF2" , @aIndex ) //Finaliza o Filtro 
	
	Set Key VK_F12 To
	
	restarea(gArea)
	
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NFE00000  �Autor  �Microsiga           � Data �  07/03/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MenuDef()  

	Local aRotina := {	{ "Buscar"			,"AxPesqui"  					,0	,1	,0	,.F.	}	,;	//"Pesquisar"
						{ "Visualizar"		,"AxVisual"						,0	,2	,0	,.F.	}	,;	//"Visualizar"
						{ "Transmitir"		,"u_EXENFE()"					,0	,6	,0	,.T.	}	,;	//"Incluir"
						{ "Log"				,"u_VERLOG(2)"					,0	,6	,0	,.T.	}	,;	//"Incluir"
						{ "Ver Pedido"		,"u_VERPED()"					,0	,6	,0	,.T.	}	,;	//"Incluir"
						{ "Imprimir PDF"	,"u_IMPPDF()"					,0	,6	,0	,.T.	}	,;	//"Incluir"
						{ "Leyenda"			,"u_FUSACLEY()"					,0	,6	,0	,.T.	}	 }	//"Leyenda"

Return(aRotina)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NFE00000  �Autor  �Microsiga           � Data �  07/03/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FUSACLEY()
     
    local _xArea := getArea()
	local aLegenda := {}

	aAdd(aLegenda,{"ENABLE" 	,"Factura Pendiente"})
	aAdd(aLegenda,{"DISABLE"	,"Factura Transmitida"})
	aAdd(aLegenda,{"BR_AZUL"	,"Error de Transmisi�n"})

	BrwLegenda("Documentos Electronicos","Leyenda", aLegenda )
	
	RestArea(_xArea)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NFE00000  �Autor  �Microsiga           � Data �  07/03/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function EXENFE

	local _lRet := u_NFE001( .F.,.F. )

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NFE00000  �Autor  �Microsiga           � Data �  07/12/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function VERPED()

	local aArea := GetArea()
	private Inclui    := .F. //defino que a inclus�o � falsa
	private Altera    := .T. //defino que a altera��o � verdadeira
	private nOpca     := 1   //obrigatoriamente passo a variavel nOpca com o conteudo 1
	private cCadastro := "Pedido de Vendas" //obrigatoriamente preciso definir com private a vari�vel cCadastro
	private aRotina := {} //obrigatoriamente preciso definir a variavel aRotina como private

	DbSelectArea("SC5") //Abro a tabela SC5
	SC5->(dbSetOrder(1)) //Ordeno no �ndice 1
	SC5->(dbSeek(xFilial("SC5")+SF2->F2_YCOD)) //Localizo o meu pedido
	If SC5->(!EOF()) //Se o pedido existe irei continuar
		SC5->(DbGoTo(Recno())) //Me posiciono no pedido
		MatA410(Nil, Nil, Nil, Nil, "A410Visual") //executo a fun��o padr�o MatA410
	Endif
	//SC5->(DbCloseArea()) //quando eu sair da tela de visualizar pedido, fecho o meu alias
	RestArea(aArea) //restauro a area anterior.
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NFE00000  �Autor  �Microsiga           � Data �  07/12/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function IMPPDF(lPerg,lNcc)

	//local cLinkPDF := alltrim(SF2->F2_YLINK)
	//ShellExecute( "Open", cLinkPDF, "", "C:\", 1 )

	Local cPerg := PADR("M486PDF",10)
	
	Default lPerg := .t.
	Default lNcc := .f.
	
	dbSelectArea("SX1")
	dbSetOrder(1)

	If dbSeek(cPerg+"01")
		SX1->( RecLock("SX1",.F.) )
		SX1->X1_CNT01 := iif(lNcc,SF1->F1_SERIE,SF2->F2_SERIE)
		SX1->( MsUnlock() )
	EndIf

	If dbSeek(cPerg+"02")
		SX1->( RecLock("SX1",.F.) )
		SX1->X1_CNT01 := iif(lNcc,SF1->F1_DOC,SF2->F2_DOC)
		SX1->( MsUnlock() )
	EndIf

	If dbSeek(cPerg+"03")
		SX1->( RecLock("SX1",.F.) )
		SX1->X1_CNT01 := iif(lNcc,SF1->F1_DOC,SF2->F2_DOC)
		SX1->( MsUnlock() )
	EndIf

	If dbSeek(cPerg+"04")
		SX1->( RecLock("SX1",.F.) )
		SX1->X1_PRESEL := 2
		SX1->( MsUnlock() )
	EndIf
	
	if !lPerg
		Pergunte(cPerg,lPerg)
		u_ALRFAT08(iif(lNcc,SF1->F1_ESPECIE,SF2->F2_ESPECIE))
		
	else
	
		If Pergunte(cPerg,lPerg)

			u_ALRFAT08(iif(lNcc,SF1->F1_ESPECIE,SF2->F2_ESPECIE))
			
		endif
		
	endif	
Return
