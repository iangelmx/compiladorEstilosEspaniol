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
  ptr->value.valTamanho = 0;
  ptr->value.valBoolSubrayado =0;
  ptr->value.valBoolNegrita = 0;
  ptr->value.valBoolCursiva = 0;
  ptr->value.valBoolTachado = 0;
  ptr->value.valBoolMayusculas= 0; 
  ptr->value.valAnchura = 0;
  ptr->value.valAltura = 0;
  ptr->value.valBorde = 0;
  ptr->value.valFondo = (char *) malloc (sizeof (char) );
  ptr->value.valFondoImg = (char *) malloc (sizeof (char) );
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
  ptr->value.valTamanho = 0;
  ptr->value.valBoolSubrayado =0;
  ptr->value.valBoolNegrita = 0;
  ptr->value.valBoolCursiva = 0;
  ptr->value.valBoolTachado = 0;
  ptr->value.valBoolMayusculas= 0; 
  ptr->value.valAnchura = 0;
  ptr->value.valAltura = 0;
  ptr->value.valBorde = 0;
  strcpy( ptr->value.valFondo , "" );
  strcpy( ptr->value.valFondoImg , "" );
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

void cierraSelector(symrec *s){
	printf("%s { \n", s->selector);
	switch(s->type){
		case 1:
			if(strcmp("", s->value.valFuente) != 0){	
				printf("font-family: %s;\n", s->value.valFuente);
		 	}
			if( s->value.valTamanho != 0 ){
				printf("font-size: %d;pt\n", s->value.valTamanho);
		 	}
			if( s->value.valBoolSubrayado != 0 ){
				printf("text-decoration: underline\n");
		 	}
			if( s->value.valBoolNegrita != 0 ){
				printf("font-weight: bold;\n");
		 	}
			if( s->value.valBoolCursiva != 0 ){
				printf("font-weight: bold;\n");
		 	}
			if( s->value.valBoolTachado != 0 ){
				printf("text-decoration: line-through;\n");
		 	}	
			if( s->value.valBoolMayusculas != 0 ){
				printf("text-transform: uppercase;\n");
		 	}	
		break;	
		case 2:
			if( s->value.valAnchura != "" ){
				printf("width: %d px;\n", s->value.valAnchura);
		 	}
			if( s->value.valAltura != 0 ){
				printf("height: %d px;\n", s->value.valAltura);
		 	}
			if( s->value.valBorde != 0 ){
				printf("border: %d px\n;", s->value.valBorde);
		 	}
			if( s->value.valFondo != 0 ){
				printf("background: %d;\n", s->value.valFondo);
		 	}
		break;
		case 3:
			if( s->value.valAnchura != "" ){
				printf("width: %d px;\n", s->value.valAnchura);
		 	}
			if( s->value.valAltura != 0 ){
				printf("height: %d px;\n", s->value.valAltura);
		 	}
			if( s->value.valBorde != 0 ){
				printf("border: %d px;\n", s->value.valBorde);
		 	}
			if( s->value.valFondo != 0 ){
				printf("background: %d;\n", s->value.valFondo);
		 	}
		break;
		case 4:
			printf("/*No configurado*/");
		break;
		case 5:
			if( s->value.valColorVista != 0 ){
				printf("a:visited {  background-color: %s;}",s->value.valColorVista);
			}
		break;
		case 6:
			if( s->value.margen != 0 ){
				printf("font-weight: bold;\n");
			}
		break;
		}
	printf("} \n");
}

void incluyeNuevaPropiedad(symrec *destino , symrec *origen){
	if(strcmp(origen->value.valFuente, "")!=0){	
		strcpy(destino->value.valFuente, origen->value.valFuente);
	}
	if(origen->value.valTamanho!=0){	
		destino->value.valTamanho = origen->value.valTamanho;
	}
	if(origen->value.valBoolSubrayado!=0){	
		destino->value.valBoolSubrayado = origen->value.valBoolSubrayado;
	}
	if(origen->value.valBoolNegrita!=0){	
		destino->value.valBoolNegrita = origen->value.valBoolNegrita;
	}
	if(origen->value.valBoolCursiva!=0){	
		destino->value.valBoolCursiva = origen->value.valBoolCursiva;
	}
	if(origen->value.valBoolTachado!=0){	
		destino->value.valBoolTachado = origen->value.valBoolTachado;
	}
	if(origen->value.valBoolMayusculas!=0){	
		destino->value.valBoolMayusculas = origen->value.valBoolMayusculas;
	}
	if(origen->value.valAnchura!=0){	
		destino->value.valAnchura = origen->value.valAnchura;
	}
	if(origen->value.valAltura!=0){	
		destino->value.valAltura = origen->value.valAltura;
	}
	if(origen->value.valBorde!=0){	
		destino->value.valBorde = origen->value.valBorde;
	}
	if(strcmp(origen->value.valFondo, "")!=0){	
		strcpy(destino->value.valFondo, origen->value.valFondo);
	}
	if(strcmp(origen->value.valFondoImg, "")!=0){	
		strcpy(destino->value.valFondoImg, origen->value.valFondoImg);
	}
	if(strcmp(origen->value.valPosicion, "")!=0){	
		strcpy(destino->value.valPosicion, origen->value.valPosicion);
	}
	if(strcmp(origen->value.valAlineacion, "")!=0){	
		strcpy(destino->value.valAlineacion, origen->value.valAlineacion);
	}
	if(strcmp(origen->value.valColorVista, "")!=0){	
		strcpy(destino->value.valColorVista, origen->value.valColorVista);
	}
	if(strcmp(origen->value.margen, "")!=0){	
		strcpy(destino->value.margen, origen->value.margen);
	}
	if(origen->value.valVisibilidad!=0){	
		destino->value.valVisibilidad = origen->value.valVisibilidad;
	}
	if(strcmp(origen->value.color, "")!=0){	
		strcpy(destino->value.color, origen->value.color);
	}

}





