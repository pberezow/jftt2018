%option noyywrap
%option yylineno
%{
#include "calc.tab.h"
int yylex();
%}
%x comment quote docs next_line
%%
<comment,INITIAL>"\\"\n     {}
<comment>[^\\\n]*           {}
<comment>\n                 {BEGIN(INITIAL);}
[ \t]+ 	                    {}
"#"	                        {BEGIN(comment);}
0|[1-9]+[0-9]*                {yylval.d = atoi(yytext); return VAL;}
"+" |
"-" |
"*" |
"/" |
"^" |
"%" |
"(" |
")"                         {return yytext[0];}
\n	                        {return END;}
.	                        {return ERROR;}
%%
