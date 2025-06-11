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

struct CaseInfo {
    string constant_value_label;
    string constant_value_type;
    string code_target_label;
	string traducao_exp_case;
};

struct DefaultInfo {
    bool exists = false;
    string code_target_label;
};

struct SwitchContext {
    std::vector<CaseInfo> cases; 
    DefaultInfo default_info;
    std::string end_label;
};

vector<string> declaracoes;
vector<unordered_map<string, Simbolo>> tabela;
vector<string> break_label_stack;
vector<string> continue_label_stack;
vector<string> rotulo_condicao;
vector<string> rotulo_inicio;
vector<string> rotulo_fim;
vector<string> rotulo_incremento;
static vector<CaseInfo> g_current_switch_cases;
static DefaultInfo g_current_switch_default_info;
static string g_current_switch_end_label;
static vector<SwitchContext> g_switch_context_stack;

map<string, map<string, string>> tipofinal;

int yylex(void);
void yyerror(string);
string gentempcode();
bool verificar(string name);
Simbolo buscar(string name);
void declarar(string tipo, string label, int tam_string);
string cast_implicito(atributos* no1, atributos* no2, atributos* no3, string tipo);
void atualizar(string tipo, string nome, string tamanho, string cadeia_char, string atualiza_label);
int tamanho_string(string traducao);
string retirar_aspas(string traducao, int tamanho);
void adicionarSimbolo(string nome);
void retirarEscopo();
void adicionarEscopo();
string genlabel();
void retirar_rotulos();
void desempilhar_contexto_case();
string string_intermediario(string buffer, string tamanho, string cond, string label);

%}

%token TK_NUM TK_FLOAT TK_CHAR TK_BOOL TK_RELACIONAL TK_ORLOGIC TK_ANDLOGIC TK_NOLOGIC TK_CAST TK_VAR TK_CADEIA_CHAR TK_TIPO_INPUT
%token TK_MAIN TK_DEF TK_ID TK_IF TK_THEN TK_ELSE TK_WHILE TK_DO TK_FOR TK_BREAK TK_CONTINUE TK_CPY TK_INPUT TK_OUTPUT
%token TK_SWITCH TK_CASE TK_DEFAULT
// TK_FIM TK_ERROR
%start S

%left TK_ORLOGIC
%left TK_ANDLOGIC
%left TK_RELACIONAL
%left '+' '-'
%left '*' '/'
%right TK_NOLOGIC
%left '(' ')' TK_CAST

%%

S 			:LISTA_COMANDOS_GLOBAIS TK_DEF TK_MAIN BLOCO
			{
				string codigo = "/*Compilador GHP*/\n"
								"#include <iostream>\n"
								"#include<string.h>\n"
								"#include<stdio.h>\n\n"
								"int main(void) {\n";

				for (int i = 0; i < declaracoes.size(); i++) {
					codigo += declaracoes[i];
				}	

				codigo += "\n" + $1.traducao;

				codigo += "\n" + $4.traducao;
								
				codigo += 	"\n\treturn 0;"
							"\n}";

				cout << codigo << endl;
			}
			;
LISTA_COMANDOS_GLOBAIS : 
						{
							$$.traducao = "";
						}
						| LISTA_COMANDOS_GLOBAIS COMANDO_GLOBAL
						{
							$$.traducao = $1.traducao + $2.traducao;
						}
						;
COMANDO_GLOBAL : DEC ';'
				{

				}
				| ATRI ';'
				{

				}
				;
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

CRIAR_ROTULOS_FOR 	: 
            		{
        				rotulo_condicao.push_back(genlabel());
                		rotulo_incremento.push_back(genlabel());
                		rotulo_fim.push_back(genlabel());
						rotulo_inicio.push_back(genlabel());

                		break_label_stack.push_back(rotulo_fim.back());
                		continue_label_stack.push_back(rotulo_incremento.back());
                    }
                    ;
CRIAR_ROTULOS		:
					{
						rotulo_inicio.push_back(genlabel());
						rotulo_condicao.push_back(genlabel());
						rotulo_fim.push_back(genlabel());
						rotulo_incremento.push_back(genlabel());

						break_label_stack.push_back(rotulo_fim.back());
                		continue_label_stack.push_back(rotulo_condicao.back());

					}

