#include "protheus.CH"
#include "rwmake.CH"

User Function ZY3_PRECIO()

	private cUsrNoPerm	:= GetMv("AL_USRPRC")
	private cCadastro	:= "Parámetros de Precio"
	private aRotina		:=	{	{ "Buscar" , "AxPesqui" , 0, 1 },;
								{ "Visualizar" , "AxVisual" , 0, 2 },;
								{ "Incluir" , "u_fInclui()" , 0, 3 },;
								{ "Modificar" , "u_fAltera" , 0, 4 },;
								{ "Borrar" , "u_fBorrar" , 0, 5 } }

	MBrowse ( [1],[1],[250],[3],"ZY3")     

Return()


User Function fInclui(cAlias, nReg, nOpc)

	If !(Alltrim(cUserName)$cUsrNoPerm)
		AxInclui("ZY3", 0, 3)
	else
		alert("Usuario sin permiso para accesar esta rutina")
	endif

Return

User Function fAltera(cAlias, nReg, nOpc)

	If !(Alltrim(cUserName)$cUsrNoPerm)
		AxAltera(cAlias, nReg, nOpc)
	else
		alert("Usuario sin permiso para accesar esta rutina")
	endif

Return

User Function fBorrar(cAlias, nReg, nOpc)

	If !(Alltrim(cUserName)$cUsrNoPerm)
		AxDeleta(cAlias, nReg, nOpc)
	else
		alert("Usuario sin permiso para accesar esta rutina")
	endif

Return