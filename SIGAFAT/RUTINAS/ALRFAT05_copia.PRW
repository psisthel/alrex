#include "protheus.ch"
#INCLUDE "RWMAKE.CH"
#Include "TopConn.ch"
#INCLUDE "TBICONN.CH" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALRFAT05  ºAutor  ³Percy Arias,SISTHEL º Data ³  07/03/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Pre Lanzamientos de RA                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ALRFAT05()

	local clAlias	:= "ZZW"
	Local aCores	:=	{	{ "ZZW->ZZW_STATUS='0'"		, 'ENABLE'		},;
							{ "ZZW->ZZW_STATUS='1'"		, 'DISABLE'		}}

	private cCadastro 	:= "Pre Lanzamientos de RA's"
	private aRotina := {	{ "Buscar"		,	"AxPesqui"		,0,1} ,;
							{ "Visualizar"	,	"AxVisual"		,0,2} ,;
	             		 	{ "Incluir"		,	"AxInclui"		,0,3} ,;
	             		 	{ "Modificar"	,	"AxAltera"		,0,4} ,;
 	             		 	{ "Borrar"		,	"AxDeleta"		,0,5} ,;
 	             		 	{ "Genera RA"	,	"u_EXEMBRW()"	,0,6} }

	dbSelectArea( clAlias )
	dbSetOrder(1)
	dbGoTop()
	
	mBrowse( 6, 1,22,75,clAlias,,,,,,aCores)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALRFAT05  ºAutor  ³Microsiga           º Data ³  11/09/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EXEMBRW()

	Local aCpos 	:= {}
	Local aCampos 	:= {}
	Local _cSql		:= ""
	Local _cAlias	:= GetNextAlias()
	Local aCores	:=	{	{ "TXEMP->ZZW_STATUS='0'"		, 'ENABLE'		},;
							{ "TXEMP->ZZW_STATUS='1'"		, 'DISABLE'		}}
	Local _cPerg	:= PADR("ZZWOPC",10)

	Private aRotina 	:= {}
	Private cCadastro 	:= "Efectivar Recibos Anticipados - RA's"
	Private cMarcaSE2   := GetMark()    
	Private aRotina 	:= MenuDef()
	
	if !Pergunte(_cPerg,.T.)
		Return
	Endif

	If Select("TXEMP") > 0  
	   TXEMP->( dbCloseArea() )
	End   
	
	aStruct := {}
	cArq := CriaTrab(Nil,.F.)

	AAdd( aStruct,{ "ZZW_OK"			,"C",02,0	} )
	AAdd( aStruct,{ "ZZW_PEDIDO"		,"C",06,0	} )
	AAdd( aStruct,{ "ZZW_CLIENT"		,"C",11,0	} )
	AAdd( aStruct,{ "ZZW_NOMCLI"   		,"C",50,0	} )
	AAdd( aStruct,{ "ZZW_BANCO"			,"C",03,0	} )
	AAdd( aStruct,{ "ZZW_DOC"			,"C",20,0	} )
	AAdd( aStruct,{ "ZZW_DATA"			,"D",08,0	} )
	AAdd( aStruct,{ "ZZW_VALOR"			,"N",15,2	} )
	AAdd( aStruct,{ "ZZW_TIPDOC"		,"C",02,0	} ) 
	AAdd( aStruct,{ "ZZW_STATUS"		,"C",01,0	} ) 

	DbCreate(cArq , aStruct )
	DbUseArea(.T. ,, cArq ,"TXEMP",.T.,.F.)
	IndRegua("TXEMP" , cArq ,"ZZW_PEDIDO",,,"Indexando registros ..." , .T. )

	_cSql := "SELECT * "
	_cSql += "  FROM "+RetSqlName("ZZW")
	_cSql += " WHERE ZZW_FILIAL='"+xFilial("ZZW")+"'"
	_cSql += "   AND D_E_L_E_T_=' '"
	_cSql += "   AND ZZW_DATA BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "'"
	_cSql += "   AND ZZW_PEDIDO BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "'"
	_cSql += "   AND ZZW_CLIENT BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR07 + "'"

	if MV_PAR01==2		// pendientes
		_cSql += " AND ZZW_STATUS='0'"
	elseif MV_PAR01==3		// finalizados
		_cSql += " AND ZZW_STATUS='1'"
	endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSql),_cAlias,.T.,.T.)
	
	if (_cAlias)->( !eof() )

		While (_cAlias)->( !Eof() )

			TXEMP->( RecLock("TXEMP",.T.) )
			TXEMP->ZZW_OK		:= "  "
			TXEMP->ZZW_PEDIDO	:= (_cAlias)->ZZW_PEDIDO
			TXEMP->ZZW_CLIENT	:= (_cAlias)->ZZW_CLIENT
			TXEMP->ZZW_NOMCLI	:= (_cAlias)->ZZW_NOMCLI
			TXEMP->ZZW_BANCO	:= (_cAlias)->ZZW_BANCO
			TXEMP->ZZW_DOC		:= (_cAlias)->ZZW_DOC
			TXEMP->ZZW_DATA		:= sTOD((_cAlias)->ZZW_DATA)
			TXEMP->ZZW_VALOR	:= (_cAlias)->ZZW_VALOR
			TXEMP->ZZW_TIPDOC	:= (_cAlias)->ZZW_TIPDOC
			TXEMP->ZZW_STATUS	:= (_cAlias)->ZZW_STATUS
			TXEMP->( MsUnLock() )
		
			(_cAlias)->( dbSkip() )
		
		End 

	endif
	
	(_cAlias)->( dbCloseArea() )
				
	DbSelectArea("TXEMP")
	
	AADD(aCpos, "ZZW_OK" )  
	aCampos := {}
		
	AAdd( aCampos,{ "ZZW_OK"		,"","",					"@!"			} )
	AAdd( aCampos,{ "ZZW_PEDIDO"	,"","Pedido",			"@!"			} )	
	AAdd( aCampos,{ "ZZW_CLIENT"	,"","Cliente",			"@!"			} )
	AAdd( aCampos,{ "ZZW_NOMCLI"	,"","Nombre Cliente",	"@!"			} )
	AAdd( aCampos,{ "ZZW_BANCO"		,"","Banco",			"@!"			} )
	AAdd( aCampos,{ "ZZW_DOC"		,"","Documento",		"@!"			} )
	AAdd( aCampos,{ "ZZW_DATA"		,"","Fecha",			"@!"			} )
	AAdd( aCampos,{ "ZZW_VALOR"		,"","Valor",			"@e 999,999.99"	} )
	AAdd( aCampos,{ "ZZW_TIPDOC"	,"","Tp.Doc.",			"@!"			} )

	MarkBrow("TXEMP",aCpos[1],,aCampos,.F.,cMarcaSE2,"U_Mark03()",,,,'u_Mark04()',,,,aCores)
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALRFAT05  ºAutor  ³Microsiga           º Data ³  09/12/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MenuDef()  

	Local aRotina := {	{ "Efectivar Documentos"	,"u_EXECRA()"					,0	,6	,,.T.	}	,;	//"Incluir"
						{ "Leyenda"					,"u_ALRLEY()"					,0	,6	,,.T.	}	 }	//"Leyenda"

