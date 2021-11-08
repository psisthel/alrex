#include "TOTVS.CH"
#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"   
#Include "tbiconn.ch"
#define CRLF CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTH00002  บAutor  ณPercy Arias,SISTHEL บ Data ณ  06/05/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Integracion del Registro de constancia de Detracciones.    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Peru                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STH00002()

	Local oDlg
	Local targetDir	:= Space(250)
	Local cDelm := "|"
	
  	DEFINE DIALOG oDlg TITLE "Registrar Detracciones" FROM 180,180 TO 400,570 PIXEL
 
   	oGroup2:= TGroup():New(005,005,040,190,'Seleccione el archivo ',oDlg,,,.T.)
   	oGroup4:= TGroup():New(045,005,080,190,'Seleccione el delimitador ',oDlg,,,.T.)

	oTGet1 := TGet():New( 020,15,{|| targetDir },oGroup2,130,010,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,targetDir,,,,)
	oTButton1 := TButton():New( 020, 150, "Archivo",oDlg,{|| targetDir := cGetFile( 'Archivos CSV|*.csv' , 'Seleccione el Archivo (csv)', 0, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY ),.T., .T. ) }, 35,12,,,.F.,.T.,.F.,,.F.,,,.F. )

	oTGet0 := TGet():New( 060,15,{|| cDelm },oGroup4,50,010,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cDelm,,,,)
	
	oTButton1 := TButton():New( 085, 085, "Procesar"			,oDlg,{|| xProcessa( targetDir,cDelm ), targetDir := Space(250) }, 50,17,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTButton1 := TButton():New( 085, 140, "Salir"				,oDlg,{|| oDlg:End() }, 50,17,,,.F.,.T.,.F.,,.F.,,,.F. )
	
	ACTIVATE DIALOG oDlg CENTERED

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTH00002  บAutor  ณMicrosiga           บ Data ณ  06/05/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function xProcessa( xArquivo, xDelm )

	local nX
	local nValor	:=	0
	local aStruct	:= {}
	local aCpos		:= {}
	
	private aRotina 	:= {}
	private cCadastro 	:= "Registro Masivo de Detracciones"
	private cMarca		:= GetMark()
	private aCores		:= {}
	private aDetalle	:= LeArchivo( xArquivo,xDelm )
		
	if len(aDetalle) == 0
		Return
	endif
	
	If Select("TYYMP") > 0  
	   TYYMP->( dbCloseArea() )
	End   
	
	nValor	:=	0
	aStruct := {}
	aCpos	:= {}
	cArq	:= CriaTrab(Nil,.F.)
	
	AAdd ( aCores , { "TYYMP->XX_FLAG=='S'"		, "BR_DISABLE"		} )
	AAdd ( aCores , { "TYYMP->XX_FLAG=='N'"		, "BR_VERDE" 		} )
	AAdd ( aCores , { "TYYMP->XX_FLAG==' '"		, "BR_AZUL" 		} )

	AAdd( aStruct,{ "XX_OK"				,"C",02,0	} )
	AAdd( aStruct,{ "XX_CERT"	   		,"C",TAMSX3("FE_CERTDET")[1]	,0	} )
	AAdd( aStruct,{ "XX_RUC"			,"C",TAMSX3("FE_FORNECE")[1]	,0	} )
	AAdd( aStruct,{ "XX_FORNECE"		,"C",TAMSX3("A2_NOME")[1]		,0	} )
	AAdd( aStruct,{ "XX_DTPAGO"			,"D",TAMSX3("FE_EMISSAO")[1]	,0	} )
	AAdd( aStruct,{ "XX_VALOR"			,"N",15,2	} )
	AAdd( aStruct,{ "XX_SERIE"			,"C",TAMSX3("F2_SERIE2")[1]		,0	} ) 
	AAdd( aStruct,{ "XX_DOC"			,"C",TAMSX3("FE_NFISCAL")[1]	,0	} ) 
	AAdd( aStruct,{ "XX_FLAG"			,"C",01,0	} )

	DbCreate(cArq , aStruct )
	DbUseArea(.T. ,, cArq ,"TYYMP",.T.,.F.)
	IndRegua("TYYMP", cArq,"XX_DTPAGO",,,"Indexando registros ..." , .T. )		
	
	For nX:=1 To Len(aDetalle)
	
		nMonto := replace(aDetalle[nX][5],",","")
	
		TYYMP->( RecLock("TYYMP",.t.) )
		TYYMP->XX_OK		:= "  "
		TYYMP->XX_CERT		:= aDetalle[nX][1]
		TYYMP->XX_RUC		:= aDetalle[nX][2]
		TYYMP->XX_FORNECE	:= aDetalle[nX][3]
		TYYMP->XX_DTPAGO	:= ctod(aDetalle[nX][4])
		TYYMP->XX_VALOR		:= val(nMonto)
		TYYMP->XX_SERIE		:= aDetalle[nX][6]
		TYYMP->XX_DOC		:= aDetalle[nX][7]
		TYYMP->XX_FLAG		:= "N"
		TYYMP->( MsUnlock() )
	
		nValor	+=	val(aDetalle[nX][5])
	Next

	DbSelectArea("TYYMP")
	
	AADD(aRotina,{"Procesar","U_ExecDet()"	,0,1}) 

	AADD(aCpos, "XX_OK" )  
	aCampos := {}
	
	AAdd( aCampos,{ "XX_OK"				,"","",					"@!"			} )
	AAdd( aCampos,{ "XX_CERT"	   		,"","Certificado",		"@!"			} )	
	AAdd( aCampos,{ "XX_RUC"			,"","RUC",				"@!"			} )
	AAdd( aCampos,{ "XX_FORNECE"		,"","Nombre Proveedor",	"@!"			} )
	AAdd( aCampos,{ "XX_DTPAGO"			,"","Fecha Pago",		"@!"			} )
	AAdd( aCampos,{ "XX_VALOR"			,"","Valor",			"9,999,999.99"	} )
	AAdd( aCampos,{ "XX_SERIE"			,"","Serie",			"@!"			} )
	AAdd( aCampos,{ "XX_DOC"			,"","Documento",		"@!"			} )

	MarkBrow("TYYMP",aCpos[1],,aCampos,.F.,cMarca,"U_Mark1()",,,,'u_Mark2()',,,,aCores)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTH00002  บAutor  ณMicrosiga           บ Data ณ  06/05/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LeArchivo( cNomArchivo,xDlm )

	Local lOK		:= .T.    
	Local _xLog		:= ""
	Local cBuff		:= ""
	Local aItens	:= {}
	Local nX		:= 1
	
	xDlm := alltrim(xDlm)
		
	ft_fuse(cNomArchivo)
	
	While !ft_feof()
	    
		if nX>1
		
			lOK := .t.
		
			cBuff		:= Alltrim(ft_freadln())
			
			cCpo01	:= BusCad(cBuff,0,xDlm)		// tipo de cuenta
			cCpo02	:= BusCad(cBuff,1,xDlm)		// nro de cuenta
			cCpo03	:= BusCad(cBuff,2,xDlm)		// nro constancia
			cCpo04	:= BusCad(cBuff,3,xDlm)		// periodo tributario
			cCpo05	:= BusCad(cBuff,4,xDlm)		// RUC proveedor
			cCpo06	:= BusCad(cBuff,5,xDlm)		// nombre proveedor
			cCpo07	:= BusCad(cBuff,6,xDlm)		// tipo documento adquirinte
			cCpo08	:= BusCad(cBuff,7,xDlm)		// RUC documento adquiriente
			cCpo09	:= BusCad(cBuff,8,xDlm)		// razon social del adquirente
			cCpo10	:= BusCad(cBuff,9,xDlm)		// fecha de pago
			cCpo11	:= BusCad(cBuff,10,xDlm)	// monto de pago
			cCpo12	:= BusCad(cBuff,11,xDlm)	// tipo de bien
			cCpo13	:= BusCad(cBuff,12,xDlm)	// tipo operacion
			cCpo14	:= BusCad(cBuff,13,xDlm)	// tipo comprobante
			cCpo15	:= BusCad(cBuff,14,xDlm)	// serie comprobante
			cCpo16	:= BusCad(cBuff,15,xDlm)	// nro do comprobante
	
			aadd(aItens,{	cCpo03		,;		// nro constancia
							cCpo08		,;		// RUC documento adquiriente
							cCpo09		,;		// razon social del adquirente
							cCpo10		,;		// fecha de pago
							cCpo11		,;		// monto de pago
							cCpo15  	,;		// serie comprobante
							cCpo16  	})		// nro do comprobante
		endif
		
		nX++
		
		ft_fskip()
		
	Enddo
	
	ft_fuse() 
		
Return (aItens)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTH00002  บAutor  ณMicrosiga           บ Data ณ  06/05/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function BusCad(cTexto,nVeces,cSeparador)        

	Local cRegresa   := ""    
	Local Encontrado := .F.      
	Local nInicio    := 0 
	Local nFinal     := 0
	Local nNoCaract  := 0   
		  
	_cCadena   := cTexto
  	_nContador := 1 
  	_nConta2   := 0
  	_cTemp     := ''

  	If nVeces == 0
		nInicio := _nContador  
  	Endif  
          
  	While _nContador <= len(_cCadena) .And. Encontrado == .F.
    
    	If Substr(_cCadena,_nContador,1) == cSeparador
       		_nConta2 += 1  
    		If _nConta2 == nVeces
         		nInicio := _nContador  + 1
    		Endif  
    	Endif
    
    	If _nConta2 == nVeces + 1  .Or. _nContador == len(_cCadena)
       		nFinal := _nContador 
       		Encontrado := .T.
       		If _nContador == len(_cCadena)
          		nFinal += 1
       		Endif
    	Endif
    
    	_nContador += 1   
  	
  	Enddo
    
    cRegresa := Substr(_cCadena,nInicio,nFinal - nInicio)  
    
Return(cRegresa)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTH00002  บAutor  ณMicrosiga           บ Data ณ  06/05/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Mark1()

	Local aArea  := GetArea()
	Local lMarca := Nil   
	
	TYYMP->( dbGotop() )
	While TYYMP->( !Eof() )
		
		If (lMarca == Nil)
			lMarca := (TYYMP->XX_OK == cMarca)
		EndIf
		
		TYYMP->( RecLock("TYYMP",.F.) )
		TYYMP->XX_OK := If( lMarca,"",cMarca )
		TYYMP->( MsUnLock() )
		TYYMP->( dbSkip() )
		
	EndDo
	
	RestArea(aArea)
	MarkBRefresh()

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTH00002  บAutor  ณMicrosiga           บ Data ณ  06/05/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Mark2()

	If IsMark( 'XX_OK', cMarca )        
		TYYMP->( RecLock( 'TYYMP', .F. ) )
		TYYMP->XX_OK := Space(2)        
		TYYMP->( MsUnLock() )
	Else        
		TYYMP->( RecLock( 'TYYMP', .F. ) )
		TYYMP->XX_OK := cMarca
		TYYMP->( MsUnLock() )
	EndIf

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTH00002  บAutor  ณMicrosiga           บ Data ณ  06/05/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ExecDet()

	local cQuery	:= ""
	local nX		:= 1
	local cAliasSE2	:= getNextAlias()
	local cModal	:= getNewPar("AL_MODAL","0900002")
	local nLenFor	:=	TamSX3("E2_FORNECE")[1]+TamSX3("E2_LOJA")[1]
	local nLenPref	:=	TamSX3("E2_PREFIXO")[1]
	local nLenNum	:=	TamSX3("E2_NUM")[1]
	local nLenTipo	:=	TamSX3("E2_TIPO")[1]
	local nLenParc	:=	TamSX3("E2_PARCELA")[1]
	
	TYYMP->( dbgotop() )
	
	While TYYMP->( !Eof() )
	
		if !empty(TYYMP->XX_OK)

			cQuery := "SELECT E2_TITPAI,E2_EMIS1,E2_PREFIXO,E2_NUM,E2_TIPO,E2_VALOR,R_E_C_N_O_ SE2RECNO"
			cQuery += "  FROM " + RetSqlName( "SE2" ) + " SE2 " 
			cQuery += " WHERE E2_FILIAL='" + xFilial( "SE2" ) + "'" 
			cQuery += "   AND E2_FORNECE='" + TYYMP->XX_RUC + "'" 
			cQuery += "   AND E2_NATUREZ='" + cModal + "'" 
			cQuery += "   AND E2_TIPO IN ('TX ','TXA')" 
			cQuery += "   AND E2_NUM='" + TYYMP->XX_DOC + "'"
			cQuery += "   AND E2_BAIXA <> ' '"
			cQuery += "   AND D_E_L_E_T_=' '"
			cQuery += " ORDER BY E2_EMIS1,E2_PREFIXO,E2_NUM"  
			
			cQuery := ChangeQuery( cQuery ) 
			
			dbUseArea( .t., "TOPCONN", TcGenQry( ,,cQuery ), cAliasSE2, .F., .T. )   
			
			if (cAliasSE2)->( !Eof() )
				cFornLoja	:=	Substr(E2_TITPAI,nLenPref+nLenNum+nLenParc+nLenTipo+1,nLenFor)
				cNum		:=	Substr(E2_TITPAI,nLenPref+1,nLenNum)
				cSerie		:=	Substr(E2_TITPAI,1,nLenPref)
	
				SFE->(DbSetOrder(4))
				If !SFE->( dbSeek( xFilial("SFE")+cFornLoja+cNum+cSerie+"D" ) )

					BeginTran()
					SE2->( MsGoTo( (cAliasSE2)->SE2RECNO ))
					SFE->( RecLock("SFE",.T.) )
					SFE->FE_FILIAL	:=	SFE->( xFilial() )
					SFE->FE_CERTDET	:= TYYMP->XX_CERT
					SFE->FE_EMISSAO	:= SE2->E2_EMISSAO
					SFE->FE_FORNECE	:= SE2->E2_FORNECE
					SFE->FE_LOJA	:= SE2->E2_LOJA
					SFE->FE_TIPO	:= "D" 
					SFE->FE_NFISCAL	:=	SE2->E2_NUM
					SFE->FE_SERIE	:=	SE2->E2_PREFIXO
					SFE->FE_VALIMP	:=	SE2->E2_VALOR
					SFE->FE_ESPECIE	:=	SE2->E2_TIPO
					SFE->FE_PARCELA	:=	SE2->E2_PARCELA
					SFE->( MsUnLock() )
					
					TYYMP->( RecLock("TYYMP",.F.) )
					TYYMP->XX_OK	:= "  "
					TYYMP->XX_FLAG	:= "S"
					TYYMP->( MsUnlock() )
			
					EndTran()
				else
				
					TYYMP->( RecLock("TYYMP",.F.) )
					TYYMP->XX_OK	:= space(2)
					TYYMP->XX_FLAG	:= space(1)
					TYYMP->( MsUnlock() )

				Endif

			endif
			
			(cAliasSE2)->(dbCloseArea()	)

		endif
		
		TYYMP->( dbSkip() )
		
	Enddo
	
	MarkBRefresh()

Return