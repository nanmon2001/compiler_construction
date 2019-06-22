    #include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "tree.h"


/************************************
* Build type tree node funtions
*************************************/

DECL_ND_PTR tr_insert_id(ST_ID id) {
	DECL_ND_PTR head = (DECL_ND_PTR) malloc (sizeof(DECL_ND));	
	head->u.id = id;
	head->tag = ID_DECL;
	head->next = NULL;
	return head;
}

DECL_ND_PTR tr_insert_func(DECL_ND_PTR head) {
	DECL_ND_PTR new_head = (DECL_ND_PTR) malloc (sizeof(DECL_ND));	
	new_head->tag = FUNC_DECL;
	new_head->u.params = NULL;
	new_head->next = head;
	return new_head;
}

DECL_ND_PTR tr_insert_func_params(DECL_ND_PTR head, PARAM_LIST params) {
	DECL_ND_PTR new_head = (DECL_ND_PTR) malloc (sizeof(DECL_ND));	
	new_head->tag = FUNC_DECL;
	new_head->u.params = params;
	new_head->next = head;
	return new_head;
}

DECL_ND_PTR tr_insert_ptr(DECL_ND_PTR head) {
	DECL_ND_PTR new_head = (DECL_ND_PTR) malloc (sizeof(DECL_ND));	
	new_head->tag = PTR_DECL;
	new_head->next = head;
	return new_head;
}

DECL_ND_PTR tr_insert_ref(DECL_ND_PTR head) {
	DECL_ND_PTR new_head = (DECL_ND_PTR) malloc (sizeof(DECL_ND));	
	new_head->tag = REF_DECL;
	new_head->next = head;
	return new_head;
}

DECL_ND_PTR tr_insert_array(DECL_ND_PTR head, int size) {
	DECL_ND_PTR new_head = (DECL_ND_PTR) malloc (sizeof(DECL_ND));	
	new_head->tag = ARR_DECL;
	new_head->u.arr_size = size;
	new_head->next = head;
	return new_head;
}

void tr_free_tree(DECL_ND_PTR head) {
	if (head == NULL) {
		return;
	}
	while (head !=  NULL) {
		DECL_ND_PTR head1 = head->next;
		head->next = NULL;
		free(head);
		head = head1;
	}
}


/************************************
* Build syntax tree node funtions
*************************************/
TN s_binop_const_tn(TN left, TN right, OP op);
TN s_binop_const_decl_tn(TN left, TN right, OP op, TN decl);


TYPE eval_type(TN left, TN right)
{
    TYPE left_type = left->type; 
    TYPE right_type = right->type;

    TYPETAG left_tag = ty_query(left_type); 

    TYPETAG right_tag = ty_query(right_type);

    PARAMSTYLE paramstyle;
    PARAM_LIST params;  
    if(left_tag == TYFUNC){//happens when the function is declare globally
       left_type = ty_query_func(left_type, &paramstyle, &params);
       TYPETAG left_tag = ty_query(left_type); 
     }
    if(right_tag == TYFUNC){//happens when the function is declare globally
       right_type = ty_query_func(right_type, &paramstyle, &params);
       TYPETAG right_tag = ty_query(right_type);
    }
    if (left_tag == right_tag){
        return left_type;
    }
    if(left_tag == TYDOUBLE){
        return left_type;
    }else if (right_tag == TYDOUBLE){
        return right_type;
    }else if (left_tag == TYFLOAT){
        return left_type;
    }else if (right_tag == TYFLOAT){
        return right_type;
    }else if (left_tag == TYSIGNEDINT){
        return left_type;
    }else if (right_tag == TYSIGNEDINT){
        return right_type;
    }else if (left_tag == TYSIGNEDCHAR){
        return left_type;
    }else if (right_tag == TYSIGNEDCHAR){
        return right_type;
    }else{
        error("Invalid type to do addition!");
        return NULL;
    }
}

TN tr_mk_int(int val)
{
    TN ret;
    ret = (TN) malloc(sizeof(TREE_NODE));
    if (ret == NULL){
        fprintf(stderr, "Node memory allocate failure!");
        exit(1);
    }

    ret->tag = INTCONST;
    ret->u.int_val = val;
    BUCKET_PTR bucket = update_bucket(NULL, INT_SPEC, NULL);
    ret->type = build_base(bucket);
    ret->is_array = FALSE;
    ret->is_func = FALSE;
    ret->basic = 1;
    ret->dl = NULL;
    return ret;
}

TN tr_mk_double(double val)
{
    TN ret;
    ret = (TN) malloc(sizeof(TREE_NODE));
    if (ret == NULL){
        fprintf(stderr, "Node memory allocate failure!");
        exit(1);
    }

    ret->tag = DCONST;
    ret->u.d_val = val;
    BUCKET_PTR bucket = update_bucket(NULL, DOUBLE_SPEC, NULL);
    ret->type = build_base(bucket);
    ret->is_array = FALSE;
    ret->is_func = FALSE;
    ret->basic = 1;
    ret->dl = NULL;
    return ret;
}

