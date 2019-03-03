all: calc.l calc.y
	bison -d calc.y
	flex -o calc.lex.c calc.l
	g++ -w -o run_calc calc.tab.c calc.lex.c
	cat test.txt | ./run_calc

clean:
	rm calc.lex.c
	rm calc.tab.c
	rm calc.tab.h