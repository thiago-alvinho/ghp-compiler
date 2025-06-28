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
	string rows_label = "";
	string cols_label = "";
	bool is_matrix = false;
};

struct atributos
{
	string label;
	string traducao;
	string tipo;
	string tamanho = "";
	string vetor_string = "";
	string literal_value = "";
	bool id = false;
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

/*vetores de declarações das variáveis locais e globais*/
vector<string> declaracoes_locais;
vector<string> declaracoes_globais;
/*variável para saber se estamos no escopo global ainda ou não*/
bool g_processando_escopo_global = true;

// Nova variável global para coletar os valores da lista de inicialização
static vector<vector<atributos>> g_current_matrix_initializer;



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
void atualizar(string tipo, string nome, string tamanho, string cadeia_char, string atualiza_label, string rows, string cols, bool matrix);
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

%token TK_NUM TK_FLOAT TK_CHAR TK_BOOL TK_RELACIONAL TK_ORLOGIC TK_ANDLOGIC TK_NOLOGIC TK_CAST TK_VAR TK_CADEIA_CHAR TK_TIPO_INPUT TK_PLUS_EQ TK_MINUS_EQ TK_MULT_EQ TK_DIV_EQ
%token TK_MAIN TK_DEF TK_ID TK_IF TK_THEN TK_ELSE TK_WHILE TK_DO TK_FOR TK_BREAK TK_CONTINUE TK_CPY TK_CAT TK_INPUT TK_OUTPUT TK_INC TK_DEC
%token TK_SWITCH TK_CASE TK_DEFAULT
// TK_FIM TK_ERROR
%start S

%left TK_ORLOGIC
%left TK_ANDLOGIC
%left TK_RELACIONAL
%left '+' '-'
%left '*' '/'
%right TK_NOLOGIC TK_INC TK_DEC
%left '(' ')' TK_CAST

%%

S 			:LISTA_COMANDOS_GLOBAIS S_MAIN
			{
				string codigo = "/*Compilador GHP*/\n"
								"#include<string.h>\n"
								"#include<stdlib.h>\n"
								"#include<stdio.h>\n\n";

				for (int i = 0; i < declaracoes_globais.size(); i++) {
					codigo += declaracoes_globais[i];
				}

				codigo += "\nint main(void) {\n";

				for (int i = 0; i < declaracoes_locais.size(); i++) {
					codigo += declaracoes_locais[i];
				}	

				codigo += "\n" + $1.traducao;

				codigo += "\n" + $2.traducao;
								
				codigo += 	"\n\treturn 0;"
							"\n}";

				cout << codigo << endl;
			}
			;
S_MAIN : TK_DEF TK_MAIN
		{
			g_processando_escopo_global = false;
		}
		BLOCO
		{
			$$ = $4;
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
					atualizar("string", $1.label, tamanho, "", temp_ponteiro, "", "", false);

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

					atualizar($5.tipo, $1.label, "", "", var, "", "", false);
					$$.label = var;
				}

