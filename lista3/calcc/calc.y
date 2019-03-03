%{
// #define YYSTYPE int
#include <stdio.h>
#include <iostream>
#include <string>
#include <math.h>
using namespace std;
extern int yylineno;  // z lex-a

int yylex();
int yyerror(char*);

struct ast {
    int nodetype;
    struct ast* l;
    struct ast* r;
    int value;
};

struct ast* newast(int nodetype, struct ast* l, struct ast* r, int value);
int eval(struct ast*);
void write(struct ast* a);
void treefree(struct ast*);
void eval_line(struct ast* a);
int error_flag = 0;
string eq = "";
%}

%union {
    struct ast* a;
    int d;
}

%token <d> VAL
%token END
%token ERROR

%type <a> exp

%left '+' '-'
%left '*' '/' '%'
%right '^'
%nonassoc UMINUS
%%
calclist:
    | calclist exp END              {eval_line($2);}
    | calclist error END            {cout<<"Błąd."<<endl;}
    ;
exp: VAL		                    {$$ = newast('K', NULL, NULL, $1);}
    | exp '+' exp                   {$$ = newast('+', $1, $3, 0);}
    | exp '-' exp                   {$$ = newast('-', $1, $3, 0);}
    | exp '*' exp                   {$$ = newast('*', $1, $3, 0);}
    | exp '/' exp                   {$$ = newast('/', $1, $3, 0);}
    | exp '%' exp                   {$$ = newast('%', $1, $3, 0);}
    | exp '^' exp                   {$$ = newast('^', $1, $3, 0);}
    | '-' exp		                %prec UMINUS{$$ = newast('M', $2, NULL, 0);}
    | '(' exp ')'	                {$$ = $2;}
%%

int yyerror(char *s)
{
    // printf("%s in line: %d\n", s, yylineno-1);	
    return 0;
}

struct ast* newast(int nodetype, struct ast* l, struct ast* r, int value) {
    struct ast* a = (struct ast*)malloc(sizeof(struct ast));

    if (!a) {
        yyerror("Błąd. Koniec pamięci\n");
        exit(1);
    }
    a->nodetype = nodetype;
    a->l = l;
    a->r = r;
    a->value = value;
    return a;
}

int eval(struct ast* a) {
    int v = 0;
    switch (a->nodetype) {
        case 'K':
            v = a->value; 
            break;
        case 'M':
            v = -eval(a->l); 
            break;
        case '+':
            v = eval(a->l) + eval(a->r); 
            break;
        case '-':
            v = eval(a->l) - eval(a->r); 
            break;
        case '*':
            v = eval(a->l) * eval(a->r); 
            break;
        case '^':
            v = pow(eval(a->l), eval(a->r)); 
            break;
        case '/': {
            int e_r = eval(a->r);
            if (e_r != 0) {
                v = floor((float)eval(a->l) / (float)e_r);
            } else {
                printf("Błąd. Nie można dzielić przez 0\n");
                error_flag = 1;
            }
            break;
        }
        case '%': {
            int e_l = eval(a->l);
            int e_r = eval(a->r);
            if (e_r != 0) {
                v =  e_l % e_r;
                if (v < 0 && e_r > 0) {
                    int t = v+e_r;
                    v = t;
                }
            } else {
                printf("Błąd. Nie można dzielić przez 0\n");
                error_flag = 1;
            }
            break;
        }
        default:
            printf("Błąd.\n");
    }
}

void write(struct ast* a) {
    switch (a->nodetype) {
        case 'K':
            eq += to_string(a->value);
            eq += " ";
            break;
        case 'M':
            eq += "-";
            write(a->l);
            break;
        case '+': 
            write(a->l);
            write(a->r);
            eq += "+ ";
            break;
        case '-': 
            write(a->l);
            write(a->r);
            eq += "- ";
            break;
        case '*': 
            write(a->l);
            write(a->r);
            eq += "* ";
            break;
        case '^':
            write(a->l);
            write(a->r);
            eq += "^ ";
            break;
        case '/': {
            write(a->l);
            write(a->r);
            eq += "/ ";
            break;
        }
        case '%': {
            write(a->l);
            write(a->r);
            eq += "% ";
            break;
        }
        default:
            printf("Błąd.\n");
    }
}

void treefree(struct ast* a) {
    switch (a->nodetype) {
        case '+':
        case '-':
        case '*':
        case '/':
        case '^':
        case '%':
            treefree(a->r);
        case 'M':
            treefree(a->l);
        case 'K':
            free(a);
            break;
        default:
            printf("Błąd.\n");
    }
}

void eval_line(struct ast* a) {
    int res = eval(a);
    if (error_flag == 0) {
        write(a);
        cout << eq << endl;
        cout << "Wynik:  " << res << endl;
    }
    treefree(a);
    error_flag = 0;
    eq.clear();
}

int main()
{
    yyparse();
    // printf("Lines parsed: %d\n", yylineno);
    return 0;
}
