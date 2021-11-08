#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/	11/99

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ   
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MOT001    ºJorge Luis Cardona Alzate   º Data ³  28/01/014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para impressão da factura de venta.               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#IFNDEF WINDOWS
	#DEFINE PSAY SAY                
#ENDIF

User Function MOTR001()        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    


SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M,Nat,cConhec, cCodTransp, 	xQTD_TRANSP, xEMS_TRANSP")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3, xInscr_Est,tes")
SetPrvt("CNATUREZA,ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA")
SetPrvt("NLIN,WNREL,NTAMNF,CSTRING,CPEDANT,NLININI,xRedespacho,xPedCli")
SetPrvt("XNUM_NF,XSERIE,XEMISSAO,XTOT_FAT,XLOJA,XFRETE")
SetPrvt("XSEGURO,XBASE_IPI,XVALOR_ICMS,XICMS_RET,XVALOR_IPI")
SetPrvt("XVALOR_MERC,XNUM_DUPLIC,XCOND_PAG,XPBRUTO,XPLIQUI,XTIPO")
SetPrvt("XESPECIE,XVOLUME,CPEDATU,CITEMATU,XPED_VEND,XITEM_PED")
SetPrvt("XNUM_NFDV,XPREF_DV,XICMS,XCOD_PRO,XQTD_PRO,XPRE_UNI,xDoc2")
SetPrvt("XPRE_TAB,XIPI,XVAL_IPI,XDESC,XVAL_DESC,XVAL_MERC")
SetPrvt("XTES,XCF,XICMSOL,XICM_PROD,XPESO_PRO,XPESO_UNIT")
SetPrvt("XDESCRICAO,XUNID_PRO,XCOD_TRIB,XMEN_TRIB,XCOD_FIS,XCLAS_FIS")
SetPrvt("XMEN_POS,XISS,XTIPO_PRO,XLUCRO,XCLFISCAL,XPESO_LIQ")
SetPrvt("I,NPELEM,_CLASFIS,NPTESTE,XPESO_LIQUID,XPED")
SetPrvt("XPESO_BRUTO,XP_LIQ_PED,XCLIENTE,XTIPO_CLI,XCOD_MENS,XMENSAGEM")
SetPrvt("XTPFRETE,XCONDPAG,XCOD_VEND,XDESC_NF,XDESC_PAG,XOBS,XPED_CLI")
SetPrvt("XDESC_PRO,J,XCOD_CLI,XNOME_CLI,XEND_CLI,XBAIRRO")
SetPrvt("XCEP_CLI,XCOB_CLI,XREC_CLI,XMUN_CLI,XEST_CLI,XCGC_CLI")
SetPrvt("XINSC_CLI,XTRAN_CLI,XTEL_CLI,XFAX_CLI,XSUFRAMA,XCALCSUF")
SetPrvt("ZFRANCA,XVENDEDOR,XBSICMRET,XNOME_TRANSP,XEND_TRANSP,XOBS,XMUN_TRANSP")
SetPrvt("XEST_TRANSP,XVIA_TRANSP,XCGC_TRANSP,XTEL_TRANSP,XPARC_DUP,XVENC_DUP")
SetPrvt("XVALOR_DUP,XDUPLICATAS,XNATUREZA,XFORNECE,XNFORI,XPEDIDO,XNUMSERI, XCHASSI, XLINHA, XMODELO,XCOLOR, XNUMPAS")
SetPrvt("XPESOPROD,XFAX,NOPC,CCOR,NTAMDET,XB_ICMS_SOL, XDESPESA, xQuantCont")
SetPrvt("XV_ICMS_SOL,NCONT,NCOL,NTAMOBS,NAJUSTE,BB,nVol2,xDiNum,xContNum")
Private  cBarra := CHR(124)


/*#IFNDEF WINDOWS
	// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/11/99 ==> 	#DEFINE PSAY SAY
#ENDIF*/	

//+--------------------------------------------------------------+
//¦ Define Variaveis Ambientais                                  ¦
//+--------------------------------------------------------------+
//+--------------------------------------------------------------+
//¦ Variaveis utilizadas para parametros                         ¦
//¦ mv_par01             // Da Nota Fiscal                       ¦
//¦ mv_par02             // Ate a Nota Fiscal                    ¦
//¦ mv_par03             // Da Serie                             ¦
//+--------------------------------------------------------------+
CbTxt	:=""
CbCont	:=""
nOrdem 	:=0
Alfa 	:= 0
Z	:=0
M	:=0
tamanho	:="G"
limite	:=400 // 232
titulo 	:=PADC("Nota Fiscal - Nfiscal",74)
cDesc1 	:=PADC("Este programa ira emitir a Nota Fiscal de Entrada/Saida",74)
cDesc2 	:=""
cDesc3 	:=PADC("da Nfiscal",74)
cNatureza	:=""
aReturn 		:= { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog:="nfiscal"
cPerg:="MOTR01"
nLastKey:= 0
lContinua := .T.
nLin:=0
wnrel    := "siganf"   
cPed := " "
cVend := " "  
xDESPESA    :=0
xBASE_ICMS 	:= 0 
xVALOR_ICMS := 0
xBSICMRET  	:= 0 
xICMS_RET  	:= 0 
xVALOR_MERC := 0  
xCla_Fis := 0  
ncount := 0
nVol := 0  
xTotValMerc := 0
xPedCli  := " "
xDiNum   := " "
xContNum := " " 


//+-----------------------------------------------------------+
//¦ Tamanho do Formulario de Nota Fiscal (em Linhas)          ¦
//+-----------------------------------------------------------+

nTamNf:=72     // Apenas Informativo

//+-------------------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ¦
//+-------------------------------------------------------------------------+

AtuPergunta(cPerg)

Pergunte(cPerg,.F.)               // Pergunta no SX1

cString:="SF2"

//+--------------------------------------------------------------+
//¦ Envia controle para a funcao SETPRINT                        ¦
//+--------------------------------------------------------------+

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.,,,)

