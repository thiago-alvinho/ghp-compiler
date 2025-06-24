/*Compilador GHP*/
#include<string.h>
#include<stdio.h>

int t2;
int t1;

int main(void) {
	int t5;
	int t3;
	int t7;
	int t8;
	int t9;
	int t10;
	int t11;

	t2 = 15;
	t1 = t2;

	t5 = 2;
	t3 = t5;
ROTULO_1:
	printf("Digite o numero que deseja somar a variavel a: ");
	scanf("%d", &t7);
	t8 = t3 + t7;
	t3 = t8;
ROTULO_2:
	t9 = 5;
	t10 = t3 < t9;
	if (t10) goto ROTULO_1;
ROTULO_3:
	t11 = t3 + t1;
	t3 = t11;

	return 0;
}
