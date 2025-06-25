/*Compilador GHP*/
#include<string.h>
#include<stdlib.h>
#include<stdio.h>


int main(void) {
	int t1;
	int t2;
	int t4;
	int t5;
	int t7;
	int t8;
	int t10;
	int t11;
	int t12;
	int* t3;
	int t13;
	int t14;
	int t15;
	int t16;
	int t17;
	int t18;
	int t19;
	int t20;
	int t21;
	int t22;
	int t23;
	int t24;
	float t25;
	float* t6;
	int t26;
	int t27;
	int t28;
	int t29;
	float t30;
	int t31;
	int t32;
	int t33;
	char t34;
	char* t9;
	int t35;
	int t36;
	int t37;
	int t38;
	char t39;
	int t40;
	int t41;
	int t42;
	int t43;
	int t44;
	int t45;
	int t46;
	int t47;
	float t48;


	t1 = 2;
	t2 = 2;
	t4 = 2;
	t5 = 2;
	t7 = 2;
	t8 = 2;
	t10 = 0;
	t11 = 0;
	t12 = 100;
	t13 = t1 * t2;
	t3 = (int*) malloc(sizeof(int) * t13);
	t14 = t10 * t2 + t11;
	t3[t14] = t12;
	t15 = 0;
	t16 = 1;
	t17 = 200;
	t18 = t15 * t2 + t16;
	t3[t18] = t17;
	t19 = 1;
	t20 = 1;
	t21 = 999;
	t22 = t19 * t2 + t20;
	t3[t22] = t21;
	t23 = 0;
	t24 = 0;
	t25 = 1.23;
	t26 = t4 * t5;
	t6 = (float*) malloc(sizeof(float) * t26);
	t27 = t23 * t5 + t24;
	t6[t27] = t25;
	t28 = 1;
	t29 = 0;
	t30 = 4.56;
	t31 = t28 * t5 + t29;
	t6[t31] = t30;
	t32 = 0;
	t33 = 0;
	t34 = 'A';
	t35 = t7 * t8;
	t9 = (char*) malloc(sizeof(char) * t35);
	t36 = t32 * t8 + t33;
	t9[t36] = t34;
	t37 = 1;
	t38 = 1;
	t39 = 'Z';
	t40 = t37 * t8 + t38;
	t9[t40] = t39;
	t41 = 1;
	t42 = 1;
	t43 = t41 * t2 + t42;
	t44 = t3[t43];
	printf("%d", t44);
	t45 = 0;
	t46 = 0;
	t47 = t45 * t5 + t46;
	t48 = t6[t47];
	printf("%f", t48);

	return 0;
}
