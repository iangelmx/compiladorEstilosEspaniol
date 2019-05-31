%{
#include <stdio.h>  /* For printf, etc. */
#include <math.h>   /* For pow, used in the grammar.  */
#include "tabla.h"   /* Contains definition of 'symrec'.  */
int yylex (void);
void yyerror (char const *error) {printf("%s\t<- Error\n\n",error);}
void
init_table (void);
symrec *s;
%}

%define api.value.type union

%token <symrec*> TEXTO CAJA TABLA LISTA HIPERVINCULO IMAGEN EFECTO
%token DIRECCION FUENTE VINHETA 
%token TODOS REPITE PARACADA SI NO ES MIENTRAS
%token AGREGAATRIBUTO CLONAATRIBUTO MODIFICAATRIBUTO QUITAATRIBUTO
%token EQ_COMP MAYEQ_COMP MENEQ_COMP
%token H COMENTARIO

%token <int> TAMANHO BORDE ANCHO ALTO MARGEN TIPODATO D
%token <int> SUBRAYADO NEGRITAS CURSIVAS TACHADO MAYUSCULAS VISIBLE
%token <char*> FONDO POSICION ALINEACION TIPO COLORVISTO RELLENO COLOR CADENA identificador SELECTOR

%token <double>  NUM         								/* Simple double precision number.  */
%token <symrec*> VAR			     /* Symbol table pointer: variable and function.  */
%type  <symrec*>  exp
%type <symrec*>	declaracion



%precedence '='
%left '-' '+'
%left '*' '/'
%precedence NEG /* negation--unary minus */
%right '^'      /* exponentiation */
%% /* The grammar follows.  */


input:
%empty
| input line
;

line:
'\n'
| exp '\n'   { printf ("R = %d ;\n", $1->type); }
| error '\n' { yyerrok;                }
;


exp:
declaracion ';'					{ $$ = $1; printf("B_Vi una declaración UP, declaracion: %d\n\n", ($1->compatible));}
|	instruccion ';' 				{printf("B_Vi una INSTR...\n\n");}
| error  '\n' { yyerrok;               }
;

declaracion:
TIPODATO identificador				{  
	printf("B_Tipo dato recibido: %d\n", $1);
	printf("B_Valor identificador: %s\n", $2);
	
	printf("B_Vi una declaracion Down:\n\n");
	s = putsym ($2, $1);
	printf("B_Hizo pointer\n");
	printf("B_Buscará en la tabla\n");
	s = getsym ($2);														
														printf("B_Vi una declaración Down 2:\n\n");
                            if (!s){
                                //printf("No encontró a >%s<", yytext);
                                s = putsym ($2, $1);
                            }
														else{
															printf("B_Lo encontró en la tabla: %s, tipo: %d\n", s->name, s->type);
														}
														$$ = s; 
														printf("tipo y nombre: %d, %s", s->type, s->name);                           
}
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