RETIRAR_ROTULOS     :
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
                    ;
SWITCH_SETUP :
             {
                 SwitchContext current_switch_details;
                 current_switch_details.end_label = genlabel();
                 
                 break_label_stack.push_back(current_switch_details.end_label);

                 g_switch_context_stack.push_back(current_switch_details);
             }
             ;
SWITCH_CLEANUP :
               {
                   if (!break_label_stack.empty()) {
                       break_label_stack.pop_back();
                   } else {
                       yyerror("PANICO: Pilha de break vazia no cleanup do switch");
                   }

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
                declarar("bool", temp_negated_expr, -1);

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
                declarar("bool", temp_negated_expr, -1);

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
			| TK_WHILE '(' E ')' CRIAR_ROTULOS BLOCO RETIRAR_ROTULOS
			{
                if($3.tipo != "bool") {
                    yyerror("Erro Semantico: A expressao na condicional 'while' deve ser do tipo booleano.");
                }

                string temp_negated_expr = gentempcode();
                declarar("bool", temp_negated_expr, -1);

                $$.traducao = rotulo_condicao.back() + ":\n";
                $$.traducao += $3.traducao;
                $$.traducao += "\t" + temp_negated_expr + " = !" + $3.label + ";\n";
                $$.traducao += string("\t") + "if (" + temp_negated_expr + ") goto " + rotulo_fim.back() + ";\n";
                $$.traducao += $6.traducao;
                $$.traducao += string("\tgoto ") + rotulo_condicao.back() + ";\n";
                $$.traducao += rotulo_fim.back() + ":\n";

				retirar_rotulos();

                $$.tipo = ""; 
                $$.label = "";
			}
			| TK_DO CRIAR_ROTULOS BLOCO RETIRAR_ROTULOS TK_WHILE '(' E ')' ';'
			{
                if($7.tipo != "bool") {
                    yyerror("Erro Semantico: A expressao na condicional 'do-while' deve ser do tipo booleano.");
                }

                $$.traducao = rotulo_inicio.back() + ":\n";
                $$.traducao += $3.traducao;
				$$.traducao += rotulo_condicao.back() + ":\n";
                $$.traducao += $7.traducao;
                $$.traducao += string("\t") + "if (" + $7.label + ") goto " + rotulo_inicio.back() + ";\n";
				$$.traducao += rotulo_fim.back() + ":\n";

				retirar_rotulos();

                $$.tipo = ""; 
                $$.label = "";
			}
			| TK_FOR '(' ATRI ';' E ';' ATRI ')' CRIAR_ROTULOS_FOR BLOCO RETIRAR_ROTULOS
			{
                if($5.tipo != "bool") {
                    yyerror("Erro Semantico: A expressao de condicao no loop 'for' deve ser do tipo booleano.");
                }

                string temp_negated_cond = gentempcode();
                declarar("bool", temp_negated_cond, -1);

                $$.traducao = $3.traducao;
                $$.traducao += rotulo_condicao.back() + ":\n";
                $$.traducao += $5.traducao;
                $$.traducao += "\t" + temp_negated_cond + " = !" + $5.label + ";\n";
                $$.traducao += string("\t") + "if (" + temp_negated_cond + ") goto " + rotulo_fim.back() + ";\n";
                $$.traducao += $10.traducao;
				$$.traducao += rotulo_incremento.back() + ":\n";
                $$.traducao += $7.traducao;
                $$.traducao += string("\tgoto ") + rotulo_condicao.back() + ";\n";
                $$.traducao += rotulo_fim.back() + ":\n";

				retirar_rotulos();

                $$.tipo = ""; 
                $$.label = "";
			}
			| TK_BREAK ';'
			{
				if (break_label_stack.empty()) {
                    yyerror("Erro Semantico: Comando 'break' utilizado fora de um loop.");
                } else {
                    $$.traducao = string("\tgoto ") + break_label_stack.back() + ";\n";
                }
                
				$$.tipo = ""; 
				$$.label = "";
			}
			| TK_CONTINUE ';'
			{
				if (continue_label_stack.empty()) {
                    yyerror("Erro Semantico: Comando 'continue' utilizado fora de um loop.");
                } else {
                    $$.traducao = string("\tgoto ") + continue_label_stack.back() + ";\n";
                }

                $$.tipo = ""; 
				$$.label = "";
			}
			| TK_SWITCH '(' E ')' SWITCH_SETUP '{' CASE_STATEMENTS_LIST '}' SWITCH_CLEANUP
			{
				if (g_switch_context_stack.empty()) {
                	yyerror("Erro critico: Contexto de switch nao encontrado ao finalizar o switch.");
                	$$.traducao = "";
            	} else {
                	const SwitchContext& current_context = g_switch_context_stack.back();

                	string switch_expr_traducao = $3.traducao;
                	string switch_expr_val_label = $3.label;
                	string switch_expr_tipo = $3.tipo;

                	string dispatch_code;
                	string case_bodies_code = $7.traducao;

                for (const auto& ci : current_context.cases) {
                	if (tipofinal[switch_expr_tipo][ci.constant_value_type] == "float" || tipofinal[switch_expr_tipo][ci.constant_value_type] == "erro") {
                    	yyerror("Erro Semantico: Switch ou case de tipos incompativeis.");
               	 	}

                	string temp_cond = gentempcode();
                    declarar("bool", temp_cond, -1);
					dispatch_code += ci.traducao_exp_case;
                    dispatch_code += "\t" + temp_cond + " = (" + switch_expr_val_label + " == " + ci.constant_value_label + ");\n";
                    dispatch_code += string("\t") + "if (" + temp_cond + ") goto " + ci.code_target_label + ";\n";
                }

                if (current_context.default_info.exists) {
                    dispatch_code += "\tgoto " + current_context.default_info.code_target_label + ";\n";
                } else {
                    dispatch_code += "\tgoto " + current_context.end_label + ";\n";
                }

                $$.traducao = switch_expr_traducao + dispatch_code + case_bodies_code + current_context.end_label + ":\n";

				desempilhar_contexto_case();
                $$.tipo = "";
                $$.label = "";
            	}
        	}
			| TK_OUTPUT '(' OUTPUT ')' ';' 
            {	
                
                $$.traducao = $3.traducao;
                
                $$.tipo = "";
                $$.label = "";
            }
			| TK_ID '=' TK_INPUT '(' TK_TIPO_INPUT ')' ';' 
            {
                if(!verificar($1.label)) {
                    yyerror("Erro Semantico: Variavel '" + $1.label + "' nao declarada para input.");
                }

                Simbolo variavel_destino = buscar($1.label); // Obtém informações da variável de destino

                // traducaoTemp += $5.traducao; ver se precisa (vai imprimir a string em questão)

				if($5.tipo == "string"){
					if (variavel_destino.tipo != "string" && variavel_destino.tipado == true) {
                        yyerror("Erro Semantico: Variavel '" + $1.label + "' do tipo " + variavel_destino.tipo + " nao pode receber input de string.");
					}
					string tamanho = gentempcode();
					declarar("int", tamanho, -1);
					string buffer = gentempcode();
					declarar("char*", buffer, -1);
					string cond = gentempcode();
					declarar("bool", cond, -1);
					string label = genlabel();

					string temp_ponteiro = gentempcode();
				

					declarar("char*", temp_ponteiro, -1);
					atualizar("string", $1.label, tamanho, "", temp_ponteiro);

					$$.traducao += "\t" + buffer + " = malloc(256);\n" +
					"\tfgets(" + buffer + ", 256, stdin);\n" +
					string_intermediario(buffer, tamanho, cond, label) +
					"\t" + temp_ponteiro + " = malloc(" + tamanho + ");\n" +
					"\tstrcpy(" + temp_ponteiro + ", " + buffer + ");\n" +
					"\tfree(" + buffer + ");\n";

					$$.label = temp_ponteiro;
				}

				if($5.tipo == "int" || $5.tipo == "float" || $5.tipo == "char"){
					if(variavel_destino.tipo != $5.tipo && variavel_destino.tipado == true){
						yyerror("Erro Semantico: Variavel '" + $1.label + "' do tipo " + variavel_destino.tipo + " nao pode receber input de " + $5.tipo + ".");
					}

					string var = gentempcode();
					declarar($5.tipo, var, -1);
					$$.traducao += "\tscanf(\"" + $5.label + "\", &" + var + ");\n";

					atualizar($5.tipo, $1.label, "", "", var);
					$$.label = var;
				}

                $$.tipo = $5.tipo;
            }
			| TK_CPY '(' TK_ID ',' TK_ID ')'
			{	
				Simbolo simbolo1 = buscar($3.label);
				Simbolo simbolo2 = buscar($5.label);
				int tam1 = stoi(simbolo1.tamanho);
				int tam2 = stoi(simbolo2.tamanho);
				if(tipofinal[simbolo1.tipo][simbolo2.tipo] != "string") yyerror("Operação com tipos inválidos");
				if(tam1 < tam2) yyerror("Operação de copy inválida, espaço no BUFFER insuficiente"); 
				
				traducaoTemp = "";

				$$.label = gentempcode();
				$$.tipo = "string";
				$$.tamanho = tam1;

				for(int i = 0; i < tam1; i++){
					if(i == tam1 - 1){
						traducaoTemp += "\t" + $$.label + "[" + to_string(i) + "] = " + "'\\0'" + ";\n";
					} else if(i >= tam2 - 1 && tam2 <= tam1){
						traducaoTemp += "\t" + $$.label + "[" + to_string(i) + "] = '" + simbolo1.vetor_string[i] + "';\n";
					} else{
						traducaoTemp += "\t" + $$.label + "[" + to_string(i) + "] = '" + simbolo2.vetor_string[i] + "';\n";
					}
				}
				
				$$.traducao = "\tstrcpy(" + $$.label + ", " + simbolo2.label + ");\n" + traducaoTemp;
				declarar($$.tipo, $$.label, tam1);
			}
        	;

CASE_STATEMENTS_LIST :
                     {
                         $$.traducao = "";
                     }
                     | CASE_STATEMENTS_LIST_NON_EMPTY
                     ;
CASE_STATEMENTS_LIST_NON_EMPTY : CASE_OR_DEFAULT_ITEM
                               | CASE_STATEMENTS_LIST_NON_EMPTY CASE_OR_DEFAULT_ITEM
                                 { $$.traducao = $1.traducao + $2.traducao; }
                               ;
CASE_OR_DEFAULT_ITEM : CASE_CLAUSE
                     | DEFAULT_CLAUSE
                     ;

CASE_CLAUSE : TK_CASE E ':' COMANDOS
            {
                if ($2.tipo != "int" && $2.tipo != "char" && $2.tipo != "bool") {
                    yyerror("Erro Semantico: Constante do 'case' deve ser do tipo int, char ou bool. Encontrado: " + $2.tipo);
                }

                if (g_switch_context_stack.empty()) {
                    yyerror("Erro critico: 'case' encontrado fora de um contexto de switch ativo.");
        
                } else {
                    CaseInfo ci;
                    ci.constant_value_label = $2.label;
                    ci.constant_value_type = $2.tipo;
                    ci.code_target_label = genlabel();
					ci.traducao_exp_case = $2.traducao;
                    g_switch_context_stack.back().cases.push_back(ci);

                    $$.traducao = ci.code_target_label + ":\n" + $4.traducao;
                    $$.label = ci.code_target_label;
                    $$.tipo = "";
                }
            }
            ;

DEFAULT_CLAUSE : TK_DEFAULT ':' COMANDOS
               {
                   if (g_switch_context_stack.empty()) {
                       yyerror("Erro critico: 'default' encontrado fora de um contexto de switch ativo.");
                   } else {
                       SwitchContext& current_active_switch = g_switch_context_stack.back();
                       if (current_active_switch.default_info.exists) {
                           yyerror("Erro Semantico: Multiplos 'default' no mesmo switch.");
                       }
                       current_active_switch.default_info.exists = true;
                       current_active_switch.default_info.code_target_label = genlabel();

                       $$.traducao = current_active_switch.default_info.code_target_label + ":\n" + $3.traducao;
                       $$.label = current_active_switch.default_info.code_target_label;
                       $$.tipo = "";
                   }
               }
               ;

OUTPUT		: OUTPUT '+' TK_ID
			{
				if(!verificar($3.label)) yyerror("Erro Semantico: Variavel '" + $3.label + "' nao declarada para output.");

				Simbolo variavel = buscar($3.label);
				if(variavel.tipado == false) yyerror("Erro Semantico: Variavel '" + $3.label + "' nao foi tipada.");

                string format_specifier;
                if (variavel.tipo == "int" || variavel.tipo == "bool") {
                    format_specifier = "%d";
                } else if (variavel.tipo == "float") {
                    format_specifier = "%f";
                } else if (variavel.tipo == "char") {
                    format_specifier = "%c";
                } else if (variavel.tipo == "string") {
                    format_specifier = "%s";
                } else {
                    yyerror("Erro Semantico: Tipo de variavel '" + variavel.tipo + "' nao suportado para output.");
                }

                $$.traducao = $1.traducao + "\tprintf(\"" + format_specifier + "\", " + variavel.label + ");\n";
                $$.label = ""; // Resetar label/tipo se não for relevante para o pai
                $$.tipo = "";
			}
			| OUTPUT '+' TK_CADEIA_CHAR
			{
				$$.traducao = $1.traducao + "\tprintf(" + $3.label + ");\n";
                $$.label = "";
                $$.tipo = "";
			}
			| TK_ID
			{
				if(!verificar($1.label)) yyerror("Erro Semantico: Variavel '" + $1.label + "' nao declarada para output.");
	
				Simbolo variavel = buscar($1.label);
				if(variavel.tipado == false) yyerror("Erro Semantico: Variavel '" + $1.label + "' nao foi tipada.");

                string format_specifier;
                if (variavel.tipo == "int" || variavel.tipo == "bool") {
                    format_specifier = "%d";
                } else if (variavel.tipo == "float") {
                    format_specifier = "%f";
                } else if (variavel.tipo == "char") {
                    format_specifier = "%c";
                } else if (variavel.tipo == "string") {
                    format_specifier = "%s";
                } else {
                    yyerror("Erro Semantico: Tipo de variavel '" + variavel.tipo + "' nao suportado para output.");
                }

                $$.traducao = "\tprintf(\"" + format_specifier + "\", " + variavel.label + ");\n";
                $$.label = "";
                $$.tipo = "";
			}
			| TK_CADEIA_CHAR
			{
				$$.traducao = "\tprintf(" + $1.label + ");\n";
                $$.label = "";
                $$.tipo = "";
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
					if($3.tipo == "string" ){
						atualizar($3.tipo, $1.label, $3.tamanho, $3.vetor_string, "");
						declarar($3.tipo, variavel.label, stoi($3.tamanho));
						variavel.tipo = $3.tipo;
						$1.tamanho = $3.tamanho;
						$1.vetor_string = $3.vetor_string;
					}else{
						atualizar($3.tipo, $1.label, "", "", "");
						declarar($3.tipo, variavel.label, -1);
						variavel.tipo = $3.tipo;
					}
				}

				$1.tipo = variavel.tipo;
				$1.label = variavel.label;

				if(tipofinal[$1.tipo][$3.tipo] == "erro") yyerror("Operação com tipos inválidos");

				traducaoTemp = cast_implicito(&$$, &$1, &$3, "atribuicao");

				if($1.tipo == "string"){
					$$.traducao = $1.traducao + $3.traducao + traducaoTemp + "\t" + "strcpy(" + $1.label + ", " + $3.label + ");\n";
				}else{
				$$.traducao = $1.traducao + $3.traducao + traducaoTemp + "\t" + $1.label + " = " + $3.label + ";\n";
				}
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
				$$.tamanho = "";
				$$.vetor_string = "";

			};


