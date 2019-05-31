#include "tabla.h"

symrec *sym_table;

symrec *putsym (char const *sym_name, int sym_type)
{
  symrec *ptr = (symrec *) malloc (sizeof (symrec));
  ptr->name = (char *) malloc (strlen (sym_name) + 1);
  strcpy (ptr->name,sym_name);
  ptr->type = sym_type;
  ptr->value.valorInt = 0; /* Set value to 0 even if fctn.  */
  ptr->value.valorStr = ""; /* Set value to 0 even if fctn.  */
  ptr->next = (struct symrec *)sym_table;
  sym_table = ptr;
  return ptr;
}

symrec *getsym (char const *sym_name)
{
  symrec *ptr;
  for (ptr = sym_table; ptr != (symrec *) 0;
    ptr = (symrec *)ptr->next)
  if (strcmp (ptr->name, sym_name) == 0)
    return ptr;
  return 0;
}

struct init const arith_fncts[] =
{
  { "atan", atan },
  { "cos",  cos  },
  { "exp",  exp  },
  { "ln",   log  },
  { "seno",  sin  },
  { "sqrt", sqrt },
  { 0, 0 },
};

const char *type_names[]={
  "texto","caja","tabla","lista","hipervinculo","imagen","efecto","direccion","fuente",
  "tamaNHo","subrayado","negritas","cursivas","tachado","mayusculas","ancho","alto",
  "borde","fondo","posicion","alineacion","tipo","viNHeta","colorVisto",
  "margen","visible","color","agregaAtributo","clonaAtributo","modificaAtributo","quitaAtributo",
  "todos","repite","paraCada","si","no","es","mientras"
};



void
init_table (void){
  int i;
  for (i = 0; arith_fncts[i].fname != 0; i++){
    symrec *ptr = putsym (arith_fncts[i].fname, 260);
    //symrec *ptr = putsym (arith_fncts[i].fname, 260);
    ptr->value.fnctptr = arith_fncts[i].fnct;
  }
}

