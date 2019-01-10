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

map<string, int> vars;
map<string, struct arr*> arrays;
map<string, int> labels;

struct variable* get_next_label_id();
struct block* get_next_iter(struct ast* ID_node);


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
	struct block* handle_commands(struct ast* commands_node);

	struct block* handle_if(struct ast* if_node);
	struct block* handle_if_else(struct ast* if_else_node);

	struct block* handle_while(struct ast* while_node);

	struct block* handle_do_while(struct ast* do_while_node);
	
	struct block* handle_for_to(struct ast* for_to_node);

	struct block* handle_for_downto(struct ast* for_to_node);

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
	void declare_variables(struct ast* declarations);

	void gen_assembler(struct block* root);

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
						// cout << "END" << endl;
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
						// $$ =  newast("NULL", NULL, NULL, NULL, NULL, "NULL", 0);
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

	// initializeCompilation();
    // yyparse();
    // finishCompilation();
    // printf("Kompilacja zakonczona.\n");
	outfile.close();
	return 0;
}

void yyerror(char const *s){
	// finishCompilation();
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
struct block* get_next_iter(struct ast* ID_node, struct ast* value_node) {
	struct block* iter_block = newblock();
	struct variable* iterator = newvariable("ITER", ID_node->value, "", 0);
	// do mapy
	vars[ID_node->value] = iterator_id;

	// cout << "ITERATOR " << ID_node->value << "  id: " << iterator_id << endl;

	iterator_id++;

	struct indirect_code* code = handle_value(value_node, "B");
	iter_block->codes.push_back(code);

	struct variable* reg_B = newvariable("REG", "B", "", 0);
	code = newindirect_code("@STORE", reg_B, iterator);
	iter_block->codes.push_back(code);

	return iter_block;
}

// AST

struct ast* newast(string type, struct ast* s_1, struct ast* s_2, struct ast* s_3, struct ast* s_4, string value, unsigned long long number) {
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
	cout << "--------BLOCK--------" << endl;
	for(int i = 0; i < code_block->codes.size(); i++) {
		print_indirect_code(code_block->codes[i]);
	}
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
	struct block* b = handle_commands(root_node->s_2);

	print_blocks(b);
	gen_assembler(b);
	
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
			// cout << "DECLARE VAR : " << ptr->s_2->value << "  idx:" << mem_id << endl;
			vars[ptr->s_2->value] = mem_id;

		} else { // array
					mem_id -= (ptr->s_4->number - ptr->s_3->number + 1);
					struct arr* arr_obj = newarray(ptr->s_2->value, ptr->s_3->number, ptr->s_4->number, iterator_id);
					arrays[ptr->s_2->value] = arr_obj;

		}

		ptr = ptr->s_1;
	}
}




// TLUMACZENIA NA ASSEMBLER

