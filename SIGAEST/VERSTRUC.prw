#include "protheus.ch"
#include "rwmake.ch"
#include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVERSTRUC  บAutor  ณMicrosiga           บFecha ณ  11/19/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Muestra la estrutura del produto valorizado - costo        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function VERSTRUC(_cprod)

	Local aArea		:= GetArea()
	Local cQry		:= ""
	Local cAlias1
	Local nTotal	:= 0
	Local nQtdes	:= 0
	Local oDlg		:= nil
	Local aDadosSG1 := {}
	Local oLst
	Local nCantBase	:= Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_QB")
	Local aRetSD1	:= {}
	Local aRetEst	:= {}
	Local _xLocPrd	:= GetNewPar("AL_ALMPRD","P01")
	
	Default _cprod := SC2->C2_PRODUTO
	
	cQry := "SELECT G1_TRT,G1_COD,G1_COMP,G1_QUANT,G1_PERDA"
	cQry += "  FROM " + RetSqlName("SG1") + " SG1"
	cQry += " WHERE SG1.D_E_L_E_T_<>'*'"
	cQry += "   AND G1_COD='" + _cprod + "'"  
	
	cAlias1 := CriaTrab(Nil,.F.)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQry),cAlias1, .F., .T.)
 
	(cAlias1)->(DbGoTop())
	If (cAlias1)->(Eof())
		Return .F.
	Endif
 
	While (cAlias1)->(!Eof())
	
		aRetSD1 := u_GETULTPR( (cAlias1)->G1_COMP,(cAlias1)->G1_QUANT,nCantBase ) 
		aRetEst := _getSaldo( (cAlias1)->G1_COMP,_xLocPrd )
		nPrcCosto := aRetSD1[1]
	
		aAdd( aDadosSG1, { (cAlias1)->G1_COMP,;
				Posicione("SB1",1,xFilial("SB1")+(cAlias1)->G1_COMP,"B1_DESC"),;
				if(empty((cAlias1)->G1_TRT),"001",(cAlias1)->G1_TRT),;
				transform((cAlias1)->G1_QUANT,"@E 9,999.999"),;
				transform(aRetEst[1][3],"@E 9,999.999"),;
				transform(aRetEst[1][4],"@E 9,999.999"),;
				transform(aRetEst[1][5],"@E 9,999.999"),;
				transform(aRetEst[1][6],"@E 9,999.999"),;
				transform( nPrcCosto,"@E 9,999.999") } )
				
		nQtdes+=(cAlias1)->G1_QUANT
		nTotal+=nPrcCosto
		
		(cAlias1)->(DbSkip())

	End
	
	(cAlias1)->( dbCloseArea() )
	
	aSort( aDadosSG1,1,, { |x, y| x[4] > y[4] } )
	
	Define MsDialog oDlg Title "Estructura de Productos" From 0,0 To 450, 900 Of oMainWnd Pixel
 
	@  5,005 SAY "Producto:"  SIZE 50,20 OF oDlg PIXEL 
	@  5,420 SAY "Cant.Base:" SIZE 50,20 OF oDlg PIXEL 
	
	@ 15,005 SAY Posicione("SB1",1,xFilial("SB1")+_cprod,"B1_DESC")  SIZE 130,8.5 OF oDlg  PIXEL
	@ 15,420 SAY transform(nCantBase,"@E 999,999.999")  SIZE 130,8.5 OF oDlg  PIXEL

	@ 25,5 LISTBOX oLst VAR lVarMat Fields HEADER "Componente","Descripcion","Seq","Solicitada","Disponible","Reserva","Empe๑o","Empe๑o Prev.","Costo" SIZE 440,160 OF oDlg PIXEL // largura,altura
 
	oLst:SetArray(aDadosSG1)
	oLst:bLine := { || {aDadosSG1[oLst:nAt,1], aDadosSG1[oLst:nAt,2], aDadosSG1[oLst:nAt,3], aDadosSG1[oLst:nAt,4], aDadosSG1[oLst:nAt,5], aDadosSG1[oLst:nAt,6], aDadosSG1[oLst:nAt,7], aDadosSG1[oLst:nAt,8] }}
 
 	@  190,005 SAY "Total Qtd.:" SIZE 50,40 OF oDlg PIXEL 
	@  190,055 SAY transform(nQtdes,"@E 999,999.999")  SIZE 130,8.5 OF oDlg  PIXEL
 	@  200,005 SAY "Total Costo:" SIZE 50,40 OF oDlg PIXEL 
	@  200,055 SAY transform(nTotal,"@E 999,999.999")  SIZE 130,8.5 OF oDlg  PIXEL

	DEFINE SBUTTON FROM 195,420 TYPE 2  ACTION oDlg:End() ENABLE OF oDlg
	//@ 090,050 BUTTON "Cerrar" SIZE 035,015 PIXEL OF oDlg ACTION (oDlg:End())
 
	Activate MSDialog oDlg Centered

	RestArea(aArea)
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVERSTRUC  บAutor  ณMicrosiga           บ Data ณ  01/24/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GETULTPR( cComponente, nQtde, nQtdBase )

	Local cQry1		:= ""
	Local nPrcCosto	:= 0
	Local cAlias
	Local aUltComp	:= {}
	
	cQry1 := "SELECT D1_COD,D1_VUNIT,MAX(D1_EMISSAO) D1_EMISSAO,MAX(F1_HORA) F1_HORA"
	cQry1 += "  FROM " + RetSqlname("SD1") + " SD1, " + RetSqlname("SF1") + " SF1"
	cQry1 += " WHERE D1_FILIAL='" + xFilial("SD1") + "'"
	cQry1 += "   AND F1_FILIAL='" + xFilial("SF1") + "'"
	cQry1 += "   AND SD1.D_E_L_E_T_<>'*'"
	cQry1 += "   AND SF1.D_E_L_E_T_<>'*'"
   	cQry1 += "   AND D1_DOC=F1_DOC"
   	cQry1 += "   AND D1_SERIE=F1_SERIE"
	cQry1 += "   AND D1_DOC<>' '"
	cQry1 += "   AND D1_TIPO='N'"
	cQry1 += "   AND D1_COD='" + cComponente + "'"
	cQry1 += "   AND D1_VUNIT>0"
 	cQry1 += " GROUP BY D1_COD,D1_VUNIT"             
 	cQry1 += " ORDER BY D1_EMISSAO DESC"
	
	/*
	cQry1 := "SELECT B1_COD,B1_DESC,B1_QB,B1_CUSTD"
	cQry1 += "  FROM " + RetSqlname("SB1")
	cQry1 += " WHERE B1_FILIAL='" + xFilial("SB1") + "'"
	cQry1 += "   AND D_E_L_E_T_<>'*'"
	cQry1 += "   AND B1_COD='" + cComponente + "'"
	*/
	
	cAlias := CriaTrab(Nil,.F.)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQry1),cAlias, .F., .T.)
 
	If (cAlias)->( !Eof() )
		//Aadd( aUltComp,( (cAlias)->D1_VUNIT/nQtdBase ) )
		Aadd( aUltComp,( nQtde/(cAlias)->D1_VUNIT ) )
		Aadd( aUltComp,(cAlias)->D1_EMISSAO )
		//Aadd( aUltComp,( (cAlias)->B1_CUSTD/nQtdBase ) )
		//Aadd( aUltComp,dDataBase )
	Else
		Aadd( aUltComp,0 )
		Aadd( aUltComp,dDataBase )
	Endif
	
	(cAlias)->( dbCloseArea() )

