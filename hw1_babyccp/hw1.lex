%{
/*
Author: Mon-Nan How
Description:
baby.cpp construction practice through flex for CSCE 531.
*/
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include "my_defs.h"
#define INITIAL_HASH_SIZE 8
#define MAX_LOAD_FACTOR 2
#define SCALE_FACTOR 2

static DR get_item(const char *key);
static int insert_or_update(DR new_item);
static void mark_cycle(DR item);
static void unmark_cycle(DR item);
static int hash(const char *key);
static void insert_at_front(DR *list, DR new_item);
static DR remove_from_front(DR *list);
static void resize(int size);
DR get_id_val(DR drp);

long int_val=0;
char * str_val;
char * id;
VAL_TYPE mark_type;
boolean mark_define = 0;
boolean mark_key = 0;
int h_size;
int num_items;
DR *hash_tab;
int line_no = 1;

%}
digit [0-9]
digits {digit}+
alpha [A-Za-z_]
alnum [A-Za-z0-9_]


%%

"\r\n" {putchar('\n');}

[ \t]*"#define"[ \t]+ { mark_define = 1; }

[ \t] {	if (mark_define == 1) {}
		else {
			ECHO;
		}
	}

\n {	if ( mark_define == 1 && mark_key == 1) {
			if (mark_type == INT_CONST){
				add_int_to_dict(id,int_val);
			} 
			else if (mark_type == STR_CONST){
				add_str_to_dict(id,str_val);
			}
			else if (mark_type == ID) {
				add_id_to_dict(id,str_val);
			} 
			else {
				fprintf(stderr, "mark_type error, check flex script!");
			}		
			
		} else {
			ECHO;
		}

		str_val = NULL;
		id = NULL;
		mark_define = 0;
		mark_key = 0;
		line_no++;
   }

					
[+-]?{digits} {	if ( mark_define == 1 && mark_key == 1){
				int_val = atol(yytext);
				mark_type = INT_CONST;
		  	} 
		  	else {
				ECHO;
		  	}
		 }

\"[^"]*\" {	if ( mark_define == 1 && mark_key == 1){ 
			 		
                    str_val = (char*) malloc(yyleng+1);
                    strcpy(str_val, yytext);
			 		mark_type = STR_CONST;
		 	} 
		 	else {
		 		ECHO;
		 	}
		  }

{alnum}+ {   	
				if (mark_define == 1 && mark_key == 0) {

	                id = (char*) malloc(yyleng+1);
	                strcpy(id, yytext);
	                mark_key = 1; 
                } 
                else if ( mark_define == 1 && mark_key == 1) {
	                str_val = (char*) malloc(yyleng+1);
	                mark_type = ID;
	                strcpy(str_val, yytext);
                } 
                else {
	            	id = (char*) malloc(yyleng+1);
	                strcpy(id, yytext);
	            	DR drp;
	            	drp = get_item(yytext);
	            	if ( drp == NULL) {
                        ECHO;
                    }
                    else{
                        
                        /* Output the value if DR tag is long or string*/
                        drp = get_id_val(drp);
                        if (drp->tag == INT_CONST){
                            printf("%ld", drp->u.intconstval);
                        }
                        else if (drp->tag == STR_CONST) {
                            printf("%s", drp->u.strconstval);
                        }
                        else{
                            if (drp->in_cycle == TRUE){
                                printf("%s", drp->key);
                            }
                            else {
                                printf("%s", drp->u.idval);
                            }
                        }
                    }   
		 		}
		 }                    	
. {ECHO;} 
%%


int yywrap()
{
	return 1;
}

int main( int argc, char **argv)
{
	/*Open file and set up input*/
	++argv, --argc;
	if ( argc > 0 ) {
	   yyin = fopen( argv[0], "r" );
	}
	else {
	   yyin = stdin;
	}

	init_dict();
	yylex();
	fclose(yyin);
}


/*************************************/
/**********SUPPORT FUNCTIONS**********/
void init_dict()
{
    h_size = 0;
    hash_tab = NULL;
    resize(INITIAL_HASH_SIZE);
    num_items = 0;
}

// Add a key with an integer constant value to the dictionary
void add_int_to_dict(const char *key, long val)
{
    DR p = (DR) malloc(sizeof(DICT_REC));
    p->in_cycle = FALSE;
    p->key = key;
    p->tag = INT_CONST;
    p->u.intconstval = val;
    if (insert_or_update(p) == 0)
        fprintf(stderr, "Warning: redefinition of %s to %ld at line %d\n",
                key, val, line_no);
}

// Add a key with a string constant value to the dictionary
void add_str_to_dict(const char *key, const char *val)
{
    DR p = (DR) malloc(sizeof(DICT_REC));
    p->in_cycle = FALSE;
    p->key = key;
    p->tag = STR_CONST;
    p->u.strconstval = val;
    if (insert_or_update(p) == 0)
        fprintf(stderr, "Warning: redefinition of %s to %s at line %d\n",
                key, val, line_no);
}

