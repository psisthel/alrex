#Include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA410COR  บAutor  ณPercy Arias,SISTHEL บ Data ณ  04/24/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PE para adicionar una nueva leyenda al momento de la       บฑฑ
ฑฑบ          ณ liberacion del apunte de produccion, para generar la GR    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MA410COR()

	local aCoresPE	:= ParamIXB
	//local aCoresPE := {}

	aAdd(aCoresPE,{})
	aIns(aCoresPE, 7)
	//aCoresPE[1] := {"C5_TIPOCLI == 'X'", "BR_PRETO", "Pedido destinado เ Exporta็ใo"}
	/*
	aCoresPE[1] := {"Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ)"	, "GREEN"		, "Pedido em Aberto"}
	aCoresPE[2] := {"!Empty(C5_NOTA).Or.C5_LIBEROK=='E' .And. Empty(C5_BLQ)"	, "RED"			, "Pedido Encerrado"}
	aCoresPE[3] := {"!Empty(C5_LIBEROK).And.Empty(C5_NOTA).And. Empty(C5_BLQ)"	, "YELLOW"		, "Pedido Liberado"}
	aCoresPE[4] := {"C5_BLQ == '1'"												, "BLUE"		, "Pedido Bloquedo por regra"}
	aCoresPE[5] := {"C5_BLQ == '2'"												, "ORANGE"		, "Pedido Bloquedo por verba"}
	aCoresPE[6] := {"AllTrim(C5_NOTA)=='REMITO'"								, "GREY"		, "Remito Generado"}
	*/
	//aCoresPE[1] := {"C5_YSTATUS == '9'"											, "BR_PINK"		, "Pedido Apuntado"}
	
	aCoresPE[1] := {"Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ)"	, "GREEN"		, "Cotizaci๓n"}
	aCoresPE[2] := {"C5_YSTATUS == '9' .AND. empty(C5_NOTA)"					, "BR_PINK"		, "Pedido Apuntado"}
	aCoresPE[3] := {"C5_YSTATUS == '7' .AND. empty(C5_NOTA)"					, "BR_AZUL"		, "Pedido Parcialmente Apuntado"}
	aCoresPE[4] := {"AllTrim(C5_NOTA)=='REMITO'"								, "BR_CINZA"	, "Remito Generado"}
	aCoresPE[5] := {"Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ)"	, "ENABLE"		, "Pedido eN AbIerto"}
	aCoresPE[6] := {"!Empty(C5_LIBEROK).And.Empty(C5_NOTA).And. Empty(C5_BLQ)"	, "YELLOW"		, "Pedido Liberado"}
	aCoresPE[7] := {"!Empty(C5_NOTA).Or.C5_LIBEROK=='E' .And. Empty(C5_BLQ)"	, "RED"			, "Pedido Encerrado"}

Return aCoresPE