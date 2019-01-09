all: lexer.l parser.y
	bison -d parser.y
	flex -o lexer.lex.c lexer.l
	g++ -std=c++11 -o compiler parser.tab.c lexer.lex.c
	./compiler <test.imp >test
	./maszyna-rejestrowa test

clean:
	rm lexer.lex.c
	rm parser.tab.c
	rm parser.tab.h
	rm compiler