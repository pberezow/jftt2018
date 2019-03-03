.PHONY = all clean cleanall

all: calc

calc: calc.y calc.l
	bison -o calc_y.c -d calc.y
	flex -o calc_l.c calc.l
	gcc -o calc calc_y.c calc_l.c
	
clean:
	rm -f *.c *.h
