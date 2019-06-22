
y.tab.h y.tab.c: parse.y
	bison -d -y parse.y

lex.yy.c: scan.l
	flex scan.l

see: lex.yy.c y.tab.c tree.c main.c
	gcc lex.yy.c y.tab.c tree.c main.c -o see

clean:
	rm y.tab.c y.tab.h lex.yy.c see
