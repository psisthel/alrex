#INCLUDE "RWMAKE.CH"   
#INCLUDE "PROTHEUS.CH"

User Function MA410LEG
    
	local aLegend := {}
	
	aLegend := {	{"ENABLE"		,"Cotización"					},;
					{"BR_AMARELO"	,"Pedido Liberado"				},;
					{"BR_AZUL"		,"Pedido Parcialmente Apuntado"	},;
					{"BR_PINK"		,"Pedido Apuntado"				},;
					{"BR_LARANJA"	,"Pedido Parcialmente Apuntado"	},;
					{"BR_CINZA"		,"Guia de Remision Generada"	},;
					{"DISABLE"		,"Pedido Facturado"				}}

Return( aLegend )