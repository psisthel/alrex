#Include "CTBR118.Ch"
#Include "PROTHEUS.Ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CTBR118  ³ Autor ³ Patricia Ikari        ³ Data ³ 28/10/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Diario Geral                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTBR118(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³Data    ³ BOPS     ³ Motivo da Alteracao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jonathan Glz³25/06/15³PCREQ-4256³Se elimina la funcion AjustaSX1() que ³±±
±±³            ³        ³          ³que modifica la tabla SX1 por motivo  ³±±
±±³            ³        ³          ³de adecuacion a fuentes para nuevas   ³±±
±±³            ³        ³          ³estructuras SX para Version 12.       ³±±
±±³            ³        ³          ³                                      ³±±
±±³Jonathan Glz³09/10/15³PCREQ-4261³Merge v12.1.8                         ³±±
±±³  Marco A.  ³12/02/18³ DMINA-772³Se replican modificaciones al Libro   ³±±
±±³            ³        ³          ³Mayor, de acuerdo al issue. (PER)     ³±±
±±³  Marco A.  ³08/02/18³DMINA-2136³Se modifica de posicion, la funcion   ³±±
±±³            ³        ³          ³utilizada para la eliminacion del     ³±±
±±³            ³        ³          ³objeto de FWTemporaryTable. (PER)     ³±±
±±³  Marco A.  ³15/05/18³DMINA-2607³Modificaciones para pais Peru que con-³±±
±±³            ³        ³          ³sisten en re-estructuracion y mod. de ³±±
±±³            ³        ³          ³orden de preguntas CTR118. (PER)      ³±±
±±³  Oscar G.  ³05/01/19³DMINA-4919³Se actualiza fuente de 11.8 a 12.1.17 ³±±
±±³            ³        ³          ³para estabilización. (PER)            ³±±
±±³Alf. Medrano³15/05/19³DMINA-6664³Replica de DMINA-6266 Libro diario,   ³±±
±±³            ³        ³          ³reformulación del campo 20 (PER)      ³±±
±±³            ³17/05/19³          ³Se quita static a la fun DetIGVFn     ³±±
±±³            ³        ³          ³Se deelcaran variables tipo fecha(PER)³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ZCTBR118()

Local cFilIni		:= cFilAnt    

Private titulo		:= ""

Private cPerg	 	:= "CTR1182"
Private l1StQb		:= .T.
Private nTransC		:= 0
Private nTransD		:= 0
Private aSelFil		:= {}
Private cPlanRef := SuperGetMv("MV_PLANREF",,'01')
Private TMP
Private cTmpCT1Fil	:= ""
private cTmpCT2Fil	:= ""

private  _aDocOrig:= {}

Private lPrintZero	:= .f. 
Private cMascara		:= ""
Private cDescMoeda 	:= ""
Private cPicture		:= ""
Private  nDecimais	:= 0
Private aTamVal		:= TAMSX3("CT2_VALOR")
Private nTamQuebra	:= 0      
Private nTamConta	:= 25   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01  	      	// Data Inicial                          ³
//³ mv_par02            // Data Final                            ³
//³ mv_par03            // Moeda?                                ³
//³ mv_par04			// Set Of Books			    		     ³
//³ mv_par05			// Tipo Lcto? Real / Orcad / Gerenc / Pre³
//³ mv_par06  	      	// Pagina Inicial                        ³
//³ mv_par07         	// Pagina Final                          ³
//³ mv_par08         	// Pagina ao Reiniciar                   ³
//³ mv_par09         	// So Livro/Livro e Termos/So Termos     ³
//³ mv_par10         	// Imprime Plano de contas               ³ 
//³ mv_par11         	// Imprime Valor 0.00	                 ³
//³ mv_par12            // Num.linhas p/ o diario?				 ³ 
//| mv_par13               Salta linha entre contas?             |
//| mv_par14               Descricao na Moeda?                   |
//| mv_par15               Seleciona Filiais?					 |
//| mv_par16               ¿Genera ?  Archivo TXT/Informe		 |
//| mv_par17               ¿Directorio?							 |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private  dPFecIni 	//³ mv_par01  	      	// Data Inicial                         
Private  dPFecFin 	//³ mv_par02            // Data Final                           
Private  cPMon 		//³ mv_par03            // Moeda?                               
Private  cPLibro 	 //³ mv_par04			// Set Of Books		
Private  cPTPSld 	 //³ mv_par05			// Tipo Lcto? Real / Orcad / Gerenc / Pr
Private  nPPagIni 	 //³ mv_par06  	      	// Pagina Inicial                       
Private  nPPagFin	 //³ mv_par07         	// Pagina Final                         
Private  nPPagRei	 //³ mv_par08         	// Pagina ao Reiniciar                  
Private  nPTipLibr 	 //³ mv_par09         	// So Livro/Livro e Termos/So Termos    
Private  nPPlan 	//³ mv_par10         	// Imprime Plano de contas      Si/No         
Private  nPImp0	 	//³ mv_par11         	// Imprime Valor 0.00	                
Private  nPLinD 	//³ mv_par12            // Num.linhas p/ o diario?				 
Private  nPSalta 	//| mv_par13               Salta linha entre contas?            
Private  cPDesMnd 	//| mv_par14               Descricao na Moeda?                  
Private nPSelFil 	//| mv_par15               Seleciona Filiais?					
Private nPTipPrc	 //| mv_par16               ¿Genera ?  Archivo TXT/Informe			      	
Private cPRuta  	//| mv_par17               ¿Directorio?					
Private oReport
If Pergunte( cPerg , .T. )



	dPFecIni	:= mv_par01  	      	// Data Inicial                         
	dPFecFin	:= mv_par02            // Data Final                            
	cPMon 		:= mv_par03            // Moeda?                                
    cPLibro		:= mv_par04				// Set Of Books		
    cPTPSld 	:= mv_par05				// Tipo Saldo? Real / Orcad / Gerenc / Pre
    nPPagIni 	:= mv_par06  	      	// Pagina Inicial                        
    nPPagFin 	:= mv_par07         	// Pagina Final                          
    nPPagRei 	:= mv_par08         	// Pagina ao Reiniciar                   
    nPTipLibr	:= mv_par09         	// So Livro/Livro e Termos/So Termos     
    nPPlan 		:= mv_par10         	// Imprime Plano de contas                
    nPImp0 		:= mv_par11         	// Imprime Valor 0.00	                 
    nPLinD 		:= mv_par12            // Num.linhas p/ o diario?				  
    nPSalta 	:= mv_par13            //   Salta linha entre contas?             
    cPDesMnd 	:= mv_par14             //  Descricao na Moeda?                   
    nPSelFil 	:= mv_par15            //  Seleciona Filiais?					 
    nPTipPrc 	:= mv_par16             // ¿Genera ?  Archivo TXT/Informe		      		 
    cPRuta   	:= mv_par17               //¿Directorio?
    
    
    
    IF nPTipPrc == 1 // Genera Archivo txt

		If nPPlan == 1 //Imprime plan de ctas?= Si  
			Processa({|| GerArqL1(AllTrim(cPRuta)) },"Generando Archivo del Plan de Cuentas...") //"Procesando..." 
		Endif
		
		Processa({|| GerArq(AllTrim(cPRuta)) },"Generando Archivo TXT...") //"Procesando..." 
				
	endif	
    
    //If FindFunction("TRepInUse") .And. TRepInUse()
 	if nPTipPrc==2 //Imprime Informe
		oReport := ReportDef()      
  		oReport:PrintDialog()
	endif	
	//EndIf				
 endif
 


cFilAnt := cFilIni
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Patricia Ikari    	³ Data ³ 28/10/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Esta funcao tem como objetivo definir as secoes, celulas,   ³±±
±±³          ³totalizadores do relatorio que poderao ser configurados     ³±±
±±³          ³pelo relatorio.                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGACTB                                    				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()  

Local aArea	   		:= GetArea()   
Local CREPORT		:= "CTBR118"
Local CTITULO		:= OemToAnsi(STR0006)										// Emissao do Livro Diario Geral
Local CDESC			:= OemToAnsi(STR0001)+OemToAnsi(STR0002)+OemToAnsi(STR0003)	// 'Este programa imprimira el Libro Diario, de acuerdo' # 'con los parametros sugeridos por el usuario. Este modelo es ideal' # 'para Plan de Cuentas que tengan codigos poco extensos.' 

Local cSeparador    := ""
Local cMoeda		:= ""
Local aCtbMoeda		:= {}
Local lRet		 	:= .T. 
Local cQuery		:= "" 
Local cFilCt1		:= ""   

