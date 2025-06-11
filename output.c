/*Compilador GHP*/
#include<string.h>
#include<stdio.h>

int main(void) {
	int t3;
	int t2;
	char t5[7];
	char t4[7];
	int t6;
	int t1;
	int t7;
	int t8;
	int t9;
	int t10;
	int t12;
	int t11;
	int t13;


	t3 = 10;
	t2 = t3;
	t5[0] = 't';
	t5[1] = 'h';
	t5[2] = 'i';
	t5[3] = 'a';
	t5[4] = 'g';
	t5[5] = 'o';
	t5[6] = '\0';
	strcpy(t4, t5);
	t6 = 1;
	t1 = t6;
ROTULO_1:
	t7 = 10;
	t8 = t1 <= t7;
	t13 = !t8;
	if (t13) goto ROTULO_3;
	t12 = 20;
	t11 = t12;
	printf("%d", t1);
	printf("\n");
ROTULO_2:
	t9 = 1;
	t10 = t1 + t9;
	t1 = t10;
	goto ROTULO_1;
ROTULO_3:

	return 0;
}
