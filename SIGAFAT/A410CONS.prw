#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} A410CONS
Ponto de Entrada
É chamada no momento de montar a enchoicebar do pedido de vendas, e serve para incluir mais botões com rotinas de usuário.
@author Sergio
@since 13/04/2016
@version undefined

@type function
/*/
User Function A410CONS()

	local alButtons	:= {}
	U_ALR00001(0, @alButtons)

	AADD(alButtons , {"AUTOM" ,{|| U_VERSTRUC(aCols[n][2]) },"Recetas", "Recetas" + " (F11)"} )
	SetKey(VK_F11,{|| U_VERSTRUC(aCols[n][2]) } )

Return alButtons