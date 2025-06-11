# Define nomes para facilitar a manutenção
COMPILER_NAME = glf
SOURCE_FILE = exemplo.ghp
GENERATED_C_FILE = output.c
FINAL_EXECUTABLE = final_program
C_COMPILER = gcc

# O alvo 'all' agora executa todo o processo:
# 1. Constrói seu compilador
# 2. Gera o código C
# 3. Imprime o código C gerado
# 4. Compila o código C
# 5. Executa o programa final
all:
	@echo ">>> Limpando a tela..."
	clear

	@echo ">>> 1. Gerando o analisador lexico com Flex..."
	lex lexico.l

	@echo ">>> 2. Gerando o analisador sintatico com Bison/Yacc..."
	yacc -d sintatico.y

	@echo ">>> 3. Compilando o seu compilador ($(COMPILER_NAME))..."
	g++ -o $(COMPILER_NAME) y.tab.c -ll

	@echo "\n>>> 4. Executando seu compilador para gerar o codigo C..."
	./$(COMPILER_NAME) < $(SOURCE_FILE) > $(GENERATED_C_FILE)

	@echo "\n>>> 5. Imprimindo o codigo C intermediario gerado:"
	@echo "----------------------------------------------------"
	@cat $(GENERATED_C_FILE)
	@echo "----------------------------------------------------"

	@echo "\n>>> 6. Compilando o codigo C gerado ($(GENERATED_C_FILE))..."
	$(C_COMPILER) -o $(FINAL_EXECUTABLE) $(GENERATED_C_FILE)

	@echo "\n>>> 7. Executando o programa final ($(FINAL_EXECUTABLE)):"
	@echo "----------------------------------------------------"
	./$(FINAL_EXECUTABLE)
	@echo "\n----------------------------------------------------"


# Alvo 'clean' para remover todos os arquivos gerados durante a compilação
clean:
	@echo "Limpando arquivos gerados..."
	rm -f $(COMPILER_NAME) $(GENERATED_C_FILE) $(FINAL_EXECUTABLE) y.tab.c y.tab.h lex.yy.c

# Suas regras de push permanecem as mesmas
push:
	cd ~/compiladorGHP && git add . && git commit -m "Alteração feita" && git push

pushl:
	cd ~/ghp-compiler && git add . && git commit -m "Alteração feita" && git push

# Declara alvos que não são arquivos para que o 'make' sempre os execute
.PHONY: all clean push pushl
