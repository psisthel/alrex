#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALRFAT03  ºAutor  ³Microsiga           º Data ³  06/14/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Actualiza dados del cliente a partir del pedido de venta   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ALREX                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ALRFAT03

	local _aArea	:= getArea()
	local oDlg
	local oTButton1
	local oGroup1
	local oGroup2

	if empty(M->C5_CLIENTE)
		alert("Digite o escoja el codigo del cliente valido!")
		Return(.f.)
	endif
	
	SA1->( dbSetOrder(1) )
	if SA1->( !dbSeek( xFilial("SA1")+M->C5_CLIENTE ) )
		Return(.f.)
	endif

	private cRUC			:= SA1->A1_CGC
	private cRazon			:= alltrim(SA1->A1_NOME)+space( tamSX3("A1_NOME")[1]-len( alltrim(SA1->A1_NOME) ) )
	private cEnde			:= alltrim(SA1->A1_END)+space( tamSX3("A1_END")[1]-len( alltrim(SA1->A1_END) ) )
	private cNro1			:= alltrim(SA1->A1_YNRODIR)+space( tamSX3("A1_YNRODIR")[1]-len( alltrim(SA1->A1_YNRODIR) ) )
	private cNro2			:= alltrim(SA1->A1_YNROINT)+space( tamSX3("A1_YNRODIR")[1]-len( alltrim(SA1->A1_YNRODIR) ) )
	private cComple			:= alltrim(SA1->A1_COMPLEM)+space( tamSX3("A1_COMPLEM")[1]-len( alltrim(SA1->A1_COMPLEM) ) )
	private cDistrito		:= alltrim(SA1->A1_BAIRRO)+space( tamSX3("A1_BAIRRO")[1]-len( alltrim(SA1->A1_BAIRRO) ) )
	private cProvincia		:= alltrim(SA1->A1_MUN)+space( tamSX3("A1_MUN")[1]-len( alltrim(SA1->A1_MUN) ) )
	private cDpto	  		:= alltrim(SA1->A1_EST)+space( tamSX3("A1_EST")[1]-len( alltrim(SA1->A1_EST) ) )
	if !empty(SA1->A1_TEL)
		private cTel			:= alltrim(SA1->A1_TEL)+space( tamSX3("A1_TEL")[1]-len( alltrim(SA1->A1_TEL) ) )
	else
		private cTel			:= alltrim(SA1->A1_YCELULA)+space( tamSX3("A1_YCELULA")[1]-len( alltrim(SA1->A1_YCELULA) ) )
	endif
	private cMail			:= alltrim(SA1->A1_EMAIL)+space( tamSX3("A1_EMAIL")[1]-len( alltrim(SA1->A1_EMAIL) ) )

	private cEndEntr		:= alltrim(SA1->A1_ENDENT)+space( tamSX3("A1_ENDENT")[1]-len( alltrim(SA1->A1_ENDENT) ) )
	private cComEntr		:= alltrim(SA1->A1_YCOMDIR)+space( tamSX3("A1_YCOMDIR")[1]-len( alltrim(SA1->A1_YCOMDIR) ) )
	private cDisEntr		:= alltrim(SA1->A1_BAIRROE)+space( tamSX3("A1_BAIRROE")[1]-len( alltrim(SA1->A1_BAIRROE) ) )
	private cProEntr		:= alltrim(SA1->A1_MUNE)+space( tamSX3("A1_MUNE")[1]-len( alltrim(SA1->A1_MUNE) ) )
	private cDptEntr		:= alltrim(SA1->A1_ESTE)+space( tamSX3("A1_ESTE")[1]-len( alltrim(SA1->A1_ESTE) ) )

	private cNomDpto		:= alltrim(SA1->A1_ESTADO)+space( tamSX3("A1_ESTADO")[1]-len( alltrim(SA1->A1_ESTADO) ) )	
	private cNomDptEntr		:= alltrim(SA1->A1_YESTADO)+space( tamSX3("A1_YESTADO")[1]-len( alltrim(SA1->A1_YESTADO) ) )	
	
	
	Define MsDialog oDlg Title "Registro de Clientes" FROM 0,0 TO 600,500 PIXEL

	oGroup1:= TGroup():New(005,005,175,240,'Dirección Fiscal ',oDlg,,,.T.)
	oGroup2:= TGroup():New(180,005,275,240,'Dirección de Entrega ',oDlg,,,.T.)

	@ 020,010 SAY "RUC"				SIZE 040,011 	OF oDlg PIXEL
	@ 020,060 MSGET cRUC			SIZE 170,011 	OF oDlg PIXEL PICTURE "@!" WHEN .F.
	@ 035,010 SAY "Razon Social"	SIZE 040,011 	OF oDlg PIXEL
	@ 035,060 MSGET cRazon			SIZE 170,011 	OF oDlg PIXEL PICTURE "@!"
	@ 050,010 SAY "Direccion"		SIZE 040,011 	OF oDlg PIXEL
	@ 050,060 MSGET cEnde			SIZE 170,011 	OF oDlg PIXEL PICTURE "@!"
	@ 065,010 SAY "Nro/Interior"	SIZE 040,011 	OF oDlg PIXEL
	@ 065,060 MSGET cNro1			SIZE 060,011 	OF oDlg PIXEL PICTURE "@!"
	@ 065,120 MSGET cNro2			SIZE 110,011 	OF oDlg PIXEL PICTURE "@!"
	@ 080,010 SAY "Complemento"		SIZE 040,011 	OF oDlg PIXEL
	@ 080,060 MSGET cComple			SIZE 170,011 	OF oDlg PIXEL PICTURE "@!"
	@ 095,010 SAY "Distrito"		SIZE 040,011 	OF oDlg PIXEL
	@ 095,060 MSGET cDistrito		SIZE 170,011 	OF oDlg PIXEL PICTURE "@!"
	@ 110,010 SAY "Provincia"		SIZE 040,011 	OF oDlg PIXEL
	@ 110,060 MSGET cProvincia		SIZE 170,011 	OF oDlg PIXEL PICTURE "@!"
	@ 125,010 SAY "Departamento"	SIZE 040,011 	OF oDlg PIXEL
	@ 125,060 MSGET cDpto			SIZE 020,011 	OF oDlg PIXEL PICTURE "@!" WHEN xPosici1(cDpto) F3 "12"
	@ 125,080 MSGET cNomDpto		SIZE 150,011 	OF oDlg PIXEL PICTURE "@!" WHEN .F.
	@ 140,010 SAY "Telefono"		SIZE 040,011 	OF oDlg PIXEL
	@ 140,060 MSGET cTel			SIZE 170,011 	OF oDlg PIXEL PICTURE "@!"
	@ 155,010 SAY "E-mail"			SIZE 040,011 	OF oDlg PIXEL
	@ 155,060 MSGET cMail			SIZE 170,011 	OF oDlg PIXEL PICTURE "@!"

	@ 195,010 SAY "Direccion"		SIZE 040,011 	OF oDlg PIXEL
	@ 195,060 MSGET cEndEntr		SIZE 170,011 	OF oDlg PIXEL PICTURE "@!"
	@ 210,010 SAY "Complemento"		SIZE 040,011 	OF oDlg PIXEL
	@ 210,060 MSGET cComEntr		SIZE 170,011 	OF oDlg PIXEL PICTURE "@!"
	@ 225,010 SAY "Distrito"		SIZE 040,011 	OF oDlg PIXEL
	@ 225,060 MSGET cDisEntr		SIZE 170,011 	OF oDlg PIXEL PICTURE "@!"
	@ 240,010 SAY "Provincia"		SIZE 040,011 	OF oDlg PIXEL
	@ 240,060 MSGET cProEntr		SIZE 170,011 	OF oDlg PIXEL PICTURE "@!"
	@ 255,010 SAY "Departamento"	SIZE 040,011 	OF oDlg PIXEL
	@ 255,060 MSGET cDptEntr		SIZE 020,011 	OF oDlg PIXEL PICTURE "@!" WHEN xPosici2(cDptEntr) F3 "12"
	@ 255,080 MSGET cNomDptEntr		SIZE 150,011 	OF oDlg PIXEL PICTURE "@!" WHEN .F.

	oTButton1 := TButton():New( 280, 190, "Confirmar",oDlg,{|| xGrava(),oDlg:End()}, 50,15,,,.F.,.T.,.F.,,.F.,,,.F. )   

	Activate MSDialog oDlg Centered
	
	restArea( _aArea )