DL add_dim_list(DL list, int dim){
    DL ret = (DL) malloc(sizeof(DIM_LIST));
    ret->dim = dim;
    ret->next = NULL;
    if (list == NULL){
        return ret;
    }
    else{
        list->next = ret;
        return list;
    }
}

TYPE find_func_basic_type(TYPE type)//TYVOID??
{
    TYPE temp_type = type;
    TYPETAG temp_tag = ty_query(temp_type);
    DIMFLAG dimflag;
    unsigned int dim;
    PARAMSTYLE paramstyle;
    PARAM_LIST params;
    TYPE_QUALIFIER qual;
    while (temp_tag == TYARRAY | temp_tag == TYPTR | temp_tag == TYFUNC){
        if (temp_tag == TYARRAY){
            temp_type = ty_query_array(temp_type, &dimflag, &dim);
        }
        if (temp_tag == TYPTR){
            temp_type = ty_query_pointer(temp_type, &qual);
        }
        if(temp_tag == TYFUNC){
            temp_type = ty_query_func(temp_type, &paramstyle, &params);
        }
        temp_tag = ty_query(temp_type);
    }
    if (temp_tag == TYFLOAT | temp_tag == TYDOUBLE | temp_tag == TYSIGNEDINT | temp_tag == TYSIGNEDCHAR){
        return temp_type;
    }
    else{
        error("Unrecognized function basic type!");
        return NULL;
    }
}

TN tr_mk_id(ST_ID id)
{   
    //Creaet a tree node, set the attributes to default values
    TN ret = (TN) malloc(sizeof(TREE_NODE));
    if (ret == NULL){
        fprintf(stderr, "Node memory allocate failure!");
        exit(1);
    }
    ret->tag = VAR;
    ret->u.id = id;
    ret->type = NULL; //must be assign something not a NULL later
    ret->is_array = FALSE; //inicates it's a array related id
    ret->is_func = FALSE; //indicates it's a function related id
    ret->basic = 1; //store array type id's basic dimension size 
    ret->dl = NULL; //store the array dimession number sequence
    
    //Check id is in symtab, the id must be declared before hand, if not issue an error
    int block;
    ST_DR st_dr = st_lookup(id, &block);
    if (st_dr == NULL){
    	error("`%s' is undefined", st_get_id_str(id));
        return NULL;
    }

    //Check if array exists, if exists than mark it and store the basic size and dim sequence
    DIMFLAG dimflag;
    unsigned int dim;
    int ar_layer_cnt = 0;
    int i;
    unsigned int basic_size = 1;
    TYPE temp_type = st_dr->u.decl.type;
    DL dl = NULL;
    while (ty_query(temp_type) == TYARRAY){
        temp_type = ty_query_array(temp_type, &dimflag, &dim);
        if (ar_layer_cnt>0){
            basic_size *= dim;
            dl = add_dim_list(dl, dim);
        }
        ar_layer_cnt++;
    }
    TYPE temp = temp_type;
    for (i=0;i<ar_layer_cnt;i++){
        temp_type = ty_build_ptr(temp_type, NO_QUAL);
    }
    if (ar_layer_cnt > 0){
        ret->is_array = TRUE;
        ret->basic = basic_size;
    }
    ret->dl = dl; //store the dim seq that's greater than one
    ret->type = temp_type; //assign the tree node type

    //Check if function exists. 
    if(ty_query(temp_type) == TYFUNC){ //functions could be declared gobally or after an array
        ret->is_func = TRUE;
    }
    if(st_dr->tag == FDECL){
        ret->is_func = TRUE; //functions could be declared through function definition
    }

    //Check if a function is inside a pointer type
    TYPE_QUALIFIER qual;
    PARAMSTYLE paramstyle;
    PARAM_LIST params;
    while(ty_query(temp) == TYPTR){
        temp = ty_query_pointer(temp, &qual);
        if (ty_query(temp) == TYFUNC){
            ret->is_func = TRUE;
            //temp = ty_query_func(temp, &paramstyle, &params);
            //message("ty_query_func:tag %d", ty_query(temp));
        }
    }

    return ret;
}

TN tr_mk_str(char* str)
{
    TN ret;
    ret = (TN) malloc(sizeof(TREE_NODE));
    if (ret == NULL){
        fprintf(stderr, "Node memory allocate failure!");
        exit(1);
    }

    ret->tag = STRING;
    ret->u.string = str;//strcpy ( char * destination, const char * source )
    BUCKET_PTR bucket = update_bucket(NULL, CHAR_SPEC, NULL);
    TYPE type = build_base(bucket);
    ret->type = ty_build_ptr(type, NO_QUAL);
    ret->is_array = FALSE;
    ret->is_func = FALSE;
    ret->basic = 1;
    ret->dl = NULL;
    return ret;
}