// Add a key with an identifier value to the dictionary
void add_id_to_dict(const char *key, const char *val)
{
    DR p = (DR) malloc(sizeof(DICT_REC));
    p->in_cycle = FALSE;
    p->key = key;
    p->tag = ID;
    p->u.idval = val;
    if (insert_or_update(p) == 0)
        fprintf(stderr, "Warning: redefinition of %s to %s at line %d\n",
                key, val, line_no);        // redacted
}

// Output the substituted value of a defined ID to the output stream
void output_substitution(FILE *stream, const char *id)
{
        // redacted
}


/* Local routines */

/* Returns NULL if item not found */
static DR get_item(const char *key)
{

    int index = hash(key);
    DR p = hash_tab[index];
    debug1("get_item: p %s NULL\n", p==NULL?"==":"!=");
    while (p!=NULL && strcmp(key,p->key))
        p = p->next;
    return p;
}


/* Returns the number of new items inserted: 1 if new insertion; 0 otherwise */
static int insert_or_update(DR new_item)
{
    int ret;
    const char *key = new_item->key;
    int index = hash(key);
    DR p = hash_tab[index], *prev = hash_tab+index;
    debug1("insert_or_update(key=%s) called\n", new_item->key);
    while (p!=NULL && strcmp(key,p->key)) {
        prev = &p->next;
        p = p->next;//go to the next DICT_REC point
    }

    if (p == NULL) {
            /* Insertion */
        debug1("  p is NULL -- inserting at index %d\n", index);
        insert_at_front(prev, new_item);
        debug("    done\n");
        if (num_items++ > MAX_LOAD_FACTOR*h_size) {
            debug("    resizing\n");
            resize(SCALE_FACTOR*h_size);
        }
        ret = 1;
    }
    else {
            /* Update */
        debug1("  p is not NULL -- updating at index %d\n", index);
        unmark_cycle(p);
        free(remove_from_front(prev));
        insert_at_front(prev, new_item);
        ret = 0;
    }

    mark_cycle(new_item);
    debug("    cycle marked\n");
    return ret;
}

// Marks the new cycle, if there is one
static void mark_cycle(DR item)
{
    /*Base case: one node only*/
    if (item->tag != ID) {
        return;
    }
    if (get_item(item->u.idval) == NULL){
        return;
    }
    if (strcmp(item->key,item->u.idval) == 0 ) {
        item->in_cycle = TRUE;
        return;
    }
    /*Search for a cycle, mark in_cycle after visit*/
    DR temp = item;
    DR drmark = item;

    while (temp != NULL) {
        if ((temp->tag != ID) | (temp->in_cycle == TRUE) ) {
            drmark = temp;
            break;
        }
        else {
             temp->in_cycle = TRUE;
            drmark = temp;
            temp = get_item(temp->u.idval);
        }
    }
    if (temp == NULL) {
        drmark->in_cycle = FALSE;
    }

    /*Unmark the path that is not in the cycle*/
    if (strcmp(item->key,drmark->key)) {//If item == drmark, then item is a cycle, no need to unmark anything.

        temp = item;
        while ( strcmp(temp->key,drmark->key) ) {

            temp->in_cycle = FALSE;
            temp = get_item(temp->u.idval);

        }
    }
    
    return;
}


// Unmark an existing cycle
static void unmark_cycle(DR item)
{
    DR temp = item;
    while (temp->in_cycle == TRUE)
    {
        temp->in_cycle = FALSE;
        temp = get_item(temp->u.idval);
    }
}


static int hash(const char *key)
{
    int sum = 0;
    for (; *key; key++)
        sum = (37*sum + *key) % h_size;
    return sum;
}

static void insert_at_front(DR *list, DR new_item)
{
    new_item->next = *list;
    *list = new_item;
}

static DR remove_from_front(DR *list)
{
    DR ret = *list;
    *list = (*list)->next;
    return ret;
}

static void resize(int size)
{
    int i;

    DR *temp = hash_tab;
    int temp_size = h_size;

    h_size = size;
    hash_tab = (DR *) malloc(h_size * sizeof(DR));
    for (i=0; i<h_size; i++)
        hash_tab[i] = NULL;

        // This only occurs on the initial sizing, with empty dictionary
    if (temp == NULL)
        return;

    for (i=0; i<temp_size; i++)
        while (temp[i] != NULL) {
            int index = hash(temp[i]->key);
            insert_at_front(hash_tab+index, remove_from_front(temp+i));
        }
    free(temp);
}

/*RETURN DR NEED to CHECK in_cycle value, if TRUE then USE it's "key
value" INSTEAD of it's "idval"!!!!!!*/
DR get_id_val(DR drp)
{
    if ( (drp->tag == INT_CONST) | (drp->tag == STR_CONST) ) {
            return drp;
        }
        else { //Find the last id value for substitution
            DR drp_temp = (DR) malloc(sizeof(DICT_REC));
            drp_temp = drp;
            while (drp_temp != NULL){
                drp = drp_temp;
                if ( (drp->in_cycle == TRUE) | (drp->tag != ID) ) {
                    break;//id value is in cycle or not a id type value.
                }
                drp_temp = get_item(drp_temp->u.idval);
            }
            return drp;
        }
}
