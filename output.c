/*Compilador GHP*/
#include<string.h>
#include<stdlib.h>
#include<stdio.h>


int main(void) {
	int t1;
	int t2;
	char* t3;
	char* t4;
	char* t5;
	char* t6;
	int t8;
	char** t7;
	int t11;
	int t9;
	int t12;
	int t13;
	int t14;
	int t15;
	int t10;
	int t16;
	int t17;
	int t18;
	int t19;
	int t20;
	char* t21;
	char* t22;
	int t23;
	int t24;


	t1 = 2;
	t2 = 2;
	t8 = 2 * 2;
	t7 = (char**) malloc(sizeof(char*) * t8);
	t3 = (char *) malloc(6 * sizeof(char));
	t3[0] = 'l';
	t3[1] = 'u';
	t3[2] = 'i';
	t3[3] = 'z';
	t3[4] = ',';
	t3[5] = '\0';
	t4 = (char *) malloc(7 * sizeof(char));
	t4[0] = 't';
	t4[1] = 'r';
	t4[2] = 'o';
	t4[3] = 'u';
	t4[4] = 'x';
	t4[5] = 'e';
	t4[6] = '\0';
	t5 = (char *) malloc(2 * sizeof(char));
	t5[0] = 'o';
	t5[1] = '\0';
	t6 = (char *) malloc(6 * sizeof(char));
	t6[0] = 'c';
	t6[1] = 'a';
	t6[2] = 'f';
	t6[3] = 'e';
	t6[4] = '?';
	t6[5] = '\0';
	t7[0] = (char*) malloc(sizeof(char) * 6);
	strcpy(t7[0], t3);
	t7[1] = (char*) malloc(sizeof(char) * 7);
	strcpy(t7[1], t4);
	t7[2] = (char*) malloc(sizeof(char) * 2);
	strcpy(t7[2], t5);
	t7[3] = (char*) malloc(sizeof(char) * 6);
	strcpy(t7[3], t6);
	t11 = 0;
	t9 = t11;
ROTULO_1:
	t12 = 2;
	t13 = t9 < t12;
	t24 = !t13;
	if (t24) goto ROTULO_3;
	t15 = 0;
	t10 = t15;
ROTULO_5:
	t16 = 2;
	t17 = t10 < t16;
	t23 = !t17;
	if (t23) goto ROTULO_7;
	t19 = t9 * 2;
	t20 = t19 + t10;
	t21 = t7[t20];
	printf("%s", t21);
	t22 = (char *) malloc(2 * sizeof(char));
	t22[0] = ' ';
	t22[1] = '\0';
	printf("%s", t22);
ROTULO_6:
	t18 = t10;
	t10 = t10 + 1;
	goto ROTULO_5;
ROTULO_7:
ROTULO_2:
	t14 = t9;
	t9 = t9 + 1;
	goto ROTULO_1;
ROTULO_3:

	return 0;
}
