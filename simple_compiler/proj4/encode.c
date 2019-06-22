#include "encode.h"

void spit_code(ST_ID id, TYPETAG tag, int total_dim )
{
    unsigned int size = get_size_basic(tag);
    b_global_decl(st_get_id_str(id), size, total_dim* size);
	b_skip(total_dim * size);
	return;
}

void code_alloc(ST_ID id, TYPETAG tag, int total_dim )
{
    unsigned int size = get_size_basic(tag);
    b_global_decl(st_get_id_str(id), size, total_dim* size);
    return;
}

void assign_val(TYPE type, TN node)
{
    TYPETAG tag = ty_query(type);
    while (tag == TYARRAY){
        DIMFLAG dimflag;
        unsigned int dim;
        type = ty_query_array(type, &dimflag, &dim);
        tag = ty_query(type);
    }
    switch (tag) {
        case TYFLOAT:
            if (node->tag != DCONST){
                error("type mismatch in initializer");
                return;
            }
            else{
                b_alloc_gdata(tag, node->u.d_val);
                return;
            }
        case TYDOUBLE:
            if (node->tag != DCONST){
                error("type mismatch in initializer");
                return;
            }
            else{
                b_alloc_gdata(tag, node->u.d_val);
                return;
            }
        case TYSIGNEDINT:
            if (node->tag != INTCONST){
                error("type mismatch in initializer");
                return;
            }
            else{
                b_alloc_gdata(tag, node->u.int_val);
                return;
            }
        case TYSIGNEDCHAR:
            if (node->tag != INTCONST){
                error("type mismatch in initializer");
                return;
            }
            else{
                b_alloc_gdata(tag, node->u.int_val);
                return;
            }
        case TYPTR:
            if (node->tag!= INTCONST || node->u.int_val != 0){
                error("type mismatch in initializer");
                return;
            }
            else{
                b_alloc_gdata(tag, "0");
                return;
            }
        default:
            error("type mismatch in initializer");
            return;
    }
}

void partial_assign_skip(TYPE type, int cnt)
{
    TYPETAG tag = ty_query(type);
    //if tag == TYARRAY then no need to skip
    if (tag == TYFLOAT || tag == TYSIGNEDINT || tag == TYSIGNEDINT){
        unsigned int size = get_size_basic(tag);
        b_skip(cnt * size); 
        return;
    }

    unsigned int total_dim = 1;
    while (tag == TYARRAY){
        DIMFLAG dimflag;
        unsigned int dim;
        type = ty_query_array(type, &dimflag, &dim);
        total_dim *= dim;
        tag = ty_query(type);
    }
    if (tag == TYFLOAT || tag == TYSIGNEDINT || tag == TYSIGNEDINT){
        unsigned int size = get_size_basic(tag);
        b_skip(cnt * size *total_dim); 
    }
    return;
}

BOOLEAN install_params(ST_ID id, TYPE type, int offset) {
    ST_DR st_dr = stdr_alloc();
    st_dr->tag = PDECL;
    st_dr->u.decl.type = type;
    st_dr->u.decl.sc = NO_SC;
    st_dr->u.decl.binding = offset;
    if (st_install(id, st_dr) == FALSE) {
        error("duplicate declaration for %s", st_get_id_str(id));
        error("duplicate definition of `%s'", st_get_id_str(id));
        return FALSE;
    }
    return TRUE;
}

char * en_func(ST_ID id, PARAM_LIST params)
{
    char *f_name = st_get_id_str(id);
    int offset;

    b_func_prologue(f_name);

    //intall the params into symtab
    ST_ID param_id;
    TYPE param_type;
    TYPETAG tag;
    while (params != NULL){
        tag = ty_query(params->type);

        //check params type, only handles: int, char, float, double
        if (tag != TYSIGNEDINT | tag != TYFLOAT | tag != TYDOUBLE | tag != TYSIGNEDCHAR){
            error("Unexpected param type!");
            return f_name;
        }
        offset = b_store_formal_param(tag);
        install_params( params->id, params->type, offset);
        params = params->next;
    }
    return f_name;
}

