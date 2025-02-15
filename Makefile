.PHONY: clean run all
all: parser
first: 
	bison -d grammar.y
	flex grammar.l
parser: grammar.tab.h grammar.tab.c lex.yy.c
	g++ -o parser grammar.tab.c lex.yy.c -lfl
clean:
	rm parser grammar.tab.h grammar.tab.c lex.yy.c
run: parser
	./parser