private cFilSF3 	:= XFILIAL('SF3')
private cFilSE2 	:= XFILIAL('SE2')


DEFAULT aSelFil		:= {}

lPrintZero	:= .f.	
    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)		     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// faz a validação do livro
if lRet .And. !Empty( cPLibro ) 
	if ! VdSetOfBook( cPLibro , .F. )
		lRet := .F.
	endif
Endif

IF lRet
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seta o Livro											 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	aSetOfBook := CTBSetOf(cPLibro)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seta a Moeda		 									 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	aCtbMoeda	:= CtbMoeda(cPMon)
	If Empty(aCtbMoeda[1])
		Help(" ",1,"NOMOEDA")
		lRet := .F.
	EndIf	
Endif

If lRet .And. nPSelFil == 1 .And. Len( aSelFil ) <= 0
	aSelFil := AdmGetFil()
	If Len( aSelFil ) <= 0
		lRet := .F.
	EndIf
Else
	aSelFil := {cFilAnt} 
EndIf 
	
If !lRet	
	Set Filter To
	Return
EndIf

cMoeda		:= cPMon
cDescMoeda 	:= aCtbMoeda[2]
nDecimais 	:= DecimalCTB(aSetOfBook,cMoeda)

If Empty(aSetOfBook[2])
	cMascara := GetMv("MV_MASCARA")
Else
	cMascara := RetMasCtb(aSetOfBook[2],@cSeparador)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mascara do valor                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPicture 	:= aSetOfBook[4]
If Empty( cPicture ) .Or. cPicture == Nil
	cPicture := "@E " + TmContab(CT2->CT2_VALOR,aTamVal[1],nDecimais)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


oReport	:= TReport():New( CREPORT,CTITULO,cPerg, { |oReport| ReportPrint( oReport, cPicture, nDecimais, cMascara, cSeparador, cDescMoeda ) }, CDESC ) 
oReport:SetTotalInLine(.F.)
oReport:EndPage(.T.)

oReport:SetPortrait(.T.)
//oReport:DisableOrientation(.T.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
                

nTamQuebra := 178

oSection1  := TRSection():New( oReport, STR0007, {"TMP"},,.F.,.F.,,,,,,,,,,.T./*AutoAjuste*/,)    //"Totalizadores Data / Geral"   
TRCell():New( oSection1, "DATA"    		,/*Alias*/, /*Titulo*/,/*Picture*/,nTamQuebra)
TRCell():New( oSection1, "CDEBITO"		,		  ,/*STR0022*/,/*Picture*/,20,/*lPixel*/,/*CodeBlock*/,"CENTER",,"CENTER")	//"Vlr.Debito"
TRCell():New( oSection1, "CCREDITO"		,	   	  ,/*STR0023*/,/*Picture*/,20,/*lPixel*/,/*CodeBlock*/,"CENTER",,"CENTER")	//"Vlr.Credito"

oSection1:Cell("CDEBITO"):lHeaderSize	:= .F.
oSection1:Cell("CCREDITO"):lHeaderSize	:= .F.
oSection1:SetHeaderSection(.F.)  


	oSection2  := TRSection():New( oReport, STR0008 , {"TMP"},, .F., .F.,,,,,,,,,,.F./*AutoAjuste*/, )    //"Lancamentos Contabeis"
	TRCell():New( oSection2, "DOCTO"    	,"",STR0028 + CRLF + STR0029 + CRLF + STR0030 + CRLF + STR0031 + CRLF + STR0032 + CRLF + STR0033	,/*Picture*/,15	,/*lPixel*/,/*CodeBlock*/,"CENTER" 	,		,"CENTER") //"Número" # "Correlativo" # "del Asiento" # "o código" # "único de la" # "operación"     
	TRCell():New( oSection2, "DATA"	  		,"",STR0034 + CRLF + STR0035 + CRLF + STR0033						   	   							,/*Picture*/,12	,/*lPixel*/,/*CodeBlock*/,"CENTER" 	,		,"CENTER") //"Fecha" # "de la " # "operación"
	TRCell():New( oSection2, "DESCOP"	  	,"",STR0036		           																			,/*Picture*/,30	,/*lPixel*/,/*CodeBlock*/,"LEFT"	,/*LImp2lineas*/	,"LEFT"	 ) //"Glosa o descripción de la operación "
	TRCell():New( oSection2, "CODLIBRO"		,"",STR0037 + CRLF + STR0038 + CRLF + STR0039														,/*Picture*/,12	,/*lPixel*/,/*CodeBlock*/,"CENTER" 	,		,"CENTER") //"Codigo del" # " libro " # "o registro"
	TRCell():New( oSection2, "CORREL"	  	,"",STR0028 + CRLF + STR0029																		,/*Picture*/,14	,/*lPixel*/,/*CodeBlock*/,"CENTER" 	,		,"CENTER") //"Numero" # "correlativo"
	TRCell():New( oSection2, "DOCUM"    	,"",STR0040 + CRLF + STR0041 + CRLF + STR0042														,/*Picture*/,17	,/*lPixel*/,/*CodeBlock*/,"CENTER" 	,		,"CENTER") //"Número del " # "documento" # "sustentario"
	TRCell():New( oSection2, "CONTA"		,"",STR0043																							,/*Picture*/,20	,/*lPixel*/,/*CodeBlock*/,"CENTER" 	,  	 	,"CENTER") //"Código"
	TRCell():New( oSection2, "DESC01"		,"",STR0044																							,/*Picture*/,30	,/*lPixel*/,/*CodeBlock*/,"LEFT"	,/*LImp2lineas*/	,"CENTER") //"Denominación"
	TRCell():New( oSection2, "CVALDEB"		,"",STR0045																							,/*Picture*/,20	,/*lPixel*/,/*CodeBlock*/,"CENTER"	,  		,"CENTER") //"Vlr.Debito"
	TRCell():New( oSection2, "CVALCRED"		,"",STR0046						   																	,/*Picture*/,20	,/*lPixel*/,/*CodeBlock*/,"CENTER"	,		,"CENTER") //"Vlr.Credito"

	oSection2:Cell("DOCTO"):lHeaderSize  	:= .F.
	oSection2:Cell("DATA"):lHeaderSize  	:= .F. 
	oSection2:Cell("DESCOP"):lHeaderSize  	:= .F.
	oSection2:Cell("CODLIBRO"):lHeaderSize 	:= .F.
	oSection2:Cell("CORREL"):lHeaderSize  	:= .F.
	oSection2:Cell("DOCUM"):lHeaderSize  	:= .F.
	oSection2:Cell("CONTA"):lHeaderSize 	:= .F.
	oSection2:Cell("DESC01"):lHeaderSize 	:= .F.
	oSection2:Cell("CVALDEB"):lHeaderSize  	:= .F.
	oSection2:Cell("CVALCRED"):lHeaderSize 	:= .F.
	oSection2:SetLinesBefore(0)	
	

 
oSection3  :=  TRSection():New( oReport, STR0023 , {"TMP"},, .F., .F.,,,,,,,,,,.F./*AutoAjuste*/, )    //"Cabeçalho dos itens"	
TRCell():New( oSection3, " "		,		,		,/*Picture*/,76,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"")
TRCell():New( oSection3, "TIT1"		,		,STR0023,/*Picture*/,45,/*lPixel*/,/*CodeBlock*/,"LEFT",,"") //"Referencia de la operacion"
TRCell():New( oSection3, "TIT2"		,		,STR0024,/*Picture*/,70,/*lPixel*/,/*CodeBlock*/,"LEFT",,"") //"Cuenta contable asociada a la operacion"
TRCell():New( oSection3, "TIT3"		,		,STR0025,/*Picture*/,51,/*lPixel*/,/*CodeBlock*/,"LEFT",,"") //"Movimiento"

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³ Patricia Ikari   	³ Data ³ 28/10/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Imprime o relatorio definido pelo usuario de acordo com as  ³±±
±±³          ³secoes/celulas criadas na funcao ReportDef definida acima.  ³±±
±±³          ³Nesta funcao deve ser criada a query das secoes se SQL ou   ³±±
±±³          ³definido o relacionamento e filtros das tabelas em CodeBase.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ReportPrint(oReport)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³EXPO1: Objeto do relatório                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint( oReport, cPicture, nDecimais, cMascara, cSeparador, cDescMoeda )  

Local oSection1 	:= oReport:Section(1)     
Local oSection2 	:= oReport:Section(2)     
Local oSection3 	:= oReport:Section(3)  

Local lImpLivro		:= .T.                         
Local lImpTermos	:= .F.

