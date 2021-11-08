#Include "Rwmake.ch"
#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRETIRACHARบAutor  ณPercy Arias,SISTHEL บ Data ณ  11/21/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retira caracteres especiales para envio de la FE           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RetiraCh(cTexto)

	local cChar := ""
	local i := 0
	local cNovo := ""

    For i := 1 To Len(cTexto)
        cChar = substr(cTexto, i, 1)
        If cChar = "/"
            cChar := ""
        ElseIf cChar = "\"
            cChar := ""
        ElseIf cChar = "!" 
            cChar := ""
        ElseIf cChar = "~" 
            cChar := ""
        ElseIf cChar = "@" 
            cChar := ""
        ElseIf cChar = "#" 
            cChar := ""
        ElseIf cChar = "$" 
            cChar := ""
        ElseIf cChar = "%" 
            cChar := ""
        ElseIf cChar = "^" 
            cChar := ""
        ElseIf cChar = "&" 
            cChar := ""
        ElseIf cChar = "*" 
            cChar := ""
        ElseIf cChar = "(" 
            cChar := ""
        ElseIf cChar = ")" 
            cChar := ""
        ElseIf cChar = "-" 
            cChar := ""
        ElseIf cChar = "." 
            cChar := ""
        ElseIf cChar = "," 
            cChar := " "
        ElseIf cChar = ";" 
            cChar := " "
        ElseIf cChar = "_" 
            cChar := ""
        ElseIf cChar = "'" 
            cChar := ""
        ElseIf cChar = "[" 
            cChar := ""
        ElseIf cChar = "]" 
            cChar := ""
        ElseIf cChar = '"' 
            cChar := ""
        ElseIf cChar = "?" 
            cChar := ""
        End If
        
        cNovo = cNovo + cChar
    
    Next i

Return(cNovo)
