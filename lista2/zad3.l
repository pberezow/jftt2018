%{
#include <iostream>
using namespace std;
extern int yylex();
bool flag = false;
%}
%x comment doc quote
%option noyywrap
%%
\"[^\"]*\"						ECHO;
\#include[ \t]*(\"|\<).*		ECHO;
\/{2}(.|\\\n)*\n				;

\/\*\*	 						{ if(flag==true) ECHO; BEGIN(doc); }		
<doc>[^\*\n]*       			{ if(flag==true) ECHO; }
<doc>\*+[^\*\/\n]*   			{ if(flag==true) ECHO; }
<doc>\*+\/        	 			{ if(flag==true) ECHO; BEGIN(INITIAL); }	

\/\*          					BEGIN(comment);
<comment>[^\*\n]*        		;
<comment>\*+[^\*\/\n]*   		;
<comment>\*+\/        			BEGIN(INITIAL);
			
%%
int main(int argc, char* argv[]) {
	const char option = 'd';
	if(argc > 1){
		if(*(argv[1]) == option){
			flag = true;
		}
	}

  while (yylex()); 
  return 0;
}