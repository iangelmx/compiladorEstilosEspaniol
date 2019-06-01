%{
#include <stdio.h>  /* For printf, etc. */
#include <math.h>   /* For pow, used in the grammar.  */
#include "tabla.h"   /* Contains definition of 'symrec'.  */
int yylex (void);
void yyerror (char const *error) {printf("%s\t<- Error\n\n",error);}
void
init_table (void);
symrec *s;
int tipo;
char *strType;
char *strValor;
char *pre;
int indice;
int aux;
int auxiliarConteo = 0;
%}

%define api.value.type union

%token <symrec*> TEXTO CAJA TABLA LISTA HIPERVINCULO IMAGEN EFECTO
%token <int> FUENTE TAMANHO SUBRAYADO NEGRITAS CURSIVAS TACHADO MAYUSCULAS
%token DIRECCION VINHETA 
%token TODOS REPITE PARACADA SI NO ES MIENTRAS
%token AGREGAATRIBUTO CLONAATRIBUTO MODIFICAATRIBUTO QUITAATRIBUTO
%token EQ_COMP MAYEQ_COMP MENEQ_COMP
%token H COMENTARIO


%token <int>  BORDE ANCHO ALTO MARGEN TIPODATO D
%token <int>     VISIBLE
%token <char*> FONDO POSICION ALINEACION TIPO COLORVISTO RELLENO COLOR CADENA SELECTOR nombreId
%token <symrec*> identificador
%token <char*> id
%token <int> ATTR
%token <valores*> valor

%token <double>  NUM         								/* Simple double precision number.  */
%token <symrec*> VAR			     /* Symbol table pointer: variable and function.  */
%type  <symrec*>  exp
%type <symrec*>	declaracion
%type <symrec*> especificacion
%type <symrec*> especificaciones




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
declaracion ';'			{ $$ = $1; printf("B_Vi una declaración UP, declaracion: %d\n\n", ($1->type));}
|	instruccion ';' 				{printf("B_Vi una INSTR...\n\n");}
;

declaracion:
TIPODATO id	{  
							s = creaVariable($2, $1); 
							$$ = s;
							printf("B_tipo y nombre: %d, %s\n______\n", s->type, s->name);
						}
;

instruccion:
colocacion
|asociacion
|eliminacion
|funciones
;

asociacion:
identificador '.' SELECTOR '=' CADENA {
	printf("What?");
	printf("B_Cadena detectada: %s\n", $5);
	printf("B_Se va a buscar: %s\n", $1->name);
	s = getsym( $1->name );
	if(s){
		s->selector = $5;
		printf("%s{}\n", $5);
	}
	else{
		printf("Variable no declarada :/"); yyerrok;
	}
}
;

funciones:
REPITE NUM '{' instruccion '}'
;

eliminacion:
identificador QUITAATRIBUTO '(' especificacion ')'
|identificador QUITAATRIBUTO '(' TODOS ')'
;

colocacion:
identificador '.' AGREGAATRIBUTO '(' especificaciones ')'	{
	printf("B_Detecté una oper agregaatrr\n");
		s = getsym($1->name);
		printf("B_Va a buscar en colocación a: %s\n", $1->name);
		if(s){
			if(s->type == $5->type){
				printProperties($5);
				printf("\n");
			}
			printf("Nuevo valor de s: %s", s->value.valFuente);
		}
		else{
			printf("Variable no declarada"); yyerrok;
		}
	}
|identificador '.' MODIFICAATRIBUTO '(' especificacion ')'
|identificador '.' CLONAATRIBUTO '(' especificacion ')'
;

especificaciones:
ATTR '=' valor	{ 
	auxiliarConteo++;
	switch( $1 ){
		case FUENTE:
			printf("B_Me pareció ver un lindo gatito");
			if($3->tipo == 1){
				s = creaSimbolAux(auxiliarConteo, TEXTO);
				strcpy (s->value.valFuente,$3->valorStr);
				$$ = s;
			}
		break;
		case TAMANHO:
			if ($3->tipo == 1){
				s = creaSimbolAux(auxiliarConteo, TEXTO);
				strcpy (s->value.valTamanho,$3->valorStr);
				$$ = s;
			}
			else{
				//Mandar error;
			}
		break;
	}
 }
| ATTR {
	switch($1){
		case SUBRAYADO:
				s = creaSimbolAux(auxiliarConteo, TEXTO);
				s->value.valBoolSubrayado = 1;
				$$ = s;
			break;	
			case NEGRITAS:
				s = creaSimbolAux(auxiliarConteo, TEXTO);
				s->value.valBoolNegrita = 1;
				$$ = s;
			break;
			case CURSIVAS:
				s = creaSimbolAux(auxiliarConteo, TEXTO);
				s->value.valBoolCursiva = 1;
				$$ = s;
			break;
			case TACHADO:
				s = creaSimbolAux(auxiliarConteo, TEXTO);
				s->value.valBoolTachado = 1;
				$$ = s;
			break;
			case MAYUSCULAS:
				s = creaSimbolAux(auxiliarConteo, TEXTO);
				s->value.valBoolMayusculas = 1;
				$$ = s;
			break;
	}
}
;

especificacion: 
DIRECCION '=' CADENA					{ printf("Vi Direccion y cadena: %s\n", $3);	}
|FUENTE '=' CADENA						{ 
															
															}
|TAMANHO '=' D								{  }
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
