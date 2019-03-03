%{
#include <iostream>
using namespace std;
int wordNum = 0, lineNum = 0;
%}
%option noyywrap
%%
^([^ \t\n]+)              { ECHO; wordNum++; /*case: |word	count end rewrite word*/ } 
^([ \t]+)                 { wordNum++; /*case: |whitespaces->word	count word*/ } 
^([ \t]*\n)               ;
\n                        { fprintf(yyout, "\n"); lineNum++; /*count line*/ }
[ \t]+\n                  { fprintf(yyout, "\n"); lineNum++; /*case: word->whitespaces|  replace whitespaces with \n and count line*/ }
[ \t]+                    { fprintf(yyout, " "); wordNum++; /*count word and replace multiple whitespaces*/ }
.                           ECHO; /* rewrite any other char*/

%%
void main(int argc, char* argv[]) {
	while (yylex());
	cout << wordNum << " " << lineNum; 
}