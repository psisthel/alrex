#include "protheus.CH"
#include "rwmake.CH"

User Function ZY4_PROMO()
Private cCadastro := "Promociones"
Private aRotina := {{ "Buscar" , "AxPesqui" , 0, 1 },;
{ "Visualizar" , "AxVisual" , 0, 2 },;
{ "Incluir" , "AxInclui" , 0, 3 },;
{ "Modificar" , "AxAltera" , 0, 4 },;
{ "Borrar" , "AxDeleta" , 0, 5 } }
MBrowse ( [1],[1],[250],[3],"ZY4")     

Return()