TN tr_mk_func(TN child, TN arglist)
{
    int block;
    ST_DR st_dr;
    TN temp_tn = child;
    if (child == NULL){
        return NULL;//undefined identifier
    }

    //Check if id is a function type or not
    TYPETAG temp_tag;
    TYPE temp_type = child->type;
    TYPE_QUALIFIER qual;
    if (child->tag != VAR && child->tag != UNOP){
        error("expression not of function type");//2(), 1.2(),"hihi"()...are invalid
        return NULL;
    }
    else if (child->tag == UNOP){ //e.g (*fp)();(*(*(afp+5)))();
        if (child->is_func == FALSE){
            error("expression not of function type");
            return NULL; 
        }
        temp_tag = ty_query(temp_type);
        if (temp_tag == TYFUNC){
            //do nothing
        }
        else if (temp_tag == TYPTR){ //(*(afp+5))();
            while (temp_tag == TYPTR){
                temp_type = ty_query_pointer(temp_type, &qual);
                temp_tag = ty_query(temp_type);
            }
            if (temp_tag != TYFUNC){
                error("function call structure not recognized!");
                return NULL; 
            }
        }
    }
    else{
        if(child->tag == VAR && child->is_func == TRUE){ //e.g fp()
            //do nothing
        }
        else{
            st_dr = st_lookup(child->u.id, &block);
            if (st_dr->tag != FDECL){
                if (ty_query(st_dr->u.decl.type) != TYFUNC){
                    error("expression not of function type");//this mean that the identifier is declared as a function
                    return NULL;
                }
            } 
        }
    }
    TN ret = (TN) malloc(sizeof(TREE_NODE));
    if (ret == NULL){
        fprintf(stderr, "Node memory allocate failure!");
        exit(1);
    }
    ret->tag = FCALL;
    ret->u.fcall_node.child = child;
    ret->u.fcall_node.arglist = arglist;
    ret->type = find_func_basic_type(child->type);
    ret->is_array = FALSE;
    ret->is_func = FALSE;
    ret->basic = 1;
    ret->dl = NULL;
    return ret;
}

