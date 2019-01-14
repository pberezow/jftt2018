/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.0.4"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* Copy the first part of user declarations.  */
#line 1 "parser.y" /* yacc.c:339  */

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
	unsigned long long iterator_id = 0;
	int linoleo = 0;

	map<string, string> jumps;
	vector<string> instructs;

	vector<struct indirect_code*> codes;

	map<string, int> vars;
	map<string, struct arr*> arrays;
	map<string, int> labels;

	struct variable* get_next_label_id();
	void get_next_iter(struct ast* ID_node, struct ast* value_node);

	map<string, int> init_iterators; // zadeklarowane iteratory
	map<string, int> declared_vars; // zadeklarowane zmienne
	map<string, int> used_variables; // przechowywane uzyte zmienne
	map<string, int> initialized_variables; // sprawdzanie czy zainicjowana

	void init_var(string name);
	void del_init_var(string name);
	int check_not_init_vars(struct ast* node);

	void add_var_to_used(string name, int line);

	void check_not_declared_vars(struct ast* command_node);

	int is_variable(string name);

	int was_initialized(string name);
	void init_iterator(string name);
	void del_iterator(string name);


// PRINTS
	void print_blocks(struct block* code_block);
	void print_indirect_code();

struct lex_token {
	string str;
	unsigned long long number;
	int lineno;
};

struct lex_token* newlex_token(string str, unsigned long long number, int lineno);

// AST

	struct ast {
		string type; // node type eg. program, value etc.
		struct ast* s_1;
		struct ast* s_2;
		struct ast* s_3;
		struct ast* s_4;
		string value; // for command and ID eg. "for_to", "while" etc.
		unsigned long long number;	
		int lineno;
	};

	struct ast* newast(string type, struct ast* s_1, struct ast* s_2, struct ast* s_3, struct ast* s_4, string value, unsigned long long number, int lineno);
	void free_ast(struct ast* node);

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
		unsigned long long from;
		unsigned long long to;
		unsigned long long mem_idx;
	};

	struct arr* newarray(string id, unsigned long long from, unsigned long long to, unsigned long long mem_idx);

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
	void gen_const(string reg, unsigned long long val);
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



#line 253 "parser.tab.c" /* yacc.c:339  */

# ifndef YY_NULLPTR
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULLPTR nullptr
#  else
#   define YY_NULLPTR 0
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* In a future release of Bison, this section will be replaced
   by #include "parser.tab.h".  */
#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    DECLARE = 258,
    IN = 259,
    END = 260,
    IF = 261,
    THEN = 262,
    ELSE = 263,
    ENDIF = 264,
    WHILE = 265,
    DO = 266,
    ENDWHILE = 267,
    ENDDO = 268,
    FOR = 269,
    FROM = 270,
    TO = 271,
    DOWNTO = 272,
    ENDFOR = 273,
    READ = 274,
    WRITE = 275,
    ASSIGN = 276,
    EQ = 277,
    NEQ = 278,
    LT = 279,
    GT = 280,
    LTE = 281,
    GTE = 282,
    ID = 283,
    NUM = 284
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 188 "parser.y" /* yacc.c:355  */

	struct ast* a;
	// char* string;
	// unsigned long long number;
	struct lex_token* lex_token;

#line 330 "parser.tab.c" /* yacc.c:355  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */

/* Copy the second part of user declarations.  */

#line 347 "parser.tab.c" /* yacc.c:358  */

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE
# if (defined __GNUC__                                               \
      && (2 < __GNUC__ || (__GNUC__ == 2 && 96 <= __GNUC_MINOR__)))  \
     || defined __SUNPRO_C && 0x5110 <= __SUNPRO_C
#  define YY_ATTRIBUTE(Spec) __attribute__(Spec)
# else
#  define YY_ATTRIBUTE(Spec) /* empty */
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# define YY_ATTRIBUTE_PURE   YY_ATTRIBUTE ((__pure__))
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# define YY_ATTRIBUTE_UNUSED YY_ATTRIBUTE ((__unused__))
#endif

#if !defined _Noreturn \
     && (!defined __STDC_VERSION__ || __STDC_VERSION__ < 201112)
# if defined _MSC_VER && 1200 <= _MSC_VER
#  define _Noreturn __declspec (noreturn)
# else
#  define _Noreturn YY_ATTRIBUTE ((__noreturn__))
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN \
    _Pragma ("GCC diagnostic push") \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")\
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif


#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYSIZE_T yynewbytes;                                            \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / sizeof (*yyptr);                          \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  4
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   205

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  39
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  9
/* YYNRULES -- Number of rules.  */
#define YYNRULES  33
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  92