/* function definition reduce action */
void en_func_reduce(char * f_name, char* label)
{
    b_label(label);
    b_func_epilogue(f_name);
    st_exit_block();
    //last action, reset error count
    compiler_errors = 0;
    return;
}

void en_loc_code(unsigned int size)
{
    unsigned int align_size = size + (8-(size % 8));
    b_alloc_local_vars(align_size);
    return;
}

/*********************************************
* Evaluate syntax tree functions
**********************************************/
TN eval_unop(TN tree);
TN eval_binop(TN tree);
TN eval_func(TN tree);
void arith_eval(TN left_tn, TN right_tn, B_ARITH_REL_OP x);


TN eval_unop(TN tree)
{   
    OP op = tree->u.unop_node.op;
    TN link = tree->u.unop_node.link;
    TYPETAG type_tag = ty_query(tree->type);
    TYPETAG temp_tag;
    TYPE temp_type;
    TYPE_QUALIFIER qual;
    int block;
    ST_DR st_dr;
    while (temp_tag == TYPTR | temp_tag == TYARRAY){
        if (temp_tag == TYPTR){
            temp_type = link->type;
            temp_tag = type_tag;
            while(temp_tag == TYPTR){
                temp_type = ty_query_pointer(temp_type, &qual);
                temp_tag = ty_query(temp_type);
            }
        }
        if (temp_tag == TYARRAY){
            temp_type = link->type;
            temp_tag = type_tag;
            while(temp_tag == TYARRAY){
                temp_type = ty_query_pointer(temp_type, &qual);
                temp_tag = ty_query(temp_type);
            }
        }
    }
    unsigned int size;
    //DEF, PRE_INC, POST_INC, PRE_DEC, POST_DEC, NEGATE, POS, STAR, AMPER
    switch (op){
        case DEF:
            en_eval_tn(link);

            if (type_tag == TYARRAY){
                message("DEF a TYARRAY");
                type_tag = TYPTR;
            }
            if (link->tag == VAR && link->is_array == TRUE){
                return link;
            }
            if (link->tag == VAR){
                st_dr = st_lookup(link->u.id, &block);
                if (link->is_func == TRUE && (type_tag == TYFUNC | st_dr->tag == FDECL)){
                    return link;
                }
            }
            b_deref(type_tag);
            return link;

        case PRE_INC:
            size = get_size_basic(temp_tag);
            en_eval_tn(link);
            b_inc_dec(type_tag, B_PRE_INC, size);
            return link;

        case POST_INC:
            size = get_size_basic(temp_tag);
            en_eval_tn(link);
            b_inc_dec(type_tag, B_POST_INC, size);
            return link;

        case PRE_DEC:
            size = get_size_basic(temp_tag);
            en_eval_tn(link);
            b_inc_dec(type_tag, B_PRE_DEC, size);
            return link;

        case POST_DEC:
            size = get_size_basic(temp_tag);
            en_eval_tn(link);
            b_inc_dec(type_tag, B_POST_DEC, size);
            return link;

        case NEGATE:
            en_eval_tn(link);
            if(ty_query(link->type) == TYFLOAT){
                b_convert(TYFLOAT, TYDOUBLE);
            }
            if (ty_query(link->type) == TYSIGNEDCHAR){
                b_convert(TYSIGNEDCHAR, TYSIGNEDINT);
            }
            b_negate(type_tag);
            return link;

        case POS:
            en_eval_tn(link);
            if( ty_query(link->type) == TYFLOAT){
                b_convert(TYFLOAT, TYDOUBLE);
            }
            if ( ty_query(link->type) == TYSIGNEDCHAR){
                b_convert(TYSIGNEDCHAR, TYSIGNEDINT);
            }
            return link;

        case STAR:
            if (link->tag == UNOP && link->u.unop_node.op == AMPER){
                //i = *&i
                en_eval_tn(link->u.unop_node.link);
                return link;
            }
            else{
                en_eval_tn(link);
                type_tag = ty_query(link->type);
                if (type_tag == TYARRAY){
                    message("DEF a TYARRAY");
                    type_tag = TYPTR;
                }
                if (link->tag == BINOP){
                    return link;
                }
                if (link->is_array == TRUE && link->tag == VAR){
                    return link;
                }
                b_deref(type_tag);
                return link;
            }

        case AMPER:
            en_eval_tn(link);
            return link;

        default:
            error("Unexpected operand in unop! %d",op);
            return NULL;
    }
}

