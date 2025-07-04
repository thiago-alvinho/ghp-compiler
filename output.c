/*Compilador GHP*/
#include<string.h>
#include<stdlib.h>
#include<stdio.h>


int main(void) {
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

	return 0;
}
