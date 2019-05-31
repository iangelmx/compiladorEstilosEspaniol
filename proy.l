%{
#include<stdlib.h>
#include <math.h>
#include "tabla.h"
#include "proy.tab.h"
int valor = 0;
%}

D			[0-9]+
L			[a-zA-Z_]+
H			[a-fA-F0-9]+
V   			(L+|D*)
ES			[:space:]

%%
	
[0-9]+"."[0-9]+         { yylval.decimal = atof(yytext); return NUM;  }
[0-9]+                  { yylval.entero = atoi(yytext); return NUM;  }
\n                      { return '\n'; }
[ ]
[-n+*/^=(){}]                { printf("retorna: %s \n", yytext); return *yytext;  }
[;]						{printf("Vi un ;\n");	return ',';}
[|]						{return '|';}
[!]						{return '!';}
[&]						{return '&';}

"texto"			{ yylval.cadena = yytext; printf("Vi texto: %d", TIPODATO); return(TIPODATO); } 
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
[a-zA-Z]+			{ yylval.cadena = yytext; printf("Vi un id: %s \n", yytext); return identificador;}

"\""			{  return('"'); }
[,]			{  return(','); }
">"			{  return( *yytext); }
"|"			{  return('|'); }
%%

int indice = 0;

int check_type(){
	for(indice=0; indice < 38; indice++){
		if(! strcmp(yytext, type_names[indice]) ){
			return( TIPODATO );
		}
	}
/*
* pseudo code --- this is what it should check
*
*	if (yytext == type_name)
*		return(TYPE_NAME);
*
*	return(identificador);
*/
	return(identificador);
}