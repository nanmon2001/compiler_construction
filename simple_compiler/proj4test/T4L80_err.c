/* Test file for 80% level of Project Part 4 */

/* There are errors in this file. */

int i, j, *pi, **ppi;

float f, *pf;

char c , *s1, *s2;

int ***pppi;

int print_ints(), print_floats();

main()
{
	i = 19;
	j = 28;
	pi = &i;
	ppi = &pi;
	j = i + *pi;
	print_ints();
	*pi = j;
	print_ints();
	j = *pi * **ppi;
	print_ints();

	f = 199;
	pf = &f;
	*pf = *pf / (*pf + 1);
	print_floats();

	*&i = *&i + 1;
	print_ints();

	c = 97;
	s1 = &c;
	s2 = s1;
	i = *s1 + *s2 + *pi;
	print_ints();

	s1 = 0;
	i = (s1 > s2);
	j = (s1 < s2);
	print_ints();

	i = (s2 == 0);
	print_ints();

	**ppi = 123;
	print_ints();

	pppi = &ppi;
	***pppi = 257;
	print_ints();

	/* Some errors */
	pf = &j;
	&i = 19;
	*i = 19;
	s1 = &main;
	*main = 19;
	pi = &16;
	pi = &(i+j);
	i = *(i+j);
	i = (pf > pi);
	pf = pi;
	i = pi * j;
	i = j *pi;
	pi = i;
	pi = main;
	pi();
	*ppi = 17;
	*****pppi = 19;
}
