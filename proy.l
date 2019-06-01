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
	
[0-9]+"."[0-9]+         { yylval.NUM = atof(yytext); return NUM;  }
[0-9]+                  { yylval.NUM = atoi(yytext); return NUM;  }
\n                      { return '\n'; }
[ ]
[-n+*/^=(){}.]                { printf("retorna glifo: ->%s<- \n", yytext); return *yytext;  }
[;]						{printf("Vi un ;\n");	return ';';}
[|]						{return '|';}
[!]						{return '!';}
[&]						{return '&';}

"texto"			{ yylval.TIPODATO = TEXTO; printf("Vi texto: %d |", TIPODATO); return(TIPODATO); } 
"caja"			{ yylval.TIPODATO = CAJA; printf("Vi una CAJA: %d |", TIPODATO); return(TIPODATO);  return(CAJA); }
"tabla"			{ yylval.TIPODATO = TABLA; return(TIPODATO);  return(TABLA); }
"lista"			{ yylval.TIPODATO = LISTA; return(LISTA); }
"hipervinculo"		{  return(HIPERVINCULO); }
"imagen"		{  return(IMAGEN); }
"efecto"		{  return(EFECTO); }



"direccion"		{ return(DIRECCION); }
"fuente"		{ yylval.ATTR=FUENTE; printf("Retorna fuente: %s\n", yytext); return(ATTR); }
"tamanho"		{  yylval.ATTR=TAMANHO;	return(ATTR); }
"subrayado"		{  yylval.ATTR=SUBRAYADO;	return(ATTR); }
"negritas"		{  yylval.ATTR=NEGRITAS;	return(ATTR); }
"cursivas"		{  yylval.ATTR=CURSIVAS;	return(ATTR); }
"tachado"		{  yylval.ATTR=TACHADO;	return(ATTR); 		}
"mayusculas"	{  yylval.ATTR=MAYUSCULAS;	return(ATTR); }
"ancho"			{  return(ANCHO); }
"alto"			{  return(ALTO); }
"borde"			{  return(BORDE); }
"fondo"			{  return(FONDO); }
"posicion"		{  return(POSICION); }
"alineacion"		{  return(ALINEACION); }
"tipo"			{  return(TIPO); }
"vinheta"		{  return(VINHETA); }
"colorVisto"		{  return(COLORVISTO); }
"margen"		{  return(MARGEN); }
"visible"		{  return(VISIBLE); }
"color"			{  return(COLOR); }

"asociaSelector"	{ return (SELECTOR); }
"agregaAtributo"	{ printf("Rertorna: agregaAtributo\n"); return(AGREGAATRIBUTO); }
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


\"(\\.|[^\\"])*\"	{ printf("Retorna la cadena: >%s<\n", yytext); 
						yylval.CADENA = yytext; 
						valores* v = creaValores();
						strcpy( v->valorStr, yytext );
						v->tipo = 1;
						yylval.valor = v;
						return(valor);
						return(CADENA);
					}
\/\*\s*([^\s]*)\s*\*\/	{ return(COMENTARIO);}
{L}+			{ printf("Vi un id: ->%s<- \n", yytext);
					symrec *s = getsym(yytext);
					if(s){
						yylval.identificador = s;
						//printf("Retorna identificador symrec\n");
						return identificador;
					}
					else{
						yylval.id=yytext;
						printf("Retorna id char* \n");
						return id;
					}
				}
"\""			{  return('"'); }
[,]			{  return(','); }
[>]			{  return( *yytext); }

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