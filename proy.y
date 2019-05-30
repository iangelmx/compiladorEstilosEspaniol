%define api.value.type union /* Generate YYSTYPE from these types:  */

%token TEXTO CAJA TABLA LISTA HIPERVINCULO IMAGEN EFECTO
%token DIRECCION FUENTE TAMAÑO SUBRAYADO NEGRITAS CURSIVAS TACHADO MAYUSCULAS ANCHO ALTO BORDE FONDO POSICION ALINEACION TIPO VIÑETA COLORVISTO RELLENO MARGEN VISIBLE COLOR
%token TODOS REPITE PARACADA SI NO ES MIENTRAS
%token AGREGAATRIBUTO CLONAATRIBUTO MODIFICAATRIBUTO QUITAATRIBUTO
%token EQ_COMP MAYEQ_COMP MENEQ_COMP

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
| exp '\n'   { printf ("R = %.10g ;\n", $1); }
| error '\n' { yyerrok;                }
;


exp
:declaracion ';'
|instruccion ';'
;

declaracion
:tipodato secuenciaIds 
;

secuenciaIds
:identificador			{$$ =$}
|secuenciaIds identificador
;

instruccion
:colocacion
|eliminacion
|funciones
;

funciones
:REPITE '(' instruccion ',' D ')'


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
|TAMAÑO '=' D
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
|VIÑETA '=' CADENA
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
