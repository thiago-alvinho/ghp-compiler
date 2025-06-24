/*Compilador GHP*/
#include<string.h>
#include<stdlib.h>
#include<stdio.h>


int main(void) {
	char* t3;
	char* t1;
	char* t4;
	char* t2;
	char* t5;


	t3 = (char *) malloc(2 * sizeof(char));
	t3[0] = 'a';
	t3[1] = '\0';
	t1 = (char *) malloc(2 * sizeof(char));
	strcpy(t1, t3);
	t4 = (char *) malloc(4 * sizeof(char));
	t4[0] = 'E';
	t4[1] = 'u';
	t4[2] = '!';
	t4[3] = '\0';
	t2 = (char *) malloc(4 * sizeof(char));
	strcpy(t2, t4);
	t5 = (char*)malloc(5);
	strcpy(t5, t2);
	strcat(t5, t1);
	free(t2);
	t2 = t5;
	printf("%s", t2);

	return 0;
}