Return(aRotina)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NFE00000  ºAutor  ³Microsiga           º Data ³  07/03/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ALRLEY()
     
    local _xArea := getArea()
	local aLegenda := {}

	aAdd(aLegenda,{"ENABLE" 	,"Documento Pendiente"})
	aAdd(aLegenda,{"DISABLE"	,"Documento Generado"})

	BrwLegenda("Lanzamientos de RA","Leyenda", aLegenda )
	
	RestArea(_xArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NFE00000  ºAutor  ³Microsiga           º Data ³  07/03/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EXECRA

	MsgRun( "Aguarde, generando anticipos..." ,, {|| EXECNOW()  } )
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALRFAT05  ºAutor  ³Microsiga           º Data ³  09/13/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function EXECNOW

	local _aArea	:= getArea()
	local _xPerg	:= PADR("XDOCRB",10)
	local _cRet		:= ""
	local _cString	:= ""
	local _cSql		:= ""
	local _cAlias	:= getNextAlias()
	
	TXEMP->( dbGotop() )
	While TXEMP->( !Eof() )
	
		if TXEMP->ZZW_OK == cMarcaSE2
		
			_cSql := "SELECT R_E_C_N_O_ NREC"
			_cSql += "  FROM "+RetSqlName("ZZW")
			_cSql += " WHERE ZZW_FILIAL='"+xFilial("ZZW")+"'"
			_cSql += "   AND ZZW_PEDIDO='" + TXEMP->ZZW_PEDIDO + "'"
			_cSql += "   AND ZZW_CLIENT='" + ZZW_CLIENT +"'"
			_cSql += "   AND ZZW_STATUS='0'"
			_cSql += "   AND D_E_L_E_T_=' '"
	
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSql),_cAlias,.T.,.T.)
		
			if (_cAlias)->( !eof() )
				//while (_cAlias)->( !eof() )
					ZZW->( dbgoto( (_cAlias)->NREC ) )
					_cRet := u_ALRFIN01(ZZW->ZZW_PEDIDO,ZZW->ZZW_CLIENT)
					if empty(_cRet)
						TXEMP->( RecLock("TXEMP",.F.) )
						TXEMP->ZZW_STATUS	:= "1"
						TXEMP->ZZW_OK		:= "  "
						TXEMP->( MsUnlock() )
					endif
					_cString += _cRet
				//(_cAlias)->( dbSkip() )
				//end
			endif
			
			(_cAlias)->( dbCloseArea() )
			
		endif
		
		TXEMP->( dbSkip() )
		
	EndDo
	
	TXEMP->( dbgotop() )
	
	restArea(_aArea)

	if !empty(_cString)
		MsgInfo(_cString,"ALREX")
	endif
		
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALRFAT05  ºAutor  ³Microsiga           º Data ³  10/01/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Mark03()

	Local aArea  := GetArea()
	Local lMarca := Nil   
	
	TXEMP->( dbGotop() )
	While TXEMP->( !Eof() )
	
		If TXEMP->ZZW_STATUS=="0"
		
			If (lMarca == Nil)
				lMarca := (TXEMP->ZZW_OK == cMarcaSE2)
			EndIf
			
			TXEMP->( RecLock("TXEMP",.F.) )
			TXEMP->ZZW_OK := If( lMarca,"",cMarcaSE2 )
			TXEMP->( MsUnLock() )

		EndIf

		TXEMP->( dbSkip() )
		
	EndDo
	
	RestArea(aArea)
	MarkBRefresh()

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALRFAT05  ºAutor  ³Microsiga           º Data ³  10/01/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Mark04()

	If TXEMP->ZZW_STATUS=="0"
		If IsMark( 'ZZW_OK', cMarcaSE2 )
			TXEMP->( RecLock( 'TXEMP', .F. ) )
			TXEMP->ZZW_OK := Space(2)
			TXEMP->( MsUnLock() )
		Else        
			TXEMP->( RecLock( 'TXEMP', .F. ) )
			TXEMP->ZZW_OK := cMarcaSE2
			TXEMP->( MsUnLock() )
		EndIf
	Endif
	
Return 
