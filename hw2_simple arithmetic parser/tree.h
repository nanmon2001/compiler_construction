#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

typedef enum {
    INT_CONST, VAR_NODE, LINK_NODE, OP_NODE
} VAL_TYPE;

typedef struct tn {
    VAL_TYPE tag;
    union{
        int int_const_val;
        int var;
        struct {
            int visiting;
            struct tn *link;
        }link_node;
        struct {
            char op;
            struct tn *left, *right;
        } op_node;
    } u;
} TREE_NODE, *TN;

TN make_int_const_node (int val);
TN make_op_node (char op, TN left, TN right);
TN make_var_node (int var);
TN make_link_node (TN node);


extern TN *treelist;TN *cache;TN *link_dict; int link_cnt; int dict_size;
