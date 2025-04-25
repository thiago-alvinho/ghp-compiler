%{
#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <map>

#define YYSTYPE atributos

using namespace std;

int var_temp_qnt;

struct atributos
{
	string label;
	string traducao;
	string tipo;
};

typedef struct 
{
	string name;
	string tipo;
	string label;
} VARIAVEL;

vector<VARIAVEL> tabelaSimbolos;
vector<string> declaracoes;

map<string, map<string, string>> tipofinal;

int yylex(void);
void yyerror(string);
string gentempcode();
bool verificar(string name);
VARIAVEL buscar(string name);
void declarar(string tipo, string label);
%}

%token TK_NUM TK_FLOAT TK_CHAR TK_BOOL TK_RELACIONAL
%token TK_MAIN TK_ID TK_TIPO_INT TK_TIPO_FLOAT TK_TIPO_CHAR TK_TIPO_BOOL
%token TK_FIM TK_ERROR

%start S

%left '+' '-'
%left '*' '/'
%left '(' ')'

%%

S 			: COMANDOS
			{
				string codigo = "/*Compilador GHP*/\n"
								"#include <iostream>\n"
								"#include<string.h>\n"
								"#include<stdio.h>\n"
								"int main(void) {\n";

				for (int i = 0; i < declaracoes.size(); i++) {
					codigo += declaracoes[i];
				}	

				codigo += "\n" + $1.traducao;
								
				codigo += 	"\treturn 0;"
							"\n}";

				cout << codigo << endl;
			}
			;

COMANDOS	: COMANDO COMANDOS
			{
				$$.traducao = $1.traducao + $2.traducao;
			}
			|
			{
				$$.traducao = "";
			}
			;

COMANDO 	: E ';'
			{
				$$ = $1;
			}
			;

E 			: '(' E ')'
			{
				$$ = $2;
			}
			|TK_TIPO_INT TK_ID
			{
				if(verificar($2.label)) {
					yyerror("Variavel já declarada.\n");
				}

				VARIAVEL variavel;
				variavel.name = $2.label;
				variavel.tipo = "int";
				variavel.label = gentempcode();
				tabelaSimbolos.push_back(variavel);
				declarar(variavel.tipo, variavel.label);
				
				$$.label = "";
				$$.traducao = "";
			}
			|TK_TIPO_FLOAT TK_ID
			{
				if(verificar($2.label)) {
					yyerror("Variavel já declarada.\n");
				}

				VARIAVEL variavel;
				variavel.name = $2.label;
				variavel.tipo = "float";
				variavel.label = gentempcode();
				tabelaSimbolos.push_back(variavel);
				declarar(variavel.tipo, variavel.label);
				
				$$.label = "";
				$$.traducao = "";
			}
			|TK_TIPO_CHAR TK_ID
			{
				if(verificar($2.label)) {
					yyerror("Variavel já declarada.\n");
				}

				VARIAVEL variavel;
				variavel.name = $2.label;
				variavel.tipo = "char";
				variavel.label = gentempcode();
				tabelaSimbolos.push_back(variavel);
				declarar(variavel.tipo, variavel.label);
				
				$$.label = "";
				$$.traducao = "";
			}
			|TK_TIPO_BOOL TK_ID
			{
				if(verificar($2.label)) {
					yyerror("Variavel já declarada.\n");
				}

				VARIAVEL variavel;
				variavel.name = $2.label;
				variavel.tipo = "int";
				variavel.label = gentempcode();
				tabelaSimbolos.push_back(variavel);
				declarar(variavel.tipo, variavel.label);
				
				$$.label = "";
				$$.traducao = "";
			}
			| E '+' E
			{
				$$.label = gentempcode();
				$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label + 
					" = " + $1.label + " + " + $3.label + ";\n";
				$$.tipo = tipofinal[$1.tipo][$3.tipo];
				cout << "teste" + $1.tipo + $3.tipo << endl;
				declarar($$.tipo, $$.label);
			}
			| E '-' E
			{
				$$.label = gentempcode();
				$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label + 
					" = " + $1.label + " - " + $3.label + ";\n";
				$$.tipo = tipofinal[$1.tipo][$3.tipo];
				cout << "teste" + tipofinal[$1.tipo][$3.tipo] << endl;
				declarar($$.tipo, $$.label);
			}
			| E '*' E
			{
				$$.label = gentempcode();
				$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " * " + $3.label + ";\n";
				$$.tipo = tipofinal[$1.tipo][$3.tipo];
				declarar($$.tipo, $$.label);			
			}
			| E '/' E
			{
				$$.label = gentempcode();
				$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " / " + $3.label + ";\n";
				$$.tipo = tipofinal[$1.tipo][$3.tipo];
				declarar($$.tipo, $$.label);
			}
			| TK_ID '=' E
			{
				if(!verificar($1.label)) {
					yyerror("Variavel nao foi declarada.");
				}

				VARIAVEL variavel;
				variavel = buscar($1.label);

				$1.label = variavel.label;
				$$.traducao = $1.traducao + $3.traducao + "\t" + $1.label + " = " + $3.label + ";\n";
			}
			|TK_FLOAT
			{
				$$.label = gentempcode();
				$$.traducao = "\t" + $$.label + " = " + $1.label + ";\n";
				$$.tipo = "float";
				declarar($$.tipo, $$.label);
			}
			| TK_NUM
			{
				$$.label = gentempcode();
				$$.traducao = "\t" + $$.label + " = " + $1.label + ";\n";
				$$.tipo = "int";
				declarar($$.tipo, $$.label);
			}
			| TK_ID
			{
				VARIAVEL variavel;

				if(!verificar($1.label)) {
					yyerror("Variavel nao foi declarada.");
				}
				
				variavel = buscar($1.label);
				$$.label = variavel.label;
				$$.traducao = "";
				$$.tipo = variavel.tipo;
			}
			| TK_CHAR
			{

				$$.traducao = "";
				$$.tipo = "char";
				$$.label = $1.label;
			}
			| TK_BOOL
			{
				if($1.label == "true") {
					$1.label = "1";
				} else {
					$1.label = "0";
				}

				$$.label = $1.label;
				$$.traducao = "";
				$$.tipo = "bool";
			}
			;

%%

#include "lex.yy.c"

int yyparse();

string gentempcode()
{
	var_temp_qnt++;
	return "t" + to_string(var_temp_qnt);
}

int main(int argc, char* argv[])
{
	var_temp_qnt = 0;
	tipofinal["int"]["int"] = "int";
	tipofinal["float"]["int"] = "float";
	tipofinal["float"]["float"] = "float";
	tipofinal["int"]["float"] = "float";

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
	for(int i = 0; i < tabelaSimbolos.size(); i++) {
		if(tabelaSimbolos[i].name == name) {
			return true;
		}
	}

	return false;
}

VARIAVEL buscar(string name)
{
	VARIAVEL variavel;

	for(int i = 0; i < tabelaSimbolos.size(); i++) {
		if(tabelaSimbolos[i].name == name) {
			variavel = tabelaSimbolos[i];
			return variavel;
		}
	}

	return variavel;
}

void declarar(string tipo, string label) {
	declaracoes.push_back("\t" + tipo + " " + label + ";\n");
}
