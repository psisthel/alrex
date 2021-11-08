#INCLUDE "rwmake.ch"    
#Include "protheus.ch"          

USER FUNCTION ALRP002()


Return Iif(SD3->D3_TM<="500","+","-")