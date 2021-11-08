#INCLUDE "rwmake.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณALREST03  บAutor  ณMicrosiga           บ Data ณ  02/07/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Consulta general de stock para usuarios de administracion  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ALREST03

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Declaracao de Variaveis                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	//Local aCores	:=	{	{ 'u_fgetSaldo()>SB1->B1_LE .AND. u_fgetSaldo()>SB1->B1_LM'	, 'ENABLE'		},;	
	//						{ 'u_fgetSaldo()<=SB1->B1_LE'	, 'BR_AMARELO'	},;	
	//						{ 'u_fgetSaldo()<=SB1->B1_LM'	, 'DISABLE'		}}

	Local aCores	:=	{	{ 'TMP->B2_QATU>TMP->B1_LE .AND. TMP->B2_QATU>TMP->B1_LM'	, 'ENABLE'		},;	
							{ 'TMP->B2_QATU<=TMP->B1_LE'								, 'BR_AMARELO'	},;	
							{ 'TMP->B2_QATU<=TMP->B1_LM'								, 'DISABLE'		}}

	local _cPerg := PADR("SALDOATU",10)
	
	//Local aIndex	:= {} 
	//Local cFiltro	:= ""

	//Local cTopFun := "U_TOPFUN()"
	//Local cBotFun := "U_BOTFUN()"
 
	Private cCadastro := "Saldo Actual - Productos"
	Private aRotina := MenuDef()
	//Private cDelFunc := ".F."
	//Private cString := "SB1"
	//Private bFiltraBrw	:= { || FilBrowse( "TMP" , @aIndex , @cFiltro ) } 
	Private aCposBrw	:= {}
	
	Pergunte(_cPerg,.t.)
	
	MsgRun("Selecionando Registros, Aguarde...",,{|| MONTATRAB()})

	Define font oFont Name "Arial" SIZE 16,20
	
	If Select("TMP") > 0
		SetKey(VK_F4,{|| U_SAYF4() } )
		SetKey(VK_F6,{|| U_SAYF6() } )
		dbSelectArea("TMP")
		mBrowse( 6 , 1 , 22 , 75 , "TMP" , aCposBrw , NIL , NIL , NIL , NIL , aCores , /*@cTopFun*/ , /*@cBotFun*/)
		SetKey(VK_F4, )
		SetKey(VK_F6, )
		
	else
		Alert("Ninguna informacion encontrada para el filtro de busqueda!")
	endif
		
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณALXSS010  บAutor  ณMicrosiga           บ Data ณ  10/22/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MenuDef()
               
	Local aRotina  :=	{	{	"Buscar"			,"U_BUSCAITM"		,0,1	} ,;
				 			{	"Otros Almacenes"	,"U_SAYF4()"		,0,6	} ,;
				 			{	"Lotes"				,"U_SAYF6()"		,0,6	} ,;
				 			{	"Leyenda"			,"U_SAYLEG()"		,0,6	} }

Return(aRotina)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณALREST03  บAutor  ณMicrosiga           บ Data ณ  10/22/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SAYF4

	local farea := getArea()
	Local cFilBkp := cFilAnt

	If FWModeAccess("SB1")=="E"
		cFilAnt := TMP->B1_FILIAL
	EndIf
	
	MaViewSB2(TMP->B1_COD)
	
	cFilAnt := cFilBkp
	restArea(farea)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณALXSS010  บAutor  ณMicrosiga           บ Data ณ  10/22/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fgetSaldo()

	local v_area := getArea()
	local n_saldo := 0

	dbSelectArea("SB2")
	MsSeek(xFilial("SB2") + SB1->B1_COD + SB1->B1_LOCPAD)
	n_saldo := SaldoSb2()
	
	restArea(v_area)

