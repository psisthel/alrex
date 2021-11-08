#Include "Rwmake.ch"
#Include "Protheus.ch"
#include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BVIEWSB2  ºAutor  ³Microsiga           º Data ³  10/05/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Adiciona botao para consulta de stock en todas las         º±±
±±º          ³ sucursales do grupo                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function BVIEWSB2

	Local aArea		:= GetArea()
	Local _aDados	:= {}
	Local nList		:= 0
	Local oLst
	
	Private oDlg
	Private _bRet	:= .F.
	Private nChoice	:= SB1->B1_COD
	
	_aDados := _getSaldo( nChoice )
	
	If Len( _aDados ) > 0
	
		If _aDados[1][1] <> ""
	
			iif(nList = 0,nList := 1,nList)
			
			Define MsDialog oDlg Title "Saldos en Stock" FROM 0,0 TO 295,550 PIXEL
				
			@ 5,5 LISTBOX oLst VAR lVarMat Fields HEADER "Sucursal","Almacen","Actual","Reservas" SIZE 270,120 On DblClick ( ConfChoice(oLst:nAt, @_aDados, @_bRet) ) OF oDlg PIXEL
				
			oLst:SetArray(_aDados)
			oLst:nAt := nList
			oLst:bLine := { || { _aDados[oLst:nAt,1], _aDados[oLst:nAt,2], Transform( _aDados[oLst:nAt,3],"999,999.99"), Transform( _aDados[oLst:nAt,4],"999,999.99") }}
				 
			//DEFINE SBUTTON FROM 130,5  TYPE 1  ACTION ConfChoice(oLst:nAt, @_aDados, @_bRet) ENABLE OF oDlg
			//DEFINE SBUTTON FROM 130,40 TYPE 2  ACTION ( nChoice:=0,oDlg:End() ) ENABLE OF oDlg 
			DEFINE SBUTTON FROM 130,5 TYPE 2  ACTION ( nChoice:=0,oDlg:End() ) ENABLE OF oDlg 
				 
			Activate MSDialog oDlg Centered
			
		EndIf

	EndIf
	
	RestArea( aArea )

Return( nChoice	)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BVIEWSB2  ºAutor  ³Microsiga           º Data ³  10/05/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _getSaldo( cProduto )

	Local oArea		:= getArea()
	Local cQry1		:= ""
	Local nPrcCosto	:= 0
	Local cAlias
	Local aUltComp	:= {}

	cQry1 := "SELECT B2_FILIAL,B2_COD,B2_LOCAL,B2_QATU,B2_RESERVA"
   	cQry1 += "  FROM " + RetSqlname("SB2")
	cQry1 += " WHERE B2_COD = '" + cProduto + "'"
 	cQry1 += "   AND D_E_L_E_T_ = ' '"
   	cQry1 += " ORDER BY B2_FILIAL,B2_COD" 
   	
	cAlias := CriaTrab(Nil,.F.)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQry1),cAlias, .F., .T.)
 
	If (cAlias)->( !Eof() )
		While (cAlias)->( !Eof() )
			Aadd( aUltComp, { (cAlias)->B2_FILIAL, (cAlias)->B2_LOCAL, (cAlias)->B2_QATU, (cAlias)->B2_RESERVA }  )
			(cAlias)->( dbSkip() )
		End
	Else
		Aadd( aUltComp, { "", "", 0, 0 } )
	Endif
	
	(cAlias)->( dbCloseArea() )
	
	RestArea( oArea )

Return( aUltComp )

