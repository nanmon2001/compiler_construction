/*
Author: Mon-Nan How
Function that create a tree node to work with the simple arithmetic parser. "parse.y" file.
*/

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include "tree.h"
#include "y.tab.h"

void dict_resize(int size);

TN make_int_const_node (int val)
{
    TN ret;
    ret = (TN) malloc(sizeof(TREE_NODE));
    if (ret == NULL){
        fprintf(stderr, "Node memory allocate failure!");
        exit(1);
    }
    ret->tag = INT_CONST;
    ret->u.int_const_val = val;
    return ret;
}

TN make_op_node (char op, TN left, TN right)
{
    TN ret;
    ret = (TN) malloc(sizeof(TREE_NODE));
    if (ret == NULL){
        fprintf(stderr, "Node memory allocate failure!");
        exit(1);
    }
    ret->tag = OP_NODE;
    ret->u.op_node.op = op;
    ret->u.op_node.left = left;
    ret->u.op_node.right = right;
    return ret;    
}

TN make_var_node (int var)
{
    TN ret;
    ret = (TN) malloc(sizeof(TREE_NODE));
    if (ret == NULL){
        fprintf(stderr, "Node memory allocate failure!");
        exit(1);
    }
    ret->tag = VAR_NODE;
    ret->u.var = var;
    return ret;
}

TN make_link_node (TN node)
{
    
    TN ret;
    ret = (TN) malloc(sizeof(TREE_NODE));
    if (ret == NULL){
        fprintf(stderr, "Node memory allocate failure!");
        exit(1);
    }
    ret->tag = LINK_NODE;
    ret->u.link_node.link = node;
    ret->u.link_node.visiting = 0;
    if (++link_cnt > dict_size) {
        dict_resize(2*dict_size);
    }
    link_dict[link_cnt-1] = ret;
    return ret;    
}