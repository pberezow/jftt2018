%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <iostream>
	#include <string>
	#include <vector>
	#include <map>
	// #include <string.h>
	#include <typeinfo>
	using namespace std;
	int yylex(void);
	void yyerror(const char *);

	// long errno;
	extern int lineno;

// GLOBALS

map<string, int> var;
map<string, struct arr*> arr;

// AST

	struct ast {
		string type; // node type eg. program, value etc.
		struct ast* s_1;
		struct ast* s_2;
		struct ast* s_3;
		struct ast* s_4;
		string value; // for command and ID eg. "for_to", "while" etc.
		int number;	
	};

	struct ast* newast(string type, struct ast* s_1, struct ast* s_2, struct ast* s_3, struct ast* s_4, string value, int number);

// BLOCK
	struct block {
		struct block* prev;
		struct block* next;
		vector<struct indirect_code*> codes;
	};

	struct block* newblock();

// INDIRECT CODE
	struct indirect_code { // ADD <var> <var>
		string kw; // keyword eg. ADD, JZERO
		struct variable* val1;
		struct variable* val2;
	};

	struct indirect_code* newindirect_code(string kw, struct variable* val1, struct variable* val2);

// VARIABLE - used in indirect code
	struct variable {
		string label; // [var, reg, arr, const]
		string id1; // for var name
		string id2; // for arr idx
		int number; // for const value
	};

	struct variable* newvariable(string label, string id1, string id2, int num);

// ARRAY
	struct arr {
		string id;
		int from;
		int to;
	};

	struct arr* newarray(string id, int from, int to);

// HANDLERS

	void handle_program(struct ast* root);
	void handle_if(struct ast* if_node);
	void handle_if_else(struct ast* if_else_node);
	struct block* handle_condition(struct ast* condition_node, int commands_len);
	struct block* handle_commands(struct ast* commands_node);

	string handle_value(struct ast* value_node);

	int semantic_analyse(struct ast* root);
%}

%union {
	struct ast* a;
	char* string;
	int number;
}

%token <string> DECLARE IN END
%token <string> IF THEN ELSE ENDIF
%token <string> WHILE DO ENDWHILE ENDDO
%token <string> FOR FROM TO DOWNTO ENDFOR
%token <string> READ WRITE
%token <string> ASSIGN
%token <string> '+' '-' '*' '/' '%'
%token <string> EQ NEQ LT GT LTE GTE
%token <string> '(' ')' ';'
%token <string> ID
%token <number> NUM

%type <a> program
%type <a> declarations
%type <a> commands
%type <a> command
%type <a> expression
%type <a> condition
%type <a> value
%type <a> identifier

%%

program: 
	DECLARE declarations IN commands END
					{
						$$ = newast("program", $2, $4, NULL, NULL, " ", 0);
						handle_program($$);
						cout << "END" << endl;
					}
;

declarations: 
	declarations ID';' 				
					{
						struct ast* id = newast("id", NULL, NULL, NULL, NULL, $2, 0);
						$$ = newast("declarations", $1, id, NULL, NULL, "dec_var", 0);
					}
|	declarations ID'('NUM':'NUM')'
					{
						struct ast* id = newast("id", NULL, NULL, NULL, NULL, $2, 0);
						struct ast* num1 = newast("num", NULL, NULL, NULL, NULL, " ", $4);
						struct ast* num2 = newast("num", NULL, NULL, NULL, NULL, " ", $6);
						$$ = newast("declarations", $1, id, num1, num2, "dec_arr", 0);
					}
| 					{
						$$ =  newast("NULL", NULL, NULL, NULL, NULL, "NULL", 0);
					}
;

commands:
	commands command
					{

						$$ = newast("commands", $1, $2, NULL, NULL, " ", 0);
					}
|	command
					{
						$$ = newast("commands", $1, NULL, NULL, NULL, " ", 0);
					}
;

command:
	identifier ASSIGN expression';'
					{
						$$ = newast("command", $1, $3, NULL, NULL, ":=", 0);
					}
|	IF condition THEN commands ELSE commands ENDIF
                    {
						$$ = newast("command", $2, $4, $6, NULL, "if_else", 0);
                    }
|	IF condition THEN commands ENDIF
                    {
						$$ = newast("command", $2, $4, NULL, NULL, "if", 0);
                    }
