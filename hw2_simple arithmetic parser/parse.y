/*
Author: Mon-Nan How
Simple arithmetic parser.
 */


%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include "tree.h"
#define YYDEBUG 1
#define INITIAL_LIST_SIZE 8
#define SCALE_FACTOR 2
int  yylex();

void yyerror(char *s);
void print_welcome();
int  get_val(int);
void set_val(int, int);
int eval (TN t);

static void init_list();
static void resize(int size);
static void add_tree(TN new_item, int line_index);
static void clear_cache();
void dict_resize(int size);

int line_no = 1;
TN *treelist;
TN *cache;
int l_size;
int num_items;

TN *link_dict;
int link_cnt = 0;
int dict_size;
int temp;

%}

%union {
    int yyint;
    TN yytree;
}
%token <yyint> CONST VAR 
%type <yyint> assign
%type <yytree> expr term factor atom


%%
session
    : { print_welcome(); printf("%4d: ",line_no); init_list();}
      eval
    ;

eval
    : eval line         {}
    | /* empty */       
    ;

line
    : assign '\n'       {printf("%d\n", $1); printf("%4d: ",++line_no); }
    ;

assign
    : VAR '=' expr      { temp = eval($3); $$ = temp; set_val($1, temp);clear_cache(); ;add_tree($3, line_no);}
    | expr              { temp = eval($1); $$ = temp; add_tree($1, line_no); cache[line_no-1] = make_int_const_node(temp);}
    ;

expr
    : term              
    | '+' term          { $$ = $2;}
    | '-' term          { $$ = make_op_node('-',make_int_const_node(0),$2);}
    | expr '+' term     { $$ = make_op_node('+',$1, $3); }
    | expr '-' term     { $$ = make_op_node('-',$1, $3); }
    ;

term
    : factor
    | term '*' factor       { $$ = make_op_node('*',$1, $3); }
    | term '/' factor       { $$ = make_op_node('/',$1, $3); }
    | term '%' factor       { $$ = make_op_node('%',$1, $3); }
    ;

factor
    : atom
    | '#' factor         { $$ = make_link_node($2); }
    ;

atom
    : CONST             { $$ = make_int_const_node($1); }
    | VAR               { $$ = make_var_node($1); }
    | '(' expr ')'      { $$ = $2; }
    ;    
%%

void yyerror(char *s)
{
    fprintf(stderr, "%s\n", s);
}

void print_welcome()
{
    printf("Welcome to the Simple Expression Evaluator.\n");
    printf("Enter one expression per line, end with ^D\n\n");
}

static int val_tab[26];

int get_val(int v)
{
    return val_tab[v - 'A'];
}

void set_val(int v, int val)
{
    val_tab[v - 'A'] = val;
}

int eval (TN t)
{
    int left_val, right_val;
    int index;
    int cache_val;

    switch (t->tag) {
        case INT_CONST:
            return t->u.int_const_val;
        case VAR_NODE:
            return get_val(t->u.var);
        case LINK_NODE:
            if (t->u.link_node.visiting == 1){
                fprintf(stderr, "circular reference found\n");
                exit(1);
            }
            t->u.link_node.visiting = 1;
            index = eval(t->u.link_node.link);
            if (index < 1 | index > num_items){
                fprintf(stderr, "index %d out of range\n",index );
                exit(1);
            }
            if (cache[index-1] != NULL){
                return eval(cache[index-1]);
            }
            cache_val = eval(treelist[index-1]);
            cache[index-1] = make_int_const_node (cache_val);
            return cache_val;
        case OP_NODE:
            left_val = eval(t->u.op_node.left);
            right_val = eval(t->u.op_node.right);
            switch (t->u.op_node.op){
                case '+':
                    return left_val+right_val;
                case '-':
                    return left_val-right_val;
                case '*':
                    return (left_val*right_val);
                case '/':
                    return (left_val/right_val);
                case '%':
                    return (left_val%right_val);
                default:
                    fprintf(stderr, "Unrecognize operator!");
            }
    }
}

static void init_list()
{
    l_size = 0;
    dict_size = 0;
    treelist = NULL;
    cache = NULL;
    link_dict = NULL;
    resize(INITIAL_LIST_SIZE);
    dict_resize(INITIAL_LIST_SIZE);
    num_items = 0;
    link_cnt = 0;

}

/*Resize the treelist table and the cache simultaneously, because the they should have the same number of items. Cache saves the root value of a tree after a variable assignement */
static void resize(int size)
{
    int i;
    TN *temp = treelist;
    int temp_size = l_size;
    TN *temp_cache = cache;

    l_size = size;
    treelist = (TN *) malloc(l_size * sizeof(TN));
    cache = (TN *) malloc(l_size * sizeof(TN));

    for (i=0; i<l_size; i++) {
        treelist[i] = NULL;
        cache[i] = NULL;
    }
        // This only occurs on the initial sizing, with empty list
    if (temp == NULL)
        return;
    
    for (i=0; i<temp_size; i++) {
        if (temp[i] != NULL) {
            treelist[i] = temp[i];
        }
        if (temp_cache[i] != NULL) {
            cache[i] = temp_cache[i];
        }
    }
    free(temp);
    free(temp_cache);
}

/*add a syntax tree to the list*/
static void add_tree(TN new_item, int line_index)
{
    
    if (line_index<1) {
        fprintf(stderr, "Insert to treelist out of range!");
        exit(1);
    }

    if (++num_items > l_size) {
        resize(SCALE_FACTOR*l_size);
    }

    treelist[line_index-1] = new_item;
}


static void clear_cache() {
    int i;
    for (i = 0; i<num_items; i++){
        cache[i] = NULL;
    }
    for (i = 0; i<link_cnt; i++){
        if (link_dict[i] != NULL){
            link_dict[i]->u.link_node.visiting = 0;
        }
    }
}

void dict_resize(int size)
{
    int i;
    TN *temp = link_dict;
    int temp_size = dict_size;

    dict_size = size;
    link_dict = (TN *) malloc(dict_size*sizeof(TN));

    for (i=0; i<dict_size; i++) {
        link_dict[i] = NULL;
    }
        // This only occurs on the initial sizing, with empty list
    if (temp == NULL)
        return;
    
    for (i=0; i<temp_size; i++) {
        if (temp[i] != NULL) {
            link_dict[i] = temp[i];
        }
    }
    free(temp);
}