                $$.tipo = $5.tipo;
            }
			| TK_CAT '(' TK_ID ',' TK_ID ')' ';'
			{
				Simbolo simbolo1 = buscar($3.label); 
				Simbolo simbolo2 = buscar($5.label); 

				if (simbolo1.label == simbolo2.label) yyerror("Nao eh possivel concatenar quando o destino e a origem são o mesmo endereço.");
				if(tipofinal[simbolo1.tipo][simbolo2.tipo] != "string") {
					yyerror("Operação de concatenacao com tipos inválidos");
				}

				// `stoi(simbolo1.tamanho)` é o tamanho alocado anterior, incluindo o '\0'.
				int len1 = stoi(simbolo1.tamanho) - 1; // Conteúdo útil do destino
				int len2 = stoi(simbolo2.tamanho) - 1; // Conteúdo útil da fonte (este não muda)
				
				// Calcular o novo tamanho total necessário para a concatenação
				int tamcat_total_alocado = len1 + len2 + 1; 
				string cat = simbolo1.vetor_string + simbolo2.vetor_string; 

				// Gerar um novo label para a variável temporária C que conterá o resultado
				string resultado_temp_c_label = gentempcode();

				// Declara o ponteiro char* para o resultado temporário
				declarar("char*", resultado_temp_c_label, -1); 

				$$.traducao = ""; 

				// Alocar memória para o NOVO temporário
				$$.traducao += "\t" + resultado_temp_c_label + " = (char*)malloc(" + to_string(tamcat_total_alocado) + ");\n";


				$$.traducao += "\tstrcpy(" + resultado_temp_c_label + ", " + simbolo1.label + ");\n";
				$$.traducao += "\tstrcat(" + resultado_temp_c_label + ", " + simbolo2.label + ");\n";

				$$.tipo = "string";
				$$.tamanho = to_string(tamcat_total_alocado); 

				// **CORREÇÃO AQUI:** Liberar a memória antiga do DESTINO e atribuir o NOVO ponteiro.
				// O $3.label aqui refere-se ao nome da variável GHP ('a'), não ao seu label C (`t1`).
				// O `simbolo1.label` é o label C atual da variável 'a' (que é 't1').
				$$.traducao += "\tfree(" + simbolo1.label + ");\n"; // Libera a memória antiga de 'a' (t1)
				$$.traducao += "\t" + simbolo1.label + " = " + resultado_temp_c_label + ";\n"; // 'a' (t1) agora aponta para o novo buffer

				atualizar($$.tipo, $3.label, $$.tamanho, cat, simbolo1.label, "", "", false); 
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

OUTPUT      : E
            {
                // Este é o caso base: imprimir uma única expressão.
                // A expressão $1 já foi processada e seu valor está em $1.label.
                
                string format_specifier;
                string valor_a_imprimir = $1.label;

                if ($1.tipo == "int" || $1.tipo == "bool") {
                    format_specifier = "%d";
                } else if ($1.tipo == "float") {
                    format_specifier = "%f";
                } else if ($1.tipo == "char") {
                    format_specifier = "%c";
                } else if ($1.tipo == "string") {
                    format_specifier = "%s";
                } else {
                    yyerror("Erro Semantico: Tentando imprimir uma expressao de tipo invalido ou desconhecido: " + $1.tipo);
                }

                // O código final é o código para calcular a expressão, seguido do printf.
                $$.traducao = $1.traducao + "\tprintf(\"" + format_specifier + "\", " + valor_a_imprimir + ");\n";
                $$.label = "";
                $$.tipo = "";
            }
            | OUTPUT ',' E
            {
                // Caso recursivo: já imprimimos algo ($1) e estamos concatenando outra expressão ($3).
                $$.traducao = $1.traducao; // Pega o código gerado anteriormente.
                
                string format_specifier;
                string valor_a_imprimir = $3.label;

                if ($3.tipo == "int" || $3.tipo == "bool") {
                    format_specifier = "%d";
                } else if ($3.tipo == "float") {
                    format_specifier = "%f";
                } else if ($3.tipo == "char") {
                    format_specifier = "%c";
                } else if ($3.tipo == "string") {
                    format_specifier = "%s";
                } else {
                    yyerror("Erro Semantico: Tentando imprimir uma expressao de tipo invalido ou desconhecido: " + $3.tipo);
                }

                // Adiciona o código para calcular a nova expressão e seu respectivo printf.
                $$.traducao += $3.traducao + "\tprintf(\"" + format_specifier + "\", " + valor_a_imprimir + ");\n";
                $$.label = "";
                $$.tipo = "";
            }
            ;
OP_ATRIBUICAO : TK_PLUS_EQ { $$.label = "+";}
			  | TK_MINUS_EQ { $$.label = "-";}
			  | TK_MULT_EQ { $$.label = "*";}
			  | TK_DIV_EQ { $$.label = "/";}
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
						atualizar($3.tipo, $1.label, $3.tamanho, $3.vetor_string, "", "", "", false);
						declarar($3.tipo, variavel.label, stoi($3.tamanho));
						variavel.tipo = $3.tipo;
						variavel.tamanho = $3.tamanho;
						$1.tamanho = $3.tamanho;
						$1.vetor_string = $3.vetor_string;
					}else{
						atualizar($3.tipo, $1.label, "", "", "", "", "", false);
						declarar($3.tipo, variavel.label, -1);
						variavel.tipo = $3.tipo;
					}
				}

				$1.tipo = variavel.tipo;
				$1.label = variavel.label;

				if(tipofinal[$1.tipo][$3.tipo] == "erro") yyerror("Operação com tipos inválidos");

				traducaoTemp = cast_implicito(&$$, &$1, &$3, "atribuicao");
				if($1.tipo == "string" && $3.tipo == "string" && $3.id){
					$$.traducao += $1.traducao + $3.traducao + traducaoTemp + 
					"\t" + $1.label + " = (char *) realloc(" + $1.label + ", " + $3.tamanho + ");\n" +
					"\tstrcpy(" + $1.label + ", " + $3.label + ");\n";
				}else if($1.tipo == "string" && $3.tipo == "string"){
					$$.traducao += $1.traducao + $3.traducao + traducaoTemp + 
					"\t" + $1.label + " = (char *) malloc(" + $3.tamanho + " * sizeof(char));\n" +
					"\tstrcpy(" + $1.label + ", " + $3.label + ");\n";
				}else{
					$$.traducao += $1.traducao + $3.traducao + traducaoTemp + "\t" + $1.label + " = " + $3.label + ";\n";
				}
			}
			| TK_ID '[' E ']' '[' E ']' '=' E
			{
				if (!verificar($1.label)) {
          			yyerror("Erro Semantico: Matriz '" + $1.label + "' nao declarada.");
      			}

      			Simbolo s = buscar($1.label);
      			if (!s.is_matrix) {
          			yyerror("Erro Semantico: Variavel '" + $1.label + "' nao eh uma matriz.");
      			}

      			// Copiamos os atributos do valor da direita ($9) para poder modificá-los com o cast.
      			atributos rhs_attrs = $9;
      
      			// Concatenar a tradução de todas as expressões (índices e valor)
      			$$.traducao = $3.traducao + $6.traducao + rhs_attrs.traducao;

      			if (s.tipado == false) {
          			// --- SEÇÃO DE INFERÊNCIA E ALOCAÇÃO (JÁ ESTÁ CORRETA) ---
          			string tipo_inferido = rhs_attrs.tipo;


          			string tipo_c_ptr = tipo_inferido + "*";
					if(tipo_inferido == "bool") tipo_c_ptr = "int*";
          			declarar(tipo_c_ptr, s.label, -1);
          
          			string temp_total_size = gentempcode();
          			declarar("int", temp_total_size, -1);
              
          			$$.traducao += "\t" + temp_total_size + " = " + s.rows_label + " * " + s.cols_label + ";\n";
					if(tipo_inferido == "bool") {
						$$.traducao += "\t" + s.label + " = ("+tipo_c_ptr+") malloc(sizeof(" + "int" + ") * " + temp_total_size + ");\n";	
					} else {
						$$.traducao += "\t" + s.label + " = ("+tipo_c_ptr+") malloc(sizeof(" + tipo_inferido + ") * " + temp_total_size + ");\n";	
					}
              
          			// Atualiza a tabela com o tipo inferido e outras informações
          			atualizar(tipo_inferido, $1.label, "", "", "", s.rows_label, s.cols_label, true); 
          			s.tipo = tipo_inferido; // Atualiza a cópia local para o passo seguinte
      			} else {
          			// --- AJUSTE: VERIFICAÇÃO DE TIPO E CAST IMPLÍCITO ---
          			if (tipofinal[s.tipo][rhs_attrs.tipo] == "erro") {
               			yyerror("Erro de tipo: A matriz '" + $1.label + "' eh do tipo " + s.tipo + " e nao pode receber uma atribuicao do tipo " + rhs_attrs.tipo);
          			}
          
          			// Cria um atributo temporário para representar o tipo de destino (o tipo da matriz)
          			atributos lhs_attrs;
          			lhs_attrs.tipo = s.tipo;
          			lhs_attrs.label = s.label; // Não é estritamente necessário para o cast, mas é bom ter

          			// Chama o cast_implicito para ajustar o valor da direita (rhs_attrs) se necessário
          			// A função cast_implicito já adiciona a tradução do cast em 'traducaoTemp'.
          			traducaoTemp = "";
          			traducaoTemp = cast_implicito(&$$, &lhs_attrs, &rhs_attrs, "atribuicao");
          			$$.traducao += traducaoTemp;
      			}

      			// --- LÓGICA DE CÁLCULO DE ÍNDICE E ATRIBUIÇÃO (Usa o rhs_attrs possivelmente modificado pelo cast) ---
      			string temp_index = gentempcode();
      			declarar("int", temp_index, -1);

      			$$.traducao += "\t" + temp_index + " = " + $3.label + " * " + s.cols_label + " + " + $6.label + ";\n";
      			$$.traducao += "\t" + s.label + "[" + temp_index + "] = " + rhs_attrs.label + ";\n"; // Usa o label do rhs
			}
			| TK_ID OP_ATRIBUICAO E
			{
				// 1. Buscar a variável do lado esquerdo (LHS)
           		Simbolo lhs_var = buscar($1.label);
           		if (!lhs_var.tipado) {
               		yyerror("Erro Semantico: Variavel '" + $1.label + "' usada em operacao composta antes de ser tipada.");
           		}

           		// 2. Tratar concatenação de strings com +=
           		if (lhs_var.tipo == "string" && $2.label == "+") {
               		if ($3.tipo != "string") {
                   		yyerror("Erro Semantico: Operador '+=' em uma string requer outra string como operando.");
               		}
               
               		string novo_tamanho_label = gentempcode();
               		declarar("int", novo_tamanho_label, -1);
               
               		// Código para calcular o novo tamanho necessário e realocar a memória do LHS
               		$$.traducao = $3.traducao; // Código da expressão do lado direito
               		$$.traducao += "\t" + novo_tamanho_label + " = strlen(" + lhs_var.label + ") + strlen(" + $3.label + ") + 1;\n";
               		$$.traducao += "\t" + lhs_var.label + " = (char*) realloc(" + lhs_var.label + ", " + novo_tamanho_label + ");\n";
               		$$.traducao += "\tstrcat(" + lhs_var.label + ", " + $3.label + ");\n";

               		// Atualizar o tamanho na tabela de símbolos (opcional, mas bom para consistência)
               		atualizar(lhs_var.tipo, $1.label, novo_tamanho_label, "", lhs_var.label, "", "", false);

           		} else { // 3. Tratar operações aritméticas
               
               		// Verificação de tipo para a operação
               		if (tipofinal[lhs_var.tipo][$3.tipo] == "erro" || tipofinal[lhs_var.tipo][$3.tipo] == "string") {
                   		yyerror("Operador '" + $2.label + "=' com tipos incompativeis: " + lhs_var.tipo + " e " + $3.tipo);
               		}

               		// Gerar o código de três endereços que espelha a = a + b
               		$$.traducao = $3.traducao; // Primeiro, o código da expressão do lado direito
               
               		// Gera a operação e armazena em um temporário.
               		// Isso lida corretamente com as regras de promoção de tipo (ex: int + float -> float)
               		string op_result_temp = gentempcode();
               		string op_result_tipo = tipofinal[lhs_var.tipo][$3.tipo];
               		declarar(op_result_tipo, op_result_temp, -1);
               		$$.traducao += "\t" + op_result_temp + " = " + lhs_var.label + " " + $2.label + " " + $3.label + ";\n";

               		// Atribui o resultado de volta à variável original.
               		// O C lidará com o casting de atribuição (ex: float sendo truncado para int).
               		$$.traducao += "\t" + lhs_var.label + " = " + op_result_temp + ";\n";
           		}
			}
			| OPERADORES_UNARIOS
			;
