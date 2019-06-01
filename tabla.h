#include <stdlib.h> /* malloc. */
#include <string.h> /* strlen. */
#include <stdio.h>
#include <math.h>
#include <stdio.h>



#ifndef __TABLA_H__
#define __TABLA_H__
/* Function type.  */
typedef double (*func_t) (double);
struct init
{
  char const *fname;
  double (*fnct) (double);
};

struct valores{
  char *valorStr;
  int valorInt;
  double valorDouble;
  int tipo;
};

typedef struct valores valores;


struct valorVar{
    char *valorStr;
    int valorInt;
    func_t fnctptr;  /* value of a FNCT */
    char *valFuente;
    char *valTamanho;
    int valBoolSubrayado;
    int valBoolNegrita;
    int valBoolCursiva;
    int valBoolTachado;
    int valBoolMayusculas;
    char *valAnchura;
    char *valAltura;
    char *valBorde;
    char *valFondo;
    char *valPosicion;
    char *valAlineacion;
    char *valColorVista;
    char *margen;
    int valVisibilidad;
    char *color;
};
typedef struct valorVar datos;

/* Data type for links in the chain of symbols.  */
struct symrec
{
  char *name;  /* name of symbol */
  int type;    /* type of symbol: either VAR or FNCT */
  int *compatible;
  char *selector;
  datos value; 
  struct symrec *next;  /* link field */
};

typedef struct symrec symrec;


/* The symbol table: a chain of 'struct symrec'.  */
extern symrec *sym_table;
//extern symrec *FNCT;


////>>>
extern int yydebug;
extern const char *type_names[];
extern int check_type(void);
extern symrec *creaVariable(char const *sym_name, int tipo );
extern symrec *validaExistencia(char const *sym_name);
extern void cleanStruct( symrec *s );
extern void printProperties( symrec *s );
extern valores* creaValores();
extern symrec *creaSimbolAux(int auxiliarConteo, int tipoDato);
extern void imprimeValores(symrec *elemento);
//extern YYSTYPE yylval;

symrec *putsym (char const *, int);
symrec *getsym (char const *);




/* Put arithmetic functions in table.  */
void
init_table (void);
#endif
