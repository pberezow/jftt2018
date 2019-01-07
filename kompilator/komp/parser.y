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
int label_id = 0;

map<string, int> var;
map<string, struct arr*> arr;

struct variable* get_next_label_id();

// PRINTS
void print_blocks(struct block* code_block);
void print_indirect_code(struct indirect_code* code);

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
		string label; // [VAR, REG, ARR, CONST]
		string id1; // for var name / reg name
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
	// DONE
	struct block* handle_commands(struct ast* commands_node);

	void handle_if(struct ast* if_node);
	void handle_if_else(struct ast* if_else_node);

	
	// DONE
	void handle_condition(struct ast* condition_node, struct variable* end_label, vector<struct indirect_code*>* vec);
	void _handle_lt(struct ast* condition_node, struct variable* end_label, vector<struct indirect_code*>* vec);
	void _handle_lte(struct ast* condition_node, struct variable* end_label, vector<struct indirect_code*>* vec);
	void _handle_eq(struct ast* condition_node, struct variable* end_label, vector<struct indirect_code*>* vec);
	void _handle_neq(struct ast* condition_node, struct variable* end_label, vector<struct indirect_code*>* vec);
	//DONE - wczytywanie
	struct indirect_code* handle_value(struct ast* value_node, string reg);
	//DONE - zapisywanie
	struct indirect_code* handle_store(struct ast* value_node, string reg);
	//DONE - dzialania
	void handle_expression(struct ast* exp_node, string result_reg, vector<struct indirect_code*>* vec);
	//DONE - przypisanie a := b + c
	struct block* handle_assign(struct ast* asg_node);
	//
	struct block* handle_write(struct ast* write_node);
	//
	struct block* handle_read(struct ast* read_node);
	//IN PROGRESS - assign
	struct block* handle_command(struct ast* command_node);

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
						$$ = newast("program", $2, $4, NULL, NULL, "", 0);
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
						struct ast* num1 = newast("num", NULL, NULL, NULL, NULL, "", $4);
						struct ast* num2 = newast("num", NULL, NULL, NULL, NULL, "", $6);
						$$ = newast("declarations", $1, id, num1, num2, "dec_arr", 0);
					}
| 					{
						$$ =  newast("NULL", NULL, NULL, NULL, NULL, "NULL", 0);
					}
;

commands:
	commands command
					{

						$$ = newast("commands", $1, $2, NULL, NULL, "", 0);
					}
|	command
					{
						$$ = newast("commands", $1, NULL, NULL, NULL, "", 0);
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
						struct ast* num = newast("num", NULL, NULL, NULL, NULL, "", $1);
						$$ = newast("value", num, NULL, NULL, NULL, "", 0);
					}
|	identifier
					{
						$$ = newast("value", $1, NULL, NULL, NULL, "", 0);
					}
;

identifier:
	ID
					{
						struct ast* id = newast("id", NULL, NULL, NULL, NULL, $1, 0);
						$$ = newast("identifier_id", id, NULL, NULL, NULL, "", 0);
					}
|	ID'('ID')'
					{
						struct ast* id1 = newast("id", NULL, NULL, NULL, NULL, $1, 0);
						struct ast* id2 = newast("id", NULL, NULL, NULL, NULL, $3, 0);
						$$ = newast("identifier_id_id", id1, id2, NULL, NULL, "", 0);
					}
