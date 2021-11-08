#Include "Rwmake.ch"
#Include "Protheus.ch"

User Function MA113BAR
    
	local aBotom := {}
	
	Aadd( aBotom,{"S4WB005N",{|| U_ALXCOM03() },"Importa P.C.","Importa P.C." })

Return( aBotom )