D			[0-9]+
L			[a-zA-Z_]+
H			[a-fA-F0-9]+
V   			(L+|D*)
ES			[:space:]

%{
#include <stdio.h>
#include "proy.tab.h"
%}
%%
	


"texto"			{ count(); return(TEXTO); }
"caja"			{ count(); return(CAJA); }
"tabla"			{ count(); return(TABLA); }
"lista"			{ count(); return(LISTA); }
"hipervinculo"		{ count(); return(HIPERVINCULO); }
"imagen"		{ count(); return(IMAGEN); }
"efecto"		{ count(); return(EFECTO); }



"direccion"		{ count(); return(DIRECCION); }
"fuente"		{ count(); return(FUENTE); }
"tamaño"		{ count(); return(TAMAÑO); }
"subrayado"		{ count(); return(SUBRAYADO); }
"negritas"		{ count(); return(NEGRITAS); }
"cursivas"		{ count(); return(CURSIVAS); }
"tachado"		{ count(); return(TACHADO); }
"mayusculas"		{ count(); return(MAYUSCULAS); }
"ancho"			{ count(); return(ANCHO); }
"alto"			{ count(); return(ALTO); }
"borde"			{ count(); return(BORDE); }
"fondo"			{ count(); return(FONDO); }
"posicion"		{ count(); return(POSICION); }
"alineacion"		{ count(); return(ALINEACION); }
"tipo"			{ count(); return(TIPO); }
"viñeta"		{ count(); return(VIÑETA); }
"colorVisto"		{ count(); return(COLORVISTO); }
"margen"		{ count(); return(MARGEN); }
"visible"		{ count(); return(VISIBLE); }
"color"			{ count(); return(COLOR); }


"agregaAtributo"	{ count(); return(AGREGAATRIBUTO); }
"clonaAtributo"		{ count(); return(CLONAATRIBUTO); }
"modificaAtributo"	{ count(); return(MODIFICAATRIBUTO); }
"quitaAtributo"		{ count(); return(QUITAATRIBUTO); }

"todos"			{ count(); return(TODOS); }
"repite"		{ count(); return(REPITE); }
"paraCada"		{ count(); return(PARACADA); }
"si"			{ count(); return(SI); }
"no"			{ count(); return(NO); /*POR QUE NO MANEJAMOS ESTO COMO !=*/}
"es"			{ count(); return(ES); /*POR QUE NO MANEJAMOS ESTO COMO UN ==?*/}
"mientras"		{ count(); return(MIENTRAS); }


\"(\\.|[^\\"])*\"	{count(); return(CADENA);}
\/\*\s*([^\s]*)\s*\*\/	{count(); return(COMENTARIO);}

"\""			{ count(); return('"'); }
","			{ count(); return(','); }
"."			{ count(); return('.'); }
"&"			{ count(); return('&'); }
"!"			{ count(); return('!'); }
"-"			{ count(); return('-'); }
"+"			{ count(); return('+'); }
"*"			{ count(); return('/'); }
"/"			{ count(); return('/'); }
"%"			{ count(); return('%'); }
"<"			{ count(); return('<'); }
">"			{ count(); return('>'); }
"|"			{ count(); return('|'); }
"?"			{ count(); return('?'); }
"="			{ count(); return('='); }
"=="			{ count(); return(EQ_COMP); /*TOMAR NOTA DEL NOMBRE*/}
">="			{ count(); return(MAYEQ_COMP); /*TOMAR NOTA DEL NOMBRE*/}
"<="			{ count(); return(MENEQ_COMP);/*TOMAR NOTA DEL NOMBRE*/ }
";"			{ count(); return(';'); }

		

%%
void main()
	{
	
	
	}