|	ID'('NUM')'
					{
						struct ast* id = newast("id", NULL, NULL, NULL, NULL, $1, 0);
						struct ast* num = newast("num", NULL, NULL, NULL, NULL, "", $3);
						$$ = newast("identifier_id_num", id, num, NULL, NULL, "", 0);
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

// LABEL ITERATOR
struct variable* get_next_label_id() {
	struct variable* label = newvariable("", "", "", label_id);
	label_id++;

	return label;
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
	if(!value.empty())
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

void print_blocks(struct block* code_block) {

	do {
		cout << "--------BLOCK--------" << endl;
		for(int i = 0; i < code_block->codes.size(); i++) {
			print_indirect_code(code_block->codes[i]);
		}
		code_block = code_block->next;
	} while(code_block->next != NULL);
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

void print_indirect_code(struct indirect_code* code) {
	cout << code->kw << " VAL1: ";
	if(code->val1 != NULL) {
		cout << code->val1->label;
	}
	cout << " VAL2: ";
	if(code->val2 != NULL) {
		cout << code->val2->label;
	}
	cout << endl;
}

// VARIABLE

struct variable* newvariable(string label, string id1, string id2, int num) {
	struct variable* a = (struct variable*)malloc(sizeof(struct variable));

	if(!a) {
		yyerror("Błąd. Koniec pamięci\n");
        exit(1);
	}

	if(!label.empty())
	a->label = label;
	if(!id1.empty())
	a->id1 = id1;
	if(!id2.empty())
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
	struct block* b = handle_commands(root->s_2);
	print_blocks(b);
	
}

int semantic_analyse(struct ast* root) {
	// TODO
	return 1;
}


// void handle_if(struct ast* if_node) {
// 	struct ast* condition = if_node->s_1;
// 	struct ast* commands = if_node->s_2;
	
// 	struct block* commands_block = handle_commands(commands);

	
	
// }

// ################ DONE ####################
struct block* handle_commands(struct ast* commands_node) {
	// MOZE DO POPRAWY? SAM NIE WIEM
	// BUDUJE SIE OD OSTATNIEJ INSTRUKCJI
	struct block* code_block = newblock();
	if(commands_node == NULL) { // teoretycznie niepotrzebne
		// PUSTE COMMANDS
		cout << "NULL" << endl;
		return code_block;
	}

	while(commands_node->s_2 != NULL) {
		code_block->prev = handle_command(commands_node->s_2);
		code_block->prev->next = code_block;

		commands_node = commands_node->s_1;
		code_block = code_block->prev;

	}
	
	code_block->prev = handle_command(commands_node->s_1);
	code_block->prev->next = code_block;

	// while(code_block->prev != NULL) {
	// 	code_block = code_block->prev;
	// }
	return code_block->prev;
}

// ################## DONE ##################
struct block* handle_command(struct ast* command_node) {
	struct block* code_block = newblock();
	if(command_node->value.compare(":=") == 0) {
		// ASSIGN
		code_block = handle_assign(command_node);
	} else if(command_node->value.compare("if_else") == 0) {
		// IF ... THEN ... ELSE ... ENDIF

	} else if(command_node->value.compare("if") == 0) {
		// IF ... THEN ... ENDIF

	} else if(command_node->value.compare("while") == 0) {
		// WHILE ... DO ... ENDWHILE

	} else if(command_node->value.compare("do_while") == 0) {
		// DO ... WHILE ... ENDDO

	} else if(command_node->value.compare("for_to") == 0) {
		// FOR ID FROM ... TO ... DO ... ENDFOR

	} else if(command_node->value.compare("for_downto") == 0) {
		// FOR ID FROM ... DOWNTO ... DO ... ENDFOR

	} else if(command_node->value.compare("read") == 0) {
		// READ ...
		code_block = handle_read(command_node);
	} else {
		// WRITE ...
		code_block = handle_write(command_node);
	}
	return code_block;
}

void handle_condition(struct ast* condition_node, struct variable* end_label, vector<struct indirect_code*>* vec) { 

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
		_handle_lt(condition_node, end_label, vec);
	} else if(condition_node->value.compare("<=") == 0) {
		_handle_lte(condition_node, end_label, vec);
	} else if(condition_node->value.compare("=") == 0) {
		_handle_eq(condition_node, end_label, vec);
	} else if(condition_node->value.compare("!=") == 0) {
		_handle_neq(condition_node, end_label, vec);
	} else {

	}
}

// \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
// ########## <, <=, =, != ###################
void _handle_lt(struct ast* condition_node, struct variable* end_label, vector<struct indirect_code*>* vec) {
	struct variable* reg_B = newvariable("REG", "B", "", 0);
	struct variable* reg_C = newvariable("REG", "C", "", 0);
	
	struct indirect_code* a = handle_value(condition_node->s_1, "B");
	struct indirect_code* b = handle_value(condition_node->s_2, "C");
	(*vec).push_back(a);
	(*vec).push_back(b);

	// b - a
	struct indirect_code* sub = newindirect_code("SUB", reg_C, reg_B);
	(*vec).push_back(sub);
	// JUMP -> @END
	struct indirect_code* jzero = newindirect_code("@JZERO", reg_C, end_label);
	(*vec).push_back(jzero);
}

void _handle_lte(struct ast* condition_node, struct variable* end_label, vector<struct indirect_code*>* vec) {
	struct variable* reg_B = newvariable("REG", "B", "", 0);
	struct variable* reg_C = newvariable("REG", "C", "", 0);
	
	struct indirect_code* a = handle_value(condition_node->s_1, "B");
	struct indirect_code* b = handle_value(condition_node->s_2, "C");
	(*vec).push_back(a);
	(*vec).push_back(b);

	struct variable* lab = get_next_label_id();

	// a - b
	struct indirect_code* sub = newindirect_code("SUB", reg_B, reg_C);
	(*vec).push_back(sub);
	// JZERO -> (+2)
	struct indirect_code* jzero = newindirect_code("@JZERO", reg_B, lab);
	(*vec).push_back(jzero);
	// JUMP -> @END
	struct indirect_code* jump = newindirect_code("@JUMP", end_label, NULL);
	(*vec).push_back(jump);
	// LABEL (+2)
	struct indirect_code* label = newindirect_code("@LABEL", lab, NULL);
	(*vec).push_back(label);
}

void _handle_eq(struct ast* condition_node, struct variable* end_label, vector<struct indirect_code*>* vec) {
	struct variable* reg_B = newvariable("REG", "B", "", 0);
	struct variable* reg_C = newvariable("REG", "C", "", 0);
	struct variable* reg_D = newvariable("REG", "D", "", 0);

	struct indirect_code* a = handle_value(condition_node->s_1, "B");
	struct indirect_code* b = handle_value(condition_node->s_2, "C");
	(*vec).push_back(a);
	(*vec).push_back(b);

	// COPY a
	struct indirect_code* copy_a = newindirect_code("@COPY", reg_D, reg_B);
	(*vec).push_back(copy_a);

	struct variable* lab1 = get_next_label_id();
	struct variable* lab2 = get_next_label_id();


	// a - b
	struct indirect_code* sub = newindirect_code("SUB", reg_B, reg_C);
	(*vec).push_back(sub);
	// JZERO -> (+2)
	struct indirect_code* jzero = newindirect_code("@JZERO", reg_B, lab1);
	(*vec).push_back(jzero);
	// JUMP -> @END
	struct indirect_code* jump = newindirect_code("@JUMP", end_label, NULL);
	(*vec).push_back(jump);
	// LABEL (+2)
	struct indirect_code* label = newindirect_code("@LABEL", lab1, NULL);
	(*vec).push_back(label);

	// b - a
	sub = newindirect_code("SUB", reg_C, reg_D);
	(*vec).push_back(sub);
	// JZERO -> (+2)
	jzero = newindirect_code("@JZERO", reg_C, lab2);
	(*vec).push_back(jzero);
	// JUMP -> @END
	jump = newindirect_code("@JUMP", end_label, NULL);
	(*vec).push_back(jump);
	label = newindirect_code("@LABEL", lab2, NULL);
	(*vec).push_back(label);
}

void _handle_neq(struct ast* condition_node, struct variable* end_label, vector<struct indirect_code*>* vec) {
	struct variable* reg_B = newvariable("REG", "B", "", 0);
	struct variable* reg_C = newvariable("REG", "C", "", 0);
	struct variable* reg_D = newvariable("REG", "D", "", 0);

	struct indirect_code* a = handle_value(condition_node->s_1, "B");
	struct indirect_code* b = handle_value(condition_node->s_2, "C");
	(*vec).push_back(a);
	(*vec).push_back(b);

	// COPY a
	struct indirect_code* copy_a = newindirect_code("@COPY", reg_D, reg_B);
	(*vec).push_back(copy_a);

	struct variable* lab1 = get_next_label_id();
	struct variable* lab2 = get_next_label_id();

	// a - b
	struct indirect_code* sub = newindirect_code("SUB", reg_B, reg_C);
	(*vec).push_back(sub);
	// JZERO -> (+2)
	struct indirect_code* jzero = newindirect_code("@JZERO", reg_B, lab1);
	(*vec).push_back(jzero);
	// JUMP -> @lab2
	struct indirect_code* jump = newindirect_code("@JUMP", lab2, NULL);
	(*vec).push_back(jump);
	// LABEL (+2)
	struct indirect_code* label = newindirect_code("@LABEL", lab1, NULL);
	(*vec).push_back(label);

	// b - a
	sub = newindirect_code("SUB", reg_C, reg_D);
	(*vec).push_back(sub);
	// JZERO -> @END
	jzero = newindirect_code("@JZERO", reg_C, lab2);
	(*vec).push_back(jzero);
	// LABEL @lab2
	label = newindirect_code("@LABEL", lab2, NULL);
	(*vec).push_back(label);
}
// \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/


// ################### DONE #####################
struct block* handle_assign(struct ast* asg_node) {
	struct block* asg = newblock();

	handle_expression(asg_node->s_2, "B", &(asg->codes));
	struct indirect_code* code = handle_store(asg_node->s_2->s_1, "B");
	asg->codes.push_back(code);
	return asg;
}

// #################### DONE ##########################
void handle_expression(struct ast* exp_node, string result_reg, vector<struct indirect_code*>* vec) {
	if(exp_node->value.compare("value") == 0) {
		// stała
		struct indirect_code* var1 = handle_value(exp_node->s_1, result_reg);
		//
		// TU MOZE NIE DZIALAC
		// FIXME
		(*vec).push_back(var1);
	} else {
		// wyrazenie
		struct indirect_code* var1 = handle_value(exp_node->s_1, result_reg);
		struct indirect_code* var2 = handle_value(exp_node->s_2, "C");
		(*vec).push_back(var1);
		(*vec).push_back(var2);

		struct variable* reg1 = newvariable("REG", result_reg, "", 0);
		struct variable* reg2 = newvariable("REG", "C", "", 0);
		if(exp_node->value.compare("+") == 0) { // + dodawanie
			struct indirect_code* add = newindirect_code("ADD", reg1, reg2);
			(*vec).push_back(add);
		} else if(exp_node->value.compare("-") == 0) { // - odejmowanie
			struct indirect_code* sub = newindirect_code("SUB", reg1, reg2);
			(*vec).push_back(sub);
		} else if(exp_node->value.compare("*") == 0) { // * mnozenie
			struct indirect_code* mul = newindirect_code("@MUL", reg1, reg2);
			(*vec).push_back(mul);
		} else if(exp_node->value.compare("/") == 0) { // / dzielenie
			struct indirect_code* div = newindirect_code("@DIV", reg1, reg2);
			(*vec).push_back(div);
		} else { // % modulo
			struct indirect_code* mod = newindirect_code("@MOD", reg1, reg2);
			(*vec).push_back(mod);
		}
	}
}

// ########################### DONE ############################
struct indirect_code* handle_value(struct ast* value_node, string reg) {
	struct indirect_code* code;
	if(value_node->s_1->type.compare("num") == 0) {
		// numer (generowanie stalej)
		struct variable* var1 = newvariable("CONST", "", "", value_node->s_1->number);
		struct variable* var2 = newvariable("REG", reg, "", 0);

		code = newindirect_code("@LOAD", var1, var2);
	} else {
		if(value_node->s_1->type.compare("identifier_id") == 0) {
			// zmienna
			struct variable* var1 = newvariable("VAR", value_node->s_1->s_1->value, "", 0);
			struct variable* var2 = newvariable("REG", reg, "", 0);

			code = newindirect_code("@LOAD", var1, var2);
		} else if(value_node->s_1->type.compare("identifier_id_id") == 0) {
			// tablica id(id)
			struct variable* var1 = newvariable("ARR", value_node->s_1->s_1->value, value_node->s_1->s_2->value, 0);
			struct variable* var2 = newvariable("REG", reg, "", 0);

			code = newindirect_code("@LOAD", var1, var2);
		} else { // if(value_node->s_1->type.compare("identifier_id_num")) {
			// tablica id(numer)
			struct variable* var1 = newvariable("ARR", value_node->s_1->s_1->value, "", value_node->s_1->s_2->number);
			struct variable* var2 = newvariable("REG", reg, "", 0);

			code = newindirect_code("@LOAD", var1, var2);
		} 
	}
	return code;
}

// ##################### DONE #########################
struct indirect_code* handle_store(struct ast* value_node, string reg) {
	struct indirect_code* code;

	if(value_node->s_1->type.compare("num") == 0) {
		// numer (generowanie stalej)
		// tego nie bedzie
		struct variable* var1 = newvariable("REG", reg, "", 0);
		struct variable* var2 = newvariable("CONST", "", "", value_node->s_1->number);

		code = newindirect_code("@STORE", var1, var2);
	} else {
		if(value_node->s_1->type.compare("identifier_id") == 0) {
			// zmienna
			struct variable* var1 = newvariable("REG", reg, "", 0);
			struct variable* var2 = newvariable("VAR", value_node->s_1->s_1->value, "", 0);

			code = newindirect_code("@STORE", var1, var2);
		} else if(value_node->s_1->type.compare("identifier_id_id") == 0) {
			// tablica id(id)
			struct variable* var1 = newvariable("REG", reg, "", 0);
			struct variable* var2 = newvariable("ARR", value_node->s_1->s_1->value, value_node->s_1->s_2->value, 0);

			code = newindirect_code("@STORE", var1, var2);
		} else { // if(value_node->s_1->type.compare("identifier_id_num")) {
			// tablica id(numer)
			struct variable* var1 = newvariable("REG", reg, "", 0);
			struct variable* var2 = newvariable("ARR", value_node->s_1->s_1->value, "", value_node->s_1->s_2->number);

			code = newindirect_code("@STORE", var1, var2);
		} 
	}
	return code;
}

struct block* handle_read(struct ast* read_node) {
	// UWAGA handle_store(node) dostaje normalnie value, a nie identifier
	// dlatego tutaj nie przekazujemy syna tylko calego node
	struct block* read_block = newblock();

	struct variable* reg_B = newvariable("REG", "B", "", 0);

	struct indirect_code* code = newindirect_code("@GET", reg_B, NULL);
	read_block->codes.push_back(code);

	code = handle_store(read_node, "B");
	read_block->codes.push_back(code);
	
	return read_block;
}

struct block* handle_write(struct ast* write_node) {
	struct block* write_block = newblock();

	struct indirect_code* code = handle_value(write_node->s_1, "B");
	write_block->codes.push_back(code);
	struct variable* reg_B = newvariable("REG", "B", "", 0);

	code = newindirect_code("@PUT", reg_B, NULL);
	write_block->codes.push_back(code);

	
	return write_block;
}

void handle_if_else(struct ast* if_else_node) {
	struct ast* condition = if_else_node->s_1;
	struct ast* if_commands = if_else_node->s_2;
	struct ast* else_commands = if_else_node->s_3;

}
