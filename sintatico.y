%{
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
	bool tipado = false;
};

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
	bool tipado;
} VARIAVEL;

vector<VARIAVEL> tabelaSimbolos;
vector<string> declaracoes;
vector<unordered_map<string, Simbolo>> tabela;

map<string, map<string, string>> tipofinal;

int yylex(void);
void yyerror(string);
string gentempcode();
bool verificar(string name);
Simbolo buscar(string name);
void declarar(string tipo, string label);
VARIAVEL criar(string tipo, string label);
string cast_implicito(atributos* no1, atributos* no2, atributos* no3, string tipo);
void atualizar(string tipo, string name);
int tamanho_string(string traducao);
string retirar_aspas(string traducao, int tamanho);
void atualizar(string tipo, string nome);
void adicionarSimbolo(string nome);
void retirarEscopo();
void adicionarEscopo();
string genlabel();


%}

%token TK_NUM TK_FLOAT TK_CHAR TK_BOOL TK_RELACIONAL TK_ORLOGIC TK_ANDLOGIC TK_NOLOGIC TK_CAST TK_VAR 
%token TK_MAIN TK_DEF TK_ID TK_IF TK_THEN TK_ELSE
%token TK_FIM TK_ERROR

%start S

%left TK_ORLOGIC
%left TK_ANDLOGIC
%left TK_RELACIONAL
%left '+' '-'
%left '*' '/'
%right TK_NOLOGIC
%left '(' ')' TK_CAST

%%

S 			:TK_DEF TK_MAIN BLOCO
			{
				string codigo = "/*Compilador GHP*/\n"
								"#include <iostream>\n"
								"#include<string.h>\n"
								"#include<stdio.h>\n\n"
								"int main(void) {\n";

				for (int i = 0; i < declaracoes.size(); i++) {
					codigo += declaracoes[i];
				}	

				codigo += "\n" + $3.traducao;
								
				codigo += 	"\n\treturn 0;"
							"\n}";

				cout << codigo << endl;
			};
