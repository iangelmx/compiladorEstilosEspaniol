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
%token DIRECCION VINHETA FONDOIMG
%token CAJA_Y_TABLA CAJA_TABLA_TEXTO_LISTA_HIPERV
%token TODOS REPITE PARACADA SI NO ES MIENTRAS
%token AGREGAATRIBUTO CLONAATRIBUTO MODIFICAATRIBUTO QUITAATRIBUTO
%token EQ_COMP MAYEQ_COMP MENEQ_COMP
%token H COMENTARIO CIERRASELECTOR


%token BORDE ANCHO ALTO MARGEN TIPODATO D
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
|cierraComponente
|funciones
;

cierraComponente:
identificador '.' CIERRASELECTOR	{ imprimeValores( $1 ); }
;

asociacion:
identificador '.' SELECTOR '=' valor {
	printf("What?");
	if( $5->tipo==1 ){
		printf("B_Cadena detectada: %s\n", $5->valorStr);
		s = $1;
		strcpy( s->selector, $5->valorStr );
		printf("Pasó strcpy \n");
		
	}else{
		printf("Tipo incompatible");
		s->compatible=-1;
	}
}
;

funciones:
REPITE NUM '{' instruccion '}'
;

eliminacion:
identificador QUITAATRIBUTO '(' ATTR ')'
|identificador QUITAATRIBUTO '(' TODOS ')'
;

colocacion:
identificador '.' AGREGAATRIBUTO '(' especificaciones ')'	{
	printf("B_Detecté una oper agregaatrr\n");
		s = $1;
		if(s){
			if(s->type == $5->type){
				incluyeNuevaPropiedad(s, $5);
				printf("Se supone que se añadió el nuevo atributo");
			}
			else if((s->type == CAJA_Y_TABLA || s->type==CAJA_TABLA_TEXTO_LISTA_HIPERV) && ($1->type == CAJA || $1->type==TABLA){
				incluyeNuevaPropiedad(s, $5);
				printf("Se supone que se añadió UN nuevo atributo");
			}			
		}
		else{
			printf("Variable no declarada"); yyerrok;
		}
	}
|identificador '.' MODIFICAATRIBUTO '(' especificaciones ')'
|identificador '.' CLONAATRIBUTO '(' especificaciones ')'
;

especificaciones:
ATTR '=' valor	{ 
	auxiliarConteo++;
	switch( $1 ){
		case FUENTE:
			if($3->tipo == 1){
				//printf("Tipo de valor: %d\n", $3->tipo);
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
		case ANCHO:
			s = creaSimbolAux(auxiliarConteo, CAJA_Y_TABLA);
			strcpy (s->value.valAnchura, $3->valorStr);
			 //Para cajas y tablas.
			$$ = s;
		break;
		case ALTO:
			s = creaSimbolAux(auxiliarConteo, CAJA_Y_TABLA);
			strcpy (s->value.valAltura, $3->valorStr);
			 //Para cajas y tablas.
			$$ = s;
		break;
		case BORDE:
			s = creaSimbolAux(auxiliarConteo, CAJA_Y_TABLA);
			strcpy (s->value.valBorde, $3->valorStr);
			 //Para cajas y tablas.
			$$ = s;
		break;
		case FONDO:
			s = creaSimbolAux(auxiliarConteo, CAJA_Y_TABLA);
			strcpy (s->value.valFondo, $3->valorStr);
			 //Para cajas y tablas.
			$$ = s;
		break;
		case FONDOIMG:
			s = creaSimbolAux(auxiliarConteo, CAJA_Y_TABLA);
			strcpy (s->value.valFondoImg, $3->valorStr);
			 //Para cajas y tablas.
			$$ = s;
		break;
		case POSICION:
			s = creaSimbolAux(auxiliarConteo, CAJA_Y_TABLA);
			strcpy (s->value.valPosicion, $3->valorStr);
			 //Para cajas y tablas.
			$$ = s;
		break;
		case ALINEACION:
			s = creaSimbolAux(auxiliarConteo, TABLA);
			strcpy (s->value.valAlineacion, $3->valorStr);
			$$ = s;
		break;
		case COLORVISTO:
			s = creaSimbolAux(auxiliarConteo, HIPERVINCULO);
			strcpy (s->value.valColorVista, $3->valorStr);
			$$ = s;
		break;
		case MARGEN:
			s = creaSimbolAux(auxiliarConteo, CAJA_TABLA_TEXTO_LISTA_HIPERV);
			strcpy (s->value.margen, $3->valorStr);
			$$ = s;
		break;
		case VISIBLE:
			s = creaSimbolAux(auxiliarConteo, CAJA_TABLA_TEXTO_LISTA_HIPERV);
			s->value.valVisibilidad = $3->valorInt;
			$$ = s;
		break;
		case COLOR:
			s = creaSimbolAux(auxiliarConteo, CAJA_TABLA_TEXTO_LISTA_HIPERV);
			strcpy (s->value.color, $3->valorStr);
			$$ = s;
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
