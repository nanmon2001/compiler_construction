/* Test file for the 100% level of Project Part 4 */

/* There are errors in the file. */

int (*fp)(), (*fq)();
int i, *pi;
int (*(afp[10]))();

int print1(), print2();

int f1()
{
	print1();
}

int f2()
{
	print2();
}

main()
{
	fp = f1;
	(*fp)();
	fp = f2;
	fp();
	fq = fp;
	fq();
	afp[5] = f1;
	(*(*(afp+5)))();

	/* Some errors */
	i = fp - fq;
	(*pi)();
}
