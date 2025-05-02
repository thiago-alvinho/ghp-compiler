all:
	clear
	lex lexico.l
	yacc -d sintatico.y
	g++ -o glf y.tab.c -ll
	./glf < exemplo.ghp

push:
	cd ~/compiladorGHP && git add . && git commit -m "Alteração feita" && git push