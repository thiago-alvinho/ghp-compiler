/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

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

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output, and Bison version.  */
#define YYBISON 30802

/* Bison version string.  */
#define YYBISON_VERSION "3.8.2"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* First part of user prologue.  */
#line 1 "sintatico.y"

#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <map>
#include <unordered_map>

#define YYSTYPE atributos

using namespace std;

int var_temp_qnt;
int label_qnt;
string traducaoTemp;

struct Simbolo
{
	string label;
	string tipo = "";
	string tamanho = "";
	string vetor_string = "";
	bool tipado = false;
};

struct atributos
{
	string label;
	string traducao;
	string tipo;
	string tamanho = "";
	string vetor_string = "";
};

vector<string> declaracoes;
vector<unordered_map<string, Simbolo>> tabela;
vector<string> break_label_stack;
vector<string> continue_label_stack;
vector<string> rotulo_condicao;
vector<string> rotulo_inicio;
vector<string> rotulo_fim;
vector<string> rotulo_incremento;

map<string, map<string, string>> tipofinal;

int yylex(void);
void yyerror(string);
string gentempcode();
bool verificar(string name);
Simbolo buscar(string name);
void declarar(string tipo, string label, int tam_string);
string cast_implicito(atributos* no1, atributos* no2, atributos* no3, string tipo);
void atualizar(string tipo, string nome, string tamanho, string cadeia_char);
int tamanho_string(string traducao);
string retirar_aspas(string traducao, int tamanho);
void adicionarSimbolo(string nome);
void retirarEscopo();
void adicionarEscopo();
string genlabel();
void retirar_rotulos();



#line 135 "y.tab.c"

# ifndef YY_CAST
#  ifdef __cplusplus
#   define YY_CAST(Type, Val) static_cast<Type> (Val)
#   define YY_REINTERPRET_CAST(Type, Val) reinterpret_cast<Type> (Val)
#  else
#   define YY_CAST(Type, Val) ((Type) (Val))
#   define YY_REINTERPRET_CAST(Type, Val) ((Type) (Val))
#  endif
# endif
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

/* Use api.header.include to #include this header
   instead of duplicating it here.  */
#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    TK_NUM = 258,                  /* TK_NUM  */
    TK_FLOAT = 259,                /* TK_FLOAT  */
    TK_CHAR = 260,                 /* TK_CHAR  */
    TK_BOOL = 261,                 /* TK_BOOL  */
    TK_RELACIONAL = 262,           /* TK_RELACIONAL  */
    TK_ORLOGIC = 263,              /* TK_ORLOGIC  */
    TK_ANDLOGIC = 264,             /* TK_ANDLOGIC  */
    TK_NOLOGIC = 265,              /* TK_NOLOGIC  */
    TK_CAST = 266,                 /* TK_CAST  */
    TK_VAR = 267,                  /* TK_VAR  */
    TK_CADEIA_CHAR = 268,          /* TK_CADEIA_CHAR  */
    TK_MAIN = 269,                 /* TK_MAIN  */
    TK_DEF = 270,                  /* TK_DEF  */
    TK_ID = 271,                   /* TK_ID  */
    TK_IF = 272,                   /* TK_IF  */
    TK_THEN = 273,                 /* TK_THEN  */
    TK_ELSE = 274,                 /* TK_ELSE  */
    TK_WHILE = 275,                /* TK_WHILE  */
    TK_DO = 276,                   /* TK_DO  */
    TK_FOR = 277,                  /* TK_FOR  */
    TK_BREAK = 278,                /* TK_BREAK  */
    TK_CONTINUE = 279,             /* TK_CONTINUE  */
    TK_CPY = 280,                  /* TK_CPY  */
    TK_FIM = 281,                  /* TK_FIM  */
    TK_ERROR = 282                 /* TK_ERROR  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif
/* Token kinds.  */
#define YYEMPTY -2
#define YYEOF 0
#define YYerror 256
#define YYUNDEF 257
#define TK_NUM 258
#define TK_FLOAT 259
#define TK_CHAR 260
#define TK_BOOL 261
#define TK_RELACIONAL 262
#define TK_ORLOGIC 263
#define TK_ANDLOGIC 264
#define TK_NOLOGIC 265
#define TK_CAST 266
#define TK_VAR 267
#define TK_CADEIA_CHAR 268
#define TK_MAIN 269
#define TK_DEF 270
#define TK_ID 271
#define TK_IF 272
#define TK_THEN 273
#define TK_ELSE 274
#define TK_WHILE 275
#define TK_DO 276
#define TK_FOR 277
#define TK_BREAK 278
#define TK_CONTINUE 279
#define TK_CPY 280
#define TK_FIM 281
#define TK_ERROR 282

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
/* Symbol kind.  */
enum yysymbol_kind_t
{
  YYSYMBOL_YYEMPTY = -2,
  YYSYMBOL_YYEOF = 0,                      /* "end of file"  */
  YYSYMBOL_YYerror = 1,                    /* error  */
  YYSYMBOL_YYUNDEF = 2,                    /* "invalid token"  */
  YYSYMBOL_TK_NUM = 3,                     /* TK_NUM  */
  YYSYMBOL_TK_FLOAT = 4,                   /* TK_FLOAT  */
  YYSYMBOL_TK_CHAR = 5,                    /* TK_CHAR  */
  YYSYMBOL_TK_BOOL = 6,                    /* TK_BOOL  */
  YYSYMBOL_TK_RELACIONAL = 7,              /* TK_RELACIONAL  */
  YYSYMBOL_TK_ORLOGIC = 8,                 /* TK_ORLOGIC  */
  YYSYMBOL_TK_ANDLOGIC = 9,                /* TK_ANDLOGIC  */
  YYSYMBOL_TK_NOLOGIC = 10,                /* TK_NOLOGIC  */
  YYSYMBOL_TK_CAST = 11,                   /* TK_CAST  */
  YYSYMBOL_TK_VAR = 12,                    /* TK_VAR  */
  YYSYMBOL_TK_CADEIA_CHAR = 13,            /* TK_CADEIA_CHAR  */
  YYSYMBOL_TK_MAIN = 14,                   /* TK_MAIN  */
  YYSYMBOL_TK_DEF = 15,                    /* TK_DEF  */
  YYSYMBOL_TK_ID = 16,                     /* TK_ID  */
  YYSYMBOL_TK_IF = 17,                     /* TK_IF  */
  YYSYMBOL_TK_THEN = 18,                   /* TK_THEN  */
  YYSYMBOL_TK_ELSE = 19,                   /* TK_ELSE  */
  YYSYMBOL_TK_WHILE = 20,                  /* TK_WHILE  */
  YYSYMBOL_TK_DO = 21,                     /* TK_DO  */
  YYSYMBOL_TK_FOR = 22,                    /* TK_FOR  */
  YYSYMBOL_TK_BREAK = 23,                  /* TK_BREAK  */
  YYSYMBOL_TK_CONTINUE = 24,               /* TK_CONTINUE  */
  YYSYMBOL_TK_CPY = 25,                    /* TK_CPY  */
  YYSYMBOL_TK_FIM = 26,                    /* TK_FIM  */
  YYSYMBOL_TK_ERROR = 27,                  /* TK_ERROR  */
  YYSYMBOL_28_ = 28,                       /* '+'  */
  YYSYMBOL_29_ = 29,                       /* '-'  */
  YYSYMBOL_30_ = 30,                       /* '*'  */
  YYSYMBOL_31_ = 31,                       /* '/'  */
  YYSYMBOL_32_ = 32,                       /* '('  */
  YYSYMBOL_33_ = 33,                       /* ')'  */
  YYSYMBOL_34_ = 34,                       /* '{'  */
  YYSYMBOL_35_ = 35,                       /* '}'  */
  YYSYMBOL_36_ = 36,                       /* ';'  */
  YYSYMBOL_37_ = 37,                       /* '='  */
  YYSYMBOL_38_ = 38,                       /* ','  */
  YYSYMBOL_YYACCEPT = 39,                  /* $accept  */
  YYSYMBOL_S = 40,                         /* S  */
  YYSYMBOL_BLOCO = 41,                     /* BLOCO  */
  YYSYMBOL_42_1 = 42,                      /* $@1  */
  YYSYMBOL_COMANDOS = 43,                  /* COMANDOS  */
  YYSYMBOL_CRIAR_ROTULOS_FOR = 44,         /* CRIAR_ROTULOS_FOR  */
  YYSYMBOL_CRIAR_ROTULOS = 45,             /* CRIAR_ROTULOS  */
  YYSYMBOL_RETIRAR_ROTULOS = 46,           /* RETIRAR_ROTULOS  */
  YYSYMBOL_COMANDO = 47,                   /* COMANDO  */
  YYSYMBOL_ATRI = 48,                      /* ATRI  */
  YYSYMBOL_DEC = 49,                       /* DEC  */
  YYSYMBOL_E = 50                          /* E  */
};
typedef enum yysymbol_kind_t yysymbol_kind_t;




