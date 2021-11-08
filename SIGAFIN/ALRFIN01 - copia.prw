#include "protheus.ch"
#INCLUDE "RWMAKE.CH"
#Include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALRFIN01  ºAutor  ³Percy Arias,SISTHEL º Data ³  09/13/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Genera RA a partir del PV                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ALRFIN01( _cNumPed, _cCodCliente )

	local _aArea	:= getArea()
	local _aSE1		:= {}
	local cErroTmp	:= ""
	local cModal	:= getNewPar("AL_MODPAD","0800001")
	local vPerg		:= Padr("FIN040",10)
	local cAliasSA6	:= getNextAlias()
	local npos		:= 0
	
	private lMsErroAuto := .f.
	
	dbSelectArea("SX1")
	dbSetOrder(1)

	If dbSeek(vPerg+"01")
		SX1->( RecLock("SX1",.f.) )
		SX1->X1_PRESEL := 2
		SX1->( MsUnlock() )
	EndIf

	If dbSeek(vPerg+"02")
		SX1->( RecLock("SX1",.f.) )
		SX1->X1_PRESEL := 2
		SX1->( MsUnlock() )
	EndIf

	If dbSeek(vPerg+"03")
		SX1->( RecLock("SX1",.f.) )
		SX1->X1_PRESEL := 2
		SX1->( MsUnlock() )
	EndIf

	Pergunte(vPerg,.F.)

	SA1->( dbSetOrder(1) )
	SC5->( dbSetOrder(1) )
	SA6->( dbSetOrder(1) )
	ZZW->( dbSetOrder(1) )
	
	ZZW->( MsSeek( xFilial("ZZW")+_cNumPed ) )
	SA1->( MsSeek( xFilial("SA1")+_cCodCliente ) )
	SC5->( MsSeek( xFilial("SC5")+_cNumPed ) )
	//SA6->( MsSeek( xFilial("SA6")+ZZW->ZZW_BANCO+ZZW->ZZW_AGENCIA+ZZW->ZZW_NUMCON ) )
	//SA6->( MsSeek( xFilial("SA6")+ZZW->ZZW_BANCO ) )

	csql := "SELECT A6_MOEDA,A6_AGENCIA,A6_NUMCON,R_E_C_N_O_ AS NREC"
	csql += "  FROM "+RetSqlName("SA6")
	csql += " WHERE A6_FILIAL='"+xFilial("SA6")+"'"
	csql += "   AND A6_COD='"+ZZW->ZZW_BANCO+"'"
	csql += "   AND D_E_L_E_T_=''"

	csql := ChangeQuery( csql ) 
			
	dbUseArea( .t., "TOPCONN", TcGenQry( ,,csql ), cAliasSA6, .F., .T. )   
			
	if (cAliasSA6)->( !Eof() )
		npos := (cAliasSA6)->NREC
	endif
	(cAliasSA6)->( DBCloseArea() )

	if npos > 0
 
		SA6->( dbgoto(npos) )
	
		_aSE1 := {	{"E1_NUM"		, _cNumPed							, Nil	},;
					{"E1_PREFIXO"	, "REC"								, Nil	},;
					{"E1_TIPO"		, "RA "								, Nil	},;
					{"E1_NATUREZ"	, cModal							, Nil	},;
					{"E1_CLIENTE"	, _cCodCliente						, Nil	},;
					{"E1_LOJA"		, SA1->A1_LOJA						, Nil	},;
					{"E1_EMISSAO"	, ZZW->ZZW_DATA						, Nil	},;
					{"E1_VENCTO"	, ZZW->ZZW_DATA						, Nil	},;
					{"E1_HIST"		, "RA GENERADO PEDIDO "+_cNumPed	, Nil	},;
					{"E1_MOEDA"		, SA6->A6_MOEDA						, Nil	},;
					{"E1_TXMOEDA"	, SC5->C5_TXMOEDA					, Nil	},;
					{"E1_VALOR"		, ZZW->ZZW_VALOR					, Nil	},;
					// {"CBCOAUTO"		, ZZW->ZZW_BANCO					, Nil	},;
					// {"CAGEAUTO"		, SA6->A6_AGENCIA					, Nil	},;
					// {"CCTAAUTO"		, SA6->A6_NUMCON					, Nil	} }
									
		MsExecAuto( { |x,y| FINA040(x,y)} , _aSE1, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão

		If lMsErroAuto
			cErroTmp := Mostraerro() 
		Else
			cErroTmp := ""
			
			ZZW->( RecLock("ZZW",.f.) )
			ZZW->ZZW_STATUS	:= "1"
			ZZW->( MsUnlock() )
			
		Endif
	else
		alert("¡ Cuenta bancaria no encontrada !")
	endif 
	
	restArea( _aArea )

Return( cErroTmp )
