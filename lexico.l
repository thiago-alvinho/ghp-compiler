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
ID {LETRA}({LETRA}|{NUM})*
BOOL ("true"|"false")
RELACIONAIS (">"|"<"|"<="|">="|"=="|"!=")

%%

"\n"		{}

{DELIM} 	{}

"main"		{return TK_MAIN;}

"int"		{return TK_TIPO_INT;}

"float"     {return TK_TIPO_FLOAT;}

"char"      {return TK_TIPO_CHAR;}

"bool"      {return TK_TIPO_BOOL;}

"var"       {}

[(){}[\];,]	{ return *yytext; }

[+\-*/]		{ return *yytext; }

"="		    { return '='; }

{RELACIONAIS} { yylval.label = yytext; return TK_RELACIONAL;}
{BOOL}        { yylval.label = yytext; return TK_BOOL;}
{NUM}		  { yylval.label = yytext; return TK_NUM;}
{ID}		  { yylval.label = yytext; return TK_ID;}
{REAL}        { yylval.label = yytext; return TK_FLOAT;}
{CHAR}        { yylval.label = yytext; return TK_CHAR;}
.			  { *yytext; }

%%
