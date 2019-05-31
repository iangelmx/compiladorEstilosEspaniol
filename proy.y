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
%type <float> exp

%precedence '='
%left '-' '+'
%left '*' '/'
%precedence NEG /* negation--unary minus */
%% /* The grammar follows.  */

input:
%empty
| input line
;

line:
'\n'
| exp '\n'   { printf ("R = %f ;\n", $1); }
| error '\n' { yyerrok;                }
;


exp
:declaracion ';'
|instruccion ';'
;

declaracion
:TIPODATO secuenciaIds 
;

secuenciaIds
:identificador			
|secuenciaIds identificador
;

instruccion
:colocacion
|eliminacion
|funciones
;

funciones
:REPITE NUM '{' instruccion '}'


eliminacion
:identificador QUITAATRIBUTO '(' especificacion ')'
|identificador QUITAATRIBUTO '(' TODOS ')'
;

colocacion
:identificador '.' AGREGAATRIBUTO '(' especificacion ')'
|identificador '.' MODIFICAATRIBUTO '(' especificacion ')'
|identificador '.' CLONAATRIBUTO '(' especificacion ')'
;

especificacion 
:DIRECCION '=' CADENA
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