Local i				:= 0
Local nLinReport    := 8
Local nMaxLin		:= nPLinD
Local lSalLin 		:= Iif(nPSalta==1,.T.,.F.)  //ojo
Local lResetPag		:= .T.
Local m_pag			:= 1 // controle de numeração de pagina
Local l1StQb		:= .T.  
Local nPagIni		:= nPPagIni
Local nPagFim		:= nPPagFin
Local nReinicia		:= nPPagRei
Local nBloco		:= 0
Local nBlCount		:= 1  
Local nPaginas      := nPPagIni //ojo          
Local lNovoDoc		:= .T.  
Local nToDocC		:= 0 
Local nToDocD		:= 0
Local nGeralC		:= 0
Local nGeralD		:= 0
Local lFim			:= .F.
Local nK			:= 0  
Local cFilOld	    := cFilAnt
Local aArea			:= GetArea()
Local aAreaSM0		:= SM0->(GetArea())
Local dDt			:= ''

	If !Empty( oReport:uParam )
		Pergunte( oReport:uParam, .F. )
	EndIf
	dPFecIni	:= mv_par01  	      	// Data Inicial                         
	dPFecFin	:= mv_par02            // Data Final                            
	cPMon 		:= mv_par03            // Moeda?                                
    cPLibro		:= mv_par04				// Set Of Books		
    cPTPSld 	:= mv_par05				// Tipo Saldo? Real / Orcad / Gerenc / Pre
    nPPagIni 	:= mv_par06  	      	// Pagina Inicial                        
    nPPagFin 	:= mv_par07         	// Pagina Final                          
    nPPagRei 	:= mv_par08         	// Pagina ao Reiniciar                   
    nPTipLibr	:= mv_par09         	// So Livro/Livro e Termos/So Termos     
    nPPlan 		:= mv_par10         	// Imprime Plano de contas                
    nPImp0 		:= mv_par11         	// Imprime Valor 0.00	                 
    nPLinD 		:= mv_par12            // Num.linhas p/ o diario?				  
    nPSalta 	:= mv_par13            //   Salta linha entre contas?             
    cPDesMnd 	:= mv_par14             //  Descricao na Moeda?                   
    nPSelFil 	:= mv_par15            //  Seleciona Filiais?					 
						 
	


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao de Termo / Livro                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
	Case nPTipLibr == 1 ; lImpLivro := .T. ; lImpTermos := .F.
	Case nPTipLibr == 2 ; lImpLivro := .T. ; lImpTermos := .T.
	Case nPTipLibr == 3 ; lImpLivro := .F. ; lImpTermos := .T.      
EndCase		                                                  

aSetOfBook := CTBSetOf(cPLibro)
cPicture 	:= aSetOfBook[4]
If Empty( cPicture ) .Or. cPicture == Nil
	cPicture := "@E " + TmContab(CT2->CT2_VALOR,aTamVal[1],nDecimais)
Endif        


Cursorwait()

QryCT2() //Hace consulta

Count to nTotREg

CursorArrow()

oReport:SetMeter(nTotREg)
 




DBSELECTAREA('TMP')
TMP->(DBGoTop())
              