#ifdef short
# undef short
#endif

/* On compilers that do not define __PTRDIFF_MAX__ etc., make sure
   <limits.h> and (if available) <stdint.h> are included
   so that the code can choose integer types of a good width.  */

#ifndef __PTRDIFF_MAX__
# include <limits.h> /* INFRINGES ON USER NAME SPACE */
# if defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stdint.h> /* INFRINGES ON USER NAME SPACE */
#  define YY_STDINT_H
# endif
#endif

/* Narrow types that promote to a signed type and that can represent a
   signed or unsigned integer of at least N bits.  In tables they can
   save space and decrease cache pressure.  Promoting to a signed type
   helps avoid bugs in integer arithmetic.  */

#ifdef __INT_LEAST8_MAX__
typedef __INT_LEAST8_TYPE__ yytype_int8;
#elif defined YY_STDINT_H
typedef int_least8_t yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef __INT_LEAST16_MAX__
typedef __INT_LEAST16_TYPE__ yytype_int16;
#elif defined YY_STDINT_H
typedef int_least16_t yytype_int16;
#else
typedef short yytype_int16;
#endif

/* Work around bug in HP-UX 11.23, which defines these macros
   incorrectly for preprocessor constants.  This workaround can likely
   be removed in 2023, as HPE has promised support for HP-UX 11.23
   (aka HP-UX 11i v2) only through the end of 2022; see Table 2 of
   <https://h20195.www2.hpe.com/V2/getpdf.aspx/4AA4-7673ENW.pdf>.  */
#ifdef __hpux
# undef UINT_LEAST8_MAX
# undef UINT_LEAST16_MAX
# define UINT_LEAST8_MAX 255
# define UINT_LEAST16_MAX 65535
#endif

#if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
typedef __UINT_LEAST8_TYPE__ yytype_uint8;
#elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST8_MAX <= INT_MAX)
typedef uint_least8_t yytype_uint8;
#elif !defined __UINT_LEAST8_MAX__ && UCHAR_MAX <= INT_MAX
typedef unsigned char yytype_uint8;
#else
typedef short yytype_uint8;
#endif

#if defined __UINT_LEAST16_MAX__ && __UINT_LEAST16_MAX__ <= __INT_MAX__
typedef __UINT_LEAST16_TYPE__ yytype_uint16;
#elif (!defined __UINT_LEAST16_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST16_MAX <= INT_MAX)
typedef uint_least16_t yytype_uint16;
#elif !defined __UINT_LEAST16_MAX__ && USHRT_MAX <= INT_MAX
typedef unsigned short yytype_uint16;
#else
typedef int yytype_uint16;
#endif

#ifndef YYPTRDIFF_T
# if defined __PTRDIFF_TYPE__ && defined __PTRDIFF_MAX__
#  define YYPTRDIFF_T __PTRDIFF_TYPE__
#  define YYPTRDIFF_MAXIMUM __PTRDIFF_MAX__
# elif defined PTRDIFF_MAX
#  ifndef ptrdiff_t
#   include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  endif
#  define YYPTRDIFF_T ptrdiff_t
#  define YYPTRDIFF_MAXIMUM PTRDIFF_MAX
# else
#  define YYPTRDIFF_T long
#  define YYPTRDIFF_MAXIMUM LONG_MAX
# endif
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM                                  \
  YY_CAST (YYPTRDIFF_T,                                 \
           (YYPTRDIFF_MAXIMUM < YY_CAST (YYSIZE_T, -1)  \
            ? YYPTRDIFF_MAXIMUM                         \
            : YY_CAST (YYSIZE_T, -1)))

#define YYSIZEOF(X) YY_CAST (YYPTRDIFF_T, sizeof (X))


/* Stored state numbers (used for stacks). */
typedef yytype_int8 yy_state_t;

/* State numbers in computations.  */
typedef int yy_state_fast_t;

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


#ifndef YY_ATTRIBUTE_PURE
# if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define YY_ATTRIBUTE_PURE
# endif
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
# else
#  define YY_ATTRIBUTE_UNUSED
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YY_USE(E) ((void) (E))
#else
# define YY_USE(E) /* empty */
#endif

/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
#if defined __GNUC__ && ! defined __ICC && 406 <= __GNUC__ * 100 + __GNUC_MINOR__
# if __GNUC__ * 100 + __GNUC_MINOR__ < 407
#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")
# else
#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# endif
# define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
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

#if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
# define YY_IGNORE_USELESS_CAST_BEGIN                          \
    _Pragma ("GCC diagnostic push")                            \
    _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
# define YY_IGNORE_USELESS_CAST_END            \
    _Pragma ("GCC diagnostic pop")
#endif
#ifndef YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_END
#endif


#define YY_ASSERT(E) ((void) (0 && (E)))

#if !defined yyoverflow

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
#endif /* !defined yyoverflow */

#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yy_state_t yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (YYSIZEOF (yy_state_t) + YYSIZEOF (YYSTYPE)) \
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
        YYPTRDIFF_T yynewbytes;                                         \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * YYSIZEOF (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / YYSIZEOF (*yyptr);                        \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, YY_CAST (YYSIZE_T, (Count)) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYPTRDIFF_T yyi;                      \
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
#define YYLAST   190

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  39
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  12
/* YYNRULES -- Number of rules.  */
#define YYNRULES  39
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  97

/* YYMAXUTOK -- Last valid token kind.  */
#define YYMAXUTOK   282


/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                \
  (0 <= (YYX) && (YYX) <= YYMAXUTOK                     \
   ? YY_CAST (yysymbol_kind_t, yytranslate[YYX])        \
   : YYSYMBOL_YYUNDEF)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_int8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
      32,    33,    30,    28,    38,    29,     2,    31,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,    36,
       2,    37,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    34,     2,    35,     2,     2,     2,     2,
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
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27
};