If nLastKey == 27
	Return
Endif

//+--------------------------------------------------------------+
//¦ Verifica Posicao do Formulario na Impressora                 ¦
//+--------------------------------------------------------------+
SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

VerImp()     

//+--------------------------------------------------------------+
//¦                                                              ¦
//¦ Inicio do Processamento da Nota Fiscal                       ¦
//¦                                                              ¦
//+--------------------------------------------------------------+
#IFDEF WINDOWS
	RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> 	RptStatus({|| Execute(RptDetail)})
	Return
	// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> 	Function RptDetail
	Static Function RptDetail()
#ENDIF 

if MV_PAR01 == " "
	MV_PAR01 := "000000"
ENDIF

dbSelectArea("SF2")                // * Cabecalho da Nota Fiscal Saida       
dbSetOrder(1)
dbSeek(xFilial()+mv_par01+mv_par03,.t.)

dbSelectArea("SD2")                // * Itens de Venda da Nota Fiscal
dbSetOrder(3) // INDICE NUM DO DOC + SERIE + LOJA + PRODUTO + ITEM
dbSeek(xFilial("SD2")+mv_par01+mv_par03)
cPedant := SD2->D2_PEDIDO      

//+-----------------------------------------------------------+
//¦ Inicializa  regua de impressao                            ¦
//+-----------------------------------------------------------+
SetRegua(Val(mv_par02)-Val(mv_par01))  


