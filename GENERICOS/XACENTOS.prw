#Include "Rwmake.ch"
#Include "Protheus.ch"

User Function XACENTOS(cstring)

    cstring = alltrim(cstring)
    
    cstring = replace(cstring,"Ñ","N")
    cstring = replace(cstring,"ñ","n")
    
Return( cstring )