#if YYDEBUG
/* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_int16 yyrline[] =
{
       0,    81,    81,   100,   100,   106,   111,   117,   128,   140,
     156,   160,   161,   162,   163,   182,   206,   228,   246,   271,
     282,   294,   328,   345,   349,   391,   407,   423,   438,   445,
     452,   469,   477,   489,   500,   507,   514,   521,   534,   556
};
#endif

/** Accessing symbol of state STATE.  */
#define YY_ACCESSING_SYMBOL(State) YY_CAST (yysymbol_kind_t, yystos[State])

#if YYDEBUG || 0
/* The user-facing name of the symbol whose (internal) number is
   YYSYMBOL.  No bounds checking.  */
static const char *yysymbol_name (yysymbol_kind_t yysymbol) YY_ATTRIBUTE_UNUSED;

/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "\"end of file\"", "error", "\"invalid token\"", "TK_NUM", "TK_FLOAT",
  "TK_CHAR", "TK_BOOL", "TK_RELACIONAL", "TK_ORLOGIC", "TK_ANDLOGIC",
  "TK_NOLOGIC", "TK_CAST", "TK_VAR", "TK_CADEIA_CHAR", "TK_MAIN", "TK_DEF",
  "TK_ID", "TK_IF", "TK_THEN", "TK_ELSE", "TK_WHILE", "TK_DO", "TK_FOR",
  "TK_BREAK", "TK_CONTINUE", "TK_CPY", "TK_FIM", "TK_ERROR", "'+'", "'-'",
  "'*'", "'/'", "'('", "')'", "'{'", "'}'", "';'", "'='", "','", "$accept",
  "S", "BLOCO", "$@1", "COMANDOS", "CRIAR_ROTULOS_FOR", "CRIAR_ROTULOS",
  "RETIRAR_ROTULOS", "COMANDO", "ATRI", "DEC", "E", YY_NULLPTR
};

static const char *
yysymbol_name (yysymbol_kind_t yysymbol)
{
  return yytname[yysymbol];
}
#endif

#define YYPACT_NINF (-79)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-1)

#define yytable_value_is_error(Yyn) \
  0

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
static const yytype_int16 yypact[] =
{
      -4,    -2,    14,   -19,   -79,   -79,   -79,    65,   -79,   -79,
     -79,   -79,    90,    90,     0,   -79,   -18,   -14,   -12,   -79,
     -10,   -15,    -9,     4,    90,   -79,    22,    65,    24,    26,
      25,   -79,   -79,   -79,   -79,    90,    90,    90,   -19,    42,
     -79,   -79,    90,   104,   -79,   -79,   -79,   -79,    90,    90,
      90,    90,    90,    90,    90,   -79,   155,   110,   116,   -79,
     -18,    29,    21,   -79,   -23,   159,    16,   -21,   -21,   -79,
     -79,    48,   -79,    47,    90,    90,   -19,   -19,    52,   100,
     143,    60,   -79,    90,    42,   -79,   -19,   -79,   149,    59,
     -79,    44,   -79,   -79,   -19,   -79,   -79
};

/* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE does not specify something else to do.  Zero
   means the default is an error.  */
static const yytype_int8 yydefact[] =
{
       0,     0,     0,     0,     1,     3,     2,     6,    29,    28,
      31,    32,     0,     0,     0,    38,    30,     0,     0,     8,
       0,     0,     0,     0,     0,    13,     0,     6,     0,     0,
       0,    30,    36,    37,    22,     0,     0,     0,     0,     0,
      19,    20,     0,     0,     4,     5,    11,    12,     0,     0,
       0,     0,     0,     0,     0,    10,    21,     0,     0,     9,
       0,     0,     0,    23,    33,    34,    35,    24,    25,    26,
      27,     0,     8,     0,     0,     0,     0,     0,     0,     0,
       0,    14,     9,     0,     0,    39,     0,    16,     0,     0,
      15,     0,     7,    17,     0,     9,    18
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int8 yypgoto[] =
{
     -79,   -79,    -3,   -79,    71,   -79,    30,   -78,   -79,   -36,
     -79,   -11
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int8 yydefgoto[] =
{
       0,     2,    25,     7,    26,    94,    38,    73,    27,    28,
      29,    30
};

/* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule whose
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int8 yytable[] =
{
       6,    32,    33,    61,    87,    51,    52,    53,    54,    53,
      54,     1,     3,    43,     4,     5,    34,    96,    36,    35,
      37,    40,    39,    48,    56,    57,    58,    41,    48,    49,
      50,    62,    48,    49,    50,    59,    42,    64,    65,    66,
      67,    68,    69,    70,    51,    52,    53,    54,    89,    51,
      52,    53,    54,    51,    52,    53,    54,    44,    60,    75,
      46,    55,    47,    79,    80,    74,    76,    78,     8,     9,
      10,    11,    88,    81,    82,    12,    13,    14,    15,    86,
      93,    16,    17,    90,    83,    18,    19,    20,    21,    22,
      23,    95,    92,     8,     9,    10,    11,    24,    45,     5,
      12,    13,    77,    15,     0,     0,    31,    48,    49,    50,
       0,    48,    49,    50,     0,    23,     0,    48,    49,    50,
       0,     0,    24,    48,    49,    50,     0,     0,    51,    52,
      53,    54,    51,    52,    53,    54,    84,    63,    51,    52,
      53,    54,     0,    71,    51,    52,    53,    54,     0,    72,
      48,    49,    50,     0,     0,     0,    48,    49,    50,     0,
       0,     0,    48,    49,    50,     0,    48,     0,    50,     0,
       0,    51,    52,    53,    54,     0,    85,    51,    52,    53,
      54,     0,    91,    51,    52,    53,    54,    51,    52,    53,
      54
};

static const yytype_int8 yycheck[] =
{
       3,    12,    13,    39,    82,    28,    29,    30,    31,    30,
      31,    15,    14,    24,     0,    34,    16,    95,    32,    37,
      32,    36,    32,     7,    35,    36,    37,    36,     7,     8,
       9,    42,     7,     8,     9,    38,    32,    48,    49,    50,
      51,    52,    53,    54,    28,    29,    30,    31,    84,    28,
      29,    30,    31,    28,    29,    30,    31,    35,    16,    38,
      36,    36,    36,    74,    75,    36,    18,    20,     3,     4,
       5,     6,    83,    76,    77,    10,    11,    12,    13,    19,
      36,    16,    17,    86,    32,    20,    21,    22,    23,    24,
      25,    94,    33,     3,     4,     5,     6,    32,    27,    34,
      10,    11,    72,    13,    -1,    -1,    16,     7,     8,     9,
      -1,     7,     8,     9,    -1,    25,    -1,     7,     8,     9,
      -1,    -1,    32,     7,     8,     9,    -1,    -1,    28,    29,
      30,    31,    28,    29,    30,    31,    36,    33,    28,    29,
      30,    31,    -1,    33,    28,    29,    30,    31,    -1,    33,
       7,     8,     9,    -1,    -1,    -1,     7,     8,     9,    -1,
      -1,    -1,     7,     8,     9,    -1,     7,    -1,     9,    -1,
      -1,    28,    29,    30,    31,    -1,    33,    28,    29,    30,
      31,    -1,    33,    28,    29,    30,    31,    28,    29,    30,
      31
};

/* YYSTOS[STATE-NUM] -- The symbol kind of the accessing symbol of
   state STATE-NUM.  */
static const yytype_int8 yystos[] =
{
       0,    15,    40,    14,     0,    34,    41,    42,     3,     4,
       5,     6,    10,    11,    12,    13,    16,    17,    20,    21,
      22,    23,    24,    25,    32,    41,    43,    47,    48,    49,
      50,    16,    50,    50,    16,    37,    32,    32,    45,    32,
      36,    36,    32,    50,    35,    43,    36,    36,     7,     8,
       9,    28,    29,    30,    31,    36,    50,    50,    50,    41,
      16,    48,    50,    33,    50,    50,    50,    50,    50,    50,
      50,    33,    33,    46,    36,    38,    18,    45,    20,    50,
      50,    41,    41,    32,    36,    33,    19,    46,    50,    48,
      41,    33,    33,    36,    44,    41,    46
};

/* YYR1[RULE-NUM] -- Symbol kind of the left-hand side of rule RULE-NUM.  */
static const yytype_int8 yyr1[] =
{
       0,    39,    40,    42,    41,    43,    43,    44,    45,    46,
      47,    47,    47,    47,    47,    47,    47,    47,    47,    47,
      47,    48,    49,    50,    50,    50,    50,    50,    50,    50,
      50,    50,    50,    50,    50,    50,    50,    50,    50,    50
};

/* YYR2[RULE-NUM] -- Number of symbols on the right-hand side of rule RULE-NUM.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     3,     0,     4,     2,     0,     0,     0,     0,
       2,     2,     2,     1,     6,     8,     7,     9,    11,     2,
       2,     3,     2,     3,     3,     3,     3,     3,     1,     1,
       1,     1,     1,     3,     3,     3,     2,     2,     1,     6
};


enum { YYENOMEM = -2 };

#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab
#define YYNOMEM         goto yyexhaustedlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
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

/* Backward compatibility with an undocumented macro.
   Use YYerror or YYUNDEF. */
#define YYERRCODE YYUNDEF


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




# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Kind, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo,
                       yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep)
{
  FILE *yyoutput = yyo;
  YY_USE (yyoutput);
  if (!yyvaluep)
    return;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YY_USE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo,
                 yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyo, "%s %s (",
             yykind < YYNTOKENS ? "token" : "nterm", yysymbol_name (yykind));

  yy_symbol_value_print (yyo, yykind, yyvaluep);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yy_state_t *yybottom, yy_state_t *yytop)
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
yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp,
                 int yyrule)
{
  int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %d):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       YY_ACCESSING_SYMBOL (+yyssp[yyi + 1 - yynrhs]),
                       &yyvsp[(yyi + 1) - (yynrhs)]);
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
# define YYDPRINTF(Args) ((void) 0)
# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)
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






