%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <iostream>
	#include <string>
	#include <vector>
	#include <map>
	#include <fstream>
	// #include <string.h>
	#include <typeinfo>
	using namespace std;
	int yylex(void);
	void yyerror(const char *);

	// long errno;
	extern int lineno;

	// output
	ofstream outfile;

// GLOBALS
int label_id = 0;
int iterator_id = 0;
int linoleo = 0;
// struct block* root;

map<string, string> jumps;
vector<string> instructs;

vector<struct indirect_code*> codes;

map<string, int> vars;
map<string, struct arr*> arrays;
map<string, int> labels;

struct variable* get_next_label_id();
void get_next_iter(struct ast* ID_node, struct ast* value_node);


// PRINTS
void print_blocks(struct block* code_block);
void print_indirect_code();

// AST

	struct ast {
		string type; // node type eg. program, value etc.
		struct ast* s_1;
		struct ast* s_2;
		struct ast* s_3;
		struct ast* s_4;
		string value; // for command and ID eg. "for_to", "while" etc.
		unsigned long long number;	
	};

	struct ast* newast(string type, struct ast* s_1, struct ast* s_2, struct ast* s_3, struct ast* s_4, string value, unsigned long long number);

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
		string label; // [VAR, REG, ARR, CONST, ITER]
		string id1; // for var name / reg name
		string id2; // for arr idx
		unsigned long long number; // for const value
	};

	struct variable* newvariable(string label, string id1, string id2, unsigned long long num);

// ARRAY
	struct arr {
		string id;
		int from;
		int to;
		int mem_idx;
	};

	struct arr* newarray(string id, int from, int to, int mem_idx);

// HANDLERS

	void handle_program(struct ast* root);
	// DONE
	void handle_commands(struct ast* commands_node);

	void handle_if(struct ast* if_node);
	void handle_if_else(struct ast* if_else_node);

	void handle_while(struct ast* while_node);

	void handle_do_while(struct ast* do_while_node);
	
	void handle_for_to(struct ast* for_to_node);

	void handle_for_downto(struct ast* for_to_node);

	// DONE
	void handle_condition(struct ast* condition_node, struct variable* end_label);
	void _handle_lt(struct ast* condition_node, struct variable* end_label);
	void _handle_lte(struct ast* condition_node, struct variable* end_label);
	void _handle_eq(struct ast* condition_node, struct variable* end_label);
	void _handle_neq(struct ast* condition_node, struct variable* end_label);
	//DONE - wczytywanie
	void handle_value(struct ast* value_node, string reg);
	//DONE - zapisywanie
	void handle_store(struct ast* value_node, string reg);
	//DONE - dzialania
	void handle_expression(struct ast* exp_node, string result_reg);
	//DONE - przypisanie a := b + c
	void handle_assign(struct ast* asg_node);
	//
	void handle_write(struct ast* write_node);
	//
	void handle_read(struct ast* read_node);
	//IN PROGRESS - assign
	void handle_command(struct ast* command_node);


	int semantic_analyse(struct ast* root);
	void declare_variables(struct ast* declarations);

	void gen_assembler();

	void gen_load(struct indirect_code* code);
	void gen_store(struct indirect_code* code);
	void gen_const(string reg, int val);
	void gen_add(struct indirect_code* code);
	void gen_sub(struct indirect_code* code);
	void gen_dec(struct indirect_code* code);
	void gen_inc(struct indirect_code* code);
	void gen_label(struct indirect_code* code);
	void gen_jzero(struct indirect_code* code);
	void gen_jump(struct indirect_code* code);
	void gen_copy(struct indirect_code* code);
	void gen_put(struct indirect_code* code);
	void gen_get(struct indirect_code* code);

	void gen_half(struct indirect_code* code);
	void gen_jodd(struct indirect_code* code);


%}

%union {
	struct ast* a;
	char* string;
	unsigned long long number;
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
					}
;

declarations: 
	declarations ID';' 				
					{
						struct ast* id = newast("id", NULL, NULL, NULL, NULL, $2, 0);
						$$ = newast("declarations", $1, id, NULL, NULL, "dec_var", 0);
					}
|	declarations ID'('NUM':'NUM')'';'
					{
						struct ast* id = newast("id", NULL, NULL, NULL, NULL, $2, 0);
						struct ast* num1 = newast("num", NULL, NULL, NULL, NULL, "", $4);
						struct ast* num2 = newast("num", NULL, NULL, NULL, NULL, "", $6);
						$$ = newast("declarations", $1, id, num1, num2, "dec_arr", 0);
					}
| 					{
						$$ = NULL;
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
	extern FILE * yyin; 
	FILE *infile = fopen(argv[1], "r");

	if (!infile) {
		printf( "File not found.");
		return -1;
	}

	// ofstream outfile;
  	outfile.open(argv[2]);

	yyin = infile;
	yyparse();

    // printf("Kompilacja zakonczona.\n");
	outfile.close();
	return 0;
}

void yyerror(char const *s){
	fprintf(stderr, "%s.\n", s);
	exit(1);
}


// LABEL ITERATOR
struct variable* get_next_label_id() {
	struct variable* label = newvariable("", "", "", label_id);
	label_id++;

	return label;
}

// LOOP ITERATOR
void get_next_iter(struct ast* ID_node, struct ast* value_node) {
	struct variable* iterator = newvariable("ITER", ID_node->value, "", 0);
	// do mapy
	vars[ID_node->value] = iterator_id;
	iterator_id++;

	handle_value(value_node, "B");

	struct variable* reg_B = newvariable("REG", "B", "", 0);
	codes.push_back(newindirect_code("@STORE", reg_B, iterator));
}

// AST

