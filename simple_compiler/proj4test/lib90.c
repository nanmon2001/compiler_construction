/* Print "library" for 90% level of Project Part 4, CSCE 531 */

#include <stdio.h>

extern int i, j, *pi, **ppi;

extern float f, *pf;

extern char c , *s1, *s2;

print_ints()
{
    printf("i = %d; j = %d; pi-&i = %x; ppi-&pi = %x\n",
           i, j, pi-&i, ppi-&pi);
}

print_floats()
{
    printf("f = %e; pf = %x;\n", f, (int) pf);
}


extern int ai[10], aai[10][10], aaai[10][10][10];
extern float af[10];
extern char as[10];
extern double ad[13], *dp;

print_chars()
{
    printf("c = %d; s1-as = %x; s2-as = %x\n", c, s1-as, s2-as);
}

print_dp()
{
    printf("dp-ad = %x;\n", dp-ad);
}

print_ai()
{
    for (i = 0; i < 10; i++)
        printf(" %d", ai[i]);
    printf("\n");
}

print_spec()
{
    printf("aai[5][7] = %d; aaai[5][4][2] = %d;\n", aai[5][7], aaai[5][4][2]);
    printf("af[4] = %e; ad[12] = %e;\n", af[4], ad[12]);
}

print_as()
{
    printf("as is '%s'\n", as);
}