|	WHILE condition DO commands ENDWHILE
                    {
						$$ = newast("command", $2, $4, NULL, NULL, "while", 0);
                    }
|	DO commands WHILE condition ENDDO
					{
						$$ = newast("command", $2, $4, NULL, NULL, "do_while", 0);
					} 
|	FOR ID FROM value TO value DO commands ENDFOR
					{
						struct ast* id = newast("id", NULL, NULL, NULL, NULL, $2, 0);
						$$ = newast("command", id, $4, $6, $8, "for_to", 0);
		 			}
|	FOR ID FROM value DOWNTO value DO commands ENDFOR
                    {
						struct ast* id = newast("id", NULL, NULL, NULL, NULL, $2, 0);
						$$ = newast("command", id, $4, $6, $8, "for_downto", 0);
                    }
|	READ identifier';'
					{
						$$ = newast("command", $2, NULL, NULL, NULL, "read", 0);
					}
|	WRITE value';'
					{
						$$ = newast("command", $2, NULL, NULL, NULL, "write", 0);
					}
;

expression:
	value
					{
						$$ = newast("expression", $1, NULL, NULL, NULL, "value", 0);
					}
|	value '+' value
					{
						$$ = newast("expression", $1, $3, NULL, NULL, "+", 0);
					}
|	value '-' value
					{
						$$ = newast("expression", $1, $3, NULL, NULL, "-", 0);
					}
|	value '*' value
					{
						$$ = newast("expression", $1, $3, NULL, NULL, "*", 0);
					}
|	value '/' value
					{
						$$ = newast("expression", $1, $3, NULL, NULL, "/", 0);
					}
|	value '%' value
					{
						$$ = newast("expression", $1, $3, NULL, NULL, "%", 0);
					}
;

condition:
	value EQ value
					{
						$$ = newast("condition", $1, $3, NULL, NULL, "=", 0);
					}
|	value NEQ value
					{
						$$ = newast("condition", $1, $3, NULL, NULL, "!=", 0);
					}
|	value LT value
					{
						$$ = newast("condition", $1, $3, NULL, NULL, "<", 0);
					}
|	value GT value
					{
						$$ = newast("condition", $1, $3, NULL, NULL, ">", 0);
					}
|	value LTE value
					{
						$$ = newast("condition", $1, $3, NULL, NULL, "<=", 0);
					}
|	value GTE value
					{
						$$ = newast("condition", $1, $3, NULL, NULL, ">=", 0);
					}
;

value:
	NUM
					{
						struct ast* num = newast("num", NULL, NULL, NULL, NULL, " ", $1);
						$$ = newast("value", num, NULL, NULL, NULL, " ", 0);
					}
|	identifier
					{
						$$ = newast("value", $1, NULL, NULL, NULL, " ", 0);
					}
;

identifier:
	ID
					{
						struct ast* id = newast("id", NULL, NULL, NULL, NULL, $1, 0);
						$$ = newast("identifier_id", id, NULL, NULL, NULL, " ", 0);
					}
|	ID'('ID')'
					{
						struct ast* id1 = newast("id", NULL, NULL, NULL, NULL, $1, 0);
						struct ast* id2 = newast("id", NULL, NULL, NULL, NULL, $3, 0);
						$$ = newast("identifier_id_id", id1, id2, NULL, NULL, " ", 0);
					}
|	ID'('NUM')'
					{
						struct ast* id = newast("id", NULL, NULL, NULL, NULL, $1, 0);
						struct ast* num = newast("num", NULL, NULL, NULL, NULL, " ", $3);
						$$ = newast("identifier_id_num", id, num, NULL, NULL, " ", 0);
					}
;


%%


int main(int argc, char **argv) {
	// initializeCompilation();
    yyparse();
    // finishCompilation();
    printf("Kompilacja zakonczona.\n");
}

void yyerror(char const *s){
	// finishCompilation();
	// fprintf(stderr, RED"Błąd [linia %d]:%s %s.\n", lineno, NORMAL, s);
	exit(1);
}


// AST

struct ast* newast(string type, struct ast* s_1, struct ast* s_2, struct ast* s_3, struct ast* s_4, string value, int number) {
	struct ast* a = (struct ast*)malloc(sizeof(struct ast));

    if (!a) {
        yyerror("Błąd. Koniec pamięci\n");
        exit(1);
    }