/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg,
            yysymbol_kind_t yykind, YYSTYPE *yyvaluep)
{
  YY_USE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yykind, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YY_USE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/* Lookahead token kind.  */
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
    yy_state_fast_t yystate = 0;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus = 0;

    /* Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* Their size.  */
    YYPTRDIFF_T yystacksize = YYINITDEPTH;

    /* The state stack: array, bottom, top.  */
    yy_state_t yyssa[YYINITDEPTH];
    yy_state_t *yyss = yyssa;
    yy_state_t *yyssp = yyss;

    /* The semantic value stack: array, bottom, top.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs = yyvsa;
    YYSTYPE *yyvsp = yyvs;

  int yyn;
  /* The return value of yyparse.  */
  int yyresult;
  /* Lookahead symbol kind.  */
  yysymbol_kind_t yytoken = YYSYMBOL_YYEMPTY;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;



#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yychar = YYEMPTY; /* Cause a token to be read.  */

  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yysetstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
  YY_ASSERT (0 <= yystate && yystate < YYNSTATES);
  YY_IGNORE_USELESS_CAST_BEGIN
  *yyssp = YY_CAST (yy_state_t, yystate);
  YY_IGNORE_USELESS_CAST_END
  YY_STACK_PRINT (yyss, yyssp);

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    YYNOMEM;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYPTRDIFF_T yysize = yyssp - yyss + 1;

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        yy_state_t *yyss1 = yyss;
        YYSTYPE *yyvs1 = yyvs;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * YYSIZEOF (*yyssp),
                    &yyvs1, yysize * YYSIZEOF (*yyvsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        YYNOMEM;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yy_state_t *yyss1 = yyss;
        union yyalloc *yyptr =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (! yyptr)
          YYNOMEM;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YY_IGNORE_USELESS_CAST_BEGIN
      YYDPRINTF ((stderr, "Stack size increased to %ld\n",
                  YY_CAST (long, yystacksize)));
      YY_IGNORE_USELESS_CAST_END

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */


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

  /* YYCHAR is either empty, or end-of-input, or a valid lookahead.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token\n"));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = YYEOF;
      yytoken = YYSYMBOL_YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else if (yychar == YYerror)
    {
      /* The scanner already issued an error message, process directly
         to error recovery.  But do not keep the error token as
         lookahead, it is too special and may lead us to an endless
         loop in error recovery. */
      yychar = YYUNDEF;
      yytoken = YYSYMBOL_YYerror;
      goto yyerrlab1;
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
  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  /* Discard the shifted token.  */
  yychar = YYEMPTY;
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
| yyreduce -- do a reduction.  |
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
  case 2: /* S: TK_DEF TK_MAIN BLOCO  */
#line 82 "sintatico.y"
                        {
				string codigo = "/*Compilador GHP*/\n"
								"#include <iostream>\n"
								"#include<string.h>\n"
								"#include<stdio.h>\n\n"
								"int main(void) {\n";

				for (int i = 0; i < declaracoes.size(); i++) {
					codigo += declaracoes[i];
				}	

				codigo += "\n" + yyvsp[0].traducao;
								
				codigo += 	"\n\treturn 0;"
							"\n}";

				cout << codigo << endl;
			}
#line 1354 "y.tab.c"
    break;

  case 3: /* $@1: %empty  */
#line 100 "sintatico.y"
                     { adicionarEscopo();}
#line 1360 "y.tab.c"
    break;

  case 4: /* BLOCO: '{' $@1 COMANDOS '}'  */
#line 101 "sintatico.y"
                        {
				yyval.traducao = yyvsp[-1].traducao;
				retirarEscopo();
			}
#line 1369 "y.tab.c"
    break;

  case 5: /* COMANDOS: COMANDO COMANDOS  */
#line 107 "sintatico.y"
                        {
				yyval.traducao = yyvsp[-1].traducao + yyvsp[0].traducao;
			}
#line 1377 "y.tab.c"
    break;

  case 6: /* COMANDOS: %empty  */
#line 111 "sintatico.y"
                        {
				yyval.traducao = "";
			}
#line 1385 "y.tab.c"
    break;

  case 7: /* CRIAR_ROTULOS_FOR: %empty  */
#line 117 "sintatico.y"
                        {
        				rotulo_condicao.push_back(genlabel());
                		rotulo_incremento.push_back(genlabel());
                		rotulo_fim.push_back(genlabel());
						rotulo_inicio.push_back(genlabel());

                		break_label_stack.push_back(rotulo_fim.back());
                		continue_label_stack.push_back(rotulo_incremento.back());
                    }
#line 1399 "y.tab.c"
    break;

  case 8: /* CRIAR_ROTULOS: %empty  */
#line 128 "sintatico.y"
                                        {
						rotulo_inicio.push_back(genlabel());
						rotulo_condicao.push_back(genlabel());
						rotulo_fim.push_back(genlabel());
						rotulo_incremento.push_back(genlabel());

						break_label_stack.push_back(rotulo_fim.back());
                		continue_label_stack.push_back(rotulo_condicao.back());

					}
#line 1414 "y.tab.c"
    break;

  case 9: /* RETIRAR_ROTULOS: %empty  */
#line 140 "sintatico.y"
                    {
                    
                    if (!continue_label_stack.empty()) {
                        continue_label_stack.pop_back();
                    } else {
                        yyerror("Pilha continue vazia no cleanup");
                    }
                    
					if (!break_label_stack.empty()) {
                        break_label_stack.pop_back();
                    } else {
                        yyerror("Pilha break vazia no cleanup");
                    }

                    }
#line 1434 "y.tab.c"
    break;

  case 10: /* COMANDO: E ';'  */
#line 157 "sintatico.y"
                        {
				yyval = yyvsp[-1];
			}
#line 1442 "y.tab.c"
    break;

  case 14: /* COMANDO: TK_IF '(' E ')' TK_THEN BLOCO  */
#line 164 "sintatico.y"
                        {
                if(yyvsp[-3].tipo != "bool") {
                    yyerror("Erro Semantico: A expressao na condicional 'if' deve ser do tipo booleano.");
                }

                string temp_negated_expr = gentempcode();
                declarar("bool", temp_negated_expr, -1);

                string fim_label = genlabel();
                yyval.traducao = yyvsp[-3].traducao; 
                yyval.traducao += "\t" + temp_negated_expr + " = !" + yyvsp[-3].label + ";\n";
                yyval.traducao += string("\t") + "if (" + temp_negated_expr + ") goto " + fim_label + ";\n";
                yyval.traducao += yyvsp[0].traducao;
                yyval.traducao += fim_label + ":\n";
                yyval.tipo = "";
                yyval.label = "";

			}
#line 1465 "y.tab.c"
    break;

  case 15: /* COMANDO: TK_IF '(' E ')' TK_THEN BLOCO TK_ELSE BLOCO  */
#line 183 "sintatico.y"
                        {
                if(yyvsp[-5].tipo != "bool") {
                    yyerror("Erro Semantico: A expressao na condicional 'if' deve ser do tipo booleano.");
                }

                string else_label = genlabel();
                string end_if_label = genlabel();

                string temp_negated_expr = gentempcode();
                declarar("bool", temp_negated_expr, -1);

                yyval.traducao = yyvsp[-5].traducao;
                yyval.traducao += "\t" + temp_negated_expr + " = !" + yyvsp[-5].label + ";\n";
                yyval.traducao += string("\t") + "if (" + temp_negated_expr + ") goto " + else_label + ";\n";
                yyval.traducao += yyvsp[-2].traducao;
                yyval.traducao += string("\tgoto ") + end_if_label + ";\n";
                yyval.traducao += else_label + ":\n";
                yyval.traducao += yyvsp[0].traducao;
                yyval.traducao += end_if_label + ":\n";

                yyval.tipo = ""; 
                yyval.label = "";
			}
#line 1493 "y.tab.c"
    break;

  case 16: /* COMANDO: TK_WHILE '(' E ')' CRIAR_ROTULOS BLOCO RETIRAR_ROTULOS  */
#line 207 "sintatico.y"
                        {
                if(yyvsp[-4].tipo != "bool") {
                    yyerror("Erro Semantico: A expressao na condicional 'while' deve ser do tipo booleano.");
                }

                string temp_negated_expr = gentempcode();
                declarar("bool", temp_negated_expr, -1);

                yyval.traducao = rotulo_condicao.back() + ":\n";
                yyval.traducao += yyvsp[-4].traducao;
                yyval.traducao += "\t" + temp_negated_expr + " = !" + yyvsp[-4].label + ";\n";
                yyval.traducao += string("\t") + "if (" + temp_negated_expr + ") goto " + rotulo_fim.back() + ";\n";
                yyval.traducao += yyvsp[-1].traducao;
                yyval.traducao += string("\tgoto ") + rotulo_condicao.back() + ";\n";
                yyval.traducao += rotulo_fim.back() + ":\n";

				retirar_rotulos();

                yyval.tipo = ""; 
                yyval.label = "";
			}
#line 1519 "y.tab.c"
    break;

  case 17: /* COMANDO: TK_DO CRIAR_ROTULOS BLOCO RETIRAR_ROTULOS TK_WHILE '(' E ')' ';'  */
#line 229 "sintatico.y"
                        {
                if(yyvsp[-2].tipo != "bool") {
                    yyerror("Erro Semantico: A expressao na condicional 'do-while' deve ser do tipo booleano.");
                }

                yyval.traducao = rotulo_inicio.back() + ":\n";
                yyval.traducao += yyvsp[-6].traducao;
				yyval.traducao += rotulo_condicao.back() + ":\n";
                yyval.traducao += yyvsp[-2].traducao;
                yyval.traducao += string("\t") + "if (" + yyvsp[-2].label + ") goto " + rotulo_inicio.back() + ";\n";
				yyval.traducao += rotulo_fim.back() + ":\n";

				retirar_rotulos();

                yyval.tipo = ""; 
                yyval.label = "";
			}
#line 1541 "y.tab.c"
    break;

  case 18: /* COMANDO: TK_FOR '(' ATRI ';' E ';' ATRI ')' CRIAR_ROTULOS_FOR BLOCO RETIRAR_ROTULOS  */
#line 247 "sintatico.y"
                        {
                if(yyvsp[-6].tipo != "bool") {
                    yyerror("Erro Semantico: A expressao de condicao no loop 'for' deve ser do tipo booleano.");
                }

                string temp_negated_cond = gentempcode();
                declarar("bool", temp_negated_cond, -1);

                yyval.traducao = yyvsp[-8].traducao;
                yyval.traducao += rotulo_condicao.back() + ":\n";
                yyval.traducao += yyvsp[-6].traducao;
                yyval.traducao += "\t" + temp_negated_cond + " = !" + yyvsp[-6].label + ";\n";
                yyval.traducao += string("\t") + "if (" + temp_negated_cond + ") goto " + rotulo_fim.back() + ";\n";
                yyval.traducao += yyvsp[-1].traducao;
				yyval.traducao += rotulo_incremento.back() + ":\n";
                yyval.traducao += yyvsp[-4].traducao;
                yyval.traducao += string("\tgoto ") + rotulo_condicao.back() + ";\n";
                yyval.traducao += rotulo_fim.back() + ":\n";

				retirar_rotulos();

                yyval.tipo = ""; 
                yyval.label = "";
			}
#line 1570 "y.tab.c"
    break;

  case 19: /* COMANDO: TK_BREAK ';'  */
#line 272 "sintatico.y"
                        {
				if (break_label_stack.empty()) {
                    yyerror("Erro Semantico: Comando 'break' utilizado fora de um loop.");
                } else {
                    yyval.traducao = string("\tgoto ") + break_label_stack.back() + ";\n";
                }
                
				yyval.tipo = ""; 
				yyval.label = "";
			}
#line 1585 "y.tab.c"
    break;

  case 20: /* COMANDO: TK_CONTINUE ';'  */
#line 283 "sintatico.y"
                        {
				if (continue_label_stack.empty()) {
                    yyerror("Erro Semantico: Comando 'continue' utilizado fora de um loop.");
                } else {
                    yyval.traducao = string("\tgoto ") + continue_label_stack.back() + ";\n";
                }

                yyval.tipo = ""; 
				yyval.label = "";
			}
#line 1600 "y.tab.c"
    break;

  case 21: /* ATRI: TK_ID '=' E  */
#line 295 "sintatico.y"
                        {
				traducaoTemp = "";

				if(!verificar(yyvsp[-2].label)) {
					yyerror("Variavel nao foi declarada.");
				}

				Simbolo variavel;
				variavel = buscar(yyvsp[-2].label);

				if(variavel.tipado == false) {
					if(yyvsp[0].tipo == "string" ){
						atualizar(yyvsp[0].tipo, yyvsp[-2].label, yyvsp[0].tamanho, yyvsp[0].vetor_string);
						declarar(yyvsp[0].tipo, variavel.label, stoi(yyvsp[0].tamanho));
						variavel.tipo = yyvsp[0].tipo;
					}else{
						atualizar(yyvsp[0].tipo, yyvsp[-2].label, "", "");
						declarar(yyvsp[0].tipo, variavel.label, -1);
						variavel.tipo = yyvsp[0].tipo;
					}
				}

				yyvsp[-2].tipo = variavel.tipo;
				yyvsp[-2].label = variavel.label;

				if(tipofinal[yyvsp[-2].tipo][yyvsp[0].tipo] == "erro") yyerror("Operação com tipos inválidos");

				traducaoTemp = cast_implicito(&yyval, &yyvsp[-2], &yyvsp[0], "atribuicao");

				yyval.traducao = yyvsp[-2].traducao + yyvsp[0].traducao + traducaoTemp + "\t" + yyvsp[-2].label + " = " + yyvsp[0].label + ";\n";
			}
#line 1636 "y.tab.c"
    break;

  case 22: /* DEC: TK_VAR TK_ID  */
#line 329 "sintatico.y"
                        {
				if(verificar(yyvsp[0].label)) {
					yyerror("Variavel já declarada.\n");
				}

				adicionarSimbolo(yyvsp[0].label);

				yyval.label = "";
				yyval.traducao = "";
				yyval.tipo = "";
				yyval.tamanho = "";
				yyval.vetor_string = "";

			}
#line 1655 "y.tab.c"
    break;

  case 23: /* E: '(' E ')'  */
#line 346 "sintatico.y"
                        {
				yyval = yyvsp[-1];
			}
#line 1663 "y.tab.c"
    break;

  case 24: /* E: E '+' E  */
#line 350 "sintatico.y"
                        {	
				traducaoTemp = "";

				if(tipofinal[yyvsp[-2].tipo][yyvsp[0].tipo] == "string")
				{	
					yyval.label = gentempcode();
					yyval.tipo = "string";
					int tam1 = stoi(yyvsp[-2].tamanho);
					int tam2 = stoi(yyvsp[0].tamanho);
					int tamcat = (tam1 - 1) + (tam2 - 1) + 1;
					yyval.tamanho = to_string(tamcat);

					for(int i = 0; i < tamcat; i++){
						if(i == tamcat - 1){
							traducaoTemp += "\t" + yyval.label + "[" + to_string(i) + "] = " + "'\\0'" + ";\n";
						} else if(i < (stoi(yyvsp[-2].tamanho)- 1)){
							traducaoTemp += "\t" + yyval.label + "[" + to_string(i) + "] = '" + yyvsp[-2].vetor_string[i] + "';\n";
						} else{
							traducaoTemp += "\t" + yyval.label + "[" + to_string(i) + "] = '" + yyvsp[0].vetor_string[i - (tam1 - 1)] + "';\n";
						}
					}
					
					yyval.traducao = "\t" + yyval.label + " = strcat(" + yyvsp[-2].vetor_string + ", " + yyvsp[0].vetor_string + ");\n" + traducaoTemp;
					declarar(yyval.tipo, yyval.label, tamcat);
					
				}
				else
				{
					traducaoTemp = cast_implicito(&yyval, &yyvsp[-2], &yyvsp[0], "operacao");

					yyval.label = gentempcode();
					
					yyval.tipo = tipofinal[yyvsp[-2].tipo][yyvsp[0].tipo];
					if(yyval.tipo == "erro") yyerror("Operação com tipos inválidos");

					yyval.traducao = yyvsp[-2].traducao + yyvsp[0].traducao + traducaoTemp +
						"\t" + yyval.label + " = " + yyvsp[-2].label + " + " + yyvsp[0].label + ";\n";

					declarar(yyval.tipo, yyval.label, -1);
				}
			}
#line 1709 "y.tab.c"
    break;

  case 25: /* E: E '-' E  */
#line 392 "sintatico.y"
                        {
				traducaoTemp = "";
				
				traducaoTemp = cast_implicito(&yyval, &yyvsp[-2], &yyvsp[0], "operacao");
				
    			yyval.label = gentempcode();
    			
				yyval.tipo = tipofinal[yyvsp[-2].tipo][yyvsp[0].tipo];
				if(yyval.tipo == "erro" || yyval.tipo == "string") yyerror("Operação com tipos inválidos");

    			yyval.traducao = yyvsp[-2].traducao + yyvsp[0].traducao + traducaoTemp +
                  	"\t" + yyval.label + " = " + yyvsp[-2].label + " - " + yyvsp[0].label + ";\n";

    			declarar(yyval.tipo, yyval.label, -1);
			}
#line 1729 "y.tab.c"
    break;

  case 26: /* E: E '*' E  */
#line 408 "sintatico.y"
                        {
				traducaoTemp = "";

				traducaoTemp = cast_implicito(&yyval, &yyvsp[-2], &yyvsp[0], "operacao");

    			yyval.label = gentempcode();
    			
				yyval.tipo = tipofinal[yyvsp[-2].tipo][yyvsp[0].tipo];
				if(yyval.tipo == "erro" || yyval.tipo == "string") yyerror("Operação com tipos inválidos");

    			yyval.traducao = yyvsp[-2].traducao + yyvsp[0].traducao + traducaoTemp +
                  	"\t" + yyval.label + " = " + yyvsp[-2].label + " * " + yyvsp[0].label + ";\n";

    			declarar(yyval.tipo, yyval.label, -1);			
			}
#line 1749 "y.tab.c"
    break;

  case 27: /* E: E '/' E  */
#line 424 "sintatico.y"
                        {
				traducaoTemp = "";

				traducaoTemp = cast_implicito(&yyval, &yyvsp[-2], &yyvsp[0], "operacao");

				yyval.label = gentempcode();
    			
				yyval.tipo = tipofinal[yyvsp[-2].tipo][yyvsp[0].tipo];
				if(yyval.tipo == "erro" || yyval.tipo == "string") yyerror("Operação com tipos inválidos");

    			yyval.traducao = yyvsp[-2].traducao + yyvsp[0].traducao + traducaoTemp + "\t" + yyval.label + " = " + yyvsp[-2].label + " / " + yyvsp[0].label + ";\n";

    			declarar(yyval.tipo, yyval.label, -1);
			}
#line 1768 "y.tab.c"
    break;

  case 28: /* E: TK_FLOAT  */
#line 439 "sintatico.y"
                        {
				yyval.label = gentempcode();
				yyval.traducao = "\t" + yyval.label + " = " + yyvsp[0].label + ";\n";
				yyval.tipo = "float";
				declarar(yyval.tipo, yyval.label, -1);
			}
#line 1779 "y.tab.c"
    break;

  case 29: /* E: TK_NUM  */
#line 446 "sintatico.y"
                        {
				yyval.label = gentempcode();
				yyval.traducao = "\t" + yyval.label + " = " + yyvsp[0].label + ";\n";
				yyval.tipo = "int";
				declarar(yyval.tipo, yyval.label, -1);
			}
#line 1790 "y.tab.c"
    break;

  case 30: /* E: TK_ID  */
#line 453 "sintatico.y"
                        {
				Simbolo variavel;

				if(!verificar(yyvsp[0].label)) {
					yyerror("Variavel nao foi declarada.");
				}
				
				variavel = buscar(yyvsp[0].label);
				if(variavel.tipo == "") yyerror("Variavel ainda nao possui tipo");
				
				yyval.label = variavel.label;
				yyval.traducao = "";
				yyval.tipo = variavel.tipo;
				yyval.tamanho = variavel.tamanho;
				yyval.vetor_string = variavel.vetor_string;				
			}
#line 1811 "y.tab.c"
    break;

  case 31: /* E: TK_CHAR  */
#line 470 "sintatico.y"
                        {

				yyval.label = gentempcode();
				yyval.traducao = "\t" + yyval.label + " = " + yyvsp[0].label + ";\n";
				yyval.tipo = "char";
				declarar(yyval.tipo, yyval.label, -1);
			}
#line 1823 "y.tab.c"
    break;

  case 32: /* E: TK_BOOL  */
#line 478 "sintatico.y"
                        {
				if(yyvsp[0].label == "true") {
					yyvsp[0].label = "1";
				} else {
					yyvsp[0].label = "0";
				}

				yyval.label = yyvsp[0].label;
				yyval.traducao = "";
				yyval.tipo = "bool";
			}
#line 1839 "y.tab.c"
    break;

  case 33: /* E: E TK_RELACIONAL E  */
#line 490 "sintatico.y"
                {	
				traducaoTemp = "";

				traducaoTemp = cast_implicito(&yyval, &yyvsp[-2], &yyvsp[0], "operacao");

            	yyval.label = gentempcode();
       			yyval.traducao = yyvsp[-2].traducao + yyvsp[0].traducao + traducaoTemp + "\t" + yyval.label + " = " + yyvsp[-2].label + " " + yyvsp[-1].label + " " + yyvsp[0].label + ";\n";
        		yyval.tipo = "bool";
        		declarar(yyval.tipo, yyval.label, -1);
        	}
#line 1854 "y.tab.c"
    break;

  case 34: /* E: E TK_ORLOGIC E  */
#line 501 "sintatico.y"
                {
   				yyval.label = gentempcode();
        		yyval.traducao = yyvsp[-2].traducao + yyvsp[0].traducao + "\t" + yyval.label + " = " + yyvsp[-2].label + " " + yyvsp[-1].label + " " + yyvsp[0].label + ";\n";
        		yyval.tipo = "bool";
    			declarar(yyval.tipo, yyval.label, -1);
        	}
#line 1865 "y.tab.c"
    break;

  case 35: /* E: E TK_ANDLOGIC E  */
#line 508 "sintatico.y"
                {
        		yyval.label = gentempcode();
        		yyval.traducao = yyvsp[-2].traducao + yyvsp[0].traducao + "\t" + yyval.label + " = " + yyvsp[-2].label + " " + yyvsp[-1].label + " " + yyvsp[0].label + ";\n";
        		yyval.tipo = "bool";
        		declarar(yyval.tipo, yyval.label, -1);
            }
#line 1876 "y.tab.c"
    break;

  case 36: /* E: TK_NOLOGIC E  */
#line 515 "sintatico.y"
            {
		    	yyval.label = gentempcode();
        		yyval.traducao = yyvsp[0].traducao + "\t" + yyval.label + " = !" + yyvsp[0].label +  ";\n";
        		yyval.tipo = "bool";
        		declarar(yyval.tipo, yyval.label, -1);
        	}
#line 1887 "y.tab.c"
    break;

  case 37: /* E: TK_CAST E  */
#line 522 "sintatico.y"
                {
				string temp1 = gentempcode();
    			string temp2 = gentempcode();

    			declarar(yyvsp[0].tipo, temp1, -1);
    			declarar(yyvsp[-1].tipo, temp2, -1);

    			yyval.traducao = yyvsp[0].traducao +	"\t" + temp1 + " = " + yyvsp[0].label + ";\n" +"\t" + temp2 + " = " + "(" + yyvsp[-1].tipo + ")" + temp1 + ";\n";

    			yyval.label = temp2;
    			yyval.tipo = yyvsp[-1].tipo;
	    	}
#line 1904 "y.tab.c"
    break;

  case 38: /* E: TK_CADEIA_CHAR  */
#line 535 "sintatico.y"
                        {
				int tamString = tamanho_string(yyvsp[0].label);
				traducaoTemp = retirar_aspas(yyvsp[0].label, tamString);

				yyval.label = gentempcode();
				yyval.tipo = "string";
				yyval.tamanho = to_string(tamString);
				yyval.vetor_string = traducaoTemp;

				for(int i = 0; i < tamString; i++){
					if(i != tamString - 1) 
					{
						yyval.traducao += "\t" + yyval.label + "[" + to_string(i) + "] = '" + traducaoTemp[i] + "';\n";
					} else
					{
						yyval.traducao += "\t" + yyval.label + "[" + to_string(i) + "] = '\\0';\n";
					}
				}

				declarar(yyval.tipo, yyval.label, tamString);
			}
#line 1930 "y.tab.c"
    break;

  case 39: /* E: TK_CPY '(' E ',' E ')'  */
#line 557 "sintatico.y"
                        {
				if(tipofinal[yyvsp[-3].tipo][yyvsp[-1].tipo] != "string") yyerror("Operação com tipos inválidos");
				if(stoi(yyvsp[-3].tamanho) < stoi(yyvsp[-1].tamanho)) yyerror("Operação de copy inválida, espaço no BUFFER insuficiente");
				
				traducaoTemp = "";

				yyval.label = gentempcode();
				yyval.tipo = "string";
				int tam1 = stoi(yyvsp[-3].tamanho);
				yyval.tamanho = yyvsp[-3].tamanho;


				for(int i = 0; i < tam1; i++){
					if(i == tam1 - 1){
						traducaoTemp += "\t" + yyval.label + "[" + to_string(i) + "] = " + "'\\0'" + ";\n";
					} else{
						traducaoTemp += "\t" + yyval.label + "[" + to_string(i) + "] = " + yyvsp[-1].vetor_string[i] + ";\n";
					}
				}
				yyval.traducao = "\t" + yyval.label + " = strcpy(" + yyvsp[-3].vetor_string + ", " + yyvsp[-1].vetor_string + ");\n" + traducaoTemp;
				declarar(yyval.tipo, yyval.label, tam1);
			}
#line 1957 "y.tab.c"
    break;


#line 1961 "y.tab.c"

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
  YY_SYMBOL_PRINT ("-> $$ =", YY_CAST (yysymbol_kind_t, yyr1[yyn]), &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYSYMBOL_YYEMPTY : YYTRANSLATE (yychar);
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
      yyerror (YY_("syntax error"));
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
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;
  ++yynerrs;

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

  /* Pop stack until we find a state that shifts the error token.  */
  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYSYMBOL_YYerror;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYSYMBOL_YYerror)
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
                  YY_ACCESSING_SYMBOL (yystate), yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", YY_ACCESSING_SYMBOL (yyn), yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturnlab;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturnlab;


/*-----------------------------------------------------------.
| yyexhaustedlab -- YYNOMEM (memory exhaustion) comes here.  |
`-----------------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  goto yyreturnlab;


/*----------------------------------------------------------.
| yyreturnlab -- parsing is finished, clean up and return.  |
`----------------------------------------------------------*/
yyreturnlab:
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
                  YY_ACCESSING_SYMBOL (+*yyssp), yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif

  return yyresult;
}

#line 580 "sintatico.y"


#include "lex.yy.c"

int yyparse();

string gentempcode()
{
	var_temp_qnt++;
	return "t" + to_string(var_temp_qnt);
}

int main(int argc, char* argv[])
{
	adicionarEscopo();

	traducaoTemp = "";
	label_qnt = 0;
	var_temp_qnt = 0;
	tipofinal["int"]["int"] = "int";
	tipofinal["float"]["int"] = "float";
	tipofinal["float"]["float"] = "float";
	tipofinal["string"]["string"] = "string";
	tipofinal["int"]["float"] = "float";
	tipofinal["char"]["int"] = "char";
	tipofinal["int"]["char"] = "char";
	tipofinal["char"]["char"] = "char";
	tipofinal["bool"]["bool"] = "bool";
	tipofinal["string"]["char"] = "string";
	tipofinal["char"]["string"] = "string";
	tipofinal["bool"]["int"] = "erro";
	tipofinal["int"]["bool"] = "erro";
	tipofinal["float"]["char"] = "erro";
	tipofinal["char"]["float"] = "erro";
	tipofinal["bool"]["char"] = "erro";
	tipofinal["char"]["bool"] = "erro";
	tipofinal["bool"]["float"] = "erro";
	tipofinal["float"]["bool"] = "erro";
	tipofinal["string"]["bool"] = "erro";
	tipofinal["bool"]["string"] = "erro";
	tipofinal["string"]["int"] = "erro";
	tipofinal["int"]["string"] = "erro";
	tipofinal["string"]["float"] = "erro";
	tipofinal["float"]["string"] = "erro";

	yyparse();

	return 0;
}

void yyerror(string MSG)
{
	cout << MSG << endl;
	exit (0);
}

bool verificar(string name)
{
	for(int i = tabela.size() - 1; i >= 0; i--) {
		auto it = tabela[i].find(name);
		if(!(it == tabela[i].end())) return true;
	}

	return false;
}

Simbolo buscar(string name)
{
	for(int i = tabela.size() - 1; i >= 0; i--) {
		auto it = tabela[i].find(name);
		if(!(it == tabela[i].end())) return it->second;
	}
	yyerror("Não foi encontrado o símbolo durante a busca!");
}

void declarar(string tipo, string label, int tam_string) 
{
	if (tipo == "bool") tipo = "int";
	if (tipo == "string") tipo = "char";
	
	if(tam_string != -1) // Quando o campo de tamanho for -1, quer dizer que não estamos declarando uma string
	{
		declaracoes.push_back("\t" + tipo + " " + label + "[" + to_string(tam_string) + "]" + ";\n");
	}
	else
	{
	declaracoes.push_back("\t" + tipo + " " + label + ";\n");
	}
}

string cast_implicito(atributos* no1, atributos* no2, atributos* no3, string tipo)
{

		traducaoTemp = "";

		if (!((no2->tipo == "float" && no3->tipo == "int") || (no2->tipo == "int" && no3->tipo == "float")) ) {
			return traducaoTemp;
		}

		if(tipo == "operacao") {
			
        	if (no2->tipo == "int" && no3->tipo == "float") {
        		no1->label = gentempcode();
        		declarar("float", no1->label, -1);
        		traducaoTemp += "\t" + no1->label + " = (float)" + no2->label + ";\n";
        		no2->label = no1->label;
				no2->tipo = "float";
       		} else if (no2->tipo == "float" && no3->tipo == "int") {
				no1->label = gentempcode();
        		declarar("float", no1->label, -1);
        		traducaoTemp += "\t" + no1->label + " = (float)" + no3->label + ";\n";
        		no3->label = no1->label;
        		no3->tipo = "float";
        	}
    	}
		 

		if(tipo == "atribuicao") {
			
        	if (no2->tipo == "int" && no3->tipo == "float") {
        		no1->label = gentempcode();
        		declarar("int", no1->label, -1);
        		traducaoTemp += "\t" + no1->label + " = (int)" + no3->label + ";\n";
				no3->label = no1->label;
    		} else if (no2->tipo == "float" && no3->tipo == "int") {
				no1->label = gentempcode();
        		declarar("float", no1->label, -1);
        		traducaoTemp += "\t" + no1->label + " = (float)" + no3->label + ";\n";
				no3->label = no1->label;
        	} 
    	}

	return traducaoTemp;
}

void atualizar(string tipo, string nome, string tamanho, string cadeia_char) {

	for(int i = tabela.size() - 1; i >= 0; i--) {
		auto it = tabela[i].find(nome);
		if(!(it == tabela[i].end())) {
			it->second.tipo = tipo;
			it->second.tipado = true;
			it->second.tamanho = tamanho;
			it->second.vetor_string = cadeia_char;
			break;
		}
	}
}

void adicionarEscopo()
{
	unordered_map<string, Simbolo> escopo;
	tabela.push_back(escopo);
}

void retirarEscopo() 
{
	tabela.pop_back();
}

void adicionarSimbolo(string nome)
{
	Simbolo simbolo;
	simbolo.label = gentempcode();
	auto it = tabela.end();
	(*(--it))[nome] = simbolo;
}

string genlabel()
{
    label_qnt++;
    return "ROTULO_" + to_string(label_qnt); // Gera labels como L_FIM_1, L_FIM_2, etc.
}

void retirar_rotulos() {
	if (!rotulo_condicao.empty()) {
    	rotulo_condicao.pop_back();
    } else {
        yyerror("Tentativa de dar pop na pilha rotulo condicao vazia");
    }
                    
	if (!rotulo_fim.empty()) {
        rotulo_fim.pop_back();
    } else {
        yyerror("Tentativa de dar pop na pilha rotulo fim vazia");
    }
					
	if (!rotulo_inicio.empty()) {
        rotulo_inicio.pop_back();
    } else {
        yyerror("Tentativa de dar pop na pilha rotulo inicio vazia");
    }
                    
	if (!rotulo_incremento.empty()) {
        rotulo_incremento.pop_back();
    } else {
        yyerror("Tentativa de dar pop na pilha rotulo incremento vazia");
	}
}

int tamanho_string(string traducao){
	traducaoTemp = "";
	int tamanho = 0;
	int i = 0;

	while(traducao[i] != '\0'){
		if(traducao[i] != '"') tamanho++;
		i++;
	}
	tamanho++;

	return tamanho;
}

string retirar_aspas(string traducao, int tamanho){
	traducaoTemp = "";

	for(int j = 1; j < tamanho; j++){
		traducaoTemp += traducao[j];
	}	

	return traducaoTemp;
}
