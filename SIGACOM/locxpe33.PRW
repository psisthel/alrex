#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLOCXPE33  บAutor  ณPercy Arias,SISTHEL บ Data ณ  05/29/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Adicionar campos en la factura directa - Institucional     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FUSAC - Peru                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function LOCXPE33

	Local _aArea	:= GetArea()
	LOCAL aCposFact := Paramixb[1]
	
	if Alltrim(FunName())=="MATA467N" 			// Rutina de Factura de salida
	    
		If cNFTipo=="A" .And. nNFTipo==19
			aAdd(aCposFact,{NIL,"F2_SERIE2",NIL,NIL,NIL,"",NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,".T."})  // Campo numero de serie 2
		endif

		aAdd(aCposFact,{NIL,"F2_DIACTB",NIL,NIL,NIL,"",NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,".T."})  // Campo numero de serie 2
   
	elseIf Alltrim(FunName())=="MATA101N" 			// Rutina de Factura de Entrada

		//If cNFTipo=="N" .and. nNFTipo==10		// FACTURA DE ENTRADA
			//aAdd(aCposFact,{NIL,"F1_TPRENTA",NIL,NIL,NIL,"",NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,".T."})  // Campo deL tipo de renta
			aAdd(aCposFact,{NIL,"F1_YGLOSA",NIL,NIL,NIL,"",NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,".T."})  //03/09/2018
		//EndIf
		
	ElseIf Alltrim(Funname()) == 'MATA465N'		// nota de credito y debito del para el proveedor (salida de mercaderia del stock)
	
		If cNFTipo=="D" .And. nNFTipo==4	// nota de credito cliente
			aAdd(aCposFact,{NIL,"F1_YTPNCC",NIL,NIL,NIL,"",NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,".T."})  // Campo deL tipo nota de credito
			
			nPosNatur := Ascan(aCposFact,{|x| AllTrim(x[2]) == 'F1_NATUREZ' })
			nPosSeri2 := Ascan(aCposFact,{|x| AllTrim(x[2]) == 'F1_SERIE2' })
			aCposNCC := {}
			
			For nL := 1 To Len(aCposFact)
				
				If nL == nPosNatur
					aAdd(aCposNCC,aCposFact[nPosSeri2])
				ElseIf nL == nPosSeri2
					aAdd(aCposNCC,aCposFact[nPosNatur])
				Else
					aAdd(aCposNCC,aCposFact[nL])
				EndIf
				
			Next nL
			
			aCposFact := AClone(ACposNCC)
	
			nPosNatur := Ascan(aCposFact,{|x| AllTrim(x[2]) == 'F1_SERIE2' })
			nPosSeri2 := Ascan(aCposFact,{|x| AllTrim(x[2]) == 'F1_SERIE' })
			aCposNCC := {}
		
			For nL := 1 To Len(aCposFact)
				
				If nL == nPosNatur
					aAdd(aCposNCC,aCposFact[nPosSeri2])
				ElseIf nL == nPosSeri2
					aAdd(aCposNCC,aCposFact[nPosNatur])
				Else
					aAdd(aCposNCC,aCposFact[nL])
				EndIf
				
			Next nL
			
			aCposFact := AClone(ACposNCC)
	
			nPosNatur := Ascan(aCposFact,{|x| AllTrim(x[2]) == 'F1_DOC' })
			nPosSeri2 := Ascan(aCposFact,{|x| AllTrim(x[2]) == 'F1_ESPECIE' })
			aCposNCC := {}
		
			For nL := 1 To Len(aCposFact)
				
				If nL == nPosNatur
					aAdd(aCposNCC,aCposFact[nPosSeri2])
				ElseIf nL == nPosSeri2
					aAdd(aCposNCC,aCposFact[nPosNatur])
				Else
					aAdd(aCposNCC,aCposFact[nL])
				EndIf
				
			Next nL
			
			aCposFact := AClone(ACposNCC)
	
		Endif
		
	EndIf

	RestArea(_aArea)
   
Return( aCposFact )