INITIALIZER_SETUP : 
				  {
					g_current_matrix_initializer.clear();
				  }
				  ;
INITIALIZER : '{' INITIALIZER_SETUP ROW_LIST '}'
			;

ROW_LIST : ROW
		 | ROW_LIST ',' ROW
		 ;
ROW : '{' 
	{
		g_current_matrix_initializer.push_back({});
	}
	ELEMENT_LIST '}'
	;
ELEMENT_LIST : E
			 {
				g_current_matrix_initializer.back().push_back($1);
			 }
			 | ELEMENT_LIST ',' E
			 {
				g_current_matrix_initializer.back().push_back($3);
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

			}
			| TK_VAR TK_ID '[' E ']' '[' E ']'
			{
			  if(verificar($2.label)) {
                  yyerror("Variavel ja declarada: " + $2.label);
              }
              // Verifica se as expressões de dimensão são numéricas
              if ($4.tipo != "int" || $7.tipo != "int") {
                  yyerror("Erro Semantico: As dimensoes da matriz devem ser do tipo inteiro.");
              }

              // Adiciona o símbolo da matriz na tabela
              adicionarSimbolo($2.label); 

			  atualizar("", $2.label, "", "", "", $4.label, $7.label, true);

			  $$.traducao = $4.traducao + $7.traducao;
			  $$.label = "";
			  $$.tipo = "";
			}
			| TK_VAR TK_ID '[' E ']' '[' E ']' '=' INITIALIZER
			{
				// $2: TK_ID (nome), $4: E (linhas), $7: E (colunas), $10: INITIALIZER

          		// --- 1. Verificações Iniciais ---
          		if(verificar($2.label)) {
              		yyerror("Variavel ja declarada: " + $2.label);
          		}
          		if ($4.tipo != "int" || $7.tipo != "int") {
              		yyerror("Erro Semantico: As dimensoes da matriz devem ser do tipo inteiro constante.");
          		}
          		if (g_current_matrix_initializer.empty() || g_current_matrix_initializer[0].empty()) {
              		yyerror("Erro Semantico: Lista de inicializacao da matriz '" + $2.label + "' nao pode ser vazia.");
          		}

          		// --- 2. Verificações de Dimensão, Tipo e CASTING ---
          		int declared_rows = stoi($4.literal_value);
          		int declared_cols = stoi($7.literal_value);
          
          		if (g_current_matrix_initializer.size() != declared_rows) {
              		yyerror("Erro Semantico: Numero de linhas no inicializador (" + to_string(g_current_matrix_initializer.size()) + ") eh diferente do declarado (" + to_string(declared_rows) + ").");
          		}
          
				string inferred_type = g_current_matrix_initializer[0][0].tipo;
				string all_expressions_code;

				for (size_t i = 0; i < g_current_matrix_initializer.size(); ++i) {
					if (g_current_matrix_initializer[i].size() != declared_cols) {
						yyerror("Erro Semantico: Numero de colunas na linha " + to_string(i) + " do inicializador eh diferente do declarado (" + to_string(declared_cols) + ").");
					}
					for (size_t j = 0; j < g_current_matrix_initializer[i].size(); ++j) {
						atributos& current_elem = g_current_matrix_initializer[i][j];
						all_expressions_code += current_elem.traducao;
						
						if (inferred_type != current_elem.tipo) {
							bool cast_valido = (inferred_type == "float" && current_elem.tipo == "int") || (inferred_type == "int" && current_elem.tipo == "float");
							if (cast_valido) {
								string casted_temp_label = gentempcode();
								string c_type_for_decl = inferred_type;
								if(c_type_for_decl == "bool") c_type_for_decl = "int";
								
								declarar(inferred_type, casted_temp_label, -1);
								all_expressions_code += "\t" + casted_temp_label + " = (" + c_type_for_decl + ")" + current_elem.label + ";\n";
								current_elem.label = casted_temp_label; // ATUALIZA o label para o valor castado
							} else {
								yyerror("Erro Semantico: Tipos incompativeis na inicializacao. Esperado " + inferred_type + ", mas encontrado " + current_elem.tipo + ".");
							}
						}
					}
				}

				// --- 3. Geração de Código ---
				adicionarSimbolo($2.label);
				Simbolo s = buscar($2.label);
				atualizar(inferred_type, $2.label, "", "", "", $4.literal_value, $7.literal_value, true);
				
				string tipo_c = inferred_type;
				if (tipo_c == "bool") tipo_c = "int";
				
				declarar(tipo_c + "*", s.label, -1);

				string temp_total_size = gentempcode();
				declarar("int", temp_total_size, -1);
				$$.traducao = $4.traducao + $7.traducao;
				$$.traducao += "\t" + temp_total_size + " = " + $4.literal_value + " * " + $7.literal_value + ";\n";
				$$.traducao += "\t" + s.label + " = (" + tipo_c + "*) malloc(sizeof(" + tipo_c + ") * " + temp_total_size + ");\n";
				$$.traducao += all_expressions_code;

				for (int i = 0; i < declared_rows; ++i) {
					for (int j = 0; j < declared_cols; ++j) {
						string temp_index = gentempcode();
						declarar("int", temp_index, -1);
						string valor_label = g_current_matrix_initializer[i][j].label;
						$$.traducao += "\t" + temp_index + " = " + to_string(i) + " * " + $7.literal_value + " + " + to_string(j) + ";\n";
						$$.traducao += "\t" + s.label + "[" + temp_index + "] = " + valor_label + ";\n";
					}
				}
			}
			;


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

				declarar($$.tipo, $$.label, -1);
				
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
				$$.literal_value = $1.label;
			}
			| TK_NUM
			{
				$$.label = gentempcode();
				$$.traducao = "\t" + $$.label + " = " + $1.label + ";\n";
				$$.tipo = "int";
				declarar($$.tipo, $$.label, -1);
				$$.literal_value = $1.label;
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
                $$.id = true;				
			}
			| TK_CHAR
			{

				$$.label = gentempcode();
				$$.traducao = "\t" + $$.label + " = " + $1.label + ";\n";
				$$.tipo = "char";
				$$.tamanho = "1";
				declarar($$.tipo, $$.label, -1);
				$$.literal_value = $1.label;
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

				$$.traducao += "\t" + $$.label + " = (char *) malloc(" + $$.tamanho + " * sizeof(char));\n";

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
			| TK_ID '[' E ']' '[' E ']'
			{
			// $1: nome da matriz, $3: expr linha, $6: expr coluna
            if (!verificar($1.label)) {
            	yyerror("Erro Semantico: Matriz '" + $1.label + "' nao declarada.");
            }

            Simbolo s = buscar($1.label);
            if (!s.is_matrix) {
            	yyerror("Erro Semantico: Variavel '" + $1.label + "' nao eh uma matriz.");
            }
            if (!s.tipado) {
            	yyerror("Erro Semantico: Matriz '" + $1.label + "' usada antes de qualquer valor ser atribuido a ela.");
            }

            // Gerar código para calcular o índice linear
            string temp_index = gentempcode();
            declarar("int", temp_index, -1);

            $$.traducao = $3.traducao + $6.traducao; // Código das expressões de índice
            $$.traducao += "\t" + temp_index + " = " + $3.label + " * " + s.cols_label + " + " + $6.label + ";\n";
              
            // Gerar código para ler o valor e colocá-lo em uma nova temp
            $$.label = gentempcode();
            $$.tipo = s.tipo; // O tipo da expressão é o tipo base da matriz
            declarar($$.tipo, $$.label, -1);
            $$.traducao += "\t" + $$.label + " = " + s.label + "[" + temp_index + "];\n";
			}
			| OPERADORES_UNARIOS
            ;
OPERADORES_UNARIOS : TK_ID TK_INC
					{
						// Pós-incremento: a++
        				Simbolo variavel = buscar($1.label);
        				// Validação de tipo: só pode incrementar tipos numéricos
        				if (variavel.tipo != "int" && variavel.tipo != "float" && variavel.tipo != "char") {
            				yyerror("Erro Semantico: Operador '++' so pode ser aplicado em tipos numericos (int, float, char).");
        				}
        				if (!variavel.tipado) {
            				yyerror("Erro Semantico: Variavel '" + $1.label + "' usada em operacao antes de ser tipada.");
        				}

        				// 1. Cria um temporário para guardar o valor ORIGINAL de 'a'
        				$$.label = gentempcode();
        				$$.tipo = variavel.tipo; // O tipo da expressão é o tipo original da variável
        				declarar($$.tipo, $$.label, -1);
        
        				// 2. A tradução consiste em copiar o valor original, depois incrementar a variável
        				$$.traducao = "\t" + $$.label + " = " + variavel.label + ";\n"; // temp = a;
        				$$.traducao += "\t" + variavel.label + " = " + variavel.label + " + 1;\n"; // a = a + 1;
					}
					| TK_ID TK_DEC
					{
						// Pós-decremento: a--
        				Simbolo variavel = buscar($1.label);
        				if (variavel.tipo != "int" && variavel.tipo != "float" && variavel.tipo != "char") {
            				yyerror("Erro Semantico: Operador '--' so pode ser aplicado em tipos numericos (int, float, char).");
        				}
        				if (!variavel.tipado) {
            				yyerror("Erro Semantico: Variavel '" + $1.label + "' usada em operacao antes de ser tipada.");
        				}

        				$$.label = gentempcode();
        				$$.tipo = variavel.tipo;
        				declarar($$.tipo, $$.label, -1);
        
        				$$.traducao = "\t" + $$.label + " = " + variavel.label + ";\n"; // temp = a;
        				$$.traducao += "\t" + variavel.label + " = " + variavel.label + " - 1;\n"; // a = a - 1;
					}
					| TK_INC TK_ID
					{
						// Pré-incremento: ++a
        				Simbolo variavel = buscar($2.label);
        				if (variavel.tipo != "int" && variavel.tipo != "float" && variavel.tipo != "char") {
            				yyerror("Erro Semantico: Operador '++' so pode ser aplicado em tipos numericos (int, float, char).");
        				}
        				if (!variavel.tipado) {
            				yyerror("Erro Semantico: Variavel '" + $2.label + "' usada em operacao antes de ser tipada.");
        				}
        
        				// 1. A tradução é simplesmente a operação de incremento
        				$$.traducao = "\t" + variavel.label + " = " + variavel.label + " + 1;\n";
        
        				// 2. O resultado da expressão é a própria variável com seu novo valor
        				$$.label = variavel.label;
        				$$.tipo = variavel.tipo;
					}
					| TK_DEC TK_ID
					{
						// Pré-decremento: --a
        				Simbolo variavel = buscar($2.label);
        				if (variavel.tipo != "int" && variavel.tipo != "float" && variavel.tipo != "char") {
            				yyerror("Erro Semantico: Operador '--' so pode ser aplicado em tipos numericos (int, float, char).");
        				}
        				if (!variavel.tipado) {
            				yyerror("Erro Semantico: Variavel '" + $2.label + "' usada em operacao antes de ser tipada.");
        				}

        				$$.traducao = "\t" + variavel.label + " = " + variavel.label + " - 1;\n";
        
        				$$.label = variavel.label;
        				$$.tipo = variavel.tipo;
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
	tipofinal["string"]["char"] = "erro";
	tipofinal["char"]["string"] = "erro";
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
	if (tipo == "string") tipo = "char*";
	
	if(g_processando_escopo_global){
		if(tam_string != -1) // Quando o campo de tamanho for -1, quer dizer que não estamos declarando uma string
		{
			declaracoes_globais.push_back(tipo + " " + label + ";\n");
		}
		else
		{
			declaracoes_globais.push_back(tipo + " " + label + ";\n");
		}
	}
	else {
		if(tam_string != -1) // Quando o campo de tamanho for -1, quer dizer que não estamos declarando uma string
		{
			declaracoes_locais.push_back("\t" + tipo + " " + label +  + ";\n");
		}
		else
		{
			declaracoes_locais.push_back("\t" + tipo + " " + label + ";\n");
		}
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

void atualizar(string tipo, string nome, string tamanho, string cadeia_char, string atualiza_label, string rows, string cols, bool matrix) {

	for(int i = tabela.size() - 1; i >= 0; i--) {
		auto it = tabela[i].find(nome);
		if(!(it == tabela[i].end())) {
			if(atualiza_label != "") it->second.label = atualiza_label;
			
			if(tipo != "") {
				it->second.tipo = tipo;
				it->second.tipado = true;
			}
			it->second.tamanho = tamanho;
			it->second.vetor_string = cadeia_char;
			it->second.rows_label = rows;
			it->second.cols_label = cols;
			it->second.is_matrix = matrix;
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