void arith_eval(TN left_tn, TN right_tn, B_ARITH_REL_OP x)
{   
    TYPETAG l_tag, r_tag, f_tag;
    l_tag = ty_query(left_tn->type);
    r_tag = ty_query(right_tn->type);
    TYPE left, right;
    PARAMSTYLE paramstyle;
    PARAM_LIST params;
    //change tag for TYFUNC
    if (l_tag == TYFUNC){
        left = ty_query_func(left_tn->type, &paramstyle, &params);
        l_tag = ty_query(left);
    }
    if (r_tag == TYFUNC){
        right = ty_query_func(right_tn->type, &paramstyle, &params);
        r_tag = ty_query(right);
    }
    //start generate assembly code
    if (r_tag == TYDOUBLE){
        en_eval_tn(right_tn);
        if (right_tn->tag == UNOP && right_tn->u.unop_node.op == STAR){
            b_deref(r_tag);
        }
        f_tag = TYDOUBLE;
    }
    else if (r_tag == TYFLOAT){
        en_eval_tn(right_tn);
        if (right_tn->tag == UNOP && right_tn->u.unop_node.op == STAR){
            b_deref(r_tag);
        }
        b_convert(TYFLOAT, TYDOUBLE);
        f_tag = TYDOUBLE;
    }
    else if (r_tag == TYSIGNEDINT){
        en_eval_tn(right_tn);
        if (right_tn->tag == UNOP && right_tn->u.unop_node.op == STAR){
            b_deref(r_tag);
        }
        if (l_tag == TYFLOAT | l_tag == TYDOUBLE){
            b_convert(TYSIGNEDINT, TYDOUBLE);
            f_tag = TYDOUBLE;
        }
        else{
            f_tag = TYSIGNEDINT;
        }  
    }
    else if (r_tag == TYSIGNEDCHAR){
        en_eval_tn(right_tn);
        if (right_tn->tag == UNOP && right_tn->u.unop_node.op == STAR){
            b_deref(r_tag);
        }
        b_convert(TYSIGNEDCHAR, TYSIGNEDINT);
        f_tag = TYSIGNEDINT;
        if (l_tag == TYFLOAT | l_tag == TYDOUBLE){
            b_convert(TYSIGNEDINT, TYDOUBLE);
            f_tag = TYDOUBLE;
        }
    }
    else{
        error("Unexpected type in expression!");
        return;
    }
    if (right_tn->tag == VAR){
        b_deref(r_tag);
    }
    b_arith_rel_op(x, f_tag);
    return;   
}