/* YYTRANSLATE[YYX] -- Symbol number corresponding to YYX as returned
   by yylex, with out-of-bounds checking.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   284

#define YYTRANSLATE(YYX)                                                \
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, without out-of-bounds checking.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,    26,     2,     2,
      33,    34,    24,    22,     2,    23,     2,    25,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    38,    35,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    27,    28,    29,
      30,    31,    32,    36,    37
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   219,   219,   227,   233,   241,   247,   252,   259,   263,
     267,   271,   275,   279,   284,   289,   293,   300,   304,   308,
     312,   316,   320,   327,   331,   335,   339,   343,   347,   354,
     359,   367,   372,   378
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "DECLARE", "IN", "END", "IF", "THEN",
  "ELSE", "ENDIF", "WHILE", "DO", "ENDWHILE", "ENDDO", "FOR", "FROM", "TO",
  "DOWNTO", "ENDFOR", "READ", "WRITE", "ASSIGN", "'+'", "'-'", "'*'",
  "'/'", "'%'", "EQ", "NEQ", "LT", "GT", "LTE", "GTE", "'('", "')'", "';'",
  "ID", "NUM", "':'", "$accept", "program", "declarations", "commands",
  "command", "expression", "condition", "value", "identifier", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,    43,    45,    42,    47,    37,   277,   278,   279,
     280,   281,   282,    40,    41,    59,   283,   284,    58
};
# endif

#define YYPACT_NINF -26

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-26)))

#define YYTABLE_NINF -1

#define yytable_value_is_error(Yytable_value) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
       0,   -26,     7,    -2,   -26,   167,   -25,   -19,   -19,   167,
     -14,     3,   -19,   -22,    10,   -26,    12,    -6,   -26,   -26,
      33,   163,   -26,    30,   169,    27,     9,    13,   -10,   -26,
     -26,   -19,    15,   167,   -19,   -19,   -19,   -19,   -19,   -19,
     167,   -19,   -19,   -26,   -26,    16,    17,    19,    67,    18,
     100,   -26,   -26,   -26,   -26,   -26,   -26,   111,     1,    20,
     -26,   -26,   -26,   -19,   -19,   -19,   -19,   -19,    23,   167,
     -26,   -26,   -26,   -19,   -19,   -26,   -26,   -26,   -26,   -26,
      24,   118,    36,    47,   -26,   -26,   167,   167,   138,   149,
     -26,   -26
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       0,     5,     0,     0,     1,     0,     0,     0,     0,     0,
       0,     0,     0,    31,     0,     7,     0,     0,     3,    29,
       0,     0,    30,     0,     0,     0,     0,     0,     0,     2,
       6,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    15,    16,     0,     0,     0,    17,     0,
       0,    23,    24,    25,    26,    27,    28,     0,     0,     0,
      32,    33,     8,     0,     0,     0,     0,     0,     0,     0,
      10,    11,    12,     0,     0,    18,    19,    20,    21,    22,
       0,     0,     0,     0,     4,     9,     0,     0,     0,     0,
      13,    14
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int8 yypgoto[] =
{
     -26,   -26,   -26,    -8,    -1,   -26,    -3,    31,    -5
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int8 yydefgoto[] =
{
      -1,     2,     3,    14,    15,    47,    20,    21,    22
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_uint8 yytable[] =
{
      16,    24,     5,     1,    16,    23,    26,     4,    17,    16,
      18,    28,    40,    30,    72,    29,     7,    13,    19,    16,
       8,     9,    25,    30,    10,    50,    45,    46,    16,    11,
      12,    32,    57,    31,     6,    16,    73,    74,    58,    13,
      33,    40,    42,    27,    43,    16,    13,    86,    44,    30,
      60,    61,    16,    49,    62,    68,    30,    80,    87,    84,
       0,    81,    48,     0,    16,    51,    52,    53,    54,    55,
      56,     0,     0,    59,     0,     0,    16,     0,    88,    89,
      30,    16,    16,    16,    16,     0,     0,    30,    30,    63,
      64,    65,    66,    67,    75,    76,    77,    78,    79,     0,
       0,     0,     0,     0,    82,    83,     7,     0,    69,    70,
       8,     9,     0,     0,    10,     0,     0,     7,     0,    11,
      12,     8,     9,    71,     7,    10,     0,    85,     8,     9,
      11,    12,    10,     0,     0,     0,    13,    11,    12,     0,
       0,     0,     0,     0,     7,     0,     0,    13,     8,     9,
       0,     0,    10,     0,    13,     7,    90,    11,    12,     8,
       9,     0,     0,    10,     0,     0,     0,    91,    11,    12,
       0,     0,     0,     7,    13,     7,     0,     8,     9,    41,
       9,    10,     0,    10,     0,    13,    11,    12,    11,    12,
      34,    35,    36,    37,    38,    39,     0,     0,     0,     0,
       0,     0,     0,    13,     0,    13
};

static const yytype_int8 yycheck[] =
{
       5,     9,     4,     3,     9,     8,    11,     0,    33,    14,
      35,    33,    11,    14,    13,     5,     6,    36,    37,    24,
      10,    11,    36,    24,    14,    33,    36,    37,    33,    19,
      20,    37,    40,    21,    36,    40,    16,    17,    41,    36,
       7,    11,    15,    12,    35,    50,    36,    11,    35,    50,
      34,    34,    57,    38,    35,    37,    57,    34,    11,    35,
      -1,    69,    31,    -1,    69,    34,    35,    36,    37,    38,
      39,    -1,    -1,    42,    -1,    -1,    81,    -1,    86,    87,
      81,    86,    87,    88,    89,    -1,    -1,    88,    89,    22,
      23,    24,    25,    26,    63,    64,    65,    66,    67,    -1,
      -1,    -1,    -1,    -1,    73,    74,     6,    -1,     8,     9,
      10,    11,    -1,    -1,    14,    -1,    -1,     6,    -1,    19,
      20,    10,    11,    12,     6,    14,    -1,     9,    10,    11,
      19,    20,    14,    -1,    -1,    -1,    36,    19,    20,    -1,
      -1,    -1,    -1,    -1,     6,    -1,    -1,    36,    10,    11,
      -1,    -1,    14,    -1,    36,     6,    18,    19,    20,    10,
      11,    -1,    -1,    14,    -1,    -1,    -1,    18,    19,    20,
      -1,    -1,    -1,     6,    36,     6,    -1,    10,    11,    10,
      11,    14,    -1,    14,    -1,    36,    19,    20,    19,    20,
      27,    28,    29,    30,    31,    32,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    36,    -1,    36
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     3,    40,    41,     0,     4,    36,     6,    10,    11,
      14,    19,    20,    36,    42,    43,    47,    33,    35,    37,
      45,    46,    47,    45,    42,    36,    47,    46,    33,     5,
      43,    21,    37,     7,    27,    28,    29,    30,    31,    32,
      11,    10,    15,    35,    35,    36,    37,    44,    46,    38,
      42,    46,    46,    46,    46,    46,    46,    42,    45,    46,
      34,    34,    35,    22,    23,    24,    25,    26,    37,     8,
       9,    12,    13,    16,    17,    46,    46,    46,    46,    46,
      34,    42,    46,    46,    35,     9,    11,    11,    42,    42,
      18,    18
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    39,    40,    41,    41,    41,    42,    42,    43,    43,
      43,    43,    43,    43,    43,    43,    43,    44,    44,    44,
      44,    44,    44,    45,    45,    45,    45,    45,    45,    46,
      46,    47,    47,    47
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     5,     3,     8,     0,     2,     1,     4,     7,
       5,     5,     5,     9,     9,     3,     3,     1,     3,     3,
       3,     3,     3,     3,     3,     3,     3,     3,     3,     1,
       1,     1,     4,     4
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                  \
do                                                              \
  if (yychar == YYEMPTY)                                        \
    {                                                           \
      yychar = (Token);                                         \
      yylval = (Value);                                         \
      YYPOPSTACK (yylen);                                       \
      yystate = *yyssp;                                         \
      goto yybackup;                                            \
    }                                                           \
  else                                                          \
    {                                                           \
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;                                                  \
    }                                                           \
while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*----------------------------------------.
| Print this symbol's value on YYOUTPUT.  |
`----------------------------------------*/

