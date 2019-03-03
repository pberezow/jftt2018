%{
#include <iostream>
#include <cmath>
#include <vector>
using namespace std;
vector<int> stack;
extern int yylex();
%}
%x ERROR
%option noyywrap
%%
-?[0-9]+										{ stack.push_back(atoi(yytext)); }
([^ \t\n0123456789\/\*\+-\^%]|[\.,;:@=\?]) 		{ cout << "Zły symbol "; ECHO; cout << endl; BEGIN(ERROR); }
<ERROR>[^\n]*\n 								{ stack.clear(); BEGIN(INITIAL); }		
	
\+ 												{	if(stack.size() >= 2){
														int temp1 = stack.back();	stack.pop_back();
														int temp2 = stack.back();	stack.pop_back();
														stack.push_back(temp1+temp2);
													}else{
														cout << "Za mało argumentów\n"; BEGIN(ERROR);
													} 	
												}
	
-										 		{	if(stack.size() >= 2){
														int temp1 = stack.back();	stack.pop_back();
														int temp2 = stack.back();	stack.pop_back();
														stack.push_back(temp2-temp1);
													}else{
														cout << "Za mało argumentów\n"; BEGIN(ERROR);
													} 	
												}
		
\* 												{	if(stack.size() >= 2){
														int temp1 = stack.back();	stack.pop_back();
														int temp2 = stack.back();	stack.pop_back();
														stack.push_back(temp1*temp2);
													}else{
														cout << "Za mało argumentów\n"; BEGIN(ERROR);
													} 	
												}
			
\/ 												{	if(stack.size() >= 2){
														int temp1 = stack.back();	stack.pop_back();
														int temp2 = stack.back();	stack.pop_back();
														if(temp1 == 0){
																cout << "Nie można dzielić przez 0\n"; BEGIN(ERROR);
														}else
															stack.push_back(temp2/temp1);	
													}else{
														cout << "Za mało argumentów\n"; BEGIN(ERROR);
													} 	
												}
		
% 												{	if(stack.size() >= 2){
														int temp1 = stack.back();	stack.pop_back();
														int temp2 = stack.back();	stack.pop_back();
														if(temp1 == 0){
																cout << "Nie można dzielić przez 0\n"; BEGIN(ERROR);
														}else
															stack.push_back(temp2%temp1);	
													}else{
														cout << "Za mało argumentów\n"; BEGIN(ERROR);
													} 	
												}
	
\^ 												{	if(stack.size() >= 2){
														int temp1 = stack.back();	stack.pop_back();
														int temp2 = stack.back();	stack.pop_back();
														if(temp2 == 0 && temp1 <= 0){
															cout << "Nieprawidłowe argumenty" << endl; BEGIN(ERROR);
														}else
															stack.push_back((int) pow(temp2,temp1));	
													}else{
														cout << "Za mało argumentów\n"; BEGIN(ERROR);
													} 	
												}



\n												{	if(stack.size() == 1){
														cout << "= " << stack[0] << endl;	//proper counting
														stack.clear();
													}else{
														if(stack.size() > 1){
															cout << "Za mało operatorów\n"; 
															stack.clear();
														}	
													}
												}
	
[ \t]+											;

%%


int main(){    
   
	while(yylex()); 
   	return 0;
}