Return(.t.)

Static Function xPosici1( cDp )

	SX5->( dbSetOrder(1) )
	If SX5->( dbSeek( xFilial("SX5")+"12"+cDp ) )
		cNomDpto := SX5->X5_DESCSPA
	else
		cNomDpto := ""
	EndIf
	
Return

Static Function xPosici2( cDp )

	SX5->( dbSetOrder(1) )
	If SX5->( dbSeek( xFilial("SX5")+"12"+cDp ) )
		cNomDptEntr := SX5->X5_DESCSPA
	else
		cNomDptEntr := ""
	EndIf
	
Return

Static Function xGrava()
            
	SA1->( Reclock("SA1",.f.) )
	SA1->A1_NOME	:= cRazon
	SA1->A1_END		:= cEnde
	SA1->A1_YNRODIR	:= cNro1
	SA1->A1_YNROINT	:= cNro2
	SA1->A1_COMPLEM	:= cComple
	SA1->A1_BAIRRO	:= cDistrito
	SA1->A1_MUN		:= cProvincia
	SA1->A1_EST		:= cDpto
	SA1->A1_TEL		:= cTel
	SA1->A1_EMAIL	:= cMail
	SA1->A1_ENDENT	:= cEndEntr
	SA1->A1_YCOMDIR	:= cComEntr
	SA1->A1_BAIRROE	:= cDisEntr
	SA1->A1_MUNE	:= cProEntr
	SA1->A1_ESTE	:= cDptEntr
	SA1->A1_ESTADO	:= cNomDpto
	SA1->A1_YESTADO	:= cNomDptEntr
	SA1->( MsUnlock() )

Return