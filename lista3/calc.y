%{
#define YYSTYPE int
#include<stdio.h>
// extern int yylineno;  // z lex-a
int yylex();
int yyerror(char*);
%}
%token VAL
%token END
%token BREAKLINE
%token ERROR
%%
input:
    | input line
;
line: exp BREAKLINE exp         { ; }
    | exp END 	                { printf("Wynik: %d\n", $$); }
    | error END	                { printf("Błąd\n"); }
;
exp: VAL		                { $$ = $1; }
    | exp '+' exp	            { $$ = $1 + $3; }
    | exp '-' exp               { $$ = $1 - $3; }
    | exp '*' exp               { $$ = $1 * $3; }
    | exp '/' exp               { $$ = $1 / $3; }
    | '-' exp                   { $$ = -$2; }
    | '(' exp ')'       { $$ = $2; }

%%
int yyerror(char *s)
{
    printf("%s\n",s);	
    return 0;
}

int main()
{
    yyparse();
    // printf("Przetworzono linii: %d\n",yylineno-1);
    return 0;
}
