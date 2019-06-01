#include "tabla.h"

symrec *sym_table;

symrec *putsym (char const *sym_name, int sym_type)
{
  symrec *ptr = (symrec *) malloc (sizeof (symrec));
  ptr->name = (char *) malloc (strlen (sym_name) + 1);
  strcpy (ptr->name,sym_name);
  ptr->type = sym_type;
  ptr->compatible = 0;
  ptr->selector = (char *) malloc (sizeof (char) );
  ptr->value.valorInt = 0; /* Set value to 0 even if fctn.  */
  ptr->value.valorStr = (char *) malloc (sizeof (sym_name) + 1); /* Set value to 0 even if fctn.  */
  ptr->value.valFuente = (char *) malloc (sizeof (sym_name) + 1);
  ptr->value.valTamanho = (char *) malloc (sizeof (sym_name) + 1);
  ptr->value.valBoolSubrayado =0;
  ptr->value.valBoolNegrita = 0;
  ptr->value.valBoolCursiva = 0;
  ptr->value.valBoolTachado = 0;
  ptr->value.valBoolMayusculas= 0; 
  ptr->value.valAnchura = (char *) malloc (sizeof (char) );
  ptr->value.valAltura = (char *) malloc (sizeof (char) );
  ptr->value.valBorde = (char *) malloc (sizeof (char) );
  ptr->value.valFondo = (char *) malloc (sizeof (char) );
  ptr->value.valPosicion = (char *) malloc (sizeof (char) );
  ptr->value.valAlineacion = (char *) malloc (sizeof (char) );
  ptr->value.valColorVista = (char *) malloc (sizeof (char) );
  ptr->value.margen = (char *) malloc (sizeof (char) );
  ptr->value.valVisibilidad = 0;
  ptr->value.color = (char *) malloc (sizeof (char) );
  ptr->next = (struct symrec *)sym_table;
  sym_table = ptr;
  return ptr;
}

symrec *getsym (char const *sym_name)
{
  symrec *ptr;
  for (ptr = sym_table; ptr != (symrec *) 0; ptr = (symrec *)ptr->next)
    if (strcmp (ptr->name, sym_name) == 0)
      return ptr;
    else
      printf("Este no es: %s\n", ptr->name);
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

symrec *creaVariable(char const *sym_name, int tipo ){
  symrec * s;
  //printf("B_Tipo dato recibido: %d\n", tipo);
  //printf("B_Valor identificador: %s\n", sym_name);
  
  //printf("B_Vi una declaracion Down:\n\n");
  s = putsym (sym_name, tipo);
  //printf("B_Hizo pointer\n");
  //printf("B_Buscará en la tabla\n");
  s = getsym (sym_name);
  return s;

}
void cleanStruct( symrec *ptr ){
  strcpy( ptr->name, "" );
  ptr->compatible = 0;
  ptr->value.valorInt = 0; /* Set value to 0 even if fctn.  */
  strcpy( ptr->value.valorStr, "" );
  strcpy( ptr->value.valFuente, "" );
  strcpy( ptr->value.valTamanho, "" );
  ptr->value.valBoolSubrayado =0;
  ptr->value.valBoolNegrita = 0;
  ptr->value.valBoolCursiva = 0;
  ptr->value.valBoolTachado = 0;
  ptr->value.valBoolMayusculas= 0; 
  strcpy( ptr->value.valAnchura , "" );
  strcpy( ptr->value.valAltura , "" );
  strcpy( ptr->value.valBorde , "" );
  strcpy( ptr->value.valFondo , "" );
  strcpy( ptr->value.valPosicion , "" );
  strcpy( ptr->value.valAlineacion , "" );
  strcpy( ptr->value.valColorVista , "" );
  strcpy( ptr->value.margen , "" );
  ptr->value.valVisibilidad = 0;
  strcpy( ptr->value.color , "" );
  ptr->next = NULL;
}


void printProperties( symrec* s ){
  if( s->value.valorInt != 0 ){
    printf("%d",s->value.valorInt);
  }
  if( s->value.valFuente != 0 ){
    printf("font-family: %s;", s->value.valFuente);
  }
}

valores* creaValores(){
  valores* ptr = (valores*) malloc( sizeof(valores) );
  ptr->valorStr = (char*) malloc(sizeof(char));
  strcpy (ptr->valorStr,"");
  ptr->valorInt = 0;
  ptr->valorDouble = 0;
  ptr->tipo = 0;
}


symrec *creaSimbolAux(int auxiliarConteo, int tipoDato){
  symrec *s;
  char *pre;
  pre=malloc(sizeof(char));
  sprintf(pre, "%d", auxiliarConteo);
  s = putsym( pre, tipoDato );
  free(pre);
  return s;
}

void imprimeValores(symrec *elemento){

}

/*clonaValores( symrec* s1  symrec* s2 ){
  
}

imprimeCss(){

}*/
