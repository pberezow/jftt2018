all: lexer.l parser.y
	bison -d parser.y
	flex -o lexer.lex.c lexer.l
	g++ -o compiler parser.tab.c lexer.lex.c
	cat test.imp | ./compiler

clean:
	rm lexer.lex.c
	rm parser.tab.c
	rm parser.tab.h
	rm compiler