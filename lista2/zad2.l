%{
#include <iostream>
using namespace std;
extern int yylex();
%}
%x quote comment
%option noyywrap
%%
\"                                  { ECHO; BEGIN(quote); }
<quote>[^\"]*   					{ ECHO; }
<quote>\"                           { ECHO; BEGIN(INITIAL); }


\<!--[^-]                           { BEGIN(comment); }
<comment>--\>                       { BEGIN(INITIAL); }
<comment>.                          
<comment>\n
.                                   ECHO;
%%
int main(int argc, char* argv[]) {
    while (yylex());
}