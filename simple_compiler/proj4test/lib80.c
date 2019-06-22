/* Print "library" for 80% level of Project Part 4, CSCE 531 */

#include <stdio.h>

extern int i, j, *pi, **ppi;

extern float f, *pf;

extern char c , *s1, *s2;

print_ints()
{
    printf("i = %d; j = %d; pi-&i = %x; ppi-&pi = %x\n", i, j, pi-&i, ppi-&pi);
}

print_floats()
{
    printf("f = %e; pf-&f = %x;\n", f, pf-&f);
}
