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

	private cCadastro 	:= "Efectivar Recibos Anticipados - RA's"
	private aRotina := {	{ "Buscar"				,	"AxPesqui"		,0,1} ,;
							{ "Visualizar"			,	"AxVisual"		,0,2} ,;
	             		 	{ "Incluir"				,	"AxInclui"		,0,3} ,;
	             		 	{ "Modificar"			,	"AxAltera"		,0,4} ,;
 	             		 	{ "Borrar"				,	"AxDeleta"		,0,5} ,;
 	             		 	{ "Genera Cob.Diversos"	,	"u_EXEMBRW()"	,0,6} ,;
							{ "Leyenda"				,	"u_ALRLEY()"	,0,7} }

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

	local _aArea	:= getArea()
	local _Pedido	:= ZZW->ZZW_PEDIDO
	local _Data		:= ZZW->ZZW_DATA
	local _Client	:= ZZW->ZZW_CLIENT
	local _NomCli	:= ZZW->ZZW_NOMCLI
	local _TipDoc	:= ZZW->ZZW_TIPDOC
	local _Moeda	:= if(ZZW->ZZW_MOEDA==1,"SOLES","DOLARES")
	local _Banco	:= ZZW->ZZW_BANCO
	local _Conta	:= ZZW->ZZW_CONTA
	local _Doc		:= ZZW->ZZW_DOC
	//local _Valor	:= ZZW->ZZW_VALOR
	//local _ValEfe	:= 0
	local _ValEfe	:= ZZW->ZZW_VALOR
	local _DataEf	:= dDataBase		//CriaVar("ZZW_DATAEF")
	Local aSize		:= MsAdvSize( .F. ) 
	local oDlg		:= Nil

	if ZZW->ZZW_STATUS=="1"
		alert("Documento ya fue generado")
		Return
	endif

	oDlg := TDialog():New(aSize[7],0,(aSize[6]/1.3),aSize[5]/3,"Efectivar RAs",,,,,,,,oMainWnd,.T.)
	
	@ 010,010 SAY "Pedido"				SIZE 040,011 	OF oDlg PIXEL
	@ 010,080 MSGET _Pedido				SIZE 120,011 	OF oDlg PIXEL PICTURE "@!" WHEN .F.

	@ 025,010 SAY "Fecha Pedido"		SIZE 040,011 	OF oDlg PIXEL
	@ 025,080 MSGET _Data				SIZE 120,011 	OF oDlg PIXEL PICTURE "@!" WHEN .F.
	
	@ 040,010 SAY "Cliente"				SIZE 040,011 	OF oDlg PIXEL
	@ 040,080 MSGET _Client				SIZE 120,011 	OF oDlg PIXEL PICTURE "@!" WHEN .F.

	@ 055,010 SAY "Razon Social"		SIZE 040,011 	OF oDlg PIXEL
	@ 055,080 MSGET _NomCli				SIZE 120,011 	OF oDlg PIXEL PICTURE "@!" WHEN .F.

	@ 070,010 SAY "Tipo Doc."			SIZE 040,011 	OF oDlg PIXEL
	@ 070,080 MSGET _TipDoc				SIZE 120,011 	OF oDlg PIXEL PICTURE "@!" WHEN .F.

	@ 085,010 SAY "Moneda"				SIZE 040,011 	OF oDlg PIXEL
	@ 085,080 MSGET _Moeda				SIZE 120,011 	OF oDlg PIXEL PICTURE "@!" WHEN .F.

	@ 100,010 SAY "Banco"				SIZE 040,011 	OF oDlg PIXEL
	@ 100,080 MSGET _Banco				SIZE 120,011 	OF oDlg PIXEL PICTURE "@!" WHEN .F.

	@ 115,010 SAY "Cuenta Banco"		SIZE 040,011 	OF oDlg PIXEL
	@ 115,080 MSGET _Conta				SIZE 120,011 	OF oDlg PIXEL PICTURE "@!" WHEN .F.

	@ 130,010 SAY "Documento"			SIZE 040,011 	OF oDlg PIXEL
	@ 130,080 MSGET _Doc				SIZE 120,011 	OF oDlg PIXEL PICTURE "@!" WHEN .F.

	// @ 145,010 SAY "Valor Registrado"	SIZE 040,011 	OF oDlg PIXEL
	// @ 145,080 MSGET _Valor				SIZE 120,011 	OF oDlg PIXEL PICTURE "@E 999,999.99" WHEN .F.

	@ 160,010 SAY "Fecha Efectivacion"	SIZE 050,011 	OF oDlg PIXEL
	@ 160,080 MSGET _DataEf				SIZE 050,011 	OF oDlg PIXEL PICTURE "@!"  VALID !empty(_DataEf) 

	@ 175,010 SAY "Valor Efectivado"	SIZE 040,011 	OF oDlg PIXEL
	@ 175,080 MSGET _ValEfe				SIZE 050,011 	OF oDlg PIXEL PICTURE "@E 999,999.99" WHEN .F.		//VALID u_valMontos(_Valor,_ValEfe)

	//oTButton1 := TButton():New( 120,010, "Confirmar",oDlg,{||msgRun("Generando apunte de producción...", "Procesando...",{|| nOpc := runApunte() }),nCont++,oGet2:Setfocus(),oDlg:End()}, 35,15,,,.F.,.T.,.F.,,.F.,,,.F. )
	@ 195,060 BUTTON "Confirmar" SIZE 050,015 PIXEL OF oDlg ACTION (u_ALRFIN01(ZZW->ZZW_PEDIDO,ZZW->ZZW_SEQ,_DataEf,_ValEfe),oDlg:End())
	@ 195,120 BUTTON "Salir"	 SIZE 050,015 PIXEL OF oDlg ACTION ( oDlg:End() )

	Activate MSDialog oDlg Centered

	restArea(_aArea)

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
User Function ALRLEY()
     
    local _xArea := getArea()
	local aLegenda := {}

	aAdd(aLegenda,{"ENABLE" 	,"Documento Pendiente"})
	aAdd(aLegenda,{"DISABLE"	,"Documento Generado"})

	BrwLegenda("Efectivar Recibos Anticipados","Leyenda", aLegenda )
	
	RestArea(_xArea)

Return

User Function valMontos(nval_informado,nval_efectivado)

	local lret := .f.

	if nval_efectivado > 0

		if nval_efectivado <> nval_informado
			alert("Valor a efectivar es diferente del valor informado, informe al sector de ventas")
			lret := .f.
		else
			lret := .t.
		endif

	endif

Return(lret)
