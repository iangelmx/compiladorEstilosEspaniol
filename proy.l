%{
#include<stdlib.h>
#include <math.h>
#include "tabla.h"
#include "proy.tab.h"
%}

D			[0-9]+
L			[a-zA-Z_]+
H			[a-fA-F0-9]+
V   			(L+|D*)
ES			[:space:]

%%
	


"texto"			{ yylval.cadena = yytext; return(TIPODATO); } 
"caja"			{ yylval.variable.cadena = yytext; return(TIPODATO);  return(CAJA); }
"tabla"			{ yylval.cadena = yytext; return(TIPODATO);  return(TABLA); }
"lista"			{  return(LISTA); }
"hipervinculo"		{  return(HIPERVINCULO); }
"imagen"		{  return(IMAGEN); }
"efecto"		{  return(EFECTO); }



"direccion"		{  return(DIRECCION); }
"fuente"		{  return(FUENTE); }
"tamaNHo"		{  return(TAMANHO); }
"subrayado"		{  return(SUBRAYADO); }
"negritas"		{  return(NEGRITAS); }
"cursivas"		{  return(CURSIVAS); }
"tachado"		{  return(TACHADO); }
"mayusculas"		{  return(MAYUSCULAS); }
"ancho"			{  return(ANCHO); }
"alto"			{  return(ALTO); }
"borde"			{  return(BORDE); }
"fondo"			{  return(FONDO); }
"posicion"		{  return(POSICION); }
"alineacion"		{  return(ALINEACION); }
"tipo"			{  return(TIPO); }
"viNHeta"		{  return(VINHETA); }
"colorVisto"		{  return(COLORVISTO); }
"margen"		{  return(MARGEN); }
"visible"		{  return(VISIBLE); }
"color"			{  return(COLOR); }


"agregaAtributo"	{  return(AGREGAATRIBUTO); }
"clonaAtributo"		{  return(CLONAATRIBUTO); }
"modificaAtributo"	{  return(MODIFICAATRIBUTO); }
"quitaAtributo"		{  return(QUITAATRIBUTO); }

"todos"			{  return(TODOS); }
"repite"		{  return(REPITE); }
"paraCada"		{  return(PARACADA); }
"si"			{  return(SI); }
"no"			{  return(NO); /*POR QUE NO MANEJAMOS ESTO COMO !=*/}
"es"			{  return(ES); /*POR QUE NO MANEJAMOS ESTO COMO UN ==?*/}
"mientras"		{  return(MIENTRAS); }


\"(\\.|[^\\"])*\"	{ return(CADENA);}
\/\*\s*([^\s]*)\s*\*\/	{ return(COMENTARIO);}

"\""			{  return('"'); }
","			{  return(','); }
"."			{  return('.'); }
"&"			{  return('&'); }
"!"			{  return('!'); }
"-"			{  return('-'); }
"+"			{  return('+'); }
"*"			{  return('/'); }
"/"			{  return('/'); }
"%"			{  return('%'); }
"<"			{  return('<'); }
">"			{  return('>'); }
"|"			{  return('|'); }
"?"			{  return('?'); }
"="			{  return('='); }
"=="			{  return(EQ_COMP); /*TOMAR NOTA DEL NOMBRE*/}
">="			{  return(MAYEQ_COMP); /*TOMAR NOTA DEL NOMBRE*/}
"<="			{  return(MENEQ_COMP);/*TOMAR NOTA DEL NOMBRE*/ }
";"			{  return(';'); }

		

%%
void main()
	{
	
	
	}









