/*Compilador GHP*/
#include<string.h>
#include<stdlib.h>
#include<stdio.h>

int t1(int n);

int main(void) {
	int t3;
	int t4;
	int t2;


	t3 = 5;
	t4 = t1(t3);
	t2 = t4;
	printf("%d", t2);

	return 0;
}
int t1(int t5) {
	int t6;
	int t7;
	int t8;
	int t9;
	int t10;
	int t11;
	int t12;
	int t13;
	t6 = 0;
	t7 = t5 == t6;
	t13 = !t7;
	if (t13) goto ROTULO_1;
	t8 = 1;
	return t8;
	goto ROTULO_2;
ROTULO_1:
	t9 = 1;
	t10 = t5 - t9;
	t11 = t1(t10);
	t12 = t5 * t11;
	return t12;
ROTULO_2:
}