//LT, GT, LE, GE, EQ, NE
TN eval_binop(TN tree)
{
    //Initialize setting
    OP op = tree->u.binop_node.op;
    TN left = tree->u.binop_node.left , right = tree->u.binop_node.right;
    TYPETAG r_tag, l_tag, f_tag;
    l_tag = ty_query(left->type);
    r_tag = ty_query(right->type);
    TYPE temp_type;
    TYPE_QUALIFIER qual;
    PARAMSTYLE paramstyle;
    PARAM_LIST params;
    if (l_tag == TYPTR){
        temp_type = left->type;
        f_tag = l_tag;
        while(f_tag == TYPTR){
            temp_type = ty_query_pointer(temp_type, &qual);
            f_tag = ty_query(temp_type);
        }
    }
    if (r_tag == TYPTR){
        temp_type = right->type;
        f_tag = r_tag;
        while(f_tag == TYPTR){
            temp_type = ty_query_pointer(temp_type, &qual);
            f_tag = ty_query(temp_type);
        }
    }
    if (f_tag == TYFUNC){
        temp_type = ty_query_func(temp_type, &paramstyle, &params);
        f_tag = ty_query(temp_type);
    }
    unsigned int size;

    //Start generating assembly code
    switch (op){
        case ASSIGN:
            en_eval_tn(left);
            en_eval_tn(right);
            if (right->tag == UNOP && right->u.unop_node.op == STAR){
                b_deref(r_tag);
            }
            if(right->tag == VAR && right->is_func == TRUE){
                b_deref(r_tag);
            }
            if (l_tag!=r_tag){
                b_convert(r_tag, l_tag);
            }
            b_assign(l_tag);
            return tree;
            //B_ADD, B_SUB, B_MULT, B_DIV, B_MOD, B_LT, B_LE, B_GT, B_GE, B_EQ, B_NE } B_ARITH_REL_OP;
            //b_ptr_arith_op (B_ARITH_REL_OP arop, TYPETAG type, unsigned int size);
        case PLUS:
            if ( l_tag == TYPTR | l_tag == TYARRAY){
                size = get_size_basic(f_tag);
                en_eval_tn(left);
                if (left->tag == VAR && left->is_array != TRUE){
                    b_deref(TYPTR);
                }
                en_eval_tn(right);
                if (right->tag == VAR){
                    if (right->is_array != TRUE) {
                        b_deref(r_tag);
                    }
                }
                if (right->tag == UNOP && right->u.unop_node.op == STAR){
                    b_deref(r_tag);
                }
                if (f_tag != TYSIGNEDINT){//pointer arith only accepts int and ptr
                    f_tag = TYSIGNEDINT;
                }
                if (left->is_array == TRUE){
                    size *= left->basic;
                }
                b_ptr_arith_op (B_ADD, f_tag, size);
                return tree;
            }
            if ( r_tag == TYPTR | r_tag == TYARRAY){
                size = get_size_basic(f_tag);
                en_eval_tn(right);
                if (right->tag == VAR && right->is_array != TRUE){
                    b_deref(TYPTR);
                }
                en_eval_tn(left);
                if (left->tag == VAR){
                    if (left->is_array != TRUE){
                        b_deref(l_tag);
                    }
                }
                if (left->tag == UNOP && left->u.unop_node.op == STAR){
                    b_deref(l_tag);
                }
                if (f_tag != TYSIGNEDINT){
                    f_tag = TYSIGNEDINT;
                }
                if (right->is_array == TRUE){
                    size *= right->basic;
                }
                b_ptr_arith_op (B_ADD, f_tag, size);
                return tree;
            }
            en_eval_tn(left);
            if (left->tag == VAR && left->is_array != TRUE){
                b_deref(l_tag);
            }
            if(left->tag == UNOP && left->u.unop_node.op == STAR){
                b_deref(l_tag);
            }
            if (l_tag == TYFLOAT){
                b_convert(TYFLOAT, TYDOUBLE);
            }
            if (l_tag == TYSIGNEDCHAR){
                b_convert(TYSIGNEDCHAR, TYSIGNEDINT);
            }
            arith_eval(left, right, B_ADD);
            return tree;

        case MINUS:
            if ( l_tag == TYPTR | l_tag == TYARRAY){
                size = get_size_basic(f_tag);
                en_eval_tn(left);
                if (left->tag == VAR && left->is_array != TRUE){
                    b_deref(TYPTR);
                }
                en_eval_tn(right);
                if (right->tag == VAR && left->is_array != TRUE){
                    b_deref(r_tag);
                }
                if (f_tag != TYSIGNEDINT){//pointer arith only accepts int and ptr
                    f_tag = TYSIGNEDINT;
                }
                if (r_tag == TYPTR){
                    f_tag = TYPTR;
                }
                if (left->is_array == TRUE){
                    size *= left->basic;
                }
                b_ptr_arith_op (B_SUB, f_tag, size);
                return tree;
            }
            if ( r_tag == TYPTR | r_tag == TYARRAY){
                size = get_size_basic(f_tag);
                en_eval_tn(right);
                if (right->tag == VAR && left->is_array != TRUE){
                    b_deref(TYPTR);
                }
                en_eval_tn(left);
                if (left->tag == VAR && left->is_array != TRUE){
                    b_deref(l_tag);
                }
                if (f_tag != TYSIGNEDINT){
                    f_tag = TYSIGNEDINT;
                }
                if (right->is_array == TRUE){
                    size *= right->basic;
                }
                b_ptr_arith_op (B_SUB, f_tag, size);
                return tree;
            }
            en_eval_tn(left);
            if (left->tag == VAR && left->is_array != TRUE){
                b_deref(l_tag);
            }
            if(left->tag == UNOP && left->u.unop_node.op == STAR){
                b_deref(l_tag);
            }
            if (l_tag == TYFLOAT){
                b_convert(TYFLOAT, TYDOUBLE);
            }
            if (l_tag == TYSIGNEDCHAR){
                b_convert(TYSIGNEDCHAR, TYSIGNEDINT);
            }
            arith_eval(left, right, B_SUB);
            return tree;

        case MUL:
            en_eval_tn(left);
            if (left->tag == VAR && left->is_array != TRUE){
                b_deref(l_tag);
            }
            if(left->tag == UNOP && left->u.unop_node.op == STAR){
                b_deref(l_tag);
            }
            if (l_tag == TYFLOAT){
                b_convert(TYFLOAT, TYDOUBLE);
            }
            if (l_tag == TYSIGNEDCHAR){
                b_convert(TYSIGNEDCHAR, TYSIGNEDINT);
            }
            arith_eval(left, right, B_MULT);
            return tree;
        case DIV:
            en_eval_tn(left);
            if (left->tag == VAR && left->is_array != TRUE){
                b_deref(l_tag);
            }
            if(left->tag == UNOP && left->u.unop_node.op == STAR){
                b_deref(l_tag);
            }
            if (l_tag == TYFLOAT){
                b_convert(TYFLOAT, TYDOUBLE);
            }
            if (l_tag == TYSIGNEDCHAR){
                b_convert(TYSIGNEDCHAR, TYSIGNEDINT);
            }
            arith_eval(left, right, B_DIV);
            return tree;

        case MOD:
            en_eval_tn(left);
            if (left->tag == VAR && left->is_array != TRUE){
                b_deref(l_tag);
            }
            if(left->tag == UNOP && left->u.unop_node.op == STAR){
                b_deref(l_tag);
            }
            if (l_tag == TYFLOAT){
                b_convert(TYFLOAT, TYDOUBLE);
            }
            if (l_tag == TYSIGNEDCHAR){
                b_convert(TYSIGNEDCHAR, TYSIGNEDINT);
            }
            arith_eval(left, right, B_MOD);
            return tree;

        case LT:
            if ( l_tag == TYPTR | l_tag == TYARRAY | r_tag == TYPTR | r_tag == TYARRAY){
                size = get_size_basic(f_tag);
                en_eval_tn(left);
                if (left->tag == VAR){
                    b_deref(l_tag);
                }
                //for case that ptr == 0
                if(left->tag == INTCONST && left->u.int_val == 0){
                    b_convert (TYSIGNEDINT, TYPTR);
                }
                en_eval_tn(right);
                if (right->tag == VAR){
                    b_deref(r_tag);
                }
                if(right->tag == INTCONST && right->u.int_val == 0){
                    b_convert (TYSIGNEDINT, TYPTR);
                }
                b_arith_rel_op(B_LT,TYPTR);
                return tree;
            }
            en_eval_tn(left);
            if (left->tag == VAR){
                b_deref(l_tag);
            }
            if(left->tag == UNOP && left->u.unop_node.op == STAR){
                b_deref(l_tag);
            }
            if (l_tag == TYFLOAT){
                b_convert(TYFLOAT, TYDOUBLE);
            }
            if (l_tag == TYSIGNEDCHAR){
                b_convert(TYSIGNEDCHAR, TYSIGNEDINT);
            }
            arith_eval(left, right, B_LT);
            return tree;

        case LE:
            if ( l_tag == TYPTR | l_tag == TYARRAY | r_tag == TYPTR | r_tag == TYARRAY){
                size = get_size_basic(f_tag);
                en_eval_tn(left);
                if (left->tag == VAR){
                    b_deref(l_tag);
                }
                //for case that ptr == 0
                if(left->tag == INTCONST && left->u.int_val == 0){
                    b_convert (TYSIGNEDINT, TYPTR);
                }
                en_eval_tn(right);
                if (right->tag == VAR){
                    b_deref(r_tag);
                }
                if(right->tag == INTCONST && right->u.int_val == 0){
                    b_convert (TYSIGNEDINT, TYPTR);
                }
                b_arith_rel_op(B_LE,TYPTR);
                return tree;
            }
            en_eval_tn(left);
            if (left->tag == VAR){
                b_deref(l_tag);
            }
            if(left->tag == UNOP && left->u.unop_node.op == STAR){
                b_deref(l_tag);
            }
            if (l_tag == TYFLOAT){
                b_convert(TYFLOAT, TYDOUBLE);
            }
            if (l_tag == TYSIGNEDCHAR){
                b_convert(TYSIGNEDCHAR, TYSIGNEDINT);
            }
            arith_eval(left, right, B_LE);
            return tree;

        case GT:
            if ( l_tag == TYPTR | l_tag == TYARRAY | r_tag == TYPTR | r_tag == TYARRAY){
                size = get_size_basic(f_tag);
                en_eval_tn(left);
                if (left->tag == VAR){
                    b_deref(l_tag);
                }
                //for case that ptr == 0
                if(left->tag == INTCONST && left->u.int_val == 0){
                    b_convert (TYSIGNEDINT, TYPTR);
                }
                en_eval_tn(right);
                if (right->tag == VAR){
                    b_deref(r_tag);
                }
                if(right->tag == INTCONST && right->u.int_val == 0){
                    b_convert (TYSIGNEDINT, TYPTR);
                }
                b_arith_rel_op(B_GT,TYPTR);
                return tree;
            }
            en_eval_tn(left);
            if (left->tag == VAR){
                b_deref(l_tag);
            }
            if(left->tag == UNOP && left->u.unop_node.op == STAR){
                b_deref(l_tag);
            }
            if (l_tag == TYFLOAT){
                b_convert(TYFLOAT, TYDOUBLE);
            }
            if (l_tag == TYSIGNEDCHAR){
                b_convert(TYSIGNEDCHAR, TYSIGNEDINT);
            }
            arith_eval(left, right, B_GT);
            return tree;

        case GE:
            if ( l_tag == TYPTR | l_tag == TYARRAY | r_tag == TYPTR | r_tag == TYARRAY){
                size = get_size_basic(f_tag);
                en_eval_tn(left);
                if (left->tag == VAR){
                    b_deref(l_tag);
                }
                //for case that ptr == 0
                if(left->tag == INTCONST && left->u.int_val == 0){
                    b_convert (TYSIGNEDINT, TYPTR);
                }
                en_eval_tn(right);
                if (right->tag == VAR){
                    b_deref(r_tag);
                }
                if(right->tag == INTCONST && right->u.int_val == 0){
                    b_convert (TYSIGNEDINT, TYPTR);
                }
                b_arith_rel_op(B_GE,TYPTR);
                return tree;
            }
            en_eval_tn(left);
            if (left->tag == VAR){
                b_deref(l_tag);
            }
            if(left->tag == UNOP && left->u.unop_node.op == STAR){
                b_deref(l_tag);
            }
            if (l_tag == TYFLOAT){
                b_convert(TYFLOAT, TYDOUBLE);
            }
            if (l_tag == TYSIGNEDCHAR){
                b_convert(TYSIGNEDCHAR, TYSIGNEDINT);
            }
            arith_eval(left, right, B_GE);
            return tree;

        case EQ:
            if ( l_tag == TYPTR | l_tag == TYARRAY | r_tag == TYPTR | r_tag == TYARRAY){
                size = get_size_basic(f_tag);
                en_eval_tn(left);
                if (left->tag == VAR){
                    b_deref(l_tag);
                }
                //for case that ptr == 0
                if(left->tag == INTCONST && left->u.int_val == 0){
                    b_convert (TYSIGNEDINT, TYPTR);
                }
                en_eval_tn(right);
                if (right->tag == VAR){
                    b_deref(r_tag);
                }
                if(right->tag == INTCONST && right->u.int_val == 0){
                    b_convert (TYSIGNEDINT, TYPTR);
                }
                b_arith_rel_op(B_EQ,TYPTR);
                return tree;
            }
            en_eval_tn(left);
            if (left->tag == VAR){
                b_deref(l_tag);
            }
            if(left->tag == UNOP && left->u.unop_node.op == STAR){
                b_deref(l_tag);
            }
            if (l_tag == TYFLOAT){
                b_convert(TYFLOAT, TYDOUBLE);
            }
            if (l_tag == TYSIGNEDCHAR){
                b_convert(TYSIGNEDCHAR, TYSIGNEDINT);
            }
            arith_eval(left, right, B_EQ);
            return tree;

        case NE:
            if ( l_tag == TYPTR | l_tag == TYARRAY | r_tag == TYPTR | r_tag == TYARRAY){
                size = get_size_basic(f_tag);
                en_eval_tn(left);
                if (left->tag == VAR){
                    b_deref(l_tag);
                }
                //for case that ptr == 0
                if(left->tag == INTCONST && left->u.int_val == 0){
                    b_convert (TYSIGNEDINT, TYPTR);
                }
                en_eval_tn(right);
                if (right->tag == VAR){
                    b_deref(r_tag);
                }
                if(right->tag == INTCONST && right->u.int_val == 0){
                    b_convert (TYSIGNEDINT, TYPTR);
                }
                b_arith_rel_op(B_NE,TYPTR);
                return tree;
            }
            en_eval_tn(left);
            if (left->tag == VAR){
                b_deref(l_tag);
            }
            if(left->tag == UNOP && left->u.unop_node.op == STAR){
                b_deref(l_tag);
            }
            if (l_tag == TYFLOAT){
                b_convert(TYFLOAT, TYDOUBLE);
            }
            if (l_tag == TYSIGNEDCHAR){
                b_convert(TYSIGNEDCHAR, TYSIGNEDINT);
            }
            arith_eval(left, right, B_NE);
            return tree;

        default:
            error("Unrecognize binop operand!");
            return NULL;
    }
}

