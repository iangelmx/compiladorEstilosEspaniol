%{
#include <stdio.h>  /* For printf, etc. */
#include <math.h>   /* For pow, used in the grammar.  */
#include "tabla.h"   /* Contains definition of 'symrec'.  */
int yylex (void);
void yyerror (char const *error) {printf("%s\t<- Error\n\n",error);}
void
init_table (void);
void verificaTiposYAsigna(symrec *a, symrec *b);
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
%token DIRECCION VINHETA FONDOIMG FINSI
%token CAJA_Y_TABLA CAJA_TABLA_TEXTO_LISTA_HIPERV
%token TODOS REPITE PARACADA SI NO ES MIENTRAS
%token AGREGAATRIBUTO CLONAATRIBUTO MODIFICAATRIBUTO QUITAATRIBUTO
%token EQ_COMP MAYEQ_COMP MENEQ_COMP
%token H COMENTARIO CIERRASELECTOR


%token BORDE ANCHO ALTO MARGEN D
%token <int>  TIPODATO   VISIBLE COLORVISTO COLOR
%token <char*> FONDO POSICION ALINEACION TIPO RELLENO CADENA SELECTOR nombreId
%token <symrec*> identificador
%token <char*> id
%token <int> ATTR
%token <valores*> valor

%token <double>  NUM         								/* Simple double precision number.  */
%token <symrec*> VAR			     /* Symbol table pointer: variable and function.  */
%type  <symrec*>  exp
%type <symrec*>	declaracion
%type <symrec*> especificaciones
%type <double> expresion




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
| seleccion						{printf( "Vi una sentencia de seleccion" );}
;

seleccion:
	SI '(' expresion ')' ':' line FINSI			{	  if( $3 == 1 ){
																								printf("B_IF TRUE\n");
																							}else{
																								printf("B_IF False\n");
																							}
																						}
;

expresion:
NUM 												{$$ = $1;}
| identificador												{$$ = $1->compatible;}
| identificador ES TIPODATO    				{ $$ = $1->type == $3; }
| identificador '.' ATTR '=' valor 	{ 
		switch($5->tipo){
			case 2:
				switch($3){
					case ALTO:
						$$ = $5->valorInt == $1->value.valAltura;
					break;
					case ANCHO:
						$$ = $5->valorInt == $1->value.valAnchura;
					break;
					case BORDE:
						$$ = $5->valorInt == $1->value.valBorde;
					break;
				}
			break;
		}
 }
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
identificador '.' CIERRASELECTOR	{ cierraSelector( $1 ); }
;

asociacion:
identificador '.' SELECTOR '=' '"' valor '"' {
	printf("What?");
	if( $5->tipo==1 ){
		s = $1;
		strcpy( s->selector, $5->valorStr );
	}else{
		printf("AttributeError: El selector debe ser una cadena\n");/*hace*/
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
identificador '.' AGREGAATRIBUTO '(' especificaciones ')'			{
																																printf("B_Detecté una oper agregaatrr\n");
																																	verificaTiposYAsigna($1, $5);

																																}
|identificador '.' MODIFICAATRIBUTO '(' especificaciones ')'		{
																																		printf("B_Detecté una oper modificaAttr\n");
																																		verificaTiposYAsigna($1, $5);
																																}
|identificador '.' CLONAATRIBUTO '(' identificador ',' ATTR ')'	
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
				s->value.valTamanho = $3->valorInt;
				$$ = s;
			}
			else{
				//Mandar error;
			}
		break;
		case FONDO:
			s = creaSimbolAux(auxiliarConteo, CAJA_Y_TABLA);
			s->value.valFondo, $3->valorInt;
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
			s->value.valColorVista, $3->valorInt;
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
			s->value.color, $3->valorInt;
			$$ = s;
		break;
		case ANCHO:
			s = creaSimbolAux(auxiliarConteo, CAJA_Y_TABLA);
			s->value.valAnchura = $3->valorInt;
			//Para cajas y tablas.
			$$ = s;
		break;
		case ALTO:
			s = creaSimbolAux(auxiliarConteo, CAJA_Y_TABLA);
			s->value.valAltura = $3->valorInt;
			//Para cajas y tablas.
			$$ = s;
		break;
		case BORDE:
			s = creaSimbolAux(auxiliarConteo, CAJA_Y_TABLA);
			s->value.valBorde = $3->valorInt;
			//Para cajas y tablas.
			$$ = s;
		break;
		default:
			$$ = NULL;
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


void verificaTiposYAsigna(symrec *a, symrec *b){
	if(a){
		if(a->type == b->type){
			incluyeNuevaPropiedad(a, b);
			printf("Se supone que se añadió el nuevo atributo");
		}
		else if((a->type == CAJA_Y_TABLA || a->type==CAJA_TABLA_TEXTO_LISTA_HIPERV) && (a->type == CAJA || a->type==TABLA) ){
			incluyeNuevaPropiedad(a, b);
			printf("Se supone que se añadió UN nuevo atributo");
		}
		else{
			printf("AttributeError: Tipos de dato incompatibles: %d y %d\n\n", a->type, b->type);
		}
	}
	else{
		printf("Variable no declarada");
	}
}
