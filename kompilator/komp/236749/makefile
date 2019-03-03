all: lexer.l parser.y
	bison -d parser.y
	flex -o lexer.lex.c lexer.l
	g++ -std=c++17 -o kompilator parser.tab.c lexer.lex.c

clean:
	rm lexer.lex.c
	rm parser.tab.c
	rm parser.tab.h
	rm kompilator