//UNARY OP CASES:DEF, PRE_INC, POST_INC, PRE_DEC, POST_DEC, NEGATE, POS, STAR, AMPER
TN tr_mk_unop(TN link, OP op)
{
    //NULL indicates a error happen before.
    if (link == NULL){
        return NULL;
    }
    //Initialize the tree node
    TN ret = (TN) malloc(sizeof(TREE_NODE));
    if (ret == NULL){
        fprintf(stderr, "Node memory allocate failure!");
        exit(1);
    }
    ret->tag = UNOP;
    ret->u.unop_node.link = link;
    ret->u.unop_node.op = op;
    ret->type = link->type;
    ret->is_array = link->is_array;
    ret->is_func = link->is_func;
    ret->basic = link->basic;
    ret->dl = link->dl;

    //the below are declarations for funtion calls
    EXPR_TAG tag = link->tag;
    TYPETAG type_tag = ty_query(link->type); 
    TYPE_QUALIFIER qual;
    TYPETAG temp_tag;
    BUCKET_PTR bucket;
    DIMFLAG dimflag;
    unsigned int dim;
    PARAMSTYLE paramstyle;
    PARAM_LIST params;
    int block;
    ST_DR st_dr;
    DL temp_dl = NULL;

    //Operation leagal check
    switch(op){
        case DEF:
            if (link->tag != VAR){
                return link;
            }
            else{
                return ret;
            }
        //PRE_INC, POST_INC, PRE_DEC, POST_DEC all do the same
        case PRE_INC:
        case POST_INC:
        case PRE_DEC:
        case POST_DEC:
            if (tag == INTCONST | tag == DCONST ){
                //++, --, all has to work on an value
                error("illegal unary operation on constant operand");
                return NULL;
            }
            if (tag == FCALL){
                error("operator requires function designator or l-value");
                return NULL;
            }
           if (tag == STRING){
                error("illegal unary operation on string constants");
                return NULL;
            }
            if (tag == UNOP){
                if (link->u.unop_node.op == STAR){
                    return ret;
                }
                else if (link->u.unop_node.op == DEF){
                    //if VAR->DEF->PRE_INC/POST_INC/PRE_DEC/POST_DEC, then no need of DEF node
                    ret->u.unop_node.link = link->u.unop_node.link;
                    ret->type = link->u.unop_node.link->type;
                    return ret;
                }
                else{
                    error("operator requires function designator or l-value");
                    return NULL;  
                }
            }
            if(tag == BINOP){
                error("operator requires function designator or l-value");
                return NULL; 
            }
            //Till here the link node could only be a VAR node
            if(type_tag == TYARRAY | type_tag == TYFUNC){
                error("cannot increment or decrement nonscalar type");
                return NULL; 
            }
            else{//TYFLOAT TYDOUBLE TYSIGNEDCHAR TYUNSIGNEDINT TYPTR
                return ret;
            }

        case NEGATE:
            if (tag == INTCONST){
                link->u.int_val = link->u.int_val*(-1);
                return link;
            }
            if (tag == DCONST){
                link->u.d_val = link->u.d_val*(-1);
                return link;
            }
            if (type_tag == TYARRAY | type_tag == TYFUNC | TYPTR){
                error("illegal pointer operation");
                return NULL; 
            }
            else{
                if (type_tag == TYUNSIGNEDINT | type_tag == TYSIGNEDCHAR){
                    bucket = update_bucket(NULL, INT_SPEC, NULL);
                    ret->type = build_base(bucket); 
                    return ret;
                }
                else{
                    bucket = update_bucket(NULL, DOUBLE_SPEC, NULL);
                    ret->type = build_base(bucket); 
                    return ret;
                }
            }

        case POS:
            if (tag == INTCONST){
                return link;
            }
            if (tag == DCONST){
                return link;
            }
            if (type_tag == TYARRAY | type_tag == TYFUNC | TYPTR){
                error("illegal pointer operation");
                return NULL; 
            }
            else{
                if (type_tag == TYUNSIGNEDINT | type_tag == TYSIGNEDCHAR){
                    bucket = update_bucket(NULL, INT_SPEC, NULL);
                    ret->type = build_base(bucket); 
                    return ret;
                }
                else{
                    bucket = update_bucket(NULL, DOUBLE_SPEC, NULL);
                    ret->type = build_base(bucket); 
                    return ret;
                }
            }

        case STAR://'*' operator take a ptr type and turn it into the type it points to
            if (tag == INTCONST | tag == DCONST ){
                error("illegal unary operation on constant operand");
                return NULL;
            }
            if (tag == UNOP && link->u.unop_node.op == DEF){//possible fault
                //if VAR->DEF->STAR, then no need of DEF node
                ret->u.unop_node.link = link->u.unop_node.link;
            }
            if(type_tag == TYPTR){
                ret->type = ty_query_pointer(link->type, &qual);
                if (ty_query(ret->type) == TYPTR && link->is_array == TRUE){
                    dim = 1;
                    if(link->dl != NULL){
                        temp_dl = link->dl->next;
                    }
                    while (temp_dl != NULL){
                        dim*=link->dl->next->dim;
                        temp_dl = temp_dl->next;
                    }
                    ret->is_array = TRUE;
                    ret->basic = dim;
                    if(link->dl != NULL){
                        ret->dl = link->dl->next;
                    }
                    else{
                        ret->dl = NULL;
                    }
                }
                ret->is_func = link->is_func;
                return ret;
            }
            else if (type_tag == TYARRAY){
                ret->type = ty_query_array(link->type, &dimflag, &dim);
                ret->is_func = link->is_func;
                return ret;
            }
            else if(type_tag == TYFUNC){
                ret->type = ty_query_func(link->type, &paramstyle, &params);
                ret->is_func = link->is_func;
                return ret;
            }
            else if (tag == STRING){
                error("illegal unary operation on string constants");
                return NULL;
            }
            else{
                if (tag == VAR){//*main = 19
                    if(link->u.id){
                        st_dr = st_lookup(link->u.id, &block);
                    }
                    if(st_dr->tag == FDECL){
                        error("left side of assignment is not an l-value");
                        return NULL;
                    }
                }
                error("indirection on nonpointer type");
                return NULL;
            }

        case AMPER://'&' operator take a type and turn it into a ptr that points to that type
            if (tag == INTCONST | tag == DCONST ){
                //++, --, all has to work on an value
                error("illegal unary operation on constant operand");
                return NULL;
            }
            else if (tag == BINOP | tag == FCALL){
                error("address operator requires function designator or l-value");
                return NULL;
            }
            else if (tag == STRING){
                error("illegal unary operation on string constants");
                return NULL;
            }
            else{//Till here, tag must be UNOP
                if (link->u.unop_node.op == DEF){
                    //if VAR->DEF->AMPER, then no need of DEF node
                    ret->u.unop_node.link = link->u.unop_node.link;
                    ret->type = ty_build_ptr(link->u.unop_node.link->type, NO_QUAL);
                    return ret;
                }
                if (link->u.unop_node.op == STAR){//wait check
                    //for case &*(a+b), dont want * to trigger b_deref
                    ret->u.unop_node.link = link->u.unop_node.link;
                }
                ret->type = ty_build_ptr(link->type, NO_QUAL);
                return ret;
            }

        default:
            error("new unary opearand? op:%d",op );
            return NULL;
    } 
}