Return( n_saldo )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณALREST03  บAutor  ณMicrosiga           บ Data ณ  10/22/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MONTATRAB()

	Local aEstrut	:= {}
	Local _cAlias	:= getNextAlias()

	cSql := "SELECT A5_FORNECE,B1_COD,B1_DESC,A5_CODPRF,A5_YPRDFOR,B1_TIPO,B1_UM,B1_LOCPAD,B1_GRUPO,B1_PRV1,B2_QATU,B1_LE,B1_LM"
	cSql += "  FROM "+retSqlName("SB1")+" SB1"
	cSql += "  LEFT JOIN "+retSqlName("SB2")+" SB2 ON B1_COD=B2_COD"
	cSql += "   AND B1_LOCPAD=B2_LOCAL"
	cSql += "  LEFT JOIN "+retSqlName("SA5")+" SA5 ON B1_COD=A5_PRODUTO"
	cSql += " WHERE B1_FILIAL='"+xFilial("SB1")+"'"
	cSql += "   AND B2_FILIAL='"+xFilial("SB2")+"'"
	cSql += "   AND A5_FILIAL='"+xFilial("SA5")+"'"
	cSql += "   AND SB1.D_E_L_E_T_=''"
	cSql += "   AND SB2.D_E_L_E_T_=''"
	cSql += "   AND SA5.D_E_L_E_T_=''"
	if !empty(MV_PAR01)
		cSql += " AND A5_FORNECE='"+MV_PAR01+"'"
	endif
	if !empty(MV_PAR02)
		cSql += " AND A5_CODPRF LIKE '%"+MV_PAR02+"'%"
	endif
	if !empty(MV_PAR03)
		cSql += " AND B1_COD='"+MV_PAR03+"'"
	endif
	if !empty(MV_PAR04)
		cSql += " AND B1_LOCPAD='"+MV_PAR04+"'"
	endif
	if !empty(MV_PAR05)
		cSql += " AND B1_TIPO='"+MV_PAR05+"'"
	endif

	cSql += " ORDER BY B1_COD"

	If Select(_cAlias) > 0
   		(_cAlias)->( dbCloseArea() )
	EndIf   
	   
	dbUseArea(.T., "TOPCONN", tcGenQry(,,cSql), _cAlias )

	If (_cAlias)->( !Eof() )
	
		aCposBrw := {}

		aAdd(aCposBrw,      { "Proveedor"			, "A5_FORNECE"		,     "C"     , TamSx3("A5_FORNECE")[1]		, 0, ""})
		aAdd(aCposBrw,      { "Producto ALREX"		, "B1_COD"			,     "C"     , TamSx3("B1_COD")[1]			, 0, ""})
		aAdd(aCposBrw,      { "Descripcion"			, "B1_DESC"			,     "C"     , TamSx3("B1_DESC")[1]		, 0, ""})
		aAdd(aCposBrw,      { "Producto Prov."		, "A5_CODPRF"		,     "C"     , TamSx3("A5_CODPRF")[1]		, 0, ""})
		aAdd(aCposBrw,      { "Descripcion"			, "A5_YPRDFOR"		,     "C"     , TamSx3("A5_YPRDFOR")[1]		, 0, ""})
		aAdd(aCposBrw,      { "PRECIO"				, "B1_PRV1"			,     "N"     , 15							, 2, "@E 999,999,999.99"})
		aAdd(aCposBrw,      { "SALDO"				, "B2_QATU"			,     "N"     , 15							, 4, "@E 999,999,999.9999"})
		aAdd(aCposBrw,      { "LOTE ECONO"			, "B1_LE"			,     "N"     , 15							, 4, "@E 999,999,999.9999"})
		aAdd(aCposBrw,      { "LOTE MINIMO"			, "B1_LM"			,     "N"     , 15							, 4, "@E 999,999,999.9999"})
		aAdd(aCposBrw,      { "Tipo"				, "B1_TIPO"			,     "C"     , TamSx3("B1_TIPO")[1]		, 0, ""})
		aAdd(aCposBrw,      { "UM"					, "B1_UM"			,     "C"     , TamSx3("B1_UM")[1]			, 0, ""})
		aAdd(aCposBrw,      { "ALMACEN"				, "B1_LOCPAD"		,     "C"     , TamSx3("B1_LOCPAD")[1]		, 0, ""})
		aAdd(aCposBrw,      { "GRUPO"				, "B1_GRUPO"		,     "C"     , TamSx3("B1_GRUPO")[1]		, 0, ""})
          
		//aAdd(aEstrut,     { "ORDEM" , "C", 1, 0})

		For nX := 1 To Len(aCposBrw)
			aAdd(aEstrut, { aCposBrw[nX,2], aCposBrw[nX,3], aCposBrw[nX,4], aCposBrw[nX,5] } )
		Next nX
		
		cArqTMP := CriaTrab(aEstrut, .T.)
			
		If Select("TMP") > 0
			TMP->( DbCloseArea() )
			FErase(cArqTmp + GetDbExtension())  // Deletando o arquivo
			FErase(cArqTmp + OrdBagExt())       // Deletando ํndice
			cArqTMP := CriaTrab(aEstrut, .T.)
		endif
			
		dbUseArea(.T.,, cArqTMP, "TMP", .T., .F.)
		IndRegua( "TMP", cArqTMP, "A5_FORNECE+B1_COD",,,"Indexando registros..." )
			         
		DbSelectArea("TMP")
		TMP->(dbClearIndex())
		TMP->(dbSetIndex(cArqTMP + OrdBagExt()))
	

     	While (_cAlias)->(!Eof())
     	
			TMP->( RecLock("TMP", .T.) )
			TMP->A5_FORNECE		:= (_cAlias)->A5_FORNECE
			TMP->B1_COD			:= (_cAlias)->B1_COD
			TMP->B1_DESC		:= (_cAlias)->B1_DESC
			TMP->A5_CODPRF		:= (_cAlias)->A5_CODPRF
			TMP->A5_YPRDFOR		:= (_cAlias)->A5_YPRDFOR
			TMP->B1_TIPO		:= (_cAlias)->B1_TIPO
			TMP->B1_UM			:= (_cAlias)->B1_UM
			TMP->B1_LOCPAD		:= (_cAlias)->B1_LOCPAD
			TMP->B1_GRUPO		:= (_cAlias)->B1_GRUPO
			TMP->B1_PRV1		:= (_cAlias)->B1_PRV1
			TMP->B2_QATU		:= (_cAlias)->B2_QATU
			TMP->B1_LE			:= (_cAlias)->B1_LE
			TMP->B1_LM			:= (_cAlias)->B1_LM
			TMP->( MsUnlock() )
			
			(_cAlias)->(DbSkip())

		Enddo

	EndIf

	(_cAlias)->(dbCloseArea())
	
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณALREST03  บAutor  ณMicrosiga           บ Data ณ  10/24/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function BUSCAITM

	local _cPerg := PADR("SALDOATU",10)

	if Pergunte(_cPerg,.t.)
	
		MsgRun("Selecionando Registros, Aguarde...",,{|| MONTATRAB()})
	
	endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณALREST03  บAutor  ณMicrosiga           บ Data ณ  11/19/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SAYF6()

	local harea		:= getArea()
	local cProduto	:= TMP->B1_COD
	local cLocal	:= TMP->B1_LOCPAD
	local aArrayF4	:= {}
	local lEmpPrev 	:= If(SuperGetMV("MV_QTDPREV")== "S",.T.,.F.)
	local cPict		:= PesqpictQt("B8_SALDO",14)
	
	dbSelectArea("SB8")
	dbSetOrder(1)
	nSaldo := 0
	MsSeek(xFilial()+cProduto+cLocal)

	While !EOF() .And. B8_FILIAL+B8_PRODUTO+B8_LOCAL == xFilial()+cProduto+cLocal
		If SB8SALDO(,,,,,lEmpPrev,,,.T.)-(SB8SALDO(.T.,,,,,lEmpPrev,,,.T.)+AvalQtdPre("SB8",1)) <= 0
			DbSkip()
			Loop
		EndIf

		If Rastro( cProduto, "S" )
			AADD(aArrayF4, { B8_NUMLOTE,B8_PRODUTO,Dtoc(B8_DATA),;
				Dtoc(B8_DTVALID),Transform(SB8SALDO(,,,,,lEmpPrev,,,.T.)-(SB8SALDO(.T.,,,,,lEmpPrev,,,.T.)+AvalQtdPre("SB8",1)),cPict),B8_LOTECTL })
		Else

			nScan := AScan( aArrayF4, { |x| x[6] == B8_LOTECTL } )

			If nScan == 0
				AADD(aArrayF4, { B8_LOTECTL,B8_PRODUTO,Dtoc(B8_DATA),;
					Dtoc(B8_DTVALID),Transform(SB8SALDO(,,,,,lEmpPrev,,,.T.)-(SB8SALDO(.T.,,,,,lEmpPrev,,,.T.)+AvalQtdPre("SB8",1)),cPict),B8_LOTECTL })
			Else
				nSaldoLt := Val( aArrayF4[ nScan, 5 ] )
				nSaldoLt += SB8SALDO(,,,,,lEmpPrev,,,.T.) - (SB8SALDO(.T.,,,,,lEmpPrev,,,.T.)+AvalQtdPre("SB8",1))
				aArrayF4[ nScan ] := { B8_LOTECTL,B8_PRODUTO,Dtoc(B8_DATA),;
						Dtoc(B8_DTVALID),Transform(nSaldoLt,cPict),B8_LOTECTL }
			EndIf
		EndIf

		nSaldo += SB8SALDO(,,,,,lEmpPrev,,,.T.)-(SB8SALDO(.T.,,,,,lEmpPrev,,,.T.)+AvalQtdPre("SB8",1))

		cLtAnt := B8_LOTECTL

		dbSkip()
	EndDo

	If Len(aArrayF4) > 0
	
		nOpcA := 0
		cCadastro := "Saldos por Lote"
			
		DEFINE MSDIALOG oDlg TITLE cCadastro From 09,0 To 40,110 OF oMainWnd		
		@ 0.5,  0 TO 15, 54.0 OF oDlg
		@ 1,  .7  Say "Saldo Disponกvel  "		
		@ 1, 7  Say Transform(nSaldo,cPict)
		@ 2,.7 LISTBOX oQual VAR cVar Fields HEADER "Lote","Produto","Data","Dt.Valid.","Saldo","Lote" SIZE 420,180 ON DBLCLICK (nList:= oQual:nAt, nOpca := 1,oDlg:End())
		oQual:SetArray(aArrayF4)
		oQual:bLine := { ||{aArrayF4[oQual:nAT,1],aArrayF4[oQual:nAT,2],;
				aArrayF4[oQual:nAT,3],aArrayF4[oQual:nAT,4],;
				aArrayF4[oQual:nAT,5],aArrayF4[oQual:nAT,6]}}
		   
		DEFINE SBUTTON FROM 215, 375  TYPE 1 ACTION (nList:= oQual:nAt, nOpca := 1,oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON FROM 215, 405  TYPE 2 ACTION (nList:= oQual:nAt, oDlg:End()) ENABLE OF oDlg
			
		ACTIVATE MSDIALOG oDlg
		If nOpca == 1

		EndIf
	Else
		Help(" ",1,"NO-LOTE")
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณALREST03  บAutor  ณMicrosiga           บ Data ณ  11/21/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SAYLEG()
     
    local _xArea := getArea()
	local aLegenda := {}

	aAdd(aLegenda,{"ENABLE" 	,"Stock Ok"})
	aAdd(aLegenda,{"DISABLE"	,"Stock Minimo"})
	aAdd(aLegenda,{"YELLOW"		,"Stock Economico"})

	BrwLegenda("Stock","Leyenda", aLegenda )
	
	RestArea(_xArea)

Return