dbSelectArea("SF2")
While !eof() .and. SF2->F2_DOC    <= mv_par02 .and. lContinua
		
	If SF2->F2_SERIE #mv_par03    // Se a Serie do Arquivo for Diferente
		DbSkip()                    // do Parametro Informado !!!
		Loop
	Endif
		
	#IFNDEF WINDOWS
		IF LastKey()==286
			@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
			lContinua := .F.
			Exit
		Endif
	#ELSE
		IF lAbortPrint
			@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
			lContinua := .F.
			Exit
		Endif
	#ENDIF
		
	nLinIni:=nLin                         // Linha Inicial da Impressao
		
		
		//+--------------------------------------------------------------+
		//¦ Inicio de Levantamento dos Dados da Nota Fiscal              ¦
		//+--------------------------------------------------------------+
		
		// * Cabecalho da Nota Fiscal
		
	xNUM_NF     :=SF2->F2_DOC             // Numero
	xSERIE      :=SF2->F2_SERIE           // Serie
	xEMISSAO    :=SF2->F2_EMISSAO         // Data de Emissao
	xTOT_FAT    :=SF2->F2_VALFAT          // Valor Total da Fatura
	if xTOT_FAT == 0
		xTOT_FAT := SF2->F2_VALMERC+SF2->F2_SEGURO+SF2->F2_FRETE
	endif
	
	
	xTIPO_CLI   :=SF2->F2_TIPOCLI            // Tipo de Cliente
	xCONDPAG    :=SF2->F2_COND            // Condicao de Pagamento
						
	xCLIENTE    :=SF2->F2_CLIENTE            // Codigo do Cliente
	xLOJA       :=SF2->F2_LOJA            // Loja do Cliente
	xFRETE      :=SF2->F2_FRETE           // Frete8
	xSEGURO     :=SF2->F2_SEGURO          // Seguro
	xVALOR_IVA  :=SF2->F2_VALIMP1         // Valor  do ICMS
	xVALOR_MERC :=SF2->F2_VALMERC         // Valor  da Mercadoria
	xNUM_DUPLIC :=SF2->F2_DUPL            // Numero da Duplicata
	xCOND_PAG   :=SF2->F2_COND            // Condicao de Pagamento
	xPBRUTO     :=SF2->F2_PBRUTO          // Peso Bruto
	xPLIQUI     :=SF2->F2_PLIQUI          // Peso Liquido
	xTIPO       :=SF2->F2_TIPO            // Tipo do Cliente
	xVOLUME     :=SF2->F2_VOLUME1         // Volume 1 no Pedido
	xDescNota	:=SF2->F2_DESCONT		  // Desconto da nota  
	xObs		:= ""//SF2->F2_XOBS
	xCOD_VEND	:= {SF2->F2_VEND1,;             // Codigo do Vendedor 1
			SF2->F2_VEND2,;             // Codigo do Vendedor 2
			SF2->F2_VEND3,;             // Codigo do Vendedor 3
			SF2->F2_VEND4,;             // Codigo do Vendedor 4
			SF2->F2_VEND5}              // Codigo do Vendedor 5
	                                                           
	
	//+---------------------------------------------+
	//¦ Pesquisa da Condicao de Pagto               ¦
	//+---------------------------------------------+
		
	dbSelectArea("SE4")                    // Condicao de Pagamento
	dbSetOrder(1)
	dbSeek(xFilial("SE4")+xCONDPAG)
	xDESC_PAG := SE4->E4_DESCRI
	
	dbSelectArea("SD2")                   // * Itens de Venda da N.F.
	dbSetOrder(3)
	dbSeek(xFilial("SD2")+xNUM_NF+xSERIE)
		
	cPedAtu := SD2->D2_PEDIDO
	cItemAtu := SD2->D2_ITEMPV
		
	xPED_VEND:={}                         // Numero do Pedido de Venda
	xITEM_PED:={}                         // Numero do Item do Pedido de Venda
	xNUM_NFDV:={}                         // nUMERO QUANDO HOUVER DEVOLUCAO
	xPREF_DV :={}                         // Serie  quando houver devolucao
	xICMS    :={}                         // Porcentagem do ICMS
	xCOD_PRO :={}                         // Codigo  do Produto
	xQTD_PRO :={}                         // Peso/Quantidade do Produto
	xPRE_UNI :={}                         // Preco Unitario de Venda
	xPRE_TAB :={}                         // Preco Unitario de Tabela
	xIPI     :={}                         // Porcentagem do IPI
	xVAL_IPI :={}                         // Valor do IPI
	xDESC    :={}                         // Desconto por Item
	xVAL_DESC:={}                         // Valor do Desconto
	xVAL_MERC:={}                         // Valor da Mercadoria
	xTES     :={}                         // TES
	xOBS     :={}                         // Observacao
	xCF      :={}                         // Classificacao quanto natureza da Operacao
	xICMSOL  :={}                         // Base do ICMS Solidario
	xICM_PROD:={}                         // ICMS do Produto
	xNUMSERI:={}                       
	xVAL_DESC:={}

	    //barrter
	xCOD_TRIB:={}
	nVol     :=0
	ncount :=1
	Tes    :=""
		// end barter
		                   
	dbSelectArea("SD2")
	while !eof() .and. SD2->D2_DOC==xNUM_NF .and. SD2->D2_SERIE==xSERIE
			
		If SD2->D2_SERIE #mv_par03        // Se a Serie do Arquivo for Diferente
			SD2->(DbSkip())                   // do Parametro Informado !!!
			Loop
		Endif
		
		AADD(xPED_VEND ,SD2->D2_PEDIDO)
		AADD(xITEM_PED ,SD2->D2_ITEMPV)
		AADD(xNUM_NFDV ,IIF(Empty(SD2->D2_NFORI),"",SD2->D2_NFORI))
		AADD(xPREF_DV  ,SD2->D2_SERIORI)
		AADD(xICMS     ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
		AADD(xCOD_PRO  ,SD2->D2_COD)
		AADD(xQTD_PRO  ,SD2->D2_QUANT)     // Guarda as quant. da NF
		AADD(xPRE_UNI  ,SD2->D2_PRCVEN)
		AADD(xPRE_TAB  ,SD2->D2_PRUNIT)
		AADD(xIPI      ,IIF(Empty(SD2->D2_IPI),0,SD2->D2_IPI))
		AADD(xVAL_IPI  ,SD2->D2_VALIPI)
		AADD(xDESC     ,SD2->D2_DESC)
		AADD(xVAL_DESC ,SD2->D2_DESCON)
		AADD(xVAL_MERC ,SD2->D2_TOTAL)
		AADD(xTES      ,SD2->D2_TES)
		AADD(xCF       ,SD2->D2_CF)
		AADD(xICM_PROD ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))  
		AADD(xNUMSERI, SD2->D2_NUMSERI)
		
		tes := SD2->D2_TES

		nVol := nVol + SD2->D2_QTSEGUM
		  
		SD2->(dbSkip())
		
	EndDo
		
	dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
	DbSetOrder(1)
	dbSeek(xFilial()+tes)
	xNATUREZA:=SF4->F4_TEXTO              // Natureza da Operacao
	Nat := SF4->F4_CODIGO
		 
		
	dbSelectArea("SB1")                     // * Desc. Generica do Produto
	dbSetOrder(1)
		
	xPESO_PRO	:=	{}                           // Peso Liquido
	xPESO_UNIT 	:=	{}                         // Peso Unitario do Produto
	xDESCRICAO 	:=	{}                         // Descricao do Produto
	xUNID_PRO	:=	{}                           // Unidade do Produto
	//xCOD_TRIB	:=	{}                           // Codigo de Tributacao
	xMEN_TRIB	:=	{}                           // Mensagens de Tributacao
	xCOD_FIS 	:=	{}                           // Cogigo Fiscal
	xCLAS_FIS	:=	{}                           // Classificacao Fiscal
	xMEN_POS 	:=	{}                           // Mensagem da Posicao IPI
	xISS     	:=	{}                           // Aliquota de ISS
	xTIPO_PRO	:=	{}                           // Tipo do Produto
	xLUCRO   	:=	{}                           // Margem de Lucro p/ ICMS Solidario
	xCLFISCAL   :=	{}
	xCla_Fis 	:=	{}
	XLINHA      :=  {}
	XMODELO		:=  {}
	XCOLOR		:=  {}
	XNUMPAS		:=  {}

	xPESO_LIQ 	:= 	0
	I:=1
		
	For I:=1 to Len(xCOD_PRO)
			
		dbSeek(xFilial()+xCOD_PRO[I])
		AADD(xPESO_PRO ,SB1->B1_PESO * xQTD_PRO[I])
		xPESO_LIQ  := xPESO_LIQ + xPESO_PRO[I]
		AADD(xPESO_UNIT , SB1->B1_PESO)
		AADD(xUNID_PRO ,SB1->B1_UM)
		AADD(xDESCRICAO ,Alltrim(SB1->B1_DESC))
		AADD(XLINHA, SB1->B1_SERIE)
		AADD(XMODELO, SB1->B1_MODELO)
		AADD(XCOLOR, SB1->B1_COLOR)                                    
		AADD(XNUMPAS,SB1->B1_NROPAG)
		If Ascan(xMEN_TRIB, SB1->B1_ORIGEM)==0   // ascan pesq no vetor xMen_trib o campo com o valor b1_origem == 0 Não encontrou
			AADD(xMEN_TRIB ,SB1->B1_ORIGEM)
		Endif
		AADD (xCOD_TRIB, SB1->B1_ORIGEM + SB1->B1_CLASFIS)
			
		npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI) //NPeLEN RECEBE 0
			
		if npElem == 0
			AADD(xCLAS_FIS  ,SB1->B1_POSIPI)// VAI ADD NA ULTIMA POSIÇÃO DE XcLAS_FIS B1_POSIPI
		endif
			
		npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)//npelem := posição de xClas_fis preenchida com o valor B1_posi
			
		DO CASE
		CASE npElem == 1
			_CLASFIS := "A"
					
		CASE npElem == 2
			_CLASFIS := "B"
					
		CASE npElem == 3
			_CLASFIS := "C"
					
		CASE npElem == 4
			_CLASFIS := "D"
					
		CASE npElem == 5
			_CLASFIS := "E"
					
		CASE npElem == 6
			_CLASFIS := "F"
					
		ENDCASE
		nPteste := Ascan(xCLFISCAL,_CLASFIS)// nPtESTE :=0
		If nPteste == 0
			AADD(xCLFISCAL,_CLASFIS)
		Endif
			
		AADD(xCOD_FIS ,_CLASFIS)
		If SB1->B1_ALIQISS > 0
			AADD(xISS ,SB1->B1_ALIQISS)
		Endif
		AADD(xTIPO_PRO ,SB1->B1_TIPO)
		AADD(xLUCRO    ,SB1->B1_PICMRET)
			
			
			//
			// Calculo do Peso Liquido da Nota Fiscal
			//
			
		xPESO_LIQUID:=0                                 // Peso Liquido da Nota Fiscal
		For j:=1 to Len(xPESO_PRO)
			xPESO_LIQUID:=xPESO_LIQUID+xPESO_PRO[j]
		Next
			
	Next
		
	dbSelectArea("SC5")                            // * Pedidos de Venda
	dbSetOrder(1)
		
	xPED        := {}
	xPESO_BRUTO := 0
	xP_LIQ_PED  := 0
	xRedespacho := ""
	xPedCli     := ""
	xCOD_MENS   := ""

		
	For I:=1 to Len(xPED_VEND)
			
		dbSeek(xFilial()+xPED_VEND[I])
			
		dbSelectArea("SM4")
		dbSetOrder(1)
		dbSeek(XFILIAL("SM4")+SC5->C5_MENPAD)
			
		If ASCAN(xPED,xPED_VEND[I])==0
			dbSeek(xFilial()+xPED_VEND[I])
			xCLIENTE    :=SC5->C5_CLIENTE            // Codigo do Cliente
			xTIPO_CLI   :=SC5->C5_TIPOCLI            // Tipo de Cliente
			xCOD_MENS   :=SC5->C5_MENPAD             // Codigo da Mensagem Padrao
			xMENSAGEM   :=SC5->C5_MENNOTA            // Mensagem para a Nota Fiscal
			xTPFRETE    :=SC5->C5_TPFRETE            // Tipo de Entrega
			xCONDPAG    :=SC5->C5_CONDPAG            // Condicao de Pagamento
			   	 
		Endif
			
		If xP_LIQ_PED >0
			xPESO_LIQ := xP_LIQ_PED
		Endif
			
	Next
		
	dbSelectArea("SC6")                    // * Itens de Pedido de Venda
	dbSetOrder(1)
	xPED_CLI :={}                          // Numero de Pedido
	xDESC_PRO:={}                          // Descricao aux do produto
	XCHASSI  :={}
	J:=Len(xPED_VEND)
	For I:=1 to J
		dbSeek(xFilial()+xPED_VEND[I]+xITEM_PED[I])
		if i == 1
			cPed:=xPED_VEND[I]
		endif
		AADD(xPED_CLI ,SC6->C6_PEDCLI)
		AADD(xDESC_PRO,SC6->C6_DESCRI)
		AADD(xVAL_DESC,SC6->C6_VALDESC)
		AADD(XCHASSI,SC6->C6_CHASSI) // Nº Motor
	Next
		
	If xTIPO=='N' .OR. xTIPO=='C' .OR. xTIPO=='P' .OR. xTIPO=='I' .OR. xTIPO=='S' .OR. xTIPO=='T' .OR. xTIPO=='O'
		
		xCLIENTE    :=SF2->F2_CLIENTE            // Codigo do Cliente
		xLOJA       :=SF2->F2_LOJA            // Loja do Cliente
			
		dbSelectArea("SA1")                // * Cadastro de Clientes
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+xCLIENTE+xLOJA)
		xCOD_CLI :=SA1->A1_COD             // Codigo do Cliente
		xNOME_CLI:=SA1->A1_NOME            // Nome
		xEND_CLI :=SA1->A1_END             // Endereco
		xBAIRRO  :=SA1->A1_BAIRRO          // Bairro
		xCEP_CLI :=SA1->A1_CEP             // CEP
		xCOB_CLI :=SA1->A1_ENDCOB          // Endereco de Cobranca
		xREC_CLI :=SA1->A1_ENDENT          // Endereco de Entrega
		xMUN_CLI :=SA1->A1_MUN             // Municipio
		xEST_CLI :=SA1->A1_EST             // Estado
		xCGC_CLI :=Iif(Empty(SA1->A1_CGC),SA1->A1_PFISICA,SA1->A1_CGC)// CGC
		xINSC_CLI:=SA1->A1_INSCR           // Inscricao estadual
		xTRAN_CLI:=SA1->A1_TRANSP          // Transportadora
		xTEL_CLI :=SA1->A1_TEL             // Telefone
		xFAX_CLI :=SA1->A1_FAX             // Fax
		xSUFRAMA :=SA1->A1_SUFRAMA            // Codigo Suframa
		xCALCSUF :=SA1->A1_CALCSUF            // Calcula Suframa
			// Alteracao p/ Calculo de Suframa
		if !empty(xSUFRAMA) .and. xCALCSUF =="S"
			IF XTIPO == 'D' .OR. XTIPO == 'B'
				zFranca := .F.
			else
				zFranca := .T.
			endif
		Else
			zfranca:= .F.
		Endif
		
			
	Else
		zFranca:=.F.
		dbSelectArea("SA2")                // * Cadastro de Fornecedores
		dbSetOrder(1)
		dbSeek(xFilial()+xCLIENTE+xLOJA)
		xCOD_CLI :=SA2->A2_COD             // Codigo do Fornecedor
		xNOME_CLI:=SA2->A2_NOME            // Nome Fornecedor
		xEND_CLI :=SA2->A2_END             // Endereco
		xBAIRRO  :=SA2->A2_BAIRRO          // Bairro
		xCEP_CLI :=SA2->A2_CEP             // CEP
		xCOB_CLI :=""                      // Endereco de Cobranca
		xREC_CLI :=""                      // Endereco de Entrega
		xMUN_CLI :=SA2->A2_MUN             // Municipio
		xEST_CLI :=SA2->A2_EST             // Estado
		xCGC_CLI :=SA2->A2_CGC             // CGC
		xINSC_CLI:=SA2->A2_INSCR           // Inscricao estadual
		xTRAN_CLI:=SA2->A2_TRANSP          // Transportadora
		xTEL_CLI :=SA2->A2_TEL             // Telefone
		xFAX_CLI :=SA2->A2_FAX             // Fax
	Endif
	dbSelectArea("SA3")                   // * Cadastro de Vendedores
	dbSetOrder(1)
	xVENDEDOR:={}                         // Nome do Vendedor
	I:=1
	J:=Len(xCOD_VEND)
	For I:=1 to J
		dbSeek(xFilial()+xCOD_VEND[I])
		Aadd(xVENDEDOR,SA3->A3_NREDUZ)
		if i == 1
			cVend := xVendedor[i]
		endif
	Next
		
	If xICMS_RET >0                          // Apenas se ICMS Retido > 0
		dbSelectArea("SF3")                   // * Cadastro de Livros Fiscais
		dbSetOrder(4)
		dbSeek(xFilial()+SA1->A1_COD+SA1->A1_LOJA+SF2->F2_DOC+SF2->F2_SERIE)
		If Found()
			xBSICMRET:=F3_VALOBSE
		Else
			xBSICMRET:=0
		Endif
	Else
		xBSICMRET:=0
	Endif
	dbSelectArea("SA4")                   // * Transportadoras
	dbSetOrder(1)
	dbSeek(xFilial()+SF2->F2_TRANSP)
	xNOME_TRANSP :=SA4->A4_NOME           // Nome Transportadora
	xEND_TRANSP  :=SA4->A4_END            // Endereco
	xMUN_TRANSP  :=SA4->A4_MUN            // Municipio
	xEST_TRANSP  :=SA4->A4_EST            // Estado
	xVIA_TRANSP  :=SA4->A4_VIA            // Via de Transporte
	xCGC_TRANSP  :=SA4->A4_CGC            // CGC
	xTEL_TRANSP  :=SA4->A4_TEL            // Fone
	xInscr_Est   :=SA4->A4_INSEST         //Inscrição estadual
		
	dbSelectArea("SE1")                   // * Contas a Receber
	dbSetOrder(1)
	xPARC_DUP  :={}                       // Parcela
	xVENC_DUP  :={}                       // Vencimento
	xVALOR_DUP :={}                       // Valor
	xDUPLICATAS:=IIF(dbSeek(xFilial()+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas
		
	while !eof() .and. SE1->E1_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
		If !("NF" $ SE1->E1_TIPO)
			dbSkip()
			Loop
		Endif
		AADD(xPARC_DUP ,SE1->E1_PARCELA)
		AADD(xVENC_DUP ,SE1->E1_VENCTO)
		AADD(xVALOR_DUP,SE1->E1_VALOR)
		dbSkip()
	EndDo
		
	dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
	DbSetOrder(1)
	dbSeek(xFilial()+xTES[1])
	xNATUREZA:=SF4->F4_TEXTO              // Natureza da Operacao
	Nat := SF4->F4_CODIGO
		//AADD(xCOD_TRIB ,SF4->F4_SITTRIB)
		
		
	Imprime()
		
		//+--------------------------------------------------------------+
		//¦ Termino da Impressao da Nota Fiscal                          ¦
		//+--------------------------------------------------------------+
		
	IncRegua()                    // Termometro de Impressao
		
   	nLin:=0
	dbSelectArea("SF2")
	dbSkip()                      // passa para a proxima Nota Fiscal
		
EndDo

//+--------------------------------------------------------------+
//¦                                                              ¦
//¦                      FIM DA IMPRESSAO                        ¦
//¦                                                              ¦
//+-------------d-------------------------------------------------+

//+--------------------------------------------------------------+
//¦ Fechamento do Programa da Nota Fiscal                        ¦
//+--------------------------------------------------------------+

dbSelectArea("SF2")
Retindex("SF2")
dbSelectArea("SF1")
Retindex("SF1")
dbSelectArea("SD2")
Retindex("SD2")
dbSelectArea("SD1")
Retindex("SD1")
Set Device To Screen

If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()
//+--------------------------------------------------------------+
//¦ Fim do Programa                                              ¦
//+--------------------------------------------------------------+

//+--------------------------------------------------------------+
//¦                                                              ¦
//¦                   FUNCOES ESPECIFICAS                        ¦
//¦                                                              ¦
//+--------------------------------------------------------------+

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ VERIMP   ¦ Autor ¦   Marcos Simidu       ¦ Data ¦ 20/12/95 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Verifica posicionamento de papel na Impressora             ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Nfiscal                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

//+---------------------+
//¦ Inicio da Funcao    ¦
//+---------------------+

// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> Function VerImp
Static Function VerImp()

nLin:= 0                // Contador de Linhas
nLinIni:=0
If aReturn[5]==2
	
	nOpc       := 1
	#IFNDEF WINDOWS
		cCor       := "B/BG"
	#ENDIF
	While .T.
		
		SetPrc(0,0)
		dbCommitAll()
		
	   	//@ PROW()+1, 001 Psay CHR(18)   
			@ nLin ,022 PSAY "."
			IF MsgYesNo("Fomulario esta posicionado ? ")
				nOpc := 1
			ElseIF MsgYesNo("Tenta Novamente ? ")
				nOpc := 2
			Else
				nOpc := 3
			Endif
		
		Do Case
			Case nOpc==1
				lContinua:=.T.
				Exit
			Case nOpc==2
				Loop
			Case nOpc==3
				lContinua:=.F.
				Return
		EndCase
	End
Endif

Return

//+---------------------+
//¦ Fim da Funcao       ¦
//+---------------------+

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ IMPDET   ¦ Autor ¦   Marcos Simidu       ¦ Data ¦ 20/12/95 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao de Linhas de Detalhe da Nota Fiscal              ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Nfiscal                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static Function IMPDET()

Local nTamDet 	:= getmv("MV_NUMITEN")            // Tamanho da Area de Detalhe
Local I	 		:= 1
Local J			:= 1
Local nSomaDesc := 0
                        
For I:=1 to nTamDet
	
	If I<=Len(xCOD_PRO)                
		If 	MV_PAR04 > 1
			If MV_PAR04 = 2
				@ nLin, 016  PSAY xQTD_PRO[I]             Picture"@E 999,999"
				@ nLin, 025  PSAY posicione("SB1",1,XFILIAL("SB1")+xCOD_PRO[I],"B1_YCODALR")
				
				cXObs:= Posicione("SC6",1,XFILIAL("SC6")+xPED_VEND[I]+xITEM_PED[I]+XCOD_PRO[I],"C6_YSTRUCT")
	
				If MLCount(cXObs ,40) > 0
				
					nLine2:=nLin
					nLinhas2 := MLCount(cXObs ,40)
					For nXi := 1 To nLinhas2
					 If ! Empty(MLCount(cXObs,40))
						  If ! Empty(MemoLine(cXObs,40,nXi))
							   //oPrn:Say(nLine2 + 2100, 105,OemToAnsi(MemoLine(cXObs,40,nXi)), oFont09Tex, 200 )
							   @ nLin, 033  PSAY OemToAnsi(MemoLine(cXObs,40,nXi))
							   //IncLinha(50)
							   nLine2+=40
						  EndIf
					 EndIf
					Next nXi
				
				EndIF
				
				@ nLin, 099  PSAY xPRE_UNI[I]             Picture"@E 9,999,999,999.99"
				
				xVAL_MERC[I] := xPRE_UNI[I] * xQTD_PRO[I] 		//ajusta o valor total do item da nota
				xTotValMerc	 := xTotValMerc + xVAL_MERC[I]
				@ nLin, 120  PSAY xVAL_MERC[I]      Picture"@E 9,999,999,999.99"
				
				nLin :=nLin+1
			
			Else
				
				@ nLin, 000  PSAY xQTD_PRO[I]             Picture"@E 999,999"
				@ nLin, 015  PSAY posicione("SB1",1,XFILIAL("SB1")+xCOD_PRO[I],"B1_YCODALR")
				cXObs:= Posicione("SC6",1,XFILIAL("SC6")+xPED_VEND[I]+xITEM_PED[I]+XCOD_PRO[I],"C6_YSTRUCT")
	
				If MLCount(cXObs ,40) > 0
				
					nLine2:=nLin
				//	For nXi := 1 To MLCount(SD2->D2_XDESPRS,50)
					nLinhas2 := MLCount(cXObs ,40)
					For nXi := 1 To nLinhas2
					 If ! Empty(MLCount(cXObs,40))
						  If ! Empty(MemoLine(cXObs,40,nXi))
							   //oPrn:Say(nLine2 + 2100, 105,OemToAnsi(MemoLine(cXObs,40,nXi)), oFont09Tex, 200 )
							   @ nLin, 033  PSAY OemToAnsi(MemoLine(cXObs,40,nXi))
							   //IncLinha(50)
							   nLine2+=40  // Juan Pablo 40 
						  EndIf
					 EndIf
					Next nXi
				
				EndIF
				
				
				@ nLin, 099  PSAY xPRE_UNI[I]             Picture"@E 9,999,999,999.99"
				
				xVAL_MERC[I] := xPRE_UNI[I] * xQTD_PRO[I] 		//ajusta o valor total do item da nota
				xTotValMerc	:= xTotValMerc + xVAL_MERC[I]
				
				@ nLin, 120  PSAY xVAL_MERC[I]  Picture"@E 9,999,999,999.99"
	
			EndIf
			nLin :=nLin+1
		Else
			cXObs := ALLTRIM(Replace(Posicione("SC6",1,XFILIAL("SC6")+xPED_VEND[I]+xITEM_PED[I]+XCOD_PRO[I],"C6_YSTRUCT"),chr(13)+chr(10)," "))   
			cFam  := Posicione("SC6",1,XFILIAL("SC6")+xPED_VEND[I]+xITEM_PED[I]+XCOD_PRO[I],"C6_YCODF")    
			cDoc  :=ALLTRIM(SF2->F2_DOC)
			cSer  :=Alltrim(SF2->F2_PREFIXO)
			cAnti :=Alltrim(Posicione("SE5",2,xFilial("SE5")+"CP"+cSer+cDoc,"E5_DOCUMEN"))
			cMot  :=Alltrim(Posicione("SE5",2,xFilial("SE5")+"CP"+cSer+cDoc,"E5_MOTBX"))  
			cSerie:=Alltrim(SUBSTR(cAnti,1,3))
			cNum  :=Alltrim(SUBSTR(cAnti,4,11))
			cSeSFP:=Alltrim(Posicione("SFP",1,xfilial("SFP")+SM0->M0_CODFIL+cSer,"FP_YSERIE"))  
			cFecha:=DTOS(Posicione("SE1",1,xFilial("SE1")+(cSerie+cNum),"E1_EMISSAO"))
			nLine2:=nLin+1  
			nLine3:=nLin+2
			@ nLin, 020  PSAY xQTD_PRO[I] // Picture"@E 999,999"
			@ nLin, 033  PSAY ALLTRIM(xCOD_PRO[I])   
			IF !Empty(cFam) 	  						   							   					
		 		@ nLin,065 PSAY  Alltrim(Posicione("SB1",1,XFILIAL("SB1")+cFam,"B1_DESC")) 			
			else
				@ nLin,065 PSAY  Alltrim(Posicione("SB1",1,XFILIAL("SB1")+XCOD_PRO[I],"B1_DESC")) 	
	   		EndIf	                                 º
		 	@ nLin, 105  PSAY xPRE_UNI[I]  Picture "9,999,999.99"
			xVAL_MERC[I] := xPRE_UNI[I] * xQTD_PRO[I] 		//ajusta o valor total do item da nota
			xTotValMerc	:= xTotValMerc + xVAL_MERC[I]
			@ nLin, 130  PSAY xVAL_MERC[I] Picture "9,999,999.99"   
			                
			IF !Empty(cXObs)
				If MLCount(cXObs ,70) > 0
				nLinhas2 := MLCount(cXObs ,70)
							For nXi := 1 To nLinhas2
						   	  	@ nLine2,033  PSAY OemToAnsi(MemoLine(cXObs,70,nXi))
								nLine2+=1
							next nXi
				EndIF 
				IF nLinhas2=2
					nLin :=nLin+2  
						ELSEIF nLinhas2=3 
			   				nLin :=nLin+3 
			   					ELSEIF nLinhas2=4
			   							nLin :=nLin+4
					   						ELSEIF nLinhas2=5
					   							nLin :=nLin+5
										   			ELSEIF nLinhas2=6  
										   				nLin :=nLin+6
			   	EndIf		  
	   		Endif     
	   	
	  Endif   
	EndIf	      
	nLin :=nLin+1
Next   
		
	IF(cMot=='CMP')
		@ nLine2+1,033  PSAY Alltrim("ANTICIPO")+"  "+cSeSFP+" "+cNum+" "+Alltrim(SUBSTR(cFecha,7,2))+"/"+Alltrim(SUBSTR(cFecha,5,2))+"/"+Alltrim(SUBSTR(cFecha,1,4))
		@ nLine2+1,129  PSAY Alltrim("-")
		@ nLine2+1,130  PSAY SF2->F2_VALADI Picture "9,999,999.99"  
	EndIf	
 Return

//+---------------------+
//¦ Fim da Funcao       ¦
//+---------------------+

/*/_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ IMPRIME  ¦ Autor ¦   Marcos Simidu       ¦ Data ¦ 20/12/95 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Imprime a Nota Fiscal de Entrada e de Saida                ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Generico RDMAKE                                            ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> Function Imprime
Static Function Imprime()
//+--------------------------------------------------------------+
//¦                                                              ¦
//¦              IMPRESSAO DA N.F. DA Nfiscal                    ¦
//¦                                                              ¦
//+--------------------------------------------------------------+

//nLin:=05       // Juan Pablo      05

//+-------------------------------------+
//¦ Impressao do Cabecalho da N.F.      ¦
//+-------------------------------------+

@ 01, 000 PSAY Chr(15)                // Compressao de Impressao

//+-------------------------------------+
//¦ Impressao dos Dados do Cliente      ¦
//+-------------------------------------+

cEMISSAO  := Dtos(xEMISSAO)
cVENC_DUP := Dtos(xVENC_DUP[1])
@ 10, 014 PSAY "SEÑORES"
@ 10, 024 PSAY ": "+xNOME_CLI   
@ 10, 150 PSAY ALLTRIM(SF2->F2_DOC)
@ 11, 014 PSAY "R.U.C."
@ 11, 024 PSAY ": "+xCGC_CLI
@ 12, 014 PSAY "DIRECCION"
@ 12, 024 PSAY ": "+Alltrim(xEND_CLI)                
@ 13, 014 PSAY "PEDIDO N°"
@ 13, 024 PSAY ": "+alltrim(cPedAtu)
@ 13, 050 PSAY "FECHA"
@ 13, 070 PSAY ": "+Substr(cEMISSAO,7,2)+"/"+Substr(cEMISSAO,5,2)+"/"+Substr(cEMISSAO,1,4) 
@ 14, 014 PSAY "G/R"  
@ 14, 024 PSAY ": "                                      

@ 18,016 PSAY ALLTRIM("CANTIDAD")
@ 18,040 PSAY ALLTRIM("CODIGO")
@ 18,070 PSAY ALLTRIM("DESCRIPCION")
@ 18,110 PSAY ALLTRIM("P.U.")
@ 18,135 PSAY ALLTRIM("IMPORTE")

//+-------------------------------------+
//¦ Dados dos Produtos Vendidos         ¦
//+-------------------------------------+

nLin := 20
ImpDet()                 // Itens da nota

//+-------------------------------------------------------------------------+
//¦ Imprime valor total da nota 										    ¦
//+-------------------------------------------------------------------------+

cxSM := If(SF2->F2_MOEDA==1,Alltrim("S/"),If(SF2->F2_MOEDA==2,Alltrim("$"),""))   

@ 057, 014  PSAY Alltrim("SUBTOTAL")+" "+Alltrim(cxSM)
@ 057, 030  PSAY SF2->F2_BASIMP1 Picture "99,999.99"   // Valor sUBTOTAL
@ 057, 050  PSAY Alltrim("IGV")+" "+Alltrim(cxSM)
@ 057, 070  PSAY SF2->F2_VALIMP1 Picture "99,999.99"    // IVA
@ 057, 110  PSAY Alltrim("TOTAL")+" "+Alltrim(cxSM)
@ 057, 130  PSAY SF2->F2_VALBRUT Picture "99,999.99"   // Valor sUBTOTAL
@ 058, 014  PSAY AllTrim(Extenso(SF2->F2_VALBRUT,.F.,SF2->F2_MOEDA,,"2",.T.,.T.))     
cDia		:= SubStr(DtoS(SF2->F2_EMISSAO),7,2)
nMes		:= SubStr(DtoS(SF2->F2_EMISSAO),5,2)
cAno		:= SubStr(DtoS(SF2->F2_EMISSAO),1,4)  
cAno2		:= SubStr(DtoS(SF2->F2_EMISSAO),3,2)   

IF nMes == '01'
	cMes := "ENERO" 
		ElseIf nMes == '02'
			cMes := "FEBRERO"
				ElseIf nMes == '03'
					cMes := "MARZO"
				   		ElseIf nMes == '04'
							cMes := "ABRIL"
								ElseIf nMes == '05'
									cMes := "MAYO"
										ElseIf nMes == '06'
											cMes := "JUNIO"
												ElseIf nMes == '07'
													cMes := "JULIO"
														ElseIf nMes == '08'
															cMes := "AGOSTO"
																ElseIf nMes == '09'
																	cMes := "SETIEMBRE"
																		ElseIf nMes == '10'
																			cMes := "OCTUBRE"
																				ElseIf nMes == '11'
																					cMes := "NOVIEMBRE"
																						ElseIf nMes == '12'
																								cMes := "DICIEMBRE"
EndIf
@ 061	, 068 Psay 	cDia    
@ 061	, 078 Psay 	cMes  
@ 061	, 100 Psay 	cAno2    


//@ 10, 000 PSAY Chr(15)                // Compressao de Impressao     // Juann Pablo 61


SetPrc(10,0)                              // (Zera o Formulario)

Return .t.


*------------------------------------------------------------------------------------
Static Function AtuPergunta(cPerg)
*------------------------------------------------------------------------------------


Local aHelpPor := {}
Local nTamDOC  := TamSx3("F2_DOC")[1]
Local nTamSer  := TamSx3("F2_SERIE")[1]

aAdd(aHelpPor, ".")
PutSx1(cPerg, "01", "De Factura ?" , "A  Factura ?", "A  Factura ?", "MV_CH1", "C",nTamDOC , 0, 1, "G","","","","","MV_PAR01","","","","","","","","","","","","","","","","", aHelpPor, aHelpPor, aHelpPor)
PutSx1(cPerg, "02", "A  Factura ?" , "A  Factura ?", "A  Factura ?", "MV_CH2", "C", nTamDOC, 0, 1, "G","","","","","MV_PAR02","","","","","","","","","","","","","","","","", aHelpPor, aHelpPor, aHelpPor)
	
aHelpPor := {}
aAdd(aHelpPor, " ")
PutSx1(cPerg, "03", "De Serie ?" , "De Serie  ?", "De Serie  ?", "MV_CH3", "C", nTamSer, 0, 1, "G","","","","","MV_PAR03","","","","","","","","","","","","","","","","", aHelpPor, aHelpPor, aHelpPor)

aHelpPor := {}
aAdd(aHelpPor, " ")
PutSx1(cPerg, "04", "Tipo Factura?" , "Tipo Factura  ?", "Tipo Factura ?", "MV_CH4", "N", 1, 0, 1, "C","","","","","MV_PAR04","Normal","Normal","Normal","","Maquin. e Implem.","Maquin. e Implem.","Maquin. e Implem.","Cuatrimotos","Cuatrimotos","Cuatrimotos","","","","","","", aHelpPor, aHelpPor, aHelpPor)

	
Return     

