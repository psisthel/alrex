#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF2460I   ºAutor  ³Microsiga           ºFecha ³  12/17/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE para modificar el tipo de doc gerado na facturacion     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SF2460I
	
	Local aArea 	:= GetArea()  
	Local aAreaSF2  := SF2->( GetArea() ) 
	Local cSerie	:= SF2->F2_SERIE
	local _xNomCli	:= ""
	
	IF (FunName()=="MATA468N")
	
		_xNomCli := Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE,"SA1->A1_NREDUZ")
		if empty(_xNomCli)
			_xNomCli := Left(Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE,"SA1->A1_NOME"),TamSX3("F2_YNOMCLI")[1])
		endif
		
		SF2->( RecLock("SF2",.F.) )
		SF2->F2_YNOMCLI := _xNomCli			//Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE,"SA1->A1_NREDUZ")
		SF2->F2_YCOD := SC5->C5_NUM
		If SUBSTR(cSerie,1,1)=="F"              
		  	SF2->F2_TPDOC = '01'
		ElseIF SUBSTR(cSerie,1,1)=="B" 
			SF2->F2_TPDOC = '03'	
		EndIf
		SF2->( MsUnLock() )
		
		SD2->( dbSetOrder(3) )
		If SD2->( dbSeek( xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA ) )
		
			While SF2->( xFilial("SF2")+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA ) == SD2->( xFilial("SD2")+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA ) .And.;
					SD2->( !Eof() )
				
				SD2->( RecLock("SD2",.f.) )
				SD2->D2_YNOMCLI := _xNomCli			//Posicione("SA1",1,xFilial("SA1")+SD2->D2_CLIENTE,"SA1->A1_NREDUZ")
				SD2->D2_YDESCRI := Left(Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"SB1->B1_DESC"),30)
				SD2->( MsUnlock() )
				SD2->( dbSkip() )
			
			End
			
		EndIf
		
	EndIf	
	
	/*
	If Aviso("I M P R E S I O N !","¿ Desea Imprimir las Facturas ? ",{"SI","NO"}) =1 
	 
		U_ALR001(.T.)                                      
	
 	endif
 	*/
	
	MsgInfo("Se enviara la factura generada a SUNAT"+CRLF+"¡ ENTER para continuar !","ALREX")
	U_NFE001( .T.,.F. )
	
	RestArea( aAreaSF2)
	RestArea( aArea )
	
RETURN (.T.)