//BINOP OP CASES: ASSIGN, PLUS, MINUS, MUL, DIV, MOD, LT, GT, LE, GE, EQ, NE, BRACKET
TN tr_mk_binop(TN left, TN right, OP op, TN decl)
{   
    //Either side of the tree node is NULL indicates a error happen before.
    if (left == NULL | right == NULL){
        return NULL;
    }
    //Start creating a syntax tree node
    TN ret = (TN) malloc(sizeof(TREE_NODE));
    if (ret == NULL){
        fprintf(stderr, "Node memory allocate failure!");
        exit(1);
    }
    ret->tag = BINOP;
    ret->u.binop_node.op = op;
    ret->u.binop_node.left = left;
    ret->u.binop_node.right = right;    
    //The type will be determined later

    //Combined two tree nodes if both sides are constant nodes on '+', '-', '*', '/', '%' operations
    if ( (left->tag == INTCONST | left->tag == DCONST) && (right->tag == INTCONST | right->tag == DCONST)){
        if (op == PLUS | op == MINUS | op == MUL | op == DIV | op == MOD){
            if (decl->tag != VAR){
                return s_binop_const_tn(left, right, op);
            }
            else{
                return s_binop_const_decl_tn(left, right, op, decl);
            }
        }
    }

    //Check if the syntax tree node is semantically leagal
    TYPETAG l_tag, r_tag;
    l_tag = ty_query(left->type);
    r_tag = ty_query(right->type);
    BUCKET_PTR bucket;
    TN temp_tn;
    int block;//wait del

    switch(op){
        case ASSIGN:
            //Check if lhs is leagal
            if (left->tag == INTCONST | left->tag == DCONST | left->tag == FCALL | left->tag == STRING){
                //1, 1.2, f(), Hello" on lhs are not allowed
                error("left side of assignment is not an l-value");
                return NULL;
            }
            if(left->tag == VAR && left->is_array == TRUE){
                error("left side of assignment is not an l-value");
                return NULL;
            }
            if (left->tag == UNOP && left->u.unop_node.op != STAR){
                //&p, ++p, --p, -p, etc. Last unary operand not a '*' are not allowed
                error("left side of assignment is not an l-value");
                return NULL; 
            }
            if (l_tag != TYFLOAT && l_tag != TYDOUBLE && l_tag != TYSIGNEDINT && l_tag != TYSIGNEDCHAR && l_tag != TYPTR){
                //Non basic data type variable and also not a pointer type are not allowed
                error("left side of assignment is not an l-value");
                return NULL; 
            }
            if (l_tag == TYPTR && left->type != right->type){
                //Pointer variables on both sides has to be exactly the same, unless rhs is 0
                if ( right->tag == INTCONST && right->u.int_val == 0){
                    //do nothing
                }
                else if (left->is_func == TRUE && right->is_func == TRUE){
                    //Change the type on both type for later generating assembly code use
                    left->type = ty_build_ptr(right->type, NO_QUAL);
                    right->type = ty_build_ptr(right->type, NO_QUAL);
                }
                else{
                    error("type mismatch in pointer conversion");
                    return NULL;
                }
            }
            ret->type = left->type;
            return ret;

        case PLUS://almost everything can be added together except ptr+ptr
            if (l_tag == TYPTR | l_tag == TYARRAY){
                if(r_tag != TYSIGNEDINT){
                    error("noninteger added to pointer");
                    return NULL;
                }
                ret->type = left->type;
                ret->is_func = left->is_func;
                return ret;
            }
            else if (r_tag == TYPTR | r_tag == TYARRAY){
                if(l_tag != TYSIGNEDINT){
                    error("noninteger added to pointer");
                    return NULL;
                }
                ret->type = right->type;
                ret->is_func = right->is_func;
                return ret;
            }
            else if (l_tag == TYDOUBLE | l_tag == TYFLOAT | r_tag == TYDOUBLE | r_tag == TYFLOAT){
                bucket = update_bucket(NULL, DOUBLE_SPEC, NULL);
                ret->type = build_base(bucket); 
                return ret;
            }
            else if (l_tag == TYSIGNEDINT | l_tag == TYSIGNEDCHAR | r_tag == TYSIGNEDINT | r_tag == TYSIGNEDCHAR){
                bucket = update_bucket(NULL, INT_SPEC, NULL);
                ret->type = build_base(bucket); 
                return ret;
            }
            else{
                error("add operation on some tag unexpected!");
                return NULL;
            } 

        case MINUS:
            //*int - *int and *int - int are allowed, other kinds ptr substraction such as int - *int, *float - *int are not.
            if (l_tag == TYPTR | l_tag == TYARRAY){
                if(left->is_func == TRUE){
                    error("arithmetic on function pointers not allowed");
                    return NULL;  
                }
                if(r_tag == TYSIGNEDINT){
                    ret->type = left->type;
                    return ret;
                }
                else if(r_tag == TYPTR | r_tag == TYARRAY){
                    if(left->type == right->type){
                        bucket = update_bucket(NULL, INT_SPEC, NULL);
                        ret->type = build_base(bucket);
                        return ret;
                    }
                    else{
                        error("type mismatch in pointer subtraction");
                        return NULL;   
                    }
                }
            }
            else if (r_tag == TYPTR | r_tag == TYARRAY){//left side is not a pointer, so if right is a pointer then it must be illeagal
                error("pointer subtracted from nonpointer");
                return NULL;
            }
            else if (l_tag == TYDOUBLE | l_tag == TYFLOAT | r_tag == TYDOUBLE | r_tag == TYFLOAT){
                bucket = update_bucket(NULL, DOUBLE_SPEC, NULL);
                ret->type = build_base(bucket); 
                return ret;
            }
            else if (l_tag == TYSIGNEDINT | l_tag == TYSIGNEDCHAR | r_tag == TYSIGNEDINT | r_tag == TYSIGNEDCHAR){
                bucket = update_bucket(NULL, INT_SPEC, NULL);
                ret->type = build_base(bucket); 
                return ret;
            }
            else{
                error("add operation on some tag unexpected!");
                return NULL;
            }

        case MUL://pointer operation is illeagal
            if (l_tag == TYPTR | l_tag == TYARRAY | r_tag == TYPTR | r_tag == TYARRAY){
                error("illegal pointer operation");
                return NULL;
            }
            else if (l_tag == TYDOUBLE | l_tag == TYFLOAT | r_tag == TYDOUBLE | r_tag == TYFLOAT){
                bucket = update_bucket(NULL, DOUBLE_SPEC, NULL);
                ret->type = build_base(bucket); 
                return ret;
            }
            else if (l_tag == TYSIGNEDINT | l_tag == TYSIGNEDCHAR | r_tag == TYSIGNEDINT | r_tag == TYSIGNEDCHAR){
                bucket = update_bucket(NULL, INT_SPEC, NULL);
                ret->type = build_base(bucket); 
                return ret;
            }
            else{
                error("add operation on some tag unexpected!");
                return NULL;
            }

        case DIV://pointer operation is i
            if (l_tag == TYPTR | l_tag == TYARRAY | r_tag == TYPTR | r_tag == TYARRAY){
                error("illegal pointer operation");
                return NULL;
            }
            else if (l_tag == TYDOUBLE | l_tag == TYFLOAT | r_tag == TYDOUBLE | r_tag == TYFLOAT){
                bucket = update_bucket(NULL, DOUBLE_SPEC, NULL);
                ret->type = build_base(bucket); 
                return ret;
            }
            else if (l_tag == TYSIGNEDINT | l_tag == TYSIGNEDCHAR | r_tag == TYSIGNEDINT | r_tag == TYSIGNEDCHAR){
                bucket = update_bucket(NULL, INT_SPEC, NULL);
                ret->type = build_base(bucket); 
                return ret;
            }
            else{
                error("add operation on some tag unexpected!");
                return NULL;
            }

        case MOD://pointer operation is i
            if (l_tag == TYPTR | l_tag == TYARRAY | r_tag == TYPTR | r_tag == TYARRAY){
                error("illegal pointer operation");
                return NULL;
            }
            else if (l_tag == TYDOUBLE | l_tag == TYFLOAT | r_tag == TYDOUBLE | r_tag == TYFLOAT){
                bucket = update_bucket(NULL, DOUBLE_SPEC, NULL);
                ret->type = build_base(bucket); 
                return ret;
            }
            else if (l_tag == TYSIGNEDINT | l_tag == TYSIGNEDCHAR | r_tag == TYSIGNEDINT | r_tag == TYSIGNEDCHAR){
                bucket = update_bucket(NULL, INT_SPEC, NULL);
                ret->type = build_base(bucket); 
                return ret;
            }
            else{
                error("add operation on some tag unexpected!");
                return NULL;
            }
        //LT, GT, GE, EQ, NE all do the same thing
        case LT:
        case GT:
        case GE:
        case EQ:
        case NE:
            if (l_tag == TYPTR | l_tag == TYARRAY | r_tag == TYPTR | r_tag == TYARRAY){
                //if a pointer exist, then both side have to be the same type of pointer
                if (left->type != right->type){//ptr if not the same type than has to be 0
                    if (left->tag == INTCONST && left->u.int_val == 0){
                        //do nothing
                    }
                    else if( right->tag == INTCONST && right->u.int_val == 0){
                        //do nothing
                    }
                    else{
                        error("type mismatch in pointer operation"); 
                        return NULL;
                    }
                }
            }
            bucket = update_bucket(NULL, INT_SPEC, NULL);
            ret->type = build_base(bucket); 
            return ret;

        case BRACKET:
            //Change the from of a[b] to *(a+b). One of a,b must be a TYARRAY and the other must be a TYSIGNEDINT
            if ((left->tag == VAR && left->is_func == TRUE && l_tag != TYPTR) | (right->tag == VAR && right->is_func == TRUE && r_tag != TYPTR)){
                error("arithmetic on function pointers not allowed"); 
                return NULL;
            }
            if (left->is_func == TRUE){ //function can't do arith operation but function pointer can
                if (left->tag == UNOP && left->u.unop_node.op == DEF){//PTR->DEF->PTR+int no need DEF node
                    left = left->u.unop_node.link;
                }
                if (r_tag == TYSIGNEDINT){
                   if(left->is_array == TRUE){
                        temp_tn = tr_mk_binop(left, right, PLUS, decl);
                        temp_tn->is_array = TRUE;
                        temp_tn->is_func = TRUE;
                        temp_tn->basic = left->basic;
                        temp_tn->dl = left->dl;
                        temp_tn = tr_mk_unop(temp_tn, STAR);
                        temp_tn->is_func =TRUE;
                        return temp_tn;
                    }
                    temp_tn->is_func =TRUE;
                    temp_tn = tr_mk_binop(left, right, PLUS, decl);
                    temp_tn->is_func =TRUE;
                    return tr_mk_unop(temp_tn, STAR);
                }
                else{
                    error("arithmetic on function pointers not allowed");
                    return NULL;
                }
            }
            if (right->is_func == TRUE){ //function can't do arith operation but function pointer can
                if (right->tag == UNOP && right->u.unop_node.op == DEF){//PTR->DEF->PTR+int no need DEF node
                    right = right->u.unop_node.link;
                }
                if (l_tag == TYSIGNEDINT){
                   if(right->is_array == TRUE){
                        temp_tn = tr_mk_binop(left, right, PLUS, decl);
                        temp_tn->is_array = TRUE;
                        temp_tn->is_func =TRUE;
                        temp_tn->basic = right->basic;
                        temp_tn->dl = right->dl;
                        temp_tn = tr_mk_unop(temp_tn, STAR);
                        temp_tn->is_func =TRUE;
                        return temp_tn;
                    }
                    temp_tn->is_func =TRUE;
                    temp_tn = tr_mk_binop(left, right, PLUS, decl);
                    temp_tn->is_func =TRUE;
                    return tr_mk_unop(temp_tn, STAR);
                }
                else{
                    error("arithmetic on function pointers not allowed");
                    return NULL;
                }
            }
            if (l_tag == TYPTR){
                if (left->tag == UNOP && left->u.unop_node.op == DEF){//PTR->DEF->PTR+int no need DEF node
                    left = left->u.unop_node.link;
                }
                if (r_tag == TYSIGNEDINT){
                   if(left->is_array == TRUE){
                        temp_tn = tr_mk_binop(left, right, PLUS, decl);
                        temp_tn->is_array = TRUE;
                        temp_tn->basic = left->basic;
                        temp_tn->dl = left->dl;
                        temp_tn = tr_mk_unop(temp_tn, STAR);
                        return temp_tn;
                    }
                    temp_tn = tr_mk_binop(left, right, PLUS, decl);
                    return tr_mk_unop(temp_tn, STAR);
                }
                else{
                    error("noninteger added to pointer");
                    return NULL;
                }
            }
            else if(r_tag == TYPTR){
                if (left->tag == UNOP && left->u.unop_node.op == DEF){//PTR->DEF->PTR+int no need DEF node
                    left = left->u.unop_node.link;
                }
                if (l_tag == TYSIGNEDINT){
                   if(right->is_array == TRUE){
                        temp_tn = tr_mk_binop(left, right, PLUS, decl);
                        temp_tn->is_array = TRUE;
                        temp_tn->basic = right->basic;
                        temp_tn->dl = right->dl;
                        return tr_mk_unop(temp_tn, STAR);
                    }
                    temp_tn = tr_mk_binop(left, right, PLUS, decl);
                    return tr_mk_unop(temp_tn, STAR);
                }
                else{
                    error("noninteger added to pointer");
                    return NULL;
                }
            }
            else{
                error("indirection on nonpointer type");
                return NULL;
            }

        default:
            error("new binary opearand? op:%d",op );
            return NULL;
    }
}