E 			: '(' E ')'
			{
				$$ = $2;
			}
			| E '+' E
			{	
				traducaoTemp = "";

				if(tipofinal[$1.tipo][$3.tipo] == "string")
				{	
					$$.label = gentempcode();
					$$.tipo = "string";
					int tam1 = stoi($1.tamanho);
					int tam2 = stoi($3.tamanho);
					int tamcat = (tam1 - 1) + (tam2 - 1) + 1;
					$$.tamanho = to_string(tamcat);

					for(int i = 0; i < tamcat; i++){
						if(i == tamcat - 1){
							traducaoTemp += "\t" + $$.label + "[" + to_string(i) + "] = " + "'\\0'" + ";\n";
						} else if(i < (stoi($1.tamanho)- 1)){
							traducaoTemp += "\t" + $$.label + "[" + to_string(i) + "] = '" + $1.vetor_string[i] + "';\n";
						} else{
							traducaoTemp += "\t" + $$.label + "[" + to_string(i) + "] = '" + $3.vetor_string[i - (tam1 - 1)] + "';\n";
						}
					}
					
					$$.traducao = traducaoTemp;
					declarar($$.tipo, $$.label, tamcat);
					
				}
				else
				{
					traducaoTemp = cast_implicito(&$$, &$1, &$3, "operacao");

					$$.label = gentempcode();
					
					$$.tipo = tipofinal[$1.tipo][$3.tipo];
					if($$.tipo == "erro") yyerror("Operação com tipos inválidos");

					$$.traducao = $1.traducao + $3.traducao + traducaoTemp +
						"\t" + $$.label + " = " + $1.label + " + " + $3.label + ";\n";

					declarar($$.tipo, $$.label, -1);
				}
			}
			| E '-' E
			{
				traducaoTemp = "";
				
				traducaoTemp = cast_implicito(&$$, &$1, &$3, "operacao");
				
    			$$.label = gentempcode();
    			
				$$.tipo = tipofinal[$1.tipo][$3.tipo];
				if($$.tipo == "erro" || $$.tipo == "string") yyerror("Operação com tipos inválidos");

    			$$.traducao = $1.traducao + $3.traducao + traducaoTemp +
                  	"\t" + $$.label + " = " + $1.label + " - " + $3.label + ";\n";

    			declarar($$.tipo, $$.label, -1);
			}
			| E '*' E
			{
				traducaoTemp = "";

				traducaoTemp = cast_implicito(&$$, &$1, &$3, "operacao");

    			$$.label = gentempcode();
    			
				$$.tipo = tipofinal[$1.tipo][$3.tipo];
				if($$.tipo == "erro" || $$.tipo == "string") yyerror("Operação com tipos inválidos");

    			$$.traducao = $1.traducao + $3.traducao + traducaoTemp +
                  	"\t" + $$.label + " = " + $1.label + " * " + $3.label + ";\n";

    			declarar($$.tipo, $$.label, -1);			
			}
			| E '/' E
			{
				traducaoTemp = "";

				traducaoTemp = cast_implicito(&$$, &$1, &$3, "operacao");

				$$.label = gentempcode();
    			
				$$.tipo = tipofinal[$1.tipo][$3.tipo];
				if($$.tipo == "erro" || $$.tipo == "string") yyerror("Operação com tipos inválidos");

    			$$.traducao = $1.traducao + $3.traducao + traducaoTemp + "\t" + $$.label + " = " + $1.label + " / " + $3.label + ";\n";

    			declarar($$.tipo, $$.label, -1);
			}
			| TK_FLOAT
			{
				$$.label = gentempcode();
				$$.traducao = "\t" + $$.label + " = " + $1.label + ";\n";
				$$.tipo = "float";
				declarar($$.tipo, $$.label, -1);
			}
			| TK_NUM
			{
				$$.label = gentempcode();
				$$.traducao = "\t" + $$.label + " = " + $1.label + ";\n";
				$$.tipo = "int";
				declarar($$.tipo, $$.label, -1);
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
				$$.tamanho = variavel.tamanho;
				$$.vetor_string = variavel.vetor_string;				
			}
			| TK_CHAR
			{

				$$.label = gentempcode();
				$$.traducao = "\t" + $$.label + " = " + $1.label + ";\n";
				$$.tipo = "char";
				$$.tamanho = "1";
				declarar($$.tipo, $$.label, -1);
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
        		declarar($$.tipo, $$.label, -1);
        	}
            | E TK_ORLOGIC E
    		{
   				$$.label = gentempcode();
        		$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " " + $2.label + " " + $3.label + ";\n";
        		$$.tipo = "bool";
    			declarar($$.tipo, $$.label, -1);
        	}
            | E TK_ANDLOGIC E
        	{
        		$$.label = gentempcode();
        		$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " " + $2.label + " " + $3.label + ";\n";
        		$$.tipo = "bool";
        		declarar($$.tipo, $$.label, -1);
            }
            | TK_NOLOGIC E
            {
		    	$$.label = gentempcode();
        		$$.traducao = $2.traducao + "\t" + $$.label + " = !" + $2.label +  ";\n";
        		$$.tipo = "bool";
        		declarar($$.tipo, $$.label, -1);
        	}
	    	| TK_CAST E
	    	{
				string temp1 = gentempcode();
    			string temp2 = gentempcode();

    			declarar($2.tipo, temp1, -1);
    			declarar($1.tipo, temp2, -1);

    			$$.traducao = $2.traducao +	"\t" + temp1 + " = " + $2.label + ";\n" +"\t" + temp2 + " = " + "(" + $1.tipo + ")" + temp1 + ";\n";

    			$$.label = temp2;
    			$$.tipo = $1.tipo;
	    	}
			|TK_CADEIA_CHAR
			{
				int tamString = tamanho_string($1.label);
				traducaoTemp = retirar_aspas($1.label, tamString);

				$$.label = gentempcode();
				$$.tipo = "string";
				$$.tamanho = to_string(tamString);
				$$.vetor_string = traducaoTemp;

				for(int i = 0; i < tamString; i++){
					if(i != tamString - 1) 
					{
						$$.traducao += "\t" + $$.label + "[" + to_string(i) + "] = '" + traducaoTemp[i] + "';\n";
					} else
					{
						$$.traducao += "\t" + $$.label + "[" + to_string(i) + "] = '\\0';\n";
					}
				}

				declarar($$.tipo, $$.label, tamString);
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

void atualizar(string tipo, string nome, string tamanho, string cadeia_char, string atualiza_label) {

	for(int i = tabela.size() - 1; i >= 0; i--) {
		auto it = tabela[i].find(nome);
		if(!(it == tabela[i].end())) {
			if(atualiza_label != "") it->second.label = atualiza_label;
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
void desempilhar_contexto_case() {
	if (!g_switch_context_stack.empty()) {
        g_switch_context_stack.pop_back();
	} else {
        yyerror("PANICO: Pilha de contexto de switch vazia no cleanup");
    }
}

string string_intermediario(string buffer, string tamanho, string cond, string label)
{
    string temp = gentempcode();
	declarar("char", temp, -1);
    string saida = "";
	saida += "\n\t" + tamanho + " = 0;\n"; // Inicializa o contador de tamanho
	saida += "\t" + label + ":\n"; // Rótulo de início do loop
	saida += "\t\t" + temp + " = *" + buffer + ";\n"; // Pega o caractere atual
	saida += "\t\t" + buffer + " = " + buffer + " + 1;\n";
	saida += "\t\t" + cond + " = (" + temp + " != '\\0');\n"; // Verifica se o caractere não é nulo
	saida += "\t\tif (!" + cond + ") goto " + label + "_end;\n"; // Se for nulo (cond for falso), sai do loop
	saida += "\t\t" + tamanho + " = " + tamanho + " + 1;\n"; // Incrementa o tamanho
	saida += "\t\tgoto " + label + ";\n"; // Volta para o início do loop
	saida += "\t" + label + "_end:\n"; // Rótulo de fim do loop
	saida += "\t\t" + tamanho + " = " + tamanho + " + 1;\n"; // Incrementa o tamanho mais uma vez (para incluir o nulo ou compensar o último incremento)
    return saida;
}