%{
#include <stdio.h>  /* For printf, etc. */
#include <math.h>   /* For pow, used in the grammar.  */
#include "tabla.h"   /* Contains definition of 'symrec'.  */
int yylex (void);
void yyerror (char const *error) {printf("%s\t<- Error\n\n",error);}
void
init_table (void);
%}

%union{
	int entero;
	double decimal;
	char* cadena;
	struct variable{
	   int entero;
	   double db;
	   char* cadena;
	   char* nombre;
	   char* tipo; 
	} variable;
}


%token TEXTO CAJA TABLA LISTA HIPERVINCULO IMAGEN EFECTO
%token DIRECCION FUENTE TAMANHO SUBRAYADO NEGRITAS CURSIVAS TACHADO MAYUSCULAS ANCHO ALTO BORDE FONDO POSICION ALINEACION TIPO VINHETA COLORVISTO RELLENO MARGEN VISIBLE COLOR
%token TODOS REPITE PARACADA SI NO ES MIENTRAS
%token AGREGAATRIBUTO CLONAATRIBUTO MODIFICAATRIBUTO QUITAATRIBUTO
%token EQ_COMP MAYEQ_COMP MENEQ_COMP
%token TIPODATO NUM identificador COMENTARIO
%token CADENA
%token D H

%type <cadena> identificador


%precedence '='
%left '-' '+'
%left '*' '/'
%precedence NEG /* negation--unary minus */
%right '^'      /* exponentiation */
%% /* The grammar follows.  */

programa:
listaSentencias
;

listaSentencias:
|	sentencia
|	listaSentencias	sentencia
;

sentencia:
'\n'														
|	declaracion ';' '\n'					{printf("B_Vi una declaración UP\n\n");}
|	instruccion ';' '\n'				{printf("B_Vi una INSTR...\n\n");}
| error  '\n' { yyerrok;               }
;

declaracion:
TIPODATO secuenciaIds 				{printf("B_Vi una declaración Down\n");}
;

secuenciaIds:
identificador											{ printf("B_Vi un solo ID %s\n", $1); }
|secuenciaIds ',' identificador		{printf("B_Vi una seq Ids\n");}
;

instruccion:
colocacion
|eliminacion
|funciones
;

funciones:
REPITE NUM '{' instruccion '}'
;

eliminacion:
identificador QUITAATRIBUTO '(' especificacion ')'
|identificador QUITAATRIBUTO '(' TODOS ')'
;

colocacion:
identificador '.' AGREGAATRIBUTO '(' especificacion ')'
|identificador '.' MODIFICAATRIBUTO '(' especificacion ')'
|identificador '.' CLONAATRIBUTO '(' especificacion ')'
;

especificacion:
DIRECCION '=' CADENA
|FUENTE '=' D
|TAMANHO '=' D
|SUBRAYADO
|NEGRITAS
|CURSIVAS 
|TACHADO
|MAYUSCULAS
|ANCHO '='D
|ALTO '=' D
|BORDE '='
|FONDO '=' CADENA
|POSICION '=' CADENA 
|ALINEACION '=' CADENA
|TIPO '='CADENA
|VINHETA '=' CADENA
|COLORVISTO '=' H 
|MARGEN '=' D
|VISIBLE
|COLOR '='H
;

/* End of grammar.  */
%%
void
init_table (void);
int yydebug;

int main (int argc, char const* argv[])
{
  int i;
  /* Enable parse traces on option -p.  */
  for (i = 1; i < argc; ++i)
    if (!strcmp(argv[i], "-p"))
       yydebug = 1;
       init_table ();
    return yyparse ();
}
