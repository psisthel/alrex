#INCLUDE "protheus.ch"

User Function ALRPCP03

	Private cVldAlt := ".T."
	Private cVldExc := ".T."
	Private cString := "ZZU"

	DbSelectArea("ZZU")
	DbSetOrder(1)

	AxCadastro( cString ,"Familias X Fases de Produccion" , cVldAlt , cVldExc )

Return
