run : a.out
	./a.out
clean : 
	rm *.o proy.tab.h proy.tab.c a.out lex.yy.c

lex.yy.c : proy.l proy.tab.h
	flex proy.l
proy.tab.c : proy.y
	bison -d proy.y

proy.tab.h: proy.tab.c

tabla.o : tabla.c
	gcc -c tabla.c

lex.yy.o : lex.yy.c
	gcc -c lex.yy.c
	
proy.tab.o : proy.tab.c
	gcc -c proy.tab.c

main.o: main.c
	gcc -c main.c

a.out : lex.yy.o proy.tab.o tabla.o 
	gcc proy.tab.o lex.yy.o tabla.o  -lm -ll