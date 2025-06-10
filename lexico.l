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
CADEIA_CHAR \"[^\"]*\"
ID {LETRA}({LETRA}|{NUM})*
BOOL ("true"|"false")
RELACIONAIS (">"|"<"|"<="|">="|"=="|"!=")
ORLOGIC ("||")
ANDLOGIC ("&&")
NOLOGIC ("!")
CAST ("(float)"|"(int)"|"(bool)"|"(char)")
    
%%
    
"\n"		  {}
    
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

"main"		    {return TK_MAIN;}
    
"var"           {return TK_VAR;}
    
[(){}[\]:;,]    { return *yytext; }
    
[+\-*/]		    { return *yytext; }
    
"="		        { return '='; }

"strcpy"        {yylval.label = yytext; return TK_CPY;}

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
{CADEIA_CHAR}   { printf("DEBUG_LEX: TK_CADEIA_CHAR -> '%s'\n", yytext); yylval.label = yytext; return TK_CADEIA_CHAR;}
.			    { *yytext; }
    
%%