For nK := 1 to Len(aSelFil)
			cFilAnt := aSelFil[nK]
			SM0->(MsSeek(cEmpAnt+cFilAnt))
			
			
			If lImpLivro
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//| titulo do relatorio                                          |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				titulo := OemToAnsi(STR0013) + DTOC(dPFecIni) + OemToAnsi(STR0014) + DTOC(dPFecFin) + OemToAnsi(STR0015) + cDescMoeda + CtbTitSaldo(cPTPSld) //' LIBRO DIARIO GENERAL DE' # ' A ' # '  EN ' 
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//| cabeçalho do relatorio                                       |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If cPaisLoc == "PER" .and. FindFunction("CabRelPer")    
					titulo := STR0020	// ##'FORMATO 5.1: "LIBRO DIARIO"' 
					oReport:SetCustomText( {|| (Pergunte(cPerg,.F.),CabRelPer( ,,,,,dPFecFin,oReport:Title(),,,,,oReport,.T.,@lResetPag,@nPagIni,@nPagFim,@nReinicia,@m_pag,@nBloco,@nBlCount,@l1StQb,dPFecIni,Titulo)) } )
				Else	
					oReport:SetCustomText( {|| (Pergunte(cPerg,.F.),CtCGCCabTR(,,,,,dPFecFin,titulo,,,,,oReport,.T.,@lResetPag,@nPagIni,@nPagFim,@nReinicia,@m_pag,@nBloco,@nBlCount,@l1StQb)) } )
				EndIf	
				
				oSection1:OnPrintLine( {|| CTR118Maxl( nMaxLin, @nLinReport, cPicture )} )
				
				oSection2:Cell("DOCTO")	  :SetBlock( { || TMP->CT2_SEGOFI})
				oSection2:Cell("DATA")	  :SetBlock( { || TMP->CT2_DATA } )
				oSection2:Cell("DESCOP")  :SetBlock( { || (StrTran(StrTran(StrTran(TMP->CT2_HIST,"/"," "),"\"," "),"|"," ")) } )
				oSection2:Cell("CODLIBRO"):SetBlock( { || ALLTRIM(STR(VAL(TMP->CT2_DIACTB))) })
				oSection2:Cell("CORREL")  :SetBlock( { || "M"+ Strzero(val(TMP->CT2_LINHA),9) /*getxLinea()*/ })
				 
				oSection2:Cell("CONTA" )  :SetBlock( { || EntidadeCTB(TMP->CT1_CONTA,0,0,nTamConta,.F.,cMascara,cSeparador,,,,,.F.) } )
				oSection2:Cell("DESC01")  :SetBlock( { || TMP->CT1_DESC01 })
				oSection2:Cell("CVALDEB" ):SetBlock( { || ValorCTB( if( TMP->CT1_CONTA == TMP->CT2_DEBITO,TMP->CT2_VALOR , 0 ) ,,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.)})
				oSection2:Cell("CVALCRED"):SetBlock( { || ValorCTB( if( TMP->CT1_CONTA == TMP->CT2_CREDITO,TMP->CT2_VALOR ,0 ) ,,,aTamVal[1],nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.)})
				
			
				oSection1:Cell("DATA"):SetBlock( { || Iif( lFim, STR0016, Iif (lNovoDoc, "", "Total por Asiento"))}) //' Total General============> ' # ' Fecha ' # ' Total por Fecha '
				oSection1:Cell("CDEBITO"):SetBlock( { || Iif( lFim, ValorCTB( nGeralD,,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.), Iif(lNovoDoc, nil,;
							ValorCTB( nToDocD,,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.)))})
				
				oSection1:Cell("CCREDITO"):SetBlock( { || Iif( lFim, ValorCTB( nGeralC,,,aTamVal[1],nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.), Iif(lNovoDoc, nil,;
							ValorCTB( nToDocC,,,aTamVal[1],nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.)))})
				
			    oSection1:PrintLine() 
				
				While TMP->(!Eof())
			   	
					_aDocOrig := u_fDocOri(TMP->CT2_KEY,TMP->CTL_ALIAS,TMP->CTL_ORDER,TMP->CT2_LP)
					oSection2:Cell("DOCUM"):SetValue( if(!empty(_aDocOrig[1][3]),_aDocOrig[1][3],_aDocOrig[1][2])+"-"+_aDocOrig[1][4]) //Serie  Doc
					
					
					dDt := TMP->CT2_SEGOFI
					lNovoDoc := .T.    
					nToDocC  := 0
					nToDocD  := 0
					nTransC  := 0
		   			nTransD  := 0
				
					oSection1:Init() 
					oSection1:PrintLine()
					oSection1:Finish()
					
					oSection3:Init()   
			   		oSection3:PrintLine() 
			 		oSection3:Finish()
					
					oSection2:Init()
			
					
					While  TMP->(!Eof()) .and. TMP->CT2_SEGOFI == dDt
						
						If oReport:Cancel()
							Exit
						EndIf
						lNovoDoc := .F.
						oSection2:PrintLine()
						
						
						If TMP->CT1_CONTA == TMP->CT2_DEBITO
							nToDocD += TMP->CT2_VALOR
							nTransD += TMP->CT2_VALOR
							nGeralD += TMP->CT2_VALOR
						EndIf
						
						If TMP->CT1_CONTA == TMP->CT2_CREDITO
							nToDocC += TMP->CT2_VALOR
							nTransC += TMP->CT2_VALOR
							nGeralC += TMP->CT2_VALOR
						EndIf
		
						TMP->(dbSkip())
					EndDo
		
					oSection2:Finish()	
					
					oSection1:Init() 
					oSection1:PrintLine()
					oSection1:Finish()
					nLinReport++
					oReport:IncMeter()
				EndDo  
				
				lFim := .T.
			 	oSection1:Init()
				oSection1:PrintLine()
				oSection1:Finish()  			
		
			Endif   	
			oReport:EndPage()
Next

nGeralD := 0
nGeralC	:= 0
lFim := .F.



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressão do Plano de Contas                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If nPPlan == 1 //Imprime plan de ctas?= Si  
	Ctbr010R4( cPMon )	
	GerArqL1(AllTrim(cPRuta))	
Endif



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao dos Termos                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lImpTermos 		
	oReport:HideHeader()
	oSection2:Hide()

	cArqAbert:=GetMv("MV_LDIARAB")
	cArqEncer:=GetMv("MV_LDIAREN")

	dbSelectArea("SM0")
	aVariaveis:={}

	For i:=1 to FCount()	
		If FieldName(i)=="M0_CGC"
			AADD(aVariaveis,{FieldName(i),Transform(FieldGet(i),"@R 99.999.999/9999-99")})
		Else
            If FieldName(i)=="M0_NOME"
                Loop
            EndIf
			AADD(aVariaveis,{FieldName(i),FieldGet(i)})
		Endif
	Next

	dbSelectArea("SX1")
	dbSeek( padr(cPerg , Len( X1_GRUPO ) , ' ' ) + "01" )

	While ! Eof() .And. SX1->X1_GRUPO  == padr( cPerg , Len( X1_GRUPO ) , ' ' )
		AADD(aVariaveis,{Rtrim(Upper(X1_VAR01)),&(X1_VAR01)})
		dbSkip()
	End

	If AliasIndic( "CVB" )
		dbSelectArea( "CVB" )
		CVB->(MsSeek( xFilial( "CVB" ) ))
		For i:=1 to FCount()
			If FieldName(i)=="CVB_CGC"
				AADD(aVariaveis,{FieldName(i),Transform(FieldGet(i),"@R 99.999.999/9999-99")})
			ElseIf FieldName(i)=="CVB_CPF"
				AADD(aVariaveis,{FieldName(i),Transform(FieldGet(i),"@R 999.999.999-99")})
			Else
				AADD(aVariaveis,{FieldName(i),FieldGet(i)})
			Endif
		Next
	EndIf

	AADD(aVariaveis,{"M_DIA",StrZero(Day(dDataBase),2)})
	AADD(aVariaveis,{"M_MES",MesExtenso()})
	AADD(aVariaveis,{"M_ANO",StrZero(Year(dDataBase),4)})

	If !File(cArqAbert)
		aSavSet:=__SetSets()
		cArqAbert:=CFGX024(,STR0054) // Editor de Termos de Livros - "Diario Geral."
		__SetSets(aSavSet)
		Set(24,Set(24),.t.)
	Endif

	If !File(cArqEncer)
		aSavSet:=__SetSets()
		cArqEncer:=CFGX024(,STR0054) // Editor de Termos de Livros - "Diario Geral."
		__SetSets(aSavSet)
		Set(24,Set(24),.t.)
	Endif

	If cArqAbert#NIL
		oReport:EndPage()
		ImpTerm2(cArqAbert,aVariaveis,,,,oReport)		
	Endif

	If cArqEncer#NIL
		oReport:EndPage()
		ImpTerm2(cArqEncer,aVariaveis,,,,oReport)
	Endif	 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Cabeçalho do Relatorio                                       |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:EndPage()
	oReport:ShowHeader()
	oSection2:Show()

Endif

cFilAnt := cFilOld
RestArea(aAreaSM0)	
RestArea(aArea)		
TMP->(DbCloseArea()) 
CtbTmpErase(cTmpCT1Fil)
CtbTmpErase(cTmpCT2Fil)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |CTR118MaxL    ºAutor ³ Renato F. Campos º Data ³ 01/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Faz a quebra de pagina de acordo com o parametro passado   º±±
±±º          ³ no relatorio.                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPL1 - Numero maximo de linhas definido no relatorio      º±±
±±º          ³ EXPL2 - Contador de linhas impressas no relatorio          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ nil                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Diario Geral                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/           
Static Function CTR118MaxL(nMaxLin,nLinReport, cPicture )
Local oSection1 	:= oReport:Section(1)     
Local oSection2 	:= oReport:Section(2)   
Local oSection3 	:= oReport:Section(3)   

Local nMaxLin1       

nMaxLin1 := nMaxLin   

If oSection1:Printing()
	nLinReport += 2
Else
	nLinReport++
Endif

If nLinReport > nMaxLin1 - 2
	If nTransC > 0 .OR. nTransD > 0 	
	
		oSection3:Init()
  		oSection3:Printline() 
		oSection3:Finish()
	  
		oSection2:Init()
  		oSection2:Printline() 
		oSection2:Finish()
		
		oReport:EndPage()
		
		nLinReport := 11 	
		
		oSection3:Init()
		oSection3:Printline() 
		oSection3:Finish()
		
		oSection2:Init()
		oSection2:Printline() 
		oSection2:Finish()

		oReport:Skipline() 
		
    Else     
  		nLinReport := 9  	                      
 		oReport:EndPage() 	
	EndIf 	       
EndIf   

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao     ³ GerArq   ³ Autor ³ Marivaldo           ³ Data ³ 23.04.2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao  ³ Gera o arquivo magnético do Diario contabil                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Parametros ³ cDir - Diretorio de criacao do arquivo.                    ³±±
±±³            ³ cArq - Nome do arquivo com extensao do arquivo.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno    ³ Nulo                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ Fiscal Peru - Diario contabil - Arquivo Magnetico          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GerArq(cDir)

private nHdl    := 0
private cLin    := ""
private cSep    := "|"
private cArq    := ""
private nCont   := 0
private cHist   := ""
private cFilSYF := xFilial("SYF")
private _cCliPad:= getMV("MV_CLIPAD") //Codigo de Cliente ESTANDAR para Cheques diferidos
private cDocX   := space(TAMSX3("F2_DOC")[1])
private cOserie :=""
private cTienda :=""
private cOtienda:=""
private cMovtip :=""
private cEspecie:=""
private cVcto   :=""
private dBaixa  := Ctod("  /  /  ")
private dFecha  := Ctod("  /  /  ")
private nDetra  := 0
private cFilSF3 :=""
private dFechsf3:=Ctod("  /  /  ")     
private cPrefixo :=""
private cNumero  :=""
private cParcela :=""
private cTipo    :=""
private dSfefecha:=Ctod("  /  /  ")  
private nPos     := 0
private aRet     := {}  
private cDctb	   :="" 
private cF1doc   :=""
private cF1tienda:=""
private cLbSiDom := getNewPar("MV_LFSDOM","080100")
private cLbNoDom := getNewPar("MV_LFNDOM","080200")
private cLbVenta := getNewPar("MV_LFVENT","140100")
private cCodLibr := ""
private aTID:={}
private nTotREg:=0

Private cMesInic := ""
Private cAnoInic := ""
Private cMesFin := ""
Private cAnoFin := ""
Private dDUtilInic:= Ctod("  /  /  ")
Private dDUtilFin := Ctod("  /  /  ")
Private cMV_1DUP  := padr(SuperGetMV("MV_1DUP",,"1"),TamSx3("E5_PARCELA")[1])
 
cdir:=SUBSTR(cDir,1,rat("\",cdir)) //limpia si hay algun nombre de archivo en la ruta 

//Nombre del archivo
cArq += "LE"                            // Fixo  'LE'
cArq +=  AllTrim(SM0->M0_CGC)           // Ruc
cArq +=  AllTrim(Str(Year(dPFecIni)))   // Ano
cArq +=  AllTrim(Strzero(Month(dPFecIni),2))  // Mes
cArq +=  "00"                            // Fixo '00'
cArq += "050100"                         // Fixo '060100'
cArq += "00"                             // Fixo '00'
cArq += "1"
cArq += "1"
cArq += "1"
cArq += "1"
cArq += ".TXT" // Extensao

nHdl := fCreate(cDir+cArq,0,Nil,.F.)

If nHdl <= 0
	ApMsgStop(STR0055) //"Ha ocurrido un error durante la generación del archivo. Intente nuevamente."
	Return Nil
endif

IncProc("Seleccionando información...") // "Obteniendo informacion..."

QryCT2() //Crea Query

Count to nTotREg //Cuenta los registros a procesar

TMP->(DBGoTop())

ProcRegua(nTotREg)
			
DBSELECTAREA('TMP')
        
Do While TMP->( !Eof() )
	IncProc()
	
	aTID := {}
	_aDocOrig := {}
	_aDocOrig := u_fDocOri(TMP->CT2_KEY,TMP->CTL_ALIAS,TMP->CTL_ORDER,TMP->CT2_LP)  //Obtiene informacion de las facturas o documentos relacionados al asiento
	
	if empty(_aDocOrig[1,5]) .And. empty(_aDocOrig[1,9])
		Aadd( aTID, { "","","","" } )
	else
		aTID:= u_fFindA12( _aDocOrig[1,5],_aDocOrig[1,9],_aDocOrig[1,6] ) //Obtiene el tipo de Identificacion del cliente o del proveedor
	endif
		
	If TMP->CT2_DEBITO == TMP->CT2_CREDITO  //Cargo y abono en el mismo movimiento (tipo 3)
            	
				cLin:=""
				//01 - Periodo
				cLin += SubStr(DTOS(dPFecIni),1,6)+"00"
				cLin += cSep
				
				//02 - Num correlativo
				cLin += AllTrim(TMP->CT2_SEGOFI)
				cLin += cSep
			

				//03 - M+Num correlativo
				cCodLibr:=''
				if left(AllTrim(TMP->CT2_SEGOFI),2)=="14"
						cCodLibr := cLbVenta
				elseif left(AllTrim(TMP->CT2_SEGOFI),2)=="08"
		
						
					   	if  !empty(aTID[1,4])
			   				if aTID[1,4]=='1'	// domiciliados
								cCodLibr := cLbSiDom
							else
								cCodLibr := cLbNoDom
							EndIf
						endif
				endif
				
		
				cContAux := "M"+ Strzero(val(TMP->CT2_LINHA),9)
				cLin += cContAux
				cLin += cSep
		
				//04 - Codigo da conta contabil
				cLin += AllTrim(TMP->CT1_CONTA)
				cLin += cSep
				
				//05 - Código de la Unidad de Operación, de la Unidad Económica Administrativa, de la Unidad de Negocio, de la Unidad de Producción
				cLin += ""
				cLin += cSep
				
				//06 - Código del Centro de Costos, Centro de Utilidades o Centro de Inversión, de corresponder
				cLin += If(empty(TMP->CT2_CCD),TMP->CT2_CCC,TMP->CT2_CCD)
				cLin += cSep
				
				//07 - Tipo de Moneda de origen (TABLA 4)											
				If SYF->(MsSeek(cFilSYF+(GetMV("MV_SIMB"+AllTrim(STR(VAL(TMP->CT2_MOEDLC))))))) 
					if !Empty(AllTrim(SYF->YF_ISO))			
						cLin += AllTrim(SYF->YF_ISO)
					else
						cLin += ""
					endif
				else
					cLin += ""
				EndIf					   				       
				cLin += cSep 					

				ctipDoc:="00";	cSerieN:= ""
				
				If len(_aDocOrig)>0
					cTipDoc := alltrim(_aDocOrig[1,1])
					cSerieN := if(!empty(_aDocOrig[1,3]),_aDocOrig[1,3],_aDocOrig[1,2])
				EndIf
				//08 - tipo de documento de identidad del emisor
				_cTpDocCli := ""
				If len(_aDocOrig)>0
					_cTpDocCli := aTID[1,1]
					If alltrim( aTID[1,2])$_cCliPad	  //"99999999999/00000000000"
						cLin += "0"
					ElseIf alltrim( aTID[1,3])$_cCliPad//"99999999999/00000000000"
						cLin += "0"
					Else
						cLin += iif(empty(_cTpDocCli),"0",_cTpDocCli)
					EndIf
				Else
					cLin += "0"
				EndIf
				cLin += cSep			
				
				//09 - numero de documento de identidad del emisor
				cFornece:=''
				If len(_aDocOrig)>0
					If _cTpDocCli$"0/1"
						cLin += if(empty(aTID[1,2]),"00000000000",aTID[1,2]) // fisica
						cFornece:=_aDocOrig[1][5]  
					Else 
						If empty(_aDocOrig[1][4])
							cLin += "00000000000"
						Else						
							cLin += if(empty(aTID[1,3]),"00000000000",aTID[1,3]) // juridica
							cFornece:=_aDocOrig[1][5] 						
						EndIf
					EndIf
				Else
					cLin += "00000000000"
				EndIf
				cLin += cSep
				
				//10 - Tipo de Comprobante de Pago o Documento asociada a la operación, de corresponder				

				cLin += iif(AllTrim(cTipDoc)=="","00",AllTrim(cTipDoc))
				cLin += cSep
								
				//11 - Número de serie del comprobante de pago o documento asociada a la operación, de corresponder							
				
				cTipDoc:=Alltrim(cTipDoc)
				cSerieNf:=Alltrim(cSerieN)

				If !(cTipDoc $ "50|05")
					If Len(cSerieNf)<=3
						if left(cSerieNf,1)$"E/F/B"
							cSerieNf := left(cSerieNf,1)+"0"+right(cSerieNf,2)
						elseif substr(cSerieNf,2,1)$"E/F/A/B/C/D"
							cSerieNf := left(cSerieNf,2)+"0"+right(cSerieNf,1)
						else
							cSerieNf := Replicate("0",4-Len(cSerieNf))+cSerieNf
						endif
					EndIf
				else
					If Len(cSerieNf)<=3 .And. alltrim(cSerieNf)=="000"
						cSerieNf := "0000"
					else
						cSerieNf := right(cSerieNf,3)
					endif
				EndIf
		
				If cTipDoc == "00" .Or. empty(cTipDoc)
					cLin += "0000"
				Else
					cLin += AllTrim(cSerieNf)
				EndIf
				cLin += cSep
				
				//12 - Número del comprobante de pago o documento asociada a la operación
				cDocX := space(TamSX3("F2_DOC")[1])
				If len(_aDocOrig)>0
					If empty(_aDocOrig[1][4])
						cLin += "0000"
					Else
						cLin += right(alltrim(_aDocOrig[1][4]),8)
						cDocX := _aDocOrig[1][4]
					EndIf
				Else
					cLin += "0000" 
				EndIf
				cLin += cSep				
								
				//13 - Fecha contable
				cLin += SubStr(DTOC(TMP->CT2_DATA),1,6)+SubStr(DTOS(TMP->CT2_DATA),1,4)	
				cLin += cSep
				
				//14 - Fecha de vencimiento
				cLin += ""
				cLin += cSep			
												
				//15  - Data da contabilizacao Fecha de la operación o emisión
				If len(_aDocOrig) > 0
					If empty(_aDocOrig[1][7])
						cLin += SubStr(DTOC(TMP->CT2_DATA),1,6)+SubStr(DTOS(TMP->CT2_DATA),1,4)
					Else
						cLin += dtoc( stod( _aDocOrig[1][7] ) )
					EndIf
				Else
					cLin += SubStr(DTOC(TMP->CT2_DATA),1,6)+SubStr(DTOS(TMP->CT2_DATA),1,4)
				EndIf
				cLin += cSep
				
				//16 - Historico. Glosa o descripción de la naturaleza de la operación registrada, de ser el caso.
				cHist := AllTrim(TMP->CT2_HIST)
				cLin += StrTran(StrTran(StrTran(cHist,"/"," "),"\"," "),"|"," ")
				cLin += cSep
				
				//17 - Glosa referencial, de ser el caso
				cLin += ""
				cLin += cSep
								
				//18  - Conta Debito
				cLin +=ALLTRIM(STR(TMP->CT2_VALOR,17,2))
				cLin += cSep
				
				//19 - Conta Credito
				cLin +='0.00'
				cLin += cSep
				
				//20 - Dato Estructurado: Código del libro, campo 1, campo 2 y campo 3 del Registro de Ventas e Ingresos o del Registro de Compras, 
				//separados con el carácter "&", de corresponder.
				if Left(AllTrim(TMP->CT2_SEGOFI),2)<>"99" .and. _aDocOrig[1][1]<>"02" .and. !empty(_aDocOrig[1][1]) //.And. alltrim(_aDocOrig[1,1])<>"07"
					cLin += u_fgenAnidado(cDocX,cFornece,mv_par01,mv_par02,cCodLibr,TMP->CT2_SEGOFI,cContAux,TMP->CT2_FILIAL)
				Else
					cLin += ""
				EndIf
				cLin += cSep
				
				//21 - Indica el estado de la operación
				cLin += '1'
				cLin += cSep
				
				cLin += chr(13)+chr(10)
				
				fWrite(nHdl,cLin)
								            	
				cLin:=""
				//01 - Periodo
				cLin += SubStr(DTOS(TMP->CT2_DATA),1,6)+"00"
				cLin += cSep
				
				//02 - Num correlativo
				cLin += AllTrim(TMP->CT2_SEGOFI)
				cLin += cSep
			

				//03 - M+Num correlativo
				cCodLibr := ''
				
				if left(AllTrim(TMP->CT2_SEGOFI),2)=="14"
					cCodLibr := cLbVenta
				elseif left(AllTrim(TMP->CT2_SEGOFI),2)=="08"
				   	if !empty(aTID[1,4])
		   				if aTID[1,4]=='1'	// domiciliados
							cCodLibr:= if ((aTID[1,4]=='1'),cLbSiDom,cLbNoDom)// domiciliados o no domiciliado
						EndIf
					endif
				endif
				
				//cContAux := "M"+getLinCCT2(AllTrim(TMP->CT2_SEGOFI),TMP->CT2_VALOR,TMP->CT1_CONTA)
				cContAux := "M"+ Strzero(val(TMP->CT2_LINHA),9)
				cLin += cContAux
				cLin += cSep
				
				//04 - Codigo da conta contabil
				cLin += AllTrim(TMP->CT1_CONTA)
				cLin += cSep
				
				//05 - Código de la Unidad de Operación, de la Unidad Económica Administrativa, de la Unidad de Negocio, de la Unidad de Producción
				cLin += ""
				cLin += cSep
				
				//06 - Código del Centro de Costos, Centro de Utilidades o Centro de Inversión, de corresponder
				cLin += If(empty(TMP->CT2_CCD),TMP->CT2_CCC,TMP->CT2_CCD)
				cLin += cSep
				
				//07 - Tipo de Moneda de origen (TABLA 4)											
				If SYF->(MsSeek(cFilSYF+(GetMV("MV_SIMB"+AllTrim(STR(VAL(TMP->CT2_MOEDLC))))))) 
					if !Empty(AllTrim(SYF->YF_ISO))			
						cLin += AllTrim(SYF->YF_ISO)
					else
						cLin += ""
					endif
				else
					cLin += ""
				EndIf					   				       
				cLin += cSep 					
								  
				ctipDoc:="00" ;		cSerieN:= ""

				If len(_aDocOrig)>0
					cTipDoc := alltrim(_aDocOrig[1][1])
					cSerieN := if(!empty(_aDocOrig[1][3]),_aDocOrig[1][3],_aDocOrig[1][2])
				EndIf	
					
				//08 - tipo de documento de identidad del emisor
				_cTpDocCli := ""
				If len(_aDocOrig)>0
					_cTpDocCli :=  aTID[1,1]
					If alltrim( aTID[1,2])$_cCliPad		//"99999999999/00000000000"
						cLin += "0"
					ElseIf alltrim( aTID[1,3])$_cCliPad	//"99999999999/00000000000"
						cLin += "0"
					Else
						cLin += iif(empty(_cTpDocCli),"0",_cTpDocCli)
					EndIf
				Else
					cLin += "0"
				EndIf
				cLin += cSep		
					
				//09 - numero de documento de identidad del emisor
				cFornece:=''
				If len(_aDocOrig)>0
					If _cTpDocCli$"0/1"
						cLin += if(empty(aTID[1,2]),"00000000000",aTID[1,2])
						cFornece:=_aDocOrig[1][5]  
					Else 
						If empty(_aDocOrig[1][4])
							cLin += "00000000000"
						Else						
							cLin += if(empty(aTID[1,3]),"00000000000",aTID[1,3])
							cFornece:=_aDocOrig[1][5] 						
						EndIf
					EndIf
				Else
					cLin += "00000000000"
				EndIf
				cLin += cSep
				
				//10 - Tipo de Comprobante de Pago o Documento asociada a la operación, de corresponder				
				cLin += iif(AllTrim(cTipDoc)=="","00",AllTrim(cTipDoc))
				cLin += cSep
								
				//11 - Número de serie del comprobante de pago o documento asociada a la operación, de corresponder							
				cTipDoc:=Alltrim(cTipDoc)	
				cSerieNf:=Alltrim(cSerieN)	
				
				If !(cTipDoc $ "50|05")
					If Len(cSerieNf)<=3
						if left(cSerieNf,1)$"E/F/B"
							cSerieNf := left(cSerieNf,1)+"0"+right(cSerieNf,2)
						elseif substr(cSerieNf,2,1)$"E/F/A/B/C/D"
							cSerieNf := left(cSerieNf,2)+"0"+right(cSerieNf,1)
						else
							cSerieNf := Replicate("0",4-Len(cSerieNf))+cSerieNf
						endif
					EndIf
				else
					If Len(cSerieNf)<=3 .And. alltrim(cSerieNf)=="000"
						cSerieNf := "0000"
					else
						cSerieNf := right(cSerieNf,3)
					endif
				EndIf

				If cTipDoc == "00" .Or. empty(cTipDoc)
					cLin += "0000"
				Else
					cLin += AllTrim(cSerieNf)
				EndIf
				cLin += cSep
				
				//12 - Número del comprobante de pago o documento asociada a la operación
				cDocX := space(TamSX3("F2_DOC")[1])
				If len(_aDocOrig)>0
					If empty(_aDocOrig[1][4])
						cLin += "0000"
					Else
						cLin += right(alltrim(_aDocOrig[1][4]),8)
						cDocX := _aDocOrig[1][4]
					EndIf
				Else
					cLin += "0000" //AllTrim(TMP->CT2_DOC)
				EndIf
				cLin += cSep		
					
				//13 - Fecha contable
				cLin += SubStr(DTOC(TMP->CT2_DATA),1,6)+SubStr(DTOS(TMP->CT2_DATA),1,4)	
				cLin += cSep
				
				//14 - Fecha de vencimiento
				cLin += ""
				cLin += cSep	
														
				//15  - Data da contabilizacao Fecha de la operación o emisión
				If len(_aDocOrig) > 0
					If empty(_aDocOrig[1][7])
						cLin += SubStr(DTOC(TMP->CT2_DATA),1,6)+SubStr(DTOS(TMP->CT2_DATA),1,4)
					Else
						cLin += dtoc( stod( _aDocOrig[1][7] ) )
					EndIf
				Else
					cLin += SubStr(DTOC(TMP->CT2_DATA),1,6)+SubStr(DTOS(TMP->CT2_DATA),1,4)
				EndIf
				cLin += cSep
				
				//16 - Historico. Glosa o descripción de la naturaleza de la operación registrada, de ser el caso.
				cLin += AllTrim(TMP->CT2_HIST)
				cLin += cSep
				
				//17 - Glosa referencial, de ser el caso
				cLin += ""
				cLin += cSep
								
				//18  - Conta Debito
				cLin +='0.00'
				cLin += cSep
				
				//19 - Conta Credito
				cLin +=ALLTRIM(STR(TMP->CT2_VALOR,17,2))
				cLin += cSep
								
				//20 - Dato Estructurado: Código del libro, campo 1, campo 2 y campo 3 del Registro de Ventas e Ingresos o del Registro de Compras, 
				//separados con el carácter "&", de corresponder.				
				if Left(AllTrim(TMP->CT2_SEGOFI),2)<>"99" .and. _aDocOrig[1][1]<>"02" .and. !empty(_aDocOrig[1][1]) //.And. alltrim(_aDocOrig[1,1])<>"07"
					cLin += u_fgenAnidado(cDocX,cFornece,mv_par01,mv_par02,cCodLibr,TMP->CT2_SEGOFI,cContAux,TMP->CT2_FILIAL)
				Else
					cLin += ""
				EndIf
				cLin += cSep
				
				//21 - Indica el estado de la operación
				cLin += '1'
				cLin += cSep
				
				cLin += chr(13)+chr(10)
				fWrite(nHdl,cLin)
				cLin:=""

	Else //De TMP->CT2_DEBITO == TMP->CT2_CREDITO
				
			
				cLin:=""
				//01 - Periodo
				cLin += SubStr(DTOS(TMP->CT2_DATA),1,6)+"00"
				cLin += cSep
				
				//02 - Num correlativo
				cLin += AllTrim(TMP->CT2_SEGOFI)
				cLin += cSep
								
			

				//03 - M+Num correlativo
				cCodLibr:=''
				if left(AllTrim(TMP->CT2_SEGOFI),2)=="14"
					cCodLibr := cLbVenta
				elseif left(AllTrim(TMP->CT2_SEGOFI),2)=="08"
				   	if !empty(aTID[1,4])
				   	 
		   				cCodLibr:= if (aTID[1,4]=='1',cLbSiDom,cLbNoDom)// domiciliados o no domiciliado
					endif
				endif
				
				cContAux := "M"+ Strzero(val(TMP->CT2_LINHA),9)
				cLin += cContAux
				cLin += cSep
				
				//04 - Codigo da conta contabil
				cLin += AllTrim(TMP->CT1_CONTA)
				cLin += cSep
				
				//05 - Código de la Unidad de Operación, de la Unidad Económica Administrativa, de la Unidad de Negocio, de la Unidad de Producción
				cLin += ""
				cLin += cSep
				
				//06 - Código del Centro de Costos, Centro de Utilidades o Centro de Inversión, de corresponder
				cLin += If(empty(TMP->CT2_CCD),TMP->CT2_CCC,TMP->CT2_CCD)
				cLin += cSep
				
				//07 - Tipo de Moneda de origen (TABLA 4)											
				If SYF->(MsSeek(cFilSYF+(GetMV("MV_SIMB"+AllTrim(STR(VAL(TMP->CT2_MOEDLC))))))) 
					if !Empty(AllTrim(SYF->YF_ISO))			
						cLin += AllTrim(SYF->YF_ISO)
					else
						cLin += ""
					endif
				else
					cLin += ""
				EndIf					   				       
				cLin += cSep 					
						  
				cTipDoc:="00";	cSerieN:= ""

				If len(_aDocOrig)>0
					cTipDoc := alltrim(_aDocOrig[1][1])
					cSerieN := if(!empty(_aDocOrig[1][3]),_aDocOrig[1][3],_aDocOrig[1][2])
				EndIf
				
				//08 - tipo de documento de identidad del emisor
				
				_cTpDocCli := ""
				If len(_aDocOrig)>0
					_cTpDocCli := aTID[1,1] 
					If alltrim(aTID[1,2])$_cCliPad	  //"99999999999/00000000000"
						cLin += "0"
					ElseIf alltrim(aTID[1,3])$_cCliPad//"99999999999/00000000000"
						cLin += "0"
					Else
						cLin += iif(empty(_cTpDocCli),"0",_cTpDocCli)
					EndIf
				Else
					cLin += "0"
				EndIf
				cLin += cSep		
						
				//09 - numero de documento de identidad del emisor
				cFornece:=''
				If len(_aDocOrig)>0
					If _cTpDocCli$"0/1"
						cLin += if(empty(aTID[1,2]),"00000000000",aTID[1,2])
						cFornece:=_aDocOrig[1][5]  
					Else 
						If empty(_aDocOrig[1][4])
							cLin += "00000000000"
						Else						
							cLin += if(empty(aTID[1,3]),"00000000000",aTID[1,3])
							cFornece:=_aDocOrig[1][5] 						
						EndIf
					EndIf
				Else
					cLin += "00000000000"
				EndIf
				cLin += cSep
				
				//10 - Tipo de Comprobante de Pago o Documento asociada a la operación, de corresponder	
			
				cLin += iif(AllTrim(cTipDoc)=="","00",AllTrim(cTipDoc))
				cLin += cSep
								
				//11 - Número de serie del comprobante de pago o documento asociada a la operación, de corresponder	
										
				
				cTipDoc:=Alltrim(cTipDoc)	
				cSerieNf:=Alltrim(cSerieN)	

				If !(cTipDoc $ "50|05")
					If Len(cSerieNf)<=3
						if left(cSerieNf,1)$"E/F/B"
							cSerieNf := left(cSerieNf,1)+"0"+right(cSerieNf,2)
						elseif substr(cSerieNf,2,1)$"E/F/A/B/C/D"
							cSerieNf := left(cSerieNf,2)+"0"+right(cSerieNf,1)
						else
							cSerieNf := Replicate("0",4-Len(cSerieNf))+cSerieNf
						endif
					EndIf
				else
					If Len(cSerieNf)<=3 .And. alltrim(cSerieNf)=="000"
						cSerieNf := "0000"
					else
						cSerieNf := right(cSerieNf,3)
					endif
				EndIf
				
				If cTipDoc == "00" .Or. empty(cTipDoc)
					cLin += "0000"
				Else
					cLin += AllTrim(cSerieNf)
				EndIf
				cLin += cSep
				
				//12 - Número del comprobante de pago o documento asociada a la operación
				cDocX := space(TamSX3("F2_DOC")[1])
				If len(_aDocOrig)>0
					If empty(_aDocOrig[1][4])
						cLin += "0000"
					Else
						cLin += right(alltrim(_aDocOrig[1][4]),8)
						cDocX := _aDocOrig[1][4]
					EndIf
				Else
					cLin += "0000" 
				EndIf
				cLin += cSep			
								
				//13 - Fecha contable
				cLin += SubStr(DTOC(TMP->CT2_DATA),1,6)+SubStr(DTOS(TMP->CT2_DATA),1,4)	
				cLin += cSep
				
				//14 - Fecha de vencimiento
				cLin += ""
				cLin += cSep			
												
				//15  - Data da contabilizacao Fecha de la operación o emisión
				If len(_aDocOrig) > 0
					If empty(_aDocOrig[1][7])
						cLin += SubStr(DTOC(TMP->CT2_DATA),1,6)+SubStr(DTOS(TMP->CT2_DATA),1,4)
					Else
						cLin += dtoc( stod( _aDocOrig[1][7] ) )
					EndIf
				Else
					cLin += SubStr(DTOC(TMP->CT2_DATA),1,6)+SubStr(DTOS(TMP->CT2_DATA),1,4)
				EndIf
				cLin += cSep
				
				//16 - Historico. Glosa o descripción de la naturaleza de la operación registrada, de ser el caso.
				cHist := AllTrim(TMP->CT2_HIST)
				cLin += StrTran(StrTran(StrTran(cHist,"/"," "),"\"," "),"|"," ") 
				cLin += cSep
				
				//17 - Glosa referencial, de ser el caso
				cLin += ""
				cLin += cSep
								
				//18  - Conta Debito
				cLin +=IIF( TMP->CT1_CONTA == TMP->CT2_DEBITO,ALLTRIM(STR(TMP->CT2_VALOR,17,2)) ,'0.00' )
				cLin += cSep
				
				//19 - Conta Credito
				cLin +=IIF( TMP->CT1_CONTA == TMP->CT2_CREDITO,ALLTRIM(STR(TMP->CT2_VALOR,17,2)) , '0.00'  )
				cLin += cSep
				
				//20 - Dato Estructurado: Código del libro, campo 1, campo 2 y campo 3 del Registro de Ventas e Ingresos o del Registro de Compras, 
				//separados con el carácter "&", de corresponder.							
				if Left(AllTrim(TMP->CT2_SEGOFI),2)<>"99" .and. _aDocOrig[1][1]<>"02" .and. !empty(_aDocOrig[1][1]) //.And. alltrim(_aDocOrig[1,1])<>"07"
					cLin += u_fgenAnidado(cDocX,cFornece,mv_par01,mv_par02,cCodLibr,TMP->CT2_SEGOFI,cContAux,TMP->CT2_FILIAL)
				Else
					cLin += ""
				EndIf
				cLin += cSep
				
				//21 - Indica el estado de la operación
				cLin += '1'
				cLin += cSep
				
				cLin += chr(13)+chr(10)
				
				fWrite(nHdl,cLin)
				
				cLin:=""
	ENDIF

	TMP->(dbSkip())

EndDo
TMP->(dbClosearea())
fClose(nHdl)
IF nTotReg==0
	MSGINFO("No existe información con los parametros seleccionados!.")
ELSE
	MSGINFO("Proceso Finalizado!!")
ENDIF	

Return Nil


/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao     ³ GerArqL1   ³                           ³ Data ³ 07.03.2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao  ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Parametros ³ cDir - Diretorio de criacao do arquivo.                    ³±±
±±³            ³ cArqL1 - Nome do arquivo com extensao do arquivo.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno    ³ Nulo                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ Fiscal Peru - Livro Diario 5.3 detalhe plano de contas     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/
Static Function GerArqL1(cDir)

Local nHdl    := 0
Local cLin    := ""
Local cSep    := "|"
Local cArq    := ""
Local nCont   := 0
Local cQuery := ""
Local cTMPTMP1Fil

cArq += "LE"                            // Fixo  'LE'
cArq +=  AllTrim(SM0->M0_CGC)           // Ruc
cArq +=  AllTrim(Str(Year(dPFecIni)))   // Ano
cArq +=  AllTrim(Strzero(Month(dPFecIni),2))  // Mes
cArq +=  "00"                            // Fixo '00'
cArq += "050300"                         // Fixo '050300'
cArq += "00"                             // Fixo '00'
cArq += "1"
cArq += "1"
cArq += "1"
cArq += "1"
cArq += ".TXT" // Extensao

FOR nCont:=LEN(AllTrim(cDir)) TO 1 STEP -1
   IF SUBSTR(cDir,nCont,1)=='\' 
      cDir:=Substr(cDir,1,nCont)
      EXIT
   ENDIF   

NEXT 

Pergunte("CTR010",.F.) // utilizando pergunte da rotina ctbr010
nHdl := fCreate(cDir+cArq,0,Nil,.F.)
If nHdl <= 0
	ApMsgStop(STR0055) //"Ha ocurrido un error durante la generación del archivo. Intente nuevamente."
Else

TMP1 := GetNextAlias()

cFilCt1  := " CT1_FILIAL " + GetRngFil( aSelFil, "CT1", .T., @cTMPTMP1Fil )

cQuery := " SELECT CT1_FILIAL"
cQuery += "       , CT1_CONTA"
cQuery += "       , CT1_DESC01"
cQuery += "   FROM " + RetSqlName('CT1') + " CT1"
cQuery += "  WHERE " + cFilCT1
cQuery += "		AND CT1_CONTA  >= '" + mv_par01 + "'"
cQuery += "     AND CT1_CONTA  <= '" + mv_par02 + "'"
IF mv_par03 == 2
cQuery += "		AND CT1_NCUSTO = 0"
EndIF
cQuery += "		AND CT1_CLASSE = '2'" 
If mv_par07 == 2
cQuery += "		AND CT1_BLOQ = '2'" 
EndIf
cQuery += "		AND CT1.D_E_L_E_T_ = ' ' "
cQuery += "  ORDER BY CT1_CONTA "

ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), 'TMP1', .T., .F. )     

	dbSelectArea("TMP1")
	
	Count to nTotREg //Cuenta los registros a procesar
	ProcRegua(nTotREg)
	
	TMP1 ->(dbGoTop())
	
	Do While TMP1->(!EOF())

		IncProc()
		
			cLin:=""	
			//01 - Periodo
			cLin += SubStr(DTOS(dPFecIni),1,8)
			cLin += cSep
				
			//02 - Código de la Cuenta Contable desagregada hasta el nivel máximo de dígitos utilizado
			cLin += AllTrim(TMP1->CT1_CONTA)
			cLin += cSep
								
			//03 - Descripción de la Cuenta Contable desagregada al nivel máximo de dígitos utilizado
			cLin += AllTrim(TMP1->CT1_DESC01)
			cLin += cSep
					
			//04 - Código del Plan de Cuentas utilizado por el deudor tributario - TABELA 17					
			cLin += cPlanRef
			cLin += cSep

			//05 - Descripción del Plan de Cuentas utilizado por el deudor tributario - TABELA17
			If AllTrim(cPlanRef) $ "01" 
		        cLin +=STR0057 + STR0058 //"PLAN CONTABLE " # "GENERAL EMPRESARIAL"
		    ElseIf AllTrim(cPlanRef) $ "02" 
		        cLin +=STR0057 + STR0059 //"PLAN CONTABLE " # "GENERAL REVISAOO"
		    ElseIf AllTrim(cPlanRef) $ "03" 
		        cLin +=STR0060 + STR0061//"PLAN DE CUENTAS " # "PARA EMPRESAS DEL SISTEMA FINANCIERO"
		    ElseIf AllTrim(cPlanRef) $ "04" 
		        cLin +=STR0060 + STR0062 //"PLAN DE CUENTAS " # "PARA ENTIDADES PRESTADORAS DE SALUD"	
		    ElseIf AllTrim(cPlanRef) $ "05" 
		        cLin +=STR0060 + STR0063 //"PLAN DE CUENTAS " # "PARA EMPRESAS DEL SISTEMA ASEGURADOR"		          
		    ElseIf AllTrim(cPlanRef) $ "06" 
		        cLin +=STR0064 //"PLAN DE CUENTAS, ADMIN. PRIVADAS DE FONDOS DE PENSIONES"		          		    
		    ElseIf AllTrim(cPlanRef) $ "07" 
		    	cLin +=STR0065 //"PLAN CONTABLE GUBERNAMENTAL"      	          		         		          		          	      
			ElseIf AllTrim(cPlanRef) $ "99"
				cLin +=STR0066 //"OTROS"
			Else 	
				cLin +=STR0066 //"OTROS"
			EndIf	          					   
				cLin += cSep 			

			//06 - Código de la Cuenta Contable Corporativa desagregada hasta el nivel máximo de dígitos utilizadoo
			cLin += ""
			cLin += cSep	
	
			//07 - Descripción de la Cuenta Contable Corporativa desagregada al nivel máximo de dígitos utilizado
			cLin += ""
			cLin += cSep	
	
			//08 - Indica el estado de la operación
			If dPFecFin >= dPFecIni
				cLin += '1'
			Else
				cLin += '9'
			EndIf	
			cLin += cSep
		
			cLin += chr(13)+chr(10)
			
	fWrite(nHdl,cLin)
	TMP1->(dbSkip())
	EndDo
	fClose(nHdl)

EndIf	

TMP1->(DbCloseArea()) 
CtbTmpErase(cTmptmp1Fil)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ZCTBR118  ºAutor  ³Microsiga           ºFecha ³  12/16/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static function QryCT2

Local cFilCTL:=" CTL_FILIAL = '"+ XFILIAL("CTL")+"' "  
Local cFilCt1  := " CT1_FILIAL " + GetRngFil( aSelFil, "CT1", .T., @cTmpCT1Fil )
Local cFilCT2  := " CT2_FILIAL " + GetRngFil( aSelFil, "CT2", .T., @cTmpCT2Fil )
Local cQuery:=''

  
DBSELECTAREA("CTL")
DBSELECTAREA("CT2")
DBSELECTAREA("CT1")

TMP := GetNextAlias()
       

cQuery := " SELECT CT2_FILIAL"
cQuery += "      , CT2_DATA"
cQuery += "      , CT2_LOTE"
cQuery += "      , CT2_SBLOTE"
cQuery += "      , CT2_DOC"
cQuery += "      , CT2_LINHA"
cQuery += "      , CT2_DC"
cQuery += "      , CT2_VALOR"
cQuery += "      , CT2_DIACTB"
cQuery += "      , CT2_SEGOFI"
cQuery += "      , CT2_NODIA"
cQuery += "      , CT2_ROTINA"
cQuery += "      , CT1_CONTA"
cQuery += "      , CT2_DEBITO"
cQuery += "      , CT2_CREDIT"
cQuery += "      , CT1_DESC01"
cQuery += "      , CVL_CTBCLA"
cQuery += "      , CVL_DESCR"
cQuery += "      , CT2_HIST"
cQuery += "      , CT2_MOEDLC"
cQuery += "      , CT2_CCD"
cQuery += "      , CT2_CCC"
cQuery += "      , CT2_KEY"
cQuery += "      , CT2_LP"
cQuery += "      , CT2.R_E_C_N_O_, CTL_KEY,CTL_ORDER, CTL_ALIAS"
cQuery += "   FROM " + RetSqlName('CT2') + " CT2"
cQuery += "        JOIN " + RetSqlName('CT1') + " CT1 ON " + cFilCT1 + " AND ( CT1_CONTA = CT2.CT2_DEBITO OR  CT1_CONTA = CT2.CT2_CREDIT ) AND CT1.D_E_L_E_T_ = ' ' "
cQuery += "   LEFT JOIN " + RetSqlName('CTL') + " CTL ON " + cFilCTL + " AND   CT2_LP = CTL_LP  AND CTL.D_E_L_E_T_ = ' ' "
cQuery += "   LEFT JOIN " + RetSqlName('CVL') + " CVL ON CVL.CVL_FILIAL = CT2.CT2_FILIAL AND CVL.CVL_COD = CT2.CT2_DIACTB AND CVL.D_E_L_E_T_ = ' ' "
cQuery += "  WHERE " + cFilCT2
cQuery += "    AND CT2_DATA BETWEEN '" + DTOS( dPFecIni ) + "' AND '" + DTOS ( dPFecFin ) + "' "
cQuery += "    AND CT2_MOEDLC = '" + cPMon + "' "
cQuery += "    AND CT2_TPSALD = '" + cPTPSld + "' "
cQuery += "    AND CT2.D_E_L_E_T_ = ' ' AND  NOT(CT2_DEBITO= '' AND CT2_CREDIT='') "
cQuery += "  ORDER BY CT2_SEGOFI,CT2_DATA,CT1_CONTA "


ChangeQuery(cQuery)

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), 'TMP', .T., .F. )  

DbSelectArea('TMP')

TcSetField("TMP","CT2_DATA" ,"D")

Return