static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyo = yyoutput;
  YYUSE (yyo);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# endif
  YYUSE (yytype);
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyoutput, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yytype_int16 *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  unsigned long int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[yyssp[yyi + 1 - yynrhs]],
                       &(yyvsp[(yyi + 1) - (yynrhs)])
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
static YYSIZE_T
yystrlen (const char *yystr)
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            /* Fall through.  */
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
  int yycount = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (! (yysize <= yysize1
                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
                    return 2;
                  yysize = yysize1;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
      return 2;
    yysize = yysize1;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        YYSTYPE *yyvs1 = yyvs;
        yytype_int16 *yyss1 = yyss;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * sizeof (*yyssp),
                    &yyvs1, yysize * sizeof (*yyvsp),
                    &yystacksize);

        yyss = yyss1;
        yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yytype_int16 *yyss1 = yyss;
        union yyalloc *yyptr =
          (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
                  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 2:
#line 220 "parser.y" /* yacc.c:1646  */
    {
						(yyval.a) = newast("program", (yyvsp[-3].a), (yyvsp[-1].a), NULL, NULL, "", 0, (yyvsp[-4].lex_token)->lineno);
						handle_program((yyval.a));
					}
#line 1501 "parser.tab.c" /* yacc.c:1646  */
    break;

  case 3:
#line 228 "parser.y" /* yacc.c:1646  */
    {
						struct ast* id = newast("id", NULL, NULL, NULL, NULL, (yyvsp[-1].lex_token)->str, 0, (yyvsp[-1].lex_token)->lineno);
						(yyval.a) = newast("declarations", (yyvsp[-2].a), id, NULL, NULL, "dec_var", 0, (yyvsp[-1].lex_token)->lineno);
						// declared_vars[$2] = 1;
					}
#line 1511 "parser.tab.c" /* yacc.c:1646  */
    break;

  case 4:
#line 234 "parser.y" /* yacc.c:1646  */
    {
						struct ast* id = newast("id", NULL, NULL, NULL, NULL, (yyvsp[-6].lex_token)->str, 0, (yyvsp[-6].lex_token)->lineno);
						struct ast* num1 = newast("num", NULL, NULL, NULL, NULL, "", (yyvsp[-4].lex_token)->number, (yyvsp[-4].lex_token)->lineno);
						struct ast* num2 = newast("num", NULL, NULL, NULL, NULL, "", (yyvsp[-2].lex_token)->number, (yyvsp[-2].lex_token)->lineno);
						(yyval.a) = newast("declarations", (yyvsp[-7].a), id, num1, num2, "dec_arr", 0, (yyvsp[-6].lex_token)->lineno);
						// declared_vars[$2] = 1;
					}
#line 1523 "parser.tab.c" /* yacc.c:1646  */
    break;

  case 5:
#line 241 "parser.y" /* yacc.c:1646  */
    {
						(yyval.a) = NULL;
					}
#line 1531 "parser.tab.c" /* yacc.c:1646  */
    break;

  case 6:
#line 248 "parser.y" /* yacc.c:1646  */
    {

						(yyval.a) = newast("commands", (yyvsp[-1].a), (yyvsp[0].a), NULL, NULL, "", 0, (yyvsp[0].a)->lineno);
					}
#line 1540 "parser.tab.c" /* yacc.c:1646  */
    break;

  case 7:
#line 253 "parser.y" /* yacc.c:1646  */
    {
						(yyval.a) = newast("commands", (yyvsp[0].a), NULL, NULL, NULL, "", 0, (yyvsp[0].a)->lineno);
					}
#line 1548 "parser.tab.c" /* yacc.c:1646  */
    break;

  case 8:
#line 260 "parser.y" /* yacc.c:1646  */
    {
						(yyval.a) = newast("command", (yyvsp[-3].a), (yyvsp[-1].a), NULL, NULL, ":=", 0, (yyvsp[-3].a)->lineno);
					}
#line 1556 "parser.tab.c" /* yacc.c:1646  */
    break;

  case 9:
#line 264 "parser.y" /* yacc.c:1646  */
    {
						(yyval.a) = newast("command", (yyvsp[-5].a), (yyvsp[-3].a), (yyvsp[-1].a), NULL, "if_else", 0, (yyvsp[-6].lex_token)->lineno);
                    }
#line 1564 "parser.tab.c" /* yacc.c:1646  */
    break;

  case 10:
#line 268 "parser.y" /* yacc.c:1646  */
    {
						(yyval.a) = newast("command", (yyvsp[-3].a), (yyvsp[-1].a), NULL, NULL, "if", 0, (yyvsp[-4].lex_token)->lineno);
                    }
#line 1572 "parser.tab.c" /* yacc.c:1646  */
    break;

  case 11:
#line 272 "parser.y" /* yacc.c:1646  */
    {
						(yyval.a) = newast("command", (yyvsp[-3].a), (yyvsp[-1].a), NULL, NULL, "while", 0, (yyvsp[-4].lex_token)->lineno);
                    }
#line 1580 "parser.tab.c" /* yacc.c:1646  */
    break;

  case 12:
#line 276 "parser.y" /* yacc.c:1646  */
    {
						(yyval.a) = newast("command", (yyvsp[-3].a), (yyvsp[-1].a), NULL, NULL, "do_while", 0, (yyvsp[-4].lex_token)->lineno);
					}
#line 1588 "parser.tab.c" /* yacc.c:1646  */
    break;

  case 13:
#line 280 "parser.y" /* yacc.c:1646  */
    {
						struct ast* id = newast("id", NULL, NULL, NULL, NULL, (yyvsp[-7].lex_token)->str, 0, (yyvsp[-7].lex_token)->lineno);
						(yyval.a) = newast("command", id, (yyvsp[-5].a), (yyvsp[-3].a), (yyvsp[-1].a), "for_to", 0, (yyvsp[-8].lex_token)->lineno);
		 			}
#line 1597 "parser.tab.c" /* yacc.c:1646  */
    break;

  case 14:
#line 285 "parser.y" /* yacc.c:1646  */
    {
						struct ast* id = newast("id", NULL, NULL, NULL, NULL, (yyvsp[-7].lex_token)->str, 0, (yyvsp[-7].lex_token)->lineno);
						(yyval.a) = newast("command", id, (yyvsp[-5].a), (yyvsp[-3].a), (yyvsp[-1].a), "for_downto", 0, (yyvsp[-8].lex_token)->lineno);
                    }
#line 1606 "parser.tab.c" /* yacc.c:1646  */
    break;

  case 15:
#line 290 "parser.y" /* yacc.c:1646  */
    {
						(yyval.a) = newast("command", (yyvsp[-1].a), NULL, NULL, NULL, "read", 0, (yyvsp[-2].lex_token)->lineno);
					}
#line 1614 "parser.tab.c" /* yacc.c:1646  */
    break;

  case 16:
#line 294 "parser.y" /* yacc.c:1646  */
    {
						(yyval.a) = newast("command", (yyvsp[-1].a), NULL, NULL, NULL, "write", 0, (yyvsp[-2].lex_token)->lineno);
					}
#line 1622 "parser.tab.c" /* yacc.c:1646  */
    break;

  case 17:
#line 301 "parser.y" /* yacc.c:1646  */
    {
						(yyval.a) = newast("expression", (yyvsp[0].a), NULL, NULL, NULL, "value", 0, (yyvsp[0].a)->lineno);
					}
#line 1630 "parser.tab.c" /* yacc.c:1646  */
    break;

  case 18:
#line 305 "parser.y" /* yacc.c:1646  */
    {
						(yyval.a) = newast("expression", (yyvsp[-2].a), (yyvsp[0].a), NULL, NULL, "+", 0, (yyvsp[-1].lex_token)->lineno);
					}
#line 1638 "parser.tab.c" /* yacc.c:1646  */
    break;

  case 19:
#line 309 "parser.y" /* yacc.c:1646  */
    {
						(yyval.a) = newast("expression", (yyvsp[-2].a), (yyvsp[0].a), NULL, NULL, "-", 0, (yyvsp[-1].lex_token)->lineno);
					}
#line 1646 "parser.tab.c" /* yacc.c:1646  */
    break;

  case 20:
#line 313 "parser.y" /* yacc.c:1646  */
    {
						(yyval.a) = newast("expression", (yyvsp[-2].a), (yyvsp[0].a), NULL, NULL, "*", 0, (yyvsp[-1].lex_token)->lineno);
					}
#line 1654 "parser.tab.c" /* yacc.c:1646  */
    break;

  case 21:
#line 317 "parser.y" /* yacc.c:1646  */
    {
						(yyval.a) = newast("expression", (yyvsp[-2].a), (yyvsp[0].a), NULL, NULL, "/", 0, (yyvsp[-1].lex_token)->lineno);
					}
#line 1662 "parser.tab.c" /* yacc.c:1646  */
    break;

  case 22:
#line 321 "parser.y" /* yacc.c:1646  */
    {
						(yyval.a) = newast("expression", (yyvsp[-2].a), (yyvsp[0].a), NULL, NULL, "%", 0, (yyvsp[-1].lex_token)->lineno);
					}
#line 1670 "parser.tab.c" /* yacc.c:1646  */
    break;

  case 23:
#line 328 "parser.y" /* yacc.c:1646  */
    {
						(yyval.a) = newast("condition", (yyvsp[-2].a), (yyvsp[0].a), NULL, NULL, "=", 0, (yyvsp[-1].lex_token)->lineno);
					}
#line 1678 "parser.tab.c" /* yacc.c:1646  */
    break;

  case 24:
#line 332 "parser.y" /* yacc.c:1646  */
    {
						(yyval.a) = newast("condition", (yyvsp[-2].a), (yyvsp[0].a), NULL, NULL, "!=", 0, (yyvsp[-1].lex_token)->lineno);
					}
#line 1686 "parser.tab.c" /* yacc.c:1646  */
    break;

  case 25:
#line 336 "parser.y" /* yacc.c:1646  */
    {
						(yyval.a) = newast("condition", (yyvsp[-2].a), (yyvsp[0].a), NULL, NULL, "<", 0, (yyvsp[-1].lex_token)->lineno);
					}
#line 1694 "parser.tab.c" /* yacc.c:1646  */
    break;

  case 26:
#line 340 "parser.y" /* yacc.c:1646  */
    {
						(yyval.a) = newast("condition", (yyvsp[-2].a), (yyvsp[0].a), NULL, NULL, ">", 0, (yyvsp[-1].lex_token)->lineno);
					}
#line 1702 "parser.tab.c" /* yacc.c:1646  */
    break;

  case 27:
#line 344 "parser.y" /* yacc.c:1646  */
    {
						(yyval.a) = newast("condition", (yyvsp[-2].a), (yyvsp[0].a), NULL, NULL, "<=", 0, (yyvsp[-1].lex_token)->lineno);
					}
#line 1710 "parser.tab.c" /* yacc.c:1646  */
    break;

  case 28:
#line 348 "parser.y" /* yacc.c:1646  */
    {
						(yyval.a) = newast("condition", (yyvsp[-2].a), (yyvsp[0].a), NULL, NULL, ">=", 0, (yyvsp[-1].lex_token)->lineno);
					}
#line 1718 "parser.tab.c" /* yacc.c:1646  */
    break;

  case 29:
#line 355 "parser.y" /* yacc.c:1646  */
    {
						struct ast* num = newast("num", NULL, NULL, NULL, NULL, "", (yyvsp[0].lex_token)->number, (yyvsp[0].lex_token)->lineno);
						(yyval.a) = newast("value", num, NULL, NULL, NULL, "", 0, (yyvsp[0].lex_token)->lineno);
					}
#line 1727 "parser.tab.c" /* yacc.c:1646  */
    break;

  case 30:
#line 360 "parser.y" /* yacc.c:1646  */
    {
						(yyval.a) = newast("value", (yyvsp[0].a), NULL, NULL, NULL, "", 0, (yyvsp[0].a)->lineno);
						add_var_to_used((yyvsp[0].a)->s_1->value, lineno);
					}
#line 1736 "parser.tab.c" /* yacc.c:1646  */
    break;

  case 31:
#line 368 "parser.y" /* yacc.c:1646  */
    {
						struct ast* id = newast("id", NULL, NULL, NULL, NULL, (yyvsp[0].lex_token)->str, 0, (yyvsp[0].lex_token)->lineno);
						(yyval.a) = newast("identifier_id", id, NULL, NULL, NULL, "", 0, (yyvsp[0].lex_token)->lineno);
					}
#line 1745 "parser.tab.c" /* yacc.c:1646  */
    break;

  case 32:
#line 373 "parser.y" /* yacc.c:1646  */
    {
						struct ast* id1 = newast("id", NULL, NULL, NULL, NULL, (yyvsp[-3].lex_token)->str, 0, (yyvsp[-3].lex_token)->lineno);
						struct ast* id2 = newast("id", NULL, NULL, NULL, NULL, (yyvsp[-1].lex_token)->str, 0, (yyvsp[-1].lex_token)->lineno);
						(yyval.a) = newast("identifier_id_id", id1, id2, NULL, NULL, "", 0, (yyvsp[-3].lex_token)->lineno);
					}
#line 1755 "parser.tab.c" /* yacc.c:1646  */
    break;

  case 33:
#line 379 "parser.y" /* yacc.c:1646  */
    {
						struct ast* id = newast("id", NULL, NULL, NULL, NULL, (yyvsp[-3].lex_token)->str, 0, (yyvsp[-3].lex_token)->lineno);
						struct ast* num = newast("num", NULL, NULL, NULL, NULL, "", (yyvsp[-1].lex_token)->number, (yyvsp[-1].lex_token)->lineno);
						(yyval.a) = newast("identifier_id_num", id, num, NULL, NULL, "", 0, (yyvsp[-3].lex_token)->lineno);
					}
#line 1765 "parser.tab.c" /* yacc.c:1646  */
    break;


#line 1769 "parser.tab.c" /* yacc.c:1646  */
      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
#line 387 "parser.y" /* yacc.c:1906  */



int main(int argc, char **argv) {
	extern FILE * yyin; 
	FILE *infile = fopen(argv[1], "r");

	if (!infile) {
		printf("Nie znaleziono pliku.\n");
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

// DO OBSLUGI BLEDOW ITERATORA
// sprawdza czy jest uzywany
int was_initialized(string name) {
	if(init_iterators.find(name) != init_iterators.end()) {
		if(init_iterators[name] == 1) {
			return 1;
		}
	}
	return 0;
}

// ustawia iterator jako uzywany
void init_iterator(string name) {
	init_iterators[name] = 1;
}

// usuwa iterator / ustawia jako nie uzywany
void del_iterator(string name) {
	// vars[name] = -1;
	// vars[name + "_END"] = -1;
	init_iterators[name] = -1;
}

// zmienna jako iterator
int is_variable(string name) {
	if(declared_vars.find(name) != declared_vars.end()) {
		if(declared_vars[name] == 1) {
			return 1;
		} else {
			return 0;
		}
	} else {
		return 0;
	}
}


void add_var_to_used(string name, int line) {
	if(used_variables.find(name) == used_variables.end()) {
		used_variables[name] = line;
	}
}


// sprawdzenie uzycia niezadeklarowanych zmiennych
void check_not_declared_vars(struct ast* command_node) {
	if(command_node->type.compare("identifier_id") == 0 || command_node->type.compare("identifier_id_num") == 0) {
		if(declared_vars.find(command_node->s_1->value) == declared_vars.end() || declared_vars[command_node->s_1->value] != 1) {
			// do poprawy sprawdzanie czy jest iteratorem
			string err = "Użycie niezadeklarowanej zmiennej " + command_node->s_1->value + " - w lini " + to_string(command_node->s_1->lineno);
			yyerror(&err[0]);
		}
	} else if(command_node->type.compare("identifier_id_id") == 0) {
		if(declared_vars.find(command_node->s_1->value) == declared_vars.end() || declared_vars[command_node->s_1->value] != 1) {
			// do poprawy sprawdzanie czy jest iteratorem
			string err = "Użycie niezadeklarowanej zmiennej " + command_node->s_1->value + " - w lini " + to_string(command_node->s_1->lineno);
			yyerror(&err[0]);
		}
		if(declared_vars.find(command_node->s_2->value) == declared_vars.end() || declared_vars[command_node->s_2->value] != 1) {
			// do poprawy sprawdzanie czy jest iteratorem
			string err = "Użycie niezadeklarowanej zmiennej " + command_node->s_2->value + " - w lini " + to_string(command_node->s_2->lineno);
			yyerror(&err[0]);
		}
	} else if(command_node->value.compare("for_to") == 0 || command_node->value.compare("for_downto") == 0) {
		declared_vars[command_node->s_1->value] = 1;

		check_not_declared_vars(command_node->s_2);
		check_not_declared_vars(command_node->s_3);
		check_not_declared_vars(command_node->s_4);

		declared_vars[command_node->s_1->value] = -1;
		// cout << "ITERATOR: " << command_node->s_1->value << " = " << declared_vars[command_node->s_1->value] << endl;
	} else {
		if(command_node->s_1 != NULL) {
			check_not_declared_vars(command_node->s_1);
		} 
		if(command_node->s_2 != NULL) {
			check_not_declared_vars(command_node->s_2);
		} 
		if(command_node->s_3 != NULL) {
			check_not_declared_vars(command_node->s_3);
		} 
		if(command_node->s_4 != NULL) {
			check_not_declared_vars(command_node->s_4);
		}
	}
}

struct lex_token* newlex_token(string str, unsigned long long number, int lineno) {
	struct lex_token* a = (struct lex_token*)malloc(sizeof(struct lex_token));

    if (!a) {
        yyerror("Błąd. Koniec pamięci\n");
        exit(1);
    }

	if(!str.empty())
    a->str = str;
    a->number = number;
	a->lineno = lineno;

    return a;
}

void init_var(string name) {
	initialized_variables[name] = 1;
}

void del_init_var(string name) {
	initialized_variables[name] = -1;
}

int check_not_init_vars(struct ast* node) {
	// TODO - obsluga tablic
	if(node->value.compare(":=") == 0) {
		init_var(node->s_1->s_1->value);
		check_not_init_vars(node->s_2);
	} else if(node->value.compare("read") == 0) {
		init_var(node->s_1->s_1->value);
		check_not_init_vars(node->s_1);
	} else if(node->value.compare("for_to") == 0 || node->value.compare("for_downto") == 0) {
		init_var(node->s_1->value);

		check_not_init_vars(node->s_2);
		check_not_init_vars(node->s_3);
		check_not_init_vars(node->s_4);

		del_init_var(node->s_1->value);
	} else if(node->type.compare("identifier_id") == 0 || node->type.compare("identifier_id_num") == 0) {
		if(initialized_variables.find(node->s_1->value) == initialized_variables.end()) {
			string err = "Uzycie niezainicjowanej zmiennej " + node->s_1->value + " w lini " + to_string(node->s_1->lineno);
			yyerror(&err[0]); 
		}
	} else if(node->type.compare("identifier_id_id") == 0) {
		if(initialized_variables.find(node->s_1->value) == initialized_variables.end()) {
			string err = "Uzycie niezainicjowanej zmiennej " + node->s_1->value + " w lini " + to_string(node->s_1->lineno);
			yyerror(&err[0]); 
		}
		if(initialized_variables.find(node->s_2->value) == initialized_variables.end()) {
			string err = "Uzycie niezainicjowanej zmiennej " + node->s_2->value + " w lini " + to_string(node->s_2->lineno);
			yyerror(&err[0]); 
		}
	} else {
		if(node->s_1 != NULL) {
			check_not_init_vars(node->s_1);
		}
		if(node->s_2 != NULL) {
			check_not_init_vars(node->s_2);
		}
		if(node->s_3 != NULL) {
			check_not_init_vars(node->s_3);
		}
		if(node->s_4 != NULL) {
			check_not_init_vars(node->s_4);
		}
	}
}

// AST

struct ast* newast(string type, struct ast* s_1, struct ast* s_2, struct ast* s_3, struct ast* s_4, string value, unsigned long long number, int lineno) {
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
	a->lineno = lineno;

    return a;
}

void free_ast(struct ast* node) {
	// cout << "START FREE :: type : " << node->type << endl;
	if(node == NULL) {
		return;
	}
	if(node->s_1 != NULL) {
		free_ast(node->s_1);
		node->s_1 = NULL;
	}

	if(node->s_2 != NULL) {
		free_ast(node->s_2);
		node->s_2 = NULL;
	}
	
	if(node->s_3 != NULL) {
		free_ast(node->s_3);
		node->s_3 = NULL;
	}
	
	if(node->s_4 != NULL) {
		free_ast(node->s_4);
		node->s_4 = NULL;
	}
	// node->type.clear();
	// node->value.clear();
	node->number = 0;
	free(node);
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

struct arr* newarray(string id, unsigned long long from, unsigned long long to, unsigned long long mem_idx) {
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
		cout << "Błąd podczas analizy semantycznej." << endl;
		return;
	}
	handle_commands(root_node->s_2);

	free_ast(root_node);
	gen_assembler();
	print_indirect_code();
	
}

int semantic_analyse(struct ast* root) {
	// TODO
	declare_variables(root->s_1);
	check_not_declared_vars(root->s_2);
	check_not_init_vars(root->s_2);

	return 1;
}

void declare_variables(struct ast* declarations) {
	struct ast* ptr = declarations;
	unsigned long long mem_id = 0;

	while(ptr != NULL) {
		if(ptr->value.compare("dec_var") == 0) { // variable
			// sprawdzenie czy juz zadeklarowana
			if(declared_vars.find(ptr->s_2->value) == declared_vars.end()) { // && arrays.find(ptr->s_2->value) == arrays.end()) {
				mem_id++;
				iterator_id++;
				declared_vars[ptr->s_2->value] = 1;

			} else {
				string err = "Zmienna " + ptr->s_2->value + " zadeklarowana więcej niż raz.";
				yyerror(&err[0]);
			}

		} else { // array
			if(declared_vars.find(ptr->s_2->value) == declared_vars.end()) { // && arrays.find(ptr->s_2->value) == arrays.end()) {
				if(ptr->s_4->number >= ptr->s_3->number) {
					iterator_id += ptr->s_4->number - ptr->s_3->number + 1;
					mem_id += ptr->s_4->number - ptr->s_3->number + 1;
					declared_vars[ptr->s_2->value] = 1;

				} else {
					string err = "Błędne indeksowanie tablicy - " + ptr->s_2->value;
					yyerror(&err[0]);
				}
			} else {
				string err = "Zmienna " + ptr->s_2->value + " zadeklarowana więcej niż raz.";
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
			// declared_vars[ptr->s_2->value] = 1;

		} else { // array
					mem_id -= (ptr->s_4->number - ptr->s_3->number + 1);
					struct arr* arr_obj = newarray(ptr->s_2->value, ptr->s_3->number, ptr->s_4->number, mem_id);
					arrays[ptr->s_2->value] = arr_obj;
					// declared_vars[ptr->s_2->value] = 1;
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
	unsigned long long idx = 0;
	if(code->val2->label.compare("VAR") == 0 || code->val2->label.compare("ITER") == 0) {
		if(vars.find(code->val2->id1) == vars.end()) {
			string err = "Błędne użycie zmiennej tablicowej " + code->val2->id1;
			yyerror(&err[0]);
		}

		idx = vars[code->val2->id1];
		gen_const("A", idx);

	// } else if(code->val2->label.compare("ITER") == 0) {
		// if(was_initialized(code->val2->id1) == 1) {
		// 	string err = "Niedozwolona zmiana wartości iteratora " + code->val2->id1;
		// 	yyerror(&err[0]);
		// } else {
		// 	init_iterators[code->val2->id1] = 1;
		// 	idx = vars[code->val2->id1];
		// 	gen_const("A", idx);
		// }
	} else if(code->val2->label.compare("ARR") == 0){
		if(arrays.find(code->val2->id1) == arrays.end()) {
			string err = "Błędne użycie zmiennej " + code->val2->id1;
			yyerror(&err[0]);
		}

		struct arr* a = arrays[code->val2->id1];
		if(code->val2->id2.compare("") == 0) {
			if(code->val2->number < a->from || code->val2->number > a->to) {
				string err = "Odwołanie do elementu poza tablicą - " + a->id + "(" + to_string(code->val2->number) + "). Tablica " + a->id + " przyjmuje indeksy z przedziału [" + to_string(a->from) + ", " + to_string(a->to) + "]";
				yyerror(&err[0]);
			}

			idx = code->val2->number - a->from + a->mem_idx;
			gen_const("A", idx);
		} else {
			if(vars.find(code->val2->id2) == vars.end()) {
				string err = "Błędne użycie zmiennej tablicowej " + code->val2->id2;
				yyerror(&err[0]);
			}

			unsigned long long a_idx = vars[code->val2->id2];
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
	unsigned long long idx = 0;
	if(code->val1->label.compare("VAR") == 0 || code->val1->label.compare("ITER") == 0) {
		if(vars.find(code->val1->id1) == vars.end()) {
			string err = "Błędne użycie zmiennej tablicowej " + code->val1->id1;
			yyerror(&err[0]);
		}

		idx = vars[code->val1->id1];
		gen_const("A", idx);

	} else if(code->val1->label.compare("ARR") == 0){
		if(arrays.find(code->val1->id1) == arrays.end()) {
			string err = "Błędne użycie zmiennej " + code->val1->id1;
			yyerror(&err[0]);
		}

		struct arr* a = arrays[code->val1->id1];
		if(code->val1->id2.compare("") == 0) {
			if(code->val1->number < a->from || code->val1->number > a->to) {
				string err = "Odwołanie do elementu poza tablicą - " + a->id + "(" + to_string(code->val1->number) + "). Tablica " + a->id + " przyjmuje indeksy z przedziału [" + to_string(a->from) + ", " + to_string(a->to) + "]";
				yyerror(&err[0]);
			}

			idx = code->val1->number - a->from + a->mem_idx;
			gen_const("A", idx);
		} else {
			if(vars.find(code->val1->id2) == vars.end()) {
				string err = "Błędne użycie zmiennej tablicowej " + code->val1->id2;
				yyerror(&err[0]);
			}

			unsigned long long a_idx = vars[code->val1->id2];
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

void gen_const(string reg, unsigned long long val) {
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
	if(was_initialized(for_to_node->s_1->value) == 1) {
		string err = "Ponowne użycie iteratora " + for_to_node->s_1->value + " na wyższym poziomie pętli";
		yyerror(&err[0]);
	}
	if(is_variable(for_to_node->s_1->value) == 1) {
		string err = "Błędna nazwa iteratora - " + for_to_node->s_1->value + " istnieje jako zmienna";
		yyerror(&err[0]);
	}

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
	init_iterator(for_to_node->s_1->value);
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
	
	del_iterator(for_to_node->s_1->value);
	
}

void handle_for_downto(struct ast* for_to_node) {
	if(was_initialized(for_to_node->s_1->value) == 1) {
		string err = "Ponowne użycie iteratora " + for_to_node->s_1->value + " na wyższym poziomie pętli";
		yyerror(&err[0]);
	}
	if(is_variable(for_to_node->s_1->value) == 1) {
		string err = "Błędna nazwa iteratora - " + for_to_node->s_1->value + " istnieje jako zmienna";
		yyerror(&err[0]);
	}

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
	init_iterator(for_to_node->s_1->value);
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
	
	del_iterator(for_to_node->s_1->value);

}


void handle_assign(struct ast* asg_node) {
	if(asg_node->s_1->type.compare("identifier_id") == 0) {
		if(was_initialized(asg_node->s_1->s_1->value) == 1) {
			string err = "Niedozwolona zmiana wartości iteratora " + asg_node->s_1->s_1->value;
			yyerror(&err[0]);
		}
	}

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