TN tr_mk_arglist(TN prev, TN next)
{   
    TN ret = prev;
    while(ret->next != NULL){
        ret = ret->next;
    }
    ret->next = next;
    return prev;       
}


TN s_binop_const_tn(TN left, TN right, OP op)
{
    switch (op){
        case PLUS:
            if (left->tag == right->tag ){
                if (left->tag == INTCONST){
                    left->u.int_val = left->u.int_val + right->u.int_val;
                    return left;
                }else{
                    left->u.d_val = left->u.d_val + right->u.d_val;
                    return left;
                }
            }
            else if(left->tag == DCONST){//implies that right->tag is INTCONST
                left->u.d_val = left->u.d_val + right->u.int_val;
                return left;
            }
            else{//implies that left->tag is INTCONST and right->tag is DCONST
                right->u.d_val = left->u.int_val + right->u.d_val;
                return right;
            }    

        case MINUS:
            if (left->tag == right->tag ){
                if (left->tag == INTCONST){
                    left->u.int_val = left->u.int_val - right->u.int_val;
                    return left;
                }else{
                    left->u.d_val = left->u.d_val - right->u.d_val;
                    return left;
                }
            }
            else if(left->tag == DCONST){//implies that right->tag is INTCONST
                left->u.d_val = left->u.d_val - right->u.int_val;
                return left;
            }
            else{//implies that left->tag is INTCONST and right->tag is DCONST
                right->u.d_val = left->u.int_val - right->u.d_val;
                return right;
            }   

        case MUL:
            if (left->tag == right->tag ){
                if (left->tag == INTCONST){
                    left->u.int_val = left->u.int_val * right->u.int_val;
                    return left;
                }else{
                    left->u.d_val = left->u.d_val * right->u.d_val;
                    return left;
                }
            }
            else if(left->tag == DCONST){//implies that right->tag is INTCONST
                left->u.d_val = left->u.d_val * right->u.int_val;
                return left;
            }
            else{//implies that left->tag is INTCONST and right->tag is DCONST
                right->u.d_val = left->u.int_val * right->u.d_val;
                return right;
            }   

        case DIV:
            if (left->tag == right->tag ){
                if (left->tag == INTCONST){
                    left->u.int_val = left->u.int_val / right->u.int_val;
                    return left;
                }else{
                    left->u.d_val = left->u.d_val / right->u.d_val;
                    return left;
                }
            }
            else if(left->tag == DCONST){//implies that right->tag is INTCONST
                left->u.d_val = left->u.d_val / right->u.int_val;
                return left;
            }
            else{//implies that left->tag is INTCONST and right->tag is DCONST
                right->u.d_val = left->u.int_val / right->u.d_val;
                return right;
            }   

        case MOD:
            if (left->tag == right->tag ){
                if (left->tag == INTCONST){
                    left->u.int_val = left->u.int_val % right->u.int_val;
                    return left;
                }else{
                    error("Can't mod type of double!");
                return left;
                }
            }
            else {
                error("Can't mod different types!");
                return left;
            } 
    } 
}