	// cout << "type: " << type << "   value: " << value << endl;
	// cout << typeid(type).name() << endl;
    a->type = type;
    a->s_1 = s_1;
	a->s_2 = s_2;
	a->s_3 = s_3;
	a->s_4 = s_4;
    a->value = value;
	a->number = number;

	// cout << type << endl;
    return a;
}

// BLOCK

struct block* newblock() {
	struct block* a = (struct block*)malloc(sizeof(struct block));
	
	if(!a) {
		yyerror("Błąd. Koniec pamięci\n");
        exit(1);
	}

	a->prev = NULL;
	a->next = NULL;
}

// INDIRECT CODE

struct indirect_code* newindirect_code(string kw, struct variable* val1, struct variable* val2) {
	struct indirect_code* a = (struct indirect_code*)malloc(sizeof(struct indirect_code));

	if(!a) {
		yyerror("Błąd. Koniec pamięci\n");
        exit(1);
	}

	a->kw = kw;
	a->val1 = val1;
	a->val2 = val2;

	return a;
}

// VARIABLE

struct variable* newvariable(string label, string id1, string id2, int num) {
	struct variable* a = (struct variable*)malloc(sizeof(struct variable));

	if(!a) {
		yyerror("Błąd. Koniec pamięci\n");
        exit(1);
	}

	a->label = label;
	a->id1 = id1;
	a->id2 = id2;
	a->number = num;

	return a;
}

// ARRAY

struct arr* newarray(string id, int from, int to) {
	struct arr* a = (struct arr*)malloc(sizeof(struct arr));

	if(!a) {
		yyerror("Błąd. Koniec pamięci\n");
        exit(1);
	}

	a->id = id;
	a->from = from;
	a->to = to;

	return a;
}


// HANDLERS
void handle_program(struct ast* root) {
	if(semantic_analyse(root) != 1) {
		cout << "ERROR! SEMANTIC ANALYSIS" << endl;
		return;
	}
	handle_value(root);
	
}

int semantic_analyse(struct ast* root) {
	// TODO
	return 1;
}

struct block* handle_assign(struct ast* asg_node) {
	struct block* assign = newblock();

}

void handle_if(struct ast* if_node) {
	struct ast* condition = if_node->s_1;
	struct ast* commands = if_node->s_2;
	
	struct block* commands_block = handle_commands(commands);

	
	
}

struct block* handle_commands(struct ast* commands_node) {
	return newblock();
}

struct block* handle_condition(struct ast* condition_node, int commands_len) { 
	struct block* condition = newblock();

	if(condition_node->value.compare(">") == 0) {
		struct ast* tmp = condition_node->s_1;
		condition_node->s_1 = condition_node->s_2;
		condition_node->s_2 = tmp;
		condition_node->value = "<";
	} else if(condition_node->value.compare(">=") == 0) {
		struct ast* tmp = condition_node->s_1;
		condition_node->s_1 = condition_node->s_2;
		condition_node->s_2 = tmp;
		condition_node->value = "<=";
	} else {
		// condition->codes.push_back(handle_value(condition_node->s_1) + condition_node->value + handle_value(s_2));
	}

	// condition->codes.push_back(handle_value(condition_node->s_1) + condition_node->value + handle_value(s_2));
	
	if(condition_node->value.compare("<") == 0) {
		// condition->codes.push_back("");
	} else if(condition_node->value.compare("<=") == 0) {

	} else if(condition_node->value.compare("==") == 0) {

	} else if(condition_node->value.compare("!=") == 0) {

	} else {

	}


}

string handle_value(struct ast* value_node) {
	if(value_node->s_1->type.compare("num")) {
		return to_string(value_node->s_1->number);
	} else if(value_node->s_1->type.compare("identifier_id")) {
		return value_node->s_1->s_1->value;
	} else if(value_node->s_1->type.compare("identifier_id_id")) {
		return value_node->s_1->s_1->value + "(" + value_node->s_1->s_2->value + ")";
	} else if(value_node->s_1->type.compare("identifier_id_num")) {
		return value_node->s_1->s_1->value + "(" + to_string(value_node->s_1->s_2->number) + ")";
	} else {
		return "blad";
	}
}


void handle_if_else(struct ast* if_else_node) {
	struct ast* condition = if_else_node->s_1;
	struct ast* if_commands = if_else_node->s_2;
	struct ast* else_commands = if_else_node->s_3;

}
