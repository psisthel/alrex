#Include "Rwmake.ch"
#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RETIRACHAR�Autor  �Percy Arias,SISTHEL � Data �  11/21/19   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retira caracteres especiales para envio de la FE           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