TN eval_func(TN tree)
{   
    //check if the var node is a defined funciton
    TN child_tn = tree->u.fcall_node.child;
    while (child_tn->tag == UNOP){
        child_tn = child_tn->u.unop_node.link;
    }
    if (child_tn->tag != VAR && child_tn->is_func == FALSE){
        error("Invalid function declarator!");
        return NULL;
    }

    unsigned int size = 0;
    TN temp_tn = tree->u.fcall_node.arglist;
    TYPETAG temp_tag;

    //Allocote memory for argument list
    while(temp_tn != NULL){
        temp_tag = ty_query(temp_tn->type);
        if (temp_tag == TYSIGNEDINT | temp_tag == TYSIGNEDCHAR | temp_tag == TYPTR){
            size += 4;
        }
        else if (temp_tag == TYFLOAT | temp_tag == TYDOUBLE){
            size += 8;
        }
        else {
            error("Unexpected type in function!");
        }
        temp_tn = temp_tn->next;
    }
    b_alloc_arglist(size);

    //Generate assembly code for argument list
    temp_tn = tree->u.fcall_node.arglist;
    while(temp_tn != NULL){
        if (temp_tn->tag == UNOP && temp_tn->u.unop_node.op == DEF){
                //True condition mean there is VAR node below
                en_eval_tn(temp_tn);
                temp_tag = ty_query(temp_tn->type);
                if(temp_tag == TYFLOAT){
                        b_load_arg(TYDOUBLE);
                }
                else{
                        b_load_arg(temp_tag);  
                }
        }
        else{
                temp_tag = ty_query(temp_tn->type);
                switch (temp_tag){
                    case TYSIGNEDINT:
                        b_push_const_int(temp_tn->u.int_val);
                        b_load_arg(TYSIGNEDINT);
                        break;
                    case TYSIGNEDCHAR:
                        b_push_const_int(temp_tn->u.int_val);
                        b_load_arg(TYSIGNEDCHAR);
                        break;
                    case TYFLOAT:
                        b_push_const_double(temp_tn->u.d_val);
                        b_load_arg(TYDOUBLE);
                        break;
                    case TYDOUBLE:
                        b_push_const_double(temp_tn->u.d_val);
                        b_load_arg(TYDOUBLE);
                        break;
                    case TYPTR:
                        b_push_const_string(temp_tn->u.string);
                        //b_push_ext_addr(temp_tn->u.string);
                        b_load_arg(TYPTR);
                        break;
                    default:
                        error("Unrecognize function argument!");
                        break;
                }        
        }
        temp_tn = temp_tn->next;
    }

    //Generate assembly code for id
    PARAMSTYLE paramstyle;
    PARAM_LIST params;
    TYPE temp_type = child_tn->type;
    temp_tag = ty_query(temp_type);
    TYPE_QUALIFIER qual;
    if (child_tn->tag == BINOP){
        if (child_tn->is_func == TRUE){
            en_eval_tn(child_tn);
            b_deref(TYPTR);
            while(temp_tag == TYPTR){
                temp_type = ty_query_pointer(temp_type, &qual);
                temp_tag = ty_query(temp_type);
            }
            if(temp_tag == TYFUNC){
                temp_type = ty_query_func(temp_type, &paramstyle, &params);
                temp_tag = ty_query(temp_type);
            }
            b_funcall_by_ptr(temp_tag);
            return tree;
        }
        else{
            error("Not a function type!");
            return tree;
        }
    }
    if(child_tn->tag != VAR){
        error("Unexpected expr tag in function call!");
        return tree;
    }

    if ( temp_tag == TYFUNC){
        temp_type = ty_query_func(temp_type,&paramstyle, &params);
        b_funcall_by_name(st_get_id_str(child_tn->u.id), ty_query(temp_type));

    }
    else if( temp_tag != TYPTR){
        b_funcall_by_name(st_get_id_str(child_tn->u.id), ty_query(temp_type));
    }
    else{
        en_eval_tn(child_tn);
        while (temp_tag == TYPTR){
            temp_type = ty_query_pointer(temp_type, &qual);
            temp_tag = ty_query(temp_type);
        }
        if (temp_tag == TYFUNC){
            temp_type = ty_query_func(temp_type, &paramstyle, &params);
            temp_tag = ty_query(temp_type);
        }
        if(temp_tag == TYSIGNEDINT | temp_tag == TYDOUBLE | temp_tag == TYSIGNEDCHAR | temp_tag == TYFLOAT){
            b_deref(TYPTR);
            b_funcall_by_ptr(temp_tag);
        }
        else{
            error("unexpected function return type!");
        }
    }
    return tree;
}

TN en_eval_tn(TN tree)
{
    EXPR_TAG expr_tag = tree->tag;
    switch (expr_tag){
        case VAR:
            b_push_ext_addr(st_get_id_str(tree->u.id));
            return tree;
        case INTCONST:
            b_push_const_int(tree->u.int_val);
            return tree;
        case DCONST:
            b_push_const_double(tree->u.d_val);
            return tree;
        case UNOP:
            return eval_unop(tree);
        case BINOP:
            return eval_binop(tree);
        case FCALL:
            return eval_func(tree);
        case STRING:
        //wait check
            return tree;
        default:
            error("Unrecognize tree tag!");
            return NULL;
    }
}


void en_eval_expr(TN tree)
{
    if(tree == NULL){
        return;
    }
    if (compiler_errors == 0){
        en_eval_tn(tree);
        b_pop();
    }
    compiler_errors = 0;
    return;
}