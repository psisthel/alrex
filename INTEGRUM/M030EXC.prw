#Include 'Protheus.ch'

User Function M030EXC()
Local aArea :=GetArea()
Local lFound 

DbSelectArea("CV0")
DbSetOrder(2)
If DbSeek(xFilial("CV0")+SA1->A1_CGC) .OR. DbSeek(xFilial("CV0")+SA1->A1_PFISICA)
	Reclock("CV0",.F.)
	DbDelete()
	MsUnlock()
EndIf

RestArea(aArea)
Return