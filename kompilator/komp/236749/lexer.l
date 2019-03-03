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
	struct lex_token* newlex_token(string str, unsigned long long number, int lineno);
%}

%x comment
WHITESPACE [ \t]
NUMBER [0-9]

%%

"[" 				{BEGIN(comment);}

<comment>{
    <<EOF>>			{yyerror("Nie zamknięty komentarz"); yyterminate();}
	"]"				{BEGIN(INITIAL);}
	.				;
	\n 				{lineno++;}
}

"+"  				{yylval.lex_token = newlex_token("+", 0, lineno); return '+';}
"-"	 				{yylval.lex_token = newlex_token("-", 0, lineno); return '-';}
"*"	 				{yylval.lex_token = newlex_token("*", 0, lineno); return '*';}
"/"	 				{yylval.lex_token = newlex_token("/", 0, lineno); return '/';}
"%"	 				{yylval.lex_token = newlex_token("%", 0, lineno); return '%';}
"="	 				{yylval.lex_token = newlex_token("=", 0, lineno); return EQ;}
"!=" 				{yylval.lex_token = newlex_token("!=", 0, lineno); return NEQ;}
"<"	 				{yylval.lex_token = newlex_token("<", 0, lineno); return LT;}
">"	 				{yylval.lex_token = newlex_token(">", 0, lineno); return GT;}
"<=" 				{yylval.lex_token = newlex_token("<=", 0, lineno); return LTE;}
">=" 				{yylval.lex_token = newlex_token(">=", 0, lineno); return GTE;}
":=" 				{yylval.lex_token = newlex_token(":=", 0, lineno); return ASSIGN;}


DECLARE     		{yylval.lex_token = newlex_token("DECLARE", 0, lineno); return DECLARE;}
IN          		{yylval.lex_token = newlex_token("IN", 0, lineno); return IN;}
END         		{yylval.lex_token = newlex_token("END", 0, lineno); return END;}
IF          		{yylval.lex_token = newlex_token("IF", 0, lineno); return IF;}
THEN        		{yylval.lex_token = newlex_token("THEN", 0, lineno); return THEN;}
ELSE        		{yylval.lex_token = newlex_token("ELSE", 0, lineno); return ELSE;}
ENDIF       		{yylval.lex_token = newlex_token("ENDIF", 0, lineno); return ENDIF;}
WHILE       		{yylval.lex_token = newlex_token("WHILE", 0, lineno); return WHILE;}
DO          		{yylval.lex_token = newlex_token("DO", 0, lineno); return DO;}
ENDWHILE    		{yylval.lex_token = newlex_token("ENDWHILE", 0, lineno); return ENDWHILE;}
ENDDO       		{yylval.lex_token = newlex_token("ENDDO", 0, lineno); return ENDDO;}
FOR         		{yylval.lex_token = newlex_token("FOR", 0, lineno); return FOR;}
FROM        		{yylval.lex_token = newlex_token("FROM", 0, lineno); return FROM;}
TO          		{yylval.lex_token = newlex_token("TO", 0, lineno); return TO;}
DOWNTO      		{yylval.lex_token = newlex_token("DOWNTO", 0, lineno); return DOWNTO;}
ENDFOR      		{yylval.lex_token = newlex_token("ENDFOR", 0, lineno); return ENDFOR;}
READ        		{yylval.lex_token = newlex_token("READ", 0, lineno); return READ;}
WRITE       		{yylval.lex_token = newlex_token("WRITE", 0, lineno); return WRITE;}


";"					{yylval.lex_token = newlex_token(";", 0, lineno); return ';';}
":"         		{yylval.lex_token = newlex_token(":", 0, lineno); return ':';}
"("					{yylval.lex_token = newlex_token("(", 0, lineno); return '(';}
")"					{yylval.lex_token = newlex_token(")", 0, lineno); return ')';}

[_a-z]+				{yylval.lex_token = newlex_token(strdup(yytext), 0, lineno);  return ID;}
{NUMBER}+			{yylval.lex_token = newlex_token("NUM", strtoull(yytext, NULL, 10), lineno);  return NUM;}
[_a-zA-Z0-9]+		{string err = "Nierozpoznany napis w lini " + to_string(lineno); yyerror(&err[0]); yyterminate();}
{WHITESPACE}		;
\n 					{lineno++;}
.					{string err = "Nieznany znak w lini " + to_string(lineno); yyerror(&err[0]); yyterminate();}

%%
