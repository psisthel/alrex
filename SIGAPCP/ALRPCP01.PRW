#INCLUDE "protheus.ch"

User Function ALRPCP01

	Private cVldAlt := ".T."
	Private cVldExc := ".T."
	Private cString := "ZZV"

	DbSelectArea("ZZV")
	DbSetOrder(1)

	AxCadastro( cString ,"Apuntes de Produccion" , cVldAlt , cVldExc )

Return
