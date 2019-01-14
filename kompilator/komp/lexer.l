%option noyywrap
%option yylineno

%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <iostream>
	// #include <string.h>
	#include <string>

	#include "parser.tab.h"

	using namespace std;
	extern void yyerror(const char*);
	int lineno = 1;
	int yylex();
%}

%x comment
WHITESPACE [ \t]
NUMBER [0-9]

%%

"[" 		{BEGIN(comment);}

<comment>{
    <<EOF>>	{yyerror("Nie zamknięty komentarz"); yyterminate();}
	"]"		{BEGIN(INITIAL);}
	.		;
	\n 		{lineno++;}
}

"+"  		{return '+';}
"-"	 		{return '-';}
"*"	 		{return '*';}
"/"	 		{return '/';}
"%"	 		{return '%';}
"="	 		{return EQ;}
"!=" 		{return NEQ;}
"<"	 		{return LT;}
">"	 		{return GT;}
"<=" 		{return LTE;}
">=" 		{return GTE;}
":=" 		{return ASSIGN;}


DECLARE     {return DECLARE;}
IN          {return IN;}
END         {return END;}
IF          {return IF;}
THEN        {return THEN;}
ELSE        {return ELSE;}
ENDIF       {return ENDIF;}
WHILE       {return WHILE;}
DO          {return DO;}
ENDWHILE    {return ENDWHILE;}
ENDDO       {return ENDDO;}
FOR         {return FOR;}
FROM        {return FROM;}
TO          {return TO;}
DOWNTO      {return DOWNTO;}
ENDFOR      {return ENDFOR;}
READ        {return READ;}
WRITE       {return WRITE;}


";"			{return ';';}
":"         {return ':';}
"("			{return '(';}
")"			{return ')';}

[_a-z]+		{yylval.string = strdup(yytext); return ID;}
{NUMBER}+	{yylval.number = strtoull(yytext, NULL, 10); return NUM;}
[_a-zA-Z0-9]+	{string err = "Nierozpoznany napis w lini " + to_string(lineno); yyerror(&err[0]); yyterminate();}
{WHITESPACE}	;
\n 				{lineno++;}
.			{ string err = "Nieznany znak w lini " + to_string(lineno); yyerror(&err[0]); yyterminate();}

%%
