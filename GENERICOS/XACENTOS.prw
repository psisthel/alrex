#Include "Rwmake.ch"
#Include "Protheus.ch"

User Function XACENTOS(cstring)

    cstring = alltrim(cstring)
    
    cstring = replace(cstring,"�","N")
    cstring = replace(cstring,"�","n")
    
Return( cstring )
