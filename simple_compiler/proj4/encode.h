#ifndef ENCODE_H
#define ENCODE_H

#include "types.h"
#include "symtab.h"
#include "tree.h"
#include "message.h"
#include BACKEND_HEADER_FILE


void spit_code(ST_ID id, TYPETAG tag, int total_dim);
void code_alloc(ST_ID id, TYPETAG tag, int total_dim );
void assign_val(TYPE type, TN node);
void partial_assign_skip(TYPE type, int cnt);
char * en_func(ST_ID id, PARAM_LIST params);
void en_func_reduce(char * f_name, char* label);
void en_loc_code(unsigned int size);
void en_eval_expr(TN tree);
TN en_eval_tn(TN tree);

#endif
