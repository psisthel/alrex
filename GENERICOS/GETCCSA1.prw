#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"  
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RPTDEF.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GETCCSA1  ºAutor  ³Microsiga           º Data ³  05/02/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca contactos del cliente, tabla principal SA1->SU5      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GETCCSA1( clCodFor, clLjFor, clSeparador )

	Local clChave	:= ""
	Local clAlias	:= "TCC" + AllTrim( Str( Randomize(1, 10000) ) )
	Local clRet		:= ""

	Default clSeparador := ","
	
	if !Empty( clCodFor ) .And. !Empty( clLjFor )
	
		clChave := PADR(clCodFor, TAMSX3("A1_COD")[1] ) + PADR(clLjFor, TAMSX3("A1_LOJA")[1] )
	
		BEGINSQL ALIAS clAlias
							
		SELECT  SU5.U5_EMAIL
		FROM %Table:AC8% AC8
		JOIN %Table:SU5% SU5
		ON AC8.AC8_CODCON = SU5.U5_CODCONT
		WHERE AC8.AC8_FILIAL = %xFilial:AC8%
		  AND AC8.AC8_CODENT = %Exp:clChave%
		  AND AC8.%notdel%
		  AND SU5.%notdel%
		  
		ENDSQL
		
		( clAlias )->( dbGoTop() )
		
		While ( clAlias )->( !Eof() )
			clRet += AllTrim( ( clAlias )->U5_EMAIL ) + clSeparador
			( clAlias )->( dbSkip() )
		EndDo
		( clAlias )->( dbCloseArea() )
		
		if !Empty( clRet )
			clRet := SUBSTR(clRet, 1, ( Len( clRet ) -1 ) )
		endif
		
	endif

Return clRet