Return( aUltComp )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVERSTRUC  บAutor  ณMicrosiga           บ Data ณ  04/11/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _getSaldo( vProduto,vLocal )

	Local oArea		:= getArea()
	Local cQry1		:= ""
	Local nPrcCosto	:= 0
	Local cAlias
	Local aUltComp	:= {}

	cQry1 := "SELECT B2_FILIAL,B2_COD,B2_LOCAL,B2_QATU,B2_RESERVA,B2_QEMP,B2_QEMPPRE"
   	cQry1 += "  FROM " + RetSqlname("SB2")
	cQry1 += " WHERE B2_FILIAL='" + xFilial("SB2") + "'"
	cQry1 += "   AND B2_COD = '" + vProduto + "'"
	cQry1 += "   AND B2_LOCAL = '" + vLocal + "'"
 	cQry1 += "   AND D_E_L_E_T_ = ' '"
   	cQry1 += " ORDER BY B2_FILIAL,B2_COD" 
   	
	cAlias := CriaTrab(Nil,.F.)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQry1),cAlias, .F., .T.)
 
	If (cAlias)->( !Eof() )
		While (cAlias)->( !Eof() )
			Aadd( aUltComp, {	(cAlias)->B2_FILIAL,;
								(cAlias)->B2_LOCAL,;
								(cAlias)->B2_QATU,;
								(cAlias)->B2_RESERVA,;
								(cAlias)->B2_QEMP,;
								(cAlias)->B2_QEMPPRE }  )
			(cAlias)->( dbSkip() )
		End
	Else
		Aadd( aUltComp, { "", "", 0, 0, 0, 0 } )
	Endif
	
	(cAlias)->( dbCloseArea() )
	
	RestArea( oArea )

Return( aUltComp )

