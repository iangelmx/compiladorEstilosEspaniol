#include<stdio.h>
void main(void){
    void * general;
    float varuno = 23.2;
    char *name;
    printf("Dame el nombre de la variable:\n");
    scanf("%s", name);
    float * uno = &varuno;

    general = *(float*)(name);

    printf("El valor de general: %f", *(float*)general);
}