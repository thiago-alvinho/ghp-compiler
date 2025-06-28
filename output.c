/*Compilador GHP*/
#include<string.h>
#include<stdlib.h>
#include<stdio.h>


int main(void) {
	int t1;
	int t2;
	float t3;
	float t4;
	int t5;
	int t6;
	float t7;
	float t8;
	float* t9;
	int t10;
	int t11;
	int t12;
	int t13;
	int t14;


	t1 = 2;
	t2 = 2;
	t10 = 2 * 2;
	t9 = (float*) malloc(sizeof(float) * t10);
	t3 = 2.5;
	t4 = 2.5;
	t5 = 3;
	t7 = (float)t5;
	t6 = 4;
	t8 = (float)t6;
	t11 = 0 * 2 + 0;
	t9[t11] = t3;
	t12 = 0 * 2 + 1;
	t9[t12] = t4;
	t13 = 1 * 2 + 0;
	t9[t13] = t7;
	t14 = 1 * 2 + 1;
	t9[t14] = t8;

	return 0;
}
