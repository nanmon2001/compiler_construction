#ifndef TREE_H
#define TREE_H

#include "symtab.h"
#include "types.h"
#include "bucket.h"
#include "message.h"

/*typedef struct arec{
    ST_ID ar_id;
    unsigned int size;
    struct arec *next;
} AR_REC, *AR;*/

typedef struct cr {
    int val;
    char* label;
    struct cr *next;
} CASE_REC, *CR;

typedef enum {
    IFELSE, WHILELOOP, FORLOOP, SWITCHCASE
} STACKTAG;

typedef struct sr {
    STACKTAG sktag;
    char* label;
    struct sr *next;
    BOOLEAN default_on;
    CR cr;
} STACK_REC, *SR;

typedef enum {
    VAR, INTCONST, DCONST, UNOP, BINOP, FCALL, STRING
} EXPR_TAG;

typedef enum {
    ASSIGN, PLUS, MINUS, MUL, DIV, MOD, LT, GT, LE, GE, EQ, NE, BRACKET, DEF, PRE_INC, POST_INC, PRE_DEC, POST_DEC, NEGATE, POS, STAR, AMPER
} OP;
//EQ = 10, STAR =20

typedef struct dim_list {
    unsigned int dim;
    struct dim_list *next;
}DIM_LIST, *DL;

typedef struct tn {
    EXPR_TAG tag;
    TYPE type;
    struct tn *next;//not used for syntax tree building
    BOOLEAN is_array;
    BOOLEAN is_func;
    unsigned int basic;
    DL dl;
    union{
        ST_ID id;
        int int_val;
        double d_val;
        char *string;

        struct {
            int op;
            struct tn *link;
        } unop_node;
        struct {
            int op;
            struct tn *left, *right;
        } binop_node;
        struct {
            struct tn *child, *arglist;
        } fcall_node;
    } u;
} TREE_NODE, *TN;

typedef enum {ID_DECL, FUNC_DECL, REF_DECL, PTR_DECL, ARR_DECL} DECL_TAG;

typedef struct decl_nd {
	struct decl_nd * next;
	DECL_TAG tag;
	union{
		ST_ID id;
		int arr_size;
		PARAM_LIST params;
	}u;	
} DECL_ND, *DECL_ND_PTR;

typedef struct {
   TYPE type;
   unsigned int dim;
   ST_ID id;
} intr_node;

typedef struct {
   BUCKET_PTR bucket;
   DECL_ND_PTR head;
} install_node;

/* Insert ID node */
extern DECL_ND_PTR tr_insert_id(ST_ID id);

/* Insert array node. Size required */
extern DECL_ND_PTR tr_insert_array(DECL_ND_PTR head, int size);

/* Insert pointer node */
extern DECL_ND_PTR tr_insert_ptr(DECL_ND_PTR head);

/* Insert ref node */
extern DECL_ND_PTR tr_insert_ref(DECL_ND_PTR head);

/* Insert func node --delete*/
extern DECL_ND_PTR tr_insert_func(DECL_ND_PTR head);

/* Insert func node */
extern DECL_ND_PTR tr_insert_func_params(DECL_ND_PTR head, PARAM_LIST params);

/* free tree nodes */
extern void tr_free_tree(DECL_ND_PTR head);

extern TN tr_mk_int(int val);

extern TN tr_mk_double(double val);

extern TN tr_mk_id(ST_ID id);

extern TN tr_mk_str(char* str);

extern TN tr_mk_func(TN child, TN arglist);

extern TN tr_mk_unop(TN link, OP op);

extern TN tr_mk_binop(TN left, TN right, OP op, TN decl);

extern TN tr_mk_arglist(TN prev, TN next);


#endif
