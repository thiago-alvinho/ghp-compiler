/*Compilador GHP*/
#include<string.h>
#include<stdlib.h>
#include<stdio.h>


int main(void) {
	int t2;
	char* t3;
	int t4;
	char* t5;
	char t6;


	t3 = malloc(256);
	fgets(t3, 256, stdin);

	t2 = 1;
	ROTULO_1:
		t6 = *t3;
		t3 = t3 + 1;
		t4 = (t6 != '\0');
		if (!t4) goto ROTULO_1_end;
		t2 = t2 + 1;
		goto ROTULO_1;
	ROTULO_1_end:
		t2 = t2 + 1;
	t5 = malloc(t2);
	strcpy(t5, t3);
	printf("%s", t5);

	return 0;
}