void gen_assembler(struct block* root) {
	struct block* ptr = root;
	while(ptr != NULL) {

		for(int i = 0; i < ptr->codes.size(); i++) {
			struct indirect_code* code = (ptr->codes.at(i));
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
		ptr = ptr->next;
	}

	for(int i=0; i<instructs.size(); i++) {
		if(instructs[i].length() < 5) {
			outfile << jumps[instructs[i]] << labels[instructs[i]] << "    #" << i << endl;
		} else {
			outfile << instructs[i] << "    #" << i << endl;
		}
	}
	outfile << "HALT" << endl;
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
	// if(labels.find(code->val1->number) != labels.end()) {
		jumps[to_string(code->val1->number)] = "JUMP ";
		instructs.push_back(to_string(code->val1->number));
		linoleo++;
	// } else {

	// }
}

void gen_jzero(struct indirect_code* code) {
	// if(labels.find(code->val2->number) != labels.end()) {
		jumps[to_string(code->val2->number)] = "JZERO " + code->val1->id1 + " ";
		instructs.push_back(to_string(code->val2->number));
		linoleo++;
	// } else {
		
	// }
}

void gen_jodd(struct indirect_code* code) {
	// if(labels.find(code->val2->number) != labels.end()) {
		jumps[to_string(code->val2->number)] = "JODD " + code->val1->id1 + " ";
		instructs.push_back(to_string(code->val2->number));
		linoleo++;
	// } else {
		
	// }
}

void gen_half(struct indirect_code* code) {
	instructs.push_back("HALF " + code->val1->id1);
	linoleo++;
		
	// }
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
	// cout << code->val2->label << endl;
	if(code->val2->label.compare("VAR") == 0 || code->val2->label.compare("ITER") == 0) {
		idx = vars[code->val2->id1];
		gen_const("A", idx);

	} else if(code->val2->label.compare("ARR") == 0){
		struct arr* a = arrays[code->val2->id1];
		if(code->val2->id2.compare("") == 0) {
			idx = code->val2->number - a->from;
			gen_const("A", idx);
		} else {
			int a_idx = vars[code->val2->id2];
			gen_const("A", a_idx);
			instructs.push_back("LOAD A");
			linoleo++;
			gen_const("B", a->from);
			instructs.push_back("SUB A B");
			linoleo++;
		}
		// idx = a_idx - a->from;

	} else {
		// gen_const(code->val1->id1, code->val2->number);
		// return;
	}
	instructs.push_back("STORE " + code->val1->id1);
	linoleo++;
}

void gen_load(struct indirect_code* code) {
	int idx = 0;
	// cout << code->val1->label << endl;
	if(code->val1->label.compare("VAR") == 0 || code->val1->label.compare("ITER") == 0) {
		idx = vars[code->val1->id1];
		// cout << "VAR " << code->val1->id1 << "  idx: " << vars[code->val1->id1] << endl; 
		gen_const("A", idx);

	} else if(code->val1->label.compare("ARR") == 0){
		struct arr* a = arrays[code->val1->id1];
		if(code->val1->id2.compare("") == 0) {
			idx = code->val1->number - a->from;
			gen_const("A", idx);
		} else {
			int a_idx = vars[code->val1->id2];
			gen_const("A", a_idx);
			instructs.push_back("LOAD A");
			linoleo++;
			gen_const("B", a->from);
			instructs.push_back("SUB A B");
			linoleo++;
		}
		// idx = a_idx - a->from;

	} else {
		gen_const(code->val2->id1, code->val1->number);
		// cout << "LOAD ELSE" << code->val1->id1 << endl;
		return;
	}
	instructs.push_back("LOAD " + code->val2->id1);
	linoleo++;
}

void gen_const(string reg, int val) {
	vector<string> queue;
	// linoleo++;

	while(val > 0) {
		if(val % 2 == 0) {
			val = val / 2;
			queue.push_back("ADD " + reg + " " + reg);
			// linoleo++;
		} else {
			val--;
			queue.push_back("INC " + reg);
			// linoleo ++;
		}
	}
	queue.push_back("SUB " + reg + " " + reg);
	// linoleo++;

	// cout << queue.size() << endl;
	for(int i=queue.size()-1 ; i >= 0; i--) {
		instructs.push_back(queue[i]);
		linoleo++;
	}


	// int i = 1;
	// cout << "SUB " << reg << " " << reg << endl;
	// cout << "INC " << reg << endl;
	// while(2*i < val) {
	// 	cout << "ADD " << reg << " " << reg << endl;
	// 	i += i;
	// }
	// while(i < val) {
	// 	cout << "INC " << reg << endl;
	// 	i++;
	// }
}



struct block* handle_commands(struct ast* commands_node) {
	struct block* tmp = NULL;
	struct block* code_block = NULL;

	if(commands_node->s_2 != NULL) {
		tmp = handle_command(commands_node->s_2);
		code_block = handle_commands(commands_node->s_1);
	} else {
		tmp = handle_command(commands_node->s_1);
	}

	if(code_block != NULL) {
		struct block* ptr = code_block;
		while(ptr->next != NULL) {
			ptr = ptr->next;
		}
		ptr->next = tmp;
		tmp->prev = code_block;
		return code_block;
	} else {
		return tmp;
	}
}


// ################ DONE ####################
// struct block* handle_commands(struct ast* commands_node) {
// 	// MOZE DO POPRAWY? SAM NIE WIEM
// 	// BUDUJE SIE OD OSTATNIEJ INSTRUKCJI
// 	struct block* code_block = newblock();
// 	if(commands_node == NULL) { // teoretycznie niepotrzebne
// 		// PUSTE COMMANDS
// 		cout << "NULL" << endl;
// 		return code_block;
// 	}

// 	while(commands_node->s_2 != NULL) {
// 		struct block* tmp = handle_command(commands_node->s_2);
// 		// while(tmp->next != NULL) {
// 		// 	tmp = tmp->next;
// 		// }
// 		while(code_block->prev != NULL) {
// 			code_block = code_block->prev;
// 		}
// 		code_block->prev = tmp;
// 		tmp->next = code_block;

// 		commands_node = commands_node->s_1;
// 		// code_block = code_block->prev;

// 	}
// 	while(code_block->prev != NULL) {
// 		code_block = code_block->prev;
// 	}
	
// 	struct block* tmp = handle_command(commands_node->s_1);
// 	code_block->prev = tmp;
// 	tmp->next = code_block;

// 	while(code_block->next != NULL) {
// 		code_block = code_block->next;
// 	}

// 	return code_block;
// }

// ################## DONE ##################
struct block* handle_command(struct ast* command_node) {
	struct block* code_block = newblock();
	if(command_node->value.compare(":=") == 0) {
		// ASSIGN
		code_block = handle_assign(command_node);
		return code_block;
	} else if(command_node->value.compare("if_else") == 0) {
		// IF ... THEN ... ELSE ... ENDIF
		code_block = handle_if_else(command_node);
		return code_block;
	} else if(command_node->value.compare("if") == 0) {
		// IF ... THEN ... ENDIF
		code_block = handle_if(command_node);
		return code_block;
	} else if(command_node->value.compare("while") == 0) {
		// WHILE ... DO ... ENDWHILE
		code_block = handle_while(command_node);
		return code_block;
	} else if(command_node->value.compare("do_while") == 0) {
		// DO ... WHILE ... ENDDO
		code_block = handle_do_while(command_node);
		return code_block;
	} else if(command_node->value.compare("for_to") == 0) {
		// FOR ID FROM ... TO ... DO ... ENDFOR
		code_block = handle_for_to(command_node);
		return code_block;
	} else if(command_node->value.compare("for_downto") == 0) {
		// FOR ID FROM ... DOWNTO ... DO ... ENDFOR
		code_block = handle_for_downto(command_node);
		return code_block;
	} else if(command_node->value.compare("read") == 0) {
		// READ ...
		code_block =  handle_read(command_node);
		return code_block;
	} else {
		// WRITE ...
		code_block = handle_write(command_node);
		return code_block;
	}
	return newblock();
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
	// print_indirect_code(jzero);
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


// ###################### DONE ################
struct block* handle_if(struct ast* if_node) {
	struct variable* end_label = get_next_label_id();

	struct block* condition_block = newblock();
	handle_condition(if_node->s_1, end_label, &(condition_block->codes));
	
	struct block* commands_block = handle_commands(if_node->s_2);

	commands_block->prev = condition_block;
	condition_block->next = commands_block;

	struct block* tmp = condition_block;
	while(tmp->next != NULL) {
		tmp = tmp->next;
	}
	struct indirect_code* lab = newindirect_code("@LABEL", end_label, NULL);
	tmp->codes.push_back(lab);

	return condition_block;
}

// ###################### DONE ###################
struct block* handle_if_else(struct ast* if_else_node) {
	struct variable* else_label = get_next_label_id();

	struct block* condition_block = newblock();
	handle_condition(if_else_node->s_1, else_label, &(condition_block->codes));
	
	struct block* if_commands_block = handle_commands(if_else_node->s_2);
	struct block* else_commands_block = handle_commands(if_else_node->s_3);

	if_commands_block->prev = condition_block;
	condition_block->next = if_commands_block;

	struct block* tmp = condition_block;
	while(tmp->next != NULL) {
		tmp = tmp->next;
	}
	struct indirect_code* lab = newindirect_code("@LABEL", else_label, NULL);
	tmp->codes.push_back(lab);

	else_commands_block->prev = tmp;
	tmp->next = else_commands_block;

	return condition_block;
}

struct block* handle_while(struct ast* while_node) {
	struct variable* end_label = get_next_label_id();
	struct variable* loop_label = get_next_label_id();

	struct block* condition_block = newblock();
	struct indirect_code* lab_loop = newindirect_code("@LABEL", loop_label, NULL);
	condition_block->codes.push_back(lab_loop);

	handle_condition(while_node->s_1, end_label, &(condition_block->codes));
	
	struct block* commands_block = handle_commands(while_node->s_2);

	condition_block->next = commands_block;
	commands_block->prev = condition_block;

	struct block* tmp = commands_block;
	while(tmp->next != NULL) {
		tmp = tmp->next;
	}
	struct indirect_code* jump = newindirect_code("@JUMP", loop_label, NULL);
	tmp->codes.push_back(jump);
	struct indirect_code* lab_end = newindirect_code("@LABEL", end_label, NULL);
	tmp->codes.push_back(lab_end);

	return condition_block;
}

struct block* handle_do_while(struct ast* do_while_node) {
	struct variable* end_label = get_next_label_id();
	struct variable* loop_label = get_next_label_id();

	struct block* condition_block = newblock();
	handle_condition(do_while_node->s_2, end_label, &(condition_block->codes));
	
	struct block* commands_block = handle_commands(do_while_node->s_1);
	
	struct indirect_code* lab_loop = newindirect_code("@LABEL", loop_label, NULL);
	vector<struct indirect_code*>::iterator it;
	it = commands_block->codes.begin();
	commands_block->codes.insert(it, lab_loop);

	struct block* tmp = commands_block;
	while(tmp->next != NULL) {
		tmp = tmp->next;
	}

	tmp->next = condition_block;
	condition_block->prev = tmp;

	struct indirect_code* jump = newindirect_code("@JUMP", loop_label, NULL);
	condition_block->codes.push_back(jump);
	struct indirect_code* lab_end = newindirect_code("@LABEL", end_label, NULL);
	condition_block->codes.push_back(lab_end);

	return commands_block;
}

struct block* handle_for_to(struct ast* for_to_node) {
	struct variable* end_label = get_next_label_id();
	struct variable* loop_label = get_next_label_id();

	struct block* iter_block = get_next_iter(for_to_node->s_1, for_to_node->s_2);
	
	struct indirect_code* lab_loop = newindirect_code("@LABEL", loop_label, NULL);
	iter_block->codes.push_back(lab_loop);

	// CONDITION
	struct block* condition_block = newblock();
	struct variable* reg_B = newvariable("REG", "B", "", 0);
	struct variable* reg_C = newvariable("REG", "C", "", 0);
	struct variable* iterator = newvariable("ITER", for_to_node->s_1->value, "", 0);
	
	struct indirect_code* load_iter = newindirect_code("@LOAD", iterator, reg_B);
	struct indirect_code* b = handle_value(for_to_node->s_3, "C");

	condition_block->codes.push_back(load_iter);
	condition_block->codes.push_back(b);

	// b - @iter
	struct indirect_code* sub = newindirect_code("SUB", reg_C, reg_B);
	condition_block->codes.push_back(sub);
	// JUMP -> @END
	struct indirect_code* jzero = newindirect_code("@JZERO", reg_C, end_label);
	condition_block->codes.push_back(jzero);

	iter_block->next = condition_block;
	condition_block->prev = iter_block;

	// COMMANDS
	struct block* commands_block = handle_commands(for_to_node->s_4);

	condition_block->next = commands_block;
	commands_block->prev = condition_block;
	
	struct block* tmp = commands_block;
	while(tmp->next != NULL) {
		tmp = tmp->next;
	}

	tmp->codes.push_back(load_iter);
	struct indirect_code* inc = newindirect_code("INC", reg_B, NULL);
	tmp->codes.push_back(inc);
	struct indirect_code* store_iter = newindirect_code("@STORE", reg_B, iterator);
	tmp->codes.push_back(store_iter);
	struct indirect_code* jump = newindirect_code("@JUMP", loop_label, NULL);
	tmp->codes.push_back(jump);
	struct indirect_code* lab_end = newindirect_code("@LABEL", end_label, NULL);
	tmp->codes.push_back(lab_end);

	return iter_block;
}

struct block* handle_for_downto(struct ast* for_to_node) {
	struct variable* end_label = get_next_label_id();
	struct variable* loop_label = get_next_label_id();

	struct block* iter_block = get_next_iter(for_to_node->s_1, for_to_node->s_2);
	
	struct indirect_code* lab_loop = newindirect_code("@LABEL", loop_label, NULL);
	iter_block->codes.push_back(lab_loop);

	// CONDITION
	struct block* condition_block = newblock();
	struct variable* reg_B = newvariable("REG", "B", "", 0);
	struct variable* reg_C = newvariable("REG", "C", "", 0);
	struct variable* iterator = newvariable("ITER", for_to_node->s_1->value, "", 0);
	
	struct indirect_code* load_iter = newindirect_code("@LOAD", iterator, reg_B);
	struct indirect_code* b = handle_value(for_to_node->s_3, "C");

	condition_block->codes.push_back(load_iter);
	condition_block->codes.push_back(b);

	// TU MOZE BYC BLAD
	// @iter - b
	struct indirect_code* sub = newindirect_code("SUB", reg_B, reg_C);
	condition_block->codes.push_back(sub);
	// JUMP -> @END
	struct indirect_code* jzero = newindirect_code("@JZERO", reg_B, end_label);
	condition_block->codes.push_back(jzero);

	iter_block->next = condition_block;
	condition_block->prev = iter_block;

	// COMMANDS
	struct block* commands_block = handle_commands(for_to_node->s_4);

	condition_block->next = commands_block;
	commands_block->prev = condition_block;
	
	struct block* tmp = commands_block;
	while(tmp->next != NULL) {
		tmp = tmp->next;
	}

	tmp->codes.push_back(load_iter);
	struct indirect_code* dec = newindirect_code("DEC", reg_B, NULL);
	tmp->codes.push_back(dec);
	struct indirect_code* store_iter = newindirect_code("@STORE", reg_B, iterator);
	tmp->codes.push_back(store_iter);
	struct indirect_code* jump = newindirect_code("@JUMP", loop_label, NULL);
	tmp->codes.push_back(jump);
	struct indirect_code* lab_end = newindirect_code("@LABEL", end_label, NULL);
	tmp->codes.push_back(lab_end);

	return iter_block;
}

// ################### DONE #####################
struct block* handle_assign(struct ast* asg_node) {
	struct block* asg = newblock();

	handle_expression(asg_node->s_2, "B", &(asg->codes));
	struct indirect_code* code = handle_store(asg_node, "B");
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
			// DO OPTYMALIZACJI
			
			struct variable* reg3 = newvariable("REG", "D", "", 0);
			struct variable* reg4 = newvariable("REG", "E", "", 0);
			struct variable* lab1 = get_next_label_id();
			struct variable* lab2 = get_next_label_id();
			struct variable* lab_end = get_next_label_id();



			(*vec)[(*vec).size()-2] = handle_value(exp_node->s_1, reg3->id1);

			(*vec).push_back(newindirect_code("SUB", reg1, reg1));

			// struct indirect_code* cp1 = newindirect_code("@COPY", reg3, reg1);
			// (*vec).push_back(cp1);

			struct indirect_code* jodd = newindirect_code("@JODD", reg2, lab1);
			(*vec).push_back(jodd);
			struct indirect_code* jump1 = newindirect_code("@JUMP", lab2, NULL);
			(*vec).push_back(jump1);
			struct indirect_code* lab1_code = newindirect_code("@LABEL", lab1, NULL);
			(*vec).push_back(lab1_code);
			struct indirect_code* add1 = newindirect_code("ADD", reg1, reg3);
			(*vec).push_back(add1);
			struct indirect_code* lab2_code = newindirect_code("@LABEL", lab2, NULL);
			(*vec).push_back(lab2_code);
			struct indirect_code* add2 = newindirect_code("ADD", reg3, reg3);
			(*vec).push_back(add2);
			struct indirect_code* half = newindirect_code("@HALF", reg2, NULL);
			(*vec).push_back(half);
			(*vec).push_back(jodd);
			struct indirect_code* jzero = newindirect_code("@JZERO", reg2, lab_end);
			(*vec).push_back(jzero);
			struct indirect_code* jump2 = newindirect_code("@JUMP", lab2, NULL);
			(*vec).push_back(jump2);
			struct indirect_code* lab_end_code = newindirect_code("@LABEL", lab_end, NULL);
			(*vec).push_back(lab_end_code);
			
			
			// struct indirect_code* mul = newindirect_code("@MUL", reg1, reg2);
			// (*vec).push_back(mul);
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
