%{
/*
Author: Mon-Nan How
*/
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include "tree.h"
#include "y.tab.h"
%}



%%

"\r\n"	{putchar('\n');}

[ \t]	{;}

[A-Za-z]	{ yylval.yyint = toupper(yytext[0]); return VAR;}

[0-9]+	{ yylval.yyint = atoi(yytext); return CONST; }

.|\n	{ return yytext[0];}

%%

int yywrap()
{
	printf("\n");
	return 1;
}

