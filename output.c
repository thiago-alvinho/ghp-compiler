/*Compilador GHP*/
#include<string.h>
#include<stdlib.h>
#include<stdio.h>


int main(void) {
	int t1;
	int t2;
	int t4;
	int t5;
	char* t6;
	char** t3;
	int t7;
	int t8;
	int t9;
	int t10;
	int t11;
	char* t12;
	int t13;
	int t14;
	int t15;
	int t16;
	int t17;
	int t18;
	char* t19;
	char* t20;
	int t21;
	int t22;
	int t23;
	int t24;
	char* t25;


	t1 = 1;
	t2 = 2;
	t4 = 0;
	t5 = 0;
	t6 = (char *) malloc(4 * sizeof(char));
	t6[0] = 'o';
	t6[1] = 'l';
	t6[2] = 'a';
	t6[3] = '\0';
	t7 = t1 * t2;
	t3 = (char**) malloc(sizeof(char*) * t7);
	t8 = t4 * t2;
	t9 = t8 + t5;
	t3[t9] = (char*) malloc(sizeof(char) * 4);
	strcpy(t3[t9], t6);
	t10 = 0;
	t11 = 1;
	t12 = (char *) malloc(6 * sizeof(char));
	t12[0] = 'm';
	t12[1] = 'u';
	t12[2] = 'n';
	t12[3] = 'd';
	t12[4] = 'o';
	t12[5] = '\0';
	t13 = t10 * t2;
	t14 = t13 + t11;
	t3[t14] = (char*) malloc(sizeof(char) * 6);
	strcpy(t3[t14], t12);
	t15 = 0;
	t16 = 0;
	t17 = t15 * t2;
	t18 = t17 + t16;
	t19 = t3[t18];
	printf("%s", t19);
	t20 = (char *) malloc(2 * sizeof(char));
	t20[0] = ' ';
	t20[1] = '\0';
	printf("%s", t20);
	t21 = 0;
	t22 = 1;
	t23 = t21 * t2;
	t24 = t23 + t22;
	t25 = t3[t24];
	printf("%s", t25);

	return 0;
}