TN s_binop_const_decl_tn(TN left, TN right, OP op, TN decl)
{
    TYPETAG decl_tag = ty_query(decl->type);
    TN ret = (TN) malloc(sizeof(TREE_NODE));
    if (ret == NULL){
        fprintf(stderr, "Node memory allocate failure!");
        exit(1);
    }
    if (decl_tag == TYFLOAT | decl_tag == TYDOUBLE){
        ret->tag = DCONST;
        BUCKET_PTR bucket = update_bucket(NULL, DOUBLE_SPEC, NULL);
        ret->type = build_base(bucket);
    }
    else{
        ret->tag = INTCONST;
        ret->type = decl->type;
    }

    switch (op){
        case PLUS:
            if (decl_tag == TYFLOAT | decl_tag == TYDOUBLE){
                if (left->tag == INTCONST){
                    ret->u.d_val = left->u.int_val;
                }
                else{
                    ret->u.d_val = left->u.d_val;
                }
                if (right->tag == INTCONST){
                    ret->u.d_val = ret->u.d_val + right->u.int_val;
                }
                else{
                    ret->u.d_val = ret->u.d_val + right->u.d_val;
                }
            }
            else{
                if (left->tag == INTCONST){
                    ret->u.int_val = left->u.int_val;
                }
                else{
                    ret->u.int_val = left->u.d_val;
                }
                if (right->tag == INTCONST){
                    ret->u.int_val = ret->u.int_val + right->u.int_val;
                }
                else{
                    ret->u.int_val = ret->u.int_val + right->u.d_val;
                }
            }
            return ret;  

        case MINUS:
            if (decl_tag == TYFLOAT | decl_tag == TYDOUBLE){
                if (left->tag == INTCONST){
                    ret->u.d_val = left->u.int_val;
                }
                else{
                    ret->u.d_val = left->u.d_val;
                }
                if (right->tag == INTCONST){
                    ret->u.d_val = ret->u.d_val - right->u.int_val;
                }
                else{
                    ret->u.d_val = ret->u.d_val - right->u.d_val;
                }
            }
            else{
                if (left->tag == INTCONST){
                    ret->u.int_val = left->u.int_val;
                }
                else{
                    ret->u.int_val = left->u.d_val;
                }
                if (right->tag == INTCONST){
                    ret->u.int_val = ret->u.int_val - right->u.int_val;
                }
                else{
                    ret->u.int_val = ret->u.int_val - right->u.d_val;
                }
            }
            return ret;    

        case MUL:
            if (decl_tag == TYFLOAT | decl_tag == TYDOUBLE){
                if (left->tag == INTCONST){
                    ret->u.d_val = left->u.int_val;
                }
                else{
                    ret->u.d_val = left->u.d_val;
                }
                if (right->tag == INTCONST){
                    ret->u.d_val = ret->u.d_val * right->u.int_val;
                }
                else{
                    ret->u.d_val = ret->u.d_val * right->u.d_val;
                }
            }
            else{
                if (left->tag == INTCONST){
                    ret->u.int_val = left->u.int_val;
                }
                else{
                    ret->u.int_val = left->u.d_val;
                }
                if (right->tag == INTCONST){
                    ret->u.int_val = ret->u.int_val * right->u.int_val;
                }
                else{
                    ret->u.int_val = ret->u.int_val * right->u.d_val;
                }
            }
            return ret;   

        case DIV:
            if (decl_tag == TYFLOAT | decl_tag == TYDOUBLE){
                if (left->tag == INTCONST){
                    ret->u.d_val = left->u.int_val;
                }
                else{
                    ret->u.d_val = left->u.d_val;
                }
                if (right->tag == INTCONST){
                    ret->u.d_val = ret->u.d_val / right->u.int_val;
                }
                else{
                    ret->u.d_val = ret->u.d_val / right->u.d_val;
                }
            }
            else{
                if (left->tag == INTCONST){
                    ret->u.int_val = left->u.int_val;
                }
                else{
                    ret->u.int_val = left->u.d_val;
                }
                if (right->tag == INTCONST){
                    ret->u.int_val = ret->u.int_val / right->u.int_val;
                }
                else{
                    ret->u.int_val = ret->u.int_val / right->u.d_val;
                }
            }
            return ret;

        case MOD:
            if (left->tag == INTCONST && right->tag == INTCONST){
                if (decl_tag == TYFLOAT | decl_tag == TYDOUBLE){
                    ret->u.d_val = left->u.int_val % right->u.int_val;
                }
                else{
                    ret->u.int_val = left->u.int_val % right->u.int_val;
                }
            }
            else {
                error("Can't do mod, both side need to be INCONST!");
            }
            return ret; 
    } 
}