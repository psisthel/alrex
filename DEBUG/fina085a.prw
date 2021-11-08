#include "protheus.CH"        // incluido pelo assistente de conversao do AP5 IDE em 09/09/99
#include "FINA085A.CH"

//Posicoes do Array  ASE2
#DEFINE _FORNECE  1
#DEFINE _LOJA     2
#DEFINE _VALOR    3
#DEFINE _MOEDA    4
#DEFINE _SALDO    5
#DEFINE _SALDO1   6
#DEFINE _EMISSAO  7
#DEFINE _VENCTO   8                                             	
#DEFINE _PREFIXO  9
#DEFINE _NUM     10
#DEFINE _PARCELA 11
#DEFINE _TIPO    12
#DEFINE _RECNO   13
#DEFINE _RETIVA  14
#DEFINE _RETIB   15
#DEFINE _NOME    16
#DEFINE _JUROS   17
#DEFINE _DESCONT 18
#DEFINE _NATUREZ 19
#DEFINE _ABATIM  20
#DEFINE _PAGAR   21
#DEFINE _MULTA   22
#DEFINE _RETIRIC 23
#DEFINE _RETSUSS 24
#DEFINE _RETSLI  25
#DEFINE _RETIR   26
#DEFINE _RETIRC  27 //Portugal
#DEFINE _RETISI  28
#DEFINE _RETRIE  29 //Angola
#DEFINE _RETIGV  30 //PERU
#DEFINE _CBU     31 //Controle de CBU - Argentina
#DEFINE _NRCHQ   32 //EQUADOR


#DEFINE _CAJAME  33 //CAJAME
#DEFINE _SERORI  34
#DEFINE _CPR     35
#DEFINE _TXMOEDA 36 //Taxa da moeda do t�tulo - Peru
#DEFINE _FILORIG 37
#DEFINE _FILIAL  38
#DEFINE _ELEMEN  38 //indica o tamanho para o array ase2

//Posicoes do ListBox

#DEFINE H_OK		1
#DEFINE H_FORNECE	2
#DEFINE H_LOJA    	3
#DEFINE H_NOME    	4
#DEFINE H_NF      	5
#DEFINE H_NCC_PA  	6
#DEFINE H_TOTAL 	7

//ARG
#DEFINE H_RETGAN	8
#DEFINE H_RETIB 	10
#DEFINE H_RETSUSS	11
#DEFINE H_RETSLI 	12
#DEFINE H_RETISI	13
#DEFINE H_CBU		14
#DEFINE H_CAJAME	21
#DEFINE H_CPR		22
//URU
#DEFINE H_RETIRIC   8 //Mesma posicao que as Ganancias pq so eh utilizado no Uruguai.
#DEFINE H_RETIR    11 //Mesma posicao que as SUSS pq so eh utilizado no Uruguai.
// INI Portugal
#DEFINE H_RETIRC    8 //Mesma posicao que as Ganancias pq so eh utilizado EM portugal.
#DEFINE H_RETIVA    9 //ARG Tambem
#DEFINE H_DESPESAS 10
//FIM PORTUGAL
//ANGOLA
#DEFINE H_RETRIE    8 //A confirmar - Posicao do imposto RIE de Angola
//Fim Angola
//PERU
#DEFINE H_RETIGV    8 //A confirmar - Posicao do imposto IGV DO PERU
//Fim PERU

#DEFINE H_TOTALVL 	15
#DEFINE H_PORDESC 	16
#DEFINE H_TOTRET 	17
#DEFINE H_DESCVL 	18
#DEFINE H_EDITPA  	19
#DEFINE H_VALORIG  	20
#DEFINE H_MULTAS    21

#DEFINE _PA_VLANT  01
#DEFINE _PA_MOEANT 02
#DEFINE _PA_VLATU  03
#DEFINE _PA_MOEATU 04
Static 	nPosTipo,nPosTpDoc,nPosMoeda,nPosNum,nPosBanco,nPosAge,nPosConta,nPosEmi,nPosVcto,nPosVlr,nPosParc
Static lA085aTit,lA085aRet
Static cAgente,nMVCUSTO
Static nDel :=0
Static lF085aChS := ExistBlock("F085aChS") .and. ExecBlock("F085aChS",.F.,.F.)
Static lFWCodFil := FindFunction("FWCodFil")
STATIC lMod2	 := FindFunction("FinModProc")
Static lF085aBPg
Static __lF085VLNAT
Static _cTipo	:= ""  
Static nDescOP := 0
// TRADUCAO DE CH'S PARA PORTUGAL

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � FINA085A � Autor � Bruno Sobieski         � Data � 23.02.99 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Generar Retensi�n de Impuestos y Calcular Gan�ncias para    ���
���          � las facturas de Compras. (AutomaTica)                       ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Cobranzas                                                   ���
��������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      ���
��������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR    � DATA   � BOPS �  MOTIVO DA ALTERACAO                  ���
��������������������������������������������������������������������������Ĵ��
���Jose Aurelio    �21/11/01�11106 �Ajuste do ponto de entrada a085DEFS pa-���
���                �        �      �ra que o mesmo trate o parametro "4".  ���
���                �        �      �Dessa forma, esse ponto podera ser usa-���
���                �        �      �do em DEFINE'S com Ordens de Pagamento ���
���Jose Aurelio    �27/11/01�11714 �Desabilitacao do teste para, se SE2 for���
���                �        �      �vazio, nao permite acesso aos cadastros���
���Paulo Augusto   �17/07/02�QNC   �Substituida a Indregua pela FilBrowse  ���
���                �        �      �para que seja possivel tirar o filtro  ���
���                �        �      �na pesquisa dos titulos de abatimento, ���
���                �        �      �para que os mesmos sejam baixados      ���
���C. Denardi      �23/09/03�66.814�Filtrar titulos que nao foram liberados���
���                �        �      �pela rotina FINA580 e quando o parame- ���
���                �        �      �tro MV_CTLIPAG = .T.                   ���
���Dixon           �24/11/04�      �Inclusao de FT no filtro.              ���
���                  �        �      �                                      ���
���Wagner Montenegro *08/06/10�      �Add campo Natureza e grava��o no SE2  ���
���  Adicionado consistencia na sele��o de bancos X forma de pago.          ���
���  Adicionado consistencia na tributa��o de ITF X bancos.                 ���
���  Adicionado consistencia na sele��o de titulos X Natureza(Incidencia ITF)���
���M. Camargo      �18/04/13�THCETX�Modificaci�n de la funci�n CalcRetIB   ���
���				   �        �      �para que considere todos los           ���
���                �        �      �registros del proveedor de la SFH      ���
���M. Camargo      �07/05/13�TF2479�Se agrega c�lculo 4xmil Para colombia  ���
���				   �        �      �cuando es debido diferido y acredita-  ���
���                �        �      �ci�n inmediata.                        ���
���M. Camargo      �23/05/13�THKCZR�Modificaci�n de la funci�n CalcRetIva  ���
���				   �23/05/13�THKCZR�para que considere el % de exenci�n de IVA���
���L Samaniego     �17/01/14�THKIIM�Modificacion en la funcion CalcRetIVA  ���
���                �        �      �para la exencion de IVA                ��� 
���Laura Medina    �21/01/14�TIAGWQ�Se modifico el calculo de la retencion ���
���                �        �      �cuando sea necesario desglosar la aliq ���
���                �        �      �por separado (SFF).                    ���
���EMANUEL V.V.    �13/02/14�THKIIM�Correcci�n en la funcion CalcRetIVA    ���
���                �        �      �para la exencion de IVA                ���
���Laura Medina    �26/02/14�TIHNR4�Se agrego un PE FI85ATCH para agregar  ���
���                �        �      �columnas en la venta "Elija el Cheque" ���
���                �        �      �en Pago Diferenciado.                  ���
���Alfredo Medrano �06/09/16�TWFLBM�Se agrega registro PA en SE2 cuando es ���
���                �        �      �Anticipo en func Fa085Grava.           ���  
���                �        �      �En func FA085SE2 Valida Anticipo en    ���
���                �        �      �Pago Autom�tico. En Func Fa085Tela si  ���
���                �        �      �es Anticipo se llena campo Modalidad   ���
���                �        �      �En func a085aPagos se valida que la    ���
���                �        �      �opci�n Pago Especial no este disponible���
���                �        �      �para anticipos.                        ���
���                �        �      �Los campos E2_NUM y E2_PREFIXO se llena���
���                �        �      �con los campos correspondientes a Fac. ���
���                �        �      �Anticipo. fVerifImp obtiene el impuesto���
���                �        �      �de la Fac.Anticipo fRetParcel obtiene  ���
���                �        �      �consecutivo para Parcela MEX           ���
���                �        �      �No permita seleccionar registros tipo  ���
���                �        �      �t�tulo PA con modalidad informada donde���
���                �        �      �el ED_OPERADT=SI en Func a085aMark MEX ���
���Jonathan Glez   �14/12/16�SERINN001�Elimina funciones FA085vlna, ajusaSx1,  ���
���                �        �     -486�acertasx1, ajustasx3, fa085tudoOk y se  ���
���                �        �         �eliminan los funciones de PUTHELP.      ���
���Alf. Medrano    �31/01/17� MMI-4859�Merge 12.1.07 vs 12.1.14                ���
���  Marco A. Glz  �27/04/17� MMI-194 �Se replica llamado(TWG704 - V11.8),     ���
���                �        �         �Visualizar correctamente campo Modalidad���
���                �        �         �en Orden de Pago, al existir punto      ���
���                �        �         �de entrada A085ALNA. (MEX)              ���
���Ivan Gomez      �01/11/17�DMICNS   �Se agrega la validaci�n correcta para   ���
���                �        �-128     � que tome el valor SE2->E2_FILORIG en   ���
���                �        �         � el campo SE5->E5_FILORIG cuando se     ���
���                �        �         �realice la grabaci�n de la ord de pag   ���
���M.Camargo       �11/04/18�DMINA-761�Func. AaddSE2: Se modifica valor de tasa���
���                �        �         �de la moneda, cambio en llenado de array���
���                �        �         �aSE2 _TXMOEDA(PER).                     ���
���                �        �         �Se modifica la conversion de la tasa    ���
���                �        �         �para los documentos tipo TX, en las     ���
���                �        �         �Ordenes de Pago. El cambios se realiza  ���
���                �        �         �en la funcion AddSE2(). (PER)           ���
���                �        �         �Se agrega funcionalidad para poder com- ���
���                �        �         �pensar titulos entre filiales. se crea  ���
���                �        �         �la variable lConsFilial  y se modifica  ���
���                �        �         �la funci�n Fa085Grava para posicionarse ���
���                �        �         �en el titulo de la manera correcta.MEX  ���
���M.Camargo       �14/07/18�DMINA-   �Grabar valor en campo SFE->FE_SERIE2    ���
���                �        �3376     �a partir del par�metro MV_CRSERIE para  ���
���                �        �         �PERU.                                   ���
���M.Camargo       �15/10/18�DMINA-   �En Fun Fa085AtuVl, dentro del c�lculo de���
���                �        �4552     �total de orden de pago se redondea el   ���
���                �        �         �valor de la NF MEX.                     ���
���Alf. Medrano    �07/11/18�DMINA-   �En fun fa085Grava se asigna fil origen  ���
���                �        �         �para descuentos, multas y intereses.    ���
���                �        �         �en Fun GravaPagos se asigna fil origen  ���
���                �        �         � para asignar a los pagos  MEX.         ���
���Oscar G.        �19/12/18�DMINA-   �En Fun Fa085Alt se omite la alteracion  ���
���                �        �5269     �de los val. a partir de un array temp.  ���
���Ver�nica Flores �12/02/19�DMINA-   �Se realiza replica de DMINA-4053 v12.1.7���
���                �        �5451     �En fun Fina085a se activa var lUUI si   ���
���                �        �  	      �campo EK_UUID existe.En fun A085ApgAut  ���
���                �        �     	  �se asigna valor a campo EK_UUID cuando  ���
���                �        �         �es TB y PA.En fun GravaPagos se asigna  ���
���                �        �         �valor a campo EK_UUID cuando es CT y CP ���
���                �        �         �En fun Fa085Tela agrega campo EK_UUID   ���
���                �        �         �a encabezado de la Orden Pag. En fun    ���
���                �        �         �Fa085Alt en modif. de la Orden Pag se   ���
���                �        �         �asigna campo F1_UUID al encabezado del  ���
���                �        �         �detalle y se asigna informaci�n. MEX    ���
���                �        �         �En Fun A085ApgAut se asigna a __cUUID   ���
���                �        �         �la longitud de campo EK_UUID solo si el ���
���                �        �         �campo existe. MEX                       ���
���M. Camargo      �23/05/13�DMINA-   �Modificaci�n de la funci�n Fa085Grv     ���
���                �        �6478     �para que considere guardar campo E2_FIL-���
���                �        �         �ORIG.                                   ���
���Oscar G.        �05/02/20�DMINA-   �En FA085Alt() se valida aTits por error ���
���                �        �8024     �log, en a085FldOk1() se modifica calculo���
���                �        �         �del valor cuando se agrega descuento, en���
���                �        �         �Fa085AtuVl() se abre tratamiento para NF���
���                �        �         � y localizacion para PER. (PER)         ���
���Eduardo Perez   �06/02/20�DMINA-   �Modificaci�n de la funci�n Fa085Tela    ���
���                �        �7987     �para guardar el pais del proveedor y que���
���                �        �         �realice la validacion del pais de forma ���
���                �        �         �correcta                                ���
���Eduardo Perez   �08/04/20�DMINA-   �Modificaci�n de la funci�n Fa085AtuVl   ���
���                �        �8495     �para mostrar mensaje al usuario en      ���
���                �        �         �de que la moneda selecciona para el pago���
���                �        �         �no cuente con tipo de cambio del dia    ���
���Oscar G.        �05/02/20�DMINA-   �En A085APgAut() se si titulo tiene blo- ���
���                �        �8705     �queo por calendario contable. (MEX)     ���
���Jos� Gonz�lez   �12/05/20�DMINA-   �Se agrega validaci�n en la funci�n      ���
���                �        �8992     �AtuaSaldos para cuando el valor a pagar ���
���                �        �         �sea 0 no se realice actualizaci�n(COL)  ���
��� Marco A. Glez  �28/05/20�DMINA-   �Se agrega el grabado del campo EK_MSFIL ���
���                �        �9118     �en los movimentos realizados en la tabla���
���                �        �         �SEK (Filial Origen) - MEX               ���
���Oscar G.        �27/05/20�DMINA-   �Se crea Fun. a085VldDsc() para manejo de���
���                �        �9028     �descuentos globales, en fun. Fa085Alt se���
���                �        �         �corrige ventana de Modificar. (COL)     ���
���Alf. Medrano    �03/07/20�DMINA-   �Se modifica la fun Fa085AtuVl d�nde se  ���
���                �        �9446     �corrige c�lculo de conversi�n de monedas���
���                �        �         �(PER)                                   ���
���Jos� Gonz�lez   �01/07/20�DMINA-   �Se agrega el guardado  campo EK_NATUREZ ���
���                �        �8935     �en la funci�n a085aGravRet(PER)         ���
���Eduardo Prez    �12/08/20�DMINA-   �Se modifica la fun Fa085Tela d�nde se   ���
���                �        �9530     �realiza la conversion del total a pagar ���
���                �        �         �usando el tipo de cambio del dia(PER)   ���
���Oscar G.        �14/09/20�DMINA-   �Se ajusta conversion de monedas en fun. ���
���                �        �10068    �Fa085AtuVl(), se ajusta comportamiento  ���
���                �        �         �de descuentos en fun. a085FldOk1().(PER)���
���Cristian Franco �14/09/20�DMICNS-  �Se modifica la funcion Fa085Tela localiz���
���                �        �9286     �aci�n ya que no mostraba correctamente  ���
���                �        �         �los montos en el encabezado de OP       ���
���Ver�nica Flores �04/02/21�DMINA-   �Se modifica la funcion Fa085AtuVl donde ���
���                �        �10929    �realiza la conversi�n de la retenci�n   ���
���                �        �         �IR (PER).                               ���
���Luis Enr�quez   �13/02/21�DMINA-   �Se elimina validaci�n de cheques para   ���
���                �        �10663    �realiza la conversi�n de la retenci�n   ���
���Ver�nica Flores �26/02/21�DMINA-   �Se modifica el uso de la tasa en las    ���
���                �        �11055    �detracciones "TX" sea usado el TC del   ���
���                �        �         �documento (PER).                        ���
��� Marco A. Glez  �17/04/21�DMINA-   �Se utiliza la posicion del tipo de titu-���
���                �        �    12006�en el array para determinar el tipo de  ���
���                �        �         �documento (PER).                        ���
���Diego Rivera    �28/04/21�DMINA-   �Replica de DMINA-10663 para Ecuador     ���
���                �        �11808    �Se elimina validaci�n de cheques para   ���
���                �        �         �realizar la conversi�n de la retenci�n  ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
Function Fina085A()
//Declaracao de variaveis  usadas na indregua
Local lLibTit	:= SuperGetMv("MV_CTLIPAG") // Alteracao conforme BOPS 66.814
Local cPagaveis	:=	""
Local cFltUsr	:=	""
Local cPerg		:= "FIN85A"
Local aLockSE2, nAux
Local cFilt		:= ""
Local cQuery    := ""
Local nA		:= 0
Local aHelpEsp:={}
Local aHelpPor:={}
Local aHelpEng:={}
Local aCores := { { 'Empty(E2_BAIXA) .and. E2_SALDO == E2_VALOR' ,"BR_VERDE" },;
				  { 'E2_SALDO + E2_SDACRES > 0 .and. E2_SALDO <> E2_VALOR'	 ,"BR_AZUL"  },;
				  { '!Empty(E2_BAIXA) .and. E2_SALDO == 0'		 ,"BR_VERMELHO" },;
				  { '!Empty(E2_NUMBOR)'							 ,"BR_PRETO" },;
				  { 'E2_TIPO == "'+MVPAGANT+'" .and. ROUND(E2_SALDO,2) > 0',"BR_BRANCO" },;
				  { '!Empty(E2_NUMBOR) .and. E2_SALDO > 0 .and. E2_SALDO <> E2_VALOR',"BR_CINZA" } }

Private cIndex,cKey,cCondicao, cChave,nIndex
Private lBxParc := Iif(SE2->(FieldPos("E2_VLBXPAR")>0),.T.,.F.)
Private aRatCond:={}
//Declaracao de variaveis Multimoeda
Private cMoedaTx,nC	:=	MoedFin()

//Declaracao de variaveis onde serao carregadas as perguntas
Private dDatade,dDataAte,cForDe,cForAte,cBcoChq,cAgeChq,cCtaChq,nCondAgr
Private nMoedChq,nDiasChq,nLimite,lFiltra,lDigita,lAglutina,lGeraLanc
Private lConsFilial

//Declaracao de variaveis Multimoeda
Private aTxMoedas	:=	{}
Private cMarcaE1	:=	GetMark()
Private cMarcaE2

//Declaracao das variaveis integracao contabil
Private cArquivo   := ""
Private nHdlPrv    := 1
Private nTotalLanc := 0
Private cLoteCom   := ""
Private nLinha     := 2
Private lLancPad70 := .F.

//VAriavel para compatibilidade com a Enchoice da AxVisual
Private	aTela[0][0],aGets[0]
Private 	cDocCred	:=	''
//Declaracao de vairaveis de uso geral
Private lRetPA	:=	(GetNewPar("MV_RETPA","N") == "S")
Private nDecs		:=	MsDecimais(1)
Private	nMoedaCor	:=	1
Private lBaixaChq	:=	.F.
Private aCerts		:=	{}
Private aIndexADC  := {}
Private bFiltraBrw 	:= {|| FilBrowse("SE2",@aIndexADC,@cCondicao) }
Private aRecNoSE2   := {}
Private nPosDeb
Private cCodDiario  := ""
Private lGeraDCam	:=	(GetNewPar("MV_DIFCAMP","N") == "S")
Private lTemMon	:= .F.
Private aRetIvAcm 	:= Array(3)
Private cGrpSNF := ""
Private	cGrpSPA := ""
Private	cGrpSF2 := ""
Private nNumPa
Private aCert   := {}
Private aRetencao := {} //Array para exibi��o de impostos com base no Configurador de Imposto FRM X FRN
Private nFlagMOD :=0
Private nCtrlMOD :=0
Private lFindITF := FindFunction("FinProcITF")
PRIVATE nFinLmCH := SuperGetMV("MV_FINLMCH",.F.,0.00)

Private lMsfil:= (cPaisLoc == "ARG") .And. SF1->(FieldPos("F1_MSFIL")) > 0 .And. SD1->(FieldPos("D1_MSFIL")) > 0 .AND. SE2->(FieldPos("E2_MSFIL")) > 0;
					.And. !Empty(xFilial("SF1")) .And. FWCodFil()!=xFilial("SE2")

Private nTotBSUSS:= 0
Private nLimiteSUSS:= 0
Private aTotIva:= {}        
Private lEsRetAdc := .F. //Se debe generar una retenci�n adicional (TIAGWQ)
Private lSFFOk 	  := .F.
Private lExecFRet := FieldPos("CO_TPMINRE") > 0
Private lUUID := .f.
Private cPaisProv := ""

/* Verifica��o do processo que est� configurado para ser utilizado no M�dulo Financeiro (Argentina) */
if cPaisloc == "ARG"
	Alert(STR0268)
	Return()
endif

If lMod2
	If !FinModProc()
		Return()
	EndIf
EndIf

If SX6->(Dbseek(xfilial("SX6")+"MV_MDCFIN"))
    lTemMon	:=Iif(!Empty(GETMV("MV_MDCFIN")),.T.,.F.)
EndIf
If cAgente == Nil
	cAgente	:= GETMV("MV_AGENTE")
Endif
If nMVCusto == Nil
	nMVCusto	:=	Val(GetMv("MV_MCUSTO"))
Endif
//Verifica se a moeda escolhida para o limite de credito esta em uso.
If Empty(GetMv("MV_MOEDA"+StrZero(nMVCusto,1)))
	MsgAlert(OemToAnsi(STR0142))
	Return nil
EndIf

If cPaisLoc == "MEX"
	dbSelectArea("SX3")
	SX3->(dbSetOrder(2)) // X3_CAMPO
	If SX3->(dbSeek("EK_UUID"))
		lUUID := .T.
	EndIF
EndIf

/*
//����������������������������������������������������������������������Ŀ
//�A moeda 1 e tambem inclusa como um dummy, nao vai ter uso,            �
//�mas simplifica todas as chamadas a funcao xMoeda, ja que posso        �
//�passara a taxa usando a moeda como elemento do Array atxMoedas        �
//�Exemplo xMoeda(E1_VALOR,E1_MOEDA,1,dDataBase,,aTxMoedas[E1_MOEDA][2]) �
//�Bruno - Paraguay 25/07/2000                                           �
//������������������������������������������������������������������������
*/
//Inicializar Array com as cotacoes e Nomes de Moedas segundo o arquivo SM2
Aadd(aTxMoedas,{"",1,PesqPict("SM2","M2_MOEDA1")})
For nA	:=	2	To nC
	cMoedaTx	:=	Str(nA,IIf(nA <= 9,1,2))
	If !Empty(GetMv("MV_MOEDA"+cMoedaTx))
		Aadd(aTxMoedas,{GetMv("MV_MOEDA"+cMoedaTx),RecMoeda(dDataBase,nA),PesqPict("SM2","M2_MOEDA"+cMoedaTx) })
	Else
		Exit
	Endif
Next

/*
+-Preguntas---------------------------------+
�  Mv_par01    �Del Vencimiento   ?         �
�  Mv_par02    �Hasta Vencimiento ?         �
�  Mv_par03    �Del Proveedor     ?         �
�  Mv_par04    �Hasta Proveedor   ?         �
�  Mv_par05    �Exibir ?  Todas/Pre-Ordens  �
�  Mv_par06    �Filtra Generadas  ?         �
�  Mv_par07    �Muestra Asientos  ?         �
�  Mv_par08    �Aglomera Asientos ?         �
�  Mv_par09    �Asientos On-Line  ?         �
�  Mv_par10    Agrupar OP's por             �
�  Mv_par11    Para saldo gerar   ?         �
�  Mv_par12    Imprime Comprovante? PER     �
�  Mv_par12    Considerar filial  ? MEX     �
�  Mv_par13    Nome rotina comprovante?     �
�  Mv_par14    Edita nro. comprovante?(PERU)�
+-------------------------------------------+
*/
If !Pergunte(cPerg,.T.)
	Return nil
EndIf

dDatade		:= mv_par01
dDataAte	:= mv_par02
cForDe   	:= mv_par03
cForAte  	:= mv_par04
lShowPOrd  	:= (mv_par05==2)  // .t. se mostra apenas pre-ordens
lFiltra   	:= (mv_par06==1)
lDigita		:= (mv_par07==1)
lAglutina	:= (mv_par08==1)
lGeraLanc	:= (mv_par09==1)
nCondAgr		:= mv_par10
lConsFilial := .F.
IF cPaisLoc $ "PER/MEX"
	lConsFilial := If(mv_par12==1,.T.,.F.)
ENDIF	

If cPaisLoc == "ARG" .And. lRetPA
	cDocCred		:=	IIf((mv_par11$MVPAGANT),MVPAGANT,'')
Else
	cDocCred		:=	IIf(Empty(mv_par11).Or. !(mv_par11$MV_CPNEG+"|"+MVPAGANT),'',mv_par11)
Endif

If Empty(cDocCred)
	Help(" ",1,"A085SALDO")
	Return
Endif
cPagaveis	:=	GetSESTipos({|| ES_BXRCOP == "1"},"2|3")
cPagaveis	:=	IIf(Empty(cPagaveis),MVNOTAFIS+"/"+MVPAGANT+"/"+MVFATURA+"/NDP/NCP/LTR",cPagaveis)
cIndex 		:= CriaTrab(nil,.f.)

If cPaisLoc == "MEX"
	If lConsFilial
		cCondicao   := 'E2_FILIAL=="'+xFilial("SE2")+'"'
		cCondicao 	+= ' .And. E2_FORNECE>="'+cForDe+'".And.E2_FORNECE<="'+cForAte+'".AND.E2_TIPO $"'+cPagaveis+ '"'
	Else
		cCondicao 	:= ' E2_FORNECE>="'+cForDe+'".And.E2_FORNECE<="'+cForAte+'".AND.E2_TIPO $"'+cPagaveis+ '"'
	EndIf
Else
	cCondicao   := 'E2_FILIAL=="'+xFilial("SE2")+'"'
	cCondicao 	+= ' .And. E2_FORNECE>="'+cForDe+'".And.E2_FORNECE<="'+cForAte+'".AND.E2_TIPO $"'+cPagaveis + '"'
EndIf

cCondicao 	+= '.And.Dtos(E2_VENCREA)>="'+dTos(dDatade)+'".And.Dtos(E2_VENCREA)<="'+dTos(dDataAte)+'".And.Dtos(E2_EMISSAO)<="'+dTos(dDataBase) +'".And.Dtos(E2_EMIS1)<="'+dTos(dDataBase) + '"'

// Filtra titulos que nao foram liberados pelo FINA580
// Esta condicao somente eh ativada qdo MV_CTLIPAG = .T.
// Alteracao conforme BOPS 66.814
If ( lLibTit )
	cCondicao += ".And. !Empty(E2_DATALIB) .And. Empty(E2_DATACAN)"
Endif
If lFiltra
	cCondicao += '.And.(E2_SALDO +E2_SDACRES) > 0 '
EndIf

If lShowPOrd  // somente PRE-Ordenes de pagamento
	cCondicao := cCondicao + '.And.E2_PREOK=="S"'
EndIf

If ExistBlock("A085ABRW")
	cFltUsr	:=	ExecBlock("A085ABRW",.F.,.F.)
Endif
If !Empty(cFltUsr)
	cCondicao := cCondicao + '.And.'+cFltUsr
Endif

cKey := "E2_FILIAL+E2_FORNECE+E2_LOJA+DTOS(E2_VENCREA)"
cChave := OemToAnsi(STR0004) //"Proveedor + Sucursal + Vencimiento"

DbSelectArea("SE2")
DbSetOrder(1)

//����������������������������������������������������������������������Ŀ
//� Processar filtro na MarkBrowse                                       �
//������������������������������������������������������������������������
Eval(bFiltraBrw)
nSaveOrder:=indexord()

cCadastro := OemToAnsi(STR0006)  //"Generacion de la Orden de Pago Automatica"

Private aRotina := MenuDef(@nFlagMOD,@nCtrlMOD)

cMarcaE2 := GetMark()

SX3->(dbSetOrder(1))

MarkBrow("SE2","E2_OK","SE2->E2_SALDO + SE2->E2_SDACRES <= 0",,,cMarcaE2,"a085aMarkAll(@nFlagMOD,@nCtrlMOD)",,,,"a085aMark(,@nFlagMOD,@nCtrlMOD)",,,,aCores)

//�����������������������������������������������������������������������Ŀ
//� Desbloquear os registros locados pela sele��o do Usario no MarkBrowse �
//�������������������������������������������������������������������������
DbSelectArea("SE2")
dbSetOrder(1)

DbUnlockAll()
//����������������������������������������������������������������������Ŀ
//� Limpa Filtro e reabre indices com RetIndex                           �
//������������������������������������������������������������������������
EndFilBrw("SE2",aIndexADC)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A085aPgAut�Autor  �Bruno Sobieski      �Fecha �  01/16/01   ���
�������������������������������������������������������������������������͹��
���Desc.     � Geracao de ordem de pagamento multiple.                    ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function A085APgAut(nFlagMOD,nCtrlMOD)        // incluido pelo assistente de conversao do AP5 IDE em 09/09/99
Local aSE2  := {}
Local nC	:= 0
Local nI    := 0
Local nX 	:= 0
Local lImpCert := (GetNewPar("MV_CERTRET","N") == "S")
Local lF085AltSE2 := ExistBlock("F085ARRSE2")
Local aAuxSE2 := {}
// variaveis privadas usadas no Fa085Tela
Private aPagos	 :=	{}
Private aPagosOrig := {}
Private oDlg,oLBx,cListBox,oValorPg ,oValPag,oMsg1
Private aSizes
Private aFields,oBrw
Private nValOrdens	:=	0	,nNumOrdens:=0,oNumOrdens,oValOrdens
Private oDataTxt1,oTipo
Private oDataTxt2
Private oPagar,nPagar
Private oChkBox
Private oDataVenc,oDataVenc1
Private oCbx1,oCbx2
Private aCtrChEQU := {}
Private oUUID := nIL
Private __cUUID := IIf(lUUID, Space(TamSX3("EK_UUID")[1]), "")

//Variaves relativas ao multimoeda (usadas no Fa085Tela)
Private oMoeda
Private oCbx,cMoeda	:=	MV_MOEDA1 ,aMoeda	:=	{}
Private cBanco:=Criavar("A6_COD"),cAgencia	:=	Criavar("A6_AGENCIA"),cConta:=Criavar("A6_NUMCON")
Private cProv:=Criavar("A2_EST")
Private cCF	:=	Criavar("F4_CODIGO")
Private nGrpSus := Criavar("FF_GRUPO")
Private cZnGeo := Criavar("FF_ITEM")
Private cNumOp := Iif(SEK->(FieldPos("EK_NUMOPER"))>0,Criavar("EK_NUMOPER"),"")
Private nTotAnt := Iif(SEK->(FieldPos("EK_TOTANT"))>0,Criavar("EK_TOTANT")  ,"")
Private cDebMed,aDebMed:={}
Private cDebInm,aDebInm:={}
Private dDataVenc  := dDataBase
Private dDataVenc1 := dDataBase
Private cTes	   := Criavar("F4_CODIGO")
Private aHeader1
Private nBaseRet   := 0 //Base para reten��o de PA Automatico

Private nValSobra  := 0.00
Private nTotPag    := 0.00
Private oMod	,	cMod	:=""
Private nTotNeg    := 0.00
Private cNatureza  := Criavar("ED_CODIGO")
PRIVATE nContDesc := 0
Private cDesc := Iif(SEK->(FieldPos("EK_DCONCEP"))>0,space(255),"")
Private aModAux :={}
Private nVlDscAux := 0, nPrDscAux := 0
// Verifica se pode ser incluido mov. com essa data
If !DtMovFin(ddatabase,,"1")
	Return  .F.
EndIf
nMoedaCor := 1
//Carregar combo com as moedas
Aadd(aMoeda,MV_MOEDA1)
For nC	:=	2	To Len(aTxMoedas)
	Aadd(aMoeda,aTxMoedas[nC][1])
Next

//Forco para que seja inclusao
aRotina[3][4]	:=	3
//Carrega o Array SE2 com todas as informacoes do pagamento
Processa({|| Fa085Se2(@aSE2)})

If lF085AltSE2
	aAuxSE2 := ExecBlock("F085ARRSE2",.F.,.F.,{aSE2})
	If ValType(aAuxSE2) = "A"
   	aSE2 := aClone(aAuxSE2)
	Endif
Endif

If Len(aSE2) > 0
	//�����������������������������������������������������������Ŀ
	//� Inicializa a gravacao dos lancamentos do SIGAPCO          �
	//�������������������������������������������������������������
	PcoIniLan("000313")

	//Monta interface com o Usuario
	If Fa085Tela(@aSE2,@nFlagMOD,@nCtrlMOD,@aCtrChEQU)
		// Gravacao

		Processa({|| Fa085Grava(aSE2,,,,@nFlagMOD,@nCtrlMOD,@aCtrChEQU) })

		IF cPaisLoc == "PER" .And. Len(aCert) > 0
   			IF MV_PAR12 == 1
				For nI:=1 to Len(aCert)
					If aCert[nI][3] == "I"
			  			bBlock := &("{||"+Alltrim(mv_par13)+"(aCert[nI][1],aCert[nI][2],.T.)"+"}")
			  			Eval(bBLock)
		  			EndIf
		  		Next nI
			EndIf
		EndIf

		aRetencao := {}
		aRetIvAcm := Array(3)

	Else
		//Cancela as reten��os calculadas com base no Conf. de Impostos
		If cPaisLoc $ "COS|DOM"
			F85aCanRet()
		EndIf
		aRetencao := {}
		aRetIvAcm := Array(3)
	Endif

	//������������������������������������������������Ŀ
	//� Finaliza a gravacao dos lancamentos do SIGAPCO �
	//��������������������������������������������������
	PcoFinLan("000313")

Endif

//Set Filter to
Eval(bFiltraBrw)

//Forco para que seja visualizacao e naio voltar
aRotina[3][4]	:=	2

// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> __Return( .F. )
Return( .F. )        // incluido pelo assistente de conversao do AP5 IDE em 09/09/99

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Fa085Grava�Autor  �Leonardo Gentile    �Fecha �  01/15/01   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gravacao da orden de PAGO                                   ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC Function Fa085Grava(aSE2,lPa,aRecAdt,lMonotrb,nFlagMOD,nCtrlMOD,aCtrChEQU)
Local nA,nI,nJ,nK
Local aTitPags 		:=	Array(MoedFin())
Local cSeq  		:= ""
Local nRegs 		:= 0
Local aNums			:=	{}
Local nMoedaPag 	:=	1, cFilSX6
Local lBaixaChqTmp 	:=	.F.
Local lPagoInf 		:=	.F.
Local cQuery    	:= ""
Local lExiste 		:= .F.
Local cKeyImp		:= ""
Local cAlias 		:= ""
Local nMoedaRet		:= 1
Local aMoedasPg		:= { 1 }
Local aAreaSA2		:= {}
Local aAreaSE2		:= {}
Local cFilterSE2	:= {}
Local aAreaSEF		:= {}
Local aAreaSEK		:= {}
Local cFilter		:=	''
Local lExterno		:= .F.
Local ny			:= 1
Local nx			:= 1
Local aConGan		:= {}
Local aRateioGan	:= {}
Local aConGanRat	:= {}
Local nC			:= 1
local cGrSUSS		:= Alltrim( nGrpSus ) + Alltrim( cZnGeo )
Local aFlagCTB		:= {}
Local lUsaFlag		:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/ )
Local aTmp1			:= {}
Local aTmpIB		:= {}
Local nBaseITF    := 0
Local lFindITF    := FindFunction("FinProcITF")
Local aHdlPrv     := {}
Local lCBU		  := .F.
Local nValMoed1	  := 0
Local cPrefix 	  := " "
Local nNum    	  := 0
Local cParcela    := " "
Local cTipoDoc    := " "
Local nFornec     := 0
Local nVlrRet  	  := 0
Local lF085NoShw 	:= .F.
local nColig		:=GetNewPar("MV_RMCOLIG",0)
Local nOrdPag		:= 0
Local lMsgUnica		:=(Iif( FindFunction("IsIntegTop"),IsIntegTop(),.F.))
Local lF85ALTVAL 	:= ExistBlock("F85ALTVAL")
Local lAltGrava		:= .F.
Local aNump  := {}
Local nMulta:=0
Local nJuros:=0
Local nModAux:=0
Local nTasaCon:=1
Local lCertImp    := ExistBlock("FA085CERT")
Local lPERGenPA := .F.

Private dDataRef 	:=	dDatabase      //PA - Anticipos
Private cProveedor 	:=	Space(TamSX3("EK_FORNECE")[1])
Private cLoja		:=	Space(TamSX3("EK_LOJA")[1])
Private cProvOri 	:=	Space(TamSX3("EK_FORNECE")[1])
Private cLojOri	    :=	Space(TamSX3("EK_LOJA")[1])
Private cNome       :=	Space(TamSX3("A2_NOME")[1])
Private cCGC		:=	Space(TamSX3("A2_CGC")[1])
Private cContato	:=	Iif(SA1->(FieldPos("A2_CONTATO"))>0,Space(TamSX3("A2_CONTATO")[1]),"")
Private cTel		:=	Iif(SA1->(FieldPos("A2_TEL"))>0,	Space(TamSX3("A2_TEL")[1]),"")

If cPaisLoc == "MEX" .And. lF85ALTVAL 
	lAltGrava := ExecBlock("F85ALTVAL",.F.,.F.)
EndIf

If ExistBlock("F085NOSHW")
	lF085NoShw := ExecBlock("F085NOSHW",.F.,.F.)
	If ValType(lF085NoShw) != "L"
		lF085NoShw := .F.
	EndIf
EndIf

If lA085aTit == Nil
	lA085aTit	:=	ExistBlock("A085ATIT")
Endif
Private cLiquid	:= ""
Private cOrdPago	:= ""
Private aRatAFR 	:={}
Private aTitImp	:= {}
Private cDesc := Iif(SEK->(FieldPos("EK_DCONCEP"))>0,cDesc,"")
DEFAULT aRecADT	:=	{}
DEFAULT lMonotrb  := .F.
DEFAULT aCtrChEQU :={}
If !IsMemVar("__cUUID")
	Private __cUUID := ""
EndIf
//+---------------------------------------------------------+
//� Generar asientos contables                              �
//+---------------------------------------------------------+
If lGeraLanc
	//+--------------------------------------------------------------+
	//� Nao Gerar os lancamento Contabeis On-Line                    �
	//+--------------------------------------------------------------+
	lLancPad70 := VerPadrao("570")
EndIf
If lLancPad70
	//+--------------------------------------------------------------+
	//� Posiciona numero do Lote para Lancamentos do Financeiro      �
	//+--------------------------------------------------------------+
	dbSelectArea("SX5")
	dbSeek(xFilial()+"09FIN")
	cLoteCom:=IIF(Found(),Trim(X5_DESCRI),"FIN")
EndIf
If lLancPad70
	nHdlPrv := HeadProva( cLoteCom,;
	                      "PAGO011",;
	                      substr( cUsuario, 7, 6 ),;
	                      @cArquivo )

	If nHdlPrv <= 0
		Help(" ",1,"A100NOPROV")
	EndIf
	aHdlPrv := { nHdlPrv, "570", "FINA085", "PAGO011", cLoteCom }
Else
	aHdlPrv := {}
EndIf
lPa	:=	Iif(lPa==Nil,.F.,lPa)

If	lPa
	nRegs	:=	1
Else
	aEval( aSE2, {|x,y| nRegs+=Len( aSE2[y][1])}  )
Endif

ProcRegua(2*Len(aSE2)+nRegs)

For ni := 1 to Len(aPagos)

	If aPagos[ni][H_OK] <> 1  // se !ok
		Loop
	EndIf

	Begin Transaction
	//Flag CBU
	lCBU := Iif(cPaisLoc == "ARG",aPagos[ni][H_CBU],.F.)

	//Inicializar array dos valores Baixados
	For nA	:=	1	To	Len(aTitPags)
		aTitPags[nA]	:=	0
	Next
	// pega novo numero de ordem de pago

	cOrdPago := StrZero(Val(GetSxeNum("SEK","EK_ORDPAGO")),TamSx3("EK_ORDPAGO")[1])

	// rDMAKE PARA ALTERAR A NUMERACAO DA oRDEM DE PAGO
	If ExistBlock("A085NORP")
		cOrdPago :=	ExecBlock("A085NORP",.F.,.F.,cOrdPago)
	Endif

	aCerts:={}  // Redefinir o array dos doctos de retencoes

	SEK->(DbSetOrder(1))
	lExiste := SEK->(DbSeek(xFilial("SEK")+cOrdPago,.F.))
	If __lSx8
		If !lExiste
	 		ConfirmSx8()
		Else
			RollBackSX8()
			Final(OemToAnsi(STR0156),OemToAnsi(STR0157))
		EndIf
	EndIf
	cLiquid    	:= Soma1(GetMv("MV_NUMLIQ"),6)
	cFilSX6    	:= SX6->X6_FIL
	lPagoInf	:=	.F.

	//���������������������������������������������������������������Ŀ
	//�Determinar se o pago foi feito em uma unica moeda, para gravar �
	//�todas as retencoes nessa moeda (BOPS 76135)                    �
	//�����������������������������������������������������������������
	nMoedaRet	:=	1

	For nj := 1 to Len( aSE2[ni][1])

		IncProc()

		If !(aSE2[ni][1][nj][_TIPO] $ MVABATIM ) .And. aSE2[ni][1][nj][_PAGAR] > 0
		SE2->(DbSetOrder(1))
          	If Empty(aSE2[ni][1][nj][_PARCELA])
          		If  cPaisLoc == "URU"
          			aSE2[ni][1][nj][_PARCELA]  := Space(TamSX3("E2_PARCELA")[1])
          		Else
          			aSE2[ni][1][nj][_PARCELA]  := " "
          		Endif
          	EndIf
			If cPaisLoc == "MEX"
				SE2->(MsSeek(aSE2[ni][1][nj][_FILIAL]+aSE2[ni][1][nj][_PREFIXO]+aSE2[ni][1][nj][_NUM]+aSE2[ni][1][nj][_PARCELA]+;
				             aSE2[ni][1][nj][_TIPO]+aSE2[ni][1][nj][_FORNECE]+aSE2[ni][1][nj][_LOJA]))
			Else
				SE2->(MsSeek(xFilial("SE2")+aSE2[ni][1][nj][_PREFIXO]+aSE2[ni][1][nj][_NUM]+aSE2[ni][1][nj][_PARCELA]+;
							aSE2[ni][1][nj][_TIPO]+aSE2[ni][1][nj][_FORNECE]+aSE2[ni][1][nj][_LOJA]))
			EndIF			
			cSeq:=FaNxtSeqBx("SE2")

			//����������������������������������������������������������������Ŀ
			//� Caso a Natureza do titulo for de adiatamento ED_OPERADT = 1    �
			//� gera o titulo do tipo "RA" com base no titulo de adiantamento. �
			//������������������������������������������������������������������
			If cPaisLoc == "PER" .And. X3Usado("ED_OPERADT")
				If GetAdvFVal("SED","ED_OPERADT",xFilial("SED")+SE2->E2_NATUREZ,1,"") == "1" 
					cProveedor 	:=	aSE2[ni][1][nj][_FORNECE]
					cLoja		:=	aSE2[ni][1][nj][_LOJA   ]
					Fa085aNFRA(SF1->F1_VALMERC,SF1->F1_VALMERC*aSE2[ni][1][nj][_MOEDA]) // aSE2[ni][1][nj][_PAGAR],aSE2[ni][1][nj][_PAGAR]*aSE2[ni][1][nj][_MOEDA]
				EndIf
			ElseIf 	cPaisLoc $ "DOM|COS"
				If lPa	.And. !Empty(cNatureza)
					//Gera��o das Reten��es de Impostos
					If 	!SE2->E2_TIPO $ "CH |PA "
						fa085GerRet("9", cNatureza, aSE2[ni][1][nj][3], aSE2[ni][1][nj][_PREFIXO], aSE2[ni][1][nj][_NUM], aSE2[ni][1][nj][_FORNECE])
					EndIf
					fa085GerRet("2", cNatureza, aSE2[ni][1][nj][3], aSE2[ni][1][nj][_PREFIXO], aSE2[ni][1][nj][_NUM], aSE2[ni][1][nj][_FORNECE])
				Else
					cFatGer     := F085FatGer(SE2->E2_NATUREZ)
					nVlrRet 	:= F085PesAbt()
					If nVlrRet  > 0 .And. cFatGer == "2" .And. Empty(SE2->E2_BAIXA)  .And. SE2->E2_VALLIQ == 0 .And. aSE2[ni][1][nj][3] < SE2->E2_VALOR
						aSE2[ni][1][nj][3] := aSE2[ni][1][nj][3] + nVlrRet
					EndIf
					If 	!SE2->E2_TIPO $ "CH |PA "
						//Gera��o das Reten��es de Impostos
						fa085GerRet("2", aSE2[ni][1][nj][19], aSE2[ni][1][nj][3], aSE2[ni][1][nj][_PREFIXO], aSE2[ni][1][nj][_NUM], aSE2[ni][1][nj][_FORNECE])
                    EndIf
				EndIf
			Endif
			
			nModAux := ASCAN(aModAux,{|x|  x[1] == aSE2[ni][1][nj][1]+ aSE2[ni][1][nj][2] +aSE2[ni][1][nj][9] + aSE2[ni][1][nj][10] + aSE2[ni][1][nj][11] + aSE2[ni][1][nj][12] })
			If nModAux > 0
				nJuros:=aModAux[nModAux][2][1]
				nMulta:=aModAux[nModAux][3][1]				
			Else
				nJuros:=aSE2[ni][1][nj][_JUROS  ]
				nMulta:=aSE2[ni][1][nj][_MULTA  ]							
			Endif
						
			If aSE2[ni][1][nj][_JUROS  ] > 0  // existem juros

				RecLock("SE5",.T.)
				SE5->E5_FILIAL    	:= xFilial("SE5")
				If cPaisLoc $ "ARG|PAR|MEX|COL|PER" 
					SE5->E5_FILORIG := aSE2[ni][1][nj][_FILORIG ]
				Else
					SE5->E5_FILORIG := SE2->E2_FILIAL
				EndIf
				SE5->E5_RECPAG    	:= "P"
				SE5->E5_HISTOR    	:= STR0071 //"Interes pago sobre titulo"
				SE5->E5_DTDIGIT   	:= dDataBase
				SE5->E5_DATA      	:= dDataBase
				SE5->E5_NATUREZ   	:= aSE2[ni][1][nj][_NATUREZ]
				SE5->E5_TIPODOC   	:= "JR"
				SE5->E5_PREFIXO   	:= aSE2[ni][1][nj][_PREFIXO]
				SE5->E5_NUMERO    	:= aSE2[ni][1][nj][_NUM    ]
				SE5->E5_PARCELA   	:= aSE2[ni][1][nj][_PARCELA]
				SE5->E5_CLIFOR    	:= aSE2[ni][1][nj][_FORNECE]
				SE5->E5_LOJA      	:= aSE2[ni][1][nj][_LOJA   ]
				SE5->E5_BENEF     	:= aSE2[ni][1][nj][_NOME   ]
				SE5->E5_MOTBX     	:= "NOR"
				SE5->E5_VLMOED2   	:= aSE2[ni][1][nj][_JUROS  ]
				SE5->E5_DOCUMEN   	:= cOrdPago
				SE5->E5_ORDREC		:= cOrdPago
				SE5->E5_TIPO      	:= aSE2[ni][1][nj][_TIPO   ]
				SE5->E5_NUMLIQ    	:= cLiquid
				SE5->E5_MOEDA     	:= StrZero( aSE2[ni][1][nj][_MOEDA  ],2)
				SE5->E5_VALOR     	:= Round(xMoeda( aSE2[ni][1][nj][_JUROS  ], aSE2[ni][1][nj][_MOEDA  ], 1,,5,aTxMoedas[aSE2[ni][1][nj][_MOEDA  ]][2]),MsDecimais(1))
				SE5->E5_SEQ       	:= cSeq
				If !lUsaFlag
					SE5->E5_LA        	:= "S"
				EndIF
				If FieldPos("E5_TXMOEDA")>0
					SE5->E5_TXMOEDA		:= aTxMoedas[aSE2[ni][1][nj][_MOEDA  ]][2]
				EndIf
				MsUnlock()

				If lUsaFlag // Armazena em aFlagCTB para atualizar no modulo Contabil
					aAdd( aFlagCTB, { "E5_LA", "S", "SE5", SE5->( RecNo() ), 0, 0, 0} )
				EndIf

				If lFindITF .And. FinProcITF( SE5->( RecNo() ),1 ) .and. lRetCkPG(3,,SE5->E5_BANCO)//verifico se esse lancamento deve compor a base de calculo do ITF
					nBaseITF += SE5->E5_VALOR
				EndIf

			EndIf

			If aSE2[ni][1][nj][_MULTA  ] > 0 //Existe Multa
				Reclock( "SE5", .T. )
				SE5->E5_FILIAL 	:= xFilial("SE5")
				If cPaisLoc $ "MEX|COL|PER" 
					SE5->E5_FILORIG := aSE2[ni][1][nj][_FILORIG ]
				Else
					SE5->E5_FILORIG := SE2->E2_FILIAL
				EndIf
				SE5->E5_NUMERO 	:= aSE2[ni][1][nj][_NUM    ]
				SE5->E5_PREFIXO	:= aSE2[ni][1][nj][_PREFIXO]
				SE5->E5_RECPAG 	:= "P"
				SE5->E5_TIPO   	:= aSE2[ni][1][nj][_TIPO   ]
				SE5->E5_PARCELA	:= aSE2[ni][1][nj][_PARCELA]
				SE5->E5_TIPODOC	:= "MT"
				SE5->E5_MOTBX  	:= "NOR"
				SE5->E5_DATA   	:= dDataBase
				SE5->E5_VALOR  	:= Round(xMoeda( aSE2[ni][1][nj][_MULTA  ], aSE2[ni][1][nj][_MOEDA  ], 1,,5,aTxMoedas[aSE2[ni][1][nj][_MOEDA  ]][2]),MsDecimais(1))
				SE5->E5_NATUREZ	:= aSE2[ni][1][nj][_NATUREZ]
				If !lUsaFlag
					SE5->E5_LA        	:= "S"
				EndIf
				SE5->E5_HISTOR 	:= 	STR0144 // "Multa sobre Pago de Titulo"
				SE5->E5_CLIFOR 	:= aSE2[ni][1][nj][_FORNECE]
				SE5->E5_LOJA   	:= aSE2[ni][1][nj][_LOJA   ]
				SE5->E5_BENEF  	:= aSE2[ni][1][nj][_NOME   ]
				SE5->E5_DTDIGIT	:= dDataBase
				SE5->E5_SEQ	  	:= cSeq
				SE5->E5_VLMOED2	:= aSE2[ni][1][nj][_MULTA  ]
				SE5->E5_DOCUMEN	:= cOrdPago
				SE5->E5_ORDREC	:= cOrdPago
				SE5->E5_MOEDA  	:= StrZero( aSE2[ni][1][nj][_MOEDA  ],2)
				SE5->E5_NUMLIQ 	:= cLiquid
				If FieldPos("E5_TXMOEDA")>0
					SE5->E5_TXMOEDA		:= aTxMoedas[aSE2[ni][1][nj][_MOEDA  ]][2]
				EndIf

				If lUsaFlag // Armazena em aFlagCTB para atualizar no modulo Contabil
					aAdd( aFlagCTB, { "E5_LA", "S", "SE5", SE5->( RecNo() ), 0, 0, 0} )
				EndIf
				If lFindITF .And. FinProcITF( SE5->( RecNo() ),1 ) .and. lRetCkPG(3,,SE5->E5_BANCO)//verifico se esse lancamento deve compor a base de calculo para o imposto ITF
					nBaseITF += SE5->E5_VALOR
				EndIf
			Endif
			If aSE2[ni][1][nj][_DESCONT] > 0  // existem descontos
				RecLock("SE5",.T.)
				SE5->E5_FILIAL    	:= xFilial("SE5")
				If cPaisLoc $ "ARG|PAR|MEX|COL|PER" 
					SE5->E5_FILORIG := aSE2[ni][1][nj][_FILORIG ]
				Else
					SE5->E5_FILORIG := SE2->E2_FILIAL
				EndIf
				SE5->E5_RECPAG    	:= "P"
				SE5->E5_HISTOR    	:= STR0072 //"Descuento sobre pago de titulo"
				SE5->E5_DTDIGIT   	:= dDataBase
				SE5->E5_DATA      	:= dDataBase
				SE5->E5_NATUREZ   	:= aSE2[ni][1][nj][_NATUREZ]
				SE5->E5_TIPODOC   	:= "DC"
				SE5->E5_PREFIXO   	:= aSE2[ni][1][nj][_PREFIXO]
				SE5->E5_NUMERO    	:= aSE2[ni][1][nj][_NUM    ]
				SE5->E5_PARCELA   	:= aSE2[ni][1][nj][_PARCELA]
				SE5->E5_CLIFOR    	:= aSE2[ni][1][nj][_FORNECE]
				SE5->E5_LOJA      	:= aSE2[ni][1][nj][_LOJA   ]
				SE5->E5_BENEF     	:= aSE2[ni][1][nj][_NOME   ]
				SE5->E5_MOTBX     	:= "NOR"
				
				If cPaisLoc $ "MEX|PER|COL"
					If aSE2[ni][1][nj][_MOEDA] == 1
						SE5->E5_VLMOED2 := aSE2[ni][1][nj][_DESCONT]
						SE5->E5_VALOR   := Abs( Round(xMoeda(aSE2[ni][1][nj][_DESCONT],aSE2[ni][1][nj][_MOEDA],1,,5,aTxMoedas[aSE2[ni][1][nj][_MOEDA]][2]),MsDecimais(1)) )
					Else
						SE5->E5_VLMOED2	:= Abs( Round(xMoeda(aSE2[ni][1][nj][_DESCONT],aSE2[ni][1][nj][_MOEDA],1,,5,aTxMoedas[aSE2[ni][1][nj][_MOEDA]][2]),MsDecimais(1)) )
						SE5->E5_VALOR	:= aSE2[ni][1][nj][_DESCONT]
					EndIf
				Else
					SE5->E5_VLMOED2   	:= aSE2[ni][1][nj][_DESCONT]
					SE5->E5_VALOR     	:= Round(xMoeda( aSE2[ni][1][nj][_DESCONT], aSE2[ni][1][nj][_MOEDA  ], 1,,5,aTxMoedas[aSE2[ni][1][nj][_MOEDA  ]][2]),MsDecimais(1))
				EndIf
								
				SE5->E5_DOCUMEN   	:= cOrdPago
				SE5->E5_ORDREC		:= cOrdPago
				SE5->E5_TIPO      	:= aSE2[ni][1][nj][_TIPO   ]
				SE5->E5_NUMLIQ    	:= cLiquid
				SE5->E5_MOEDA     	:= StrZero( aSE2[ni][1][nj][_MOEDA  ],2)
				 
				SE5->E5_SEQ       	:= cSeq
				If !lUsaFlag
					SE5->E5_LA        	:= "S"
				EndIf

				If FieldPos("E5_TXMOEDA")>0
					SE5->E5_TXMOEDA		:= aTxMoedas[aSE2[ni][1][nj][_MOEDA  ]][2]
				EndIf
				MsUnlock()

				If lUsaFlag // Armazena em aFlagCTB para atualizar no modulo Contabil
					aAdd( aFlagCTB, { "E5_LA", "S", "SE5", SE5->( RecNo() ), 0, 0, 0} )
				EndIf
				If lFindITF .And. FinProcITF( SE5->( RecNo() ),1 ) .and. lRetCkPG(3,,SE5->E5_BANCO)//verifico se esse lancamento deve compor a base de calculo para o imposto ITF
					nBaseITF += SE5->E5_VALOR
				EndIf
			EndIf
			RecLock("SE5",.T.)
			SE5->E5_FILIAL    	:= xFilial("SE5")
			If cPaisLoc $ "ARG|PAR|MEX|COL|PER" 
				SE5->E5_FILORIG := aSE2[ni][1][nj][_FILORIG ]
			Else
				SE5->E5_FILORIG := cFilAnt
			EndIf
			SE5->E5_RECPAG    	:= "P"
			SE5->E5_HISTOR    	:= STR0073 //"BJ.TIT.P/ORD.PAGO"
			SE5->E5_DTDIGIT   	:= dDataBase
			SE5->E5_DATA      	:= dDataBase
			SE5->E5_NATUREZ   	:= aSE2[ni][1][nj][_NATUREZ]
			SE5->E5_TIPODOC   	:= "BA"
			SE5->E5_PREFIXO   	:= aSE2[ni][1][nj][_PREFIXO]
			SE5->E5_NUMERO    	:= aSE2[ni][1][nj][_NUM    ]
			SE5->E5_PARCELA   	:= aSE2[ni][1][nj][_PARCELA]
			SE5->E5_CLIFOR    	:= aSE2[ni][1][nj][_FORNECE]
			SE5->E5_LOJA      	:= aSE2[ni][1][nj][_LOJA   ]
			SE5->E5_BENEF     	:= aSE2[ni][1][nj][_NOME   ]
			SE5->E5_MOTBX     	:= "NOR"
	 		If lAltGrava
				SE5->E5_VLMOED2   	:= Abs( aSE2[ni][1][nj][_PAGAR] )
				SE5->E5_VALOR     	:= Abs( Round(xMoeda(aSE2[ni][1][nj][_PAGAR],aSE2[ni][1][nj][_MOEDA],1,,5,aTxMoedas[aSE2[ni][1][nj][_MOEDA]][2]),MsDecimais(1)) )
			Else
				If aSE2[ni][1][nj][_MOEDA] == 1
					SE5->E5_VLMOED2 += aSE2[ni][1][nj][_PAGAR]
				Else
					IF cPaisLoc $ "PER" .And. AllTrim(aSE2[ni][1][nj][_TIPO]) == "TX"
						SE5->E5_VLMOED2	:= Abs( Round(xMoeda(aSE2[ni][1][nj][_PAGAR],aSE2[ni][1][nj][_MOEDA],1,,5,aSE2[ni][1][nj][_TXMOEDA]),0))
					Else
				    	SE5->E5_VLMOED2	:= Abs( Round(xMoeda(aSE2[ni][1][nj][_PAGAR],aSE2[ni][1][nj][_MOEDA],1,,5,aTxMoedas[aSE2[ni][1][nj][_MOEDA]][2]),MsDecimais(1)) )
					EndIf
				Endif
				SE5->E5_VALOR     	:= Abs( aSE2[ni][1][nj][_PAGAR] )
			EndIf
			SE5->E5_DOCUMEN   	:= cOrdPago
			SE5->E5_ORDREC		:= cOrdPago
			SE5->E5_TIPO      	:= aSE2[ni][1][nj][_TIPO   ]
			SE5->E5_NUMLIQ    	:= cLiquid
			SE5->E5_MOEDA     	:= StrZero( aSE2[ni][1][nj][_MOEDA  ],2)
			SE5->E5_SEQ       	:= cSeq
			If !lUsaFlag
				SE5->E5_LA        	:= "S"
			EndIf
			SE5->E5_VLDESCO		:= aSE2[ni][1][nj][_DESCONT]
			nX := ASCAN(aModAux,{|x|  x[1] == aSE2[ni][1][1][1]+ aSE2[ni][1][1][2] +aSE2[ni][1][1][9] + aSE2[ni][1][1][10] + aSE2[ni][1][1][11] + aSE2[ni][1][1][12] })			
			SE5->E5_VLMULTA		:= IIF (nX>0,aModAux[nX][3][1],aSE2[ni][1][nj][_MULTA  ])
			SE5->E5_VLJUROS		:= IIF (nX>0,aModAux[nX][2][1],aSE2[ni][1][nj][_JUROS  ])

			If FieldPos("E5_TXMOEDA")>0
				IF cPaisLoc $ "PER" .And. AllTrim(aSE2[ni][1][nj][_TIPO]) == "TX"
					SE5->E5_TXMOEDA := aSE2[ni][1][nj][_TXMOEDA]
				Else
					SE5->E5_TXMOEDA	:= aTxMoedas[aSE2[ni][1][nj][_MOEDA]][2]
				EndIF
			EndIf

			MsUnlock()

			If lUsaFlag // Armazena em aFlagCTB para atualizar no modulo Contabil
				aAdd( aFlagCTB, { "E5_LA", "S", "SE5", SE5->( RecNo() ), 0, 0, 0} )
			EndIf

			If lFindITF .And. FinProcITF( SE5->( RecNo() ),1 ) .and. lRetCkPG(3,,SE5->E5_BANCO)//verifico se esse lancamento deve compor a base de calculo para o imposto ITF
				nBaseITF += SE5->E5_VALOR
			EndIf

			SE2->(MsGoTo(aSE2[ni][1][nj][_RECNO]  ))
			If SE2->E2_TIPO $ MV_CPNEG+"/"+MVPAGANT
				aTitPags[1]	-=	SE5->E5_VLMOED2
			Else
				aTitPags[1]	+=	SE5->E5_VLMOED2
			Endif

			nRECSEKdiario:= SEK->(Recno())

			RecLock("SEK",.T.)
			SEK->EK_TIPODOC		:= "TB" //Titulo bajado
			SEK->EK_FILIAL		:= xFilial("SEK")
			SEK->EK_VALORIG		:= aSE2[ni][1][nj][_VALOR  ]
			SEK->EK_EMISSAO   	:= dDataBase
			SEK->EK_PREFIXO   	:= aSE2[ni][1][nj][_PREFIXO]
			SEK->EK_NUM       	:= aSE2[ni][1][nj][_NUM    ]
			SEK->EK_PARCELA   	:= aSE2[ni][1][nj][_PARCELA]
			SEK->EK_TIPO      	:= aSE2[ni][1][nj][_TIPO   ]
			SEK->EK_FORNECE   	:= aSE2[ni][1][nj][_FORNECE]
			SEK->EK_LOJA      	:= aSE2[ni][1][nj][_LOJA   ]
			SEK->EK_MOEDA     	:= Alltrim(Str( aSE2[ni][1][nj][_MOEDA  ]))
			SEK->EK_SALDO     	:= aSE2[ni][1][nj][_PAGAR  ]
			SEK->EK_VALOR     	:= Abs( aSE2[ni][1][nj][_PAGAR  ])
			SEK->EK_VENCTO    	:= aSE2[ni][1][nj][_VENCTO ]
			SEK->EK_JUROS     	:= aSE2[ni][1][nj][_JUROS  ]
			SEK->EK_DESCONT   	:= aSE2[ni][1][nj][_DESCONT]
			SEK->EK_ORDPAGO   	:= cOrdpago
			SEK->EK_SEQ       	:= cSeq
			SEK->EK_DTDIGIT   	:= dDataBase
		   	SEK->EK_FORNEPG		:= aPagos[ni][H_FORNECE]
		   	SEK->EK_LOJAPG			:= aPagos[ni][H_LOJA]
			If SEK->(FieldPos("EK_NATUREZ")) > 0
			   SEK->EK_NATUREZ:= cNatureza
			Endif
		   	If SEK->(FieldPos("EK_PGCBU")) > 0
		   		SEK->EK_PGCBU	:= aPagos[ni][H_CBU]
		   	Endif
		   	If cPaisLoc=="PER" .And. SEK->(FieldPos("EK_SERORI")) >0
		   		SEK->EK_SERORI    	:= aSE2[ni][1][nj][_SERORI]
		   EndIf  
			If cPaisLoc == "MEX" .And.cPaisProv <> "493"
				If SEK->(FieldPos("EK_DCONCEP")) > 0
					SEK->EK_DCONCEP := AllTrim(cDesc)
				Endif
			EndIf
			If cPaisLoc == "MEX" .And. SEK->(FieldPos("EK_MSFIL")) > 0
				SEK->EK_MSFIL := aSE2[ni][1][nj][_FILORIG]
			EndIf
			If cPaisLoc == "MEX"  .and. SEK->(FieldPos("EK_UUID")) > 0
				SEK->EK_UUID := __cUUID
			EndIf
			F085AGrvTx()
			IF cPaisLoc $ "PER" .And. AllTrim(aSE2[ni][1][nj][_TIPO]) == "TX"
				SEK->&("EK_TXMOE"+StrZero(aSE2[ni][1][nj][_MOEDA],2)) := aSE2[ni][1][nj][_TXMOEDA]
			 	SEK->EK_VLMOED1   	:= Round(xMoeda(SEK->EK_VALOR,Val(SEK->EK_MOEDA),1,,5,aSE2[ni][1][nj][_TXMOEDA]),0)
			Else
		    	SEK->EK_VLMOED1   	:= Round(xMoeda(SEK->EK_VALOR,Val(SEK->EK_MOEDA),1,,5,aTxMoedas[val(SEK->EK_MOEDA)][2]),MsDecimais(1))
			EndIf
			
			MsUnlock()

			If aSE2[ni][1][nj][_MOEDA] == 1
				nValMoed1 += aSE2[ni][1][nj][_PAGAR]
			Else
				IF cPaisLoc $ "PER" .And. AllTrim(aSE2[ni][1][nj][_TIPO]) == "TX"
					nValMoed1 += Round(xMoeda(Abs(aSE2[ni][1][nj][_PAGAR]),aSE2[ni][1][nj][_MOEDA],1,,5,aSE2[ni][1][nj][_TXMOEDA]),0)
				Else
			    	nValMoed1 += Round(xMoeda(Abs(aSE2[ni][1][nj][_PAGAR]),aSE2[ni][1][nj][_MOEDA],1,,5,aTxMoedas[aSE2[ni][1][nj][_MOEDA]][2]),MsDecimais(1))
				EndIf
			Endif

			If ExistBlock("A085ATIT")
				ExecBLock("A085ATIT",.F.,.F.)
			Endif
			//����������������������������������������������������������Ŀ
			//� Grava os lancamentos nas contas orcamentarias SIGAPCO    �
			//������������������������������������������������������������
			PcoDetLan("000313","01","FINA085A")
			If cPaisLoc=="MEX" .And. SE2->(FieldPos("E2_VALIMP1"))>0 .And. SEK->(FieldPos("EK_VALIMP1"))>0
				a085aGrRetMx()
			EndIf
			//Gravar reten�oes de IVA e Ingresos Brutos
			a085aGravRet(aSE2[ni][1][nj],aPagos[ni][2],aPagos[ni][3],aSE2[ni][1][nj][_PARCELA],.F.,@aTitPags,nMoedaRet,,lCBU)
		EndIf

	Next nj
	
	If cPaisLoc == "PAR" .And. procname(6) <>"A085APGADI"  
		F085GravTX(aSE2[ni],nMoedaRet,aPagos,cOrdPago,aPagos[ni][2],aPagos[ni][3])			
		IF lCertImp .And. Len(aCert) > 0
			ExecBlock("FA085CERT",.F.,.F.,{aCert,aPagos[ni][H_TOTALVL]})
		EndIf
	EndIf

	If cPaisLoc $ "ARG|ANG"
  		If lRetPa .And. ((SE2->E2_TIPO $ MVPAGANT) .Or. aSE2[ni][1][1][_PAGAR] = 0)
			a085aGravRet(aSE2[nI,1,1],aPagos[ni][2],aPagos[ni][3],/*aSE2[ni][1][1][_PARCELA]*/,.F.,@aTitPags,nMoedaRet,.T.,lCBU)
		EndIf
    EndIf
	If cPaisLoc == "PER"
		 IF procname(6) == 'A085APGAUT'
		 	If lRetPa .And. ((SE2->E2_TIPO $ MVPAGANT) .Or.aSE2[ni][1][1][_PAGAR] = 0)
				a085aGravRet(aSE2[nI,1,1],aPagos[ni][2],aPagos[ni][3],,.F.,@aTitPags,nMoedaRet,.T.)
			EndIf
         ELSE
        	 If lRetPa .And. Len(aSE2[nI,1]) > 0 .And. (SE2->E2_TIPO $ MVPAGANT)
				a085aGravRet(aSE2[nI,1,1],aPagos[ni][2],aPagos[ni][3],,.F.,@aTitPags,nMoedaRet,.T.)
			EndIf
         ENDIF
		If GetMV("MV_TITRET",.T.,.F.)
			F085TitImp(aSE2[nI],cOrdPago)
		Endif
    EndIf
	//�����������������������������������������������������������Ŀ
	//�Verifico se houve pago diferenciado para esta ordem de pago�
	//�Caso contrario, atualizo conforme escolhido por default    �
	//�������������������������������������������������������������
	If aSE2[ni][3] == Nil   // default, sem pago diferenciado

		//���������������������������������������������������������Ŀ
		//�Ajuste utilizado para evitar que a conves�o da moeda 1   �
		//�para outras moedas na tela (sele��o da moeda na 1a. aba  �
		//�da ordem de pago) necessite de re-convers�o.             �
		//�����������������������������������������������������������
		SA6->(DbSeek(xFilial()+cBanco+cAgencia+cConta))
		nMoedaPag	:= Iif(SA6->A6_MOEDAP>0,SA6->A6_MOEDAP,SA6->A6_MOEDA)
		nMoedaBco	:= SA6->A6_MOEDA

		lValOrig := .F.

		If Type("aPagosOrig")<>"U"
			If Len(aPagosOrig)>0 .And. nMoedaBco <= 1
				lValOrig := .T.
			Endif
		Endif

		GravaPagos( nPagar, cBanco, cAgencia, cConta,, aPagos[ni][H_FORNECE],;
		aPagos[ni][H_LOJA],aPagos[ni][H_NOME],Iif(lValOrig, 1, nMoedaCor), Iif(lValOrig,aPagosOrig[ni][H_TOTALVL],aPagos[ni][H_TOTALVL]),;
		dDataBase, Iif(nPagar==1,dDataVenc1,Iif(nPagar==2,dDataVenc,dDataBase)) , cDebMed, cDebInm,,,nBaseITF, aHdlPrv ,lCBU,lPa,If(cPaisLoc $ "EQU|DOM|COS",aCtrChEQU[ni][1]," "),If(cPaisLoc $ "EQU|DOM|COS",aCtrChEQU[ni][2]," "),nValMoed1,aPagos[ni][H_VALORIG])

		aTitPags[MAX(nMoedaPag,1)]	-=	aPagos[nI][H_TOTALVL]

	Else  // PAGO DIFERENCIADO

		If aSE2[ni][3][1]	== 4
			For nk := 1 to Len( aSE2[ni][3][2])
				If aSE2[ni][3][2][nK][nPosTpDoc] == "1"   // debito mediato
					lBaixaChqTmp	:=	lBaixaChq
					If   Type("nPosDeb")=="N" .And. nPosDeb > 0
						lBaixaChq	:=	IIf(aSE2[ni][3][2][nk][nPosDeb]=="0",.F.,.T.)
					Endif
					GravaPagos( 2, aSE2[ni][3][2][nK][nPosBanco], aSE2[ni][3][2][nK][nPosAge], aSE2[ni][3][2][nK][nPosConta],;
					aSE2[ni][3][2][nK][nPosNum], aPagos[ni][H_FORNECE], aPagos[ni][H_LOJA],aPagos[ni][H_NOME], ;
					Val(aSE2[ni][3][2][nK][nPosMoeda]), aSE2[ni][3][2][nK][nPosVlr], aSE2[ni][3][2][nK][nPosEmi], ;
					aSE2[ni][3][2][nK][nPosVcto], aSE2[ni][3][2][nK][nPosTipo],,,aSE2[ni][3][2][nK][nPosParc], nBaseITF, aHdlPrv ,lCBU,lPa,,,nValMoed1,aPagos[ni][H_VALORIG])
					lBaixaChq	:=	lBaixaChqTmp
				ElseIf aSE2[ni][3][2][nK][nPosTpDoc] == "2"   // debito inmediato
					GravaPagos( 3, aSE2[ni][3][2][nK][nPosBanco], aSE2[ni][3][2][nK][nPosAge], aSE2[ni][3][2][nK][nPosConta],;
					aSE2[ni][3][2][nK][nPosNum], aPagos[ni][H_FORNECE], aPagos[ni][H_LOJA],aPagos[ni][H_NOME], ;
					Val(aSE2[ni][3][2][nK][nPosMoeda]), aSE2[ni][3][2][nK][nPosVlr], aSE2[ni][3][2][nK][nPosEmi], ;
					aSE2[ni][3][2][nK][nPosVcto],, aSE2[ni][3][2][nK][nPosTipo],,aSE2[ni][3][2][nK][nPosParc], nBaseITF, aHdlPrv ,lCBU,lPa,,,nValMoed1,aPagos[ni][H_VALORIG])
				ElseIf aSE2[ni][3][2][nK][nPosTpDoc] == "3"   // cheque de terceiros
					GravaPagos( 4, aSE2[ni][3][2][nK][nPosBanco], aSE2[ni][3][2][nK][nPosAge], aSE2[ni][3][2][nK][nPosConta],;
					aSE2[ni][3][2][nK][nPosNum], aPagos[ni][H_FORNECE], aPagos[ni][H_LOJA],aPagos[ni][H_NOME], ;
					Val(aSE2[ni][3][2][nK][nPosMoeda]), aSE2[ni][3][2][nK][nPosVlr], aSE2[ni][3][2][nK][nPosEmi], ;
					aSE2[ni][3][2][nK][nPosVcto],,, aSE2[ni][3][3][nK],,nBaseITF, aHdlPrv ,lCBU,lPa,,,nValMoed1,aPagos[ni][H_VALORIG])
				EndIf
				If cPaisLoc=="PTG"
				   aSE2[ni][3][2][nK][nPosVlr]-= Val(aPagos[nI][H_DESPESAS])
    			EndIf
				// Acumular os valores pagos moeda por moeda.
				aTitPags[Val(aSE2[ni][3][2][nK][nPosMoeda])] -=	aSE2[ni][3][2][nK][nPosVlr]
			Next nK
			lPagoInf	:=	.T.
		Else
			If aSE2[ni][3][1] == 1  // cheque pre-impresso

					GravaPagos( aSE2[ni][3][1] , aSE2[ni][3][2], aSE2[ni][3][3], aSE2[ni][3][4],, aPagos[ni][H_FORNECE],;
					aPagos[ni][H_LOJA],aPagos[ni][H_NOME], nMoedaCor, aPagos[ni][H_TOTALVL],;
				dDataBase, aSE2[ni][3][5],,,,, nBaseITF, aHdlPrv ,lCBU,lPa,If(cPaisLoc $ "EQU|DOM|COS",aCtrChEQU[ni][1]," "),If(cPaisLoc $ "EQU|DOM|COS",aCtrChEQU[ni][2]," "),nValMoed1,aPagos[ni][H_VALORIG])

			ElseIf aSE2[ni][3][1]	==	2  // debito mediato
				lBaixaChqTmp	:=	lBaixaChq
				lBaixaChq	:=	aSE2[ni][3][7]
				GravaPagos( aSE2[ni][3][1] , aSE2[ni][3][2], aSE2[ni][3][3], aSE2[ni][3][4],, aPagos[ni][H_FORNECE],;
				aPagos[ni][H_LOJA],aPagos[ni][H_NOME], nMoedaCor, aPagos[ni][H_TOTALVL],;
				dDataBase, aSE2[ni][3][5], aSE2[ni][3][6],,aSE2[ni][3][7],,nBaseITF, aHdlPrv ,lCBU,lPa,If(cPaisLoc $ "EQU|DOM|COS",aCtrChEQU[ni][1]," "),If(cPaisLoc $ "EQU|DOM|COS",aCtrChEQU[ni][2]," "),nValMoed1,aPagos[ni][H_VALORIG])

				lBaixaChqp	:=	lBaixaChqTmp
			ElseIf aSE2[ni][3][1] == 3  // debito inmediato

				GravaPagos( aSE2[ni][3][1] , aSE2[ni][3][2], aSE2[ni][3][3], aSE2[ni][3][4],, aPagos[ni][H_FORNECE],;
				aPagos[ni][H_LOJA],aPagos[ni][H_NOME], nMoedaCor, aPagos[ni][H_TOTALVL],;
				dDataBase, dDataBase,, aSE2[ni][3][5],,,nBaseITF, aHdlPrv ,lCBU,lPa,,,nValMoed1,aPagos[ni][H_VALORIG])
			Endif
			SA6->(DbSeek(xFilial()+aSE2[ni][3][2]+aSE2[ni][3][3]+aSE2[ni][3][4]))
			nMoedaPag	:=	Iif(SA6->A6_MOEDAP>0,SA6->A6_MOEDAP,SA6->A6_MOEDA)
			aTitPags[MAX(nMoedaPag,1)]	-=	aPagos[nI][H_TOTALVL]
		EndIf
	EndIf
	
	If cPaisLoc $ 'MEX|PER' .and. !lPa
		lPERGenPA := cPaisLoc == "PER" .And. AllTrim(cDocCred) == "PA"
		//Valida Modalidad de operaci�n 
		If POSICIONE("SED",1,xFilial("SED")+SE2->E2_NATUREZ ,"ED_OPERADT") == '1'
			nValImps:= fVerifImp(aSE2[ni][1][1][_NUM], aSE2[ni][1][1][_PREFIXO],aSE2[ni][1][1][_PARCELA],aSE2[ni][1][1][_TIPO],aPagos[ni][H_FORNECE],aPagos[ni][H_LOJA])  // retorna el valor del Impuesto 			
			cParcLpa:= fRetParcel(aSE2[ni][1][1][_PREFIXO],aSE2[ni][1][1][_NUM],cDocCred,aPagos[ni][H_FORNECE],aPagos[ni][H_LOJA] )
			RecLock("SE2",.T.)
				SE2->E2_FILIAL	:= xFilial("SE2")
				SE2->E2_FILORIG   := xFilial()
				SE2->E2_NUMLIQ 	:= cLiquid
				SE2->E2_NUM    	:= aSE2[ni][1][1][_NUM]
				SE2->E2_PARCELA	:= cParcLpa
				SE2->E2_TIPO   	:= cDocCred
				SE2->E2_FORNECE	:= aPagos[ni][H_FORNECE]
				SE2->E2_LOJA   	:= aPagos[ni][H_LOJA   ]
				SE2->E2_NOMFOR 	:= aPagos[ni][H_NOME   ]
				SE2->E2_EMISSAO	:= dDataBase
				SE2->E2_EMIS1  	:= dDataBase
				SE2->E2_VENCTO 	:= dDataBase
				SE2->E2_VENCORI	:= dDataBase
				SE2->E2_VENCREA	:= DataValida(dDataBase,.T.)
				If lPERGenPA //Valida Generacion de PA en PER
					SE2->E2_VALOR 	:= Abs(SF1->F1_VALMERC)
					SE2->E2_SALDO  	:= SF1->F1_VALMERC
					SE2->E2_VLCRUZ 	:= Round(xMoeda(Abs(SF1->F1_VALMERC), aSE2[ni][1][1][_MOEDA], 1, , 5, aSE2[ni][1][1][_TXMOEDA]), MsDecimais(1))
				Else
					SE2->E2_VALOR 	:= Abs(aSE2[ni][1][1][_PAGAR])
					SE2->E2_SALDO  	:= aSE2[ni][1][1][_PAGAR] - nValImps 
					SE2->E2_VLCRUZ 	:= Round(xMoeda(Abs(aSE2[ni][1][1][_PAGAR]),aSE2[ni][1][1][_MOEDA],1,,5,aTxMoedas[1][2]),MsDecimais(1))
				EndIf
				SE2->E2_MOEDA  	:= aSE2[ni][1][1][_MOEDA]
				SE2->E2_PREFIXO	:= aSE2[ni][1][1][_PREFIXO]
				If FieldPos("E2_TXMOEDA")>0
					SE2->E2_TXMOEDA := IIf(lPERGenPA, aSE2[ni][1][1][_TXMOEDA], aTxMoedas[1][2])//GRAVA A TAXA DA MOEDA DO PA
				EndIf
				If SE2->(FieldPos("E2_CGC")) > 0
					SE2->E2_CGC		:= SA2->A2_CGC
				EndIf

				//Dados para Inclusao de adiantamento via pedido de compras
				aRecAdt := {SE2->(RECNO()),SE2->E2_VALOR}

				aAreaSA2:= SA2->(GetArea())
				SA2->(DbSetOrder(1))
				SA2->(DbSeek(xFilial("SA2")+aPagos[ni][H_FORNECE]+ aPagos[ni][H_LOJA   ]) )
			
				 IF Empty(cNatureza)
				      SE2->E2_NATUREZ	:=  Iif( Empty(SA2->A2_NATUREZ), &(GetMv("MV_2DUPNAT")) , SA2->A2_NATUREZ )
				   else
				      SE2->E2_NATUREZ := cNatureza
				 Endif
				SA2->(RestArea(aAreaSA2))

				SE2->E2_SITUACA	:= "0"
				SE2->E2_ORDPAGO	:= cOrdpago
				SE2->E2_ORIGEM 	:= "FINA085A"
				If !lUsaFlag
					SE2->E2_LA        	:= "S"
				EndIf
				MsUnlock()
		EndIf	
	EndIf

	//�������������������������������������������������������������������Ŀ
	//�Compensar os valores recebidos em difernetes moedas com os valores �
	//�escolhidos para baixa em diferentes moedas                         �
	//���������������������������������������������������������������������
	If lPagoInf .Or.lPa
		a085aCmpMoeds(@aTitPags)

		For nA	:=	1	To	Len(aTitPags)
			If aTitPags[nA] < 0  // GERA PA - PAGO ANTECIPADO

				DbSelectArea("SEK")
				RecLock("SEK",.T.)
				SEK->EK_FILIAL	:= xFilial("SEK")
				SEK->EK_TIPODOC	:= "PA" //Pago adelantado
				SEK->EK_NUM    	:= cOrdPago
				SEK->EK_PARCELA	:= ALLTrim(STR(nA))
				SEK->EK_TIPO   	:= cDocCred
				SEK->EK_FORNECE	:= aPagos[ni][H_FORNECE]
				SEK->EK_LOJA   	:= aPagos[ni][H_LOJA   ]
				SEK->EK_EMISSAO	:= dDataBase
				SEK->EK_VENCTO 	:= dDataBase
				SEK->EK_VALOR  	:= Abs(aTitPags[nA])
				SEK->EK_SALDO  	:= Abs(aTitPags[nA])
				SEK->EK_VLMOED1	:= Round(xMoeda(Abs(aTitPags[nA]),nA,1,,5,aTxMoedas[nA][2]),MsDecimais(1))
				SEK->EK_MOEDA  	:= Alltrim(Str(nA))
				SEK->EK_ORDPAGO	:= cOrdpago
				SEK->EK_DTDIGIT	:= dDataBase
            	SEK->EK_FORNEPG 	:= aPagos[ni][H_FORNECE]
            	SEK->EK_LOJAPG 	:= aPagos[ni][H_LOJA]
				If (SEK->(FieldPos('EK_NUMOPER')) <> 0)
					SEK->EK_NUMOPER := cNumOp
				EndIf
				If (SEK->(FieldPos('EK_TOTANT')) <> 0)
					SEK->EK_TOTANT := nTotAnt
				EndIf
				If (SEK->(FieldPos('EK_GRPSUS')) <> 0)
					SEK->EK_GRPSUS := cGrSUSS
				EndIf
				If (SEK->(FieldPos('EK_TES')) <> 0)
	                If Type("cCF")<>"U"
    	        		SEK->EK_TES := cCF
        	    	EndIf
            	EndIf
				If (SEK->(FieldPos('EK_PROV')) <> 0)
            		If Type("cProv")<>"U"
            			SEK->EK_PROV := cProv
	            	EndIf
	            EndIf
	            If SEK->(FieldPos("EK_PGCBU")) > 0
		   			SEK->EK_PGCBU	:= aPagos[ni][H_CBU]
		   		Endif
				If (SEK->(FieldPos('EK_NATUREZ')) <> 0)
           			SEK->EK_NATUREZ := cNatureza
	            EndIf
				If cPaisLoc == "MEX" .And. cPaisProv <> "493"
					If SEK->(FieldPos("EK_DCONCEP")) > 0
					   SEK->EK_DCONCEP := AllTrim(cDesc)
					Endif
				EndIf
				If cPaisLoc == "MEX"  .and. SEK->(FieldPos("EK_UUID")) > 0
					SEK->EK_UUID := __cUUID
				EndIf
            	F085AGrvTx()
				MsUnlock()
				//����������������������������������������������������������Ŀ
				//� Grava os lancamentos nas contas orcamentarias SIGAPCO    �
				//������������������������������������������������������������
				PcoDetLan("000313","02","FINA085A")
				dbSelectArea("SE2")
				RecLock("SE2",.T.)
				SE2->E2_FILIAL	:= xFilial("SE2")
				SE2->E2_FILORIG   := xFilial()
				SE2->E2_NUMLIQ 	:= cLiquid
				SE2->E2_NUM    	:= cOrdPago
				SE2->E2_PARCELA	:= AllTrim(STR(nA))
				SE2->E2_TIPO   	:= cDocCred
				If 	cPaisLoc $ "DOM|COS|ARG" .And. !Empty(cNatureza) .And.  lPa
					SE2->E2_NATUREZ := cNatureza
				EndIf
				SE2->E2_FORNECE	:= aPagos[ni][H_FORNECE]
				SE2->E2_LOJA   	:= aPagos[ni][H_LOJA   ]
				SE2->E2_NOMFOR 	:= aPagos[ni][H_NOME   ]
				SE2->E2_EMISSAO	:= dDataBase
				SE2->E2_EMIS1  	:= dDataBase
				SE2->E2_VENCTO 	:= dDataBase
				SE2->E2_VENCORI	:= dDataBase
				SE2->E2_VENCREA	:= DataValida(dDataBase,.T.)
				SE2->E2_VALOR 	:= Abs(aTitPags[nA])
				SE2->E2_SALDO  	:= Abs(aTitPags[nA])
				SE2->E2_VLCRUZ 	:= Round(xMoeda(Abs(aTitPags[nA]),nA,1,,5,aTxMoedas[nA][2]),MsDecimais(1))
				SE2->E2_MOEDA  	:= nA
				If FieldPos("E2_TXMOEDA")>0
					SE2->E2_TXMOEDA := aTxMoedas[nA][2]//GRAVA A TAXA DA MOEDA DO PA
				EndIf
				If SE2->(FieldPos("E2_CGC")) > 0
					SE2->E2_CGC		:= SA2->A2_CGC
				EndIf

				//Dados para Inclusao de adiantamento via pedido de compras
				aRecAdt := {SE2->(RECNO()),SE2->E2_VALOR}

				aAreaSA2:= SA2->(GetArea())
				SA2->(DbSetOrder(1))
				SA2->(DbSeek(xFilial("SA2")+aPagos[ni][H_FORNECE]+ aPagos[ni][H_LOJA   ]) )
				IF !(cPaisLoc$"PER|DOM|COS|ARG")
				   SE2->E2_NATUREZ	:=  Iif( Empty(SA2->A2_NATUREZ), &(GetMv("MV_2DUPNAT")) , SA2->A2_NATUREZ )
				  ELSE
				   IF Empty(cNatureza)
				      SE2->E2_NATUREZ	:=  Iif( Empty(SA2->A2_NATUREZ), &(GetMv("MV_2DUPNAT")) , SA2->A2_NATUREZ )
				     else
				      SE2->E2_NATUREZ := cNatureza
				   Endif
				Endif
				SA2->(RestArea(aAreaSA2))

				SE2->E2_SITUACA	:= "0"
				SE2->E2_ORDPAGO	:= cOrdpago
				SE2->E2_ORIGEM 	:= "FINA085A"
				If !lUsaFlag
					SE2->E2_LA        	:= "S"
				EndIf
				//Integra��o Protheus X TOP - Argentina  e Mexico
				If !lMsgUnica
					If nColig >0 .and. IntePMS() .and.  MsgYesNo(OemToAnsi(STR0247)+" "+"("+cDocCred+")"+" "+AllTrim(SE2->E2_NUM)+" " +OemToAnsi(STR0248)+" "+;
					GetMv("MV_SIMB1")+" "+ AllTrim(Transform(SE2->E2_VLCRUZ,PesqPict("SE2","E2_VLCRUZ")))+ " " + OemToAnsi(STR0249))//"Deseja associar o  Titulo" "de valor" "a um projeto?"
						PmsFi085A()
					endif
				Endif
				MsUnlock()

				If lUsaFlag // Armazena em aFlagCTB para atualizar no modulo Contabil
					aAdd( aFlagCTB, { "E2_LA", "S", "SE2", SE2->( RecNo() ), 0, 0, 0} )
				EndIf

				If ExistBlock("A085ATIT")
					ExecBLock("A085ATIT",.F.,.F.)
				Endif

			ElseIf aTitPags[nA] > 0   // NEGATIVO - DIF. SER� PAGA DE FORMA DEFAULT

				GravaPagos( nPagar, cBanco, cAgencia, cConta,, aPagos[ni][H_FORNECE],;
				aPagos[ni][H_LOJA],aPagos[ni][H_NOME], nA  , aTitPags[nA] ,;
				dDataBase,Iif(nPagar==1,dDataVenc1,dDataVenc) , cDebMed, cDebInm, lBaixaChq,, ;
				nBaseITF, aHdlPrv ,lCBU,lPa,,,nValMoed1,aPagos[ni][H_VALORIG])
			EndIf

		Next
	Endif

 	If cPaisloc=="PTG" .And. !lPa
   		GravaDesp( aPagos[ni][H_FORNECE],aPagos[ni][H_LOJA],aSE2[nI][4] )
   	EndIf

// Calculo e grava��o de Ganacias e Ingressos Brutos para os PA�s gerados devido a inser��o
// de um valor maior do que do que o valor total da ordem de pago
		If cPaisLoc=="ARG" .And. (SE2->E2_TIPO $ MVPAGANT) .And. lRetPA .And. !lPa
			nTotal:= 0
			nTotImp:=0
			cChave:= SE2->E2_FORNECE+SE2->E2_LOJA

		aConGan	:=	{{SA2->A2_AGREGAN,Round(xMoeda(nBaseRet,nMoedaCor,1,,5,aTxMoedas[nMoedaCor][2]),MsDecimais(1)),'',cChave,If(lMSFil,SE2->E2_MSFIL,"")}}
		    RateioCond(@aRateioGan)

			For nY	:=	1	To Len(aConGan)
				For nX:= 1 To Len(aRateioGan)
					AAdd(aConGanRat,{aConGan[nY][1],aConGan[nY][2]*aRateioGan[nX][4],aConGan[nY][3],aRateioGan[nX][2]+aRateioGan[nX][3]})
				Next
			Next

			For nY := 1 TO Len(aConGanRat)
				nPosGan   := ASCAN(aConGan,{|x|  x[1]+x[3]+x[4] == aConGanRat[nY][1]+aConGanRat[nY][3]+aConGanRat[nY][4] })
				If nPosGan==0
					Aadd(aConGan,aClone(aConGanRat[nY]))
				Endif
			Next
			aSE21:={}
			nSigno  :=   1
			aTmp	:=	CalcRetGN(cAgente,,aConGan,aSE2[1][1][1][1],aSE2[1][1][1][2])
			AaddSE2(1,aSE21,.T.)
			If Len(aSE2[1][1][1][_RETIB]) > 0

				aConfProv := CheckConfIB(SE2->E2_FORNECE,SE2->E2_LOJA,Iif(Type("cPrvEnt") == "U",cProv,cPrvEnt),If(lMsFil,SE2->E2_MSFIL," "))

				For nX := 1 to Len(aConfProv)
				 	aTmp1:=	CalcRetIB(cAgente,nSigno,nBaseRet,aSE2[1][1][1][15][1][11],aConfProv[nX][1],.T.,,aConfProv[nX])
					If Len(aTmp1) > 0
						aTmp1[1][1]:=""

						For nY := 1 to Len(aTmp1)
							aAdd(aTmpIB, Array(12))
							aTmpIB[Len(aTmpIb)] := aTmp1[nY]
						Next nY

						aTmp1   := {}
					EndIf
				Next nX

		  		aSE21[1,1,1,_RETIB]	:=aClone(aTmp1)
		  		a085aGravRet(aSE21[1,1,1],aPagos[ni][2],aPagos[ni][3],,.F.,@aTitPags,nMoedaRet,,aPagos[ni][H_CBU])
   			EndIf

			aSE21[1][2]	:=	ACLONE(aTmp)
			a085aGravRet(aSE21[1,2],aPagos[ni][2],aPagos[ni][3],,.T.,@aTitPags,nMoedaRet,,aPagos[ni][H_CBU])

			nTotRetIb:= Iif(Len(aTmp1)>0,aTmp1[1][6],0)
			nTotRetGn:= Iif(Len(aTmp)>0,aTmp[1][4],0)
			RecLock("SE2",.F.)
			Replace SE2->E2_VALOR With SE2->E2_VALOR + nTotRetGn + nTotRetIb
			Replace SE2->E2_SALDO With  SE2->E2_VALOR
			Replace SE2->E2_VLCRUZ With  SE2->E2_SALDO
			MsUnlock()

			dbSelectArea("SEK")
			SEK->(DbSetOrder(1))
			SEK->(DbSeek(xFilial("SEK")+SE2->E2_NUM+SE2->E2_TIPO))
			RecLock("SEK",.F.)
			Replace SEK->EK_VALOR With SEK->EK_VALOR + nTotRetGn + nTotRetIb
			Replace SEK->EK_SALDO With  SEK->EK_VALOR
			Replace SEK->EK_VLMOED1 With  SEK->EK_VALOR
			MsUnlock()

		EndIf
	//Ajuste de Valores para a Reten��o do PA
	If cPaisLoc $ "DOM|COS"  .And. lPa .And. !Empty(cNatureza)
		//Gera��o das Reten��es de Impostos
	    If SE2->E2_TIPO	<>	"CH"
			fa085GerRet("9", cNatureza, SE2->E2_VALOR, SE2->E2_PREFIXO, SE2->E2_NUM, SE2->E2_FORNECE)
		EndIf
	   	fa085GerRet("2", cNatureza, SE2->E2_VALOR, SE2->E2_PREFIXO, SE2->E2_NUM, SE2->E2_FORNECE)
		nVlrRet 	:= F085PesAbt()
		//Ajustar Valor do CH (SE2)
		cPrefix  := SE2->E2_PREFIXO
		nNum     := SE2->E2_NUM
		nFornec  := SE2->E2_FORNECE
		cParcela := " "
		cTipoDoc := "CH"
		aAreaSE2 := SE2->(GetArea())
		cFilterSE2	:= SE2->(dbFilter())
	 	dbSelectArea("SE2")
	 	SE2->(dbClearFilter()) //limpa o filtro para selecao das parcelas ja baixadas.
	 	SE2->(dbGoTop())
		SE2->(DbSetOrder(1)) //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
		SE2->(DbSeek(xFilial("SE2")+AvKey(cPrefix,"E2_PREFIXO")+AvKey(nNum,"E2_NUM")+AvKey(cParcela,"E2_PARCELA")+AvKey(cTipoDoc,"E2_TIPO")+AvKey(nFornec,"E2_FORNECE")))
		while xFilial() == SE2->E2_FILIAL .And. cPrefix==SE2->E2_PREFIXO .And. nNum==SE2->E2_NUM .AND. SE2->(!EOF())
			If ALLTRIM(SE2->E2_TIPO) $ "CH|PA"
				RecLock("SE2",.F.)
				Replace SE2->E2_VALOR  With  SE2->E2_VALOR - nVlrRet
				Replace SE2->E2_SALDO  With  SE2->E2_VALOR
				Replace SE2->E2_VLCRUZ With  SE2->E2_VALOR
				MsUnlock()
			Else
				Replace	SE2->E2_ORDPAGO With cOrdpago
			EndIf
			SE2->(DbSkip())
		Enddo

		SE2->(RestArea(aAreaSE2))
	 	Set Filter to &cFilterSE2 //aplica o filtro novamente

		//Ajustar Valor do CH (SEF)
		aAreaSEF:= SEF->(GetArea())
		SEF->(DbSetOrder(3))  //EF_FILIAL+EF_PREFIXO+EF_TITULO+EF_PARCELA+EF_TIPO+EF_NUM+EF_SEQUENC
		SEF->(DbSeek(xFilial("SEF")+AvKey(cPrefix,"EF_PREFIXO")+AvKey(nNum,"EF_TITULO")))
		Do while xFilial() == SEF->EF_FILIAL .And. cPrefix==SEF->EF_PREFIXO .And. nNum==SEF->EF_NUM .AND. SEF->(!EOF())
			If ALLTRIM(SEF->EF_TIPO) $ "CH|PA"
				RecLock("SEF",.F.)
		   		Replace SEF->EF_VALOR  With  SE2->E2_VALOR
				MsUnlock()
			EndIf
			SEF->(DbSkip())
		Enddo
		SEF->(RestArea(aAreaSEF))

		//Ajustar Valor do CH (SEK)
		aAreaSEK:= SEK->(GetArea())
		SEK->(DbSetOrder(1)) //EK_FILIAL+EK_ORDPAGO+EK_TIPODOC+EK_PREFIXO+EK_NUM+EK_PARCELA+EK_TIPO+EK_SEQ
		SEK->(DbSeek(xFilial("SEK")+AvKey(nNum,"EK_ORDPAGO")))
		Do while xFilial() == SEK->EK_FILIAL .And. AllTrim(nNum)==SEK->EK_ORDPAGO .AND. SEK->(!EOF())
			If ALLTRIM(SEK->EK_TIPO) $ "CH|PA"
				RecLock("SEK",.F.)
				Replace SEK->EK_VALOR  	With  SE2->E2_VALOR
				Replace SEK->EK_VLMOED1 With  SE2->E2_VALOR
				If ALLTRIM(SEK->EK_TIPO) == "PA"
					Replace SEK->EK_SALDO  	With  SE2->E2_VALOR
				EndIf
				MsUnlock()
			EndIf
			SEK->(DbSkip())
		Enddo
		SEK->(RestArea(aAreaSEK))

		aPagos[nI][H_TOTALVL] := aPagos[nI][H_TOTALVL] - nVlrRet

	EndIf

	AtuaSaldos( aSE2[ni], aPagos[ni][H_DESCVL]+aPagos[ni][H_TOTALVL]+IIf(cPaisLoc=="ARG" .Or. cPaisLoc$"URU|BOL|PTG|ANG|PER|EQU|DOM|COS",aPagos[ni][H_TOTRET],0);
	,aPagos[nI][H_FORNECE],aPagos[nI][H_LOJA],@nFlagMOD,@nCtrlMOD)

	//+---------------------------------------------------------+
	//� Atualiza parametro do Ultimo n�mero da Liquida��o...    �
	//+---------------------------------------------------------+
    PUTMV("MV_NUMLIQ", cLiquid )

	AAdd(aNums,{cOrdPago,aPagos[nI][H_FORNECE],aPagos[nI][H_LOJA],aPagos[nI][H_NOME],IIF(Alltrim(_cTipo)=="TX".And.cPaisLoc <> "PER",Round(aPagos[nI][H_TOTALVL],0),aPagos[nI][H_TOTALVL]),lCBU})

	If nHdlPrv > 0 .and. lLancPad70

		//+--------------------------------------------------+
		//� Gera Lancamento Contab. para Orden de Pago.      �
		//+--------------------------------------------------+
		If lLancPad70
			SEK->(DbSetOrder(1))
			SEK->(DbSeek(xFilial("SEK")+cOrdPago,.F.))
			nRECSEKdiario := SEK->(Recno())
			SA2->(DbsetOrder(1))
			SA2->(DbSeek(xFilial("SA2")+SEK->EK_FORNECE+SEK->EK_LOJA) )
			aArea := SEK->(GetArea()) //Pega area para depois restaurar e gravar
										//os registros originais do SEK no SI2 - Chile -
										//08/05/02 - Jose Aurelio
			DbSelectArea("SEK")
			Do while !SEK->(EOF()).And.SEK->EK_ORDPAGO==cOrdPago

				SA6->(DbsetOrder(1))
				SA6->(DbSeek(xFilial("SA6")+SEK->EK_BANCO+SEK->EK_AGENCIA+SEK->EK_CONTA,.F.))

				Do Case
					Case ( Alltrim(SEK->EK_TIPO) == Alltrim(GetSESnew("NCP")) )
						cAlias := "SF2"
					Case ( Alltrim(SEK->EK_TIPO) == Alltrim(GetSESnew("NDI")) )
						cAlias := "SF2"
					Otherwise
						cAlias := "SF1"
				EndCase
				cKeyImp := 	xFilial(cAlias)	+;
							SEK->EK_NUM		+;
							SEK->EK_PREFIXO	+;
							SEK->EK_FORNECE	+;
							SEK->EK_LOJA
				If ( cAlias == "SF1" )
					cKeyImp += SE1->E1_TIPO
				Endif
				If lUsaFlag // Armazena em aFlagCTB para atualizar no modulo Contabil
					aAdd( aFlagCTB, { "EK_LA", "S", "SEK", SEK->( RecNo() ), 0, 0, 0} )
				EndIf

				Posicione(cAlias,1,cKeyImp,"F"+SubStr(cAlias,3,1)+"_VALIMP1")

				nTotalLanc := nTotalLanc + DetProva( 	nHdlPrv,;
									                    "570",;
									                    "FINA085" /*cPrograma*/,;
									                    cLoteCom,;
									                    /*@nLinha*/,;
									                    /*lExecuta*/,;
									                    /*cCriterio*/,;
									                    /*lRateio*/,;
									                    /*cChaveBusca*/,;
									                    /*aCT5*/,;
									                    /*lPosiciona*/,;
									                    @aFlagCTB,;
									                    /*aTabRecOri*/,;
									                    /*aDadosProva*/ )

				SEK->(DbSkip())
			EndDo
			RestArea(aArea)
		Endif

		//+-----------------------------------------------------+
		//� Envia para Lancamento Contabil, se gerado arquivo   �
		//+-----------------------------------------------------+
		RodaProva(  nHdlPrv,;
					nTotalLanc )

		//+-----------------------------------------------------+
		//� Envia para Lancamento Contabil, se gerado arquivo   �
		//+-----------------------------------------------------+
		If ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )
			aDiario := {}
			aDiario := {{"SEK",nRECSEKdiario,cCodDiario,"EK_NODIA","EK_DIACTB"}}
		Else
			aDiario := {}
		EndIf

		If lLancPad70 .And. !lUsaFlag
			SEK->(DbSetOrder(1))
			SEK->(DbSeek(xFilial("SEK")+cOrdPago))
			Do while xFilial() == SEK->EK_FILIAL .And. cOrdPago==SEK->EK_ORDPAGO.AND.SEK->(!EOF())
				RecLock("SEK",.F.)
				Replace SEK->EK_LA With "S"
				MsUnLock()
				SEK->(DbSkip())
			Enddo
		EndIf

		SET KEY VK_F4 to
		SET KEY VK_F5 to
		SET KEY VK_F6 to
		SET KEY VK_F7 to

	EndIf

	//�������������������������������������������������Ŀ
	//�Desmarca itens apos a finaliazacao da transacao  �
	//�pois todos os registros foram deslocados         �
	//���������������������������������������������������
	Eval(bFiltraBrw)
	DbSelectArea('SE2')
	For nA := 1 To Len(aRecNoSE2)
		MsGoTo(aRecNoSE2[nA][08])
		If IsMark("E2_OK",cMarcaE2)
			RecLock("SE2",.F.)
			Replace E2_OK With "  "
            nCtrlMOD-=1     //controle de sele��o no browse para Natureza/ITF
            If nCtrlMOD==0
               nFlagMOD:=0
            Endif
			MsUnlock()
		Endif
	Next nI

	End Transaction
	If nHdlPrv > 0 .and. lLancPad70
		//�����������������������������������������������������Ŀ
		//� Envia para Lancamento Contabil                      �
 		//�������������������������������������������������������
		cA100Incl( 	cArquivo,;
							nHdlPrv,;
							3 /*nOpcx*/,;
							cLoteCom,;
							lDigita,;
							lAglutina,;
							/*cOnLine*/,;
							/*dData*/,;
							/*dReproc*/,;
							@aFlagCTB,;
							/*aDadosProva*/,;
							aDiario )

		aFlagCTB := {}  // Limpa o coteudo apos a efetivacao do lancamento
	Endif
Next

If Len(aNums) > 0
	If !lF085NoShw //Controle do usu�rio quanto a exibi��o da tela de confirma��o de oden de pago
		a085aShow(aNums,GetMBrowse())
	EndIf
EndIf

If ExistBlock("A085AFIM")
	ExecBLock("A085AFIM",.F.,.F.,aNums)
Endif

//Gera diferen�a de cambio automatica
If (SE2->(FieldPos('E2_CONVERT')) <> 0)
	If SE2->E2_CONVERT <> 'N' .And. cPaisLoc $ "ARG|BOL|URU" .And. lGeraDCam .And. lTemMon .And. !lPa
		nI:=1
		DbSelectArea("SE2")

		#IFDEF TOP
			cFilter		:=	DbFilter()
			DbClearFilter()
		#ELSE
		 	aAreaSE2	:=	GetArea()
		#ENDIF


		For nI := 1 To Len(aSE2)
			For Nc:=1  to  Len(aSE2[ni][1])
				cForn 	:= aSE2[nI][1][nC][01]
				cLoja		:= aSE2[nI][1][nC][02]
				cPrefixo	:= aSE2[nI][1][nC][09]
				nNum      	:= aSE2[nI][1][nC][10]
				cParcela	:= aSE2[nI][1][nC][11]
				cTipo  		:=aSE2[nI][1][nC][12]
				cMoeda:=	aSE2[nI][1][nC][04]
			SE2->(dbSetOrder(6))
			SE2->(dbSeek(xFilial("SE2")+cForn+cLoja+cPrefixo+nNum+cParcela+cTipo))
			If xFilial()==SE2->E2_FILIAL .And. nNum==SE2->E2_NUM .AND. cPrefixo==SE2->E2_PREFIXO .And. cParcela==SE2->E2_PARCELA .AND. SE2->(!EOF())
				lExterno:=.T.

				lExecCor:=.T.
				nPosIni:=1
				While lExecCor
					Pergunte("FIN84A",.F.)
			  		If(Empty(MV_PAR01))
			  			MV_PAR01:=0
			  		EndIf
					MV_PAR07:=2
	  		  		MV_PAR08:=1
	 		 		aArea:=GetArea()
				  If!Empty(nMoedaCor:=Val(Subs(GetMv("MV_MDCFIN"),nPosIni,2)))
						If !Empty(GetMv("MV_MOEDA"+Alltrim(Str(nMoedaCor))))
							MV_PAR11:=nMoedaCor
								cmoeda:=	aSE2[nI][1][nC][04]
							nTxaAtual:= aTxMoedas[nMoedaCor][2]
							nMoedaTit:=aTxMoedas[cmoeda][2]
							if nTasaCon==nMoedaCor  .or. cPaisLoc!='URU'
								FA084GDif(.F.,,,lExterno)
							EndIf

						EndIf
				  		nPosIni:=nPosIni+3
				  		RestArea(aArea)
				 	Else
					 	lExecCor:=.F.
				 	EndIf
		      EndDo


			EndIf
			Next nC
		Next nI

		DbSelectArea("SE2")

		#IFDEF TOP
			SET FILTER TO &cFilter.
		#ELSE
		 	RestArea(aAreaSE2)
		#ENDIF
	EndIf
EndIf

MsUnlockAll()

If ExistBlock("A085AFM2")
	ExecBlock("A085AFM2",.F.,.F.,{aNums})
EndIf

//************************
// Retira sele��o do SE2 *
//************************/
For nA := 1 To Len(aRecNoSE2)
	MsGoTo(aRecNoSE2[nA][08])
	If IsMark("E2_OK",cMarcaE2)
		RecLock("SE2",.F.)
		Replace E2_OK With "  "
		MsUnLock()
	EndIf
Next nI
Pergunte("FIN85A",.F.)
aRecnoSE2	:=	{}
Return

/*
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � ProcOrdPag Autor � Bruno Sobieski        � Data � 23.02.99 ���
��+----------+------------------------------------------------------------���
���Descri��o � Funcion Ppal de generacion de orden de pago.               ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
*/
Function FA085SE2(aSE2,lNaoMarca,lFinr995)
Local nControl := 0
Local nZ,nA,nY,nB
Local aConGan  := {}
Local aAreaSe2, nTotOrden	:= 0
Local cAgente	:= GETMV("MV_AGENTE")
Local nSigno   := 1
Local lEOFIND	:=	.F.
Local aTmp		:= {}
Local aTmp1		:= {}
Local nSaldo	:= 0
Local aValZona := {}
Local lNewOp := .T.
Local cCondAgr
Local cFilSE2
Local aOrdPg := {}
Local nI:=0, nX:=0 ,nR:=0
Local aRateioGan	:=	{}
Local nPropImp := 1
Local nVLCalcRet 	:= 0
Local nValTotBas	:= 0
Local nTotSuss	:= 0
Local nProp:=1
Local lMonotrb := .F. //Fornecedor monotribustista
Local aIVA := {}
Local aGan := {}
Local aIB	:= {}
Local aSUSS := {}
Local lGMnParc := .T. //Controle de baixas parciais de Ganancia - titulos pacelados
Local nTTit := 0
Local lPropIB	:= Iif(GetMV("MV_PROPIB",.F.,1)==2,.T.,.F.)
Local lPropIVA	:= Iif(GetMV("MV_PROPIVA",.F.,2)==2,.T.,.F.)
Local aParc		:= {}
Local cChave	:= ""
Local cFilterSE2:= ""
Local nRecnoSE2	:= 0
Local  nAliqigv := 0  //aliquota para calculo de retencao do igv
Local aCalcigv  := {} //array para calculo do igv para compensa�ao
Local lSub      := .f.
Local lSom      := .f.
Local nBaseIGV  := 0
Local aConfProv	:= {}
Local aTmpIb	:= {}
Local lContCBU 	:= .F.
Local lValLimite := .T.
Local lpv_MIBB := .F.
//Republica Dominicana
Local cNroCert  := " "
Local cTipOp		:= ""
Local cPrefixo  := " "
Local nNum		:= 0
Local nValBase	:= 0
Local nValImp   := 0
Local nValRet   := 0
Local nOpAnt		:= 0
Local nPs			:= 0
Local nLPs		:= 0
Local aSaveArea1 := GetArea()
Local aAreaSEK := {}   
Local aAreaSFE := {}
Local lReten	:= .F.
Local nValor	:= 0
Local nValAcDia	:= 0
Local nValAcMes	:= 0
Local dDtPesq	:= Ctod("//")
Local nVlAcmPg	:= 0
Local dDataIni:=firstdate(ddatabase)
Local dDataFim:=LastDate(ddatabase)  
//Acumulados Paraguay
Local nVlAcmPg	:= 0            

DEFAULT lFinr995  := .F.
DEFAULT lNaoMarca := .F.

Private cFornece  := ""
Private cLoja     := ""
Private cPrvEnt   := ""
Private aSFEIGV   := {}
Private cNatureza:=Criavar("ED_CODIGO")

lBxParc := IIf( Type("lBxParc")=="U", Iif(SE2->(FieldPos("E2_VLBXPAR")>0),.T.,.F.), lBxParc)

//Se nao existirem os campos necessarios agrupa pagamentos por cliente+filial
DbSelectArea("SEK")
aSE2		:= {}
DbClearFilter()
DbSelectArea("SE2")
DbSetOrder(6)
cFilSE2:=xFilial("SE2")

//Ordena o array de acordo com a ordem 6...
aSort(aRecNoSE2,,,{|x,y| x[1]+x[2]+x[3]+x[4]+x[5]+x[6]+x[7] < y[1]+y[2]+y[3]+y[4]+y[5]+y[6]+[7]})

//Prepara o array aOrdPg para possam ser montadas as Ordens de Pago...
aEval(aRecNoSE2,{|x,y| MArray(y,cFilSE2,nCondAgr,@aOrdPg)})

//Verifica se existem faturas com e sem CBU em uma mesma sele��o.
//Obs.: Os dados ser�o separados para que sejam geradas Ordens de Pago diferentes

If Type("aRetIvAcm") <> "U"
	aRetIvAcm := Array(3)
EndIf

If cPaisLoc=='MEX'
	For nLPs := 1 To Len(aOrdPg)
		For nPs:= 1 to Len(aOrdPg[nLPs][4])
			DbSelectArea('SE2')
			MsGoTo(aOrdPg[nLPs][4][nPs])
			cTipOp:= POSICIONE("SED",1,xFilial("SED")+SE2->E2_NATUREZ ,"ED_OPERADT")
			//Valida Modalidad de operaci�n 
			If cTipOp == '1'
				nOpAnt++
			EndIf
		Next
	Next
	If nOpAnt > 1 .OR. (nOpAnt == 1 .AND. Len(aOrdPg) > 1 )
		MSGALERT(STR0260, "") //Para compensar una factura de tipo anticipo solo puede seleccionar una a la vez
		Return .F.
	EndIf		
EndIf
ProcRegua(Len(aRecNoSE2))
If lRetPA == Nil
	lRetPA := (GetNewPar("MV_RETPA","N") == "S")
EndIf
SA2->( dbSetOrder(1) )
SA2->( dbSeek(xFilial("SA2")+cFornece+cLoja) )
lMonotrb := Iif(SA2->A2_TIPO == "M" .And. SA2->(FieldPos("A2_CMONGAN"))>0,.T.,.F.)

aTotIva:={}
For nI := 1 To Len(aOrdPg)
	cFornece := aOrdPg[nI][02]
	cLoja    := aOrdPg[nI][03]
	SA2->( dbSetOrder(1) )
	If lMsFil .And. !Empty(xFilial("SA2")) .And. (nCondAgr <> 3) .And. xFilial("SF1") == xFilial("SA2")
		SE2->(DbGoTo(aOrdPg[nI][4][1]))
		SA2->(DbSeek(SE2->E2_MSFIL+cFornece+cLoja) )
	Else
		SA2->( dbSeek(xFilial("SA2")+cFornece+cLoja) )
	Endif
	If !RateioCond(@aRateioGan)
		aSE2	:=	{}
		Return .F.
	Endif
	lMonotrb := Iif(SA2->A2_TIPO == "M" .And. SA2->(FieldPos("A2_CMONGAN"))>0,.T.,.F.)
	nTotOrden := 0
	aConGan   := {}
	nControl++
	For nX := 1 To Len(aOrdPg[nI][4])
		IncProc()
		DbSelectArea('SE2')
		MsGoTo(aOrdPg[nI][4][nX])
		If lNaoMarca .Or. IsMark("E2_OK",cMarcaE2)
			If ((nCondAgr >= 2) .And. (E2_FORNECE+E2_LOJA != cFornece+cLoja)) .Or.;
			   ((nCondAgr == 2) .And. (E2_FORNECE+E2_LOJA != cFornece+IIf(Len(cLoja) == 0,Space(TamSX3("E2_LOJA")[1]),cLoja)) .And. SE2->E2_TIPO $ "NCP")
				cFornece := E2_FORNECE
				cLoja    := E2_LOJA
				SA2->( dbSetOrder(1) )
				If lMsFil .And. !Empty(xFilial("SA2")) .And. xFilial("SF1") == xFilial("SE2")
					SA2->( DbSeek(SE2->E2_MSFIL+cFornece+cLoja) )
				Else
					SA2->( dbSeek(xFilial("SA2")+cFornece+cLoja) )
				Endif
			EndIf

			// Correcao do Saldo a maior em Porto Rico
			If cPaisLoc == "POR" .and. E2_SALDO > E2_VALOR
				nSaldo	:= Saldotit(E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_NATUREZ,;
							"P",E2_FORNECE,E2_MOEDA,,E2_LOJA,)
				GeraTXT(E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_FORNECE,E2_LOJA,Str(E2_SALDO),Str(nSaldo))
				Reclock("SE2")
				E2_SALDO	:= nSaldo
				MsUnlock()
			EndIf

			nSigno  :=      Iif(SE2->E2_TIPO $MV_CPNEG+"/"+MVPAGANT,-1,1)
			If lBxParc .and. SE2->E2_VLBXPAR >0 .And.  SE2->E2_VLBXPAR <=SE2->E2_SALDO
				nTotOrden   += Round(xMoeda(SE2->E2_VLBXPAR,SE2->E2_MOEDA,1,dDataBase,5,aTxMoedas[SE2->E2_MOEDA][2]) * nSigno,MsDecimais(1))
			Else
				nTotOrden   += Round(xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,1,dDataBase,5,aTxMoedas[SE2->E2_MOEDA][2]) * nSigno,MsDecimais(1))
			EndIf
			AaddSE2(nControl,@aSE2 )


			If cPaisLoc == "PTG"
				//+----------------------------------------------------------------+
				//� Generar las Retenci�n de IVA.                                  �
				//+----------------------------------------------------------------+
				If (SE2->E2_TIPO $ MVPAGANT + "/"+ MV_CPNEG)
					If lBxParc .and. SE2->E2_VLBXPAR >0      .And.  SE2->E2_VLBXPAR <=SE2->E2_SALDO
	   					aTmp	:=	CalcRetIV2(cAgente,nSigno,SE2->E2_VLBXPAR,nProp)
					Else
						aTmp	:=	CalcRetIV2(cAgente,nSigno,SE2->E2_SALDO,nProp)
					EndIf
				Else
					If lBxParc .and. SE2->E2_VLBXPAR >0   .And.  SE2->E2_VLBXPAR <=SE2->E2_SALDO
				   		aTmp	:=	CalcRetIVA(cAgente,nSigno,SE2->E2_VLBXPAR,,,,nProp)
					Else
						aTmp	:=	CalcRetIVA(cAgente,nSigno,SE2->E2_SALDO,,,,nProp)
					EndIf
				Endif
				If Len(aTmp) > 0
					aSE2[nControl][1][Len(aSE2[nControl][1])][_RETIVA]	:=aClone(aTmp)
				Endif

				//+----------------------------------------------------------------+
				//� Generar las Retenci�n de IRC.                                  �
				//+----------------------------------------------------------------+
				If lBxParc .and. SE2->E2_VLBXPAR >0    .And.  SE2->E2_VLBXPAR <=SE2->E2_SALDO
	   				aTmp	:=	CalcRetIRC(Iif(SE2->E2_TIPO $ MVPAGANT + "/"+ MV_CPNEG,-1,1),SE2->E2_VLBXPAR)
				Else
					aTmp	:=	CalcRetIRC(Iif(SE2->E2_TIPO $ MVPAGANT + "/"+ MV_CPNEG,-1,1),SE2->E2_SALDO)
				EndIf
				If Len(aTmp) > 0
					aSE2[nControl][1][Len(aSE2[nControl][1])][_RETIRC]	:=aClone(aTmp)
				Endif

			Endif
			//ANGOLA
			If cPaisLoc == "ANG"
				//+----------------------------------------------------------------+
				//� Retencao do Imposto sobre Empreitadas                          �
				//+----------------------------------------------------------------+
				If (SE2->E2_TIPO $ MVPAGANT + "/"+ MV_CPNEG)
					If lBxParc .and. SE2->E2_VLBXPAR >0      .And.  SE2->E2_VLBXPAR <=SE2->E2_SALDO
	   					aTmp	:=	CalcRetRIE(SE2->E2_VLBXPAR,.T.,nSigno)
					Else
						aTmp	:=	CalcRetRIE(SE2->E2_SALDO,.T.,nSigno)
					EndIf
				Else
					If lBxParc .and. SE2->E2_VLBXPAR >0   .And.  SE2->E2_VLBXPAR <=SE2->E2_SALDO
						aTmp	:=	CalcRetRIE(SE2->E2_VLBXPAR,,nSigno)
					Else
						aTmp	:=	CalcRetRIE(SE2->E2_SALDO,,nSigno)
					EndIf
				Endif
				If Len(aTmp) > 0
					aSE2[nControl][1][Len(aSE2[nControl][1])][_RETRIE]	:=aClone(aTmp)
				Endif
			Endif
			If cPaisLoc $ "URU|BOL" .And. !(SE2->E2_TIPO $ MVPAGANT + "/"+ MV_CPNEG)
				//+----------------------------------------------------------------+
				//� Generar las Retenci�n de IRIC.                                 �
				//+----------------------------------------------------------------+
				If lBxParc .and. SE2->E2_VLBXPAR >0   .And.  SE2->E2_VLBXPAR <=SE2->E2_SALDO
					aTmp :=	CalcRetIRIC(cAgente,nSigno,SE2->E2_VLBXPAR)
				Else
					aTmp :=	CalcRetIRIC(cAgente,nSigno,SE2->E2_SALDO)
				EndIf
				If Len(aTmp) > 0
					aSE2[nControl][1][Len(aSE2[nControl][1])][_RETIRIC]:=aClone(aTmp)
				Endif

				If lBxParc .and. SE2->E2_VLBXPAR >0   .And.  SE2->E2_VLBXPAR <=SE2->E2_SALDO
					aTmp :=CalcRetIR(cAgente,nSigno,SE2->E2_VLBXPAR)
				Else
					aTmp :=	CalcRetIR(cAgente,nSigno,SE2->E2_SALDO)
				EndIf

				If Len(aTmp) > 0
					aSE2[nControl][1][Len(aSE2[nControl][1])][_RETIR]:=aClone(aTmp)
				Endif

			EndIf

			IF cPaisLoc == "PER"
				//retencao de IGV
				aTmp := {}
			   	IF SUBSTRING(cAgente,1,1) $ "S/s" .AND. SA2->A2_AGENRET $ '2|N' .AND. EMPTY(SA2->A2_BCRESOL)
					IF SE2->E2_TIPO $ MV_CPNEG
						IF lBxParc .and. SE2->E2_VLBXPAR >0 .And. SE2->E2_VLBXPAR <=SE2->E2_SALDO
	   						aTmp := CalcIGV(SE2->E2_VLBXPAR)

						Else
							aTmp := CalcIGV(SE2->E2_SALDO)
						EndIf
					ELSE
						IF lBxParc .and. SE2->E2_VLBXPAR >0 .And. SE2->E2_VLBXPAR <=SE2->E2_SALDO
	   						aTmp := CalcIGV2(SE2->E2_VLBXPAR)
						Else
							aTmp := CalcIGV2(SE2->E2_SALDO)
						EndIf

					ENDIF

			   	ENDIF
				IF Len(aTmp) > 0
					aSE2[nControl][1][Len(aSE2[nControl][1])][_RETIGV]:=aClone(aTmp)
				Endif
				/* Retencao de IR */
				aTmp := {}
				aTmp := FA085RetIR()
				aSE2[nControl][1][Len(aSE2[nControl][1])][_RETIR]:=aClone(aTmp)
				
			EndIf
			If cPaisLoc == "VEN"
				// Gravar as reten��es de IVA e ISRL na tabela SFE, desde que gravados os abatimentos em Compras.
			   	If SUBSTRING(cAgente,1,1) $ "S/s" .AND. SA2->A2_AGENRET $ '1|S'
					// Pegar ou recalcular os valores da reten��o de IVA
					aTmp := CalcIVAVEN(SE2->E2_SALDO,nTotOrden)
			   	Endif
				If Len(aTmp) > 0
					aSE2[nControl][1][Len(aSE2[nControl][1])][_RETIVA]:=aClone(aTmp)
				Endif
				aTmp := {}
			    aTmp :=	CALCRIR(SE2->E2_SALDO,nTotOrden)
			    If Len(aTmp) > 0
					aSE2[nControl][1][Len(aSE2[nControl][1])][_RETIR]:=aClone(aTmp)
				EndIf
			Endif
	    	
	    Endif
	    If cPaisLoc == "PAR"
			If (SE2->E2_TIPO $ MVPAGANT + "/"+ MV_CPNEG)
				If lBxParc .and. SE2->E2_VLBXPAR >0      .And.  SE2->E2_VLBXPAR <=SE2->E2_SALDO
					aTmp	:=	CalcRetIR2(cAgente,nSigno,SE2->E2_VLBXPAR,nProp)
				Else
					aTmp	:=	CalcRetIR2(cAgente,nSigno,SE2->E2_SALDO,nProp)
				EndIf
			Else
				If lBxParc .and. SE2->E2_VLBXPAR >0   .And.  SE2->E2_VLBXPAR <=SE2->E2_SALDO
					aTmp	:=	CalcRetIR(cAgente,nSigno,SE2->E2_VLBXPAR)
				Else
					aTmp	:=	CalcRetIR(cAgente,nSigno,SE2->E2_SALDO)
				EndIf
			Endif
			If Len(aTmp) > 0
				aSE2[nControl][1][Len(aSE2[nControl][1])][_RETIR]	:=aClone(aTmp)
			Endif
			
			If (SE2->E2_TIPO $ MVPAGANT + "/"+ MV_CPNEG)
				If lBxParc .and. SE2->E2_VLBXPAR >0      .And.  SE2->E2_VLBXPAR <=SE2->E2_SALDO
					aTmp	:=	CalcRetIV2(cAgente,nSigno,SE2->E2_VLBXPAR,nProp)
				Else
					aTmp	:=	CalcRetIV2(cAgente,nSigno,SE2->E2_SALDO,nProp)
				EndIf
			Else
				aTmp := {}
				lCalcula:= .T.
				aAreaSEK:=SEK->(GetArea())   
				aAreaSFE:=SFE->(GetArea())
				SFE->(DbSetOrder(4)) 
				SEK->(DbSetOrder(1))
				SFE->(DbSeek(xFilial("SFE")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE)  )
				While    !SFE->(EOF()) .and. (xFilial("SFE")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE)==;
				 SFE->(FE_FILIAL+FE_FORNECE+FE_LOJA+FE_NFISCAL+FE_SERIE)     .And.   lCalcula  // !lAchouParc 
					If  SFE->FE_TIPO =="I"
					   If SEK->(DbSeek((xFilial("SEK")+SFE->FE_ORDPAGO+"TB"+ SF1->F1_SERIE+ SF1->F1_DOC) )) .and. SE2->E2_PARCELA ==SEK->EK_PARCELA
								lCalcula:=.F.//lAchouParc:=.T.
					   EndIf
					EndIf
					SFE->(DbSkip())
				EndDo		 
				SEK->(restarea(aAreaSEK))
				SFE->(restarea(aAreaSFE))
				If lCalcula
					If lBxParc .and. SE2->E2_VLBXPAR >0   .And.  SE2->E2_VLBXPAR <=SE2->E2_SALDO
						aTmp	:=	CalcRetIVA(cAgente,nSigno,SE2->E2_VLBXPAR,,,,nProp)
					Else
						aTmp	:=	CalcRetIVA(cAgente,nSigno,SE2->E2_SALDO,,,,nProp)
					EndIf
				EndIf	
			Endif
			If Len(aTmp) > 0
				aSE2[nControl][1][Len(aSE2[nControl][1])][_RETIVA]	:=aClone(aTmp)
			Endif
		EndIf
	Next nX

	If Len(aSE2[nControl][1]) == 0
			nControl--
	Endif
Next nI

If cPaisLoc == "PAR" .and. Len(aSe2) >0 .And.  Len(aSE2[nControl][1]) > 0
		
	//Acumulado Diario
	SFE->(DbSetOrder(3))
	dDtPesq :=dDataIni    
	SFE->(DbGotop())
	lAchou:=.F.
	SFE->(dbSeek(xFilial("SFE")+cFornece+cLoja))
    
    While !lAchou .AND.  dDtPesq<=dDataFim
    	If SFE->(dbSeek(xFilial("SFE")+cFornece+cLoja+dtos(dDtPesq)))       
    	   lAchou:=.T.
    	EndIf
    	dDtPesq:=dDtPesq+1
    Enddo      
      
	If lAchou  
	
		While lAchou .And. SFE->(!Eof()) .and.  (xFilial("SFE")+cFornece+cLoja==SFE->FE_FILIAL+SFE->FE_FORNECE+SFE->FE_LOJA)     .AND.  SFE->FE_EMISSAO<=dDataFim
			If SFE->FE_TIPO=="I"
				If SFE->FE_EMISSAO==dDatabase
			 		nValAcDia:=nValAcDia+SFE->FE_VALBASE 
					nValAcMes:=nValAcMes+SFE->FE_VALBASE 	 
				Else
			    	nValAcMes:=nValAcMes+SFE->FE_VALBASE 
			     EndIf
		     EndIf
		     SFE->(DbSkip())
		 EndDo    
	EndIf
	For nX := 1 to Len(aSe2)
		For nZ := 1 To Len(aSe2[nX,1])		
			If Len(aSe2[nX,1,nZ,_RETIVA]) > 0
				For nA := 1 To Len(aSe2[nX,1,nZ,_RETIVA])
						If aSe2[nX,1,nZ,_RETIVA,nA,4] >0              
							nValor:=0
							nValor:=     Round( (aSe2[nX,1,nZ,_RETIVA,nA,3] ),msdecimais(aSe2[nX][1][nZ][4] ))      // Round( (aSe2[nX,1,nZ,_RETIVA,nA,3] )  * ( aSe2[nX,1,nZ,_RETIVA,nA,5] / 100),msdecimais(aSe2[nX][1][nZ][4] ))
							nVlAcmPg:= nVlAcmPg +  nValor
						EndIf	
				Next nA
			EndIf
		Next nZ
	Next nX
EndIf

lReten:=.F.                                                                                                                                                                                                 
If nVlAcmPg >=GetNewPar("MV_VLRIVAT",0) .or. ( (nValAcDia+nVlAcmPg)>=GetNewPar("MV_VLRIVAD",0)) .OR. ( ( nValAcMes+nVlAcmPg)>=GetNewPar("MV_VLRIVAM",0)) 
	lReten:=.T.
	
EndIf             

If cPaisLoc == "PAR" .and. Len(aSe2) >0 .And. !lReten .and.   Len(aSE2[nControl][1]) > 0
	For nX := 1 to Len(aSe2)
		For nZ := 1 To Len(aSe2[nX,1])		
			If Len(aSe2[nX,1,nZ,_RETIVA]) > 0
				For nA := 1 To Len(aSe2[nX,1,nZ,_RETIVA])
							aSe2[nX,1,nZ,_RETIVA,nA,4]:= 0
							aSe2[nX,1,nZ,_RETIVA,nA,6]:= 0
				Next nA
			EndIf
		Next nZ
	Next nX
EndIf

/* Calcula a retencao sobre IGV */
If cPaisLoc == "PER"
	CalcRetIGV(@aSE2)
Endif

Return()

/*
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � CalcRetIVA � Autor � Jose Lucas          � Data � 25.06.98 ���
��+----------+------------------------------------------------------------���
���Descri��o � Calcular e Gerar Retencoes sobre IVA.                      ���
��+----------+------------------------------------------------------------���
���Uso       � PAGO007                                                    ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
*/
Static Function CalcRetIVA(cAgente,nSigno,nSaldo,lPa,cCF,nValor,nProp,cSerieNF)
Local aConIva  := {}
Local aSFEIVA  := {}
Local aDocAcm  := {}
Local aConfIva := {}
Local nPosIva
Local cConc
Local oDlg4
Local nCount
Local nTotRet    := 0
Local nTotRetSFE := 0
Local cChaveSFE  := ""
Local cAcmIVA	 := ""
Local lExisteSFF:=.T.
Local lRetSerie	:=	.F.
Local lCalcNew	:= GetNewPar("MV_GRETIVA","N") == "S"
Local lCalRet := .F.
Local lCalcImp := .T.
Local lCalRep := .F.
Local lCalcVen:=.F.
Local lCalrtexp:=.F.
Local lRetIVA	:= .F.
Local lAcmIva	:= .F.
Local lCalcAcm	:= .F.
Local nPercRet	:= 0
Local nBase		:= 0
Local nI := 1
Local nValorBr:=0
Local nTotBase:=0
Local nTotImp:=0
Local nRetIva := 0
Local nRetTotal := 0
Local lRetSit :=.T.
Local lExiste:=.F.
Local nVlrTot := 0
Local aParcelas := {}
Local lCalcIva := .T.
Local nX:=1
Local nReduc := 0
Local nValImps 	:= 0
Local nValIVA 	:= 0
Local nPosDoc 	:= 0
Local nTotIva := 0
Local nC := 0
Local nPorRet	:= 0
Local nImpRetIva	:= 0
Local lSento := .F.
Local lExiteSFH := .F.
Local lReten100 := .F.
Local nImporte :=0
Local xY	:= 0
Local cRetImp	:= ""
Local aLivros := {}
Local nPerc		:= 0
DEFAULT nSigno	:=	1
DEFAULT lPa	:=	.F.
DEFAULT cCF := ""
DEFAULT nValor := 0

//+---------------------------------------------------------------------+
//� Obter Impostos somente qdo a Empresa Usuario for Agente de Reten��o.�
//+---------------------------------------------------------------------+
aArea:=GetArea()
dbSelectArea("SF1")
dbSetOrder(1)

If lMsFil
	SF1->(dbSeek(SE2->E2_MSFIL+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA))
Else
	dbSeek(xFilial("SF1")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA)
EndIf

lCalRet := Iif(Alltrim(SF1->F1_SERIE) == "M",.T.,.F.)
lCalcAcm := Subs(cAgente,2,1) == "N"
If(SF1->(FieldPos("F1_TPNFEXP"))>0 .And.  SFF->(FieldPos("FF_VLRLEX"))>0 .And. SFF->(FieldPos("FF_ALIQLEX"))>0  .And.  SF1->F1_TPNFEXP=="1")  //1 - Exportador 2- Normal
	lCalrtexp:=.T.
EndIf


If ExistBlock("F0851IMP")
	lCalcImp:=ExecBlock("F0851IMP",.F.,.F.,{"IVA"})
EndIf

If cPaisLoc == "PTG"
	SA2->( dbSetOrder(1) )
	SA2->( dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA) )
Else
	SA2->( dbSetOrder(1) )
	If !lPa
		SA2->( dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA) )
	Else
		SA2->( dbSeek(xFilial("SA2")+cFornece+cLoja) )
	EndIf
	// Tratamento do Reproweb - Situa��o igual a 0 n�o deve reter Resoluci�n General ( AFIP) 2226/07
EndIf

If SA2->(FieldPos("A2_SITU")>0) .and. Alltrim(SA2->A2_SITU)$("0")
	lRetSit:=.F.
EndIf

If cPaisLoc == "PTG"
	SA2->( dbSetOrder(1) )
	SA2->( dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA) )

	//���������������������������������������������������������������������Ŀ
	//� Fornecedor ? Reter IVA                                              �
	//�����������������������������������������������������������������������
	If SA2->A2_RETIVA == "1"

		While Alltrim(SF1->F1_ESPECIE) <> AllTrim(SE2->E2_TIPO).And.!EOF()
			SF1->(DbSkip())
			Loop
		Enddo

		If AllTrim(SF1->F1_ESPECIE)==Alltrim(SE2->E2_TIPO).And.;
			xFilial("SF1")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA==;
			F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA

			nTotBase:=SF1->F1_BASIMP1+SF1->F1_BASIMP3+SF1->F1_BASIMP4+SF1->F1_BASIMP5+SF1->F1_BASIMP6
			nTotImp:=SF1->F1_VALIMP1+SF1->F1_VALIMP3+SF1->F1_VALIMP4+SF1->F1_VALIMP5+SF1->F1_VALIMP6

			AAdd(aSFEIVA,array(8))
			aSFEIVA[Len(aSFEIVA)][1] := SF1->F1_DOC         		//FE_NFISCAL
			aSFEIVA[Len(aSFEIVA)][2] := SF1->F1_SERIE       		//FE_SERIE
			aSFEIVA[Len(aSFEIVA)][3] := Round(xMoeda(nTotBase,SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1))*nSaldo/SE2->E2_VALOR * nSigno	//FE_VALBASE
			aSFEIVA[Len(aSFEIVA)][4] := Round(xMoeda(nTotImp,SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1))*nSaldo/SE2->E2_VALOR * nSigno	//FE_VALIMP
			aSFEIVA[Len(aSFEIVA)][5] := 100
			aSFEIVA[Len(aSFEIVA)][6] := aSFEIVA[Len(aSFEIVA)][4]
			aSFEIVA[Len(aSFEIVA)][7] := SE2->E2_VALOR
			aSFEIVA[Len(aSFEIVA)][8] := SE2->E2_EMISSAO
		Endif
	Endif
ElseIf (Subs(cAgente,2,1) == "S"  .Or. lCalRet .Or. lCalcAcm) .And. lCalcImp  .And.  lRetSit
	SA2->( dbSetOrder(1) )
	If !lPa
		If !Empty(xFilial("SA2")) .And. lMsFil .And. xFilial("SF1") == xFilial("SA2")
			SA2->( dbSeek(SE2->E2_MSFIL+SE2->E2_FORNECE+SE2->E2_LOJA) )
		Else
			SA2->( dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA) )
		Endif
	Else
		SA2->( dbSeek(xFilial("SA2")+cFornece+cLoja) )
	EndIf
	//���������������������������������������������������������������������Ŀ
	//� Fornecedor ? Agente de Reten??o n?o Retem IVA.                      �
	//�����������������������������������������������������������������������
	If (SA2->(FieldPos("A2_IVRVCOB")) >0  .And.  !Empty(SA2->A2_IVRVCOB) .And. SA2->A2_IVRVCOB > dDataBase)
		lCalcVen:=Iif(!Empty(SA2->A2_IVPCCOB) .Or. !Empty(SA2->A2_IVPCCOB) ,.F.,.T.)
	EndIf

	lCalRep := Iif(SA2->(FieldPos("A2_SITU")>0) .and. Alltrim(SA2->A2_SITU)$("2/4"),.T.,.F.)
	If SA2->A2_AGENRET == "N"   .Or. lCalRet

		If !lPA //Se estou em um PA
			While Alltrim(SF1->F1_ESPECIE)<>AllTrim(SE2->E2_TIPO).And.!EOF()
				SF1->(DbSkip())
				Loop
			Enddo
			If AllTrim(SF1->F1_ESPECIE)==Alltrim(SE2->E2_TIPO).And.;
				Iif(lMsFil,SF1->F1_MSFIL,xFilial("SF1"))+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA==;
				SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA

				//����������������������������������������������������������������Ŀ
				//� Se esta definida uma retencao para uma serie especial, verifico�
				//� antes de procurar no SD1.(Serie 'M' foi o primeiro caso).      �
				//������������������������������������������������������������������
				SFF->(DbSetOrder(3))

				If SFF->(DbSeek(xFilial("SFF")+"IVR"+SF1->F1_SERIE+"SER")) .And.  !lCalrtexp .And. !lCalcAcm

					SD1->(DbSetOrder(1))
	              	If lMsFil
						SD1->(DbSeek(SF1->F1_MSFIL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
					Else
						SD1->(DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
					EndIf
					If SD1->(Found())
						Do while Iif(lMsFil,SF1->F1_MSFIL,xFilial("SD1"))==SD1->D1_FILIAL.And.SF1->F1_DOC==SD1->D1_DOC.AND.;
							SF1->F1_SERIE==SD1->D1_SERIE.AND.SF1->F1_FORNECE==SD1->D1_FORNECE;
							.AND.SF1->F1_LOJA==SD1->D1_LOJA.AND.!SD1->(EOF())

							aImpInf := TesImpInf(SD1->D1_TES)

							For nI := 1 To Len(aImpInf)
								If "IV"$Trim(aImpInf[nI][01]) .And.  Trim(aImpInf[nI][01])<>"IVP"
									nPosIva:=ASCAN(aConIva,{|x| x[1]==SF1->F1_SERIE})
									If nPosIva<>0
										aConIva[nPosIva][2]:=aConIva[nPosIva][2]+(SD1->(FieldGet(FieldPos(aImpInf[nI][02]))))
										aConIva[nPosIva][3]:=aConIva[nPosIva][3]+(SD1->(FieldGet(FieldPos(aImpInf[nI][07]))))
									Else
										aParcelas := Condicao(SF1->F1_VALMERC,SF1->F1_COND,,dDataBase)
										nVlrTot := SD1->(FieldGet(FieldPos(aImpInf[nI][02]))) / Len(aParcelas)

										Aadd(aConIva,{SD1->D1_CF,nVlrTot,SD1->(FieldGet(FieldPos(aImpInf[nI][07])))})
									Endif

									If SD1->(FieldGet(FieldPos(aImpInf[nI][07]))) < SFF->FF_IMPORTE
										aConIVA[1][2]:= ((SFF->FF_ALIQ/100 ) * (SD1->(FieldGet(FieldPos(aImpInf[nI][07])))))
									Endif
								Endif
							Next
							SD1->(DbSkip())
						Enddo
					Endif

					lRetSerie	:=	.T.

				Else
					//����������������������������������������������������������������Ŀ
					//� Obter o Valor do Imposto e Base baseando se no rateio do valor �
					//� do titulo pelo total da Nota Fiscal.                           �
					//������������������������������������������������������������������
					SD1->(DbSetOrder(1))
					If lMsFil
						SD1->(DbSeek(SF1->F1_MSFIL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
					Else
						SD1->(DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
					EndIf
					If SD1->(Found())
						Do while Iif(lMsFil,SF1->F1_MSFIL,xFilial("SD1"))==SD1->D1_FILIAL.And.SF1->F1_DOC==SD1->D1_DOC.AND.;
							SF1->F1_SERIE==SD1->D1_SERIE.AND.SF1->F1_FORNECE==SD1->D1_FORNECE;
							.AND.SF1->F1_LOJA==SD1->D1_LOJA.AND.!SD1->(EOF())

							If AllTrim(SD1->D1_ESPECIE)<>AllTrim(SF1->F1_ESPECIE)
								SD1->(DbSkip())
								Loop
							Endif
							SB1->(DbSetOrder(1))
							If !Empty(SD1->D1_CF)
								If !lCalcAcm
									If cPaisLoc== "PAR"
										nRateio := ( Round(xMoeda(nSaldo,SE2->E2_MOEDA,1,,5,aTxMoedas[Max(SE2->E2_MOEDA,1)][2]),MsDecimais(1))  / Round(xMoeda(SF1->F1_VALBRUT,SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1)) )
									Else
										nRateio := ( Round(xMoeda(nSaldo,SE2->E2_MOEDA,1,,5,aTxMoedas[Max(SE2->E2_MOEDA,1)][2]),MsDecimais(1)) / ROund(xMoeda(SF1->F1_VALBRUT,SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1)) )
									EndIf
								Else
									nRateio := 1
								EndIf
								nPosIva:=ASCAN(aConIva,{|x| x[1]==SD1->D1_CF})
								If lCalcNew  .Or.  lCalrtexp // Calcula IVA metodo Novo
									If nPosIva<>0
										aConIva[nPosIva][2]:=aConIva[nPosIva][2]+((aConIva[nPosIva][4] * (SD1->D1_TOTAL ) )- ((SD1->D1_IVAFRET+SD1->D1_IVAGAST))) * nRateio
										aConIva[nPosIva][3]:=aConIva[nPosIva][3]+((SD1->D1_TOTAL ) - ((SD1->D1_BaIVAFR+SD1->D1_BaIVAGA)) ) * nRateio
									Else
										If lCalRep .or. lCalcVen
											aImpInf := TesImpInf(SD1->D1_TES)
											For nI := 1 To Len(aImpInf)
												If  "IV"$Trim(aImpInf[nI][01]) .And.  Trim(aImpInf[nI][01])<>"IVP"
													Aadd(aConIva,{SD1->D1_CF,SD1->(FieldGet(FieldPos(aImpInf[nI][02]))),SD1->(FieldGet(FieldPos(aImpInf[nI][07]))), (SD1->(FieldGet(FieldPos(aImpInf[nI][10]))) /100)})
												EndIf
											Next
										Else
											SFF->(DbSetOrder(5))
											SFF->(DbGotop())
											If SFF->(DbSeek(xFilial("SFF")+"IVR"))
												nPerc:=0
												lAchou:=.F.
												While SFF->(!EOF() ).and. (xFilial("SFF")+"IVR") ==(SFF->FF_FILIAL+SFF->FF_IMPOSTO) .And.  !lAchou
													If (Alltrim(SFF->FF_SERIENF)== Alltrim(SD1->D1_SERIE) .And. SD1->D1_CF==  SFF->FF_CFO_C )
														lAchou:=.T.
														nPerc:=SFF->FF_ALIQ
														If SFF->(FieldPos("FF_TPLIM")) > 0
															cAcmIVA := SFF->FF_TPLIM
															nLimite := SFF->FF_LIMITE
														EndIf  
														If SFF->(FieldPos("FF_IMPORTE")) > 0
															nImporte := SFF->FF_IMPORTE
														EndIf  														
													Else
														SFF->(DbSkip())
													EndIf
												EndDO

												/************************************************
												Verifica o acumulado para o c�lculo do imposto
												************************************************/
												//caso seja branco ou n�o foi selecionado nenhum m�todo de acumulo
												If Type("aRetIvAcm") <> "A"
													aRetIvAcm := Array(3)
												EndIf

												If cAcmIVA <> "" .And. cAcmIVA <> "0" .And. lCalcAcm
													aDadosIVA 	:= F085AcmIVA(cAcmIVA,SF1->F1_EMISSAO,SF1->F1_FORNECE,SF1->F1_LOJA)

													nBase := aDadosIVA[1] - aDadosIVA[2]

													If aDadosIVA[4]
														If nBase >= nLimite .Or. aDadosIVA[2]  > 0
															lRetIva := .T.
															lAcmIva := .T.

															For nX := 1 to Len(aDadosIVA[3])
																If Empty(aDadosIVA[3][nX][2])
																	aAdd(aDocAcm, {aDadosIVA[3][nX][3], aDadosIVA[3][nX][4], Iif(aDadosIVA[3][nX][1],.F.,.T.)})
																EndIf
															Next nX

															If Len(aDocAcm) > 0
																aAdd(aConfIVA,nPerc)

																aRetIvAcm[1] :=  aConfIVA

																If aRetIvAcm[2] == Nil
																	aRetIvAcm[2] := {}
																EndIf

																For nX := 1 to Len(aDocAcm)
																	If aDocAcm[nX][2] == "SF1"
																		nPosDoc := aScan(aRetIvAcm[2],{|x| x[1]==aDocAcm[nX][1] .And. x[2]=="SF1"})
																	Else
																		nPosDoc := aScan(aRetIvAcm[2],{|x| x[1]==aDocAcm[nX][1] .And. x[2]=="SF2"})
																	EndIf
																	If nPosDoc == 0
																		Aadd(aRetIvAcm[2],aDocAcm[nX])
																	EndIf
																Next nX

															EndIf

														EndIf
													Else
														lRetIva := .T.
													EndIf
												Else
													//Se n�o usa cumulatividade de IVA, calcula no m�todo antigo
													lRetIva := .T.
												EndIf

												If  lCalrtexp .And.	lAchou
													nValorBr:=Round(xmoeda(SF1->F1_VALBRUT,SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1))
													nPerc:=Iif(nValorBr>SFF->FF_VLRLEX,SFF->FF_ALIQ,SFF->FF_ALIQLEX)
												EndIf
												aParcelas := Condicao(SF1->F1_VALMERC,SF1->F1_COND,,dDataBase)
												If lRetIva
													Aadd(aConIva,{SD1->D1_CF,(((nPerc/100 ) * (SD1->D1_TOTAL - SD1->D1_VALDESC ))  - (SD1->D1_IVAFRET+SD1->D1_IVAGAST))/IIf(Len(aParcelas) > 0,Len(aParcelas),1),((SD1->D1_TOTAL - SD1->D1_VALDESC )- (SD1->D1_BaIVAFR +SD1->D1_BaIVAGA)),(nPerc /100),nImporte})
												EndIf
											EndIf
										EndIf

									EndIF
								ElseIf !lCalcAcm
									If nPosIva<>0
										If Len(aParcelas)>1
									 		nVlrTot := SD1->D1_VALIMP1/Len(aParcelas)
									   		If cPaisLoc == "PAR" .and. aConIva[nPosIva][4] > 0
									   			aConIva[nPosIva][2]:=aConIva[nPosIva][2]+ (nVlrTot-(SD1->D1_IVAFRET+SD1->D1_IVAGAST))* (aConIva[nPosIva][4]/100)
									   			aConIva[nPosIva][3]:=aConIva[nPosIva][3]+Round((SD1->D1_BASIMP1-SD1->D1_BaIVAFR+SD1->D1_BaIVAGA)* (aConIva[nPosIva][4]/100),Msdecimais(SF1->F1_MOEDA))
											Else
												aConIva[nPosIva][2]:=aConIva[nPosIva][2]+(nVlrTot-(SD1->D1_IVAFRET+SD1->D1_IVAGAST))
												aConIva[nPosIva][3]:=aConIva[nPosIva][3]+(SD1->D1_BASIMP1-SD1->D1_BaIVAFR+SD1->D1_BaIVAGA)
											EndIf
											
										Else
											If cPaisLoc == "PAR" .and. aConIva[nPosIva][4] > 0
											    nTotbas := 0         
												nImpRetIva:= 0
																		
												nTotBas:=Round((SD1->D1_BASIMP1-SD1->D1_BaIVAFR+SD1->D1_BaIVAGA)*nRateio,Msdecimais(SF1->F1_MOEDA))
												nImpRetIva:=Round((SD1->D1_VALIMP1-SD1->D1_IVAFRET+SD1->D1_IVAGAST)*nRateio,Msdecimais(SF1->F1_MOEDA))
												nImpRetIva := ((nImpRetIva * IIf(nPerc>0,nPerc,SA2->A2_PORIVA)/100 ))
												
												aConIva[nPosIva][2]:=aConIva[nPosIva][2]+ nImpRetIva
												aConIva[nPosIva][3]:=aConIva[nPosIva][3]+ nTotBas
											Else
												aConIva[nPosIva][2]:=aConIva[nPosIva][2]+(SD1->D1_VALIMP1-SD1->D1_IVAFRET+SD1->D1_IVAGAST)
												aConIva[nPosIva][3]:=aConIva[nPosIva][3]+(SD1->D1_BASIMP1-SD1->D1_BaIVAFR+SD1->D1_BaIVAGA)
											EndIf
										EndIf
									Else
										/*********************************************************************
										IMPORTANTE: O c�lculo de IVA cumulativo n�o contempla o m�todo antigo
										*********************************************************************/
										If cPaisLoc <> "PAR"
											SFH->(dbSetOrder(1))
											SFH->(dbGoTop())
											If SFH->(DbSeek(xFilial()+SA2->A2_COD+SA2->A2_LOJA+"IVR"))
												IF  (SFH->FH_ISENTO == "S")
													lAchou := .T.
													lSento := .T.
												Else
													lSento := .F.
													lAchou := .F.
												EndIf
												nPorRet := IIF(SFH->FH_PERCENT>0,SFH->FH_PERCENT/100,0)	 // % de Exencion del Impuesto
												lExiteSFH := .T.
											Else
												lExiteSFH := .F.
											EndIf
										EndIf

										SFF->(DbSetOrder(5)) // FF_FILIAL+FF_IMPOSTO+FF_CFO_C+FF_ZONFIS
										SFF->(DbGotop())
										If SFF->(DbSeek(xFilial("SFF")+"IVR")) 
											nPerc:=0
											lAchou:=.F.
											While SFF->(!EOF() ).and. (xFilial("SFF")+"IVR") ==(SFF->FF_FILIAL+SFF->FF_IMPOSTO) .And.  !lAchou
												If (cPaisLoc<>"PAR" .And. Alltrim(SFF->FF_SERIENF)== Alltrim(SD1->D1_SERIE) .And. SD1->D1_CF==  SFF->FF_CFO_C ) ;
													.Or. ( cPaisLoc=="PAR" .And. SD1->D1_CF==  SFF->FF_CFO_C)
													lAchou:=.T.
													nPerc:=SFF->FF_ALIQ
												Else
													SFF->(DbSkip())
												EndIf
											EndDO

											aParcelas := Condicao (SF1->F1_VALMERC,SF1->F1_COND,,dDataBase)
											//Caso o valor da fatura seja parcelado, atribui o valor da parcela.
											nVlrTot := SF1->F1_VALMERC/Len(aParcelas)

											If cPaisLoc <> "PAR"
												nImpRetIva := (((nPerc/100 ) * (nVlrTot ))  - (SD1->D1_IVAFRET+SD1->D1_IVAGAST))
											Else
												cRetImp:= SuperGetMv("MV_IMPRETI",.F.,"")
												aAreaSFB:= SFB->(GetArea())
												dbSelectArea("SFB")
		        								SFB->(DbSetOrder(1))												 
												SFB->(dbGoTop())
												While SFB->(!EOF() ) .and. (xFilial("SFB")==SFB->FB_FILIAL)													
													If SFB->FB_CODIGO $ cRetImp	 .And. ASCAN(aLivros,{|x| x[1]==SFB->FB_CPOLVRO}) == 0 
														aAdd(aLivros,{SFB->FB_CPOLVRO})
													EndIf																							
													SFB->(DbSkip())
												EndDo
												nTotbas := 0         
												nImpRetIva:= 0
												For xY := 1 to len (aLivros) 
													nTotBas:= nTotBas + &("SD1->D1_BASIMP"+(Alltrim(aLivros[xY][1])))											
													nImpRetIva:= nImpRetIva + &("SD1->D1_VALIMP"+(Alltrim(aLivros[xY][1])))
												Next
												If nRateio<> 0              
													If cPaisLoc=="PAR" 
														nTotBas:=Round(nTotBas*nRateio,Msdecimais(SF1->F1_MOEDA))
														nImpRetIva:=Round(nImpRetIva*nRateio,Msdecimais(SF1->F1_MOEDA))
													Else
														nTotBas:=Round(nTotBas*nRateio,Msdecimais(1))
														nImpRetIva:=Round(nImpRetIva*nRateio,Msdecimais(1))
													EndIf
												EndiF
												
												SFB->(RestArea(aAreaSFB))																				
												nImpRetIva := ((nImpRetIva * IIf(cPaisLoc=="PAR" .and. nPerc>0,nPerc,SA2->A2_PORIVA)/100 ))// * (nTotbas ))		
											EndIf

											lReten100 = .F.
											If SA2->(FieldPos("A2_IVPDCOB")) > 0 .and. (lExiteSFH == .F.) .or. (lExiteSFH == .T. .and. !A085aVigSFH())
												If (A085aVigSA2()) .and. (!Empty(SA2->A2_IVPDCOB) .and. !Empty(SA2->A2_IVPCCOB)) // Si el Reg. esta Vigencia SA2 - Exencion del Impuesto
													nPorRet := IIF(SA2->A2_PORIVA>0,SA2->A2_PORIVA/100,0)	 // % de Exencion del Impuesto
												ElseIf (!A085aVigSA2()) .and. (!Empty(SA2->A2_IVPDCOB) .and. !Empty(SA2->A2_IVPCCOB)) // Fuera de Vigencia SA2 - Exencion del Impuesto												
													lReten100 = .T.
												ElseIf (Empty(SA2->A2_IVPDCOB) .and. Empty(SA2->A2_IVPCCOB)) // Independientemente de Vigencia SA2 - Exencion del Impuesto
													nPorRet := IIF(SA2->A2_PORIVA>0,SA2->A2_PORIVA/100,0)	 // % de Exencion del Impuesto												
												ElseIf (Empty(SA2->A2_IVPDCOB) .and. ddatabase <= SA2->A2_IVPCCOB) // Resultado hasta hacia atras
													nPorRet := IIF(SA2->A2_PORIVA>0,SA2->A2_PORIVA/100,0)	 // % de Exencion del Impuesto																								
												ElseIf (Empty(SA2->A2_IVPCCOB) .and. ddatabase >= SA2->A2_IVPDCOB) // Resultado desde en adelante
													nPorRet := IIF(SA2->A2_PORIVA>0,SA2->A2_PORIVA/100,0)	 // % de Exencion del Impuesto																								
												Else
													lReten100 = .T.
												Endif
												
												If nPorRet <> 1 .and. lReten100 = .F.
													nImpRetIva := (nPorRet * nImpRetIva)
												Endif 
											Else
												If cPaisLoc <> "PAR"  
													If lSento == .T. 
														nImpRetIva := 0
													ElseIf (lSento == .F. .and. (A085aVigSFH()  .and. nPorRet > 0)) // Exencion del Impuesto											 
														If nPorRet = 1
															nImpRetIva := 0
														Else
															nImpRetIva := (nPorRet * nImpRetIva)
														Endif 
													Endif
												EndIf
											Endif
											If cPaisloc = "PAR"
												Aadd(aConIva,{SD1->D1_CF,nImpRetIva,((SD1->D1_BASIMP1-SD1->D1_BaIVAFR +SD1->D1_BaIVAGA)*nRateio),nPerc}) 
											Else
												Aadd(aConIva,{SD1->D1_CF,nImpRetIva,(SD1->D1_BASIMP1-SD1->D1_BaIVAFR +SD1->D1_BaIVAGA),0})
											EndIf
										Endif
									Endif
								Endif
							ElseIf SB1->(DbSeek(Iif(lMsFil .And. !Empty(xFilial("SB1")),SD1->D1_MSFIL,xFilial("SB1")) + SD1->D1_COD))
								nPosIva:=ASCAN(aConIva,{|x| x[1]==SB1->B1_CONCIVA})
								If nPosIva<>0
									If cPaisLoc=="PAR"  .And. nRateio<> 0 
								   		aConIva[nPosIva][2]:=aConIva[nPosIva][2]+Round(((SD1->D1_VALIMP1-SD1->D1_IVAFRET+SD1->D1_IVAGAST) *  nRateio * (aConIva[nPosIva][4]/100)  ),Msdecimais(SF1->F1_MOEDA))
							 			aConIva[nPosIva][3]:=aConIva[nPosIva][3]+Round(((SD1->D1_BASIMP1-SD1->D1_BaIVAFR+SD1->D1_BaIVAGA) *  nRateio * (aConIva[nPosIva][4]/100)  ),Msdecimais(SF1->F1_MOEDA))  
								   Else
										aConIva[nPosIva][2]:=aConIva[nPosIva][2]+(SD1->D1_VALIMP1-SD1->D1_IVAFRET+SD1->D1_IVAGAST)
										aConIva[nPosIva][3]:=aConIva[nPosIva][3]+(SD1->D1_BASIMP1-SD1->D1_BaIVAFR+SD1->D1_BaIVAGA)
									EndIf
								Else
									If cPaisLoc=="PAR" .and. nRateio <>0
										Aadd(aConIva,{SB1->B1_CONCIVA,((SD1->D1_VALIMP1-SD1->D1_IVAFRET+SD1->D1_IVAGAST)*nRateio),((SD1->D1_BASIMP1-SD1->D1_BaIVAFR +SD1->D1_BaIVAGA)*nRateio),0})
									Else   
										Aadd(aConIva,{SB1->B1_CONCIVA,(SD1->D1_VALIMP1-SD1->D1_IVAFRET+SD1->D1_IVAGAST),(SD1->D1_BASIMP1-SD1->D1_BaIVAFR +SD1->D1_BaIVAGA),0})
									EndIf
								Endif
							ElseIf !lCalcAcm
								nPosIva:=ASCAN(aConIva,{|x| x[1]==SA2->A2_ACTRET})
								If nPosIva<>0
									If cPaisLoc=="PAR" .and. nRateio <>0             
										aConIva[nPosIva][2]:=aConIva[nPosIva][2]+((SD1->D1_VALIMP1)  *nRateio)
										aConIva[nPosIva][3]:=aConIva[nPosIva][3]+((SD1->D1_BASIMP1)  *nRateio)
									Else 
										aConIva[nPosIva][2]:=aConIva[nPosIva][2]+(SD1->D1_VALIMP1)
										aConIva[nPosIva][3]:=aConIva[nPosIva][3]+(SD1->D1_BASIMP1)
									EndIf
								Else
									Aadd(aConIva,{SA2->A2_ACTRET,SD1->D1_VALIMP1,SD1->D1_BASIMP1,0})
								Endif
							Endif
							If SD1->D1_IVAFRET > 0
								MV_FRETLOC  := GetNewPar("MV_FRETLOC","IVA162GAN06")
								cConc   := Alltrim(Subs( MV_FRETLOC, 4,At("G",MV_FRETLOC)-4))
								nPosIva := ASCAN(aConIva,{|x| x[1]==cConc})
								If nPosIva<>0
									aConIva[nPosIva][2]:=aConIva[nPosIva][2]+ SD1->D1_IVAFRET
									aConIva[nPosIva][3]:=aConIva[nPosIva][3]+ SD1->D1_BaIVAFR
								Else
									Aadd(aConIva,{cConc,SD1->D1_IVAFRET,SD1->D1_BaIVAFR,0})
								Endif
							EndIf
							If SD1->D1_IVAGAST > 0
								MV_GASTLOC  := GetNewPar("MV_GASTLOC","IVA112GAN06")
								cConc   := Alltrim(Subs( MV_GASTLOC, 4,At("G",MV_GASTLOC)-4))
								nPosIva := ASCAN(aConIva,{|x| x[1]==cConc})
								If nPosIva<>0
									aConIva[nPosIva][2]:=aConIva[nPosIva][2]+ (SD1->D1_IVAGAST)
									aConIva[nPosIva][3]:=aConIva[nPosIva][3]+ (SD1->D1_BaIVAGA)
								Else
									Aadd(aConIva,{cConc,SD1->D1_IVAGAST,SD1->D1_BaIVAGA,0})
								Endif
							EndIf
							SD1->(DbSkip())
						EndDo
					Endif
				Endif
				//����������������������������������������������������������������Ŀ
				//� Gravar Retenciones.                                            �
				//������������������������������������������������������������������
				For nCount:=1  to Len(aConIva)
					aConIva[nCount][2]   := Round(xMoeda(aConIva[nCount][2],SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1))
					aConIva[nCount][3]   := Round(xMoeda(aConIva[nCount][3],SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1))
					If cPaisLoc=="PAR"
				   		nPerc:=aConIva[nCount][4]
					EndIf 

					AAdd(aSFEIVA,array(10))
					aSFEIVA[Len(aSFEIVA)][1] := SF1->F1_DOC         		//FE_NFISCAL
					aSFEIVA[Len(aSFEIVA)][2] := SF1->F1_SERIE       		//FE_SERIE
					aSFEIVA[Len(aSFEIVA)][3] := (aConIva[nCount][3]*nProp)*nSigno	//FE_VALBASE
					aSFEIVA[Len(aSFEIVA)][4] := (aConIva[nCount][2]*nProp)*nSigno	//FE_VALIMP
					aSFEIVA[Len(aSFEIVA)][5] := Iif(Alltrim(SF1->F1_SERIE)=="M",100,IIf(cPaisLoc=="PAR",nPerc,SA2->A2_PORIVA))      		//FE_PORCRET
					aSFEIVA[Len(aSFEIVA)][6] := (aSFEIVA[Len(aSFEIVA)][4]) * (Iif(Alltrim(SF1->F1_SERIE)=="M",1,Iif(lCalRep .or. lCalcVen ,1, IIf(cPaisLoc=="PAR",nPerc,SA2->A2_PORIVA)/100) ))
					aSFEIVA[Len(aSFEIVA)][9] := aConIva[nCount][1] // Gravar CFOP da opera��o
					If cPaisloc = "PAR"
						aSFEIVA[Len(aSFEIVA)][10] := aConIva[nCount][4] // Gravar A PORCENTAGEM DA ALIQUOTA
					Else
						aSFEIVA[Len(aSFEIVA)][10] := aConIva[nCount][4]*100 // Gravar A PORCENTAGEM DA ALIQUOTA
					EndIf
					If LEN(aConIva[1])==4 //pROVISORIO, PARA QUE NO DE ERROR EN BASES DESACTUALIZADAS
						//������������������������������������������������������������������������Ŀ
						//�Se se deve fazer retencao por serie, nao e necessario posicionar o SFF, �
						//�pois ele ja esta posicionado                                            �
						//��������������������������������������������������������������������������
						If !lRetSerie
							SFF->(DbSetOrder(5))
							SFF->(DbSeek(xFilial("SFF")+"IVR"+aConIva[nCount][1]))
							While SFF->(!EOF() ).and. (xFilial("SFF")+"IVR") ==(SFF->FF_FILIAL+SFF->FF_IMPOSTO) .And.  !lExiste
								If Alltrim(aSFEIVA[Len(aSFEIVA)][2]) == Alltrim(SFF->FF_SERIENF)
									lExiste:=.T.
								Else
									SFF->(DbSkip())
								EndIf
							EndDO
						EndIf
						If lExiste
							If SA2->(FieldPos("A2_IVRVCOB")) > 0 .And. SA2->(FieldPos("A2_IVPCCOB")) > 0
								nPercRet:=SFF->FF_ALIQ/100

								If	lCalRep .or. lCalcVen
									nPercRet:= 1
								EndIf
								If lCalcNew
									If lCalRep .or. lCalcVen
										aSFEIVA[Len(aSFEIVA)][6] := (aSFEIVA[Len(aSFEIVA)][4])
									Else
										//aSFEIVA[Len(aSFEIVA)][6] := (aSFEIVA[Len(aSFEIVA)][4]) *(SA2->A2_PORIVA/100)
										//----------------------------------------------------------------------------
										//������������������������������������������������������������������������Ŀ
										//�C�lculo del % de Exenci�n del IVA									   �
										//��������������������������������������������������������������������������
										///Se verifica si la fecha de generaci�n de la OP sea >= A2_IVPDCOB Y <= A2_IVPCCOB
										IF (SA2->A2_IVPCCOB <= ddatabase .and. SA2->A2_IVPCCOB >= ddatabase)
											// Se descuenta el porcentaje de A2_PORIVA
											aSFEIVA[Len(aSFEIVA)][6] := aSFEIVA[Len(aSFEIVA)][6]//aSFEIVA[Len(aSFEIVA)][4]- aSFEIVA[Len(aSFEIVA)][6]
										Else
											// Se realiza el c�lculo normal
											aSFEIVA[Len(aSFEIVA)][6] := aSFEIVA[Len(aSFEIVA)][4]
										End IF																			
										
									EndIf
								ElseIf Dtos(SA2->A2_IVRVCOB) < Dtos(dDataBase)
									MsgAlert(OemToAnsi(STR0146)+SA2->A2_COD+OemToAnsi(STR0147)) //	"Ha vencido el perido de observacion del proveedor  "+SA2->A2_COD+". Ingrese una fecha valida para el proveedor en el archivo de proveedores."
									//Zera o array das retencoes de IVA...
									aSFEIVA := {}
									//Sai do loop...
									Exit
								Else
									//aSFEIVA[Len(aSFEIVA)][6] := aSFEIVA[Len(aSFEIVA)][4] 
									//������������������������������������������������������������������������Ŀ
									//�C�lculo del % de Exenci�n del IVA									    �
									//��������������������������������������������������������������������������
									///Se verifica si la fecha de generaci�n de la OP sea >= A2_IVPDCOB Y <= A2_IVPCCOB
									IF SA2->(FieldPos("A2_IVPDCOB")) > 0 .and. (SA2-> A2_IVPDCOB <= ddatabase .and. SA2->A2_IVPCCOB >= ddatabase)
										// Se descuenta el porcentaje de A2_PORIVA
										aSFEIVA[Len(aSFEIVA)][6] := aSFEIVA[Len(aSFEIVA)][6]//aSFEIVA[Len(aSFEIVA)][4]- aSFEIVA[Len(aSFEIVA)][6]
									Else
										// Se realiza el c�lculo normal
										aSFEIVA[Len(aSFEIVA)][6] := aSFEIVA[Len(aSFEIVA)][4]
									End IF
								EndIf
							Else
								nPercRet:=SFF->FF_ALIQ/100

								If  lCalRep .or. lCalcVen
									nPercRet:= 1
								EndIf
								If lCalcNew
									If lCalRep .or. lCalcVen
										aSFEIVA[Len(aSFEIVA)][6] := (aSFEIVA[Len(aSFEIVA)][4])
									Else
										aSFEIVA[Len(aSFEIVA)][6] := (aSFEIVA[Len(aSFEIVA)][4]) *IIf(cPaisLoc=="PAR",nPercRet,(SA2->A2_PORIVA/100)   )
									EndIf

								Else
									If cPaisLoc $ "PAR"
										aSFEIVA[Len(aSFEIVA)][6] := (aSFEIVA[Len(aSFEIVA)][4])
									Else
										aSFEIVA[Len(aSFEIVA)][6] := (aSFEIVA[Len(aSFEIVA)][4]*(nPercRet))*(Iif(Alltrim(SF1->F1_SERIE)=="M",100,SA2->A2_PORIVA)/100)
									EndIf
								EndIf
							EndIf

							nTotRet += aSFEIVA[Len(aSFEIVA)][6]
						ELSE
							DEFINE MSDIALOG oDlg4 FROM 65,0 To 218,366 Title OemToAnsi(STR0074) Pixel //"Inconsistencia"
							@ 2,3 To 51,180 Pixel of oDlg4
							//"La actividad ", " de IVA no esta registrada en la Tabla SFF"
							//"por lo tanto no se generara retenci�n de IVA. Si desea Continuar con la "
							//"Orden de Pago acepte, sino cancele. "
							@ 10,004 SAY OemToAnsi(STR0050)+ Alltrim(aConIva[nCount][1]) +OemToAnsi(STR0051) PIXEL Of oDlg4
							@ 23,004 SAY OemToAnsi(STR0052)	PIXEL Of oDlg4
							@ 36,004 SAY OemToAnsi(STR0053) 	PIXEL	Of oDlg4
							DEFINE SBUTTON FROM 57,064  Type 1 Action (lRetOk	:=	.T.,oDlg4:End())    Pixel ENABLE Of oDlg4
							DEFINE SBUTTON FROM 57,104  Type 2 Action (lRetOk	:=	.F.,oDlg4:End())  Pixel ENABLE Of oDlg4
							Activate Dialog oDlg4 CENTERED
							aSFEIVA[Len(aSFEIVA)][6] := 0
						Endif
					Else
						nTotRet += aSFEIVA[Len(aSFEIVA)][6]
					Endif
					//����������������������������������������������������������������Ŀ
					//� Generar Titulo de Impuesto no Contas a Pagar.                  �
					//������������������������������������������������������������������
					If  lCalcNew
						aSFEIVA[Len(aSFEIVA)][7] := nSaldo
					Else
						aSFEIVA[Len(aSFEIVA)][7] := SE2->E2_VALOR
					EndIf
					aSFEIVA[Len(aSFEIVA)][8] := SE2->E2_EMISSAO
				Next
				//Levanta quanto ja foi retido para a factura corrente, para em seguida
				//abater do total calculado para retencao.
				SFE->(dbSetOrder(4))
				If SFE->(dbSeek(xFilial("SFE")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE+"I"))
					cChaveSFE := xFilial("SFE")+SFE->FE_FORNECE+SFE->FE_LOJA+SFE->FE_NFISCAL+SFE->FE_SERIE
					While !SFE->(Eof()) .And. cChaveSFE == SFE->FE_FILIAL+SFE->FE_FORNECE+SFE->FE_LOJA+SFE->FE_NFISCAL+SFE->FE_SERIE
						If SFE->FE_TIPO =="I" .and. SFE->FE_RETENC > 0 .and. EMPTY(SFE->FE_DTESTOR)
							nTotRetSFE += SFE->FE_RETENC
						EndIf
						SFE->(dbSkip())
					End

					//Proporcionaliza o que ja foi retido e abate da retencao que
					//foi calculada.
					If cPaisLoc<>"PAR"
						For nCount:= 1 To Len(aSFEIVA)
							aSFEIVA[nCount][6] -= (nTotRetSFE * (aSFEIVA[nCount][6] / nTotRet))
						Next nCount
					EndIf
				Else
					If nSaldo <= nTotRet .And. !lAcmIva
						//Proporcionaliza o que ja foi retido e abate da retencao que
						//foi calculada.
						If cPaisLoc<>"PAR"
							For nCount:= 1 To Len(aSFEIVA)
								aSFEIVA[nCount][6] := (nSaldo * (aSFEIVA[nCount][6] / nTotRet))
							Next nCount
						EndIf
					EndIf
				EndIf

				//Verifica se o valor de retencao calculado supera o valor
				//minimo a ser retido, caso seja inferior nao eh realizada
				//a retencao.
				If !lCalcAcm
					If Alltrim(SF1->F1_SERIE) == "M"
						nTotBase := 0
						nTotRet := 0
						aEval(aSFEIVA,{|x| nTotRet += (x[4] * x[5]/100), nTotBase +=x[3]})
						If SA2->(FieldPos("A2_IVRVCOB")) > 0
							If  ((nTotBase < SFF->FF_IMPORTE) .Or. (nTotRet < SFF->FF_VALMIN)) .And. Empty(SA2->A2_IVRVCOB)
								aEval(aSFEIVA,{|x| x[6] := 0})
							EndIf
						Else
							If  (nTotBase < SFF->FF_IMPORTE) .Or. (nTotRet < SFF->FF_VALMIN)
								aEval(aSFEIVA,{|x| x[6] := 0})
							EndIf
						Endif
					Else
						nTotRet := 0
						aEval(aSFEIVA,{|x| nTotRet += x[6]})
						If SA2->(FieldPos("A2_IVRVCOB")) > 0
							For nCount:= 1 To Len(aSFEIVA)
								If !Len(aConIva[nCount])<5 .and. ValType(aConIva[nCount][5])=="N"
									If  (IIF(cpaisloc=="PAR",nTotBasIV,nTotRet)) < aConIva[nCount][5] .And. Empty(SA2->A2_IVRVCOB)
										aSFEIVA[nCount][6] -= aConIva[nCount][2]
									EndIf
								Else
									If  nTotRet < SFF->FF_IMPORTE .And. Empty(SA2->A2_IVRVCOB)
										aEval(aSFEIVA,{|x| x[6] := x[6]- aConIva[nCount][2]})
									EndIf
								EndIf
							Next nCount
						Else
							If  nTotRet < SFF->FF_IMPORTE .and. cPaisLoc == "ARG"
								aEval(aSFEIVA,{|x| x[6] := 0})
							EndIf
							If  nTotRet <= SFF->FF_IMPORTE .and. cPaisLoc == "PAR"
								aEval(aSFEIVA,{|x| x[6] := 0})
								aEval(aSFEIVA,{|x| x[4] := 0})
							EndIf
						Endif
					EndIf
				EndIf
			EndIf
		Elseif lRetPa

			SFF->(DbSetOrder(5))
			SFF->(DbSeek(xFilial("SFF")+"IVR"+cCF)) //cConceito pegar do TES (CFO)
			If SFF->(FOUND())
				While !SFF->(Eof()) .And. xFilial("SFF")+"IVR"+cCF == SFF->(FF_FILIAL+FF_IMPOSTO+FF_CFO_C)
					If !Empty(cSerieNF) .And. PadR(cSerieNF,Len(SFF->FF_SERIENF)) != SFF->FF_SERIENF
						SFF->(dbSkip())
						Loop
					EndIf
					nPercRet:=SFF->FF_ALIQ/100					
					AAdd(aSFEIVA,array(10))
					aSFEIVA[Len(aSFEIVA)][1] := ""         		//FE_NFISCAL
					aSFEIVA[Len(aSFEIVA)][2] := ""       		//FE_SERIE
					aSFEIVA[Len(aSFEIVA)][3] := Round(xMoeda((nSaldo * nSigno),nMoedaCor,1,,5,aTxMoedas[Max(nMoedaCor,1)][2]),MsDecimais(1))	//FE_VALBASE
					aSFEIVA[Len(aSFEIVA)][4] := 0	//FE_VALIMP
					aSFEIVA[Len(aSFEIVA)][5] := SA2->A2_PORIVA   		//FE_PORCRET
					aSFEIVA[Len(aSFEIVA)][6] := (aSFEIVA[Len(aSFEIVA)][3]) *(Iif(lCalRep .or. lCalcVen ,1, SA2->A2_PORIVA/100))
					aSFEIVA[Len(aSFEIVA)][9] := cCF // Gravar CFOP da opera��o
					aSFEIVA[Len(aSFEIVA)][10] := nPercRet
					If SA2->(FieldPos("A2_IVRVCOB")) > 0 .And. SA2->(FieldPos("A2_IVPCCOB")) > 0
						If SA2->A2_PORIVA < 100.00 .And. (Empty(SA2->A2_IVPCCOB) .Or. Dtos(SA2->A2_IVPCCOB) < Dtos(dDataBase))
							MsgAlert(OemToAnsi(STR0155)+SA2->A2_COD+OemToAnsi(STR0147)) //"La fecha de validad para la reducci�n del porcentaje de la retenci�n del IVA del proveedor ya se ha vencido. ". Ingrese una fecha valida para el proveedor en el archivo de proveedores."
							//Zera o array das retencoes de IVA...
							aSFEIVA := {}
							//Sai do loop...  
						EndIf
	
						If	lCalRep .or. lCalcVen
							nPercRet:= 1
						EndIf
	
						If lCalRep .or. lCalcVen
							nRetIva:=(aSFEIVA[Len(aSFEIVA)][3])*nPercRet
						Else
							nRetIva:= ((aSFEIVA[Len(aSFEIVA)][3]) *(SA2->A2_PORIVA/100))*nPercRet
						EndIf
	
					Else
						nPercRet:=SFF->FF_ALIQ/100
	
						If  lCalRep .or. lCalcVen
							nPercRet:= 1
						EndIf
						If lCalRep .or. lCalcVen
							nRetIva:= (aSFEIVA[Len(aSFEIVA)][3])*nPercRet
						Else
							nRetIva:= ((aSFEIVA[Len(aSFEIVA)][3]) *(SA2->A2_PORIVA/100))*nPercRet
						EndIf
					EndIf
	
					aArea:=GetArea()
					DbSelectArea("SFE")
					SFE->(dbSetOrder(4))
					If SFE->(dbSeek(xFilial("SFE")+cFornece+cLoja))
						cChaveSFE := xFilial("SFE")+SFE->FE_FORNECE+SFE->FE_LOJA
						While !SFE->(Eof()) .And. cChaveSFE == SFE->FE_FILIAL+SFE->FE_FORNECE+SFE->FE_LOJA
							If SFE->FE_TIPO =="I" .And. !Empty(cNumOp) .And. SFE->FE_NUMOPER == cNumOp
								nRetTotal += SFE->FE_RETENC
							EndIf
							SFE->(dbSkip())
						End
					EndIf
	
					RestArea(aArea)
	
					aSFEIVA[Len(aSFEIVA)][6]:=Iif(nRetTotal>0,((nRetTotal-nRetIva)*-1),nRetIva)
	
					//Verifica se o valor a ser retido � maior que o valor do PA
					If (IIF(cpaisloc=="PAR",nTotBasIV,nTotRet) )< aSFEIVA[Len(aSFEIVA)][6]
						aSFEIVA[Len(aSFEIVA)][6]:= nValor
					EndIF
	
					//Verifica se o valor de retencao calculado supera o valor
					//minimo a ser retido, caso seja inferior nao eh realizada
					//a retencao.
					nTotRet := 0
					aEval(aSFEIVA,{|x| nTotRet += x[6]})
					If SA2->(FieldPos("A2_IVRVCOB")) > 0
						If  (IIF(cpaisloc=="PAR",nTotBasIV,nTotRet) )< SFF->FF_IMPORTE .And. Empty(SA2->A2_IVRVCOB)
							aEval(aSFEIVA,{|x| x[6] := 0})
						EndIf
					Else
						If  (IIF(cpaisloc=="PAR",nTotBasIV,nTotRet) )< SFF->FF_IMPORTE
							aEval(aSFEIVA,{|x| x[6] := 0})
						EndIf
					Endif
					If !Empty(cSerieNF)
						SFF->(dbSkip())
					Else
						Exit
					EndIf
				EndDo
			EndIf
		EndIF

	EndIf
EndIf
RestArea(aArea)

Return aSFEIVA

/*
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � CalcRetIB  � Autor � Jose Lucas          � Data � 25.06.98 ���
��+----------+------------------------------------------------------------���
���Descri��o � Calcular e Gerar Retencoes sobre IB Ingressos Brutos.      ���
��+----------+------------------------------------------------------------���
���Uso       � PAGO011                                                    ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
*/
 Static Function CalcRetIB(cAgente,nSigno,nSaldo,cCF,cProv,lPA,nPropImp,aConfProv)
Local nRatValImp,nRateio,nValMerc,cZona,nJ,nPosIb,cEmpAct
Local nPosRet,nRecSM0
Local aZonaIb  := {}
Local nMoeda   := 1
Local aSFEIB   := {}
Local aPerIB     := {}
Local aProvVerif := {}
Local cProvEnt   := ""
Local cChave     := ""
Local nAliq      := 0
Local nVlrTotal  := 0
Local nPos       := 0
Local nI, nA	 := 0
Local lCalcIb	 := .T.
Local nTotRetSFE:=0
Local nTotBasSFE:=0
Local nLimMInRet:=0
Local nImposto:=0
Local nBaseAtual:=0
Local nImpAtual:=0
Local nRetencao:=0
Local lCalImpos:=.F.
Local nTotBase:=0
Local aImpInf := {}
Local nRecSFF := 0
Local aCF := {}
Local nDeduc	:= 0
Local nCofRet	:= 0
Local nMinUnit	:= 0
Local nMinimo	:= 0
Local nItem		:= 0
Local lCalcMon 	:= .F.
Local aAreaSFF 	:= {}
Local cItem		:= ""
Local lPropIB	:= Iif(GetMV("MV_PROPIB",.F.,1)==2,.T.,.F.)
Local aFil		:= {}
Local lRet := .F.
Local lIsento:= .F.
//
Local cQuery 		:= ""
Local cTabTemp	:= ""
Local nNumRegs 	:= 0
Local nAliqAux	:= 0
Local nCoefmul	:= 0
Local nPercTot	:= 0   
Local nAliqRet  := 0 //Alicuota Ret
Local nAliqAdc  := 0 //Alicuota adicional
Local nObtMin 	:= 0
Local cCond		:= 0
//
DEFAULT nSigno	:=	1
DEFAULT nPropImp :=1
DEFAULT aConfProv := {}
//���������������������������������������������������������������������Ŀ
//� Obter Impostos somente qdo a Empresa Usuario for Agente de Reten��o.�
//�����������������������������������������������������������������������
lEsRetAdc := .F.
aArea:=GetArea()
If !Empty(GetMV("MV_AGIIBB",,"CF|BA|SF|SE|TU|SA|JU|SL|MI|FO|ME|ER|SJ|LR|CO|CB|CA|NE|LP|TF|CH|RN|CR")) .And. nSigno > 0
	SA2->( dbSetOrder(1) )
	If !lPA
		If lMsFil .And. !Empty(xFilial("SA2")) .And. xFilial("SF1") == xFilial("SA2")
			SA2->( DbSeek(SE2->E2_MSFIL+SE2->E2_FORNECE+SE2->E2_LOJA) )
		Else
			SA2->( dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA) )
		Endif
	Else
		SA2->( dbSeek(xFilial("SA2")+cFornece+cLoja) )
	Endif
	//����������������������������������������������������������������Ŀ
	//� Generar las Retenci�n de Ingresos Brutos                       �
	//� Reter Ingressos Brutos somente se valor total da Orden de Pago �
	//� for igual ou maior que $400,00.                                �
	//������������������������������������������������������������������

	If SA2->(FieldPos("A2_DTICALB")) > 0 .And. SA2->(FieldPos("A2_DTFCALB")) > 0 ;
	   .And. !Empty(SA2->A2_DTICALB) .And. !Empty(SA2->A2_DTFCALB)
	    If  ( Dtos(dDataBase)>= Dtos(SA2->A2_DTICALB) ) .And. ( Dtos(Ddatabase) <= Dtos(SA2->A2_DTFCALB) )
	   		lCalcIb:=.F.
	    EndIf
	EndIf

	If ExistBlock("F0851IMP")
		lCalcIb:=ExecBlock("F0851IMP",.F.,.F.,{"IB"})
	EndIf

	If lCalcIb .And. SA2->A2_RETIB == "S"
    	If lRetPa .and. lPA
    		nMoeda := nMoedaCor
			nPosIb := Ascan(aZonaIb,{|X| X[1]==cCF .And. X[2]==cProv})

			//Por Entrega
			If aConfProv[2] == "1" .And. aConfProv[3] == "1" .And. aConfProv[1] == cProv
				cProvEnt := cProv
			//Por Pago
			ElseIf aConfProv[2] == "1" .And. aConfProv[3] == "2"
				SX5->(DbSeek(xFilial()+"74"))
				cSucur := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

				nRecSM0 := SM0->(RecNo())
				cEmpAct := SM0->(M0_CODIGO)

				SM0->(DbSeek(cEmpAct+cSucur))
				If SM0->(FOUND()) .And. aConfProv[1] == SM0->M0_ESTENT
					cProvEnt := SM0->M0_ESTENT
				EndIf
			//Por Inscri��o
			ElseIf aConfProv[2] == "1" .And. aConfProv[3] == "3"
				cProvEnt := aConfProv[1]
			Endif

			If Empty(cProvEnt) .And. lPA .AND. !aConfProv[2] == "2" 
				cProvEnt := cProv
			EndIf
			
			If aConfProv[1] != cProv .And. lPA
				cProvEnt := ""
			EndIf						

			AAdd(aZonaIb,{cProvEnt,cCF,nSaldo,aConfProv[4]})
		Else

			dbSelectArea("SF1")
			SF1->(dbSetOrder(1))
			If lMsfil
				SF1->(dbSeek(SE2->E2_MSFIL+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA))
			Else
				dbSeek(xFilial("SF1")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA)
			EndIf
			If SF1->(Found())
				cChave := SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
				If cPaisLoc<>"ARG"
					nRateio := 1
				else
					nRateio     := SF1->F1_VALMERC / SF1->F1_VALBRUT
				EndIf

				nRatValImp  := Iif(aConfProv[4] == "M" .And. !lPropIB,1,( Round(xMoeda(nSaldo,SE2->E2_MOEDA,1,,5,aTxMoedas[Max(SE2->E2_MOEDA,1)][2]),MsDecimais(1)) / Round(xMoeda(SF1->F1_VALBRUT,SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1)) ) )
				nValMerc    := ( Round(xMoeda(nSaldo,SE2->E2_MOEDA,1,,5,aTxMoedas[Max(SE2->E2_MOEDA,1)][2]),MsDecimais(1)) * nRateio )
			   	nMoeda   := Max(nMoeda,SF1->F1_MOEDA)

				SD1->(DbSetOrder(1))
				If lMsfil
					SD1->(DbSeek(SF1->F1_MSFIL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
				Else
					SD1->(DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
				EndIf
				If SD1->(Found())
					nObtMin := 0
					Do While IIf(lMsfil,SD1->D1_MSFIL,xFilial("SD1"))==SD1->D1_FILIAL .And. SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA == cChave
						If AllTrim(SD1->D1_ESPECIE) <> Alltrim(SF1->F1_ESPECIE)
							SD1->(DbSkip())
							Loop
						Endif

						cProvEnt := ""

						//Por Entrega
						If aConfProv[2] == "1" .And. aConfProv[3] == "1"
							If SD1->(FieldPos("D1_PROVENT")) >0 .And. !Empty(SD1->D1_PROVENT) .And. aConfProv[1] == SD1->D1_PROVENT
								cProvEnt := SD1->D1_PROVENT
							ElseIf  SF1->(FieldPos("F1_PROVENT")) >0 .And.  !Empty(SF1->F1_PROVENT) .And. aConfProv[1] == SF1->F1_PROVENT .And. Empty(SD1->D1_PROVENT)
								cProvEnt := SF1->F1_PROVENT
							Endif
						//Por Pago
						ElseIf aConfProv[2] == "1" .And. aConfProv[3] == "2"
							SX5->(DbSeek(xFilial()+"74"))
							cSucur := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
							While !SX5->(EOF())  .And. SX5->X5_TABELA=="74"
								If SD1->D1_LOCAL  $ SX5->(X5DESCRI())
									cSucur := SUBS(SX5->X5_CHAVE,3,2)
									Exit
								Endif
								SX5->(DbSkip())
							EndDo

							cEmpAct := SM0->(M0_CODIGO)

							SM0->(DbSeek(cEmpAct+cSucur))
							If SM0->(FOUND()) .And. aConfProv[1] == SM0->M0_ESTENT
								cProvEnt := SM0->M0_ESTENT
							EndIf
						//Por Inscri��o
						ElseIf aConfProv[2] == "1" .And. aConfProv[3] == "3"
							cProvEnt := aConfProv[1]
						Endif

						//homologado pelo depto. de localizacoes...
						If cProvEnt $ GetMv("MV_AGIIBB") .And. !(cProvEnt$"CF|BA|SJ|TU|SF|SE|SA|JU|SL|MI|FO|ME|ER|SJ|LR|CO|CB|CA|NE|LP|TF|CH|RN|CR")
							If aScan(aProvVerif,cProvEnt) == 0
								MsgInfo(STR0159+cProvEnt+STR0160) //"Para la provincia o ciudad de "#" es necesario que el departamento de ubicaciones de Microsiga desarrolle la rutina de calculo. Por favor entre en contacto, con el administrador del sistema."
								AAdd(aProvVerif,cProvEnt)
							EndIf

							SD1->(DbSkip())
							Loop
						EndIf
						If !(cProvEnt $ GetMv("MV_AGIIBB"))
							SD1->(DbSkip())
							Loop
						EndIf

						nVlrTotal := (SD1->D1_TOTAL+SD1->D1_BAIVAGA+SD1->D1_BAIVAFR)
			            nProp:=(nVlrTotal/SF1->F1_Valmerc)
			            nVlrTotal:=nVlrTotal-(SF1->F1_DESCONT*nProp)
						//Verifica as caracteristicas do TES para verificar se houve
						//a incidencia de Percepcao de IIBB...
						aImpInf := TesImpInf(SD1->D1_TES)
						aArea:=GetArea()
						aReaSFF:=SFF->(GetArea())
						SFF->(dbSetOrder(5)) //FF_FILIAL+FF_IMPOSTO+FF_CFO_C+FF_ZONFIS                                                                                                                         
						SFF->(dbSeek(xFilial("SFF")+"IBR" +SD1->D1_CF+cProvEnt))
				  		lCalImpos:=.F.
				  		nTotBase:=0
						If SFF->(Found())
						    lCalImpos:=.F.
							aAreaAtu:=GetArea()
							If SFF->(FieldPos("FF_INCIMP")) > 0
								For nI := 1 To Len(aImpInf)
									If(Trim(aImpInf[nI][01])$ SFF->FF_INCIMP)
										lCalImpos:=.T.
									 	nTotBase+=SD1->(FieldGet(FieldPos(aImpInf[nI][02])))
									Endif
			      				Next
			        	 	EndIf
							If (SFF->FF_IMPORTE == 0 .or. Empty(SFF->FF_IMPORTE)) .and. (CCO->(FieldPos("CCO_IMMINR")) > 0 .and. CCO->(FieldPos("CCO_TPMINR")) > 0)
								nAliq  := SFF->FF_ALIQ
								cZona  := SFF->FF_ZONFIS
								CCO->(dbSetOrder(1))	//CCO_FILIAL+CCO_CODPRO
								If CCO->(dbSeek(xFilial("CCO") + cProvEnt))
									If CCO->CCO_IMMINR <> 0
										nObtMin := IIF(!Empty(CCO->CCO_TPMINR),Val(CCO->CCO_TPMINR),0)
										nLimMInRet := CCO->CCO_IMMINR
									Endif 
								Endif 
							Else 
								nObtMin = 0
							Endif
							RestArea(aAreaAtu)
						EndIf

						RestArea(aArea)
						SFF->(RestArea(aReaSFF))

						If !lCalImpos
							For nI:=1 to Len(aImpInf)
								If "IB"$Trim(aImpInf[nI][01]) .And. Trim(aImpInf[nI][01])<>"IBR"
									If !Empty(SD1->(FieldGet(FieldPos(aImpInf[nI][10]))))
										nPos := aScan(aPerIB,{|x| x[1]==cProvent .And.	x[2]==SD1->D1_CF .And. x[3]==aImpInf[nI][01]})
										If (nPos) == 0
											AAdd(aPerIB,{cProvEnt,SD1->D1_CF,aImpInf[nI][01],aImpInf[nI][09]})
										Else
											If aImpInf[nI][09] > aPerIB[nPos][04]
												aPerIB[nPos][04] := aImpInf[nI][09]
											EndIf
										EndIf
									EndIf
								EndIf

							Next nI
						EndIf
						
						nPosIb := Ascan(aZonaIb,{|X| X[1]==cProvEnt .And. X[2]=SD1->D1_CF})

						If nPosIb == 0
							AAdd(aZonaIb,{cProvEnt,SD1->D1_CF,((nVlrTotal+nTotBase )* nRatValImp),aConfProv[4]})
						Else
							aZonaIb[nPosIb][3] := aZonaIb[nPosIb][3]+((nVlrTotal+nTotBase )* nRatValImp)
						Endif
						nVlrTotal := 0
						SD1->(DbSkip())
					Enddo
				Else
					nPosIb := Ascan(aZonaIb,{|X| X[1]==cProvEnt .And. X[2]==SD1->D1_CF})
					AAdd(aZonaIb,{cProvEnt,SD1->D1_CF,nValMerc,aConfProv[4]})
				Endif
			Else
				nPosIb := Ascan(aZonaIb,{|X| X[1]==cProvEnt .And. X[2]==SD1->D1_CF})
				AAdd(aZonaIb,{cProvEnt,SD1->D1_CF,nSaldo/1.21,aConfProv[4]})
			Endif
		EndIf
		For nJ := 1 To Len(aZonaIb)
			//Converter a base para moeda 1
			aZonaIb[nJ][3] := Round(xMoeda(aZonaIb[nJ][3],nMoeda,1,,5,aTxMoedas[nMoeda][2]),MsDecimais(1))

			cZona := IIF(nObtMin == 0,"",cZona)
			SFF->(dbSetOrder(10))
			SFF->(dbSeek(xFilial()+"IBR"+aZonaIb[nJ][2]+aZonaIb[nJ][1]+aZonaIb[nJ][4]))
			
			If SFF->FF_IMPORTE > 0 .And. !lSFFOk
				lSFFOk := .T.
			EndIf
            
			//Verificar si tiene retencion adicional
			If  SFF->(Found()) .And. SFF->(FieldPos("FF_CFORA")) > 0  
				nAliqRet  := SFF->FF_ALIQ
				lEsRetAdc :=ObtDesgl("IBR",SFF->FF_CFO_C,SFF->FF_ZONFIS,SFF->FF_TIPO,SFF->FF_CFORA,@nAliqAdc) //Obtener registro adicional                   
			Endif

			If aZonaIb[nJ][4] <> "M" .Or. (aZonaIb[nJ][4] == "M" .And. aZonaIb[nJ][1] <> "CF")
				If SFF->(Found())
					cZona := SFF->FF_ZONFIS //aZonaIb[nJ][1]
					nAliq := SFF->FF_ALIQ
					nLimMInRet:= IIF(nObtMin == 0,SFF->FF_IMPORTE,nLimMInRet)
				Else
					SFF->(dbSetOrder(11))
					If aZonaIb[nJ][1] == "CF" .And. aZonaIb[nJ][4] == "I"
						If SFF->(dbSeek(xFilial()+"IBR"+aZonaIb[nJ][1]+aZonaIb[nJ][4]+Replicate("*",TamSX3("FF_CFO_C")[1]) ))
							cZona := aZonaIb[nJ][1]
							nAliq := SFF->FF_ALIQ
							nLimMInRet:= IIF(nObtMin == 0,SFF->FF_IMPORTE,nLimMInRet)
						EndIf
					Else
						If SFF->(dbSeek(xFilial()+"IBR"+aZonaIb[nJ][1]+Replicate("*",TamSx3("FF_TIPO")[1])+Replicate("*",TamSX3("FF_CFO_C")[1]) ))
							cZona := aZonaIb[nJ][1]
							nAliq := SFF->FF_ALIQ
							nLimMInRet:= IIF(nObtMin == 0,SFF->FF_IMPORTE,nLimMInRet)
						EndIf
					EndIf
				EndIf
			Elseif aZonaIb[nJ][1] =="CF" .And. aZonaIb[nJ][4] == "M"

				If SFF->FF_TIPO == 'M'

					cItem := SFF->FF_ITEM
					cZona := SFF->FF_ZONFIS
					nAliq := SFF->FF_ALIQ
					nLimMInRet:=  IIF(nObtMin == 0,SFF->FF_IMPORTE,nLimMInRet)

					nMinimo  	:= Iif(SFF->(FieldPos("FF_LIMITE"))>0,SFF->FF_LIMITE,0)
					nMinUnit 	:= Iif(SFF->(FieldPos("FF_MINUNIT"))>0,SFF->FF_MINUNIT,0)

					aAreaSFF := SFF->(GetArea())

					SFF->(dbSetOrder(11))
					SFF->(dbSeek(xFilial()+"IBR"+aZonaIb[nJ][1]))

					//Array contendo todos os CFOs com a mesma classifica��o
					While SFF->(!Eof()) .And. SFF->FF_IMPOSTO == "IBR"
						If SFF->FF_TIPO == 'M' .And. SFF->FF_ITEM == cItem .And. SFF->FF_ZONFIS == cZona
							If aScan(aCf,{|x| x[1] == SFF->FF_CFO_C}) == 0
								aAdd(aCf,{SFF->FF_CFO_C,SFF->FF_CFO_V})
							Endif
						Endif
						SFF->(dbSkip())
					Enddo

			 		SFF->(RestArea(aAreaSFF))
					SFH->(DbSetOrder(1))
					SFH->(DbSeek(xFilial()+SA2->A2_COD+SA2->A2_LOJA+"IBR"+cZona))
					If SFH->(FOUND()) .And. (SFH->FH_ISENTO == "N" .And. A085aVigSFH())
				 		lCalcMon:= .T.
					Else
						//Verifica se deve calcular IB
						lCalcMon := F085CheckLim(cItem,aCf,SF1->F1_FORNECE,nMinimo,SF1->F1_DOC,SF1->F1_SERIE,nMinUnit,"IB",,1,Iif(lMsFil,SF1->F1_MSFIL,""))
					EndIf

				Endif
  			Endif
  			If aZonaIb[nJ][1] $ "CR|ME|"
				SFE->(dbSetOrder(4))
				nTotRetSFE:=0
				nTotBasSFE:=0
				If SFE->(dbSeek(xFilial("SFE")+SF1->F1_FORNECE+SF1->F1_LOJA))
					cChaveSFE := SFE->FE_FILIAL+SFE->FE_FORNECE+SFE->FE_LOJA
					While !SFE->(Eof()) .And. cChaveSFE == xFilial("SFE")+SFE->FE_FORNECE+SFE->FE_LOJA
						If Month(SFE->FE_EMISSAO) != Month(dDataBase) .Or.YEAR(SFE->FE_EMISSAO)!=Year(dDataBase) .Or.;
							!(SFE->FE_TIPO $"B")
							SFE->(dbSkip())
							Loop
						EndIf
						nTotRetSFE += SFE->FE_RETENC
						nTotBasSFE += SFE->FE_VALBASE
						SFE->(dbSkip())
					End
				EndIf
			 nBaseAtual:= (nTotBasSFE + (aZonaIb[nJ][3]*nPropImp))*nSigno
			EndIf

			nDeduc := 0
			nCofRet := 0

			If IIF(nObtMin = 0,!Empty(cZona),.T.) .And. (aZonaIb[nJ][4] <> "M" .Or. (aZonaIb[nJ][4] == "M" .And. lCalcMon) .Or. (aZonaIb[nJ][4] == "M" .And. aZonaIb[nJ][1] <> "CF"))
				//****************************************************
				// SE obtienen los registros de la SFH para el proveedor
				cTabTemp := criatrab(nil,.F.)
				cQuery := "SELECT * "
				cQuery += "FROM " + RetSqlName("SFH")+ " SFH "
				cQuery += "WHERE FH_FORNECE='" + SA2->A2_COD + "' AND "
				cQuery += "FH_LOJA='"  + SA2->A2_LOJA + "' AND "
				cQuery += "FH_IMPOSTO='IBR' AND "
				cquery += "FH_ZONFIS='" + cZona +"' AND "
				If !Empty(xFilial("SFH"))  .and. !Empty(xFilial("SA2")) 
					cQuery += "FH_FILIAL='" +XFILIAL("SA2") + "' AND "
				ElseIf !Empty(xFilial("SFH")) .and. !Empty(xFilial("SE2"))
					cQuery += "FH_FILIAL='" +XFILIAL("SE2") + "' AND "				
				Endif                                    
				cquery += "FH_FIMVIGE>='"+Dtos(dDataBase)+"' AND "								          
				cquery += "FH_INIVIGE<='"+Dtos(dDataBase)+"' AND "
				cQuery += "D_E_L_E_T_<>'*'"
				cQuery += "ORDER BY FH_INIVIGE,FH_FIMVIGE"

				cQuery := ChangeQuery(cQuery)

				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTabTemp,.T.,.T.)
				TCSetField(cTabTemp,"FH_INIVIGE","D")
 				TCSetField(cTabTemp,"FH_FIMVIGE","D")

				Count to nNumRegs

				If nNumRegs > 0	// Se verifica que existan registros para el proveedor en SFH
					(cTabTemp)->(dbGoTop())
					WHILE (cTabTemp)->(!eof())   .And. ;
						(cTabTemp)->FH_FORNECE==SA2->A2_COD .AND. (cTabTemp)->FH_LOJA == SA2->A2_LOJA .And. (cTabTemp)->FH_ZONFIS == cZona .And. !lRet

						If !Empty((cTabTemp)->FH_INIVIGE) .And. !Empty((cTabTemp)->FH_FIMVIGE)
							IF(dDatabase >=(cTabTemp)->FH_INIVIGE ) .AND. dDatabase <= (cTabTemp)->FH_FIMVIGE
								nCoefmul := (cTabTemp)->FH_COEFMUL
								nAliqaux := (cTabTemp)->FH_ALIQ
								lIsento  := IIF((cTabTemp)->FH_ISENTO=="S",.T.,.F.)
								nPercTot :=(100 - (cTabTemp)->FH_PERCENT) /100	 // % de Exencion del Impuesto								
								lRet := .T.
							EndIF
						Else
							if Empty((cTabTemp)->FH_INIVIGE) .and. Empty((cTabTemp)->FH_FIMVIGE)
								nCoefmul := (cTabTemp)->FH_COEFMUL
								nAliqaux := (cTabTemp)->FH_ALIQ
								lIsento  := IIF((cTabTemp)->FH_ISENTO=="S",.T.,.F.)
								nPercTot :=(100 - (cTabTemp)->FH_PERCENT) /100	 // % de Exencion del Impuesto								
							Else
								If (dDatabase >= (cTabTemp)->FH_INIVIGE .and. !Empty((cTabTemp)->FH_INIVIGE)) .or. (dDatabase <= (cTabTemp)->FH_FIMVIGE .and.  !Empty((cTabTemp)->FH_FIMVIGE))
										nAliqaux := (cTabTemp)->FH_ALIQ
										lIsento  := IIF((cTabTemp)->FH_ISENTO=="S",.T.,.F.)
										nPercTot :=(100 - (cTabTemp)->FH_PERCENT) /100	 // % de Exencion del Impuesto										
										nCoefmul := (cTabTemp)->FH_COEFMUL
										lRet := .T.
								EndIf
							EndIf
						Endif

						(cTabTemp)->(dbskip())
					EndDo

					IF nAliqAux <> 0
						lRet := .T.
					EndIF

					If lRet .and. !lIsento .AND. nAliqAux <> 0	// Si se encontr� un registro y no es excento, se toma el valor de al�quota.
						nAliq := nAliqAux
					EndIf
					//Aplica % de Reducao para Convenio Multilateral...     
						nDeduc := aZonaIb[nJ][3]
						nCofRet := nCoefMul		
						aZonaIb[nJ][3] := aZonaIb[nJ][3] *nPercTot
						If nCoefmul <> 0
							aZonaIb[nJ][3] := aZonaIb[nJ][3] * (nCoefmul/100) 
						EndIf                                                           
	  					nDeduc -= aZonaIb[nJ][3]


				End IF
				(cTabTemp)->(dbCloseArea())
                
				//Verificar si es necesario desglosar la aliquiota
                If  lEsRetAdc
                	nAliq := nAliqAdc + nAliqRet
                Endif

				//****************************************************
				If !lIsento
					If (SFF->FF_PRALQIB <> 0) .And. (Len(aPerIB) > 0)

						If aScan(aPerIB,{|x| X[1]==aZonaIb[nJ][1] .And. X[2]==aZonaIb[nJ][2] .And. x[4]<nAliq}) > 0
							nAliq := nAliq * (SFF->FF_PRALQIB/100)
						EndIf
					EndIf

					nRetencao:=Round((((aZonaIb[nJ][3]*nPropImp)*nSigno)*(nAliq/100)),TamSX3("FE_VALIMP")[2])  //FE_VALIMP
				 	nImposto := Round((nBaseAtual  * (nAliq/100)) - nTotRetSFE,TamSX3("FE_VALIMP")[2])  //FE_VALIMP

					Aadd(aSFEIb,Array(23))
					aSFEIb[Len(aSFEIb)][1] := SE2->E2_NUM                   //FE_NFISCAL
					aSFEIb[Len(aSFEIb)][2] := SE2->E2_PREFIXO               //FE_SERIE
					aSFEIb[Len(aSFEIb)][3] := (aZonaIb[nJ][3]*nPropImp)*nSigno        //FE_VALBASE
					aSFEIb[Len(aSFEIb)][4] := nAliq
					
					If aZonaIb[nJ][1] $ "CR|ME|"
						aSFEIb[Len(aSFEIb)][5] := nImposto
					Else
						aSFEIb[Len(aSFEIb)][5] := Round((aSFEIb[Len(aSFEIb)][3]*(nAliq/100)),TamSX3("FE_VALIMP")[2])  
					Endif
					
					aSFEIb[Len(aSFEIb)][6] := aSFEIb[Len(aSFEIb)][5]        //FE_RETENC
					aSFEIb[Len(aSFEIb)][7] := nSaldo //SE2->E2_VALOR
					aSFEIb[Len(aSFEIb)][8] := SE2->E2_EMISSAO
					aSFEIb[Len(aSFEIb)][9] := cZona
					aSFEIb[Len(aSFEIb)][10]:= SE2->E2_MOEDA
					aSFEIb[Len(aSFEIb)][11]:= SFF->FF_CFO_C   //CFO - Compra
					aSFEIb[Len(aSFEIb)][12]:= SFF->FF_CFO_V   //CFO - Venda
					aSFEIb[Len(aSFEIb)][13]:= SE2->E2_TIPO
					aSFEIb[Len(aSFEIb)][14]:= SFF->FF_CONCEPT
					aSFEIb[Len(aSFEIb)][15]:= nDeduc
					aSFEIb[Len(aSFEIb)][16]:= nCofRet  
					aSFEIb[Len(aSFEIb)][17]:= lEsRetAdc
					aSFEIb[Len(aSFEIb)][18]:= Iif(lEsRetAdc,SFF->FF_CFORA,"")   
					aSFEIb[Len(aSFEIb)][19]:= nAliqRet    
					aSFEIb[Len(aSFEIb)][20]:= nAliqAdc
					aSFEIb[Len(aSFEIb)][21]:= nLimMInRet
					aSFEIb[Len(aSFEIb)][22]:= nObtMin // De donde se obtuvo el minimo
					aSFEIb[Len(aSFEIb)][23]:= Iif(aZonaIb[nJ][1] $ "CR|ME|",nBaseAtual,0) // Caso Mendoza
				Endif
			Endif
		Next nJ
	EndIf
EndIf
RestArea(aArea)
Return aSFEIB

/*
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � CalcRetGN  � Autor � Jose Lucas          � Data � 25.06.98 ���
��+----------+------------------------------------------------------------���
���Descri��o � Calcular e Gerar Retencoes sobre Ganancias.                ���
��+----------+------------------------------------------------------------���
���Uso       � PAGO011                                                    ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
*/
Static Function CalcRetGN(cAgente,nSigno,aConGan,cFornece,cLoja)
Local nCount
Local cConcepto
Local nRetencMes
Local nAliq
Local nDeduc
Local nImposto
Local nImpAtual
Local nBaseAtual
Local nRetMinima
Local nPos			:= 0
Local nBasTtlRet	:= 0
Local aBasTtlRet	:= {}
Local aSFEGn   := {}
Local aArea		:=	GetArea()
Local cConcAux  := ""
Local aAreaAtu  :={}
Local aAreaSA2	:= {}
Local lReduzGan	:= .T.
Local nValImpor :=0
Local aGanComp  := {}
Local aGanRet		:= {0,.F.,.F.}

DEFAULT nSigno		:= 1

For nCount:=1  to Len(aConGan)
	If aConGan[nCount][2] < 0
		aAdd(aGanComp,-1)
	Else
		aAdd(aGanComp,1)
	Endif
	If aConGan[nCount,1] == '02' .And. !Empty(aConGan[nCount,3])
		cConcepto := aConGan[nCount,3]
	Else
		cConcepto := aConGan[nCount,1]
	Endif
	nPos := Ascan(aBasTtlRet,{|conceito| conceito[1] == cConcepto})
	If nPos == 0
		Aadd(aBasTtlRet,{cConcepto,0})
		nPos := Len(aBasTtlRet)
	Endif
	aBasTtlRet[nPos,2] += aConGan[nCount][2]
Next nCount

//���������������������������������������������������������������������Ŀ
//� Obter Impostos somente qdo a Empresa Usuario for Agente de Reten��o �
//� o el concepto sea =="07" donde siempre se debe retener,             �
//� y el total dos titulos for maior que 0.00                           �
//�����������������������������������������������������������������������
For nCount:=1  to Len(aConGan)
	SA2->( dbSetOrder(1) )
	If lMsFil .And. !Empty(xFilial("SA2")) .And. xFilial("SF1") == xFilial("SE2")
		SA2->( dbSeek(aConGan[nCount][5]+aConGan[nCount][4]) )
	Else
		SA2->( dbSeek(xFilial("SA2")+aConGan[nCount][4]) )
	Endif
	If SA2->A2_AGREGAN   == "00"
		Loop
	Endif
	If SA2->(FieldPos("A2_DTIREDG")) > 0 .And. SA2->(FieldPos("A2_DTFREDG")) > 0 ;
	   .And. !Empty(SA2->A2_DTIREDG) .And. !Empty(SA2->A2_DTFREDG)
	    If  ( Dtos(dDataBase)< Dtos(SA2->A2_DTIREDG) ) .Or. ( Dtos(Ddatabase) > Dtos(SA2->A2_DTFREDG) )
	    	lReduzGan:= .F.
	    EndIf
	EndIf

	If SA2->(FieldPos("A2_DTICALG")) > 0 .And. SA2->(FieldPos("A2_DTFCALG")) > 0 ;
	   .And. !Empty(SA2->A2_DTICALG) .And. !Empty(SA2->A2_DTFCALG)
	    If  ( Dtos(dDataBase)>= Dtos(SA2->A2_DTICALG) ) .And. ( Dtos(Ddatabase) <= Dtos(SA2->A2_DTFCALG) )
	   		Return(aSFEGN)
	    EndIf
	EndIf

	cFornece	:=	SA2->A2_COD
	cLoja		:=	SA2->A2_LOJA

	nBasRetMes := 0.00
	nRetencMes := 0.00
	cConcepto  := 	aConGan[nCount][1]
	cConcepto2 :=	aConGan[nCount][3]

	If !Empty(cConcepto).And.((subs(cAgente,1,1) == "S").Or.cConcepto=="07");
		.And. aConGan[nCount][2] <> 0.00 ;
		.And. cConcepto <> '00'

		If ( cConcepto#"07".AND.(subs(cAgente,1,1) # "S") )
			Return(aSFEGN)
		EndIf

		//�������������������������������������������������������������������������Ŀ
		//� Varrer arquivo de Retencoes para obter acumulados do mes como condomino �
		//���������������������������������������������������������������������������
		dbSelectArea("SFE")
		dbSetOrder(5)
		dbSeek(xFilial("SFE")+cFORNECE+cLOJA)
		If Found()
			ProcRegua(RecCount())
			While !Eof() .And. FE_FILIAL  == xFilial("SFE");
				.And. FE_FORCOND == cFORNECE;
				.And. FE_LOJCOND == cLOJA

				IncProc()

				If Month(FE_EMISSAO) != Month(dDataBase) .Or.YEAR(FE_EMISSAO)!=Year(dDataBase) .Or.;
					FE_TIPO != "G" .Or. FE_CONCEPT != cConcepto
					dbSkip()
					Loop
				EndIf

				nBasRetMes := nBasRetMes + FE_VALBASE
				nRetencMes := nRetencMes + FE_RETENC
				dbSkip()
			Enddo
		EndIf
		dbSelectArea("SFE")
		dbSetOrder(3)
		dbSeek(xFilial("SFE")+cFORNECE+cLOJA)
		If Found()
			ProcRegua(RecCount())
			While !Eof() .And. FE_FILIAL  == xFilial("SFE");
				.And. FE_FORNECE == cFORNECE;
				.And. FE_LOJA    == cLOJA

				IncProc()

				If Month(FE_EMISSAO) != Month(dDataBase) .Or.YEAR(FE_EMISSAO)!=Year(dDataBase) .Or.;
					FE_TIPO != "G" .Or. FE_CONCEPT != cConcepto
					dbSkip()
					Loop
				EndIf

				nBasRetMes := nBasRetMes + FE_VALBASE
				nRetencMes := nRetencMes + FE_RETENC
				dbSkip()
			Enddo
		EndIf

		//������������������������������������������������������������Ŀ
		//� Obter Base Atual para c�lculo da Gan�ncia.                 �
		//� Base Atual := ( Base Acumulada do mes + Total das NFs -    �
		//�                 Minimo disponivel mensal )                 �
		//��������������������������������������������������������������
		nAliq      := 0.00
		nDeduc     := 0.00
		nImposto   := 0.00
		nImpAtual  := 0.00

		nBaseAtual := ( nBasRetMes + aConGan[nCount][2]) * aGanComp[nCount]

		//������������������������������������������������������������������Ŀ
		//� Buscar el Valor de Retencion Minima.                             �
		//��������������������������������������������������������������������
		If cConcepto == '02' .And. !Empty(cConcepto2)
			cConcAux := cConcepto2+Space(TamSx3("FF_NUM")[1] - TamSx3("FF_ITEM")[1])
		Else
			cConcAux := cConcepto+Space(TamSx3("FF_NUM")[1] - TamSx3("FF_ITEM")[1])
		Endif
		aAreaAtu:=GetArea()
		aAreaSA2:= SA2->(GetArea())
		dbSelectArea("SA2")
		dbSetOrder(1)

		If dbSeek(xFilial("SA2")+cFORNECE+cLOJA) .AND. SA2->A2_INSCGAN == "N"
			nRetMinima :=0
		Else
			dbSelectArea("SFF")
			dbSetOrder(1)
			If dbSeek(xFilial("SFF")+cConcAux+"12")
				nRetMinima	:=	FF_IMPORTE
			Else
				// Caso ja tenha sido realizada manutencao no arquivo SFF, atraves da rotina MATA994.
				cConcAux := Space(TamSx3("FF_NUM")[1])
				If dbSeek(xFilial("SFF")+cConcAux+"12")
					nRetMinima	:=	FF_IMPORTE
				Else
					// Mantem a compatibilidade com o legado, caso nao tenha sido realizada manutencao
					// no arquivo SFF, atraves da rotina MATA994.
					cConcAux := StrZero(1,TamSx3("FF_NUM")[1])
					If dbSeek(xFilial("SFF")+cConcAux+"12")
						nRetMinima	:=	FF_IMPORTE
					Else
						nRetMinima	:=	0
					EndIf
				EndIf
			EndIf
        EndIf
		RestArea(aAreaAtu)
		SA2->(RestArea(aAreaSA2))
		//������������������������������������������������������������������Ŀ
		//� Verificar que ACTIVIDAD desempe�a el proveedor para la retencion �
		//� de IG.                                                           �
		//��������������������������������������������������������������������
		dbSelectArea("SFF")
		dbSetOrder(2)
		If cConcepto == '02' .And. !Empty(cConcepto2)
			If "FF_IMPOSTO" $ IndexKey()
				dbSeek(xFilial("SFF")+cConcepto2+'GAN')
			Else
				dbSeek(xFilial("SFF")+cConcepto2)
			Endif
		Else
			If "FF_IMPOSTO" $ IndexKey()
				dbSeek(xFilial("SFF")+cConcepto+'GAN')
			Else
				dbSeek(xFilial("SFF")+cConcepto)
			Endif
		Endif
		If SFF->FF_ESCALA $ "D| "
			//���������������������������������������������������������������Ŀ
			//� Posicionar no Item "06" da Tabela de Ganancias para Obter     �
			//� os percentuais. (Item "06" Conceito):                         �
			//� Venta de Bienes de Cambio, Bienes Muebles; Locaciones de Obra �
			//� Y/O Servicios; Transferencia Definitiva de Llaves, Marcas,    �
			//� Patentes de Invencion, Regalias, Concesion y Similares.       �
			//�����������������������������������������������������������������
			dbSelectArea("SFF")
			dbSetOrder(2)
			If cConcepto == '02' .And. !Empty(cConcepto2)
				If "FF_IMPOSTO" $ IndexKey()
					dbSeek(xFilial("SFF")+cConcepto2+'GAN')
				Else
					dbSeek(xFilial("SFF")+cConcepto2)
				Endif
				nPos := Ascan(aBasTtlRet,{|conceito| conceito[1] == cConcepto2})
			Else
				If "FF_IMPOSTO" $ IndexKey()
					dbSeek(xFilial("SFF")+cConcepto+'GAN')
				Else
					dbSeek(xFilial("SFF")+cConcepto)
				Endif
				nPos := Ascan(aBasTtlRet,{|conceito| conceito[1] == cConcepto})
			Endif
			If nPos > 0 .And. SA2->A2_CONDO $ "1|2"
				nBasTtlRet := aBasTtlRet[nPos,2]
			Else
				nBasTtlRet := nBaseAtual
			Endif
			If ( nBasTtlRet > FF_IMPORTE ) .or.  SA2->A2_INSCGAN == "N"
				//������������������������������������������������������������Ŀ
				//� Calcular Gan�ncia baseando na Tabela de Gan�ncias.         �
				//��������������������������������������������������������������
				//�����������������������������������������������������������������������Ŀ
				//� Calculo da Gan�ncia:                                                  �
				//� Imposto := ( Retencao+Base de Calculo) * (Alquota Inscrito/100)       �
				//� Imposto := Imposto Atual - Impostos ja retidos no m�s.                �
				//�������������������������������������������������������������������������
				If SA2->A2_INSCGAN == "S"
					nAliq    := FF_ALQINSC

					nDeduc   := FF_IMPORTE

					nImposto := ((FF_RETENC) + ((nBaseAtual*((100-FF_REDBASE)/100)) - nDeduc ) * (nAliq/100)) * Iif(lReduzGan,(SA2->A2_PORGAN/100),1)
					nImpAtual:= nImposto-nRetencMes
				Else
					nAliq    := FF_ALQNOIN
					nDeduc   := 0
					nImposto := ((FF_RETENC) + ((nBaseAtual*((100-FF_REDBASE)/100)) - nDeduc ) * (nAliq/100))* Iif(lReduzGan,(SA2->A2_PORGAN/100),1)
					nImpAtual:= nImposto -  nRetencMes
				EndIf
			EndIf

		Else
            nValImpor:= SFF->FF_IMPORTE
			If SFF->FF_ITEM $ "DA"
			//Derechos de Autor
				aGanRet := F085TotGan(IIf(FieldPos("FF_TPLIM") > 0,SFF->FF_TPLIM,"0"),SA2->A2_COD,SA2->A2_LOJA,SFF->FF_LIMITE,aConGan[1][2])
				If aGanRet[2]
					nBaseAtual := aGanRet[1]
					If SA2->A2_INSCGAN == "N"
						nImposto := ((SFF->FF_RETENC) + (nBaseAtual  * (SFF->FF_ALQNOIN/100))) * Iif(lReduzGan,(SA2->A2_PORGAN/100),1)
						nImpAtual:= nImposto-nRetencMes
						nAliq    := SFF->FF_ALQNOIN
						nDeduc   := 0
					Else
						//������������������������������������������������������������Ŀ
						//� Adotar a Escala Aplicable.                                 �
						//��������������������������������������������������������������
						dbSelectArea("SFF")
						dbSetOrder(2)
						If "FF_IMPOSTO" $ IndexKey()
							dbSeek(xFilial("SFF")+"13"+"GAN")
						Else
							dbSeek(xFilial("SFF")+"13")
						Endif
						While !Eof()
							//�����������������������������������������������������������������������Ŀ
							//� Calculo da Gan�ncia:                                                  �
							//� Imposto := Retencao+(Base de Calculo-Faixa Tabela) * (Percentual/100) �
							//� Imposto := Imposto Atual - Impostos ja retidos no m�s.                �
							//�������������������������������������������������������������������������
							If (nBaseAtual - nValImpor) < FF_FXATE
								nImposto := (FF_RETENC + (nBaseAtual- nValImpor -FF_FXDE)* (FF_PERC/100))* Iif(lReduzGan,(SA2->A2_PORGAN/100),1)
								nImpAtual := nImposto - nRetencMes
								nAliq :=FF_PERC
								nDeduc:=nValImpor//+FF_FXDE
								Exit
							EndIf
				    		dbSkip()
						EndDo
					EndIf
				EndIf
			Else
				If SA2->A2_INSCGAN == "N"
					nImposto := ((FF_RETENC) + (nBaseAtual  * (FF_ALQNOIN/100))) * Iif(lReduzGan,(SA2->A2_PORGAN/100),1)
					nImpAtual:= nImposto-nRetencMes
					nAliq    := FF_ALQNOIN
					nDeduc   := 0
				Else
					//������������������������������������������������������������Ŀ
					//� Adotar a Escala Aplicable.                                 �
					//��������������������������������������������������������������
					If "FF_IMPOSTO" $ IndexKey()
						dbSeek(xFilial("SFF")+"13"+"GAN")
					Else
						dbSeek(xFilial("SFF")+"13")
					Endif
					While !Eof()
						//�����������������������������������������������������������������������Ŀ
						//� Calculo da Gan�ncia:                                                  �
						//� Imposto := Retencao+(Base de Calculo-Faixa Tabela) * (Percentual/100) �
						//� Imposto := Imposto Atual - Impostos ja retidos no m�s.                �
						//�������������������������������������������������������������������������
						If (nBaseAtual - nValImpor) < FF_FXATE
							nImposto := (FF_RETENC + (nBaseAtual- nValImpor -FF_FXDE)* (FF_PERC/100))* Iif(lReduzGan,(SA2->A2_PORGAN/100),1)
							nImpAtual := nImposto - nRetencMes
							nAliq :=FF_PERC
							nDeduc:=nValImpor//+FF_FXDE
							Exit
						EndIf
			    		dbSkip()
					End
				EndIf
			EndIf
		EndIf
		//����������������������������������������������������������������Ŀ
		//� Generar las Retenci�n de Gan�ncias                             �
		//������������������������������������������������������������������
		Aadd(aSFEGn,Array(12))
		aSFEGn[Len(aSFEGn)][1] := ""
		aSFEGn[Len(aSFEGn)][2] := IIf(aGanRet[3],nBaseAtual,aConGan[nCount][2]) // FE_VALBASE
		aSFEGn[Len(aSFEGn)][3] := nAliq                                         // FE_ALIQ
		aSFEGn[Len(aSFEGn)][4] := Round(Iif(nImpAtual+nRetencMes >= nRetMinima , nImpAtual , 0 ) * nSigno,TamSX3("FE_VALIMP")[2]) * aGanComp[nCount]  // FE_VALIMP
		aSFEGn[Len(aSFEGn)][5] := Round(Iif(nImpAtual+nRetencMes >= nRetMinima , nImpAtual , 0 ) * nSigno,TamSX3("FE_RETENC")[2]) * aGanComp[nCount]  // FE_RETENC
		aSFEGn[Len(aSFEGn)][6] := nDeduc * aGanComp[nCount]                     // FE_DEDUC
		aSFEGn[Len(aSFEGn)][7] := cConcepto                                     // FE_CONCEPT
		aSFEGn[Len(aSFEGn)][8] := SA2->A2_PORGAN                                // FE_PORCRET
		aSFEGn[Len(aSFEGn)][9] := cConcepto2                                    // FE_CONCEPT
   		If SA2->(FieldPos("A2_CODCOND")*FieldPos("A2_CONDO")*FieldPos("A2_PERCCON")) > 0 .And.SA2->A2_CONDO == "2"
			aSFEGn[Len(aSFEGn)][10] := SA2->A2_COD                              // FE_PORCRET
			aSFEGn[Len(aSFEGn)][11] := SA2->A2_LOJA                                // FE_PORCRET
		Else
			aSFEGn[Len(aSFEGn)][10] := ''                              // FE_PORCRET
			aSFEGn[Len(aSFEGn)][11] := ''                              // FE_PORCRET
		Endif
		aSFEGn[Len(aSFEGn)][12] := Iif(aGanComp[nCount] < 0, .T., .F.) //NC - conceitos diferentes
	EndIf
Next
RestArea(aArea)
Return aSFEGN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA085Tela �Autor  �Bruno Sobieski      � Data �  18.10.00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Monta a tela como os detalhes das ordens de pago calculadas ���
���          � para o usuario confirmar ou modificar os dados gerados.    ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Fa085Tela(aSE2,nFlagMOD,nCtrlMOD,aCtrChEQU)
//Variaveis da tela principal
Local oOk			:= LoadBitMap(GetResources(), "LBOK")
Local oNo			:= LoadBitMap(GetResources(), "LBNO")
Local oNever		:= LoadBitMap(GetResources(), "DISABLE")
Local oPreco		:= LoadBitMap(GetResources(), "PRECO")

//Variaveis para valores temporarios
Local nA,nC,nP,nX,nY

//Buttons
Local aButtons		:=	If(!(cPaisLoc $ "EQU|DOM|COS"),{ 	{"NOTE"   ,{||   FA085Alt(aSE2[oLBx:nAt][1],aSE2[oLBx:nAt][2],oLbx:nAt,@aSE2,oDlg,@aPagos,@nValOrdens,@oValOrdens,@oLBx,@nNumOrdens,@oNumOrdens,@aSE2[oLBx:nAt][4])},OemToAnsi(STR0067),OemToAnsi(STR0008)},{'PRECO'    ,{|| A085aPagos(aSE2[oLBx:nAt][1],aSE2[oLBx:nAt][2],oLbx:nAt,@aSE2,oDlg),Fa085atuVl(@oValOrdens,@nValOrdens,@aPagos,aSE2)   },OemToAnsi(STR0077)} },;
														{ 	{"NOTE"   ,{||   FA085Alt(aSE2[oLBx:nAt][1],aSE2[oLBx:nAt][2],oLbx:nAt,@aSE2,oDlg,@aPagos,@nValOrdens,@oValOrdens,@oLBx,@nNumOrdens,@oNumOrdens,@aSE2[oLBx:nAt][4])},OemToAnsi(STR0067),OemToAnsi(STR0008)} })

//Variaveis para posicionamento na tela.
Local nHoriz
Local	y 	:= 765
Local	x	:=	430
Local	x1	:=	050
Local	y1	:=	004
Local	x2	:=	358
Local	y2	:=	120
Local	nPos1
Local	nPos2
Local	nPos3
Local   nAux
Local 	lLimpaFor	:= .F.
Local nXPagar	:=	0
Local nAbatimentos := 0.00
Local lF085MDEM := ExistBlock("F085MDEM")
Local aButUser
Local nOldIVA 	:= 0
Local nValPag		:= 0
Local lFRetMiib := .F.
Local cTipOp := "" 
Local lWn := .T.

Private lF4 := .F. //ativar ou nao a tecla F4 para a seleca do fornecedor quando as OP's estiverem agrupadas
Private nNulo

lF085aBPg := ExistBlock("F085aBPg")

If cPaisLoc $ "EQU|DOM|COS"
	nPagar := 0
Endif
If nCondAgr>1  //Adicionar botao para a relacao de fornecedores
   Aadd(aButtons,{'POSCLI' ,{|| A085AFORN(@aSE2) },OemToAnsi(trim(STR0054))+" (F4)",OemToAnsi(STR0054)}) //"Proveedor"
Endif
If cPaisLoc == "PTG"
   Aadd(aButtons,{'RECALC' ,{|| Fa085Desp(@aSE2,nMoedaCor,oLBx:nAt),Fa085atuVl(@oValOrdens,@nValOrdens,@aPagos,aSE2)    },OemToAnsi(STR0180)+"",OemToAnsi(STR0180)})
Endif
If lF085aBPg
	aButUser := ExecBlock("F085aBPg", .f.,.f., aSE2)
	If ValType( aButUser ) == "A"
		AEval( aButUser, { |x| AAdd( aButtons, x ) } )
	EndIf
EndIf

lF085aBPg := ExistBlock("F085aBPg")
If lF085aBPg
	aButUser := ExecBlock("F085aBPg", .f.,.f., aSE2)
	If ValType( aButUser ) == "A"
		AEval( aButUser, { |x| AAdd( aButtons, x ) } )
	EndIf
EndIf
cTmp  := GetSESTipos({|| ES_RCOPGER == "1"},"2")

While	!Empty(cTmp)
	AAdd(aDebMed,Substr(cTmp,1,tamSx3("E2_TIPO")[1]))
	cTmp	:=	Substr(cTmp,tamSx3("E2_TIPO")[1]+2)
Enddo
If Len(aDebMed) ==	0
	aDebMed	:=	{MVCHEQUE}
Endif
cDebMed	:=	aDebMed[1]


cTmp  := GetSESTipos({|| ES_RCOPGER == "2"},"2")
While	!Empty(cTmp)
   AAdd(aDebInm,Substr(cTmp,1,tamSx3("E2_TIPO")[1]))
	cTmp	:=	Substr(cTmp,tamSx3("E2_TIPO")[1]+2)
Enddo
If Len(aDebInm) ==	0
	If Ascan(aDebmed,"TF") = 0
	   AAdd(aDebInm,"TF")
	EndIf
	If Ascan(aDebMed,"EF") = 0
	   AAdd(aDebInm,"EF")
	EndIf
	If Len(aDebInm) ==	0
	   AAdd(aDebInm,"")
	EndIf
Endif
cDebInm	:=	aDebInm[1]


//CARREGAR ARRAY PARA USAR NA LISTBOX.
For nA	:=	1	To Len(aSE2)
	_cTipo :=  aSE2[nA][1][1][_TIPO]
	If AllTrim(aSE2[nA][1][1][_TIPO]) == "NF"
		SE2->(dbSetOrder(1))
		SE2->(dbSeek(xFilial("SE2")+aSE2[nA][1][1][_PREFIXO]+aSE2[nA][1][1][_NUM]+aSE2[nA][1][1][_PARCELA]+aSE2[nA][1][1][_TIPO]+aSE2[nA][1][1][_FORNECE]+aSE2[nA][1][1][_LOJA]))
	EndIf
	//INICIALIZAR ARRAY COM OS DADOS PIRNCIPAIS
	AAdd(aPagos,{1,aSE2[nA][1][1][_FORNECE],aSE2[nA][1][1][_LOJA],aSE2[nA][1][1][_NOME],0,0,0,0,0,0,0,0,0,0,0,0,0,0,.F.,0,0,0})
	
	SA2->(Dbseek(xfilial("SA2")+aSE2[nA][1][1][_FORNECE]))
	cPaisProv := Alltrim(SA2->A2_PAIS)
	//VERIFICAR O USO DA TECLA F4
	If nCondAgr>1                                                                                                                        
		nAux:=Len(aPagos)
		If nCondAgr==2
			If lMsFil .And. !Empty(xFilial("SA2")) .And. xFilial("SF1") == xFilial("SE2")
				SE2->(DbGoTo(aSE2[nA][1][1][_RECNO]))
				SA2->(Dbseek(SE2->E2_MSFIL+aSE2[nA][1][1][_FORNECE]))
			Else
				SA2->(Dbseek(xfilial("SA2")+aSE2[nA][1][1][_FORNECE]))
			Endif
			If SA2->A2_LOJA == aSE2[nA][1][1][_LOJA]
				SA2->(dbskip())
				If SA2->A2_FILIAL+SA2->A2_COD == xFilial("SA2")+aSE2[nA][1][1][_FORNECE]
					lLimpaFor := .T.
				EndIf
			Else
				lLimpaFor := .T.
			EndIf
			If lLimpaFor
				aPagos[nAux][H_LOJA]:=""
				aPagos[nAux][H_NOME]:=""
				If !lF4
					lF4:=.T.
				Endif
			EndIf
	   Else
	       If SA2->(Reccount())>0
  	          aPagos[nAux][H_FORNECE]:=""
  	          aPagos[nAux][H_LOJA]:=""
  	          aPagos[nAux][H_NOME]:=""
 	          If !lF4
 	             lF4:=.T.
 	          Endif
 	       Endif
	   Endif
       //LIMPA O IMPOSTO DE GANANCIAS QUANDO NAO
       //TIVER UM FORNECEDOR ESCOLHIDO PARA AS OP's.
       If cPaisLoc = "ARG" .And. Empty(aPagos[nAux][H_FORNECE])
		  aSE2[nA][2] := {}
       Endif
    Endif
    if cPaisLoc=="EQU"
    	nAbatimentos :=0
    ENDIF	
	//CARREGAR COM OS VALORES DE NOTAS PARA SER PAGAS, NNC , PAS, E NO CASO DE ARGENTINA
	//AS RETENCOES DE IMPOSTOS DE IB E IVA.
	For nC	:=	1	To Len(aSE2[nA][1])
		If cPaisLoc=="PER" .and. Alltrim(_cTipo)=="TX"
			aSE2[nA][1][nC][_SALDO1] := Round(aSE2[nA][1][nC][_SALDO1],MsDecimais(nMoedaCor))
		Endif	
		If aSE2[nA][1][nC][_TIPO] $ MVPAGANT + "/" + MV_CPNEG
			nValPag -= aSE2[nA][1][nC][_PAGAR]
		Else
			nValPag += aSE2[nA][1][nC][_PAGAR]
		EndIf
		If aSE2[nA][1][nC][_TIPO] $ MVPAGANT + "/" + MV_CPNEG
			aPagos[nA][H_NCC_PA]	+=	aSE2[nA][1][nC][_SALDO1]
			aPagos[nA][H_VALORIG]	+=	Round(xMoeda(aSE2[nA][1][nC][_SALDO1],nMoedaCor,1,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
		Else
			If cPaisLoc $ "COL|PER|MEX" .AND. aTxMoedas[aSE2[nA][1][nC][_MOEDA]][2] <> 0
				If cPaisLoc == "PER" .And. AllTrim(_cTipo) == "TX"
					aPagos[nA][H_VALORIG] += Round(xMoeda(aSE2[nA][1][nC][_PAGAR], aSE2[nA][1][nC][_MOEDA],1 , , 5, aSE2[nA][1][nC][_TXMOEDA], aTxMoedas[nMoedaCor][2]),0)
					aPagos[nA][H_NF     ] += Round(xMoeda(aSE2[nA][1][nC][_PAGAR], aSE2[nA][1][nC][_MOEDA], nMoedaCor, , 5, aSE2[nA][1][nC][_TXMOEDA], aTxMoedas[nMoedaCor][2]), 0)
				Else
					aPagos[nA][H_VALORIG] += Round(xMoeda(aSE2[nA][1][nC][_PAGAR],aSE2[nA][1][nC][_MOEDA],1,,5,aTxMoedas[aSE2[nA][1][nC][_MOEDA]][2],aTxMoedas[nMoedaCor][2]),IIF(Alltrim(_cTipo)=="TX",0,MsDecimais(nMoedaCor)))
					aPagos[nA][H_NF     ] += Round(xMoeda(aSE2[nA][1][nC][_PAGAR],aSE2[nA][1][nC][_MOEDA],nMoedaCor,,5,aTxMoedas[aSE2[nA][1][nC][_MOEDA]][2],aTxMoedas[nMoedaCor][2]),IIF(Alltrim(_cTipo)=="TX",0,MsDecimais(nMoedaCor)))
				EndIf
			Else
				aPagos[nA][H_NF]		+=	aSE2[nA][1][nC][_SALDO1]
			    aPagos[nA][H_VALORIG]	+= Round(xMoeda(aSE2[nA][1][nC][_SALDO1],nMoedaCor,1,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			EndIf
			aPagos[nA][H_NCC_PA]	+=	aSE2[nA][1][nC][_DESCONT]
		Endif
		
		If cPaisLoc $ "URU|BOL"
			For nP	:=	1	To	Len(aSE2[nA][1][nC][_RETIRIC])
				aPagos[nA][H_RETIRIC]	+=	Round(xMoeda(aSE2[nA][1][nC][_RETIRIC][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next

			For nP	:=	1	To	Len(aSE2[nA][1][nC][_RETIR])
				aPagos[nA][H_RETIR]	+=	Round(xMoeda(aSE2[nA][1][nC][_RETIR][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next
		EndIf
		If cPaisLoc == "PTG"
			For nP	:=	1	To	Len(aSE2[nA][1][nC][_RETIRC])
				aPagos[nA][H_RETIRC]		+=	Round(xMoeda(aSE2[nA][1][nC][_RETIRC ][nP][5],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next
			For nP	:=	1	To	Len(aSE2[nA][1][nC][_RETIVA])
				aPagos[nA][H_RETIVA]	+=	Round(xMoeda(aSE2[nA][1][nC][_RETIVA][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next
		Endif
		//ANGOLA
		If cPaisLoc == "ANG"
			For nP	:=	1	To	Len(aSE2[nA][1][nC][_RETRIE])
				aPagos[nA][H_RETRIE]		+=	Round(xMoeda(aSE2[nA][1][nC][_RETRIE][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next
		Endif
		//PERU
		If cPaisLoc == "PER"
		   	For nP	:=	1	To	Len(aSE2[nA][1][nC][_RETIGV])
		   	 	aPagos[nA][H_RETIGV] +=	Round(xMoeda(aSE2[nA][1][nC][_RETIGV][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2] ) ,MsDecimais(nMoedaCor))
		   	 Next
		   	For nP	:=	1	To	Len(aSE2[nA][1][nC][_RETIR])
				aPagos[nA][H_RETIR]	+=	Round(xMoeda(aSE2[nA][1][nC][_RETIR][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next
		Endif
		//Republica Dominicana
		If 	cPaisLoc $ "DOM|COS" .And. aSE2[nA][1][nC][12]	<> MVPAGANT
			aPagos[nA][H_TOTALVL]	-= SomaAbat(aSE2[nA][1][nC][9],aSE2[nA][1][nC][10],aSE2[nA][1][nC][11],"P",aSE2[nA][1][nC][4],aSE2[nA][1][nC][7],aSE2[nA][1][nC][1])
		EndIf
		If cPaisLoc == "EQU"
			If 	aSE2[nA][1][nC][12]	== "NF "
				nAbatimentos += SomaAbat(aSE2[nA][1][nC][9],aSE2[nA][1][nC][10],aSE2[nA][1][nC][11],"P",aSE2[nA][1][nC][4],aSE2[nA][1][nC][7],aSE2[nA][1][nC][1])
				aPagos[nA][H_TOTALVL] -= nAbatimentos
			EndIf
        EndIf
        If cPaisLoc == "PAR"
			For nP	:=	1	To	Len(aSE2[nA][1][nC][_RETIVA])
				aPagos[nA][H_RETIVA]	+=	Round(xMoeda(aSE2[nA][1][nC][_RETIVA][nP][4],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next
			
		   	For nP	:=	1	To	Len(aSE2[nA][1][nC][_RETIR])
				aPagos[nA][H_RETIR]		+=	Round(xMoeda(aSE2[nA][1][nC][_RETIR][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next 
		Endif
	Next nC
	If cPaisLoc	==	"ARG"
		For nC:=	1	To Len(aSE2[nA][2])
			aPagos[nA][H_RETGAN]		+=	Round(xMoeda(aSE2[nA][2][nC][5],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
		Next nC


		//************************************************************************
		//Calculo cumulativo de IVA - reten��o de documentos que n�o s�o desta OP
		//************************************************************************
		F085DocIVA(aSE2[nA][1][1][_FORNECE],aSE2[nA][1][1][_LOJA])

		If Len(aRetIvAcm[3]) > 0
			For nP := 1 to Len(aRetIvAcm[3])
				aPagos[nA][H_RETIVA]	+=	Round(xMoeda(aRetIvAcm[3][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next
		EndIf

		nOldIva += aPagos[nA][H_RETIVA]

		//Porporcionaliza as baixas menores que o acumulado de IVA
		F085PropIV(nValPag,nOldIVA,@aSE2[nA])

		//Atualiza o IVA novamente
		aPagos[nA][H_RETIVA] := 0

		For nC := 1 to Len(aSE2[nA][1])
			For nP	:=	1	To	Len(aSE2[nA][1][nC][_RETIVA])
				aPagos[nA][H_RETIVA]	+=	Round(xMoeda(aSE2[nA][1][nC][_RETIVA][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next nP
		Next nC

		If Len(aRetIvAcm[3]) > 0
			For nP := 1 to Len(aRetIvAcm[3])
				aPagos[nA][H_RETIVA]	+=	Round(xMoeda(aRetIvAcm[3][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next
		EndIf

		nOldIva := 0
		nValPag := 0

		aPagos[nA][H_TOTALVL]	:=	aPagos[nA][H_NF]-aPagos[nA][H_NCC_PA]-;
		aPagos[nA][H_RETIB]-aPagos[nA][H_RETGAN]-;
		aPagos[nA][H_RETIVA]-aPagos[nA][H_RETSUSS]-;
		aPagos[nA][H_RETSLI]-aPagos[nA][H_RETISI]-aPagos[nA][H_CAJAME]-aPagos[nA][H_CPR]
	ElseIf cPaisLoc $ "URU|BOL"
		aPagos[nA][H_TOTALVL]	:=	aPagos[nA][H_NF]-aPagos[nA][H_NCC_PA]-aPagos[nA][H_RETIRIC]-aPagos[nA][H_RETIR]
	ElseIf cPaisLoc	==	"PTG"
		aPagos[nA][H_RETIVA]  :=	Max(aPagos[nA][H_RETIVA],0)
		aPagos[nA][H_RETIRC] 	:=	Max(aPagos[nA][H_RETIRC],0)
		aPagos[nA][H_DESPESAS] 	:=	Max(aPagos[nA][H_DESPESAS],0)
		For nC:=	1	To Len(aSE2[nA][4])
			aPagos[nA][H_DESPESAS]		+=	Round(xMoeda(aSE2[nA][4][nC][2],Val(aSE2[nA][4][nC][3]),nMoedaCor,,5,aTxMoedas[Val(aSE2[nA][4][nC][3])][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
		Next nC
		aPagos[nA][H_TOTALVL]	:=	aPagos[nA][H_NF]-aPagos[nA][H_NCC_PA]-aPagos[nA][H_RETIRC]-aPagos[nA][H_RETIVA] + aPagos[nA][H_DESPESAS]
	ElseIf cPaisLoc	==	"ANG"
		aPagos[nA][H_RETRIE] 	:=	Max(aPagos[nA][H_RETRIE],0)
		aPagos[nA][H_TOTALVL]	:=	aPagos[nA][H_NF]-aPagos[nA][H_NCC_PA]-aPagos[nA][H_RETRIE]
	ElseIf cPaisLoc	==	"PER"
		aPagos[nA][H_RETIGV] 	:=	Max(aPagos[nA][H_RETIGV],0)
		aPagos[nA][H_TOTALVL]	:=	aPagos[nA][H_NF]-aPagos[nA][H_NCC_PA]-aPagos[nA][H_RETIGV]
		/* retencao de IR */
		aPagos[nA][H_RETIR] 	:=	Max(aPagos[nA][H_RETIR],0)
		aPagos[nA][H_TOTALVL]	-=	aPagos[nA][H_RETIR]
	ElseIf cPaisLoc	==	"PAR"
		aPagos[nA][H_RETIVA]  :=	aPagos[nA][H_RETIVA]
		aPagos[nA][H_RETIR] 	 :=	aPagos[nA][H_RETIR]
		aPagos[nA][H_TOTALVL]	:= aPagos[nA][H_NF]- aPagos[nA][H_NCC_PA]- aPagos[nA][H_RETIR]- aPagos[nA][H_RETIVA] 
 	ElseIf cPaisLoc	$ "DOM|COS"
 		aPagos[nA][H_TOTALVL]	+=	aPagos[nA][H_NF] - aPagos[nA][H_NCC_PA]
 	ElseIf cPaisLoc	==	"EQU"
 		aPagos[nA][H_TOTALVL]	+=	aPagos[nA][H_NF] - aPagos[nA][H_NCC_PA]
	Else
		aPagos[nA][H_TOTALVL]	:=	aPagos[nA][H_NF] - aPagos[nA][H_NCC_PA]
	Endif
	If cPaisLoc	==	"ARG"
		aPagos[nA][H_TOTRET]	:=	aPagos[nA][H_RETIB]+aPagos[nA][H_RETIVA]+aPagos[nA][H_RETGAN]+aPagos[nA][H_RETSUSS]+aPagos[nA][H_RETSLI]
		aPagos[nA][H_RETIB]		:=	TransForm(aPagos[nA][H_RETIB]  ,Tm(aPagos[nA][H_RETIB ] ,16,nDecs))
		aPagos[nA][H_RETGAN]	:=	TransForm(aPagos[nA][H_RETGAN] ,Tm(aPagos[nA][H_RETGAN] ,16,nDecs))
		aPagos[nA][H_RETIVA]	:=	TransForm(aPagos[nA][H_RETIVA] ,Tm(aPagos[nA][H_RETIVA] ,16,nDecs))
		aPagos[nA][H_RETSUSS]	:=	TransForm(aPagos[nA][H_RETSUSS],Tm(aPagos[nA][H_RETSUSS],16,nDecs))
		aPagos[nA][H_RETSLI]	:=	TransForm(aPagos[nA][H_RETSLI] ,Tm(aPagos[nA][H_RETSLI] ,16,nDecs))
		aPagos[nA][H_RETISI]	:=	TransForm(aPagos[nA][H_RETISI] ,Tm(aPagos[nA][H_RETISI] ,16,nDecs))
		aPagos[nA][H_CAJAME]	:=	TransForm(aPagos[nA][H_CAJAME] ,Tm(aPagos[nA][H_CAJAME] ,16,nDecs))
		aPagos[nA][H_CPR]		:=	TransForm(aPagos[nA][H_CPR]    ,Tm(aPagos[nA][H_CPR] ,16,nDecs))
	ElseIf cPaisLoc $ "URU|BOL"
		aPagos[nA][H_TOTRET]	:=	aPagos[nA][H_RETIRIC]+ aPagos[nA][H_RETIR]
		aPagos[nA][H_RETIRIC]	:=	TransForm(aPagos[nA][H_RETIRIC],Tm(aPagos[nA][H_RETIRIC],16,nDecs))
		aPagos[nA][H_RETIR]	:=	TransForm(aPagos[nA][H_RETIR],Tm(aPagos[nA][H_RETIR],16,nDecs))
	ElseIf cPaisLoc == "PTG"
		aPagos[nA][H_TOTRET]	:=	aPagos[nA][H_RETIRC]+ aPagos[nA][H_RETIVA]
		aPagos[nA][H_RETIRC]	:=	TransForm(aPagos[nA][H_RETIRC],Tm(aPagos[nA][H_RETIRC],16,nDecs))
		aPagos[nA][H_RETIVA]	:=	TransForm(aPagos[nA][H_RETIVA],Tm(aPagos[nA][H_RETIVA],16,nDecs))
		aPagos[nA][H_DESPESAS]:=	TransForm(aPagos[nA][H_DESPESAS] ,Tm(aPagos[nA][H_DESPESAS] ,16,nDecs))
	//ANGOLA
	ElseIf cPaisLoc == "ANG"
		aPagos[nA][H_TOTRET]	:=	aPagos[nA][H_RETRIE]
		aPagos[nA][H_RETRIE]	:=	TransForm(aPagos[nA][H_RETRIE],Tm(aPagos[nA][H_RETRIE],16,nDecs))
	ElseIf cPaisLoc $ "DOM|COS"

		//Array aRetencao - Preenchido na fun��o fa050CalcRet() - C�lculo de reten��o com Conf. de Impostos
		If Len(aRetencao) > 0
			For nX := 1 to Len(aRetencao)
				If aRetencao[nX][6] == aPagos[nA][H_FORNECE ] .And. aRetencao[nX][7] == aPagos[nA][H_LOJA ]
					For nY := 1 to Len(aRetencao[nX][8])
						If aRetencao[nX][8][nY][3] == "1"
							aPagos[nA][H_TOTRET ] += aRetencao[nX][8][nY][2]
						ElseIf aRetencao[nX][8][nY][3] == "2"
							aPagos[nA][H_NCC_PA ] += aRetencao[nX][8][nY][2]
							aPagos[nA][H_TOTALVL] -= aRetencao[nX][8][nY][2]
						EndIf
					Next nY
				EndIf
			Next nX
		Else
			aPagos[nA][H_TOTRET ] := 0
		EndIf

	ElseIf cPaisLoc == "PER"
		aPagos[nA][H_TOTRET]	:=	aPagos[nA][H_RETIGV]
		aPagos[nA][H_RETIGV]	:=	TransForm(aPagos[nA][H_RETIGV],Tm(aPagos[nA][H_RETIGV],16,nDecs))
		/* retencao de IR */
		aPagos[nA][H_TOTRET]	+=	aPagos[nA][H_RETIR]
		aPagos[nA][H_RETIR]	:=	TransForm(aPagos[nA][H_RETIR],Tm(aPagos[nA][H_RETIR],16,nDecs))
	ElseIf cPaisLoc == "PAR"
		aPagos[nA][H_TOTRET]	:=	aPagos[nA][H_RETIVA] + aPagos[nA][H_RETIR]
		aPagos[nA][H_RETIVA]	:=	TransForm(aPagos[nA][H_RETIVA],Tm(aPagos[nA][H_RETIVA],16,nDecs))
		aPagos[nA][H_RETIR]	:=	TransForm(aPagos[nA][H_RETIR],Tm(aPagos[nA][H_RETIR],16,nDecs)	)
	ElseIf cPaisLoc == "EQU"
		aPagos[nA][H_TOTRET ] := nAbatimentos
 		aPagos[nA][H_TOTALVL] := aPagos[nA][H_NF] - aPagos[nA][H_NCC_PA] - aPagos[nA][H_TOTRET] - aPagos[nA][H_DESCVL] + aPagos[nA][H_MULTAS]
		aPagos[nA][H_NF     ] := aPagos[nA][H_NF     ]
		aPagos[nA][H_NCC_PA ] := aPagos[nA][H_NCC_PA ]
		aPagos[nA][H_TOTRET ] := aPagos[nA][H_TOTRET ]
		aPagos[nA][H_DESCVL ] := aPagos[nA][H_DESCVL ]
		aPagos[nA][H_MULTAS ] := aPagos[nA][H_MULTAS ]
		aPagos[nA][H_TOTAL  ] := aPagos[nA][H_TOTALVL]
	EndIf

	If	cPaisLoc $ "DOM|COS"
		If 	aPagos[nA][H_TOTALVL]	<	0
			aPagos[nA][1]			:=	0
			aPagos[nA][H_TOTALVL]   :=  0
		Else
			nValOrdens 				+=	aPagos[nA][H_TOTALVL]
			nNumOrdens++
		Endif
	Else
		If cPaisLoc $ "BOL"
			If 	aPagos[nA][H_VALORIG]	<	0
				aPagos[nA][1]			:=	0
			Else
				nValOrdens 				+=	aPagos[nA][H_VALORIG]
				nNumOrdens++
			Endif
		ElseIf cPaisLoc $ "CHI|PAR|URU"
			If 	aPagos[nA][H_TOTALVL]	<	0
				aPagos[nA][1]			:=	0
			Endif
			nValOrdens 				+=	aPagos[nA][H_TOTALVL]
			nNumOrdens++
		Else
			If 	aPagos[nA][H_TOTALVL]	<	0
				aPagos[nA][1]			:=	0
			Else
				nValOrdens 				+=	aPagos[nA][H_TOTALVL]
				nNumOrdens++
			Endif
		Endif	
	EndIf

	If cPaisLoc $ "DOM|COS"
		aPagos[nA][H_NF    ] 	+=  aPagos[nA][H_TOTRET] //Somo as reten��es j� descontadas
	EndIf

	If cPaisLoc <> "EQU"
		aPagos[nA][H_DESCVL]	:=	aPagos[nA][H_DESCVL]
		aPagos[nA][H_NF    ]	:=	TransForm(aPagos[nA][H_NF     ],Tm(aPagos[nA][H_NF]    ,16,nDecs))
		aPagos[nA][H_NCC_PA]	:=	TransForm(aPagos[nA][H_NCC_PA ],Tm(aPagos[nA][H_NCC_PA],16,nDecs))
		aPagos[nA][H_TOTAL ]	:=	TransForm(aPagos[nA][H_TOTALVL],Tm(aPagos[nA][H_TOTALVL] ,18,nDecs))
	EndIf
Next nA

If cPaisLoc ==	"ARG"
	aSizes	:=	{5	,30                ,25				   ,90				  ,60				  ,60				 ,60				,60					,60				   ,60			       ,60                ,60				,60                     ,30					,60				  ,60}
	aFields	:=	{" ",OemToAnsi(STR0054),OemToAnsi(STR0055),OemToAnsi(STR0056),OemToAnsi(STR0057),OemToAnsi(STR0058),OemToAnsi(STR0062),OemToAnsi(STR0059),OemToAnsi(STR0060),OemToAnsi(STR0061),OemToAnsi(STR0150),OemToAnsi(STR0158),OemToAnsi("Ret. ISI"),;
					 OemToAnsi(STR0202),OemToAnsi(STR0254),OemToAnsi("Ret. CPR")}
ElseIf cPaisLoc $ "URU|BOL"
	aSizes	:=	{5	,30				   ,25                 ,90				  ,60			      ,60			     ,60				,60				,60}
	aFields	:=	{" ",OemToAnsi(STR0054),OemToAnsi(STR0055),OemToAnsi(STR0056),OemToAnsi(STR0057),OemToAnsi(STR0058),OemToAnsi(STR0062),OemToAnsi(STR0148),OemToAnsi(STR0175)}
ElseIf cPaisLoc ==	"PTG"
	aSizes	:=	{5	,30                ,25				   ,90				  ,60				  ,60				 ,60				,60 ,60				}
	aFields	:=	{" ",OemToAnsi(STR0054),OemToAnsi(STR0055),OemToAnsi(STR0056),OemToAnsi(STR0057),OemToAnsi(STR0058),OemToAnsi(STR0060),OemToAnsi(STR0176),"Despesas"}
ElseIf cPaisLoc ==	"ANG"
	aSizes	:=	{5	 ,30					  ,25						,90					 ,60		    ,60				,60 ,60			}
	aFields	:=	{" ",OemToAnsi(STR0054),OemToAnsi(STR0055),OemToAnsi(STR0056),OemToAnsi(STR0057),OemToAnsi(STR0058),OemToAnsi(STR0192),OemToAnsi(STR0062)}
ElseIf cPaisLoc ==	"PER"
	aSizes	:=	{5	 ,30					  ,25						,90					 ,60		    ,60				,60 ,60,60			}
	aFields	:=	{" ",OemToAnsi(STR0054),OemToAnsi(STR0055),OemToAnsi(STR0056),OemToAnsi(STR0057),OemToAnsi(STR0058),OemToAnsi(STR0196),OemToAnsi(STR0203),OemToAnsi(STR0062)}
ElseIf cPaisLoc == "EQU"
	aSizes	:=	{5	 ,30			   ,25				  ,90				 ,60		        ,60	                          ,60			           ,60                     ,60                             ,60                }
	aFields	:=	{" ",OemToAnsi(STR0054),OemToAnsi(STR0055),OemToAnsi(STR0056),OemToAnsi(STR0057),OemToAnsi(STR0241),OemToAnsi(STR0242),OemToAnsi(STR0243),OemToAnsi(STR0244),OemToAnsi(STR0062)}
ElseIf cPaisLoc $ "DOM|COS"
	aSizes	:=	{5	 	,30					,25					,90					 	,60		    		,60	   				,60					,60					}
	aFields	:=	{" "	,OemToAnsi(STR0054)	,OemToAnsi(STR0055)	,OemToAnsi(STR0056)		,OemToAnsi(STR0057)	,OemToAnsi(STR0058)	,OemToAnsi(STR0098)	,OemToAnsi(STR0062)	}
ElseIf cPaisLoc == "PAR"
	aSizes	:=	{5	 ,30					  ,25						,90					 ,60		    ,60				,60                ,60			}
	aFields	:=	{" ",OemToAnsi(STR0054),OemToAnsi(STR0055),OemToAnsi(STR0056),OemToAnsi(STR0057),OemToAnsi(STR0058),OemToAnsi(STR0060),OemToAnsi(STR0203),OemToAnsi(STR0062)}
Else
	aSizes	:=	{5	 ,30					  ,25						,90					 ,60		    ,60	   ,60			}
	aFields	:=	{" ",OemToAnsi(STR0054),OemToAnsi(STR0055),OemToAnsi(STR0056),OemToAnsi(STR0057),OemToAnsi(STR0058),OemToAnsi(STR0062)}
Endif

oBrw	:=	GetMbrowse()
nHoriz  := oMainWnd:nClientWidth
nOpc	:= 0

If Type("nHoriz")=="N".And.nHoriz < 800
	y 	:= 615
	x	:=	290
	x1	:=	030
	y1	:=	004
	x2	:=	290
	y2	:=	090
Endif

nPos1	:=	(x2-y1 + 09)
nPos2 :=	(x2-y1 + 09) * 0.20
nPos3 := (x2-y1 + 09) * 0.80

If ExistBlock("A085DEFS")
	ExecBlock("A085DEFS",.F.,.F.,"1")
Endif

If lF4
   SetKey(VK_F4,{||A085AFORN(@aSE2)})
Endif
aSize := MSADVSIZE()

//���������������������������������������������������������������Ŀ
//� Folder para o Titulos e forma de pagamento                    �
//�����������������������������������������������������������������
DEFINE MSDIALOG oDlg FROM aSize[7],0 TO aSize[6],aSize[5] PIXEL TITLE OemToAnsi(STR0063) //"Representa��o gr�fica do Fluxo de Caixa"

@00,01 FOLDER oFolder OF oDlg PROMPT OemToAnsi(STR0078),OemToAnsi(STR0079)  PIXEL SIZE x2-y1+15,185 //"Ordenes"###"Forma de pago"

oFolder:aDialogs[1]:oFont := oDlg:oFont
oFolder:aDialogs[2]:oFont := oDlg:oFont

//�������������������������Ŀ
//�Folder das ordens de pago�
//���������������������������
oPanel := TPanel():New(0,0,'',oFolder:aDialogs[1],, .T., .T.,, ,50,50,.T.,.T. )
oPanel:Align := CONTROL_ALIGN_TOP
IIF(Alltrim(_cTipo)=="TX".And.cPaisLoc<> "PER",nValOrdens:=Round(nValOrdens,0),.T.)

@ 04,04 To (x1-4),nPos1 Pixel Of 	oFolder:aDialogs[1]

@ 13,006 SAY OemToAnsi(STR0064)  Size 70,08 	Pixel Of 	oPanel  //"�rdenes de Pago     : "
@ 14,100 SAY oNumOrdens Var nNumOrdens 		PIXEL OF 	oPanel COLOR CLR_BLUE//"�rdenes de Pago     : "

If lUUID
	@ 14,160 SAY OemToAnsi(STR0267)  Size 70,08 	Pixel Of 	oPanel  //"Folio Fiscal     : "
	@ 13,210  MSGET oUUID Var __cUUID 	Size 150,008 Pixel Of oPanel PICTURE	PesqPict("SEK","EK_UUID",TamSX3("EK_UUID")[1])//SAY oNumOrdens Var nNumOrdens 		PIXEL OF 	oPanel COLOR CLR_BLUE//"Ordenes de Pago     : "	
EndIf

@ 21,006 SAY OemToAnsi(STR0065)  Size 70,08 Pixel Of 	oPanel   //"Total a Desembolsar : "
@ 21,075 SAY oValOrdens Var nValOrdens  Size 80,08 Pixel Of 	oPanel PICTURE PesqPict("SE2","E2_PAGAR",17,nDecs) COLOR CLR_BLUE //"Ordenes de Pago     : "

@ 34,	006 SAY OemtoAnsi(STR0068) SIZE 22, 07 OF oPanel PIXEL         //"Exibir valores em : "
@ 31,	036 COMBOBOX oCBX VAR cMoeda ITEMS aMoeda   ON CHANGE (nMoedaCor:=oCBX:nAt,nDecs:=MsDecimais(nMoedaCor),Fa085atuVl(@oValOrdens,@nValOrdens,@aPagos,aSE2)) SIZE 50,50 OF oPanel PIXEL

If nMoedaCor == 1
	aPagosOrig:=aClone(aPagos)
EndIf

oLBx := TWBrowse():New( x1,y1,x2,y2,,aFields,aSizes,	oFolder:aDialogs[1],,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oLBx:SetArray(aPagos)
oLBx:bLDblClick	:= { || a085aOrdPg() }

//Se o ponto de entrada F085MDEM estiver no RPO for�o a atualiza��o dos valores
//desta forma ao carregar a tela de orden de pago as taxas j� estar�o preenchidas
//caso o t�tulo original esteja em moeda diferente de 1
If lF085MDEM
	Fa085atuVl(@oValOrdens,@nValOrdens,@aPagos,aSE2)
EndIf

If cPaisLoc $ "URU|BOL"
	oLBx:bLine 		:= { || {If(aPagos[oLBx:nAt,1]>0,oOk,If(aPagos[oLBx:nAt,1]<0,oNo,oNever)),aPagos[oLBx:nAT][2],aPagos[oLBx:nAT][3],aPagos[oLBx:nAT][4],aPagos[oLBx:nAT][5],aPagos[oLBx:nAT][6],aPagos[oLBx:nAT][7],aPagos[oLBx:nAT][8],aPagos[oLBx:nAT][11]}}
ElseIf cPaisLoc == "PTG"
//	aFields	:=	{" ",OemToAnsi(STR0054),OemToAnsi(STR0055),OemToAnsi(STR0056),OemToAnsi(STR0057),OemToAnsi(STR0058),OemToAnsi(STR0060),OemToAnsi(STR0176)}
	oLBx:bLine 		:= { || {If(aPagos[oLBx:nAt,1]>0,oOk,If(aPagos[oLBx:nAt,1]<0,oNo,oNever)),aPagos[oLBx:nAT][2],aPagos[oLBx:nAT][3],aPagos[oLBx:nAT][4],aPagos[oLBx:nAT][5],aPagos[oLBx:nAT][6],aPagos[oLBx:nAT][H_RETIVA],aPagos[oLBx:nAT][H_RETIRC],aPagos[oLBx:nAT][H_DESPESAS]}}
//ANGOLA
ElseIf cPaisLoc == "ANG"
	oLBx:bLine 		:= { || {If(aPagos[oLBx:nAt,1]>0,oOk,If(aPagos[oLBx:nAt,1]<0,oNo,oNever)),aPagos[oLBx:nAT][2],aPagos[oLBx:nAT][3],aPagos[oLBx:nAT][4],aPagos[oLBx:nAT][5],aPagos[oLBx:nAT][6],aPagos[oLBx:nAT][H_RETRIE],aPagos[oLBx:nAT][H_TOTAL]}}
ElseIf cPaisLoc == "PER"
	oLBx:bLine 		:= { || {If(aPagos[oLBx:nAt,1]>0,oOk,If(aPagos[oLBx:nAt,1]<0,oNo,oNever)),aPagos[oLBx:nAT][2],aPagos[oLBx:nAT][3],aPagos[oLBx:nAT][4],aPagos[oLBx:nAT][5],aPagos[oLBx:nAT][6],aPagos[oLBx:nAT][H_RETIGV],aPagos[oLBx:nAT][H_RETIR],aPagos[oLBx:nAT][H_TOTAL]}}
ElseIf cPaisLoc == "PAR"
	oLBx:bLine 		:= { || {If(aPagos[oLBx:nAt,1]>0,oOk,If(aPagos[oLBx:nAt,1]<0,oNo,oNever)),aPagos[oLBx:nAT][2],aPagos[oLBx:nAT][3],aPagos[oLBx:nAT][4],aPagos[oLBx:nAT][5],aPagos[oLBx:nAT][6],aPagos[oLBx:nAT][H_RETIVA],aPagos[oLBx:nAT][H_RETIR],aPagos[oLBx:nAT][H_TOTAL]}}
ElseIf cPaisLoc == "EQU"
   	oLBx:bLine 		:= { || {If(aPagos[oLBx:nAt,1]>0,oOk,If(aPagos[oLBx:nAt,1]<0,oNo,oNever)),;
   	aPagos[oLBx:nAT][H_FORNECE],;
   	aPagos[oLBx:nAT][H_LOJA],;
   	aPagos[oLBx:nAT][H_NOME],;
   	TransForm(aPagos[oLBx:nAT][H_NF    ],Tm(aPagos[oLBx:nAT][H_NF    ],16,nDecs)),;
   	TransForm(aPagos[oLBx:nAT][H_NCC_PA],Tm(aPagos[oLBx:nAT][H_NCC_PA],16,nDecs)),;
   	TransForm(aPagos[oLBx:nAT][H_TOTRET],Tm(aPagos[oLBx:nAT][H_TOTRET],16,nDecs)),;
   	TransForm(aPagos[oLBx:nAT][H_DESCVL],Tm(aPagos[oLBx:nAT][H_DESCVL],16,nDecs)),;
   	TransForm(aPagos[oLBx:nAT][H_MULTAS],Tm(aPagos[oLBx:nAT][H_MULTAS],16,nDecs)),;
   	TransForm(aPagos[oLBx:nAT][H_TOTAL ],Tm(aPagos[oLBx:nAT][H_TOTAL ],16,nDecs))}}
ElseIf cPaisLoc $ "DOM|COS"
	oLBx:bLine 		:= { || {If(aPagos[oLBx:nAt,1]>0,oOk,If(aPagos[oLBx:nAt,1]<0,oNo,oNever)),;
							  aPagos[oLBx:nAT][H_FORNECE],;
							  aPagos[oLBx:nAT][H_LOJA],;
							  aPagos[oLBx:nAT][H_NOME],;
							  aPagos[oLBx:nAT][H_NF],;
							  aPagos[oLBx:nAT][H_NCC_PA],;
							  TransForm(aPagos[oLBx:nAT][H_TOTRET],Tm(aPagos[oLBx:nAT][H_TOTRET],16,nDecs)),;
							  aPagos[oLBx:nAT][H_TOTAL]}}
Else
	oLBx:bLine 		:= { || {If(aPagos[oLBx:nAt,1]>0,oOk,If(aPagos[oLBx:nAt,1]<0,oNo,oNever)),aPagos[oLBx:nAT][2],aPagos[oLBx:nAT][3],aPagos[oLBx:nAT][4],aPagos[oLBx:nAT][5],aPagos[oLBx:nAT][6],aPagos[oLBx:nAT][7]}}
Endif

If cPaisLoc $ 'MEX|PER'
	cTipOp:= POSICIONE("SED",1,xFilial("SED")+SE2->E2_NATUREZ ,"ED_OPERADT")
	//Valida Modalidad de operaci�n 
	If cTipOp == '1'
		cNatureza:= SE2->E2_NATUREZ
		lWn := .F.
	EndIf	
EndIf
//�������������������������Ŀ
//�Folder da forma de pago  �
//���������������������������

//Valores a entregar
@ 003,004 To 030,nPos1 Pixel Of  oFolder:aDialogs[2]
//"En esta instancia debe escojer el medio para el pago de las ordenes de pago"
//", si desea escojer un medio diferenciado para alguno de los proveedores, posicionese en el mismo y  clicke en el boton"
//"Pagos diferenciados"
@ 007,008 SAY OemToAnsi(STR0080+STR0081+' "'+ STR0082+'"')    SIZE x2-y1,15 OF oFolder:aDialogs[2] COLOR CLR_BLUE PIXEL


@ 041,006 SAY  OemToAnsi(STR0207) Size 50,07  PIXEL of oFolder:aDialogs[2]  //
@ 041,048 MSGET cNatureza	F3	"SED"	SIZE 50,07 Valid  a085aVldMD(1,cNatureza,@cMod,nFlagMOD)  PIXEL of oFolder:aDialogs[2]  WHEN lWn HASBUTTON

If lF085aChS
	@ 053,004 To 180,nPos1 Pixel Of  oFolder:aDialogs[2] LABEL OemToAnsi(STR0083) //"Pagar con"
	@ 065,006  RADIO oPagar VAR nPagar 3D ;
	SIZE 120,10 ;
	ITEMS OemToAnsi(STR0085),OemToAnsi(STR0086); //"Debito diferido"###"Debito Inmediato"
	ON CHANGE { || nPagar+=1, a085aRefr(nPagar,@oCbx1,@oCbx2,@oDataVenc,@oDataVenc1,@oChkBox,@oDataTxt1,@oDataTxt2,@oTipo,@oValorPg) };
	OF oFolder:aDialogs[2] Pixel
Else
	@ 053,004 To 180,nPos1 Pixel Of  oFolder:aDialogs[2] LABEL OemToAnsi(STR0083) //"Pagar con"
	@ 065,006  RADIO oPagar VAR nPagar 3D ;
	SIZE 120,10 ;
	ITEMS OemToansi(STR0084), OemToAnsi(STR0085),OemToAnsi(STR0086); //"Cheque Pre-Impreso"###"Debito diferido"###"Debito Inmediato"
	ON CHANGE { || a085aRefr(nPagar,@oCbx1,@oCbx2,@oDataVenc,@oDataVenc1,@oChkBox,@oDataTxt1,@oDataTxt2,@oTipo,@oValorPg) };
	OF oFolder:aDialogs[2] Pixel
Endif

@ 100,010 To 128,nPos1-5 Pixel Of  oFolder:aDialogs[2] LABEL OemToAnsi(STR0087) //"Datos del titulo de pago"

//Box para selecionar a data do debito do cheque pre-impresso
@ 110,015 SAY oDataTxt1 Var OemToAnsi(STR0088) SIZE 50,10 OF	oFolder:aDialogs[2] PIXEL //"Fecha para el debito "
@ 110,080 GET oDataVenc1 VAR dDataVenc1 Valid fa085DtVenc(dDataVenc)	SIZE 34,09 OF	oFolder:aDialogs[2] PIXEL
@ 110,015 SAY oTipo VAR OemToAnsi(STR0089) SIZE 10,10 OF 	oFolder:aDialogs[2] PIXEL //"Tipo "

//Box para selecionar a data do debito do titulo de debito diferido
@ 110,030 COMBOBOX oCBX1 VAR cDebMed ITEMS aDebMed SIZE 50,50 OF 	oFolder:aDialogs[2] PIXEL
@ 110,090 SAY oDataTxt2 VAR OemToAnsi(STR0088) SIZE 50,10 OF	oFolder:aDialogs[2] PIXEL //"Fecha para el debito "
@ 110,150 GET oDataVenc VAR dDataVenc Valid fa085DtVenc(dDataVenc)	SIZE 34,09 OF	oFolder:aDialogs[2] PIXEL
@ 115,200 CHECKBOX oChkBox Var lBaixaChq	PROMPT OemToAnsi(STR0090) SIZE 80,16 PIXEL When (dDataVenc==dDataBase) Of oFolder:aDialogs[2] //"� Debitar los titulos ahora ? "

//Box para escolher o titulo de debito Inmediato
If cPaisLoc $ "DOM"
	lFa085aTot:=FA085ATOT(aPagos)
	If !lFa085aTot
		nTamEK:=(tamSx3("EK_TIPO")[1] -2)
		aDebInm:={}
	   AAdd(aDebInm,"TF"+Space(nTamEK))
	Endif
	@ 110,030 COMBOBOX oCBX2 VAR cDebInm ITEMS aDebInm  SIZE 50,50 OF 	oFolder:aDialogs[2] PIXEL When (nPagar==3 .and. lFa085aTot)
Else
	@ 110,030 COMBOBOX oCBX2 VAR cDebInm ITEMS aDebInm  SIZE 50,50 OF 	oFolder:aDialogs[2] PIXEL When (nPagar==3)
Endif


//Box com os dados do banco
@ 140,010 To 170,nPos1-5 Pixel Of  oFolder:aDialogs[2] LABEL OemToAnsi(STR0091) //"Banco"

@ 147,015 SAY OemToAnsi(STR0091) 		 SIZE 19, 7 OF oFolder:aDialogs[2] PIXEL //"Banco"
@ 147,050 SAY OemToAnsi(STR0092) 		 SIZE 25, 7 OF oFolder:aDialogs[2] PIXEL //"Agencia"
@ 147,083 SAY OemToAnsi(STR0093) 		 SIZE 20, 7 OF oFolder:aDialogs[2] PIXEL //"Cuenta"

@ 155,016 MSGET cBanco		F3 "SA6" Picture "@S4"    Valid CarregaSa6(@cBanco,@cAgencia,@cConta,.F.) 	.And. (ExistCpo("SA6",cBanco+cAgencia+cConta ) .and. IF(lRetCkPG(0,cDebInm,cBanco,nPagar),.T.,.T.) .Or.Empty(cBanco  )) .And. If(CCBLOCKED(cBanco,cAgencia,cConta),.F.,.T.) SIZE 12, 10 OF oFolder:aDialogs[2] PIXEL HASBUTTON
@ 155,050 MSGET cAgencia	Picture "@S5"             Valid CarregaSa6(@cBanco,@cAgencia,@cConta,.F.)	.And. (ExistCpo("SA6",cBanco+cAgencia+cConta ).Or.Empty(cAgencia)) .And. If(CCBLOCKED(cBanco,cAgencia,cConta),.F.,.T.) SIZE 20, 10 OF oFolder:aDialogs[2] PIXEL
@ 155,083 MSGET cConta		Picture "@S10"            Valid CarregaSa6(@cBanco,@cAgencia,@cConta,.F.)	.And. (ExistCpo("SA6",cBanco+cAgencia+cConta ).Or.Empty(cConta)) .And. If(CCBLOCKED(cBanco,cAgencia,cConta),.F.,.T.) SIZE 45, 10 OF oFolder:aDialogs[2] PIXEL

If cPaisLoc == "MEX" .And. cPaisProv <> "493" .and. SEK->(FieldPos("EK_DCONCEP")) > 0
	@ 185,005 To 225,nPos1 Pixel Of  oFolder:aDialogs[2] LABEL OemToAnsi(STR0258) //"Banco"
	@ 200,010 MSGET cDesc		Picture "@"    Valid Len(cDesc) <= 255 .and. !Vazio() SIZE nPos1 - 15, 20 OF oFolder:aDialogs[2] PIXEL
EndIf
a085aRefr(nPagar,@oCbx1,@oCbx2,@oDataVenc,@oDataVenc1,@oChkBox,@oDataTxt1,@oDataTxt2,@oTipo,,,,,,,,,,,,,,,,,,,,,,,,@nNulo)

oDlg:lMaximized := .T.
oFolder:Align := CONTROL_ALIGN_ALLCLIENT
oLBx:Align := CONTROL_ALIGN_ALLCLIENT
ACTIVATE MSDIALOG oDlg  CENTERED ON INIT (EnchoiceBar(oDlg,{|| If(a085aEnch(@nOpc,aSE2,cNatureza,@aCtrChEQU,nValordens),oDlg:End(),)},{ || (nOpc := 0,F085DelAbt(SE2->E2_FILIAL+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM),oDlg:End())},,aButtons))

If lF4
   SetKey(VK_F4,)
Endif

If ExistBLock('F85TELAOP')
	ExecBlock('F85TELAOP',.F.,.F.,{nOpc})
Endif

Return (nOpc == 1)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A085aEnch �Autor  �Bruno Sobieski      � Data �  08.01.01   ���
�������������������������������������������������������������������������͹��
���Desc.     �Validacao da tela principal.                                ���
���          �Verifica a forma de pagamento dos titulos. Deve ser informada���
���			 �uma forma de pagamento diferenciada para cada um dos titulos,���
���			 �e ou um pagamento generico para um ou mais titulos que nao	���
���			 �estiverem na condicao de pago diferenciado.                 	���
��������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                    ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function a085aEnch(nOpc,aSE2,cNatureza,aCtrChEQU,nValOrdens)
Local lBcoOk := .T., lRet := .T.
Local lNegativo := .F.
Local aSoluEsp	:= {}
Local aSoluPor	:= {}
Local aSoluEng	:= {}
Local nTotalIVA	:= 0
Local nA 		:= 0
Local nB 		:= 0
Local nC 		:= 0
Local aHelpEsp:={}
Local aHelpPor:={}
Local aHelpEng:={}
Local nX:=1
Local cCalcITF   := SuperGetMv("MV_CALCITF",.F.,"2")
Local cQrySEF
Local lLckSEF	:= .F.
Local cTMPSEF
Local nXRec
Local nRecnoSEF
Local aArea   	:= {}
Local aSFP    	:= {}
Local lNumDoc 	:= .F.  
Local cNumIni 	:= ""
Local cNumFim 	:= ""
Local nPosIni 	:= 0
Local cCombo  	:= ""
Local cEspecie	:= "RET"
Local lTemImp	:= .F.
Local lFormPre 	:= .F.
Local cNumCert	:= ""
Local lNumDoc	:= .F.
Local cTimbrado := "" 
Local dDtValTim := Ctod("//") 

If Len(aCtrChEQU)==0
	For nX:=1 to nNumOrdens
		Aadd(aCtrChEQU,{0,""})
	Next
Else
	SEF->(MsUnlock())
	aCtrChEQU:={}
	For nX:=1 to nNumOrdens
		Aadd(aCtrChEQU,{0,""})
	Next
Endif
For nx:=1 to Len(aSE2)
	If  aSE2[nx][3]==NIL .Or. aSE2[nx][3][1]==4 .And. aSE2[nx][3][5] > 0
		If nX<= Len(aPagos) .And. aPagos[nX][1] == 1
         	lBcoOk:=.F.
        EndIf
    EndIf
Next

SA6->(DbSetOrder(1))
For nA := 1 To Len(aSE2)
	If (aPagos[nA][H_TOTALVL] < 0)
		lNegativo := .T.
		Exit
	EndIf
Next nA


//Caso nao tenha sido informado o banco e o exista retencao de IVA
//deve ser liberada a gravacao...
If lRet
	If !lBcoOk
	   //Caso o saldo da OP seja igual a zero(situacao: o total das PAs equivale ao total
	   //das NFs a pagar) nao deve validar se foi digitado o banco, ou seja, se o saldo
	   //para qq. fornecedor for maior a zero, deve validar o banco
	   lBcoOk := .T.
	   For nA := 1 to Len(aPagos)
	      If (aPagos[nA][H_TOTALVL] > 0)
	         lBcoOk  := .F.
	         Exit
	      EndIf
	   Next nA
	EndIf
	If  !lBcoOk .And. Empty(cBanco+cAgencia+cConta)
		Help("",1,"BCOBRANCO")
		lRet := .F.
	ElseIf !lBcoOk .And. !SA6->(DbSeek(xFilial()+cBanco+cAgencia+cConta))
		Help("",1,"BCONAOCAD")
		lRet := .F.
	ElseIf nNumOrdens < 1 // nao se selecionou nenhum fornecedor (titulos)
		Help("",1,"SEMORDPAG")
		lRet := .F.
	ElseIf lNegativo
		Help("",1,"NEGATIVO")
		lRet := .F.
	Else
		nOpc := 1
		If nCondAgr>1  //Verificar se todas as OP's possuem fornecedor
		   nG:=1
		   nN:=Len(aPagos)
		   While nG<=nN .and. nOpc==1
		         If aPagos[nG][H_OK]==1
	                If Empty(aPagos[nG][H_LOJA])
		               nOpc:=0
		            Endif
		         Endif
		         nG++
		   Enddo
		   If nOpc==0
		      MsgAlert(OemToAnsi(STR0141))  //"Existem pagamentos sem fornecedor. Selecione o fornecedor com F4."
		      lRet := .F.
		   Endif
		Endif
	Endif
Endif
If lRet .and. aSE2[1][3] == Nil
   lRet:=lRetCkPG(0,cDebInm,cBanco,nPagar)
Endif
If lRet .And. ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )
	cCodDiario := CTBAVerDia()
EndIf

If lRet .And. ExistBLock('A085TUDOK')
	lRet	:=	ExecBlock('A085TUDOK',.F.,.F.,aClone(aSE2))
Endif
If lRet .and. cPaisLoc$"PER|DOM|COS" .and. Empty(cNatureza) .and. AllTrim(cCalcITF) == "1"
   MsgAlert(STR0218)//"O campo Natureza � obrigat�rio!"
   lRet	:=	.F.
Endif

// Valida a numera��o de certificados de reten��o de IVA. O numero do certificado dever� pertencer a um intervalo
// cadastrado na tabela SFP(controle de formularios) e dever� ter data de vencimento v�lida
If lRet .And. cPaisloc == "PAR" 
	aArea   := GetArea()
	aSFP    := SFP->(GetArea())
	/*lNumDoc := .F.  
	cNumIni := ""
	cNumFim := ""
	nPosIni := 0
	cCombo  := ""
	cEspecie:= "RET"*/
		
	For nA := 1 to Len(aPagos)	  
    	If DesTrans(aPagos[nA][H_RETIVA]) > 0 .OR. DesTrans(aPagos[nA][H_RETIR]) > 0
      		lTemImp:= .T.
		EndIf 
	Next nA

	If lTemImp
		DbSelectArea("SX5")
		IF !MsSeek(xFilial("SX5")+"99"+"IVA",.F.)
			cNumCert := PadL( "1", TamSX3( "FE_NROCERT" )[1], "0" )
		Else
			cNumCert := StrZero( Val( X5DESCRI() ) + 1, TamSX3( "FE_NROCERT" )[1] )
		EndIf               
	//����������������������������������������������������������������������������������������������������Ŀ

		//� Busca posicao da descricao da especie da nota no combo da tabela SFP (1=NF;2=NCI;3=NDI;4=NCC;5=NDC)�
		//������������������������������������������������������������������������������������������������������
		
		SX3->(dbSetOrder(2))
		SX3->(dbSeek("FP_ESPECIE"))
		nPosIni := At(AllTrim(cEspecie),AllTrim(SX3->X3_CBOX))
		cCombo := Substr(AllTrim(SX3->X3_CBOX),nPosIni-2,1)
		
		DbSelectArea("SFP")
		DbSetOrder(6)
		If DbSeek(xFilial("SFP") + cFilAnt + cCombo)
		
			cNumIni := FP_NUMINI 
			cNumFim := FP_NUMFIM
			lFormPre:= If ((SFP->(FieldPos("FP_TIPOFOR")))>0,.T.,.F.)
		
			While FP_FILIAL+FP_FILUSO+FP_ESPECIE == xFilial("SFP")+cFilAnt+cCombo
				If Val(cNumCert) >= Val(FP_NUMINI) .And. Val(cNumCert) <= Val(FP_NUMFIM) .And. dDataBase <= FP_DTAVAL
					lNumDoc := .T.
					cTimbrado := SFP->FP_CAI 
					dDtValTim:= SFP->FP_DTAVAL 
					Exit
				EndIf
				SFP->(dbSkip())
			End    
			
			If !lNumDoc
				lRet := .F.
				MsgAlert(STR0220 + AllTrim(cNumCert) + ") " + STR0221,STR0223)
			EndIf                                
			
		Else
			lRet := .F.      
			MsgAlert(STR0222 ,STR0223)   
		EndIf
		RestArea(aSFP)
		RestArea(aArea)              
	EndIF		
EndIf

If lRet .And. (nPagar<=1 .And. cPaisLoc $ "DOM|EQU")
	cTMPSEF	:=	Alias()
	If Select("TMPSEF")>0
		TMPSEF->(DbCloseArea())
	Endif
	
	cQrySEF	:="SELECT EF_CART,EF_TALAO,EF_PREFIXO,EF_NUM,EF_STATUS,EF_LIBER,R_E_C_N_O_ "
	cQrySEF	+="FROM "+RETSQLNAME("SEF")+" WHERE EF_FILIAL='"+xFILIAL("SEF")+"' AND EF_CART='P' AND "
	cQrySEF	+="EF_BANCO='"+cBanco+"' AND EF_AGENCIA='"+cAgencia+"' AND EF_CONTA='"+cConta+"' AND EF_STATUS='00' AND EF_LIBER='S' "
	cQrySEF	+="AND D_E_L_E_T_ = '' ORDER BY EF_CART,EF_TALAO,EF_PREFIXO,EF_NUM "
	cQrySEF	:= ChangeQuery(cQrySEF)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQrySEF), "TMPSEF", .T., .T.)
	
	DbSelectArea("TMPSEF")
	TMPSEF->(DbGoTop())
	nXrec := 0
	While !TMPSEF->(EOF())
	   nRecnoSEF	:=	TMPSEF->R_E_C_N_O_
	   SEF->(DbGoTo(nRecnoSEF))
	   If !EMPTY(SEF->EF_TALAO) .and. !EMPTY(SEF->EF_NUM) .and. SEF->EF_STATUS=="00" .and. SEF->EF_LIBER=="S" .and. SEF->(DbRlock(nRecnoSEF))
   		If nXRec<=Len(aCtrChEQU)
   			aCtrChEQU[(nXRec+1)][1]:=nRecnoSEF
   			aCtrChEQU[(nXRec+1)][2]:=SEF->EF_NUM
				nXRec++
				If nXRec=Len(aCtrChEQU)
					lLckSEF := .T.
					Exit
	   		Endif
   		Endif
   	Endif
   	TMPSEF->(DbSkip())
   Enddo
   If !lLckSEF
   	If Len(aCtrChEQU)>1
   		MsgAlert(STR0225) //"N�o ha quantidade suficiente de cheques disponiveis para os pagamentos!"
   		SEF->(MsUnlock())
   	Else
	   	MsgAlert(STR0226)  //"N�o foi encontrado cheque disponivel para este pagamento!"
	   Endif
   	TMPSEF->(DbCloseArea())
   	lRet:=.F.
   Endif
   DbSelectArea(cTMPSEF)
Endif

If lRet .And. existBlock("F85ASDBCO")
	lRet:= ExecBlock("F85ASDBCO",.F.,.F.,{cBanco,cAgencia,cConta,nValOrdens})
EndIf

If cPaisLoc == "MEX" .And. cPaisProv <> "493"
	If SEK->(FieldPos("EK_DCONCEP")) > 0 .And. Empty(cDesc)
	   Help("",1,"EK_DCONCEP")
	   lRet := .F.
	Endif
EndIf
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A085aRefr �Autor  �Bruno Sobieski      � Data �  18.10.00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualiza os enable/disable dos objetos da tela              ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A085aRefr(nPagar, oCbx1, oCbx2,  oDataVenc,  oDataVenc1, oChkBox, oDataTxt1, oDataTxt2, oTipo, oMsg, oSaldo,  oTxt1, oBAnco, oAgencia, oConta,nValor,oValor,nRet,oRet,nLiquido,oLiquido,oMsg1,oValorPg,oMoedaPA,oRetIB,nRetIB,oRetIVA,nRetIva,oRetSUSS,nRetSUSS,oAliqigv,nAliqIGV,nNulo,lPagAdi)
Local lNulo
Default nNulo 	 := 0
Default lPagAdi := .F.

If lRetPA == Nil
	lRetPA := (GetNewPar("MV_RETPA","N") == "S")
EndIf

If nPagar == 0 .and. cPaisLoc $ "EQU|DOM|COS"
	oCbx1:Hide()
	oCbx2:Hide()
	oDataTxt2:Hide()
	oDataVenc:Hide()
	oChkBox:Hide()
	oTipo:Hide()
	oDataTxt1:Hide()
	oDataVenc1:Hide()
	If oMsg <> Nil
		oMsg:Hide()
		If oSaldo	<>	Nil
			oSaldo:Hide()
			oTxt1:Hide()
		Endif
		If oValorPg <>	Nil
			oValorPg :Hide()
		EndIf
		If oValPag <>	Nil
			oValPag  :Hide()
		Endif
		oMsg:Hide()
		oBanco:Enable()
		oAgencia:Enable()
		oConta:Enable()
	Endif
	If oMsg1  <>	Nil
		oMsg1:Hide()
	EndIf
	If oMoedaPA <> Nil
		oMoedaPA:Hide()
	Endif
	If oValor	<>	Nil
		oValor:Enable()
		oValor:Refresh()
		If lRetPA
			If oLiquido <> Nil
				oLiquido:Refresh()
			Endif
			If oRet <> Nil
				oRet:Refresh()
			Endif
			If oRetIB <> Nil
				oRetIB:Refresh()
			Endif
			If oRetIva <> Nil
				oRetIva:Refresh()
			Endif
		Endif
	Endif
Elseif nPagar == 1 .And. !lF085aChS
	oTipo:Hide()
	oCbx1:Hide()
	oCbx2:Hide()
	oDataTxt2:Hide()
	oDataVenc:Hide()
	oChkBox:Hide()
	oDataTxt1:Show()
	oDataVenc1:Show()
	oDataVenc1:Enable()
	If oMsg <> Nil
		oMsg:Hide()
		If oSaldo	<>	Nil
			oSaldo:Hide()
			oTxt1:Hide()
		Endif
		If oValorPg <>	Nil
			oValorPg :Hide()
		EndIf
		If oValPag <>	Nil
			oValPag  :Hide()
		Endif
		oMsg:Hide()
		oBanco:Enable()
		oAgencia:Enable()
		oConta:Enable()
	Endif

	If oMsg1  <>	Nil
		oMsg1:Hide()
	EndIf
	If oMoedaPA <> Nil
		oMoedaPA:Hide()
	Endif
	If oValor	<>	Nil
		oValor:Enable()
		oValor:Refresh()
		If lRetPA .Or. (cPaisLoc == "ARG" .And. !lRetPa .And. lImpVal)
			If cPaisLoc == "PER"
				oAliqigv:Refresh()
			EndIf
			If oLiquido <> Nil
				oLiquido:Refresh()
			Endif
			If oRet <> Nil
				oRet:Refresh()
			Endif
			If oRetIB <> Nil
				oRetIB:Refresh()
			Endif
			If oRetIva <> Nil
				oRetIva:Refresh()
			Endif
		Endif
	Endif
	If nNulo>0
  	   lNulo:=lRetCkPG(0,cDebInm,SA6->A6_COD,nPagar)
	Endif
ElseIf (nPagar == 2 .And. !lPagAdi) .Or. (lF085aChS .And. nPagar == 1)
	oTipo:Show()
	oCbx1:Show()
	oCbx1:Enable()
	oDataTxt2:Show()
	oDataVenc:Show()
	oDataVenc:Enable()
	If !(cPaisLoc $ "EQU|DOM")
		oChkBox:Show()
		oChkBox:Enable()
	Else
		oChkBox:Hide()
	Endif
	oCbx2:Hide()
	oDataTxt1:Hide()
	odataVenc1:Hide()
	If oMsg1  <>	Nil
		oMsg1:Hide()
	EndIf
	If oMoedaPA <> Nil
		oMoedaPA:Hide()
	Endif

	If oMsg <> Nil
		oMsg:Hide()
		If oSaldo	<>	Nil
			oSaldo:Hide()
			oTxt1:Hide()
		Endif
		If oValorPg <>	Nil
			oValorPg :Hide()
		EndIf
		If oValPag <>	Nil
			oValPag  :Hide()
		EndIf

		oBanco:Enable()
		oAgencia:Enable()
		oConta:Enable()
	Endif
	If oValor	<>	Nil
		oValor:Enable()
		oValor:Refresh()
		If lRetPA  .Or. (cPaisLoc == "ARG" .And. !lRetPa .And. lImpVal)
			If cPaisLoc <> "PER" .AND. !(cPaisLoc $ "DOM|COS") .And. oLiquido != Nil
				oLiquido:Refresh()
			ENDIF
			If oRet <> Nil
				oRet:Refresh()
			EndIF
		Endif
	Endif
	If nNulo>0
  	   lNulo:=lRetCkPG(0,cDebInm,SA6->A6_COD,nPagar)
	Endif
ElseIf (nPagar == 3 .And. !lPagAdi) .Or. (lF085aChs .And. nPagar == 2)
	oTipo:Show()
	oCbx2:Show()
	oCbx2:Enable()
	oCbx1:Hide()
	oDataTxt1:Hide()
	oDataVenc:Hide()
	oChkBox:Hide()
	oDataTxt2:Hide()
	oDataVenc1:Hide()
	If oMoedaPA <> Nil
		oMoedaPA:Hide()
	Endif
	If oMsg <> Nil
		oMsg:Hide()
		If oValorPg <>	Nil
			oValorPg:Hide()
		EndIf
		If oValPag <>	Nil
			oValPag  :Hide()
		EndIf
		If oSaldo	<>	Nil
			oSaldo:Hide()
			oTxt1:Hide()
		Endif
		oBanco:Enable()
		oAgencia:Enable()
		oConta:Enable()
	Endif
	If oMsg1  <>	Nil
		oMsg1:Hide()
	EndIf
	If oValor	<>	Nil
		oValor:Enable()
		oValor:Refresh()
		If lRetPA  .Or. (cPaisLoc == "ARG" .And. !lRetPa .And. lImpVal)
			If cPaisLoc <> "PER" .AND. !(cPaisLoc $ "DOM|COS") .And. oLiquido != Nil
				oLiquido:Refresh()
			ENDIF
			If oRet <> Nil
				oRet:Refresh()
			EndIf
		Endif
	Endif
	If nNulo>0
  	   lNulo:=lRetCkPG(0,cDebInm,SA6->A6_COD,nPagar)
	Endif
ElseIf nPagar == 4 .Or. (lF085aChs .And. nPagar == 3 .And. lPagAdi)
	oTipo:Hide()
	oCbx2:Hide()
	oCbx1:Hide()
	oDataTxt1:Hide()
	oDataVenc:Hide()
	oChkBox:Hide()
	oDataTxt2:Hide()
	oDataVenc1:Hide()
	If oValorPg <>	Nil  .and. !lRetPA
		oValorPg  :Hide()
	EndIf
	If oValorPg <>	Nil .and. lRetPA
		oValorPg :Show()
	EndIf
	If oMoedaPA <> Nil .and. lRetPA
		oMoedaPA:Show()
	Endif
	oBanco:Disable()
	oAgencia:Disable()
	oConta:Disable()
	If oSaldo	<>	Nil
		oSaldo:Show()
		oTxt1:Show()
	Endif
	If oMsg  <>	Nil .And. lRetPA
		oMsg:Show()
	EndIf
	If oMsg1  <>	Nil .And. lRetPA
		oMsg1:Show()
	EndIf
	If oValor	<>	Nil
		If cPaisLoc $ "ARG|ANG|PER|DOM|COS"
			If lRetPA .Or. (cPaisLoc == "ARG" .And. !lRetPa .And. lImpVal)
				oValor:Enable()
				oValor:Refresh()
				If oLiquido != Nil
					oLiquido:Refresh()
				EndIf
				If oRet <> Nil
					oRet:Refresh()
				EndIf
			Else
				nValor	:=	0
				oValor:Disable()
				oValor:Disable()
				oValor:Refresh()
			Endif
		Else
			If oLiquido <> Nil
				oLiquido:Refresh()
			EndIf
			If oRet <> Nil
				oRet:Refresh()
			EndIf
			If oValor <> Nil
				oValor:Enable()
				oValor:Refresh()
			EndIf

		Endif
	Endif
Endif
nNulo++
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA085Alt  �Autor  �Bruno Sobieski      � Data �  18.10.00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Altera os dados da Ordem de pago.                           ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function Fa085Alt(aTits,aGan,nPos,aSE2,oObj,aPagos,nValOrdens,oValOrdens,oLbx,nNumOrdens,oNumOrdens,aDesp)
Local nX,nA,nP,nC,nY,nZ
Local nRetIva	:= 0	,nRetGan	:=	0,nRetISI	:= 0,nTotNF	:=	0,nRetib	:=	0,nRetIric := 0,nRetIr := 0, nRetIRC	:=	0
Local nRetSUSS  := 0    ,nRetSLI    := 0 ,nRetIGV   := 0, nRetIR4 := 0, nRetAbt := 0
Local cFornece	:= ""
Local cLoja		:= ""
Local oDlg,oFntMoeda
Local lConfirmo	:=	.F.
Local oFolder,oRetGan,oRetISI,oRetIB,oRetIVA,oRetIric,oRetIr,oPagar,oRetSUSS,oRetSLI,oRetIRC,oRetRIE,oRetIGV,nPagar:=If(!(cPaisLoc $ "EQU|DOM|COS"),1,0)
Local aCpos
Local nJuros := 0,nDesc := 0, nMulta := 0
Local aSE2Tmp	:=	aClone(aSE2[nPos])
Local oGetDad1
Local nHdl
Local lModi := .F.
Local bZeraRets	:=	{|| A085AZeraRet(@nRetIva,@nRetGan,@nRetIB,@nRetIric,@nRetSUSS,@nRetSLI,oRetIVA,oRetGan,oRetIB,oRetIric,oRetSUSS,oRetSLI,@nRetIr,oRetIR,@nRetIrc,oRetIRC,oRetISI,@nRetIGV,oRetIGV,@nRetIR4)}
Local aDescontos	:=	{} 	//Variavel para guardar os descontos por item se o campo
 							//E2_DESCONT nao estiver em uso. O valor � necessario
 							//PAra calculo de retencoes. BRuno
Local nSalPos := 0, nPosVlr := 0
Local aRateioGan :=	{}
Local aCampos := {} // Retorno do PONTO DE ENTRADA (A085AOPHEAD)
Local nRetRIE := 0  //ANGOLA
Local nAbatimentos := 0.00
Local nAbtTotal := 0.00
Local cTipOp:=''
Local cPosNum := ""
Local cPosSer := ""
Local cPosFor := ""
Local cPosLoj := ""
Local nPosNro := 0
Local nPosSer := 0
Local nPosFor := 0
Local nPosLoj := 0
Local aAreaSEK := {}   
Local aAreaSFE := {}
Local lReten	:= .F.
Local nValor	:= 0
Local nValAcDia	:= 0
Local nValAcMes	:= 0
Local dDtPesq	:= Ctod("//")
Local nVlAcmPg	:= 0


//Estas vari�veis s�o STATIC para melhorar a performance, pois podem
//ser carregadas so uma vez por sessao
Static aGet
Static nPosJuros	:=	0,	nPofasDesc	:=	0, nPosSaldo	:=	0, nPosMulta := 0,nPosDesc :=0
Static nPosAPag := 0
Private	oValBrut,nValBrut:=0,nValDesc	:=	0,nPorDesc	:=	0,nTotNCC:=0
Private	oValLiq ,nValLiq :=0,oPorDesc ,oValDesc
Private lRetenc		:= .T.
Private	aCols		:= {}
Private aPagar		:= {}
Private bRecalc		:= {||}
Private nValDesp	:= 0

If cPaisLoc $ 'MEX|PER'
	cTipOp:= POSICIONE("SED",1,xFilial("SED")+SE2->E2_NATUREZ ,"ED_OPERADT")
	//Valida Modalidad de operaci�n 
	If cTipOp == '1'
		MSGALERT(STR0262, "") //"No se pueden modificar las �rdenes de Pago de tipo Anticipo."
		Return
	EndIf	
EndIf

//VER TRATAMENTO ANGOLA
If cPaisLoc $ "URU|BOL|PTG"
	bRecalc	:=	{ || 	aSE2Tmp	:=	a085aRecal(nPos,aSE2,nPosJuros,nPosDesc,@nRetIva,@oRetIva,@nRetIB,@oRetIB,;
				   		@nRetGan,@oRetGan,@nRetISI,@oRetISI,aDescontos,@nRetIric,@oRetIric,;
					   	@nRetSUSS,@oRetSUSS,@nRetSLI,@oRetSLI,@nValBrut,@oValBrut,,,,@nRetIr,@oRetIr,@nRetIrc,@oRetIrc,nValDesp)}
ElseIf cPaisLoc $ "ANG"
	bRecalc	:=	{ || 	aSE2Tmp	:=	a085aRecal(nPos,aSE2,nPosJuros,nPosDesc,@nRetIva,@oRetIva,@nRetIB,@oRetIB,;
				   		@nRetGan,@oRetGan,@nRetISI,@oRetISI,aDescontos,@nRetIric,@oRetIric,;
					   	@nRetSUSS,@oRetSUSS,@nRetSLI,@oRetSLI,@nValBrut,@oValBrut,,,,/*@nRetIr*/,/*@oRetIr*/,/*@nRetIrc*/,/*@oRetIrc*/,/*nValDesp*/,nRetRIE,oRetRIE)}
ElseIf cPaisLoc $ "PAR"
	bRecalc	:=	{ || 	aSE2Tmp	:=	a085aRecal(nPos,aSE2,nPosJuros,nPosDesc,@nRetIva,@oRetIva,@nRetIB,@oRetIB,;
				   		@nRetGan,@oRetGan,@nRetISI,@oRetISI,aDescontos,@nRetIric,@oRetIric,;
					   	@nRetSUSS,@oRetSUSS,@nRetSLI,@oRetSLI,@nValBrut,@oValBrut,,,,;
					   	@nRetIr,@oRetIr,/*@nRetIrc*/,/*@oRetIrc*/,/*nValDesp*/,nRetRIE,oRetRIE,@nRetIGV,oRetIGV,@nRetIR4)}

ElseIf cPaisLoc $ "PER|EQU|DOM|COS"
	bRecalc	:=	{ || 	aSE2Tmp	:=	a085aRecal(nPos,aSE2,nPosJuros,nPosDesc,@nRetIva,@oRetIva,@nRetIB,@oRetIB,;
				   		@nRetGan,@oRetGan,@nRetISI,@oRetISI,aDescontos,@nRetIric,@oRetIric,;
					   	@nRetSUSS,@oRetSUSS,@nRetSLI,@oRetSLI,@nValBrut,@oValBrut,,,,;
					   	/*@nRetIr*/,/*@oRetIr*/,/*@nRetIrc*/,/*@oRetIrc*/,/*nValDesp*/,nRetRIE,oRetRIE,@nRetIGV,oRetIGV,@nRetIR4)}

Endif
//��������������������������������������������Ŀ
//�Inicializar o aHeader e o aCols do folder 1.�
//����������������������������������������������

For nA:= 1 To Len(aTits)
	nX := ASCAN(aModAux,{|x|  x[1] == aTits[nA][1]+ aTits[nA][2] +aTits[nA][9] + aTits[nA][10] + aTits[nA][11] + aTits[nA][12] })
	If nX = 0   
		Aadd(aModAux,{aTits[nA][1]+ aTits[nA][2] +aTits[nA][9] + aTits[nA][10] + aTits[nA][11] + aTits[nA][12],{0,aTits[nA][17]},{0,aTits[nA][22]}})	
		nX := LEN(aModAux)
	Endif
	aTits[nA][17] :=   aModAux[nX][2][1]
	aTits[nA][22] :=   aModAux[nX][3][1]	
Next nA

//Se o aHeader nao foi definido ainda, defino ele aqui SO UMA VEZ POR SESSAO. Bruno
If aHeader1	==	Nil
	aHeader1 :=	{}
	aGet		:=	{}
	DbSelectArea("SX3")
	//Se o usuario tem acesso ao campo e esta em uso incluir o campo em primeiro lugar
	//para permitir mudar o valor por pagar. Bruno
	DbSetOrder(2)
	DbSeek("E2_PAGAR")
	If Found() .And. X3Uso(x3_usado)  .And. cNivel >= X3_NIVEL
		AADD(aHeader1,{ TRIM(X3TITULO()), X3_CAMPO, X3_PICTURE,;
		X3_TAMANHO, X3_DECIMAL, "Fa085aVldP()",;
		X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT } )

		Aadd(aGet,X3_CAMPO)

		AADD(aHeader1,{ OemToAnsi(STR0174) , "NVLMDINF", X3_PICTURE,;
		X3_TAMANHO, X3_DECIMAL, "Fa085VlM()",;
		X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT } )

		Aadd(aGet,"NVLMDINF")
	Endif
	//��������������������������������Ŀ
	//�Ponto de entrada para customizar�
	//�as colunas na opcao Modificar OP�
	//����������������������������������
	If ExistBlock("F085HEAD")
		aCampos	:=	ExecBLock("F085HEAD",.F.,.F.)
	Endif
	//Carregar os demais campos no aHeader
	DbSetOrder(1)
	DbSeek("SE2")
	While !EOF() .And. X3_ARQUIVO == "SE2"     
		If (X3Uso(x3_usado).And. cNivel >= X3_NIVEL .And. alltrim(x3_campo) <> "E2_PAGAR" .And. (cPaisLoc == 'ARG' .Or. AllTrim(X3_CAMPO) != "E2_CODAPRO"));
		 	.Or. Trim(X3_CAMPO) == "E2_MULTA" .Or. Trim(X3_CAMPO) == "E2_JUROS" .Or. Trim(X3_CAMPO) == "E2_DESCONT" .or. Trim(X3_CAMPO) == "E2_VLBXPAR" .Or. !Empty(AScan( aCampos, { |x| x == AllTrim(SX3->X3_CAMPO) } ))
			aAdd(aHeader1,{ TRIM(X3TITULO()), X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL, X3_VALID,X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT })
			If Trim(X3_CAMPO)=="E2_JUROS"
				nPosJuros	:=	Len(aHeader1)
				Aadd(aGet,X3_CAMPO)
			ElseIf Trim(X3_CAMPO) == "E2_MULTA"
				nPosMulta := Len(aHeader1)
				Aadd(aGet,X3_CAMPO)
			ElseIf Trim(X3_CAMPO)=="E2_DESCONT"
				nPosDesc	:=	Len(aHeader1)
				If cPaisLoc  != "URU"
					aAdd(aGet,X3_CAMPO)
				EndIf
			ElseIf AllTrim(X3_CAMPO)=="E2_SALDO"
				nPosSaldo	:= Len(aHeader1)
			Endif
		EndIf
		DbSkip()
	Enddo
	If cPaisLoc == 'MEX'
		DbSetOrder(2)
		If SX3->(MsSeek("F1_UUID")) .And. X3Uso(x3_usado)  .And. cNivel >= X3_NIVEL
			aAdd(aHeader1,{ TRIM(X3TITULO()), X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL, X3_VALID,X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT })
		EndIf
	EndIf
EndIf

nPosAPag := Ascan(aHeader1,{ |x| Alltrim(x[2])=="E2_PAGAR"  })
nPosJuros:= Ascan(aHeader1,{ |x| Alltrim(x[2])=="E2_JUROS"  })
nPosMulta:= Ascan(aHeader1,{ |x| Alltrim(x[2])=="E2_MULTA"  })
nPosDesc := Ascan(aHeader1,{ |x| Alltrim(x[2])=="E2_DESCONT"})
nPosSaldo:= Ascan(aHeader1,{ |x| Alltrim(x[2])=="E2_SALDO"  })

SF1->(DbSelectArea("SF1"))
SF1->(DbSetOrder(1))//F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
DbSelectArea("SE2")
For nA:= 1 To Len(aTits)
	MsGoto(aTits[nA][_RECNO])
	AAdd(aCols,ARRAY(Len(AHeader1)+1))
	AAdd(aDescontos,0)
	nLenACol	:=	Len(aCols)
	nSalPos	:=	IIf(nSalPos==0,Ascan(aHeader1,{|x| Alltrim(x[2])=="E2_SALDO"}),nSalPos)
	nPosVlr :=	IIf(nPosVlr==0,Ascan(aHeader1,{|x| Alltrim(x[2])=="E2_VALOR"}),nSalPos)
	aCols[nLenACol][Len(aCols[nLenACol])]	:=	.F.

	If aTits[nA][_SALDO] <> aTits[nA][_PAGAR]
		aAdd(aPagar,( aTits[nA][_SALDO] + aTits[nA][_DESCONT]) - (aTits[nA][_JUROS]+aTits[nA][_MULTA]))
	Else
		aAdd(aPagar,( aTits[nA][_PAGAR]+aTits[nA][_DESCONT]) - (aTits[nA][_JUROS]+aTits[nA][_MULTA]))
	EndIf

	If 	cPaisLoc == "EQU"
		nRetAbt := 0
      	cfA85NUm := aTits[nA][_NUM]
		For nP	:=	1 To Len(aTits)
			If aTits[nP][_TIPO] == "NF " .and. aTits[nP][_NUM] == cfA85Num
            	nRetAbt += SomaAbat(aTits[nP][_PREFIXO],aTits[nP][_NUM],aTits[nP][_PARCELA],"P",aTits[nP][_MOEDA],,aTits[nP][_FORNECE])
            	nAbtTotal += nRetAbt
			EndIf
        Next nP
		aTits[nA][_PAGAR] := aTits[nA][_SALDO] - nRetAbt - aTits[nA][_DESCONT] + (aTits[nA][_JUROS]+aTits[nA][_MULTA])
	EndIf

	If cPaisLoc  $ "URU|COL|PER|MEX"
		aCols[nLenACol][1] := aTits[nA][_PAGAR]-aTits[nA][_DESCONT ]
	Else	
		aCols[nLenACol][1] := aTits[nA][_PAGAR]
	EndIF

	For nX	:=	2	To Len(aHeader1)
		If aHeader1[nX][10] <> "V"
 			If nX == nSalPos
 				If cPaisLoc  == "URU"
			   		aCols[nLenACol][nX]	:=	aTits[nA][_JUROS]
 				Else
			   		aCols[nLenACol][nX]	:=	aTits[nA][_SALDO] - aTits[nA][_PAGAR]
			   	EndIf			   
			ElseIf aHeader1[nX][2]== "NVLMDINF"
					If cPaisLoc == "PAR"
						aCols[nLenACol][nX]:= aTits[nA][_SALDO1]
					Else
						aCols[nLenACol][nX]:= Round(xMoeda(aTits[nA][_PAGAR ],aTits[nA][_MOEDA],nMoedaCor,,5,aTxmoedas[aTits[nA][_MOEDA]][2],aTxmoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
					EndIf	
			Else
				If cPaisLoc == 'MEX' .AND. Alltrim(aHeader1[nX][2]) == "F1_UUID"	
					nPosNro := Ascan(aHeader1,{|x| Alltrim(x[2])=="E2_NUM"})
					nPosSer := Ascan(aHeader1,{|x| Alltrim(x[2])=="E2_PREFIXO"})
					nPosFor := Ascan(aHeader1,{|x| Alltrim(x[2])=="E2_FORNECE"})	
					nPosLoj := Ascan(aHeader1,{|x| Alltrim(x[2])=="E2_LOJA"})	
					
					cPosNum := IIF(nPosNro > 0, aCols[nLenACol][nPosNro],"" )
					cPosSer := IIF(nPosSer > 0, aCols[nLenACol][nPosSer],"")  
					cPosFor := IIF(nPosFor > 0, aCols[nLenACol][nPosFor],"")  
					cPosLoj := IIF(nPosLoj > 0, aCols[nLenACol][nPosLoj],"")    
					If SF1->(MsSeek(xFilial("SF1")+cPosNum+cPosSer+cPosFor))
						aCols[nLenACol][nX]:= SF1->F1_UUID
					EndIf
				Else				
					aCols[nLenACol][nX]:=	&(aHeader1[nX][2])
				EndIf
			EndIf
	    Else
	        aCols[nLenACol][nX]:= CriaVar(aHeader1[nX][2],.T.)
	    Endif
	Next nX

	aDescontos[nLenACol]:=	aTits[nA][_DESCONT]
	If nPosDesc  > 0
		aCols[nLenACol][nPosDesc]	:=	aTits[nA][_DESCONT]
	Endif
	If nPosJuros > 0
		aCols[nLenACol][nPosJuros]	:=	aTits[nA][_JUROS]
	Endif
	If nPosMulta > 0
		aCols[nLenACol][nPosMulta]	:=	aTits[nA][_MULTA]
	EndIf
	//Calcular os Totais
	If aTits[nA][_TIPO] $ MVPAGANT + "/" + MV_CPNEG
		nTotNcc	+=	Round(xMoeda(aTits[nA][_PAGAR],aTits[nA][_MOEDA],nMoedaCor,,5,aTxmoedas[aTits[nA][_MOEDA]][2],aTxmoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
	Else
		If cPaisLoc == "EQU"
	    	nValBrut += Round(xMoeda(aTits[nA][_SALDO],aTits[nA][_MOEDA],nMoedaCor,,5,aTxmoedas[aTits[nA][_MOEDA]][2],aTxmoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			nValDesc += Round(xMoeda(aTits[nA][_DESCONT],aTits[nA][_MOEDA],nMoedaCor,,5,aTxmoedas[aTits[nA][_MOEDA]][2],aTxmoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
		    If nValDesc > 0
				nValLiq  += Round(xMoeda(aTits[nA][_PAGAR]+aTits[nA][_DESCONT]-nRetAbt,aTits[nA][_MOEDA],nMoedaCor,,5,aTxmoedas[aTits[nA][_MOEDA]][2],aTxmoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
            Else
 				nValLiq  += Round(xMoeda(aTits[nA][_SALDO]+aTits[nA][_DESCONT]-nRetAbt,aTits[nA][_MOEDA],nMoedaCor,,5,aTxmoedas[aTits[nA][_MOEDA]][2],aTxmoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
            EndIf
		Else
			If cPaisLoc $ "COL|PER|MEX"
	 	   		nValBrut += Round(xMoeda(aTits[nA][_VALOR],aTits[nA][_MOEDA],nMoedaCor,,5,aTxmoedas[aTits[nA][_MOEDA]][2],aTxmoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Else
	    		nValBrut += Round(xMoeda(aTits[nA][_PAGAR ],aTits[nA][_MOEDA],nMoedaCor,,5,aTxmoedas[aTits[nA][_MOEDA]][2],aTxmoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			EndIf
			nValLiq  += Round(xMoeda(aTits[nA][_PAGAR ],aTits[nA][_MOEDA],nMoedaCor,,5,aTxmoedas[aTits[nA][_MOEDA]][2],aTxmoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			nValDesc += Round(xMoeda(aTits[nA][_DESCONT],aTits[nA][_MOEDA],nMoedaCor,,5,aTxmoedas[aTits[nA][_MOEDA]][2],aTxmoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
		EndIf
	EndIf
	//Carregar retencoes para informar no cabecalho...
	If cPaisLoc	==	"ARG"
		For nP	:=	1	To	Len(aTits[nA][_RETIB])
			nRetib	+=	Round(xMoeda(aTits[nA][_RETIB ][nP][5],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
		Next
		For nP	:=	1	To	Len(aTits[nA][_RETIVA])
			nRetiva	+=	Round(xMoeda(aTits[nA][_RETIVA][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
		Next
		For nP	:=	1	To	Len(aTits[nA][_RETSUSS])
			nRetSUSS+=	Round(xMoeda(aTits[nA][_RETSUSS][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
		Next
		For nP	:=	1	To	Len(aTits[nA][_RETSLI])
			nRetSLI +=	Round(xMoeda(aTits[nA][_RETSLI][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
		Next
		For nP	:=	1	To	Len(aTits[nA][_RETISI])
			nRetISI +=	Round(xMoeda(aTits[nA][_RETISI][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
		Next
	ElseIf cPaisLoc $ "URU|BOL"
		For nP	:=	1	To	Len(aTits[nA][_RETIRIC])
			nRetIric	+=	Round(xMoeda(aTits[nA][_RETIRIC][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
		Next
		For nP	:=	1	To	Len(aTits[nA][_RETIR])
			nRetIr		+=	Round(xMoeda(aTits[nA][_RETIR][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
		Next

	//Carregar retencoes para informar no cabecalho...
	ElseIf cPaisLoc	==	"PTG"
		For nP	:=	1	To	Len(aTits[nA][_RETIRC])
			nRetIrc	+=	Round(xMoeda(aTits[nA][_RETIRC ][nP][5],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
		Next
		For nP	:=	1	To	Len(aTits[nA][_RETIVA])
			nRetiva	+=	Round(xMoeda(aTits[nA][_RETIVA][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
		Next
	//ANGOLA
	//Carregar retencoes para informar no cabecalho...
	ElseIf cPaisLoc	==	"ANG"
		For nP	:=	1	To	Len(aTits[nA][_RETRIE])
			nRetRie	+=	Round(xMoeda(aTits[nA][_RETRIE][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
		Next
	ElseIf cPaisLoc	==	"PER"
		For nP	:=	1	To	Len(aTits[nA][_RETIGV])
			nRetIGV	+=	Round(xMoeda(aTits[nA][_RETIGV][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
		Next
		/* retencao de IR */
		For nP	:=	1	To	Len(aTits[nA][_RETIR])
			nRetIR4	+=	Round(xMoeda(aTits[nA][_RETIR][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
		Next
	ElseIf cPaisLoc == "PAR"
		For nP	:=	1	To	Len(aTits[nA][_RETIVA])
			nRetiva	+=	Round(xMoeda(aTits[nA][_RETIVA][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
		Next 
	
		For nP	:=	1	To	Len(aTits[nA][_RETIR])
			nRetIr		+=	Round(xMoeda(aTits[nA][_RETIR][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
		Next	

	Endif
Next nA

If cPaisLoc == "PTG"
	For nP	:=	1	To	Len(aDesp)
		nValDesp	+=	Round(xMoeda(aDesp[nP][2],Val(aDesp[nP][3]),nMoedaCor,,5,aTxMoedas[Val(aDesp[nP][3])][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
	Next
Endif

//����������������������������������������������Ŀ
//�Soma no nValBrut o valor dos PAs se houverem  �
//������������������������������������������������
If aSE2TMP[3] <> Nil
	If aSE2TMP[3][1] ==4 .And. aSE2TMP[3][6] > 0
		aSE2TMP[3][6]	:=	0
		aSE2TMP[3][7]	:=	1
	Endif
Endif

If cPaisLoc == "EQU"
	nValLiq	:= (nValBrut - nAbtTotal - nTotNcc)- nValDesc + nValDesp
ElseIf cPaisLoc $ "COL|PER|MEX"
	nValLiq	+= - nTotNcc - (nValDesc + nRetGan + nRetIb + nRetIVA + nRetIric + nRetSUSS + nRetSLI + nRetIr + nRetIRC + nRetIGV + nRetIR4) + nValDesp
Else
	nValLiq	:= (nValBrut - nTotNcc)-(nValDesc+nRetGan+nRetIb+nRetIVA+nRetIric+nRetSUSS+nRetSLI+nRetIr+nRetIRC+nRetIGV+nRetIR4) + nValDesp
EndIf
nPorDesc	:=	aPagos[nPos][H_PORDESC]

SA2->(DbSetOrder(1))
SA2->(MsSeek(xFilial("SA2")+aPagos[nPos][H_FORNECE]+aPagos[nPos][H_LOJA]))
If !RateioCond(@aRateioGan)
	aSE2	:=	{}
	Return .F.
Endif
//Inicilaizo o aHeader
Private aHeader	:=	aClone(aHeader1)

//Inicializo as vari�veis de mem�ria para evitar erro na valida��o do X3_RELAC do campo E2_CODAPRO
RegToMemory("SE2",.F.)

DEFINE MSDIALOG oDlg FROM 30,52  TO IIf(cPaisLoc=="ARG".Or. cPaisLoc $ "URU|BOL|PTG",450,380),633 TITLE OemToAnsi(STR0063+aPagos[nPos][H_NOME] ) Of oObj PIXEL  // "Orden de pago del proveedor "

//Titulos por pagar
@ 47,004 To 73,290 Pixel Of  oDlg LABEL OemToAnsi(STR0094) //"Totales"

@ 55,006 SAY OemToAnsi(STR0095)  	Size 90,08 Pixel Of oDlg //"Valor dos titulos : "
@ 55,075 SAY oValBrut Var nValBrut  Size 80,08 Pixel Of oDlg Picture Tm(nValBrut,19,nDecs)  COLOR CLR_BLUE

@ 63,006 SAY OemToAnsi(STR0096)  	Size 90,08 Pixel Of oDlg //"Valor dos titulos : "
@ 63,075 SAY oValLiq  Var nValLiq   Size 80,08 Pixel Of oDlg Picture Tm(nValLiq,19,nDecs)  COLOR CLR_BLUE

If cPaisLoc $ "URU|BOL"
	@ 177,004 To 195,290 Pixel Of oDlg LABEL OemToAnsi(STR0098) //"Retenciones"
	@ 185,006 SAY OemToAnsi(STR0149)  		Size 40,08 Pixel Of  oDlg
	@ 185,050 SAY oRetIric VAR nRetIric Size 60,08 PIXEL OF oDlg Picture Tm(nRetIric,19,nDecs)  COLOR CLR_BLUE

	@ 185,110 SAY OemToAnsi("IR : ") Size 40,08 Pixel Of  oDlg
	@ 185,154 SAY oRetIr Var nRetIr  Size 60,08 Pixel Of  oDlg Picture Tm(nRetIr,19,nDecs)  COLOR CLR_BLUE
ElseIf cPaisLoc  == "PTG"
	@ 157,004 To 175,290 Pixel Of oDlg LABEL OemToAnsi(STR0181) //"Retencoes e despesas"
	@ 165,006 SAY OemToAnsi("IVA :")  		Size 30,08 Pixel Of  oDlg
	@ 165,040 SAY oRetIva VAR nRetIva Size 60,08 PIXEL OF oDlg Picture Tm(nRetIva,19,nDecs)  COLOR CLR_BLUE

	@ 165,110 SAY OemToAnsi("IRC : ") Size 30,08 Pixel Of  oDlg
	@ 165,144 SAY oRetIrc Var nRetIrc  Size 60,08 Pixel Of  oDlg Picture Tm(nRetIrc,19,nDecs)  COLOR CLR_BLUE

	@ 165,214 SAY OemToAnsi(STR0180+" :")  Size 30,08 Pixel Of  oDlg //"Despesas"
	@ 165,248 SAY nValDesp  Size 60,08 Pixel Of  oDlg Picture Tm(nValDesp,19,nDecs)  COLOR CLR_BLUE
ElseIf cPaisLoc  == "ANG"
	@ 157,004 To 175,290 Pixel Of oDlg LABEL OemToAnsi(STR0181) //"Retencoes e despesas"
	@ 165,006 SAY OemToAnsi("RIE : ")  		Size 30,08 Pixel Of  oDlg
	@ 165,040 SAY oRetRIE VAR nRetRIE Size 60,08 PIXEL OF oDlg Picture Tm(nRetRIE,19,nDecs)  COLOR CLR_BLUE
ElseIf cPaisLoc  == "PAR"
	@ 137,004 To 165,290 Pixel Of oDlg LABEL OemToAnsi(STR0181) //"Retencoes e despesas"
	@ 145,006 SAY OemToAnsi("IVA :")  		Size 30,08 Pixel Of  oDlg
	@ 145,040 SAY oRetIva VAR nRetIva Size 60,08 PIXEL OF oDlg Picture Tm(nRetIva,19,nDecs)  COLOR CLR_BLUE  
	@ 145,110 SAY OemToAnsi("IR : ") Size 40,08 Pixel Of  oDlg
	@ 145,154 SAY oRetIr Var nRetIr  Size 60,08 Pixel Of  oDlg Picture Tm(nRetIr,19,nDecs)  COLOR CLR_BLUE
Endif

If cPaisLoc=="PAR"
	oGetDad1	:= MsGetDados():New(45,04,130,290,3,"AllwaysTrue()","A085aTudok(1,,,,,,,.T.)",,.F.,aGet,,,Len(aCols),"A085FldOk1(bRecalc)",,,,oDlg)
Else
	oGetDad1	:= MsGetDados():New(75,04,175,290,3,"AllwaysTrue()","A085aTudok(1)",,.F.,aGet,,,Len(aCols),"A085FldOk1(bRecalc)",,,,oDlg)
EndIf

///Estes gets foram definidos aqui para nao aparecer "Focused" quando abrir a tela,
//pois gera problemas quando % desc == 0 e Desconto > 0... Bruno
@ 30,130 SAY OemtoAnsi(STR0127)  Size 40,08 Pixel Of oDlg  //"% Desc."
If cPaisLoc  == "URU"
	@ 48,130 MSGET oPorDesc Var nPorDesc  Size 30,08 Pixel Of oDlg Picture "@E 99.99" Valid a085aVldDe(1,oPorDesc,nPorDesc,oValDesc,@nValDesc,nValBrut,nValLiq,oValLiq,@aDescontos,bZeraRets,@oGetDad1,bRecalc,(nValDesp-nRetIva-nRetIRC))
	@ 40,170 SAY OemtoAnsi(STR0128)  Size 50,08 Pixel Of oDlg  //"Valor Descuento"
	@ 48,170 MSGET oValDesc Var nValDesc   Size 55,08 Pixel Of oDlg Picture Tm(nValDesc,19,nDecs) Valid a085aVldDe(2,oPorDesc,@nPorDesc,oValDesc,nValDesc,nValBrut,nValLiq,oValLiq,@aDescontos,bZeraRets,@oGetDad1,bRecalc,(nValDesp-nRetIva-nRetIRC))
ElseIf cPaisLoc $ "COL|PER|MEX"
	nPrDscAux := nPorDesc
	nVlDscAux := nValDesc
	@ 38,130 MSGET oPorDesc Var nPorDesc  Size 30,08 Pixel Of oDlg Picture "@E 99.99" Valid IIf(nPrDscAux <> nPorDesc .Or. nVlDscAux <> nValDesc, a085VldDsc(1,oPorDesc,nPorDesc,oValDesc,@nValDesc,nValBrut,@nValLiq,oValLiq,@aDescontos,bZeraRets,@oGetDad1,bRecalc,(nValDesp-nRetIva-nRetIRC)),)
	@ 30,170 SAY OemtoAnsi(STR0128)  Size 50,08 Pixel Of oDlg  //"Valor Descuento"
	@ 38,170 MSGET oValDesc Var nValDesc   Size 55,08 Pixel Of oDlg Picture Tm(nValDesc,19,nDecs) Valid IIf(nPrDscAux <> nPorDesc .Or. nVlDscAux <> nValDesc, a085VldDsc(2,oPorDesc,@nPorDesc,oValDesc,nValDesc,nValBrut,@nValLiq,oValLiq,@aDescontos,bZeraRets,@oGetDad1,bRecalc,(nValDesp-nRetIva-nRetIRC)),)
Else
	@ 28,130 MSGET oPorDesc Var nPorDesc  Size 30,08 Pixel Of oDlg Picture "@E 99.99" Valid a085aVldDe(1,oPorDesc,nPorDesc,oValDesc,@nValDesc,nValBrut,@nValLiq,oValLiq,@aDescontos,bZeraRets,@oGetDad1,bRecalc,(nValDesp-nRetIva-nRetIRC))
	@ 20,170 SAY OemtoAnsi(STR0128)  Size 50,08 Pixel Of oDlg  //"Valor Descuento"
	@ 28,170 MSGET oValDesc Var nValDesc   Size 55,08 Pixel Of oDlg Picture Tm(nValDesc,19,nDecs) Valid a085aVldDe(2,oPorDesc,@nPorDesc,oValDesc,nValDesc,nValBrut,@nValLiq,oValLiq,@aDescontos,bZeraRets,@oGetDad1,bRecalc,(nValDesp-nRetIva-nRetIRC))
EndIf
If !(cPaisLoc $ "ARG|URU|BOL|PTG")
	@ 32,227 To 49,285 Label OemtoAnsi(STR0143) Of oDlg Pixel
	DEFINE FONT oFntMoeda  NAME "Arial" SIZE 08,11 BOLD
	@ 40,230 SAY cMoeda Size 40,08 Pixel Of ODlg FONT oFntMoeda COLOR CLR_HBLUE
EndIf

ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{||(lConfirmo	:=	oGetDad1:TudoOk(),If(lConfirmo,oDlg:End(),lConfirmo	:=	.F.))},{||(lConfirmo	:=	.F.,oDlg:End() )}) )
//Atualizar o array aSE2 com os valores escolhidos aqui e logo o aPagos...

nContDesc := 1

If lConfirmo
	If cPaisLoc == "ARG" .Or. cPaisLoc $ "URU|BOL|PTG|ANG|PER|PAR"   //ANGOLA/PERU
	
		aSE2[nPos]	:=	aClone(aSE2Tmp)
		
	Endif
	If Empty(aTits) .Or. (cPaisLoc $ "PER" .And. Type("aTits") <> "A")
		aTits:=aSE2[oLBx:nAt][1]	
	Endif  
	
	If cPaisLoc == "PAR" .and. Len(aSe2) >0 .And.  Len(aSE2[nPos][1]) > 0
		nValAcDia:=0 
		nValAcMes:=0
	//Acumulado Diario
		SFE->(DbSetOrder(3))
		dDtPesq :=firstdate(ddatabase)    
		dDataFim:=LastDate(ddatabase)   
		dDataAtu:=dDatabase
		nVlAcmPg:=0
		SFE->(DbGotop())
		lAchou:=.F.
		SFE->(dbSeek(xFilial("SFE")+cFornece+cLoja))
    
    	While !lAchou .AND.  dDtPesq<=dDataFim
    		If SFE->(dbSeek(xFilial("SFE")+cFornece+cLoja+dtos(dDtPesq)))       
    	   		lAchou:=.T.
    		EndIf
    		dDtPesq:=dDtPesq+1
    	Enddo      
      
		If lAchou  
	
			While lAchou .And. SFE->(!Eof()) .and.  (xFilial("SFE")+cFornece+cLoja==SFE->FE_FILIAL+SFE->FE_FORNECE+SFE->FE_LOJA)     .AND.  SFE->FE_EMISSAO<=dDataFim
				If SFE->FE_TIPO=="I"
					If SFE->FE_EMISSAO==dDatabase
			 			nValAcDia:=nValAcDia+SFE->FE_VALBASE 
						nValAcMes:=nValAcMes+SFE->FE_VALBASE 	 
					Else
			   	 		nValAcMes:=nValAcMes+SFE->FE_VALBASE 
			     	EndIf
		     	EndIf
		     	SFE->(DbSkip())
		 	EndDo    
		EndIf
		For nX := 1 to Len(aSe2)
			For nZ := 1 To Len(aSe2[nX,1])		
				If Len(aSe2[nX,1,nZ,_RETIVA]) > 0
					For nA := 1 To Len(aSe2[nX,1,nZ,_RETIVA])              
							If aSe2[nX,1,nZ,_RETIVA,nA,4] >0              
								nValor:=0
								nValor:=Round( (aSe2[nX,1,nZ,_RETIVA,nA,3] ),msdecimais(aSe2[nX][1][nZ][4] ))
								nVlAcmPg:= nVlAcmPg +  nValor
							EndIf	
					Next nA
				EndIf
			Next nZ
		Next nX
		lReten:=.F.                                                                                                                                                                                                 
		If  nVlAcmPg >=GetNewPar("MV_VLRIVAT",0) .or. ( (nValAcDia+nVlAcmPg)>=GetNewPar("MV_VLRIVAD",0)) .OR. ( ( nValAcMes+nVlAcmPg)>=GetNewPar("MV_VLRIVAM",0)) 
			lReten:=.T.
		EndIf             

		If  Len(aSe2) >0 .And. !lReten .and.    Len(aSE2[nPos][1]) > 0
			For nX := 1 to Len(aSe2)
				For nZ := 1 To Len(aSe2[nX,1])		
					If Len(aSe2[nX,1,nZ,_RETIVA]) > 0
						For nA := 1 To Len(aSe2[nX,1,nZ,_RETIVA])
							aSe2[nX,1,nZ,_RETIVA,nA,4]:= 0
							aSe2[nX,1,nZ,_RETIVA,nA,6]:= 0
						Next nA
					EndIf
				Next nZ
			Next nX
		EndIf
	EndIf

	nDesc := 0
	For nA:=1	To	Len(aSE2[nPos][1])
		If (aSE2[nPos][1][nA][_TIPO   ] $ MVPAGANT + "/"+ MV_CPNEG)
			nDesc	:= 0
			aSE2[nPos][1][nA][_PAGAR  ]	:=	aCols[nA][nPosAPag]
		Else
			If nPosDesc	> 0
				nDesc	:=	aCols[nA][nPosDesc ]
			Else
				nDesc	:=	(aCols[nA][1] * nPorDesc /100)
			EndIf
			
						
			nX := ASCAN(aModAux,{|x|  x[1] == aTits[nA][1]+ aTits[nA][2] +aTits[nA][9] + aTits[nA][10] + aTits[nA][11] + aTits[nA][12] })
			aSE2[nPos][1][nA][_PAGAR  ]	:=	aCols[nA][nPosAPag]  + nRetAbt + nDesc
			aSE2[nPos][1][nA][_JUROS  ]	:=	IIf(nPosJuros > 0, aCols[nA][nPosJuros],0)
			aSE2[nPos][1][nA][_MULTA  ]	:=	IIf(nPosMulta > 0, aCols[nA][nPosMulta],0)
			If nX>0                                            
				If cPaisLoc  == "URU"
					aModAux[nX][2][1]:= aCols[nPos][nPosJuros]
				Else                                           
					aModAux[nX][2][1]:= aSE2[nPos][1][nA][_JUROS  ]
				EndIf 
				aSE2[nPos][1][nA][_JUROS  ] +=	aModAux[nX][2][2]
				aModAux[nX][3][1]:= aSE2[nPos][1][nA][_MULTA  ]
    			aSE2[nPos][1][nA][_MULTA  ] +=	aModAux[nX][3][2]
    		Endif 			
			aSE2[nPos][1][nA][_DESCONT]	:=	nDesc
			nMulta += aSE2[nPos][1][nA][_MULTA  ]
			nJuros += aSE2[nPos][1][nA][_JUROS  ]
		EndIf
	Next

	nValOrdens	-=	aPagos[nPos][H_TOTALVL]

	aPagos[nPos][H_NCC_PA ]	:=	0
	aPagos[nPos][H_NF]		:=	0
	aPagos[nPos][H_TOTAL]	:=	0
	aPagos[nPos][H_TOTALVL]	:=	0
	aPagos[nPos][H_VALORIG]	:=	0
	aPagos[nPos][H_DESCVL]	:=	0

	If cPaisLoc $ "URU|BOL"
		aPagos[nPos][H_RETIRIC]	:=	0
		aPagos[nPos][H_RETIR]	:=	0

	ElseIf cPaisLoc == "PTG"
		aPagos[nPos][H_RETIVA]	 :=	0
		aPagos[nPos][H_RETIRC]	 :=	0
		aPagos[nPos][H_DESPESAS] :=	0
	ElseIf cPaisLoc == "ANG"
		aPagos[nPos][H_RETRIE]	:=	0
	ElseIf cPaisLoc == "PER"
		aPagos[nPos][H_RETIGV]	:=	0           
		aPagos[nPos][H_RETIR]	:=	0
	ElseIf cPaisLoc $ "DOM|COS"
		aPagos[nPos][H_TOTRET]	:=	0
	ElseIf cPaisLoc == "PAR"
		aPagos[nPos][H_RETIVA]	 :=	0
		aPagos[nPos][H_RETIR]	:=	0
	Endif

	//CARREGAR COM OS VALORES DE NOTAS PARA SER PAGAS, NNC , PAS, E NO CASO DE ARGENTINA
	//AS RETENCOES DE IMPOSTOS DE IB E IVA.
	For nC	:=	1	To Len(aSE2[nPos][1])
		If aSE2[nPos][1][nC][_TIPO] $ MVPAGANT + "/" + MV_CPNEG
			aPagos[nPos][H_NCC_PA ]	+= Round(xMoeda(aSE2[nPos][1][nC][_PAGAR],aSE2[nPos][1][nC][_MOEDA],nMoedaCor,,5,aTxMoedas[aSE2[nPos][1][nC][_MOEDA]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			aPagos[nPos][H_VALORIG] += Round(xMoeda(aSE2[nPos][1][nC][_PAGAR],aSE2[nPos][1][nC][_MOEDA],1,,5,aTxMoedas[aSE2[nPos][1][nC][_MOEDA]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
		Else
			If cPaisLoc == "EQU"
   				nAbatimentos := SomaAbat(aSE2[nPos][1][nC][9],aSE2[nPos][1][nC][10],aSE2[nPos][1][nC][11],"P",aSE2[nPos][1][nC][4],aSE2[nPos][1][nC][7],aSE2[nPos][1][nC][1])
				aPagos[nPos][H_VALORIG] += Round(xMoeda(aSE2[nPos][1][nC][_PAGAR],aSE2[nPos][1][nC][_MOEDA],nMoedaCor,,5,aTxMoedas[aSE2[nPos][1][nC][_MOEDA]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
				aPagos[nPos][H_NF     ] += Round(xMoeda(aSE2[nPos][1][nC][_PAGAR],aSE2[nPos][1][nC][_MOEDA],nMoedaCor,,5,aTxMoedas[aSE2[nPos][1][nC][_MOEDA]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Else
				aPagos[nPos][H_VALORIG] += Round(xMoeda(aSE2[nPos][1][nC][_PAGAR],aSE2[nPos][1][nC][_MOEDA],1,,5,aTxMoedas[aSE2[nPos][1][nC][_MOEDA]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
				aPagos[nPos][H_NF     ] += Round(xMoeda(aSE2[nPos][1][nC][_PAGAR],aSE2[nPos][1][nC][_MOEDA],nMoedaCor,,5,aTxMoedas[aSE2[nPos][1][nC][_MOEDA]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
				aPagos[nPos][H_NCC_PA ] += aSE2[nPos][1][nC][_DESCONT] //nValDesc
				nDescOP := aPagos[nPos][_DESCONT ] // guarda o valor do nValDesc
			EndIf
		EndIf

		If cPaisLoc $ "URU|BOL"
			For nP	:=	1	To	Len(aSE2[nPos][1][nC][_RETIRIC])
				aPagos[nPos][H_RETIRIC]	+=	Round(xMoeda(aSE2[nPos][1][nC][_RETIRIC][nP][4],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next

			For nP	:=	1	To	Len(aSE2[nPos][1][nC][_RETIR])
				aPagos[nPos][H_RETIR]	+=	Round(xMoeda(aSE2[nPos][1][nC][_RETIR][nP][4],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next
		ElseIf cPaisLoc == "PTG"
			For nP	:=	1	To	Len(aSE2[nPos][1][nC][_RETIRC])
				aPagos[nPos][H_RETIRC]	+=	Round(xMoeda(aSE2[nPos][1][nC][_RETIRC ][nP][5],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next
			For nP	:=	1	To	Len(aSE2[nPos][1][nC][_RETIVA])
				aPagos[nPos][H_RETIVA]	+=	Round(xMoeda(aSE2[nPos][1][nC][_RETIVA][nP][4],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next
		ElseIf cPaisLoc == "ANG"
			For nP	:=	1	To	Len(aSE2[nPos][1][nC][_RETRIE])
				aPagos[nPos][H_RETRIE]	+=	Round(xMoeda(aSE2[nPos][1][nC][_RETRIE ][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next
		ElseIf cPaisLoc == "PER"
			/* retencao de IR */
				If !Empty(aSE2[nPos][1][nC][_RETIR])
					aSE2[nPos][1][nC][_RETIR][1][3] := aSE2[nPos][1][nC][_PAGAR]
					aSE2[nPos][1][nC][_RETIR][1][7] := aSE2[nPos][1][nC][_PAGAR]
					aSE2[nPos][1][nC][_RETIR][1][4] := (aSE2[nPos][1][nC][_RETIR][1][3] * aSE2[nPos][1][nC][_RETIR][1][9])/100
					aSE2[nPos][1][nC][_RETIR][1][6] := (aSE2[nPos][1][nC][_RETIR][1][3] * aSE2[nPos][1][nC][_RETIR][1][9])/100
				Endif
		ElseIf cPaisLoc == "PAR"
			For nP	:=	1	To	Len(aSE2[nPos][1][nC][_RETIVA])
				aPagos[nPos][H_RETIVA]	+=	Round(xMoeda(aSE2[nPos][1][nC][_RETIVA][nP][4],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next 		     
			For nP	:=	1	To	Len(aSE2[nPos][1][nC][_RETIR])
				aPagos[nPos][H_RETIR]	+=	Round(xMoeda(aSE2[nPos][1][nC][_RETIR][nP][4],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next
		Endif
	Next nC

	If cPaisLoc	==	"ARG"
		For nC:=	1	To Len(aSE2[nPos][2])
			aPagos[nPos][H_RETGAN]	+=	Round(xMoeda(aSE2[nPos][2][nC][5],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
		Next nC

		//IVA Cumulativo
		If Len(aRetIvAcm[3]) > 0 .And. aRetIvAcm[3] <> Nil
			For nP := 1 to Len(aRetIvAcm[3])
				aPagos[nPos][H_RETIVA]	+=	Round(xMoeda(aRetIvAcm[3][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next nP
		EndIf

		aPagos[nPos][H_TOTALVL]	:=	aPagos[nPos][H_NF]-aPagos[nPos][H_NCC_PA]-;
		aPagos[nPos][H_RETIB]-aPagos[nPos][H_RETGAN]-;
		aPagos[nPos][H_RETIVA]-aPagos[nPos][H_RETSUSS]-;
		aPagos[nPos][H_RETSLI]-aPagos[nPos][H_RETISI]
	ElseIf cPaisLoc $ "URU|BOL"
		aPagos[nPos][H_TOTALVL]	:=	aPagos[nPos][H_NF]-aPagos[nPos][H_NCC_PA]-aPagos[nPos][H_RETIRIC] -aPagos[nPos][H_RETIR]
	ElseIf cPaisLoc == "PTG"
		For nC:=	1	To Len(aSE2[nPos][4])
			aPagos[nPos][H_DESPESAS]		+=	Round(xMoeda(aSE2[nPos][4][nC][2],Val(aSE2[nPos][4][nC][3]),nMoedaCor,,5,aTxMoedas[Val(aSE2[nPos][4][nC][3])][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
		Next nC
		aPagos[nPos][H_TOTALVL]	:=	aPagos[nPos][H_NF]-aPagos[nPos][H_NCC_PA]-aPagos[nPos][H_RETIRC] -aPagos[nPos][H_RETIVA]+ aPagos[nPos][H_DESPESAS]
	ElseIf cPaisLoc == "ANG"
		aPagos[nPos][H_TOTALVL]	:=	aPagos[nPos][H_NF]-aPagos[nPos][H_NCC_PA]-aPagos[nPos][H_RETRIE]
	ElseIf cPaisLoc == "PER"
		CalcRetIGV(@aSE2,nPos,nPos)
		aPagos[nPos][H_TOTALVL]	:=	aPagos[nPos][H_NF]-aPagos[nPos][H_NCC_PA]-aPagos[nPos][H_RETIGV]-aPagos[nPos][H_RETIR]
	ElseIf cPaisLoc == "PAR"
		aPagos[nPos][H_TOTALVL]	:=	aPagos[nPos][H_NF]-aPagos[nPos][H_NCC_PA]-aPagos[nPos][H_RETIVA]-aPagos[nPos][H_RETIR]
	Else
		aPagos[nPos][H_TOTALVL]	:=	aPagos[nPos][H_NF]//-aPagos[nPos][H_NCC_PA]
	Endif
    If cPaisLoc	==	"EQU"
        If	aPagos[nPos][H_TOTALVL] !=	aPagos[nPos][H_VALORIG]
	 		aPagos[nPos][H_TOTALVL] := aPagos[nPos][H_NF]
	 	EndIf
		aPagos[nPos][H_DESCVL ] := If(nValDesc > 0,nValDesc,0.00)
		aPagos[nPos][H_MULTAS ] := If(nMulta+nJuros > 0,nMulta + nJuros,0.00)
		aPagos[nPos][H_TOTRET ] := aPagos[nPos][H_TOTRET]
		aPagos[nPos][H_PORDESC]	:=	nPorDesc
 		aPagos[nPos][H_NF     ] := aPagos[nPos][H_NF     ]
		aPagos[nPos][H_NCC_PA ] := aPagos[nPos][H_NCC_PA ]
		aPagos[nPos][H_TOTRET ] := aPagos[nPos][H_TOTRET ]
		aPagos[nPos][H_DESCVL ] := aPagos[nPos][H_DESCVL ]
		aPagos[nPos][H_MULTAS ] := aPagos[nPos][H_MULTAS ]
		aPagos[nPos][H_RETIVA ] := fA085GetRet("IV-",aPagos[nPos][H_TOTRET],aSE2,aPagos)
		aPagos[nPos][H_RETIR  ] := fA085GetRet("IR-",aPagos[nPos][H_TOTRET],aSE2,aPagos)
 		aPagos[nPos][H_TOTALVL] := aPagos[nPos][H_NF] - aPagos[nPos][H_NCC_PA] - aPagos[nPos][H_TOTRET] - aPagos[nPos][H_DESCVL] + aPagos[nPos][H_MULTAS]
		aPagos[nPos][H_TOTAL  ] := aPagos[nPos][H_TOTALVL]
  	EndIf
	If cPaisLoc	==	"ARG"
		aPagos[nPos][H_TOTRET]	:=	aPagos[nPos][H_RETIB]+aPagos[nPos][H_RETIVA]+aPagos[nPos][H_RETGAN]
		aPagos[nPos][H_RETIB]	:=	TransForm(aPagos[nPos][H_RETIB]  ,Tm(aPagos[nPos][H_RETIB ] ,16,nDecs))
		aPagos[nPos][H_RETGAN]	:=	TransForm(aPagos[nPos][H_RETGAN] ,Tm(aPagos[nPos][H_RETGAN] ,16,nDecs))
		aPagos[nPos][H_RETIVA]	:=	TransForm(aPagos[nPos][H_RETIVA] ,Tm(aPagos[nPos][H_RETIVA] ,16,nDecs))
		aPagos[nPos][H_RETSUSS]	:=	TransForm(aPagos[nPos][H_RETSUSS],Tm(aPagos[nPos][H_RETSUSS],16,nDecs))
		aPagos[nPos][H_RETSLI]	:=	TransForm(aPagos[nPos][H_RETSLI] ,Tm(aPagos[nPos][H_RETSLI] ,16,nDecs))
		aPagos[nPos][H_RETISI]	:=	TransForm(aPagos[nPos][H_RETISI] ,Tm(aPagos[nPos][H_RETISI] ,16,nDecs))
	ElseIf cPaisLoc $ "URU|BOL"
		aPagos[nPos][H_TOTRET]	:=	aPagos[nPos][H_RETIRIC] + aPagos[nPos][H_RETIR]
		aPagos[nPos][H_RETIRIC]	:=	TransForm(aPagos[nPos][H_RETIRIC],Tm(aPagos[nPos][H_RETIRIC],16,nDecs))
		aPagos[nPos][H_RETIR]	:=	TransForm(aPagos[nPos][H_RETIR],Tm(aPagos[nPos][H_RETIR],16,nDecs))
	ElseIf cPaisLoc	==	"PTG"
		aPagos[nPos][H_TOTRET]	:=	aPagos[nPos][H_RETIRC]+aPagos[nPos][H_RETIVA]
		aPagos[nPos][H_RETIRC]	:=	TransForm(aPagos[nPos][H_RETIRC]  ,Tm(aPagos[nPos][H_RETIRC ] ,16,nDecs))
		aPagos[nPos][H_RETIVA]	:=	TransForm(aPagos[nPos][H_RETIVA] ,Tm(aPagos[nPos][H_RETIVA] ,16,nDecs))
		aPagos[nPos][H_DESPESAS]:=	TransForm(aPagos[nPos][H_DESPESAS] ,Tm(aPagos[nPos][H_DESPESAS] ,16,nDecs))
	ElseIf cPaisLoc	==	"ANG"
		aPagos[nPos][H_TOTRET]	:=	aPagos[nPos][H_RETRIE]
		aPagos[nPos][H_RETRIE]	:=	TransForm(aPagos[nPos][H_RETRIE]  ,Tm(aPagos[nPos][H_RETRIE ] ,16,nDecs))
	ElseIf cPaisLoc	==	"PER"
		aPagos[nPos][H_TOTRET]	:=	aPagos[nPos][H_RETIGV]
		aPagos[nPos][H_RETIGV]	:=	TransForm(aPagos[nPos][H_RETIGV]  ,Tm(aPagos[nPos][H_RETIGV ] ,16,nDecs))
		/* retencao de IR */
		aPagos[nPos][H_TOTRET]	+=	aPagos[nPos][H_RETIR]
		aPagos[nPos][H_RETIR]	:=	TransForm(aPagos[nPos][H_RETIR] ,Tm(aPagos[nPos][H_RETIR] ,16,nDecs))
	ElseIf cPaisLoc	==	"PAR"
		aPagos[nPos][H_TOTRET]	:=	aPagos[nPos][H_RETIVA] + aPagos[nPos][H_RETIR]
		aPagos[nPos][H_RETIVA]	:=	TransForm(aPagos[nPos][H_RETIVA]  ,Tm(aPagos[nPos][H_RETIVA ] ,16,nDecs))
		aPagos[nPos][H_RETIR]	:=	TransForm(aPagos[nPos][H_RETIR],Tm(aPagos[nPos][H_RETIR],16,nDecs))
	ElseIf cPaisLoc $ "COS|DOM"
		//Array aRetencao - Preenchido na fun��o fa050CalcRet() - C�lculo de reten��o com Conf. de Impostos
		If Len(aRetencao) > 0
			For nX := 1 to Len(aRetencao)
				If aRetencao[nX][6] == aPagos[nPos][H_FORNECE ] .And. aRetencao[nX][7] == aPagos[nPos][H_LOJA ]
					For nY := 1 to Len(aRetencao[nX][8])
						If aRetencao[nX][8][nY][3] == "1"
							aPagos[nPos][H_TOTRET ] += aRetencao[nX][8][nY][2]
							aPagos[nPos][H_NF     ] += aPagos[nPos][H_TOTRET ]
						ElseIf aRetencao[nX][8][nY][3] == "2"
							aPagos[nPos][H_NCC_PA ] += aRetencao[nX][8][nY][2]
							aPagos[nPos][H_TOTALVL] -= aRetencao[nX][8][nY][2]
						EndIf
					Next nY
				EndIf
			Next nX
		Else
			aPagos[nPos][H_TOTRET ] := 0
		EndIf
	Endif

	If aPagos[nPos][1] == 0
		nNumOrdens++
	Endif
	//A factura so eh desconsiderada caso a retencao de IVA e o total a ser
	//pago sejam menores que zero. Isso so eh valido para Argentina.
	If (aPagos[nPos][H_TOTALVL]	< 0) .And. Iif(cPaisLoc=="ARG",DesTrans(aPagos[nPos][H_RETIVA],nDecs) <= 0,.F.)
		aPagos[nPos][1]	:=	0
		nNumOrdens--
	Else
		aPagos[nPos][1]	:=	1
		nValOrdens	+=	aPagos[nPos][H_TOTALVL]
	Endif
	If cPaisLoc <> "EQU"
		aPagos[nPos][H_DESCVL]	:=	aPagos[nPos][H_NCC_PA]
		aPagos[nPos][H_NF    ]	:=	TransForm(aPagos[nPos][H_NF     ],Tm(aPagos[nPos][H_NF]    ,16,nDecs))
		aPagos[nPos][H_NCC_PA]	:=	TransForm(aPagos[nPos][H_NCC_PA ],Tm(aPagos[nPos][H_NCC_PA],16,nDecs))
		aPagos[nPos][H_TOTAL ]	:=	TransForm(aPagos[nPos][H_TOTALVL],Tm(aPagos[nPos][H_TOTALVL] ,18,nDecs))
		aPagos[nPos][H_PORDESC]	:=	nPorDesc

		Fa085atuVl(@oValOrdens,@nValOrdens,@aPagos,aSE2)
		If aPagos[nPos][H_VALORIG]==0
			aPagos[nPos][H_OK] := -1	
		EndIf
	EndIf
	oLbx:Refresh()
	oValOrdens:Refresh()

	//�������������������������������������������������������������������Ŀ
	//�Se foi definido um pagamento diferenciado e modifico os valores das�
	//�notas, chamo a fun��o do pagamento especial para atualizar os      �
	//�valores e validar.                                                 �
	//���������������������������������������������������������������������
	If aSE2[nPos][3] <> Nil .And. aSE2[nPos][3][1]	==	4
		A085aPagos(aSE2[nPos][1],aSE2[nPos][2],nPos,@aSE2,oObj,.T.)
	Endif
	aPagosOrig:={}
Else
	nPorDesc:= 	0
	nValDesc:=	0
Endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �a085ATudok�Autor  �Bruno Sobieski      � Data �  04/11/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida a digitacao dos titulos no pagamento parcial         ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function A085aTudok(nOpc,nPagar,lPa,nLiquido,oObj,cNatureza,aCtrChEQU)
Local lRet		:=	.T.
Local nDel
Local nLines	:=	0
Local lMoedaOk	:=	.T.
Local nMoedaCol	:=	1
Local nTotalCol	:=	0
Local nPosMoe		:=	Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_MOEDA"})
Local nPosValor 	:=	Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_VALOR"})
Local nX		:= 0
Local nValorTit:= 0
Local oDlg1
Local nBaseImp
Local cCalcITF   := SuperGetMv("MV_CALCITF",.F.,"2")
Local lLckSEF := .F.
Local cQrySEF
Local cTMPSEF
Local nRecnoSEF
Local lF085ANOPA := Existblock("F085ANOPA")

Private oTes,oBaseImp

Default aCtrChEQU	:=	{}

If lF085aChS .and. nPagar==1
	nPagar++
Endif
If cPaisLoc $ "EQU|DOM|COS" .and. nOpc==2
	If Len(aCtrChEQU)==0
		Aadd(aCtrChEQU,{0,""})
	Else
		SEF->(MsUnlock())
		aCtrChEQU:={}
		Aadd(aCtrChEQU,{0,""})
	Endif
Endif
If lRetPA == Nil
	lRetPA := (GetNewPar("MV_RETPA","N") == "S")
EndIf

lPa	:=	If(lPa==Nil,.F.,lPa)
nLiquido:=	If(nLiquido==Nil,0,nLiquido)
nValor := IIf( Type("NVALOR")=="U", 1, nValor)
//����������������������������������������������������������������Ŀ
//�Validacao da digitacao dos saldos a pagar dos titulos escolhidos�
//������������������������������������������������������������������
If nValor <= 0
	Help(" ",1,"VALNEG")
	lRet := .F.
EndIf

If Type("cFornece")<>"U" .and. Type("cLoja")<>"U"
	If  Empty(cFornece) .or. Empty(cLoja)
		Help(" ",1,"Obrigat")
		lRet := .F.
	Else
		SA2->(DbsetOrder(1))
		If !(SA2->(DbSeek(xFilial("SA2")+cFornece+cLoja) ))
			Help(" ",1,"NOFORNEC")
			lRet := .F.
		EndIf
	EndIf
EndIf

//�����������������������������������������������������������������������Ŀ
//� Validacao do preechimento dos dados para o calculo de rentencao no PA �
//�������������������������������������������������������������������������
If (nOpc	==	2 .And. lRet .And. lPa .And. lRetPA .And. ((Substr(cAgente,2,1) == "S") .Or. (Substr(cAgente,3,1) == "S") .Or. (Substr(cAgente,6,1) == "S"))) .And. cPaisLoc == "ARG"

	//Valor base para todos os impostos
	If nTotAnt == 0
		lRet := .F.
	Endif

	//IVA e IB
	If ((Substr(cAgente,2,1) == "S") .Or. (Substr(cAgente,3,1) == "S")) .And. (AllTrim(cCf) == "" .Or. AllTrim(cProv) == "")
		lRet := .F.
	Endif

	//SUSS
	If (Substr(cAgente,6,1) == "S") .And. (AllTrim(nGrpSus) == "" .Or. AllTrim(cZnGeo) == "")
		lRet := .F.
	Endif

	If !lRet
		MsgAlert(STR0250)
    Endif

Endif

If nOpc	==	1 .and. lRet
	If	nValLiq	<	0 .And. lRet
		MsgAlert(STR0103) //"Escoja un valor mayor (o igual) que cero."
		lRet	:=	.F.
	Endif
	//�����������������������������������������������������������Ŀ
	//�Validacao dos titulos entregues para o pago na seleccao de �
	//�pagamento diferenciado.                                    �
	//�������������������������������������������������������������
ElseIf nOpc == 2 .and. lRet
	If nPagar == 4
		nLines	:=	0
		For nX	:=	1	To	Len(aCols)
			If !aCols[nX][Len(aCols[nX])]
				nLines++
			Endif
		Next
		If nLines == 0
			Help("",1,"NoCols")
			lRet	:=	.F.
		ElseIf !lPA	.And. aSaldos[Len(aSaldos)] > 0 .and. !lRetPA
			lRet	:=	MsgYesNo(OemToAnsi(STR0104 + GetMv("MV_SIMB"+Alltrim(Str(nMoedaCor)))+ TransForm(aSaldos[Len(aSaldos)],Tm(aSaldos[Len(aSaldos)],18,nDecs)) +; //"Faltan "
			STR0105+CHR(13)+CHR(10)+; //" o su equivalente en otra moneda, para pagar los titulos escogidos."
			STR0106+CHR(13)+CHR(10)+; //"Si confirma, la diferencia sera paga de la forma escogida para el resto de las OP."
			STR0107),OemToAnsi(STR0040)) //"� Desea confirmar ? "###"Confirmar"
		ElseIf  !lPa .And. aSaldos[Len(aSaldos)] < 0	.and. !lRetPA
			If lF085ANOPA
				lRet := ExecBlock("F085ANOPA",.F.,.F.,{aSaldos[Len(aSaldos)]})
			Else
			lRet	:=	MsgYesNo(OemToAnsi(STR0109+ GetMv("MV_SIMB"+Alltrim(Str(nMoedaCor))) + TransForm(aSaldos[Len(aSaldos)]*-1,Tm(aSaldos[Len(aSaldos)],18,nDecs)) +; //"Sobran "
			STR0110+CHR(13)+CHR(10)+; //" o sus equivalentes en otras monedas, para pagar los titulos escogidos."
			STR0111+CHR(13)+CHR(10)+; //"Si confirma, seran generados PA por la diferencia "
			STR0107),OemToAnsi(STR0108)) //"� Desea confirmar ? "###"Confirmar"
			Endif
		ElseIf  !lPa .And. lRetPA .And. aSaldos[Len(aSaldos)] <> 0
			For nX:=1 to Len(aCols)
				nValorTit:= nValorTit+ aCols[nX][nPosVlr]
		    Next
		    	If aSaldos[Len(aSaldos)] < 0
					lRet	:=	MsgYesNo(OemToAnsi(STR0109+ GetMv("MV_SIMB"+Alltrim(Str(nMoedaCor))) + TransForm(aSaldos[Len(aSaldos)]*-1,Tm(aSaldos[Len(aSaldos)],18,nDecs)) +; //"Sobran "
					STR0110+CHR(13)+CHR(10)+; //" o sus equivalentes en otras monedas, para pagar los titulos escogidos."
					STR0111+CHR(13)+CHR(10)+; //"Si confirma, seran generados PA por la diferencia "
					STR0107),OemToAnsi(STR0108)) //"� Desea confirmar ? "###"Confirmar"
                ElseIf aSaldos[Len(aSaldos)] > 0
					lRet	:=	MsgYesNo(OemToAnsi(STR0104 + GetMv("MV_SIMB"+Alltrim(Str(nMoedaCor)))+ TransForm(aSaldos[Len(aSaldos)],Tm(aSaldos[Len(aSaldos)],18,nDecs)) +; //"Faltan "
					STR0105+CHR(13)+CHR(10)+; //" o su equivalente en otra moneda, para pagar los titulos escogidos."
					STR0106+CHR(13)+CHR(10)+; //"Si confirma, la diferencia sera paga de la forma escogida para el resto de las OP."
					STR0107),OemToAnsi(STR0040)) //"� Desea confirmar ? "###"Confirmar"
		       	   //	Aviso(STR0163, STR0162,{"OK"}  ) //" Valores dos titulos informados esta diferente do valor total da Op"###"Valor"
		        	//lRet:=.F.
		        EndIf
		ElseIf lRetPA	.And. lPA
			For nX	:=	1	To	Len(aCols)
				If !aCols[nX][Len(aCols[nX])]
					nTotalCol	+=	xMoeda(aCols[nX][nPosValor],val(aCols[nX][nPosMoe]),1,dDataBase,,aTxMoedas[val(aCols[nX][nPosMoe])][2])
				EndIf
			Next
				If nTotalCol <> nLiquido
					AVISO(STR0163, STR0162+"."+CRLF+"Informar valores para el pago por el total de "+GetMv("MV_SIMB1")+TransForm(nLiquido,PesqPict("SE2","E2_VALOR"))+".",{"OK"},2  ) //" Valores dos titulos informados esta diferente do valor total da Op"###"Valor"
					lRet	:=	.F.
				Endif
		Endif

		//Validacao para quando sejam feitas retencoes nos PA

		If lRet
			If Len(aRecChqTer) < Len(aCols)
				AAdd(aRecChqTer,0)
			Endif
			For nX	:=	1	To	Len(aRecChqTer)
				//Se for um registro de cheque de terceiro e esta apagado, limpo ele
				If  aCols[nX][Len(aCols[nX])]
					//���������������������������������������������������������������Ŀ
					//�Marco o Acols com array zerado pra dar aDel e aSize na saida.  �
					//�Se fazer um adel agora, perco a referencia direta entre o aCols�
					//�e o aRecChqTer                                                 �
					//�����������������������������������������������������������������
					aCols[nX]	:=	{}
					If aRecChqTer[nX] > 0
						SE1->(MsGoTo(aRecChqTer[nX]))
						Replace	SE1->E1_OK	With "  "
						SE1->(MsRUnlock(aRecChqTer[nX]))
					Endif
				Endif
			Next
			nDel	:=	0
			For nX:=1	To Len(aCols)
				If aCols[nX] <> Nil .And. Len(aCols[nX]) == 0
					aDel(aCols,nX)
					aDel(aRecChqTer,nX)
					nDel++
				Endif
			Next
			aSize(aCols			,Len(aCols)		-nDel)
			aSize(aRecChqTer	,Len(aRecChqTer)-nDel)
		Endif
	Else
		For nX	:=	1	To Len(aRecChqTer)
			If aRecChqTer[nX] > 0
				SE1->(MsGoTo(aRecChqTer[nX]))
				Replace	SE1->E1_OK	With "  "
				SE1->(MsRUnlock(aRecChqTer[nX]))
			Endif
		Next
		SA6->(DbSetOrder(1))
		If	(EMPTY(cBanco).Or.Empty(cAgencia).Or.Empty(cConta)) .Or. ;
			!SA6->(DbSeek(xFilial()+cBanco+cAgencia+cConta))
			Help("",1,"BCOBRANCO")
			lRet	:=	.F.
		Else
			If nPagar	<> 3 .And. SA6->A6_COD $ GetMV("MV_CARTEIR")
				Help("",1,"a085ChqCar")
				lRet	:=	.F.
			Endif
		Endif
	Endif
Endif

If Type("aSaldos")<>"U" .And. !lPa .And. aSaldos[Len(aSaldos)] < 0	.and. lRetPA .And. lret
	DEFINE MSDIALOG oDlg1 FROM 30,40  TO 200,400 TITLE OemToAnsi(STR0189) Of oMainWnd PIXEL  // "Orden de pago del proveedor "

	//Titulos por pagar
 		@ 05,004 To 80,175 Pixel Of  oDlg1

 			@ 10,015 SAY OemToAnsi(STR0190)SIZE 250, 7 OF oDlg1 PIXEL
	@ 20,015 SAY OemToAnsi(STR0191) SIZE 250, 7 OF oDlg1 PIXEL

	@ 40,006 SAY OemToAnsi(STR0184) SIZE 30, 7 OF oDlg1 PIXEL COLOR CLR_HBLUE //Codigo Fiscal
	@ 40,025 MSGET cTes	F3 "SF4" Picture "@S3"  Valid F085ImpTes(@nBaseRet,Iif(Type(cCodFor)<> "U",cCodFor,""),Iif(Type(cLojaFor)<> "U",cLojaFor,"")) SIZE 15, 7 PIXEL OF oDlg1 // WHEN nPagar<>4

	@ 40,75 SAY OemToAnsi(STR0159) SIZE 45, 7 OF oDlg1 PIXEL COLOR CLR_HBLUE //Provincia
	@ 40,119 MSGET cProv F3 "12" Picture "@!" Valid F085ImpTes(@nBaseRet,Iif(Type(cCodFor)<> "U",cCodFor,""),Iif(Type(cLojaFor)<> "U",cLojaFor,""))  SIZE 15, 7 PIXEL OF oDlg1 // WHEN nPagar<>4

  	DEFINE SBUTTON FROM 57,070  Type 1 Action If((!Empty(cTes)  .And. !Empty(cProv)),(nOpca := 1,oDlg1:End()),HELP(" ",1,"OBRIGAT",,SPACE(45),3,0)) ENABLE PIXEL OF oDlg1
	Activate Dialog oDlg1 CENTERED
EndIf

If cPaisLoc $ "EQU|DOM" .and. nOpc==2
	If	nPagar<=1
		lRet	:=	.F.
		MsgAlert(STR0224) //"Selecione a forma de pagamento!"
	Endif
Endif

If lRet
   lRet:=lRetCkPG(1,cDebInm,SA6->A6_COD,nPagar)
Endif
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �a085FldOk1�Autor  �Bruno Sobieski      � Data �  10/19/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida a digitacao do campo  e o total para a nova moeda dgi���
���          � tada.                                                      ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function a085FldOk1(bRecalc)
Local cCampo	:=	ReadVar()
Local nPos 		:=	Ascan(aHeader,{ |x| Alltrim(x[2])==Alltrim(Substr(cCampo,4))})
Local nPosTipE2	:=	Ascan(aHeader,{ |x| Alltrim(x[2])=="E2_TIPO"   })
Local nPosMoeE2	:=	Ascan(aHeader,{ |x| Alltrim(x[2])=="E2_MOEDA"  })
Local nPosPagE2	:=	Ascan(aHeader,{ |x| Alltrim(x[2])=="E2_PAGAR"  })
Local nPosSalE2	:=	Ascan(aHeader,{ |x| Alltrim(x[2])=="E2_SALDO"  })
Local nPosMulE2	:= 	Ascan(aHeader,{ |x| Alltrim(x[2])=="E2_MULTA"  })
Local nPosJurE2	:= 	Ascan(aHeader,{ |x| Alltrim(x[2])=="E2_JUROS"  })
Local nPosDesE2	:= 	Ascan(aHeader,{ |x| Alltrim(x[2])=="E2_DESCONT"})
Local nPosValE2	:= 	Ascan(aHeader,{ |x| Alltrim(x[2])=="E2_VALOR"  })
Local nPosVlMod	:= 	Ascan(aHeader,{ |x| Alltrim(x[2])=="NVLMDINF"  })
Local lRet		:=	.T.
Local nSigno
Local nX := 0

//Zerar descontos de cabecalho quando se modifica alguma campo de valor da linha
If (Alltrim(aHeader[nPos][2]) == "E2_PAGAR" .Or. 	AllTrim(aHeader[nPos][2]) == "E2_JUROS" .Or. AllTrim(aHeader[nPos][2]) == "E2_MULTA" )
	For nX:=1	To	Len(aCols)
		aCols[nX][nPosPagE2]	+= aCols[nX][nPosDesc]
		aCols[nX][nPosDesc]	:= 0
	Next
	nValDesc	:=	0
	nPorDesc	:=	0
Endif
If	aCols[n][nPosTipE2]	$	MV_CPNEG+"/"+MVPAGANT
	//Se o titulo diminui do valor total, so posso editar o campo E2_PAGAR
	If (aHeader[nPos][2] == "E2_DESCONT".Or. 	Trim(aHeader[nPos][2]) == "E2_JUROS" .Or. Trim(aHeader[nPos][2]) == "E2_MULTA" )
		lRet	:=	.F.
	Else
		nValLiq := 0
		aCols[n][nPosSalE2]+= aCols[n][nPosPagE2]  
		If cPaisLoc $ "MEX" .AND. aHeader[nPosPagE2][2]<>Right(cCampo,LEN(ALLTRIM(aHeader[nPosPagE2][2])))
			aCols[n][nPosPagE2]:= Round(xMoeda(&(cCampo),nMoedaCor,aCols[N][nPosMoeE2],,5),MsDecimais(nMoedaCor))
		ElseIf cPaisLoc $ "BOL" .AND. aHeader[nPosPagE2][2]<>Right(cCampo,LEN(ALLTRIM(aHeader[nPosPagE2][2])))
			aCols[n][nPosPagE2]:= Round(xMoeda(&(cCampo),nMoedaCor,aCols[N][nPosMoeE2],,5,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
		Else
			If !cPaisLoc $ "PAR|CHI|URU|BOL"
				aCols[n][nPosPagE2]:= &(cCampo)
			EndIF
		Endif 		
		aCols[n][nPosSalE2]+= aCols[n][nPosPagE2]
		aCols[n][nPosSalE2]-= aCols[n][nPosPagE2]
		Aeval(aCols,{|x,y|,Iif(aCols[y][nPosTipE2] $	MV_CPNEG+"/"+MVPAGANT,nValLiq -= Round(xMoeda(aCols[y][nPosPagE2],aCols[y][nPosMoeE2],nMoedaCor,,nDecs+1,aTxMoedas[aCols[y][nPosMoeE2]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor)),nValLiq += Round(xMoeda(aCols[y][nPosPagE2],aCols[y][nPosMoeE2],nMoedaCor,,nDecs+1,aTxMoedas[aCols[y][nPosMoeE2]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor)))})
	Endif
Else
	nSigno	:=	IIf(aHeader[nPos][2] == "E2_DESCONT",-1,1)

	If nSigno < 0
		If (aPagar[n] - &(cCampo)) < 0
			Help("",1,"DESC>SALDO")
			lRet	:=	.F.
		Else
			nValDesc 	+=	Round(xMoeda(&(cCampo)-aCols[n][nPos],aCols[n][nPosMoeE2],nMoedaCor,,5,aTxMoedas[aCols[n][nPosMoeE2]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			//Zerar o percentagem de desconto pois o desconto comeca a ser individual (Nota por Nota)...
			nPorDesc	:=	0
			If cPaisLoc $ "PER"
				aCols[n][nPosPagE2] := aCols[n][nPosPagE2] - (M->E2_DESCONT - aCols[n][nPosDesE2])
				nVlDscAux			+= Round(xMoeda((M->E2_DESCONT - aCols[n][nPosDesE2]),aCols[n][nPosMoeE2],nMoedaCor,,nDecs+1,aTxMoedas[aCols[n][nPosMoeE2]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Else
				aCols[n][nPosPagE2] := (aPagar[n] + aCols[n][nPosJurE2] + aCols[n][nPosMulE2]) - (M->E2_DESCONT + aCols[n][nPosSalE2])
			EndIf
			If aCols[n][nPosPagE2] < 0
				aCols[n][nPosSalE2] := aCols[n][nPosSalE2] + aCols[n][nPosPagE2]
	 			aCols[n][nPosPagE2] := 0
			EndIf
			nValLiq := 0
			Aeval(aCols,{|x,y|,Iif(aCols[y][nPosTipE2] $	MV_CPNEG+"/"+MVPAGANT,nValLiq -= Round(xMoeda(aCols[y][nPosPagE2],aCols[y][nPosMoeE2],nMoedaCor,,nDecs+1,aTxMoedas[aCols[y][nPosMoeE2]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor)),nValLiq += Round(xMoeda(aCols[y][nPosPagE2],aCols[y][nPosMoeE2],nMoedaCor,,nDecs+1,aTxMoedas[aCols[y][nPosMoeE2]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor)))})
			nValLiq	+=	nValDesp
		Endif
	Else
		//Atualizar aCOLS , antes de acabar a validacao, para que seja recalculado o desconto
		//de acordo com a Porcentagem do cabe�alho
		If Alltrim(cCampo) $"M->E2_PAGAR|M->NVLMDINF"
			If Alltrim(cCampo)== "M->E2_PAGAR"
			nDiff	:=	Round(xMoeda(M->E2_PAGAR 	,aCols[n][nPosMoeE2]	,nMoedaCor	,,5,aTxMoedas[aCols[n][nPosMoeE2]][2],	aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))-;
						Round(xMoeda(aCols[n][1]	,aCols[n][nPosMoeE2]	,nMoedaCor	,,5,aTxMoedas[aCols[n][nPosMoeE2]][2],	aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Else
				nDiff	:=	M->NVLMDINF-aCols[n][nPosVlMod]
			EndIf
			nValBrut	+= IIf(!cPaisLoc $ 'PER|MEX', nDiff, 0)
			aCols[n][nPosSalE2]-= (aPagar[n]+ aCols[n][nPosJurE2]+ aCols[n][nPosMulE2]) - (aCols[n][nPosPagE2] + aCols[n][nPosDesE2])
			aCols[n][nPosPagE2]:= Iif(Alltrim(cCampo)== "M->E2_PAGAR",M->E2_PAGAR,aCols[n][nPosPagE2])
			aCols[n][nPosSalE2]+= (aPagar[n]+ aCols[n][nPosJurE2]+ aCols[n][nPosMulE2]) - (aCols[n][nPosPagE2] + aCols[n][nPosDesE2])
		ElseIf cCampo == "M->E2_JUROS"
			aCols[n][nPosPagE2] := (aPagar[n] + M->E2_JUROS + aCols[n][nPosMulE2]) - (aCols[n][nPosDesE2] + aCols[n][nPosSalE2])
			nDiff	:=	Round(xMoeda(&(cCampo)		,aCols[n][nPosMoeE2]	,nMoedaCor	,,5,aTxMoedas[aCols[n][nPosMoeE2]][2],	aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))-;
						Round(xMoeda(aCols[n][nPos]	,aCols[n][nPosMoeE2]	,nMoedaCor	,,5,aTxMoedas[aCols[n][nPosMoeE2]][2],	aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			nValBrut	+=	nDiff
		ElseIf cCampo == "M->E2_MULTA"
			aCols[n][nPosPagE2] := (aPagar[n] + aCols[n][nPosJurE2] + M->E2_MULTA) - (aCols[n][nPosDesE2] + aCols[n][nPosSalE2])
			nDiff	:=	Round(xMoeda(&(cCampo)		,aCols[n][nPosMoeE2]	,nMoedaCor	,,5,aTxMoedas[aCols[n][nPosMoeE2]][2],	aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))-;
						Round(xMoeda(aCols[n][nPos]	,aCols[n][nPosMoeE2]	,nMoedaCor	,,5,aTxMoedas[aCols[n][nPosMoeE2]][2],	aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			nValBrut	+=	nDiff
		EndIf
		If aCols[n][nPosPagE2] < 0
			aCols[n][nPosSalE2] := aCols[n][nPosSalE2] + aCols[n][nPosPagE2]
 			aCols[n][nPosPagE2] := 0
		EndIf
		nValLiq := 0
		Aeval(aCols,{|x,y|,Iif(aCols[y][nPosTipE2] $	MV_CPNEG+"/"+MVPAGANT,nValLiq -= Round(xMoeda(aCols[y][nPosPagE2],aCols[y][nPosMoeE2],nMoedaCor,,nDecs+1,aTxMoedas[aCols[y][nPosMoeE2]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor)),nValLiq += Round(xMoeda(aCols[y][nPosPagE2],aCols[y][nPosMoeE2],nMoedaCor,,nDecs+1,aTxMoedas[aCols[y][nPosMoeE2]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor)))})
		nValLiq	+=	nValDesp
	EndIf
Endif
//ANGOLA
If (cPaisLoc ==	"ARG" .Or. cPaisLoc $ "URU|BOL|PTG|ANG|PER|PAR") .And. lRet //.And.	aCols[n][nPos]	<>	&(cCampo)
	Eval(bRecalc)
Endif

oValDesc:Refresh()
oPorDesc:Refresh()
oValLiq:Refresh()
oValBrut:Refresh()

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �a085FldOk2�Autor  �Bruno Sobieski      � Data �  10/19/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida a digitacao dos itens do aCols do pagamento diferenci���
���          � ado de Ordens de Pago                                      ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function a085FldOk2(lPA)
Local cCampo	:=	ReadVar()
Local nPos 		:=	Ascan(aHeader,{ |x| Alltrim(x[2])=="EK_TIPODOC"})
Local nPosTp 	:=	Ascan(aHeader,{ |x| Alltrim(x[2])=="EK_TIPO"})
Local nPosVlr 	:=	Ascan(aHeader,{ |x| Alltrim(x[2])=="EK_VALOR"})
Local nPosBco 	:=	Ascan(aHeader,{ |x| Alltrim(x[2])=="EK_BANCO"})
Local lRet		:=	.T.
Local nMoeda	:=	1

lPA	:=	If(lPA==Nil,.F.,lPa)
If lPa
	If lRet .and. cPaisLoc $ "DOM"
		If lRet .and. cCampo == "M->EK_TIPO"
			If RTRIM(M->EK_TIPO) == "EF" .and. aCols[n][nPosVlr] >= nFinLmCH
            Help(" ",1,"HELP",STR0229,STR0230,1,0)//"FA085A - LIMITE ITF","Pagamento disponivel apenas com Cheque ou Transfer�ncia Banc�ria."
            lRet:=.F.
    		Endif
	      If lRet .and. RTRIM(M->EK_TIPO) == "EF" .and. !Empty(aCols[n][nPosBco])
	      	If !(aCols[n][nPosBco] $ (Left(GetMv("MV_CXFIN"),TamSX3("A6_COD")[1])+"/"+GetMv("MV_CARTEIR")) .or. !IsCaixaLoja(aCols[n][nPosBco]))
					MsgAlert(STR0215+aCols[n][nPosBco]+STR0231)  //" n�o recebe lan�amento do tipo EF."
					lRet:=.F.
				Endif
			Endif
    	Endif
		If lRet .and. cCampo == "M->EK_VALOR"
			If M->EK_VALOR >= nFinLmCH .and. Rtrim(aCols[n][nPosTp]) == "EF"
            Help(" ",1,"HELP",STR0229,STR0230,1,0) //"FA085A - LIMITE ITF","Pagamento disponivel apenas com Cheque ou Transfer�ncia Banc�ria."
            lRet:=.F.
    		Endif
    	Endif
		If lRet .and. cCampo == "M->EK_BANCO"
	      If !Empty(M->EK_BANCO) .and.  !(M->EK_BANCO $ (Left(GetMv("MV_CXFIN"),TamSX3("A6_COD")[1])+"/"+GetMv("MV_CARTEIR")) .or. IsCaixaLoja(M->EK_BANCO))
	     		If Rtrim(aCols[n][nPosTp]) == "EF"
					MsgAlert(STR0215+M->EK_BANCO+STR0231) //" n�o recebe lan�amento do tipo EF."
					lRet:=.F.
				Endif
			Endif
		Endif
   Endif
	If lRet	.And. !Empty(aCols[n][nPos])
		If cCampo	==	"M->EK_VALOR" .And. !Empty( aCols[n][nPosMoeda])
			aCols[n][nPosVlr]	:=	&(cCampo)
			a085aSalPa(Iif(lPa,Nil,oSaldo)	,lPa)
		ElseIf cCampo == "M->EK_BANCO"	.And. SA6->A6_COD==&(cCampo)
			nMoeda	:=	Iif(SA6->(FieldPos("A6_MOEDAP")) > 0 .And. SA6->A6_MOEDAP>0,SA6->A6_MOEDAP,SA6->A6_MOEDA)
			aCols[n][nPosMoeda]	:=	Alltrim(Str(MAX(nMoeda,1)))
			a085aSalPa(Iif(lPa,Nil,oSaldo)	,lPa)
		Endif
	Endif
Else
	If cCampo <> "M->EK_TIPODOC"  .And. aCols[n][nPos]	==	"3"
		Help("",1,"ChqTerc")
		lRet	:=	.F.
	Endif
	If lRet .and. cPaisLoc $ "DOM"
		If lRet .and. cCampo == "M->EK_TIPO"
			If RTRIM(M->EK_TIPO) == "EF" .and. aCols[n][nPosVlr] >= nFinLmCH
            Help(" ",1,"HELP",STR0229,STR0230,1,0) //"FA085A - LIMITE ITF","Pagamento disponivel apenas com Cheque ou Transfer�ncia Banc�ria."
            lRet:=.F.
    		Endif
	      If lRet .and. RTRIM(M->EK_TIPO) == "EF" .and. !Empty(aCols[n][nPosBco])
	      	If !(aCols[n][nPosBco] $ (Left(GetMv("MV_CXFIN"),TamSX3("A6_COD")[1])+"/"+GetMv("MV_CARTEIR")) .or. !IsCaixaLoja(aCols[n][nPosBco]))
					MsgAlert(STR0215+aCols[n][nPosBco]+STR0231) //" n�o recebe lan�amento do tipo EF."
					lRet:=.F.
				Endif
			Endif
    	Endif
		If lRet .and. cCampo == "M->EK_VALOR"
			If M->EK_VALOR >= nFinLmCH .and. Rtrim(aCols[n][nPosTp]) == "EF"
            Help(" ",1,"HELP",STR0229,STR0230,1,0)//"FA085A - LIMITE ITF","Pagamento disponivel apenas com Cheque ou Transfer�ncia Banc�ria."
            lRet:=.F.
    		Endif
    	Endif
		If lRet .and. cCampo == "M->EK_BANCO"
	      If !Empty(M->EK_BANCO) .and.  !(M->EK_BANCO $ (Left(GetMv("MV_CXFIN"),TamSX3("A6_COD")[1])+"/"+GetMv("MV_CARTEIR")) .or. IsCaixaLoja(M->EK_BANCO))
	     		If Rtrim(aCols[n][nPosTp]) == "EF"
					MsgAlert(STR0215+M->EK_BANCO+STR0231) //" n�o recebe lan�amento do tipo EF."
					lRet:=.F.
				Endif
			Endif
		Endif
	Endif
	If lRet	.And. !Empty(aCols[n][nPos])
		If cCampo	==	"M->EK_VALOR" .And. !Empty( aCols[n][nPosMoeda])
			a085aSaldos(aCols[n][nPosVlr],	Val(aCols[n][nPosMoeda]), 1,oSaldo,lPa)
			aCols[n][nPosVlr]	:=	&(cCampo)
			a085aSaldos(aCols[n][nPosVlr],	Val(aCols[n][nPosMoeda]), -1,oSaldo,lPa)
		ElseIf cCampo == "M->EK_BANCO"	.And. SA6->A6_COD==&(cCampo)
			a085aSaldos(aCols[n][nPosVlr], Val(	aCols[n][nPosMoeda]), 1,oSaldo,lPa)
			CarregaSA6(M->EK_BANCO,aCols[N][nPosAge],aCols[N][nPosConta],.T.)
 			nMoeda	:=	Iif(SA6->(FieldPos("A6_MOEDAP")) > 0 .And. SA6->A6_MOEDAP>0,SA6->A6_MOEDAP,SA6->A6_MOEDA)
			aCols[n][nPosMoeda]	:=	Alltrim(Str(MAX(nMoeda,1)))
			a085aSaldos(aCols[n][nPosVlr],	Val(aCols[n][nPosMoeda]), -1,oSaldo,lPa)
		ElseIf cCampo == "M->EK_AGENCIA"	.And. sA6->A6_AGENCIA==&(cCampo)
			a085aSaldos(aCols[n][nPosVlr], Val(	aCols[n][nPosMoeda]), 1,oSaldo,lPa)
			CarregaSA6(aCols[N][nPosBanco],M->EK_AGENCIA,aCols[N][nPosConta],.T.)
 			nMoeda	:=	Iif(SA6->(FieldPos("A6_MOEDAP")) > 0 .And. SA6->A6_MOEDAP>0,SA6->A6_MOEDAP,SA6->A6_MOEDA)
			aCols[n][nPosMoeda]	:=	Alltrim(Str(MAX(nMoeda,1)))
			a085aSaldos(aCols[n][nPosVlr],	Val(aCols[n][nPosMoeda]), -1,oSaldo,lPa)
		ElseIf cCampo == "M->EK_CONTA"	.And. SA6->A6_NUMCON==&(cCampo)
			a085aSaldos(aCols[n][nPosVlr], Val(	aCols[n][nPosMoeda]), 1,oSaldo,lPa)
			CarregaSA6(aCols[N][nPosBanco],aCols[N][nPosAge],M->EK_CONTA,.T.)
 			nMoeda	:=	Iif(SA6->(FieldPos("A6_MOEDAP")) > 0 .And. SA6->A6_MOEDAP>0,SA6->A6_MOEDAP,SA6->A6_MOEDA)
			aCols[n][nPosMoeda]	:=	Alltrim(Str(MAX(nMoeda,1)))
			a085aSaldos(aCols[n][nPosVlr],	Val(aCols[n][nPosMoeda]), -1,oSaldo,lPa)
		Endif
	Endif
EndIf

Return	lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �a085aRecal�Autor  �Bruno Sobieski      � Data �  10/19/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Recalcula as retencoes                                      ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function a085aRecal(nPos,aSE2,nPosJuros,nPosDesc,nRetIva,oRetIva,nRetIB,;
oRetIB,nRetGan,oRetGan,nRetISI,oRetISI,aDescontos,nRetIric,oRetIric,;
nRetSUSS,oRetSUSS,nRetSLI,oRetSLI,nValBrut,oValBrut,aRateioGan,lModif,lModPA,nRetIr,oRetIr,nRetIRC,oRetIRC,nValDesp,nRetRIE,oRetRIE,nRetIGV,oRetIGV,nRetIR4)

Local aTmp		:=	{} ,nA:=0,nP:=0,nZ:=0
Local aConGan	:=	{}
Local aSE2Tmp	:=	aClone(aSE2[nPos])
Local nJuros
Local cFornece	:=	aSE2Tmp[1][1][_FORNECE]
Local cLoja		:=	aSE2Tmp[1][1][_LOJA]
Local lNewOp 	:= .T.
Local aValZona	:= {}
Local cZona    	:= ""
Local nX:=0, nY:=0 ,nI:=0
Local nPropImp := 1
Local nProp := 1
Local lMonotrb 	:= .F.
Local nValPag  	:= 0
Local nOldIVA  	:= 0
Local nTotImp 	:= 0
Local nImpAux	:= 0
Local nRedut	:= 1/(10^MsDecimais(nMoedaCor)) //valor redutor - diferen�a de centavos
Local aImpCalc	:= {}
Local aSUSS		:= {}
Local nBaseSUSS := 0
Local aTmpIB	:= {}
Local nTTit:=0
Local nTotSuss := 0        
Local nSaldo
Local nTot :=0
Local nVlAcmPg	:= 0

DEFAULT lModif	:=	.T.
DEFAULT nPosJuros	:=	0
DEFAULT nPosDesc	:=	0
DEFAULT aRateioGan	:=	{}
DEFAULT nValDesp := 0
DEFAULT lModPA	:= .F.
DEFAULT nValBrut := 0
DEFAULT nRetGan :=0
DEFAULT nRetIB :=0
DEFAULT nRetIva :=0
DEFAULT nRetRIE :=0

//Verifica se o fornecedor � monotributista
dbSelectArea("SA2")
dbGoTop()
dbSetOrder(1)
If lMsFil .And. !Empty(xFilial("SA2")) .And. xFilial("SF1") == xFilial("SE2")
	SE2->(DbGoTo(aSE2Tmp[1][1][_RECNO]))
	SA2->(dbSeek(SE2->E2_MSFIL+cFornece+cLoja))
Else
	SA2->(dbSeek(xFilial("SA2")+cFornece+cLoja))
Endif
If SA2->(Found())
     lMonotrb := Iif(SA2->A2_TIPO == "M" .And. SA2->(FieldPos("A2_CMONGAN"))>0,.T.,.F.)
Endif

ProcRegua(Len(aSE2Tmp))
DbSelectArea("SE2")
nTotVL:=0
nTotPA:=0
nTotNF:=0
aTotIva:={}

If lRetPA == Nil
	lRetPA := (GetNewPar("MV_RETPA","N") == "S")
EndIf
If Type("nValDesc")=="U"
	nValDesc:=0
EndIf

For nA:=1	To	Len(aSE2Tmp[1])
	SE2->(MsGoto(aSE2Tmp[1][nA][_RECNO]))
	aAdd(aImpCalc, {})

	If lModif .And. Type("aCols")<>"U"
		nJuros	:=	IIf(nPosJuros > 0, aCols[nA][nPosJuros],0)
		aSE2Tmp[1][nA][_PAGAR  ]	:=	aCols[nA][1]
		aSE2Tmp[1][nA][_JUROS  ]	:= nJuros
		aSE2Tmp[1][nA][_DESCONT] 	:= aDescontos[nA]
		If cPaisLoc == "PAR"
			aSE2Tmp[1][nA][_SALDO1 ]	:=	aCols[nA][2]
		EndIf	
	Endif

	If cPaisLoc $ "URU|BOL" .And. !(SE2->E2_TIPO $ MVPAGANT + "/"+ MV_CPNEG)
		aTmp	:=	CalcRetIric(cAgente,,aSE2Tmp[1][nA][_PAGAR])
		If Len(aTmp) > 0
			aSE2Tmp[1][nA][_RETIRIC] :=aClone(aTmp)
		Endif

		aTmp:={}
		aTmp	:=	CalcRetIr(cAgente,,aSE2Tmp[1][nA][_PAGAR])
		If Len(aTmp) > 0
			aSE2Tmp[1][nA][_RETIR] :=aClone(aTmp)
		Endif

	EndIf
	If cPaisLoc == "PTG"
		//+----------------------------------------------------------------+
		//� Generar las Retenci�n de IVA.                                  �
		//+----------------------------------------------------------------+
		If (SE2->E2_TIPO $ MVPAGANT + "/"+ MV_CPNEG)
			aTmp	:=	CalcRetIV2(cAgente,-1,aSE2Tmp[1][nA][_PAGAR ],nProp)
		Else
			aTmp	:=	CalcRetIVA(cAgente,,aSE2Tmp[1][nA][_PAGAR  ],,,,nProp)
		Endif
		If Len(aTmp) > 0
			aSE2Tmp[1][nA][_RETIVA]	:=aClone(aTmp)
		Endif

		//+----------------------------------------------------------------+
		//� Generar las Retenci�n de IRC.                                  �
		//+----------------------------------------------------------------+
		aTmp	:=	CalcRetIRC(Iif(SE2->E2_TIPO $ MVPAGANT + "/"+ MV_CPNEG,-1,1),aSE2Tmp[1][nA][_PAGAR  ])
		If Len(aTmp) > 0
			aSE2Tmp[1][nA][_RETIRC]	:=aClone(aTmp)
		Endif

	Endif
	If cPaisLoc == "ANG"
		//+----------------------------------------------------------------+
		//� Retencoes de Imposto sobre Empreitadas	                      �
		//+----------------------------------------------------------------+
		If (SE2->E2_TIPO $ MVPAGANT + "/"+ MV_CPNEG)
			aTmp	:=	CalcRetRIE(aSE2Tmp[1][nA][_PAGAR ],.T.,-1)
		Else
			aTmp	:=	CalcRetRIE(aSE2Tmp[1][nA][_PAGAR ])
		Endif
		If Len(aTmp) > 0
			aSE2Tmp[1][nA][_RETRIE]	:=aClone(aTmp)
		Endif

	Endif
   	If cPaisLoc == "PER"
		aTmp := {}
		aTmp := FA085RetIR(aSE2Tmp[1][nA][_PAGAR])
		aSE2Tmp[1][nA][_RETIR] := aClone(aTmp)
	Endif
	
	If cPaisLoc == "PAR" 
		//+----------------------------------------------------------------+
		//� Generar las Retenci�n de IVA.                                  �
		//+----------------------------------------------------------------+
		If (SE2->E2_TIPO $ MVPAGANT + "/"+ MV_CPNEG)
			aTmp	:=	CalcRetIV2(cAgente,-1,aSE2Tmp[1][nA][_PAGAR ],nProp)
		Else
			aTmp	:=	CalcRetIVA(cAgente,,aSE2Tmp[1][nA][_PAGAR  ],,,,nProp)
		Endif
		If Len(aTmp) > 0
			aSE2Tmp[1][nA][_RETIVA]	:=aClone(aTmp)
		Endif
	 
   		//+----------------------------------------------------------------+
		//� Generar las Retenci�n de IR.                                  �
		//+----------------------------------------------------------------+
		aTmp:={}   
		If (SE2->E2_TIPO $ MVPAGANT + "/"+ MV_CPNEG)
			aTmp	:=	CalcRetIr2(cAgente,-1,aSE2Tmp[1][nA][_PAGAR ],nProp)
		Else
    		aTmp	:=	CalcRetIr(cAgente,,aSE2Tmp[1][nA][_PAGAR])
		EndIf        
		
		If Len(aTmp) > 0
			aSE2Tmp[1][nA][_RETIR] :=aClone(aTmp)
		Endif
	 EndIf

	nValPag += 	aSE2Tmp[1][nA][_PAGAR]

Next

// Verifica a aplicacao de retencao de ingresos brutos, sobre o total dos pagamentos efetuados.
lNewOp := .T.

If lModif
	nOldIva	 := nRetIva
	nRetIva	 := 0
	nRetIB	 := 0
	nRetGan	 := 0
	nRetISI	 := 0
	nRetIric := 0
	nRetIr	 := 0
	nRetIrc	 := 0
	nRetSUSS := 0
	nRetSLI  := 0
	nTotNCC  := 0
	nVlAcmPg	:= 0
	For nA	:=	1	To	Len(aSE2TMP[1])
		If aSE2TMP[1][nA][_TIPO] $ MVPAGANT + "/" + MV_CPNEG
			If SE2->E2_TXMOEDA <> SM2->M2_MOEDA2 .and. Round(aSE2TMP[1][nA][21]*SE2->E2_TXMOEDA,MsDecimais(nMoedaCor))==aSE2TMP[1][nA][6]
				nTotNCC += Round(xMoeda(aSE2TMP[1][nA][_PAGAR],aSE2TMP[1][nA][_MOEDA],nMoedaCor,,5,SE2->E2_TXMOEDA,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Else
				If cPaisLoc $ "PAR|CHI|URU|BOL"
					If READVAR()=="M->E2_PAGAR"
						nTotNCC += M->E2_PAGAR	
					ElseIf READVAR()== "M->NVLMDINF"
						nTotNCC += M->NVLMDINF
					EndIf
				Else
					nTotNCC += Round(xMoeda(aSE2TMP[1][nA][_PAGAR],aSE2TMP[1][nA][_MOEDA],nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
				EndiF	
			EndIf
		Endif
		
		If cPaisLoc $ "URU|BOL"
			For nP	:=	1	To	Len(aSE2TMP[1][nA][_RETIRIC])
				nRetIric	+=	Round(xMoeda(aSE2TMP[1][nA][_RETIRIC][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next nP

			For nP	:=	1	To	Len(aSE2TMP[1][nA][_RETIR])
				nRetIr	+=	Round(xMoeda(aSE2TMP[1][nA][_RETIR][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next nP

		EndIf
		If cPaisLoc == "PTG"
			For nP	:=	1	To	Len(aSE2TMP[1][nA][_RETIRC])
				nRetIRC	+=	Round(xMoeda(aSE2TMP[1][nA][_RETIRC ][nP][5],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next
			For nP	:=	1	To	Len(aSE2TMP[1][nA][_RETIVA])
				nRetiva	+=	Round(xMoeda(aSE2TMP[1][nA][_RETIVA][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next nP
		Endif
		//ANGOLA
		If cPaisLoc == "ANG"
			For nP	:=	1	To	Len(aSE2TMP[1][nA][_RETRIE])
				nRetRIE	+=	Round(xMoeda(aSE2TMP[1][nA][_RETRIE ][nP][5],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next
		Endif
		If cPaisLoc == "PAR"
			For nP	:=	1	To	Len(aSE2TMP[1][nA][_RETIVA])
				nRetiva	+=	Round(xMoeda(aSE2TMP[1][nA][_RETIVA][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
				nVlAcmPg += Round(xMoeda(aSE2TMP[1][nA][_RETIVA][nP][7],aSE2TMP[1][nA][_MOEDA],1,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))  - nRetiva //Round(xMoeda(aSE2TMP[1][nA][_RETIVA][nP][3],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next nP  
			
			For nP	:=	1	To	Len(aSE2TMP[1][nA][_RETIR])
				nRetIr	+=	Round(xMoeda(aSE2TMP[1][nA][_RETIR][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next nP 
		EndIf
	Next nA
	
	nValPag := 0
	If cPaisLoc $ "URU"
		nValLiq		:=	nValBrut - nValDesc - nRetIric - nRetIr
	ElseIf cPaisLoc $ "BOL"
		nValLiq		:=	nValBrut - nValDesc - nRetIric - nRetIr - nTotNCC
	ElseIf cPaisLoc == "PTG"
		nValLiq		:=	nValBrut - nValDesc - nRetIrc - nRetIva + nValDesp
	//ANGOLA
	ElseIf cPaisLoc == "ANG"
		nValLiq		:=	nValBrut - nValDesc - nRetRIE
	ElseIf cPaisLoc == "PAR"	                       
		nValLiq		:=	nValBrut - nRetIVA - nRetIr 
	EndIf

	If oRetIva != Nil
		oRetIva:Refresh()
	EndIf
	If oRetIB != Nil
		oRetIB:Refresh()
	EndIf
	If oRetGan != Nil
		oRetGan:Refresh()
	EndIf
	If oRetSUSS != Nil
		oRetSUSS:Refresh()
	EndIf
	If oRetSLI != Nil
		oRetSLI:Refresh()
	EndIf
	If oRetISI != Nil
		oRetISI:Refresh()
	EndIf
	If oRetIric != Nil
		oRetIric:Refresh()
	EndIf
	If oRetIr != Nil
		oRetIr:Refresh()
	EndIf
	If oRetIrc != Nil
		oRetIrc:Refresh()
	EndIf
	If oValBrut	!= Nil
		oValBrut:Refresh()
	Endif
	If oValLiq != Nil
		oValLiq:Refresh()
	Endif
	//ANGOLA
	If oRetRIE != Nil
		oRetRIE:Refresh()
	EndIf
Else
	If cPaisLoc == "ARG" .Or. cPaisLoc $ "URU|BOL|PTG|ANG"	//ANGOLA
		aSE2[nPos]	:=	aClone(aSE2Tmp)
	Endif

	nValOrdens	-=	aPagos[nPos][H_TOTALVL]

	Fa085atuVl(@oValOrdens,@nValOrdens,@aPagos,aSE2)

	If aSE2[nPos][3] <> Nil .And. aSE2[nPos][3][1]	==	4 .and. !lModPA
		A085aPagos(aSE2[nPos][1],aSE2[nPos][2],nPos,@aSE2,oDlg,.T.)
	Endif

Endif
lRetenc	:=	.T.

Return aSE2TMP

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �a085aPagos�Autor  �Bruno Sobieski      � Data �  10/19/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Permitir a escolha de outra forma de pagamento diferente a  ���
���          � definida para todas as ordens de pagamento, para a orden de���
���          � pago selecionada.                                          ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function a085aPagos(aTits,aGan,nPos,aSE2,oObj,lModif)
Local aCpos	:=	{}
Local oPagar
Local oGetDad,oDlg
Local lConfirmo	:=	.F.
Local cTmp	:=	""
Local oBAnco,oAgencia,oConta
Local oFnt
Local oDataTxt1,oTipo
Local oDataTxt2
Local oChkBox,lBaixaChq	:=	.F.
Local oDataVenc,oDataVenc1
Local cDebMed
Local cDebInm
Local dDataVenc	:=	dDataBase
Local dDataVenc1:=	dDataBase
Local oCbx1,oCbx2
Local nX,nP,nA,nI
Local aSE2Bkp	:=	aClone(aSE2[nPos])
Local cMoeda	:=	MV_MOEDA1
Local nValorPago:=  0
Local oValorPg,oMsg,oMsg1,oMoedaPA
Local nValorTit :=0
Local nRetGan	:= 0
Local nPosValor :=	 0
Local nValDif	:=0
Local nD :=1
Local nXPagar	:=	0
Local lOculta := .F.
Local cTipOp := ""
Local lF85NoInfo := ExistBlock("F85NOINFO")
DEFAULT lModif	:=	.F.
Static aHeader2

If lF85NoInfo
	lOculta := ExecBlock("F85NOINFO",.F.,.F.)
EndIf

If lRetPA == Nil
	lRetPA := (GetNewPar("MV_RETPA","N") == "S")
EndIf

//���������������������������������������������������������������Ŀ
//�Sao definidas como privates pois devem ser enxergadas desde as �
//�funcooes de validacao e refresh. Bruno.                        �
//�����������������������������������������������������������������
Private cBanco:=Criavar("A6_COD"),cAgencia	:=	Criavar("A6_AGENCIA"),cConta:=Criavar("A6_NUMCON")
Private aDebMed:={},aDebInm:={}
Private nPagar	:=If(!(cPaisLoc $ "EQU|DOM|COS"),1,0)
Private oSaldo,oTxt1 ,oValor
Private aSaldos	:=	{}
Private aRecChqTer:=	{}
Private cCodFor	:= aTits[1][_FORNECE]
Private cLojaFor:= aTits[1][_LOJA]
Private aVlPA	:={0,0,0,0}

If cPaisLoc $ "EQU|DOM|COS"
	nPagar	:=	0
Endif

If cPaisLoc $ 'MEX|PER'
	cTipOp:= POSICIONE("SED",1,xFilial("SED")+SE2->E2_NATUREZ ,"ED_OPERADT")
	//Valida Modalidad de operaci�n 
	If cTipOp == '1'
		MSGALERT(STR0261, "") //Opci�n No disponible para Anticipos
		Return
	EndIf	
EndIf
aVlPA[_PA_MOEATU]:=1

//��������������������������������������������������������������������������Ŀ
//�Carregar os tipos definidos no SES para a ordem de pago pelo campo        �
//�ES_RCOPGER, que indica que tipo de movimento vai gerar o tipo (BANCARIO ou�
//�TITULO A PAGAR)                                                           �
//����������������������������������������������������������������������������
cTmp  := GetSESTipos({|| ES_RCOPGER == "1"},"2")
While	!Empty(cTmp)
	AAdd(aDebMed,Substr(cTmp,1,tamSx3("E2_TIPO")[1]))
	cTmp	:=	Substr(cTmp,tamSx3("E2_TIPO")[1]+2)
Enddo
If Len(aDebMed) ==	0
	aDebMed	:=	{MVCHEQUE}
Endif
cDebMed	:=	aDebMed[1]

cTmp  := GetSESTipos({|| ES_RCOPGER == "2"},"2")
While	!Empty(cTmp)
   AAdd(aDebInm,Substr(cTmp,1,tamSx3("E2_TIPO")[1]))
	cTmp	:=	Substr(cTmp,tamSx3("E2_TIPO")[1]+2)
Enddo
If Len(aDebInm) ==	0
	If Ascan(aDebmed,"TF") = 0
	   AAdd(aDebInm,"TF")
	EndIf
	If Ascan(aDebMed,"EF") = 0
	   AAdd(aDebInm,"EF")
	EndIf
	If Len(aDebInm) ==	0
	   AAdd(aDebInm,"")
	EndIf
Endif
cDebInm	:=	aDebInm[1]

//��������������������������������������������Ŀ
//�Inicializar o aHeader e o aCols.            �
//����������������������������������������������
//Se o aHeader nao foi definido ainda, defino ele aqui SO UMA VEZ POR SESSAO. Bruno
If aHeader2	==	Nil
	aHeader2 	:=	{}
	cTipos		:=	""
	If ExistBlock("A085CPOS")
		aHeader2	:=	ExecBlock("A085CPOS",.F.,.F.)
	Else
		DbSelectArea("SX3")
		DbSetOrder(2)
		DbSeek("EK_TIPODOC")
		Aadd(aHeader2,{OemToAnsi(x3titulo()),"EK_TIPODOC"   ,"9",X3_TAMANHO ,X3_DECIMAL,'PERTENCE("123").And.A085aVlds()',X3_usado,"C","SEK"})
		DbSeek("EK_TIPO")
		Aadd(aHeader2,{OemToAnsi(x3titulo()),"EK_TIPO"   ,X3_PICTURE,X3_TAMANHO ,X3_DECIMAL,'A085aVlds(aDebMed,aDebInm)',X3_usado,"C","SEK"})
		DbSeek("EK_NUM")
		Aadd(aHeader2,{OemToAnsi(x3titulo()),"EK_NUM" 	 ,X3_PICTURE,X3_TAMANHO,X3_DECIMAL, ".T.",X3_usado,"C","SEK"})
		DbSeek("EK_VALOR")
		Aadd(aHeader2,{OemToAnsi(x3titulo()),"EK_VALOR"  , PesqPict("SEK","EK_VALOR"),X3_TAMANHO,X3_DECIMAL,".T.",X3_usado,"N","SEK"})
		DbSeek("EK_MOEDA")
		Aadd(aHeader2,{OemToAnsi(x3titulo()),"EK_MOEDA"  ,X3_PICTURE, X3_TAMANHO ,X3_DECIMAL,'.F.',X3_usado,"C","SEK"})
		DbSeek("EK_EMISSAO")
		Aadd(aHeader2,{OemToAnsi(x3titulo()),"EK_EMISSAO",X3_PICTURE, X3_TAMANHO,X3_DECIMAL,".T.",X3_usado,"D","SEK"})
		DbSeek("EK_VENCTO")
		Aadd(aHeader2,{OemToAnsi(x3titulo()),"EK_VENCTO" ,X3_PICTURE, X3_TAMANHO,X3_DECIMAL,"M->EK_VENCTO  >= aCols[N][6].And.A085aVlds()" ,X3_usado,"D","SEK"})
		DbSeek("EK_BANCO")
		Aadd(aHeader2,{OemToAnsi(x3titulo()),"EK_BANCO"  ,X3_PICTURE,X3_TAMANHO ,X3_DECIMAL,'a085aVlds()',X3_usado,"C","SEK"})
		DbSeek("EK_AGENCIA")
		Aadd(aHeader2,{OemToAnsi(x3titulo()),"EK_AGENCIA",X3_PICTURE,X3_TAMANHO ,X3_DECIMAL,'a085aVlds()',X3_usado,"C","SEK"})
		DbSeek("EK_CONTA")
		Aadd(aHeader2,{OemToAnsi(x3titulo()),"EK_CONTA"  ,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,'a085aVlds()',X3_usado,"C","SEK"})
		DbSeek("EK_PARCELA")
		Aadd(aHeader2,{OemToAnsi(x3titulo()),"EK_PARCELA"  ,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,'a085aVlds()',X3_usado,"C","SEK"})
		//Inclus�o do campo debito automatico
		If DbSeek("EK_DEBITO")
			Aadd(aHeader2,{OemToAnsi(x3titulo()),"EK_DEBITO"  ,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,'a085aVlds()',X3_usado,"C","SEK"})
		Endif
	EndIf
Endif

aHeader	:=	aClone(aHeader2)
nPosValor 	:=	 Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_VALOR"})
nPosMoe		:=	Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_MOEDA"})
//�������������������������������������������������������������������Ŀ
//�Se o tipo for 4 (Informado) e ja passou por esta rotina, carrego o �
//�aCols que tinha sido escolhido.                                    �
//���������������������������������������������������������������������
DbSelectArea("SX3")
DbSetOrder(2)
If aSE2[nPos][3]==Nil.Or.aSE2[nPos][3][1] <> 4
	aCols	:=	Array(1,Len(aHeader)+1)
	For nA := 1 To Len(aHeader)
		If DbSeek(aHeader[nA][2])
			nA := nA
			aCols[1][nA] := Criavar(AllTrim(aHeader[nA][2]))
		EndIf
	Next nA
	aCols[1][Len(aCols[1])]	:=	.F.
Endif
If aSE2[nPos][3] <> Nil
	nPagar	:=	aSE2[nPos][3][1]
	If nPagar	<>	4
		cBanco	:=	aSE2[nPos][3][2]
		cAgencia:=	aSE2[nPos][3][3]
		cConta	:=	aSE2[nPos][3][4]
	Endif
	Do Case
		Case nPagar	==	1
			dDataVenc1	:=	aSE2[nPos][3][5]
		Case nPagar	==	2
			dDataVenc	:=	aSE2[nPos][3][5]
			cDebMed		:=	aSE2[nPos][3][6]
			lBaixaChq	:=	aSE2[nPos][3][7]
		Case nPagar	==	3
			cDebInm		:= aSE2[nPos][3][5]
		Case nPagar	==	4
			aCols		:=	aClone(aSE2[nPos][3][2])
			aRecChqTer	:=	aClone(aSE2[nPos][3][3])
			aVlPA[_PA_VLANT]	:=	aSE2[nPos][3][6]
			aVlPA[_PA_VLATU]	:=	aSE2[nPos][3][6]
			aVlPA[_PA_MOEANT]	:=	aSE2[nPos][3][7]
			aVlPA[_PA_MOEATU]	:=	aSE2[nPos][3][7]
	EndCase
Endif
DEFINE FONT oFnt  NAME "Arial" SIZE 09,11 BOLD

//����������������������������������������������������������������������������Ŀ
//�Obter o total da OP moeda por moeda, para evitar problemas de arredondamento�
//�na validacao dos valores ingresados para o pago e total da OP.              �
//������������������������������������������������������������������������������
aSaldos	:=	Array(MoedFin()+1)
aFill(aSaldos,0)
For nX	:=	1	To	Len(aTits)
	If cPaisLoc=="CHI"
		aSaldos[aTits[nX][_MOEDA]]	+=	Round(xMoeda((aTits[nX][_PAGAR] * (IIf(aTits[nX][_TIPO]$ MVPAGANT+"/"+MV_CPNEG,-1,1))),aTits[nX][_MOEDA],nMoedacor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
	Else
		aSaldos[aTits[nX][_MOEDA]]	+=	aTits[nX][_PAGAR] * (IIf(aTits[nX][_TIPO]$ MVPAGANT+"/"+MV_CPNEG,-1,1))
	Endif

    If aVlPA[_PA_VLANT] > 0
				nValorPago += Round(xMoeda(aTits[nX][_PAGAR],aTits[nX][_MOEDA],aVlPA[_PA_MOEANT],,5,aTxMoedas[aTits[nX][_MOEDA]][2],aTxMoedas[aVlPA[_PA_MOEANT]][2]),MsDecimais(aVlPA[_PA_MOEANT])   )

	EndIf

	//����������������������������������������������������Ŀ
	//�Tirar retencoes de ingresos Brutos e IVA (ARGENTINA)�
	//������������������������������������������������������
	If cPaisLoc $ "URU|BOL"
		For nP	:=	1	To	Len(aTits[nX][_RETIRIC])
			aSaldos[1]	-=	Round(aTits[nX][_RETIRIC ][nP][6],MsDecimais(nMoedaCor))
		Next nP

		For nP	:=	1	To	Len(aTits[nX][_RETIR])
			aSaldos[1]	-=	Round(aTits[nX][_RETIR ][nP][6],MsDecimais(nMoedaCor))
		Next nP
	ElseIf cPaisLoc == "PTG"
		For nP	:=	1	To	Len(aTits[nX][_RETIRC])
			aSaldos[1]	-=	Round(aTits[nX][_RETIRC ][nP][5],MsDecimais(nMoedaCor))
		Next
		For nP	:=	1	To	Len(aTits[nX][_RETIVA])
			aSaldos[1]	-=	Round(aTits[nX][_RETIVA ][nP][6],MsDecimais(nMoedaCor))
		Next nP
	//ANGOLA
	ElseIf cPaisLoc == "ANG"
		For nP	:=	1	To	Len(aTits[nX][_RETRIE])
			aSaldos[1]	-=	Round(aTits[nX][_RETRIE ][nP][5],MsDecimais(nMoedaCor))
		Next
	ElseIf cPaisLoc == "PAR"
		For nP	:=	1	To	Len(aTits[nX][_RETIVA])
			aSaldos[1]	-=	Round(aTits[nX][_RETIVA ][nP][6],MsDecimais(nMoedaCor))
		Next nP
	Endif
Next

If aVlPA[_PA_VLANT] > 0
	nValorPago := 	nValorPago  + Round(xMoeda(aVlPA[_PA_VLANT],aVlPA[_PA_MOEANT],nMoedaCor,,5,aTxMoedas[aVlPA[_PA_MOEANT]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
EndIf

If nPosValor > 0
	For nI:=1 to Len(aCols)
		nValorTit:= nValorTit+ Round(xMoeda(aCols[nI][nPosValor],Val(aCols[nI][nPosMoe]),nMoedaCor,,5,aTxMoedas[Val(aCols[nI][nPosMoe])][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
	Next
EndIf

If aVlPA[_PA_VLANT] <> 0
	If nValorPago >0
		aSaldos[aVlPA[_PA_MOEANT]]  := 0
		If nValorTit >0
			nValDif := nValorTit - (nValorPago - nRetGan)   // aSaldos[aVlPA[_PA_MOEANT]] - ( nValorPago - aVlPA[_PA_VLANT])
		Else
			nValDif := aSaldos[aVlPA[_PA_MOEANT]] - ( nValorPago - aVlPA[_PA_VLANT])
		EndIf
	Else
		aSaldos[aVlPA[_PA_MOEANT]]  += aVlPA[_PA_VLANT]
	EndIf
Else
	aSaldos[nMoedaCor] -= nValorTit
EndIf

If cPaisLoc == "PTG"
	For nD	:=	1	To Len(aSe2[1][4])
   		aSaldos[Len(aSaldos)] += Round(xMoeda(aSE2[1,4,nD,2],Val(aSE2[1,4,nD,3]),nMoedaCor,dDataBase,5,aTxMoedas[Val(aSE2[1,4,nD,3])][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
	Next
EndIf

//��������������������������������������Ŀ
//�Tirar retencao de ganacias (Argentina)�
//����������������������������������������


//�����������������������������������������������������������Ŀ
//�Calculo o saldo total na moeda corrente e guardo na ultima �
//�posicao do array de saldos                                 �
//�������������������������������������������������������������
For nP	:=	1	To Len(aTxMoedas)
	If cPaisLoc=="CHI"
		aSaldos[Len(aSaldos)] += Round(aSaldos[nP],MsDecimais(nMoedaCor))
	Else
		aSaldos[Len(aSaldos)] += Round(xMoeda(aSaldos[nP],nP,nMoedaCor,,5,aTxMoedas[nP][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
	EndIf
Next

For nP	:=	1	To Len(aCols)
	a085aSaldos(nValDif,nMoedaCor, -1,oSaldo)
Next

If ExistBlock("A085DEFS")
	ExecBlock("A085DEFS",.F.,.F.,"2")
Endif

DEFINE MSDIALOG oDlg FROM 30,40  TO 420,633 TITLE OemToAnsi(STR0063) Of oObj PIXEL  // "Ordenes de pago"

//����������������������������������������������������������Ŀ
//�Informar o tipo de documento com que vamos pagar e o banco�
//������������������������������������������������������������
@ 17,004 To 100,290 Pixel Of  oDlg LABEL OemToAnsi(STR0083) //"Pagar con"
If cPaisLoc $ "EQU|DOM|COS"
	@ 25,006  RADIO oPagar VAR nXPagar 3D ;
	SIZE 120,10 ;
	ITEMS OemToansi(STR0084), OemToAnsi(STR0085),OemToAnsi(STR0086),OemToAnsi(STR0115) ; //"Cheque Pre-Impreso"###"Debito diferido"###"Debito Inmediato"###"Informar"
	ON CHANGE { || oGetDad:OBROWSE:LACTIVE	:=	(nPagar==4),oGetDad:OBROWSE:LNOPAINT	:=	(nPagar<>4),oGetDad:OBROWSE:Refresh() ,;
	a085aRefr(If(nXPagar==1,Eval({||nPagar:=2,nPagar}),If(nXPagar==2,Eval({||nPagar:=3,nPagar}),nPagar)),@oCbx1,@oCbx2,@oDataVenc,@oDataVenc1,@oChkBox,@oDataTxt1,@oDataTxt2,@oTipo,@oMsg,@oSaldo,@oTxt1,@oBanco,@oAgencia,@oConta,,,,,,,@oMsg1,@oValorPg,@oMoedaPA) };
	OF oDlg Pixel
Else
	If lF085aChS
		If lOculta
			@ 25,006  RADIO oPagar VAR nPagar 3D ;
			SIZE 120,10 ;
			ITEMS OemToAnsi(STR0085),OemToAnsi(STR0086); //"Cheque Pre-Impreso"###"Debito diferido"###"Debito Inmediato"###"Informar"
			ON CHANGE { || oGetDad:OBROWSE:LACTIVE	:=	(nPagar==4),oGetDad:OBROWSE:LNOPAINT	:=	(nPagar<>4),oGetDad:OBROWSE:Refresh() ,;
			a085aRefr(nPagar,@oCbx1,@oCbx2,@oDataVenc,@oDataVenc1,@oChkBox,@oDataTxt1,@oDataTxt2,@oTipo,@oMsg,@oSaldo,@oTxt1,@oBanco,@oAgencia,@oConta,,,,,,,@oMsg1,@oValorPg,@oMoedaPA) };
			OF oDlg Pixel
		Else
			@ 25,006  RADIO oPagar VAR nPagar 3D ;
			SIZE 120,10 ;
			ITEMS OemToAnsi(STR0085),OemToAnsi(STR0086),OemToAnsi(STR0115) ; //"Cheque Pre-Impreso"###"Debito diferido"###"Debito Inmediato"###"Informar"
			ON CHANGE { || oGetDad:OBROWSE:LACTIVE	:=	((nPagar==4 .Or. (nPagar == 3 .And. lF085aChs))),oGetDad:OBROWSE:LNOPAINT	:=	(nPagar<>4 .AND. !(nPagar == 3 .And. lF085aChs)),oGetDad:OBROWSE:Refresh() ,;
			a085aRefr(nPagar,@oCbx1,@oCbx2,@oDataVenc,@oDataVenc1,@oChkBox,@oDataTxt1,@oDataTxt2,@oTipo,@oMsg,@oSaldo,@oTxt1,@oBanco,@oAgencia,@oConta,,,,,,,@oMsg1,@oValorPg,@oMoedaPA) };
			OF oDlg Pixel
		EndIf
	Else
		If lOculta
			@ 25,006  RADIO oPagar VAR nPagar 3D ;
			SIZE 120,10 ;
			ITEMS OemToansi(STR0084), OemToAnsi(STR0085),OemToAnsi(STR0086); //"Cheque Pre-Impreso"###"Debito diferido"###"Debito Inmediato"###"Informar"
			ON CHANGE { || oGetDad:OBROWSE:LACTIVE	:=	(nPagar==4),oGetDad:OBROWSE:LNOPAINT	:=	(nPagar<>4),oGetDad:OBROWSE:Refresh() ,;
			a085aRefr(nPagar,@oCbx1,@oCbx2,@oDataVenc,@oDataVenc1,@oChkBox,@oDataTxt1,@oDataTxt2,@oTipo,@oMsg,@oSaldo,@oTxt1,@oBanco,@oAgencia,@oConta,,,,,,,@oMsg1,@oValorPg,@oMoedaPA) };
			OF oDlg Pixel
		Else
			@ 25,006  RADIO oPagar VAR nPagar 3D ;
			SIZE 120,10 ;
			ITEMS OemToansi(STR0084), OemToAnsi(STR0085),OemToAnsi(STR0086),OemToAnsi(STR0115) ; //"Cheque Pre-Impreso"###"Debito diferido"###"Debito Inmediato"###"Informar"
			ON CHANGE { || oGetDad:OBROWSE:LACTIVE	:=	(nPagar==4),oGetDad:OBROWSE:LNOPAINT	:=	(nPagar<>4),oGetDad:OBROWSE:Refresh() ,;
			a085aRefr(nPagar,@oCbx1,@oCbx2,@oDataVenc,@oDataVenc1,@oChkBox,@oDataTxt1,@oDataTxt2,@oTipo,@oMsg,@oSaldo,@oTxt1,@oBanco,@oAgencia,@oConta,,,,,,,@oMsg1,@oValorPg,@oMoedaPA) };
			OF oDlg Pixel
		EndIf
	EndIf
Endif

//���������������Ŀ
//�Digitar o banco�
//�����������������
@ 25,160 To 68,285 Pixel Of  oDlg LABEL OemToAnsi(STR0091) //"Banco"

@ 030,164 SAY OemToAnsi(STR0091) 		 SIZE 19, 7 OF oDlg PIXEL //"Banco"
@ 030,193 SAY OemToAnsi(STR0092) 		 SIZE 25, 7 OF oDlg PIXEL //"Agencia"
@ 030,225 SAY OemToAnsi(STR0093) 		 SIZE 20, 7 OF oDlg PIXEL //"Cuenta"

@ 038,165 MSGET oBanco   VAR cBanco		F3 "SA6" Picture "@S3"    Valid CarregaSa6(@cBanco,@cAgencia,@cConta,.F.) 	.And. (ExistCpo("SA6",cBanco+cAgencia+cConta ) .AND. IF(lRetCkPG(0,cDebInm,cBanco,nPagar),.T.,.T.) .Or.Empty(cBanco  )) .And. If(CCBLOCKED(cBanco,cAgencia,cConta),.F.,.T.) SIZE 10, 10 OF oDlg PIXEL WHEN nPagar<>4 HASBUTTON
@ 038,193 MSGET oAgencia VAR cAgencia	Picture "@S5"             Valid CarregaSa6(@cBanco,@cAgencia,@cConta,.F.)	.And. (ExistCpo("SA6",cBanco+cAgencia+cConta ).Or.Empty(cAgencia)) .And. If(CCBLOCKED(cBanco,cAgencia,cConta),.F.,.T.) SIZE 20, 10 OF oDlg PIXEL	WHEN nPagar<>4
@ 038,225 MSGET oConta   VAR cConta		Picture "@S10"            Valid CarregaSa6(@cBanco,@cAgencia,@cConta,.F.)	.And. (ExistCpo("SA6",cBanco+cAgencia+cConta ).Or.Empty(cConta)) .And. If(CCBLOCKED(cBanco,cAgencia,cConta),.F.,.T.) SIZE 45, 10 OF oDlg PIXEL	WHEN nPagar<>4

@ 070,010 To 95,285 Pixel Of  oDlg LABEL OemToAnsi(STR0087) //"Datos del titulo de pago"
//��������������������������������������������Ŀ
//�Escolher o vencimento do cheque pre-impresso�
//����������������������������������������������
@ 080,015 SAY oDataTxt1 Var OemToAnsi(STR0088) SIZE 50,10 OF	oDlg PIXEL //"Fecha para el debito "
@ 080,080 GET oDataVenc1 VAR dDataVenc1 Valid (dDataVenc1 >= dDataBase)	SIZE 34,09 OF	oDlg PIXEL

@ 080,015 SAY oTipo VAR OemToAnsi(STR0089) SIZE 10,10 OF oDlg PIXEL //"Tipo "

@ 080,030 COMBOBOX oCBX1 VAR cDebMed ITEMS aDebMed VALID IF(lRetCkPG(0,cDebInm,cBanco,nPagar),.T.,.T.) SIZE 50,50 OF oDlg PIXEL

//������������������������������������Ŀ
//�Escolher o titulo de debito diferido�
//��������������������������������������
@ 080,090 SAY oDataTxt2 VAR OemToAnsi(STR0088) SIZE 50,10 OF	oDlg PIXEL //"Fecha para el debito "
@ 080,150 GET oDataVenc VAR dDataVenc Valid (dDataVenc >= dDataBase)	SIZE 34,09 OF	oDlg PIXEL
@ 075,200 CHECKBOX oChkBox Var lBaixaChq	PROMPT OemToAnsi(STR0090) SIZE 80,16 PIXEL When (dDataVenc==dDataBase) Of oDlg //"� Debitar los titulos ahora ? "

//Box para escolher o titulo de debito Inmediato
@ 080,030 COMBOBOX oCBX2 VAR cDebInm ITEMS aDebInm VALID IF(lRetCkPG(0,cDebInm,cBanco,nPagar),.T.,.T.) SIZE 50,50  OF oDlg PIXEL When (nPagar==3)
//Mensagen para digitar os titulos informados

If !lRetPA
	@ 078,015 SAY oMsg Var OemToAnsi(STR0116) SIZE 265,16 COLOR CLR_BLUE FONT oFnt Of oDlg PIXEL //"Escoja en la lista abajo los titulo que seran entregados para el pago."
Else
	@ 080,015 SAY oMsg Var OemToAnsi(STR0164) SIZE 210,16 COLOR CLR_BLUE FONT oFnt Of oDlg PIXEL //"Escoja en la lista abajo los titulo que seran entregados para el pago." //"Inf.Valor a Pagar"
	@ 078,090 GET oValorPg Var nValorPago Valid (a085aSaldVl(@oSaldo,@oValorPg,nValorPago,aSE2,nPos,@oValorPg,lModIf)) Picture TM( nValorPago,16,nDecs)	 SIZE 60,09 OF	oDlg PIXEL
	@ 080,150 SAY oMsg1 Var OemtoAnsi(STR0165) SIZE 30, 07 COLOR CLR_BLUE FONT oFnt OF 	oDlg PIXEL         //"Exibir valores em : " //"Moeda :"
	@ 078,210 COMBOBOX oMoedaPA VAR cMoeda ITEMS aMoeda   ON CHANGE (aVlPA[_PA_MOEATU]:=oMoedaPA:nAt,nDecs:=MsDecimais(aVlPA[_PA_MOEATU]),(a085aSaldVl(@oSaldo,,nValorPago,aSE2,nPos,@oValorPg,lModif))) SIZE 50,50 OF 	oDlg PIXEL
EndIf

oGetDad	:= MsGetDados():New(105,04,160,290,3,"a085aLnok(@oSaldo)","A085aTudok(2,nPagar,,,,cNatureza) .AND. lRetCkPG(0,cDebInm,cBanco,nPagar)","EK_EMISSAO/EK_VENCTO",.T.,,,,500,"a085FldOk2()",,,"a085DelLn",oDlg)

@ 165,010 SAY oTxt1  Var OemToAnsi(STR0117+GetMV("MV_SIMB"+AllTrim(Str(nMoedaCor))) +" : ") SIZE 50,10 Of oDlg PIXEL //"Saldo OP en "

//Tratamento para solucionar problemas de arredondamento     
If abs(aPagos[nPos][15]-aSaldos[Len(aSaldos)]) <= 1/(10**MsDecimais(1))
	aSaldos[Len(aSaldos)]:=aPagos[nPos][15]
EndIf	
If aPagos[1][15]<>aSaldos[Len(aSaldos)] .And. mv_par10==3
	@ 165,060 SAY oSaldo Var aPagos[1][20]   Picture TM(aPagos[Len(aPagos)],18,nDecs)  SIZE 80,10 Of oDlg PIXEL
Else
	@ 165,060 SAY oSaldo Var aSaldos[Len(aSaldos)]    Picture TM(aSaldos[Len(aSaldos)],18,nDecs)  SIZE 80,10 Of oDlg PIXEL
EndIf
a085aRefr(nPagar,@oCbx1,@oCbx2,@oDataVenc,@oDataVenc1,@oChkBox,@oDataTxt1,@oDataTxt2,@oTipo,@oMsg,@oSaldo,@oTxt1,@oBanco,@oAgencia,@oConta,;
	,,,,,,@oMsg1,@oValorPg,@oMoedaPA)
ACTIVATE MSDIALOG oDlg ON INIT (oGetDad:OBROWSE:LACTIVE	:=	(nPagar==4),oGetDad:OBROWSE:LNOPAINT	:=	(nPagar<>4),oGetDad:OBROWSE:Refresh(),EnchoiceBar(oDlg,{||(lConfirmo	:=	oGetDad:TudoOk(),If(lConfirmo,oDlg:End(),lConfirmo	:=	.F.))},{||IIf(lModif,Nil,(lConfirmo	:=	.F.,oDlg:End()) )})) VALID (lConfirmo.Or.!lModif)

If lConfirmo
	If ExistBlock("A085ACHQ")
		ExecBlock("A085ACHQ",.F.,.F.,{aHeader,aCols})
	EndIf
	Do Case
		Case nPagar	==	1
			aSE2[nPos][3]	:=	{nPagar,cBanco,cAgencia,cConta,dDataVenc1}
		Case nPagar	==	2
			aSE2[nPos][3]	:=	{nPagar,cBanco,cAgencia,cConta,dDataVenc,cDebMed,(dDataVenc<=dDataBase.And.lBaixaChq)}
		Case nPagar	==	3
			aSE2[nPos][3]	:=	{nPagar,cBanco,cAgencia,cConta,cDebInm}
		Case nPagar	==	4
			If aSE2[nPos][3]	<>	Nil .And.  aSE2[nPos][3][1] == 4
				aPagos[nPos][H_TOTALVL]	-=	aSE2[nPos][3][4]
			Endif
			aSE2[nPos][3]	:=	{nPagar,aClone(aCols),aClone(aRecChqTer),0,0,aVlPA[_PA_VLATU],aVlPA[_PA_MOEATU]}
			If aSaldos[Len(aSaldos)] < 0
				aPagos[nPos][H_TOTALVL]	+=	Abs(aSaldos[Len(aSaldos)])
				aSE2[nPos][3][4]	:=	Abs(aSaldos[Len(aSaldos)])
			Else
				If lRetPa
					aPagos[nPos][H_TOTALVL]	+= Round(xMoeda(aVlPA[_PA_VLATU],aVlPA[_PA_MOEATU],nMoedaCor,,5,aTxMoedas[aVlPA[_PA_MOEATU]][2],aTxMoedas[nMoedaCor][2] ),MsDecimais(nMoedaCor))
					aSE2[nPos][3][4]			:= Round(xMoeda(aVlPA[_PA_VLATU],aVlPA[_PA_MOEATU],1,,5,aTxMoedas[aVlPA[_PA_MOEATU]][2] ),MsDecimais(1))
				EndIf
			Endif
			aPagos[nPos][H_TOTAL  ]	:=	TransForm(aPagos[nPos][H_TOTALVL],Tm(aPagos[nPos][H_TOTALVL] ,18,nDecs))
	EndCase
ElseIf nPagar == 4
	DbSelectArea("SE1")
	For	nA:=1 To Len(aRecChqTer)
		If aRecChqTer[nA] > 0
			Replace	SE1->E1_OK	With "  "
			MsRUnlock(aRecChqTer[nA])
		Endif
	Next
Endif
If !lConfirmo
	aSE2[nPos] :=	aClone(aSE2Bkp)
Endif
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �a085aVlds �Autor  �Bruno Sobieski      � Data �  10/17/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Validacoes da digitacao dos titulos usados para pagar       ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085a                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function a085aVlds(aDebMed,aDebInm,lPa)
Local lRet		:=	.T.
Local cVar		:=	ReadVar()
Local lMoedaP	:=	.T.
Local aChq		:=	{}
Local nX		:= 0

If nPosTipo	==	Nil
	nPosTipo :=	Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_TIPO"})
	nPosTpDoc:=	Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_TIPODOC"})
	nPosNum  :=	Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_NUM"})
	nPosMoeda:=	Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_MOEDA"})
	nPosBanco:=	Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_BANCO"})
	nPosAge  :=	Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_AGENCIA"})
	nPosConta:=	Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_CONTA"})
	nPosVlr	:=	Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_VALOR"})
	nPosEmi :=	Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_EMISSAO"})
	nPosVcto:=	Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_VENCTO"})
	nPosDeb  := Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_DEBITO"})
	nPosParc :=	Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_PARCELA"})
Endif

If cVar	==	"M->EK_TIPO"
	If Alltrim(aCols[n][nPosTpDoc]) == "1"	.And. Ascan(aDebMed,Alltrim(M->EK_TIPO)) == 0
		Help( " ",1, "No SES")
		lRet	:=	.F.
	ElseIf Alltrim(aCols[n][nPosTpDoc]) == "2"	.And. Ascan(aDebInm,Alltrim(M->EK_TIPO)) == 0
		Help( " ",1, "No SES")
		lRet	:=	.F.
	ElseIf 	Empty(aCols[n][nPosTpDoc])
		Help( " ",1, "TipoDeb")
		lRet	:=	.F.
	Endif
ElseIf cVar	==	"M->EK_TIPODOC"
	//��������������������������������������������������������������Ŀ
	//�Se for um cheque de terceiro vou abrir interface para escolher�
	//�o cheque do SE1, senao for e o conteudo anterior da linha for �
	//�um Cheque de terceiro, vou limpar o aCols                     �
	//����������������������������������������������������������������
	If M->EK_TIPODOC == "3"
		aChq	:=	Fa085aTerc()
		If Len(aChq) > 0
			a085aSaldos(aCols[n][nPosVlr],	Val(aCols[n][nPosMoeda]), IIf(aChq[6]$+MVRECANT+"/"+MV_CRNEG,-1, 1),oSaldo,lPa)
			aCols[n][nPosTipo]	:=	aChq[6]
			aCols[n][nPosNum]	:=	aChq[1]
			aCols[n][nPosVlr]	:=	aChq[2]
			aCols[n][nPosMoeda]	:=	StrZero(aChq[3],1)
			aCols[n][nPosEmi]	:=	aChq[4]
			aCols[n][nPosVcto]	:=	aChq[5]
			aCols[n][nPosParc]	:=	aChq[7]
			If Len(aRecChqTer) < Len(aCols)
				AAdd(aRecChqTer,aChq[8])
			Else
				aRecChqTer[n]	:=	aChq[8]
			Endif
			a085aSaldos(aCols[n][nPosVlr],	Val(aCols[n][nPosMoeda]), IIf(aChq[6]$+MVRECANT+"/"+MV_CRNEG,1, -1),oSaldo,lPa)
		Else
			lRet	:=	.F.
		Endif
	Else
		If aCols[n][nPosTpDoc] == "3"
			a085aSaldos(aCols[n][nPosVlr],	Val(aCols[n][nPosMoeda]), 1,oSaldo,lPa)
			For nX	:=	1	To	Len(aHeader)
				aCols[n][nX]	:=	Criavar(aHeader[nX][2])
			Next
			SE1->(MsGoTo(aRecChqTer[n]))
			Replace	SE1->E1_OK	With "  "
			SE1->(MsRUnlock(aRecChqTer[n]))
			aRecChqTer[n]	:=	0
		Else
			aCols[n][nPosTipo]	:=	Criavar(aHeader[nPosTipo][2])
		Endif
	Endif
ElseIf cVar == "M->EK_BANCO"
	If Alltrim(aCols[n][nPosTpDoc])	==	"3"
		Help(" ", 1, "ChqTerc")
		lRet	:=	.F.
	Else
   		CarregaSA6(M->EK_BANCO,aCols[N][nPosAge],aCols[N][nPosConta],.T.)
	Endif
ElseIf cVar == "M->EK_AGENCIA"
	If Alltrim(aCols[n][nPosTpDoc])	==	"3"
		Help(" ", 1, "ChqTerc")
		lRet	:=	.F.
	Else
		CarregaSA6(aCols[N][nPosBanco],M->EK_AGENCIA,aCols[N][nPosConta],.T.)
Endif
ElseIf cVar == "M->EK_CONTA"
	If Alltrim(aCols[n][nPosTpDoc])	==	"3"
		Help(" ", 1, "ChqTerc")
		lRet	:=	.F.
	Else
		CarregaSA6(aCols[N][nPosBanco],aCols[N][nPosAge],M->EK_CONTA,.T.)
	 Endif
ElseIf cVar == "M->EK_VENCTO" .And. Type("nPosDeb")=="N" .And.  nPosDeb > 0
	//se alterar a data de vencimento pra uma data menor do que a data base
	//o status de debito na hora eh marcado como 1-"Nao"
	If (Empty(M->EK_VENCTO) .Or. !(M->EK_VENCTO<=dDataBase))
		aCols[n][nPosDeb]	:= "2"
	Endif
ElseIf cVar == "M->EK_DEBITO"
	//verifica se o tipo de documento e debito mediato, se a data de
	//vencimento e menor do que a data base e se a data de vencimento esta preenchida
	If (nPagar<>4) .Or. (aCols[n][1]<>"1") .Or. (aCols[n][7] > dDataBase .Or. Empty(aCols[n][7]))
		lRet	:=	.F.
	Endif
Endif

If Len(aRecChqTer) < Len(aCols)
	AAdd(aRecChqTer,0)
Endif

If lRet .And. aCols[n][nPosVlr] <> 0 .And. IsInCallStack("A085APgAdi")
	oValor:Refresh()
	If oLiquido <> Nil
		oLiquido:Refresh()
	EndIf
EndIf

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �a085aLnOk �Autor  �Bruno Sobieski      � Data �  10/17/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Linha OK   da digitacao dos titulos usados para pagar       ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085a                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function a085aLnOK(oSaldo,lPa)
Local lRet		:=	.T.
Local cFilter	:=	''
Local aAreaSE2
Local nX	:=	0
Local cParc:=Space(TamSx3("FF_NUM")[1])
Local nSomaDom := 0
Local nMx
Local lPermite := .F.
Local lF085PER := ExistBlock("F085PER")
lPa	:=	If(lPa==Nil,.F.,lPa)

If  lF085PER
	lPermite :=ExecBlock("F085PER",.F.,.F.)
EndIf

If nPosTipo	==	Nil
	nPosTipo :=	Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_TIPO"})
	nPosTpDoc:=	Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_TIPODOC"})
	nPosMoeda:=	Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_MOEDA"})
	nPosNum  :=	Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_NUM"})
	nPosBanco:=	Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_BANCO"})
	nPosAge  :=	Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_AGENCIA"})
	nPosConta:=	Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_CONTA"})
	nPosEmi  :=	Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_EMISSAO"})
	nPosVcto :=	Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_VENCTO"})
	nPosVlr  :=	Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_VALOR"})
	nPosParc :=	Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_PARCELA"})
Endif
If cPaisLoc $ "DOM|COS" .and. Len(aCols) > 1
   nMx:=Len(aCols[1])
   For nX := 1 to Len(aCols)
   	If !aCols[nX][nMx]
	   	nSomaDom+=aCols[nX][nPosVlr]
	   Endif
   Next
   If Ascan(aCols,{|x| Rtrim(x[nPosTipo]) == "EF" .and. !x[nMx] }) > 0 .and. nSomaDom >= nFinLmCH
		lRet	:=	.F.
   	Help(" ",1,"HELP",STR0229,STR0230,1,0)//"FA085A - LIMITE ITF","Pagamento disponivel apenas com Cheque ou Transfer�ncia Banc�ria."
   Endif
Endif
If nPagar == 4 .and. lRet
	If !aCols[n][Len(aCols[n])]
		If Empty(aCols[n][nPosTipo]).Or.Empty(aCols[n][nPosTpDoc]).Or.Empty(aCols[n][nPosMoeda]).Or.;
			Empty(aCols[n][nPosNum]).Or.Empty(aCols[n][nPosEmi]).Or.Empty(aCols[n][nPosVcto]).Or.Empty(aCols[n][nPosVlr])
			Help(" ",1,"Obrigat")
			lRet	:=	.F.
		ElseIf (Empty(aCols[n][nPosBanco]).Or.Empty(aCols[n][nPosAge]).Or.Empty(aCols[n][nPosConta]) ) ;
			.And.Alltrim(aCols[n][nPosTpDoc]) <> "3"
			Help(" ",1,"Obrigat")
			lRet	:=	.F.
		ElseIf aCols[n][nPosTpDoc] == "2" .And. aCols[n][nPosVcto] <> dDataBase
			If !lPermite
		   		Help(" ",1,"BLOQDTVENC")
				lRet:= .F.
			EndIf
		Else
			For nX := 1 To Len(aCols)
				If nX <> n .And. !aCols[nx][len(aCols[nX])].And. aCols[nX][nPosTipo]+aCols[nX][nPosTpDoc]+aCols[nX][nPosNum]+aCols[nX][nPosParc]==;
					aCols[n][nPosTipo]+aCols[n][nPosTpDoc]+aCols[n][nPosNum]+aCols[n][nPosParc]
					Help(" ",1,"FA050NUM")
					lRet	:=	.F.
					Exit
				Endif
			Next
		Endif
		If lRet	.And. Alltrim(aCols[n][nPosTpDoc]) == "1"
			DbSelectArea("SE2")
			#IFDEF TOP
				cFilter		:=	DbFilter()
				DbClearFilter()
			#ELSE
			 	aAreaSE2	:=	GetArea()
			#ENDIF
			DbSetOrder(1)
			cParc:= aCols[n][nPosParc]
			If DbSeek(xFilial()+Space(TamSX3('E2_PREFIXO')[1])+aCols[n][nPosNum]+ cParc +aCols[n][nPosTipo])
				While !EOF().and. xFilial()+Space(TamSX3('E2_PREFIXO')[1])+aCols[n][nPosNum]+cParc+aCols[n][nPosTipo] == ;
					xFilial()+E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO

					If SE2->E2_BCOCHQ ==  aCols[n][nPosBanco] .And.	SE2->E2_AGECHQ ==  aCols[n][nPosAge] .and.	SE2->E2_CTACHQ ==  aCols[n][nPosConta]
						Help(" ",1,"CHEQJAEXIST")
						lRet	:=	.F.
					EndIf

					dbSkip()
				 	If lRet
				 		cParc :=Soma1(cParc)
				 		DbSeek(xFilial()+Space(TamSX3('E2_PREFIXO')[1])+aCols[n][nPosNum]+ cParc +aCols[n][nPosTipo])
				 	EndIf
				EndDo

			Endif
			If lRet
				aCols[n][nPosParc]:= cParc
			EndIf
			#IFDEF TOP
				SET FILTER TO &cFilter.
			#ELSE
			 	RestArea(aAreaSE2)
			#ENDIF
		Endif
		If lRet .and. Alltrim(aCols[n][1])<>"3"
		   lRet:=lRetCkPG(2,aCols[n][2],aCols[n][8],Val(aCols[n][1]))
		Endif
	Endif
	If Len(aRecChqTer) < Len(aCols)
		AAdd(aRecChqTer,0)
	Endif
Endif

// Ponto de entrada para a valida��o do acols
If lRet .And. ExistBlock("F085AVAL")
	lRet:=ExecBlock("F085AVAL",.F.,.F.)
EndIf

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �a085aSaldos�Autor  �Bruno Sobieski      � Data �  10/17/00  ���
�������������������������������������������������������������������������͹��
���Desc.     �Linha OK   da digitacao dos titulos usados para pagar       ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085a                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function a085aSaldos(nValor,nMoeda,nSinal,oSaldo,lPa)
Local nPosMoe		:=	Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_MOEDA"})
Local nPosValor 	:=	Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_VALOR"})
Local nX

lPa	:=	Iif(lPa==Nil,.F.,lPa)
If lRetPA == Nil
	lRetPA := (GetNewPar("MV_RETPA","N") == "S")
EndIf

    // Bruno
aSaldos[nMoeda] += nValor * nSinal
aSaldos[Len(aSaldos)]	+=	Round(xMoeda(nValor,nMoeda,nMoedaCor,,5,aTxMoedas[nMoeda][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor)) * nSinal

// Arredonda o total em moeda corrente. (Apresentava msg de saldo insuficiente por problema de arredondamento.) // Guilherme
aSaldos[Len(aSaldos)] := Round(aSaldos[Len(aSaldos)],MsDecimais(nMoedaCor))

If lPa .And. !lRetPA
	nValor	:=	aSaldos[Len(aSaldos)] * nSinal
	oValor:Refresh()
Endif

If Type("oSaldo")<> "U" .And. oSaldo <> Nil
	oSaldo:Refresh()
Endif
Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Fa085AtuVl�Autor  �Bruno Sobieski      � Data �  10/19/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualiza o Array do listbox e o total para a nova moeda digi���
���          � tada.                                                      ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Fa085AtuVl(oValOrdens,nValOrdens,aPagos,aSE2)
Local nA,nC,nP,nX,nY
Local lF085MDEM		:= ExistBlock("F085MDEM")
Local aAuxMDEM		:= {}
Local aAreaMoeda	:= {}

nValOrdens	:=	0
nDecs	 :=	MsDecimais(nMoedaCor)
nValDesc := nDescOP

//Validacion de la tasa de cambio de la moneda seleccionada
If nMoedaCor <> 1 
	aAreaMoeda := GetArea()
	DbSelectArea("SM2")	
		If IIf (SM2->(DbSeek(dDataBase,.T.)), SM2 ->&('M2_MOEDA'+ltrim(str(nMoedaCor)))== 0  , .T.)  
			MsgAlert(OemToAnsi(STR0269)+cMoeda+OemToAnsi(STR0270)) //"Registre correctamente el tipo de cambio de la moneda"," de lo contrario su pago tendra inconsistencias." 
		EndIf
	RestArea(aAreaMoeda)
EndIf

//CARREGAR ARRAY PARA USAR NA LISTBOX.
For nA	:=	1	To Len(aSE2)
	//INICIALIZAR ARRAY COM OS DADOS PIRNCIPAIS
	aPagos[nA][H_NCC_PA]	:=	0
	aPagos[nA][H_NF    ]	:=	0
	aPagos[nA][H_TOTALVL]	:=	0
	aPagos[nA][H_VALORIG]	:=	0
	aPagos[nA][H_DESCVL]	:=	0
	If cPaisLoc	==	"ARG"
		aPagos[nA][H_RETIB]  :=	0
		aPagos[nA][H_RETIVA] :=	0
		aPagos[nA][H_RETGAN] :=	0
		aPagos[nA][H_RETSUSS]:=	0
		aPagos[nA][H_RETSLI] :=	0
		aPagos[nA][H_RETISI] :=	0
		aPagos[nA][H_CPR] 	:=	0
	ElseIf cPaisLoc $ "URU|BOL"
		aPagos[nA][H_RETIRIC]:=	0
		aPagos[nA][H_RETIR]:=	0
	ElseIf cPaisLoc	==	"PTG"
		aPagos[nA][H_RETIRC]  :=0
		aPagos[nA][H_RETIVA] :=	0
		aPagos[nA][H_DESPESAS]:=	0

	//ANGOLA
	ElseIf cPaisLoc	==	"ANG"
		aPagos[nA][H_RETRIE]  :=0
	ElseIf cPaisLoc	==	"PER"
		aPagos[nA][H_RETIGV]  :=0
		aPagos[nA][H_RETIR]  :=0
	ElseIf cPaisLoc $ "COS|DOM"
		aPagos[nA][H_TOTRET ] := 0
	ElseIf cPaisLoc	==	"PAR"
		aPagos[nA][H_RETIVA]  :=0
		aPagos[nA][H_RETIR]  :=0
	Endif

	//CARREGAR COM OS VALORES DE NOTAS PARA SER PAGAS, NNC , PAS, E NO CASO DE ARGENTINA
	//AS RETENCOES DE IMPOSTOS DE IB E IVA.
	For nC	:=	1	To Len(aSE2[nA][1])
		If lF085MDEM
			aAuxMDEM := aClone(ExecBlock("F085MDEM",.F.,.F.,{aClone(aSE2[nA][1][nC]),aClone(aTxMoedas)}))
			If ValType(aAuxMDEM) == "A" .And. Len(aAuxMDEM) > 0
				aTxMoedas := aClone(aAuxMDEM)
			EndIf
		EndIf
		If aSE2[nA][1][nC][_TIPO] $ MVPAGANT + "/" + MV_CPNEG 
			if cPaisLoc $ "PAR|CHI|URU|BOL" .and. (!IsInCallStack("FA085TELA") .and. PROCNAME(1) == "FA085ALT" )
				aPagos[nA][H_NCC_PA]	+= nTotNCC
				aPagos[nA][H_VALORIG]	+= nTotNCC
			ELSE 
				if cPaisLoc $ "PAR|CHI|URU|BOL"
				   If nMoedaCor== 1  .and. cPaisLoc == "PAR"
					  aPagos[nA][H_NCC_PA]	+= aSE2[nA][1][nC][_SALDO1]
					  aPagos[nA][H_VALORIG]	+= aSE2[nA][1][nC][_SALDO1]
				    Else
                      aPagos[nA][H_NCC_PA]		+= Round(xMoeda(aSE2[nA][1][nC][_PAGAR],aSE2[nA][1][nC][_MOEDA],nMoedaCor,,5,aTxMoedas[aSE2[nA][1][nC][_MOEDA]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
		 			  aPagos[nA][H_VALORIG]	+= Round(xMoeda(aSE2[nA][1][nC][_PAGAR],aSE2[nA][1][nC][_MOEDA],1,,5,aTxMoedas[aSE2[nA][1][nC][_MOEDA]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
				    EndIF
				Else
					aPagos[nA][H_NCC_PA]		+= Round(xMoeda(aSE2[nA][1][nC][_PAGAR],aSE2[nA][1][nC][_MOEDA],nMoedaCor,,5,aTxMoedas[aSE2[nA][1][nC][_MOEDA]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
		 			aPagos[nA][H_VALORIG]	+= Round(xMoeda(aSE2[nA][1][nC][_PAGAR],aSE2[nA][1][nC][_MOEDA],1,,5,aTxMoedas[aSE2[nA][1][nC][_MOEDA]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
				EndIf 
			EndIf
		Else
			If cPaisLoc == "EQU"
				nAbatimentos := SomaAbat(aSE2[nA][1][nC][9],aSE2[nA][1][nC][10],aSE2[nA][1][nC][11],"P",aSE2[nA][1][nC][4],aSE2[nA][1][nC][7],aSE2[nA][1][nC][1])
				If aSE2[nA][1][nC][3] <> (aSE2[nA][1][nC][_PAGAR] + aSE2[nA][1][nC][_DESCONT] + nAbatimentos)
					aPagos[nA][H_VALORIG] += Round(xMoeda(aSE2[nA][1][nC][_PAGAR],aSE2[nA][1][nC][_MOEDA],nMoedaCor,,5,aTxMoedas[aSE2[nA][1][nC][_MOEDA]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
					aPagos[nA][H_NF     ] += Round(xMoeda(aSE2[nA][1][nC][_PAGAR]+IIf(Type("nValDesc") != "U",nValDesc,0),aSE2[nA][1][nC][_MOEDA],nMoedaCor,,5,aTxMoedas[aSE2[nA][1][nC][_MOEDA]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
				Else
				   	aPagos[nA][H_VALORIG] += Round(xMoeda(aSE2[nA][1][nC][3],aSE2[nA][1][nC][_MOEDA],1,,5,aTxMoedas[aSE2[nA][1][nC][_MOEDA]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
					aPagos[nA][H_NF     ] += Round(xMoeda(aSE2[nA][1][nC][3],aSE2[nA][1][nC][_MOEDA],nMoedaCor,,5,aTxMoedas[aSE2[nA][1][nC][_MOEDA]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
				EndIf
			Else
				 If cPaisLoc == "PER"
			    	If aTxMoedas[aSE2[nA][1][nC][_MOEDA]][2] <> Round(RecMoeda(dDataBase,aSE2[nA,1,nC,_MOEDA]),MsDecimais(aSE2[nA,1,nC,_MOEDA])) .And. AllTrim(SE2->E2_TIPO) <> "TX"
						aPagos[nA][H_VALORIG] += Round(xMoeda(aSE2[nA][1][nC][_PAGAR],aSE2[nA][1][nC][_MOEDA],1,,5,aTxMoedas[aSE2[nA][1][nC][_MOEDA]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
						aPagos[nA][H_NF     ] += Round(xMoeda(aSE2[nA][1][nC][_PAGAR],aSE2[nA][1][nC][_MOEDA],nMoedaCor,,5,aTxMoedas[aSE2[nA][1][nC][_MOEDA]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			    	Else
			    		If aSE2[nA][1][nC][_MOEDA] == 1
				    		If (AllTrim(aSE2[nA][1][nC][_TIPO]) $ "TX|NF")
				    			aPagos[nA][H_VALORIG] += Round(xMoeda(aSE2[nA][1][nC][_PAGAR],aSE2[nA][1][nC][_MOEDA],1        ,,5,SE2->E2_TXMOEDA,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
								aPagos[nA][H_NF     ] += Round(xMoeda(aSE2[nA][1][nC][_PAGAR],aSE2[nA][1][nC][_MOEDA],nMoedaCor,,5,SE2->E2_TXMOEDA,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))			    	
				    		Else
								aPagos[nA][H_VALORIG] += Round(xMoeda(aSE2[nA][1][nC][_PAGAR],aSE2[nA][1][nC][_MOEDA],1        ,,5,,IIF(Empty(aSE2[nA,1,nC,_TXMOEDA]),aTxMoedas[nMoedaCor][2],aSE2[nA,1,nC,_TXMOEDA])),MsDecimais(nMoedaCor))
								aPagos[nA][H_NF     ] += Round(xMoeda(aSE2[nA][1][nC][_PAGAR],aSE2[nA][1][nC][_MOEDA],nMoedaCor,,5,,IIF(Empty(aSE2[nA,1,nC,_TXMOEDA]),aTxMoedas[nMoedaCor][2],aSE2[nA,1,nC,_TXMOEDA])),MsDecimais(nMoedaCor))
							EndIf
						Else
							If (AllTrim(aSE2[nA][1][nC][_TIPO]) $ "TX|NF")
								If AllTrim(aSE2[nA][1][nC][_TIPO]) == "TX"
									aPagos[nA][H_VALORIG] += Round(xMoeda(aSE2[nA][1][nC][_PAGAR], aSE2[nA][1][nC][_MOEDA], 1, , 5, aSE2[nA][1][nC][_TXMOEDA], aTxMoedas[nMoedaCor][2]),IIF(nMoedaCor==1,0,MsDecimais(nMoedaCor)))
									aPagos[nA][H_NF     ] += Round(xMoeda(aSE2[nA][1][nC][_PAGAR], aSE2[nA][1][nC][_MOEDA], nMoedaCor, , 5, aSE2[nA][1][nC][_TXMOEDA], aTxMoedas[nMoedaCor][2]),IIF(nMoedaCor==1,0,MsDecimais(nMoedaCor)))			    	
								Else
									aPagos[nA][H_VALORIG] += Round(xMoeda(aSE2[nA][1][nC][_PAGAR],aSE2[nA][1][nC][_MOEDA],1        	,,5,aTxMoedas[aSE2[nA][1][nC][_MOEDA]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
									aPagos[nA][H_NF     ] += Round(xMoeda(aSE2[nA][1][nC][_PAGAR],aSE2[nA][1][nC][_MOEDA],nMoedaCor ,,5,aTxMoedas[aSE2[nA][1][nC][_MOEDA]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
								EndIf
			    			Else
								aPagos[nA][H_VALORIG] += Round(xMoeda(aSE2[nA][1][nC][_PAGAR],aSE2[nA][1][nC][_MOEDA],1        	,,5,IIF(Empty(aSE2[nA,1,nC,_TXMOEDA]),aTxMoedas[nMoedaCor][2],aSE2[nA,1,nC,_TXMOEDA])),MsDecimais(nMoedaCor))
								aPagos[nA][H_NF     ] += Round(xMoeda(aSE2[nA][1][nC][_PAGAR],aSE2[nA][1][nC][_MOEDA],nMoedaCor ,,5,IIF(Empty(aSE2[nA,1,nC,_TXMOEDA]),aTxMoedas[nMoedaCor][2],aSE2[nA,1,nC,_TXMOEDA])),MsDecimais(nMoedaCor))
							EndIf
						EndIf
			    	EndIf			    	
			  	ElseIf cPaisLoc == "COL"
					aPagos[nA][H_VALORIG] += Round(xMoeda(aSE2[nA][1][nC][_PAGAR],aSE2[nA][1][nC][_MOEDA],1,,5,aTxMoedas[aSE2[nA][1][nC][_MOEDA]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
					aPagos[nA][H_NF     ] += Round(xMoeda(aSE2[nA][1][nC][_PAGAR],aSE2[nA][1][nC][_MOEDA],nMoedaCor,,5,aTxMoedas[aSE2[nA][1][nC][_MOEDA]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
				ElseIf cPaisLoc == "PAR" 
			  	 	aPagos[nA][H_VALORIG]   += Round(xMoeda(aSE2[nA][1][nC][_PAGAR],aSE2[nA][1][nC][_MOEDA],1,,5,aTxMoedas[aSE2[nA][1][nC][_MOEDA]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
					aPagos[nA][H_NF     ] 	+= Round(xMoeda(aSE2[nA][1][nC][_PAGAR],aSE2[nA][1][nC][_MOEDA],nMoedaCor,,5,aTxMoedas[aSE2[nA][1][nC][_MOEDA]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
				Else
					aPagos[nA][H_VALORIG] += Round(xMoeda(IIf(nValdesc==0,aSE2[nA][1][nC][_PAGAR],aSE2[nA][1][nC][_VALOR]),aSE2[nA][1][nC][_MOEDA],1,,5,aTxMoedas[aSE2[nA][1][nC][_MOEDA]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
					aPagos[nA][H_NF     ] += Round(xMoeda(IIF(nValDesc==0,aSE2[nA][1][nC][_PAGAR],aSE2[nA][1][nC][_VALOR]),aSE2[nA][1][nC][_MOEDA],nMoedaCor,,5,aTxMoedas[aSE2[nA][1][nC][_MOEDA]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
				EndIF
				If Type("nValDesc") != "U"
					If cPaisLoc  $ "URU|PER|MEX"
						aPagos[nA][H_NCC_PA ] += Round(xMoeda(aSE2[nA][1][nC][_DESCONT],aSE2[nA][1][nC][_MOEDA],nMoedaCor,,5,aTxMoedas[aSE2[nA][1][nC][_MOEDA]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
					ElseIf cPaisLoc == "COL" 
						aPagos[nA][H_NCC_PA ] += xMoeda(aSE2[nA][1][nC][_DESCONT],aSE2[nA][1][nC][_MOEDA],nMoedaCor,,5,aTxMoedas[aSE2[nA][1][nC][_MOEDA]][2],aTxMoedas[nMoedaCor][2])
					Else					
						aPagos[nA][H_NCC_PA ] += aSE2[nA][1][nC][_DESCONT]//nValDesc 
					EndIf
					nDescOP := aPagos[nA][_DESCONT ] // guarda o valor do nValDesc					
				EndIf
			EndIf
			aPagos[nA][H_DESCVL]  += Round(xMoeda(aSE2[nA][1][nC][_DESCONT],aSE2[nA][1][nC][_MOEDA],nMoedaCor,,5,aTxMoedas[aSE2[nA][1][nC][_MOEDA]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
		Endif
		
		If cPaisLoc $ "URU|BOL"
			For nP	:=	1	To	Len(aSE2[nA][1][nC][_RETIRIC])
				aPagos[nA][H_RETIRIC]	+=	Round(xMoeda(aSE2[nA][1][nC][_RETIRIC][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next

			For nP	:=	1	To	Len(aSE2[nA][1][nC][_RETIR])
				aPagos[nA][H_RETIR]	+=	Round(xMoeda(aSE2[nA][1][nC][_RETIR][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next
		ElseIf cPaisLoc == "PTG"
			For nP	:=	1	To	Len(aSE2[nA][1][nC][_RETIRC])
				aPagos[nA][H_RETIRC]		+=	Round(xMoeda(aSE2[nA][1][nC][_RETIRC ][nP][5],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next
			For nP	:=	1	To	Len(aSE2[nA][1][nC][_RETIVA])
				aPagos[nA][H_RETIVA]		+=	Round(xMoeda(aSE2[nA][1][nC][_RETIVA][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next
		//ANGOLA
		ElseIf cPaisLoc == "ANG"
			For nP	:=	1	To	Len(aSE2[nA][1][nC][_RETRIE])
				aPagos[nA][H_RETRIE]		+=	Round(xMoeda(aSE2[nA][1][nC][_RETRIE ][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next
		ElseIf cPaisLoc == "PER"
			For nP	:=	1	To	Len(aSE2[nA][1][nC][_RETIGV])   
				aPagos[nA][H_RETIGV] +=	Round(xMoeda(aSE2[nA][1][nC][_RETIGV ][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))										
			Next
			/* retencao de IR */
			For nP	:=	1	To	Len(aSE2[nA][1][nC][_RETIR])				
				If aSE2[nA][1][nC][_PAGAR] <> aSE2[nA][1][nC][26][nP][3]
					aPagos[nA][H_RETIR]	+=	Round(xMoeda(aSE2[nA][1][nC][_RETIR][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
				Else
					aPagos[nA][H_RETIR]	+=	Round(xMoeda(aSE2[nA][1][nC][_RETIR][nP][6],aSE2[nA][1][nC][_MOEDA],nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
				EndIf				
			Next
		ElseIf cPaisLoc == "PAR"
			For nP	:=	1	To	Len(aSE2[nA][1][nC][_RETIVA])
				If aPagos[nA][5] >= Round(xMoeda(SFF->FF_IMPORTE,1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor)) //SFF->FF_IMPORTE  
					aPagos[nA][H_RETIVA]		+=	Round(xMoeda(aSE2[nA][1][nC][_RETIVA][nP][4],1,nMoedaCor,,5,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
				Else
					aPagos[nA][H_RETIVA]:= 0
				EndIf	
			Next
				/* retencao de IR */
			For nP	:=	1	To	Len(aSE2[nA][1][nC][_RETIR])
				aPagos[nA][H_RETIR]	+=	Round(xMoeda(aSE2[nA][1][nC][_RETIR][nP][6],1,nMoedaCor,,5,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next
		Endif
	Next nC
	If cPaisLoc	==	"ARG"
		For nC:=	1	To Len(aSE2[nA][2])
			aPagos[nA][H_RETGAN]		+=	Round(xMoeda(aSE2[nA][2][nC][5],1,nMoedaCor,,5,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
		Next nC

			//************************************************************************
		//Calculo cumulativo de IVA - reten��o de documentos que n�o s�o desta OP
		//************************************************************************
		F085DocIVA(aSE2[nA][1][1][_FORNECE],aSE2[nA][1][1][_LOJA])

		If Len(aRetIvAcm[3]) > 0 .And. aRetIvAcm[3] <> Nil
			For nP := 1 to Len(aRetIvAcm[3])
				aPagos[nA][H_RETIVA] +=	Round(xMoeda(aRetIvAcm[3][nP][6],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next nP
		EndIf

		aPagos[nA][H_TOTALVL]	:=	aPagos[nA][H_NF]-aPagos[nA][H_NCC_PA]-;
		aPagos[nA][H_RETIB]-aPagos[nA][H_RETGAN]-;
		aPagos[nA][H_RETIVA]-aPagos[nA][H_RETSUSS]-;
		aPagos[nA][H_RETSLI]-aPagos[nA][H_RETISI]-aPagos[nA][H_CPR]
	ElseIf cPaisLoc $ "URU|BOL"
		aPagos[nA][H_TOTALVL]	:=	aPagos[nA][H_NF]-aPagos[nA][H_NCC_PA]-aPagos[nA][H_RETIRIC]- aPagos[nA][H_RETIR]
	ElseIf cPaisLoc == "PTG"
		For nC:=	1	To Len(aSE2[nA][4])
			aPagos[nA][H_DESPESAS]		+=	Round(xMoeda(aSE2[nA][4][nC][2],Val(aSE2[nA][4][nC][3]),nMoedaCor,,5,,aTxMoedas[Val(aSE2[nA][4][nC][3])][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
		Next nC
		aPagos[nA][H_TOTALVL]	:=	aPagos[nA][H_NF] - aPagos[nA][H_NCC_PA] - aPagos[nA][H_RETIRC] - aPagos[nA][H_RETIRC] - aPagos[nA][H_RETIVA] + aPagos[nA][H_DESPESAS]

	//ANGOLA
	ElseIf cPaisLoc == "ANG"
		aPagos[nA][H_TOTALVL]	:=	aPagos[nA][H_NF]-aPagos[nA][H_NCC_PA]-aPagos[nA][H_RETRIE]
	ElseIf cPaisLoc == "PER"
		aPagos[nA][H_TOTALVL]	:=	aPagos[nA][H_NF]-aPagos[nA][H_NCC_PA]-aPagos[nA][H_RETIGV]-aPagos[nA][H_RETIR]
	Elseif  cPaisLoc == "MEX"
		//aPagos[nA][H_TOTALVL]	:=	Round(xMoeda(aPagos[nA][H_NF],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))-aPagos[nA][H_NCC_PA]
		aPagos[nA][H_TOTALVL]	:=	Round(aPagos[nA][H_NF],MsDecimais(nMoedaCor))-aPagos[nA][H_NCC_PA]
	Else
		aPagos[nA][H_TOTALVL]	:=	aPagos[nA][H_NF]-aPagos[nA][H_NCC_PA]
	Endif
	If cPaisLoc	==	"ARG"
		aPagos[nA][H_TOTRET]	:=	aPagos[nA][H_RETIB]+aPagos[nA][H_RETIVA]+aPagos[nA][H_RETGAN]
		aPagos[nA][H_RETIB]		:=	TransForm(aPagos[nA][H_RETIB]  ,Tm(aPagos[nA][H_RETIB ] ,16,nDecs))
		aPagos[nA][H_RETGAN]	:=	TransForm(aPagos[nA][H_RETGAN] ,Tm(aPagos[nA][H_RETGAN] ,16,nDecs))
		aPagos[nA][H_RETIVA]	:=	TransForm(aPagos[nA][H_RETIVA] ,Tm(aPagos[nA][H_RETIVA] ,16,nDecs))
		aPagos[nA][H_RETSUSS]:=	TransForm(aPagos[nA][H_RETSUSS],Tm(aPagos[nA][H_RETSUSS],16,nDecs))
		aPagos[nA][H_RETSLI]	:=	TransForm(aPagos[nA][H_RETSLI] ,Tm(aPagos[nA][H_RETSLI] ,16,nDecs))
		aPagos[nA][H_RETISI]	:=	TransForm(aPagos[nA][H_RETISI] ,Tm(aPagos[nA][H_RETISI] ,16,nDecs))
		aPagos[nA][H_CPR]		:=	TransForm(aPagos[nA][H_CPR] ,Tm(aPagos[nA][H_CPR] ,16,nDecs))
	ElseIf cPaisLoc $ "URU|BOL"
		aPagos[nA][H_RETIRIC]	:=	TransForm(aPagos[nA][H_RETIRIC],Tm(aPagos[nA][H_RETIRIC],16,nDecs))
		aPagos[nA][H_RETIR]	:=	TransForm(aPagos[nA][H_RETIR],Tm(aPagos[nA][H_RETIR],16,nDecs))
	ElseIf cPaisLoc	==	"PTG"
		aPagos[nA][H_TOTRET]	:=	aPagos[nA][H_RETIVA]+aPagos[nA][H_RETIRC]
		aPagos[nA][H_RETIRC]	:=	TransForm(aPagos[nA][H_RETIRC]  ,Tm(aPagos[nA][H_RETIRC ] ,16,nDecs))
		aPagos[nA][H_RETIVA]	:=	TransForm(aPagos[nA][H_RETIVA] ,Tm(aPagos[nA][H_RETIVA] ,16,nDecs))
		aPagos[nA][H_DESPESAS]:=	TransForm(aPagos[nA][H_DESPESAS] ,Tm(aPagos[nA][H_DESPESAS] ,16,nDecs))

	//ANGOLA
	ElseIf cPaisLoc	==	"ANG"
		aPagos[nA][H_TOTRET]	:=	aPagos[nA][H_RETRIE]
		aPagos[nA][H_RETRIE]	:=	TransForm(aPagos[nA][H_RETRIE]  ,Tm(aPagos[nA][H_RETRIE ] ,16,nDecs))
	ElseIf cPaisLoc	==	"PER" //PERU
		aPagos[nA][H_TOTRET]	:=	aPagos[nA][H_RETIGV]
		aPagos[nA][H_RETIGV]	:=	TransForm(aPagos[nA][H_RETIGV]  ,Tm(aPagos[nA][H_RETIGV ] ,16,nDecs))
		/* retencao de IR */
		aPagos[nA][H_TOTRET]	+=	aPagos[nA][H_RETIR]
		aPagos[nA][H_RETIR]	:=	TransForm(aPagos[nA][H_RETIR],Tm(aPagos[nA][H_RETIR] ,16,nDecs))
	ElseIf cPaisLoc	==	"EQU"
        If	aPagos[nA][H_TOTALVL] != aPagos[nA][H_VALORIG]
	 		aPagos[nA][H_TOTALVL] := aPagos[nA][H_NF]
	 	EndIf
 		aPagos[nA][H_NF     ] := aPagos[nA][H_NF     ]
		aPagos[nA][H_NCC_PA ] := aPagos[nA][H_NCC_PA ]
		aPagos[nA][H_TOTRET ] := aPagos[nA][H_TOTRET ]
		aPagos[nA][H_DESCVL ] := aPagos[nA][H_DESCVL ]
		aPagos[nA][H_MULTAS ] := aPagos[nA][H_MULTAS ]
		aPagos[nA][H_RETIVA ] := fA085GetRet("IV-",aPagos[nA][H_TOTRET],aSE2,aPagos)
		aPagos[nA][H_RETIR  ] := fA085GetRet("IR-",aPagos[nA][H_TOTRET],aSE2,aPagos)
 		aPagos[nA][H_TOTALVL] := aPagos[nA][H_NF] - aPagos[nA][H_NCC_PA] - aPagos[nA][H_TOTRET] - aPagos[nA][H_DESCVL] + aPagos[nA][H_MULTAS]
		aPagos[nA][H_TOTAL  ] := aPagos[nA][H_TOTALVL]
	ElseIf  cPaisLoc	==	"PAR" //PARAGUAI 
		aPagos[nA][H_TOTALVL]	:=	aPagos[nA][H_NF]-aPagos[nA][H_NCC_PA]-aPagos[nA][H_RETIVA]-aPagos[nA][H_RETIR]
		aPagos[nA][H_TOTRET]	:=	aPagos[nA][H_RETIVA]-aPagos[nA][H_RETIR]
		aPagos[nA][H_RETIVA]	:=	TransForm(aPagos[nA][H_RETIVA]  ,Tm(aPagos[nA][H_RETIVA ] ,16,nDecs))	
		aPagos[nA][H_RETIR]		:=	TransForm(aPagos[nA][H_RETIR],Tm(aPagos[nA][H_RETIR] ,16,nDecs))
  	ElseIf cPaisLoc $ "COS|DOM"
		//Array aRetencao - Preenchido na fun��o fa050CalcRet() - C�lculo de reten��o com Conf. de Impostos
		If Len(aRetencao) > 0
			For nX := 1 to Len(aRetencao)
				If aRetencao[nX][6] == aPagos[nA][H_FORNECE ] .And. aRetencao[nX][7] == aPagos[nA][H_LOJA ]
					For nY := 1 to Len(aRetencao[nX][8])
						If aRetencao[nX][8][nY][3] == "1"
							aPagos[nA][H_TOTRET ] += aRetencao[nX][8][nY][2]
							aPagos[nA][H_NF     ] += aPagos[nA][H_TOTRET ]
						ElseIf aRetencao[nX][8][nY][3] == "2"
							aPagos[nA][H_NCC_PA ] += aRetencao[nX][8][nY][2]
							aPagos[nA][H_TOTALVL] -= aRetencao[nX][8][nY][2]
						EndIf
					Next nY
				EndIf
			Next nX
		Else
			aPagos[nA][H_TOTRET ] := 0
		EndIf
    EndIf

	/*
	//�����������������������������������������������������������������Ŀ
	//�Se o pagamento tem opcao de diferenciado, somar o total excedido �
	//�(PA) no H_TOTALVL                                                �
	//�������������������������������������������������������������������
	*/
	If aSE2[nA][3] <> Nil .And.  aSE2[nA][3][1] == 4
		aPagos[nA][H_TOTALVL] 	+=	Round(xMoeda(aSE2[nA][3][6],aSE2[nA][3][7],nMoedaCor,,5,aTxMoedas[aSE2[nA][3][7]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
	Endif
	If aPagos[nA][H_TOTALVL] < 0 .AND. cPaisLoc == "CHI"
		nValOrdens	+=	aPagos[nA][H_TOTALVL]
		aPagos[nA][1] := 0
	EndIf
	//A factura so eh desconsiderada caso a retencao de IVA e o total a ser
	//pago sejam menores que zero. Isso eh valido somente para Argentina.
	If (aPagos[nA][H_TOTALVL] < 0) .And. Iif(cPaisLoc=="ARG",DesTrans(aPagos[nA][H_RETIVA],nDecs) <= 0,.T.)
		aPagos[nA][1] := 0
	Else
		nValOrdens	+=	aPagos[nA][H_TOTALVL]
		IIF(Alltrim(_cTipo)=="TX".And.cPaisLoc <> "PER",nValOrdens:=Round(nValOrdens,0),.T.)
	Endif
	If aPagos[nA][H_TOTALVL] < 0 .AND. cPaisLoc == "URU"
		nValOrdens	+=	aPagos[nA][H_TOTALVL]
		aPagos[nA][1] := 0
	EndIf
	If aPagos[nA][H_TOTALVL] == 0 .AND. cPaisLoc == "URU"
		aPagos[nA][1] := 1
	EndIf  
	IIF(cPaisLoc=="PER".and.Alltrim(_cTipo)=="TX",aPagos[nA][H_TOTAL ] := Round(Val(aPagos[nA][H_TOTAL ]), MsDecimais(nMoedaCor)),.T.)
	If cPaisLoc <> "EQU"
		aPagos[nA][H_DESCVL] := aPagos[nA][H_NCC_PA]
		aPagos[nA][H_NF    ] :=	TransForm(aPagos[nA][H_NF     ],Tm(aPagos[nA][H_NF]     ,16,nDecs))
		aPagos[nA][H_NCC_PA] :=	TransForm(aPagos[nA][H_NCC_PA ],Tm(aPagos[nA][H_NCC_PA] ,16,nDecs))
		aPagos[nA][H_TOTAL ] :=	TransForm(aPagos[nA][H_TOTALVL],Tm(aPagos[nA][H_TOTALVL],18,nDecs))
	EndIf 
Next nA
oLbx:Refresh()
oValOrdens:refresh(.T.)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA085SetMo�Autor  �Alexandre Silva     � Data �  11.01.02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Configura as taxas das moedas.                              ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function Fa085SetMo()
Local   lConfirmo   :=	 .F.
Local   aCabMoed	  :=	{}
Local   aTamMoed	  := {23,25,30,30}
Local   aCpsMoed    := {"cMoeda","nTaxa"}
Local	  aTmp1	     := aTxMoedas[1]

Private nQtMoedas   := Moedfin()
Private aLinMoed    :=	aClone(aTxMoedas)
Private oBMoeda

aDel(aLinMoed,1)
aSize(aLinMoed,Len(aLinMoed)-1)

If !CtbValiDt(,dDatabase,,,,{"FIN002"},)
	Return
EndIf

Posicione("SX3",2,"EL_MOEDA","X3_TITULO")
Aadd(aCabMoed,X3Titulo())
Aadd(aCabMoed,STR0118)

If nQtMoedas > 1
	Define MSDIALOG oDlg From 50,250 TO 212,480 TITLE STR0118 PIXEL //"Tasas"

		oBMoeda:=TwBrowse():New(04,05,01,01,,aCabMoed,aTamMoed,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)

		oBMoeda:SetArray(aLinMoed)
		oBMoeda:bLine 	:= { ||{aLinMoed[oBMoeda:nAT][1],;
		Transform(aLinMoed[oBMoeda:nAT][2],aLinMoed[oBMoeda:nAT][3])}}

		oBMoeda:bLDblClick   := {||EdMoeda(),oBMoeda:ColPos := 1,oBMoeda:SetFocus()}
		oBMoeda:lHScroll     := .F.
		oBMoeda:lVScroll     := .T.
		oBMoeda:nHeight      := 112
		oBMoeda:nWidth	      := 215
		obMoeda:AcolSizes[1]	:= 50

	DEFINE  SButton FROM 064,50 TYPE 1 Action (lConfirmo := .T. , oDlg:End() ) ENABLE OF oDlg  PIXEL
	DEFINE  SButton FROM 064,80 TYPE 2 Action (,oDlg:End() ) ENABLE OF oDlg  PIXEL
	Activate MSDialog oDlg
Else
	Help("",1,"NoMoneda")
EndIf

If lConfirmo
	AAdd(aLinMoed,{})
	aIns(aLinMoed,1)
	aLinMoed[1]	:=	aClone(aTmp1)
	aTxMoedas	:=	aClone(aLinMoed)
Endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Fa085AcRet�Autor  �Microsiga           � Data �  10/17/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Acumula os valores base de calculo de retencao por Conceito.���
�������������������������������������������������������������������������͹��
���Uso       � Fina085,FINA085a                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function Fa085AcRet(aConGanOri,nSigno,nSaldo,aRateioGan,lMonotrb)
Local nRateio
Local nRatValImp
Local nValMerc
Local nTotOrden
Local nPosGan,cConc
Local nX,nY,nMoeda   := 1
Local aConGan	:=	{}
Local aConGanRat	:=	{}
Local lCalcGN := .T.
Local nI:=1
Local nVlrTotal:=0
Local aImpInf := {}

DEFAULT nSigno	:=	1
DEFAULT lMonotrb := .F.

//As retencoes sao calculadas com a taxa do d�a e nao com a taxa variavel.... //Bruno.
	If ExistBlock("F0851IMP")
		lCalcGN:=ExecBlock("F0851IMP",.F.,.F.,{"GN"})
	EndIf

If lCalcGN

//+----------------------------------------------------------------+
//� Obter o Valor do Imposto e Base baseando se no rateio do valor �
//� do titulo pelo total da Nota Fiscal.                           �
//+----------------------------------------------------------------+
If !(SE2->E2_TIPO $ MV_CPNEG)
	dbSelectArea("SF1")
	dbSetOrder(1)
		If lMsFil
			dbSeek(SE2->E2_MSFIL+(SE2->E2_NUM)+(SE2->E2_PREFIXO)+(SE2->E2_FORNECE)+SE2->E2_LOJA)
		Else
			dbSeek(xFilial("SF1")+(SE2->E2_NUM)+(SE2->E2_PREFIXO)+(SE2->E2_FORNECE)+SE2->E2_LOJA)
		EndIf

	While Alltrim(SF1->F1_ESPECIE)<>Alltrim(SE2->E2_TIPO).And.!Eof()
		SF1->(DbSkip())
		Loop
	Enddo

	If Alltrim(SF1->F1_ESPECIE)==Alltrim(SE2->E2_TIPO).And.;
			Iif(lMsFil, SF1->F1_MSFIL,xFilial("SF1"))+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA==;
		F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA

		nMoeda      := Max(SF1->F1_MOEDA,1)

		If cPaisLoc<>"ARG"
			nRateio := 1
		else
			nRateio := ( SF1->F1_VALMERC - SF1->F1_DESCONT ) / SF1->F1_VALBRUT
		Endif

		nRatValImp	:= ( Round(xMoeda(nSaldo,SE2->E2_MOEDA,1,,5,aTxMoedas[Max(SE2->E2_MOEDA,1)][2]),MsDecimais(1)) / Round(xMoeda(SF1->F1_VALBRUT,SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1)) )
		nValMerc 	:= ( Round(xMoeda(nSaldo,SE2->E2_MOEDA,1,,5,aTxMoedas[Max(SE2->E2_MOEDA,1)][2]),MsDecimais(1)) * nRateio )
		If SF1->F1_FRETE > 0
			MV_FRETLOC := GetNewPar("MV_FRETLOC","IVA162GAN06")
			cConc   := Alltrim(Subs( MV_FRETLOC, At("N",MV_FRETLOC)+1))
			nPosGan := ASCAN(aConGan,{|x| x[1]==cConc.And. x[3]==''})
			If nPosGan<>0
				aConGan[nPosGan][2]:=aConGan[nPosGan][2]+(Round(xMoeda(SF1->F1_FRETE,SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1))*nRatValimp)
			Else
				Aadd(aConGan,{cConc,Round(xMoeda(SF1->F1_FRETE,SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1))*nRatValimp,''})
			Endif
		EndIf

		If SF1->F1_DESPESA >  0
			MV_GASTLOC  := GetNewPar("MV_GASTLOC","IVA112GAN06")
			cConc   := Alltrim(Subs( MV_GASTLOC, At("N",MV_GASTLOC)+1))
			nPosGan := ASCAN(aConGan,{|x| x[1]==cConc.And. x[3]==''})
			If nPosGan<>0
				aConGan[nPosGan][2]:=aConGan[nPosGan][2]+Round(xMoeda(SF1->F1_DESPESA,SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1))*nRatValimp
			Else
				Aadd(aConGan,{cConc,Round(xMoeda(SF1->F1_DESPESA,SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1))*nRatValimp,''})
			Endif
		EndIf

		SD1->(DbSetOrder(1))
			If lMsFil
				SD1->(DbSeek(SF1->F1_MSFIL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
			Else
				SD1->(DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
			EndIf

		If SD1->(Found())
				Do while Iif(lMsFil, SD1->D1_MSFIL,xFilial("SD1"))==SD1->D1_FILIAL.And.SF1->F1_DOC==SD1->D1_DOC.AND.;
				SF1->F1_SERIE==SD1->D1_SERIE.AND.SF1->F1_FORNECE==SD1->D1_FORNECE;
				.AND.SF1->F1_LOJA==SD1->D1_LOJA.And.!SD1->(EOF())

				IF AllTrim(SD1->D1_ESPECIE)<>AllTrim(SE2->E2_TIPO)
					SD1->(DbSkip())
					Loop
				Endif

					aImpInf := TesImpInf(SD1->D1_TES)
					SFF->(DbSetOrder(2))
					If SFF->(Dbseek(xfilial("SFF")+Pad(SF1->F1_SERIE,len(SFF->FF_ITEM)) )) .and. Round(xMoeda(( SF1->F1_VALMERC - SF1->F1_DESCONT ),SF1->F1_MOEDA,1,,,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1)) > SFF->FF_FXDE
			 			nVlrTotal:= 0
			 			If SFF->(FieldPos("FF_INCIMP")) > 0
							For nI := 1 To Len(aImpInf)
					  			If(Trim(aImpInf[nI][01])$ SFF->FF_INCIMP)
									If aImpInf[nI][03] <> "3"
										nVlrTotal+=SD1->(FieldGet(FieldPos(aImpInf[nI][02])))
									EndIf
								EndIf
							Next nI
				 		EndIf
			 			nPosGan:=ASCAN(aConGan,{|x| x[1]==Pad(SF1->F1_SERIE,len(SFF->FF_ITEM)) })
						If nPosGan<>0
							aConGan[nPosGan][2]:=aConGan[nPosGan][2]+(Round(xMoeda((SD1->D1_TOTAL-SD1->D1_VALDESC+nVlrTotal),SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1)) * nRatValImp)
						Else
							Aadd(aConGan,{Pad(SF1->F1_SERIE,len(SFF->FF_ITEM)),Round(xMoeda((SD1->D1_TOTAL-SD1->D1_VALDESC+nVlrTotal),SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1)) * nRatValImp,''})
						Endif
					Else
						SB1->(DbSetOrder(1))
							SB1->(DbSeek(Iif(lMsFil .And. !Empty(xFilial("SB1")),SD1->D1_MSFIL,xFilial("SB1")) + SD1->D1_COD))

						If SB1->(Found()) .And. ((!lMonotrb .And. !Empty(SB1->B1_CONCGAN)) .Or. (SB1->(FieldPos("B1_CMONGAN"))>0 .And. !Empty(SB1->B1_CMONGAN) .And. lMonotrb))
							cConc2	:=	''
							If SB1->(FieldPos('B1_CONGANI'))>0 .AND.SB1->B1_CONCGAN=='02'
			               		cConc2	:=	SB1->B1_CONGANI
							Endif

								aAreaAtu:=GetArea()
								aAreaSFF:=SFF->(GetArea())
								dbSelectArea("SFF")
								dbSetOrder(2)
								If dbSeek(xFilial("SFF")+Iif(lMonotrb .And. SB1->(FieldPos("B1_CMONGAN"))>0,SB1->B1_CMONGAN,SB1->B1_CONCGAN)+'GAN')
									nVlrTotal:= 0
									nVlrTotIt:=0
									If SFF->(FieldPos("FF_INCIMP")) > 0
										For nI := 1 To Len(aImpInf)
					  						If(Trim(aImpInf[nI][01])$ SFF->FF_INCIMP)
												If aImpInf[nI][03] <> "3"
											   		nVlrTotal+=SD1->(FieldGet(FieldPos(aImpInf[nI][02])))
												EndIf
											EndIf
										Next nI
									EndIf
								Endif

								RestArea(aAreaAtu)
								SFF->(RestArea(aAreaSFF))

							nPosGan:=ASCAN(aConGan,{|x| x[1]==Iif(lMonotrb .And. SB1->(FieldPos("B1_CMONGAN"))>0,SB1->B1_CMONGAN,SB1->B1_CONCGAN) .And. x[3]==cConc2})

							If nPosGan<>0
								aConGan[nPosGan][2]:=aConGan[nPosGan][2]+(Round(xMoeda((SD1->D1_TOTAL-SD1->D1_VALDESC+nVlrTotal),SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1)) * nRatValImp)
							Else
								Aadd(aConGan,{Iif(lMonotrb .And. SB1->(FieldPos("B1_CMONGAN"))>0,SB1->B1_CMONGAN,SB1->B1_CONCGAN),Round(xMoeda((SD1->D1_TOTAL-SD1->D1_VALDESC+nVlrTotal),SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1)) * nRatValImp,cConc2})
							Endif

						Else
							For nY := 1 To Len(aRateioGan)
								aAreaAtu:=GetArea()
								aAreaSFF:=SFF->(GetArea())
								dbSelectArea("SFF")
								dbSetOrder(2)
								If dbSeek(xFilial("SFF")+aRateioGan[nY][5]+'GAN')
									nVlrTotal:= 0
									nVlrTotIt:=0
									If SFF->(FieldPos("FF_INCIMP")) > 0
										For nI := 1 To Len(aImpInf)
					  						If(Trim(aImpInf[nI][01])$ SFF->FF_INCIMP)
												If aImpInf[nI][03] <> "3"
											   		nVlrTotal+=SD1->(FieldGet(FieldPos(aImpInf[nI][02])))
												EndIf
											EndIf
										Next nI
									EndIf
								Endif

								RestArea(aAreaAtu)
								SFF->(RestArea(aAreaSFF))
									nPosGan:=ASCAN(aConGanRat,{|x| x[1]==aRateioGan[nY][5] .And. x[3]==''.And. x[4] == aRateioGan[nY][2]+aRateioGan[nY][3] .And. If(lMsFil .And. !Empty(xFilial("SA2")),x[5] == aRateioGan[nY][2]+aRateioGan[nY][6],.T.)})
								If nPosGan>0
									aConGanRat[nPosGan][2]+=(Round(xMoeda((SD1->D1_TOTAL-SD1->D1_VALDESC+nVlrTotal),SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1)) * nRatValImp)* aRateioGan[nY][4]
								Else
										If lMsFil .And. !Empty(xFilial("SA2"))
											Aadd(aConGanRat,{aRateioGan[nY][5],(Round(xMoeda((SD1->D1_TOTAL-SD1->D1_VALDESC+nVlrTotal),SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1)) * nRatValImp)* aRateioGan[nY][4],'',aRateioGan[nY][2]+aRateioGan[nY][3],aRateioGan[nY][6]})
										Else
											Aadd(aConGanRat,{aRateioGan[nY][5],(Round(xMoeda((SD1->D1_TOTAL-SD1->D1_VALDESC+nVlrTotal),SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1)) * nRatValImp)* aRateioGan[nY][4],'',aRateioGan[nY][2]+aRateioGan[nY][3]})
										Endif
								Endif
						Next
					Endif
				EndIf
				SD1->(DbSkip())
			Enddo
		Else
			For nY := 1 To Len(aRateioGan)
					nPosGan:=ASCAN(aConGanRat,{|x| x[1]==aRateioGan[nY][5] .And. x[3]==''.And. x[4] == aRateioGan[nY][2]+aRateioGan[nY][3] .And. If(lMsFil .And. !Empty(xFilial("SA2")) .And. xFilial("SF1") == xFilial("SE2"),x[5] == aRateioGan[nY][2]+aRateioGan[nY][6],.T.)})
				If nPosGan<>0
					aConGanRat[nPosGan][2]+= nValMerc * aRateioGan[nY][4]
				Else
						If lMsFil .And. !Empty(xFilial("SA2")) .And. xFilial("SF1") == xFilial("SE2")
							Aadd(aConGanRat,{aRateioGan[nY][5],nValMerc*aRateioGan[nY][4],'',aRateioGan[nY][2]+aRateioGan[nY][3],aRateioGan[nY][6]})
						Else
							Aadd(aConGanRat,{aRateioGan[nY][5],nValMerc*aRateioGan[nY][4],'',aRateioGan[nY][2]+aRateioGan[nY][3]})
						Endif
				Endif
			Next
		Endif
	Else
		nValMerc	 := Round(xMoeda(nSaldo,SE2->E2_MOEDA,1,,5,aTxMoedas[Max(SE2->E2_MOEDA,1)][2]),MsDecimais(1))
		For nY := 1 To Len(aRateioGan)
				nPosGan:=ASCAN(aConGanRat,{|x| x[1]==aRateioGan[nY][5] .And. x[3]==''.And. x[4] == aRateioGan[nY][2]+aRateioGan[nY][3] .And. If(lMsFil .And. !Empty(xFilial("SA2")) .And. xFilial("SF1") == xFilial("SE2"),x[5] == aRateioGan[nY][2]+aRateioGan[nY][6],.T.)})
			If nPosGan<>0
				aConGanRat[nPosGan][2]+= nValMerc * aRateioGan[nY][4]
			Else
					If lMsFil .And. !Empty(xFilial("SA2")) .And. xFilial("SF1") == xFilial("SE2")
						Aadd(aConGanRat,{aRateioGan[nY][5],nValMerc*aRateioGan[nY][4],'',aRateioGan[nY][2]+aRateioGan[nY][3],aRateioGan[nY][6]})
					Else
						Aadd(aConGanRat,{aRateioGan[nY][5],nValMerc*aRateioGan[nY][4],'',aRateioGan[nY][2]+aRateioGan[nY][3]})
					Endif
			Endif
		Next
	EndIf
Endif

//Faz o rateio dos condominos
For nY	:=	1	To Len(aConGan)
	For nX:= 1 To Len(aRateioGan)
			If lMsFil .And. !Empty(xFilial("SA2")) .And. xFilial("SF1") == xFilial("SE2")
				AAdd(aConGanRat,{aConGan[nY][1],aConGan[nY][2]*aRateioGan[nX][4],aConGan[nY][3],aRateioGan[nX][2]+aRateioGan[nX][3],aRateioGan[nY][6]})
			Else
				AAdd(aConGanRat,{aConGan[nY][1],aConGan[nY][2]*aRateioGan[nX][4],aConGan[nY][3],aRateioGan[nX][2]+aRateioGan[nX][3]})
			Endif
	Next
Next

//Distribue os acumulados ja rateados no array de acumulados total
For nY := 1 TO Len(aConGanRat)
		If lMsFil .And. !Empty(xFilial("SA2")) .And. xFilial("SF1") == xFilial("SE2")
			nPosGan   := ASCAN(aConGanOri,{|x|  x[1]+x[3]+x[4]+x[5] == aConGanRat[nY][1]+aConGanRat[nY][3]+aConGanRat[nY][4]+aConGanRat[nY][5]})
		Else
			nPosGan   := ASCAN(aConGanOri,{|x|  x[1]+x[3]+x[4] == aConGanRat[nY][1]+aConGanRat[nY][3]+aConGanRat[nY][4]})
		EndIf
	If nPosGan<>0
		aConGanOri[nPosGan][2]	+= aConGanRat[nY][2]
	Else
		Aadd(aConGanOri,aClone(aConGanRat[nY]))
	Endif
Next

EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Fa085aVldP�Autor  �Bruno Sobieski      � Data �  10/17/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida a digitacao do valor por pagar                       ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085a                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function Fa085aVldP()
Local nPosValor	:=	Ascan(aHeader,{|x| Alltrim(X[2])=="E2_VALOR"})
Local nPosSaldo	:=	Ascan(aHeader,{|x| Alltrim(X[2])=="E2_SALDO"})
Local nPosMulta	:=	Ascan(aHeader,{|x| Alltrim(x[2])=="E2_JUROS"})
Local nPosJuros	:=	Ascan(aHeader,{|x| Alltrim(x[2])=="E2_MULTA"})
Local nPosDesco :=	Ascan(aHeader,{|x| Alltrim(x[2])=="E2_DESCONT"})
Local nPosPagar :=	Ascan(aHeader,{|x| Alltrim(x[2])=="E2_PAGAR"})
Local nPosVl	:=Ascan(aHeader1,{|x| Alltrim(x[2])=="NVLMDINF"})
Local nPosMoeda	:= Ascan(aHeader,{|x| Alltrim(x[2])=="E2_MOEDA"})
Local nVlrParcial := &(ReadVar())
Local nValorSaldo	:= 0
Local nPosVlParc	:= 	Ascan(aHeader,{|x| Alltrim(x[2])=="E2_VLBXPAR"})
Local lRet	:=	.T.

lBxParc := IIf( Type("lBxParc")=="U", Iif(SE2->(FieldPos("E2_VLBXPAR")>0),.T.,.F.), lBxParc)
If nPosSaldo > 0 .or. nPosVlParc >0
	nValorSaldo := Iif(aCols[n][nPosSaldo]>0,aCols[n][nPosSaldo],0) + aCols[n][nPosPagar]
 	If lBxParc
		nValorSaldo :=Iif(aCols[n][nPosVlParc] > 0,aCols[n][nPosVlParc],nValorSaldo)       
	EndIf
	If	nVlrParcial  > (nValorSaldo + aCols[n][nPosJuros]+ aCols[n][nPosMulta]) - aCols[n][nPosDesco]
		MsgStop(OemToAnsi(STR0119)) //"El valor tipeado es MAYOR que el saldo"
		lRet:=.F.
	ElseIf nVlrParcial < 0
		MsgStop(OemToAnsi(STR0120)) //"El valor debe ser MAYOR o IGUAL a 0"
		lRet:=.F.
	EndIf
Else
	MsgStop(OemToAnsi(STR0129)) //"Habilite el campo E2_SALDO via configurador"
	lRet:=.F.
Endif

If lRet
	aCols[n][nPosVl]:= Iif(aCols[n][nPosVl]>=0,Round(xMoeda(nVlrParcial,aCols[n][nPosMoeda],nMoedaCor,,5,aTxmoedas[aCols[n][nPosMoeda]][2],aTxmoedas[nMoedaCor][2]),MsDecimais(nMoedaCor)),0)
EndIf

Return( lRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Fa085aTerc�Autor  �Microsiga           � Data �  11/21/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Permite escolher os cheques de terceiros                    ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC Function Fa085aTerc()        // incluido pelo assistente de conversao do AP5 IDE em 09/09/99
Local lTerceiro   := .F.
Local lAcepto	:=	.F.
Local cCliente	:=	Criavar("A2_COD")	,	cLoja	:=	Criavar("A2_LOJA")
Local cRecibo 	:=	Criavar("EL_RECIBO",.F.)
Local lTerc		:=	.T. , oTerc
Local oDlg
Local aTits		:=	{}
Local nRec		:=	0
Local oCart,lCart	:=	.F.
Local nAtLbx	:=	0
Local aRet		:=	{}
LOCAL cNextAlias	:=	GetNextAlias()
Local aDados	:= {} //Arreglo para el PE FI85ATCH   
Local blinePE   := {|| }   
Local bline1    := {|| }  
Private aCheques	:=	{}     
Private oOk			:= LoadBitMap(GetResources(), "BR_VERDE")
Private oNo			:= LoadBitMap(GetResources(), "BR_VERMELHO")
Private oLbx        := .T. 

If Type("nValor")=="U"
	nValor	:=	0
EndIf
//+---------------------------------------------------------------------+
//� Criacao da Interface para pedir dados do cheque                     �
//+---------------------------------------------------------------------+
If ExistBlock("A85CHPDT")
   	aCheques	:=	ExecBlock("A85CHPDT",.F.,.F.)
Else
	Define MSDIALOG oDlg FROM 65,000 To 200,340  Title OemToAnsi(iiF(!(cPaisLoc $ "PTG|CHI"),STR0121,STR0177)) PIXEL //"Pago con Cheques de Terceros."
	@ 01,003 To 68,130 Label OemToAnsi(iiF(!(cPaisLoc $ "PTG|CHI"),STR0122,STR0178))	Of oDlg PIXEL //"Datos del cheque"
	@ 12,008 SAY OemToAnsi(STR0123) SIZE 30,10 Of oDlg PIXEL //"Cliente"
	@ 12,040 MSGET cCliente F3 "SA1" VALID ExistCpo("SA1",cCliente)   HASBUTTON			SIZE 50,10 Of oDlg PIXEL
	@ 12,090 MSGET cLoja   				VALID ExistCpo("SA1",cCliente+cLoja) 	SIZE 08,10 Of oDlg PIXEL

	@ 25,008 SAY OemToAnsi(STR0124) SIZE 30,10 Of oDlg PIXEL //"Recibo"
	@ 25,040 MSGET cRecibo  VALID (Empty(cRecibo) .Or. EXISTCPO("SEL",cRecibo)) SIZE 30,10 Of oDlg PIXEL
	If !(cPaisLoc $ "PTG|CHI")
		@ 40,008 CHECKBOX oTerc	VAR lTerc	Prompt OemToAnsi(STR0125)  SIZE 80,10 Of oDlg PIXEL //"Solo liberados por clientes"
		@ 53,008 CHECKBOX oCart	VAR lCart	Prompt OemToAnsi(STR0126)  SIZE 115,10 Of oDlg PIXEL //"Mostrar cheques depositados no acreditados"
	Endif
	DEFINE SBUTTON FROM 35,135 Type 1 Action (lAcepto:=.T.,oDlg:End()) Of oDlg PIXEL ENABLE
	DEFINE SBUTTON FROM 52,135 Type 2 Action oDlg:End() Of oDlg PIXEL ENABLE
	Activate Dialog oDlg CENTERED

	//Carregar o array com os cheques segundo as opcoes escolhidas.
	If lAcepto
		If Empty(cRecibo)
			If cPaisLoc $ "PTG|CHI"
				DbSelectArea("SE1")
				DbSetOrder(2)
				#IFNDEF TOP
					DbSeek(xFilial()+cCliente+cLoja)
					While !EOF() .And. 	xFilial()+cCliente+cLoja == E1_FILIAL+E1_CLIENTE+E1_LOJA
						If E1_SALDO > 0  .And. (E1_SITUACA $ " 0"  ) .And. E1_OK <> cMarcaE1
							AAdd(aCheques,{E1_SITUACA,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_VALOR,E1_MOEDA,E1_EMISSAO,E1_VENCTO,E1_TIPO,SE1->(Recno())})
						Endif
						DbSelectArea("SE1")
						DbSkip()
					Enddo
				#ELSE
					//-- Query que apura a quantidade de processos trabalhistas e os valores das causas
					nTamSX31	:=	  TAMSX3('E1_SALDO')[1]
					nTamSX32	:=	  TAMSX3('E1_SALDO')[2]
					cNotIn		:= '%'+FormatIn(MVPROVIS+"/"+MVRECANT+"/"+MV_CRNEG+"/"+MVENVBCOR,"/")+"%"
					BeginSql alias cNextAlias
						COLUMN E1_EMISSAO AS DATE
						COLUMN E1_VENCTO AS DATE
						COLUMN E1_SALDO AS NUMERIC(nTamSX31,nTamSX32)
						SELECT E1_SITUACA,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_SALDO,E1_MOEDA,E1_EMISSAO,E1_VENCTO,R_E_C_N_O_ as RECSE1,E1_TIPO
						FROM %table:SE1% SE1
						WHERE E1_FILIAL=%xFilial:SE1%
							AND E1_CLIENTE= %exp:cCliente%
							AND E1_LOJA   = %exp:cLoja%
							AND E1_OK   <> %exp:cMarcaE1%
							AND E1_TIPO NOT IN %exp:cNotIn%
							AND E1_SITUACA IN ('0',' ')
							AND SE1.%notDel%
						ORDER BY %Order:SE1%
					EndSql
					DbSelectArea(cNextAlias)
					While !EOF()
						AAdd(aCheques,{E1_SITUACA,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_SALDO,E1_MOEDA,E1_EMISSAO,E1_VENCTO,E1_TIPO,RECSE1})
						DbSkip()
					Enddo
					dBcLOSEAREA()
					DbSelectArea("SE1")
				#ENDIF

			Else
				DbSelectArea("SE1")
				DbSetOrder(2)
				DbSeek(xFilial()+cCliente+cLoja)
				While !EOF() .And. 	xFilial()+cCliente+cLoja == E1_FILIAL+E1_CLIENTE+E1_LOJA
					If E1_SALDO > 0 .And. E1_TIPO	$IIF(Type('MVCHEQUES')=='C',MVCHEQUES,MVCHEQUE) .And. (E1_SITUACA $ " 0"  .Or. lCart) .And. E1_OK <> cMarcaE1
						If lTerc
							DbSelectArea("SEL")
							DbSetorder(2)
							DbSeek(xFilial()+SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA))
							If Found() .And. EL_TERCEIR	<>	"2"
								DbSelectArea("SE1")
								AAdd(aCheques,{E1_SITUACA,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_SALDO,E1_MOEDA,E1_EMISSAO,E1_VENCTO,E1_TIPO,SE1->(Recno())})
							Endif
						Else
							AAdd(aCheques,{E1_SITUACA,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_SALDO,E1_MOEDA,E1_EMISSAO,E1_VENCTO,E1_TIPO,SE1->(Recno())})
						Endif
					Endif
					DbSelectArea("SE1")
					DbSkip()
				Enddo
			Endif
		Else
			DbSelectArea("SEL")
			DbSetOrder(1)
			DbSeek(xFilial()+cRecibo)
			While !EOF().And. xFilial()+cRecibo	==	SEL->(EL_FILIAL+EL_RECIBO)
				If EL_TIPO $ IIF(Type('MVCHEQUES')=='C',MVCHEQUES,MVCHEQUE).And. (!lTerc .Or. EL_TERCEIR<>"2" )  .And. cCliente+cLoja==EL_CLIENTE+EL_LOJA .And. !EL_CANCEL
					DbSelectArea("SE1")
					DbSetOrder(2)
					DbSeek(xFilial()+SEL->(EL_CLIENTE+EL_LOJA+EL_PREFIXO+EL_NUMERO+EL_PARCELA+EL_TIPO))
					If Found() .And. E1_SALDO > 0 .And. (E1_SITUACA $ " 0"  .Or. lCart).And. E1_OK <> cMarcaE1
						AAdd(aCheques,{E1_SITUACA,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_SALDO,E1_MOEDA,E1_EMISSAO,E1_VENCTO,E1_TIPO,SE1->(Recno())})
					Endif
				Endif
				DbSelectArea("SEL")
				DbSkip()
			Enddo
		Endif
	Endif
EndIf

If Len(aCheques) > 0
	If lCart
		aSort(aCheques,,,{|X,Y| x[1] < y[1]})
	Endif
	lAcepto	:=	.F.
	DbSelectArea("SX3")
	DbSetOrder(2)
	Aadd(aTits," ")

	DbSeek("E1_TIPO")
	Aadd(aTits,X3TITULO())
	DbSeek("E1_PREFIXO")
	Aadd(aTits,X3TITULO())
	DbSeek("E1_NUM")
	Aadd(aTits,X3TITULO())
	DbSeek("E1_PARCELA")
	Aadd(aTits,X3TITULO())
	DbSeek("E1_VALOR")
	Aadd(aTits,X3TITULO())
	DbSeek("E1_MOEDA")
	Aadd(aTits,X3TITULO())
	DbSeek("E1_EMISSAO")
	Aadd(aTits,X3TITULO())
	DbSeek("E1_VENCREA")
	Aadd(aTits,X3TITULO())

	//���������������������������������������������������������Ŀ
	//�Ponto de entrada para modificar a ordem de apresentacao  �
	//�dos cheques                       				        �
	//�����������������������������������������������������������
	 IF ExistBlock("FI85ACH")
		aCheques:= ExecBlock("FI85ACH",.F.,.F.,aCheques)
	 Endif             
	 
	//���������������������������������������������������������Ŀ
	//�Ponto de entrada para agregar columnas al grid de la pan-�
	//�talla "Elija cheque" - Pago con cheques a terceros.      �
	//�����������������������������������������������������������
	bline1  := { || {IIf(aCheques[oLbx:nAt][1]$" 0",oOk,oNo),aCheques[oLbx:nAt][9],aCheques[oLbx:nAt][2],aCheques[oLbx:nAt][3],aCheques[oLbx:nAt][4],TransForm(aCheques[oLbx:nAt][5],TM(aCheques[oLbx:nAt][5],18,MsDecimais(aCheques[oLbx:nAt][6])) ),aCheques[oLbx:nAt][6],DTOC(aCheques[oLbx:nAt][7]),DTOC(aCheques[oLbx:nAt][8])}}
 	If  ExistBlock('FI85ATCH')        
		aDados	 := ExecBlock('FI85ATCH',.F.,.F.,{aTits,aCheques,blinePE})
		aTits    := aClone(aDados[1])
		aCheques := aClone(aDados[2])
		blinePE  := aDados[3]     
		bline1   := blinePE
	Endif
	 
	//+---------------------------------------------------------------------+
	//� Criacao da Interface para escolher o Cheque                         �
	//+---------------------------------------------------------------------+
	Define MSDIALOG oDlg FROM 0,0 To 275,655 Title OemToAnsi(If(cPaisLoc=="PTG",STR0179,STR0112)) PIXEL //"Elija el cheque"
	@ 001,001 To 133,295 OF oDlg PIXEL
	DEFINE SBUTTON FROM 120,300 Type 1 Action ( If(Fa085aConf(oLbx,aCheques),(nAtLbx:=oLbx:nAt,oDlg:End()),Nil) ) ENABLE Of oDlg PIXEL
	oLbx := TWBrowse():New( 07,07,283,120,,aTits,{5,18,50,15,63,18,35,35},oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oLbx:SetArray(aCheques)
	oLbx:bLine:= bline1
	oLbx:bLDblClick	:=	{ ||  If(Fa085aConf(oLbx,aCheques),(nAtLbx:=oLbx:nAt,oDlg:End()),Nil) }

	Activate MSDIALOG oDLG CENTERED
	If nAtLbx	>	0
		DbSelectArea("SE1")
		//������������������������������������������������������������������Ŀ
		//�Se ja estava escolhido um cheque de terceiros nesta linha do acols�
		//�o aRecChqTer vai conter o registro que estava lockeado,           �
		//�Entao, se o escolhido agora for diferente daquele, deslockeio.    �
		//��������������������������������������������������������������������
		If Len(aRecChqTer) >= Len(aCols) .And. aRecChqTer[n] > 0 .And. aRecChqTer[n] <> aCheques[nAtLbx][Len(aCheques[nAtLbx])]
			MsGoTo(aRecChqTer[n])
			Replace	E1_OK	With "  "
			MsRUnlock(aRecChqTer[n])
			nvalor:= nvalor-SE1->E1_VALOR
		Else        
			If nvalor < SE1->E1_VALOR
				nvalor:= SE1->E1_VALOR
			End if 			
		Endif
		MsGoTo(aCheques[nAtLbx][Len(aCheques[nAtLbx])] )
		aRet	:=	{SE1->E1_NUM,SE1->E1_SALDO,SE1->E1_MOEDA,SE1->E1_EMISSAO,SE1->E1_VENCREA,SE1->E1_TIPO,SE1->E1_PARCELA,SE1->(RECNO())}
	Endif
Endif

Return	aRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Fa085aconf�Autor  �Microsiga           � Data �  11/21/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Confirma a marcacao de um cheque de terceiros               ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Fa085aConf(oLbx,aCheques)
Local lRet	:= .F.
Local nPos	:= 0
Local nX  	:= 0
DbSelectArea("SE1")
MsGoto(aCheques[oLbx:nAt][Len(aCheques[oLbx:nAt])])
If SE1->E1_SITUACA $ " 0"
	nPos	:=	Ascan(aRecChqTer,SE1->(RECNO()))
	If nPos	==	0 .Or. nPos == n
		For nX	:=	0	To	2	STEP 0.25
			If MsRlock()
				Replace	E1_OK	With cMarcaE1
				lRet	:=	.T.
				nX		:=	2
			Endif
		Next
		If !lRet
			MsgAlert(OemToAnsi(STR0113)) //"El cheque est� en uso y no puede ser marcado"
		Endif
	Else
		MsgAlert(OemToAnsi(STR0114+STRZERO(nPos,2))) //"El cheque fue marcado en el item "
	Endif
Endif

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GravaPagos�Autor  �Leonardo Gentile    � Data �  04/01/01   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fazer todo o tratamento de gravacao dos registros referente ���
���          �aos pagos (por default ou diferenciado)                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GravaPagos( nPagar, cBanco, cAgencia, cConta, cNumChq, cFornece, cLoja, cNome,;
nMoeda, nTotal, dDtEmis, dDtVcto, cDebMed, cDebInm, nRegSE1,cParcela,nBaseITF,aHdlPrv,lCBU,lPa,nRecEQU,cChqEQU,nValMoed1,nValMOrig)
Local cSeqFRF
Local nMoedaBco	:=	1
Local nSize
Local aArea:={}
Local nValorTit:=0
Local lFindITF    := FindFunction("FinProcITF")
Local cPrefixo := ""
Local cFiltroSe2:=""
Local lUsaFlag		:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/ )
Local cFilSe2 := cFilAnt
Local cFilOrSe2 := cFilAnt
Private cDesc := Iif(SEK->(FieldPos("EK_DCONCEP"))>0,cDesc,"")

DEFAULT lPa=.F.
Default lCBU := .F.
DEFAULT nValMoed1 := 0
DEFAULT cDebMed := ""
If !IsMemVar("__cUUID")
	Private __cUUID := ""
EndIf
cBanco   := If( cBanco	=nil, "", cBanco)
cAgencia := If( cAgencia=nil, "", cAgencia)
cConta   := If( cConta	=nil, "", cConta)
cNumChq  := If( cNumChq	=nil, "", cNumChq)
cParcela := If( cParcela=nil, "", cParcela)
If SE2->(RECNO()) >0 
	cFilSe2 := SE2->E2_FILIAL
	cFilOrSe2 := SE2->E2_FILORIG
Endif

If !Empty(cBanco)
	SA6->(DbSetOrder(1))
	SA6->(DbSeek(xFilial()+cBanco+cAgencia+cConta))
	nMoedaBco	:=	Iif(SA6->A6_MOEDAP>0,SA6->A6_MOEDAP,SA6->A6_MOEDA)
	nMoedaBco	:=	Max(nMoedaBco,1)
Endif

SA2->(DbSetOrder(1))
SA2->(DbSeek(xFilial()+cFornece+cLoja))

If lF085aChS .and. nPagar==1
	nPagar++
Endif

//���������������������������������������������������������������Ŀ
//�Pegar a numero que vou usar para numerar os documentos gerados.�
//�����������������������������������������������������������������
If (nPagar == 2 .Or. nPagar == 3 .OR. (nPagar ==1 .AND. cPaisLoc $ "EQU|DOM|COS")) .And. (Empty(cNumChq) .Or.Substr(cNumChq,1,1)=='*')
	If ExistBlock("A085ANUM")
		cNumChq	:=	ExecBlock("A085ANUM",.F.,.F.,{nPagar,cFornece,cLoja,dDtVcto})
		If ExistBlock("A085PRECH")
			cFiltroSE2 :=	SE2->(DbFilter())  // Salva o filtro para que possa ser consultado todo o SE2 no RDMAKE
	 		SE2->(dbClearFilter())
			cPrefixo :=	ExecBlock("A085PRECH",.F.,.F.,{cNumChq,cFornece,cLoja,cBanco,cAgencia,cConta})
			DbSelectArea("SE2")
			SET FILTER TO &cFiltroSE2  // Restaura o filtro original
		EndIF
	Else
		aArea	:=GetArea()
		DbSelectArea("SA6")
		cDebInm := IIf(valtype(cDebInm) == "U", "",cDebInm)
		cCampo	:=	"A6_NUM"+Iif(nPagar==2,cDebMed,cDebInm)
		If SA6->(FieldPos(cCampo)) > 0
			nSize	:=	Len(Alltrim(&cCampo.))
			nSize	:=	If(nSize == 0,TamSX3("E2_NUM")[1],nSize)
			cNumChq	:=	&cCampo
			Reclock("SA6",.F.)
			Replace &cCampo	With StrZero(Val(&cCampo.)+1,nSize)
			MsUnLock()
		Else
			cNumChq	:=	cOrdPago
		Endif
		RestArea(aArea)
	Endif

	// VALIDACAO PARA VERIFICAR SE ESTE NUMERO DE CHEQUE JA ESTA CADASTRADO NO SE2, E CASO ESTEJA
	// AUMENTAR O NUMERO DA PARCELA PARA NAO GERAR DUPLICIDADE
	cDebMed := IIf(valtype(cDebMed) == "U", "",cDebMed)
	If !(cPaisLoc $ "EQU|DOM|COS")
	    cNum:= cNumChq + Space(TamSX3("E2_NUM")[1]-Len(cNumChq))
		aAreaSE2:= SE2->(GetArea())
		cFiltroSE2 :=	SE2->(DbFilter())  // Salva o filtro para que possa ser consultado todo o SE2 no RDMAKE
		SE2->(dbClearFilter())
		dbSelectArea("SE2")
		dbSetOrder(1)
		If SE2->(dbSeek(xFilial("SE2")+space(TamSX3("E2_PREFIXO")[1])+ cNum + If(!Empty(cParcela),cParcela,space(TamSX3("E2_PARCELA")[1])) + cDebMed + cFornece + cLoja)) .And. SE2->E2_PORTADO <> SA6->A6_COD
			If Empty(cParcela)
				cParcela := GetMV("MV_1DUP")
			Else
				Soma1( cParcela,, .T. )
			Endif
		Endif
		DbSelectArea("SE2")
		SET FILTER TO &cFiltroSE2  // Restaura o filtro original
		RestArea(aAreaSE2)
	EndIf
EndIf

//���������������������������������������������������������������������������Ŀ
//�Gravar os debitos inmediatos (Transferencias, Cash, Cartao de debito, etc).�
//�����������������������������������������������������������������������������
If 	nPagar == 3 .And. nTotal > 0
	RecLock( "SE5", .T.)
	SE5->E5_FILIAL		:= xFilial("SE5")
	If cPaisLoc $ "ARG|PAR|MEX" 
		SE5->E5_FILORIG      := cFilOrSe2
	Else
		SE5->E5_FILORIG      := cFilSe2
	EndIf
	SE5->E5_VALOR     	:= Round(xMoeda(nTotal,nMoeda,nMoedaBco,,5,aTxMoedas[nMoeda][2],aTxMoedas[nMoedaBco][2]),MsDecimais(nMoedaBco))
	SE5->E5_RECPAG    	:= "P"
	SE5->E5_HISTOR    	:= STR0099 + cOrdPago //"Ord. pago "
	SE5->E5_DTDIGIT   	:= dDataBase
	SE5->E5_DATA      	:= dDataBase
	SE5->E5_NATUREZ 	:= cNatureza
	SE5->E5_TIPODOC   	:= "VL"
	SE5->E5_PREFIXO   	:= ""
	SE5->E5_NUMERO   	:= cNumChq
	SE5->E5_PARCELA   	:= ""
	SE5->E5_CLIFOR    	:= cFornece
	SE5->E5_LOJA      	:= cLoja
	SE5->E5_BENEF     	:= cNome
	SE5->E5_MOTBX     	:= "NOR"
	SE5->E5_PARCELA		:= cParcela
	//Gravar a moeda2 em moeda 1 para facilitar a contabilizacao
	SE5->E5_VLMOED2   	:= Round(xMoeda(nTotal,nMoeda,1,,5,aTxMoedas[nMoeda][2]),5)
	SE5->E5_ORDREC	   	:= cOrdPago
	SE5->E5_TIPO      	:= cDebInm
	SE5->E5_NUMLIQ    	:= cLiquid
	SE5->E5_BANCO 	   	:= cBanco
	SE5->E5_AGENCIA   	:= cAgencia
	SE5->E5_CONTA     	:= cConta
	SE5->E5_NUMCHEQ		:= If(cPaisLoc $ "EQU|DOM|COS",cChqEQU,cNumChq)
	SE5->E5_MOEDA     	:= StrZero(nMoedaBco,2)
	SE5->E5_VENCTO    	:= dDataBase
	SE5->E5_DTDISPO   	:= dDtVcto
	SE5->E5_LA        	:= "S"
	If FieldPos("E5_TXMOEDA")>0
		SE5->E5_TXMOEDA		:= aTxMoedas[nMoedaBco][2]
	EndIf
	MsUnLock()
	AtuSalBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,SE5->E5_DATA,SE5->E5_VALOR,"-")
	IF lPa
	   if lFindITF .And. FinProcITF( SE5->( RecNo() ),1 ) .and. lRetCkPG(3,,SE5->E5_BANCO)
	      nBaseITF:=if(nBaseITF=0,SE5->E5_VALOR,nBaseITF)
	     else
	      nBaseITF:=0
	   endif
	  Else
	   if lFindITF .And. FinProcITF( SE5->( RecNo() ),1 ) .and. lRetCkPG(3,,SE5->E5_BANCO)
	      nBaseITF=SE5->E5_VALOR
	   endif
	endif
	//verifico se o sistema esta parametrizado corretamente para efetuar lancamento do imposto ITF
	If lFindITF .AND. nBaseITF > 0 .AND. FinProcITF( SE5->( RecNo() ),1 ).AND. lRetCkPG(3,,SE5->E5_BANCO)
		//faco o lancamento do imposto ITF na movimentacao bancaria e retorno os dados para contabilizacao
		FinProcITF( SE5->( RecNo() ), 3, nBaseITF , .F., aHdlPrv,  )
	EndIf
//��������������������������������������������������������������������������Ŀ
//�Gravar os debitos mediatos (Cheques, Letras, Etc), e os cheques "avulsos".�
//����������������������������������������������������������������������������
ElseIf nPagar <> 4
   	If	( nPagar == 1 .Or. (nPagar	==	2	.And.	Trim(cDebMed) == Trim(MVCHEQUE)) ) .And. nTotal > 0
		If cPaisLoc $ "EQU|DOM"
			SEF->(DbGoTo(nRecEQU))
			If SEF->(Recno()) == nRecEQU
				RecLock("SEF",.F.)
				SEF->EF_VALOR   := Round(xMoeda(nTotal,nMoeda,nMoedaBco,,5,aTxMoedas[nMoeda][2],aTxMoedas[nMoedaBco][2]),MsDecimais(nMoedaBco))
				//������������������������������������������������������������������������Ŀ
				//�Grava o numero do cheque somente se for pagamento diferenciado          �
				//��������������������������������������������������������������������������
				SEF->EF_BENEF	:= cNome
				SEF->EF_VENCTO	:= dDtVcto
				SEF->EF_DATA	:= dDtEmis
				SEF->EF_HIST 	:= STR0099+cOrdPago //"Ord. pago "
				SEF->EF_LIBER 	:= If(nPagar==1,GetMV("MV_LIBCHEQ"),"S")
				SEF->EF_FORNECE	:= cFornece
				SEF->EF_LOJA	:= cLoja
				SEF->EF_LA     	:= "S"
				SEF->EF_SEQUENC	:= PadL("1",TamSX3("EF_SEQUENC")[1],"0")
				SEF->EF_PARCELA	:= cParcela
				SEF->EF_STATUS		:=	"02"
				If nPagar==1 .AND. !(cPaisLoc $ "EQU|DOM|COS")   // cheque pre-impresso
					SEF->EF_TITULO  := cOrdPago
					SEF->EF_TIPO    :="ORP"
				ElseIf Trim(cDebMed)==Trim(MVCHEQUE).And. Subs(cNumChq,1,1)=="*"
					SEF->EF_TITULO  := cOrdPago
					SEF->EF_TIPO    :=Trim(MVCHEQUE)
				ElseIf Trim(cDebMed)==Trim(MVCHEQUE)
					SEF->EF_TITULO  := cOrdPago
					SEF->EF_TIPO    :=Trim(MVCHEQUE)
				Endif
				SEF->(MsUnlock())
				cSeqFRF := GetSx8Num("FRF","FRF_SEQ")
			    RecLock("FRF",.T.)
			    FRF->FRF_FILIAL		:= xFilial("FRF")
			    FRF->FRF_BANCO		:= SEF->EF_BANCO
			    FRF->FRF_AGENCIA	:= SEF->EF_AGENCIA
			    FRF->FRF_CONTA		:= SEF->EF_CONTA
			    FRF->FRF_NUM		:= SEF->EF_NUM
			    FRF->FRF_PREFIX		:= SEF->EF_PREFIXO
			    FRF->FRF_CART		:= "P"
			    FRF->FRF_DATPAG		:= dDataBase
			    FRF->FRF_MOTIVO		:= "99"
			    FRF->FRF_DESCRI		:= STR0227 //"CHEQUE VINCULADO A PAGAMENTO"
			    FRF->FRF_SEQ		:= cSeqFRF
			    FRF->(MsUnLock())
			    ConfirmSX8()
			Endif
		Else
			RecLock("SEF",.T.)
			SEF->EF_FILIAL 	:= xFilial("SEF")
			SEF->EF_VALOR   := Round(xMoeda(nTotal,nMoeda,nMoedaBco,,5,aTxMoedas[nMoeda][2],aTxMoedas[nMoedaBco][2]),MsDecimais(nMoedaBco))
			//������������������������������������������������������������������������Ŀ
			//�Grava o numero do cheque somente se for pagamento diferenciado          �
			//��������������������������������������������������������������������������
			If nPagar == 2 .And. Trim(cDebMed) == Trim(MVCHEQUE)
				SEF->EF_NUM	:= cNumChq
			EndIf
			SEF->EF_BANCO	:= cBanco
			SEF->EF_AGENCIA	:= cAgencia
			SEF->EF_CONTA	:= cConta
			SEF->EF_BENEF	:= cNome
			SEF->EF_VENCTO	:= dDtVcto
			SEF->EF_DATA	:= dDtEmis
			SEF->EF_HIST 	:= STR0099+cOrdPago //"Ord. pago "
			SEF->EF_CART 	:= "P"
			SEF->EF_LIBER 	:= If(nPagar==1,GetMV("MV_LIBCHEQ"),"S")
			SEF->EF_ORIGEM 	:= "FINA085A"
			SEF->EF_FORNECE	:= cFornece
			SEF->EF_LOJA	:= cLoja
			SEF->EF_LA     	:= "S"
			SEF->EF_SEQUENC	:= "01"
			If SEF->(FieldPos("EF_STATUS")) > 0 .And. lBaixaChq  
				SEF->EF_STATUS		:=	"02"			
			Endif 
			SEF->EF_PARCELA	:= cParcela
			If nPagar==1  .AND. !(cPaisLoc $ "EQU|DOM|COS") // cheque pre-impresso
				SEF->EF_TITULO  := cOrdPago
				SEF->EF_TIPO    :="ORP"
			ElseIf Trim(cDebMed)==Trim(MVCHEQUE).And. Subs(cNumChq,1,1)=="*"
				SEF->EF_TITULO  := cOrdPago
				SEF->EF_TIPO    :=Trim(MVCHEQUE)
			ElseIf Trim(cDebMed)==Trim(MVCHEQUE)
				SEF->EF_TITULO  := cOrdPago
				SEF->EF_TIPO    :=Trim(MVCHEQUE)
			Endif
			MsUnlock()
		Endif
	Endif

	If (nPagar ==2 .OR. (nPagar ==1 .AND. cPaisLoc $ "EQU|DOM|COS")) .And. nTotal > 0 // debito mediato (CH)
		dbSelectArea("SE2")
		// GERAR SE2
		RecLock("SE2",.T.)
		SE2->E2_FILIAL	:= xFilial("SE2")
		SE2->E2_NUMLIQ	:= cLiquid
		If cPaisLoc $ "EQU|DOM|COS" .and. SEF->(Recno()) == nRecEQU
			SE2->E2_NUMBCO		:=	cChqEQU
			SE2->E2_PREFIXO	:=	SEF->EF_PREFIXO
		Endif
		SE2->E2_NUM   	:= cNumChq
		SE2->E2_TIPO 	:= cDebMed
		SE2->E2_NATUREZ := cNatureza
		SE2->E2_FORNECE	:= cFornece
		SE2->E2_LOJA  	:= cLoja
		SE2->E2_NOMFOR 	:= cNome
		SE2->E2_EMISSAO	:= dDtEmis
		SE2->E2_EMIS1 	:= dDtEmis
		SE2->E2_VENCTO	:= dDtVcto
		SE2->E2_VENCREA	:= DataValida(dDtVcto,.T.)
		nValorTit:=  Round(xMoeda(nTotal,nMoeda,nMoedaBco,,5,aTxMoedas[nMoeda][2],aTxMoedas[nMoedaBco][2]),MsDecimais(nMoedaBco))
		SE2->E2_VALOR   := nValorTit
		SE2->E2_VENCORI	:= DataValida(dDtVcto,.T.)
		SE2->E2_PARCELA :=cParcela
		If lBaixaChq
			SE2->E2_VALLIQ   := nValorTit
			SE2->E2_SALDO    := 0
			SE2->E2_BAIXA    := dDataBase
			SE2->E2_MOVIMEN  := dDataBase
			SE2->E2_BCOPAG   := cBanco
		Else
			SE2->E2_SALDO    := nValorTit
		Endif
		SE2->E2_VLCRUZ 	:= Round(xMoeda(nTotal,nMoedaBco,1,,5,aTxMoedas[nMoeda][2]),MsDecimais(1))
		SE2->E2_MOEDA   := nMoedaBco
		SE2->E2_SITUACA  := "0"
		SE2->E2_PORTADO  := cBanco
		SE2->E2_BCOCHQ   := cBanco
		SE2->E2_AGECHQ   := cAgencia
		SE2->E2_CTACHQ   := cConta
		SE2->E2_ORDPAGO  := cOrdpago
		SE2->E2_ORIGEM 	 := "FINA085A"
		SE2->E2_LA       :=  "S"
		SE2->E2_FILORIG   := cFilOrSe2 // mlcm
		If SE2->(FieldPos("E2_CGC")) > 0
			SE2->E2_CGC		 := SA2->A2_CGC
		EndIf
		If FieldPos("E2_TXMOEDA")>0
			SE2->E2_TXMOEDA := aTxMoedas[Max(nMoedaBco,1)][2]//GRAVA A TAXA DA MOEDA DO PA
		EndIf
		If SE2->(FieldPos("E2_DATALIB")) > 0
			SE2->E2_DATALIB:= dDtEmis
		EndIf
		If !Empty(cPrefixo)
			SE2->E2_PREFIXO   	:= cPrefixo
		EndIf
		MsUnlock()
		FKCommit()
		If lBaixaChq .and. !(cPaisLoc $ "EQU|DOM")

			RecLock( "SE5", .T.)
			SE5->E5_FILIAL		:= xFilial("SE5")
			SE5->E5_VALOR     	:= Round(xMoeda(nTotal,nMoeda,nMoedaBco,,5,aTxMoedas[nMoeda][2],aTxMoedas[nMoedaBco][2]),MsDecimais(nMoedaBco))
			SE5->E5_RECPAG    	:= "P"
			SE5->E5_HISTOR    	:= STR0140  // "DEBITO CC"
			SE5->E5_DTDIGIT   	:= dDataBase
			SE5->E5_DATA      	:= dDataBase
			SE5->E5_TIPODOC   	:= "VL"
			SE5->E5_NUMERO   	:= cNumChq
			SE5->E5_PARCELA   	:= cParcela
			SE5->E5_CLIFOR    	:= cFornece
			SE5->E5_LOJA      	:= cLoja
				SE5->E5_BENEF     	:= cNome
			SE5->E5_MOTBX     	:= "DEB"
				//Gravar a moeda2 em moeda 1 para facilitar a contabilizacao
			If lPa
  				SE5->E5_VLMOED2   	:= Round(xMoeda(nTotal,nMoeda,1,,5,aTxMoedas[nMoeda][2]),5)
			Else
 				SE5->E5_VLMOED2	 := nValMOrig
		  	EndIf
			SE5->E5_SEQ       	:= PadL("1",TamSX3("E5_SEQ")[1],"0")
			SE5->E5_TIPO      	:= cDebMed
			SE5->E5_BANCO 	   	:= cBanco
			SE5->E5_AGENCIA   	:= cAgencia
			SE5->E5_CONTA     	:= cConta
			SE5->E5_MOEDA     	:= StrZero(nMoedaBco,2)
			SE5->E5_DTDISPO   	:= dDtVcto
			SE5->E5_NATUREZ     := cNatureza //?
			If FieldPos("E5_TXMOEDA")>0
				SE5->E5_TXMOEDA		:= aTxMoedas[nMoedaBco][2]
			EndIf
			If !Empty(cPrefixo)
				SE5->E5_PREFIXO   	:= cPrefixo
			EndIf

			If lUsaFlag .and. ( GetMv("MV_CTBAIXA") <> "B" ) // SOMENTE SE CHEQUE OU AMBOS
				SE5->E5_LA		:= "S"
			EndIf
			MsUnLock()
			FKCommit()
			AtuSalBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,SE5->E5_DATA,SE5->E5_VALOR,"-")
			//verifico se o sistema esta parametrizado corretamente para efetuar lancamento do imposto ITF
			IF  cPaisLoc == "COL" .and. lFindITF .AND. FinProcITF( SE5->( RecNo() ),1 )
					nBaseITf := SE5->E5_VALOR
			End IF
			If lFindITF .And. nBaseITF > 0 .AND. FinProcITF( SE5->( RecNo() ),1 ) .AND. lRetCkPG(3,,SE5->E5_BANCO)
				//faco o lancamento do imposto ITF na movimentacao bancaria e retorno os dados para contabilizacao
				FinProcITF( SE5->( RecNo() ), 3, nBaseITF , .F., aHdlPrv  )
			EndIf
		Else
			Reclock("SA2",.F.)
			SA2->A2_SALDUP	:= SA2->A2_SALDUP  + Round(xMoeda(nValorTit,nMoedaBco,1,,5,aTxMoedas[nMoedaBco][2]),MsDecimais(1))
			SA2->A2_SALDUPM	:= SA2->A2_SALDUPM + Round(xMoeda(nValorTit,nMoedaBco,nMVCusto,,5,aTxMoedas[nMoedaBco][2],aTxMoedas[nMVCusto][2]),MsDecimais(nMVCusto))
			MsUnlock()
		EndIf
	EndIf
Else
	//��������������������������������������������������Ŀ
	//�Baixar cheques de terceiros aplicados no pagamento�
	//����������������������������������������������������
	If nRegSE1 # nil
		SE1->( MsGoto( nRegSE1))
		If !SE1->(Eof())
			RecLock( "SE5", .T.)
			SE5->E5_FILIAL		:= xFilial("SE5")
			SE5->E5_RECPAG    	:= "R"
			SE5->E5_HISTOR    	:= STR0100+cOrdPago //"Entregado OP "
			SE5->E5_DTDIGIT   	:= dDataBase
			SE5->E5_DATA      	:= dDtEmis
			SE5->E5_NATUREZ 	:= SE1->E1_NATUREZ
			SE5->E5_TIPODOC   	:= "BA"
			SE5->E5_PREFIXO   	:= SE1->E1_PREFIXO
			SE5->E5_NUMERO   	:= SE1->E1_NUM
			SE5->E5_PARCELA   	:= SE1->E1_PARCELA
			SE5->E5_CLIFOR    	:= SE1->E1_CLIENTE
			SE5->E5_LOJA      	:= SE1->E1_LOJA
			SE5->E5_BENEF     	:= cFornece+cLoja
			SE5->E5_MOTBX     	:= "LIQ"
			SE5->E5_VLMOED2   	:= SE1->E1_VALOR
			SE5->E5_SEQ       	:= PadL("1",TamSX3("E5_SEQ")[1],"0")
			SE5->E5_DOCUMEN   	:= cOrdpago
			SE5->E5_ORDREC	   	:= cOrdPago
			SE5->E5_TIPO      	:= SE1->E1_TIPO
			SE5->E5_NUMLIQ    	:= cLiquid
			SE5->E5_MOEDA     	:= StrZero(SE1->E1_MOEDA,2)
			SE5->E5_VALOR     	:= SE1->E1_VLCRUZ
			SE5->E5_LA        	:= "S"
			MsUnLock()

			RecLock("SEK",.T.)
			SEK->EK_FILIAL   := xFilial("SEK")
			SEK->EK_TIPODOC  := "CT" //CHEQUE Tercero
			SEK->EK_PREFIXO  := SE1->E1_PREFIXO
			SEK->EK_NUM      := SE1->E1_NUM
			SEK->EK_PARCELA  := SE1->E1_PARCELA
			SEK->EK_TIPO     := SE1->E1_TIPO
			SEK->EK_VALOR    := SE1->E1_VALOR
			SEK->EK_SALDO    := SE1->E1_SALDO
			SEK->EK_MOEDA    := AllTrim( Str(SE1->E1_MOEDA))
			SEK->EK_BANCO    := SE1->E1_BCOCHQ
			SEK->EK_AGENCIA  := SE1->E1_AGECHQ
			SEK->EK_CONTA    := SE1->E1_CTACHQ
			SEK->EK_ENTRCLI  := SE1->E1_CLIENTE
			SEK->EK_LOJCLI   := SE1->E1_LOJA
			SEK->EK_EMISSAO  := dDtEmis
			SEK->EK_VENCTO   := dDtVcto
			SEK->EK_VLMOED1  := Round(xMoeda( SE1->E1_VALOR,SE1->E1_MOEDA,1, dDataBase,5,aTxMoedas[SE1->E1_MOEDA][2]),MsDecimais(1))
			SEK->EK_ORDPAGO  := cOrdpago
			SEK->EK_DTDIGIT  := dDataBase
			SEK->EK_FORNECE  := cFornece
			SEK->EK_LOJA     := cLoja
			SEK->EK_FORNEPG := cFornece
			SEK->EK_LOJAPG := cLoja
			If SEK->(FieldPos("EK_PGCBU")) > 0
				SEK->EK_PGCBU := lCBU
			Endif
			If SEK->(FieldPos("EK_NATUREZ")) > 0
			   SEK->EK_NATUREZ := cNatureza
			Endif
			If cPaisLoc == "MEX" .And. cPaisProv <> "493"
				If SEK->(FieldPos("EK_DCONCEP")) > 0
				   SEK->EK_DCONCEP := AllTrim(cDesc)
				Endif
			EndIf
			If cPaisLoc == "MEX"  .and. SEK->(FieldPos("EK_UUID")) > 0
				SEK->EK_UUID := __cUUID
			EndIf
			F085AGrvTx()
			MsUnlock()
			//����������������������������������������������������������Ŀ
			//� Grava os lancamentos nas contas orcamentarias SIGAPCO    �
			//������������������������������������������������������������
			PcoDetLan("000313","03","FINA085A")
		EndIf
	EndIf
EndIf

If nPagar <> 4
	//Nao pode ser gravado documento com valor ZERO...
	If nTotal > 0
		RecLock("SEK",.T.)
		SEK->EK_FILIAL	:= xFilial("SEK")
		SEK->EK_TIPODOC	:= "CP"     //CHEQUE PROPRIO
		SEK->EK_NUM		:= If( nPagar > 1	 , cNumChq, cOrdPago)
		If nPagar == 1 .AND. cPaisLoc $ "EQU|DOM|COS"
			SEK->EK_TIPO   	:= cDebMed
		Else
			SEK->EK_TIPO   	:= If( nPagar	== 3 , cDebInm,If( nPagar=2,cDebMed,"CA")  )
		EndIf
		SEK->EK_FORNECE	:= cFornece
		SEK->EK_LOJA   	:= cLoja
		SEK->EK_EMISSAO	:= dDtEmis
		SEK->EK_VENCTO 	:= dDtVcto
		SEK->EK_VALOR  	:= Round(xMoeda(nTotal,nMoeda,nMoedaBco,,5,aTxMoedas[nMoeda][2],aTxMoedas[nMoedaBco][2]),MsDecimais(nMoedaBco))
		SEK->EK_VLMOED1	:= Round(xMoeda(nTotal,nMoeda,1,,5,aTxMoedas[nMoeda][2]),MsDecimais(1))
		SEK->EK_MOEDA 	:= AllTrim( Str( nMoedaBco))
		SEK->EK_BANCO 	:= cBanco
		SEK->EK_AGENCIA	:= cAgencia
		SEK->EK_CONTA 	:= cConta
		SEK->EK_ORDPAGO	:= cOrdpago
		SEK->EK_DTDIGIT	:= dDataBase
		SEK->EK_FORNEPG := cFornece
		SEK->EK_LOJAPG := cLoja
		SEK->EK_PARCELA :=cParcela
		If SEK->(FieldPos("EK_PGCBU")) > 0
			SEK->EK_PGCBU := lCBU
		Endif
		If SEK->(FieldPos("EK_NATUREZ")) > 0
		   SEK->EK_NATUREZ := cNatureza
		Endif
		If ExistBlock("A085PRECH")
			SEK->EK_PREFIXO :=cPrefixo
		EndIf
		If cPaisLoc == "MEX" .And. cPaisProv <> "493"
			If SEK->(FieldPos("EK_DCONCEP")) > 0
			   SEK->EK_DCONCEP := AllTrim(cDesc)
			Endif
		EndIf
		If cPaisLoc == "MEX"  .and. SEK->(FieldPos("EK_UUID")) > 0
			SEK->EK_UUID := __cUUID
		EndIf
		F085AGrvTx()
		MsUnlock()
		If nPagar == 3 .AND. cPaisLoc $ "EQU|DOM|COS"
			FA85AtuSFE(SFE->(FE_FILIAL+FE_FORNECE+FE_LOJA+FE_NFISCAL+FE_SERIE+FE_TIPO+FE_CONCEPT),cOrdpago)
		EndIf
		IF (ExistBlock("F085GRA"))
	       ExecBlock("F085GRA",.f.,.f.)
	   Endif
		//����������������������������������������������������������Ŀ
		//� Grava os lancamentos nas contas orcamentarias SIGAPCO    �
		//������������������������������������������������������������
		PcoDetLan("000313","04","FINA085A")
	EndIf
EndIf

If ExistBlock("A085APAG")
	ExecBLock("A085APAG",.F.,.F.)
Endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AtuaSaldos�Autor  �Leonardo Gentile    � Data �  06/01/01   ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualizacao dos saldos dos regs. do SE2, SE1, SA1, SA2      ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function	AtuaSaldos(aDocs, nValorFor,cFornece,cLoja,nFlagMOD,nCtrlMOD)
Local nMVCusto	:=	Val(GetMv("MV_MCUSTO"))
Local nAux
Local aLockSE2
Local cTitulo	:= ""
Local cForne   := ""
Local nX		:= 0
Local nValPag	:= 0

dbSelectArea("SE2")

aLockSE2 := DbRLockList()
For nX	:=	1	TO Len( aDocs[1] )
	
	If !Empty(aDocs[1][nx][_RECNO] ) .AND. aDocs[1][nx][_PAGAR] <> 0
		MsGoto( aDocs[1][nx][_RECNO])
		nAux := Ascan(aLockSE2,Recno())
	
		RecLock("SE2",.F.)
			nModAux := ASCAN(aModAux,{|x|  x[1] == aDocs[1][nX][1]+ aDocs[1][nX][2] +aDocs[1][nX][9] + aDocs[1][nX][10] + aDocs[1][nX][11] + aDocs[1][nX][12] })
			If nModAux>0
				nJuros:=aModAux[nModAux][2][1]
				nMulta:=aModAux[nModAux][3][1]
			Else             
				nJuros:=aDocs[1][nX][_JUROS]
				nMulta:=aDocs[1][nX][_MULTA]
			Endif	
			nValPag := Abs( aDocs[1][nX][_PAGAR]+aDocs[1][nX][_ABATIM]+ aDocs[1][nX][_DESCONT] - aDocs[1][nX][_JUROS] - aDocs[1][nX][_MULTA])
			If cPaisLoc	==	"EQU"                                                                                                                           
				E2_SALDO := E2_SALDO - Abs( aDocs[1][nX][_PAGAR] - nJuros - nMulta)		
			Else
				E2_SALDO := E2_SALDO - Abs( aDocs[1][nX][_PAGAR]+aDocs[1][nX][_ABATIM] - nJuros - nMulta)
			Endif
			If E2_SALDO  < 0              
				E2_SDACRES := E2_SDACRES - ABS(E2_SALDO)
				E2_SALDO  := 0
			Endif 
		E2_OK := "  "
	    nCtrlMOD-=1
	    If nCtrlMOD==0
	       nFlagMOD:=0
	    Endif
			If FieldPos("E2_VLBXPAR")>0 .and. E2_VLBXPAR >0  .And.  SE2->E2_VLBXPAR <=SE2->E2_SALDO
			E2_VLBXPAR := E2_VLBXPAR - Abs( aDocs[1][nX][_PAGAR]+aDocs[1][nX][_ABATIM]+ aDocs[1][nX][_DESCONT] - aDocs[1][nX][_JUROS] - aDocs[1][nX][_MULTA])
			If E2_VLBXPAR == 0
				E2_PREOK := " "
			EndIf
		EndIf
		
		E2_MOVIMEN 	:= dDataBase
		E2_ORDPAGO 	:= cOrdPago
		E2_DESCONT 	:= Abs( aDocs[1][nX][_DESCONT])
		E2_MULTA	:= Abs( aDocs[1][nX][_MULTA])
		E2_JUROS	:= Abs( aDocs[1][nX][_JUROS])
		E2_VALLIQ   := Abs( aDocs[1][nX][_PAGAR])
		E2_BAIXA	:= dDataVenc1
		
		//Verifica se existe solicitacao de NCP e caso exista atualiza o campo CU_DTBAIXA...
		If cPaisLoc <> "BRA"
			A055AtuDtBx("1",SE2->E2_FORNECE,SE2->E2_LOJA,SE2->E2_NUM,SE2->E2_PREFIXO,SE2->E2_BAIXA)
		EndIf
	
		//+--------------------------------------------------------------+
		//� Baixar titulos de abatimento se for baixa total              �
		//+--------------------------------------------------------------+
			IF cPaisLoc $ "ARG|EQU|DOM|COS"
			F085AtuAbt(cOrdPago)
		EndIF
		IF SE2->E2_SALDO > 0 .And. SE2->E2_SALDO == aDocs[1][nX][_ABATIM].And.!(SE2->E2_TIPO$ MV_CPNEG)
	
			Reclock("SE2",.F.)
			E2_SALDO :=	0
			MsUnlock()
	        aLockSE2 := DbRLockList()
		    cTitulo  := xfilial("SE2")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA
			cForne   := SE2->E2_FORNECE+SE2->E2_LOJA
		    dbSelectArea("SE2")
			DbSetOrder(1)
			DbClearFilter()
			dbSeek(cTitulo)
			While !SE2->(EOF()) .And. cTitulo  == SE2->E2_FILIAL+SE2->E2_PREFIXO+	SE2->E2_NUM+SE2->E2_PARCELA
				If SE2->E2_FORNECE+SE2->E2_LOJA == cForne .And. SE2->E2_TIPO $ MVABATIM
					nAux := Ascan(aLockSE2,Recno())
					If nAux==0
					   RecLock("SE2",.F.)
					Endif
					E2_SALDO    := 0
					E2_BAIXA    := dDataBase
					E2_MOVIMEN  := dDataBase
					SE2->(MsUnLock())
				EndIf
				dbSkip()
			Enddo
		Endif
	
		MsGoto( aDocs[1][nx][_RECNO])
		If E2_SALDO == 0
			E2_BAIXA := dDataBase
		EndIf
		MsUnlock(SE2->(Recno()))
	
			If (lMsFil .And. !Empty(xFilial("SA2")) .And. xFilial("SF1") == xFilial("SE2"))
				DbSelectArea("SA2")
				If DbRLock(SA2->(Recno()))
					SA2->(DbSetOrder(1))
					If SA2->(DbSeek(SE2->E2_MSFIL + SE2->E2_FORNECE + SE2->E2_LOJA))
						Reclock("SA2",.F.)
						SA2->A2_SALDUP	:= SA2->A2_SALDUP  - Round(xMoeda(nValPag,nMoedaCor,1,,5,aTxMoedas[nMoedaCor][2]),MsDecimais(1))
						SA2->A2_SALDUPM	:= SA2->A2_SALDUPM - Round(xMoeda(nValPag,nMoedaCor,nMVCusto,,5,aTxMoedas[nMoedaCor][2],aTxMoedas[nMVCusto][2]),MsDecimais(nMVCusto))
						SA2->(MsUnlock())
					Endif
				Endif
				DbSelectArea("SE2")
			Endif
	Endif
Next

If aDocs[3] <> Nil .And. aDocs[3][1] == 4
	For nX	:=	1	To  Len(aDocs[3][3])
		If aDocs[3][3][nX] > 0
			DbSelectArea("SE1")
			MsGoTo(aDocs[3][3][nX])
			//+--------------------------------------------------------------+
			//� Gravar os campos E1_FORNECE e E1_LOJAFOR para criar um tipo  �
			//� de controle (rastro) para detectar de quem e o cheque...     �
			//+-Lucas, Argentina 11/2001 ------------------------------------+
			RecLock("SE1",.F.)
				E1_SALDO := 0
				E1_BAIXA := dDatabase
				E1_MOVIMEN := dDatabase
				E1_STATUS := "B"
				If SE1->(FieldPos("E1_FORNECE")) > 0
					E1_FORNECE	:= cFornece
				EndIf
				If SE1->(FieldPos("E1_LOJAFOR")) > 0
					E1_LOJAFOR := cLoja
				EndIf
			MsUnlock(Recno())

			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA))
			IF SA1->(FOUND())
				AtuSalDup("-",SE1->E1_VALOR,SE1->E1_MOEDA,SE1->E1_TIPO,aTxMoedas[SE1->E1_MOEDA][2],SE1->E1_EMISSAO)
			EndIf
		EndIf
	Next nX
EndIf

If !(lMsFil .And. !Empty(xFilial("SA2")) .And. xFilial("SF1") == xFilial("SE2"))
	DbSelectArea("SA2")
	If DbRLock(SA2->(Recno()))
		DbSetOrder(1)
		DbSeek(xFilial("SA2")+cFornece+cLoja)
		If Found()
			Reclock("SA2",.F.)
			SA2->A2_SALDUP	:= SA2->A2_SALDUP  - Round(xMoeda(nValorFor,nMoedaCor,1,,5,aTxMoedas[nMoedaCor][2]),MsDecimais(1))
			SA2->A2_SALDUPM	:= SA2->A2_SALDUPM - Round(xMoeda(nValorFor,nMoedaCor,nMVCusto,,5,aTxMoedas[nMoedaCor][2],aTxMoedas[nMVCusto][2]),MsDecimais(nMVCusto))
			MsUnlock()
		Endif
	Endif
Endif
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �a085aMarkAll �Autor  �Bruno Sobieski   �Fecha �  01/09/01   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao de marca Tudo definida aqui para usar a a085aMark    ���
���          � e tratar os locks do SE2.                                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function A085aMarkAll(nFlagMOD,nCtrlMOD)
Local nRecno	:=	REcno()
Local aArea		:= GetArea()
Local cFiltroM 	:= cCondicao

Default nFlagMOD := 0

If !lFiltra
	If cPaisLoc == "MEX"
		If lConsFilial
			cFiltroM := cFiltroM + '.And.E2_SALDO + E2_SDACRES >0.And.E2_FILIAL=="'+xFilial("SE2")+'"' //.And.Empty(E2_ORDPAGO)'
		Else
			cFiltroM := cFiltroM + '.And.E2_SALDO + E2_SDACRES >0 '
		EndIf
	Else
		cFiltroM := cFiltroM + '.And.E2_SALDO + E2_SDACRES >0.And.E2_FILIAL=="'+xFilial("SE2")+'"' //.And.Empty(E2_ORDPAGO)'
	EndIf
EndIf

DbSelectArea("SE2")
dbSetOrder(1)
DbClearFilter()

#IFDEF TOP
	MSFilter(cFiltroM)
#ELSE
	Dbsetfilter({|| &cFiltroM},cFiltroM)
#ENDIF

dbseek(xFilial("SE2"))
If cPaisLoc$"PER|DOM|COS"
   DBGOTOP()
   if nFlagMOD==0
      If lFindITF .And. FinProcITF( SE5->(RECNO()),1,,,,,SE2->E2_NATUREZ)
         MsgAlert(STR0210)//"Ser� selecionado apenas Titulos sem incid�ncia de ITF.")
       Else
         MsgAlert(STR0209)//"Ser� selecionado apenas Titulos sem incid�ncia de ITF.")
      Endif
     Else
      If nFlagMOD==1
         nFlagMOD:=22
         MsgAlert(STR0209)//"Ser� selecionado apenas Titulos sem incid�ncia de ITF.")
       Else
         nFlagMOD:=11
         MsgAlert(STR0210)//"Ser� selecionado apenas Titulos com incid�ncia de ITF.")
      Endif
   Endif
Endif

While !EOF()
	//Pois o click na bMarkAll, chama tanto a markall como a makr
	a085aMark(.T.,@nFlagMOD,@nCtrlMOD)
	DbSkip()
Enddo
DbSelectArea("SE2")
dbSetOrder(1)
DbClearFilter()

RestArea(aArea)
Eval(bFiltraBrw)
MsGoTo(nRecno)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �a085aMark �Autor  �Bruno Sobieski      �Fecha �  01/09/01   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao de marca da MarkBrowse, definida aqui para tratar os ���
���          � locks do SE2 a efeitos ad concorrencia de processos.       ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function a085aMark(lAll,nFlagMOD,nCtrlMOD)
Local lRet	:=	.F.
Local nX	:=	0
Local lValid
Local aHelpEspP
Local aHelpPorP
Local aHelpEngP
Local lGrpSF2:=.T.
Local lGrpSPA:=.T.
Local lGrpSNF:=.T.
Local cGrupoPA:=""
Local cGrupo :=""
Local nNum
Local lValida:=.T.
Local cNatdig := ' '
LOCAL aPostit := Getarea()
Local cChvSE2 := ' '
LOCAL lOK := .F.
Local lMRet :=.T.
Default nFlagMOD := 0
lAll	:=	Iif(lAll==Nil,.F.,lAll)

If cPaisLoc $ 'MEX|PER'
	//Valida Modalidad de operaci�n
	If SE2->E2_TIPO  == PADR('PA',TamSx3("E2_TIPO")[1]) .AND. POSICIONE("SED",1,xFilial("SED")+SE2->E2_NATUREZ ,"ED_OPERADT") == '1'
		IF (!lAll, MSGALERT(STR0263, ""),) //"No es posible seleccionar registros de recepci�n anticipado que posean modalidad con operaci�n de anticipo habilitada."
		Return
	endif
EndIf

//��������������������������������������������������������������������������������Ŀ
//�O titulo que teve seu ajuste de saldo por dif. de cambio nao pode ser baixado em�
//�data anterior ao ajuste, porque senao o ajuste feito seria sobre o saldo errado �
//����������������������������������������������������������������������������������
If cPaisLoc $ "ARG|BOL|URU" .And. SE2->(FieldPos('E2_DTDIFCA'))>0
	If SE2->E2_DTDIFCA>= dDataBase
		If !lAll
			Help('',1,'BXDIFCAMB')
			Return
		Endif
	Endif
Endif

DbSelectArea("SE2")

//Nao usamos o lInvete pois tem problemas...
//����������������������������������������������������������������������������������Ŀ
//� Caso esteja ligado o controle de solicitacao de notas de credito e exista alguma �
//� pendencia para este titulo                                                       �
//������������������������������������������������������������������������������������
SCU->(DbSetOrder(2))
If cPaisloc <> "BRA" .And. SuperGetMv('MV_SOLNCP') .And. SE2->E2_TIPO == MVNOTAFIS;
		.And. SCU->(MsSeek(xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_NUM+SE2->E2_PREFIXO)).And. Empty(SCU->CU_NCRED)
	If !lAll
		HELP(" ",1,"SOLNCPAB")
	Endif
Else
	If IsMark("E2_OK",cMarcaE2)
		RecLock("SE2",.F.)
		Replace E2_OK With "  "
        nCtrlMOD-=1
        If nCtrlMOD==0
           If nFlagMOD=22
              nFlagMOD:=2
             Elseif nFlagMOD=11
              nFlagMOD:=1
             Else
              nFlagMOD:=0
           Endif
        Endif
		MsRUnLock(SE2->(RECNO()))
		nX := aScan(aRecNoSE2,{|x| x[8] == RecNo()})
		aDel(aRecNoSE2, nX)
		aSize(aRecNoSE2, Len(aRecNoSE2)-1)
	Else
		lValid := F085MrKb(lAll)
		If nFlagMOD=11
		   nFlagMOD:=1
		Endif
		If nFlagMOD=22
		   nFlagMOD:=2
		Endif
		If lValid
			For nX	:=	0	To 1 STEP 0.2
				If MsRLock()
				   IF CPAISLOC$"PER|DOM|COS"
				      if nFlagMOD==0
				         lMRet:=	.T.
				         If lFindITF .And. FinProcITF( SE5->(RECNO()),1,,,,,SE2->E2_NATUREZ )
				            nFlagMOD:=1
				           Else
				            nFlagMOD:=2
				         Endif
				        Else
				         If nFlagMOD==1
  				            If lFindITF .And. FinProcITF( SE5->(RECNO()),1,,,,,SE2->E2_NATUREZ )
  				               lMRet:=	.T.
  				              Else
  				               lMRet:=	.F.
  				            Endif
  				          Else
  				            If lFindITF .And. FinProcITF( SE5->(RECNO()),1,,,,,SE2->E2_NATUREZ )
  				               lMRet:=	.F.
  				              Else
  				               lMRet:=	.T.
  				            Endif
				         Endif
				      Endif
				   Endif
				   If lMRet
						RecLock("SE2",.F.)
				  		Replace E2_OK With cMarcaE2
						nX	:=	1
						lRet:=	.T.
						AAdd(aRecNoSE2,{SE2->E2_FILIAL,SE2->E2_FORNECE,SE2->E2_LOJA,;
						SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,;
						SE2->E2_TIPO,RecNo()})
				      nCtrlMOD+=1
				      If nCtrlMOD==0
				         nFlagMOD:=0
				      Endif
					 Else
					   IF CPAISLOC$"PER|DOM|COS"
					      If nFlagMOD==1 .AND. !lAll
				            MsgAlert(STR0211)//"Selecione apenas Titulos com incid�ncia de ITF.")
				         Endif
					      If nFlagMOD==2 .AND. !lAll
				            MsgAlert(STR0212)//"Selecione apenas Titulos sem incid�ncia de ITF.")
				         Endif
				   	 ENDIF
				       EXIT
				    Endif
				  Else
					Inkey(0.2)
				Endif
			Next
			If !lRet .And. !lAll .AND. lMRet
				MsgAlert(OemToAnsi(STR0130)) //"El titulo est� en uso y no puede ser marcado en este momento"
			Endif
		EndIf
	Endif
Endif

IF cPaisLoc == "PER"
	aPostit := Getarea()
	IF SE2->E2_TIPO $ MV_CPNEG
		DBSELECTAREA("SF2")
		SF2 -> (DBSETORDER(2)) //F2_FILIAL+F2_CLIENTE+F2_LOJA+F2_DOC+F2_SERIE
		IF SF2->(DBSEEK(XFILIAL("SF2") + SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_NUM + SE2->E2_PREFIXO))

   		   IF SF2 -> F2_VALIMP5 > 0 //VERIFICA SE HA DETRACAO PARA ESTA NOTA
       		 	DBSELECTAREA("SFB")
				SFB -> (DBSETORDER(1)) //FB_FILIAL+FB_CODIGO
				SFB -> (DBSEEK(XFILIAL("SFB")+"DIG"))
				cNatdig := SFB->FB_NATUREZ
				cCampo := SE2->&("E2_PARIMP"+Alltrim(SFB->FB_CPOLVRO))

				If Empty(Alltrim(cCampo))
					cCampo := SuperGetMV("MV_1DUP",.F.,"")
					If Empty(AllTrim(cCampo))
						cCampo := Space(TamSX3("E2_PARCELA")[1])
					EndIf
				EndIf
				cCampo := PadR(cCampo,Len(SE2->E2_PARCELA))
				aAreaSA2 := SA2 -> (GetArea())
				SA2 -> (dbSetOrder(1))
				SA2 -> (MsSeek(xFilial("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_NUM + SE2->E2_PREFIXO))
				If Alltrim(SE2->E2_TIPO) == "NF" .AND. SA2->A2_RETENED <> "2"
					cChvSE2:= XFILIAL("SE2") + SE2->E2_PREFIXO + SE2->E2_NUM + cCampo + PadR("TX", Len(SE2->E2_TIPO)) + SE2->E2_FORNECE + SE2->E2_LOJA
				EndIf
				SA2 -> (RestArea(aAreaSA2))

				DBSELECTAREA("SE2")
				Set Filter to
				SE2 -> (DBGOTOP())
				SE2 -> (DBSETORDER(1)) //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
				IF SE2 -> (DBSEEK(cChvSE2))
           		 	IF SE2->E2_NATUREZ == cNatdig .AND. SE2->E2_SALDO > 0
			    	 	MsgInfo(STR0197,STR0198)
			       		lOK := .T.
			    	Endif
            	ENDIF
	   	   ENDIF
    	ENDIF

    	Eval(bFiltraBrw)
    	RestArea(aPostit)
    	IF lOK
    		RecLock("SE2",.F.)
    		Replace E2_OK With "  "
            nCtrlMOD-=1

            nX := aScan(aRecNoSE2,{|x| x[8] == RecNo()})
            aDel(aRecNoSE2, nX)
            aSize(aRecNoSE2, Len(aRecNoSE2)-1)

            If nCtrlMOD==0
               nFlagMOD:=0
            Endif
		ENDIF
	ELSE
   		DBSELECTAREA("SF1")
		SF1 -> (DBSETORDER(1)) //F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
		IF SF1 -> (DBSEEK(XFILIAL("SF1") + SE2->E2_NUM + SE2->E2_PREFIXO + SE2->E2_FORNECE + SE2->E2_LOJA))

   		   IF SF1 -> F1_VALIMP5 > 0 //VERIFICA SE HA DETRACAO PARA ESTA NOTA
       		 	DBSELECTAREA("SFB")
				SFB -> (DBSETORDER(1)) //FB_FILIAL+FB_CODIGO
				SFB -> (DBSEEK(XFILIAL("SFB")+"DIG"))
				cNatdig := SFB->FB_NATUREZ
				cCampo := SE2->&("E2_PARIMP"+Alltrim(SFB->FB_CPOLVRO))

				If Empty(Alltrim(cCampo))
					cCampo := SuperGetMV("MV_1DUP",.F.,"")
					If Empty(AllTrim(cCampo))
						cCampo := Space(TamSX3("E2_PARCELA")[1])
					EndIf
				EndIf
				cCampo := PadR(cCampo, Len(SE2->E2_PARCELA))
				aAreaSA2 := SA2 -> (GetArea())
				SA2 -> (dbSetOrder(1)) //A2_FILIAL+A2_COD+A2_LOJA
				SA2 -> (MsSeek(xFilial("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_NUM + SE2->E2_PREFIXO))
				If Alltrim(SE2->E2_TIPO) == "NF" .AND. SA2->A2_RETENED <> "2"
					cChvSE2:= XFILIAL("SE2") + SE2->E2_PREFIXO + SE2->E2_NUM + cCampo + PadR("TX", Len(SE2->E2_TIPO)) + SE2->E2_FORNECE + SE2->E2_LOJA
				EndIf
				SA2 -> (RestArea(aAreaSA2))

				DBSELECTAREA("SE2")
				Set Filter to
				SE2 -> (DBGOTOP())
				SE2 -> (DBSETORDER(1)) //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
				IF SE2 -> (DBSEEK(cChvSE2))
           		 	IF SE2->E2_NATUREZ == cNatdig .AND. SE2->E2_SALDO > 0
			    	 	MsgInfo(STR0197,STR0198)
			       		lOK := .T.
			    	Endif
            	ENDIF
	   	   ENDIF
		ENDIF

    	Eval(bFiltraBrw)
    	RestArea(aPostit)
    	IF lOK
    		RecLock("SE2",.F.)
    		Replace E2_OK With "  "
            nCtrlMOD-=1

            nX := aScan(aRecNoSE2,{|x| x[8] == RecNo()})
            aDel(aRecNoSE2, nX)
            aSize(aRecNoSE2, Len(aRecNoSE2)-1)

            If nCtrlMOD==0
               nFlagMOD:=0
            Endif
		ENDIF
    ENDIF
ENDIF

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �a085aCmpMo�Autor  �Bruno Sobieski      �Fecha �  01/10/01   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao recursiva para aplicar os valores recebidos em moeda ���
���          �diferente a dos titulos, nestes mesmos titulos.             ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function a085aCmpMo(aTitPags)
Local nA,nP,nPAgo	:=	0

For nA	:= 1	To Len(aTitPags)
	If aTitPags[nA]	>	0
		For nP	:=	1	To Len(aTitPags)
			If aTitPags[nA]	>	0
				If aTitPags[nP]	<	0
					nPago	:=	Round(xMoeda(aTitPags[nP],nP,nA,,MsDecimais(nA)+1,aTxMoedas[nP][2],aTxMoedas[nA][2] ),MsDecimais(nA) )
					//NP e o valor nPago e sempre negativo
					If Abs(nPago) > aTitPags[nA]
						aTitPags[nP]	+=	Round(xMoeda(aTitPags[nA],nA,nP,,MsDecimais(nP)+1,aTxMoedas[nA][2],aTxMoedas[nP][2] ),MsDecimais(nP) )
						aTitPags[nA]	:=	0
					ElseIf Abs(nPago) <  aTitPags[nA]
						aTitPags[nA]	+=	nPago
						aTitPags[nP]	:=	0
					Else
						aTitPags[nA]	:=	0
						aTitPags[nP]	:=	0
					Endif
				Endif
			Else
				Exit
			Endif
		Next
	Endif
Next

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �a085aVldDe�Autor  �Microsiga           �Fecha �  01/12/01   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida a digitacao do % de desconto e do valor de desconto. ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function a085aVldDe(nOpc,oPorDesc,nPorDesc,oValDesc,nValDesc,nValBrut,nValLiq,oValLiq,aDescontos,bZeraRets,oGetDad1,bRecalc,nValAdic)
Local nPosTipE2	:=	Ascan(aHeader,{ |x| Alltrim(x[2])=="E2_TIPO"})
Local nPosMoeE2	:=	Ascan(aHeader,{ |x| Alltrim(x[2])=="E2_MOEDA"})
Local nPosPagE2	:=	Ascan(aHeader,{ |x| Alltrim(x[2])=="E2_PAGAR"})
Local nPosJurE2	:=	Ascan(aHeader,{ |x| Alltrim(x[2])=="E2_JUROS"})
Local nPosMulE2	:=	Ascan(aHeader,{ |x| Alltrim(x[2])=="E2_MULTA"})
Local nPosSalE2	:=	Ascan(aHeader,{ |x| Alltrim(x[2])=="E2_SALDO"})
Local nPosPagMo	:=	Ascan(aHeader,{ |x| Alltrim(x[2])=="NVLMDINF"})
Local nTotNet	:=	0
Local nTotBrut	:=	0
Local nValAnt	:=	0
Local lRet		:=.T.
Local nX		:= 0
Local nP        := 	0
Local nValOri	:=	0
Local nRetAbt   := 	0
Local aHelpEsp,aHelpPor,aHelpEng
DEFAULT nValAdic	:=	0

If nOpc	==	2	// Valor
	lModi = .F.
	If nValDesc >= nValBrut
		lRet	:=	.F.
		Help("",1,"No 100 %")
	ElseIF  nValDesc < 0 .AND. cPaisLoc  == "URU"
		lRet	:=	.F.
		Help("",1,"INVDISC")	
	Else
		If cPaisLoc == "ARG" .Or. cPaisLoc $ "URU|BOL"
			Eval(bZeraRets)
		Endif
		//��������������������������������������������Ŀ
		//�Ratear o Total do desconto nas Notas Fiscais�
		//����������������������������������������������
		nPorDesc:=	(nValDesc * 100 ) / nValBrut
		For nX:=1	To	Len(aCols)
			nValOri	:=	(aCols[nX][nPosPagMo]+aCols[nX][nPosJurE2]+aCols[nX][nPosMulE2])
			If cPaisLoc == "EQU"
				aCols[nX][1]  += aCols[nX][17]
			EndIf
			If !aCols[nX][Len(aCols[nX])]  .And. !(aCols[nX][nPosTipE2] $ MVPAGANT+"/"+MV_CPNEG)
				If cPaisLoc  == "URU"
					aDescontos[nX]	:=	Round(((aCols[nX][15]+aCols[nX][nPosJurE2]+aCols[nX][nPosMulE2])*nPorDesc /100),nDecs)
				Else			
					aDescontos[nX]	:=	Round(((aCols[nX][2]+aCols[nX][nPosJurE2]+aCols[nX][nPosMulE2])*nPorDesc /100),nDecs)
				EndIf
			Endif
			If cPaisLoc == "EQU"
				nValOri       := aCols[nX][1]  + aDescontos[nX]
				nRetAbt       := aCols[nX][17]
			EndIf
			If cPaisLoc  == "URU"
				nValOri				:=	(aCols[nX][1]+aCols[nX][nPosDesc]+aCols[nX][nPosJurE2]+aCols[nX][nPosMulE2])
			EndIF
			aCols[nX][nPosDesc]  := aDescontos[nX]
			aCols[nX][nPosPagE2] := nValOri - aDescontos[nX]

			If cPaisLoc  == "URU"
				aCols[nX][nPosSalE2] := - (aCols[nX][nPosPagE2])
			Else	
				aCols[nX][nPosSalE2] := (aPagar[nX] + aCols[nX][nPosJurE2] + aCols[nX][nPosMulE2]) - (aDescontos[nX]+ aCols[nX][nPosPagE2])
			EndIf
			If aCols[nX][nPosPagE2] < 0
				aCols[nX][nPosSalE2]+= aCols[nX][nPosPagE2]
	 			aCols[nX][nPosPagE2]:= 0
			Endif
			If cPaisLoc == "EQU"
				nValOri       := aCols[nX][15]
				aCols[nX][1]  := nValOri - aCols[nX][19] - nRetAbt
				aCols[nX][2]  := nValOri - aCols[nX][19] - nRetAbt
			EndIf
		Next
		nValLiq := 0
		Aeval(aCols,{|x,y|,Iif(aCols[y][nPosTipE2] $	MV_CPNEG+"/"+MVPAGANT,nValLiq -= Round(xMoeda(aCols[y][nPosPagE2],aCols[y][nPosMoeE2],nMoedaCor,,nDecs+1,aTxMoedas[aCols[y][nPosMoeE2]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor)),nValLiq += Round(xMoeda(aCols[y][nPosPagE2],aCols[y][nPosMoeE2],nMoedaCor,,nDecs+1,aTxMoedas[aCols[y][nPosMoeE2]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor)))})
		nValLiq	+=	nValAdic

		oPorDesc:Refresh()
		oValLiq:Refresh()
		oValDesc:Refresh()
		oGetDad1:Refresh()
	Endif
Else
	lModi = .T.
	If nPorDesc < 0 .AND. cPaisLoc  == "URU"
		lRet	:=	.F.
			Help("",1,"INVDISC")
	Else
		nValDesc	:=	0
		If cPaisLoc == "ARG" .Or. cPaisLoc $ "URU|BOL"
			Eval(bZeraRets)
		Endif
		For nX:=1	To	Len(aCols)
			If !aCols[nX][Len(aCols[nX])]  .And. !(aCols[nX][nPosTipE2] $ MVPAGANT+"/"+MV_CPNEG) .And.  nPorDesc <> 0
				If cPaisLoc == "EQU"
					aCols[nX][1]  := aCols[nX][15]-aCols[nX][nPosDesc]-aCols[nX][nPosJurE2]-aCols[nX][nPosMulE2]
					aCols[nX][2]  := aCols[nX][1]
					nRetAbt       := aCols[nX][17]
				EndIf
	 			If nPosDesc > 0
	 				If cPaisLoc  == "URU"
	 					IF ( aCols[nX][1] == (- aCols[nX][nPosJurE2] ))	 					
	 					nValOri	:=	(aCols[nX][1]+aCols[nX][nPosDesc]+aCols[nX][nPosMulE2])
	 					Else
	 					nValOri	:=	(aCols[nX][1]+aCols[nX][nPosDesc]+aCols[nX][nPosJurE2]+aCols[nX][nPosMulE2])
	 					EndIf
	 				else
						nValOri	:=	(aCols[nX][1]+aCols[nX][nPosDesc]+aCols[nX][nPosJurE2]+aCols[nX][nPosMulE2])
					EndIf
					aCols[nX][nPosDesc]	:=	Round(nValOri* nPorDesc / 100,nDecs)
					nValDesc 			+=	Round(xMoeda(aCols[nX][nPosDesc],aCols[nX][nPosMoeE2],nMoedaCor,,nDecs+1,aTxMoedas[aCols[nX][nPosMoeE2]][2],aTxMoedas[nMoedaCor][2],nDecs),MsDecimais(nMoedaCor))
					aDescontos[nX]		:=	Round(aCols[nX][nPosDesc],nDecs)
				Else
					nValDesc 			+=	Round(xMoeda(nValBrut,aCols[nX][nPosMoeE2],nMoedaCor,,nDecs+1,aTxMoedas[aCols[nX][nPosMoeE2]][2],aTxMoedas[nMoedaCor][2],MsDecimais(nMoedaCor)) * nPorDesc / 100,nDecs)
					aDescontos[nX]		:=	Round(aCols[nX][nPosPagE2]* nPorDesc / 100,nDecs)
				Endif
				aCols[nX][nPosDesc]	:= Round(xMoeda(aCols[nX][nPosDesc],aCols[nX][nPosMoeE2],nMoedaCor,,nDecs+1,aTxMoedas[nMoedaCor][2],aTxMoedas[aCols[nX][nPosMoeE2]][2]),MsDecimais(nMoedaCor))
			Endif
			If nPorDesc == 0
				aCols[nX][nPosDesc]  := 0
				If cPaisLoc  == "URU"
					aCols[nX][nPosSalE2] :=	-(aCols[nX][H_TOTALVL])  //  Balance
					aCols[nX][nPosPagE2] := (aCols[nX][H_TOTALVL])
				Else
					aCols[nX][nPosPagE2] += aDescontos[nX]
				EndIf
			ElseIf cPaisLoc == "EQU"
				aCols[nX][nPosPagE2] 	:= aCols[nX][15] - nRetAbt - aDescontos[nX]
				aCols[nX][2]  			:= aCols[nX][1]
			Else
				aCols[nX][nPosPagE2] := 	nValOri - aDescontos[nX]
				If cPaisLoc  == "URU"
					aCols[nX][nPosSalE2] :=		-(aCols[nX][nPosPagE2])  //  Balance
				Else
					aCols[nX][nPosSalE2] -=		aCols[nX][nPosPagE2]
				EndIf
				If cPaisLoc == "COL"
					aCols[nX][2] := Round(xMoeda(aCols[nX][nPosPagE2],aCols[nX][nPosMoeE2],nMoedaCor,,nDecs+1,aTxMoedas[aCols[nX][nPosMoeE2]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
				EndIf
			EndIf

			If aCols[nX][nPosPagE2] < 0
				aCols[nX][nPosSalE2]+= aCols[nX][nPosPagE2]
		 		aCols[nX][nPosPagE2]:= 0
			EndIf
		Next
		nValLiq := 0
		Aeval(aCols,{|x,y|,Iif(aCols[y][nPosTipE2] $	MV_CPNEG+"/"+MVPAGANT,nValLiq -= Round(xMoeda(aCols[y][nPosPagE2],aCols[y][nPosMoeE2],nMoedaCor,,nDecs+1,aTxMoedas[aCols[y][nPosMoeE2]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor)),nValLiq += Round(xMoeda(aCols[y][nPosPagE2],aCols[y][nPosMoeE2],nMoedaCor,,nDecs+1,aTxMoedas[aCols[y][nPosMoeE2]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor)))})
		nValLiq	+=	nValAdic
		If cPaisLoc  == "URU"
		oPorDesc:Refresh()
		EndIf
		oValLiq:Refresh()
		oValDesc:Refresh()
		oGetDad1:Refresh()
	EndIf
Endif

lRetenc	:=	.F.
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A085APgAdi�Autor  �Bruno Sobieski      �Fecha �  01/16/01   ���
�������������������������������������������������������������������������͹��
���Desc.     �Pagamento adiantado.                                        ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085a                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function A085APgAdi(lIncAdt,cCodFor,cLojFor,aRecAdt)
Local aCpos	:=	{}
Local oPagar
Local oGetDad,oDlg
local OBROWSE
Local lConfirmo	:=	.F.
Local cTmp	:=	""
Local oBAnco,oAgencia,oConta
Local oProv
Local oCF
Local oFnt
Local oObj
Local oDataTxt1,oTipo
Local oDataTxt2
Local oChkBox
Local oDataVenc,oDataVenc1
Local oCbx1,oCbx2
Local oAliqigv
Local nX,nP
Local oFor	,	cFor	:=""
Local oMod	,	cMod	:=""
Local oRet,nRet	:=	0,aConGan
Local oRetIB, nRetIB:=0
Local oRetIVA, nRetIVA:=0
Local oRetSUSS, nRetSUSS:=0
Local nBaseRIE:=nAliqRIE:=nRetRIE:=0
LOCAL nRetIGV :=0
Local nRetIR  := 0
Local aSE2		:=	{ { {}, {} , Nil} }
Local nMoedaPag	:=	1
Local nA		:= 0
Local cPerg		:= "FIN85A"
Local aRotinaOld:= If(Type("aRotina")=="A",aClone(aRotina),{})
Local aHeaderOld:= If(Type("aHeader")=="A",aClone(aHeader),{})
Local aColsOld  := If(Type("aCols")=="A",aClone(aCols),{})
Local nOld      := If(Type("n")=="N",n,1)
Local nBaseIGV  := 0 // valor base para caculo da reten�ao do igv
Local nAliqIGV  := 0 // aliquota para calculo do valor do igv a ser retido
Local aButtons	 := If(cPaisLoc=="ARG",	{ 	{"NOTE"   ,{||   F085ImpPA(,@aSE2,@cFor,@oFor,oRet,@nRet,nValor,@nLiquido,oLiquido,@nRetIb,oRetIb,@nRetIva,oRetIva,@nRetSuss,oRetSuss)},OemToAnsi(STR0189)}},{}); //,OemToAnsi(STR0008)}} //'Alterar OP' } //"Modificar"
	   //	{'PRECO'    ,{|| A085aPagos(aSE2[oLBx:nAt][1],aSE2[oLBx:nAt][2],oLbx:nAt,@aSE2,oDlg),Fa085atuVl(@oValOrdens,@nValOrdens,@aPagos,aSE2)   },OemToAnsi(STR0077)} } //"Pago diferenciado"
Local nImpRet      := 0
Local nI           := 0
Local lCBU		   := .F.
Local nMinCBU	   := GetMV("MV_MINCBU",.F.,0)
Local lMonotrb	   := .F.
Local lImpCert     := (GetNewPar("MV_CERTRET","N") == "S")
Local nXPagar	   := 0
Local lOculta := .F.
Local lF85NoInfo := ExistBlock("F85NOINFO")
Local lAltNatu   := .F.

Private lImpVal	   := .F.
Private dDataVenc  := dDataBase
Private dDataVenc1 := dDataBase
Private nValor	   := 0, oValor, oVALORPG, oMsg1, oValpag, oSaldo
Private aPagos	   := {}
Private cBanco	   := Criavar("A6_COD"),cAgencia	:=	Criavar("A6_AGENCIA"),cConta:=Criavar("A6_NUMCON")
Private cProv	   := Criavar("A2_EST")
Private cCF	       := Criavar("F4_CODIGO")
Private nGrpSus    := Criavar("FF_GRUPO")
Private cZnGeo     := Criavar("FF_ITEM")
Private cNumOp     := Iif(SEK->(FieldPos("EK_NUMOPER"))>0,Criavar("EK_NUMOPER"),"")
Private nTotAnt    := Iif(SEK->(FieldPos("EK_TOTANT"))>0,Criavar("EK_TOTANT")  ,"")
Private aDebMed	   := {}	,	aDebInm:={}
Private nPagar	   := If(!(cPaisLoc $ "EQU|DOM|COS"),1,0),nLiquido:=0, oLiquido
Private aRecChqTer := {}
Private aSaldos	   := Array(MoedFin()+1)
Private cFornece   := SE2->E2_FORNECE
Private cLoja      := SE2->E2_LOJA
Private cNatureza:=Iif(SEK->(FieldPos("EK_NATUREZ"))>0,Criavar("EK_NATUREZ"),Criavar("ED_CODIGO"))
Private aCtrChEQU  := {}
Private cDebMed :=""
Private cDebInm :=""    
Private cSerieNF	:= Space(3)

If !CtbValiDt(,dDatabase,,,,{"FIN002"},)
	Return
EndIf

// usado para o calculo da retencao do IGV
IF cPaisLoc	==	"PER"
	If cAgente == Nil
		cAgente	:= GETMV("MV_AGENTE")
	Endif
ENDIF

DEFAULT aRecAdt	:= {}
DEFAULT cCodFor	:= ""
DEFAULT cLojFor	:= ""
DEFAULT lIncAdt	:= .F.

If lF85NoInfo
	lOculta := ExecBlock("F85NOINFO",.F.,.F.)
EndIf

//ANGOLA - Inclusao de adiantamento para relacionar com pedido
//Vari�veis Private declaradas no inicio do FINA085A e necess�rias para a
//chamada direta desta fun��o.
//NAO TRASFORME EM LOCAL !!!!
If lIncAdt
	aTxMoedas	:= F085TxMoed()
	aRotina		:= MenuDef(@nFlagMOD,@nCtrlMOD)
	aRecNoSE2	:= {}
	lRetPA		:=	(GetNewPar("MV_RETPA","N") == "S")
	bFiltraBrw	:= {||.T.}
	cFornece		:= cCodFor
	cLoja			:= cLojFor
	lBaixaChq	:=	.F.
	cForDe   	:= cCodFor
	cForAte  	:= cCodFor
	nDecs			:=	MsDecimais(1)
	cDocCred		:= SuperGetMV("MV_TPADTCD",.T.,Substr(MVPAGANT,1,3))

	//Posiciono SA2 para obter nome do fornecedor
	SA2->(dbSetOrder(1))
	SA2->(MsSeek(xFilial("SA2")+cFornece+cLoja))
	cFor			:= SA2->A2_NREDUZ //SA2->A2_NOME

	//Carrega pergunte para obter variaveis de contabilizacao
	Pergunte(cPerg,.F.)
	lDigita		:= (mv_par07==1)
	lAglutina	:= (mv_par08==1)
	lGeraLanc	:= (mv_par09==1)
	cArquivo		:= ""
	nHdlPrv		:= 1
	nTotalLanc	:= 0
	cLoteCom		:= ""
	lLancPad70	:= .F.

	If lGeraLanc
		lLancPad70 := VerPadrao("570")
	EndIf

	If nMVCusto == Nil
		nMVCusto	:=	Val(GetMv("MV_MCUSTO"))
	Endif

Endif

If lRetPA == Nil
	lRetPA := (GetNewPar("MV_RETPA","N") == "S")
EndIf

aFill(aSaldos,0)

// Verifica se pode ser incluido mov. com essa data
If !DtMovFin(ddatabase,,"2") 
	Return  .F.
EndIf
nMoedaCor	:=	1
//Forco para que seja inclusao
aRotina[4][4]	:=	3

//��������������������������������������������������������������������������Ŀ
//�Carregar os tipos definidos no SES para a ordem de pago pelo campo        �
//�ES_RCOPGER, que indica que tipo de movimento vai gerar o tipo (BANCARIO ou�
//�TITULO A PAGAR)                                                           �
//����������������������������������������������������������������������������
cTmp  := GetSESTipos({|| ES_RCOPGER == "1"},"2")
While	!Empty(cTmp)
	AAdd(aDebMed,Substr(cTmp,1,tamSx3("E2_TIPO")[1]))
	cTmp	:=	Substr(cTmp,tamSx3("E2_TIPO")[1]+2)
Enddo
If Len(aDebMed) ==	0
	aDebMed	:=	{MVCHEQUE}
Endif
If cPaisLoc<>"PER"
   cDebMed	:=	aDebMed[1]
Endif


cTmp  := GetSESTipos({|| ES_RCOPGER == "2"},"2")
While	!Empty(cTmp)
   AAdd(aDebInm,Substr(cTmp,1,tamSx3("E2_TIPO")[1]))
	cTmp	:=	Substr(cTmp,tamSx3("E2_TIPO")[1]+2)
Enddo
If Len(aDebInm) ==	0
	nTamEK:=(tamSx3("EK_TIPO")[1] -2)
	If Ascan(aDebmed,"TF"+Space(nTamEK)) = 0
	   AAdd(aDebInm,"TF"+Space(nTamEK))
	EndIf
	If Ascan(aDebMed,"EF"+Space(nTamEK)) = 0
	   AAdd(aDebInm,"EF"+Space(nTamEK))
	EndIf
	If Len(aDebInm) ==	0
	   AAdd(aDebInm,"")
	EndIf
Endif
If cPaisLoc<>"PER"
   cDebInm	:=	aDebInm[1]
Endif

//��������������������������������������������Ŀ
//�Inicializar o aHeader e o aCols.            �
//����������������������������������������������
//Se o aHeader nao foi definido ainda, defino ele aqui SO UMA VEZ POR SESSAO. Bruno
If aHeader2	==	Nil
	aHeader2 	:=	{}
	cTipos		:=	""
	If ExistBlock("A085CPOS")
		aHeader2	:=	ExecBlock("A085CPOS",.F.,.F.)
	Else
		DbSelectArea("SX3")
		DbSetOrder(2)
		DbSeek("EK_TIPODOC")
		Aadd(aHeader2,{OemToAnsi(x3titulo()),"EK_TIPODOC"   ,"9",X3_TAMANHO ,X3_DECIMAL,'PERTENCE("123").And.A085aVlds(Nil,Nil,.T.)',X3_usado,"C","SEK"})
		DbSeek("EK_TIPO")
		Aadd(aHeader2,{OemToAnsi(x3titulo()),"EK_TIPO"   ,X3_PICTURE,X3_TAMANHO ,X3_DECIMAL,'A085aVlds(aDebMed,aDebInm,.T.)',X3_usado,"C","SEK"})
		DbSeek("EK_NUM")
		Aadd(aHeader2,{OemToAnsi(x3titulo()),"EK_NUM" 	 ,X3_PICTURE,X3_TAMANHO,X3_DECIMAL, ".T.",X3_usado,"C","SEK"})
		DbSeek("EK_VALOR")
		Aadd(aHeader2,{OemToAnsi(x3titulo()),"EK_VALOR"  ,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,".T.",X3_usado,"N","SEK"})
		DbSeek("EK_MOEDA")
		Aadd(aHeader2,{OemToAnsi(x3titulo()),"EK_MOEDA"  ,X3_PICTURE, X3_TAMANHO ,X3_DECIMAL,'.F.',X3_usado,"C","SEK"})
		DbSeek("EK_EMISSAO")
		Aadd(aHeader2,{OemToAnsi(x3titulo()),"EK_EMISSAO",X3_PICTURE, X3_TAMANHO,X3_DECIMAL,".T.",X3_usado,"D","SEK"})
		DbSeek("EK_VENCTO")
		Aadd(aHeader2,{OemToAnsi(x3titulo()),"EK_VENCTO" ,X3_PICTURE, X3_TAMANHO,X3_DECIMAL,"M->EK_VENCTO  >= aCols[N][6].And.A085aVlds()" ,X3_usado,"D","SEK"})
		DbSeek("EK_BANCO")
		Aadd(aHeader2,{OemToAnsi(x3titulo()),"EK_BANCO"  ,X3_PICTURE,X3_TAMANHO ,X3_DECIMAL,'a085aVlds(Nil,Nil,.T.)',X3_usado,"C","SEK"})
		DbSeek("EK_AGENCIA")
		Aadd(aHeader2,{OemToAnsi(x3titulo()),"EK_AGENCIA",X3_PICTURE,X3_TAMANHO ,X3_DECIMAL,'a085aVlds(Nil,Nil,.T.)',X3_usado,"C","SEK"})
		DbSeek("EK_CONTA")
		Aadd(aHeader2,{OemToAnsi(x3titulo()),"EK_CONTA"  ,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,'a085aVlds(Nil,Nil,.T.)',X3_usado,"C","SEK"})
		DbSeek("EK_PARCELA")
		Aadd(aHeader2,{OemToAnsi(x3titulo()),"EK_PARCELA"  ,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,'a085aVlds()',X3_usado,"C","SEK"})
		If DbSeek("EK_DEBITO")
			Aadd(aHeader2,{OemToAnsi(x3titulo()),"EK_DEBITO"  ,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,'a085aVlds()',X3_usado,"C","SEK"})
		Endif
	EndIf
Endif
DbSelectArea("SX3")
DbSetOrder(2)
aHeader := aClone(aHeader2)
aCols	:=	Array(1,Len(aHeader)+1)
For nA	:=	1	To	Len(aHeader)
	If DbSeek(aHeader[nA][2])
		aCols[1][nA] := CriaVar(aHeader[nA][2])
	EndIf
Next nA
aCols[1][Len(aCols[1])]	:=	.F.
DbSetOrder(1)

//�����������������������������������������������������������Ŀ
//� Inicializa a gravacao dos lancamentos do SIGAPCO          �
//�������������������������������������������������������������
PcoIniLan("000313")
DEFINE FONT oFnt  NAME "Arial" SIZE 09,11 BOLD

DEFINE MSDIALOG oDlg FROM 30,40  TO 440,633 TITLE OemToAnsi(STR0137) Of oMainWnd PIXEL  // "Pagos Anticipados"

//�����������������������������������������������������������������������Ŀ
//�Informar el proveedor para el que ser� hecho el pago y el valor a pagar�
//�������������������������������������������������������������������������
@ 33,004 To 65,290 Pixel Of  oDlg
If cPaisLoc $ "COS|ARG"
	@ 33,004 To 81,290 Pixel Of  oDlg
EndIf
@ 39,010 SAY  OemtoAnsi(STR0025) Size 50,07  PIXEL of oDlg  // Fornecedor
@ 37,060 MSGET cFornece	F3	"FOR"	SIZE 40,07 Valid  a085aVldPA(1,cFornece,@cFor,oFor,,,,,,,cLoja) .And. F085VldRet(1,cFornece,@cFor,oFor,oRet,@nRet,nValor,@nLiquido,oLiquido,@aSE2,cLoja,cCF,cProv,oRetIB,@nRetIB,cZnGeo,nGrpSus,nTotAnt,oRetIVA,@nRetIVA,oRetSUSS,@nRetSuss,nBaseRIE,nAliqRIE,nBaseIGV,nAliqIGV,oAliqigv,nBaseIGV) PIXEL of oDlg HASBUTTON When !lIncAdt
@ 37,102 MSGET cLoja Size 10,07 Valid (ExistCpo("SA2",cFornece+cLoja) .And. F085VFor(cFornece,cLoja) .And. a085aVldPA(1,cFornece,@cFor,oFor,,,,,,,cLoja) .And. F085VldRet(1,cFornece,@cFor,oFor,oRet,@nRet,nValor,@nLiquido,oLiquido,@aSE2,cLoja,cCF,cProv,oRetIB,@nRetIB,cZnGeo,nGrpSus,nTotAnt,oRetIVA,@nRetIVA,oRetSUSS,@nRetSuss,nBaseRIE,nAliqRIE,nAliqIGV,oAliqigv,nBaseIGV)) PIXEL of oDlg When !lIncAdt
@ 37,130 SAY oFor Var cFor  Size 150,16 PIXEL of oDlg COLOR CLR_BLUE FONT oFnt
@ 53,010 SAY  OemtoAnsi(STR0069) Size 50,07  PIXEL of oDlg  // Valor del Pago
@ 53,060 MSGET oValor VAR nValor  	SIZE 69,07 Valid (nValor > 0 .And. a085aVldPA(1,cFornece,@cFor,oFor,,,,,,,cLoja) .and.F085VldRet(1,cFornece,@cFor,oFor,oRet,@nRet,nValor,@nLiquido,oLiquido,@aSE2,cLoja,cCF,cProv,oRetIB,@nRetIB,cZnGeo,nGrpSus,nTotAnt,oRetIVA,@nRetIVA,oRetSUSS,@nRetSuss,nBaseRIE,nAliqRIE,nAliqIGV,oAliqigv,nBaseIGV) );
PICTURE PesqPict("SE2","E2_VALOR") PIXEL of oDlg  HASBUTTON

lAltNatu:= Iif(cPaisLoc $ "PER|DOM|COS|ARG" ,.T.,.F.)
If ExistBlock("A085ALNA")
	lAltNatu:=	ExecBlock("A085ALNA",.F.,.F.)
Endif

If lAltNatu	
	@ 53,169 SAY  OemToAnsi(STR0207) Size 50,07  PIXEL of oDlg  // Natureza
	@ 51,200 MSGET cNatureza	F3	"SED"	SIZE 50,07 Valid  a085aVldMD(1,cNatureza,@cMod,oMod,,,,,,,)  PIXEL of oDlg HASBUTTON When !lIncAdt
EndIF

IF cPaisLoc	==	"PER" .And. lRetPa 
	DBSELECTAREA("SFF")
	DBSETORDER(9)
	DBSEEK(XFILIAL("SFF")+"IGR")
	nAliqIGV:= SFF->FF_ALIQ
	@ 49,169 SAY OemToAnsi(STR0195) SIZE 35, 7 OF oDlg PIXEL   //"Aliq. IGV"
	@ 47,210 MSGET oAliqigv VAR nAliqIGV WHEN .F. Picture "@E 999.99" Valid (Positivo(nAliqIGV) .And. F085VldRet(1,cFornece,@cFor,oFor,oRet,@nRet,nValor,@nLiquido,oLiquido,@aSE2,cLoja,cCF,cProv,oRetIB,@nRetIB,cZnGeo,nGrpSus,nTotAnt,oRetIVA,@nRetIVA,oRetSUSS,@nRetSuss,nBaseRIE,nAliqRIE,nAliqIGV,oAliqigv,nBaseIGV)) SIZE 15, 7 PIXEL OF oDlg
	@ 203,190 SAY OemToAnsi(STR0096) SIZE 30,08 PIXEL of oDlg   // Valor Neto
 	@ 203,215 SAY oLiquido VAR nLiquido PICTURE PesqPict("SE2","E2_VALOR") SIZE 54,08 PIXEL of oDlg
EndIf

If (cPaisLoc	$	"ARG|ANG"	.And. lRetPa) .Or. lImpVal
 	@ 187,190 SAY OemToAnsi(STR0096) SIZE 30,08 PIXEL of oDlg   // Valor Neto
 	@ 187,215 SAY oLiquido VAR nLiquido PICTURE PesqPict("SE2","E2_VALOR") SIZE 54,08 PIXEL of oDlg
EndIf
If cPaisLoc	==	"ANG"	.And. lRetPa
 	@ 33,140 SAY OemToAnsi(STR0193 ) SIZE 45, 7 OF oDlg PIXEL //"Base RIE"
 	@ 31,162 MSGET nBaseRIE    PICTURE PesqPict("SE2","E2_VALOR") Valid (Positivo(nBaseRIE) .And. F085VldRet(1,cFornece,@cFor,oFor,oRet,@nRet,nValor,@nLiquido,oLiquido,@aSE2,cLoja,cCF,cProv,oRetIB,@nRetIB,cZnGeo,nGrpSus,nTotAnt,oRetIVA,@nRetIVA,oRetSUSS,@nRetSuss,nBaseRIE,nAliqRIE,nBaseIGV,nAliqIGV)) SIZE 60, 7 PIXEL OF oDlg // WHEN nPagar<>4
	@ 33,225 SAY OemToAnsi(STR0194 ) SIZE 45, 7 OF oDlg PIXEL   //"Aliq. RIE"
	@ 31,245 MSGET nAliqRIE Picture "@E 99.99" Valid (Positivo(nAliqRIE) .And. F085VldRet(1,cFornece,@cFor,oFor,oRet,@nRet,nValor,@nLiquido,oLiquido,@aSE2,cLoja,cCF,cProv,oRetIB,@nRetIB,cZnGeo,nGrpSus,nTotAnt,oRetIVA,@nRetIVA,oRetSUSS,@nRetSuss,nBaseRIE,nAliqRIE,nBaseIGV,nAliqIGV)) SIZE 15, 7 PIXEL OF oDlg // WHEN nPagar<>4
Endif
//����������������������������������������������������������Ŀ
//�Informar o tipo de documento com que vamos pagar e o banco�
//������������������������������������������������������������
	@ 65,004 To 146,290 Pixel Of  oDlg LABEL OemToAnsi(STR0083) //"Pagar con"
If cPaisLoc $ "EQU|DOM"
	@ 71,006  RADIO oPagar VAR nXPagar 3D ;
	SIZE 120,10 ;
	ITEMS OemToAnsi(STR0085),OemToAnsi(STR0086); //"Debito diferido"###"Debito Inmediato"
	ON CHANGE { || oGetDad:OBROWSE:LACTIVE	:=	(nPagar==4),oGetDad:OBROWSE:NOPC:=3,oGetDad:OBROWSE:LNOPAINT	:=	(nPagar<>4),oGetDad:OBROWSE:Refresh() ,;
	a085aRefr( If(nXPagar==1,Eval({||nPagar:=2,nPagar}),If(nXPagar==2,Eval({||nPagar:=3,nPagar}),nPagar)),@oCbx1,@oCbx2,@oDataVenc,@oDataVenc1,@oChkBox,@oDataTxt1,@oDataTxt2,@oTipo,@oMsg,,,@oBanco,@oAgencia,@oConta,@nValor,oValor,nRet,oRet,nLiquido,oLiquido,,,,oRetIB,nRetIB,oRetIVA,nRetIVA,oRetSUSS,nRetSUSS,oAliqigv,nAliqIGV ) };
	OF oDlg Pixel
Else
	If lF085aChS
		If lOculta
			@ 71,006  RADIO oPagar VAR nPagar 3D ;
			SIZE 120,10 ;
			ITEMS OemToAnsi(STR0085),OemToAnsi(STR0086); //"Cheque Pre-Impreso"###"Debito diferido"###"Debito Inmediato"###"Informar"
			ON CHANGE { || oGetDad:OBROWSE:LACTIVE	:=	((nPagar==4 .Or. (nPagar == 3 .And. lF085aChs))),oGetDad:OBROWSE:NOPC:=3,oGetDad:OBROWSE:LNOPAINT	:=	((nPagar != 4 .Or. (nPagar != 3 .And. lF085aChs))),oGetDad:OBROWSE:Refresh() ,;
			a085aRefr(nPagar,@oCbx1,@oCbx2,@oDataVenc,@oDataVenc1,@oChkBox,@oDataTxt1,@oDataTxt2,@oTipo,@oMsg,,,@oBanco,@oAgencia,@oConta,@nValor,oValor,nRet,oRet,nLiquido,oLiquido,,,,oRetIB,nRetIB,oRetIVA,nRetIVA,oRetSUSS,nRetSUSS,oAliqigv,nAliqIGV,,.T.) };
			OF oDlg Pixel
		Else
			@ 71,006  RADIO oPagar VAR nPagar 3D ;
			SIZE 120,10 ;
			ITEMS OemToAnsi(STR0085),OemToAnsi(STR0086),OemToAnsi(STR0115) ; //"Cheque Pre-Impreso"###"Debito diferido"###"Debito Inmediato"###"Informar"
			ON CHANGE { || oGetDad:OBROWSE:LACTIVE	:=	((nPagar==4 .Or. (nPagar == 3 .And. lF085aChs))),oGetDad:OBROWSE:NOPC:=3,oGetDad:OBROWSE:LNOPAINT	:=	((nPagar != 4 .Or. (nPagar != 3 .And. lF085aChs))),oGetDad:OBROWSE:Refresh() ,;
			a085aRefr(nPagar,@oCbx1,@oCbx2,@oDataVenc,@oDataVenc1,@oChkBox,@oDataTxt1,@oDataTxt2,@oTipo,@oMsg,,,@oBanco,@oAgencia,@oConta,@nValor,oValor,nRet,oRet,nLiquido,oLiquido,,,,oRetIB,nRetIB,oRetIVA,nRetIVA,oRetSUSS,nRetSUSS,oAliqigv,nAliqIGV,,.T.) };
			OF oDlg Pixel
		EndIf
	Else
		If lOculta
			@ 71,006  RADIO oPagar VAR nPagar 3D ;
			SIZE 120,10 ;
			ITEMS OemToansi(STR0084), OemToAnsi(STR0085),OemToAnsi(STR0086); //"Cheque Pre-Impreso"###"Debito diferido"###"Debito Inmediato"###"Informar"
			ON CHANGE { || oGetDad:OBROWSE:LACTIVE	:=	((nPagar==4 .Or. (nPagar == 3 .And. lF085aChs))),oGetDad:OBROWSE:NOPC:=3,oGetDad:OBROWSE:LNOPAINT	:=	((nPagar != 4 .Or. (nPagar != 3 .And. lF085aChs))),oGetDad:OBROWSE:Refresh() ,;
			a085aRefr(nPagar,@oCbx1,@oCbx2,@oDataVenc,@oDataVenc1,@oChkBox,@oDataTxt1,@oDataTxt2,@oTipo,@oMsg,,,@oBanco,@oAgencia,@oConta,@nValor,oValor,nRet,oRet,nLiquido,oLiquido,,,,oRetIB,nRetIB,oRetIVA,nRetIVA,oRetSUSS,nRetSUSS,oAliqigv,nAliqIGV ) };
			OF oDlg Pixel
		Else
			@ 71,006  RADIO oPagar VAR nPagar 3D ;
			SIZE 120,10 ;
			ITEMS OemToansi(STR0084), OemToAnsi(STR0085),OemToAnsi(STR0086),OemToAnsi(STR0115) ; //"Cheque Pre-Impreso"###"Debito diferido"###"Debito Inmediato"###"Informar"
			ON CHANGE { || oGetDad:OBROWSE:LACTIVE	:=	((nPagar==4 .Or. (nPagar == 3 .And. lF085aChs))),oGetDad:OBROWSE:NOPC:=3,oGetDad:OBROWSE:LNOPAINT	:=	((nPagar != 4 .Or. (nPagar != 3 .And. lF085aChs))),oGetDad:OBROWSE:Refresh() ,;
			a085aRefr(nPagar,@oCbx1,@oCbx2,@oDataVenc,@oDataVenc1,@oChkBox,@oDataTxt1,@oDataTxt2,@oTipo,@oMsg,,,@oBanco,@oAgencia,@oConta,@nValor,oValor,nRet,oRet,nLiquido,oLiquido,,,,oRetIB,nRetIB,oRetIVA,nRetIVA,oRetSUSS,nRetSUSS,oAliqigv,nAliqIGV ) };
			OF oDlg Pixel
		EndIf
	EndIf
Endif
If lRetPa
	If !(cPaisLoc $ "ARG|ANG|PER")
		oPagar:Disable(4)
	Endif
Endif
//���������������Ŀ
//�Digitar o banco�
//�����������������

@ 71,160 To 114,285 Pixel Of  oDlg LABEL OemToAnsi(STR0091) //"Banco"

@ 076,169 SAY OemToAnsi(STR0091) 		 SIZE 19, 7 OF oDlg PIXEL  //"Banco"
@ 076,203 SAY OemToAnsi(STR0092) 		 SIZE 25, 7 OF oDlg PIXEL  //"Agencia"
@ 076,235 SAY OemToAnsi(STR0093) 		 SIZE 20, 7 OF oDlg PIXEL //"Cuenta"

@ 084,169 MSGET oBanco   VAR cBanco		F3 "SA6" Picture "@S3"    Valid CarregaSa6(@cBanco,@cAgencia,@cConta,.F.) 	.And. (ExistCpo("SA6",cBanco+cAgencia+cConta ) .And. IF(lRetCkPG(0,cDebInm,cBanco,nPagar,nValor),.T.,.T.) .Or.Empty(cBanco  )).And. If(CCBLOCKED(cBanco,cAgencia,cConta),.F.,.T.) .And.  F085VldRet(1,cFornece,@cFor,oFor,oRet,@nRet,nValor,@nLiquido,oLiquido,@aSE2,cLoja,cCF,cProv,oRetIB,@nRetIB,cZnGeo,nGrpSus,nTotAnt,oRetIVA,@nRetIVA,oRetSUSS,@nRetSuss,nBaseRIE,nAliqRIE,nBaseIGV,nAliqIGV)	SIZE 10, 10 OF oDlg PIXEL WHEN IIf(lF085aChs,nPagar <> 3,nPagar <> 4) HASBUTTON
@ 084,203 MSGET oAgencia VAR cAgencia	Picture "@S5"             Valid CarregaSa6(@cBanco,@cAgencia,@cConta,.F.)	.And. (ExistCpo("SA6",cBanco+cAgencia+cConta ).Or.Empty(cAgencia)) .And. If(CCBLOCKED(cBanco,cAgencia,cConta),.F.,.T.)	SIZE 20, 10 OF oDlg PIXEL	WHEN IIf(lF085aChs,nPagar <> 3,nPagar <> 4)
@ 084,235 MSGET oConta   VAR cConta		Picture "@S10"            Valid CarregaSa6(@cBanco,@cAgencia,@cConta,.F.)	.And. (ExistCpo("SA6",cBanco+cAgencia+cConta ).Or.Empty(cConta)) .And. If(CCBLOCKED(cBanco,cAgencia,cConta),.F.,.T.)	SIZE 45, 10 OF oDlg PIXEL	WHEN IIf(lF085aChs,nPagar <> 3,nPagar <> 4)

@ 116,010 To 141,285 Pixel Of  oDlg LABEL OemToAnsi(STR0087) //"Datos del titulo de pago"
//��������������������������������������������Ŀ
//�Escolher o vencimento do cheque pre-impresso�
//����������������������������������������������
@ 126,015 SAY oDataTxt1 Var OemToAnsi(STR0088) SIZE 50,10 OF	oDlg PIXEL //"Fecha para el debito "
@ 124,080 MSGET oDataVenc1 VAR dDataVenc1 Valid (dDataVenc1 >= dDataBase)	SIZE 44,09 OF	oDlg PIXEL HASBUTTON

@ 126,015 SAY oTipo VAR OemToAnsi(STR0089) SIZE 20,10 OF oDlg PIXEL //"Tipo "

@ 124,030 COMBOBOX oCBX1 VAR cDebMed ITEMS aDebMed Valid IF(lRetCkPG(0,cDebInm,cBanco,nPagar),.T.,.T.)  SIZE 50,50 OF oDlg PIXEL

//������������������������������������Ŀ
//�Escolher o titulo de debito diferido�
//��������������������������������������
@ 126,090 SAY oDataTxt2 VAR OemToAnsi(STR0088) SIZE 50,10 OF	oDlg PIXEL //"Fecha para el debito "
@ 126,150 MSGET oDataVenc VAR dDataVenc Valid (dDataVenc >= dDataBase)	SIZE 44,09 OF	oDlg PIXEL  HASBUTTON
@ 124,200 CHECKBOX oChkBox Var lBaixaChq	PROMPT OemToAnsi(STR0090) SIZE 80,16 PIXEL When (dDataVenc==dDataBase) Of oDlg //"� Debitar los titulos ahora ? "

//Box para escolher o titulo de debito Inmediato
@ 124,030 COMBOBOX oCBX2 VAR cDebInm ITEMS aDebInm Valid IF(lRetCkPG(0,cDebInm,cBanco,nPagar,nValor),.T.,.T.)  SIZE 50,50  OF oDlg PIXEL When (nPagar==3 .Or. (nPagar == 2 .And. lF085aChs))
//Mensagen para digitar os titulos informados

@ 124,015 SAY oMsg Var OemToAnsi(STR0116) SIZE 265,16 COLOR CLR_BLUE FONT oFnt Of oDlg PIXEL //"Escoja en la lista abajo los titulo que seran entregados para el pago."

oGetDad	:= MsGetDados():New(151,04,188,290,3,"a085aLnok(,.T.)","A085aTudok(2,nPagar,.T.,nLiquido,,cNatureza,@aCtrChEQU)","EK_EMISSAO/EK_VENCTO",.T.,,,,500,"a085FldOk2(.T.)",,,"a085aSalPa(,.T.)",oDlg)
oGetDad:cTudoOk  := "A085aTudok(2,nPagar,.T.,nLiquido,,cNatureza,@aCtrChEQU) .AND. lRetCkPG(0,cDebInm,cBanco,nPagar,nValor)"
oGetDad:cLinhaOk := "a085aLnok(,.T.,nValor)"

a085aRefr(nPagar,@oCbx1,@oCbx2,@oDataVenc,@oDataVenc1,@oChkBox,@oDataTxt1,@oDataTxt2,@oTipo,@oMsg,,,@oBanco,@oAgencia,@oConta,,,,,,,,,,,,,,,,,,,.T.)

ACTIVATE MSDIALOG oDlg ON INIT (oGetDad:OBROWSE:LACTIVE	:= ((nPagar==4 .Or. (nPagar == 3 .And. lF085aChs))),oGetDad:OBROWSE:LNOPAINT := ((nPagar != 4 .Or. (nPagar != 3 .And. lF085aChs))),oGetDad:OBROWSE:Refresh(),EnchoiceBar(oDlg,{||(lConfirmo	:=	oGetDad:TudoOk(),If(lConfirmo,oDlg:End(),lConfirmo	:=	.F.))},{||(lConfirmo	:=	.F.,oDlg:End() )},,aButtons)) CENTERED
//																																			  EnchoiceBar(oDlg,{|| If(a085aEnch(@nOpc,aSE2),oDlg:End(),)},{ || (nOpc := 0,oDlg:End())},,aButtons))

If lConfirmo
	If lF085aChS
		nPagar++
	Endif
	aPagos	:=	{{1,cFornece,cLoja,cFor,0,0,0,0,0,0,0,0,0,0,0,0,0,0,.F.,0}}
	SA6->(DbSetOrder(1))
	SA6->(DbSeek(xFilial()+cBanco+cAgencia+cConta))
	nMoedaPag	:=	Iif(SA6->A6_MOEDAP>0,SA6->A6_MOEDAP,Max(SA6->A6_MOEDA,1))
	If cPaisLoc == "ANG"
		nRetRIE	:= If(lRetPA,nValor-nLiquido,0)
	Endif
	If cPaisLoc == "PER" .AND. nLiquido>0
		nRetIGV	:= 0
		If lRetPA
			If !Empty(aSE2[1,1,1,_RETIGV])
				nRetIGV := aSE2[1,1,1,_RETIGV,1,6]
			Endif
		Endif
		/* retencao de IR */
		nRetIR := 0
		If lRetPA
			If !Empty(aSE2[1,1,1,_RETIR])
				nRetIR := aSE2[1,1,1,_RETIR,1,6]
			Endif
		Endif
	Endif

	Do Case
		Case nPagar	==	1
			aSE2[1][3]	:=	{nPagar,cBanco,cAgencia,cConta,dDataVenc1}
			nMoedaCor	:=	nMoedaPag
			aPagos[1][H_TOTALVL]	:=	nValor
		Case nPagar	==	2
			aSE2[1][3]	:=	{nPagar,cBanco,cAgencia,cConta,dDataVenc,cDebMed,(dDataVenc<=dDataBase.And.lBaixaChq)}
			nMoedaCor	:=	nMoedaPag
			aPagos[1][H_TOTALVL]	:=	nValor
		Case nPagar	==	3
			aSE2[1][3]	:=	{nPagar,cBanco,cAgencia,cConta,cDebInm}
			nMoedaCor	:=	nMoedaPag
			aPagos[1][H_TOTALVL]	:=	nValor
		Case nPagar	==	4
			aSE2[1][3]	:=	{nPagar,aClone(aCols),aClone(aRecChqTer)}
			aPagos[1][H_TOTALVL]	:=	aSaldos[Len(aSaldos)]  + 	nRet + nRetIB + nRetIva + nRetSuss +nRetIGV + nRetIR
	EndCase
	aPagos[1][H_CBU]	:= Iif(cPaisLoc == "ARG",lCBU,.F.)
	aPagos[1][H_TOTAL ] :=	TransForm(aPagos[1][H_TOTALVL],Tm(aPagos[1][H_TOTALVL] ,18,nDecs))
	aPagos[1][H_TOTRET]	:=	nRet +nRetIB + nRetIva + nRetSuss+nRetRIE+nRetIGV
	aPagos[1][H_RETGAN]	:=	TransForm(nRet,Tm(nRet,16,nDecs))
	aPagos[1][H_RETIVA]	:=	TransForm(nRetIva,Tm(nRetIva,16,nDecs))
	aPagos[1][H_RETIB ]	:=	TransForm(nRetIB,Tm(nRetIB,16,nDecs))
	aPagos[1][H_RETSUSS]:=	TransForm(nRetSuss,Tm(nRetSuss,16,nDecs))
	aPagos[1][H_RETRIE]	:=	TransForm(nRetRIE,Tm(nRetRIE,16,nDecs))
	aPagos[1][H_RETIGV]	:=	TransForm(nRetIGV,Tm(nRetIGV,16,nDecs))
	aPagos[1][H_RETIR]	:=	TransForm(nRetIR,Tm(nRetIR,16,nDecs))
  	aPagos[1][H_TOTAL ]	:=	"0"
   	aPagos[1][H_TOTALVL]+=	(nRet + nRetIB + nRetIva + nRetSuss+nRetRIE+nRetIGV+nRetIR) * -1
	aCert:={}
	Processa({|| Fa085Grava(aSE2,.T.,,lMonotrb,@nFlagMOD,@nCtrlMOD,@aCtrChEQU) })

	IF cPaisLoc	==	"PER"

		IF MV_PAR12 == 1 .and. len(aCert) > 0
			For nI:=1 to Len(aCert)
	  			bBlock := &("{||"+Alltrim(mv_par13)+"(aCert[nI][1],aCert[nI][2],.T.)"+"}")
	  			Eval(bBLock)
            NEXT nI
		EndIf
	EndIf

ElseIf nPagar == 4
	DbSelectArea("SE1")
	For	nA:=1 To Len(aRecChqTer)
		If aRecChqTer[nA] > 0
			MsRUnlock(aRecChqTer[nA])
		Endif
	Next
Endif

//������������������������������������������������Ŀ
//� Finaliza a gravacao dos lancamentos do SIGAPCO �
//��������������������������������������������������
PcoFinLan("000313")
aRotina:= aClone(aRotinaOld)
aHeader:= aClone(aHeaderOld)
aCols  := aClone(aColsOld)
n	   := nOld

Return( .F. )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �a085aVldPA�Autor  �Bruno Sobieski      �Fecha �  01/17/01   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida o fornecedor na digitacao do Paganmento adiantado   ���
���          � e atualiza os objetos referidos .                          ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function a085aVldPA(nOpc,cFornece,cFor,oFor,oRet,nRet,nValor,nLiquido,oLiquido,aSE2,cLoja,cCF,cProv,oRetIB,nRetIB,cZnGeo,nGrpSus,nTotAnt,oRetIVA,nRetIVA,oRetSUSS,nRetSuss)
Local lRet		:= .F.
Local cPesquisa	:=""

Default nTotAnt:=0

If lRetPA == Nil
	lRetPA := (GetNewPar("MV_RETPA","N") == "S")
EndIf

If !Empty(cLoja)
	cPesquisa	:= cFornece+cLoja
Else
	cPesquisa	:=cFornece
EndIf

SA2->(DbSetOrder(1))
If nOpc	==	1	//validacao do fornecedor
	If SA2->(DbSeek(xFilial("SA2")+cPesquisa)) .AND. cFornece >= cForDe .And.cFornece <= cForAte
		cFor:= SA2->A2_NREDUZ //SA2->A2_NOME
		oFor:SetText(cFor)
		oFor:Refresh()
		lRet:= .T.
	Else
		Help(" ",1,"NOFORNEC")
		lRet	:=	.F.
	Endif
Endif

Return lRet

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ShowPO   � Autor � Armando P. Waiteman� Data �  16/01/01   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao para a geracao de tela com a lista de todas as      ���
���          � ordens de pagto geradas.                                   ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function a085aShow(aList,oBrw)
Local oDlg,oLbx
Local nTotalPago	:=	0
Local oFnt
Local nX 			:= 0
Local aA085BTN		:= {}
Local oBtnAux
Local aHeader		:= {}
Local aSize			:= {}

DEFINE FONT oFnt  NAME "Arial" SIZE 09,11 BOLD

For nX	:=	1	To	Len(aList)
    nTotalPago	+=	aList[nX][5]
Next

//DEFINE MsDialog  oDlg FROM  91,61 To 400,635  Title OemToAnsi(STR0132) PIXEL Of oBrw  //"Ordenes de pago generadas"
DEFINE MsDialog  oDlg FROM  91,61 To 400,635  Title OemToAnsi(STR0132) PIXEL Of oBrw: GetOwner()  //"Ordenes de pago generadas"
@ 03,05 To 130,280 PIXEL of oDlg
//"Nro OP","Proveedor","Sucursal","Nombre","Valor Pago"
If cPaisLoc == "ARG" .And. SEK->(FieldPos("EK_PGCBU")) > 0
	aHeader := {STR0134,STR0054,STR0055,STR0056,STR0135,STR0202,STR0254,"CPR"}
	aSize   := {35,35,18,90,60,30}
Else
	aHeader := {STR0134,STR0054,STR0055,STR0056,STR0135}
	aSize   := {35,35,18,90,60}
Endif

oLBx := TWBrowse():New( 07,07,270,120,,aHeader,aSize,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
// Define o conte�do do listbox
oLbx:SetArray(aList)
// Define as colunas que ser�o impressas e a ordem (Fixo para cinco colunas)
oLbx:bLine:={ || {aList[oLbx:nAt,1],aList[oLbx:nAt,2],aList[oLbx:nAt,3],aList[oLbx:nAt,4],TransForm(aList[oLbx:nAt,5],TM(aList[oLbx:nAt,5],19,MsDecimais(nMoedaCor))),Iif(aList[oLbx:nAt,6],STR0047,STR0048)} }
@140,10 SAY OemToAnsi(STR0133) Size 60,10 PIXEL of oDlg FONT oFnt  //"Total Pago : "
@140,75 SAY nTotalPago Picture	TM(nTotalPago,19,MsDecimais(nMoedaCor)) Size 80,10 Of oDlg PIXEL FONT oFnt

// PE para permitir ao usuario incluir objetos na tela.
If ExistBlock( "A085BTN" )
	aA085BTN := ExecBlock( "A085BTN" )
	oBtnAux := TButton():New( 135, aA085BTN[1], aA085BTN[2], oDlg, { || NIL }, 32, 10,,, .F., .T., .F.,, .F.,,, .F. )
	oBtnAux:bAction := { || &( aA085BTN[3] ) }
EndIf

Define SBUTTON FROM  135,250 Type 1 Of oDlg ENABLE Action oDlg:End()

Activate Dialog oDlg CENTERED

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AaddSE2   �Autor  �Bruno Sobieski      � Data �  10/17/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Inclui um novo Item no array de notas para serem pagas      ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085a                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AaddSE2(nControl,aSE2,lFake)
Local x,y
Local cFatGer  := " "
Local nVlrRet  := 0
Local nTxMoeda := 0

lBxParc := IIf( Type("lBxParc")=="U", Iif(SE2->(FieldPos("E2_VLBXPAR")>0),.T.,.F.), lBxParc)
DEFAULT lFake	:=	.F.
//A estrutura do array eh a seguinte

// Cada elemento do aSE2 e uma ordem de pagamento, e dentro desta
// matriz temos, por um lado (posi'cao 1) as retencoes de GANACIAS (argentina)
// e o outro elemento eh um array com os dados de cada nota

//    aSE2[1][1]    := Array com as notas da ordem de pagamento
//    aSE2[1][1][1]  := Array com os dados da nota 1
//    aSE2[1][1][2]  := Array com os dados da nota 1
//              [3]
//              [4]
//      ...
//    aSE2[1][2][1]   := Array com retencoes de ganancias para o primer conceito
//    aSE2[1][2][2]   := Array com retencoes de ganancias para o segundo conceito
//              [3]
//      ...
//    aSE2[1][3][1]   := Tipo (Cheque pre-impresso == 1,Debito mediato == 2,,Debito Inmediato == 3,Informado == 4
//    aSE2[1][3][2]   := Outras informacoes do pagamento
//              [3]  := Outras informacoes do pagamento
//              [4]  := Outras informacoes do pagamento
//	  ...
//    aSE2[1][4]     := Array com despesas

x  := nControl

If x > Len(aSE2)
	AAdd(aSE2,{ { Array(_ELEMEN) }, {} , Nil, {} } )
	y  := 1
Else
	AAdd(aSE2[x][1],Array(_ELEMEN))
	y  := Len(aSE2[x][1])
Endif
If !lFake
	aSe2[x][1][y][_FORNECE] := SE2->E2_FORNECE
	aSE2[x][1][y][_LOJA   ] := SE2->E2_LOJA
	aSE2[x][1][y][_NOME   ] := SE2->E2_NOMFOR
	aSE2[x][1][y][_MOEDA  ] := SE2->E2_MOEDA
	aSE2[x][1][y][_EMISSAO] := SE2->E2_EMISSAO
	aSE2[x][1][y][_VENCTO ] := SE2->E2_VENCTO
	aSE2[x][1][y][_PREFIXO] := SE2->E2_PREFIXO
	aSE2[x][1][y][_NUM    ] := SE2->E2_NUM
	aSE2[x][1][y][_PARCELA] := SE2->E2_PARCELA
	aSE2[x][1][y][_TIPO   ] := SE2->E2_TIPO
	aSE2[x][1][y][_NATUREZ] := SE2->E2_NATUREZ
	aSE2[x][1][y][_RECNO  ] := SE2->(RECNO())
	aSE2[x][1][y][_RETIVA ] := {}
	aSE2[x][1][y][_RETIB  ] := {}
	aSE2[x][1][y][_VALOR  ] := SE2->E2_VALOR + SE2->E2_ACRESC - SE2->E2_DECRESC
	aSE2[x][1][y][_FILORIG ] := SE2->E2_FILORIG
	If cPaisLoc == "MEX"
   		aSE2[x][1][y][_FILIAL] := SE2->E2_FILIAL
	EndIf
	//Considero para moeda da orden de pago:
	// 1 - Moeda da taxa modificada/digitada quando for diferente da cota��o do dia (significa que foi modificada)
	// 2 - Taxa da inclus�o do t�tulo (E2_TXMOEDA)
	// 3 - Taxa do dia (SM2)
	If aTxMoedas[SE2->E2_MOEDA][2] <> Round(RecMoeda(dDataBase,SE2->E2_MOEDA),TamSX3("M2_MOEDA"+ALLTRIM(STR(SE2->E2_MOEDA)))[2])
		nTxMoeda := aTxMoedas[SE2->E2_MOEDA][2]
	ElseIf SE2->E2_TXMOEDA <> 0
		nTxMoeda := SE2->E2_TXMOEDA
	Else
		nTxMoeda := Round(RecMoeda(dDataBase, SE2->E2_MOEDA),TamSX3("M2_MOEDA"+ALLTRIM(STR(SE2->E2_MOEDA)))[2])
	EndIf

	If cPaisLoc $ "DOM|COS"
		cFatGer     := F085FatGer(SE2->E2_NATUREZ)
		nVlrRet 	:= F085PesAbt()
		If nVlrRet  > 0 .And. cFatGer == "2" .And. Empty(SE2->E2_BAIXA)  .And. SE2->E2_VALLIQ == 0  .And. !SE2->E2_TIPO	$ 	"CH |PA "
			RecLock("SE2",.F.)
			Replace SE2->E2_VALOR With SE2->E2_VALOR 	+ nVlrRet
			Replace SE2->E2_SALDO With  SE2->E2_SALDO 	+ nVlrRet
			Replace SE2->E2_VLCRUZ With  SE2->E2_VLCRUZ	+ nVlrRet
			MsUnlock()
			F085DelAbt(xFilial("SE2")+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM)
		EndIf
		/* Gera��o das Reten��es de Impostos - Republica Dominicana */
		/* Function fa050CalcRet(cCarteira, cFatoGerador)           */
		/* 1-Contas a Pagar ou 3-Ambos e Fato Gerador 2-Baixa       */
		If 	!SE2->E2_TIPO	$ 	"CH |PA "
			fa050CalcRet("'1|3'", "2", SE2->E2_NATUREZA, SE2->E2_VALOR, SE2->E2_PREFIXO, SE2->E2_NUM, SE2->E2_FORNECE)
		EndIf
	EndIf
	//Reten��es do Equador ocorrem na Origem
	If	cPaisLoc $ "DOM|COS|EQU|PER" //.Or. (cPaisLoc == "DOM" .And. SE2->E2_TIPO == MVPAGANT)
		aSE2[x][1][y][_ABATIM ] := 0
	Else
		aSE2[x][1][y][_ABATIM ] := SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",SE2->E2_MOEDA,,SE2->E2_FORNECE)
	EndIf
	If cPaisLoc=="PER" .And.  SE2->(FieldPos("E2_SERORI")) >0
		aSE2[x][1][y][_SERORI ] := SE2->E2_SERORI
	EndIf
	If lBxParc .and. SE2->E2_VLBXPAR >0   .And.  SE2->E2_VLBXPAR <=SE2->E2_SALDO
		aSE2[x][1][y][_PAGAR  ] := SE2->E2_VLBXPAR - aSE2[x][1][y][_ABATIM ] + SE2->E2_SDACRES
	Else
		aSE2[x][1][y][_PAGAR  ] := SE2->E2_SALDO - aSE2[x][1][y][_ABATIM ] + SE2->E2_SDACRES
	EndIf
	If lBxParc .and. SE2->E2_VLBXPAR >0     .And.  SE2->E2_VLBXPAR <=SE2->E2_SALDO
		If cPaisLoc == "PER"
			aSE2[x][1][y][_SALDO1 ] := Round(xMoeda(SE2->E2_VLBXPAR - aSE2[x][1][y][_ABATIM ],SE2->E2_MOEDA,1,,5,nTxMoeda),MsDecimais(1))
		Else
			aSE2[x][1][y][_SALDO1 ] := Round(xMoeda(SE2->E2_VLBXPAR - aSE2[x][1][y][_ABATIM ],SE2->E2_MOEDA,1,,5,aTxMoedas[SE2->E2_MOEDA][2]),MsDecimais(1))
		EndIf
	Else
		If cPaisLoc == "PER"
			aSE2[x][1][y][_SALDO1 ] := Round(xMoeda(SE2->E2_SALDO - aSE2[x][1][y][_ABATIM ],SE2->E2_MOEDA,1,,5,nTxMoeda),MsDecimais(1))
		Else
	   		aSE2[x][1][y][_SALDO1 ] := Round(xMoeda(SE2->E2_SALDO + SE2->E2_SDACRES - aSE2[x][1][y][_ABATIM ],SE2->E2_MOEDA,1,,5,aTxMoedas[SE2->E2_MOEDA][2]),MsDecimais(1))
		EndIf
	EndIf

	If lBxParc .and. SE2->E2_VLBXPAR >0  .And.  SE2->E2_VLBXPAR <=SE2->E2_SALDO
		aSE2[x][1][y][_SALDO  ] :=  SE2->E2_VLBXPAR
	Else
		aSE2[x][1][y][_SALDO  ] := SE2->E2_SALDO
	EndIf
	If Empty(SE2->E2_BAIXA)
        If cPaisLoc == "COL"
			aSE2[x][1][y][_DESCONT] := SE2->E2_DECRESC
        Else
			aSE2[x][1][y][_DESCONT] := SE2->E2_DESCONT
        EndIf
		aSE2[x][1][y][_MULTA  ] := SE2->E2_MULTA
		aSE2[x][1][y][_JUROS  ] := SE2->E2_JUROS
	Else
		aSE2[x][1][y][_DESCONT] := 0
		aSE2[x][1][y][_MULTA  ] := 0
		aSE2[x][1][y][_JUROS  ] := 0
	EndIf
	aSE2[x][1][y][_RETIRIC ] := {}
	aSE2[x][1][y][_RETSUSS ] := {}
	aSE2[x][1][y][_RETSLI  ] := {}
	aSE2[x][1][y][_RETIR ] := {}
	aSE2[x][1][y][_RETIRC  ] := {}
	aSE2[x][1][y][_RETISI  ] := {}
	aSE2[x][1][y][_RETRIE ] := {}	//ANGOLA
	aSE2[x][1][y][_RETIGV ] := {}	//PERU
	aSE2[x][1][y][_RETIR ] := {}	//PERU
	If cPaisLoc == "PER"
   		aSE2[x][1][y][_TXMOEDA] := nTxMoeda
	EndIf
Else
	aSe2[x][1][y][_FORNECE] := ""//SE2->E2_FORNECE
	aSE2[x][1][y][_LOJA   ] := ""//SE2->E2_LOJA
	aSE2[x][1][y][_NOME   ] := ""//SE2->E2_NOMFOR
	aSE2[x][1][y][_MOEDA  ] := ""//SE2->E2_MOEDA
	aSE2[x][1][y][_EMISSAO] := ""//SE2->E2_EMISSAO
	aSE2[x][1][y][_VENCTO ] := ""//SE2->E2_VENCTO
	aSE2[x][1][y][_PREFIXO] := ""//SE2->E2_PREFIXO
	aSE2[x][1][y][_NUM    ] := ""//SE2->E2_NUM
	aSE2[x][1][y][_PARCELA] := ""//SE2->E2_PARCELA
	aSE2[x][1][y][_TIPO   ] := ""//SE2->E2_TIPO
	aSE2[x][1][y][_NATUREZ] := ""//SE2->E2_NATUREZ
	aSE2[x][1][y][_RECNO  ] := ""//SE2->(RECNO())
	aSE2[x][1][y][_RETIVA ] := {}
	aSE2[x][1][y][_RETIB  ] := {}
	aSE2[x][1][y][_VALOR  ] := 0 //SE2->E2_VALOR
	aSE2[x][1][y][_PAGAR  ] := 0
	aSE2[x][1][y][_ABATIM ] := 0
	aSE2[x][1][y][_SALDO  ] := 0 //SE2->E2_SALDO
	aSE2[x][1][y][_SALDO1 ] := 0
	aSE2[x][1][y][_DESCONT] := 0
	aSE2[x][1][y][_MULTA  ] := 0
	aSE2[x][1][y][_JUROS  ] := 0
	aSE2[x][1][y][_RETIRIC ] := {}
	aSE2[x][1][y][_RETSUSS ] := {}
	aSE2[x][1][y][_RETSLI  ] := {}
	aSE2[x][1][y][_RETIR ] := {}
	aSE2[x][1][y][_RETISI  ] := {}
	aSE2[x][1][y][_RETRIE ] := {}	//ANGOLA
	aSE2[x][1][y][_RETIGV ] := {}	//peru
	aSE2[x][1][y][_RETIR ] := {}	//peru
	If cPaisLoc == "MEX"
   		aSE2[x][1][y][_FILIAL] := ""
	EndIf
Endif
If ExistBlock("F085AALE2")
	aSE2[x][1][y]:=ExecBlock("F085AALE2",.F.,.F.,{aSE2[x][1][y]})
EndIf
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A085FORN  �Autor  �Marcello Gabriel    � Data �  22/03/01   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cria uma janela com a lista de fornecedores                 ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085a                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function A085AFORN(aSE2)
Local ni,oCol,nTitulos,oForm ,oCBX, cIndice
Local nOrdSA2,nSA2,nOrdSX3
Local cCodForn:= Space(30)
Local aSE2Tmp
Local lRet			:=	.T.
Local aRateioGan  :=	{}
Local aAreaSA2
Private cFiltro,cTitulo
Private cForm:= Space(9)
Private oDlgForn,nOpca,cAlias:=Alias()
Private oBrwForn
Private nIndice := 1

DbSelectArea("SX3")
nOrdSX3:=IndexOrd()
DbSetOrder(2)
DbSelectArea("SA2")
nSA2:=Select("SA2")
nOrdSA2:=Indexord()
DbSetorder(1)

If nCondAgr==2
   cFiltro:="A2_COD='"+aPagos[oLbx:nAT][H_FORNECE]+"'"
	If lMsFil .And. !Empty(xFilial("SA2")) .And. xFilial("SF1") == xFilial("SE2")
		cFiltro += " .And. A2_FILIAL = '" + SE2->E2_MSFIL + "'"
	Endif

    MSFilter(cFiltro)

   SA2->(DbGoTop())
Else
	SA2->(dbseek(xFilial("SA2")))
Endif

nOpca:=0
cTitulo:=STR0054
If nCondAgr==2
   cTitulo+=" "+aPagos[oLbx:nAT][H_FORNECE]

	DEFINE MSDIALOG oDlgForn FROM  0,0 TO 250,500 PIXEL TITLE cTitulo OF oMainWnd
	   oBrw:=TCBrowse():New(5,5,241,100,,,,oDlgForn,,,,,{|nRow,nCol,nFlags|nOpca:=1,oDlgForn:End()},,,,,,,.F.,,.T.,,.F.,)
	   If nCondAgr>2
	      SX3->(DbSeek("A2_COD"))
	      oCol:=TCColumn():New(Trim(x3titulo()),FieldWBlock("A2_COD",nSA2),,,,,,.F.,.F.,,,,.F.,)
	      oBrw:ADDCOLUMN(oCol)
	   Endif
	   SX3->(DbSeek("A2_LOJA"))
	   oCol:=TCColumn():New(Trim(x3titulo()),FieldWBlock("A2_LOJA",nSA2),,,,,,.F.,.F.,,,,.F.,)
	   oBrw:ADDCOLUMN(oCol)
	   SX3->(DbSeek("A2_NREDUZ"))

	   oCol:=TCColumn():New(Trim(x3titulo()),FieldWBlock("A2_NREDUZ",nSA2),,,,,,.F.,.F.,,,,.F.,)
	   oBrw:ADDCOLUMN(oCol)
	   DEFINE SBUTTON FROM 110,185 TYPE 1 ACTION (nOpca:=1,oDlgForn:End()) PIXEL ENABLE OF oDlgForn
	   DEFINE SBUTTON FROM 110,217 TYPE 2 ACTION (nOpca:=0,oDlgForn:End()) PIXEL ENABLE OF oDlgForn
	ACTIVATE MSDIALOG oDlgForn CENTERED
	If nOpca==1
	   aAreaSA2	:=	SA2->(GetArea())
		If RateioCond(@aRateioGan)
			RestArea(aAreaSA2)
		   aPagos[oLbx:nAT][H_FORNECE]	:=	SA2->A2_COD
		   aPagos[oLbx:nAT][H_LOJA]		:=	SA2->A2_LOJA
			aPagos[oLbx:nAT][H_NOME]		:=	SA2->A2_NREDUZ
			aSE2Tmp	:=	a085aRecal(oLbx:nAT,aSE2,,,,,,,,,,,,,,,,,,,,aRateioGan,.F.)
			aSE2[oLBX:nAT]	:=	aClone(aSE2Tmp)
		Endif
		RestArea(aAreaSA2)
		 oLbx:refresh()
	Endif
Else
	If ConPad1(,,,"SA2")
		aAreaSA2	:=	SA2->(GetArea())
		If RateioCond(@aRateioGan)
			RestArea(aAreaSA2)
		   aPagos[oLbx:nAT][H_FORNECE]	:=	SA2->A2_COD
		   aPagos[oLbx:nAT][H_LOJA]		:=	SA2->A2_LOJA
			aPagos[oLbx:nAT][H_NOME]		:=	SA2->A2_NREDUZ
			aSE2Tmp	:=	a085aRecal(oLbx:nAT,aSE2,,,,,,,,,,,,,,,,,,,,aRateioGan,.F.)
			aSE2[oLBX:nAT]	:=	aClone(aSE2Tmp)
		Endif
		RestArea(aAreaSA2)
		oLbx:refresh()
	EndIf
EndIf
DbSelectArea("SA2")
If nCondAgr==2
   DbClearFilter()
Endif
DbSetOrder(nOrdSA2)
SX3->(DbSetOrder(nOrdSX3))
dbSelectArea(cAlias)
Return lRet

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � GERATXT  � Autor � Jose Novaes Romeu  � Data �  05/06/01   ���
�������������������������������������������������������������������������͹��
���Descri��o � Gravacao de arquivo de LOG quando o saldo for maior que o  ���
���          � valor do titulo a pagar. Somente para localizacao "POR".   ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function GeraTxt(cPrefixo,cNum,cParcela,cTipo,cFornece,cLoja,cSaldoAnt,cSaldo)
Local cArqTxt	:= "ERRORPAG.LOG"
Local cEOL		:= "CHR(13)+CHR(10)"
Local nMode		:= 1
Local nTamLin	:= 80
Local cLin, nHdl
Local aFil		:= IIf( FindFunction( "FWArrFilAtu" ), FWArrFilAtu( cEmpAnt, cFilAnt ), { SM0->M0_CODIGO } )

cEOL := &cEOL
nHdl := fOpen(cArqTxt,nMode)

If nHdl == -1
	nHdl := fCreate(cArqTxt)
Endif

If nHdl <> -1
	fSeek(nHdl,0,2)
	cLin	:= Padr( aFil[1]+cFilial+"/"+cPrefixo+"/"+cNum+"/"+cParcela+"/"+cTipo+;
			"/"+cFornece+"/"+cLoja+"/"+cSaldoAnt+"/"+cSaldo,nTamLin)+cEOL
	fWrite(nHdl,cLin)
	fClose(nHdl)
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � GravaRet � Autor � Bruno Sobieski     � Data �  27/06/01   ���
�������������������������������������������������������������������������͹��
���Descri��o � Gravacao das retencoes de impostos  (argentina)            ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function a085aGravRet(aRets,cFornece,cLoja,cParcela,lGan,aTitPags,nMoedaRet,lGerPA,lCBU)
 Local nX	     := 0
Local cNroCert   := ""
Local cNroCert1	 := ""
Local aArea   := {}
Local nValRet	:=	0
Local cConcAnt	:=	''
Local aValGan  := {}  // Guilherme
Local nPosVal  := 0   // Guilherme
Local nS := 0
Local nItensc:= GETMV("MV_ITENSC",.F.,0)
Local nC := 0
Local nImporte := 0
Local nContGan := 0
Local nTotRet  := 0
Local nContIva := 0
Local cChave1	:=	""
Local aAreaSF1 	:= SF1->(GetArea())
Local aAreaSF2	:= SF2->(GetArea())
Local nLimite   :=0

Default lGerPa:=.F.
Default lCBU := .F.
If lA085aRet == Nil
	lA085aRet	:=	ExistBlock("A085ARET")
Endif

If cPaisLoc $ "URU|BOL"
	If !lGan                                                                        
		nLimite:= Iif(ValType(aRets[_RETIRIC])=="A",Len(aRets[_RETIRIC]),0)
		For nX 	:= 1	To nLimite				                                 			
			If aRets[_RETIRIC][nX][6] != 0
				cNroCert	:=	GetCert("IRIC  ",cFornece+cLoja+"IRIC")
				RecLock("SFE",.T.)
				FE_FILIAL	:=	xFilial("SFE")
				FE_NROCERT	:=	cNroCert
				FE_EMISSAO  :=	dDataBase
				FE_FORNECE  :=	cFornece
				FE_LOJA     :=	cLoja
				FE_TIPO     :=	"I"
				FE_ORDPAGO  :=	cOrdPago
				FE_PARCELA	:=	cParcela
				FE_NFISCAL 	:=	aRets[_RETIRIC][nX][1]
				FE_SERIE	:=	aRets[_RETIRIC][nX][2]
				FE_VALBASE	:=	aRets[_RETIRIC][nX][3]
				FE_VALIMP	:=	aRets[_RETIRIC][nX][4]
				FE_PORCRET	:=	aRets[_RETIRIC][nX][5]
				FE_RETENC	:=	aRets[_RETIRIC][nX][6]
				MsUnLock()

				RecLock("SEK",.T.)
				SEK->EK_FILIAL  := xFilial("SEK")
				SEK->EK_TIPODOC := "RG" //Retencion Generada
				SEK->EK_NUM     := cNroCert
				SEK->EK_TIPO    := "IR-"
				SEK->EK_EMISSAO	:= dDataBase
				SEK->EK_VLMOED1 := aRets[_RETIRIC][nX][6]
				SEK->EK_VALOR   := aRets[_RETIRIC][nX][6]
				SEK->EK_SALDO   := aRets[_RETIRIC][nX][6]
				SEK->EK_VENCTO  := dDataBase
				SEK->EK_FORNECE := cFornece
				SEK->EK_LOJA    := cLoja
				SEK->EK_MOEDA	:= StrZero(1,TamSx3("EK_MOEDA")[1]) //"01"
				SEK->EK_ORDPAGO := cOrdPago
				SEK->EK_DTDIGIT := dDataBase
				If FieldPos("EK_FORNEPG")>0
			   		SEK->EK_FORNEPG:= cFornece
				Endif
				If FieldPos("EK_LOJAPG")>0
		   			SEK->EK_LOJAPG:= cLoja
				Endif
				If SEK->(FieldPos("EK_NATUREZ"))>0
				   SEK->EK_NATUREZ:= cNatureza
				Endif
				F085AGrvTx()
				MsUnlock()
				aTitPags[1]	-=	SEK->EK_VALOR
				If lA085aRet
					ExecBLock("A085ARET",.F.,.F.,"IRIC")
				Endif
				//����������������������������������������������������������Ŀ
				//� Grava os lancamentos nas contas orcamentarias SIGAPCO    �
				//������������������������������������������������������������
				PcoDetLan("000313","05","FINA085A")
			EndIf
		Next
		nLimite:= Iif(ValType(aRets[_RETIR])=="A",Len(aRets[_RETIR]),0)
		For nX 	:= 1	To nLimite				                                 			
			If aRets[_RETIR][nX][6] != 0
				cNroCert	:=	GetCert("IR  ",cFornece+cLoja+"IR")
				RecLock("SFE",.T.)
				FE_FILIAL	:=	xFilial("SFE")
				FE_NROCERT	:=	cNroCert
				FE_EMISSAO  :=	dDataBase
				FE_FORNECE  :=	cFornece
				FE_LOJA     :=	cLoja
				FE_TIPO     :=	"I"
				FE_ORDPAGO  :=	cOrdPago
				FE_PARCELA	:=	cParcela
				FE_NFISCAL 	:=	aRets[_RETIR][nX][1]
				FE_SERIE	:=	aRets[_RETIR][nX][2]
				FE_VALBASE	:=	aRets[_RETIR][nX][3]
				FE_VALIMP	:=	aRets[_RETIR][nX][4]
				FE_PORCRET	:=	aRets[_RETIR][nX][5]
				FE_RETENC	:=	aRets[_RETIR][nX][6]
				MsUnLock()

				RecLock("SEK",.T.)
				SEK->EK_FILIAL  := xFilial("SEK")
				SEK->EK_TIPODOC := "RG" //Retencion Generada
				SEK->EK_NUM     := cNroCert
				SEK->EK_TIPO    := "IR-"
				SEK->EK_EMISSAO	:= dDataBase
				SEK->EK_VLMOED1 := aRets[_RETIR][nX][6]
				SEK->EK_VALOR   := aRets[_RETIR][nX][6]
				SEK->EK_SALDO   := aRets[_RETIR][nX][6]
				SEK->EK_VENCTO  := dDataBase
				SEK->EK_FORNECE := cFornece
				SEK->EK_LOJA    := cLoja
				SEK->EK_MOEDA	:= StrZero(1,TamSx3("EK_MOEDA")[1]) //"01"
				SEK->EK_ORDPAGO := cOrdPago
				SEK->EK_DTDIGIT := dDataBase
				If FieldPos("EK_FORNEPG")>0
			   		SEK->EK_FORNEPG:= cFornece
				Endif
				If FieldPos("EK_LOJAPG")>0
		   			SEK->EK_LOJAPG:= cLoja
				Endif
				If SEK->(FieldPos("EK_NATUREZ"))>0
				   SEK->EK_NATUREZ:= cNatureza
				Endif
				F085AGrvTx()
				MsUnlock()
				aTitPags[1]	-=	SEK->EK_VALOR
				If lA085aRet
					ExecBLock("A085ARET",.F.,.F.,"IRI")
				Endif
				//����������������������������������������������������������Ŀ
				//� Grava os lancamentos nas contas orcamentarias SIGAPCO    �
				//������������������������������������������������������������
				PcoDetLan("000313","05","FINA085A")
			EndIf
		Next
	EndIf
ElseIf cPaisLoc=="PTG"
	If !lGan                                                                                
		nLimite:= Iif(ValType(aRets[_RETIVA])=="A",Len(aRets[_RETIVA]),0)
		For nX 	:= 1	To nLimite				                                 				
			If aRets[_RETIVA][nX][6] != 0
				cNroCert	:=	GetCert("IVA  ",cFornece+cLoja+"IVA")
				RecLock("SFE",.T.)
				FE_FILIAL	:=	xFilial("SFE")
				FE_NROCERT	:=	cNroCert
				FE_EMISSAO  :=	dDataBase
				FE_FORNECE  :=	cFornece
				FE_LOJA     :=	cLoja
				FE_TIPO     :=	"I"
				FE_ORDPAGO  :=	cOrdPago
				FE_PARCELA	:=	cParcela
				FE_NFISCAL 	:=	aRets[_RETIVA][nX][1]
				FE_SERIE	:=	aRets[_RETIVA][nX][2]
				FE_VALBASE	:=	aRets[_RETIVA][nX][3]
				FE_VALIMP	:=	aRets[_RETIVA][nX][4]
				FE_PORCRET	:=	aRets[_RETIVA][nX][5]
				FE_RETENC	:=	aRets[_RETIVA][nX][6]
				MsUnLock()

				RecLock("SEK",.T.)
				SEK->EK_FILIAL  := xFilial("SEK")
				SEK->EK_TIPODOC := "RG" //Retencion Generada
				SEK->EK_NUM     := cNroCert
				SEK->EK_TIPO    := "IV-"
				SEK->EK_EMISSAO	:= dDataBase
				SEK->EK_VLMOED1 := aRets[_RETIVA][nX][6]
				SEK->EK_VALOR   := Round(xMoeda(aRets[_RETIVA][nX][6],1,nMoedaRet,,3,,aTxMoedas[nMoedaRet][2]),MsDecimais(nMoedaRet))
				SEK->EK_SALDO   := Round(xMoeda(aRets[_RETIVA][nX][6],1,nMoedaRet,,3,,aTxMoedas[nMoedaRet][2]),MsDecimais(nMoedaRet))
				SEK->EK_VENCTO  := dDataBase
				SEK->EK_FORNECE := cFornece
				SEK->EK_LOJA    := cLoja
				SEK->EK_MOEDA	:= StrZero(nMoedaRet,TamSx3("EK_MOEDA")[1]) //"01"
				SEK->EK_ORDPAGO := cOrdPago
				SEK->EK_DTDIGIT := dDataBase
		   		SEK->EK_FORNEPG:= cFornece
	   			SEK->EK_LOJAPG:= cLoja
				If SEK->(FieldPos("EK_NATUREZ")) > 0
				   SEK->EK_NATUREZ:= cNatureza
				Endif
				F085AGrvTx()
				MsUnlock()

				aTitPags[1]	-=	aRets[_RETIVA][nX][6]
				If lA085aRet
					ExecBLock("A085ARET",.F.,.F.,"IVA")
				Endif
			EndIf
		Next  
		nLimite:= Iif(ValType(aRets[_RETIRC])=="A",Len(aRets[_RETIRC]),0)
		For nX 	:= 1	To nLimite				                                 						
			If aRets[_RETIRC][nX][5] != 0
				cNroCert	:=	GetCert("IRC  ",cFornece+cLoja+"IRC")
				RecLock("SFE",.T.)
				FE_FILIAL	:=	xFilial("SFE")
				FE_NROCERT	:=	cNroCert
				FE_EMISSAO  :=	dDataBase
				FE_FORNECE  :=	cFornece
				FE_LOJA     :=	cLoja
				FE_TIPO     :=	"R"
				FE_ORDPAGO  :=	cOrdPago
				FE_PARCELA	:=	cParcela
				FE_NFISCAL 	:=	aRets[_RETIRC][nX][1]
				FE_SERIE	:=	aRets[_RETIRC][nX][2]
				FE_VALBASE	:=	aRets[_RETIRC][nX][3]
				FE_ALIQ   	:=	aRets[_RETIRC][nX][4]
				FE_VALIMP	:=	aRets[_RETIRC][nX][5]
				FE_RETENC	:=	aRets[_RETIRC][nX][5]
				MsUnLock()

				RecLock("SEK",.T.)
				SEK->EK_FILIAL  := xFilial("SEK")
				SEK->EK_TIPODOC := "RG" //Retencion Generada
				SEK->EK_NUM     := cNroCert
				SEK->EK_TIPO    := "IR-"
				SEK->EK_EMISSAO	:= dDataBase
				SEK->EK_VLMOED1 := aRets[_RETIRC][nX][5]
				SEK->EK_VALOR   := Round(xMoeda(aRets[_RETIRC][nX][5],1,nMoedaRet,,3,,aTxMoedas[nMoedaRet][2]),MsDecimais(nMoedaRet))
				SEK->EK_SALDO   := Round(xMoeda(aRets[_RETIRC][nX][5],1,nMoedaRet,,3,,aTxMoedas[nMoedaRet][2]),MsDecimais(nMoedaRet))
				SEK->EK_VENCTO  := dDataBase
				SEK->EK_FORNECE := cFornece
				SEK->EK_LOJA    := cLoja
				SEK->EK_MOEDA	:= StrZero(nMoedaRet,TamSx3("EK_MOEDA")[1]) //"01"
				SEK->EK_ORDPAGO := cOrdPago
				SEK->EK_DTDIGIT := dDataBase
		   		SEK->EK_FORNEPG:= cFornece
	   			SEK->EK_LOJAPG:= cLoja
				If SEK->(FieldPos("EK_NATUREZ")) > 0
				   SEK->EK_NATUREZ:= cNatureza
				Endif
				F085AGrvTx()
				MsUnlock()

				aTitPags[1]	-=	aRets[_RETIVA][nX][5]
				If lA085aRet
					ExecBLock("A085ARET",.F.,.F.,"IRC")
				Endif
			EndIf
		Next
	Endif
ElseIf cPaisLoc=="ANG"
	If !lGan  
		nLimite:= Iif(ValType(aRets[_RETRIE])=="A",Len(aRets[_RETRIE]),0)
		For nX 	:= 1	To nLimite				                                 							
			If aRets[_RETRIE][nX][6] != 0
				cNroCert	:=	GetCert("RIE  ",cFornece+cLoja+"RIE")
				RecLock("SFE",.T.)
				FE_FILIAL	:=	xFilial("SFE")
				FE_NROCERT	:=	cNroCert
				FE_EMISSAO  :=	dDataBase
				FE_FORNECE  :=	cFornece
				FE_LOJA     :=	cLoja
				FE_TIPO     :=	"3"
				FE_ORDPAGO  :=	cOrdPago
				FE_PARCELA	:=	cParcela
				If lGerPA
					FE_NFISCAL 	:=	cOrdPago
					FE_SERIE	:=	"PA"
				Else
					FE_NFISCAL 	:=	aRets[_RETRIE][nX][1]
					FE_SERIE	:=	aRets[_RETRIE][nX][2]
				Endif
				FE_VALBASE	:=	aRets[_RETRIE][nX][3]
				FE_VALIMP	:=	aRets[_RETRIE][nX][4]
				FE_PORCRET	:=	aRets[_RETRIE][nX][5]
				FE_RETENC	:=	aRets[_RETRIE][nX][6]
				MsUnLock()

				RecLock("SEK",.T.)
				SEK->EK_FILIAL  := xFilial("SEK")
				SEK->EK_TIPODOC := "RG" //Retencion Generada
				SEK->EK_NUM     := cNroCert
				SEK->EK_TIPO    := "IE-"
				SEK->EK_EMISSAO	:= dDataBase
				SEK->EK_VLMOED1 := aRets[_RETRIE][nX][6]
				SEK->EK_VALOR   := Round(xMoeda(aRets[_RETRIE][nX][6],1,nMoedaRet,,3,,aTxMoedas[nMoedaRet][2]),MsDecimais(nMoedaRet))
				SEK->EK_SALDO   := Round(xMoeda(aRets[_RETRIE][nX][6],1,nMoedaRet,,3,,aTxMoedas[nMoedaRet][2]),MsDecimais(nMoedaRet))
				SEK->EK_VENCTO  := dDataBase
				SEK->EK_FORNECE := cFornece
				SEK->EK_LOJA    := cLoja
				SEK->EK_MOEDA	:= StrZero(nMoedaRet,TamSx3("EK_MOEDA")[1]) //"01"
				SEK->EK_ORDPAGO := cOrdPago
				SEK->EK_DTDIGIT := dDataBase
		   		SEK->EK_FORNEPG:= cFornece
	   			SEK->EK_LOJAPG:= cLoja
				If SEK->(FieldPos("EK_NATUREZ")) > 0
				   SEK->EK_NATUREZ:= cNatureza
				Endif
				F085AGrvTx()
				MsUnlock()

				aTitPags[1]	-=	aRets[_RETRIE][nX][6]
				If lA085aRet
					ExecBLock("A085ARET",.F.,.F.,"IVA")
				Endif
			EndIf
		Next
	Endif
ElseIf cPaisLoc=="PER"
		nC := 0   //controla a quebra de itens por comprovante
		aCert:= {}
		nLimite:= Iif(ValType(aRets[_RETIGV])=="A",Len(aRets[_RETIGV]),0)
		For nX 	:= 1	To nLimite				                                 									
			If aRets[_RETIGV][nX][4] <> 0
				IF nC == 0 .OR. nC > nItensc
					cNroCert	:=	GetCert("IGV   ",cFornece+cLoja+"IGV")
					aadd(aCert,{cNroCert,GETMV("MV_SERETEN"),"I"})
					nC := 1
				Else
				    nC := nC + 1
				ENDIF
				RecLock("SFE",.T.)
				FE_FILIAL	:=	xFilial("SFE")
				FE_NROCERT	:=	cNroCert
				FE_EMISSAO  :=	dDataBase
				FE_FORNECE  :=	cFornece
				FE_LOJA     :=	cLoja
				FE_TIPO     :=	"I"
				FE_ORDPAGO  :=	cOrdPago
				FE_PARCELA	:=	cParcela
				FE_SERIEC   :=	GETMV("MV_SERETEN")
				If cpaisLoc == "PER" .AND. ColumnPos("FE_SERIE2")
					FE_SERIE2	:=  GETMV("MV_CRSERIE")
				EndIf
				If lGerPA
					FE_NFISCAL 	:=	cOrdPago
				Else
					FE_NFISCAL 	:=	aRets[_RETIGV][nX][1]
					FE_SERIE	:=	aRets[_RETIGV][nX][2]
				Endif
				FE_VALBASE	:=	aRets[_RETIGV][nX][3]
				FE_VALIMP	:=	aRets[_RETIGV][nX][4]
				FE_PORCRET	:=	aRets[_RETIGV][nX][5]
				FE_RETENC	:=	aRets[_RETIGV][nX][6]
				FE_ALIQ     :=	aRets[_RETIGV][nX][9]
				FE_ESPECIE  :=	aRets[_RETIGV][nX][10]
				FE_ITEM     :=  nC
				MsUnLock()

				RecLock("SEK",.T.)
				SEK->EK_FILIAL  := xFilial("SEK")
				SEK->EK_TIPODOC := "RG" //Retencion Generada
				SEK->EK_NUM     := cNroCert
				SEK->EK_TIPO    := "IG-"
				SEK->EK_EMISSAO	:= dDataBase
				SEK->EK_VLMOED1 := aRets[_RETIGV][nX][6]
				SEK->EK_VALOR   := Round(xMoeda(aRets[_RETIGV][nX][6],1,nMoedaRet,,3,,aTxMoedas[nMoedaRet][2]),MsDecimais(nMoedaRet))
				SEK->EK_SALDO   := Round(xMoeda(aRets[_RETIGV][nX][6],1,nMoedaRet,,3,,aTxMoedas[nMoedaRet][2]),MsDecimais(nMoedaRet))
				SEK->EK_VENCTO  := dDataBase
				SEK->EK_FORNECE := cFornece
				SEK->EK_LOJA    := cLoja
				SEK->EK_MOEDA	:= StrZero(nMoedaRet,TamSx3("EK_MOEDA")[1]) //"01"
				SEK->EK_ORDPAGO := cOrdPago
				SEK->EK_DTDIGIT := dDataBase
		   		SEK->EK_FORNEPG:= cFornece
	   			SEK->EK_LOJAPG:= cLoja
				If SEK->(FieldPos("EK_NATUREZ")) > 0
				   SEK->EK_NATUREZ:= cNatureza
				Endif
				F085AGrvTx()
				MsUnlock()
				aTitPags[1]	-=	aRets[_RETIGV][nX][6]
				If lA085aRet
					ExecBLock("A085ARET",.F.,.F.,"IGV")
				Endif
			EndIf
		Next nX
		/* Retencao de IR */
		nLimite:= Iif(ValType(aRets[_RETIR])=="A",Len(aRets[_RETIR]),0)
		For nX 	:= 1	To nLimite				                                 											
			cNroCert	:=	GetCert("ISRPER",cFornece+cLoja+"ISRPER")
			aadd(aCert,{cNroCert,PadR(GETMV("MV_SERETEN"),TamSX3("FE_SERIEC")[1]),"R"})
			RecLock("SFE",.T.)
			FE_FILIAL	:=	xFilial("SFE")
			FE_NROCERT	:=	cNroCert
			FE_EMISSAO  :=	dDataBase
			FE_FORNECE  :=	cFornece
			FE_LOJA     :=	cLoja
			FE_TIPO     :=	"R"
			FE_ORDPAGO  :=	cOrdPago
			FE_PARCELA	:=	cParcela
			FE_SERIEC   :=	GETMV("MV_SERETEN")
			If lGerPA
				FE_NFISCAL 	:=	cOrdPago
			Else
				FE_NFISCAL 	:=	aRets[_RETIR][nX][1]
				FE_SERIE	:=	aRets[_RETIR][nX][2]
			Endif
			FE_VALBASE	:=	aRets[_RETIR][nX][3]
			FE_VALIMP	:=	aRets[_RETIR][nX][4]
			FE_PORCRET	:=	aRets[_RETIR][nX][5]
			FE_RETENC	:=	aRets[_RETIR][nX][6]
			FE_ALIQ     :=	aRets[_RETIR][nX][9]
			FE_ESPECIE  :=	aRets[_RETIR][nX][10]
			FE_ITEM     :=  nC
			MsUnLock()

			RecLock("SEK",.T.)
			SEK->EK_FILIAL  := xFilial("SEK")
			SEK->EK_TIPODOC := "RG" //Retencion Generada
			SEK->EK_NUM     := cNroCert
			SEK->EK_TIPO    := "IR-"
			SEK->EK_EMISSAO	:= dDataBase
			SEK->EK_VLMOED1 := aRets[_RETIR][nX][6]
			SEK->EK_VALOR   := Round(xMoeda(aRets[_RETIR][nX][6],1,nMoedaRet,,3,,aTxMoedas[nMoedaRet][2]),MsDecimais(nMoedaRet))
			SEK->EK_SALDO   := Round(xMoeda(aRets[_RETIR][nX][6],1,nMoedaRet,,3,,aTxMoedas[nMoedaRet][2]),MsDecimais(nMoedaRet))
			SEK->EK_VENCTO  := dDataBase
			SEK->EK_FORNECE := cFornece
			SEK->EK_LOJA    := cLoja
			SEK->EK_MOEDA	:= StrZero(nMoedaRet,TamSx3("EK_MOEDA")[1]) //"01"
			SEK->EK_ORDPAGO := cOrdPago
			SEK->EK_DTDIGIT := dDataBase
	   		SEK->EK_FORNEPG:= cFornece
   			SEK->EK_LOJAPG:= cLoja
   			If SEK->(FieldPos("EK_NATUREZ")) > 0
			   SEK->EK_NATUREZ:= cNatureza
			Endif
			F085AGrvTx()
			MsUnlock()
			aTitPags[1]	-=	aRets[_RETIR][nX][6]
			If lA085aRet
				ExecBLock("A085ARET",.F.,.F.,"ISR")
			Endif
		Next nX
ElseIf cPaisLoc=="VEN"
		nC := 0   //controla a quebra de itens por comprovante
		aCert:= {}
 		dbSelectArea("SFF")
		dbSetOrder(9)
		dbSeek(xFilial("SFF")+"IVA")
		nImporte:= SFF->FF_IMPORTE
		If Len(aRets[_RETIVA]) == 0
			If SFE->(dbSeek(xFilial("SFE")+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_NUM+SE2->E2_PREFIXO)) //Forncedor+Loja+NotaFisal+Serie
				While !SFE->(Eof()) .and. SFE->FE_FILIAL == xFilial("SFE") .and.;
				       SFE->FE_FORNECE == SE2->E2_FORNECE .and. SFE->FE_LOJA == SE2->E2_LOJA .and.;
				       SFE->FE_NFISCAL == SE2->E2_NUM .and. SFE->FE_SERIE == SE2->E2_PREFIXO
					RecLock("SFE",.F.)
					FE_ORDPAGO  :=	cOrdPago
       		        If Empty(SFE->FE_EMISSAO)
       	    	       	FE_EMISSAO := dDataBase
       	        	EndIf
					MsUnLock()
					SFE->(dbSkip())
				End
			EndIf
		EndIf 
		nLimite:= Iif(ValType(aRets[_RETIVA])=="A",Len(aRets[_RETIVA]),0)
		For nX 	:= 1	To nLimite				                                 													
			If aRets[_RETIVA][nX][3] >= nImporte

				IF nC == 0 .OR. nC > nItensc
					If Empty(cNroCert)
						cNroCert	:=	GetCert("IVA   ",cFornece+cLoja+"IVA")
						nC := 1
					EndIf
				Else
				    nC := nC + 1
				ENDIF
				SFE->(dbSetOrder(4))
				If ! SFE->(dbSeek(xFilial("SFE")+cFornece+cLoja+aRets[_RETIVA][nX][1]+aRets[_RETIVA][nX][2]+"I")) //Forncedor+Loja+NotaFisal+Serie
					RecLock("SFE",.T.)
					FE_FILIAL	:=	xFilial("SFE")
					FE_NROCERT	:=	StrZero(Year(dDataBase),4)+StrZero(Month(dDataBase),2)+cNroCert
					FE_EMISSAO  :=	dDataBase
					FE_FORNECE  :=	cFornece
					FE_LOJA     :=	cLoja
					FE_TIPO     :=	"I"
					FE_ORDPAGO  :=	cOrdPago
					FE_PARCELA	:=	cParcela
					FE_SERIEC   :=	" "
					If lGerPA
						FE_NFISCAL 	:=	cOrdPago
					Else
						FE_NFISCAL 	:=	aRets[_RETIVA][nX][1]
						FE_SERIE	:=	aRets[_RETIVA][nX][2]
					Endif
					FE_VALBASE	:=	aRets[_RETIVA][nX][3]
					FE_VALIMP	:=	aRets[_RETIVA][nX][4]
					FE_PORCRET	:=	aRets[_RETIVA][nX][5]
					FE_RETENC	:=	aRets[_RETIVA][nX][6]
					FE_ALIQ     :=	aRets[_RETIVA][nX][9]
					FE_ESPECIE  :=	aRets[_RETIVA][nX][10]
					FE_CONCEPT  :=  aRets[_RETIVA][nX][14]
					FE_ITEM     :=  nC
					MsUnLock()
				Else
					RecLock("SFE",.F.)
					FE_ORDPAGO  :=	cOrdPago
					FE_VALBASE	+=	aRets[_RETIVA][nX][3]
					FE_VALIMP	+=	aRets[_RETIVA][nX][4]
					FE_RETENC	+=	aRets[_RETIVA][nX][6]
					If Empty(SFE->FE_CONCEPT)
						FE_CONCEPT := aRets[_RETIVA][nX][14]
					EndIf
                    If Empty(SFE->FE_EMISSAO)
                    	FE_EMISSAO := dDataBase
                    EndIf
					MsUnLock()
	            EndIf

				RecLock("SEK",.T.)
				SEK->EK_FILIAL  := xFilial("SEK")
				SEK->EK_TIPODOC := "RG" //Retencion Generada
				SEK->EK_NUM     := cNroCert
				SEK->EK_TIPO    := "IV-"
				SEK->EK_EMISSAO	:= dDataBase
				SEK->EK_VLMOED1 := aRets[_RETIVA][nX][6]
				SEK->EK_VALOR   := Round(xMoeda(aRets[_RETIVA][nX][6],1,nMoedaRet,,3,,aTxMoedas[nMoedaRet][2]),MsDecimais(nMoedaRet))
				SEK->EK_SALDO   := Round(xMoeda(aRets[_RETIVA][nX][6],1,nMoedaRet,,3,,aTxMoedas[nMoedaRet][2]),MsDecimais(nMoedaRet))
				SEK->EK_VENCTO  := dDataBase
				SEK->EK_FORNECE := cFornece
				SEK->EK_LOJA    := cLoja
				SEK->EK_MOEDA	:= StrZero(nMoedaRet,TamSx3("EK_MOEDA")[1]) //"01"
				SEK->EK_ORDPAGO := cOrdPago
				SEK->EK_DTDIGIT := dDataBase
		   		SEK->EK_FORNEPG:= cFornece
	   			SEK->EK_LOJAPG:= cLoja
				If SEK->(FieldPos("EK_NATUREZ")) > 0
				   SEK->EK_NATUREZ:= cNatureza
				Endif
				F085AGrvTx()
				MsUnlock()
				aTitPags[1]	-=	aRets[_RETIVA][nX][6]
				If lA085aRet
					ExecBLock("A085ARET",.F.,.F.,"IVA")
				Endif
			EndIf
		Next nX
		/* Retencao de IR */
		If Len(aRets[_RETIR]) == 0
			If SFE->(dbSeek(xFilial("SFE")+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_NUM+SE2->E2_PREFIXO)) //Forncedor+Loja+NotaFisal+Serie
				While !SFE->(Eof()) .and. SFE->FE_FILIAL == xFilial("SFE") .and.;
				       SFE->FE_FORNECE == SE2->E2_FORNECE .and. SFE->FE_LOJA == SE2->E2_LOJA .and.;
				       SFE->FE_NFISCAL == SE2->E2_NUM .and. SFE->FE_SERIE == SE2->E2_PREFIXO
					RecLock("SFE",.F.)
					FE_ORDPAGO  :=	cOrdPago
        	        If Empty(SFE->FE_EMISSAO)
            	       	FE_EMISSAO := dDataBase
                	EndIf
					MsUnLock()
					SFE->(dbSkip())
				End
			EndIf
		EndIf
		nC := 0                                                                 
		nLimite:= Iif(ValType(aRets[_RETIR])=="A",Len(aRets[_RETIR]),0)
		For nX 	:= 1	To nLimite				                                 															
			IF nC == 0 .OR. nC > nItensc
				If Empty(cNroCert)
					cNroCert	:=	GetCert("ISRVEN",cFornece+cLoja+"ISRVEN")
					nC := 1
				EndIf
			Else
			    nC := nC + 1
			ENDIF
			SFE->(dbSetOrder(4))
			If ! SFE->(dbSeek(xFilial("SFE")+cFornece+cLoja+aRets[_RETIR][nX][1]+aRets[_RETIR][nX][2]+"R"+aRets[_RETIR][nX][14])) //Fornecedor+Loja+NotaFiscal+Serie
				RecLock("SFE",.T.)
				FE_FILIAL	:=	xFilial("SFE")
				FE_NROCERT	:=	StrZero(Year(dDataBase),4)+StrZero(Month(dDataBase),2)+cNroCert
				FE_EMISSAO  :=	dDataBase
				FE_FORNECE  :=	cFornece
				FE_LOJA     :=	cLoja
				FE_TIPO     :=	"R"
				FE_ORDPAGO  :=	cOrdPago
				FE_PARCELA	:=	cParcela
	   			FE_SERIEC   :=	" "
				If lGerPA
					FE_NFISCAL 	:=	cOrdPago
				Else
					FE_NFISCAL 	:=	aRets[_RETIR][nX][1]
					FE_SERIE	:=	aRets[_RETIR][nX][2]
				Endif
				FE_VALBASE	:=	aRets[_RETIR][nX][3]
				FE_VALIMP	:=	aRets[_RETIR][nX][4]
				FE_PORCRET	:=	aRets[_RETIR][nX][5]
				FE_RETENC	:=	aRets[_RETIR][nX][6]
				FE_ALIQ     :=	aRets[_RETIR][nX][9]
				FE_ESPECIE  :=	aRets[_RETIR][nX][10]
				FE_CONCEPT  :=  aRets[_RETIR][nX][14]
				FE_DEDUC    :=  aRets[_RETIR][nX][15]
				FE_ITEM     :=  nC
				MsUnLock()
			Else
				RecLock("SFE",.F.)
				FE_ORDPAGO  :=	cOrdPago
				If Empty(SFE->FE_CONCEPT)
					FE_CONCEPT := aRets[_RETIR][nX][14]
				EndIf
				If Empty(SFE->FE_EMISSAO)
					FE_EMISSAO := dDataBase
				EndIf
				MsUnLock()
			EndIf

			RecLock("SEK",.T.)
			SEK->EK_FILIAL  := xFilial("SEK")
			SEK->EK_TIPODOC := "RG" //Retencion Generada
			SEK->EK_NUM     := cNroCert
			SEK->EK_TIPO    := "IR-"
			SEK->EK_EMISSAO	:= dDataBase
			SEK->EK_VLMOED1 := aRets[_RETIR][nX][6]
			SEK->EK_VALOR   += Round(xMoeda(aRets[_RETIR][nX][6],1,nMoedaRet,,3,,aTxMoedas[nMoedaRet][2]),MsDecimais(nMoedaRet))
			SEK->EK_SALDO   += Round(xMoeda(aRets[_RETIR][nX][6],1,nMoedaRet,,3,,aTxMoedas[nMoedaRet][2]),MsDecimais(nMoedaRet))
			SEK->EK_VENCTO  := dDataBase
			SEK->EK_FORNECE := cFornece
			SEK->EK_LOJA    := cLoja
			SEK->EK_MOEDA	:= StrZero(nMoedaRet,TamSx3("EK_MOEDA")[1]) //"01"
			SEK->EK_ORDPAGO := cOrdPago
			SEK->EK_DTDIGIT := dDataBase
	   		SEK->EK_FORNEPG:= cFornece
   			SEK->EK_LOJAPG:= cLoja
				If SEK->(FieldPos("EK_NATUREZ")) > 0
				   SEK->EK_NATUREZ:= cNatureza
				Endif
			F085AGrvTx()
			MsUnlock()
			aTitPags[1]	-=	aRets[_RETIR][nX][6]
			If lA085aRet
				ExecBLock("A085ARET",.F.,.F.,"ISR")
			Endif
		Next nX
ElseIf cPaisLoc == "PAR"
	For nX	:= 1	To Len(aRets[_RETIVA]) 	
		If(aRets[_RETIVA][nX][3] != 0) .or. (aRets[_RETIVA][nX][6] = 0 .and. aRets[_TIPO]= "NCP" )
			
				cChave1	:=	""
				lNaoAchou:= .T.
				aArea:=GetArea()
				aAreaSFE:=SFE->(GetArea())
				DbSelectArea("SFE")
				DbSetOrder(2)
				If SFE->(DBSEEK(xFilial("SFE")+cOrdPago))
					While(xFilial("SFE")+cOrdPago== FE_FILIAL+FE_ORDPAGO) .And. lNaoAchou .and. !SFE->(EOF())      
						If FE_FORNECE ==cFornece  .And.  FE_PARCELA	 ==	cParcela  .And.  FE_NFISCAL ==	aRets[_RETIVA][nX][1]  .And.  FE_SERIE	==	aRets[_RETIVA][nX][2]
					      	If FE_VALIMP>0
					      		cNroCert:= FE_NROCERT
								lNaoAchou:=.F.           
							EndIf
						EndIf
						DbSkip()
					EndDo			
				End
				RestArea(aArea)
				SFE->(Restarea(aAreaSFE))
				
				If lNaoAchou
					cNroCert	:=	GetCert("IVA  ",cFornece+cLoja+"IVA",.F.) 
				EndIf
				
		    nPos:=AScan(aCert,{|x| x[1]==Padr(cNroCert,TamSx3("FE_NROCERT")[1],"") .And. x[2]=="I"})
			If nPos = 0
				AAdd(aCert,{Padr(cNroCert,TamSx3("FE_NROCERT")[1],""),"I",cOrdPago})
			EndIf	
			RecLock("SFE",.T.)
			FE_FILIAL	:=	xFilial("SFE")
			FE_NROCERT	:=	Iif (aRets[_RETIVA][nX][4]<> 0,cNroCert,"NORET")
			FE_EMISSAO  :=	dDataBase
			FE_FORNECE  :=	cFornece
			FE_LOJA     :=	cLoja
			FE_TIPO     :=	"I"
			FE_ORDPAGO  :=	cOrdPago
			FE_PARCELA	 :=	cParcela
			FE_NFISCAL :=	aRets[_RETIVA][nX][1] 
			FE_SERIE	:=	aRets[_RETIVA][nX][2]
			FE_VALBASE	:=	aRets[_RETIVA][nX][3]
			FE_VALIMP	:=	aRets[_RETIVA][nX][4]				
			FE_PORCRET	:=	aRets[_RETIVA][nX][5]				
			FE_RETENC	:=	aRets[_RETIVA][nX][4]									
			If  Len(aRets[_RETIVA][nX]) >= 10
				FE_ALIQ   	:=	aRets[_RETIVA][nX][10]
			EndIf	
			
			MsUnLock()

			RecLock("SEK",.T.)
			SEK->EK_FILIAL  := xFilial("SEK")
			SEK->EK_TIPODOC := "RG" //Retencion Generada
			SEK->EK_NUM     := cNroCert
			SEK->EK_TIPO    := "IV-"
			SEK->EK_EMISSAO	:= dDataBase
			SEK->EK_VLMOED1 := aRets[_RETIVA][nX][4]				
			SEK->EK_VALOR   := Round(xMoeda(aRets[_RETIVA][nX][4],1,nMoedaRet,,3,,aTxMoedas[nMoedaRet][2]),MsDecimais(nMoedaRet))
			SEK->EK_SALDO   := Round(xMoeda(aRets[_RETIVA][nX][4],1,nMoedaRet,,3,,aTxMoedas[nMoedaRet][2]),MsDecimais(nMoedaRet))								
			SEK->EK_VENCTO  := dDataBase
			SEK->EK_FORNECE := cFornece
			SEK->EK_LOJA    := cLoja
			SEK->EK_MOEDA	:= StrZero(nMoedaRet,TamSx3("EK_MOEDA")[1]) //"01"
			SEK->EK_ORDPAGO := cOrdPago
			SEK->EK_DTDIGIT := dDataBase
	   		SEK->EK_FORNEPG:= cFornece
   			SEK->EK_LOJAPG:= cLoja
			If SEK->(FieldPos("EK_NATUREZ")) > 0
			   SEK->EK_NATUREZ:= cNatureza
			Endif   	   			
			F085AGrvTx()
			MsUnlock() 





			aTitPags[1]	-=	aRets[_RETIVA][nX][6]
			If lA085aRet
				ExecBLock("A085ARET",.F.,.F.,"IVA")
			Endif                                              
		EndIf
	Next
	
	For nX	:= 1 To Len(aRets[_RETIR]) 	
		If aRets[_RETIR][nX][6] != 0
			cChave1	:=	""
			lNaoAchou:= .T.
			aArea:=GetArea()
			aAreaSFE:=SFE->(GetArea())
			DbSelectArea("SFE")
			DbSetOrder(2)
			If SFE->(DBSEEK(xFilial("SFE")+cOrdPago))
				While(xFilial("SFE")+cOrdPago== FE_FILIAL+FE_ORDPAGO) .And. lNaoAchou .and. !SFE->(EOF())      
					If FE_FORNECE ==cFornece  .And.  FE_PARCELA	 ==	cParcela  .And.  FE_NFISCAL ==	aRets[_RETIR][nX][1]  .And.  FE_SERIE	==	aRets[_RETIR][nX][2]
				      	If FE_VALIMP>0
				      		cNroCert:= FE_NROCERT
							lNaoAchou:=.F. 
						EndIf
					EndIf
					DbSkip()
				EndDo			
			End
			RestArea(aArea)
			SFE->(Restarea(aAreaSFE))
						
			If lNaoAchou
				cNroCert	:=	GetCert("IR  ",cFornece+cLoja+"IR",.F.)
			EndIf
		    nPos:=AScan(aCert,{|x| x[1]==Padr(cNroCert,TamSx3("FE_NROCERT")[1],"") .And. x[2]=="R"})
			If nPos = 0
				AAdd(aCert,{Padr(cNroCert,TamSx3("FE_NROCERT")[1],""),"R",cOrdPago})
			EndIf	
			RecLock("SFE",.T.)
			FE_FILIAL	:=	xFilial("SFE")
			FE_NROCERT	:=	cNroCert
			FE_EMISSAO  :=	dDataBase
			FE_FORNECE  :=	cFornece
			FE_LOJA     :=	cLoja
			FE_TIPO     :=	"R"
			FE_ORDPAGO  :=	cOrdPago
			FE_PARCELA	:=	cParcela
			FE_NFISCAL 	:=	aRets[_RETIR][nX][1] 
			FE_SERIE	:=	aRets[_RETIR][nX][2]
			FE_VALBASE	:=	aRets[_RETIR][nX][3]
			FE_VALIMP	:=	aRets[_RETIR][nX][4]
			FE_PORCRET	:=	aRets[_RETIR][nX][5]
			FE_RETENC	:=	aRets[_RETIR][nX][6]
			FE_ALIQ		:=	aRets[_RETIR][nX][9]
			MsUnLock()
	
			RecLock("SEK",.T.)
			SEK->EK_FILIAL  := xFilial("SEK")
			SEK->EK_TIPODOC := "RG" //Retencion Generada
			SEK->EK_NUM     := cNroCert
			SEK->EK_TIPO    := "IR-"
			SEK->EK_EMISSAO	:= dDataBase
			SEK->EK_VLMOED1 := aRets[_RETIR][nX][6]
			SEK->EK_VALOR   := aRets[_RETIR][nX][6]
			SEK->EK_SALDO   := aRets[_RETIR][nX][6]
			SEK->EK_VENCTO  := dDataBase
			SEK->EK_FORNECE := cFornece
			SEK->EK_LOJA    := cLoja
			SEK->EK_MOEDA	:= StrZero(1,TamSx3("EK_MOEDA")[1]) //"01"
			SEK->EK_ORDPAGO := cOrdPago
			SEK->EK_DTDIGIT := dDataBase
			If FieldPos("EK_FORNEPG")>0
		   		SEK->EK_FORNEPG:= cFornece
			Endif
			If FieldPos("EK_LOJAPG")>0
	   			SEK->EK_LOJAPG:= cLoja
			Endif
			If SEK->(FieldPos("EK_NATUREZ"))>0
			   SEK->EK_NATUREZ:= cNatureza
			Endif 
			If SEK->(FieldPos("EK_NROCERT")) > 0
			   SEK->EK_NROCERT:= cNroCert
			Endif   				
			F085AGrvTx()
			MsUnlock()
			aTitPags[1]	-=	SEK->EK_VALOR
			If lA085aRet
				ExecBLock("A085ARET",.F.,.F.,"IRI")
			Endif
		EndIf
	Next
EndIf

Return aCert

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GetCert    �Autor  �Microsiga           � Data �    /  /   ���
�������������������������������������������������������������������������͹��
���Desc.     �Pega os numeros de certificados de retencao                 ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function GetCert(cImposto,cChave,lReUsa)
Local cNroCert	:=	""
Local nPosCert	:=	0
Local nTamCpoCert := TamSx3("FE_NROCERT")[1]
Local aRet		:= {}
Local aParam	:= {}
Local aArea		:= GetArea()

DEFAULT lReUsa	:=	.T.

If lReUsa
	nPosCert :=	Ascan(aCerts,{|x| X[1] == cChave } )
Endif
If nPosCert > 0
	Return  aCerts[nPosCert][2]
Endif

DO CASE
	CASE cPaisLoc=="PER"
		If AllTrim(cImposto) $ "IGV"
			DbSelectArea("SX5")
			IF !MsSeek(xFilial("SX5")+"99"+cImposto,.F.) //Caso n�o encontre o registro 'padr�o', cria um registro 'mestre'
				RecLock("SX5", .T.)
					SX5->X5_TABELA 	:= '99'
					SX5->X5_FILIAL 	:= xFilial("SX5")
					SX5->X5_CHAVE  	:= cImposto
					SX5->X5_DESCRI 	:= '00000001'
					SX5->X5_DESCSPA 	:= '00000001'
					SX5->X5_DESCENG 	:= '00000001'
					cNroCert       	:= '00000001'
				MsUnLock()

				RecLock("SX5", .T.)
					SX5->X5_TABELA 	:= '99'
					SX5->X5_FILIAL 	:= cFilAnt
					SX5->X5_CHAVE  	:= cImposto
					SX5->X5_DESCRI 	:= '00000001'
					SX5->X5_DESCSPA 	:= '00000001'
					SX5->X5_DESCENG 	:= '00000001'
				MsUnLock()
			Else
				If !MsSeek(cFilAnt+"99"+cImposto,.F.) //Conforme orienta��o da SUNAT, crio um registro de numera��o para cada filial
					RecLock("SX5", .T.)                //dessa forma, cada filial pode gerar o recibo com sequencial pr�prio
						SX5->X5_TABELA 	:= '99'
						SX5->X5_FILIAL 	:= cFilAnt
						SX5->X5_CHAVE  	:= cImposto
						SX5->X5_DESCRI 	:= '00000001'
						SX5->X5_DESCSPA 	:= '00000001'
						SX5->X5_DESCENG 	:= '00000001'
						cNroCert       	:= '00000001'
					MsUnLock()
				Else
					cNroCert := StrZero(Val(X5DESCRI())+1,8)
					If mv_par14 == 1
						aAdd(aParam,{1,STR0253,cNroCert,,,,,60,.T.})

						If Parambox(aParam,STR0252,@aRet,,,.T.,,,,,.F.,.F.)
							cNroCert := aRet[1]
						EndIf
					EndIf
					Reclock("SX5",.F.)
					SX5->X5_DESCRI  := StrZero(Val(cNroCert),8)
					SX5->X5_DESCSPA := StrZero(Val(cNroCert),8)
					SX5->X5_DESCENG := StrZero(Val(cNroCert),8)
					MsUnLock()
				EndIf
			EndIf
		Else
			DbSelectArea("SX5")
			If !MsSeek(xFilial("SX5")+"99"+cImposto,.F.)
				RecLock("SX5", .T.)
					SX5->X5_TABELA 	:= '99'
					SX5->X5_FILIAL 	:= xFilial("SX5")
					SX5->X5_CHAVE  	:= cImposto
					SX5->X5_DESCRI 	:= '00000001'
					SX5->X5_DESCSPA 	:= '00000001'
					SX5->X5_DESCENG 	:= '00000001'
					cNroCert       	:= '00000001'
				MsUnLock()
			Else
				cNroCert := StrZero(Val(X5DESCRI())+1,8)
				Reclock("SX5",.F.)
				SX5->X5_DESCRI  := StrZero(Val(cNroCert),8)
				SX5->X5_DESCSPA := StrZero(Val(cNroCert),8)
				SX5->X5_DESCENG := StrZero(Val(cNroCert),8)
				MsUnLock()
			EndIf
		EndIf
	CASE cPaisLoc=="PAR"	
		DbSelectArea("SX5")
		IF !MsSeek(xFilial("SX5")+"99"+cImposto,.F.)
			RecLock("SX5", .T.)
				SX5->X5_TABELA	:= '99'
				SX5->X5_FILIAL	:= xFilial("SX5")
				SX5->X5_CHAVE	:= cImposto
				SX5->X5_DESCRI	:= StrZero(1,nTamCpoCert)
				SX5->X5_DESCSPA	:= StrZero(1,nTamCpoCert)
				SX5->X5_DESCENG	:= StrZero(1,nTamCpoCert)
				cNroCert		:= StrZero(1,nTamCpoCert)
			MsUnLock()
		Else
			cNroCert := StrZero(Val(X5DESCRI())+1,TamSX3( "FE_NROCERT" )[1])
			Reclock("SX5",.F.)
			SX5->X5_DESCRI	:= StrZero(Val(cNroCert),TamSX3( "FE_NROCERT" )[1])
			SX5->X5_DESCSPA	:= StrZero(Val(cNroCert),TamSX3( "FE_NROCERT" )[1])
			SX5->X5_DESCENG	:= StrZero(Val(cNroCert),TamSX3( "FE_NROCERT" )[1])
			MsUnLock()
		EndIf
	OTHERWISE
		DbSelectArea("SX5")
		IF ! MsSeek(xFilial("SX5")+"99"+cImposto,.F.)
			RecLock("SX5", .T.)
			SX5->X5_TABELA 	:= '99'
			SX5->X5_FILIAL 	:= xFilial("SX5")
			SX5->X5_CHAVE  	:= cImposto
			SX5->X5_DESCRI 	:= StrZero(1,nTamCpoCert)
			SX5->X5_DESCSPA := StrZero(1,nTamCpoCert)
			SX5->X5_DESCENG := StrZero(1,nTamCpoCert)
			cNroCert       	:= StrZero(1,nTamCpoCert)
			MsUnLock()
		Else
			cNroCert := StrZero(Val(X5DESCRI())+1,nTamCpoCert)
			Reclock("SX5",.F.)
			SX5->X5_DESCRI 	:= StrZero(Val(cNroCert),nTamCpoCert)
			SX5->X5_DESCSPA := StrZero(Val(cNroCert),nTamCpoCert)
			SX5->X5_DESCENG := StrZero(Val(cNroCert),nTamCpoCert)
			MsUnLock()
		EndIf
ENDCASE

AAdd(aCerts,{cChave,cNroCert})

RestArea(aArea)
Return cNroCert

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �a085aZeraRet�Autor  �Bruno Sobieski      � Data �  07/29/01 ���
�������������������������������������������������������������������������͹��
���Desc.     �Zera os valores de retencoes cuando � mudado algum dado que ���
���          �determina que as retencoes devem ser recalculadas           ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A (Argentina)                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A085AZeraRet(nRetIva,nRetGan,nRetIB,nRetIric,nRetSUS,nRetSLI,;
oRetIVA,oRetGan,oRetIB,oRetIric,oRetSUSS,oRetSLI,nRetIr,oRetIr,nRetIRC,oRetIRC,oRetISI,nRetISI,oRetIGV,nRetIR4)
nRetIva		:=	0
nRetIB		:=	0
nRetGan		:=	0
nRetIric    :=  0
nRetIrc    	:=  0
nRetIr    	:=  0
nRetSUSS    :=  0
nRetSLI 	:=  0
If lModi .and. cPaisLoc  == "URU"
nValLiq		:= nValBrut - ((nValBrut * nPorDesc) /100)
Else
nValLiq		:=	nValBrut - nValDesc
EndIf
If cPaisLoc=="ARG"
	oRetIva:Refresh()
	oRetIB:Refresh()
	oRetGan:Refresh()
	oRetSUSS:Refresh()
	oRetSLI:Refresh()
	oRetISI:Refresh()
Endif
If cPaisLoc $ "URU|BOL"
	oRetIric:Refresh()
	oRetIr:Refresh()
Endif
If cPaisLoc == "PTG"
	oRetIrc:Refresh()
	oRetIVA:Refresh()
Endif

If cPaisLoc == "PER"
	nRetIR4 := 0
Endif

oValBrut:Refresh()
oValLiq:Refresh()
lRetenc	:=	.F.

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Program   �A085AORDPG�Author �Microsiga           � Date �  08/02/01   ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualiza os contadores de ordem de pago e a marca de selecao���
�������������������������������������������������������������������������͹��
���Use       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function a085aOrdPg()

aPagos[oLBx:nAt,H_OK] := aPagos[oLBx:nAt,H_OK] * -1

nNumOrdens:=nNumOrdens+aPagos[oLBx:nAt,H_OK]
nValOrdens:=nValOrdens+(aPagos[oLBx:nAt,H_TOTALVL]*aPagos[oLBx:nAt,H_OK])
If aPagos[oLBx:nAt,H_VALORIG] ==0
	Alert(STR0257)
	aPagos[oLBx:nAt,H_OK] := -1	
EndIf

oNumOrdens:Refresh()
oValOrdens:Refresh()

SysRefresh()

Return

//----------------------------------------------------------
Static Function EdMoeda()

oBMoeda:ColPos := 1
lEditCell(@aLinMoed,oBMoeda,aLinMoed[oBMoeda:nAT][3],2)
aLinMoed[oBMoeda:nAT][2] := obMoeda:Aarray[oBMoeda:nAT][2]

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F085MRKB  �Autor  �Sergio S. Fuzinaka  �Fecha �  20/01/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Validacion de proveedores Observados por DGI - MarkBrowse   ���
�������������������������������������������������������������������������͹��
���Uso       �FINA085A()                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function F085MRKB(lAll)
Local aArea     := GetArea()
Local lRet      := .T.
Local lExistCpo := (SA2->(FieldPos("A2_IVRVCOB")) > 0 .And. SA2->(FieldPos("A2_IVPCCOB")) > 0)

// Executa PE para validacao da MarkBrowse...
If ExistBlock("A085MRKB")
	lRet := ExecBLock("A085MRKB",.F.,.F.,lAll)
Endif

If lExistCpo
	If lRet
		dbSelectArea( "SA2" )
		dbSetOrder ( 1 )
		If !Empty(xFilial("SA2")) .And. lMsFil .And. xFilial("SF1") == xFilial("SA2")
			dbSeek( SE2->E2_MSFIL + SE2->E2_FORNECE + SE2->E2_LOJA, .F. )
		Else
			dbSeek( xFilial( "SA2" ) + SE2->E2_FORNECE + SE2->E2_LOJA, .F. )
		Endif
		If !SA2->( Found() )
			MsgStop( OemToAnsi(STR0146) )
			lRet := .F.
		Else
			If lRet .And. !Empty(SA2->A2_IVRVCOB) .And. SA2->A2_IVRVCOB < dDataBase
				MsgAlert( OemToAnsi(STR0146) + CRLF + CRLF + ;
				OemToAnsi(STR0147) )
				lRet := .F.
			EndIf
		EndIf
	Endif

Endif

If lRet .and. !lAll
	If !Empty(xFilial("SA2")) .And. lMsFil .And. xFilial("SF1") == xFilial("SA2")
		lRet := dbSeek( SE2->E2_MSFIL + SE2->E2_FORNECE + SE2->E2_LOJA, .F. )
	Else
		lret:=ExistCpo("SA2",SE2->E2_FORNECE + SE2->E2_LOJA)
	Endif
ElseIf lRet .And. FieldPos("A2_MSBLQL")>0
	lRet:= Iif(SA2->A2_MSBLQL == "1",.F.,.T.)
EndIf
RestArea( aArea )

Return( lRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F085VFOR  �Autor  �Sergio S. Fuzinaka  �Fecha �  20/01/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Validacion de proveedores Observados por DGI - MsGet        ���
�������������������������������������������������������������������������͹��
���Uso       �FINA085A()                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function F085VFOR(cFornece,cLoja)

Local aArea     := GetArea()
Local lRet      := .T.
Local lExistCpo := (SA2->(FieldPos("A2_IVRVCOB")) > 0 .And. SA2->(FieldPos("A2_IVPCCOB")) > 0)

// Executa PE validacao do MsGet
If ExistBlock("A085VFOR")
	lRet := ExecBlock("A085VFOR",.F.,.F.,{cFornece,cLoja})
Endif

If lExistCpo

	If lRet
		dbSelectArea( "SA2" )
		dbSetOrder ( 1 )
		dbSeek( xFilial( "SA2" ) + cFornece + cLoja, .F. )
		If !SA2->( Found() )
			MsgStop( OemToAnsi(STR0147) )
			lRet := .F.
		Else
			If SA2->A2_PORIVA < 100.00 .And. (Empty(SA2->A2_IVPCCOB) .Or. Dtos(SA2->A2_IVPCCOB) < Dtos(dDataBase))
				MsgAlert( OemToAnsi(STR0155) + CRLF + CRLF + ; //"La fecha de validad para la reducci�n del porcentaje de la retenci�n del IVA del proveedor ya se ha vencido. "
				OemToAnsi(STR0147) )
				lRet := .F.
			EndIf

			If lRet .And. !Empty(SA2->A2_IVRVCOB) .And. SA2->A2_IVRVCOB < dDataBase
				MsgAlert( OemToAnsi(STR0146) + CRLF + CRLF + ;
				OemToAnsi(STR0147) )
				lRet := .F.
			EndIf
		EndIf
	Endif

Endif

RestArea( aArea )

Return( lRet )

/*
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � CalcRetIRIC� Autor � Julio Cesar         � Data � 22.01.03 ���
��+----------+------------------------------------------------------------���
���Descri��o � Calcular e Gerar Retencoes de IRIC.                        ���
��+----------+------------------------------------------------------------���
���Uso       � FINA085A                                                   ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
*/
Static Function CalcRetIRIC(cAgente,nSigno,nSaldo)
Local nValBrut := 0
Local aSFEIRIC := {}
Local lCalcImp:=.T.
Local lCalcula	:=.F.
Local aArea:=GetArea()    
Local nTotIR := 0
Local nValIR := 0 
Local nTotBase := 0
Local nBaseIR := 0
Local nAliqIR := 0
Local nI
DEFAULT nSigno := 1

If ExistBlock("F0851IMP")
	lCalcImp:=ExecBlock("F0851IMP",.F.,.F.,{"IRIC"})
EndIf
If cPaisLoc == "PAR"
	aAreaSE2:=GetArea()
	dbSelectArea("SF1")
	dbSetOrder(1)
	dbSeek(xFilial("SF1")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA)
	 aArea:=GetArea()
	dbSelectArea("SD1")
	SD1->(DbSetOrder(1))
	SD1->(DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
	Do while xFilial("SD1")==SD1->D1_FILIAL.And.SF1->F1_DOC==SD1->D1_DOC.AND.;
	SF1->F1_SERIE==SD1->D1_SERIE.AND.SF1->F1_FORNECE==SD1->D1_FORNECE;
	.AND.SF1->F1_LOJA==SD1->D1_LOJA.AND.!SD1->(EOF())
		aImpInf := TesImpInf(SD1->D1_TES)   
		For nI := 1 To Len(aImpInf) 
			If "RIR"$Trim(aImpInf[nI][01]) .Or. "R15"$Trim(aImpInf[nI][01])			 
				nValIR:=SD1->(FieldGet(FieldPos(aImpInf[nI][02]))) 
				nBaseIR:=SD1->(FieldGet(FieldPos(aImpInf[nI][07]))) 
				nAliqIR := SD1->(FieldGet(FieldPos(aImpInf[nI][10]))) 
				nTotIR += nValIR                               
				nTotBase += nBaseIR 
			Endif	
		Next                                   
	 SD1->(DbSkip())	
	Enddo		

	nProp := Round(xMoeda(nSaldo,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,5)/xMoeda(se2->e2_valor,SE2->E2_MOEDA,1,,5),3)
	nTotBase :=	nTotBase * nProp
	nTotImpIR := nTotIR * nProp
	RestArea(aArea)
	
	If AllTrim(SF1->F1_ESPECIE)==Alltrim(SE2->E2_TIPO).And.;
				xFilial("SF1")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA==;
				SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA   
	
				AAdd(aSFEIR,array(9))
				aSFEIR[Len(aSFEIR)][1] := SF1->F1_DOC         		//FE_NFISCAL
				aSFEIR[Len(aSFEIR)][2] := SF1->F1_SERIE       		//FE_SERIE
				aSFEIR[Len(aSFEIR)][3] := Round(xMoeda(nTotBase,SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1))* nSigno	//FE_VALBASE
				aSFEIR[Len(aSFEIR)][4] := Round(xMoeda(nTotImpIR,SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1))* nSigno	//FE_VALIMP
				aSFEIR[Len(aSFEIR)][5] := SA2->A2_PORIVA
				aSFEIR[Len(aSFEIR)][6] := aSFEIR[Len(aSFEIR)][4]
				aSFEIR[Len(aSFEIR)][7] := SE2->E2_VALOR
				aSFEIR[Len(aSFEIR)][8] := SE2->E2_EMISSAO   
				aSFEIR[Len(aSFEIR)][9] := nAliqIR
	EndIf
	RestArea(aAreaSE2)	
//+---------------------------------------------------------------------+
//� Obter Impostos somente qdo a Empresa Usuario for Agente de Reten��o.�
//+---------------------------------------------------------------------+
ElseIf Subs(cAgente,1,1) == "S" .And. SA2->(FieldPos("A2_RETIRIC")) > 0 .And. SA2->(FieldPos("A2_PORIRIC")) > 0 .And. lCalcImp
	SA2->( dbSetOrder(1) )
	If !Empty(xFilial("SA2")) .And. lMsFil .And. xFilial("SF1") == xFilial("SA2")
		SA2->( dbSeek(SE2->E2_MSFIL+SE2->E2_FORNECE+SE2->E2_LOJA) )
	Else
		SA2->( dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA) )
	Endif

	//���������������������������������������������������������������������Ŀ
	//� Verifica se o fornecedor retem IRIC e se e estrangeiro              �
	//�����������������������������������������������������������������������
	If SA2->A2_RETIRIC == "1" .And. SA2->A2_TIPO == "3"
		//����������������������������������������������������������������Ŀ
		//� Calcula a retencao.                                            �
		//������������������������������������������������������������������
		nValBrut := Round(xMoeda(nSaldo,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,5,aTxMoedas[Max(SE2->E2_MOEDA,1)][2]),MsDecimais(1))

		AAdd(aSFEIRIC,array(8))
		aSFEIRIC[Len(aSFEIRIC)][1] := SE2->E2_NUM      //FE_NFISCAL
		aSFEIRIC[Len(aSFEIRIC)][2] := SE2->E2_PREFIXO  //FE_SERIE
		aSFEIRIC[Len(aSFEIRIC)][3] := nValBrut*nSigno	//FE_VALBASE
		aSFEIRIC[Len(aSFEIRIC)][4] := nValBrut*nSigno  //FE_VALIMP
		aSFEIRIC[Len(aSFEIRIC)][5] := SA2->A2_PORIRIC  //FE_PORCRET
		aSFEIRIC[Len(aSFEIRIC)][6] := (aSFEIRIC[Len(aSFEIRIC)][4]*(SA2->A2_PORIRIC/100))

		//����������������������������������������������������������������Ŀ
		//� Generar Titulo de Impuesto no Contas a Pagar.                  �
		//������������������������������������������������������������������
		aSFEIRIC[Len(aSFEIRIC)][7] := SE2->E2_VALOR
		aSFEIRIC[Len(aSFEIRIC)][8] := SE2->E2_EMISSAO
	EndIf
EndIf

Return aSFEIRIC

/*
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � CalcRetSUSS� Autor � Julio Cesar         � Data � 30.01.03 ���
��+----------+------------------------------------------------------------���
���Descri��o � Calcular e Gerar Retencoes de SUSS                         ���
��+----------+------------------------------------------------------------���
���Uso       � FINA085A                                                   ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
*/

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Fa085AcRe2�Autor  �Microsiga           � Data �  10/17/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Acumula os valores base de calculo de retencao por Conceito.���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Fina085,FINA085a                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function Fa085AcRe2(aConGanOri,nSigno,nSaldo,aRateioGan,lPa,lMonotrb)
Local nRateio
Local nRatValImp
Local nValMerc
Local nTotOrden
Local nPosGan,cConc
Local nX,nY,nMoeda   := 1
Local aConGan	:=	{}
Local aConGanRat	:=	{}
Local lCalcGan := .T.
Local nVlrTotal:=0
Local nI:=1
Local aImpInf := {}
DEFAULT nSigno	:=	-1
DEFAULT lPA		:=	.F.
DEFAULT lMonotrb := .F.

If lRetPA == Nil
	lRetPA := (GetNewPar("MV_RETPA","N") == "S")
EndIf

//+----------------------------------------------------------------+
//� Obter o Valor do Imposto e Base baseando se no rateio do valor �
//� do titulo pelo total da Nota Fiscal.                           �
//+----------------------------------------------------------------+
If ExistBlock("F0851IMP")
	lCalcGan:=ExecBlock("F0851IMP",.F.,.F.,{"GN2"})
EndIf

If lCalcGan
	If SE2->E2_TIPO $ MVPAGANT .And. lRetPA
		nRatPa	:=	(nSaldo/SE2->E2_VALOR)
		//Procurar no SFE qual foi a base utilizada para calculo da retencao
		DbSelectArea("SFE")
		DbSetOrder(2)
		If MsSeek(xFilial("SFE")+ Substr(SE2->E2_NUM,1,Len(SFE->FE_ORDPAGO))+"G")
			For nY := 1 To Len(aRateioGan)
				nPosGan:=ASCAN(aConGanRat,{|x| x[1]==aRateioGan[nY][5] .And. x[3]==''.And. x[4] == aRateioGan[nY][2]+aRateioGan[nY][3] .And. If(lMsFil .And. !Empty(xFilial("SA2")) .And. xFilial("SF1") == xFilial("SE2"),x[5] == aRateioGan[nY][2]+aRateioGan[nY][6],.T.)})
				If nPosGan<>0
					aConGanRat[nPosGan][2]+= SFE->FE_VALBASE *nRatPA * aRateioGan[nY][4]  * nSigno
				Else
					Aadd(aConGanRat,{aRateioGan[nY][5],SFE->FE_VALBASE * nRatPA * aRateioGan[nY][4]* nSigno,'',aRateioGan[nY][2]+aRateioGan[nY][3]})
				Endif
			Next
		Endif
	Else
	If !lPa
		dbSelectArea("SF2")
		dbSetOrder(1)
		If lMsFil
			dbSeek(SE2->E2_MSFIL+(SE2->E2_NUM)+(SE2->E2_PREFIXO)+(SE2->E2_FORNECE)+SE2->E2_LOJA)
		Else
			dbSeek(xFilial("SF2")+(SE2->E2_NUM)+(SE2->E2_PREFIXO)+(SE2->E2_FORNECE)+SE2->E2_LOJA)
		EndIf
		While Alltrim(SF2->F2_ESPECIE)<>Alltrim(SE2->E2_TIPO).And.!Eof()
			SF2->(DbSkip())
			Loop
		Enddo
	Endif

	If !lPa .And. Alltrim(SF2->F2_ESPECIE)==Alltrim(SE2->E2_TIPO).And.;
		Iif(lMsfil,SF2->F2_MSFIL,xFilial("SF2"))+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA==;
		F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA

		nMoeda      := Max(SF2->F2_MOEDA,1)

		If cPaisLoc<>"ARG"
			nRateio := 1
		else
			nRateio     := SF2->F2_VALMERC / SF2->F2_VALBRUT
		Endif

		nRatValImp	:= ( Round(xMoeda(nSaldo,SE2->E2_MOEDA,1,,5,aTxMoedas[Max(SE2->E2_MOEDA,1)][2]),MsDecimais(1)) / Round(xMoeda(SF2->F2_VALBRUT,SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1)) )
		nValMerc 	:= ( Round(xMoeda(nSaldo,SE2->E2_MOEDA,1,,5,aTxMoedas[Max(SE2->E2_MOEDA,1)][2]),MsDecimais(1)) * nRateio )
		If SF2->F2_FRETE > 0
			MV_FRETLOC := GetNewPar("MV_FRETLOC","IVA162GAN06")
			cConc   := Alltrim(Subs( MV_FRETLOC, At("N",MV_FRETLOC)+1))
			nPosGan := ASCAN(aConGan,{|x| x[1]==cConc.And.x[3]==''})
			If nPosGan<>0
				aConGan[nPosGan][2]:=aConGan[nPosGan][2]+((Round(xMoeda(SF2->F2_FRETE,SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1))*nRatValimp) * nSigno)
			Else
				Aadd(aConGan,{cConc,(Round(xMoeda(SF2->F2_FRETE,SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1))*nRatValimp)*nSigno,''})
			Endif
		EndIf
		If SF2->F2_DESPESA >  0
			MV_GASTLOC  := GetNewPar("MV_GASTLOC","IVA112GAN06")
			cConc   := Alltrim(Subs( MV_GASTLOC, At("N",MV_GASTLOC)+1))
			nPosGan := ASCAN(aConGan,{|x| x[1]==cConc.And.x[3]==''})
			If nPosGan<>0
				aConGan[nPosGan][2]:=aConGan[nPosGan][2]+(Round(xMoeda(SF2->F2_DESPESA,SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1))*nRatValimp)*nSigno
			Else
				Aadd(aConGan,{cConc,(Round(xMoeda(SF2->F2_DESPESA,SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1))*nRatValimp) * nSigno,''})
			Endif
		EndIf

		SD2->(DbSetOrder(3))
		If lMsfil
			SD2->(DbSeek(SD2->D2_MSFIL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
		Else
			SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
		EndIf
		If SD2->(Found())
			Do while Iif(lMsFil,SD2->D2_MSFIL,xFilial("SD2"))==SD2->D2_FILIAL.And.SF2->F2_DOC==SD2->D2_DOC.AND.;
				SF2->F2_SERIE==SD2->D2_SERIE.AND.SF2->F2_CLIENTE==SD2->D2_CLIENTE;
				.AND.SF2->F2_LOJA==SD2->D2_LOJA.And.!SD2->(EOF())

				IF AllTrim(SD2->D2_ESPECIE)<>AllTrim(SE2->E2_TIPO)
					SD2->(DbSkip())
					Loop
				Endif
					aImpInf := TesImpInf(SD2->D2_TES)
					SFF->(DbSetOrder(2))
					If SFF->(Dbseek(xfilial("SFF")+Pad(SF2->F2_SERIE,len(SFF->FF_ITEM))) )  .and. Round(xMoeda(SF2->F2_VALMERC,SF2->F2_MOEDA,1,,,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1)) > SFF->FF_FXDE
						nVlrTotal:= 0
						If SFF->(FieldPos("FF_INCIMP")) > 0
							For nI := 1 To Len(aImpInf)
					  			If(Trim(aImpInf[nI][01])$ SFF->FF_INCIMP)
									If aImpInf[nI][03] <> "3"
										nVlrTotal+=SD2->(FieldGet(FieldPos(aImpInf[nI][02])))
									EndIf
								EndIf
							Next nI
                        EndIf
			  		 	nPosGan:=ASCAN(aConGan,{|x| x[1]==Pad(SF2->F2_SERIE,len(SFF->FF_ITEM))} )
						If nPosGan<>0
							aConGan[nPosGan][2]:=aConGan[nPosGan][2]+(Round(xMoeda((SD2->D2_TOTAL+nVlrTotal),SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1)) * nRatValImp)
						Else
							Aadd(aConGan,{Pad(SF2->F2_SERIE,len(SFF->FF_ITEM)),Round(xMoeda((SD2->D2_TOTAL+nVlrTotal),SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1)) * nRatValImp,''})
						Endif
					Else
					SB1->(DbSetOrder(1))
					SB1->(DbSeek(Iif(lMsFil .And. !Empty(xFilial("SB1")),SD2->D2_MSFIL,xFilial("SB1")) + SD2->D2_COD))
					If SB1->(Found()) .And. ((!lMonotrb .And. !Empty(SB1->B1_CONCGAN)) .Or. (SB1->(FieldPos("B1_CMONGAN"))>0 .And. !Empty(SB1->B1_CMONGAN) .And. lMonotrb))
						cConc2	:=	''
						If SB1->(FieldPos('B1_CONGANI'))>0 .AND.SB1->B1_CONCGAN=='02'
			              	cConc2	:=	SB1->B1_CONGANI
						Endif

						aAreaAtu:=GetArea()
						aAreaSFF:=SFF->(GetArea())
						dbSelectArea("SFF")
						dbSetOrder(2)
						If dbSeek(xFilial("SFF")+Iif(lMonotrb .And. SB1->(FieldPos("B1_CMONGAN"))>0,SB1->B1_CMONGAN,SB1->B1_CONCGAN)+'GAN')
							nVlrTotal:= 0
							If SFF->(FieldPos("FF_INCIMP")) > 0
								For nI := 1 To Len(aImpInf)
			  						If(Trim(aImpInf[nI][01])$ SFF->FF_INCIMP)
										If aImpInf[nI][03] <> "3"
									   		nVlrTotal+=SD2->(FieldGet(FieldPos(aImpInf[nI][02])))
										EndIf
									EndIf
								Next nI
						   EndIf
						Endif

						RestArea(aAreaAtu)
						SFF->(RestArea(aAreaSFF))

						nPosGan:=ASCAN(aConGan,{|x| x[1]==SB1->B1_CONCGAN .And. x[3]==cConc2})

						If nPosGan<>0
							aConGan[nPosGan][2]:=aConGan[nPosGan][2]+((Round(xMoeda(SD2->D2_TOTAL,SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1)) * nRatValImp) * nSigno)
						Else
							Aadd(aConGan,{Iif(lMonotrb .And. SB1->(FieldPos("B1_CMONGAN"))>0,SB1->B1_CMONGAN,SB1->B1_CONCGAN),(Round(xMoeda(SD2->D2_TOTAL,SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1)) * nRatValImp ) * nSigno,cConc2})
						Endif
					Else

							For nY := 1 To Len(aRateioGan)
								nPosGan:=ASCAN(aConGanRat,{|x| x[1]==aRateioGan[nY][5] .And. x[3]==''.And. x[4] == aRateioGan[nY][2]+aRateioGan[nY][3] .And. If(lMsFil .And. !Empty(xFilial("SA2")) .And. xFilial("SF1") == xFilial("SE2"),x[5] == aRateioGan[nY][2]+aRateioGan[nY][6],.T.)})
								If nPosGan<>0
									aConGanRat[nPosGan][2]+= (Round(xMoeda((SD2->D2_TOTAL+nVlrTotal),SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1)) 	* nRatValImp) * aRateioGan[nY][4]  * nSigno
								Else
									If lMsFil .And. !Empty(xFilial("SA2")) .And. xFilial("SF1") == xFilial("SE2")
										Aadd(aConGanRat,{aRateioGan[nY][5],nValMerc*aRateioGan[nY][4]* nSigno,'',aRateioGan[nY][2]+aRateioGan[nY][3],aRateioGan[nY,6]})
								    Else
										Aadd(aConGanRat,{aRateioGan[nY][5],nValMerc*aRateioGan[nY][4]* nSigno,'',aRateioGan[nY][2]+aRateioGan[nY][3]})
									Endif
								Endif
							Next
						Endif
					EndIf
					SD2->(DbSkip())
				Enddo
			Else
				For nY := 1 To Len(aRateioGan)
					nPosGan:=ASCAN(aConGanRat,{|x| x[1]==aRateioGan[nY][5] .And. x[3]==''.And. x[4] == aRateioGan[nY][2]+aRateioGan[nY][3] .And. If(lMsFil .And. !Empty(xFilial("SA2")),x[5] == aRateioGan[nY][2]+aRateioGan[nY][6],.T.)})
					If nPosGan<>0
						aConGanRat[nPosGan][2]+= nValMerc * aRateioGan[nY][4]  * nSigno
					Else
						If lMsFil .And. !Empty(xFilial("SA2")) .And. xFilial("SF1") == xFilial("SE2")
							Aadd(aConGanRat,{aRateioGan[nY][5],(nValMerc+nVlrTotal)*aRateioGan[nY][4]* nSigno,'',aRateioGan[nY][2]+aRateioGan[nY][3],aRateioGan[nY][6]})
						Else
							Aadd(aConGanRat,{aRateioGan[nY][5],(nValMerc+nVlrTotal)*aRateioGan[nY][4]* nSigno,'',aRateioGan[nY][2]+aRateioGan[nY][3]})
						Endif
					Endif
				Next
			Endif
		Else
			If lPa
				nValMerc	 := nSaldo
			Else
				nValMerc	 := Iif( lRetPA,Round(xMoeda(nSaldo,SE2->E2_MOEDA,1,,5,aTxMoedas[Max(SE2->E2_MOEDA,1)][2]),MsDecimais(1)),0)
			Endif
			For nY := 1 To Len(aRateioGan)

				aAreaAtu:=GetArea()
				aAreaSFF:=SFF->(GetArea())
				dbSelectArea("SFF")
				dbSetOrder(2)
				If dbSeek(xFilial("SFF")+aRateioGan[nY][5]+'GAN')
					nVlrTotal:= 0
					nVlrTotIt:=0
					If SFF->(FieldPos("FF_INCIMP")) > 0
						For nI := 1 To Len(aImpInf)
							If(Trim(aImpInf[nI][01])$ SFF->FF_INCIMP)
									If aImpInf[nI][03] <> "3"
								   		nVlrTotal+=SD2->(FieldGet(FieldPos(aImpInf[nI][02])))
									EndIf
							EndIf
						Next nI
			   		EndIf
				Endif

			RestArea(aAreaAtu)
			SFF->(RestArea(aAreaSFF))

				nPosGan:=ASCAN(aConGanRat,{|x| x[1]==aRateioGan[nY][5] .And. x[3]==''.And. x[4] == aRateioGan[nY][2]+aRateioGan[nY][3] .And. If(lMsFil .And. !Empty(xFilial("SA2")) .And. xFilial("SF1") == xFilial("SE2"),x[5] == aRateioGan[nY][2]+aRateioGan[nY][6],.T.)})
				If nPosGan<>0
					aConGanRat[nPosGan][2]+= (nValMerc+nVlrTotal) * aRateioGan[nY][4]  * nSigno
				Else
					If lMsFil .And. !Empty(xFilial("SA2")) .And. xFilial("SF1") == xFilial("SE2")
						Aadd(aConGanRat,{aRateioGan[nY][5],(nValMerc+nVlrTotal)*aRateioGan[nY][4]* nSigno,'',aRateioGan[nY][2]+aRateioGan[nY][3],aRateioGan[nY][6]})
					Else
						Aadd(aConGanRat,{aRateioGan[nY][5],(nValMerc+nVlrTotal)*aRateioGan[nY][4]* nSigno,'',aRateioGan[nY][2]+aRateioGan[nY][3]})
					Endif
				Endif
			Next
		EndIf
	Endif
	//Faz o rateio dos condominos
	For nY	:=	1	To Len(aConGan)
		For nX:= 1 To Len(aRateioGan)
			If lMsFil .And. !Empty(xFilial("SA2")) .And. xFilial("SF1") == xFilial("SE2")
				AAdd(aConGanRat,{aConGan[nY][1],aConGan[nY][2]*aRateioGan[nX][4],aConGan[nY][3],aRateioGan[nX][2]+aRateioGan[nX][3],aRateioGan[nY][6]})
			Else
				AAdd(aConGanRat,{aConGan[nY][1],aConGan[nY][2]*aRateioGan[nX][4],aConGan[nY][3],aRateioGan[nX][2]+aRateioGan[nX][3] })
			Endif
		Next
	Next

	//Distribue os acumulados ja rateados no array de acumulados total
	For nY := 1 TO Len(aConGanRat)
		nPosGan   := ASCAN(aConGanOri,{|x|  x[1]+x[3]+x[4] == aConGanRat[nY][1]+aConGanRat[nY][3]+aConGanRat[nY][4] })
		If nPosGan<>0
			aConGanOri[nPosGan][2]	+= aConGanRat[nY][2]
		Else
			Aadd(aConGanOri,aClone(aConGanRat[nY]))
		Endif
	Next
EndIf
Return

/*
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � CalcRetIV2 � Autor � Jose Lucas          � Data � 25.06.98 ���
��+----------+------------------------------------------------------------���
���Descri��o � Calcular e Gerar Retencoes sobre IVA.                      ���
��+----------+------------------------------------------------------------���
���Uso       � PAGO007                                                    ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
*/
Static Function CalcRetIV2(cAgente,nSigno,nSaldo,nProp)
Local aConIva  := {}
Local aSFEIVA  := {}
Local aDadosIVA := {}
Local aDocAcm 	:= {}
Local aConfIVA 	:= {}
Local nPosIva
Local cConc
Local oDlg4
Local nCount
Local nTotRet    := 0
Local nTotRetSFE := 0
Local cChaveSFE  := ""
Local cAliasCabe := ""
Local cAliasItem := ""
Local lAcmIVA	 := .F.
Local lExisteSFF	:= .T.
Local lRetSerie   :=	.F.
Local lCalRet	:=.F.
Local lCalcImp := .T.
Local lCalRep := .F.
Local lCalcVen:=.F.
Local lCalcNew	:= GetNewPar("MV_GRETIVA","N") == "S"
Local lCalrtexp:=.F.
Local  nI := 1
Local nX := 0
Local nValorBr:=0
Local nTotBase:=0
Local nTotImp:=0
Local lRetSit :=.T.
Local nValMin := 0
Local nRetIva:= 0
Local nValIVA:=0
Local nAliqIva := 0
Local lCalcIva := .T.
Local lRetIva  := .F.
Local lCalcAcm := .F.
Local cAcmIVA	:= ""
Local xY 	:= 0
Local cRetImp	:= ""
Local aLivros := {}
Local nPerc		:= 0
Local lExiste := .F.
DEFAULT nSigno	:=	-1
DEFAULT nProp := 1

//+---------------------------------------------------------------------+
//� Obter Impostos somente qdo a Empresa Usuario for Agente de Reten��o.�
//+---------------------------------------------------------------------+
dbSelectArea("SF2")
dbSetOrder(1)
If lMsfil
	SF2->(dbSeek(SE2->E2_MSFIL+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA))
Else
	SF2->(dbSeek(xFilial("SF2")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA))
EndIf

lCalRet := Iif(Alltrim(SF2->F2_SERIE) == "M",.T.,.F.)
lCalcAcm := Subs(cAgente,2,1) == "N"
If(SF2->(FieldPos("F2_TPNFEXP"))>0 .And. SFF->(FieldPos("FF_VLRLEX"))>0 .And. SFF->(FieldPos("FF_ALIQLEX"))>0 .And.  SF2->F2_TPNFEXP=="1")  //1 - Exportador 2- Normal
	lCalrtexp:=.T.
EndIf
If ExistBlock("F0851IMP")
	lCalcImp:=ExecBlock("F0851IMP",.F.,.F.,{"IV2"})
EndIf

// Tratamento do Reproweb - Situa��o igual a 0 n�o deve reter Resoluci�n General ( AFIP) 2226/07
SA2->( dbSetOrder(1) )
If lMsFil .And. !Empty(xFilial("SA2")) .And. xFilial("SF1") == xFilial("SE2")
	SA2->(DbSeek(SE2->E2_MSFIL+SE2->E2_FORNECE+SE2->E2_LOJA) )
Else
	SA2->( dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA) )
Endif

If SA2->(FieldPos("A2_SITU")>0) .and. Alltrim(SA2->A2_SITU)$("0")
	lRetSit:=.F.
EndIf

If cPaisLoc == "PTG"
	SA2->( dbSetOrder(1) )
	SA2->( dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA) )

	//���������������������������������������������������������������������Ŀ
	//� Fornecedor ? Reter IVA                                              �
	//�����������������������������������������������������������������������
	If SA2->A2_RETIVA == "1"

		While Alltrim(SF2->F2_ESPECIE)<>AllTrim(SE2->E2_TIPO).And.!EOF()
			SF2->(DbSkip())
			Loop
		Enddo

		If AllTrim(SF2->F2_ESPECIE)==Alltrim(SE2->E2_TIPO).And.;
			xFilial("SF2")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA==;
			F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA

			nTotBase:=SF2->F2_BASIMP1+SF2->F2_BASIMP3+SF2->F2_BASIMP4+SF2->F2_BASIMP5+SF2->F2_BASIMP6
			nTotImp:=SF2->F2_VALIMP1+SF2->F2_VALIMP3+SF2->F2_VALIMP4+SF2->F2_VALIMP5+SF2->F2_VALIMP6

			AAdd(aSFEIVA,array(8))
			aSFEIVA[Len(aSFEIVA)][1] := SF2->F2_DOC         		//FE_NFISCAL
			aSFEIVA[Len(aSFEIVA)][2] := SF2->F2_SERIE       		//FE_SERIE
			aSFEIVA[Len(aSFEIVA)][3] := Round(xMoeda(nTotBase,SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1))*nSaldo/SE2->E2_VALOR * nSigno	//FE_VALBASE
			aSFEIVA[Len(aSFEIVA)][4] := Round(xMoeda(nTotImp,SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1))*nSaldo/SE2->E2_VALOR * nSigno	//FE_VALIMP
			aSFEIVA[Len(aSFEIVA)][5] := 100
			aSFEIVA[Len(aSFEIVA)][6] := aSFEIVA[Len(aSFEIVA)][4]
			aSFEIVA[Len(aSFEIVA)][7] := SE2->E2_VALOR
			aSFEIVA[Len(aSFEIVA)][8] := SE2->E2_EMISSAO
		Endif
	Endif
ElseIf (Subs(cAgente,2,1) == "S" .Or. lCalRet .Or. lCalcAcm)  .And.  lCalcImp  .And.  lRetSit
	SA2->( dbSetOrder(1) )
	If lMsFil .And. !Empty(xFilial("SA2")) .And. xFilial("SF1") == xFilial("SE2")
		SA2->( dbSeek(SE2->E2_MSFIL+SE2->E2_FORNECE+SE2->E2_LOJA) )
	Else
		SA2->( dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA) )
	Endif

	//���������������������������������������������������������������������Ŀ
	//� Fornecedor ? Agente de Reten??o n?o Retem IVA.                      �
	//�����������������������������������������������������������������������
	If SA2->A2_AGENRET == "N" .Or. lCalRet

		If (SA2->(FieldPos("A2_IVRVCOB")) >0  .And.  !Empty(SA2->A2_IVRVCOB) .And. SA2->A2_IVRVCOB > dDataBase)
			lCalcVen:=Iif(!Empty(SA2->A2_IVPCCOB) .Or. !Empty(SA2->A2_IVPCCOB) ,.F.,.T.)
		EndIf

		lCalRep := Iif(SA2->(FieldPos("A2_SITU")>0) .and. Alltrim(SA2->A2_SITU)$("2/4"),.T.,.F.)

		While Alltrim(SF2->F2_ESPECIE)<>AllTrim(SE2->E2_TIPO).And.!EOF()
			SF2->(DbSkip())
			Loop
		Enddo

		If AllTrim(SF2->F2_ESPECIE)==Alltrim(SE2->E2_TIPO).And.;
			Iif(lMsFil,SF2->F2_MSFIL,xFilial("SF2"))+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA==;
			F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA

			//����������������������������������������������������������������Ŀ
			//� Obter o Valor do Imposto e Base baseando se no rateio do valor �
			//� do titulo pelo total da Nota Fiscal.                           �
			//������������������������������������������������������������������
			SD2->(DbSetOrder(3))
			If lMsFil
				SD2->(DbSeek(SF2->F2_MSFIL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
			Else
				SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
			EndIf
			If SD2->(Found())
				Do while Iif(lMsFil,SD2->D2_MSFIL,xFilial("SD2"))==SD2->D2_FILIAL.And.SF2->F2_DOC==SD2->D2_DOC.AND.;
					SF2->F2_SERIE==SD2->D2_SERIE.AND.SF2->F2_CLIENTE==SD2->D2_CLIENTE;
					.AND.SF2->F2_LOJA==SD2->D2_LOJA.AND.!SD2->(EOF())

					If AllTrim(SD2->D2_ESPECIE)<>AllTrim(SF2->F2_ESPECIE)
						SD2->(DbSkip())
						Loop
					Endif
					SB1->(DbSetOrder(1))
					If !Empty(SD2->D2_CF)
						If !lCalcAcm
							nRateio := ( Round(xMoeda(nSaldo,SE2->E2_MOEDA,1,,5,aTxMoedas[Max(SE2->E2_MOEDA,1)][2]),MsDecimais(1)) / Round(xMoeda(SF2->F2_VALBRUT,SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1)) )
						Else
							nRateio := 1
						EndIf
						nPosIva:=ASCAN(aConIva,{|x| x[1]==SD2->D2_CF})
						If lCalcNew   // Calcula IVA metodo Novo
							If nPosIva<>0
								If SD2->(FieldPos("D2_IVAFRET"))>0  .And.  SD2->(FieldPos("D2_IVAGAST"))>0  .And. SD2->(FieldPos("D2_BAIVAGA"))>0   .And.  SD2->(FieldPos("D2_BAIVAFR"))>0
									aConIva[nPosIva][2]:=aConIva[nPosIva][2]+((aConIva[nPosIva][4] * (SD2->D2_TOTAL ) )- ((SD2->D2_IVAFRET+SD2->D2_IVAGAST))) * nRateio
									aConIva[nPosIva][3]:=aConIva[nPosIva][3]+((SD2->D2_TOTAL ) - ((SD2->D2_BaIVAFR+SD2->D2_BaIVAGA)) )  * nRateio
								Else
									aConIva[nPosIva][2]:=aConIva[nPosIva][2]+(aConIva[nPosIva][4] * (SD2->D2_TOTAL ) )  * nRateio
									aConIva[nPosIva][3]:=aConIva[nPosIva][3]+(SD2->D2_TOTAL )  * nRateio
								EndIf
							Else
								If  lCalRep .Or. lCalcVen
									aImpInf := TesImpInf(SD2->D2_TES)
									For nI := 1 To Len(aImpInf)
										If  "IV"$Trim(aImpInf[nI][01]) .And.  Trim(aImpInf[nI][01])<>"IVP"

											Aadd(aConIva,{SD2->D2_CF,SD2->(FieldGet(FieldPos(aImpInf[nI][02]))),SD2->(FieldGet(FieldPos(aImpInf[nI][07]))), (SD2->(FieldGet(FieldPos(aImpInf[nI][10]))) /100)})
										EndIf
									Next
								Else
									SFF->(DbSetOrder(5))
									If SFF->(DbSeek(xFilial("SFF")+"IVR"))
										nPerc:=0
										lAchou:=.F.
										While SFF->(!EOF() ).and. (xFilial("SFF")+"IVR") ==(SFF->FF_FILIAL+SFF->FF_IMPOSTO) .And.  !lAchou
											If (cPaisLoc<> "PAR" .and.Alltrim(SFF->FF_SERIENF)==Alltrim(SD2->D2_SERIE)  .And.  SD2->D2_CF==  SFF->FF_CFO_V)  ;
											.or. (cPaisLoc=="PAR" .and. SD2->D2_CF==  SFF->FF_CFO_V) 
												lAchou:=.T.
												nPerc:=SFF->FF_ALIQ
												If SFF->(FieldPos("FF_TPLIM")) > 0
													cAcmIVA := SFF->FF_TPLIM
													nLimite := SFF->FF_LIMITE
												EndIf
											Else
												SFF->(DbSkip())
											EndIf
										EndDo
										/*************************************************
										//Verifica o acumulado para o c�lculo do imposto
										//************************************************/
										//caso seja branco ou n�o foi selecionado nenhum m�todo de acumulo
										If Type("aRetIvAcm") <> "A"
											aRetIvAcm := Array(3)
										EndIf
										If cAcmIVA <> "" .And. cAcmIVA <> "0" .And. lCalcAcm
											aDadosIVA 	:= F085AcmIVA(cAcmIVA,SF2->F2_EMISSAO,SF2->F2_CLIENTE,SF2->F2_LOJA)
											If aDadosIVA[4]
												nBase := aDadosIVA[1] - aDadosIVA[2]

												If nBase > nLimite .Or. aDadosIVA[2]  > 0
													lRetIva := .T.
													lAcmIVA := .T.

													For nX := 1 to Len(aDadosIVA[3])
														If Empty(aDadosIVA[3][nX][2])
															aAdd(aDocAcm, {aDadosIVA[3][nX][3], aDadosIVA[3][nX][4], Iif(aDadosIVA[3][nX][1],.F.,.T.)})
														EndIf
													Next nX

													If Len(aDocAcm) > 0
														aAdd(aConfIVA,nPerc)

														aRetIvAcm[1] :=  aConfIVA

														If aRetIvAcm[2] == Nil
															aRetIvAcm[2] := {}
														EndIf

														For nX := 1 to Len(aDocAcm)
															If aDocAcm[nX][2] == "SF1"
																nPosDoc := aScan(aRetIvAcm[2],{|x| x[1]==aDocAcm[nX][1] .And. x[2]=="SF1"})
															Else
																nPosDoc := aScan(aRetIvAcm[2],{|x| x[1]==aDocAcm[nX][1] .And. x[2]=="SF2"})
															EndIf
															If nPosDoc == 0
																Aadd(aRetIvAcm[2],aDocAcm[nX])
															EndIf
														Next nX

													EndIf

												EndIf
											Else
												lRetIva := .T.
											EndIf

										Else
											//Se n�o usa cumulatividade de IVA, calcula no m�todo antigo
											lRetIva := .T.
										EndIf
										If  lCalrtexp  .And. lAchou
											nValorBr:=Round(xmoeda(SF2->F2_VALBRUT,SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1))
											nPerc:=Iif(nValorBr>SFF->FF_VLRLEX,SFF->FF_ALIQ,SFF->FF_ALIQLEX)
										EndIf

										If lRetIva
											If SD2->(FieldPos("D2_IVAFRET"))>0  .And.  SD2->(FieldPos("D2_IVAGAST"))>0  .And. SD2->(FieldPos("D2_BAIVAGA"))>0   .And.  SD2->(FieldPos("D2_BAIVAFR"))>0
												Aadd(aConIva,{SD2->D2_CF,(((nPerc /100) * (SD2->D2_TOTAL ))  - (SD2->D2_IVAFRET+SD2->D2_IVAGAST)),((SD2->D2_TOTAL )- (SD2->D2_BaIVAFR +SD2->D2_BaIVAGA)), (nPerc /100)})
											Else
												If cPaisLoc=="PAR"  
													cRetImp:= SuperGetMv("MV_IMPRETI",.F.,"")
													aAreaSFB:= SFB->(GetArea())  
													aLivros:={}
													dbSelectArea("SFB")
			        								SFB->(DbSetOrder(1))												 
													SFB->(dbGoTop())
													While SFB->(!EOF() ) .and. (xFilial("SFB")==SFB->FB_FILIAL)													
														If SFB->FB_CODIGO $ cRetImp	 .And. ASCAN(aLivros,{|x| x[1]==SFB->FB_CPOLVRO}) == 0 
															aAdd(aLivros,{SFB->FB_CPOLVRO})
														EndIf																							
														SFB->(DbSkip())
													EndDo
													nTotbas := 0         
													nImpRetIva:= 0
													For xY := 1 to len (aLivros) 
														nTotBas:= nTotBas + &("SD2->D2_BASIMP"+(Alltrim(aLivros[xY][1])))											
														nImpRetIva:= nImpRetIva + &("SD2->D2_VALIMP"+(Alltrim(aLivros[xY][1])))
													Next 
													nTotBas:=Round(nTotBas*nRateio,Msdecimais(SF2->F2_MOEDA))
													nImpRetIva:=Round(nImpRetIva*nRateio,Msdecimais(SF2->F2_MOEDA))
													nImpRetIva := ((nImpRetIva * IIf(cPaisLoc=="PAR" .and. nPerc>0,nPerc,SA2->A2_PORIVA)/100 ))  
													
													If cPaisLoc=="PAR"
														nImpRetIva :=Round(nImpRetIva,Msdecimais(SF2->F2_MOEDA))
													EndIf
													
													Aadd(aConIva,{SD2->D2_CF,(nImpRetIva) ,(nTotBas ), nPerc })
												Else
													Aadd(aConIva,{SD2->D2_CF,((nPerc /100) * (SD2->D2_TOTAL )) ,(SD2->D2_TOTAL ), (SFF->FF_ALIQ /100)})
												EndIf
											EndIf
										EndIf
									EndIf
								EndIf
							EndIF
						Else
							If nPosIva<>0
								If SD2->(FieldPos("D2_IVAFRET"))>0  .And.  SD2->(FieldPos("D2_IVAGAST"))>0  .And. SD2->(FieldPos("D2_BaIVAGA"))>0   .And.  SD2->(FieldPos("D2_BAIVAFR"))>0
									aConIva[nPosIva][2]:=aConIva[nPosIva][2]+(SD2->D2_VALIMP1-SD2->D2_IVAFRET+SD2->D2_IVAGAST)
									aConIva[nPosIva][3]:=aConIva[nPosIva][3]+(SD2->D2_BASIMP1-SD2->D2_BaIVAFR+SD2->D2_BaIVAGA)
								ElseIf cPaisLoc=="PAR"    
									SFF->(DbSetOrder(5)) // FF_FILIAL+FF_IMPOSTO+FF_CFO_C+FF_ZONFIS
									SFF->(DbGotop())
									
									If SFF->(DbSeek(xFilial("SFF")+"IVR")) 
										nPerc:=0
										lAchou:=.F.
										While SFF->(!EOF() ).and. (xFilial("SFF")+"IVR") ==(SFF->FF_FILIAL+SFF->FF_IMPOSTO) .And.  !lAchou
											If  SD1->D1_CF==  SFF->FF_CFO_C
												lAchou:=.T.
										   		nPerc:=SFF->FF_ALIQ	
											Else
												SFF->(DbSkip())
											EndIf
										EndDO
										cRetImp:= SuperGetMv("MV_IMPRETI",.F.,"")
										aAreaSFB:= SFB->(GetArea())  
										aLivros:={}
										dbSelectArea("SFB")
				        				SFB->(DbSetOrder(1))												 
										SFB->(dbGoTop())
										While SFB->(!EOF() ) .and. (xFilial("SFB")==SFB->FB_FILIAL)													
											If SFB->FB_CODIGO $ cRetImp	 .And. ASCAN(aLivros,{|x| x[1]==SFB->FB_CPOLVRO}) == 0 
													aAdd(aLivros,{SFB->FB_CPOLVRO})
											EndIf																							
											SFB->(DbSkip())
										EndDo
										nTotbas := 0         
										nImpRetIva:= 0
										For xY := 1 to len (aLivros) 
									   		nTotBas:= nTotBas + &("SD2->D2_BASIMP"+(Alltrim(aLivros[xY][1])))											
											nImpRetIva:= nImpRetIva + &("SD2->D2_VALIMP"+(Alltrim(aLivros[xY][1])))
										Next 
										nTotBas:=Round(nTotBas*nRateio,Msdecimais(SF2->F2_MOEDA))
										nImpRetIva:=Round(nImpRetIva*nRateio,Msdecimais(SF2->F2_MOEDA))
										nImpRetIva := ((nImpRetIva * IIf(cPaisLoc=="PAR" .and. nPerc>0,nPerc,SA2->A2_PORIVA)/100 ))     
										If cPaisLoc=="PAR"
											nImpRetIva :=Round(nImpRetIva,Msdecimais(SF2->F2_MOEDA))
										EndIf
								   		aConIva[nPosIva][2]:=aConIva[nPosIva][2]+(nImpRetIva)
										aConIva[nPosIva][3]:=aConIva[nPosIva][3]+(nTotBas)
									EndIf
								Else
									aConIva[nPosIva][2]:=aConIva[nPosIva][2]+(SD2->D2_VALIMP1)
									aConIva[nPosIva][3]:=aConIva[nPosIva][3]+(SD2->D2_BASIMP1)
								EndIf
							ElseIf nPosIva == 0 .and. cPaisLoc == "PAR"	
								SFF->(DbSetOrder(5)) // FF_FILIAL+FF_IMPOSTO+FF_CFO_C+FF_ZONFIS
								SFF->(DbGotop())
								If SFF->(DbSeek(xFilial("SFF")+"IVR")) 
									nPerc:=0
									lAchou:=.F.
									While SFF->(!EOF() ).and. (xFilial("SFF")+"IVR") ==(SFF->FF_FILIAL+SFF->FF_IMPOSTO) .And.  !lAchou
										If    SD2->D2_CF==  SFF->FF_CFO_V
											lAchou:=.T.
											nPerc:=SFF->FF_ALIQ
										Else
											SFF->(DbSkip())
										EndIf
									EnddO
									cRetImp:= SuperGetMv("MV_IMPRETI",.F.,"")
									aAreaSFB:= SFB->(GetArea())  
									aLivros:={}
									dbSelectArea("SFB")
									SFB->(DbSetOrder(1))												 
									SFB->(dbGoTop())
									While SFB->(!EOF() ) .and. (xFilial("SFB")==SFB->FB_FILIAL)													
											If SFB->FB_CODIGO $ cRetImp	 .And. ASCAN(aLivros,{|x| x[1]==SFB->FB_CPOLVRO}) == 0 
												aAdd(aLivros,{SFB->FB_CPOLVRO})
											EndIf																							
											SFB->(DbSkip())
									EndDo
									nTotbas := 0         
									nImpRetIva:= 0
									For xY := 1 to len (aLivros) 
										nTotBas:= nTotBas + &("SD2->D2_BASIMP"+(Alltrim(aLivros[xY][1])))											
										nImpRetIva:= nImpRetIva + &("SD2->D2_VALIMP"+(Alltrim(aLivros[xY][1])))
									Next 
									nTotBas:=Round(nTotBas*nRateio,Msdecimais(SF2->F2_MOEDA))
									nImpRetIva:=Round(nImpRetIva*nRateio,Msdecimais(SF2->F2_MOEDA))
									nImpRetIva := ((nImpRetIva * IIf(cPaisLoc=="PAR" .and. nPerc>0,nPerc,SA2->A2_PORIVA)/100 ))
									If cPaisLoc=="PAR"
										nImpRetIva :=Round(nImpRetIva,Msdecimais(SF2->F2_MOEDA))
									EndIf			
									Aadd(aConIva,{SD2->D2_CF,(nImpRetIva) ,(nTotBas ), nPerc })
								EndIf	
							Else
								Aadd(aConIva,{SD2->D2_CF,SD2->D2_VALIMP1,SD2->D2_BASIMP1,0})
							Endif
						Endif
					ElseIf SB1->(DbSeek(Iif(lMsFil .And. !Empty(xFilial("SB1")),SD2->D2_MSFIL,xFilial("SB1")) + SD2->D2_COD)) .And. !lCalcAcm
						nPosIva:=ASCAN(aConIva,{|x| x[1]==SB1->B1_CONCIVA})
						If nPosIva<>0
							aConIva[nPosIva][2]:=aConIva[nPosIva][2]+SD2->D2_VALIMP1
							aConIva[nPosIva][3]:=aConIva[nPosIva][3]+SD2->D2_BASIMP1
						Else
							Aadd(aConIva,{SB1->B1_CONCIVA,SD2->D2_VALIMP1,SD2->D2_BASIMP1})
						Endif
					ElseIf !lCalcAcm
						nPosIva:=ASCAN(aConIva,{|x| x[1]==SA2->A2_ACTRET})
						If nPosIva<>0
							aConIva[nPosIva][2]:=aConIva[nPosIva][2]+(SD2->D2_VALIMP1)
							aConIva[nPosIva][3]:=aConIva[nPosIva][3]+(SD2->D2_BASIMP1)
						Else
							Aadd(aConIva,{SA2->A2_ACTRET,SD2->D2_VALIMP1,SD2->D2_BASIMP1})
						Endif
					Endif
					SD2->(DbSkip())
				EndDo
			Endif
		Endif
		//����������������������������������������������������������������Ŀ
		//� Gravar Retenciones.                                            �
		//������������������������������������������������������������������
		For nCount:=1  to Len(aConIva)
			aConIva[nCount][2]   := Round(xMoeda(aConIva[nCount][2],SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1))
			aConIva[nCount][3]   := Round(xMoeda(aConIva[nCount][3],SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1))
			If cPaisLoc=="PAR"
             	nPerc:=aConIva[nCount][4]               
            EndIf

			AAdd(aSFEIVA,array(10))
			aSFEIVA[Len(aSFEIVA)][1] := SF2->F2_DOC         		//FE_NFISCAL
			aSFEIVA[Len(aSFEIVA)][2] := SF2->F2_SERIE       		//FE_SERIE
			aSFEIVA[Len(aSFEIVA)][3] := (aConIva[nCount][3]*nProp)*nSigno	//FE_VALBASE
			aSFEIVA[Len(aSFEIVA)][4] := (aConIva[nCount][2]*nProp)*nSigno	//FE_VALIMP
			If cPaisLoc=="PAR"
			   	aSFEIVA[Len(aSFEIVA)][5] := nPerc
			Else
				aSFEIVA[Len(aSFEIVA)][5] := Iif(lCalRet  .or.  lCalcVen,100,SA2->A2_PORIVA)      		//FE_PORCRET
			EndIf
			aSFEIVA[Len(aSFEIVA)][6] := 0
			aSFEIVA[Len(aSFEIVA)][9] := aConIva[nCount][1]  // Gravar CFOP da opera��o
			If cPaisloc = "PAR"
				aSFEIVA[Len(aSFEIVA)][10]:= aConIva[nCount][4] // Gravar A PORCENTAGEM DA ALIQUOTA
			Else
				aSFEIVA[Len(aSFEIVA)][10]:= aConIva[nCount][4]*100 // Gravar A PORCENTAGEM DA ALIQUOTA
			EndIf		
			If LEN(aConIva[1])==3 //pROVISORIO, PARA QUE NO DE ERROR EN BASES DESACTUALIZADAS
				If !lRetSerie
					SFF->(DbSetOrder(6))
					SFF->(DbSeek(xFilial("SFF")+"IVR"+aConIva[nCount][1]))
				Endif
				If SFF->(FOUND())
					If SA2->(FieldPos("A2_IVRVCOB")) > 0 .And. SA2->(FieldPos("A2_IVPCCOB")) > 0
						If SA2->A2_PORIVA < 100.00 .And. (Empty(SA2->A2_IVPCCOB) .Or. Dtos(SA2->A2_IVPCCOB) < Dtos(dDataBase))
							MsgAlert(OemToAnsi(STR0154)+SA2->A2_COD+OemToAnsi(STR0146)) //"La fecha de validad para la reducci�n del porcentaje de la retenci�n del IVA del proveedor ya se ha vencido. ". Ingrese una fecha valida para el proveedor en el archivo de proveedores."
							//Zera o array das retencoes de IVA...
							aSFEIVA := {}
							//Sai do loop...
							Exit
						EndIf

						If Empty(SA2->A2_IVRVCOB)
							aSFEIVA[Len(aSFEIVA)][6] := (aSFEIVA[Len(aSFEIVA)][4]*(SFF->FF_ALIQ/100))*(SA2->A2_PORIVA/100)
						ElseIf Dtos(SA2->A2_IVRVCOB) < Dtos(dDataBase)
							MsgAlert(OemToAnsi(STR0145)+SA2->A2_COD+OemToAnsi(STR0146)) //	"Ha vencido el perido de observacion del proveedor  "+SA2->A2_COD+". Ingrese una fecha valida para el proveedor en el archivo de proveedores."
							//Zera o array das retencoes de IVA...
							aSFEIVA := {}
							//Sai do loop...
							Exit
						Else
							aSFEIVA[Len(aSFEIVA)][6] := aSFEIVA[Len(aSFEIVA)][4]
						EndIf
					Else
						aSFEIVA[Len(aSFEIVA)][6] := (aSFEIVA[Len(aSFEIVA)][4]*(SFF->FF_ALIQ/100))*(Iif(lCalRet,100,SA2->A2_PORIVA)/100)
					EndIf

					nTotRet += aSFEIVA[Len(aSFEIVA)][6]
				ELSE
					DEFINE MSDIALOG oDlg4 FROM 65,0 To 218,312 Title OemToAnsi(STR0074) Pixel //"Inconsistencia"
					@ 2,3 To 51,150 Pixel of oDlg4
					//"La actividad ", " de IVA no esta registrada en la Tabla SFF"
					//"por lo tanto no se generara retenci�n de IVA. Si desea Continuar con la "
					//"Orden de Pago acepte, sino cancele. "
					@ 10,004 SAY OemToAnsi(STR0050)+ aConIva[nCount][1] +OemToAnsi(STR0051) PIXEL Of oDlg4
					@ 23,004 SAY OemToAnsi(STR0052)	PIXEL Of oDlg4
					@ 36,004 SAY OemToAnsi(STR0053) 	PIXEL	Of oDlg4
					DEFINE SBUTTON FROM 57,064  Type 1 Action (lRetOk	:=	.T.,oDlg4:End())    Pixel ENABLE Of oDlg4
					DEFINE SBUTTON FROM 57,104  Type 2 Action (lRetOk	:=	.F.,oDlg4:End())  Pixel ENABLE Of oDlg4
					Activate Dialog oDlg4 CENTERED
				Endif
			Else
				If SA2->(FieldPos("A2_IVRVCOB")) > 0 .And. SA2->(FieldPos("A2_IVPCCOB")) > 0
					If SA2->A2_PORIVA < 100.00 .And. (Empty(SA2->A2_IVPCCOB) .Or. Dtos(SA2->A2_IVPCCOB) < Dtos(dDataBase))
						MsgAlert(OemToAnsi(STR0154)+SA2->A2_COD+OemToAnsi(STR0146)) //"La fecha de validad para la reducci�n del porcentaje de la retenci�n del IVA del proveedor ya se ha vencido. ". Ingrese una fecha valida para el proveedor en el archivo de proveedores."
						//Zera o array das retencoes de IVA...
						aSFEIVA := {}
						//Sai do loop...
						Exit
					EndIf

					If lCalcNew
						If lCalRep .or. lCalcVen
							aSFEIVA[Len(aSFEIVA)][6] := (aSFEIVA[Len(aSFEIVA)][4])
						Else
							aSFEIVA[Len(aSFEIVA)][6] := (aSFEIVA[Len(aSFEIVA)][4]) *(SA2->A2_PORIVA/100)
						EndIf
					ElseIf Dtos(SA2->A2_IVRVCOB) < Dtos(dDataBase)
						MsgAlert(OemToAnsi(STR0146)+SA2->A2_COD+OemToAnsi(STR0147)) //	"Ha vencido el perido de observacion del proveedor  "+SA2->A2_COD+". Ingrese una fecha valida para el proveedor en el archivo de proveedores."
						//Zera o array das retencoes de IVA...
						aSFEIVA := {}
						//Sai do loop...
						Exit
					Else
						aSFEIVA[Len(aSFEIVA)][6] := aSFEIVA[Len(aSFEIVA)][4]
					EndIf

				EndIf
			Endif
			//����������������������������������������������������������������Ŀ
			//� Generar Titulo de Impuesto no Contas a Pagar.                  �
			//������������������������������������������������������������������
			aSFEIVA[Len(aSFEIVA)][7] := SE2->E2_VALOR
			aSFEIVA[Len(aSFEIVA)][8] := SE2->E2_EMISSAO
		Next
		//Levanta quanto ja foi retido para a factura corrente, para em seguida
		//abater do total calculado para retencao.
		SFE->(dbSetOrder(4))
		If SFE->(dbSeek(xFilial("SFE")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE+"I"))
			cChaveSFE := SFE->FE_FILIAL+SFE->FE_FORNECE+SFE->FE_LOJA+SFE->FE_NFISCAL+SFE->FE_SERIE+"I"
			While !SFE->(Eof()) .And. cChaveSFE == xFilial("SFE")+SFE->FE_FORNECE+SFE->FE_LOJA+SFE->FE_NFISCAL+SFE->FE_SERIE+"I"
				nTotRetSFE += SFE->FE_RETENC
				SFE->(dbSkip())
			End

			//Proporcionaliza o que ja foi retido e abate da retencao que
			//foi calculada.
			For nCount:= 1 To Len(aSFEIVA)
				aSFEIVA[nCount][6] -= (nTotRetSFE * (aSFEIVA[nCount][6] / nTotRet))
			Next nCount
		Else
			If nSaldo <= Abs(nTotRet) .And. !lAcmIva
				//Proporcionaliza o que ja foi retido e abate da retencao que
				//foi calculada.
				For nCount:= 1 To Len(aSFEIVA)
					aSFEIVA[nCount][6] := (nSaldo * (aSFEIVA[nCount][6] / nTotRet))
				Next nCount
			EndIf
		EndIf
		//Verifica se o valor de retencao calculado supera o valor
		//minimo a ser retido, caso seja inferior nao eh realizada
		//a retencao.
		If !lCalcAcm
			nTotRet := 0
			aEval(aSFEIVA,{|x| nTotRet += (x[6]*-1)})
			If SA2->(FieldPos("A2_IVRVCOB")) > 0
				If  nTotRet < SFF->FF_IMPORTE .And. Empty(SA2->A2_IVRVCOB)
					aEval(aSFEIVA,{|x| x[6] := 0})
				EndIf
			Else
				If  nTotRet < SFF->FF_IMPORTE
					aEval(aSFEIVA,{|x| x[6] := 0})
				EndIf
			Endif
		EndIf
	EndIf
EndIf

Return aSFEIVA

/*
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � CalcRetSU2  � Autor � Julio Cesar         � Data � 30.01.03 ���
��+----------+------------------------------------------------------------���
���Descri��o � Calcular e Gerar Retencoes de SUSS                         ���
��+----------+------------------------------------------------------------���
���Uso       � FINA085A                                                   ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
*/

/*
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � CalcRetIB2 � Autor � Jose Lucas          � Data � 25.06.98 ���
��+----------+------------------------------------------------------------���
���Descri��o � Calcular e Gerar Retencoes sobre IB Ingressos Brutos.      ���
��+----------+------------------------------------------------------------���
���Uso       � PAGO011                                                    ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
*/

/*
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
��|Fun��o    | MArray     | Autor | Julio Cesar         | Data | 03.09.03 |��
��+----------+-------------------------------------------------------------��
��|Descricao | Monta o array com os registros utilizados na Ordem de Pago |��
��+----------+------------------------------------------------------------|��
��|Uso       | FINA085A                                                   |��
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
*/
Static Function MArray(nI,cFilSE2,nCondAgr,aOrdPg)
Local nX := 0

Do Case
	Case nCondAgr <= 1 //Filial + Fornecedor + Loja
		nX := aScan(aOrdPg,{|x| x[1] == cFilSE2 .And. x[2] == aRecNoSE2[nI][2] .And. x[3] == aRecNoSE2[nI][3]})
	Case nCondAgr == 2 //Filial + Fornecedor
		nX := aScan(aOrdPg,{|x| x[1] == cFilSE2 .And. x[2] == aRecNoSE2[nI][2]})
	OtherWise //Filial
		nX := aScan(aOrdPg,{|x| x[1] == cFilSE2})
EndCase

If nX == 0
	Do Case
		Case nCondAgr <= 1 //Filial + Fornecedor + Loja
			AAdd(aOrdPg,{aRecNoSE2[nI][1],aRecNoSE2[nI][2],aRecNoSE2[nI][3],{aRecNoSE2[nI][8]}})
		Case nCondAgr == 2 //Filial + Fornecedor
			AAdd(aOrdPg,{aRecNoSE2[nI][1],aRecNoSE2[nI][2],"",{aRecNoSE2[nI][8]}})
		OtherWise //Filial
			AAdd(aOrdPg,{aRecNoSE2[nI][1],"","",{aRecNoSE2[nI][8]}})
	EndCase
Else
	AAdd(aOrdPg[nX][4],aRecNoSE2[nI][8])
EndIf

Return(Nil)

/*
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � CalcRetSLI � Autor � Julio Cesar         � Data � 30.01.03 ���
��+----------+------------------------------------------------------------���
���Descri��o � Calcular e Gerar Retencoes de Servico de Limpeza de Imoveis���
��+----------+------------------------------------------------------------���
���Uso       � FINA085A                                                   ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
*/
Static Function CalcRetSLI(cAgente,nSigno,nSaldo)
Local aSFESLI  := {}
Local nRateio  := 0
Local nValRet  := 0
Local nVlrBase := 0
Local nVlrTotal:= 0
Local nAliq    := 0
Local cChave   := ""
Local nI	   := 0
Local lCalcLimp	:=.T.

DEFAULT nSigno	:=	1
//+---------------------------------------------------------------------+
//� Obter Impostos somente qdo a Empresa Usuario for Agente de Reten��o.�
//+---------------------------------------------------------------------+
SA2->( dbSetOrder(1) )
If SA2->(DbSeek(If(lMsFil .And. !Empty(xFilial("SA2")) .And. xFilial("SF1") == xFilial("SE2"),SE2->E2_MSFIL,xFilial("SA2"))+SE2->E2_FORNECE+SE2->E2_LOJA)) .And. SA2->(FieldPos("A2_DTICALL")) > 0 ;
	.And. SA2->(FieldPos("A2_DTFCALL")) > 0  .And. !Empty(SA2->A2_DTICALL) .And. !Empty(SA2->A2_DTFCALL)
    If  ( Dtos(dDataBase)>= Dtos(SA2->A2_DTICALL) ) .And. ( Dtos(Ddatabase) <= Dtos(SA2->A2_DTFCALL) )
   		lCalcLimp	:=.F.
    EndIf
EndIf

If ExistBlock("F0851IMP")
	lCalcLimp:=ExecBlock("F0851IMP",.F.,.F.,{"SLI"})
EndIf
If Subs(cAgente,7,1) == "S" .And. lCalcLimp

	dbSelectArea("SF1")
	dbSetOrder(1)
	If lMsfil
		SF1->(dbSeek(SE2->E2_MSFIL+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA))
	Else
		dbSeek(xFilial("SF1")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA)
	EndIf
	While !Eof() .And. (Alltrim(SF1->F1_ESPECIE) <> AllTrim(SE2->E2_TIPO))
		dbSkip()
		Loop
	End

	If (AllTrim(SF1->F1_ESPECIE) == Alltrim(SE2->E2_TIPO)) .And. ;
		(Iif(lMsFil,SF1->F1_MSFIL,xFilial("SF1"))+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA == ;
		F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)

		nRateio := ( Round(xMoeda(nSaldo,SE2->E2_MOEDA,1,,5,aTxMoedas[Max(SE2->E2_MOEDA,1)][2]),MsDecimais(1)) / ROund(xMoeda(SF1->F1_VALBRUT,SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1)) )

		cChave := SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
		SD1->(DbSetOrder(1))
		If lMsFil
			SD1->(DbSeek(SF1->F1_MSFIL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
		Else
			SD1->(DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
		EndIf
		While !SD1->(Eof()) .And. Iif(lMsFil,SD1->D1_MSFIL,xFilial("SD1"))==SD1->D1_FILIAL .And. SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA == cChave
			If AllTrim(SD1->D1_ESPECIE) <> Alltrim(SF1->F1_ESPECIE)
				SD1->(DbSkip())
				Loop
			Endif

			SFF->(dbSetOrder(10))
			SFF->(dbSeek(xFilial()+"SLI"+SD1->D1_CF))
			If SFF->(Found())
				nAliq     := SFF->FF_ALIQ
				nVlrTotal += SD1->D1_TOTAL

				//Verifica as caracteristicas do TES para que os impostos
				//possam ser somados ao valor da base de calculo da retencao...
				aImpInf := TesImpInf(SD1->D1_TES)

				For nI := 1 To Len(aImpInf)
					//Caso o fornecedor seja "Responsable Inscripto" o IVA
					//nao eh considerado na soma dos impostos...
					If (SA2->A2_TIPO == "I")
						If !("IVA"$Trim(aImpInf[nI][01])) .And. (aImpInf[nI][03] <> "3")
							nVlrTotal += (SD1->(FieldGet(FieldPos(aImpInf[nI][02]))) * Iif(aImpInf[nI][03]=="1",1,-1))
						ElseIf ("IVA"$Trim(aImpInf[nI][01])) .And. (aImpInf[nI][03] == "3")
							nVlrTotal -= SD1->(FieldGet(FieldPos(aImpInf[nI][02])))
						EndIf
					Else
						If aImpInf[nI][03] <> "3"
							nVlrTotal += (SD1->(FieldGet(FieldPos(aImpInf[nI][02]))) * Iif(aImpInf[nI][03]=="1",1,-1))
						EndIf
					EndIf
				Next
			EndIf
			SD1->(dbSkip())
		End

		If nVlrTotal > 0
			nVlrBase := (nVlrTotal * nRateio)
			nValRet  := Round((nVlrBase*(nAliq/100))*nSigno,TamSX3("FE_VALIMP")[2])

			//����������������������������������������������������������������Ŀ
			//� Gravar Retenciones.                                            �
			//������������������������������������������������������������������
			AAdd(aSFESLI,array(6))
			aSFESLI[Len(aSFESLI)][1] := SF1->F1_DOC   //FE_NFISCAL
			aSFESLI[Len(aSFESLI)][2] := SF1->F1_SERIE //FE_SERIE
			aSFESLI[Len(aSFESLI)][3] := nSaldo	       //FE_VALBASE
			aSFESLI[Len(aSFESLI)][4] := nSaldo	       //FE_VALIMP
			aSFESLI[Len(aSFESLI)][5] := Round((nValRet*100)/nSaldo,2)//FE_PORCRET
			aSFESLI[Len(aSFESLI)][6] := nValRet
		EndIf
	EndIf
EndIf

Return aSFESLI

/*
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � CalcRetSL2  � Autor � Julio Cesar        � Data � 30.01.03 ���
��+----------+------------------------------------------------------------���
���Descri��o � Calcular e Gerar Retencoes de Servico de Limpeza de Imoveis���
��+----------+------------------------------------------------------------���
���Uso       � FINA085A                                                   ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
*/
Static Function CalcRetSL2(cAgente,nSigno,nSaldo)
Local aSFESLI  := {}
Local nRateio  := 0
Local nValRet  := 0
Local nVlrBase := 0
Local nVlrTotal:= 0
Local nAliq    := 0
Local cChave   := ""
Local nI	   := 0
Local 	lCalcLimp	:=.T.
DEFAULT nSigno:= -1

SA2->( dbSetOrder(1) )
If SA2->(DbSeek(If(lMsFil .And. !Empty(xFilial("SA2")) .And. xFilial("SF1") == xFilial("SE2"),SE2->E2_MSFIL,xFilial("SA2"))+SE2->E2_FORNECE+SE2->E2_LOJA)) .And. SA2->(FieldPos("A2_DTICALL")) > 0 ;
	.And. SA2->(FieldPos("A2_DTFCALL")) > 0  .And. !Empty(SA2->A2_DTICALL) .And. !Empty(SA2->A2_DTFCALL)
    If  ( Dtos(dDataBase)>= Dtos(SA2->A2_DTICALL) ) .And. ( Dtos(Ddatabase) <= Dtos(SA2->A2_DTFCALL) )
   		lCalcLimp	:=.F.
    EndIf
EndIf

If ExistBlock("F0851IMP")
	lCalcLimp:=ExecBlock("F0851IMP",.F.,.F.,{"SL2"})
EndIf

//+---------------------------------------------------------------------+
//� Obter Impostos somente qdo a Empresa Usuario for Agente de Reten��o.�
//+---------------------------------------------------------------------+
If Subs(cAgente,7,1) == "S"   .And. lCalcLimp

	dbSelectArea("SF2")
	dbSetOrder(1)
	If lMsFil
		SF2->(dbSeek(SE2->E2_MSFIL+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA))
	Else
		SF2->(dbSeek(xFilial("SF2")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA))
	EndIf
	While !Eof() .And. (Alltrim(SF2->F2_ESPECIE) <> AllTrim(SE2->E2_TIPO))
		DbSkip()
		Loop
	Enddo

	If (AllTrim(SF2->F2_ESPECIE) == Alltrim(SE2->E2_TIPO)) .And. ;
		(Iif(lMsFil,SF2->F2_MSFIL,xFilial("SF2"))+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA == ;
		F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)

		nRateio := ( Round(xMoeda(nSaldo,SE2->E2_MOEDA,1,,5,aTxMoedas[Max(SE2->E2_MOEDA,1)][2]),MsDecimais(1)) / Round(xMoeda(SF2->F2_VALBRUT,SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1)) )

		cChave := SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA
		SD2->(DbSetOrder(3))
		If lMsFil
			SD2->(DbSeek(SF2->F2_MSFIL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
		Else
			SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
		EndIf

		While !SD2->(Eof()) .And. Iif(lMsfil,SD2->D2_MSFIL,xFilial("SD2"))==SD2->D2_FILIAL .And. SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == cChave
			If AllTrim(SD2->D2_ESPECIE) <> Alltrim(SF2->F2_ESPECIE)
				SD2->(DbSkip())
				Loop
			Endif

			SFF->( Iif(SD2->D2_CF < "500",dbSetOrder(10),dbSetOrder(12)) )
			SFF->(dbSeek(xFilial()+"SLI"+SD2->D2_CF))
			If SFF->(Found())
				nAliq     := SFF->FF_ALIQ
				nVlrTotal += SD2->D2_TOTAL

				//Verifica as caracteristicas do TES para que os impostos
				//possam ser somados ao valor da base de calculo da retencao...
				aImpInf := TesImpInf(SD2->D2_TES)

				For nI := 1 To Len(aImpInf)
					//Caso o fornecedor seja "Responsable Inscripto" o IVA
					//nao eh considerado na soma dos impostos...
					If (SA2->A2_TIPO == "I")
						If !("IVA"$Trim(aImpInf[nI][01])) .And. (aImpInf[nI][03] <> "3")
							nVlrTotal += (SD2->(FieldGet(FieldPos(aImpInf[nI][02]))) * Iif(aImpInf[nI][03]=="1",1,-1))
						ElseIf ("IVA"$Trim(aImpInf[nI][01])) .And. (aImpInf[nI][03] == "3")
							nVlrTotal -= SD2->(FieldGet(FieldPos(aImpInf[nI][02])))
						EndIf
					Else
						If aImpInf[nI][03] <> "3"
							nVlrTotal += (SD2->(FieldGet(FieldPos(aImpInf[nI][02]))) * Iif(aImpInf[nI][03]=="1",1,-1))
						EndIf
					EndIf
				Next
			EndIf
			SD2->(dbSkip())
		End

		If nVlrTotal > 0
			nVlrBase := (nVlrTotal * nRateio)
			nValRet  := Round((nVlrBase*(nAliq/100))*nSigno,TamSX3("FE_VALIMP")[2])

			//����������������������������������������������������������������Ŀ
			//� Gravar Retenciones.                                            �
			//������������������������������������������������������������������
			AAdd(aSFESLI,array(6))
			aSFESLI[Len(aSFESLI)][1] := SF2->F2_DOC   //FE_NFISCAL
			aSFESLI[Len(aSFESLI)][2] := SF2->F2_SERIE //FE_SERIE
			aSFESLI[Len(aSFESLI)][3] := nSaldo	       //FE_VALBASE
			aSFESLI[Len(aSFESLI)][4] := nSaldo	       //FE_VALIMP
			aSFESLI[Len(aSFESLI)][5] := Round((nValRet*100)/nSaldo,2)//FE_PORCRET
			aSFESLI[Len(aSFESLI)][6] := nValRet
		EndIf
	EndIf
EndIf

Return aSFESLI

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F085AGrvTx  �Autor  �Cristiano Denardi   � Data �22.01.2004 ���
�������������������������������������������������������������������������͹��
���Desc.     �Grava taxa da Moeda em SEK para qdo existirem campos        ���
���Desc.     �correspondentes ( da moeda 2 ate n informada)               ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function F085AGrvTx()
Local nTx := 0

For nTx := 2 To Len(aTxMoedas)
	If ( SEK->(FieldPos("EK_TXMOE"+StrZero(nTx,2))) > 0 )
		SEK->&("EK_TXMOE"+StrZero(nTx,2)) := aTxMoedas[nTx][2]
	Endif
Next nTx

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA085Pesq   �Autor  �Paulo Augusto       � Data �20.02.2004 ���
�������������������������������������������������������������������������͹��
���Desc.     �Pesquisa a tea de Fornecedor que e acionada via F4          ���
�������������������������������������������������������������������������͹��
���Variaveis �lIndice: Se muda o Indice                                   ���
���          �cPesq: Chave de Pesquisa ou indice selecionado              ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function FA085Pesq(lIndice,cPesq)
Local nRec:=Sa2->(Recno())
If lIndice
	SA2->(DbSetOrder(cPesq))
Else
	If !(SA2->(dBseek(xFilial("SA2")+Alltrim(cPesq ))))
		SA2->(DbGoto(nRec))
	EndIf
EndIf
oBrwForn:Refresh()

Return

Static Function RateioCond(aRateio)
Local cCodCond	:=	''
Local lRet		:=	.T.
Local nTotRat	:=	0
Local nX			:=	0
Local aHelpEsp,aHelpPor,aHelpEng
Local cConcGan	:=	Iif(SA2->A2_TIPO == "M" .And. SA2->(FieldPos("A2_CMONGAN"))>0,SA2->A2_CMONGAN,SA2->A2_AGREGAN)
Local cFornece	:=	SA2->A2_COD
Local cLoja		:=	SA2->A2_LOJA
Local cFilFor	:= SA2->A2_FILIAL
Local lCalcRetTo := .F.
aRatCond:={}
aRateio	:=	{}
lCalcRetTo:= If (SA2->(FieldPos("A2_CALRETT")) > 0,Iif(!Empty(SA2->A2_CALRETT),SA2->A2_CALRETT,.F.),lCalcRetTo)

If SA2->(FieldPos("A2_CODCOND")*FieldPos("A2_CONDO")*FieldPos("A2_PERCCON")) > 0 .And.SA2->A2_CONDO == "1"
	cCodCond := SA2->A2_CODCOND
	DbSelectArea("SA2")
	DbSetOrder(1)
	DbSeek(xFilial("SA2")+cCodCond)
	//*FAZ RATEIO ENTRE OS CONDOMINOS*//
	While !EOF() .And. xFilial("SA2") == SA2->A2_FILIAL .And. cCodCond == SA2->A2_CODCOND
		If SA2->A2_CONDO =="2"//*SE CONDOMINO*//
		   AAdd(aRateio,{A2_CONDO,A2_COD,A2_LOJA,A2_PERCCON/100,Iif(A2_TIPO == "M" .And. SA2->(FieldPos("A2_CMONGAN"))>0,A2_CMONGAN,A2_AGREGAN) })
		   If lCalcRetTo
		   		AAdd(aRatCond,{A2_CONDO,A2_COD,A2_LOJA,A2_PERCCON/100,Iif(A2_TIPO == "M" .And. SA2->(FieldPos("A2_CMONGAN"))>0,A2_CMONGAN,A2_AGREGAN) })
		   	EndIf
		Endif
		DbSkip()
	Enddo
	If Len(aRateio)==0//*CASO NAO SEJAM ACHADOS CONDOMINOS*//
		AAdd(aRateio,{'',cFornece,cLoja,1,cConcGan,cFilFor})
	Endif
Else
	AAdd(aRateio,{'',cFornece,cLoja,1,cConcGan,cFilFor})
Endif

For nX:= 1 To Len(aRateio)
	nTotRat	+=	aRateio[nX][4]
Next
If Round(nTotRat,0) <> 1
	Help(" ",1,"A085ACOND")
	lRet	:=	.F.
Endif
If lCalcRetTo
	aRateio:={}
	AAdd(aRateio,{'',cFornece,cLoja,1,cConcGan,cFilFor})
EndIf
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FINA085A  �Autor  �Microsiga           �Fecha �  12-16-04   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function A085AWhen()
Local lRet := .T.
If Substr(ReadVar(),4,9) == "EK_DEBITO"
	lRet	:=	(aCols[n][1]=="1").And.(aCols[n][7] <= dDataBase .And. !Empty(aCols[n][7]))
Endif
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FINA085A  �Autor  �Bruno Sobieski      �Fecha �  12-16-04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna a moeda do pagamento                                ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GetMoedPag(aPgtos)
Local aMoedas	:=	{}
Local nK	:=	0
If aPgtos == Nil   // default, sem pago diferenciado
	SA6->(DbSeek(xFilial()+cBanco+cAgencia+cConta))
	aMoedas	:=	{Max(Iif(SA6->(FieldPos("A6_MOEDAP")) > 0 .And. SA6->A6_MOEDAP>0,SA6->A6_MOEDAP,SA6->A6_MOEDA),1)}
Else
	If aPgtos[1]	<> 4
		SA6->(DbSeek(xFilial()+aPgtos[2]+aPgtos[3]+aPgtos[4]))
		aMoedas	:=	{Max(Iif(SA6->(FieldPos("A6_MOEDAP")) > 0 .And. SA6->A6_MOEDAP>0,SA6->A6_MOEDAP,SA6->A6_MOEDA),1)}
	Else
		For nk := 1 to Len(aPgtos[2])
			If Ascan(aMoedas,aPgtos[2][nK][nPosMoeda])==0
				AAdd(aMoedas,aPgtos[2][nK][nPosMoeda])
			Endif
		Next
	EndIf
EndIf
Return aMoedas

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �a085aSaldVl�Autor  �Paulo Augusto       � Data �  28/02/05  ���
�������������������������������������������������������������������������͹��
���Desc.     �Validacao da digitacao do valor informado                   ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085a                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function a085aSaldVl(oSaldo,oVlPago,nVlPago,aSe2,nPos,oValorPg,lModif)
Local aRateioGan :={}
Local nI,nP
DEFAULT lModif := .T.

aVlPA[_PA_VLATU] := nVlPago

If nVlPago > 0
	For nI:=1 To Len(aSE2[nPos][1])
		aVlPA[_PA_VLATU] -=  Round(xMoeda(aSE2[nPos][1][nI][_PAGAR],aSE2[nPos][1][nI][_MOEDA],aVlPA[_PA_MOEATU],,5,aTxMoedas[aSE2[nPos][1][nI][_MOEDA]][2],aTxMoedas[aVlPA[_PA_MOEATU]][2]),MsDecimais(aVlPA[_PA_MOEATU])   )
	Next
Endif
If aVlPA[_PA_VLATU]<= 0 .And. nVlPago > 0
	Aviso(STR0163,STR0166 + STR0167 + STR0168,{"OK"} ) //"Valor"###"Este campo so devera ser"###"informado quando o valor "###"a pagar for maior que o total"
	aVlPA[_PA_VLATU]:= aVlPA[_PA_MOEANT]
	nVlPago:=0
	oValorPg:Refresh()
	Return(.F.)
EndIf
If aVlPA[_PA_VLANT] <> aVlPA[_PA_VLATU] .Or. aVlPA[_PA_MOEANT] <> aVlPA[_PA_MOEATU]
	If aVlPA[_PA_MOEANT]>0
		a085aSaldos(aVlPA[_PA_VLANT],	aVlPA[_PA_MOEANT], -1)
	EndIf
	If aVlPA[_PA_MOEATU] > 0
		a085aSaldos(aVlPA[_PA_VLATU],	aVlPA[_PA_MOEATU],  1)
    EndIf
	For nP	:=	1	To	Len(aSE2[nPos][2])
		a085aSaldos(aSE2[nPos][2][nP][5],1, 1)
	Next nP
	cFornece :=	aPagos[nPos][H_FORNECE]
	cLoja    := aPagos[nPos][H_LOJA]

	SA2->( dbSetOrder(1) )
	SA2->( dbSeek(xFilial("SA2")+cFornece+cLoja) )
	If !RateioCond(@aRateioGan)
		aSE2	:=	{}
	Endif

	nValorPA1	:=	Round(xMoeda(aVlPA[_PA_VLATU],aVlPA[_PA_MOEATU],1,,5,aTxMoedas[aVlPA[_PA_MOEATU]][2]),MsDecimais(1))

	a085aRecal(nPos,aSE2,,,0,,0,,0,,0,,0,,,0,,0,,nValorPA1,,aRateioGan,lModif,.F.)

	For nP	:=	1	To	Len(aSE2[nPos][2])
		a085aSaldos(aSE2[nPos][2][nP][5],1, -1)
	Next nP

	aVlPA[_PA_MOEANT]	:=	aVlPA[_PA_MOEATU]
	aVlPA[_PA_VLANT]	:=	aVlPA[_PA_VLATU]
EndIf
Return .T.

Function a085DelLn(n1,n2,n3,n4)
Local nPosMoeda	:=	Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_MOEDA"})
Local nPosVlr	:=	Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_VALOR"})
nDel := nDel +1

If(nDel%2)==0
	Return()
EndIf

If aCols[n][Len(aCols[n])]
	a085aSaldos(aCols[n][nPosVlr],	Val(aCols[n][nPosMoeda]), -1)
Else
	a085aSaldos(aCols[n][nPosVlr],	Val(aCols[n][nPosMoeda]), 1)
Endif

If Type("oSaldo")<> "U" .And. oSaldo <> Nil
	oSaldo:Refresh()
Endif
Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �a085aSalPa �Autor  �Paulo Augusto       � Data �  04/03/05  ���
�������������������������������������������������������������������������͹��
���Desc.     �Linha OK   da digitacao dos titulos usados para pagar       ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085a                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function a085aSalPa(oSaldo,lPa)
Local nPosMoe		:=	Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_MOEDA"})
Local nPosValor 	:=	Ascan(aHeader,{|X| Alltrim(X[2]) == "EK_VALOR"})
Local nX
Local aSldTmp	:=	aClone(aSaldos)

lPa	:=	Iif(lPA=Nil,.F.,lPA)
If lRetPA == Nil
	lRetPA := (GetNewPar("MV_RETPA","N") == "S")
EndIf
If lPa
	aFill(aSldTmp,0)
Endif

For nX	:=	1	To	Len(aCols)
	If Val(aCols[nX][nPosMoe])	>	0 .And. !aCols[nX][Len(aCols[nX])]
		aSldTmp[Val(aCols[nX][nPosMoe])]	+=	aCols[nX][nPosValor] * Iif(lPa,1,-1)
	Endif
Next

aSaldos[Len(aSaldos)]	:=	0
For nX	:=	1	To	Len(aTxMoedas)
	If lPa .And. !lRetPa
		aSaldos[Len(aSaldos)]	+=	Round(xMoeda(aSldTmp[nX],nX,nMoedaCor,,5,aTxMoedas[nX][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
	Else
		aSaldos[Len(aSaldos)]	+=	Round(xMoeda(aSldTmp[nX],nX,nMoedaCor,,5,aTxMoedas[nX][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
	Endif
Next

// Arredonda o total em moeda corrente. (Apresentava msg de saldo insuficiente por problema de arredondamento.) // Guilherme
aSaldos[Len(aSaldos)] := Round(aSaldos[Len(aSaldos)],MsDecimais(nMoedaCor))
If lPa .And. !lRetPA
	nValor	:=	aSaldos[Len(aSaldos)]
	oValor:Refresh()
Endif

If oSaldo <> Nil
	oSaldo:Refresh()
Endif
Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F085CalRet �Autor  �Paulo Augusto       � Data �  04/04/05  ���
�������������������������������������������������������������������������͹��
���Desc.     �Recalculo das Retencoes para Sujeitos Multiplos             ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085a                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function F085CalRet(aRatCond,aRets)
Local aRetCond := {}
Local nI:=1
Local nValBase:= 0
Local nValImp := 0
Local nValRet := 0
Local nValDedu:= 0

For nI:= 1 to Len(aRatCond)
	nValBase:=aRets[1][2] * aRatCond[nI][4]
	nValImp :=aRets[1][4] * aRatCond[nI][4]
	nValRet :=aRets[1][5] * aRatCond[nI][4]
	nValDedu:=aRets[1][6] * aRatCond[nI][4]

	If aRatCond[nI][4] > 0
		Aadd(aRetCond,{"",nValBase,aRets[1][3],nValImp,nValRet,nValDedu,aRets[1][7],aRets[1][8],aRets[1][9],aRatCond[nI][2],aRatCond[nI][3]})
	EndIf
Next

Return(aRetCond)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Fa085RatSuss�Autor  �Paulo Augusto     �Fecha �  04/07/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rateio do SUSS Lei 1784                                    ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085a                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function Fa085RatSuss(cFornece,cLoja)
Local aAreaSA2:= SA2->(GetArea())
Local aRateio:= {}
Local lLey1784 :=.F.

DbSelectArea("SA2")
DbSetOrder(1)
DbSeek(xFilial("SA2")+cFornece+cLoja)
If SA2->(FieldPos("A2_PROVEMP")) > 0  .and. SA2->A2_PROVEMP == 1
	lLey1784 :=.T.
EndIf

If SA2->(FieldPos("A2_CODCOND")*FieldPos("A2_CONDO")*FieldPos("A2_PERCCON")) > 0 .And.SA2->A2_CONDO == "1"
	cCodCond := SA2->A2_CODCOND
	DbSelectArea("SA2")
	DbSetOrder(1)
	DbSeek(xFilial("SA2")+cCodCond)
	//*FAZ RATEIO ENTRE OS CONDOMINOS*//
	While !EOF() .And. xFilial("SA2") == SA2->A2_FILIAL .And. cCodCond == SA2->A2_CODCOND
		If SA2->A2_CONDO =="2"//*SE CONDOMINO*//
		   AAdd(aRateio,{A2_COD,A2_LOJA,A2_PERCCON/100,lLey1784})
		Endif
		DbSkip()
	Enddo
Endif

If Len(aRateio)==0//*CASO NAO SEJAM ACHADOS CONDOMINOS*//
	AAdd(aRateio,{cFornece,cLoja,1,lLey1784})
Endif

RestArea(aAreaSA2)

Return(aRateio)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Fa085VlM  �Autor  �Paulo Augusto       � Data �  14/09/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida a digitacao do valor da moeda selecionada            ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085a                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function Fa085VlM()
Local nPosVl	:=Ascan(aHeader1,{|x| Alltrim(x[2])=="NVLMDINF"})
Local nPosMoeda	:= Ascan(aHeader,{|x| Alltrim(x[2])=="E2_MOEDA"})
Local nPosPagar	:= Ascan(aHeader,{|x| Alltrim(x[2])=="E2_PAGAR"})
Local nPosValor	:=	Ascan(aHeader,{|x| Alltrim(X[2])=="E2_VALOR"})
Local nPosSaldo	:=	Ascan(aHeader,{|x| Alltrim(X[2])=="E2_SALDO"})
Local nPosMulta	:=	Ascan(aHeader,{|x| Alltrim(x[2])=="E2_JUROS"})
Local nPosJuros	:=	Ascan(aHeader,{|x| Alltrim(x[2])=="E2_MULTA"})
Local nPosDesco :=	Ascan(aHeader,{|x| Alltrim(x[2])=="E2_DESCONT"})
Local nVlrParcial := &(ReadVar())
Local nValorSaldo	:= 0
Local nPosVlParc	:= 	Ascan(aHeader,{|x| Alltrim(x[2])=="E2_VLBXPAR"})
Local lRet	:=	.T.
Local nVlrInf:=0
Local nValorInf:=0

lBxParc := IIf( Type("lBxParc")=="U", Iif(SE2->(FieldPos("E2_VLBXPAR")>0),.T.,.F.), lBxParc)

If nPosSaldo > 0 .or. nPosVlParc >0
	nValorInf := Iif(aCols[n][nPosVl]>=0,Round(xMoeda(nVlrParcial,nMoedaCor,aCols[n][nPosMoeda],,5,aTxmoedas[nMoedaCor][2],aTxmoedas[aCols[n][nPosMoeda]][2]),MsDecimais(aCols[n][nPosMoeda])),0)
	nValorSaldo := Iif(aCols[n][nPosSaldo]>0,aCols[n][nPosSaldo],0) + aCols[n][nPosPagar]
 	If lBxParc
		nValorSaldo :=Iif(aCols[n][nPosVlParc] > 0,aCols[n][nPosVlParc],nValorSaldo)
	EndIf
	If	nValorInf  > (nValorSaldo + aCols[n][nPosJuros]+ aCols[n][nPosMulta]) - aCols[n][nPosDesco]
		MsgStop(OemToAnsi(STR0119)) //"El valor tipeado es MAYOR que el saldo"
		lRet:=.F.
	ElseIf nValorInf < 0
		MsgStop(OemToAnsi(STR0120)) //"El valor debe ser MAYOR o IGUAL a 0"
		lRet:=.F.
	EndIf
Else
	MsgStop(OemToAnsi(STR0129)) //"Habilite el campo E2_SALDO via configurador"
	lRet:=.F.
Endif
If lRet
	aCols[n][nPosPagar]:= nValorInf
	aCols[n][nPosSaldo]:=nValorSaldo -  nValorInf
	aCols[n][nPosVl]:= M->NVLMDINF
EndIf
Return( lRet )

/*/
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MenuDef   � Autor � Ana Paula N. Silva     � Data �21/11/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Utilizacao de menu Funcional                               ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Array com opcoes da rotina.                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Parametros do array a Rotina:                               ���
���          �1. Nome a aparecer no cabecalho                             ���
���          �2. Nome da Rotina associada                                 ���
���          �3. Reservado                                                ���
���          �4. Tipo de Transa��o a ser efetuada:                        ���
���          �		1 - Pesquisa e Posiciona em um Banco de Dados     ���
���          �    2 - Simplesmente Mostra os Campos                       ���
���          �    3 - Inclui registros no Bancos de Dados                 ���
���          �    4 - Altera o registro corrente                          ���
���          �    5 - Remove o registro corrente do Banco de Dados        ���
���          �5. Nivel de acesso                                          ���
���          �6. Habilita Menu Funcional                                  ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MenuDef(nFlagMOD,nCtrlMOD)
Local lF085ABT := ExistBlock("F085ABT")
Local aRotina  := {	{ OemToAnsi(STR0007)  ,'PesqBrw(cChave,cIndex)',0,1},;  					//"Buscar"
					{ OemToAnsi(STR0009)  ,'AxVisual("SE2",SE2->(RECNO()),2)',0 ,2},;         	//"Visualizar"
					{ OemToAnsi(STR0010)  ,'A085APgAut(@nFlagMOD,@nCtrlMOD)'	,0 ,3},;		// Pago Automatico
					{ OemToAnsi(STR0136)  ,'A085APgAdi()'	,0 ,3},;							// Generar PA
					{ OemToAnsi(STR0070)  ,'FA085SETMO()',0,3},;								// Modificar tasas
					{ OemToAnsi(STR0239)  ,'fA085aLegenda()', 0 , 6, ,.F.}}                     // Leyenda

					If lF085ABT
			  			aRotina := Execblock ("F085ABT",.F.,.F.,aRotina)
					EndIf

Return(aRotina)

Static Function a085aGrRetMx()
Local aArea      := GetArea()
LOCAL aAreaSE2   := SE2->( GetArea() )
LOCAL _ValorBx1  := 0
Local _ValorBx2  := 0
Local _ValorBx3  := 0
Local _ValorBx4  := 0
Local _ValorBx5  := 0
Local _ValorBx6  := 0
Local _PerBx     := 0
Local _PerDesc   := 0
Local _ValorDc1  := 0
Local _ValorDc2  := 0
Local _ValorDc3  := 0
Local _ValorDc4  := 0
Local _ValorDc5  := 0
Local _ValorDc6  := 0
LOCAL _BaseBx1  := 0
Local _BaseBx2  := 0
Local _BaseBx3  := 0
Local _BaseBx4  := 0
Local _BaseBx5  := 0
Local _BaseBx6  := 0
LOCAL _AliqBx1  := 0
Local _AliqBx2  := 0
Local _AliqBx3  := 0
Local _AliqBx4  := 0
Local _AliqBx5  := 0
Local _AliqBx6  := 0

Local aGrvSE   := {} //campos das tabelas SEK e SE5 a serem gravados.
Local nX

dbSelectArea("SE2")
dbSetOrder(1)
dbSeek(xFilial("SE2")+SEK->EK_PREFIXO+SEK->EK_NUM+SEK->EK_PARCELA+SEK->EK_TIPO+SEK->EK_FORNECE+SEK->EK_LOJA)
If Found()

	_PerBx   := (SEK->EK_VALOR   * 100) / SE2->E2_VALOR
	_PerDesc := (SEK->EK_DESCONT * 100) / SE2->E2_VALOR

	If SE2->E2_VALIMP1 > 0
		_ValorBx1 := SE2->E2_VALIMP1 * (_PerBx / 100)
		_BaseBx1 := SE2->E2_BASIMP1 * (_PerBx / 100)
		_AliqBx1 := SE2->E2_ALQIMP1
	EndIf
	If SE2->E2_VALIMP2 > 0
		_ValorBx2 := SE2->E2_VALIMP2 * (_PerBx / 100)
		_BaseBx2 := SE2->E2_BASIMP2 * (_PerBx / 100)
		_AliqBx2 := SE2->E2_ALQIMP2
	EndIf
	If SE2->E2_VALIMP3 > 0
		_ValorBx3 := SE2->E2_VALIMP3 * (_PerBx / 100)
		_BaseBx3 := SE2->E2_BASIMP3 * (_PerBx / 100)
		_AliqBx3 := SE2->E2_ALQIMP3
	EndIf
	If SE2->E2_VALIMP4 > 0
		_ValorBx4 := SE2->E2_VALIMP4 * (_PerBx / 100)
		_BaseBx4 := SE2->E2_BASIMP4 * (_PerBx / 100)
		_AliqBx4 := SE2->E2_ALQIMP4
	EndIf
	If SE2->E2_VALIMP5 > 0
		_ValorBx5 := SE2->E2_VALIMP5 * (_PerBx / 100)
		_BaseBx5 := SE2->E2_BASIMP5 * (_PerBx / 100)
		_AliqBx5 := SE2->E2_ALQIMP5
	EndIf
	If SE2->E2_VALIMP6 > 0
		_ValorBx6 := SE2->E2_VALIMP6 * (_PerBx / 100)
		_BaseBx6 := SE2->E2_BASIMP6 * (_PerBx / 100)
		_AliqBx6 := SE2->E2_ALQIMP6
	EndIf
	If SEL->EL_DESCONT > 0 .and. SE2->E2_VALIMP1 > 0
		_ValorDc1  := SE2->E2_VALIMP1 * (_PerDesc / 100)
	EndIf
	If SEL->EL_DESCONT > 0 .and. SE2->E2_VALIMP2 > 0
		_ValorDc2  := SE2->E2_VALIMP2 * (_PerDesc / 100)
	EndIf
	If SEL->EL_DESCONT > 0 .and. SE2->E2_VALIMP3 > 0
		_ValorDc3  := SE2->E2_VALIMP3 * (_PerDesc / 100)
	EndIf
	If SEL->EL_DESCONT > 0 .and. SE2->E2_VALIMP4 > 0
		_ValorDc4  := SE2->E2_VALIMP4 * (_PerDesc / 100)
	EndIf
	If SEL->EL_DESCONT > 0 .and. SE2->E2_VALIMP5 > 0
		_ValorDc5  := SE2->E2_VALIMP5 * (_PerDesc / 100)
	EndIf
	If SEL->EL_DESCONT > 0 .and. SE2->E2_VALIMP6 > 0
		_ValorDc6  := SE2->E2_VALIMP6 * (_PerDesc / 100)
	EndIf

	//Campos da tabela SEK
	//             Tab.      Campo        Valor
	Aadd(aGrvSE, {"SEK", "EK_VALIMP1", _ValorBx1})
	Aadd(aGrvSE, {"SEK", "EK_VALIMP2", _ValorBx2})
	Aadd(aGrvSE, {"SEK", "EK_VALIMP3", _ValorBx3})
	Aadd(aGrvSE, {"SEK", "EK_VALIMP4", _ValorBx4})
	Aadd(aGrvSE, {"SEK", "EK_VALIMP5", _ValorBx5})
	Aadd(aGrvSE, {"SEK", "EK_VALIMP6", _ValorBx6})
	Aadd(aGrvSE, {"SEK", "EK_BASIMP1", _BaseBx1})
	Aadd(aGrvSE, {"SEK", "EK_BASIMP2", _BaseBx2})
	Aadd(aGrvSE, {"SEK", "EK_BASIMP3", _BaseBx3})
	Aadd(aGrvSE, {"SEK", "EK_BASIMP4", _BaseBx4})
	Aadd(aGrvSE, {"SEK", "EK_BASIMP5", _BaseBx5})
	Aadd(aGrvSE, {"SEK", "EK_BASIMP6", _BaseBx6})
	Aadd(aGrvSE, {"SEK", "EK_ALQIMP1", _AliqBx1})
	Aadd(aGrvSE, {"SEK", "EK_ALQIMP2", _AliqBx2})
	Aadd(aGrvSE, {"SEK", "EK_ALQIMP3", _AliqBx3})
	Aadd(aGrvSE, {"SEK", "EK_ALQIMP4", _AliqBx4})
	Aadd(aGrvSE, {"SEK", "EK_ALQIMP5", _AliqBx5})
	Aadd(aGrvSE, {"SEK", "EK_ALQIMP6", _AliqBx6})
	Aadd(aGrvSE, {"SEK", "EK_IMPDES1", _ValorDc1})
	Aadd(aGrvSE, {"SEK", "EK_IMPDES2", _ValorDc2})
	Aadd(aGrvSE, {"SEK", "EK_IMPDES3", _ValorDc3})
	Aadd(aGrvSE, {"SEK", "EK_IMPDES4", _ValorDc4})
	Aadd(aGrvSE, {"SEK", "EK_IMPDES5", _ValorDc5})
	Aadd(aGrvSE, {"SEK", "EK_IMPDES6", _ValorDc6})

	//Campos da tabela SE5
	//             Tab.      Campo        Valor
	Aadd(aGrvSE, {"SE5", "E5_VALIMP1", _ValorBx1})
	Aadd(aGrvSE, {"SE5", "E5_VALIMP2", _ValorBx2})
	Aadd(aGrvSE, {"SE5", "E5_VALIMP3", _ValorBx3})
	Aadd(aGrvSE, {"SE5", "E5_VALIMP4", _ValorBx4})
	Aadd(aGrvSE, {"SE5", "E5_VALIMP5", _ValorBx5})
	Aadd(aGrvSE, {"SE5", "E5_VALIMP6", _ValorBx6})
	Aadd(aGrvSE, {"SE5", "E5_BASIMP1", _BaseBx1})
	Aadd(aGrvSE, {"SE5", "E5_BASIMP2", _BaseBx2})
	Aadd(aGrvSE, {"SE5", "E5_BASIMP3", _BaseBx3})
	Aadd(aGrvSE, {"SE5", "E5_BASIMP4", _BaseBx4})
	Aadd(aGrvSE, {"SE5", "E5_BASIMP5", _BaseBx5})
	Aadd(aGrvSE, {"SE5", "E5_BASIMP6", _BaseBx6})
	Aadd(aGrvSE, {"SE5", "E5_ALQIMP1", _AliqBx1})
	Aadd(aGrvSE, {"SE5", "E5_ALQIMP2", _AliqBx2})
	Aadd(aGrvSE, {"SE5", "E5_ALQIMP3", _AliqBx3})
	Aadd(aGrvSE, {"SE5", "E5_ALQIMP4", _AliqBx4})
	Aadd(aGrvSE, {"SE5", "E5_ALQIMP5", _AliqBx5})
	Aadd(aGrvSE, {"SE5", "E5_ALQIMP6", _AliqBx6})

	//verifica se o campo existe e grava o valor na tabela
	For nX := 1 to Len(aGrvSE)
		//aGrvSE[nX,1] = Tabela
		//aGrvSE[nX,2] = Campo
		//aGrvSE[nX,3] = Valor a ser atribuido no campo

		//verifica se o campo existe.
		If (aGrvSE[nX,1])->(FieldPos(aGrvSE[nX,2]))> 0
			RecLock(aGrvSE[nX,1], .F.)
			//atribui��o de valor no campo, caso o mesmo exista.
			(aGrvSE[nX,1])->&(aGrvSE[nX,2]) := aGrvSE[nX,3]
			MsUnlock()
		Endif
	Next nX

	dbSelectArea("SEK")
	//����������������������������������������������������������Ŀ
	//� Grava os lancamentos nas contas orcamentarias SIGAPCO    �
	//������������������������������������������������������������
	If SEK->EK_TIPODOC == "TB"
		PcoDetLan("000313","01","FINA085A")

	ElseIf SEK->EK_TIPODOC == "PA"
		PcoDetLan("000313","02","FINA085A")

	ElseIf SEK->EK_TIPODOC == "CT"
		PcoDetLan("000313","03","FINA085A")

	ElseIf SEK->EK_TIPODOC == "CP"
		PcoDetLan("000313","04","FINA085A")

	ElseIf SEK->EK_TIPODOC == "RG"
		PcoDetLan("000313","05","FINA085A")

	EndIf

EndIf

RestArea( aAreaSE2)
RestArea( aArea )

RETURN .T.

/*
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � CalcRetIR� Autor � Paulo Augusto       � Data � 18.07.06 ���
��+----------+------------------------------------------------------------���
���Descri��o � Calcular e Gerar Retencoes de IR .                        ���
��+----------+------------------------------------------------------------���
���Uso       � FINA085A                                                   ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
*/
Static Function CalcRetIR(cAgente,nSigno,nSaldo)
Local nValBrut := 0
Local aSFEIR := {}
Local lCalcula	:=.F.
Local aArea:=GetArea()
Local nTotIR := 0
Local nValIR := 0 
Local nTotBase := 0
Local nBaseIR := 0
Local nAliqIR := 0
Local nI
DEFAULT nSigno := 1

If cPaisLoc == "PAR"
	aAreaSE2:=GetArea()
	dbSelectArea("SF1")
	dbSetOrder(1)
	dbSeek(xFilial("SF1")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA)
	 aArea:=GetArea()
	dbSelectArea("SD1")
	SD1->(DbSetOrder(1))
	SD1->(DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
	Do while xFilial("SD1")==SD1->D1_FILIAL.And.SF1->F1_DOC==SD1->D1_DOC.AND.;
	SF1->F1_SERIE==SD1->D1_SERIE.AND.SF1->F1_FORNECE==SD1->D1_FORNECE;
	.AND.SF1->F1_LOJA==SD1->D1_LOJA.AND.!SD1->(EOF())
		aImpInf := TesImpInf(SD1->D1_TES)   
		For nI := 1 To Len(aImpInf) 
			If "RIR"$Trim(aImpInf[nI][01]) .Or. "R15"$Trim(aImpInf[nI][01])			 
				nValIR:=SD1->(FieldGet(FieldPos(aImpInf[nI][02]))) 
				nBaseIR:=SD1->(FieldGet(FieldPos(aImpInf[nI][07]))) 
				nAliqIR := SD1->(FieldGet(FieldPos(aImpInf[nI][10]))) 
				nTotIR += nValIR                               
				nTotBase += nBaseIR 
			Endif	
		Next                                   
	 SD1->(DbSkip())	
	Enddo		

	
	nProp := Round(xMoeda(nSaldo,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,5)/xMoeda(se2->e2_valor,SE2->E2_MOEDA,1,,5),3)
	nTotBase :=	nTotBase * nProp
	nTotImpIR := nTotIR * nProp
	RestArea(aArea)
	
	

	If AllTrim(SF1->F1_ESPECIE)==Alltrim(SE2->E2_TIPO).And.;
				xFilial("SF1")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA==;
				SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA   
	
				AAdd(aSFEIR,array(9))
				aSFEIR[Len(aSFEIR)][1] := SF1->F1_DOC         		//FE_NFISCAL
				aSFEIR[Len(aSFEIR)][2] := SF1->F1_SERIE       		//FE_SERIE
				aSFEIR[Len(aSFEIR)][3] := Round(xMoeda(nTotBase,SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1))* nSigno	//FE_VALBASE
				aSFEIR[Len(aSFEIR)][4] := Round(xMoeda(nTotImpIR,SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1))* nSigno	//FE_VALIMP
				aSFEIR[Len(aSFEIR)][5] := SA2->A2_PORIVA
				aSFEIR[Len(aSFEIR)][6] := aSFEIR[Len(aSFEIR)][4]
				aSFEIR[Len(aSFEIR)][7] := SE2->E2_VALOR
				aSFEIR[Len(aSFEIR)][8] := SE2->E2_EMISSAO   
				aSFEIR[Len(aSFEIR)][9] := nAliqIR
	EndIf
	RestArea(aAreaSE2)	
//+---------------------------------------------------------------------+
//� Obter Impostos somente qdo a Empresa Usuario for Agente de Reten��o.�
//+---------------------------------------------------------------------+
ElseIf  SA2->(FieldPos("A2_RETIR"))>0 

	DbSelectArea("SED")
	If SED->(FieldPos("ED_IRALIQ"))>0                     
	   	If (SED->(dbSeek(xFilial("SED")+SE2->E2_NATUREZ) )) 
		    nAliq :=SED->ED_IRALIQ
			lCalcula:=.T.
		EndIf	
	EndIf                                           

EndIf
RestArea(aArea)
//+---------------------------------------------------------------------+
//� Obter Impostos somente qdo a Empresa Usuario for Agente de Reten��o.�
//+---------------------------------------------------------------------+
If  SA2->(FieldPos("A2_RETIR"))>0 .And. lCalcula

	SA2->( dbSetOrder(1) )
	SA2->( dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA) )

	//����������������������������������������������������������������Ŀ
	//� Verifica se o fornecedor retem IR e se e estrangeiro              �
	//������������������������������������������������������������������
	//����������������������������������������������������������������Ŀ
	//� Calcula a retencao.                                            �
	//������������������������������������������������������������������
	nValBrut := Round(xMoeda(nSaldo,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,5,aTxMoedas[Max(SE2->E2_MOEDA,1)][2]),MsDecimais(1))

	AAdd(aSFEIR,array(8))
	aSFEIR[Len(aSFEIR)][1] := SE2->E2_NUM      //FE_NFISCAL
	aSFEIR[Len(aSFEIR)][2] := SE2->E2_PREFIXO  //FE_SERIE
	aSFEIR[Len(aSFEIR)][3] := nValBrut*nSigno	//FE_VALBASE
	aSFEIR[Len(aSFEIR)][4] := nValBrut*nSigno  //FE_VALIMP
	aSFEIR[Len(aSFEIR)][5] := nAliq  //FE_PORCRET
	aSFEIR[Len(aSFEIR)][6] := (aSFEIR[Len(aSFEIR)][4]*(nAliq/100))

	//����������������������������������������������������������������Ŀ
	//� Generar Titulo de Impuesto no Contas a Pagar.                  �
	//������������������������������������������������������������������
	aSFEIR[Len(aSFEIR)][7] := SE2->E2_VALOR
	aSFEIR[Len(aSFEIR)][8] := SE2->E2_EMISSAO

EndIf

Return aSFEIR


/*
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � CalcRetIRC � Autor � Bruno Sobieski      � Data � 18.05.08 ���
��+----------+------------------------------------------------------------���
���Descri��o � Calcular e Gerar Retencoes sobre IRC (Portugal)            ���
��+----------+------------------------------------------------------------���
���Uso       � PAGO007                                                    ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
*/
Static Function CalcRetIRC(nSigno,nSaldo)
Local lCalcImp	:=	.T.
Local aSFEIRC	:=	{}
DEFAULT nSigno	:=	1

If ExistBlock("F0851IMP")
	lCalcImp:=ExecBlock("F0851IMP",.F.,.F.,{"IRC",nSigno})
EndIf

If lCalcImp
	If nSigno == 1
		//���������������������������������������������������������������������Ŀ
		//� Fornecedor � Reter IRC                                              �
		//�����������������������������������������������������������������������
		If SA2->A2_RETIRC == "1"

			While Alltrim(SF1->F1_ESPECIE) <> AllTrim(SE2->E2_TIPO).And.SF1->(!EOF())
				SF1->(DbSkip())
				Loop
			Enddo

			If AllTrim(SF1->F1_ESPECIE)==Alltrim(SE2->E2_TIPO).And.;
				xFilial("SF1")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA==;
				F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA

				AAdd(aSFEIRC,array(8))
				aSFEIRC[Len(aSFEIRC)][1] := SF1->F1_DOC         		//FE_NFISCAL
				aSFEIRC[Len(aSFEIRC)][2] := SF1->F1_SERIE       		//FE_SERIE
				aSFEIRC[Len(aSFEIRC)][3] := Round(xMoeda(SF1->F1_BASIMP2,SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1))*nSaldo/SE2->E2_VALOR * nSigno	//FE_VALBASE
				aSFEIRC[Len(aSFEIRC)][4] := 100
				aSFEIRC[Len(aSFEIRC)][5] := Round(xMoeda(SF1->F1_VALIMP2a,SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1))*nSaldo/SE2->E2_VALOR * nSigno	//FE_VALIMP
				aSFEIRC[Len(aSFEIRC)][6] := aSFEIRC[Len(aSFEIRC)][5]
				aSFEIRC[Len(aSFEIRC)][7] := SE2->E2_VALOR
				aSFEIRC[Len(aSFEIRC)][8] := SE2->E2_EMISSAO
			Endif
		Endif

	Else
		dbSelectArea("SF2")
		dbSetOrder(1)
		dbSeek(xFilial("SF2")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA)
		SA2->( dbSetOrder(1) )
		SA2->( dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA) )

		//���������������������������������������������������������������������Ŀ
		//� Fornecedor � Reter IRC                                              �
		//�����������������������������������������������������������������������
		If SA2->A2_RETIRC == "1"

			While Alltrim(SF2->F2_ESPECIE)<>AllTrim(SE2->E2_TIPO).And.!EOF()
				SF2->(DbSkip())
				Loop
			Enddo

			If AllTrim(SF2->F2_ESPECIE)==Alltrim(SE2->E2_TIPO).And.;
				xFilial("SF2")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA==;
				F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA

				AAdd(aSFEIRC,array(8))

				aSFEIRC[Len(aSFEIRC)][1] := SF2->F2_DOC         		//FE_NFISCAL
				aSFEIRC[Len(aSFEIRC)][2] := SF2->F2_SERIE       		//FE_SERIE
				aSFEIRC[Len(aSFEIRC)][3] := Round(xMoeda(SF2->F2_BASIMP2,SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1))*nSaldo/SE2->E2_VALOR * nSigno	//FE_VALBASE
				aSFEIRC[Len(aSFEIRC)][4] := 100
				aSFEIRC[Len(aSFEIRC)][5] := Round(xMoeda(SF2->F2_VALIMP2,SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1))*nSaldo/SE2->E2_VALOR * nSigno	//FE_VALIMP
				aSFEIRC[Len(aSFEIRC)][6] := aSFEIRC[Len(aSFEIRC)][5]
				aSFEIRC[Len(aSFEIRC)][7] := SE2->E2_VALOR
				aSFEIRC[Len(aSFEIRC)][8] := SE2->E2_EMISSAO
			Endif
		Endif
	Endif
Endif
Return aSFEIRC

/*
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � Despesas   � Autor � Bruno Sobieski      � Data � 18.05.08 ���
��+----------+------------------------------------------------------------���
���Descri��o � Manutencao de Despesas e Taxas       (Portugal)            ���
��+----------+------------------------------------------------------------���
���Uso       � PAGO007                                                    ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
*/
Static Function Fa085Desp(aSE2,nMoeda,nOp)
Local cComboMoe	:=	""
Local oDlg,oGrp1,oSBtn2,oSBtn3,oSay4,oGrp7, nX
Local nOpcao := 0
Local nTotal	:= 0
Private aCols
Private aHeader
Private oTotal

oDlg := MSDIALOG():Create()
oDlg:cName := "oDlg"
oDlg:cCaption := STR0182 //"Despesas do pagamento"
oDlg:nLeft := 0
oDlg:nTop := 0
oDlg:nWidth := 499
oDlg:nHeight := 241
oDlg:lShowHint := .F.
oDlg:lCentered := .F.

oGrp1 := TGROUP():Create(oDlg)
oGrp1:cName := "oGrp1"
oGrp1:cCaption := "Totais"
oGrp1:nLeft := 6
oGrp1:nTop := 1
oGrp1:nWidth := 481
oGrp1:nHeight := 37
oGrp1:lShowHint := .F.
oGrp1:lReadOnly := .F.
oGrp1:Align := 0
oGrp1:lVisibleControl := .T.

oSay4 := TSAY():Create(oDlg)
oSay4:cName := "oSay4"
oSay4:cCaption := STR0183+aMoeda[nMoeda]+")"//"Total de despesas (em "
oSay4:nLeft := 23
oSay4:nTop := 16
oSay4:nWidth := 154
oSay4:nHeight := 17
oSay4:lShowHint := .F.
oSay4:lReadOnly := .F.
oSay4:Align := 0
oSay4:lVisibleControl := .T.
oSay4:lWordWrap := .F.
oSay4:lTransparent := .F.

oTotal := TSAY():Create(oDlg)
oTotal:cName := "oTotal"
nTotal	:=	0
For nX:= 1 To Len(aSE2[nOp,4])
	nTotal	+=	 Round(xMoeda(aSE2[nOp,4,nX,2],Val(aSE2[nOp,4,nX,3]),nMoeda,dDataBase,5,aTxMoedas[Val(aSE2[nOp,4,nX,3])][2],aTxMoedas[nMoeda][2]),MsDecimais(nMoeda))
Next
oTotal:cCaption := TransForm(nTotal,'@E 999,999,999.99')
oTotal:nLeft := 200
oTotal:nTop := 16
oTotal:nWidth := 150
oTotal:nHeight := 17
oTotal:lShowHint := .F.
oTotal:lReadOnly := .F.
oTotal:Align := 0
oTotal:lVisibleControl := .T.
oTotal:lWordWrap := .F.
oTotal:lTransparent := .F.

oGrp7 := TGROUP():Create(oDlg)
oGrp7:cName := "oGrp7"
oGrp7:cCaption := STR0180 //"Despesas"
oGrp7:nLeft := 6
oGrp7:nTop := 38
oGrp7:nWidth := 481
oGrp7:nHeight := 146
oGrp7:lShowHint := .F.
oGrp7:lReadOnly := .F.
oGrp7:Align := 0
oGrp7:lVisibleControl := .T.

oSBtn2 := SBUTTON():Create(oDlg)
oSBtn2:cName := "oSBtn2"
oSBtn2:cCaption := "oSBtn2"
oSBtn2:nLeft := 368
oSBtn2:nTop := 188
oSBtn2:nWidth := 52
oSBtn2:nHeight := 22
oSBtn2:lShowHint := .F.
oSBtn2:lReadOnly := .F.
oSBtn2:Align := 0
oSBtn2:lVisibleControl := .T.
oSBtn2:nType := 1
oSBtn2:bAction:= {|| nOpcao := 1, oDlg:End()}

oSBtn3 := SBUTTON():Create(oDlg)
oSBtn3:cName := "oSBtn3"
oSBtn3:cCaption := "oSBtn3"
oSBtn3:nLeft := 432
oSBtn3:nTop := 188
oSBtn3:nWidth := 52
oSBtn3:nHeight := 22
oSBtn3:lShowHint := .F.
oSBtn3:lReadOnly := .F.
oSBtn3:Align := 0
oSBtn3:lVisibleControl := .T.
oSBtn3:nType := 2
oSBtn3:bAction:= {|| nOpcao := 0, oDlg:End()}

aHeader	:=	{}
For nX := 1 To Len(aMoeda)
	cComboMoe	+= StrZero(nX,1)+"="+aMoeda[nX]+";"
Next
cComboMoe	:=	Left(cComboMoe,Len(cComboMoe)-1)
DbSelectArea("SX3")
DbSetOrder(2)
DbSeek('EK_TPDESP')

AADD(aHeader,{ TRIM(X3TITULO()), X3_CAMPO, X3_PICTURE,;
		X3_TAMANHO, X3_DECIMAL, X3_VALID,;
		X3_USADO, X3_TIPO, X3_F3, X3_ARQUIVO, X3CBOX() } )
DbSeek('EK_VALOR')
AADD(aHeader,{ TRIM(X3TITULO()), X3_CAMPO, X3_PICTURE,;
		X3_TAMANHO, X3_DECIMAL, "Positivo().And. Fa085VldDesp("+Str(nMoeda,2)+",@oTotal)",;
		X3_USADO, X3_TIPO, X3_F3, X3_ARQUIVO, X3CBOX() } )
DbSeek('EK_MOEDA')
AADD(aHeader,{ TRIM(X3TITULO()), X3_CAMPO, X3_PICTURE,;
		X3_TAMANHO, X3_DECIMAL, "NAOVAZIO().And. Fa085VldDesp("+Str(nMoeda,2)+",@oTotal)",;
		X3_USADO, X3_TIPO, X3_F3, X3_ARQUIVO, cComboMoe } )

If Len(aSE2[nOP,4]) > 0
	aCols := aClone(aSE2[nOP,4])
Else
	aCols	:=	Array(1,Len(aHeader)+1)
	aCols[1,1]	:=	"  "
	aCols[1,2]	:=	0
	aCols[1,3]	:=	"1"
	aCols[1,4]	:=	.F.
Endif
oGetD := MsNewGetDados():New(25,6,88,240,3,"Fa085DspLok()","AllwaysTrue()","EK_MOEDA",/*acpos*/,/*freeze*/,100,,/*superdel*/,/*delok*/,oDlg,@aHeader,@aCols)

Activate Dialog oDlg CENTERED

If nOpcao == 1
	aSE2[nOP,4] := {}
	For nX := 1 To Len(oGetd:aCols)
		If !oGetd:aCols[nX,Len(oGetd:aCols[nX]) ] .And. oGetd:aCols[nX,2] > 0
			AAdd(aSE2[nOP,4],oGetd:aCols[nX])
		Endif
	Next
Endif

Return

Function Fa085VldDesp(nMoeda,oTotal)
Local nTotal	:=	0
Local nX
Local lRet	:=	.T.
If lRet .And. !("EK_TPDESP"$ReadVar())
	For nX:= 1 to Len(aCols)
		If !aCols[nX,Len(aCols[nX]) ]
			IF n==nX
				If "EK_MOEDA" $ READVAR()
					nMoeAtu := 	Val(M->EK_MOEDA)
					nValAtu	:=	aCols[nX,2]
				Else
					nMoeAtu := 	Val(aCols[nX,3])
					nValAtu	:=	M->EK_VALOR
				Endif
			Else
				nMoeAtu := 	Val(aCols[nX,3])
				nValAtu	:=	aCols[nX,2]
	  	Endif
			nTotal	+=	 Round(xMoeda(nValAtu,nMoeAtu,nMoeda,dDataBase,5,aTxMoedas[nMoeAtu][2],aTxMoedas[nMoeda][2]),MsDecimais(nMoeda))
		Endif
	Next
	oTotal:SetText(TransForm(nTotal,'@E 999,999,999.99'))
Endif
Return lRet

Function Fa085DspLok()
Local lRet		:=	.T.
If !aCols[n,Len(aCols[n])]
	If Empty(aCols[n,1]) .Or.Empty(aCols[n,2]).Or. Empty(aCols[n,3])
		Help(" ",1,'OBRIGAT')
		lRet	:=	.F.
	Endif
Endif
Return lRet

Static Function	GravaDesp( cFornece,cLoja,aDesp )
Local nX	:=	1

For nX:= 1 To Len(aDesp)
		RecLock("SEK",.T.)
		SEK->EK_FILIAL   := xFilial("SEK")
		SEK->EK_TIPODOC  := "DE" //Despesas
		SEK->EK_VALOR    := aDesp[nX][2]
		SEK->EK_SALDO    := aDesp[nX][2]
		SEK->EK_MOEDA    := AllTrim( aDesp[nX][3])
		SEK->EK_EMISSAO  := dDataBase
		SEK->EK_VLMOED1  := Round(xMoeda( aDesp[nX][2],Val(aDesp[nX][3]),1, dDataBase,5,aTxMoedas[(Val(aDesp[nX][3]))][2]),MsDecimais(1))
		SEK->EK_ORDPAGO  := cOrdpago
		SEK->EK_DTDIGIT  := dDataBase
		SEK->EK_FORNECE  := cFornece
		SEK->EK_LOJA     := cLoja
		SEK->EK_FORNEPG  := cFornece
		SEK->EK_LOJAPG 	 := cLoja
		If SEK->(FieldPos("EK_TPDESP"))<>0
			SEK->EK_TPDESP		:= aDesp[nX][1]
		EndIf
		If SEK->(FieldPos("EK_NATUREZ")) > 0
		   SEK->EK_NATUREZ:= cNatureza
		Endif
		F085AGrvTx()
		MsUnlock()
Next nX

Return

Function PropNFPA(aOrdPg)
Local nTotPA :=0
Local nTotNF:=0
Local nTotCr:=0
Local nX:=0
Local nI:=0
Local nPropImp:= 1

For nI := 1 To Len(aOrdPg)

	For nX := 1 To Len(aOrdPg[nI][4])
		DbSelectArea('SE2')
		MsGoTo(aOrdPg[nI][4][nX])
		cFornece := E2_FORNECE
		cLoja    := E2_LOJA
		If (SE2->E2_TIPO $ MVPAGANT)
  			If lBxParc .and. SE2->E2_VLBXPAR > 0  .And.  SE2->E2_VLBXPAR <=SE2->E2_SALDO
 				nTotPA   += Round(xMoeda(SE2->E2_VLBXPAR,SE2->E2_MOEDA,1,dDataBase,5,aTxMoedas[SE2->E2_MOEDA][2]),MsDecimais(1))
 			Else
  				nTotPA   += Round(xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,1,dDataBase,5,aTxMoedas[SE2->E2_MOEDA][2]),MsDecimais(1))
 	   		EndIf
		ElseIf (SE2->E2_TIPO$MV_CPNEG)
  			If lBxParc .and. SE2->E2_VLBXPAR > 0  .And.  SE2->E2_VLBXPAR <=SE2->E2_SALDO
 				nTotCr   += Round(xMoeda(SE2->E2_VLBXPAR,SE2->E2_MOEDA,1,dDataBase,5,aTxMoedas[SE2->E2_MOEDA][2]),MsDecimais(1))
 			Else
  				nTotCr   += Round(xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,1,dDataBase,5,aTxMoedas[SE2->E2_MOEDA][2]),MsDecimais(1))
 	   		EndIf

		Else
  			If lBxParc .and. SE2->E2_VLBXPAR > 0  .And.  SE2->E2_VLBXPAR <=SE2->E2_SALDO
   				nTotNF   += Round(xMoeda(SE2->E2_VLBXPAR,SE2->E2_MOEDA,1,dDataBase,5,aTxMoedas[SE2->E2_MOEDA][2]),MsDecimais(1))
  			Else
   				nTotNF   += Round(xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,1,dDataBase,5,aTxMoedas[SE2->E2_MOEDA][2]),MsDecimais(1))
  			EndIf
		EndIf
	Next
	nPropImp:=(nTotNF-(nTotPA+nTotCr) )/(nTotNF-nTotCr)

Next

Return nPropImp

Function PegaAliq(cFornece,cLoja)
Local nX
Local nAliq := 0
Local aAreaSFH := {}
Private aImpVarSD1 := {0,0,0,0,0,{}}
Private cSerie	:=	"A  "

DEFAULT cFornece := ""
DEFAULT cLoja    := ""

aImpVarSD1[1] := 1 		// nQuant
aImpVarSD1[2] := 1 		//nPrcVen
aImpVarSD1[3] := nValor	//nValorItem
aImpVarSD1[4] := 0.00
aImpVarSD1[5] := 0.00
aImpVarSD1[6] := {}

CalcTesXIp( "E",nValor /*nTotBaseImp*/, nValor/*nValorItem*/, ""/*cProduto*/, /*nPosCols*/, 1 /*nPosRow*/, "RAPIDA"/*cVenda*/ ,/*nDescontos*/,/*nDescTot*/,1 /*nMaxArray*/,/*aUltItem*/)

For nX:= 1 To Len(aImpVarSD1[6])
	If aImpVarSD1[6,nX,4] > 0
		If !("IB"$aImpVarSD1[6,nX,1])

		 	If aImpVarSD1[6,nX,2] > 0
		 		nAliq += aImpVarSD1[6,nX,2]
		 	Else
		 		dbSelectArea("SFH")
		 		aAreaSFH := SFH->(GetArea())
		 		SFH->(dbSetOrder(1))

		 		If SFH->(dbSeek(xFilial("SFH")+cFornece+cLoja+aImpVarSD1[6,nX,1]))
		 			nAliq += SFH->FH_ALIQ
		 		Else
		 			nAliq += 0
		 		Endif

		 		SFH->(RestArea(aAreaSFH))
		 	Endif

		Elseif  (aImpVarSD1[6,nX,20] == cProv .Or. Empty(aImpVarSD1[6,nX,20])) .And. "IB"$aImpVarSD1[6,nX,1]

		    If aImpVarSD1[6,nX,2] > 0
		    	nAliq += aImpVarSD1[6,nX,2]
			Else
				dbSelectArea("SFH")
				aAreaSFH := SFH->(GetArea())
		 		SFH->(dbSetOrder(1))

		 		If SFH->(dbSeek(xFilial("SFH")+cFornece+cLoja+aImpVarSD1[6,nX,1]+aImpVarSD1[6,nX,20]))
		 			nAliq += SFH->FH_ALIQ
		 		Else
		 			nAliq += 0
		 		Endif

		 		SFH->(RestArea(aAreaSFH))
			Endif

		Endif
	EndIf
Next
Return nAliq

Function F085ImpPA(oObj,aSE2,cFor,oFor,oRet,nRet,nValor,nLiquido,oLiquido,nRetIb,oRetIb,nRetIva,oRetIva,nRetSuss,oRetSuss)
Local nX,nA,nP,nC
Local oDlg,oFntMoeda
Local lConfirmo	:=	.F.
Local aCpos
Local aConGan
Local oGetDad1
Local nHdl
Local lMonotrb := .F.

Local oRetGan
Static aGet
Private	oTotAnt,nValDesc	:=	0,nPorDesc	:=	0,nTotNCC:=0
Private	oNumOp ,oPorDesc ,oValDesc ,oZnGeo,oGrpSus, oSerieNF

//Verifica se o fornecedor atualizado � monotributista

DEFINE MSDIALOG oDlg FROM 30,40  TO 300,550 TITLE OemToAnsi(STR0189) Of oObj PIXEL  // "Orden de pago del proveedor "

//Titulos por pagar
@ 17,004 To 85,250 Pixel Of  oDlg LABEL OemToAnsi(STR0089)

@ 25,006 SAY OemToAnsi(STR0185)  	Size 70,08  Of oDlg Pixel COLOR CLR_HBLUE  //"Numero da operacao
@ 25,050 MSGET oNumOp  Var cNumOp    Valid F085NumOp(cNumOp,nTotAnt)Size 60,08 Pixel Of oDlg

@ 25,145 SAY OemToAnsi(STR0186)Size 70,08 Pixel Of oDlg COLOR CLR_HBLUE //Valor base para calculo da ret SUSS e IVA
@ 25,185 GET oTotAnt Var nTotAnt  Valid F085NumOp(cNumOp,nTotAnt) .And. F085VldRet(1,cFornece,@cFor,oFor,oRet,@nRet,nValor,@nLiquido,oLiquido,@aSE2,cLoja,cCF,cProv,oRetIB,@nRetIB,cZnGeo,nGrpSus,nTotAnt,oRetIVA,@nRetIVA,oRetSUSS,@nRetSuss,,,,,,oSerieNF,cSerieNF) Size 60,08 Pixel Of oDlg Picture Tm(nTotAnt,19,nDecs)

@ 38,006 SAY OemToAnsi(STR0187) SIZE 45, 7 OF oDlg PIXEL //Zona Geografica
@ 38,050 MSGET oZnGeo   VAR cZnGeo F3 "ZG" Picture "@S3"  Valid F085VldRet(1,cFornece,@cFor,oFor,oRet,@nRet,nValor,@nLiquido,oLiquido,@aSE2,cLoja,cCF,cProv,oRetIB,@nRetIB,cZnGeo,nGrpSus,nTotAnt,oRetIVA,@nRetIVA,oRetSUSS,@nRetSuss,,,,,,oSerieNF,cSerieNF) SIZE 15, 7 PIXEL OF oDlg // WHEN nPagar<>4

@ 38,145 SAY OemToAnsi(STR0188) SIZE 45, 7 OF oDlg PIXEL //Tipo de Obra
@ 38,185 MSGET oGrpSus   VAR nGrpSus F3 "CO" Picture "@S3" Valid F085VldRet(1,cFornece,@cFor,oFor,oRet,@nRet,nValor,@nLiquido,oLiquido,@aSE2,cLoja,cCF,cProv,oRetIB,@nRetIB,cZnGeo,nGrpSus,nTotAnt,oRetIVA,@nRetIVA,oRetSUSS,@nRetSuss,,,,,,oSerieNF,cSerieNF) SIZE 15, 7 PIXEL OF oDlg // WHEN nPagar<>4

@ 50,006 SAY OemToAnsi(STR0184) SIZE 30, 7 OF oDlg PIXEL COLOR CLR_HBLUE //Codigo Fiscal
@ 50,050 MSGET oCF   VAR cCF	F3 "SF4" Picture "@S3"  Valid (ExistCpo("SF4",cCF) .And. F085VldRet(1,cFornece,@cFor,oFor,oRet,@nRet,nValor,@nLiquido,oLiquido,@aSE2,cLoja,cCF,cProv,oRetIB,@nRetIB,cZnGeo,nGrpSus,nTotAnt,oRetIVA,@nRetIVA,oRetSUSS,@nRetSuss,,,,,,oSerieNF,cSerieNF)) SIZE 15, 7 PIXEL OF oDlg // WHEN nPagar<>4

@ 50,145 SAY OemToAnsi(STR0159) SIZE 45, 7 OF oDlg PIXEL COLOR CLR_HBLUE //Provincia
@ 50,185 MSGET oProv   VAR cProv F3 "12" Picture "@!" Valid F085VldRet(1,cFornece,@cFor,oFor,oRet,@nRet,nValor,@nLiquido,oLiquido,@aSE2,cLoja,cCF,cProv,oRetIB,@nRetIB,cZnGeo,nGrpSus,nTotAnt,oRetIVA,@nRetIVA,oRetSUSS,@nRetSuss,,,,,,oSerieNF,cSerieNF) SIZE 15, 7 PIXEL OF oDlg // WHEN nPagar<>4

	@ 85,004 To 120,250 Pixel Of oDlg LABEL OemToAnsi(STR0098) // "&Recalc. Ret."
	@ 95,006 SAY OemToAnsi("Ganancias : ")  		Size 40,08 Pixel Of  oDlg
	@ 95,050 SAY oRet VAR nRet Size 60,08 PIXEL OF oDlg Picture Tm(nRet,19,nDecs)  COLOR CLR_BLUE

	@ 95,110 SAY OemToAnsi("Ingresos Brutos : ") Size 40,08 Pixel Of  oDlg
	@ 95,154 SAY oRetIB Var nRetIB  Size 60,08 Pixel Of  oDlg Picture Tm(nRetIB,19,nDecs)  COLOR CLR_BLUE

	@ 105,110 SAY OemToAnsi("IVA : ")  Size 15,08 Pixel Of  oDlg
	@ 105,154 SAY oRetIVA Var nRETIVA  Size 60,08 Pixel Of  oDlg Picture Tm(nRetIva,19,nDecs)  COLOR CLR_BLUE

	@ 105,006 SAY OemToAnsi("SUSS : ")  		Size 40,08 Pixel Of  oDlg
	@ 105,050 SAY oRetSUSS VAR nRetSUSS Size 60,08 PIXEL OF oDlg Picture Tm(nRetSUSS,19,nDecs)  COLOR CLR_BLUE

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||nOpca:=1,if(Fa085TudoOk(cNumOp,nTotAnt,cZnGeo,nGrpSus,cCF,cProv),oDlg:End(),nOpca := 0)},{||oDlg:End()})

Return .T.

// Fun��o para verificar se ja exiuste o numero de operacao informado
// caso exista o valor total da opera��o(valor utilizado ocmo base de calculo)
// nao poder� ser diferente do valor da opera��o original.
Function F085NumOp()
DbSelectArea("SEK")
SEK->(dbSetOrder(2))
If SEK->(dbSeek(xFilial("SEK")+cFornece+cLoja))    //criar um indide com numero da operacao
	cChaveSEK := xFilial("SEK")+SEK->EK_FORNECE+SEK->EK_LOJA
	While !SEK->(Eof()) .And. cChaveSEK == SEK->EK_FILIAL+SEK->EK_FORNECE+SEK->EK_LOJA
		If SEK->EK_TIPODOC =="PA"  .And. SEK->EK_NUMOPER == cNumOp
			nTotAnt:=SEK->EK_TOTANT
		EndIf
		SEK->(dbSkip())
	End
EndIf
Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F085VldRet�Autor  �Ana PAula			 �Fecha �  10/12/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Calcula reten��es de IVA, SUSS, IB e Ganancias na incluss�o���
���          � de pagamentos antecipados quando o parametro MV_RETPA=S    ���
�������������������������������������������������������������������������͹��
���Uso       � Fina085a                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function F085VldRet(nOpc,cFornece,cFor,oFor,oRet,nRet,nValor,nLiquido,oLiquido,aSE2,cLoja,cCF,cProv,oRetIB,nRetIB,cZnGeo,nGrpSus,nTotAnt,oRetIVA,nRetIVA,oRetSUSS,nRetSuss,nBaseRIE,nAliqRIE,nAliqIGV,oAliqIGV,nBaseIGV,oSerieNF,cSerieNF)
Local aConGan	:= {}
Local aTmp		:= {}
Local aTmp1		:= {}
Local aTmpSus 	:= {}
Local aTmpIva 	:= {}
Local aTmpIB	:= {}
Local aRateioGan   := {}
Local aConGanRat   := {}
Local nX,nY
Local lPa:=.F.

Local nA:=0
Local lRetem:=.T.
Local lCalcSus := .F.
Local lCalcIb  := .F.
Local lCalcGan := .F.
Local lMonotrb := .F.
Local nLiquP :=0

Default nTotAnt:=0
DEfault nBaseRIE := 0
DEfault nAliqRIE := 0
DEfault nBaseIGV := 0
DEfault nAliqIGV := 0
lRetPA		:=	(GetNewPar("MV_RETPA","N") == "S")
lMonotrb := Iif(SA2->A2_TIPO == 'M' .And. SA2->(FieldPos("A2_CMONGAN"))>0,.T.,.F.)

If lRetPA .And. nValor > 0 .And. cPaisLoc == "ANG"
	oAliqigv:Refresh()
	aSE2	:=	{}
	AaddSE2(1,aSE2,.T.)
	aSFERIE := {}
	AAdd(aSFERIE,array(8))
	aSFERIE[Len(aSFERIE)][1] := ""
	aSFERIE[Len(aSFERIE)][2] := "PA"
	aSFERIE[Len(aSFERIE)][3] := Round(nBaseRIE,MsDecimais(1)) 	//FE_VALBASE
	aSFERIE[Len(aSFERIE)][4] := Round(nBaseRIE * nAliqRIE/100,MsDecimais(1))	//FE_VALIMP
	aSFERIE[Len(aSFERIE)][5] := 100
	aSFERIE[Len(aSFERIE)][6] := aSFERIE[Len(aSFERIE)][4]
	aSFERIE[Len(aSFERIE)][7] := nBaseRIE
	aSFERIE[Len(aSFERIE)][8] := dDataBase

	aSE2[1,1,1,_RETRIE]	:= aClone(aSFERIE)
	nLiquido:= nValor - aSE2[1,1,1,_RETRIE,1,6]

ElseIf lRetPA .And. nValor > 0  .AND. SUBSTR(cAGENTE,1,1) =='S'	.And. cPaisLoc == "PER"
//	CALCULO DA RETENCAO DO IGV
	IF SA2->A2_AGENRET $ 'N|2' .AND. EMPTY(SA2->A2_BCRESOL) .And. nValor >= SFF->FF_IMPORTE
	    nBaseIGV := nValor
	    nAliqIGV := SFF->FF_ALIQ
		aSE2	:=	{}
		AaddSE2(1,aSE2,.T.)
		aSFEIGV := {}
		AAdd(aSFEIGV,array(12))
		aSFEIGV[Len(aSFEIGV)][1]  := ""
		aSFEIGV[Len(aSFEIGV)][2]  := "PA"
		aSFEIGV[Len(aSFEIGV)][3]  := Round(nBaseIGV,MsDecimais(1)) 	//FE_VALBASE
		aSFEIGV[Len(aSFEIGV)][4]  := Round(nBaseIGV * nAliqIGV/100,MsDecimais(1))	//FE_VALIMP
		aSFEIGV[Len(aSFEIGV)][5]  := 100
		aSFEIGV[Len(aSFEIGV)][6]  := aSFEIGV[Len(aSFEIGV)][4]
		aSFEIGV[Len(aSFEIGV)][7]  := nBaseIGV
		aSFEIGV[Len(aSFEIGV)][8]  := dDataBase
		aSFEIGV[Len(aSFEIGV)][9]  := nAliqIGV
		aSFEIGV[Len(aSFEIGV)][10] := " "
		aSFEIGV[Len(aSFEIGV)][11] := 0
		aSFEIGV[Len(aSFEIGV)][12] := 0
		aSE2[1,1,1,_RETIGV]	:= aClone(aSFEIGV)
		nLiquido:= nValor - aSE2[1,1,1,_RETIGV,1,6]

    ENDIF

Endif

If oLiquido <> NIL
	oLiquido:Refresh()
EndIF



Return .T.

Function Fa085TudoOk()
Local lRet:= .T.
Local aHelpSpa := {}
Local aHelpPor := {}
Local aHelpEng := {}

If Empty (cNumOp) .Or. Empty(nTotAnt) .Or. Empty (cCF) .Or. Empty(cProv)
	Help(" ",1,"Obrigat")
	lRet:=.F.
EndIf

If Empty (cZnGeo) .And. !Empty(nGrpSus)
	Help(" ",1,"OBRIZNGEO")
	lRet:=.F.
EndIf

If !Empty (cZnGeo) .And. Empty(nGrpSus)
	Help(" ",1,"OBRIGATPOBRA")
	lRet:=.F.
EndIf

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Fa085SegF2�Autor  � Acacio Egas        � Data �  10/12/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Acumula os valores base de calculo de retencao por Conceito.���
�������������������������������������������������������������������������͹��
���Uso       � Fina085,FINA085a                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Fa085SegF2(cAgente,nSigno,nSaldo)
Local aSFEISI  := {}
Local nRateio  := 0
Local nValRet  := 0
Local nValTot  := 0
Local nVlrBase := 0
Local nVlrTotal:= 0
Local nAliq    := 0
Local nVlrFF   := 0
Local nRecFF   := 0
Local nPercTot := 0
Local nValBasTot := 0
Local aCF	   := {}
Local cChave   := ""
Local nI,nJ
Local 	lCalcLimp	:=.T.
DEFAULT nSigno:= -1

If SA2->(Found()) .And. SA2->(FieldPos("A2_RETISI")) >0.And. (SA2->A2_RETISI == "1").and.;
	SA2->(FieldPos("A2_ISICM")) >0
	lCalcLimp	:=.F.
EndIf


If ExistBlock("F0851IMP")
	lCalcLimp:=ExecBlock("F0851IMP",.F.,.F.,{"ZA2"})
EndIf

//+---------------------------------------------------------------------+
//� Obter Impostos somente qdo a Empresa Usuario for Agente de Reten��o.�
//+---------------------------------------------------------------------+
If Subs(cAgente,8,1) == "S"   .And. lCalcLimp

	dbSelectArea("SF2")
	dbSetOrder(1)
	If lMsFil
		dbSeek(SE2->E2_MSFIL+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA)
	Else
		dbSeek(xFilial("SF2")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA)
	EndIf
	While !Eof() .And. (Alltrim(SF2->F2_ESPECIE) <> AllTrim(SE2->E2_TIPO))
		DbSkip()
		Loop
	Enddo

	If (AllTrim(SF2->F2_ESPECIE) == Alltrim(SE2->E2_TIPO)) .And. ;
		(Iif(lMsFil,SF2->F2_MSFIL,xFilial("SF2"))+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA == ;
		F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)

		nRateio := ( Round(xMoeda(nSaldo,SE2->E2_MOEDA,1,,5,aTxMoedas[Max(SE2->E2_MOEDA,1)][2]),MsDecimais(1)) / Round(xMoeda(SF2->F2_VALBRUT,SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1)) )

		cChave := SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA
		SD2->(DbSetOrder(3))
		If lMsFil
			SD2->(DbSeek(SF2->F2_MSFIL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
		Else
			SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
		EndIf

		While !SD2->(Eof()) .And. Iif(lMsFil,SF2->F2_MSFIL,xFilial("SD2"))==SD2->D2_FILIAL .And. SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == cChave
			If AllTrim(SD2->D2_ESPECIE) <> Alltrim(SF2->F2_ESPECIE)
				SD2->(DbSkip())
				Loop
			Endif

			// Controla CF
			If (nJ := aScan(aCF, {|x| x[1]==SD2->D2_CF}))==0
				aAdd( aCF , {SD2->D2_CF,0,0} ) // CF , Total , Aliq
				nJ := Len(aCF)
			EndIf
			aCF[nJ,2]	+= SD2->D2_TOTAL

			//Verifica as caracteristicas do TES para que os impostos
			//possam ser somados ao valor da base de calculo da retencao...
			aImpInf := TesImpInf(SD2->D2_TES)

			For nI := 1 To Len(aImpInf)
				//Caso o fornecedor recolha Zarate
			   If(Trim(aImpInf[nI][01])$ SFF->FF_INCIMP)
			   		lCalImpos:=.T.
			    	aCF[nJ,2]-=SD2->(FieldGet(FieldPos(aImpInf[nI][02])))
			  	Endif
			Next
			SD2->(dbSkip())
		End

		// Loacaliza CF para totalizar
		For nJ:=1 To Len(aCF)

			SFF->(dbSetOrder(10))
			SFF->(dbSeek(xFilial()+"ISI"+aCF[nJ,1]))
			Do While !SFF->(Eof()) .and. "ISI"+aCF[nJ,1]==SFF->(FF_IMPOSTO+FF_CFO_C)
				If SFF->FF_IMPORTE <= nVlrTotal .and. nVlrFF < SFF->FF_IMPORTE
					nVlrFF := SFF->FF_IMPORTE
					nRecFF := SFF->(Recno())
				EndIf
				SFF->(DbSkip())
			EndDo

			// Verrica se encotrou SFF para o valor total e se o valor � > 0
			If nRecFF > 0 .and. aCF[nJ,2] > 0
				SFF->(DbGoTo(nRecFF))

				// ISI com controle de Aliq por parametro
				If SA2->A2_ISICM=="1" .and. ALLTRIM(SA2->A2_MUN)=="ZARATE"
					aCF[nJ,3]	:= 0.2 // Parametrizar
				ElseIf ALLTRIM(SA2->A2_MUN)=="ZARATE"
					aCF[nJ,3]	:= 0.3
				Else
					aCF[nJ,3]	:= 0.4
				EndIf
			Else
				aCF[nJ,2]	:= 0
			EndIf
			nRecFF := 0
			nVlrFF := 0
		Next

		If lCalcLimp
			// Totaliza Base de calculo por CFOP
			For nJ:=1 To Len(aCF)
				nVlrBase := (aCF[nJ,2] * nRateio)
				nAliq	 :=  aCF[nJ,3] // Aliquota
				nValRet  := Round((nVlrBase*(aCF[nJ,3]/100))*nSigno,TamSX3("FE_VALIMP")[2])
				nValRet	 := (nValRet * nPercTot) // Redu��o de imposto
				nValTot	 += nValRet
				nValBasTot += nVlrBase
			Next
			//����������������������������������������������������������������Ŀ
			//� Gravar Retenciones.                                            �
			//������������������������������������������������������������������
			AAdd(aSFEISI,array(8))
			aSFEISI[Len(aSFEISI)][1] := SF2->F2_DOC   //FE_NFISCAL
			aSFEISI[Len(aSFEISI)][2] := SF2->F2_SERIE //FE_SERIE
			aSFEISI[Len(aSFEISI)][3] := nValBasTot	       //FE_VALBASE
			aSFEISI[Len(aSFEISI)][4] := nValTot	       //FE_VALIMP
			aSFEISI[Len(aSFEISI)][5] := Round((nValTot*100)/nSaldo,2)//FE_PORCRET
			aSFEISI[Len(aSFEISI)][6] := nValTot // FE_RETENC
			aSFEISI[Len(aSFEISI)][7] := nPercTot //FE_DEDUC
			aSFEISI[Len(aSFEISI)][8] := nAliq		//FE_ALIQ
		EndIf
	EndIf
EndIf

Return aSFEISI

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Fa085SegF1 �Autor  � acrosiga          � Data �  10/17/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Acumula os valores base de calculo de retencao por Conceito.���
�������������������������������������������������������������������������͹��
���Uso       � Fina085,FINA085a                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function Fa085SegF1(cAgente,nSigno,nSaldo)
Local aSFEISI  := {}
Local nRateio  := 0
Local nValRet  := 0
Local nValTot  := 0
Local nVlrBase := 0
Local nVlrTotal:= 0
Local nAliq    := 0
Local nVlrFF   := 0
Local nRecFF   := 0
Local nPercTot := 1
Local nValBasTot := 0
Local aCF	   := {}
Local cChave   := ""
Local nI,nJ
Local lFin85Zar
Local lCalcLimp	:=.F.

DEFAULT nSigno	:=	1
//+---------------------------------------------------------------------+
//� Obter Impostos somente qdo a Empresa Usuario for Agente de Reten��o.�
//+---------------------------------------------------------------------+
SA2->( dbSetOrder(1) )
If lMsFil .And. !Empty(xFilial("SA2")) .And. xFilial("SF1") == xFilial("SE2")
	SA2->(DbSeek(SE2->E2_MSFIL+SE2->E2_FORNECE+SE2->E2_LOJA))
Else
	SA2->(DbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA))
Endif

If SA2->(Found()) .And. SA2->(FieldPos("A2_RETISI")) >0.And. (SA2->A2_RETISI == "1").and.;
	SA2->(FieldPos("A2_ISICM")) >0
	lCalcLimp	:=.T.
EndIf

If ExistBlock("F0851IMP")
	lCalcLimp:=ExecBlock("F0851IMP",.F.,.F.,{"ZA1"})
EndIf

If Subs(cAgente,8,1) == "S" .And. lCalcLimp

	dbSelectArea("SF1")
	If lMsFil
		dbSeek(SE2->E2_MSFIL+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA)
	Else
		dbSeek(xFilial("SF1")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA)
	EndIf
	dbSeek(xFilial("SF1")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA)
	While !Eof() .And. (Alltrim(SF1->F1_ESPECIE) <> AllTrim(SE2->E2_TIPO))
		dbSkip()
		Loop
	End

	If (AllTrim(SF1->F1_ESPECIE) == Alltrim(SE2->E2_TIPO)) .And. ;
		(Iif(lMsFil,SF1->F1_MSFIL,xFilial("SF1"))+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA == ;
		F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)

		nRateio := ( Round(xMoeda(nSaldo,SE2->E2_MOEDA,1,,5,aTxMoedas[Max(SE2->E2_MOEDA,1)][2]),MsDecimais(1)) / ROund(xMoeda(SF1->F1_VALBRUT,SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1)) )

		cChave := SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
		SD1->(DbSetOrder(1))
		If lMsFil
			SD1->(DbSeek(SF1->F1_MSFIL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
		Else
			SD1->(DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
		EndIf

		While !SD1->(Eof()) .And. Iif(lMsFil,SF1->F1_MSFIL,xFilial("SD1"))==SD1->D1_FILIAL .And. SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA == cChave
			If AllTrim(SD1->D1_ESPECIE) <> Alltrim(SF1->F1_ESPECIE)
				SD1->(DbSkip())
				Loop
			Endif

			// Controla CF
			If (nJ := aScan(aCF, {|x| x[1]==SD1->D1_CF}))==0
				aAdd( aCF , {SD1->D1_CF,0,0} ) // CF , Total , Aliq
				nJ := Len(aCF)
			EndIf
			aCF[nJ,2]	+= SD1->D1_TOTAL

			//Verifica as caracteristicas do TES para que os impostos
			//possam ser somados ao valor da base de calculo da retencao...

			aImpInf := TesImpInf(SD1->D1_TES)

			For nI := 1 To Len(aImpInf)
				//Caso o fornecedor recolha Zarate
			   If(Trim(aImpInf[nI][01])$ SFF->FF_INCIMP)
			   		lCalImpos:=.T.
			    	aCF[nJ,2]-=SD1->(FieldGet(FieldPos(aImpInf[nI][02])))
			  	Endif
			Next

			SD1->(dbSkip())
		End

		// Loacaliza CF para totalizar
		For nJ:=1 To Len(aCF)

			SFF->(dbSetOrder(10))
			SFF->(dbSeek(xFilial()+"ISI"+aCF[nJ,1]))
			Do While !SFF->(Eof()) .and. "ISI"+aCF[nJ,1]==SFF->(FF_IMPOSTO+FF_CFO_C)
				If SFF->FF_IMPORTE <= aCF[nJ,2] .and. nVlrFF < SFF->FF_IMPORTE
					nVlrFF := SFF->FF_IMPORTE
					nRecFF := SFF->(Recno())
				EndIf
				SFF->(DbSkip())
			EndDo

			// Verrica se encotrou SFF para o valor total e se o valor � > 0
			If nRecFF > 0 .and. aCF[nJ,2] > 0
				SFF->(DbGoTo(nRecFF))
				// ISI com controle de Aliq por parametro
				If SA2->A2_ISICM=="1" .and. ALLTRIM(SA2->A2_MUN)=="ZARATE"
					aCF[nJ,3]	:= SuperGetMV("MV_ISIALQ1",.F.,0) //0.2 Parametrizar
				ElseIf ALLTRIM(SA2->A2_MUN)=="ZARATE"
					aCF[nJ,3]	:= SuperGetMV("MV_ISIALQ2",.F.,0)//0.3
				Else
					aCF[nJ,3]	:= SuperGetMV("MV_ISIALQ3",.F.,0) //0.4
				EndIf
			Else
				aCF[nJ,2]	:= 0 // Zera base de calculo quando nao tem CFOP no SFF
			EndIf
			nRecFF := 0
			nVlrFF := 0
		Next

		If lCalcLimp

			// Totaliza Base de calculo por CFOP
			For nJ:=1 To Len(aCF)
				nVlrBase := (aCF[nJ,2] * nRateio)
				nAliq	 :=  aCF[nJ,3] // Aliquota
				nValRet  := Round((nVlrBase*(aCF[nJ,3]/100))*nSigno,TamSX3("FE_VALIMP")[2])
				nValRet	 := (nValRet * nPercTot) // Redu��o de imposto
				nValTot	 += nValRet
            nValBasTot += nVlrBase

			Next
			//����������������������������������������������������������������Ŀ
			//� Gravar Retenciones.                                            �
			//������������������������������������������������������������������
			AAdd(aSFEISI,array(8))
			aSFEISI[Len(aSFEISI)][1] := SF1->F1_DOC   //FE_NFISCAL
			aSFEISI[Len(aSFEISI)][2] := SF1->F1_SERIE //FE_SERIE
			aSFEISI[Len(aSFEISI)][3] := nValBasTot	       //FE_VALBASE
			aSFEISI[Len(aSFEISI)][4] := nValTot	       //FE_VALIMP
			aSFEISI[Len(aSFEISI)][5] := Round((nValTot*100)/nSaldo,2)//FE_PORCRET
			aSFEISI[Len(aSFEISI)][6] := nValTot // FE_RETENC
			aSFEISI[Len(aSFEISI)][7] := nPercTot //FE_DEDUC
			aSFEISI[Len(aSFEISI)][8] := nAliq		//FE_ALIQ
			//FE_EST
		EndIf
	EndIf
EndIf

Return aSFEISI

// Proporcionaliza��o para reten��es de IVA e SUSS
Function F085PropIS(aOrdPg)
Local nTotPA :=0
Local nTotNF:=0
Local nX:=0
Local nI:=0
Local nProp:= 1
For nI := 1 To Len(aOrdPg)

	For nX := 1 To Len(aOrdPg[nI][4])
		DbSelectArea('SE2')
		MsGoTo(aOrdPg[nI][4][nX])
		cFornece := E2_FORNECE
		cLoja    := E2_LOJA
		SEK->(DbsetOrder(1))
		SEK->(DbSeek(xFilial("SE2")+SE2->E2_NUM+SE2->E2_TIPO) )
		If (SE2->E2_TIPO $ MVPAGANT)
  			nTotPA   += Round(xMoeda(SEK->EK_TOTANT,SE2->E2_MOEDA,1,dDataBase,5,aTxMoedas[SE2->E2_MOEDA][2]),MsDecimais(1))
 	   	Else
  			If lBxParc .and. SE2->E2_VLBXPAR > 0   .And.  SE2->E2_VLBXPAR <=SE2->E2_SALDO
   				nTotNF   += Round(xMoeda(SE2->E2_VLBXPAR,SE2->E2_MOEDA,1,dDataBase,5,aTxMoedas[SE2->E2_MOEDA][2]),MsDecimais(1))
  			Else
   				nTotNF   += Round(xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,1,dDataBase,5,aTxMoedas[SE2->E2_MOEDA][2]),MsDecimais(1))
  			EndIf
		EndIf
	Next
  	   	nProp:=(nTotNF-nTotPA)/nTotNF
Next

Return nProp

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F085ImpTes�Autor  � Ana Paula          � Data �  07/04/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Calcula base de calculo para PA automatico abatendo os      ���
���          � impostos relacionados na TES informada                     ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085a                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function F085ImpTes(nBaseImp,cFornece,cLoja)
Local nTotImp := 0
Private aHeader:={}

DEFAULT cFornece := ""
DEFAULT cLoja    := ""

aArea:=GetArea()

			SF4->(DbSetOrder(1))
			SF4->(DbSeek(xFilial("SF4")+cTes))

			nSaldo:=aSaldos[Len(aSaldos)]*-1
			nTotImp:= PegaAliq(cFornece,cLoja)

		  	nBaseRet:= Round((nSaldo/(nTotImp/100+1)),MsDecimais(1))

		If oBaseImp != Nil
			oBaseImp:Refresh()
		EndIf

Restarea(aArea)
Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CalcRetGNMnt�Autor  �Marcos Berto      � Data �  15/04/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Calculo de Ganancia para monotributista.                   ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function CalcRetGNMnt(cAgente,nSigno,aConGan,cFornece,cLoja,cDoc,cSerie,lPa,nTTit)
Local nAliq
Local nImposto
Local nBaseAtual
Local nRetMinima
Local aSFEGn   := {}
Local aArea		:=	GetArea()
Local lReduzGan	:= .T.
Local lCalcMon 	:= .F. //Validacao do calculo de Ganancia e IVA para monotributista
Local nMinimo 	:= 0
Local nMinUnit	:= 0
Local aGanComp	:= {}
Local nI

DEFAULT nSigno	:=	1
DEFAULT lPa 	:= .F.

For nI:=1  to Len(aConGan)
	If aConGan[nI][2] < 0
		aAdd(aGanComp,-1)
	Else
		aAdd(aGanComp,1)
	Endif
Next nI

For nI := 1 to Len(aConGan)

	dbSelectArea("SFF")
	dbGoTop()
	dbSetOrder(2)

	If dbSeek(xFilial("SFF")+aConGan[nI][1])
		If aConGan[nI][1] $ "G1|G2"
			nMinimo  	:= Iif(SFF->(FieldPos("FF_LIMITE"))>0,SFF->FF_LIMITE,0)
			nMinUnit 	:= Iif(SFF->(FieldPos("FF_MINUNIT"))>0,SFF->FF_MINUNIT,0)
			nRetMinima 	:= SFF->FF_IMPORTE
		Endif

		If SFF->FF_TIPO == "M"
			//Verifica se deve calcular a Ganancia
			lCalcMon := F085CheckLim(aConGan[nI][1],,cFornece,nMinimo,cDoc,cSerie,nMinUnit,"GAN",lPa,nTTit,Iif(lMsFil,SE2->E2_MSFIL,""))
		Endif
	Endif

	If lCalcMon
		SA2->( dbSetOrder(1) )
		If lMsFil .And. !Empty(xFilial("SA2")) .And. xFilial("SF1") == xFilial("SE2")
			SA2->( dbSeek(aConGan[nCount][5]+aConGan[nCount][4]) )
		Else
			SA2->( dbSeek(xFilial("SA2")+aConGan[nI][4]) )
		Endif

		If SA2->(FieldPos("A2_DTIREDG")) > 0 .And. SA2->(FieldPos("A2_DTFREDG")) > 0 ;
		   .And. !Empty(SA2->A2_DTIREDG) .And. !Empty(SA2->A2_DTFREDG)
		    If  ( Dtos(dDataBase)< Dtos(SA2->A2_DTIREDG) ) .Or. ( Dtos(Ddatabase) > Dtos(SA2->A2_DTFREDG) )
		    	lReduzGan:= .F.
		    EndIf
		EndIf

		If SA2->(FieldPos("A2_DTICALG")) > 0 .And. SA2->(FieldPos("A2_DTFCALG")) > 0 ;
		   .And. !Empty(SA2->A2_DTICALG) .And. !Empty(SA2->A2_DTFCALG)
		    If  ( Dtos(dDataBase)>= Dtos(SA2->A2_DTICALG) ) .And. ( Dtos(Ddatabase) <= Dtos(SA2->A2_DTFCALG) )
		   		Return(aSFEGN)
		    EndIf
		EndIf

		cFornece	:=	SA2->A2_COD
		cLoja		:=	SA2->A2_LOJA

		If !Empty(aConGan[nI][1]).And. aConGan[nI][2] <> 0.00

			nAliq      := 0.00
			nImposto   := 0.00
			nBaseAtual := aConGan[nI][2] * aGanComp[nI]

			dbSelectArea("SFF")
			dbSetOrder(2)
			dbSeek(xFilial("SFF")+aConGan[nI][1])

			If ( nBaseAtual > SFF->FF_IMPORTE )
				//������������������������������������������������������������Ŀ
				//� Calcular Gan�ncia baseando na Tabela de Gan�ncias.         �
				//��������������������������������������������������������������
				//�����������������������������������������������������������������������Ŀ
				//� Calculo da Gan�ncia:                                                  �
				//� Imposto := ( Retencao+Base de Calculo) * (Alquota Inscrito/100)       �
				//�������������������������������������������������������������������������

					nAliq    := SFF->FF_ALQNOIN
					nImposto := ((nBaseAtual - SFF->FF_IMPORTE) * (nAliq/100))* Iif(lReduzGan,(SA2->A2_PORGAN/100),1) * aGanComp[nI]

				//����������������������������������������������������������������Ŀ
				//� Generar las Retenci�n de Gan�ncias                             �
				//������������������������������������������������������������������
				Aadd(aSFEGn,Array(12))
				aSFEGn[Len(aSFEGn)][1] := ""
				aSFEGn[Len(aSFEGn)][2] := aConGan[nI][2]                            // FE_VALBASE
				aSFEGn[Len(aSFEGn)][3] := nAliq                                         // FE_ALIQ
				aSFEGn[Len(aSFEGn)][4] := Round(nImposto * nSigno,TamSX3("FE_VALIMP")[2])  // FE_VALIMP
				aSFEGn[Len(aSFEGn)][5] := Round(nImposto * nSigno,TamSX3("FE_RETENC")[2])  // FE_RETENC
				aSFEGn[Len(aSFEGn)][6] := 0/*nDeduc*/                                        // FE_DEDUC
				aSFEGn[Len(aSFEGn)][7] := aConGan[nI][1]                                     // FE_CONCEPT
				aSFEGn[Len(aSFEGn)][8] := SA2->A2_PORGAN                                // FE_PORCRET
				aSFEGn[Len(aSFEGn)][9] := aConGan[nI][3]                               // FE_CONCEPT
		   		If SA2->(FieldPos("A2_CODCOND")*FieldPos("A2_CONDO")*FieldPos("A2_PERCCON")) > 0 .And.SA2->A2_CONDO == "2"
					aSFEGn[Len(aSFEGn)][10] := SA2->A2_COD                              // FE_PORCRET
					aSFEGn[Len(aSFEGn)][11] := SA2->A2_LOJA                                // FE_PORCRET
				Else
					aSFEGn[Len(aSFEGn)][10] := ''                              // FE_PORCRET
					aSFEGn[Len(aSFEGn)][11] := ''                              // FE_PORCRET
				Endif
				aSFEGn[Len(aSFEGn)][12] := Iif(aGanComp[nI] < 0,.T.,.F.)
			Endif
		EndIf
	Endif
Next nI
RestArea(aArea)
Return aSFEGN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CalcRetIM �Autor  �Marcos Berto        � Data �  15/04/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Calculo de IVA para monotributista                         ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CalcRetIM2�Autor  �Marcos Berto        � Data �  15/04/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Calculo de IVA para monotributista - Nota de Cr�dito       ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F085CheckLim  �Autor  �Bruno S./Marcos � Data �  15/04/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Realizaza a verificacao das operacoes dos ultimos 12 meses,���
���          � pagos ou n�o                                               ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function F085CheckLim(cConcepto,aCF,cFornece,nMinimo,cDoc,cSerie,nMinUnit,cImposto,lPa,nSD,cFilOr)
Local cDataIni	:=	""
Local cDataFim	:= 	""
Local dDataTmp	:=	dDataBase
Local nCompras	:=	0
Local nI   		:= 0
Local lRet := .F.

#IFDEF TOP
	Local cQuery	:=	""
	Local cAlias	:=	""
#ELSE
	Local nValMax 	:= 0
	Local nValAux 	:= 0
	Local nMoeda	:= 1
#ENDIF

DEFAULT lPa := .F.
DEFAULT nSd := 1
DEFAULT cFilOr := ""

//Considera 12 meses retroativo, a partir do penultimo mes do fato gerador - para Ingresos Brutos.
If cImposto == "IB"
	dDataTmp := Ctod("01/"+StrZero(Month(dDataBase)-1,2)+"/"+Str(Iif(Month(dDataBase)==12,Year(dDataBase)-1,Year(dDataBase)),4))-1
Endif

cDataFim := Dtos(dDataTmp)
If cImposto == "IB"
	dDataTmp++
	cDataIni :=	Str(Year(dDataTmp)-1,4)+StrZero(Month(dDataTmp),2)+StrZero(Day(dDataTmp),2)
Else // Para IVA e GN ser� considerado o mes da ordem de pago + os 11 meses anteiores
	IF  (Month(dDataTmp) - 11) <= 0
		cDataIni := Str(Year(dDataTmp)-1,4) + StrZero(Month(dDataTmp)+1,2)+ "01"
	Else
		cDataIni := Str(Year(dDataTmp),4) + StrZero(Month(dDataTmp)-11,2)+ "01"
	EndIf
EndIf

#IFDEF TOP

	/*
	//�����������������������������������������������������Ŀ
	//�	1a. Validacao                                       �
	//�		Cosas muebles - Preco unitario superior a $870  �
	//�������������������������������������������������������
	*/
	If (cConcepto == "G2" .Or. cConcepto == "I2" .Or. cConcepto == "B2") .And. !lPa

		If nSD == 1	.And. cImposto == "IB"
			cQuery 	:=  "SELECT D1_VUNIT, F1_MOEDA FROM "+RetSqlName("SD1")+" SD1, "+RetSqlName("SB1")+" SB1 , "+RetSqlName("SF1")+" SF1 "
			cQuery	+=	" WHERE"

			If !lMsFil
				cQuery	+=	" D1_FILIAL = '"+xFilial("SD1")+"' AND "
				cQuery	+=	" F1_FILIAL = '"+xFilial("SF1")+"' AND "
				cQuery	+=	" B1_FILIAL = '"+xFilial("SB1")+"' AND "
			Else
				cQuery	+=	" F1_FILIAL = D1_FILIAL AND "
				If xFilial('SB1') == xFilial('SD1')
					cQuery  +=  " D1_FILIAL  = B1_FILIAL AND "
				Endif
			Endif

			If cImposto == "IVA" .Or. cImposto == "IB"
				cQuery += "("
				For nI := 1 to Len(aCF)
					cQuery  +=  " D1_CF    = '"+aCF[nI][1]+"' "

					If nI == Len(aCF)
						cQuery += ") AND "
					Else
						cQuery += " OR "
					Endif
				Next nI
			Elseif cImposto == "GAN"
				cQuery  +=  " B1_CMONGAN    = '"+cConcepto+"' AND "
			Endif
			cQuery	+=	" D1_FORNECE 	= '"+cFornece+"' AND " //NAO INCLUIR A LOJA
			cQuery	+=	SerieNfId("SD1",3,"D1_SERIE")+" = '"+cSerie+"' AND "
			cQuery	+=	" D1_DOC        = '"+cDoc+"' AND "

			cQuery  += " D1_COD     = B1_COD AND "
			cQuery  += " D1_FORNECE = F1_FORNECE AND "
			cQuery  += " D1_SERIE   = F1_SERIE AND "
			cQuery  += " D1_DOC     = F1_DOC AND "

			cQuery	+=	" SB1.D_E_L_E_T_ = '' AND "
			cQuery	+=	" SD1.D_E_L_E_T_ = '' AND "
			cQuery	+=	" SF1.D_E_L_E_T_ = '' "

			cQuery 	:= 	ChangeQuery(cQuery)
			cAlias	:=	GetNextAlias()
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.)

			While !Eof()
				If xMoeda(D1_VUNIT,F1_MOEDA,1,dDataBase) > nMinUnit .And. nMinUnit > 0
					lRet := .T.
					Exit
				Endif
				dbSkip()
			Enddo

			DbCloseArea()

		Elseif nSD == 2 .And. cImposto == "IB"

			cQuery 	:=  "SELECT D2_PRCVEN, F2_MOEDA FROM "+RetSqlName("SD2")+" SD2, "+RetSqlName("SB1")+" SB1 , "+RetSqlName("SF2")+" SF2 "
			cQuery	+=	" WHERE B1_FILIAL = '"+xFilial("SB1")+"' AND "

			If !lMsFil
				cQuery	+=	" D2_FILIAL = '"+xFilial("SD2")+"' AND "
				cQuery	+=	" F2_FILIAL = '"+xFilial("SF2")+"' AND "
				cQuery	+=	" B1_FILIAL = '"+xFilial("SB1")+"' AND "
			Else
				cQuery	+=	" F2_FILIAL = D2_FILIAL AND "
				If xFilial('SB1') == xFilial('SD2')
					cQuery  +=  " D2_FILIAL  = B1_FILIAL AND "
				Endif
			Endif

			If cImposto == "IVA" .Or. cImposto == "IB"
				cQuery += "("
				For nI := 1 to Len(aCF)
					cQuery  +=  " D2_CF    = '"+aCF[nI][2]+"' "

					If nI == Len(aCF)
						cQuery += ") AND "
					Else
						cQuery += " OR "
					Endif
				Next nI
			Elseif cImposto == "GAN"
				cQuery  +=  " B1_CMONGAN    = '"+cConcepto+"' AND "
			Endif
			cQuery	+=	" D2_CLIENTE 	= '"+cFornece+"' AND " //NAO INCLUIR A LOJA
			cQuery	+=	SerieNfId("SD2",3,"D2_SERIE")+" = '"+cSerie+"' AND "
			cQuery	+=	" D2_DOC        = '"+cDoc+"' AND "

			cQuery  += " D2_COD     = B1_COD AND "
			cQuery  += " D2_CLIENTE = F2_CLIENTE AND "
			cQuery  += " D2_SERIE   = F2_SERIE AND "
			cQuery  += " D2_DOC     = F2_DOC AND "

			cQuery	+=	" SB1.D_E_L_E_T_ = '' AND "
			cQuery	+=	" SD2.D_E_L_E_T_ = '' AND "
			cQuery	+=	" SF2.D_E_L_E_T_ = '' "

			cQuery 	:= 	ChangeQuery(cQuery)
			cAlias	:=	GetNextAlias()
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.)

			While !Eof()
				If xMoeda(D2_PRCVEN,F2_MOEDA,1,dDataBase) > nMinUnit .And. nMinUnit > 0
					lRet := .T.
					Exit
				Endif
				dbSkip()
			Enddo

			DbCloseArea()

		Endif

	Endif

	/*
	//�����������������������������������������������������������������Ŀ
	//�	2a. Validacao                                                   �
	//�		a. Locaciones - Soma superior a $72.000 (concepto = G1)     �
	//�		b. Cosas muebles - Soma superior a $144.000 (concepto = G2) �
	//�������������������������������������������������������������������
	*/

	If !lRet .And. (!cImposto == "IB" .Or. (cImposto == "IB" .And. cConcepto == "B2") )
		//Somar acumulado
		cQuery	:=	" SELECT SUM(D1_TOTAL) D1_TOTAL, F1_MOEDA FROM "+RetSqlName("SD1")+" SD1, "+RetSqlName("SF1")+" SF1, "+RetSqlName("SB1")+" SB1 "
		cQuery	+=	" WHERE "
		If !lMsFil
			cQuery	+=	" D1_FILIAL = '"+xFilial("SD1")+"' AND "
			cQuery	+=	" F1_FILIAL = '"+xFilial("SF1")+"' AND "
			cQuery	+=	" B1_FILIAL = '"+xFilial("SB1")+"' AND "
		Else
			cQuery	+=	" F1_FILIAL = D1_FILIAL AND "
			If xFilial('SB1') == xFilial('SD1')
				cQuery  +=  " D1_FILIAL  = B1_FILIAL AND "
			Endif
		Endif
		cQuery	+=	" D1_FORNECE 	= '"+cFornece+ "' AND " //NAO INCLUIR A LOJA
		cQuery	+=	" F1_SERIE 		= D1_SERIE AND "
		cQuery	+=	" F1_DOC 		= D1_DOC AND "
		cQuery	+=	" F1_ESPECIE 	= D1_ESPECIE AND "
		cQuery	+=	" F1_LOJA 		= D1_LOJA AND "
		cQuery	+=	" F1_FORNECE	= D1_FORNECE AND "
		cQuery	+=	" F1_FILIAL		= D1_FILIAL AND "
		cQuery  +=  " D1_COD        = B1_COD AND "

		cQuery	+=	" D1_TIPO IN ('C','N') AND "

		If cImposto == "IVA" .Or. cImposto == "IB"
			cQuery += "("
			For nI := 1 to Len(aCF)
				cQuery  +=  " D1_CF    = '"+aCF[nI][1]+"' "

				If nI == Len(aCF)
					cQuery += ") AND "
				Else
					cQuery += " OR "
				Endif
			Next nI
		Elseif cImposto == "GAN"
			cQuery  +=  " B1_CMONGAN    = '"+cConcepto+"' AND "
		Endif

		cQuery	+=	" D1_EMISSAO between '"+cDataIni+"' AND '"+cDataFim+"' AND "

		cQuery	+=	" SF1.D_E_L_E_T_ = '' AND "
		cQuery	+=	" SB1.D_E_L_E_T_ = '' AND "
		cQuery	+=	" SD1.D_E_L_E_T_ = '' "
		cQuery	+=	" GROUP BY F1_MOEDA "

		cQuery 	:= 	ChangeQuery(cQuery)
		cAlias	:=	GetNextAlias()
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.)
		While !Eof()
			nCompras +=	xMoeda(D1_TOTAL,F1_MOEDA,1,dDataBase)
			DbSkip()
		EndDo

		DbCloseArea()

		cQuery	:=	" SELECT SUM(D2_TOTAL) D2_TOTAL, F2_MOEDA FROM "+RetSqlName("SD2")+" SD2, "+RetSqlName("SF2")+" SF2, "+RetSqlName("SB1")+" SB1 "
		cQuery	+=	" WHERE "
		If !lMsFil
			cQuery	+=	" D2_FILIAL = '"+xFilial("SD2")+"' AND "
			cQuery	+=	" F2_FILIAL = '"+xFilial("SF2")+"' AND "
			cQuery	+=	" B1_FILIAL = '"+xFilial("SB1")+"' AND "
		Else
			cQuery	+=	" F2_FILIAL = D2_FILIAL AND "
			If xFilial('SB1') == xFilial('SD2')
				cQuery  +=  " D2_FILIAL  = B1_FILIAL AND "
			Endif
		Endif
		cQuery	+=	" D2_CLIENTE 	= '"+cFornece+ "' AND " //NAO INCLUIR A LOJA
		cQuery	+=	" F2_SERIE 		= D2_SERIE AND "
		cQuery	+=	" F2_DOC 		= D2_DOC AND "
		cQuery	+=	" F2_ESPECIE 	= D2_ESPECIE AND "
		cQuery	+=	" F2_LOJA 		= D2_LOJA AND "
		cQuery	+=	" F2_CLIENTE	= D2_CLIENTE AND "
		cQuery	+=	" F2_FILIAL		= D2_FILIAL AND "
		cQuery  +=  " D2_COD        = B1_COD AND "

		cQuery	+=	" D2_TIPO = 'D' AND "

		If cImposto == "IVA" .Or. cImposto == "IB"
			cQuery += "("
			For nI := 1 to Len(aCF)
				cQuery  +=  " D2_CF    = '"+aCF[nI][2]+"' "

				If nI == Len(aCF)
					cQuery += ") AND "
				Else
					cQuery += " OR "
				Endif

			Next nI
		Elseif cImposto == "GAN"
			cQuery  +=  " B1_CMONGAN    = '"+cConcepto+"' AND "
		Endif

		cQuery	+=	" D2_EMISSAO between '"+cDataIni+"' AND '"+cDataFim+"' AND "

		cQuery	+=	" SF2.D_E_L_E_T_ = '' AND "
		cQuery	+=	" SB1.D_E_L_E_T_ = '' AND "
		cQuery	+=	" SD2.D_E_L_E_T_ = '' "
		cQuery	+=	" GROUP BY F2_MOEDA "
		cQuery 	:= 	ChangeQuery(cQuery)
		cAlias	:=	GetNextAlias()
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.)

		While !Eof()
			nCompras -=	xMoeda(D2_TOTAL,F2_MOEDA,1,dDataBase)
			DbSkip()
		EndDo
		DbCloseArea()

		//Verificacao dos titulos inserido manualmente - Ganancia
		If cConcepto $ "G1|G2"
			cQuery := " SELECT SUM(E2_VALOR) E2_VALOR, E2_MOEDA  FROM "+RetSqlName("SE2")+" SE2 ,"+RetSqlName("SA2")+" SA2 "
			cQuery += " WHERE "
			//se o SA2 � exclusivo entao trabalho com as filiais normalmente
			If !EMPTY(xFilial('SA2'))
				cQuery	+=	" E2_FILIAL = '"+xFilial("SE2")+"' AND "
			Endif
			cQuery += " E2_FORNECE = '"+cFornece+"' AND "
			cQuery += " E2_TIPO <> '" + MVCHEQUE + "' AND "
			cQuery += " A2_CMONGAN = '"+cConcepto+"' AND "
			cQuery += " A2_COD = E2_FORNECE AND "
			cQuery += " E2_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND "

			cQuery += " NOT EXISTS ( "
			cQuery += " SELECT D1_SERIE, D1_DOC FROM "+RetSqlName("SD1")+" SD1 "
			cQuery += " WHERE "
			If xFilial('SE2') == xFilial('SD1')
				cQuery	+=	" E2_FILIAL = D1_FILIAL AND "
			ElseIf lMsFil
				cQuery	+=	" E2_MSFIL = D1_FILIAL AND "
			EndIf
			cQuery += " D1_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND "
			cQuery += " D1_FORNECE = '"+cFornece+"' AND "
			cQuery += " D1_SERIE   = E2_PREFIXO AND "
			cQuery += " D1_DOC     = E2_NUM AND "

			cQuery += " SD1.D_E_L_E_T_ = ' ' "

			cQuery += " GROUP BY D1_DOC, D1_SERIE ) AND "

			cQuery += " SE2.D_E_L_E_T_ = ' ' "

			cQuery += " GROUP BY E2_MOEDA "

			cQuery 	:= 	ChangeQuery(cQuery)
			cAlias	:=	GetNextAlias()
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.)
			While !Eof()
				nCompras +=	xMoeda(E2_VALOR,E2_MOEDA,1,dDatabase)
				DbSkip()
			EndDo

			DbCloseArea()
		Endif

		lRet := nCompras >= nMinimo
	Endif

#ELSE

	/*
	//�����������������������������������������������������Ŀ
	//�	1a. Validacao                                       �
	//�		Cosas muebles - Preco unitario superior a $870  �
	//�������������������������������������������������������
	*/
	If (cConcepto == "G2" .Or. cConcepto == "I2" .Or. cConcepto == "B2") .And. !lPa
		If nSD == 1	.And. cImposto == "IB"

			dbSelectArea("SD1")
			dbGoTop()
			If lMsFil
				SD1->(dbSeek(cFilOr+cDoc+cSerie+cFornece))
			Else
				SD1->(dbSeek(xFilial("SD1")+cDoc+cSerie+cFornece))
			EndIf
			If SD1->(FOUND())
				While !Eof() .And.;
					   SD1->D1_FILIAL == Iif(lMsFil,SD1->D1_MSFIL,xFilial("SD1")) .And. SD1->D1_DOC == cDoc .And.;
					   SerieNfId('SD1',2,'D1_SERIE') == cSerie .And. SD1->D1_FORNECE == cFornece

						dbSelectArea("SF1")
						dbGoTop()
		   				dbSetOrder(1)
						If lMsFil
							SF1->(dbSeek(cFilOr+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_TIPO))
						Else
							SF1->(dbSeek(xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_TIPO))
						EndIf
						If SF1->(Found())
							nMoeda := SF1->F1_MOEDA
						Endif

						//Ganancia
					   If cImposto == "GAN"
							dbSelectArea("SB1")
							dbGoTop()
							dbSetOrder(1)

							If SB1->(DbSeek(Iif(lMsFil .And. !Empty(xFilial("SB1")),SD1->D1_MSFIL,xFilial("SB1")) + SD1->D1_COD))
								If SB1->B1_CMONGAN == cConcepto
									nValAux := xMoeda(SD1->D1_VUNIT,nMoeda,1,dDataBase)
									If nValAux > nValMax
										nValMax := nValAux
									Endif
								Endif
							Endif
						ElseIf cImposto == "IVA" .Or. cImposto == "IB"

							For nI := 1 to Len(aCF)
								If 	aCF[nI][1] == SD1->D1_CF
										nValAux := xMoeda(SD1->D1_VUNIT,nMoeda,1,dDataBase)
										If nValAux > nValMax
											nValMax := nValAux
										Endif
								Endif
							Next nI
						Endif
				SD1->(dbSkip())
				Enddo
			Endif

		Elseif nSD == 2 .And. cImposto == "IB"

			dbSelectArea("SD2")
			dbGoTop()
			dbSetOrder(1)

			If lMsfil
				SD2->(dbSeek(cFilOr+cDoc+cSerie+cFornece))
			Else
				SD2->(dbSeek(xFilial("SD2")+cDoc+cSerie+cFornece))
			EndIf

			If SD2->(Found())
				While !Eof() .And.;
					   SD2->D2_FILIAL == Iif(lMsfil,SD2->D2_MSFIL,xFilial("SD2")) .And. SD2->D2_DOC == cDoc .And.;
					   SerieNfId('SD2',2,'D2_SERIE') == cSerie .And. SD2->D2_CLIENTE == cFornece

						dbSelectArea("SF2")
						dbGoTop()
						dbSetOrder(1)
						If lMsFil
							SF2->(dbSeek(SD2->D2_MSFIL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_TIPO))
			         Else
							SF2->(dbSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_TIPO))
			         EndIf
						If SF2->(FOUND())
							nMoeda := SF2->F2_MOEDA
						Endif

						//Ganancia
					   If cImposto == "GAN"
							dbSelectArea("SB1")
							dbGoTop()
							dbSetOrder(1)

							If SB1->(DbSeek(Iif(lMsFil .And. !Empty(xFilial("SB1")),SD2->D2_MSFIL,xFilial("SB1")) + SD2->D2_COD))
								If SB1->B1_CMONGAN == cConcepto
									nValAux := xMoeda(SD2->D2_PRCVEN,nMoeda,1,dDataBase)
									If nValAux > nValMax
										nValMax := nValAux
									Endif
								Endif
							Endif
						ElseIf cImposto == "IVA" .Or. cImposto == "IB"
							For nI := 1 to Len(aCF)
								If 	aCF[nI][2] == SD2->D2_CF
									nValAux := xMoeda(SD2->D2_PRCVEN,nMoeda,1,dDataBase)
									If nValAux > nValMax
										nValMax := nValAux
									Endif
								Endif
							Next nI
						Endif
				SD1->(dbSkip())
				Enddo
			Endif

		Endif

		If nValMax > nMinUnit .And. nMinUnit > 0
			lRet := .T.
		Endif

	Endif

	/*
	//�����������������������������������������������������������������Ŀ
	//�	2a. Validacao                                                   �
	//�		a. Locaciones - Soma superior a $72.000 (concepto = G1)     �
	//�		b. Cosas muebles - Soma superior a $144.000 (concepto = G2) �
	//�������������������������������������������������������������������
	*/
	If !lRet .And. (!cImposto == "IB" .Or. (cImposto == "IB" .And. cConcepto == "B2") )

		//Faturas de entrada
		dbSelectArea("SD1")
		dbGoTop()
		dbSetOrder(10)

		If lMsFil
			SD1->(dbSeek(cFilOr+cFornece))
		Else
			SD1->(dbSeek(xFilial("SD1")+cFornece))
		EndIf
		If SD1->(FOUND())
			While !Eof() .And.;
				   SD1->D1_FILIAL == Iif(lMsFil,SD1->D1_MSFIL,xFilial("SD1")) .And. SD1->D1_FORNECE == cFornece

				If (SD1->D1_EMISSAO >= Stod(cDataIni) .And. SD1->D1_EMISSAO <= Stod(cDataFim))

					dbSelectArea("SF1")
					dbGoTop()
	   				dbSetOrder(1)

					If lMsFil
						SF1->(dbSeek(SD1->D1_MSFIL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_TIPO))
					Else
						SF1->(dbSeek(xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_TIPO))
					EndIf
					If SF1->(Found())
						nMoeda := SF1->F1_MOEDA
					Endif

					//Ganancia
					If cImposto == "GAN"
						dbSelectArea("SB1")
						dbGoTop()
						dbSetOrder(1)
						If SB1->(DbSeek(Iif(lMsFil .And. !Empty(xFilial("SB1")),SD1->D1_MSFIL,xFilial("SB1")) + SD1->D1_COD))
							If SB1->B1_CMONGAN == cConcepto
								nCompras += xMoeda(SD1->D1_TOTAL,nMoeda,1,dDatabase)
							Endif
						Endif
					ElseIf cImposto == "IVA" .Or. cImposto == "IB"
						For nI := 1 to Len(aCF)
							If 	aCF[nI][1] == SD1->D1_CF
								nCompras += xMoeda(SD1->D1_TOTAL,nMoeda,1,dDatabase)
							Endif
						Next nI
					Endif
				Endif
			SD1->(dbSkip())
			Enddo
		Endif

		//Notas de Credito
		dbSelectArea("SD2")
		dbGoTop()
		dbSetOrder(9)
		If lMsFil
			SD2->(dbSeek(cFilOr+cFornece))
		Else
			SD2->(dbSeek(xFilial("SD2")+cFornece))
		EndIf
		If SD2->(Found())
			While !Eof() .And. SD2->D2_FILIAL == Iif(lMsFil,SD2->D2_MSFIL,xFilial("SD2")) .And. SD2->D2_CLIENTE == cFornece

				If (SD2->D2_EMISSAO >= Stod(cDataIni) .And. SD2->D2_EMISSAO <= Stod(cDataFim))

					dbSelectArea("SF2")
					dbGoTop()
	   				dbSetOrder(1)

					If lMsFil
		   				SF2->(dbSeek(SD2->D2_MSFIL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_TIPO))
	   				Else
		   				SF2->(dbSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_TIPO))
	   				EndIf

					If SF2->(Found())
						nMoeda := SF2->F2_MOEDA
					Endif

					//Ganancia
					If cImposto == "GAN"
						dbSelectArea("SB1")
						dbGoTop()
						dbSetOrder(1)
						If SB1->(DbSeek(Iif(lMsFil .And. !Empty(xFilial("SB1")),SD2->D2_MSFIL,xFilial("SB1")) + SD2->D2_COD))
							If SB1->B1_CMONGAN == cConcepto
								nCompras -= xMoeda(SD2->D2_TOTAL,nMoeda,1,dDatabase)
							Endif
						Endif
					ElseIf cImposto == "IVA" .Or. cImposto == "IB"
						For nI := 1 to Len(aCF)
							If 	aCF[nI][2] == SD2->D2_CF
								nCompras -= xMoeda(SD2->D2_TOTAL,nMoeda,1,dDatabase)
							Endif
						Next nI
					Endif
				Endif
			SD2->(dbSkip())
			Enddo
		Endif

		//Titulos manuais
		dbSelectArea("SE2")
		dbGoTop()
		dbSetOrder(6)

		If lMsFil
			SE2->(dbSeek(cFilOr+cFornece))
		Else
			SE2->(dbSeek(xFilial("SE2")+cFornece))
		EndIf
		If SE2->(Found())
			While !Eof() .And. SE2->E2_FILIAL == Iif(lMsFil,cFilOr,xFilial("SE2")) .And. SE2->E2_FORNECE == cFornece
				If (SE2->E2_EMISSAO >= Stod(cDataIni) .And. SE2->E2_EMISSAO <= Stod(cDataFim))

					nMoeda := SE2->E2_MOEDA

						dbSelectArea("SD1")
						dbGoTop()
						dbSetOrder(1)

						If lMsFil
							SD1->(dbSeek(SE2->E2_MSFIL+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE))
						Else
							SD1->(dbSeek(xFilial("SD1")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE))
						EndIf

						If !Found()
							nCompras += xMoeda(SE2->E2_VALOR,nMoeda,1,dDatabase)
						Endif
				Endif
			SE2->(dbSkip())
			Enddo
		Endif
		lRet := nCompras >= nMinimo
	Endif

#ENDIF

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F085TxMoed �Autor  �Totvs              � Data �  27/08/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Inicializar Array com as cotacoes e Nomes de Moedas segundo ���
���          �o arquivo SM2                                               ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function F085TxMoed()
Local nC := MoedFin()
Local nA := 0
Local aTxMoedas := {}
Local cMoedaTx	:= ""

/*
//����������������������������������������������������������������������Ŀ
//�A moeda 1 e tambem inclusa como um dummy, nao vai ter uso,            �
//�mas simplifica todas as chamadas a funcao xMoeda, ja que posso        �
//�passara a taxa usando a moeda como elemento do Array atxMoedas        �
//�Exemplo xMoeda(E1_VALOR,E1_MOEDA,1,dDataBase,,aTxMoedas[E1_MOEDA][2]) �
//�Bruno - Paraguay 25/07/2000                                           �
//������������������������������������������������������������������������
*/
//Inicializar Array com as cotacoes e Nomes de Moedas segundo o arquivo SM2
Aadd(aTxMoedas,{"",1,PesqPict("SM2","M2_MOEDA1")})
For nA	:=	2	To nC
	cMoedaTx	:=	Str(nA,IIf(nA <= 9,1,2))
	If !Empty(GetMv("MV_MOEDA"+cMoedaTx))
		Aadd(aTxMoedas,{GetMv("MV_MOEDA"+cMoedaTx),RecMoeda(dDataBase,nA),PesqPict("SM2","M2_MOEDA"+cMoedaTx) })
	Else
		Exit
	Endif
Next

Return aTxMoedas

/*
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � CalcRetRIE � Autor � Jose Lucas          � Data � 25.06.98 ���
��+----------+------------------------------------------------------------���
���Descri��o � Calcular e Gerar Retencoes sobre Imposto sobre Empreitada  ���
��+----------+------------------------------------------------------------���
���Uso       � PAGO007                                                    ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
*/
Static Function CalcRetRIE(nSaldo,lPa,nSigno)
Local aSFERIE  	:= {}
Local nTotBase	:=	0
Local nTotImp	:=	0
Local nMoedaNF	:=	1

DEFAULT nSaldo 	:= 	0
DEFAULT lPa		:=	.F.
DEFAULT nSigno 	:= 	1

aArea:=GetArea()

If !lPa
	dbSelectArea("SF1")
	dbSetOrder(1)
	dbSeek(xFilial("SF1")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA)

	SA2->( dbSetOrder(1) )
	SA2->( dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA) )

	//���������������������������������������������������������������������Ŀ
	//� Retencao do Imposto sobre Empreitada                                �
	//�����������������������������������������������������������������������
	While Alltrim(SF1->F1_ESPECIE) <> AllTrim(SE2->E2_TIPO).And.!EOF()
		SF1->(DbSkip())
		Loop
	Enddo

	If AllTrim(SF1->F1_ESPECIE)==Alltrim(SE2->E2_TIPO).And.;
			xFilial("SF1")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA==;
			F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA

		nProp := Round(xMoeda(nSaldo,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,5),MsDecimais(1))/Round(xMoeda(SF1->F1_VALBRUT,SF1->F1_MOEDA,1,SF1->F1_DTDIGIT,5),MsDecimais(1))
		nTotBase	:=	SF1->F1_BASIMP3 * nProp
		nTotImp		:=	SF1->F1_VALIMP3 * nProp
		nMoedaNF	:=	SF1->F1_MOEDA

		If nTotBase > 0
			AAdd(aSFERIE,array(8))
			aSFERIE[Len(aSFERIE)][1] := SF1->F1_DOC
			aSFERIE[Len(aSFERIE)][2] := SF1->F1_SERIE
			aSFERIE[Len(aSFERIE)][3] := Round(xMoeda(nTotBase,nMoedaNF,1,,5,aTxMoedas[Max(nMoedaNF,1)][2]),MsDecimais(1)) * nSigno	//FE_VALBASE
			aSFERIE[Len(aSFERIE)][4] := Round(xMoeda(nTotImp ,nMoedaNF,1,,5,aTxMoedas[Max(nMoedaNF,1)][2]),MsDecimais(1)) * nSigno	//FE_VALIMP
			aSFERIE[Len(aSFERIE)][5] := 100
			aSFERIE[Len(aSFERIE)][6] := aSFERIE[Len(aSFERIE)][4]
			aSFERIE[Len(aSFERIE)][7] := SE2->E2_VALOR
			aSFERIE[Len(aSFERIE)][8] := SE2->E2_EMISSAO
		Endif

	Endif
Else
	If SE2->E2_TIPO $ MVPAGANT
		nTotPA := 0
		//PROCURA A RETENCAO GERADA PARA O PA
		nSaldoOri	:=	nSaldo
		nSaldo		:=	Round(xMoeda(nSaldo ,SE2->E2_MOEDA,1,,5,aTxMoedas[Max(SE2->E2_MOEDA,1)][2]),MsDecimais(1))
		SFE->(DbsetOrder(4))
		If	SFE->(DbSeek(xFilial("SFE")+SE2->E2_FORNECE+SE2->E2_LOJA+PADR(SE2->E2_ORDPAGO,Len(SFE->FE_NFISCAL))+"PA "+"3") )
 			nTotPA   += (nSaldoOri/SE2->E2_VALOR)*(SFE->FE_VALBASE/SE2->E2_VLCRUZ) * SFE->FE_RETENC
			If nTotPA > 0
				AAdd(aSFERIE,array(8))
				aSFERIE[Len(aSFERIE)][1] := SFE->FE_NFISCAL
				aSFERIE[Len(aSFERIE)][2] := SFE->FE_SERIE
				aSFERIE[Len(aSFERIE)][3] := nSaldo
				aSFERIE[Len(aSFERIE)][4] := nTotPa * -1
				aSFERIE[Len(aSFERIE)][5] := 100
				aSFERIE[Len(aSFERIE)][6] := nTotPa * -1
				aSFERIE[Len(aSFERIE)][7] := SE2->E2_VALOR
				aSFERIE[Len(aSFERIE)][8] := SE2->E2_EMISSAO
			Endif
		Endif
    Else
		dbSelectArea("SF2")
		dbSetOrder(1)
		dbSeek(xFilial("SF2")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA)

		SA2->( dbSetOrder(1) )
		SA2->( dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA) )

		//���������������������������������������������������������������������Ŀ
		//� Retencao do Imposto sobre Empreitada                                �
		//�����������������������������������������������������������������������
		While Alltrim(SF2->F2_ESPECIE) <> AllTrim(SE2->E2_TIPO).And.!EOF()
			SF2->(DbSkip())
			Loop
		Enddo

		If AllTrim(SF2->F2_ESPECIE)==Alltrim(SE2->E2_TIPO).And.;
				xFilial("SF2")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA==;
				F2_FILIAL+F2_DOC+F2_SERIE+F2_FORNECE+F2_LOJA

			nProp := Round(xMoeda(nSaldo,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,5),MsDecimais(1))/Round(xMoeda(SF2->F2_VALBRUT,SF2->F2_MOEDA,1,SF2->F2_DTDIGIT,5),MsDecimais(1))
			nTotBase	:=	SF1->F1_BASIMP3 * nProp
			nTotImp		:=	SF1->F1_VALIMP3 * nProp
			nMoedaNF	:=	SF1->F1_MOEDA

			If nTotBase > 0
				AAdd(aSFERIE,array(8))
				aSFERIE[Len(aSFERIE)][1] := SF2->F2_DOC
				aSFERIE[Len(aSFERIE)][2] := SF2->F2_SERIE
				aSFERIE[Len(aSFERIE)][3] := Round(xMoeda(nTotBase,nMoedaNF,1,,5,aTxMoedas[Max(nMoedaNF,1)][2]),MsDecimais(1)) * nSigno	//FE_VALBASE
				aSFERIE[Len(aSFERIE)][4] := Round(xMoeda(nTotImp ,nMoedaNF,1,,5,aTxMoedas[Max(nMoedaNF,1)][2]),MsDecimais(1)) * nSigno	//FE_VALIMP
				aSFERIE[Len(aSFERIE)][5] := 100
				aSFERIE[Len(aSFERIE)][6] := aSFERIE[Len(aSFERIE)][4]
				aSFERIE[Len(aSFERIE)][7] := SE2->E2_VALOR
				aSFERIE[Len(aSFERIE)][8] := SE2->E2_EMISSAO
			Endif

		Endif
    Endif
Endif
RestArea(aArea)

Return aSFERIE

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CalcIGV   �Autor  �ROBERTO R.MEZZALIRA � Data �  27/11/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Calculo de IGV 											  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION CALCIGV(nVlr)
Local nBaseIGV	:= 0
Local nVlrOper	:= 0
Local aSFEIGV	:= {}
Local cNRetIGV	:= ""

/* O parametro MV_NRETIGV indica quais comprovantes estao livres da retencao de igv. Nesse parametro devem ser
informados os c�digos dos comprovantes segundo a tabela CCL (CCL_CODGOV) */
cNRetIGV := GetMV("MV_NRETIGV",.T.,"")
SF2->(DbSetOrder(2))
If SF2->(DbSeek(xFilial("SF2") + SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_NUM + SE2->E2_PREFIXO))
	/* a retencao ocorre se nao houve detracao e se o tipo da fatura permitir */
	If SF2->F2_BASIMP1 > 0 .And. SF2->F2_BASIMP5 == 0 .And. !(SF2->F2_TPDOC $ cNRetIGV)
		nVlrOper := xMoeda(SF2->F2_BASIMP1 + SF2->F2_VALIMP1,SF2->F2_MOEDA,1,,5,,MsDecimais(1))
	Endif
EndIf
If nVlrOper > 0
	/* a retencao de IGV deve ser feita com valores na moeda 1 */
	nBaseIGV := xMoeda(nVlr,SE2->E2_MOEDA,1,,5,,MsDecimais(1))
	/*-*/
	AAdd(aSFEIGV,array(12))
	aSFEIGV[Len(aSFEIGV)][1] := SE2->E2_NUM
	aSFEIGV[Len(aSFEIGV)][2] := SE2->E2_PREFIXO
	aSFEIGV[Len(aSFEIGV)][3] := nBaseIGV 	//FE_VALBASE
	aSFEIGV[Len(aSFEIGV)][4] := 0
	aSFEIGV[Len(aSFEIGV)][5] := 100
	aSFEIGV[Len(aSFEIGV)][6] := 0
	aSFEIGV[Len(aSFEIGV)][7] := nBaseIGV
	aSFEIGV[Len(aSFEIGV)][8] := dDataBase
	aSFEIGV[Len(aSFEIGV)][9] := 0
	aSFEIGV[Len(aSFEIGV)][10] := SE2->E2_TIPO
	aSFEIGV[Len(aSFEIGV)][11] := -(nVlrOper)
	aSFEIGV[Len(aSFEIGV)][12] := -1
Endif
Return(Aclone(aSFEIGV))

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CalcRIR   � Jos� Lucas				� Data �  17/09/10    ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera��o do array aRets com as reten��es de ISRL, conforme  ���
���          � requerimentos para localiza��o Venezuela.                  ���
�������������������������������������������������������������������������͹��
���Sintaxe   � ExpA := CalcRIR(ExpN1,ExpN2)                               ���
�������������������������������������������������������������������������͹��
���Parametros� ExpN1 := nVlr := Valor do t�tulo (E2_VALOR).               ���
���          � ExpN2 := nTotOrden := Total da Ordem de Pago.              ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CALCRIR(nVlr,nTotOrden)
Local aSavArea  := GetArea()
Local nBaseRIR  := 0.00
Local nAliqRIR  := 0.00
Local aSFERIR   := {}
Local cQuery    := ""
Local nPosArray := 0

SB1->(dbSetOrder(1))
SFF->(dbSetOrder(14))

SA2->(dbSetOrder(1))
SA2->(dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA))

//Verificar se j� existe Reten��es geradas para o Documento NF/NDP/NCP
SFE->(dbSetOrder(4))
If SFE->(dbSeek(xFilial("SFE")+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_NUM+SE2->E2_PREFIXO)) //Forncedor+Loja+NotaFisal+Serie
	RestArea(aSavArea)
	Return aSFERIR
EndIf

If SE2->E2_TIPO $ "NF |NDP"	//Nota Fiscal de Compras e Nota de Debito a Proveedores.

	dbSelectArea("SF1")
	dbSetOrder(1)
	If dbSeek(xFilial("SF1")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA)
    	dbSelectArea("SD1")
    	dbSetOrder(1)
		If dbSeek(xFilial("SD1")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA)
    		While !Eof() .and. D1_FILIAL == xFilial("SD1") .and. D1_DOC == SE2->E2_NUM;
    	    	         .and. D1_SERIE == SE2->E2_PREFIXO .and. D1_FORNECE == SE2->E2_FORNECE;
    	       		     .and. D1_LOJA == SE2->E2_LOJA

	   			// Verificar se o Item tem RIR
				SB1->(dbSeek(xFilial("SB1")+SD1->D1_COD))
   		 		If !Empty(SB1->B1_GRTRIB)
    				// Pegar a aliquota de RIR na tela de complemento de impostos RIR
					If SFF->(dbSeek(xFilial("SFF")+"RIR"+SA2->A2_GRTRIB+SB1->B1_GRTRIB))
                	   nAliqRIR := SFF->FF_ALIQ
               	    EndIf
					nBaseRIR := SD1->D1_TOTAL
				EndIf
				//Inicializar array com as reten��es
				If nAliqRIR > 0 .and. nBaseRIR > 0 .and. fa085GetImpos("RIR","SD1")[3] > 0.00
					nPosArray := Ascan(aSFERIR,{|x| AllTrim(x[14]) == AllTrim(SFF->FF_CONCEPT)})
					If nPosArray == 0
						AAdd(aSFERIR,{"","",0,0,0,0,0,CTOD(""),0,"","","","","",""})
						nPosArray := Len(aSFERIR)
					EndIf
					aSFERIR[nPosArray][01] := SE2->E2_NUM
					aSFERIR[nPosArray][02] := SE2->E2_PREFIXO
					aSFERIR[nPosArray][03] += fa085GetImpos("RIR","SD1")[1]		//SF1->F1_BASIMPn###SD1->D1_BASIMPn
					aSFERIR[nPosArray][04] += fa085GetImpos("RIR","SD1")[3]		//SF1->F1_VALIMPn###SD1->D1_VALIMPn
   					aSFERIR[nPosArray][06] := aSFERIR[nPosArray][04]			//SF1->F1_VALIMPn
 					If aSFERIR[nPosArray][04] > 0.00
						aSFERIR[nPosArray][05] := Round((aSFERIR[nPosArray][06]/aSFERIR[nPosArray][04])*100,2)
					Else
						aSFERIR[nPosArray][05] := 0.00
					EndIf
   					aSFERIR[nPosArray][06] := aSFERIR[nPosArray][04]			//SF1->F1_VALIMPn
   					aSFERIR[nPosArray][07] += aSFERIR[nPosArray][03]  			//SF1->F1_BASIMPn
					aSFERIR[nPosArray][08] := dDataBase
					If aSFERIR[nPosArray][04] > 0 .and. aSFERIR[nPosArray][03] > 0.00
						aSFERIR[nPosArray][09] := Round((aSFERIR[nPosArray][04]/aSFERIR[nPosArray][03])*100,2)
					Else
						aSFERIR[nPosArray][09] := 0.00
					EndIf
					aSFERIR[nPosArray][10] := SE2->E2_TIPO
					aSFERIR[nPosArray][14] := SFF->FF_CONCEPT
					aSFERIR[nPosArray][15] := SFF->FF_IMPORTE
				EndIf
				SD1->(dbSkip())
			End
		EndIf
		If Len(aSFERIR) == 0
			//Garantir que se houve abatimentos na gera��o da nota gravar as reten��es como gravado em Compras.
			If Select("QRYRET") > 0
				dbSelectArea("QRYRET")
				dbCloseArea()
			EndIf
  	      	cQuery := "SELECT DISTINCT "
  	      	cQuery += "E2_PREFIXO, "
        	cQuery += "E2_NUM, "
        	cQuery += "E2_FORNECE, "
        	cQuery += "E2_LOJA, "
        	cQuery += "E2_TIPO, "
        	cQuery += "E2_VALOR, "
        	cQuery += "E2_SALDO "
        	cQuery += " FROM "
        	cQuery += RetSqlName("SE2") + " SE2 "
        	cQuery += "WHERE "
        	cQuery += " E2_FILIAL = '" + xFilial("SE2") + "' "
        	cQuery += " AND E2_PREFIXO = '" + SF1->F1_SERIE + "' "
        	cQuery += " AND E2_NUM = '" + SF1->F1_DOC + "' "
        	cQuery += " AND E2_FORNECE = '" + SF1->F1_FORNECE + "' "
        	cQuery += " AND E2_LOJA = '" + SF1->F1_LOJA + "' "
			cQuery += "ORDER BY E2_PREFIXO, E2_NUM, E2_FORNECE, E2_LOJA, E2_TIPO"
        	cQuery := ChangeQuery( cQuery )
			dbUseArea( .t., "TopConn", TCGenQry(,,cQuery),"QRYRET", .F., .F. )
			TCSetField( "QRYRET", "E2_VALOR", "N", TamSX3("E2_VALOR")[1], TamSX3("E2_VALOR")[2])
			TCSetField( "QRYRET", "E2_SALDO", "N", TamSX3("E2_SALDO")[1], TamSX3("E2_SALDO")[2])

        	QRYRET->(dbGoTop())

        	While QRYRET->(!Eof())

           		If AllTrim(QRYRET->E2_TIPO) $ "IR-" .and. QRYRET->E2_SALDO > 0.00

   					dbSelectArea("SD1")
    				dbSetOrder(1)
					If dbSeek(xFilial("SD1")+QRYRET->E2_NUM+QRYRET->E2_PREFIXO+QRYRET->E2_FORNECE+QRYRET->E2_LOJA)
    					While !Eof() .and. D1_FILIAL == xFilial("SD1") .and. D1_DOC == QRYRET->E2_NUM;
    	          		  	 		 .and. D1_SERIE == QRYRET->E2_PREFIXO .and. D1_FORNECE == QRYRET->E2_FORNECE;
    	             			     .and. D1_LOJA == QRYRET->E2_LOJA

                        	If fa085GetImpos("RIR","SF1")[3] > 0.00
   						   		// Verificar se o Item tem RIR
								SB1->(dbSeek(xFilial("SB1")+SD1->D1_COD))
   								// Pegar a aliquota de RIR na tela de complemento de impostos RIR
								SFF->(dbSeek(xFilial("SFF")+"RIR"+SA2->A2_GRTRIB+SB1->B1_GRTRIB))
 								//Montar array para gravar as reten��es na tabela SFE
								nPosArray := Ascan(aSFERIR,{|x| AllTrim(x[14]) == AllTrim(SFF->FF_CONCEPT)})
								If nPosArray == 0
									AAdd(aSFERIR,{"","",0,0,0,0,0,CTOD(""),0,"","","","","",""})
									nPosArray := Len(aSFERIR)
								EndIf
								aSFERIR[nPosArray][01] := QRYRET->E2_NUM
								aSFERIR[nPosArray][02] := QRYRET->E2_PREFIXO
								aSFERIR[nPosArray][03] := fa085GetImpos("RIR","SD1")[1]		//SF1->F1_BASIMPn
								aSFERIR[nPosArray][04] := fa085GetImpos("RIR","SD1")[3]		//SF1->F1_VALIMPn
   								aSFERIR[nPosArray][06] := QRYRET->E2_VALOR
								If aSFERIR[nPosArray][04] > 0.00
									aSFERIR[nPosArray][05] := Round((aSFERIR[nPosArray][06]/aSFERIR[nPosArray][04])*100,2)
								Else
									aSFERIR[nPosArray][05] := 0.00
								EndIf
   								aSFERIR[nPosArray][06] := QRYRET->E2_VALOR
   								aSFERIR[nPosArray][07] := aSFERIR[nPosArray][03]  //SF1->F1_VALMERC
								aSFERIR[nPosArray][08] := dDataBase
								If aSFERIR[nPosArray][04] > 0 .and. aSFERIR[nPosArray][03] > 0.00
									aSFERIR[nPosArray][09] := Round((aSFERIR[nPosArray][04]/aSFERIR[nPosArray][03])*100,2)
								Else
									aSFERIR[nPosArray][09] := 0.00
								EndIf
								aSFERIR[nPosArray][10] := QRYRET->E2_TIPO
								aSFERIR[nPosArray][14] := SFF->FF_CONCEPT
								aSFERIR[nPosArray][15] := SFF->FF_IMPORTE
            				EndIf
            				SD1->(dbSkip())
            			End
            		EndIf
            	EndIf
            	QRYRET->(dbSkip())
    		End
        	QRYRET->(dbCloseArea())
    	Endif
	EndIf

ElseIf SE2->E2_TIPO $ "NCP"	//Nota de Credito de Proveedores.

	dbSelectArea("SF2")
	dbSetOrder(1)
	If dbSeek(xFilial("SF2")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA)
    	dbSelectArea("SD2")
    	dbSetOrder(3)
		If dbSeek(xFilial("SD2")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA)
    		While !Eof() .and. D2_FILIAL == xFilial("SD2") .and. D2_DOC == SE2->E2_NUM;
    	    	         .and. D2_SERIE == SE2->E2_PREFIXO .and. D2_CLIENTE == SE2->E2_FORNECE;
    	       		     .and. D2_LOJA == SE2->E2_LOJA

	   			// Verificar se o Item tem RIR
				SB1->(dbSeek(xFilial("SB1")+SD2->D2_COD))
   		 		If !Empty(SB1->B1_GRTRIB)
    				// Pegar a aliquota de RIR na tela de complemento de impostos RIR
					If SFF->(dbSeek(xFilial("SFF")+"RIR"+SA2->A2_GRTRIB+SB1->B1_GRTRIB))
                	   nAliqRIR := SFF->FF_ALIQ
               	    EndIf
					nBaseRIR := SD2->D2_TOTAL
				EndIf
				//Inicializar array com as reten��es
				If nAliqRIR > 0 .and. nBaseRIR > 0 .and. fa085GetImpos("RIR","SD2")[3] > 0.00
					nPosArray := Ascan(aSFERIR,{|x| AllTrim(x[14]) == AllTrim(SFF->FF_CONCEPT)})
					If nPosArray == 0
						AAdd(aSFERIR,{"","",0,0,0,0,0,CTOD(""),0,"","","","","",""})
						nPosArray := Len(aSFERIR)
					EndIf
					aSFERIR[nPosArray][01] := SE2->E2_NUM
					aSFERIR[nPosArray][02] := SE2->E2_PREFIXO
					aSFERIR[nPosArray][03] += fa085GetImpos("RIR","SD2")[1]		//SF1->F1_BASIMPn###SD1->D1_BASIMPn
					aSFERIR[nPosArray][04] += fa085GetImpos("RIR","SD2")[3]		//SF1->F1_VALIMPn###SD1->D1_VALIMPn
   					aSFERIR[nPosArray][06] := aSFERIR[nPosArray][04]			//SF1->F1_VALIMPn
					If aSFERIR[nPosArray][04] > 0.00
						aSFERIR[nPosArray][05] := Round((aSFERIR[nPosArray][06]/aSFERIR[nPosArray][04])*100,2)
					Else
						aSFERIR[nPosArray][05] := 0.00
					EndIf
   					aSFERIR[nPosArray][06] := aSFERIR[nPosArray][04]			//SF1->F1_VALIMPn
   					aSFERIR[nPosArray][07] += aSFERIR[nPosArray][03]  			//SF1->F1_BASIMPn
					aSFERIR[nPosArray][08] := dDataBase
					If aSFERIR[nPosArray][04] > 0 .and. aSFERIR[nPosArray][06] > 0.00
						aSFERIR[nPosArray][09] := Round((aSFERIR[nPosArray][04]/aSFERIR[nPosArray][03])*100,2)
					Else
						aSFERIR[nPosArray][09] := 0.00
					EndIf
					aSFERIR[nPosArray][10] := SE2->E2_TIPO
					aSFERIR[nPosArray][14] := SFF->FF_CONCEPT
					aSFERIR[nPosArray][15] := SFF->FF_IMPORTE
				EndIf
				SD2->(dbSkip())
			End
		EndIf
		If Len(aSFERIR) == 0
			//Garantir que se houve abatimentos na gera��o da nota gravar as reten��es como gravado em Compras.
			If Select("QRYRET") > 0
				dbSelectArea("QRYRET")
				dbCloseArea()
			EndIf
  	      	cQuery := "SELECT DISTINCT "
  	      	cQuery += "E2_PREFIXO, "
        	cQuery += "E2_NUM, "
        	cQuery += "E2_FORNECE, "
        	cQuery += "E2_LOJA, "
        	cQuery += "E2_TIPO, "
        	cQuery += "E2_VALOR, "
        	cQuery += "E2_SALDO "
        	cQuery += " FROM "
        	cQuery += RetSqlName("SE2") + " SE2 "
        	cQuery += "WHERE "
        	cQuery += " E2_FILIAL = '" + xFilial("SE2") + "' "
        	cQuery += " AND E2_PREFIXO = '" + SF2->F2_SERIE + "' "
        	cQuery += " AND E2_NUM = '" + SF2->F2_DOC + "' "
        	cQuery += " AND E2_FORNECE = '" + SF2->F2_CLIENTE + "' "
        	cQuery += " AND E2_LOJA = '" + SF2->F2_LOJA + "' "
			cQuery += "ORDER BY E2_PREFIXO, E2_NUM, E2_FORNECE, E2_LOJA, E2_TIPO"
        	cQuery := ChangeQuery( cQuery )
			dbUseArea( .t., "TopConn", TCGenQry(,,cQuery),"QRYRET", .F., .F. )
			TCSetField( "QRYRET", "E2_VALOR", "N", TamSX3("E2_VALOR")[1], TamSX3("E2_VALOR")[2])
			TCSetField( "QRYRET", "E2_SALDO", "N", TamSX3("E2_SALDO")[1], TamSX3("E2_SALDO")[2])

        	QRYRET->(dbGoTop())

        	While QRYRET->(!Eof())

           		If AllTrim(QRYRET->E2_TIPO) $ "IR-" .and. QRYRET->E2_SALDO > 0.00

   					dbSelectArea("SD2")
    				dbSetOrder(3)
					If dbSeek(xFilial("SD2")+QRYRET->E2_NUM+QRYRET->E2_PREFIXO+QRYRET->E2_FORNECE+QRYRET->E2_LOJA)
    					While !Eof() .and. D2_FILIAL == xFilial("SD2") .and. D2_DOC == QRYRET->E2_NUM;
    	          		  	 		 .and. D2_SERIE == QRYRET->E2_PREFIXO .and. D2_CLIENTE == QRYRET->E2_FORNECE;
    	             			     .and. D2_LOJA == QRYRET->E2_LOJA

                        	If fa085GetImpos("RIR","SD2")[3] > 0.00
   						   		// Verificar se o Item tem RIR
								SB1->(dbSeek(xFilial("SB1")+SD1->D1_COD))
   								// Pegar a aliquota de RIR na tela de complemento de impostos RIR
								SFF->(dbSeek(xFilial("SFF")+"RIR"+SA2->A2_GRTRIB+SB1->B1_GRTRIB))
 								//Montar array para gravar as reten��es na tabela SFE
								nPosArray := Ascan(aSFERIR,{|x| AllTrim(x[14]) == AllTrim(SFF->FF_CONCEPT)})
								If nPosArray == 0
									AAdd(aSFERIR,{"","",0,0,0,0,0,CTOD(""),0,"","","","","",""})
									nPosArray := Len(aSFERIR)
								EndIf
								aSFERIR[nPosArray][01] := QRYRET->E2_NUM
								aSFERIR[nPosArray][02] := QRYRET->E2_PREFIXO
								aSFERIR[nPosArray][03] := fa085GetImpos("RIR","SD2")[1]		//SF1->F1_BASIMPn
								aSFERIR[nPosArray][04] := fa085GetImpos("RIR","SD2")[3]		//SF1->F1_VALIMPn
   								aSFERIR[nPosArray][06] := QRYRET->E2_VALOR
								If aSFERIR[nPosArray][04] > 0.00 .and. aSFERIR[nPosArray][06] > 0.00
									aSFERIR[nPosArray][05] := Round((aSFERIR[nPosArray][06]/aSFERIR[nPosArray][04])*100,2)
								Else
									aSFERIR[nPosArray][05] := 0.00
								EndIf
   								aSFERIR[nPosArray][06] := QRYRET->E2_VALOR
   								aSFERIR[nPosArray][07] := aSFERIR[nPosArray][03]  //SF1->F1_VALMERC
								aSFERIR[nPosArray][08] := dDataBase
								If aSFERIR[nPosArray][04] > 0 .and. aSFERIR[nPosArray][06] > 0.00
									aSFERIR[nPosArray][09] := Round((aSFERIR[nPosArray][04]/aSFERIR[nPosArray][03])*100,2)
								Else
									aSFERIR[nPosArray][09] := 0.00
								EndIf
								aSFERIR[nPosArray][10] := QRYRET->E2_TIPO
								aSFERIR[nPosArray][14] := SFF->FF_CONCEPT
								aSFERIR[nPosArray][15] := SFF->FF_IMPORTE
            				EndIf
            				SD1->(dbSkip())
            			End
            		EndIf
            	EndIf
            	QRYRET->(dbSkip())
    		End
        	QRYRET->(dbCloseArea())
    	Endif
	EndIf

EndIf
RestArea(aSavArea)
Return aSFERIR

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CalcIVAVEN  � Jos� Lucas				� Data �  17/09/10    ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera��o do array aRets com as reten��es de IVA,  conforme  ���
���          � requerimentos para localiza��o Venezuela.                  ���
�������������������������������������������������������������������������͹��
���Sintaxe   � ExpA := CalcIVAVEN(ExpN1,ExpN2)                            ���
�������������������������������������������������������������������������͹��
���Parametros� ExpN1 := nVlr := Valor do t�tulo (E2_VALOR).               ���
���          � ExpN2 := nTotOrden := Total da Ordem de Pago.              ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CalcIVAVEN(nVlr,nTotOrden)
Local aSavArea    := GetArea()
Local aSFEIVAVEN  := {}
Local cQuery      := ""
Local nPosArray   := 0

SA2->(dbSetOrder(1))
SA2->(dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA))

//Verificar se j� existe Reten��es geradas para o Documento NF/NDP/NCP
SFE->(dbSetOrder(4))
If SFE->(dbSeek(xFilial("SFE")+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_NUM+SE2->E2_PREFIXO)) //Forncedor+Loja+NotaFisal+Serie
	RestArea(aSavArea)
	Return aSFEIVAVEN
EndIf
If SE2->E2_TIPO $ "NF |NDP"	//Nota Fiscal de Compras e Nota de Debito a Proveedores.

	// Pesquisar nos documentos e verificar se possui itens com reten��o de IVA calculado.
	dbSelectArea("SF1")
	dbSetOrder(1)
	If dbSeek(xFilial("SF1")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA)
    	dbSelectArea("SD1")
	    dbSetOrder(1)
		If dbSeek(xFilial("SD1")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA)
    		While !Eof() .and. D1_FILIAL == xFilial("SD1") .and. D1_DOC == SE2->E2_NUM;
    		             .and. D1_SERIE == SE2->E2_PREFIXO .and. D1_FORNECE == SE2->E2_FORNECE;
    	    	         .and. D1_LOJA == SE2->E2_LOJA

				//Verificar de existe reten��o de IVA calculada.
				If fa085GetImpos("RV","SD1")[3] > 0
 					//Montar array para gravar as reten��es na tabela SFE
					AAdd(aSFEIVAVEN,{"","",0,0,0,0,0,CTOD(""),0,"","","","","",""})
					nPosArray := Len(aSFEIVAVEN)
					aSFEIVAVEN[nPosArray][01] := SE2->E2_NUM
					aSFEIVAVEN[nPosArray][02] := SE2->E2_PREFIXO
					aSFEIVAVEN[nPosArray][03] := fa085GetImpos("RV","SD1")[1]		//SF1->F1_BASIMPn###SD1->D1_BASIMPn
					aSFEIVAVEN[nPosArray][04] := SD1->D1_VALIMP1
					aSFEIVAVEN[nPosArray][05] := fa085GetImpos("RV","SD1")[2]
   					aSFEIVAVEN[nPosArray][06] := fa085GetImpos("RV","SD1")[3]
					aSFEIVAVEN[nPosArray][07] := aSFEIVAVEN[nPosArray][03]
					aSFEIVAVEN[nPosArray][08] := dDataBase
					aSFEIVAVEN[nPosArray][09] := SD1->D1_ALQIMP1
					aSFEIVAVEN[nPosArray][10] := SE2->E2_TIPO
					aSFEIVAVEN[nPosArray][14] := ""
					aSFEIVAVEN[nPosArray][15] := ""
				Endif
				SD1->(dbSkip())
			End

			If Len(aSFEIVAVEN) == 0
				//Garantir que se houve abatimentos na gera��o da nota gravar as reten��es como gravado em Compras.
				If Select("QRYRET") > 0
					dbSelectArea("QRYRET")
					dbCloseArea()
				EndIf
        		cQuery := "SELECT DISTINCT "
        		cQuery += "E2_PREFIXO, "
        		cQuery += "E2_NUM, "
        		cQuery += "E2_FORNECE, "
        		cQuery += "E2_LOJA, "
        		cQuery += "E2_TIPO, "
        		cQuery += "E2_VALOR, "
        		cQuery += "E2_SALDO "
        		cQuery += " FROM "
        		cQuery += RetSqlName("SE2") + " SE2 "
        		cQuery += "WHERE "
        		cQuery += " E2_FILIAL = '" + xFilial("SE2") + "' "
        		cQuery += " AND E2_PREFIXO = '" + SF1->F1_SERIE + "' "
        		cQuery += " AND E2_NUM = '" + SF1->F1_DOC + "' "
        		cQuery += " AND E2_FORNECE = '" + SF1->F1_FORNECE + "' "
        		cQuery += " AND E2_LOJA = '" + SF1->F1_LOJA + "' "
				cQuery += "ORDER BY E2_PREFIXO, E2_NUM, E2_FORNECE, E2_LOJA, E2_TIPO"
        		cQuery := ChangeQuery( cQuery )
				dbUseArea( .t., "TopConn", TCGenQry(,,cQuery),"QRYRET", .F., .F. )
				TCSetField( "QRYRET", "E2_VALOR", "N", TamSX3("E2_VALOR")[1], TamSX3("E2_VALOR")[2])
				TCSetField( "QRYRET", "E2_SALDO", "N", TamSX3("E2_SALDO")[1], TamSX3("E2_SALDO")[2])

        		QRYRET->(dbGoTop())

           		While QRYRET->(!Eof())

           			If AllTrim(QRYRET->E2_TIPO) $ "IV-" .and. QRYRET->E2_SALDO > 0.00
 						dbSelectArea("SD1")
    					dbSetOrder(1)
						If dbSeek(xFilial("SD1")+QRYRET->E2_NUM+QRYRET->E2_PREFIXO+QRYRET->E2_FORNECE+QRYRET->E2_LOJA)
    						While !Eof() .and. D1_FILIAL == xFilial("SD1") .and. D1_DOC == QRYRET->E2_NUM;
    	             					 .and. D1_SERIE == QRYRET->E2_PREFIXO .and. D1_FORNECE == QRYRET->E2_FORNECE;
    	             					 .and. D1_LOJA == QRYRET->E2_LOJA

								//Verificar de existe reten��o de IVA calculada.
								If fa085GetImpos("RV","SD1")[3] > 0
									//Montar array para gravar as reten��es na tabela SFE
 									AAdd(aSFEIVAVEN,{"","",0,0,0,0,0,CTOD(""),0,"","","","","",""})
									nPosArray := Len(aSFEIVAVEN)
									aSFEIVAVEN[nPosArray][01] := QRYRET->E2_NUM
									aSFEIVAVEN[nPosArray][02] := QRYRET->E2_PREFIXO
									aSFEIVAVEN[nPosArray][03] := fa085GetImpos("RV","SD1")[1]		//SF1->F1_BASIMPn
									aSFEIVAVEN[nPosArray][04] := SD1->D1_VALIMP1
									aSFEIVAVEN[nPosArray][05] := fa085GetImpos("RV","SD1")[2]
   									aSFEIVAVEN[nPosArray][06] := fa085GetImpos("RV","SD1")[3]
									aSFEIVAVEN[nPosArray][07] := aSFEIVAVEN[nPosArray][03]
									aSFEIVAVEN[nPosArray][08] := dDataBase
									aSFEIVAVEN[nPosArray][09] := SD1->D1_ALQIMP1
									aSFEIVAVEN[nPosArray][10] := QRYRET->E2_TIPO
									aSFEIVAVEN[nPosArray][14] := ""
									aSFEIVAVEN[nPosArray][15] := ""
					 			EndIf
					 			SD1->(dbSkip())
					 		End
					 	EndIf
            		EndIf
            		QRYRET->(dbSkip())
            	End
            	QRYRET->(dbCloseArea())
        	Endif
    	Endif
    EndIf

ElseIf SE2->E2_TIPO $ "NCP"	//Nota de Credito de Proveedores.

	// Pesquisar nos documentos e verificar se possui itens com reten��o de IVA calculado.
	dbSelectArea("SF2")
	dbSetOrder(1)
	If dbSeek(xFilial("SF2")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA)
    	dbSelectArea("SD2")
	    dbSetOrder(3)
		If dbSeek(xFilial("SD2")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA)
    		While !Eof() .and. D2_FILIAL == xFilial("SD2") .and. D2_DOC == SE2->E2_NUM;
    		             .and. D2_SERIE == SE2->E2_PREFIXO .and. D2_CLIENTE == SE2->E2_FORNECE;
    	    	         .and. D2_LOJA == SE2->E2_LOJA

				//Verificar de existe reten��o de IVA calculada.
				If fa085GetImpos("RV","SD2")[3] > 0
 					//Montar array para gravar as reten��es na tabela SFE
					AAdd(aSFEIVAVEN,{"","",0,0,0,0,0,CTOD(""),0,"","","","","",""})
					nPosArray := Len(aSFEIVAVEN)
					aSFEIVAVEN[nPosArray][01] := SE2->E2_NUM
					aSFEIVAVEN[nPosArray][02] := SE2->E2_PREFIXO
					aSFEIVAVEN[nPosArray][03] := fa085GetImpos("RV","SD2")[1]		//SF1->F1_BASIMPn###SD1->D1_BASIMPn
					aSFEIVAVEN[nPosArray][04] := SD2->D2_VALIMP1
					aSFEIVAVEN[nPosArray][05] := fa085GetImpos("RV","SD2")[2]
   					aSFEIVAVEN[nPosArray][06] := fa085GetImpos("RV","SD2")[3]
					aSFEIVAVEN[nPosArray][07] := aSFEIVAVEN[nPosArray][03]
					aSFEIVAVEN[nPosArray][08] := dDataBase
					aSFEIVAVEN[nPosArray][09] := SD2->D2_ALQIMP1
					aSFEIVAVEN[nPosArray][10] := SE2->E2_TIPO
					aSFEIVAVEN[nPosArray][14] := ""
					aSFEIVAVEN[nPosArray][15] := ""
				Endif
				SD2->(dbSkip())
			End

			If Len(aSFEIVAVEN) == 0
				//Garantir que se houve abatimentos na gera��o da nota gravar as reten��es como gravado em Compras.
				If Select("QRYRET") > 0
					dbSelectArea("QRYRET")
					dbCloseArea()
				EndIf
        		cQuery := "SELECT DISTINCT "
        		cQuery += "E2_PREFIXO, "
        		cQuery += "E2_NUM, "
        		cQuery += "E2_FORNECE, "
        		cQuery += "E2_LOJA, "
        		cQuery += "E2_TIPO, "
        		cQuery += "E2_VALOR, "
        		cQuery += "E2_SALDO "
        		cQuery += " FROM "
        		cQuery += RetSqlName("SE2") + " SE2 "
        		cQuery += "WHERE "
        		cQuery += " E2_FILIAL = '" + xFilial("SE2") + "' "
        		cQuery += " AND E2_PREFIXO = '" + SF2->F2_SERIE + "' "
        		cQuery += " AND E2_NUM = '" + SF2->F2_DOC + "' "
        		cQuery += " AND E2_FORNECE = '" + SF2->F2_CLIENTE + "' "
        		cQuery += " AND E2_LOJA = '" + SF2->F2_LOJA + "' "
				cQuery += "ORDER BY E2_PREFIXO, E2_NUM, E2_FORNECE, E2_LOJA, E2_TIPO"
        		cQuery := ChangeQuery( cQuery )
				dbUseArea( .t., "TopConn", TCGenQry(,,cQuery),"QRYRET", .F., .F. )
				TCSetField( "QRYRET", "E2_VALOR", "N", TamSX3("E2_VALOR")[1], TamSX3("E2_VALOR")[2])
				TCSetField( "QRYRET", "E2_SALDO", "N", TamSX3("E2_SALDO")[1], TamSX3("E2_SALDO")[2])

        		QRYRET->(dbGoTop())

           		While QRYRET->(!Eof())

           			If AllTrim(QRYRET->E2_TIPO) $ "IV-" .and. QRYRET->E2_SALDO > 0.00
 						dbSelectArea("SD2")
    					dbSetOrder(3)
						If dbSeek(xFilial("SD2")+QRYRET->E2_NUM+QRYRET->E2_PREFIXO+QRYRET->E2_FORNECE+QRYRET->E2_LOJA)
    						While !Eof() .and. D2_FILIAL == xFilial("SD2") .and. D2_DOC == QRYRET->E2_NUM;
    	             					 .and. D2_SERIE == QRYRET->E2_PREFIXO .and. D2_CLIENTE == QRYRET->E2_FORNECE;
    	             					 .and. D2_LOJA == QRYRET->E2_LOJA

								//Verificar de existe reten��o de IVA calculada.
								If fa085GetImpos("RV","SD2")[3] > 0
									//Montar array para gravar as reten��es na tabela SFE
 									AAdd(aSFEIVAVEN,{"","",0,0,0,0,0,CTOD(""),0,"","","","","",""})
									nPosArray := Len(aSFEIVAVEN)
									aSFEIVAVEN[nPosArray][01] := QRYRET->E2_NUM
									aSFEIVAVEN[nPosArray][02] := QRYRET->E2_PREFIXO
									aSFEIVAVEN[nPosArray][03] := fa085GetImpos("RV","SD2")[1]		//SF1->F1_BASIMPn
									aSFEIVAVEN[nPosArray][04] := SD2->D2_VALIMP1
									aSFEIVAVEN[nPosArray][05] := fa085GetImpos("RV","SD2")[2]
   									aSFEIVAVEN[nPosArray][06] := fa085GetImpos("RV","SD2")[3]
									aSFEIVAVEN[nPosArray][07] := aSFEIVAVEN[nPosArray][03]
									aSFEIVAVEN[nPosArray][08] := dDataBase
									aSFEIVAVEN[nPosArray][09] := SD2->D2_ALQIMP1
									aSFEIVAVEN[nPosArray][10] := QRYRET->E2_TIPO
									aSFEIVAVEN[nPosArray][14] := ""
									aSFEIVAVEN[nPosArray][15] := ""
					 			EndIf
					 			SD2->(dbSkip())
					 		End
					 	EndIf
            		EndIf
            		QRYRET->(dbSkip())
            	End
            	QRYRET->(dbCloseArea())
        	Endif
    	Endif
    EndIf

EndIf
RestArea(aSavArea)
Return aSFEIVAVEN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CalcIGV2  �Autor  �ROBERTO R.MEZZALIRA � Data �  27/11/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Calculo de IGV 											  ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION CALCIGV2(nVlr)
Local nBaseIGV	:= 0
Local nVlrOper	:= 0
Local nFat		:= 0
Local cFil		:= ""
Local aFatOri	:= {}
Local aSFEIGV	:= {}
Local cNRetIGV	:= ""
Local nTxMoeda  := 0

/* O parametro MV_NRETIGV indica quais comprovantes estao livres da retencao de igv. Nesse parametro devem ser
informados os c�digos dos comprovantes segundo a tabela CCL (CCL_CODGOV) */
cNRetIGV := GetMV("MV_NRETIGV",.T.,"")
SF1->(DbSetOrder(1))
If SF1->(DbSeek(xFilial("SF1") + SE2->E2_NUM + SE2->E2_PREFIXO + SE2->E2_FORNECE + SE2->E2_LOJA))
	/* a retencao ocorre se nao houve detracao e se o tipo da fatura permitir */
	If SF1->F1_BASIMP1 > 0 .And. SF1->F1_BASIMP5 == 0 .And. !(SF1->F1_TIPODOC $ cNRetIGV)
		//Considero para moeda da orden de pago:
		// 1 - Moeda da taxa modificada/digitada quando for diferente da cota��o do dia (significa que foi modificada)
		// 2 - Taxa da inclus�o do t�tulo (E2_TXMOEDA)
		// 3 - Taxa do dia (SM2)
		If aTxMoedas[SE2->E2_MOEDA][2] <> Round(RecMoeda(dDataBase,SE2->E2_MOEDA),MsDecimais(SE2->E2_MOEDA))                                          
			nTxMoeda := aTxMoedas[SE2->E2_MOEDA][2]
		ElseIf SE2->E2_TXMOEDA <> 0
			nTxMoeda := SE2->E2_TXMOEDA
		Else
			nTxMoeda := Round(RecMoeda(dDataBase,SE2->E2_MOEDA),MsDecimais(SE2->E2_MOEDA))
		EndIf                                   
		
		nVlrOper := xMoeda(SF1->F1_BASIMP1 + SF1->F1_VALIMP1,SF1->F1_MOEDA,1,,5,nTxMoeda)
		nVlrPago := nVlrOper
		If SF1->F1_TIPODOC $ "09|08"
			/* se nota de debito o valor da operacao tambem compreende o da fatura original */
			cFil := xFilial("SD1")
			If SD1->(DbSeek(cFil + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA))
				While !(SD1->(Eof())) .And. (SD1->D1_FILIAL == cFIl) .And. (SD1->D1_DOC == SF1->F1_DOC) .And. (SD1->D1_SERIE == SF1->F1_SERIE) .And. (SD1->D1_FORNECE == SF1->F1_FORNECE) .And. (SD1->D1_LOJA == SF1->F1_LOJA)
					If !Empty(SD1->D1_NFORI)
						Aadd(aFatOri,{SD1->D1_NFORI,SD1->D1_SERIORI})
					Endif
					SD1->(DbSkip())
				Enddo
				If !Empty(aFatOri)
					cFil := xFilial("SF1")
					For nFat := 1 To Len(aFatOri)
						If SF1->(DbSeek(cFil + aFatOri[nFat,1] + aFatOri[nFat,2] + SF1->F1_FORNECE + SF1->F1_LOJA))
							If SF1->F1_BASIMP1 > 0 .And. SF1->F1_BASIMP5 == 0
								nVlrOper += xMoeda((SF1->F1_BASIMP1 + SF1->F1_VALIMP1),SF1->F1_MOEDA,1,,5,,MsDecimais(1))
							Endif
						Endif
					Next
				Endif
			Endif
		Endif
	Endif
EndIf
If nVlrOper > 0
	/* a retencao de IGV deve ser feita com valores na moeda 1 */
	nBaseIGV := xMoeda(nVlr,SE2->E2_MOEDA,1,,5,nTxMoeda)
	/*-*/
	AAdd(aSFEIGV,array(12))
	aSFEIGV[Len(aSFEIGV)][1] := SE2->E2_NUM
	aSFEIGV[Len(aSFEIGV)][2] := SE2->E2_PREFIXO
	aSFEIGV[Len(aSFEIGV)][3] := Round(nBaseIGV,MsDecimais(1)) 	//FE_VALBASE
	aSFEIGV[Len(aSFEIGV)][4] := 0	//FE_VALIMP
	aSFEIGV[Len(aSFEIGV)][5] := 100
	aSFEIGV[Len(aSFEIGV)][6] := 0   //aSFEIGV[Len(aSFEIGV)][4]
	aSFEIGV[Len(aSFEIGV)][7] := nBaseIGV
	aSFEIGV[Len(aSFEIGV)][8] := dDataBase
	aSFEIGV[Len(aSFEIGV)][9] := 0
	aSFEIGV[Len(aSFEIGV)][10] := SE2->E2_TIPO
	aSFEIGV[Len(aSFEIGV)][11] := nVlrOper
	aSFEIGV[Len(aSFEIGV)][12] := -1		//valor total de pagamentos anteriores dentro do mes
Endif
Return(Aclone(aSFEIGV))

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CALCRETIGV�Autor  �Microsiga           �Fecha � 27/02/2012  ���
�������������������������������������������������������������������������͹��
���Desc.     � Calculo do valor da retencao sobr IGV - Peru               ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function CalcRetIGV(aSE2,nInicio,nFim)
Local nVlrPago	:= 0
Local nVlrAcum	:= -1
Local nTotDoc	:= 0
Local nBase		:= 0
Local nSe2		:= 0
Local nTit		:= 0
Local nCrd		:= 0
Local nPos		:= 0
Local aDocs		:= {}
Local aAreaSEK	:= {}
Local cQuery	:= ""
Local cAliasSEK	:= ""
Local cArea		:= ""
Local cNRetIGV	:= ""

Default nInicio	:= 1
Default nFim	:= Len(aSE2)

cNRetIGV := GetMV("MV_NRETIGV",.T.,"")
SFF->(DbSetOrder(9))
SFF->(DbSeek(xFilial("SFF")+"IGR"))
For nSe2 := nInicio To nFim
	nVlrPago := 0
	nVlrAcum := -1
	nTotDoc := 0
	nCrd := 0
	For nTit := 1 To Len(aSe2[nSe2,1])
		If !Empty(aSE2[nSe2,1,nTit,_RETIGV])
			If aSE2[nSe2,1,nTit,_RETIGV,1,12] < 0
				/* verifica os pagamentos ja efetuados dentro do mes */
				If nVlrAcum < 0
					nVlrAcum := 0
					#IFDEF TOP
						cArea := Alias()
						cQuery := "select EK_VLMOED1,EK_TIPO,F1_TIPODOC from " + RetSQLName("SEK") + " SEK," + RetSQLName("SF1") + " SF1"
						cQuery += " where EK_FILIAL = '" + xFilial("SEK") + "'"
						cQuery += " and EK_TIPODOC = 'TB'"
						cQuery += " and EK_CANCEL <> 'T'"
						cQuery += " and EK_FORNECE = '" + aSE2[nSe2,1,1,_FORNECE] + "'"
						cQuery += " and EK_LOJA = '" + aSE2[nSe2,1,1,_LOJA] + "'"
						cQuery += " and EK_EMISSAO = '" + Dtos(dDatabase) + "'"
						cQuery += " and SEK.D_E_L_E_T_ = ''"
						cQuery += " and F1_FORNECE = EK_FORNECE"
						cQuery += " and F1_LOJA = EK_LOJA"
						cQuery += " and F1_DOC = EK_NUM"
						cQuery += " and F1_SERIE = EK_PREFIXO
						cQuery += " and F1_VALIMP1 <> 0
						cQuery += " and F1_VALIMP5 = 0
						cQuery += " and SF1.D_E_L_E_T_ = ''"
						cQuery := ChangeQuery(cQuery)
						cAliasSEK := GetNextAlias()
						DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSEK,.F.,.T.)
						DbSelectArea(cAliasSEK)
						(cAliasSEK)->(DbGoTop())
						While !((cAliasSEK)->(Eof()))
							If !((cAliasSEK)->F1_TIPODOC $ cNRetIGV)
								If (cAliasSEK)->EK_TIPO $ MV_CPNEG
									nVlrAcum -= (cAliasSEK)->EK_VLMOED1
								Else
									nVlrAcum += (cAliasSEK)->EK_VLMOED1
								Endif
							Endif
							(cAliasSEK)->(DbSkip())
						Enddo
						DbCloseArea()
						DbSelectArea(cArea)
					#ELSE
						aAreaSEK := SEK->(GetArea())
						SF1->(DbSetOrder(1))
						SEK->(DbSetOrder(2))
						SEK->(DbSeek(xFilial("SEK") + aSE2[nSe2,1,1,_FORNECE] + aSE2[nSe2,1,1,_LOJA] + Substr(Dtos(dDatabase),1,6) + "01"),.T.)
						While SEK->EK_FILIAL == xFilial("SEK") .And. !(SEK->(Eof())) .And. SEK->EK_FORNECE == aSE2[nSe2,1,1,_FORNECE] .And. SEK->EK_LOJA == aSE2[nSe2,1,1,_LOJA] .And. EK_EMISSAO <= dDataBase
							If SEK->EK_TIPODOC == "TB" .And. !(SEK->EK_CANCEL)
								If SF1->(DbSeek(xFilial("SF1") + SEK->EK_NUM + SEK->EK_PREFIXO + SEK->EK_FORNECE + SEK->EK_LOJA))
									If SF1->F1_VALIMP1 <> 0 .And. SF1->F1_VALIMP5 == 0 .And. !(SF1->F1_TIPODOC $ cNRetIGV)
										If (cAliasSEK)->EK_TIPO $ MV_CPNEG
											nVlrAcum -= SEK->EK_VLMOED1
										Else
											nVlrAcum += SEK->EK_VLMOED1
										Endif
									Endif
								Endif
							Endif
							SEK->(DBSkip())
						Enddo
						SEK->(RestArea(aAreaSEK))
					#ENDIF
				Endif
				aSE2[nSe2,1,nTit,_RETIGV,1,12] := nVlrAcum
			Endif

			If aTxMoedas[aSE2[nSe2,1,nTit,_MOEDA]][2] <> 0
				nBase := xMoeda(aSE2[nSe2,1,nTit,_PAGAR],aSE2[nSe2,1,nTit,_MOEDA],1,,5,aTxMoedas[aSE2[nSe2,1,nTit,_MOEDA]][2])			
			Else
				nBase := xMoeda(aSE2[nSe2,1,nTit,_PAGAR],aSE2[nSe2,1,nTit,_MOEDA],1,,5,aSE2[nSe2,1,nTit,_TXMOEDA])
			EndIf

			If aSE2[nSe2,1,nTit,_TIPO] $ MV_CPNEG
				nCrd += nBase
				nBase := -nBase
			Endif
			aSE2[nSe2,1,nTit,_RETIGV,1,3] := nBase
			aSE2[nSe2,1,nTit,_RETIGV,1,7] := nBase
			nVlrPago += nBase
			nPos := Ascan(aDocs,{|docs| docs[1] == aSE2[nSe2,1,nTit,_FORNECE] .And. docs[2] == aSE2[nSe2,1,nTit,_FORNECE] .And. docs[3] == aSE2[nSe2,1,nTit,_PREFIXO] .And. docs[4] == aSE2[nSe2,1,nTit,_NUM]})
			If nPos == 0
				nTotDoc += aSE2[nSe2,1,nTit,_RETIGV,1,11]
				Aadd(aDocs,{aSE2[nSe2,1,nTit,_FORNECE],aSE2[nSe2,1,nTit,_FORNECE],aSE2[nSe2,1,nTit,_PREFIXO],aSE2[nSe2,1,nTit,_NUM]})
			Endif
		Endif
	Next
	For nTit := 1 To Len(aSe2[nSe2,1])
		If !Empty(aSE2[nSe2,1,nTit,_RETIGV])

			lCalc:=.F.
			If (nVlrPago +nVlrAcum >= SFF->FF_IMPORTE)  .or. ((aSE2[nSe2,1,nTit,_RETIGV,1,3] + aSE2[nSe2,1,nTit,_RETIGV,1,12] - nCrd)  >= SFF->FF_IMPORTE)
			      lCalc:=.T.
			ElseIf 	aSE2[nSe2,1,nTit,_RETIGV,1,11] > SFF->FF_IMPORTE
				lCalc:=.T.

			EndIf

			If !lCalc
				aSE2[nSe2,1,nTit,_RETIGV,1,3] := 0
				aSE2[nSe2,1,nTit,_RETIGV,1,4] := 0
				aSE2[nSe2,1,nTit,_RETIGV,1,6] := 0
				aSE2[nSe2,1,nTit,_RETIGV,1,7] := 0
				aSE2[nSe2,1,nTit,_RETIGV,1,9] := 0
			End
	  		aSE2[nSe2,1,nTit,_RETIGV,1,4] := Round(aSE2[nSe2,1,nTit,_RETIGV,1,3] * SFF->FF_ALIQ/100,MsDecimais(1))
			aSE2[nSe2,1,nTit,_RETIGV,1,6] := aSE2[nSe2,1,nTit,_RETIGV,1,4]
			aSE2[nSe2,1,nTit,_RETIGV,1,9] := SFF->FF_ALIQ

		Endif
	Next
Next
Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CheckConfIB  �Autor  �Marcos Berto        � Data �14/04/10  ���
�������������������������������������������������������������������������͹��
���Desc.     �Configura��o de calculo de IIBB - SFH - CCO                 ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function CheckConfIB(cFornecedor, cLoja, cProvincia,cFilFor)
Local nI				:= 0
Local aConfProv	:= {}
Local cTipoForn	:= ""
Local nRegSFH := 0

Default cProvincia	:= ""
Default cFilFor		:= xFilial("SA2")

nI := 1
If AliasInDic("CCO") .And. CCO->(FieldPos("CCO_AGRET")) > 0 .And. CCO->(FieldPos("CCO_TPRET")) > 0
	CCO->(DbSetOrder(1))
	CCO->(DbSeek(xFilial("CCO")))
	While CCO->(!Eof()) .And. CCO->CCO_FILIAL == xFilial("CCO")
			SFH->(DbSetOrder(1))
			SFH->(DbGoTop())
			nRegSFH := 0	
			SFH->(DbSeek(xFilial()+cFornecedor+cLoja+"IBR"+CCO->CCO_CODPROV))
			
			While !(SFH->(Eof())) .and. nRegSFH == 0 .and. SFH->FH_FORNECE == cFornecedor .and. SFH->FH_LOJA == cLoja .and. SFH->FH_IMPOSTO == "IBR" .and. SFH->FH_ZONFIS == CCO->CCO_CODPROV
				IF (dDataBase >= SFH->FH_INIVIGE .And. dDataBase <= SFH->FH_FIMVIGE) .Or. Iif(!Empty(SFH->FH_INIVIGE),dDataBase>=SFH->FH_INIVIGE,.T.) .And. Iif(!Empty(SFH->FH_FIMVIGE),dDataBase<=SFH->FH_FIMVIGE,.T.)
			      	nRegSFH := SFH->(Recno())
	    	   	EndIf
		    	SFH->(DbSkip())
		   	EndDo
			SFH->(DbGoTo(nRegSFH))
			
			aAdd(aConfProv, Array(4))
			
			If nRegSFH > 0 .and. !Eof()
				aConfProv[nI][1] := SFH->FH_ZONFIS //Provincia
				aConfProv[nI][2] := CCO->CCO_AGRET //Agente de reten��o
				aConfProv[nI][3] := CCO->CCO_TPRET //Tipo de reten��o

				If SFH->(FieldPos("FH_TIPO")) > 0 .And. !Empty(SFH->FH_TIPO) .And. Iif(!Empty(SFH->FH_INIVIGE),dDataBase>=SFH->FH_INIVIGE,.T.) .And. Iif(!Empty(SFH->FH_FIMVIGE),dDataBase<=SFH->FH_FIMVIGE,.T.)
					cTipoForn := SFH->FH_TIPO
				Else
					//Caso o tipo n�o seja informado na amarra��o, o fornecedor deve ser tratado como No Inscripto (N)
					cTipoForn := "N"
				Endif

				aConfProv[nI][4] := cTipoForn //Tipo
			Else
				aConfProv[nI][1] := CCO->CCO_CODPRO//Provincia
				aConfProv[nI][2] := CCO->CCO_AGRET //Agente de reten��o
				aConfProv[nI][3] := CCO->CCO_TPRET //Tipo de reten��o
				aConfProv[nI][4] := "N" //Caso n�o exista a amarra��o de exce��es, o fornecedor deve ser tratado como No Inscripto (N)
			Endif
			nI++
		CCO->(DbSkip())
	EndDo
Endif

//Configura��o padr�o -> cadastro de Fornecedor - SA2
If Len(aConfProv) == 0
	dbSelectArea("SA2")
	SA2->(dbSetOrder(1))
	If !Empty(xFilial("SA2")) .And. lMsFil .And. xFilial("SF1") == xFilial("SA2")
		SA2->(DbSeek(cFilFor+cFornecedor+cLoja))
	Else
		SA2->(DbSeek(xFilial("SA2")+cFornecedor+cLoja))
	Endif
	If SA2->(Found())
		aAdd(aConfProv,{cProvincia, Iif(SA2->A2_RETIB == "S", "1", "2"), "1", SA2->A2_TIPO})
	Endif
Endif

Return aConfProv

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CheckCBU     �Autor  �Marcos Berto        � Data �26/04/10  ���
�������������������������������������������������������������������������͹��
���Desc.     �Verifica os t�tulos gerados dentro do periodo de controle   ���
���          �de CBU.                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function CheckCBU(aOrdPg)
Local nI			:= 0
Local nX			:= 0
Local aAreaSE2 := {}
Local aAreaSA2 := {}
Local aAreaSF1 := {}
Local aAreaSF2 := {}
Local aRecnoCBU := {}
Local aRecnoNCBU := {}
Local aNewOrdPg := {}
Local nMinCBU	:= GetMV("MV_MINCBU",.F.,0)
Local nValMerc	:= 0

Default aOrdPg := {}

dbSelectArea("SA2")
aAreaSA2 := SA2->(GetArea())

dbSelectArea("SE2")
aAreaSE2 := SE2->(GetArea())

For nI := 1 to Len(aOrdPg)
	SA2->(dbSetOrder(1))
	If lMsFil .And. !Empty(xFilial("SA2")) .And. xFilial("SF1") == xFilial("SA2") .And. (nCondAgr <> 3)
		SE2->(dbGoTo(aOrdPg[nI][4][1]))
		SA2->(dbSeek(SE2->E2_MSFIL+aOrdPg[nI][2]+aOrdPg[nI][3]))
	Else
		SA2->(dbSeek(xFilial("SA2")+aOrdPg[nI][2]+aOrdPg[nI][3]))
	Endif
	If SA2->(Found())

		If Empty(SA2->A2_CBUINI) .And. Empty(SA2->A2_CBUFIM)
			aAdd(aNewOrdPg, {aOrdPg[nI][1], aOrdPg[nI][2], aOrdPg[nI][3], aOrdPg[nI][4], .F. } )
		Else
			For nX := 1 to Len(aOrdPg[nI][4])
				SE2->(dbGoTo(aOrdPg[nI][4][nX]))

				If SE2->E2_TIPO $ MVPAGANT+"|"+MV_CPNEG
					dbSelectArea("SF2")
					aAreaSF2 := SF2->(GetArea())
					SF2->(dbSetOrder(1))
					If lMsFil
						SF2->(dbSeek(SE2->E2_MSFIL+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA))
					Else
						SF2->(dbSeek(xFilial("SF2")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA))
					Endif
					If SF2->(Found())
						nValMerc := xMoeda(SF2->F2_VALMERC,SF2->F2_MOEDA,1,SE2->E2_EMISSAO,MsDecimais(1))
					Else
						nValMerc := xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,MsDecimais(1))
					Endif
				Else
					dbSelectArea("SF1")
				   	aAreaSF1 := SF1->(GetArea())
					SF1->(dbSetOrder(1))
					If lMsFil
						SF1->(dbSeek(xFilial("SF1")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA))
					Else
						SF1->(dbSeek(xFilial("SF1")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA))
					Endif
					If SF1->(Found())
						nValMerc := xMoeda(SF1->F1_VALMERC,SF1->F1_MOEDA,1,SE2->E2_EMISSAO,MsDecimais(1))
					Else
						nValMerc := xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,MsDecimais(1))
					Endif
				Endif

				If (SE2->E2_EMISSAO >= SA2->A2_CBUINI .And.  SE2->E2_EMISSAO <= SA2->A2_CBUFIM) .And. nValMerc >= nMinCBU
					aAdd(aRecnoCBU, aOrdPg[nI][4][nX])
				Else
					aAdd(aRecnoNCBU, aOrdPg[nI][4][nX])
				Endif
			Next nX

			If Len(aRecnoCBU) > 0
				aAdd(aNewOrdPg, { aOrdPg[nI][1], aOrdPg[nI][2], aOrdPg[nI][3], aRecnoCBU, .T. } )
			Endif

			If Len(aRecnoNCBU) > 0
				aAdd(aNewOrdPg, { aOrdPg[nI][1], aOrdPg[nI][2], aOrdPg[nI][3], aRecnoNCBU, .F. } )
			Endif
		Endif
	Endif
Next nI

//Remonta o array aOrdPg
If Len(aNewOrdPg) > 0
	aOrdPg := aNewOrdPg
Endif

RestArea(aAreaSA2)
RestArea(aAreaSE2)
If Len(aAreaSF2) > 0
	RestArea(aAreaSF2)
Endif
If Len(aAreaSF1) > 0
	RestArea(aAreaSF1)
Endif

Return Nil

Static Function a085aVldMD(nOpc,cNatureza,cMod,nFMOD)
Local lRet		:= .T.
Local cPesquisa	:= ""
Local cCalcITF  := SuperGetMv("MV_CALCITF",.F.,"2")
Local lVldNat	:= .T.

Default nFMOD :=0
Default __lF085VLNAT := ExistBlock("F085VLNAT")

cPesquisa	:= xFilial("SED")+cNatureza

If nOpc	==	1 .and.	!Empty(cNatureza)
    SED->(DbSetOrder(1))
	If SED->(DbSeek(cPesquisa))
		cMod:= SED->ED_DESCRIC
 	   if cPaisLoc$"PER|DOM|COS"
   	      If nFMOD==0
		     lRet:= .T.
		    Else
	      If (cPaisLoc=="PER" .and. ALLTRIM(STR(nFMOD))==SED->ED_CALCITF) .or. (cPaisLoc$"DOM|COS" .and. ALLTRIM(STR(nFMOD))==If(FA085ACITF(cNatureza),"1","2"))
		        lRet:= .T.
		  Else
		        lRet:= .F.
		  If nFMOD==1
		           MsgAlert(STR0213)//"Os Titulos selecionados incidem ITF, selecione uma Natureza com incidencia de ITF.")
		  Else
		           MsgAlert(STR0214)//"Os Titulos selecionados n�o incidem ITF, selecione uma Natureza sem incidencia de ITF.")
		  Endif
		     Endif
		  Endif
	   Endif
	Else
      If !Empty(cNatureza)
         MsgAlert(STR0208)//"A natureza selecionada nao existe."
      Endif
      lRet	:=	.F.
   Endif
Endif
If lRet .and. cPaisLoc$"PER|DOM|COS" .and. Empty(cNatureza) .and. AllTrim(cCalcITF) == "1"
   MsgAlert(STR0218)//"O campo Natureza � obrigat�rio!"
   lRet	:=	.F.
Endif

//294 - Natureza sintetica/Analitica
If lRet .and. IIf(!__lF085VlNat,!FinVldNat( .F., cNatureza ),.F.)
	lRet := .F.
ElseIf __lF085VlNat //Fa�o a valida��o pelo ponto de entrada
	lVldNat := ExecBlock("F085VLNAT",.F.,.F.,{cNatureza})
	If ValType(lVldNat) == "L"
		lRet := lVldNat
	EndIf
Endif

Return lRet

Static Function lRetCkPG(n,cDebInm,cBanco,nPagar,nVlrDOM)
Local lRetCx:=.T.
Local lF85ABCVLD := ExistBlock("F85ABCVLD")

Default nVlrDOM := 0

If lF085aChS .and. nPagar==1
	nPagar++
Endif

If cPaisLoc$"PER|DOM"
   If Empty(cBanco) .and. nPagar<>4
      lRetCx:=.F.
   Endif
	If !lF85ABCVLD
	   If n==0
	   	If !Empty(cBanco) .and. cBanco $ (Left(GetMv("MV_CXFIN"),TamSX3("A6_COD")[1])+"/"+GetMv("MV_CARTEIR")) .or. IsCaixaLoja(cBanco)
	   		If nPagar=3 .and. cDebInm="TF"
	            lRetCx:=.F.
	              MsgAlert(STR0215+cBanco+STR0216)
	         Elseif nPagar=1 .or. nPagar=2
	            lRetCx:=.F.
	            MsgAlert(STR0215+cBanco+STR0217)
	         Endif
	      Else
	        If !Empty(cBanco) .and.  nPagar=3 .and. cDebInm="EF"
	           lRetCx:=.F.
				  MsgAlert(STR0215+cBanco+" no recibe asientos del tipo EF.")
	        Endif
	      Endif
		Elseif n==1
	      If !Empty(cBanco) .and. cBanco $ (Left(GetMv("MV_CXFIN"),TamSX3("A6_COD")[1])+"/"+GetMv("MV_CARTEIR"))  .or. IsCaixaLoja(cBanco)
	         If nPagar=3 .and. cDebInm="TF"
	            lRetCx:=.F.
	            MsgAlert(STR0215+cBanco+STR0216)
	          Elseif nPagar=1 .or. nPagar=2
	            lRetCx:=.F.
	            If(cBanco $ GetMv("MV_CARTEIR"),lRetCx:=.F.,MsgAlert(STR0215+cBanco+STR0217))
	         Endif
	      Else
	        If !Empty(cBanco) .and. nPagar=3 .and. cDebInm="EF"
	           lRetCx:=.F.
				  MsgAlert(STR0215+cBanco+" no recibe asientos del tipo EF.")
	        Endif
	      Endif
	   Elseif n==2
	      If !Empty(cBanco) .and. cBanco $ (Left(GetMv("MV_CXFIN"),TamSX3("A6_COD")[1])+"/"+GetMv("MV_CARTEIR"))  .or. IsCaixaLoja(cBanco)
	         If nPagar=2 .and. cDebInm="TF"
	            lRetCx:=.F.
	            MsgAlert(STR0215+cBanco+STR0216)
	          Elseif nPagar=1
	            lRetCx:=.F.
	            MsgAlert(STR0215+cBanco+STR0217)
	         Endif
	      Else
	        If !Empty(cBanco) .and. nPagar=3 .and. cDebInm="EF"
	           lRetCx:=.F.
				  MsgAlert(STR0215+cBanco+" no recibe asientos del tipo EF.")
	        Endif
	      Endif
	   Elseif n==3
	      If cBanco $ (Left(GetMv("MV_CXFIN"),TamSX3("A6_COD")[1])+"/"+GetMv("MV_CARTEIR"))  .or. IsCaixaLoja(cBanco)
	         lRetCx:=.F.
	      Endif
	   Endif
	Else
		lRetCx := ExecBlock("F85ABCVLD",.F.,.F.,{cDebInm,cBanco,nPagar})
	EndIf
   If cPaisLoc$"DOM|COS" .and. n==0 .and. lRetCx //passa aqui tb no informar do pa
		If !lF85ABCVLD
	   	If nVlrDOM >= nFinLmCH .and. nPagar=3 .and. cDebInm="EF"
	   		Help(" ",1,"HELP",STR0229,STR0230,1,0)//"FA085A - LIMITE ITF","Pagamento disponivel apenas com Cheque ou Transfer�ncia Banc�ria."
	         lRetCx:=.F.
	      Endif
		Else
			lRetCx := ExecBlock("F85ABCVLD",.F.,.F.,{cDebInm,cBanco,nPagar})
		EndIf
   Endif
Endif
Return(lRetCx)

/*
*/
Function FA085RetIR(nBase,cNat,lPA)
Local nLenIR	:= 0
Local nPercBas	:= 0
Local nBaseCalc	:= 0
Local cNatur	:= ""
Local aRetIR	:= {}
Local nBasIr := SED->ED_IRALIQ
Local lCalcIR:= .F.

Default cNat	:= ""
Default nBase	:= 0
Default lPA		:= .F.

If (SED->(FieldPos("ED_IRALIQ")) > 0) .And. (SED->(FieldPos("ED_BASELIQ")) > 0) .And. (SED->(FieldPos("ED_VALMIN")) > 0)
	If lPA
		cNatur := cNat
	Else
		cNatur := SE2->E2_NATUREZ
	Endif
	If !Empty(cNatur)
		If SED->(DbSeek(xFilial("SED") + cNatur))
			If SED->ED_IRALIQ <> 0
				If lPA
					nBaseCalc := Round(xMoeda(nBase,nMoedaCor,1,dDataBase,5,),MsDecimais(1))
				Else
					If nBase == 0
						If lBxParc .and. SE2->E2_VLBXPAR > 0 .And.  SE2->E2_VLBXPAR <= SE2->E2_SALDO
							nBaseCalc := Round(xMoeda(SE2->E2_VLBXPAR,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,5,aTxMoedas[Max(SE2->E2_MOEDA,1)][2]),MsDecimais(1))
						Else
							nBaseCalc := Round(xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,5,aTxMoedas[Max(SE2->E2_MOEDA,1)][2]),MsDecimais(1))
						Endif
					Else
						nBaseCalc := Round(xMoeda(nBase,nMoedaCor,1,dDataBase,5,),MsDecimais(1))
					Endif
				Endif

				IF ExistBlock("F085ABIRF")
				    nBasIr := ExecBlock("F085ABIRF",.f.,.f.)
				    lCalcIR:= .T.  // Se existir o ponto de entrada n�o ser� verificado o Minimo para calculo do IR
				    	IF valtype (nBasIr) <> "N"
				            nBasIr := SED->ED_IRALIQ
						EndIF
				Else
						nBasIr 	:= SED->ED_IRALIQ
						If nBaseCalc >= SED->ED_VALMIN
							lCalcIR:= .T.
						EndIf
				EndIf

				If lCalcIR .and. nBasIr > 0 // S� ser� gerado registro de reten��o se a aliquota for maior que zero.
					Aadd(aRetIR,array(11))
					nLenIR := Len(aRetIR)
					If SED->ED_BASELIQ > 0
						nPercBas := SED->ED_BASELIQ / 100
						nPercBas := Min(1,nPercBas)
						nBaseCalc := Round(nBaseCalc * nPercBas,MsDecimais(1))
					Endif

					aRetIR[nLenIR,01] := If(lPA,"",SE2->E2_NUM)
					aRetIR[nLenIR,02] := If(lPA,"PA",SE2->E2_PREFIXO)
					aRetIR[nLenIR,03] := nBaseCalc		//FE_VALBASE
					aRetIR[nLenIR,04] := Round((nBaseCalc * nBasIr / 100),MsDecimais(1))	//FE_VALIMP
					aRetIR[nLenIR,05] := nPercBas * 100
					aRetIR[nLenIR,06] := aRetIR[Len(aRetIR)][4]
					aRetIR[nLenIR,07] := nBaseCalc
					aRetIR[nLenIR,08] := dDataBase
					aRetIR[nLenIR,09] := SED->ED_IRALIQ
					aRetIR[nLenIR,10] := If(lPA," ",SE2->E2_TIPO)
					aRetIR[nLenIR,11] := SED->ED_VALMIN
				Endif
			Endif
		Endif
	Endif
Endif
Return(Aclone(aRetIR))

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  F085AtuSFF  �Autor  �Ana Paula	         � Data �  22/05/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Chamada do assinante de certificado                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fa085DtVenc  �Autor  � Jos� Lucas     � Data �  01/12/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Validar a data de vencimento do cheque informado.          ���
���          � Obs: Redefinir no cliente se � permitido cheque com vencto ���
���          �      futura.                                               ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function fa085DtVenc(dDataVenc)
Local aArea := GetArea()
Local lRet      := .T.
Local lfa085DtV := ExistBlock("FA085DTV")

If lfa085DtV
   lRet := ExecBlock("FA085DTV",.F.,.F.,{dDataVenc})
Else
	If (dDataVenc >= dDataBase)
   		lRet := .T.
   	Else
   		MsgAlert(STR0228,STR0223)
   		lRet := .F.
   	EndIf
EndIf
RestArea(aArea)
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  F085AtuAbt  �Autor  �Paulo Leme         � Data �  02/12/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Baixa de Abatimentos Localiza��es				          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function F085AtuAbt(cOrdPago)
Local aAreaAtu  := {}
Local aAreaSE2  := {}
Local cChaveSE2	:= ""
Local lImposto  := .F.
Local cChaveSFE := ""
Local cBco      := ""
Local cAge      := ""
Local cCta      := ""

aAreaAtu 	:= GetArea()
aAreaSE2 	:= SE2->(GetArea())
cChaveSE2 	:= SE2->E2_FILIAL+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM

#IFDEF TOP
	EndFilBrw("SE2",aIndexADC)
#ENDIF

dbSelectArea("SE2")
SE2->(DbSetOrder(6))

If ( SE2->(MsSeek(cChaveSE2)))
  cChaveSE2 := xFilial("SE2")+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM

  While !SE2->(Eof()) .And. cChaveSE2 == xFilial("SE2")+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM

		If cPaisLoc $ "DOM|COS"
		    lImposto  := F085AbtImp(SE2->E2_NATUREZ, SE2->E2_TIPO)
  	    EndIf

  		If 	(SE2->E2_TIPO $ MVABATIM .Or. lImposto) .And. Empty(E2_BAIXA)
		    RecLock("SE2",.F.)
			Replace E2_SALDO    With 0
			Replace E2_BAIXA    With dDataBase
			Replace E2_MOVIMEN  With dDataBase
			Replace E2_ORDPAGO  With cOrdpago
			SE2->(MsUnLock())
			//Atualiza SFE
			SEK->(DbSetOrder(1)) //EK_FILIAL+EK_ORDPAGO+EK_TIPODOC+EK_PREFIXO+EK_NUM+EK_PARCELA+EK_TIPO+EK_SEQ
			SEK->(DbSeek(xFilial("SEK")+AvKey(cOrdpago,"EK_ORDPAGO")))
			Do while xFilial() == SEK->EK_FILIAL .And. AllTrim(cOrdpago)==SEK->EK_ORDPAGO .AND. SEK->(!EOF())
				If ALLTRIM(SEK->EK_TIPODOC) $ "CP"
					cBco      := SEK->EK_BANCO
					cAge      := SEK->EK_AGENCIA
					cCta      := SEK->EK_CONTA
				EndIf
				SEK->(DbSkip())
			Enddo
			SFE->(dbSetOrder(4))
			If SFE->(dbSeek(xFilial("SFE")+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_NUM+SE2->E2_PREFIXO))
				cChaveSFE := xFilial("SFE")+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_NUM+SE2->E2_PREFIXO
				While !SFE->(Eof()) .And. cChaveSFE == xFilial("SFE")+SFE->FE_FORNECE+SFE->FE_LOJA+SFE->FE_NFISCAL+SFE->FE_SERIE
					RecLock("SFE",.F.)
					If Empty(FE_ORDPAGO)
						FE_ORDPAGO  :=  cOrdpago
					EndIf
					FE_BANCO    :=	cBco
					FE_AGENCIA  :=	cAge
					FE_NUMCOM   := 	cCta
					SFE->(MsUnLock())
					SFE->(dbSkip())
				Enddo
			EndIf
  		EndIf
   		SE2->(dbSkip())
  EndDo
Endif
RestArea(aAreaSE2)
#IFDEF TOP
	Eval( bFiltraBrw )
#ENDIF

RestArea(aAreaAtu)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � A085aVigSFH � Autor � Gustavo Henrique � Data �  18/02/11  ���
�������������������������������������������������������������������������͹��
���Descricao � Faz a validacao de uma data com o periodo de vigencia      ���
���          � de Ingressos Brutos                                        ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function A085aVigSFH( dData )

Local lRet := .F.

Default dData := dDataBase

If dData >= SFH->FH_INIVIGE
	lRet := .T.
EndIf

If lRet .And. !Empty( SFH->FH_FIMVIGE )
	lRet := ( dData <= SFH->FH_FIMVIGE )
EndIf

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ�
���Fun��o	 � FA085ACITF � Autor � Wagner Montenegro	� Data � 11.05.11 ���
��������������������������������������������������������������������������Ĵ�
���Descri��o � Verifica a Natureza possui configura��o c/ Aliquota de ITF  ��
��������������������������������������������������������������������������Ĵ�
���Retorno	 � L�gico       											               ��
��������������������������������������������������������������������������Ĵ�
���Uso		 � Localiza��o Rep. Dominicana                                 ��
���������������������������������������������������������������������������ٱ
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
FUNCTION FA085ACITF(cNaureza)
Local aAreaDOM 	:= GetArea()
Local nAliqITF		:= 0
Local lDomDtVld	:= .F.
FRM->(DbSetOrder(3))
If SED->ED_USO $ "24" .and. (FRM->(DbSeek(xFilial("FRM")+"ITF"+Space(TamSX3("FRM_SIGLA")[1]-3)+"1"+"2")) .OR. FRM->(DbSeek(xFilial("FRM")+"ITF"+Space(TamSX3("FRM_SIGLA")[1]-3)+"3"+"2"))) .or.;
 	SED->ED_USO $ "13" .and. (FRM->(DbSeek(xFilial("FRM")+"ITF"+Space(TamSX3("FRM_SIGLA")[1]-3)+"2"+"2")) .OR. FRM->(DbSeek(xFilial("FRM")+"ITF"+Space(TamSX3("FRM_SIGLA")[1]-3)+"3"+"2")))
 	While !FRM->(EOF()) .and. FRM->FRM_FILIAL==xFilial("FRM") .and. FRM->FRM_SIGLA==("ITF"+Space(TamSX3("FRM_SIGLA")[1]-3))
		If FRM->FRM_MSBLQL <> "1" .and. FRM->FRM_BLOQ <> "1" .and. FRM->FRM_SEQ <> "000" .and. (SED->ED_USO $ "24" .and. FRM->FRM_CARTEI $ "13" .or. SED->ED_USO $ "13" .and. FRM->FRM_CARTEI $ "23") .and. FRM->FRM_INIVIG <= dDataBase .and. FRM->FRM_FIMVIG >= dDataBase
	  		lDomDtVld:=.T.
	  		Exit
		Else
		   FRM->(DbSkip())
  		Endif
  	Enddo
   If lDomDtVld
      FRN->(DbSetOrder(2))
      If FRN->(DbSeek(xFilial("FRN")+SED->ED_CODIGO+FRM->FRM_COD+FRM->FRM_SEQ))
      	While !FRN->(EOF()) .and. FRN->FRN_FILIAL==xFilial("FRN") .AND. FRN->FRN_CODNAT==SED->ED_CODIGO .AND. FRN->FRN_IMPOST==FRM->FRM_COD .AND. FRN->FRN_SEQ==FRM->FRM_SEQ
      		If FRN->FRN_MSBLQL == "2"
      			If !Empty(FRN->FRN_CONCEP)
      				If CCR->(DbSeek(xFilial("CCR")+FRN->FRN_CONCEP))
      					If CCR->CCR_REDUC > 0
	      					nAliqITF := CCR->CCR_ALIQ - (CCR->CCR_ALIQ * (CCR->CCR_REDUC / 100))
      					Else
				      		nAliqITF := CCR->CCR_ALIQ / 100
				      	Endif
			      	Else
		      			nAliqITF := FRM->FRM_ALIQ / 100
		      		Endif
		      	Else
		      		nAliqITF := FRM->FRM_ALIQ / 100
		      	Endif
		      	lDomITF:=.T.
		      	Exit
		      Endif
		      FRN->(DbSkip())
		 	Enddo
		Endif
	Endif
Endif
RestArea(aAreaDOM)
Return(If(nAliqITF>0,.T.,.F.))

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ�
���Fun��o	 � FA085ATOT � Autor � Wagner Montenegro	� Data � 11.05.11 ���
��������������������������������������������������������������������������Ĵ�
���Descri��o � Verifica se valor de pagto � > que Limite p/ pgto em especie��
��������������������������������������������������������������������������Ĵ�
���Retorno	 � L�gico       											               ��
��������������������������������������������������������������������������Ĵ�
���Uso		 � Localiza��o Rep. Dominicana                                 ��
���������������������������������������������������������������������������ٱ
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
FUNCTION FA085ATOT(aPgs)
Local lRet := .T.
Local nX
Local nSomaT:=0
For nX := 1 to Len(aPgs)
	nSomaT+=DesTrans(aPgs[nX,7])
Next
If nSomaT >= nFinLmCH
//	Help(" ",1,"HELP","FA085A - LIMITE ITF","Pagamento disponivel apenas com Cheque ou Transfer�ncia Banc�ria.",1,0)
	lRet:=.F.
Endif
Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ�
���Fun��o	 � fa085GetImpos� Autor � Jos� Lucas		� Data � 15.05.11 ���
��������������������������������������������������������������������������Ĵ�
���Descri��o � Retornar array com valor base, aliquota e imposto para as   ��
���          � reten��es de IVA, ISRL � partir dos valores gerados pela NF ��
���          � de Compras.                                                 ��
��������������������������������������������������������������������������Ĵ�
���Parametros� ExpC1 := Sigla da reten��o definida na tabela SFB-Impostos  ��
���          �          Exemplo: "RV", "RIR"                               ��
��������������������������������������������������������������������������Ĵ�
���Retorno	 � ExpA1 {Valor Base,Aliquota,Valor do Imposto}				   ��
��������������������������������������������������������������������������Ĵ�
���Uso		 � Localiza��o Venezuela                                       ��
���������������������������������������������������������������������������ٱ
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function fa085GetImpos(cSiglaImp,cAlias)
LOCAL aSavArea  := GetArea()
LOCAL aImposto  := {0.00,0.00,0.00}
LOCAL cCpoVBase := ""
LOCAL cCpoImpos := ""
LOCAL nValBase  := 0.00
LOCAL nValImpos := 0.00

SFB->(dbSetOrder(1))
If SFB->(dbSeek(xFilial("SFB")+cSiglaImp))
	While SFB->(!Eof()) .and. SFB->FB_FILIAL == xFilial("SFB") .and. AllTrim(cSiglaImp) $ SFB->FB_CODIGO
		If cAlias == "SD1"
			cCpoVBase := "SD1->D1_BASIMP"+AllTrim(SFB->FB_CPOLVRO)
   			cCpoImpos := "SD1->D1_VALIMP"+AllTrim(SFB->FB_CPOLVRO)
   		Else
			cCpoVBase := "SD2->D2_BASIMP"+AllTrim(SFB->FB_CPOLVRO)
   			cCpoImpos := "SD2->D2_VALIMP"+AllTrim(SFB->FB_CPOLVRO)
   		EndIF
   		nValBase  := &(cCpoVBase)
        nValImpos := &(cCpoImpos)
        If nValImpos > 0
        	aImposto[1] := nValBase
        	aImposto[2] := SFB->FB_ALIQ
			aImposto[3] := nValImpos
		EndIf
		SFB->(dbSkip())
	End
EndIf
RestArea(aSavArea)
Return aImposto

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ�
���Fun��o	 � fa085GetConcept� Autor � Jos� Lucas		� Data � 15.05.11 ���
��������������������������������������������������������������������������Ĵ�
���Descri��o � Retornar o codigo do conceito de reten��o de ISRL � partir  ��
���          � do campo D1_CONCEPT do item da NF de Compras.               ��
��������������������������������������������������������������������������Ĵ�
���Parametros� ExpC1 := Numero da Nota Fiscal                              ��
���          � ExpC2 := Serie da Nota Fiscal                               ��
���          � ExpC3 := C�digo do Fornecedor                               ��
���          � ExpC4 := Loja do Fornecedor                                 ��
��������������������������������������������������������������������������Ĵ�
���Retorno	 � ExpC5 := Conceito                        				   ��
��������������������������������������������������������������������������Ĵ�
���Uso		 � Localiza��o Venezuela                                       ��
���������������������������������������������������������������������������ٱ
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function fa085GetConcept(cNFiscal,cSerie,cFornece,cLoja)
LOCAL aSavArea  := GetArea()
LOCAL cConceito := ""

SD1->(dbSetOrder(1))
If SD1->(dbSeek(xFilial("SD1")+cNFiscal+cSerie+cFornece+cLoja))
	While SD1->(!Eof()) .and. SD1->D1_FILIAL == xFilial("SD1") .and.;
		  SD1->D1_DOC == cNFiscal .and. SD1->D1_SERIE == cSerie .and. SD1->D1_FORNECE == cFornece .and. SD1->D1_LOJA == cLoja
		If !Empty(SD1->D1_CONCEPT)
			cConceito := SD1->D1_CONCEPT
		EndIf
		SD1->(dbSkip())
	End
EndIf
RestArea(aSavArea)
Return cConceito

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fa085GerRet � Autor � Paulo Leme       � Data �  05/04/11  ���
�������������������������������������������������������������������������͹��
���Descricao � //Gera��o das Reten��es de Impostos  - Republica Dominicana���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function fa085GerRet(cFatoGer, cNatur, nValor, cPrefixo, nNum, cFornec)


/* Gera��o das Reten��es de Impostos - Republica Dominicana */
/* Function fa050CalcRet(cCarteira, cFatoGerador)           */
/* 1-Contas a Pagar ou 3-Ambos e Fato Gerador 2-Baixa       */
 fa050CalcRet("'1|3'", cFatoGer, cNatur, nValor, cPrefixo, nNum, cFornec,.T.,cOrdPago)

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  F085PesAbt  �Autor  �Paulo Leme         � Data �  05/04/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Pesquisa de Abatimentos Localiza��es				          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function F085PesAbt()
Local aAreaAtu  := {}
Local aAreaSe2  := {}
Local cChaveSE2	:= ""
Local cFiltAux	:= ""
Local nVlrRet 	:= 0
Local lImposto  := .F.

aAreaAtu 	:= GetArea()
aAreaSe2 	:= SE2->(GetArea())
cChaveSE2 	:= SE2->E2_FILIAL+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM

#IFDEF TOP
	cFiltAux		:=	DbFilter()
	DbClearFilter()
#ENDIF

dbSelectArea("SE2")
SE2->(DbSetOrder(6))
lRet := .F.
If ( SE2->(MsSeek(cChaveSE2)))
  While !SE2->(Eof()) .And. cChaveSE2 == xFilial("SE2")+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM
  	    If cPaisLoc $ "DOM|COS"
		    lImposto  := F085AbtImp(SE2->E2_NATUREZ, SE2->E2_TIPO)
  	    EndIf

  		If 	SE2->E2_TIPO $ MVABATIM .Or. lImposto
  			nVlrRet += SE2->E2_VALOR
  		EndIf
		SE2->(dbSkip())
  		Loop
  EndDo
Endif

RestArea(aAreaSe2)
#IFDEF TOP
	SET FILTER TO &cFiltAux
#ENDIF
RestArea(aAreaSe2)
RestArea(aAreaAtu)

Return nVlrRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  F085AbtImp  �Autor  �Paulo Leme         � Data �  05/04/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �  IDENTIFICA IMPOSTO - ITBIS - ISR - REP DOM                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function F085AbtImp(cNatur, cTipo)
Local lRet := .F.
FRN->( DbSetOrder(2) )
If 	FRN->( DbSeek(xFilial("FRN") + cNatur ) )
	FRM->( DbSetOrder(2) )
	If FRM->( dbSeek(xFilial("FRM") + FRN->FRN_IMPOST + FRN->FRN_SEQ ) )
	   If FRM->FRM_APLICA == "1"
	      lRet := .T.
	   EndIf
	EndIf
EndIf
If cPaisLoc $ "DOM|COS" .And. !cTipo $ "IT |ISR|IR"
   lRet := .F.
EndIf
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  F085DelAbt  �Autor  �Paulo Leme         � Data �  25/05/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Deleta Abatimentos Localiza��es				          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function F085DelAbt(cChaveSE2)
Local aAreaAtu  := {}
Local aAreaSE2  := {}
Local cFiltAux	:= ""
Local nVlrRet 	:= 0
Local lImposto  := .F.

aAreaAtu 	:= GetArea()
aAreaSE2 	:= SE2->(GetArea())

dbSelectArea("SE2")
#IFDEF TOP
	cFiltAux		:=	DbFilter()
	SET FILTER TO
	DbClearFilter()
#ENDIF

SE2->(DbSetOrder(6))

lRet := .F.
If (SE2->(DbSeek(cChaveSE2)))
  While !SE2->(Eof()) .And. cChaveSE2 == xFilial("SE2")+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM
  	    If cPaisLoc $ "DOM|COS"
		    lImposto  := F085AbtImp(SE2->E2_NATUREZ, SE2->E2_TIPO)
	  		If 	SE2->E2_TIPO $ MVABATIM .Or. lImposto
			   	RecLock("SE2")
				SE2->(DbDelete())
				MsUnlock()
  			EndIf
  		EndIf
		SE2->(dbSkip())
		Loop
  EndDo
Endif
RestArea(aAreaSE2)

#IFDEF TOP
	SET FILTER TO &cFiltAux
#ENDIF

RestArea(aAreaAtu)

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  F085FatGer  �Autor  �Paulo Leme         � Data �  25/05/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Identifica Fato Gerador da Reten��o 1-Emissao ou 2-Baixa  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function F085FatGer(cNatur)
Local cFatGer := "1"

FRN->( DbSetOrder(2) )
If 	FRN->( DbSeek( xFilial("FRN") + cNatur ) )
	While 	!FRN->( Eof() ) .And. FRN->(xFilial("FRN") + FRN_CODNAT) 	== 	xFilial('FRN') 	+ cNatur
		If 	FRN->FRN_MSBLQL	<>	'1'
			FRM->( DbSetOrder(2) )
			FRM->( dbSeek(xFilial("FRM") + FRN->FRN_IMPOST + FRN->FRN_SEQ ) )
			While 	!FRM->( Eof() ) .And. FRM->(xFilial("FRM") + FRM->FRM_COD + FRM->FRM_SEQ) 	== 	xFilial('FRM') 	+ FRN->FRN_IMPOST + FRN->FRN_SEQ
				//1-Contas a Pagar ou 3-Ambos e Fato Gerador 2-Emissao.
			    If 	FRM->FRM_CARTEI	   	$ 	"1|3"
					cFatGer	:= FRM->FRM_FATGER
					Exit
				EndIf
				FRM->( DbSkip() )
			EndDo
		EndIf
		If 	cFatGer	<> " "
			Exit
		EndIf
		FRN->( DbSkip() )
	EndDo
EndIf
Return cFatGer

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  |FA85AtuSFE�Autor  �Rodrigo Gimenes     � Data �  29/07/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Quando for d�bito imediato, atualiza o campo com o n�mero ���
���          �  da ordem de pago.                                         ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function FA85AtuSFE(cChave,cOrdPago)
Local aAreaAtu  := {}

aAreaAtu 	:= GetArea()

dbSelectArea("SFE")

SFE->(DbSetOrder(4))
If (SFE->(DbSeek(cChave)))
  While !SFE->(Eof())
  		If Empty(SFE->FE_ORDPAGO )
			RecLock("SFE")
			SFE->FE_ORDPAGO := cOrdPago
			MsUnlock()
		EndIf
	SFE->(dbSkip())
	Loop
  EndDo
Endif
RestArea(aAreaAtu)
Return()

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fA085aLegenda Autor � Jose Lucas          � Data � 10.11.11 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Define a Legenda para os t�tulos do Contas a Pagar na      ���
���          � Orden de Pago...                                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Fina085A                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/
Function fA085aLegenda(cAlias, nReg)

Local aLegenda := { 	{"BR_VERDE"	  , STR0232 },;			//1. "Titulo em aberto"
						{"BR_AZUL"	  , STR0233 },;			//2. "Baixado parcialmente"
						{"BR_VERMELHO", STR0234	},;			//3. "Titulo Baixado"
						{"BR_PRETO"   , STR0235 },;			//4. "Titulo em Bordero"
						{"BR_BRANCO"  , STR0236 },;			//5. "Adiantamento com saldo"
						{"BR_CINZA"   ,	STR0237 }	} 		//6. "Titulo baixado parcialmente e em bordero"
Local uRetorno := .T.

DEFAULT cAlias := "SE2"
DEFAULT nReg   := 0

uRetorno := {}

Aadd(uRetorno, { 'Empty(E2_BAIXA) .and. E2_SALDO == E2_VALOR'	 , aLegenda[1][1] } )
Aadd(uRetorno, { 'E2_SALDO + E2_SDACRES > 0 .and. E2_SALDO <> E2_VALOR'		 , aLegenda[2][1] } )
Aadd(uRetorno, { '!Empty(E2_BAIXA) .and. E2_SALDO + E2_SDACRES == 0'			 , aLegenda[3][1] } )
Aadd(uRetorno, { '!Empty(E2_NUMBOR)'							 , aLegenda[4][1] } )
Aadd(uRetorno, { 'E2_TIPO == "'+MVPAGANT+'" .and. ROUND(E2_SALDO,2) > 0',"BR_BRANCO", aLegenda[5][1] } )
Aadd(uRetorno, { '!Empty(E2_NUMBOR) .and. E2_SALDO > 0 .and. E2_SALDO <> E2_VALOR'  , aLegenda[6][1] } )

If !Empty(GetMv("MV_APRPAG")) .or. GetMv("MV_CTLIPAG")
	Aadd(aLegenda, { "BR_AMARELO", OemToAnsi(STR0238)}) //Titulo aguardando liberacao
	Aadd(uRetorno, { 'Empty(E2_BAIXA) .and. E2_SALDO == E2_VALOR .and. Empty(E2_DATALIB)', aLegenda[Len(aLegenda)][1] } )
EndIf

BrwLegenda(cCadastro, OemToAnsi(STR0240), aLegenda)      //Estado de Contas � Pagar"

Return uRetorno

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fA085GetRet   �Autor  � Jose Lucas     � Data �  09/10/11  ���
�������������������������������������������������������������������������͹��
���Desc.     � Retornar o valor das reten��es de IVA e IR separadamente   ���
��           � somente quando estas possuirem saldos.                     ���
�������������������������������������������������������������������������͹��
���Sintaxe   � ExpN1 := fA085GetRet(ExpC,ExpA1,ExpA2)                     ���
�������������������������������������������������������������������������͹��
���Parametros� ExpC  := Tipo da reten��o ("IV-" ou "IR-").			      ���
���          � ExpA1 := Valor total de reten��es do titulo original.      ���
���          � ExpA2 := Array dos Titulos selecionados na Ordem de Pago.  ���
�������������������������������������������������������������������������͹��
���Retorno   � ExpN1 := Valor da reten��o.               			      ���
�������������������������������������������������������������������������͹��
���Uso       � FINA100                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function fA085GetRet(cTipoRet,nTotalRet,aSE2,aPagos)
Local aArea     := GetArea()
Local nRetencao := 0.00
Local cQrySE2   := ""
Local aTamValor := TamSX3("E2_VALOR")
Local aTamSaldo := TamSX3("E2_SALDO")
Local aPrefixo  := {}
Local aTitulos  := {}
Local aParcela  := {}
Local aFornece  := {}
Local aLoja     := {}
Local nLen      := 0
Local nX        := 0
Local lRet      := .T.

If ValType(nTotalRet) == "C"
	nTotalRet := StrTran(nTotalRet,",","")
	nTotalRet := Val(nTotalRet)
EndIf

If nTotalRet <= 0.00 .or. Len(aSE2) == 0
	lRet := .F.
EndIf
If lRet
	nLen := Len(aPagos)
	If nLen > 0
		For nX:= 1 To Len(aSE2[nLen][1])
			If aSE2[nLen][1][nX][_TIPO] $ "NF "
				AADD(aPrefixo,aSE2[nLen][1][nX][_PREFIXO])
				AADD(aTitulos,aSE2[nLen][1][nX][_NUM    ])
				AADD(aParcela,aSE2[nLen][1][nX][_PARCELA])
				AADD(aFornece,aSE2[nLen][1][nX][_FORNECE])
				AADD(aLoja   ,aSE2[nLen][1][nX][_LOJA])
			EndIf
		Next nX

		If Select("QRYSE2")> 0
			QRYSE2->(dbCloseArea())
		EndIf

		cQrySE2 := "SELECT "
		cQrySE2 += " E2_PREFIXO, "
		cQrySE2 += " E2_NUM, "
		cQrySE2 += " E2_PARCELA, "
		cQrySE2 += " E2_TIPO, "
		cQrySE2 += " E2_VALOR, "
		cQrySE2 += " E2_SALDO "
		cQrySE2	+= " FROM "
		cQrySE2 += RetSqlName("SE2") + " SE2 "
		cQrySE2 += "WHERE "
		cQrySE2 += " E2_FILIAL = '" + xFilial("SE2") + "' "
		cQrySE2 += " AND E2_PREFIXO BETWEEN '"+aPrefixo[1]+"' AND '"+aPrefixo[Len(aPrefixo)]+"' "
		cQrySE2	+= " AND E2_NUM BETWEEN '"+aTitulos[1]+"' AND '"+aTitulos[Len(aTitulos)]+"' "
		cQrySE2	+= " AND E2_PARCELA BETWEEN '"+aParcela[1]+"' AND '"+aParcela[Len(aParcela)]+"' "
		cQrySE2	+= " AND E2_TIPO = '" + cTipoRet + "' "
		cQrySE2	+= " AND E2_FORNECE BETWEEN '"+aFornece[1]+"' AND '"+aFornece[Len(aFornece)]+"' "
		cQrySE2	+= " AND E2_LOJA BETWEEN '"+aLoja[1]+"' AND '"+aLoja[Len(aLoja)]+"' "
		cQrySE2	+= " AND E2_SALDO > 0.00 "
		cQrySE2	+= " AND D_E_L_E_T_ <> '*' "
		cQrySE2 += "ORDER BY E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO "

		cQrySE2	:= ChangeQuery(cQrySE2)

		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQrySE2), "QRYSE2", .T., .T.)

		TcSetField("QRYSE2","E2_VALOR" 	,"N",aTamValor[1],aTamValor[2])
		TcSetField("QRYSE2","E2_SALDO"  ,"N",aTamSaldo[1],aTamSaldo[2])

		QRYSE2->(dbGoTop())
		While QRYSE2->(!Eof())
    		nRetencao += QRYSE2->E2_SALDO
			QRYSE2->(dbSkip())
		End
		QRYSE2->(dbCloseArea())
	EndIf
EndIf

RestArea(aArea)
Return nRetencao

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FINA085A  �Autor  �Microsiga           � Data �  01/06/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function F85aCanRet()
Local nX := 0
Local nY := 0

dbSelectArea("SE2")
SE2->(dbSetOrder(1))

//Array aRetencao - Preenchido na fun��o fa050CalcRet()
If Len(aRetencao) > 0
	For nX := 1 to Len(aRetencao)
		If SE2->(dbSeek(aRetencao[nX][1]+aRetencao[nX][2]+aRetencao[nX][3]+aRetencao[nX][4]+aRetencao[nX][5]+aRetencao[nX][6]+aRetencao[nX][7]))
			For nY := 1 to Len(aRetencao[nX][8])
				If aRetencao[nX][8][nY][3] == "1"
					RecLock("SE2",.F.)
					SE2->E2_VALOR    += aRetencao[nX][8][nY][2]
					SE2->E2_SALDO    += aRetencao[nX][8][nY][2]
					SE2->E2_VLCRUZ   += aRetencao[nX][8][nY][2]
					SE2->(MsUnlock())
				EndIf
			Next nY
		EndIf
	Next nX
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F085GeraVenc�Autor  �Ana Paula Nasci     Data �  01/09/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o para gerar a data de vencimento dos titulos de       ���
���          �reten��o de IVA para o Paraguai, segundo tabela oficial que ���
���          �estabelece o dia de acordo com o ultimo digito do RUC       ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function F085GeraVenc(cPrefixo,cImp)
Local nTamRuc		:= Len(SM0->M0_CGC)
Local dDataVenc		:= Ctod("//")
Local cDigRuc		:= Subs(SM0->M0_CGC,nTamRuc,1)
Local cAux			:= ""
Local cMsg			:= ""

DEFAULT cPrefixo	:= ""
DEFAULT cImp		:= ""

If cPaisLoc == "PER"
	If FindFunction("FR0CHAVE")
		If !Empty(cImp)
			/* procura por uma data especifica para o imposto */
			cAux := FR0Chave("PE4",Substr(Dtos(dDataBase),1,6),cImp,"01")
			If Empty(cAux)
				/* se nao encontrar uma data especifica, procura por uma padr�o ("uso geral") */
				cAux := FR0Chave("PE4",Substr(Dtos(dDataBase),1,6),"","01")
			Endif
		Else
			/* se nao informado o imposto, procura por uma data de "uso geral" */
			cAux := FR0Chave("PE4",Substr(Dtos(dDataBase),1,6),"","01")
		Endif
		dDataVenc := Ctod(cAux)
		If Empty(dDataVenc)
			dDataVenc := dDataBase
			/* se a data nao e valida, ou a tabela PE4 esta errada ou ela nao existe na FR0 */
			cMsg += AllTrim(STR0245)
			cMsg += ": " + Strzero(Month(dDataBase),2) + "/" + Strzero(Year(dDataBase),4) + "." + CRLF
			cMsg += AllTrim(STR0246) + "."
			MsgAlert(cMsg,STR0223)
		Endif
	Endif
ElseIf cPaisLoc == "PAR"
	If cPrefixo == "EXT" .And. cImp=="R"
		dDataVenc:= cTod("30/"+StrZero(Iif(Month(dDataBase)==12,01,Month(dDataBase)),2)+"/"+StrZero(Iif(Month(dDataBase)==12,Year(dDataBase)+1,Year(dDataBase)),4))
	Else
		Do Case
		Case cDigRuc == "0"
			dDataVenc:= cTod("07/"+StrZero(Iif(Month(dDataBase)==12,01,Month(dDataBase)+1),2)+"/"+StrZero(Iif(Month(dDataBase)==12,Year(dDataBase)+1,Year(dDataBase)),4))
		Case cDigRuc == "1"
			dDataVenc:= cTod("09/"+StrZero(Iif(Month(dDataBase)==12,01,Month(dDataBase)+1),2)+"/"+StrZero(Iif(Month(dDataBase)==12,Year(dDataBase)+1,Year(dDataBase)),4))
		Case cDigRuc == "2"
			dDataVenc:= cTod("11/"+StrZero(Iif(Month(dDataBase)==12,01,Month(dDataBase)+1),2)+"/"+StrZero(Iif(Month(dDataBase)==12,Year(dDataBase)+1,Year(dDataBase)),4))
		Case cDigRuc == "3"
			dDataVenc:= cTod("13/"+StrZero(Iif(Month(dDataBase)==12,01,Month(dDataBase)+1),2)+"/"+StrZero(Iif(Month(dDataBase)==12,Year(dDataBase)+1,Year(dDataBase)),4))
		Case cDigRuc == "4"
			dDataVenc:= cTod("15/"+StrZero(Iif(Month(dDataBase)==12,01,Month(dDataBase)+1),2)+"/"+StrZero(Iif(Month(dDataBase)==12,Year(dDataBase)+1,Year(dDataBase)),4))
		Case cDigRuc == "5"
			dDataVenc:= cTod("17/"+StrZero(Iif(Month(dDataBase)==12,01,Month(dDataBase)+1),2)+"/"+StrZero(Iif(Month(dDataBase)==12,Year(dDataBase)+1,Year(dDataBase)),4))
		Case cDigRuc == "6"
			dDataVenc:= cTod("19/"+StrZero(Iif(Month(dDataBase)==12,01,Month(dDataBase)+1),2)+"/"+StrZero(Iif(Month(dDataBase)==12,Year(dDataBase)+1,Year(dDataBase)),4))
		Case cDigRuc == "7"
			dDataVenc:= cTod("21/"+StrZero(Iif(Month(dDataBase)==12,01,Month(dDataBase)+1),2)+"/"+StrZero(Iif(Month(dDataBase)==12,Year(dDataBase)+1,Year(dDataBase)),4))
		Case cDigRuc == "8"
			dDataVenc:= cTod("23/"+StrZero(Iif(Month(dDataBase)==12,01,Month(dDataBase)+1),2)+"/"+StrZero(Iif(Month(dDataBase)==12,Year(dDataBase)+1,Year(dDataBase)),4))
		Case cDigRuc == "9"
			dDataVenc:= cTod("25/"+StrZero(Iif(Month(dDataBase)==12,01,Month(dDataBase)+1),2)+"/"+StrZero(Iif(Month(dDataBase)==12,Year(dDataBase)+1,Year(dDataBase)),4))
		End
	EndIf
Endif
Return(dDataVenc)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F085TITIMP�Autor  �Microsiga           �Fecha � 27/02/2012  ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera titulos no contas a pagar referentes aos impostos e   ���
���          � retencoes.                                                 ���
���          � Os titulos gerados tem o mesmo numero da ordem de pago,    ���
���          � com as parcelas em sequencia crescente (1,2,3...)          ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function F085TitImp(aSE2,cOrdPago)
Local aTitulos	:= {}
Local cFornec	:= ""
Local cLojaImp	:= ""
Local cParcela	:= ""
Local nSE2		:= 0
Local nTit		:= 0
Local nValor1	:= 0
Local nValor2	:= 0
Local lF085GER  := ExistBlock("F085GER")

Default aSE2	:= {{}}
/* Verifica os impostos e retencoes praticados
Estrutura do array de titulos: {valor,data de vencimento,moeda,tipo,historico} */
If cPaisLoc == "PER"
	For	nSE2 := 1 To Len(aSE2[1])
		/* cria um titulo por tipo de retencao */
		If !Empty(aSE2[1,nSe2,_RETIGV])		//IGV
			For nTit := 1 To Len(aSE2[1,nSe2,_RETIGV])
				nValor1 += aSE2[1,nSe2,_RETIGV,nTit,4]
			Next
		Endif
		If !Empty(aSE2[1,nSe2,_RETIR])		//IR
			For nTit := 1 To Len(aSE2[1,nSe2,_RETIR])
				nValor2 += aSE2[1,nSe2,_RETIR,nTit,4]
			Next
		Endif
	Next
	If nValor1 > 0
		Aadd(aTitulos,{nValor1,F085GeraVenc("","IG-"),1,"IG-",STR0196})
	Endif
	If nValor2 > 0
		Aadd(aTitulos,{nValor2,F085GeraVenc("","IR-"),1,"IR-",STR0203})
	Endif
Endif
/* Grava os titulos referentes a impostos e retencoes */
If !Empty(aTitulos)
	cLojaImp := PadR("00",TamSX3("A2_LOJA")[1],"0")
	cParcela := PadR("0",TamSX3("E2_PARCELA")[1],"")
	/* Verifica se o fornecedor padrao para impostos existe e em caso negativo, o insere no cadastro */
	cFornec := GetMV("MV_UNIAO",.T.,"FISCO")
	cFornec := Padr(cFornec,TamSX3("A2_COD")[1])
	If !SA2->(DbSeek(xFilial("SA2") + cFornec))
		Reclock("SA2",.T.)
		Replace A2_FILIAL	With xFilial("SA2")
		Replace A2_COD		With cFornec
		Replace A2_NOME		With OemToAnsi(STR0219)  // "UNIAO"
		Replace A2_NREDUZ	With OemToAnsi(STR0219)  // "UNIAO"
		Replace A2_LOJA		With cLojaImp
		Replace A2_MUN		With "."
		Replace A2_EST		With "."
		Replace A2_BAIRRO	With "."
		Replace A2_END		With "."
		Replace A2_TIPO		With "J"
		SA2->(MsUnLock())
		SA2->(DbCommit())
	Endif
	/* insere os titulos */
	For nTit := 1 To Len(aTitulos)
		cParcela := Soma1(cParcela)
		RecLock("SE2",.T.)
		SE2->E2_FILIAL 	:= xFilial("SE2")
		SE2->E2_NUM		:= cOrdPago
	 	SE2->E2_PARCELA := cParcela
		SE2->E2_EMISSAO	:= dDataBase
		SE2->E2_VENCTO 	:= aTitulos[nTit,2]
		SE2->E2_VENCORI	:= aTitulos[nTit,2]
		SE2->E2_VENCREA	:= DataValida(aTitulos[nTit,2])
		SE2->E2_VALOR	:= aTitulos[nTit,1]
		SE2->E2_SALDO	:= aTitulos[nTit,1]
		SE2->E2_NATUREZ	:= SA2->A2_NATUREZ
		SE2->E2_TIPO	:= aTitulos[nTit,4]
		SE2->E2_NOMFOR  := SA2->A2_NREDUZ
		SE2->E2_PREFIXO	:= "  "			//o prefixo sempre e deixado em branco, para facilitar na exclusao da OP (ver fina086)
		SE2->E2_FORNECE := SA2->A2_COD
		SE2->E2_LOJA	:= SA2->A2_LOJA
		SE2->E2_EMIS1	:= dDataBase
		SE2->E2_VLCRUZ 	:= aTitulos[nTit,1]
		SE2->E2_MOEDA	:= aTitulos[nTit,3]
		SE2->E2_HIST	:= aTitulos[nTit,5]
		SE2->E2_ORIGEM	:= "FINA085A"
		SE2->(MsUnLock())
		SE2->(DbCommit())
		IF lF085GER
	       ExecBlock("F085GER",.f.,.f.)
	   Endif
	Next
Endif
Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FINA085A  �Autor  �Microsiga           � Data �  10/16/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function F085AcmIVA(cTpAcm,dDtRef,cFornece,cLoja)
Local dDataIni	:=	""
Local dDataFim	:= 	""
Local cChaveSFE :=  ""
Local cDoc 		:=  ""
Local lEmpty	:= .F.
Local lValid	:= .F.
Local nValImp 	:= 0
Local nValRet	:= 0
Local nTotal	:= 0
Local nTotOP	:= 0
Local aRet		:= Array(5)
Local aDados 	:= {}

#IFDEF TOP
	Local cQuery	:=	""
	Local cAlias	:=	""
#ENDIF

DEFAULT cTpAcm		:= 0
DEFAULT dDtRef 		:= dDataBase
DEFAULT cFornece	:= ""
DEFAULT cLoja    	:= ""

If cTpAcm == "1" //Acumulo anual
	dDataIni := Ctod("01/01/"+Str(Year(dDtRef),4))
	dDataFim := Ctod("31/12/"+Str(Year(dDtRef),4))
ElseIf cTpAcm == "2" //Acumulo mensal
	dDataIni := FirstDay(dDtRef)
	dDataFim := LastDay(dDtRef)
Else
	dDataIni := dDtRef
	dDataFim := dDtRef
Endif

#IFDEF TOP

   		//Somar acumulado
		cQuery	:=	" SELECT D1_TOTAL, F1_DOC, F1_SERIE, F1_MOEDA, E2_OK, E2_SALDO, "
		If SF1->(FieldPos("F1_ORDPAGO")) > 0
			cQuery	+=	" F1_ORDPAGO, "
		EndIf
		cQuery 	+=  " SF1.R_E_C_N_O_ F1_RECNO"
		cQuery 	+=  " FROM "+RetSqlName("SD1")+" SD1, "+RetSqlName("SF1")+" SF1, "+RetSqlName("SE2")+" SE2 "
		cQuery	+=	" WHERE "
		cQuery	+=	" D1_FILIAL = '"+xFilial("SD1")+"' AND "
		cQuery	+=	" D1_FORNECE 	= '"+cFornece+ "' AND "
		cQuery	+=	" D1_LOJA	 	= '"+cLoja+ "' AND "
		cQuery	+=	" F1_SERIE 		= D1_SERIE AND "
		cQuery	+=	" F1_DOC 		= D1_DOC AND "
		cQuery	+=	" F1_ESPECIE 	= D1_ESPECIE AND "
		cQuery	+=	" F1_LOJA 		= D1_LOJA AND "
		cQuery	+=	" F1_FORNECE	= D1_FORNECE AND "
		//Ajuste para a diferen�a de compartilhamento
		If !Empty(xFilial("SE2")) .And. !Empty(xFilial("SF1"))
			cQuery	+=	" F1_FILIAL	= E2_FILIAL AND "
		EndIf
		cQuery	+=	" F1_SERIE 		= E2_PREFIXO AND "
		cQuery	+=	" F1_DOC 		= E2_NUM AND "
		cQuery	+=	" F1_ESPECIE 	= E2_TIPO AND "
		cQuery	+=	" F1_LOJA 		= E2_LOJA AND "
		cQuery	+=	" F1_FORNECE	= E2_FORNECE AND "

		cQuery	+=	" D1_TIPO IN ('C','N') AND "

		cQuery	+=	" F1_EMISSAO BETWEEN '"+Dtos(dDataIni)+"' AND '"+Dtos(dDataFim)+"' AND "

		cQuery	+=	" SE2.D_E_L_E_T_ = '' AND "
		cQuery	+=	" SF1.D_E_L_E_T_ = '' AND "
		cQuery	+=	" SD1.D_E_L_E_T_ = '' "

		cQuery 	:= 	ChangeQuery(cQuery)
		cAlias	:=	GetNextAlias()
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.)
		While !Eof()

		    nTotal += xMoeda(D1_TOTAL,F1_MOEDA,1,dDataBase)

			If FieldPos("F1_ORDPAGO") > 0
				If !Empty(F1_ORDPAGO)
					cDoc := F1_DOC+F1_SERIE

					//Valida se n�o foi reten��o parcial
					SFE->(dbSetOrder(4))
					If SFE->(dbSeek(xFilial("SFE")+cFornece+cLoja+cDoc+"I"))
				  	   	cChaveSFE := xFilial("SFE")+SFE->FE_FORNECE+SFE->FE_LOJA+SFE->FE_NFISCAL+SFE->FE_SERIE
						While !SFE->(Eof()) .And. cChaveSFE == SFE->FE_FILIAL+SFE->FE_FORNECE+SFE->FE_LOJA+SFE->FE_NFISCAL+SFE->FE_SERIE
							If SFE->FE_TIPO =="I" .and. SFE->FE_RETENC > 0
								nValImp := SFE->FE_VALIMP
								nValRet += SFE->FE_RETENC
							EndIf
							SFE->(dbSkip())
						EndDo

						If nValImp == nValRet
				   			nTotOP += xMoeda(D1_TOTAL,F1_MOEDA,1,dDataBase)
				   			lEmpty := .F. //N�o zero o numero da OP nos casos de baixas totais
				  		Else
				  			lEmpty := .T. //Zero o numero da OP nos casos de baixas parciais
				  			lValid := .T. //Recalcula os impostos para o saldo nas baixas parciais
				  		EndIf

				  		nValImp := 0
						nValRet := 0
					Else
						nTotOP += xMoeda(D1_TOTAL,F1_MOEDA,1,dDataBase)
					EndIf
				Else
					lValid := .T.
				EndIf
			EndIf
			//aDados - Dados adicionais do c�lculo de cumulatividade
			//1 = Selecionado na OP - .T. ou .F.
			//2 = Retido em alguma OP - campo F1_ORDPAGO
			//3 = Recno da nota (SF1) - para grava��o do n� da OP para reten��o acumulada
			aAdd(aDados,{Iif(E2_OK == cMarcaE2,.T.,.F.),If(lEmpty,"",F1_ORDPAGO),F1_RECNO,"SF1"})
			lEmpty := .F.
			(cAlias)->(DbSkip())
		EndDo

		(cAlias)->(DbCloseArea())

		cQuery	:=	" SELECT D2_TOTAL, F2_MOEDA, F2_DOC, F2_SERIE, E2_OK, "
		If SF2->(FieldPos("F2_ORDPAGO")) > 0
			cQuery	+=	" F2_ORDPAGO, "
		EndIf
		cQuery 	+=  " SF2.R_E_C_N_O_ F2_RECNO"
		cQuery 	+=  " FROM "+RetSqlName("SD2")+" SD2, "+RetSqlName("SF2")+" SF2, "+RetSqlName("SE2")+" SE2 "
		cQuery	+=	" WHERE "
		cQuery	+=	" D2_FILIAL = '"+xFilial("SD2")+"' AND "
		cQuery	+=	" D2_CLIENTE 	= '"+cFornece+ "' AND "
		cQuery	+=	" D2_LOJA	 	= '"+cLoja+ "' AND "
		cQuery	+=	" F2_SERIE 		= D2_SERIE AND "
		cQuery	+=	" F2_DOC 		= D2_DOC AND "
		cQuery	+=	" F2_ESPECIE 	= D2_ESPECIE AND "
		cQuery	+=	" F2_LOJA 		= D2_LOJA AND "
		cQuery	+=	" F2_CLIENTE	= D2_CLIENTE AND "
		//Ajuste da diferen�a de compartilhamento
		If !Empty(xFilial("SE2")) .And. !Empty(xFilial("SF2"))
			cQuery	+=	" F2_FILIAL	= E2_FILIAL AND "
		EndIf
		cQuery	+=	" F2_SERIE 		= E2_PREFIXO AND "
		cQuery	+=	" F2_DOC 		= E2_NUM AND "
		cQuery	+=	" F2_ESPECIE 	= E2_TIPO AND "
		cQuery	+=	" F2_LOJA 		= E2_LOJA AND "
		cQuery	+=	" F2_CLIENTE	= E2_FORNECE AND "

		cQuery	+=	" D2_TIPO IN ('D','N') AND "

		cQuery	+=	" F2_EMISSAO BETWEEN '"+Dtos(dDataIni)+"' AND '"+Dtos(dDataFim)+"' AND "

		cQuery	+=	" SE2.D_E_L_E_T_ = '' AND "
		cQuery	+=	" SF2.D_E_L_E_T_ = '' AND "
		cQuery	+=	" SD2.D_E_L_E_T_ = '' "

		cQuery 	:= 	ChangeQuery(cQuery)
		cAlias	:=	GetNextAlias()
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.)
		While !Eof()

		    nTotal -= xMoeda(D2_TOTAL,F2_MOEDA,1,dDataBase)

			If FieldPos("F2_ORDPAGO") > 0
				If !Empty(F2_ORDPAGO)
					cDoc := F2_DOC+F2_SERIE
					//Valida se n�o foi reten��o parcial
					SFE->(dbSetOrder(4))
					If SFE->(dbSeek(xFilial("SFE")+cFornece+cLoja+cDoc+"I"))
				  	   	cChaveSFE := xFilial("SFE")+SFE->FE_FORNECE+SFE->FE_LOJA+SFE->FE_NFISCAL+SFE->FE_SERIE
						While !SFE->(Eof()) .And. cChaveSFE == SFE->FE_FILIAL+SFE->FE_FORNECE+SFE->FE_LOJA+SFE->FE_NFISCAL+SFE->FE_SERIE
							If SFE->FE_TIPO =="I" .and. SFE->FE_RETENC < 0
								nValImp := SFE->FE_VALIMP
								nValRet += SFE->FE_RETENC
							EndIf
							SFE->(dbSkip())
						EndDo

						If nValImp == nValRet
				   			nTotOP -= xMoeda(D2_TOTAL,F2_MOEDA,1,dDataBase)
				   			lEmpty := .F. //N�o zero o numero da OP nos casos de baixas totais
				  		Else
				  			lEmpty := .T. //Zero o numero da OP nos casos de baixas parciais
				  			lValid := .T. //Recalcula os impostos para o saldo nas baixas parciais
				  		EndIf

				  		nValImp := 0
						nValRet := 0
					Else
						nTotOP -= xMoeda(D2_TOTAL,F2_MOEDA,1,dDataBase)
					EndIf
				Else
					lValid := .T.
				EndIf
			EndIf

			//aDados - Dados adicionais do c�lculo de cumulatividade
			//1 = Selecionado na OP - .T. ou .F.
			//2 = Retido em alguma OP - campo F1_ORDPAGO
			//3 = Recno da nota (SF1) - para grava��o do n� da OP para reten��o acumulada
			aAdd(aDados,{Iif(E2_OK == cMarcaE2,.T.,.F.),Iif(lEmpty,"",F2_ORDPAGO),F2_RECNO,"SF2"})
			(cAlias)->(DbSkip())
		EndDo

		aRet[1] := nTotal
		aRet[2] := nTotOP
		aRet[3] := aDados
		aRet[4] := lValid

		(cAlias)->(DbCloseArea())

#ENDIF

Return aRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FINA085A  �Autor  �Microsiga           � Data �  10/16/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � IVA acumulado de outros documentos					     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function F085DocIVA(cFornece,cLoja)

Local aAreaSA2 := SA2->(GetArea())
Local aAreaSE2 := SE2->(GetArea())
Local aAreaSF1 := SF1->(GetArea())
Local aAreaSD1 := SD1->(GetArea())
Local aAreaSF2 := SF2->(GetArea())
Local aAreaSD2 := SD2->(GetArea())

Local aIVA 		:= {}
Local aConfIVA 	:= {}
Local aDocs		:= {}

Local cAliasSF		:= ""
Local cAliasSD		:= ""
Local cChaveSF		:= ""
Local cTotal		:= ""
Local cSerie		:= ""
Local cDoc			:= ""
Local cCFO			:= ""
Local cSFE			:= ""
Local cChaveSFE		:= ""
Local nX 			:= 0
Local nY        	:= 0
Local nAliq 		:= 0
Local nSigno	 	:= 1
Local nPorcIva 		:= 1
Local nValor		:= 0
Local nTotRetSFE	:= 0

DEFAULT cFornece := ""
DEFAULT cLoja	 := ""

If Len(aRetIvAcm) > 0

	If aRetIvAcm[1] <> Nil
		aConfIVA := aRetIvAcm[1]
	EndIf

	If aRetIvAcm[2] <> Nil
		aDocs := aRetIvAcm[2]
	EndIf

EndIf

If cFornece <> Nil .And. cLoja <> Nil
	dbSelectArea("SA2")
	SA2->(dbSetOrder(1))
	If SA2->(dbSeek(xFilial("SA2")+cFornece+cLoja))
		nPorcIva := SA2->A2_PORIVA/100
	EndIf
EndIf

If Len(aDocs) > 0 .And. Len(aConfIVA) > 0

	nAliq := aConfIVA[1]/100

	For nX := 1 to Len(aDocs)

		If aDocs[nX][3] //Calcula IVA para o documento

			cAliasSF := aDocs[nX][2]
			dbSelectArea(cAliasSF)

			(cAliasSF)->(dbGoTo(aDocs[nX][1]))

			If cAliasSF == "SF1"
				cAliasSD := "SD1"
				nSigno 	 := 1
				cChaveSF := "F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA"
				cTotal	 := "D1_TOTAL"
				cSerie	 := "F1_SERIE"
				cDoc	 := "F1_DOC"
				cCFO	 := "D1_CF"
				cSFE 	 := "F1_FORNECE+F1_LOJA+F1_DOC+F1_SERIE"
				cForn	 := "D1_FORNECE"
				cLojaForn:= "D1_LOJA"
				cDocSD  := "D1_DOC"
				cSerieSD:= "D1_SERIE"
			Else
				cAliasSD := "SD2"
				nSigno 	 := -1
				cChaveSF := "F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA"
				cTotal	 := "D2_TOTAL"
				cSerie	 := "F2_SERIE"
				cDoc	 := "F2_DOC"
				cCFO	 := "D2_CF"
				cSFE 	 := "F2_CLIENTE+F2_LOJA+F2_DOC+F2_SERIE"
				cForn	 := "D2_CLIENTE"
				cLojaForn:= "D2_LOJA
				cDocSD  := "D2_DOC"
				cSerieSD:= "D2_SERIE"
			EndIf

			dbSelectArea(cAliasSD)
			If cAliasSD == "SD1"
				(cAliasSD)->(dbSetOrder(1))
			Else
				(cAliasSD)->(dbSetOrder(3))
			EndIf

		   (cAliasSD)->(DbSeek(xFilial(cAliasSD)+(cAliasSF)->&(cChaveSF)))
			While !(cAliasSD)->(Eof()) .And. (cAliasSD)->&(cDocSD)+ (cAliasSD)->&(cSerieSD)+(cAliasSD)->&(cForn)+(cAliasSD)->&(cLojaForn) ==(cAliasSF)->&(cChaveSF)
				If SFF->(dbSeek(xFilial()+"SLI"+(cAliasSD)->&(cCFO)))
					nValor += (cAliasSD)->&(cTotal)
				Endif 
				(cAliasSD)->(dbSkip())
			EndDo

			AAdd(aIVA,Array(10))
			aIVA[Len(aIVA)][1]  := (cAliasSF)->&(cDoc)        			//FE_NFISCAL
			aIVA[Len(aIVA)][2]  := (cAliasSF)->&(cSerie)       			//FE_SERIE
			aIVA[Len(aIVA)][3]  := (nValor*nSigno)						//FE_VALBASE
			aIVA[Len(aIVA)][4]  := (nValor*nAliq)*nSigno				//FE_VALIMP
			aIVA[Len(aIVA)][5]  := nPorcIva*100    						//FE_PORCRET
			aIVA[Len(aIVA)][6]  := (aIVA[Len(aIVA)][4] * nPorcIva)  	//FE_RETENC
			aIVA[Len(aIVA)][9]  := (cAliasSD)->&(cCFO) 					//Gravar CFOP da opera��o
			aIVA[Len(aIVA)][10] := nAliq					            //Aliquota do imposto

	        //Levanta quanto ja foi retido
			SFE->(dbSetOrder(4))
			If SFE->(dbSeek(xFilial("SFE")+(cAliasSF)->&(cSFE)+"I"))
		  	   	cChaveSFE := xFilial("SFE")+SFE->FE_FORNECE+SFE->FE_LOJA+SFE->FE_NFISCAL+SFE->FE_SERIE
				While !SFE->(Eof()) .And. cChaveSFE == SFE->FE_FILIAL+SFE->FE_FORNECE+SFE->FE_LOJA+SFE->FE_NFISCAL+SFE->FE_SERIE
					If SFE->FE_TIPO =="I" .and. ((SFE->FE_RETENC < 0 .and. cAliasSF == "SF2") .or. (SFE->FE_RETENC > 0 .and. cAliasSF == "SF1"))
						nTotRetSFE += SFE->FE_RETENC
					EndIf
					SFE->(dbSkip())
				EndDo

				//Abate da retencao que foi calculada.
				aIVA[Len(aIVA)][6] -= nTotRetSFE
				nTotRetSFE := 0
			EndIf

	        nValor := 0
	        (cAliasSD)->(dbCloseArea())
	        (cAliasSF)->(dbCloseArea())

		EndIf

	Next nX

EndIf

aRetIvAcm[3] := aIVA

SA2->(RestArea(aAreaSA2))
SE2->(RestArea(aAreaSE2))
SD1->(RestArea(aAreaSD1))
SF1->(RestArea(aAreaSF1))
SD2->(RestArea(aAreaSD2))
SF2->(RestArea(aAreaSF2))

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FINA085A  �Autor  �Microsiga           � Data �  10/25/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function F085PropIV(nValPag,nRetIva,aSE2TMP)

Local nX 	:= 0
Local nA 	:= 0
Local nProp := 0
Local nSoma := 0

DEFAULT nValPag	  := 0
DEFAULT nRetIVA	  := 0
DEFAULT aSE2TMP   := {}

//Proporcionaliza��o
If nValPag < nRetIVA
	nProp := nValPag/nRetIVA
Else
	nProp := 1
EndIf

If nProp < 1
	//Proporcionaliza o valor de IVA das notas pendentes
	For nX := 1 to Len(aRetIvAcm[3])
		aRetIvAcm[3][nX][6] := Round(aRetIvAcm[3][nX][6] * nProp,MsDecimais(1))
	 	nSoma += aRetIvAcm[3][nX][6]
	Next nX

	//Proporcionaliza o valor do IVA das notas selecionadas na OP
	If Len(aSE2TMP) > 0
		For nA	:=	1	To	Len(aSE2TMP[1])
			For nX	:=	1	To	Len(aSE2TMP[1][nA][_RETIVA])
				aSE2TMP[1][nA][_RETIVA][nX][6] := Round(aSE2TMP[1][nA][_RETIVA][nX][6] * nProp,MsDecimais(1))
				nSoma += aSE2TMP[1][nA][_RETIVA][nX][6]
			Next nX
		Next nA
	EndIf

	//Ajusta os centavos no �ltimo t�tulo
	If nSoma > nValPag .and. !(SE2->E2_TIPO $ MVPAGANT + "/" + MV_CPNEG)
		If Len(aSE2TMP) > 0
			If Len(aSE2TMP[1][Len(aSE2TMP[1])][_RETIVA]) > 0
				aSE2TMP[1][Len(aSE2TMP[1])][_RETIVA][Len(aSE2TMP[1][Len(aSE2TMP[1])][_RETIVA])][6] -= (nSoma - nValPag)
			EndIf
		EndIf
	ElseIf (nValPag - nSoma) == 0.01
		If Len(aSE2TMP) > 0
			If Len(aSE2TMP[1][Len(aSE2TMP[1])][_RETIVA]) > 0
				aSE2TMP[1][Len(aSE2TMP[1])][_RETIVA][Len(aSE2TMP[1][Len(aSE2TMP[1])][_RETIVA])][6] += 0.01
			EndIf
		EndIf
	EndIf

EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PMSFi085a �Autor  �Jandir Deodato      �Fecha � 04/09/12    ���
�������������������������������������������������������������������������͹��
���Desc.     � Caso a integra��o com o Totvs Obras e Projetos esteja      ���
���              ligada chama a tela de rateio do projeto.                ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PMSFi085a()
Local aArea
Local bPMSDlgF08	:= {||PmsDlgFI(3,SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA)}//integra��o pms
aArea:=GetArea()
M->E2_NUM 		:= SE2->E2_NUM
M->E2_PREFIXO := SE2->E2_PREFIXO
M->E2_FORNECE := SE2->E2_FORNECE
M->E2_LOJA		:=SE2->E2_LOJA
M->E2_ORIGEM	:=SE2->E2_ORIGEM
M->E2_VALOR	:=SE2->E2_VALOR
M->E2_MOEDA	:=SE2->E2_MOEDA
M->E2_TXMOEDA	:=SE2->E2_TXMOEDA
Eval(bPmsDlgF08)
PmsWriteFI(1,"SE2")
RestArea(aArea)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CalcRetCmr �Autor  �Marivaldo		     �Fecha � 25/03/13    ���
�������������������������������������������������������������������������͹��
���Desc.     � Calcular e Gerar Retencoes sobre Caja Medica               ���
���                           											  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CalRetCmr2 �Autor  �Marivaldo		     �Fecha � 25/03/13    ���
�������������������������������������������������������������������������͹��
���Desc.     � Calcular e Gerar Retencoes sobre Caja Medica               ���
���                           											  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function CalRetCmr2(cAgente,nSigno,nSaldo)

Local nRateio
Local nRatValImp
Local nValMerc
Local nTotOrden
Local nPosGan,cConc
Local nX,nY,nMoeda   := 1
Local aConCmr	:=	{}
Local aConCmrRat	:=	{}
Local lCalcGN := .T.
Local nI:=1
Local nVlrTotal:=0
Local aImpInf := {}
Local lCalcula:=.F.
Local nAliqSFH:=0
Local nValRet	:= 0
DEFAULT nSigno	:=	1

//As retencoes sao calculadas com a taxa do d�a e nao com a taxa variavel....
//Bruno.
	If ExistBlock("F0851IMP")
		lCalcGN:=ExecBlock("F0851IMP",.F.,.F.,{"GN"})
	EndIf

DbSelectArea("SFH")
DbSetOrder(1)
If Dbseek(xFilial("SFH")+SE2->E2_FORNECE+SE2->E2_LOJA+"CMR")
  	lCalcula:=.T.
	nAliqSFH:= SFH->FH_ALIQ
EndIf

//+----------------------------------------------------------------+
//� Obter o Valor do Imposto e Base baseando se no rateio do valor �
//� do titulo pelo total da Nota Fiscal.                           �
//+----------------------------------------------------------------+
If lCalcula .and. (SE2->E2_TIPO $ MV_CPNEG).and. A085aVigSFH()
   		DbSelectArea("SF2")
   		DbSetOrder(1)
		If lMsFil
			dbSeek(SE2->E2_MSFIL+(SE2->E2_NUM)+(SE2->E2_PREFIXO)+(SE2->E2_FORNECE)+SE2->E2_LOJA)
		Else
			dbSeek(xFilial("SF2")+(SE2->E2_NUM)+(SE2->E2_PREFIXO)+(SE2->E2_FORNECE)+SE2->E2_LOJA)
		EndIf
	While Alltrim(SF2->F2_ESPECIE)<>Alltrim(SE2->E2_TIPO).And.!Eof()
		SF2->(DbSkip())
		Loop
	Enddo

	If Alltrim(SF2->F2_ESPECIE)==Alltrim(SE2->E2_TIPO).And.;
		Iif(lMsFil, SF2->F2_MSFIL,xFilial("SF2"))+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA==;
		F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA

		nMoeda      := Max(SF2->F2_MOEDA,1)

		If cPaisLoc<>"ARG"
			nRateio := 1
		else
			nRateio := ( SF2->F2_VALMERC - SF2->F2_DESCONT ) / SF2->F2_VALBRUT
		Endif

		nRatValImp	:= ( Round(xMoeda(nSaldo,SE2->E2_MOEDA,1,,5,aTxMoedas[Max(SE2->E2_MOEDA,1)][2]),MsDecimais(1)) / Round(xMoeda(SF2->F2_VALBRUT,SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1)) )
		nValMerc 	:= ( Round(xMoeda(nSaldo,SE2->E2_MOEDA,1,,5,aTxMoedas[Max(SE2->E2_MOEDA,1)][2]),MsDecimais(1)) * nRateio )
		If SF2->F2_FRETE > 0
			MV_FRETLOC := GetNewPar("MV_FRETLOC","IVA162GAN06")
			cConc   := Alltrim(Subs( MV_FRETLOC, At("N",MV_FRETLOC)+1))
			nPosGan := ASCAN(aConCmr,{|x| x[1]==cConc.And. x[3]==''})
			If nPosGan<>0
				aConCmr[nPosGan][2]:=aConCmr[nPosGan][2]+(Round(xMoeda(SF2->F2_FRETE,SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1))*nRatValimp)
			Else
				Aadd(aConCmr,{cConc,Round(xMoeda(SF2->F2_FRETE,SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1))*nRatValimp,''})
			Endif
		EndIf
		If SF2->F2_DESPESA >  0
			MV_GASTLOC  := GetNewPar("MV_GASTLOC","IVA112GAN06")
			cConc   := Alltrim(Subs( MV_GASTLOC, At("N",MV_GASTLOC)+1))
			nPosGan := ASCAN(aConCmr,{|x| x[1]==cConc.And. x[3]==''})
			If nPosGan<>0
				aConCmr[nPosGan][2]:=aConCmr[nPosGan][2]+Round(xMoeda(SF2->F2_DESPESA,SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1))*nRatValimp
			Else
				Aadd(aConCmr,{cConc,Round(xMoeda(SF2->F2_DESPESA,SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1))*nRatValimp,''})
			Endif
		EndIf

		SD2->(DbSetOrder(3))
			If lMsFil
				SD2->(DbSeek(SF2->F2_MSFIL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
			Else
				SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
			EndIf
		If SD2->(Found())
		    Do while Iif(lMsFil, SD2->D2_MSFIL,xFilial("SD2"))==SD2->D2_FILIAL.And.SF2->F2_DOC==SD2->D2_DOC.AND.;
				SF2->F2_SERIE==SD2->D2_SERIE.AND.SF2->F2_CLIENTE==SD2->D2_CLIENTE;
				.AND.SF2->F2_LOJA==SD2->D2_LOJA.And.!SD2->(EOF())

				IF AllTrim(SD2->D2_ESPECIE)<>AllTrim(SE2->E2_TIPO)
					SD2->(DbSkip())
					Loop
				Endif
					aImpInf := TesImpInf(SD2->D2_TES)
					SFF->(DbSetOrder(6))

					 // Imposto +CFO
					If SFF->(Dbseek(xfilial("SFF")+"CMR"+Pad(SD2->D2_CF,len(SFF->FF_CFO)) )) .and. Round(xMoeda(( SF2->F2_VALMERC - SF2->F2_DESCONT ),SF2->F2_MOEDA,1,,,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1)) > SFF->FF_FXDE

			 			nAliq:= SFF-> FF_ALIQ

			 			If nAliqSFH>0
			 				nAliq:=nAliqSFH
			 			EndIf

			 				nPosGan:=ASCAN(aConCmr,{|x| x[1]==Pad(SF2->F2_CFO,len(SFF->FF_CFOC)) })
							If nPosGan<>0
								nValor:=(Round(xMoeda((SD2->D2_TOTAL-SD2->D2_VALDESC+nVlrTotal),SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1)) * nRatValImp)
								nValRet:=nValor *  nAliq
								aConCmr[nPosGan][2]:=aConCmr[nPosGan][2]+nValor
								aConCmr[nPosGan][3]:=aConCmr[nPosGan][3]+nValRet
							Else
								nValor:=Round(xMoeda((SD2->D2_TOTAL-SD2->D2_DESC+nVlrTotal),SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1)) * nRatValImp
								nValRet:=nValor *(nAliq/100)

								Aadd(aConCmr,{Pad(SD1->D1_CF,len(SFF->FF_CFO)),"CMR",nValor,nValRet,SFF->FF_ALIQ,SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_CLIENTE,SF2->F2_LOJA,,})

						Endif

						// cfo , impostp, base, valor ret
						If (SFF->FF_IMPORTE <  SD2->D2_TOTAL*(SFF->FF_ALIQ   / 100))
							AAdd(aConCmrRat,array(10))
							aConCmrRat[Len(aConCmr)][1] := aConCmr[1][1] //CFO
							aConCmrRat[Len(aConCmr)][2] := aConCmr[1][2] //IMPOSTO
 							aConCmrRat[Len(aConCmr)][3] := Round(xMoeda(nValor,SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1))*nSaldo/SE2->E2_VALOR * nSigno	//FE_VALBASE
							aConCmrRat[Len(aConCmr)][4] := Round(xMoeda(nValRet,SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1))*nSaldo/SE2->E2_VALOR * nSigno	//FE_VALIMP
							aConCmrRat[Len(aConCmr)][5] := aConCmr[1][5]
							aConCmrRat[Len(aConCmr)][6] := aConCmr[1][6]
							aConCmrRat[Len(aConCmr)][7] := aConCmr[1][7]
							aConCmrRat[Len(aConCmr)][8] := aConCmr[1][8]
							aConCmrRat[Len(aConCmr)][9] := aConCmr[1][9]
							aConCmrRat[Len(aConCmr)][10] := 100
						Else
							AAdd(aConCmrRat, {,0,0,0,0,0,0,0,0,0,0})
						Endif
					EndIf
				SD2->(DbSkip())
			Enddo
		Endif
	Endif
Else
	AAdd(aConCmrRat, {,0,0,0,0,0,0,0,0,0,0})
EndIf

If Empty(aConCmrRat)
	AAdd(aConCmrRat, {,0,0,0,0,0,0,0,0,0,0})
Endif

Return aConCmrRat

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CalcRetCPR �Autor  �Marivaldo		     �Fecha � 25/03/13    ���
�������������������������������������������������������������������������͹��
���Desc.     � Calcular e Gerar Retencoes sobre CPR	                      ���
���                           											  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function CalcRetCpr(cAgente,nSigno,nSaldo)

Local nRateio
Local nRatValImp
Local nValMerc
Local nTotOrden
Local nPosGan,cConc
Local nX,nY,nMoeda   := 1
Local aConCpr	:=	{}
Local aConCprRat	:=	{}
Local lCalcGN := .T.
Local nI:=1
Local nVlrTotal:=0
Local aImpInf := {}
Local lCalcula:=.F.
Local nAliqSFH:=0
Local nValRet	:= 0
DEFAULT nSigno	:=	1

//As retencoes sao calculadas com a taxa do d�a e nao com a taxa variavel....
//Bruno.
	If ExistBlock("F0851IMP")
		lCalcGN:=ExecBlock("F0851IMP",.F.,.F.,{"GN"})
	EndIf

DbSelectArea("SFH")
DbSetOrder(1)
If Dbseek(xFilial("SFH")+SE2->E2_FORNECE+SE2->E2_LOJA+"CPR")
  	lCalcula:=.T.
	nAliqSFH:= SFH->FH_ALIQ
EndIf

//+----------------------------------------------------------------+
//� Obter o Valor do Imposto e Base baseando se no rateio do valor �
//� do titulo pelo total da Nota Fiscal.                           �
//+----------------------------------------------------------------+
If lCalcula .and.  !(SE2->E2_TIPO $ MV_CPNEG) .and. A085aVigSFH()
	dbSelectArea("SF1")
	dbSetOrder(1)
		If lMsFil
			dbSeek(SE2->E2_MSFIL+(SE2->E2_NUM)+(SE2->E2_PREFIXO)+(SE2->E2_FORNECE)+SE2->E2_LOJA)
		Else
			dbSeek(xFilial("SF1")+(SE2->E2_NUM)+(SE2->E2_PREFIXO)+(SE2->E2_FORNECE)+SE2->E2_LOJA)
		EndIf
	While Alltrim(SF1->F1_ESPECIE)<>Alltrim(SE2->E2_TIPO).And.!Eof()
		SF1->(DbSkip())
		Loop
	Enddo

	If Alltrim(SF1->F1_ESPECIE)==Alltrim(SE2->E2_TIPO).And.;
		Iif(lMsFil, SF1->F1_MSFIL,xFilial("SF1"))+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA==;
		F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA

		nMoeda      := Max(SF1->F1_MOEDA,1)

		If cPaisLoc<>"ARG"
			nRateio := 1
		else
			nRateio := ( SF1->F1_VALMERC - SF1->F1_DESCONT ) / SF1->F1_VALBRUT
		Endif

		nRatValImp	:= ( Round(xMoeda(nSaldo,SE2->E2_MOEDA,1,,5,aTxMoedas[Max(SE2->E2_MOEDA,1)][2]),MsDecimais(1)) / Round(xMoeda(SF1->F1_VALBRUT,SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1)) )
		nValMerc 	:= ( Round(xMoeda(nSaldo,SE2->E2_MOEDA,1,,5,aTxMoedas[Max(SE2->E2_MOEDA,1)][2]),MsDecimais(1)) * nRateio )
		If SF1->F1_FRETE > 0
			MV_FRETLOC := GetNewPar("MV_FRETLOC","IVA162GAN06")
			cConc   := Alltrim(Subs( MV_FRETLOC, At("N",MV_FRETLOC)+1))
			nPosGan := ASCAN(aConCpr,{|x| x[1]==cConc.And. x[3]==''})
			If nPosGan<>0
				aConCpr[nPosGan][2]:=aConCpr[nPosGan][2]+(Round(xMoeda(SF1->F1_FRETE,SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1))*nRatValimp)
			Else
				Aadd(aConCpr,{cConc,Round(xMoeda(SF1->F1_FRETE,SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1))*nRatValimp,''})
			Endif
		EndIf
		If SF1->F1_DESPESA >  0
			MV_GASTLOC  := GetNewPar("MV_GASTLOC","IVA112GAN06")
			cConc   := Alltrim(Subs( MV_GASTLOC, At("N",MV_GASTLOC)+1))
			nPosGan := ASCAN(aConCpr,{|x| x[1]==cConc.And. x[3]==''})
			If nPosGan<>0
				aConCpr[nPosGan][2]:=aConCpr[nPosGan][2]+Round(xMoeda(SF1->F1_DESPESA,SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1))*nRatValimp
			Else
				Aadd(aConCpr,{cConc,Round(xMoeda(SF1->F1_DESPESA,SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1))*nRatValimp,''})
			Endif
		EndIf

		SD1->(DbSetOrder(1))
			If lMsFil
				SD1->(DbSeek(SF1->F1_MSFIL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
			Else
				SD1->(DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
			EndIf
		If SD1->(Found())
		    Do while Iif(lMsFil, SD1->D1_MSFIL,xFilial("SD1"))==SD1->D1_FILIAL.And.SF1->F1_DOC==SD1->D1_DOC.AND.;
				SF1->F1_SERIE==SD1->D1_SERIE.AND.SF1->F1_FORNECE==SD1->D1_FORNECE;
				.AND.SF1->F1_LOJA==SD1->D1_LOJA.And.!SD1->(EOF())

				IF AllTrim(SD1->D1_ESPECIE)<>AllTrim(SE2->E2_TIPO)
					SD1->(DbSkip())
					Loop
				Endif
					aImpInf := TesImpInf(SD1->D1_TES)
					SFF->(DbSetOrder(5))

					 // Imposto +CFO
					If SFF->(Dbseek(xfilial("SFF")+"CPR"+Pad(SD1->D1_CF,len(SFF->FF_CFO)) )) .and. Round(xMoeda(( SF1->F1_VALMERC - SF1->F1_DESCONT ),SF1->F1_MOEDA,1,,,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1)) > SFF->FF_FXDE

			 			nAliq:= SFF-> FF_ALIQ

			 			If nAliqSFH>0
			 				nAliq:=nAliqSFH
			 			EndIf                            
			 		 	nPosGan:=ASCAN(aConCpr,{|x| x[1]==Pad(SF1->F1_CFO,len(SFF->FF_CFO_C)) })
						If nPosGan <>0
							nValor:=(Round(xMoeda((SD1->D1_TOTAL-SD1->D1_VALDESC+nVlrTotal),SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1)) * nRatValImp)
							nValRet:=nValor *  nAliq
							Aadd(aConCpr,{Pad(SD1->D1_CF,len(SFF->FF_CFO)),"CPR",nValor,nValRet,SFF->FF_ALIQ,SF1->F1_SERIE,SF1->F1_DOC,SF1->F1_FORNECE,SF1->F1_LOJA,,})
							aConCpr[nPosGan][2]:=aConCpr[nPosGan][2]+nValor
							aConCpr[nPosGan][3]:=aConCpr[nPosGan][3]+nValRet
						Else
							nValor:=Round(xMoeda((SD1->D1_TOTAL-SD1->D1_VALDESC+nVlrTotal),SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1)) * nRatValImp
							nValRet:=Round(nValor *(nAliq/100),4)
							Aadd(aConCpr,{Pad(SD1->D1_CF,len(SFF->FF_CFO)),"CPR",nValor,nValRet,nAliq,SF1->F1_SERIE,SF1->F1_DOC,SF1->F1_FORNECE,SF1->F1_LOJA,,})

						EndIf

						// cfo , impostp, base, valor ret
						If (SFF->FF_IMPORTE <  SD1->D1_TOTAL*(SFF->FF_ALIQ   / 100))
					   		AAdd(aConCprRat,array(10))
							aConCprRat[Len(aConCprRat)][1] := aConCpr[1][1] //CFO
							aConCprRat[Len(aConCprRat)][2] := aConCpr[1][2] //IMPOSTO
 							aConCprRat[Len(aConCprRat)][3] := Round(xMoeda(nValor,SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1))*nSaldo/SE2->E2_VALOR * nSigno	//FE_VALBASE
							aConCprRat[Len(aConCprRat)][4] := Round(xMoeda(nValRet,SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),4)*nSaldo/SE2->E2_VALOR * nSigno	//FE_VALIMP
							aConCprRat[Len(aConCprRat)][5] := aConCpr[1][5]
							aConCprRat[Len(aConCprRat)][6] := aConCpr[1][6]
							aConCprRat[Len(aConCprRat)][7] := aConCpr[1][7]
							aConCprRat[Len(aConCprRat)][8] := aConCpr[1][8]
							aConCprRat[Len(aConCprRat)][9] := aConCpr[1][9]
							aConCprRat[Len(aConCprRat)][10] := 100
						Else
							AAdd(aConCprRat, {,0,0,0,0,0,0,0,0,0,0})
						Endif
					EndIf
				SD1->(DbSkip())
			Enddo
		Endif
	Endif
Else

AAdd(aConCprRat, {,0,0,0,0,0,0,0,0,0,0})

Return aConCprRat

EndIf

If Empty(aConCprRat)
	AAdd(aConCprRat, {,0,0,0,0,0,0,0,0,0,0})
EndIf

Return aConCprRat

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CalRetCpr2 �Autor  �Marivaldo		     �Fecha � 25/03/13    ���
�������������������������������������������������������������������������͹��
���Desc.     � Calcular e Gerar Retencoes sobre CPR			              ���
���                           											  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function CalRetCpr2(cAgente,nSigno,nSaldo)

Local nRateio
Local nRatValImp
Local nValMerc
Local nTotOrden
Local nPosGan,cConc
Local nX,nY,nMoeda   := 1
Local aConCpr	:=	{}
Local aConCprRat	:=	{}
Local lCalcGN := .T.
Local nI:=1
Local nVlrTotal:=0
Local aImpInf := {}
Local lCalcula:=.F.
Local nAliqSFH:=0
Local nValRet	:= 0
DEFAULT nSigno	:=	1

//As retencoes sao calculadas com a taxa do d�a e nao com a taxa variavel....
//Bruno.
	If ExistBlock("F0851IMP")
		lCalcGN:=ExecBlock("F0851IMP",.F.,.F.,{"GN"})
	EndIf

DbSelectArea("SFH")
DbSetOrder(1)
If Dbseek(xFilial("SFH")+SE2->E2_FORNECE+SE2->E2_LOJA+"CPR")
  	lCalcula:=.T.
	nAliqSFH:= SFH->FH_ALIQ
EndIf

//+----------------------------------------------------------------+
//� Obter o Valor do Imposto e Base baseando se no rateio do valor �
//� do titulo pelo total da Nota Fiscal.                           �
//+----------------------------------------------------------------+
If lCalcula .and. (SE2->E2_TIPO $ MV_CPNEG).and. A085aVigSFH()
   		DbSelectArea("SF2")
   		DbSetOrder(1)
		If lMsFil
			dbSeek(SE2->E2_MSFIL+(SE2->E2_NUM)+(SE2->E2_PREFIXO)+(SE2->E2_FORNECE)+SE2->E2_LOJA)
		Else
			dbSeek(xFilial("SF2")+(SE2->E2_NUM)+(SE2->E2_PREFIXO)+(SE2->E2_FORNECE)+SE2->E2_LOJA)
		EndIf
	While Alltrim(SF2->F2_ESPECIE)<>Alltrim(SE2->E2_TIPO).And.!Eof()
		SF2->(DbSkip())
		Loop
	Enddo

	If Alltrim(SF2->F2_ESPECIE)==Alltrim(SE2->E2_TIPO).And.;
		Iif(lMsFil, SF2->F2_MSFIL,xFilial("SF2"))+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA==;
		F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA

		nMoeda      := Max(SF2->F2_MOEDA,1)

		If cPaisLoc<>"ARG"
			nRateio := 1
		else
			nRateio := ( SF2->F2_VALMERC - SF2->F2_DESCONT ) / SF2->F2_VALBRUT
		Endif

		nRatValImp	:= ( Round(xMoeda(nSaldo,SE2->E2_MOEDA,1,,5,aTxMoedas[Max(SE2->E2_MOEDA,1)][2]),MsDecimais(1)) / Round(xMoeda(SF2->F2_VALBRUT,SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1)) )
		nValMerc 	:= ( Round(xMoeda(nSaldo,SE2->E2_MOEDA,1,,5,aTxMoedas[Max(SE2->E2_MOEDA,1)][2]),MsDecimais(1)) * nRateio )
		If SF2->F2_FRETE > 0
			MV_FRETLOC := GetNewPar("MV_FRETLOC","IVA162GAN06")
			cConc   := Alltrim(Subs( MV_FRETLOC, At("N",MV_FRETLOC)+1))
			nPosGan := ASCAN(aConCpr,{|x| x[1]==cConc.And. x[3]==''})
			If nPosGan<>0
				aConCpr[nPosGan][2]:=aConCpr[nPosGan][2]+(Round(xMoeda(SF2->F2_FRETE,SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1))*nRatValimp)
			Else
				Aadd(aConCpr,{cConc,Round(xMoeda(SF2->F2_FRETE,SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1))*nRatValimp,''})
			Endif
		EndIf
		If SF2->F2_DESPESA >  0
			MV_GASTLOC  := GetNewPar("MV_GASTLOC","IVA112GAN06")
			cConc   := Alltrim(Subs( MV_GASTLOC, At("N",MV_GASTLOC)+1))
			nPosGan := ASCAN(aConCpr,{|x| x[1]==cConc.And. x[3]==''})
			If nPosGan<>0
				aConCpr[nPosGan][2]:=aConCpr[nPosGan][2]+Round(xMoeda(SF2->F2_DESPESA,SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1))*nRatValimp
			Else
				Aadd(aConCpr,{cConc,Round(xMoeda(SF2->F2_DESPESA,SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1))*nRatValimp,''})
			Endif
		EndIf

		SD2->(DbSetOrder(3))
			If lMsFil
				SD2->(DbSeek(SF2->F2_MSFIL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
			Else
				SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
			EndIf
		If SD2->(Found())
		    Do while Iif(lMsFil, SD2->D2_MSFIL,xFilial("SD2"))==SD2->D2_FILIAL.And.SF2->F2_DOC==SD2->D2_DOC.AND.;
				SF2->F2_SERIE==SD2->D2_SERIE.AND.SF2->F2_CLIENTE==SD2->D2_CLIENTE;
				.AND.SF2->F2_LOJA==SD2->D2_LOJA.And.!SD2->(EOF())

				IF AllTrim(SD2->D2_ESPECIE)<>AllTrim(SE2->E2_TIPO)
					SD2->(DbSkip())
					Loop
				Endif
					aImpInf := TesImpInf(SD2->D2_TES)
					SFF->(DbSetOrder(5))

					 // Imposto +CFO
					If SFF->(Dbseek(xfilial("SFF")+"CPR"+Pad(SD2->D2_CF,len(SFF->FF_CFO)) )) .and. Round(xMoeda(( SF2->F2_VALMERC - SF2->F2_DESCONT ),SF2->F2_MOEDA,1,,,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1)) > SFF->FF_FXDE

			 			nAliq:= SFF-> FF_ALIQ

			 			If nAliqSFH>0
			 				nAliq:=nAliqSFH
			 			EndIf

							If SF1->(FieldPos("F2_CFO"))  > 0
				 				nPosGan:=ASCAN(aConCpr,{|x| x[1]==Pad(SF2->F2_CFO,len(SFF->FF_CFO_C)) })
					 		EndIf
							If nPosGan<>0
								nValor:=(Round(xMoeda((SD2->D2_TOTAL-SD2->D2_VALDESC+nVlrTotal),SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1)) * nRatValImp)
								nValRet:=nValor *  nAliq
								aConCpr[nPosGan][2]:=aConCpr[nPosGan][2]+nValor
								aConCpr[nPosGan][3]:=aConCpr[nPosGan][3]+nValRet
							Else
								nValor:=Round(xMoeda((SD2->D2_TOTAL-SD2->D2_DESC+nVlrTotal),SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1)) * nRatValImp
								nValRet:=nValor *(nAliq/100)

								Aadd(aConCpr,{Pad(SD1->D1_CF,len(SFF->FF_CFO)),"CPR",nValor,nValRet,SFF->FF_ALIQ,SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_CLIENTE,SF2->F2_LOJA,,})

						Endif

						// cfo , impostp, base, valor ret
						If (SFF->FF_IMPORTE <  SD2->D2_TOTAL*(SFF->FF_ALIQ   / 100))
							AAdd(aConCprRat,array(10))
							aConCprRat[Len(aConCpr)][1] := aConCpr[1][1] //CFO
							aConCprRat[Len(aConCpr)][2] := aConCpr[1][2] //IMPOSTO
 							aConCprRat[Len(aConCpr)][3] := Round(xMoeda(nValor,SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1))*nSaldo/SE2->E2_VALOR * nSigno	//FE_VALBASE
							aConCprRat[Len(aConCpr)][4] := Round(xMoeda(nValRet,SF1->F1_MOEDA,1,,5,aTxMoedas[Max(SF1->F1_MOEDA,1)][2]),MsDecimais(1))*nSaldo/SE2->E2_VALOR * nSigno	//FE_VALIMP
							aConCprRat[Len(aConCpr)][5] := aConCpr[1][5]
							aConCprRat[Len(aConCpr)][6] := aConCpr[1][6]
							aConCprRat[Len(aConCpr)][7] := aConCpr[1][7]
							aConCprRat[Len(aConCpr)][8] := aConCpr[1][8]
							aConCprRat[Len(aConCpr)][9] := aConCpr[1][9]
							aConCprRat[Len(aConCpr)][10] := 100
						Else
							AAdd(aConCprRat, {,0,0,0,0,0,0,0,0,0,0})
						Endif
					EndIf
				SD2->(DbSkip())
			Enddo
		Endif
	Endif
Else

AAdd(aConCprRat, {,0,0,0,0,0,0,0,0,0,0})

Return aConCprRat

EndIf

If Empty(aConCprRat)
	AAdd(aConCprRat, {,0,0,0,0,0,0,0,0,0,0})
EndIf

Return aConCprRat

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F085TotGan�Autor  � Pedro Pereira Lima � Data �  08/02/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se o acumulado para o fornecedor ultrapassou o    ���
���          � valor de 10.000.                                           ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function F085TotGan(cTpAcm,cFornece,cLoja,nLimite,nValBase)
Local cAliasQry := GetNextAlias()
Local nTotPer   := 0
Local nTotMes	 := 0
Local nCertif	 := 0
Local aRetGan	 := {0,.F.,.F.}
Local dDataIni	 := ""
Local dDataFim  := ""

If cTpAcm == "3" //Derechos de Autor
	dDataIni := Ctod("01/01/"+Str(Year(dDataBase),4))
	dDataFim := Ctod("31/12/"+Str(Year(dDataBase),4))
ElseIf cTpAcm == "2" //N�o usado para Ganancias
//	dDataIni := FirstDay(dDtRef)
//	dDataFim := LastDay(dDtRef)
ElseIf cTpAcm == "1" //N�o usado para Ganancias
//	dDataIni := Ctod("01/01/"+Str(Year(dDtRef),4))
//	dDataFim := Ctod("31/12/"+Str(Year(dDtRef),4))
Else //N�o usado para Ganancias
//	dDataIni := dDtRef
//	dDataFim := dDtRef
Endif

BeginSQL Alias cAliasQry
	SELECT SUM(SFE.FE_VALBASE) TOTRET FROM %Table:SFE% SFE
		WHERE  SFE.FE_FILIAL = %Exp:xFilial("SFE")%
			AND SFE.FE_FORNECE = %Exp:cFornece%
			AND SFE.FE_LOJA = %Exp:cLoja%
			AND SFE.FE_EMISSAO BETWEEN %Exp:dDataIni% AND %Exp:dDataFim%
			AND SFE.FE_CONCEPT = %Exp:"DA"%
			AND SFE.%NotDel%
EndSQL

If (Empty((cAliasQry)->TOTRET) .And. nValBase <= nLimite) .Or. SA2->A2_TIPO <> "I" //N�o h� registro de movimento ainda
	Return aRetGan
EndIf

nTotPer := (cAliasQry)->TOTRET

(cAliasQry)->(dbCloseArea())

cAliasQry := GetNextAlias()

BeginSQL Alias cAliasQry
	SELECT COUNT(SFE.FE_NROCERT) CERTF FROM %Table:SFE% SFE
		WHERE  SFE.FE_FILIAL = %Exp:xFilial("SFE")%
			AND SFE.FE_FORNECE = %Exp:cFornece%
			AND SFE.FE_LOJA = %Exp:cLoja%
			AND SFE.FE_EMISSAO BETWEEN %Exp:dDataIni% AND %Exp:dDataFim%
			AND SFE.FE_CONCEPT = %Exp:"DA"%
			AND SFE.FE_NROCERT <> %Exp:"NORET"%
			AND SFE.%NotDel%
EndSQL

nCertif := (cAliasQry)->CERTF

(cAliasQry)->(dbCloseArea())

cAliasQry := GetNextAlias()

Do Case
	Case Month(dDataBase) == 1
		dDataIni := CtoD("01/01/"+Str(Year(dDataBase),4))
		dDataFim := CtoD("31/01/"+Str(Year(dDataBase),4))
	Case Month(dDataBase) == 2
		dDataIni := CtoD("01/02/"+Str(Year(dDataBase),4))
		dDataFim := IIf(Empty(CtoD("29/02/"+Str(Year(dDataBase),4))),CtoD("28/02/"+Str(Year(dDataBase),4)),CtoD("29/02/"+Str(Year(dDataBase),4)))
	Case Month(dDataBase) == 3
		dDataIni := CtoD("01/03/"+Str(Year(dDataBase),4))
		dDataFim := CtoD("31/03/"+Str(Year(dDataBase),4))
	Case Month(dDataBase) == 4
		dDataIni := CtoD("01/04/"+Str(Year(dDataBase),4))
		dDataFim := CtoD("30/04/"+Str(Year(dDataBase),4))
	Case Month(dDataBase) == 5
		dDataIni := CtoD("01/05/"+Str(Year(dDataBase),4))
		dDataFim := CtoD("31/05/"+Str(Year(dDataBase),4))
	Case Month(dDataBase) == 6
		dDataIni := CtoD("01/06/"+Str(Year(dDataBase),4))
		dDataFim := CtoD("30/06/"+Str(Year(dDataBase),4))
	Case Month(dDataBase) == 7
		dDataIni := CtoD("01/07/"+Str(Year(dDataBase),4))
		dDataFim := CtoD("31/07/"+Str(Year(dDataBase),4))
	Case Month(dDataBase) == 8
		dDataIni := CtoD("01/08/"+Str(Year(dDataBase),4))
		dDataFim := CtoD("31/08/"+Str(Year(dDataBase),4))
	Case Month(dDataBase) == 9
		dDataIni := CtoD("01/09/"+Str(Year(dDataBase),4))
		dDataFim := CtoD("30/09/"+Str(Year(dDataBase),4))
	Case Month(dDataBase) == 10
		dDataIni := CtoD("01/10/"+Str(Year(dDataBase),4))
		dDataFim := CtoD("31/10/"+Str(Year(dDataBase),4))
	Case Month(dDataBase) == 11
		dDataIni := CtoD("01/11/"+Str(Year(dDataBase),4))
		dDataFim := CtoD("30/11/"+Str(Year(dDataBase),4))
	Case Month(dDataBase) == 12
		dDataIni := CtoD("01/12/"+Str(Year(dDataBase),4))
		dDataFim := CtoD("31/12/"+Str(Year(dDataBase),4))
EndCase

BeginSQL Alias cAliasQry
	SELECT SUM(SFE.FE_VALBASE) VALBASE FROM %Table:SFE% SFE
		WHERE  SFE.FE_FILIAL = %Exp:xFilial("SFE")%
			AND SFE.FE_FORNECE = %Exp:cFornece%
			AND SFE.FE_LOJA = %Exp:cLoja%
			AND SFE.FE_EMISSAO BETWEEN %Exp:dDataIni% AND %Exp:dDataFim%
			AND SFE.FE_CONCEPT = %Exp:"DA"%
			AND SFE.%NotDel%
EndSQL

nTotMes := (cAliasQry)->VALBASE

If nCertif == 0 //N�o foi feita nenhuma retencao (FE_NROCERT <> 'NORET')
	If (nTotPer + nValBase) > nLimite
		aRetGan[1] := (nValBase + nTotPer) - nLimite	//Valor para reten��o j� descontando o limite
		aRetGan[2] := .T.
		aRetGan[3] := .T.
	EndIf
Else
	aRetGan[1] := nValBase + nTotMes	//Valor para reten��o j� descontando o limite
	aRetGan[2] := .T.
	aRetGan[3] := .F.
EndIf

(cAliasQry)->(dbCloseArea())

Return aRetGan

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Fa085aNFRA�Autor  �Laura Medina        � Data �  11/10/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Caso a natureza do titulo seja de adiantamento ED_OPERADT=1���
���          � gera o titulo do tipo RA (E2_TIPODOC) com base no titulo   ���
���          � de adiantamento.                                           ���
���          � Se realizo sin IGV el PA                                   ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAFIN - PERU                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Fa085aNFRA(nValBaixa,nValCzBai)
Local cDocPA		:= Substr(MVPAGANT,1,3) //"PA" para Peru
Local cParcSE2		:= CriaVar("E2_PARCELA",.T.)
Local aSaveArea		:= GetArea()
Local aSaveSE2		:= SE2->(GetArea())
Local aSaveSEK		:= SEK->(GetArea())

Default nValBaixa	:= 0

If SE2->(!EOF())

	RegToMemory("SE2",.F.) //Carrega o titulo base na mem�ria

	//�������������������������������������������������������Ŀ
	//� Caso o titulo do tipo RA ja exista (processo de baixa �
	// �parcial) o campo E2_PARCELA eh incrementado.          �
	//���������������������������������������������������������
	SE2->(DbSetOrder(1)) //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
	While  SE2->(DbSeek(XFilial("SE2")+M->E2_PREFIXO+M->E2_NUM+cParcSE2+cDocPA))
		cParcSE2 := Soma1(cParcSE2)
	SE2->(DbSkip())
	EndDo

	//�������������������������������������������������������Ŀ
	//� Gera o novo titulo do tipo RA                         �
	//� O conceito de criacao eh semelhante ao gerado na NCC. �
	//���������������������������������������������������������
	RecLock("SE2",.T.) 
	SE2->E2_FILIAL   	:= XFilial("SE2")
	SE2->E2_PREFIXO  	:= M->E2_PREFIXO
	SE2->E2_NUM			:= M->E2_NUM
	SE2->E2_PARCELA		:= cParcSE2
	SE2->E2_TIPO     	:= cDocPA
	SE2->E2_EMISSAO  	:= dDataRef
	SE2->E2_EMIS1    	:= CtoD("")
	SE2->E2_VENCTO  	:= dDataRef
	SE2->E2_VENCREA 	:= DataValida(dDataRef)   
	SE2->E2_EMISSAO  	:= dDataRef   
	SE2->E2_VENCORI 	:= DataValida(dDataRef) 
	SE2->E2_NATUREZ  	:= M->E2_NATUREZ
	SE2->E2_MOEDA   	:= M->E2_MOEDA
	SE2->E2_VLCRUZ		:= nValCzBai
	SE2->E2_VALOR   	:= nValBaixa
	SE2->E2_SALDO   	:= nValBaixa - M->E2_VALIMP1 //Subtrai o valor referente ao IVA para compensacao no faturamento
	SE2->E2_FORNECE 	:= cProveedor
	SE2->E2_LOJA    	:= cLoja
	SE2->E2_ORDPAGO     := cOrdPago
	SE2->E2_NOMFOR   	:= SA2->A2_NOME
	SE2->E2_SITUACA  	:= "0"
	SE2->E2_ORIGEM   	:= "FINA085A"
	SE2->E2_LA       	:= "S"
	SE2->E2_STATUS   	:= "A"
	SE2->E2_TXMOEDA		:= M->E2_TXMOEDA
	Iif(SE2->(FieldPos("E2_CGC"))>0, SE2->E2_CGC := SA2->A2_CGC,Nil)
	SE2->(MsUnlock())

	//�����������������������������������������Ŀ
	//� Gera la OP del titulo PA generado arriba�
	//�������������������������������������������
	RecLock("SEK",.T.)
	EK_FILIAL   := XFilial("SEK")
	EK_TIPODOC  := cDocPA
	EK_PREFIXO  := SE2->E2_PREFIXO
	EK_NUM      := SE2->E2_NUM
	EK_PARCEKA  := SE2->E2_PARCELA
	EK_TIPO   	:= "PA"
	EK_EMISSAO  := dDataRef
	EK_DTDIGIT  := dDataBase
	EK_DTVCTO   := dDataRef
	EK_NATUREZ  := SE2->E2_NATUREZ
	EK_MOEDA    := StrZero(SE2->E2_MOEDA,2)
    EK_DESCONT  := SE2->E2_DESCONT
	EK_VLMOED1 	:= Round(nValCzBai, MsDecimais(1))
	EK_VALOR    := nValBaixa
	EK_FORNECE 	:= cProveedor
	EK_LOJA	 	:= cLoja
	EK_ORDPAGO 	:= cOrdPago
	EK_FORNEPG	:= cProveedor
	EK_LOJAPG	:= cLoja
	SEK->(MsUnlock())

EndIf

RestArea(aSaveSEK)
RestArea(aSaveSE2)
RestArea(aSaveArea)

Return Nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ObtDesgl �Autor  �Laura Medina        � Data �  21/01/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcion para obtener el desgloce de las alicuotas que      ���
���          � existan para la provincia que se esta procesando.          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAFIN - PERU                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ObtDesgl(cImpsto,cCodC,cZona,cTipo,cCodAdc,nAliqAdc)  
Local cTabTemp:= criatrab(nil,.F.)     
Local nNumRegs:= 0 
Local lRet    := .F. 
Local cQuery  := ""

cQuery := "SELECT * "
cQuery += "FROM " + RetSqlName("SFF")+ " SFF "
cQuery += "WHERE FF_TIPO ='"+ cTipo +"' AND "
cQuery += "FF_CFO_C   ='" + cCodAdc + "' AND "
cQuery += "FF_IMPOSTO ='" + cImpsto +"' AND "
cquery += "FF_ZONFIS  ='" + cZona +"' AND "
cQuery += "FF_FILIAL='" +XFILIAL("SFF") + "' AND "
cQuery += "D_E_L_E_T_<>'*'"

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTabTemp,.T.,.T.)

Count to nNumRegs

If  nNumRegs > 0	//Verificar que exista un registro adicional
	(cTabTemp)->(dbGoTop())
	If (cTabTemp)->(!eof())
		nAliqAdc:= (cTabTemp)->FF_ALIQ  
		lRet    := .T.
	Endif   
Endif 

Return lRet    

/*/
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FRetMiib �Autor  �	Bruno Schmidt     � Data �  10/02/14  ���
�������������������������������������������������������������������������͹��
���Desc.     � Projeto Em Implanta��o									  ���
���          � 															  ���
���          � 					                                          ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAFIN                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������
/*/
Static Function FRetMiib(aSE2,nA,nC,nP,lFRetMiib)
Local cCOTPMINRE := ""
Local aDup	    := {}
Local nW			:=0
Local nZ			:=0
Local nY			:=0

For nZ :=	1	To	Len(aSE2[nA][1])	
	If !Empty(aSE2[nA][1][nz][15])
			For nW	:=	1	To	Len(aSE2[nA][1][nz][15])
				CCO->(dbSeek(xFilial()+aSE2[nA][1][nz][15][nW][9]))
				cCOTPMINRE:= CCO->CO_TPMINRE
				cCOMMINRE := CCO->CO_IMMINRE
				
				If !Empty(aDup)//nPosProv > 0 .and. nPosTES > 0 
					If cCOTPMINRE = '1'
						aDup[1][1] += aSE2[nA][1][nZ][15][nW][3] // Base Valor(Fixo por que n�o utilzia separa��o por TES aDup[nPosTES][1])
						aDup[1][6] += aSE2[nA][1][nZ][15][nW][5]
					Else
						aDup[1][1] += aSE2[nA][1][nZ][15][nW][5]  // Valor Reais(Fixo por que n�o utilzia separa��o por TES aDup[nPosTES][1])
					EndIf		
				Else
					AAdd(aDup,{"","","","","",""})
					If cCOTPMINRE = '1'
						aDup[nW][1] := aSE2[nA][1][nZ][15][nW][3] //Base Valor
						aDup[nW][2] := aSE2[nA][1][nZ][15][nW][11]//TES
						aDup[nW][3] := aSE2[nA][1][nZ][15][nW][9] //Provincia
						aDup[nW][4] := cCOTPMINRE				  //Tipo
						aDup[nW][5] := cCOMMINRE			      //Valor
						aDup[nW][6] := aSE2[nA][1][nZ][15][nW][5]
						
					Else
						aDup[nW][1] := aSE2[nA][1][nZ][15][nW][5] //Valor Reais
						aDup[nW][2] := aSE2[nA][1][nZ][15][nW][11]//TES
						aDup[nW][3] := aSE2[nA][1][nZ][15][nW][9] //Provincia
						aDup[nW][4] := cCOTPMINRE				  //Tipo
						aDup[nW][5] := cCOMMINRE			      //Valor
					EndIf		
				EndIf	
			Next nW
			nW := 0
	EndIf
Next nZ
	
If aDup[1][4] = '1'
	IF aDup[1][1] < aDup[1][5]
		aDup[1][1]:= 0
	Else
		aDup[1][1]:= aDup[1][6]
	EndIf
Else
	IF aDup[1][1] < aDup[1][5]
		aDup[1][1]:= 0
	EndIf
ENdIF	

lFRetMiib:= .T.
	
Return Round(xMoeda(aDup[1][1],1,nMoedaCor,,5,,aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � A085aVigSA2 � Autor � Emanuel Villica�a� Data �  12/02/14  ���
�������������������������������������������������������������������������͹��
���Descricao � Validacion de periodo de SA2 para obtener el Porcentaje de ���
���          � Exenci�n de Percepci�n y Retenci�n del IVA 		          ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function A085aVigSA2( dData )

Local lRet := .F.

Default dData := dDataBase

If dData >= SA2->A2_IVPDCOB
	lRet := .T.
EndIf

If lRet .And. !Empty( SA2->A2_IVPCCOB )
	lRet := ( dData <= SA2->A2_IVPCCOB )
EndIf

Return lRet

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fVerifImp   � Autor � Emanuel Villica�a� Data �  11/03/14  ���
�������������������������������������������������������������������������͹��
���Descricao � Obtiene el impuesto del Anticipo en cuentas por pagar      ���
�������������������������������������������������������������������������͹��
���Uso       � FINA085A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//obtiene el impuesto del Anticipo en cuentas por pagar
Static function fVerifImp(cNum,cPrefix,cParcela,cTipo,cFornc,cLoja)
	Local aArea			:= GetArea()
	Local cNumVali		:= ""
	Local nValor		:= 0
	Local cImpAdi		:= ""
	Local cTESD2		:= ""

	DBSelectArea("SD1")
	SD1->(DBSetOrder(1)) //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM                                                                                                     
	If SD1->(DBSeek(xFilial("SD1") + cNum + cPrefix + cFornc + cLoja,.F.))
		cTESD2 := &("SD1->D1_TES")
	EndIf

	DbSelectArea("SFC")
	SFC->(DBSetOrder(2)) //FC_FILIAL + FC_TES + FC_IMPOSTO
	If SFC->(DBSeek(xFilial("SFC") + cTESD2))
		cImpAdi:= &("SFC->FC_IMPOSTO")
		cNumVali := POSICIONE("SFB",1,xFilial("SFB") + PADR(cImpAdi,TamSx3("FB_CODIGO")[1]) ,"FB_CPOLVRO")
    EndIf

	If !Empty(cNum) .and. !Empty(cNumVali)
		DBSelectArea("SF1")
		SF1->(DBSetOrder(1)) //F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
		If SF1->(DBSeek(xFilial("SF1") + cNum + cPrefix + cFornc + cLoja))
			nValor := &("SF1->F1_VALIMP" + cNumVali)
		EndIf
	EndIf		
	RestArea(aArea)	
Return  nValor

//obtiene el concecutivo para la E2_PARCELA
Static Function fRetParcel(cPrefix,cNum,cTipo,cFornc, cLoja)

	Local cTempF := CriaTrab(Nil, .F.)
	Local cQuery := ''
	Local cParcSE2 := ''
	
	cQuery := "SELECT E2_PARCELA FROM " +  RetSqlName("SE2")+" WHERE  E2_PREFIXO='" +  cPrefix + "' AND " 
	cQuery += " E2_NUM ='" + cNum + "' AND E2_TIPO='"+ cTipo +"' AND E2_FORNECE='"+cFornc+"' AND E2_LOJA ='"+cLoja+"'   AND "
	cQuery += "D_E_L_E_T_ = '' AND E2_FILIAL = '"+xFilial("SE2")+"' ORDER BY E2_PARCELA desc "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTempF,.T.,.T.)
	(cTempF)->(dbGoTop())
	While (!(cTempF)->(EOF()))
    	cParcSE2 := Soma1((cTempF)->E2_PARCELA)
    	 Exit
	EndDo
	if (EMPTY(cParcSE2),cParcSE2:= '1',)
	(cTempF)->(dbCloseArea())

Return cParcSE2

/*
���Fun��o    � CalcRetIR� Autor �  				       � Data �   	���
���Descri��o � Calcular e Gerar Retencoes de IR .                     ���
���Uso       � FINA085A                                               ���
*/ 

Static Function CalcRetIR2(cAgente,nSigno,nSaldo)
Local nValBrut := 0
Local aSFEIR := {}
Local lCalcula	:=.F.
Local aArea:=GetArea()    
Local nTotIR := 0
Local nValIR := 0 
Local nTotBase := 0
Local nBaseIR := 0
Local nAliqIR := 0
Local nI
DEFAULT nSigno := 1



If cPaisLoc == "PAR"
			dbSelectArea("SF2")
			dbSetOrder(1)
			dbSeek(xFilial("SF2")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA)
		  	 
		  	dbSelectArea("SD2")
	   		SD2->(DbSetOrder(1))
		 	SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
		   	Do while xFilial("SD2")==SD2->D2_FILIAL.And.SF2->F2_DOC==SD2->D2_DOC.AND.;
					SF2->F2_SERIE==SD2->D2_SERIE.AND.SF2->F2_FORNECE==SD2->D2_CLIENTE;
					.AND.SF2->F2_LOJA==SD2->D2_LOJA.AND.!SD2->(EOF())
			 		aImpInf := TesImpInf(SD2->D2_TES)   
					For nI := 1 To Len(aImpInf) 
						If "RIR"$Trim(aImpInf[nI][01]) .Or. "R15"$Trim(aImpInf[nI][01])			 
							nValIR:=SD2->(FieldGet(FieldPos(aImpInf[nI][02]))) 
							nBaseIR:=SD2->(FieldGet(FieldPos(aImpInf[nI][07]))) 
							nAliqIR := SD2->(FieldGet(FieldPos(aImpInf[nI][10]))) 
							nTotIR += nValIR                               
							nTotBase += nBaseIR 

							
						Endif	
					Next                                   
			 SD2->(DbSkip())	
			Enddo		
			nProp := Round(xMoeda(nSaldo,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,5)/xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,1,,5),3)
			nTotBase	:=	nTotBase * nProp
			nTotImpIR		:=	nTotIR * nProp
			
		
			
			If AllTrim(SF2->F2_ESPECIE)==Alltrim(SE2->E2_TIPO).And.;
				xFilial("SF2")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA==;
				SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA   
	
				AAdd(aSFEIR,array(9))
				aSFEIR[Len(aSFEIR)][1] := SF2->F2_DOC         		//FE_NFISCAL
				aSFEIR[Len(aSFEIR)][2] := SF2->F2_SERIE       		//FE_SERIE
				aSFEIR[Len(aSFEIR)][3] := Round(xMoeda(nTotBase,SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1))* nSigno	//FE_VALBASE
				aSFEIR[Len(aSFEIR)][4] := Round(xMoeda(nTotImpIR,SF2->F2_MOEDA,1,,5,aTxMoedas[Max(SF2->F2_MOEDA,1)][2]),MsDecimais(1))* nSigno	//FE_VALIMP
				aSFEIR[Len(aSFEIR)][5] := SA2->A2_PORIVA
				aSFEIR[Len(aSFEIR)][6] := aSFEIR[Len(aSFEIR)][4]
				aSFEIR[Len(aSFEIR)][7] := SE2->E2_VALOR
				aSFEIR[Len(aSFEIR)][8] := SE2->E2_EMISSAO   
				aSFEIR[Len(aSFEIR)][9] := nAliqIR
			EndIf
		
EndIf		
RestArea(aArea)	

Return aSFEIR

/*
���Programa  � F085GravTX  � Autor � TOTVS            � Data �  13/05/14  ���
���Descricao � Fun��o para gravar a reten��o do IR para Paraguai          ���
���Uso       � FINA085A                                                   ���
*/

Function F085GravTX(aRets,nMoedaRet,aPagos,cOrdPago,cFornece,cLoja)
Local nRetIva := 0 
Local nRetIR := 0
Local nj       
Local cLojaImp  := PadR( "00", TamSX3( "A2_LOJA" )[1], "0" )
Local nParcela := PadR( "0", TamSX3( "E2_PARCELA" )[1], "" )
Local lCertIVA    := ExistBlock("F085CERTIVA")
Local lCertImp    := ExistBlock("FA085CERT")
Local cPrefixo	  := "" 
Local nX := 1

For nj := 1 to Len( aRets[1]) 

	If cPaisLoc =="PAR" 
		If  Len(aRets[1][nj][_RETIVA]) > 0 .And. aRets[1][nj][_RETIVA][1][6] != 0
			nRetIva+=Round(xMoeda(aRets[1][nj][_RETIVA][1][4],1,nMoedaRet,,3,,aTxMoedas[nMoedaRet][2]),MsDecimais(nMoedaRet))
		EndIf
		If Len(aRets[1][nj][_RETIR]) > 0 .And. aRets[1][nj][_RETIR][1][6] != 0
			nRetIR+=Round(xMoeda(aRets[1][nj][_RETIR][1][4],1,nMoedaRet,,3,,aTxMoedas[nMoedaRet][2]),MsDecimais(nMoedaRet))     
		EndIf
	Else
		If Len(aRets[1][nj][14]) > 0 .And. aRets[1][nj][_RETIVA][1][6] != 0
			nRetIva+=Round(xMoeda(aRets[1][nj][_RETIVA][1][6],1,nMoedaRet,,3,,aTxMoedas[nMoedaRet][2]),MsDecimais(nMoedaRet))
		EndIf 
	
		If Len(aRets[1][nj][_RETIR]) > 0 .And. aRets[1][nj][_RETIR][1][6] != 0
			nRetIR+=Round(xMoeda(aRets[1][nj][_RETIR][1][6],1,nMoedaRet,,3,,aTxMoedas[nMoedaRet][2]),MsDecimais(nMoedaRet))
		EndIf
	EndIf	
	
Next nj

SA2->(DbSetOrder(1))
SA2->(DbSeek(xFilial("SA2")+cFornece+ cLoja) )

If SA2->A2_PAIS <> "586" .And. !Empty(SA2->A2_PAIS) 
	cPrefixo:= "EXT" // Fornecedor do tipo exterior
ElseIf (Subs(cAgente,1,1) == "E") 
	cPrefixo:="EXP"  // Agente Exportador
ElseIf (Subs(cAgente,1,1) == "D") 	 
	cPrefixo:="DES"  // Agente Designado
EndIf

	//� Cria o fornecedor, caso nao exista			  �
	aAreaSA2:=GetArea()
	dbSelectArea("SA2")
	If !(dbSeek(cFilial+GetMV("MV_UNIAO")))
		Reclock("SA2",.T.)
		Replace A2_FILIAL With cFilial
		Replace A2_COD   With GetMV("MV_UNIAO")
		Replace A2_NOME	With OemToAnsi(STR0219)  // "UNIAO"
		Replace A2_NREDUZ With OemToAnsi(STR0219)  // "UNIAO"
		Replace A2_LOJA	With cLojaImp
		Replace A2_MUN 	With "."
		Replace A2_EST 	With SuperGetMv("MV_DEPART")
		Replace A2_BAIRRO With "."
		Replace A2_END 	With "."
		Replace A2_TIPO	With "J"
		RestArea(aAreaSA2)
	EndIf
If nRetIva  > 0 	// Grava��o do titulo de reten��o de IVA no SE2 como titulo em aberto            	  
	nParcela		:= Soma1(nParcela)
	RecLock("SE2",.T.)
	SE2->E2_FILIAL 	:= xFilial("SE2")
	SE2->E2_NUM		:= cOrdPago
 	SE2->E2_PARCELA := nParcela
	SE2->E2_EMISSAO	:= dDataBase
	SE2->E2_VENCTO 	:= F085GeraVenc()
	SE2->E2_VENCREA	:= DataValida(SE2->E2_VENCTO)
	SE2->E2_VALOR	:= nRetIva
	SE2->E2_SALDO	:= nRetIva
	SE2->E2_NATUREZ	:= SA2->A2_NATUREZ
	SE2->E2_TIPO	:= "TX"
	SE2->E2_NOMFOR  := OemToAnsi(STR0219)
	SE2->E2_PREFIXO	:= cPrefixo
	SE2->E2_FORNECE := GetMv("MV_UNIAO")
	SE2->E2_LOJA	:= cLojaImp
	SE2->E2_EMIS1	:= dDataBase
	SE2->E2_VLCRUZ 	:= Round(xMoeda(aPagos[nX][H_TOTALVL],1,nMoedaRet,,3,,aTxMoedas[nMoedaRet][2]),MsDecimais(nMoedaRet))   
	SE2->E2_MOEDA	:= nMoedaRet 
	SE2->E2_ORDPAGO := cOrdPago
	SE2->E2_HIST	:= "Ret. IVA"	
	SE2->E2_ORIGEM	:= "FINA085A"	
	
	MsUnLock() 
EndIf
If nRetIR  > 0 	// Grava��o do titulo de reten��o de IR no SE2 como titulo em aberto            	  
	nParcela		:= Soma1(nParcela)
	RecLock("SE2",.T.)
	SE2->E2_FILIAL 	:= xFilial("SE2")
	SE2->E2_NUM		:= cOrdPago   
 	SE2->E2_PARCELA := nParcela
	SE2->E2_EMISSAO	:= dDataBase
	SE2->E2_VENCTO 	:= F085GeraVenc(cPrefixo,"R")
	SE2->E2_VENCREA	:= DataValida(SE2->E2_VENCTO)
	SE2->E2_VALOR	:= nRetIR
	SE2->E2_SALDO	:= nRetIR
	SE2->E2_NATUREZ	:= SA2->A2_NATUREZ
	SE2->E2_TIPO	:= "TX"
	SE2->E2_NOMFOR  := OemToAnsi(STR0219)
	SE2->E2_PREFIXO	:= cPrefixo
	SE2->E2_FORNECE := GetMv("MV_UNIAO")
	SE2->E2_LOJA	:= cLojaImp
	SE2->E2_EMIS1	:= dDataBase
	SE2->E2_VLCRUZ 	:= Round(xMoeda(nRetIR,1,nMoedaRet,,3,,aTxMoedas[nMoedaRet][2]),MsDecimais(nMoedaRet))   
	SE2->E2_MOEDA	:= nMoedaRet 
	SE2->E2_ORDPAGO := cOrdPago 
	SE2->E2_HIST	:= "Ret. Impuesto de Renta"     
	SE2->E2_ORIGEM	:= "FINA085A"	
	MsUnLock()
EndIf	 

IF lCertIVA .And. !lCertImp .And. Len(aCert) > 0
	ExecBlock("F085CERTIVA",.F.,.F.,{aCert})
EndIf

Return

/*/{Protheus.doc} a085VldDsc
Calcula el valor del porcentaje global por porcentaje o por valor.
@type function
@author oscar.lopez
@since 29/05/2020
@version 1.0
@param nOpc, numerico, Descuento por porcentaje o por valor  
@param oPorDesc, objeto, Objeto visual con el porcentaje de decuento
@param nPorDesc, numerico, Porcentaje de descuento
@param oValDesc, objeto, Objeto visual con el valor de decuento
@param nValDesc, numerico, Valor de descuento
@param nValBrut, numerico, Valor bruto de los t�tulos
@param nValLiq, numerico, Valor a pagar por los titulos
@param oValLiq, objeto, Objeto visual con el valor a pagar por los titulos
@param aDescontos, array, Array con el valor de descuentos para cada titulo
@param bZeraRets, bloque, Bloque de codigo para retenciones
@param oGetDad1, objeto, Objeto con el detalle de los t�tulos a pagar
@param bRecalc, bloque, Bloque de codigo para recalculo de valores de titulos
@param nValAdic, numerico, Valor adicional al valor a liquidar
@return lRet, Falso si no se cumple alguna validacion antes de calculo de descuentos
@example
a085VldDsc(nOpc,oPorDesc,nPorDesc,oValDesc,@nValDesc,nValBrut,@nValLiq,oValLiq,@aDescontos,bZeraRets,@oGetDad1,bRecalc,nValAdic) 
@see (links_or_references)
/*/
Static Function a085VldDsc(nOpc,oPorDesc,nPorDesc,oValDesc,nValDesc,nValBrut,nValLiq,oValLiq,aDescontos,bZeraRets,oGetDad1,bRecalc,nValAdic)
	Local nPosTipE2	:= Ascan(aHeader,{ |x| Alltrim(x[2])=="E2_TIPO"})
	Local nPosMoeE2	:= Ascan(aHeader,{ |x| Alltrim(x[2])=="E2_MOEDA"})
	Local nPosPagE2	:= Ascan(aHeader,{ |x| Alltrim(x[2])=="E2_PAGAR"})
	Local nPosJurE2	:= Ascan(aHeader,{ |x| Alltrim(x[2])=="E2_JUROS"})
	Local nPosMulE2	:= Ascan(aHeader,{ |x| Alltrim(x[2])=="E2_MULTA"})
	Local nPosPagMo	:= Ascan(aHeader,{ |x| Alltrim(x[2])=="NVLMDINF"})
	Local lRet		:= .T.
	Local nX		:= 0
	Local nValOri	:= 0
	Local nTotal	:= 0
	Local nTotDes	:= 0
	
	DEFAULT nValAdic	:=	0
	
	If nOpc ==	2
		lModi := .F.
		If nValDesc >= nValBrut
			lRet	:=	.F.
			Help("",1,"No 100 %")
		Endif
	Else
		lModi = .T.
	EndIf
	
	If lRet
		If nOpc ==	2
			For nX:=1	To	Len(aCols)
				nValOri	:=	aCols[nX][nPosPagE2]+aCols[nX][nPosDesc]
				nTotal += Round(xMoeda(nValOri,aCols[nX][nPosMoeE2],nMoedaCor,,nDecs+2,aTxMoedas[aCols[nX][nPosMoeE2]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			Next nX
			nPorDesc :=	(nValDesc * 100 ) / nTotal
		Else
			nValDesc := 0
		EndIf
		
		For nX:=1	To	Len(aCols)
			nValOri	:=	aCols[nX][nPosPagE2]+aCols[nX][nPosDesc]
			aCols[nX][nPosPagMo] := Round(xMoeda(nValOri,aCols[nX][nPosMoeE2],nMoedaCor,,nDecs+1,aTxMoedas[aCols[nX][nPosMoeE2]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			If !aCols[nX][Len(aCols[nX])]  .And. !(aCols[nX][nPosTipE2] $ MVPAGANT+"/"+MV_CPNEG)
				If nMoedaCor<>aCols[nX][nPosMoeE2]
					nTotDes := xMoeda((aCols[nX][nPosPagMo]*(nPorDesc /100)),nMoedaCor,aCols[nX][nPosMoeE2],,nDecs+2,aTxMoedas[nMoedaCor][2],aTxMoedas[aCols[nX][nPosMoeE2]][2])
				Else
					nTotDes := nValOri * (nPorDesc /100)
				EndIf
				aDescontos[nX] := nTotDes
			EndIf

			aCols[nX][nPosDesc] := aDescontos[nX]
			aCols[nX][nPosPagE2] := nValOri - aCols[nX][nPosDesc]

			If nOpc <> 2
				nValDesc += Round(xMoeda(aDescontos[nX],aCols[nX][nPosMoeE2],nMoedaCor,,nDecs+1,aTxMoedas[aCols[nX][nPosMoeE2]][2],aTxMoedas[nMoedaCor][2]),MsDecimais(nMoedaCor))
			EndIf
		Next

		nValLiq := 0
		AEval(aCols,{|x,y|,Iif(aCols[y][nPosTipE2] $ MV_CPNEG+"/"+MVPAGANT,nValLiq -= xMoeda(aCols[y][nPosPagE2],aCols[y][nPosMoeE2],nMoedaCor,,nDecs+2,aTxMoedas[aCols[y][nPosMoeE2]][2],aTxMoedas[nMoedaCor][2]),nValLiq += xMoeda(aCols[y][nPosPagE2],aCols[y][nPosMoeE2],nMoedaCor,,nDecs+2,aTxMoedas[aCols[y][nPosMoeE2]][2],aTxMoedas[nMoedaCor][2]))})
		nValLiq	+= nValAdic
		nValLiq := Round(nValLiq,nDecs)
		If nOpc <> 2
			oPorDesc:Refresh()
		EndIf
		oValLiq:Refresh()
		oValDesc:Refresh()
		oGetDad1:Refresh()
	EndIf
	
	nPrDscAux := nPorDesc
	nVlDscAux := nValDesc
	lRetenc	:=	.F.
Return lRet
