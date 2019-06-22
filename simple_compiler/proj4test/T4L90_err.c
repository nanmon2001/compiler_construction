/* Test file for 90% level of Project Part 4 */

/* There are errors in this file. */

int i, j, *pi, **ppi;

float f, *pf;

char c , *s1, *s2;

int ***pppi;

int ai[10], aai[10][10], aaai[10][10][10];
float af[10];
char as[10];
double ad[13], *dp;

int *(x[10]);

int print_ints(), print_chars(), print_dp(), print_ai(), print_as(),
    print_spec();

main()
{
	i = 13;
	j = 19;
	pi = &i;
	ppi = &pi;
	c = 97;

	s1 = &as[5];
	s2 = &as[9];
	i = s2 - s1;
	print_ints();

	i = &as[j] - s1;
	print_ints();

	s1 = s1 + 1;
	s2 = s2 - 3;
	print_chars();

	dp = &ad[4];
	print_dp();
	dp = dp + 1;
	print_dp();

	ppi = 2 + ppi;
	print_ints();

	j = 0;
	pi[j] = pi[j] * 4;
	print_ints();

	i = 0;
	while (i < 10) {
		ai[i+j] = i * i;
		i = i + 1;
	}
	print_ai();

	j = 0;
	i = 0;
	while (i < 10) {
		*(ai + i) = ai[i] + ai[10 - i - 1];
		i = i + 1;
	}
	print_ai();

	ai[5] = 5;
	aai[ai[5]][i - 3] = 199;
	aaai[*(ai+5)][i - 6][2] = 299;
	af[4] = 399;
	ad[12] = 499;
	print_spec();

	s1 = as;
	*s1 = 98;
	s1 = s1 + 1;
	*s1 = 108;
	s1 = s1 + 1;
	*s1 = 97;
	s1 = s1 + 1;
	*s1 = 104;
	s1 = s1 + 1;
	*s1 = 0;
	print_as();

	j = j - 1;
	s1[j] = 103;
	*as = 102;
	print_as();

	x[3] = &i;
	*x[3] = 77;
	print_ints();

	/* Some errors */
	ai[f] = 19;
	ai = &i;
	i = ai * 19;
	ai = 19;
	i = j[i];
	ai[1][2] = 19;
	i = s1 - pi;
	pi = pi + f;
	pi = 9 - pi;
	main[i] = 19;
	ai();
}
