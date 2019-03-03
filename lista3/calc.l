%option noyywrap
%{
#include "calc_y.h"
int yylex();
%}
%%
[ \t]+ 	;
0|-?[1-9]+[0-9]*            { yylval = atoi(yytext); return VAL; }
\+ 	                        { return '+'; }
-	                        { return '-'; }
\* 	                        { return '*'; }
\/	                        { return '/'; }
\(	                        { return '('; }
\)	                        { return ')'; }
\\\n                        { return BREAKLINE; }
\n	                        { return END; }
.	                        { return ERROR; }
%%
