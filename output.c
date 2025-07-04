/*Compilador GHP*/
#include<string.h>
#include<stdlib.h>
#include<stdio.h>

int t1(int n);

int main(void) {
<<<<<<< HEAD
	int t3;
	int t4;
	int t2;


	t3 = 5;
	t4 = t1(t3);
	t2 = t4;
	printf("%d", t2);
=======
	char* t1;
	char* t2;
	char* t3;
	char* t4;
	char* t5;


	t1 = (char *) malloc(7 * sizeof(char));
	t1[0] = 'T';
	t1[1] = 'h';
	t1[2] = 'i';
	t1[3] = 'a';
	t1[4] = 'g';
	t1[5] = 'o';
	t1[6] = '\0';
	t2 = (char *) malloc(7 * sizeof(char));
	strcpy(t2, t1);
	t3 = (char *) malloc(5 * sizeof(char));
	t3[0] = 'L';
	t3[1] = 'u';
	t3[2] = 'i';
	t3[3] = 'z';
	t3[4] = '\0';
	t4 = (char *) malloc(5 * sizeof(char));
	strcpy(t4, t3);
	t5 = (char*)malloc(11);
	strcpy(t5, t2);
	strcat(t5, t4);
	free(t2);
	t2 = t5;
	printf("%s", t2);
>>>>>>> origin/main

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

