%{
#include <string>
    
%}
    
ESPACO [ \t]
DIGITO [0-9]
LETRA [A-Za-z_]
    
DELIM {ESPACO}+
NUM {DIGITO}+
REAL {NUM}+("."{NUM}+)?
CHAR \'({LETRA}|{NUM})\'
CADEIA_CHAR_NAO_TERMINADA \"[^\n\"]*
CADEIA_CHAR \"[^\"]*\"
ID {LETRA}({LETRA}|{NUM})*
BOOL ("true"|"false")
RELACIONAIS (">"|"<"|"<="|">="|"=="|"!=")
ORLOGIC ("||")
ANDLOGIC ("&&")
NOLOGIC ("!")
CAST ("(float)"|"(int)"|"(bool)"|"(char)")
TIPO_INPUT ("%d"|"%f"|"%s"|"%c")
TIPOS ("int"|"float"|"void"|"char")

%%
    
"\n"            { yylineno++; }
    
{DELIM} 	{}
"if"            {return TK_IF;}
"then"          {return TK_THEN;}
"else"          {return TK_ELSE;}
"while"         {return TK_WHILE;}
"do"            {return TK_DO;}
"for"           {return TK_FOR;}
"break"         {return TK_BREAK;}
"continue"      {return TK_CONTINUE;}
"switch"        {return TK_SWITCH;}
"case"          {return TK_CASE;}
"default"       {return TK_DEFAULT;}
"input"         {return TK_INPUT;}
"output"        {return TK_OUTPUT;}
"def"           {return TK_DEF;}
"return"        {return TK_RETURN;}

"main"		    {return TK_MAIN;}
    
"var"           {return TK_VAR;}

"+="            {return TK_PLUS_EQ;}
"-="            {return TK_MINUS_EQ;}
"*="            {return TK_MULT_EQ;}
"/="            {return TK_DIV_EQ;}
"++"            {return TK_INC;}
"--"            {return TK_DEC;}
    
[(){}\[\]:;,]    { return *yytext; }
    
[+\-*/]		    { return *yytext; }
    
"="		        { return '='; }

"strcpy"        {yylval.label = yytext; return TK_CPY;}
"strcat"        {yylval.label = yytext; return TK_CAT;}
{TIPOS}         {yylval.label = yytext; return TK_TYPE_SPECIFIER;}

{TIPO_INPUT}    { yylval.label = yytext; 
                if(yylval.label == "%f") yylval.tipo = "float";
                if(yylval.label == "%d") yylval.tipo = "int";
                if(yylval.label == "%c") yylval.tipo = "char";
                if(yylval.label == "%s") yylval.tipo = "string" ;
                return TK_TIPO_INPUT;}

{CAST}          { yylval.label = yytext; 
                if(yylval.label == "(float)") yylval.tipo = "float";
                if(yylval.label == "(int)") yylval.tipo = "int";
                if(yylval.label == "(char)") yylval.tipo = "char";
                if(yylval.label == "(bool)") yylval.tipo = "int" ;
                return TK_CAST;} 

{ORLOGIC}       { yylval.label = yytext; return TK_ORLOGIC;}
{ANDLOGIC}      { yylval.label = yytext; return TK_ANDLOGIC;}  
{NOLOGIC}       { yylval.label = yytext; return TK_NOLOGIC;} 
{RELACIONAIS}   { yylval.label = yytext; return TK_RELACIONAL;}
{BOOL}          { yylval.label = yytext; return TK_BOOL;}
{NUM}		    { yylval.label = yytext; return TK_NUM;}
{ID}		    { yylval.label = yytext; return TK_ID;}
{REAL}          { yylval.label = yytext; return TK_FLOAT;}
{CHAR}          { yylval.label = yytext; return TK_CHAR;}
{CADEIA_CHAR}   { yylval.label = yytext; return TK_CADEIA_CHAR;}

{CADEIA_CHAR_NAO_TERMINADA} { 
    fprintf(stderr, "[Erro na linha %d] Erro Léxico: String não terminada.\n", yylineno);
    exit(1);}

.   { fprintf(stderr, "[Erro na linha %d] Erro Léxico: Caractere inesperado '%s'.\n", yylineno, yytext);
    exit(1);}
    
%%