struct ast* newast(string type, struct ast* s_1, struct ast* s_2, struct ast* s_3, struct ast* s_4, string value, unsigned long long number) {
	struct ast* a = (struct ast*)malloc(sizeof(struct ast));

    if (!a) {
        yyerror("Błąd. Koniec pamięci\n");
        exit(1);
    }

    a->type = type;
    a->s_1 = s_1;
	a->s_2 = s_2;
	a->s_3 = s_3;
	a->s_4 = s_4;
	if(!value.empty())
    a->value = value;
	a->number = number;

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

	cout <<"SIZE " << a << endl;
	return a;
}

void print_blocks(struct block* code_block) {
	// struct block* tmp = code_block;

	// do {
	// 	cout << "--------BLOCK--------" << endl;
	// 	for(int i = 0; i < tmp->codes.size(); i++) {
	// 		print_indirect_code(tmp->codes[i]);
	// 	}
	// 	tmp = tmp->next;
	// } while(tmp->next != NULL);
	// cout << "--------BLOCK--------" << endl;
	// for(int i = 0; i < tmp->codes.size(); i++) {
	// 	print_indirect_code(tmp->codes[i]);
	// }
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

void print_indirect_code() {
	for(int i = 0; i < codes.size(); i++) {
		struct indirect_code* code = codes.at(i);
	
		cout << code->kw << "  ";
		if(code->val1 != NULL) {
			if(code->val1->label.compare("VAR") == 0) {
				cout << "[VAL] "<< code->val1->id1;

			} else if(code->val1->label.compare("REG") == 0) {
				cout << "[REG] "<< code->val1->id1;

			} else if(code->val1->label.compare("ARR") == 0) {
				cout << "[ARR] "<< code->val1->id1 << "(";
				if(code->val1->id2.compare("") != 0) {
					cout << code->val1->id2 << ")";
				} else {
					cout << code->val1->number << ")";
				}

			} else if(code->val1->label.compare("CONST") == 0) {
				cout << "[CONST] " << code->val1->number;
			} else if(code->val1->label.compare("ITER") == 0){
				cout << "[ITER] " << code->val1->id1;
			} else {
				cout << "[LAB] " << code->val1->number;
			}
		}
		cout << "  ";
		if(code->val2 != NULL) {
			if(code->val2->label.compare("VAR") == 0) {
				cout << "[VAL] "<< code->val2->id1;

			} else if(code->val2->label.compare("REG") == 0) {
				cout << "[REG] "<< code->val2->id1;

			} else if(code->val2->label.compare("ARR") == 0) {
				cout << "[ARR] "<< code->val2->id1 << "(";
				if(code->val2->id2.compare("") != 0) {
					cout << code->val2->id2 << ")";
				} else {
					cout << code->val2->number << ")";
				}

			} else if(code->val2->label.compare("CONST") == 0) {
				cout << "[CONST] " << code->val2->number;
			} else if(code->val2->label.compare("ITER") == 0){ 
				cout << "[ITER] " << code->val2->id1;
			} else {
				cout << "[LAB] " << code->val2->number;
			}
		}
		cout << endl;
	}
}

// VARIABLE

struct variable* newvariable(string label, string id1, string id2, unsigned long long num) {
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

struct arr* newarray(string id, int from, int to, int mem_idx) {
	struct arr* a = (struct arr*)malloc(sizeof(struct arr));

	if(!a) {
		yyerror("Błąd. Koniec pamięci\n");
        exit(1);
	}

	a->id = id;
	a->from = from;
	a->to = to;
	a->mem_idx = mem_idx;

	return a;
}


// HANDLERS
void handle_program(struct ast* root_node) {
	if(semantic_analyse(root_node) != 1) {
		cout << "ERROR! SEMANTIC ANALYSIS" << endl;
		return;
	}
	handle_commands(root_node->s_2);

	print_indirect_code();
	gen_assembler();
	
}

int semantic_analyse(struct ast* root) {
	// TODO
	declare_variables(root->s_1);

	return 1;
}

void declare_variables(struct ast* declarations) {
	struct ast* ptr = declarations;
	unsigned long long mem_id = 0;

	while(ptr != NULL) {
		if(ptr->value.compare("dec_var") == 0) { // variable
			// sprawdzenie czy juz zadeklarowana
			if(vars.find(ptr->s_2->value) == vars.end() && arrays.find(ptr->s_2->value) == arrays.end()) {
				mem_id++;
				iterator_id++;

			} else {
				string err = "Variable " + ptr->s_2->value + " was already declared!";
				yyerror(&err[0]);
			}

		} else { // array
			if(vars.find(ptr->s_2->value) == vars.end() && arrays.find(ptr->s_2->value) == arrays.end()) {
				if(ptr->s_4->number > ptr->s_3->number) {
					iterator_id += ptr->s_4->number - ptr->s_3->number + 1;
					mem_id += ptr->s_4->number - ptr->s_3->number + 1;

				} else {
					string err = "Wrong index values in " + ptr->s_2->value + " array!";
					yyerror(&err[0]);
				}
			} else {
				string err = "Variable " + ptr->s_2->value + " was already declared!";
				yyerror(&err[0]);
			}
		}

		ptr = ptr->s_1;
	}

	ptr = declarations;
	while(ptr != NULL) {
		if(ptr->value.compare("dec_var") == 0) { // variable
			mem_id--;
			vars[ptr->s_2->value] = mem_id;

		} else { // array
					mem_id -= (ptr->s_4->number - ptr->s_3->number + 1);
					struct arr* arr_obj = newarray(ptr->s_2->value, ptr->s_3->number, ptr->s_4->number, mem_id);
					arrays[ptr->s_2->value] = arr_obj;

		}

		ptr = ptr->s_1;
	}
}


// TLUMACZENIA NA ASSEMBLER

void gen_assembler() {

	for(int i = 0; i < codes.size(); i++) {
		struct indirect_code* code = codes.at(i);
		// instructs.push_back("INSTR: " + code->kw + "\n");
		if(code->kw.compare("@LOAD") == 0) {
			gen_load(code);
		} else if(code->kw.compare("@STORE") == 0) {
			gen_store(code);
		} else if(code->kw.compare("SUB") == 0) {
			gen_sub(code);
		} else if(code->kw.compare("ADD") == 0) {
			gen_add(code);
		} else if(code->kw.compare("DEC") == 0) {
			gen_dec(code);
		} else if(code->kw.compare("INC") == 0) {
			gen_inc(code);
		} else if(code->kw.compare("@LABEL") == 0) {
			gen_label(code);
		} else if(code->kw.compare("@JZERO") == 0) {
			gen_jzero(code);
		} else if(code->kw.compare("@JUMP") == 0) {
			gen_jump(code);
		} else if(code->kw.compare("@COPY") == 0) {
			gen_copy(code);
		} else if(code->kw.compare("@GET") == 0) {
			gen_get(code);
		} else if(code->kw.compare("@PUT") == 0) {
			gen_put(code);
		} else if(code->kw.compare("@HALF") == 0) {
			gen_half(code);
		} else if(code->kw.compare("@JODD") == 0) {
			gen_jodd(code);
		}

	}
	
	for(int i=0; i<instructs.size(); i++) {
		if(instructs[i].length() < 5) {
			outfile << jumps[instructs[i]] << labels[instructs[i]] << "    #" << i << endl;
		} else {
			outfile << instructs[i] << "    #" << i << endl;
		}
	}
	outfile << "HALT" << "    #" << instructs.size() << endl;
}

void gen_get(struct indirect_code* code) {
	instructs.push_back("GET " + code->val1->id1);
	linoleo++;
}

void gen_put(struct indirect_code* code) {
	instructs.push_back("PUT " + code->val1->id1);
	linoleo++;
}

void gen_copy(struct indirect_code* code) {
	instructs.push_back("COPY " + code->val1->id1 + " " + code->val2->id1);
	linoleo++;
}

void gen_jump(struct indirect_code* code) {
	jumps[to_string(code->val1->number)] = "JUMP ";
	instructs.push_back(to_string(code->val1->number));
	linoleo++;
}

void gen_jzero(struct indirect_code* code) {
	jumps[to_string(code->val2->number)] = "JZERO " + code->val1->id1 + " ";
	instructs.push_back(to_string(code->val2->number));
	linoleo++;
}

void gen_jodd(struct indirect_code* code) {
	jumps[to_string(code->val2->number)] = "JODD " + code->val1->id1 + " ";
	instructs.push_back(to_string(code->val2->number));
	linoleo++;
}

void gen_half(struct indirect_code* code) {
	instructs.push_back("HALF " + code->val1->id1);
	linoleo++;
}

void gen_label(struct indirect_code* code) {
	labels[to_string(code->val1->number)] = linoleo;
}

void gen_inc(struct indirect_code* code) {
	instructs.push_back("INC " + code->val1->id1);
	linoleo++;
}

void gen_dec(struct indirect_code* code) {
	instructs.push_back("DEC " + code->val1->id1);
	linoleo++;
}

void gen_sub(struct indirect_code* code) {
	instructs.push_back("SUB " + code->val1->id1 + " " + code->val2->id1);
	linoleo++;
}

void gen_add(struct indirect_code* code) {
	instructs.push_back("ADD " + code->val1->id1 + " " + code->val2->id1);
	linoleo++;
}

void gen_store(struct indirect_code* code) {
	int idx = 0;
	if(code->val2->label.compare("VAR") == 0 || code->val2->label.compare("ITER") == 0) {
		idx = vars[code->val2->id1];
		gen_const("A", idx);

	} else if(code->val2->label.compare("ARR") == 0){
		struct arr* a = arrays[code->val2->id1];
		if(code->val2->id2.compare("") == 0) {
			idx = code->val2->number - a->from + a->mem_idx;
			gen_const("A", idx);
		} else {
			int a_idx = vars[code->val2->id2];
			gen_const("A", a_idx);
			instructs.push_back("LOAD A");
			linoleo++;
			if(a->mem_idx > a->from) {
				gen_const("H", a->mem_idx - a->from);
				instructs.push_back("ADD A H");
				linoleo++;	
			} else {
				gen_const("H", a->from - a->mem_idx);
				instructs.push_back("SUB A H");
				linoleo++;
			}
			// gen_const("H", a->mem_idx);
			// instructs.push_back("ADD A H");
			// linoleo++;
			// gen_const("H", a->from);
			// instructs.push_back("SUB A H");
			// linoleo++;
		}

	} else {
		// gen_const(code->val1->id1, code->val2->number);
		// return;
	}
	instructs.push_back("STORE " + code->val1->id1);
	linoleo++;
}

void gen_load(struct indirect_code* code) {
	int idx = 0;
	if(code->val1->label.compare("VAR") == 0 || code->val1->label.compare("ITER") == 0) {
		idx = vars[code->val1->id1];
		gen_const("A", idx);

	} else if(code->val1->label.compare("ARR") == 0){
		struct arr* a = arrays[code->val1->id1];
		if(code->val1->id2.compare("") == 0) {
			idx = code->val1->number - a->from + a->mem_idx;
			gen_const("A", idx);
		} else {
			int a_idx = vars[code->val1->id2];
			gen_const("A", a_idx);
			instructs.push_back("LOAD A");
			linoleo++;
			if(a->mem_idx > a->from) {
				gen_const("H", a->mem_idx - a->from);
				instructs.push_back("ADD A H");
				linoleo++;
			} else {
				gen_const("H", a->from - a->mem_idx);
				instructs.push_back("SUB A H");
				linoleo++;	
			}
			// gen_const("H", a->mem_idx);
			// instructs.push_back("ADD A H");
			// linoleo++;
			// gen_const("H", a->from);
			// instructs.push_back("SUB A H");
			// linoleo++;
		}

	} else {
		gen_const(code->val2->id1, code->val1->number);
		return;

	}
	instructs.push_back("LOAD " + code->val2->id1);
	linoleo++;
}

void gen_const(string reg, int val) {
	vector<string> queue;

	while(val > 0) {
		if(val % 2 == 0) {
			val = val / 2;
			queue.push_back("ADD " + reg + " " + reg);
		} else {
			val--;
			queue.push_back("INC " + reg);
		}
	}
	queue.push_back("SUB " + reg + " " + reg);

	for(int i=queue.size()-1 ; i >= 0; i--) {
		instructs.push_back(queue[i]);
		linoleo++;
	}
}



void handle_commands(struct ast* commands_node) {

	if(commands_node->s_2 != NULL) {
		handle_commands(commands_node->s_1);
		handle_command(commands_node->s_2);
	} else {
		handle_command(commands_node->s_1);
	}
}


void handle_command(struct ast* command_node) {
	if(command_node->value.compare(":=") == 0) {
		// ASSIGN
		handle_assign(command_node);

	} else if(command_node->value.compare("if_else") == 0) {
		// IF ... THEN ... ELSE ... ENDIF
		handle_if_else(command_node);

	} else if(command_node->value.compare("if") == 0) {
		// IF ... THEN ... ENDIF
		handle_if(command_node);

	} else if(command_node->value.compare("while") == 0) {
		// WHILE ... DO ... ENDWHILE
		handle_while(command_node);

	} else if(command_node->value.compare("do_while") == 0) {
		// DO ... WHILE ... ENDDO
		handle_do_while(command_node);

	} else if(command_node->value.compare("for_to") == 0) {
		// FOR ID FROM ... TO ... DO ... ENDFOR
		handle_for_to(command_node);

	} else if(command_node->value.compare("for_downto") == 0) {
		// FOR ID FROM ... DOWNTO ... DO ... ENDFOR
		handle_for_downto(command_node);

	} else if(command_node->value.compare("read") == 0) {
		// READ ...
		handle_read(command_node);

	} else {
		// WRITE ...
		handle_write(command_node);

	}
}

void handle_condition(struct ast* condition_node, struct variable* end_label) { 

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
	} else {	}
	
	if(condition_node->value.compare("<") == 0) {
		_handle_lt(condition_node, end_label);
	} else if(condition_node->value.compare("<=") == 0) {
		_handle_lte(condition_node, end_label);
	} else if(condition_node->value.compare("=") == 0) {
		_handle_eq(condition_node, end_label);
	} else if(condition_node->value.compare("!=") == 0) {
		_handle_neq(condition_node, end_label);
	} else {

	}
}


void _handle_lt(struct ast* condition_node, struct variable* end_label) {
	struct variable* reg_B = newvariable("REG", "B", "", 0);
	struct variable* reg_C = newvariable("REG", "C", "", 0);
	
	handle_value(condition_node->s_1, "B");
	handle_value(condition_node->s_2, "C");

	// b - a
	struct indirect_code* sub = newindirect_code("SUB", reg_C, reg_B);
	codes.push_back(sub);
	// JUMP -> @END
	struct indirect_code* jzero = newindirect_code("@JZERO", reg_C, end_label);
	codes.push_back(jzero);
}

void _handle_lte(struct ast* condition_node, struct variable* end_label) {
	struct variable* reg_B = newvariable("REG", "B", "", 0);
	struct variable* reg_C = newvariable("REG", "C", "", 0);
	
	handle_value(condition_node->s_1, "B");
	handle_value(condition_node->s_2, "C");

	struct variable* lab = get_next_label_id();

	// a - b
	struct indirect_code* sub = newindirect_code("SUB", reg_B, reg_C);
	codes.push_back(sub);
	// JZERO -> (+2)
	struct indirect_code* jzero = newindirect_code("@JZERO", reg_B, lab);
	codes.push_back(jzero);
	// JUMP -> @END
	struct indirect_code* jump = newindirect_code("@JUMP", end_label, NULL);
	codes.push_back(jump);
	// LABEL (+2)
	struct indirect_code* label = newindirect_code("@LABEL", lab, NULL);
	codes.push_back(label);
}

void _handle_eq(struct ast* condition_node, struct variable* end_label) {
	struct variable* reg_B = newvariable("REG", "B", "", 0);
	struct variable* reg_C = newvariable("REG", "C", "", 0);
	struct variable* reg_D = newvariable("REG", "D", "", 0);

	handle_value(condition_node->s_1, "B");
	handle_value(condition_node->s_2, "C");

	// COPY a
	struct indirect_code* copy_a = newindirect_code("@COPY", reg_D, reg_B);
	codes.push_back(copy_a);

	struct variable* lab1 = get_next_label_id();
	struct variable* lab2 = get_next_label_id();


	// a - b
	struct indirect_code* sub = newindirect_code("SUB", reg_B, reg_C);
	codes.push_back(sub);
	// JZERO -> (+2)
	struct indirect_code* jzero = newindirect_code("@JZERO", reg_B, lab1);
	codes.push_back(jzero);
	// JUMP -> @END
	struct indirect_code* jump = newindirect_code("@JUMP", end_label, NULL);
	codes.push_back(jump);
	// LABEL (+2)
	struct indirect_code* label = newindirect_code("@LABEL", lab1, NULL);
	codes.push_back(label);

	// b - a
	sub = newindirect_code("SUB", reg_C, reg_D);
	codes.push_back(sub);
	// JZERO -> (+2)
	jzero = newindirect_code("@JZERO", reg_C, lab2);
	codes.push_back(jzero);
	// JUMP -> @END
	jump = newindirect_code("@JUMP", end_label, NULL);
	codes.push_back(jump);
	label = newindirect_code("@LABEL", lab2, NULL);
	codes.push_back(label);
}

void _handle_neq(struct ast* condition_node, struct variable* end_label) {
	struct variable* reg_B = newvariable("REG", "B", "", 0);
	struct variable* reg_C = newvariable("REG", "C", "", 0);
	struct variable* reg_D = newvariable("REG", "D", "", 0);

	handle_value(condition_node->s_1, "B");
	handle_value(condition_node->s_2, "C");

	// COPY a
	struct indirect_code* copy_a = newindirect_code("@COPY", reg_D, reg_B);
	codes.push_back(copy_a);

	struct variable* lab1 = get_next_label_id();
	struct variable* lab2 = get_next_label_id();

	// a - b
	struct indirect_code* sub = newindirect_code("SUB", reg_B, reg_C);
	codes.push_back(sub);
	// JZERO -> (+2)
	struct indirect_code* jzero = newindirect_code("@JZERO", reg_B, lab1);
	codes.push_back(jzero);
	// JUMP -> @lab2
	struct indirect_code* jump = newindirect_code("@JUMP", lab2, NULL);
	codes.push_back(jump);
	// LABEL (+2)
	struct indirect_code* label = newindirect_code("@LABEL", lab1, NULL);
	codes.push_back(label);

	// b - a
	sub = newindirect_code("SUB", reg_C, reg_D);
	codes.push_back(sub);
	// JZERO -> @END
	jzero = newindirect_code("@JZERO", reg_C, end_label);
	codes.push_back(jzero);
	// LABEL @lab2
	label = newindirect_code("@LABEL", lab2, NULL);
	codes.push_back(label);
}


void handle_if(struct ast* if_node) {
	struct variable* end_label = get_next_label_id();

	handle_condition(if_node->s_1, end_label);
	
	handle_commands(if_node->s_2);

	struct indirect_code* lab = newindirect_code("@LABEL", end_label, NULL);
	codes.push_back(lab);

}


void handle_if_else(struct ast* if_else_node) {
	struct variable* else_label = get_next_label_id();
	struct variable* end_label = get_next_label_id();

	handle_condition(if_else_node->s_1, else_label);
	
	handle_commands(if_else_node->s_2);
	struct indirect_code* else_lab_code = newindirect_code("@LABEL", else_label, NULL);
	codes.push_back(newindirect_code("@JUMP", end_label, NULL));

	codes.push_back(else_lab_code);
	handle_commands(if_else_node->s_3);
	struct indirect_code* end_lab_code = newindirect_code("@LABEL", end_label, NULL);
	codes.push_back(end_lab_code);

}

void handle_while(struct ast* while_node) {
	struct variable* end_label = get_next_label_id();
	struct variable* loop_label = get_next_label_id();

	struct indirect_code* lab_loop = newindirect_code("@LABEL", loop_label, NULL);
	codes.push_back(lab_loop);

	handle_condition(while_node->s_1, end_label);
	
	handle_commands(while_node->s_2);

	struct indirect_code* jump = newindirect_code("@JUMP", loop_label, NULL);
	codes.push_back(jump);
	struct indirect_code* lab_end = newindirect_code("@LABEL", end_label, NULL);
	codes.push_back(lab_end);

}

void handle_do_while(struct ast* do_while_node) {
	struct variable* end_label = get_next_label_id();
	struct variable* loop_label = get_next_label_id();

	handle_condition(do_while_node->s_2, end_label);
	
	struct indirect_code* lab_loop = newindirect_code("@LABEL", loop_label, NULL);
	codes.push_back(lab_loop);
	handle_commands(do_while_node->s_1);
	
	struct indirect_code* jump = newindirect_code("@JUMP", loop_label, NULL);
	codes.push_back(jump);
	struct indirect_code* lab_end = newindirect_code("@LABEL", end_label, NULL);
	codes.push_back(lab_end);

}

void handle_for_to(struct ast* for_to_node) {
	// struct indirect_code* tmp_struct;
	struct variable* end_label = get_next_label_id();
	struct variable* label_0 = get_next_label_id();
	struct variable* loop_label = get_next_label_id();

	struct variable* reg_B = newvariable("REG", "B", "", 0);
	struct variable* reg_C = newvariable("REG", "C", "", 0);
	struct variable* reg_D = newvariable("REG", "D", "", 0);


	handle_value(for_to_node->s_2, "B");
	handle_value(for_to_node->s_3, "C");
	struct indirect_code* sub_b_c = newindirect_code("SUB", reg_B, reg_C);
	codes.push_back(sub_b_c); // a - b
	struct indirect_code* jzero_b_0 = newindirect_code("@JZERO", reg_B, label_0);
	codes.push_back(jzero_b_0); // JZERO +2
	struct indirect_code* jump_end = newindirect_code("@JUMP", end_label, NULL);
	codes.push_back(jump_end); // JUMP END_LOOP
	struct indirect_code* label_0_code = newindirect_code("@LABEL", label_0, NULL);
	codes.push_back(label_0_code); // LABEL 0

	// INICJALIZACJA PETLI
	get_next_iter(for_to_node->s_1, for_to_node->s_2); // i := a

	// wartosc b jest caly czas w reg C
	// ZAPIS b do pamiecicondition_block_1->next = iter_block;
	vars[for_to_node->s_1->value + "_END"] = iterator_id;
	iterator_id++;
	struct variable* iterator_end = newvariable("ITER", for_to_node->s_1->value + "_END", "", 0);
	codes.push_back(newindirect_code("@STORE", reg_C, iterator_end));
	// labelka - poczatek petli
	struct indirect_code* lab_loop = newindirect_code("@LABEL", loop_label, NULL);
	codes.push_back(lab_loop);

	// COMMANDS BLOCK
	handle_commands(for_to_node->s_4);


	struct variable* iterator = newvariable("ITER", for_to_node->s_1->value, "", 0);

	codes.push_back(newindirect_code("@LOAD", iterator, reg_B)); // LOAD ITERATOR
	codes.push_back(newindirect_code("@LOAD", iterator_end, reg_C));
	codes.push_back(newindirect_code("@COPY", reg_D, reg_B));
	struct variable* lab1 = get_next_label_id();
	struct variable* lab2 = get_next_label_id();
	codes.push_back(newindirect_code("SUB", reg_B, reg_C)); // iter - iter_end
	codes.push_back(newindirect_code("@JZERO", reg_B, lab1)); // JZERO +2
	codes.push_back(newindirect_code("@JUMP", lab2, NULL)); // JUMP loop
	codes.push_back(newindirect_code("@LABEL", lab1, NULL));
	codes.push_back(newindirect_code("SUB", reg_C, reg_D)); // iter_end - iter
	codes.push_back(newindirect_code("@JZERO", reg_C, end_label)); // jump end
	codes.push_back(newindirect_code("@LABEL", lab2, NULL));
	codes.push_back(newindirect_code("INC", reg_D, NULL)); // ITERATOR++
	codes.push_back(newindirect_code("@STORE", reg_D, iterator));
	codes.push_back(newindirect_code("@JUMP", loop_label, NULL));
	codes.push_back(newindirect_code("@LABEL", end_label, NULL));
	
}

void handle_for_downto(struct ast* for_to_node) {
	struct variable* end_label = get_next_label_id();
	struct variable* end_label1 = get_next_label_id();
	struct variable* label_0 = get_next_label_id();
	struct variable* loop_label = get_next_label_id();

	struct variable* reg_B = newvariable("REG", "B", "", 0);
	struct variable* reg_C = newvariable("REG", "C", "", 0);
	struct variable* reg_D = newvariable("REG", "D", "", 0);


	handle_value(for_to_node->s_2, "B");
	handle_value(for_to_node->s_3, "C");
	codes.push_back(newindirect_code("@COPY", reg_D, reg_C));
	struct indirect_code* sub_b_c = newindirect_code("SUB", reg_C, reg_B);
	codes.push_back(sub_b_c); // b - a
	struct indirect_code* jzero_c_0 = newindirect_code("@JZERO", reg_C, label_0);
	codes.push_back(jzero_c_0); // JZERO +2
	struct indirect_code* jump_end = newindirect_code("@JUMP", end_label1, NULL);
	codes.push_back(jump_end); // JUMP END_LOOP
	struct indirect_code* label_0_code = newindirect_code("@LABEL", label_0, NULL);
	codes.push_back(label_0_code); // LABEL 0

	// INICJALIZACJA PETLI
	get_next_iter(for_to_node->s_1, for_to_node->s_2); // i := a

	// wartosc b jest caly czas w reg D
	// ZAPIS b do pamiecicondition_block_1->next = iter_block;
	vars[for_to_node->s_1->value + "_END"] = iterator_id;
	iterator_id++;
	struct variable* iterator_end = newvariable("ITER", for_to_node->s_1->value + "_END", "", 0);
	codes.push_back(newindirect_code("@STORE", reg_D, iterator_end));
	// labelka - poczatek petli
	struct indirect_code* lab_loop = newindirect_code("@LABEL", loop_label, NULL);
	codes.push_back(lab_loop);

	// COMMANDS BLOCK
	handle_commands(for_to_node->s_4);


	struct variable* iterator = newvariable("ITER", for_to_node->s_1->value, "", 0);

	codes.push_back(newindirect_code("@LOAD", iterator, reg_B)); // LOAD ITERATOR
	
	// ITERATOR caly czas w rejestrze B i D
	// CONDITION while
	struct variable* lab1 = get_next_label_id();
	struct variable* lab2 = get_next_label_id();

	codes.push_back(newindirect_code("@JZERO", reg_B, lab2));
	codes.push_back(newindirect_code("DEC", reg_B, NULL)); // ITERATOR++
	codes.push_back(newindirect_code("@STORE", reg_B, iterator)); // STORE ITERATOR
	// load b & copy iterator
	codes.push_back(newindirect_code("@LOAD", iterator_end, reg_C));
	codes.push_back(newindirect_code("SUB", reg_C, reg_B));
	codes.push_back(newindirect_code("@JZERO", reg_C, lab1));
	codes.push_back(newindirect_code("@JUMP", end_label, NULL));
	codes.push_back(newindirect_code("@LABEL", lab1, NULL));
	codes.push_back(newindirect_code("@JUMP", loop_label, NULL));
	codes.push_back(newindirect_code("@LABEL", end_label, NULL));
	codes.push_back(newindirect_code("@LABEL", end_label1, NULL));
	codes.push_back(newindirect_code("@LABEL", lab2, NULL));

}


void handle_assign(struct ast* asg_node) {

	handle_expression(asg_node->s_2, "B");
	handle_store(asg_node, "B");
}


void handle_expression(struct ast* exp_node, string result_reg) {
	if(exp_node->value.compare("value") == 0) {
		// stała
		handle_value(exp_node->s_1, result_reg);
	} else {
		// wyrazenie

		struct variable* reg1 = newvariable("REG", result_reg, "", 0);
		struct variable* reg2 = newvariable("REG", "C", "", 0);
		if(exp_node->value.compare("+") == 0) { // + dodawanie
			struct indirect_code* add = newindirect_code("ADD", reg1, reg2);
			handle_value(exp_node->s_1, result_reg);
			handle_value(exp_node->s_2, "C");
			codes.push_back(add);
		} else if(exp_node->value.compare("-") == 0) { // - odejmowanie
			struct indirect_code* sub = newindirect_code("SUB", reg1, reg2);
			handle_value(exp_node->s_1, result_reg);
			handle_value(exp_node->s_2, "C");
			codes.push_back(sub);
		} else if(exp_node->value.compare("*") == 0) { // * mnozenie
			// DO OPTYMALIZACJI
			
			struct variable* reg3 = newvariable("REG", "D", "", 0);
			struct variable* reg4 = newvariable("REG", "E", "", 0);
			struct variable* lab1 = get_next_label_id();
			struct variable* lab2 = get_next_label_id();
			struct variable* lab_end = get_next_label_id();



			handle_value(exp_node->s_1, reg3->id1);
			handle_value(exp_node->s_2, "C");
			codes.push_back(newindirect_code("SUB", reg1, reg1));


			struct indirect_code* jodd = newindirect_code("@JODD", reg2, lab1);
			codes.push_back(jodd);
			struct indirect_code* jump1 = newindirect_code("@JUMP", lab2, NULL);
			codes.push_back(jump1);
			struct indirect_code* lab1_code = newindirect_code("@LABEL", lab1, NULL);
			codes.push_back(lab1_code);
			struct indirect_code* add1 = newindirect_code("ADD", reg1, reg3);
			codes.push_back(add1);
			struct indirect_code* lab2_code = newindirect_code("@LABEL", lab2, NULL);
			codes.push_back(lab2_code);
			struct indirect_code* add2 = newindirect_code("ADD", reg3, reg3);
			codes.push_back(add2);
			struct indirect_code* half = newindirect_code("@HALF", reg2, NULL);
			codes.push_back(half);
			codes.push_back(jodd);
			struct indirect_code* jzero = newindirect_code("@JZERO", reg2, lab_end);
			codes.push_back(jzero);
			struct indirect_code* jump2 = newindirect_code("@JUMP", lab2, NULL);
			codes.push_back(jump2);
			struct indirect_code* lab_end_code = newindirect_code("@LABEL", lab_end, NULL);
			codes.push_back(lab_end_code);
			
			
		} else if(exp_node->value.compare("/") == 0) { // / dzielenie
			struct variable* reg3 = newvariable("REG", "D", "", 0);
			struct variable* reg4 = newvariable("REG", "E", "", 0);
			struct variable* reg5 = newvariable("REG", "F", "", 0);

			struct variable* lab1 = get_next_label_id();
			struct variable* lab2 = get_next_label_id();
			struct variable* lab3 = get_next_label_id();
			struct variable* lab4 = get_next_label_id();
			struct variable* lab5 = get_next_label_id();
			struct variable* lab6 = get_next_label_id();
			struct variable* lab7 = get_next_label_id();

			codes.push_back(newindirect_code("SUB", reg1, reg1));
			handle_value(exp_node->s_2, reg3->id1);
			
			cout << "REG# - D :  " << reg3->id1 << endl;
			codes.push_back(newindirect_code("@JZERO", reg3, lab7)); // dzielenie przez 0
			handle_value(exp_node->s_1, reg2->id1);


			codes.push_back(newindirect_code("SUB", reg4, reg4));
			struct indirect_code* inc_4 = newindirect_code("INC", reg4, NULL);
			codes.push_back(inc_4);

			struct indirect_code* lab1_code = newindirect_code("@LABEL", lab1, NULL);
			codes.push_back(lab1_code);
			struct indirect_code* copy_5_3 = newindirect_code("@COPY", reg5, reg3);
			codes.push_back(copy_5_3);
			struct indirect_code* sub_5_2 = newindirect_code("SUB", reg5, reg2);
			codes.push_back(sub_5_2);
			struct indirect_code* jzero_r5_2 = newindirect_code("@JZERO", reg5, lab2);
			codes.push_back(jzero_r5_2);
			struct indirect_code* jump_3 = newindirect_code("@JUMP", lab3, NULL);
			codes.push_back(jump_3);
			struct indirect_code* lab2_code = newindirect_code("@LABEL", lab2, NULL);
			codes.push_back(lab2_code);
			struct indirect_code* add_3_3 = newindirect_code("ADD", reg3, reg3);
			codes.push_back(add_3_3);
			// struct indirect_code* inc_4 = newindirect_code("INC", reg4, NULL);
			codes.push_back(inc_4);
			struct indirect_code* jump_1 = newindirect_code("@JUMP", lab1, NULL);
			codes.push_back(jump_1);
			struct indirect_code* lab3_code = newindirect_code("@LABEL", lab3, NULL);
			codes.push_back(lab3_code);
			struct indirect_code* jzero_r4_4 = newindirect_code("@JZERO", reg4, lab4);
			codes.push_back(jzero_r4_4);
			struct indirect_code* add_1_1 = newindirect_code("ADD", reg1, reg1);
			codes.push_back(add_1_1);
			codes.push_back(copy_5_3);
			codes.push_back(sub_5_2);
			struct indirect_code* jzero_r5_5 = newindirect_code("@JZERO", reg5, lab5);
			codes.push_back(jzero_r5_5);
			struct indirect_code* jump_6 = newindirect_code("@JUMP", lab6, NULL);
			codes.push_back(jump_6);
			struct indirect_code* lab5_code = newindirect_code("@LABEL", lab5, NULL);
			codes.push_back(lab5_code);
			struct indirect_code* sub_2_3 = newindirect_code("SUB", reg2, reg3);
			codes.push_back(sub_2_3);
			struct indirect_code* inc_1 = newindirect_code("INC", reg1, NULL);
			codes.push_back(inc_1);
			struct indirect_code* lab6_code = newindirect_code("@LABEL", lab6, NULL);
			codes.push_back(lab6_code);
			struct indirect_code* half_3 = newindirect_code("@HALF", reg3, NULL);
			codes.push_back(half_3);
			struct indirect_code* dec_4 = newindirect_code("DEC", reg4, NULL);
			codes.push_back(dec_4);
			codes.push_back(jump_3);
			struct indirect_code* lab4_code = newindirect_code("@LABEL", lab4, NULL);
			codes.push_back(lab4_code);
			struct indirect_code* lab7_code = newindirect_code("@LABEL", lab7, NULL);
			codes.push_back(lab7_code);
		} else { // % modulo
			struct indirect_code* mod = newindirect_code("@MOD", reg1, reg2);
			struct variable* reg3 = newvariable("REG", "D", "", 0);
			struct variable* reg4 = newvariable("REG", "E", "", 0);
			struct variable* reg5 = newvariable("REG", "F", "", 0);
			reg2 = reg1;

			struct variable* lab1 = get_next_label_id();
			struct variable* lab2 = get_next_label_id();
			struct variable* lab3 = get_next_label_id();
			struct variable* lab4 = get_next_label_id();
			struct variable* lab5 = get_next_label_id();
			struct variable* lab6 = get_next_label_id();
			struct variable* lab7 = get_next_label_id();

			codes.push_back(newindirect_code("SUB", reg1, reg1));
			handle_value(exp_node->s_2, reg3->id1);
			
			codes.push_back(newindirect_code("@JZERO", reg3, lab7)); // dzielenie przez 0
			handle_value(exp_node->s_1, reg2->id1);


			codes.push_back(newindirect_code("SUB", reg4, reg4));
			struct indirect_code* inc_4 = newindirect_code("INC", reg4, NULL);
			codes.push_back(inc_4);

			struct indirect_code* lab1_code = newindirect_code("@LABEL", lab1, NULL);
			codes.push_back(lab1_code);
			struct indirect_code* copy_5_3 = newindirect_code("@COPY", reg5, reg3);
			codes.push_back(copy_5_3);
			struct indirect_code* sub_5_2 = newindirect_code("SUB", reg5, reg2);
			codes.push_back(sub_5_2);
			struct indirect_code* jzero_r5_2 = newindirect_code("@JZERO", reg5, lab2);
			codes.push_back(jzero_r5_2);
			struct indirect_code* jump_3 = newindirect_code("@JUMP", lab3, NULL);
			codes.push_back(jump_3);
			struct indirect_code* lab2_code = newindirect_code("@LABEL", lab2, NULL);
			codes.push_back(lab2_code);
			struct indirect_code* add_3_3 = newindirect_code("ADD", reg3, reg3);
			codes.push_back(add_3_3);
			// struct indirect_code* inc_4 = newindirect_code("INC", reg4, NULL);
			codes.push_back(inc_4);
			struct indirect_code* jump_1 = newindirect_code("@JUMP", lab1, NULL);
			codes.push_back(jump_1);
			struct indirect_code* lab3_code = newindirect_code("@LABEL", lab3, NULL);
			codes.push_back(lab3_code);
			struct indirect_code* jzero_r4_4 = newindirect_code("@JZERO", reg4, lab4);
			codes.push_back(jzero_r4_4);
			codes.push_back(copy_5_3);
			codes.push_back(sub_5_2);
			struct indirect_code* jzero_r5_5 = newindirect_code("@JZERO", reg5, lab5);
			codes.push_back(jzero_r5_5);
			struct indirect_code* jump_6 = newindirect_code("@JUMP", lab6, NULL);
			codes.push_back(jump_6);
			struct indirect_code* lab5_code = newindirect_code("@LABEL", lab5, NULL);
			codes.push_back(lab5_code);
			struct indirect_code* sub_2_3 = newindirect_code("SUB", reg2, reg3);
			codes.push_back(sub_2_3);
			struct indirect_code* lab6_code = newindirect_code("@LABEL", lab6, NULL);
			codes.push_back(lab6_code);
			struct indirect_code* half_3 = newindirect_code("@HALF", reg3, NULL);
			codes.push_back(half_3);
			struct indirect_code* dec_4 = newindirect_code("DEC", reg4, NULL);
			codes.push_back(dec_4);
			codes.push_back(jump_3);
			struct indirect_code* lab4_code = newindirect_code("@LABEL", lab4, NULL);
			codes.push_back(lab4_code);
			struct indirect_code* lab7_code = newindirect_code("@LABEL", lab7, NULL);
			codes.push_back(lab7_code);
		}
	}
}


void handle_value(struct ast* value_node, string reg) {
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
	codes.push_back(code);
}


void handle_store(struct ast* value_node, string reg) {
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
	codes.push_back(code);
}

void handle_read(struct ast* read_node) {
	// UWAGA handle_store(node) dostaje normalnie value, a nie identifier
	// dlatego tutaj nie przekazujemy syna tylko calego node

	struct variable* reg_B = newvariable("REG", "B", "", 0);

	struct indirect_code* code = newindirect_code("@GET", reg_B, NULL);
	codes.push_back(code);

	handle_store(read_node, "B");
}

void handle_write(struct ast* write_node) {

	handle_value(write_node->s_1, "B");
	struct variable* reg_B = newvariable("REG", "B", "", 0);

	struct indirect_code* code = newindirect_code("@PUT", reg_B, NULL);
	codes.push_back(code);

}