BLOCO		: '{'{ adicionarEscopo();} COMANDOS '}'
			{
				$$.traducao = $3.traducao;
				retirarEscopo();
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
			| ATRI ';'
			| DEC ';'
			| BLOCO
			| TK_IF '(' E ')' TK_THEN BLOCO
			{
                if($3.tipo != "bool") {
                    yyerror("Erro Semantico: A expressao na condicional 'if' deve ser do tipo booleano.");
                }

                string temp_negated_expr = gentempcode();
                declarar("bool", temp_negated_expr);

                string fim_label = genlabel();
                $$.traducao = $3.traducao; 
                $$.traducao += "\t" + temp_negated_expr + " = !" + $3.label + ";\n";
                $$.traducao += string("\t") + "if (" + temp_negated_expr + ") goto " + fim_label + ";\n";
                $$.traducao += $6.traducao;
                $$.traducao += fim_label + ":\n";
                $$.tipo = "";
                $$.label = "";

			}
			| TK_IF '(' E ')' TK_THEN BLOCO TK_ELSE BLOCO
			{
                if($3.tipo != "bool") {
                    yyerror("Erro Semantico: A expressao na condicional 'if' deve ser do tipo booleano.");
                }

                string else_label = genlabel();
                string end_if_label = genlabel();

                string temp_negated_expr = gentempcode();
                declarar("bool", temp_negated_expr);

                $$.traducao = $3.traducao;
                $$.traducao += "\t" + temp_negated_expr + " = !" + $3.label + ";\n";
                $$.traducao += string("\t") + "if (" + temp_negated_expr + ") goto " + else_label + ";\n";
                $$.traducao += $6.traducao;
                $$.traducao += string("\tgoto ") + end_if_label + ";\n";
                $$.traducao += else_label + ":\n";
                $$.traducao += $8.traducao;
                $$.traducao += end_if_label + ":\n";

                $$.tipo = ""; 
                $$.label = "";
			}
			;
ATRI 		:TK_ID '=' E
			{
				traducaoTemp = "";

				if(!verificar($1.label)) {
					yyerror("Variavel nao foi declarada.");
				}

				Simbolo variavel;
				variavel = buscar($1.label);

				if(variavel.tipado == false) {
					atualizar($3.tipo, $1.label);
					declarar($3.tipo, variavel.label);
					variavel.tipo = $3.tipo;
				}

				$1.tipo = variavel.tipo;
				$1.label = variavel.label;

				if(tipofinal[$1.tipo][$3.tipo] == "erro") yyerror("Operação com tipos inválidos");

				traducaoTemp = cast_implicito(&$$, &$1, &$3, "atribuicao");


				$$.traducao = $1.traducao + $3.traducao + traducaoTemp + "\t" + $1.label + " = " + $3.label + ";\n";
			}
			;

DEC			:TK_VAR TK_ID
			{
				if(verificar($2.label)) {
					yyerror("Variavel já declarada.\n");
				}

				adicionarSimbolo($2.label);

				$$.label = "";
				$$.traducao = "";
				$$.tipo = "";

			}


E 			: '(' E ')'
			{
				$$ = $2;
			}
			| E '+' E
			{
    			traducaoTemp = "";

				traducaoTemp = cast_implicito(&$$, &$1, &$3, "operacao");

    			$$.label = gentempcode();
    			
				$$.tipo = tipofinal[$1.tipo][$3.tipo];
				if($$.tipo == "erro") yyerror("Operação com tipos inválidos");

    			$$.traducao = $1.traducao + $3.traducao + traducaoTemp +
                  	"\t" + $$.label + " = " + $1.label + " + " + $3.label + ";\n";

    			declarar($$.tipo, $$.label);
			}
			| E '-' E
			{
				traducaoTemp = "";
				
				traducaoTemp = cast_implicito(&$$, &$1, &$3, "operacao");
				
    			$$.label = gentempcode();
    			
				$$.tipo = tipofinal[$1.tipo][$3.tipo];
				if($$.tipo == "erro") yyerror("Operação com tipos inválidos");

    			$$.traducao = $1.traducao + $3.traducao + traducaoTemp +
                  	"\t" + $$.label + " = " + $1.label + " - " + $3.label + ";\n";

    			declarar($$.tipo, $$.label);
			}
			| E '*' E
			{
				traducaoTemp = "";

				traducaoTemp = cast_implicito(&$$, &$1, &$3, "operacao");

    			$$.label = gentempcode();
    			
				$$.tipo = tipofinal[$1.tipo][$3.tipo];
				if($$.tipo == "erro") yyerror("Operação com tipos inválidos");

    			$$.traducao = $1.traducao + $3.traducao + traducaoTemp +
                  	"\t" + $$.label + " = " + $1.label + " * " + $3.label + ";\n";

    			declarar($$.tipo, $$.label);			
			}
			| E '/' E
			{
				traducaoTemp = "";

				traducaoTemp = cast_implicito(&$$, &$1, &$3, "operacao");

				$$.label = gentempcode();
    			
				$$.tipo = tipofinal[$1.tipo][$3.tipo];
				if($$.tipo == "erro") yyerror("Operação com tipos inválidos");

    			$$.traducao = $1.traducao + $3.traducao + traducaoTemp + "\t" + $$.label + " = " + $1.label + " / " + $3.label + ";\n";

    			declarar($$.tipo, $$.label);
			}
			| TK_FLOAT
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
				Simbolo variavel;

				if(!verificar($1.label)) {
					yyerror("Variavel nao foi declarada.");
				}
				
				variavel = buscar($1.label);
				if(variavel.tipo == "") yyerror("Variavel ainda nao possui tipo");
				
				$$.label = variavel.label;
				$$.traducao = "";
				$$.tipo = variavel.tipo;
				
			}
			| TK_CHAR
			{

				$$.label = gentempcode();
				$$.traducao = "\t" + $$.label + " = " + $1.label + ";\n";
				$$.tipo = "char";
				declarar($$.tipo, $$.label);
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
            | E TK_RELACIONAL E
    		{	
				traducaoTemp = "";

				traducaoTemp = cast_implicito(&$$, &$1, &$3, "operacao");

            	$$.label = gentempcode();
       			$$.traducao = $1.traducao + $3.traducao + traducaoTemp + "\t" + $$.label + " = " + $1.label + " " + $2.label + " " + $3.label + ";\n";
        		$$.tipo = "bool";
        		declarar($$.tipo, $$.label);
        	}
            | E TK_ORLOGIC E
    		{
   				$$.label = gentempcode();
        		$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " " + $2.label + " " + $3.label + ";\n";
        		$$.tipo = "bool";
    			declarar($$.tipo, $$.label);
        	}
            | E TK_ANDLOGIC E
        	{
        		$$.label = gentempcode();
        		$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " " + $2.label + " " + $3.label + ";\n";
        		$$.tipo = "bool";
        		declarar($$.tipo, $$.label);
            }
            | TK_NOLOGIC E
            {
		    	$$.label = gentempcode();
        		$$.traducao = $2.traducao + "\t" + $$.label + " = !" + $2.label +  ";\n";
        		$$.tipo = "bool";
        		declarar($$.tipo, $$.label);
        	}
	    	| TK_CAST E
	    	{
				string temp1 = gentempcode();
    			string temp2 = gentempcode();

    			declarar($2.tipo, temp1);
    			declarar($1.tipo, temp2);

    			$$.traducao = $2.traducao +	"\t" + temp1 + " = " + $2.label + ";\n" +"\t" + temp2 + " = " + "(" + $1.tipo + ")" + temp1 + ";\n";

    			$$.label = temp2;
    			$$.tipo = $1.tipo;
	    	}
			| TK_CADEIA_CHAR
			{
				int tamString = tamanho_string($1.label);
				traducaoTemp = retirar_aspas($1.label, tamString);

				$$.label = gentempcode();
				for(int i = 0; i < tamString; i++){
					if(i != tamString - 1) 
					{
						$$.traducao += "\t" + $$.label + "[" + to_string(i) + "] = '" + traducaoTemp[i] + "';\n";
					} else
					{
						$$.traducao += "\t" + $$.label + "[" + to_string(i) + "] = '\\0';\n";
					}
					
				}
				declaracoes.push_back("\tchar " + $$.label + "[" + to_string(tamString) + "]" + ";\n");
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
	adicionarEscopo();

	traducaoTemp = "";
	var_temp_qnt = 0;
	tipofinal["int"]["int"] = "int";
	tipofinal["float"]["int"] = "float";
	tipofinal["float"]["float"] = "float";
	tipofinal["int"]["float"] = "float";
	tipofinal["char"]["int"] = "char";
	tipofinal["int"]["char"] = "char";
	tipofinal["char"]["char"] = "char";
	tipofinal["bool"]["bool"] = "bool";
	tipofinal["bool"]["int"] = "erro";
	tipofinal["int"]["bool"] = "erro";
	tipofinal["float"]["char"] = "erro";
	tipofinal["char"]["float"] = "erro";
	tipofinal["bool"]["char"] = "erro";
	tipofinal["char"]["bool"] = "erro";
	tipofinal["bool"]["float"] = "erro";
	tipofinal["float"]["bool"] = "erro";

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

}

void declarar(string tipo, string label) 
{
	if (tipo == "bool") tipo = "int";
	declaracoes.push_back("\t" + tipo + " " + label + ";\n");
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
        		declarar("float", no1->label);
        		traducaoTemp += "\t" + no1->label + " = (float)" + no2->label + ";\n";
        		no2->label = no1->label;
				no2->tipo = "float";
       		} else if (no2->tipo == "float" && no3->tipo == "int") {
				no1->label = gentempcode();
        		declarar("float", no1->label);
        		traducaoTemp += "\t" + no1->label + " = (float)" + no3->label + ";\n";
        		no3->label = no1->label;
        		no3->tipo = "float";
        	}
    	}
		 

		if(tipo == "atribuicao") {
			
        	if (no2->tipo == "int" && no3->tipo == "float") {
        		no1->label = gentempcode();
        		declarar("int", no1->label);
        		traducaoTemp += "\t" + no1->label + " = (int)" + no3->label + ";\n";
				no3->label = no1->label;
    		} else if (no2->tipo == "float" && no3->tipo == "int") {
				no1->label = gentempcode();
        		declarar("float", no1->label);
        		traducaoTemp += "\t" + no1->label + " = (float)" + no3->label + ";\n";
				no3->label = no1->label;
        	} 
    	}

	return traducaoTemp;
}

void atualizar(string tipo, string nome) {

	for(int i = tabela.size() - 1; i >= 0; i--) {
		auto it = tabela[i].find(nome);
		if(!(it == tabela[i].end())) {
			it->second.tipo = tipo;
			it->second.tipado = true;
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
    return "L_FIM_" + to_string(label_qnt); // Gera labels como L_FIM_1, L_FIM_2, etc.
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