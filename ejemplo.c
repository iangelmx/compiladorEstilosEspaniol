#include<stdio.h>
#include <string.h>
#include <stdlib.h>
int main(int argc, char *argv[]){
    char *cadena = (char *) malloc(sizeof(char));
    char *in = (char *) malloc(sizeof(char));
    int valor;

    strcpy(cadena, "Hola");
    printf("Dame la cadena...\n");
    //scanf("%s", in);
    valor = strcmp( cadena, "");
    printf("valor: %d\n\n", valor);
    return 0;
}