/*
 *
 * yacc/bison input for simplified C++ parser
 *
 */


%{

#include "defs.h"
#include "types.h"
#include "symtab.h"
#include "bucket.h"
#include "message.h"
#include "tree.h"
#include "encode.h"
#include BACKEND_HEADER_FILE

    int yylex();
    int yyerror(char *s);

int mk_type_install(BUCKET_PTR bucket, DECL_ND_PTR head);
PARAM_LIST add_param_to_list(PARAM_LIST pre_pl, PARAM_LIST new_pl);
PARAM_LIST make_param(BUCKET_PTR bucket, DECL_ND_PTR head);
TYPE initializer_install(BUCKET_PTR bucket, DECL_ND_PTR head);
void ar_init_reduce(unsigned int dim, TYPE type, int cnt);
unsigned int get_dim(TYPE type);
TYPE get_ar_type(TYPE type);
char* mk_func(BUCKET_PTR bucket, DECL_ND_PTR head);
//BOOLEAN in_local = FALSE;
TN check_lval(TN tree);
char* if_cond(TN tree);
char* while_cond1();
char* while_cond2(TN tree);
void while_reduce(char* start, char* exit);
void ret_eval(TN tree);
static void push(STACKTAG sktag, char* label);
static char* pop();
void break_act();
char* for_cond1(TN init);
char* for_cond2(TN test);
void for_reduce(TN tree, char* test, char* exit);
char* switch_cond(TN tree);
void switch_reduce(char* label);
void case_act(TN tree);
char* switch_cond(TN tree);
void def_reduce();

BOOLEAN rhs = FALSE;
BOOLEAN pre_rhs;
TN decl_tn;//the result after checking left side tree node
TYPETAG func_ret;
SR stack;
BOOLEAN has_break = FALSE;
BOOLEAN has_default = FALSE;
%}

%union {
	int	y_int;
	double	y_double;
	char *	y_string;
	BUCKET_PTR y_bucket;
	ST_ID * y_stid;
	DECL_ND_PTR y_nd;
	PARAM_LIST y_param;
	BOOLEAN y_ptr;
	TYPE_SPECIFIER y_t_sp;
	TYPE y_type;
	TN y_tn;
	char y_char;
	OP y_op;
	};

%type <y_bucket> declaration_specifiers 
%type <y_t_sp> type_specifier storage_class_specifier type_qualifier
%type <y_stid> identifier;
%type <y_nd> direct_declarator declarator 
%type <y_tn> primary_expr postfix_expr unary_expr cast_expr multiplicative_expr additive_expr shift_expr relational_expr equality_expr and_expr exclusive_or_expr inclusive_or_expr logical_and_expr logical_or_expr conditional_expr constant_expr assignment_expr expr expr_opt argument_expr_list_opt argument_expr_list
%type <y_ptr> pointer
%type <y_param> parameter_type_list parameter_declaration parameter_list
%type <y_int> initializer_list init_declarator init_declarator_list declaration declaration_list
%type <y_op> unary_operator
%type <y_string> if_action

%token <y_string> IDENTIFIER STRING_LITERAL SIZEOF 
%token <y_int> INT_CONSTANT 
%token <y_double> DOUBLE_CONSTANT

%token PTR_OP INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token XOR_ASSIGN OR_ASSIGN TYPE_NAME

%token TYPEDEF EXTERN STATIC AUTO REGISTER
%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOLATILE VOID
%token STRUCT UNION ENUM ELIPSIS

%token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN

%token BAD

%start translation_unit
%%

 /*******************************
  * Expressions                 *
  *******************************/

primary_expr
	: identifier 			{ $$ = tr_mk_id($1);}
	| INT_CONSTANT			{ $$ = tr_mk_int($1); }
	| DOUBLE_CONSTANT		{ $$ = tr_mk_double($1); }
	| STRING_LITERAL		{ $$ = tr_mk_str($1); }
	| '(' expr ')'			{ $$ = $2; }
	;

postfix_expr //
	: primary_expr 										{ if(rhs == FALSE){$$ = $1;}else{$$ = tr_mk_unop($1, DEF);} }
	| postfix_expr '[' expr ']'							{ $$ = tr_mk_binop($1, $3, BRACKET, decl_tn);}
	| postfix_expr '('  {rhs = TRUE;}  argument_expr_list_opt ')' 	{ $$ = tr_mk_func($1, $4); rhs = FALSE;}
	| postfix_expr '.' identifier 						{/*i.e., u.val*/}
	| postfix_expr PTR_OP identifier 					{/*i.e., u->val*/}
	| postfix_expr INC_OP 								{ $$ = tr_mk_unop($1, POST_INC); }
	| postfix_expr DEC_OP 								{ $$ = tr_mk_unop($1, POST_DEC); }
	;

argument_expr_list_opt //
	: /* null derive */ 								{ $$ = NULL; }
	| argument_expr_list 								
	;

argument_expr_list  //
	: assignment_expr									
	| argument_expr_list ',' assignment_expr			{ $$ = tr_mk_arglist($1, $3);}
	;

unary_expr //no SIZEOF..
	: postfix_expr					
	| INC_OP unary_expr									{ $$ = tr_mk_unop($2, PRE_INC); }
	| DEC_OP unary_expr									{ $$ = tr_mk_unop($2, PRE_DEC);}
	| unary_operator cast_expr 							{ $$ = tr_mk_unop($2, $1); }
	| SIZEOF unary_expr 								{/*do nothing*/}
	| SIZEOF '(' type_name ')' 							{/*do nothing*/}
	;

unary_operator //
	: '&' { $$ = AMPER;}
	| '*' { $$ = STAR;}
	| '+' { $$ = POS;}
	| '-' { $$ = NEGATE;}
	| '~' { error("unary_operator:%c", '~');}
	| '!' { error("unary_operator:%c", '!');}
	;

cast_expr 
	: unary_expr 									
	| '(' type_name ')' cast_expr 					{/*do nothing*/}
	;

multiplicative_expr //
	: cast_expr
	| multiplicative_expr '*' cast_expr 			{ $$ = tr_mk_binop($1, $3, MUL, decl_tn); }
	| multiplicative_expr '/' cast_expr   	 		{ $$ = tr_mk_binop($1, $3, DIV, decl_tn); }
	| multiplicative_expr '%' cast_expr  			{ $$ = tr_mk_binop($1, $3, MOD, decl_tn); }
	;

additive_expr
	: multiplicative_expr
	| additive_expr '+' multiplicative_expr 		{ $$ = tr_mk_binop($1, $3, PLUS, decl_tn); }
	| additive_expr '-' multiplicative_expr 		{ $$ = tr_mk_binop($1, $3, MINUS, decl_tn); }	
	;

shift_expr 
	: additive_expr
	| shift_expr LEFT_OP additive_expr
	| shift_expr RIGHT_OP additive_expr
	;

relational_expr
	: shift_expr
	| relational_expr '<' shift_expr 				{ $$ = tr_mk_binop($1, $3, LT, decl_tn); }
	| relational_expr '>' shift_expr 				{ $$ = tr_mk_binop($1, $3, GT, decl_tn); }
	| relational_expr LE_OP shift_expr 				{ $$ = tr_mk_binop($1, $3, LE, decl_tn); }
	| relational_expr GE_OP shift_expr  			{ $$ = tr_mk_binop($1, $3, GE, decl_tn); }
	;

equality_expr //
	: relational_expr
	| equality_expr EQ_OP relational_expr 			{ $$ = tr_mk_binop($1, $3, EQ, decl_tn); }
	| equality_expr NE_OP relational_expr  			{ $$ = tr_mk_binop($1, $3, NE, decl_tn); }
	;

and_expr 
	: equality_expr
	| and_expr '&' equality_expr
	;

exclusive_or_expr 
	: and_expr
	| exclusive_or_expr '^' and_expr
	;

inclusive_or_expr 
	: exclusive_or_expr
	| inclusive_or_expr '|' exclusive_or_expr
	;

logical_and_expr 
	: inclusive_or_expr
	| logical_and_expr AND_OP inclusive_or_expr
	;

logical_or_expr 
	: logical_and_expr
	| logical_or_expr OR_OP logical_and_expr
	;

conditional_expr //only the first
	: logical_or_expr
	| logical_or_expr '?' expr ':' conditional_expr
	;

assignment_expr //proj4
	: conditional_expr 						
	| unary_expr assignment_operator { decl_tn = check_lval($1);} assignment_expr { $$ = tr_mk_binop($1,$4,ASSIGN,decl_tn); rhs = FALSE;}
	;

assignment_operator //only '='
	: '=' 												{ rhs = TRUE; }
	| MUL_ASSIGN 
	| DIV_ASSIGN 
	| MOD_ASSIGN 
	| ADD_ASSIGN 
	| SUB_ASSIGN
	| LEFT_ASSIGN 
	| RIGHT_ASSIGN 
	| AND_ASSIGN 
	| XOR_ASSIGN 
	| OR_ASSIGN
	;

expr 
	: assignment_expr 				
	| expr ',' assignment_expr 		
	;

constant_expr
	: conditional_expr
	;

expr_opt
	: /* null derive */		{ $$ = NULL; }
	| expr 					
	;

 /*******************************
  * Declarations                *
  *******************************/

declaration //only 2
	: declaration_specifiers ';'						{ error("no declarator in declaration"); }
	| declaration_specifiers init_declarator_list ';' 	{ $$ = $2; }		 
	;

declaration_specifiers //only3,4
	: storage_class_specifier							{ $$ = update_bucket(NULL, $1, NULL); }
	| storage_class_specifier declaration_specifiers	{ $$ = update_bucket($2, $1, NULL); }
	| type_specifier									{ $$ = update_bucket(NULL, $1, NULL); }
	| type_specifier declaration_specifiers				{ $$ = update_bucket($2, $1, NULL); }
	| type_qualifier									{ $$ = update_bucket(NULL, $1, NULL); }
	| type_qualifier declaration_specifiers				{ $$ = update_bucket($2, $1, NULL); }
	;

init_declarator_list //
	: init_declarator 															{ $$ = $1; }
	| init_declarator_list ',' {$<y_bucket>$ = $<y_bucket>0;} init_declarator	{ $$ = $1 + $4; }	
	;

init_declarator //
	: declarator 									{ $$ = mk_type_install($<y_bucket>0, $1); compiler_errors = 0;}
	| declarator '=' {$<y_type>$ = initializer_install($<y_bucket>0, $1);} initializer  { compiler_errors = 0;}//if (in_local == TRUE) {$$ = get_size_basic(ty_query($<y_type>3)); compiler_errors = 0;}
	;

storage_class_specifier 
	: TYPEDEF 										{ $$ = TYPEDEF_SPEC; }
	| EXTERN										{ $$ = EXTERN_SPEC; } 
	| STATIC 										{ $$ = STATIC_SPEC; }
	| AUTO											{ $$ = AUTO_SPEC; } 
	| REGISTER										{ $$ = REGISTER_SPEC; }
	;

type_specifier //
	: VOID 											{ $$ = VOID_SPEC; }
	| CHAR 											{ $$ = CHAR_SPEC; }
	| SHORT											{ $$ = SHORT_SPEC; }
	| INT											{ $$ = INT_SPEC; }
	| LONG 											{ $$ = LONG_SPEC; }
	| FLOAT											{ $$ = FLOAT_SPEC; }
	| DOUBLE										{ $$ = DOUBLE_SPEC; }
	| SIGNED										{ $$ = SIGNED_SPEC; }
	| UNSIGNED										{ $$ = UNSIGNED_SPEC; }
	| struct_or_union_specifier 					{/*do nothing*/}
	| enum_specifier 								{/*do nothing*/}
	| TYPE_NAME 									{/*do nothing*/}
	;

struct_or_union_specifier
	: struct_or_union '{' struct_declaration_list '}'
	| struct_or_union identifier '{' struct_declaration_list '}'
	| struct_or_union identifier
	;

struct_or_union
	: STRUCT
	| UNION
	;

struct_declaration_list
	: struct_declaration
	| struct_declaration_list struct_declaration
	;

struct_declaration
	: specifier_qualifier_list struct_declarator_list ';'
	;

specifier_qualifier_list
	: type_specifier specifier_qualifier_list_opt
	| type_qualifier specifier_qualifier_list_opt
	;

specifier_qualifier_list_opt
	: /* null derive */
	| specifier_qualifier_list
        ;

struct_declarator_list
	: struct_declarator
	| struct_declarator_list ',' struct_declarator
	;

struct_declarator
	: declarator
	| ':' constant_expr
	| declarator ':' constant_expr
	;

enum_specifier
	: ENUM '{' enumerator_list '}'
	| ENUM identifier '{' enumerator_list '}'
	| ENUM identifier
	;

enumerator_list
	: enumerator
	| enumerator_list ',' enumerator
	;

enumerator
	: identifier
	| identifier '=' constant_expr
	;

type_qualifier
	: CONST 										{$$ = CONST_SPEC; }
	| VOLATILE										{$$ = VOLATILE_SPEC; }
	;

declarator //
	: direct_declarator
	| pointer declarator							{ if($1){ $$ = tr_insert_ref($2); }else{ $$ = tr_insert_ptr($2); } }
	;

direct_declarator //
	: identifier									{ $$ = tr_insert_id($1); }
	| '(' declarator ')'							{ $$ = $2; }
	| direct_declarator '[' ']' 					
	| direct_declarator '[' constant_expr ']' 		{ $$ = tr_insert_array($1, $3->u.int_val); }
	| direct_declarator '(' parameter_type_list ')' { $$ = tr_insert_func_params($1, $3); }
	| direct_declarator '(' ')'						{ $$ = tr_insert_func($1); }
	;

pointer //
	: '*' specifier_qualifier_list_opt				{ $$ = FALSE; }
    | '&'											{ $$ = TRUE; }
	;

parameter_type_list //only 1
	: parameter_list
	| parameter_list ',' ELIPSIS
	;

parameter_list //
	: parameter_declaration
	| parameter_list ',' parameter_declaration		{ $$ = add_param_to_list($1, $3); }
	;

parameter_declaration //only1
	: declaration_specifiers declarator				{ $$ = make_param($1, $2);}
	| declaration_specifiers						{ error("no id in parameter list");}
	| declaration_specifiers abstract_declarator 	{/*do nothing*/}
	;

type_name
	: specifier_qualifier_list
	| specifier_qualifier_list abstract_declarator
	;

abstract_declarator
	: pointer
	| direct_abstract_declarator
	| pointer abstract_declarator
	;

direct_abstract_declarator
	: '(' abstract_declarator ')'
	| '[' ']'
	| '[' constant_expr ']'
	| direct_abstract_declarator '[' ']'
	| direct_abstract_declarator '[' constant_expr ']'
	| '(' ')'
	| '(' parameter_type_list ')'
	| direct_abstract_declarator '(' ')'
	| direct_abstract_declarator '(' parameter_type_list ')'
	;

initializer //
	: assignment_expr 						{ if (compiler_errors == 0){ assign_val($<y_type>0, $1); } compiler_errors = 0;}
	| '{' {$<y_int>$ = get_dim($<y_type>0);} {$<y_type>$ = get_ar_type($<y_type>0);} initializer_list comma_opt '}'  {ar_init_reduce( $<y_int>2, $<y_type>3, $4);}
	; 

comma_opt //
	: /* Null derive */
	| ','
	;

initializer_list //
	: initializer 													{ $$ = 0;}
	| initializer_list ',' {$<y_type>$ = $<y_type>0;} initializer 	{ $$ = $1 + 1;}
	;

 /*******************************
  * Statements                  *
  *******************************/

statement //only2,3,4
	: labeled_statement 	//{message("labeled_statement done!");}
	| compound_statement 	
	| expression_statement  //{message("expression_statement done!");}
	| selection_statement 	//{message("selection_statement done!");}
	| iteration_statement	//{message("iteration_statement done!");}
	| jump_statement		//{message("jump_statement done!");}
	;

labeled_statement
	: identifier ':' statement
	| CASE constant_expr ':' {case_act($2);} statement 
	| DEFAULT ':' statement 			{ def_reduce(); }
	;

compound_statement //
	: '{' '}'
	| '{' statement_list '}'  									
	| '{' declaration_list {en_loc_code($2);} '}'
	| '{' declaration_list {en_loc_code($2);} statement_list '}'
	;

declaration_list //
	: declaration 						
	| declaration_list declaration 		{ $$ = $1 + $2; }
	;

statement_list //
	: statement  //{message("statement_list done!");}
	| statement_list statement
	;

expression_statement //
	: expr_opt ';'			{ en_eval_expr($1); compiler_errors = 0;}
	;

selection_statement// proj3
	: IF '(' expr ')' if_action statement {b_label($5);compiler_errors = 0;}
	| IF '(' expr ')' if_action statement ELSE {char * label = new_symbol();b_jump(label);$<y_string>$ = label; b_label($5);} statement {b_label($<y_string>8);compiler_errors = 0;}
	| SWITCH {rhs = TRUE;} '(' expr ')' {$<y_string>$ = switch_cond($4);} statement { switch_reduce($<y_string>6); }
	;

if_action
	:/*empty*/ 				{ char* otherwise = if_cond($<y_tn>-1); $$ = otherwise; }
	;

iteration_statement
	: WHILE '(' expr ')' {$<y_string>$ = while_cond1();} {$<y_string>$ = while_cond2($3);} statement {while_reduce($<y_string>5, $<y_string>6); compiler_errors = 0;} 
	| DO statement WHILE '(' expr ')' ';'
	| FOR '(' expr_opt ';' expr_opt ';' expr_opt ')' {$<y_string>$ = for_cond1($3);} {$<y_string>$ = for_cond2($5);} statement {for_reduce($7,$<y_string>9,$<y_string>10); compiler_errors = 0;}
	;

jump_statement
	: GOTO identifier ';'
	| CONTINUE ';'
	| BREAK ';'				{ break_act(); compiler_errors = 0; has_break = TRUE; }
	| RETURN expr_opt ';' 	{ ret_eval($2); compiler_errors = 0;}
	;

 /*******************************
  * Top level                   *
  *******************************/

translation_unit //
	: external_declaration
	| translation_unit external_declaration
	;

external_declaration //
	: function_definition  
	| declaration 			//{ message("error_cnt:%d", compiler_errors);}
	;

function_definition //
	: declarator {$<y_string>$ = mk_func(NULL, $1);} {$<y_string>$ = new_symbol();} compound_statement {en_func_reduce($<y_string>2, $<y_string>3); /*in_local = FALSE;*/}
	| declaration_specifiers declarator {$<y_string>$ = mk_func($1, $2);} {$<y_string>$ = new_symbol();} compound_statement {en_func_reduce($<y_string>3, $<y_string>4);}
	;

 /*******************************
  * Identifiers                 *
  *******************************/

identifier //
	: IDENTIFIER		{ $$ = st_enter_id($1); }
	;
%%

extern int column;

int yyerror(char *s)
{
	error("%s (column %d)",s,column);
        return 0;  /* never reached */
}


/*******************************************************
The following functions support the acitons in grammar
********************************************************/

TYPE mk_type(BUCKET_PTR bucket, DECL_ND_PTR head);
BOOLEAN install_global_symbol(ST_ID id, TYPE type, STORAGE_CLASS sc);
ST_ID get_id_from_tree(DECL_ND_PTR head);
BOOLEAN is_ref(DECL_ND_PTR head);
BOOLEAN install_func(ST_ID id, TYPE type);


/* Checks if '&' exists in the tree*/
BOOLEAN is_ref(DECL_ND_PTR head) {
	while (head != NULL) {
		if (head->tag == REF_DECL) {		
			return TRUE; 
		}
		head =  head->next;
	}
	return FALSE; 
}

/* Make type from the type tree */
TYPE mk_type(BUCKET_PTR bucket, DECL_ND_PTR head) {
	//build basic type from bucket
	TYPE type = build_base(bucket);
	//make the type bottom up from the tree
	while(head != NULL) {
		if (head->tag == ARR_DECL) {
			type = ty_build_array(type, DIM_PRESENT, head->u.arr_size);
		}
		if (head->tag == PTR_DECL) {
			type = ty_build_ptr(type, NO_QUAL);
		}
		if (head->tag == FUNC_DECL) {
			type = ty_build_func(type, PROTOTYPE, head->u.params);
		}
		if (head->tag == ID_DECL) {
			break;
		}
		head = head->next;
	}
	return type;
}

/* Find the identifier from tree */
ST_ID get_id_from_tree(DECL_ND_PTR head) {
	ST_ID id = NULL;
	while(head != NULL) {
		if (head->tag == ID_DECL) {
			id = head->u.id;
		}
		head = head->next;
	}
	return id;
}

/* 1. Make type 2. Install in symbol table 3. Generate assembly code */
int mk_type_install(BUCKET_PTR bucket, DECL_ND_PTR head) {

	ST_ID id = get_id_from_tree(head);
	//make type
	TYPE type = mk_type(bucket, head);
	STORAGE_CLASS sc = get_class(bucket);

	TYPETAG tag = ty_query(type);
	TYPETAG finalTag = tag;

	//if in compound_stmt, skip globol symtab and backend actions
	/*if (in_local == TRUE) {
		return get_size_basic(tag);
	}*/

	if (install_global_symbol(id, type, sc) == FALSE) {
		return 0;
	}

	DIMFLAG dimflag;
	unsigned int total_dim = 1;
	TYPE temp = type;

	//check if an array declarator is leagal
	int i = 0;
	while (tag == TYARRAY) {
		unsigned int dim;
		temp = ty_query_array(temp, &dimflag, &dim);
		total_dim *= dim;
		//value smaller than 1 is not accepted
		if (dim < 1) {
			error("illegal array dimension\n");
		}
		tag = ty_query(temp);
		//array follow by a func is not accepted
		if (tag == TYFUNC) {
			error("cannot have array of functions");
			return 0;
		}
	}

	//check if an func declarator is leagal
	if (tag == TYFUNC) {
		PARAMSTYLE paramstyle;
		PARAM_LIST params;
		type = ty_query_func(type, &paramstyle, &params);
		tag = ty_query(type);
		//func follow by a func is not accepted
		if (tag == TYFUNC) {
			error("cannot have function returning function");
			return 0;
		}
		if (tag == TYARRAY) {
			error("cannot have function returning array");
			return 0;
		}
	}

	//no need to spit out code for funcs
	if (finalTag == TYFUNC) {
		return 0;
	}
	//gen assembly code only if no error

	if (compiler_errors == 0) {

		spit_code(id, tag, total_dim);
	}

	return 0;
}

/* 1. Make type 2. Install in symbol table 3. Generate assembly code */
char* mk_func(BUCKET_PTR bucket, DECL_ND_PTR head) {
	
	//Turn on local flg
	//in_local = TRUE;

	//if no typespecifier, the default should be int
	if (bucket == NULL){
		bucket = update_bucket(NULL, INT_SPEC, NULL);
	}

	//get id and function name
	ST_ID id = get_id_from_tree(head);
	char* f_name = st_get_id_str(id);


	//make type
	TYPE type = mk_type(bucket, head);

	TYPETAG tag = ty_query(type);

	//check if an func declarator is leagal
	PARAMSTYLE paramstyle;
	PARAM_LIST params;
	if (tag == TYFUNC) {

		type = ty_query_func(type, &paramstyle, &params);
		TYPETAG temp_tag = ty_query(type);
		//func follow by a func is not accepted
		tag = temp_tag;
		if (temp_tag == TYFUNC) {
			error("cannot have function returning function");
			return f_name;
		}
		if (temp_tag == TYARRAY) {
			error("cannot have function returning array");
			return f_name;
		}
	}
	else{
		error("Expected a function declarator here!");
		return f_name;
	}
	func_ret = tag;
		
	//install fcn into the symtab as FDECL
	install_func(id, type);

	//push a new local scope
	st_enter_block();

	//throw out assembly code and install params into symtab
	en_func( id, params);

	compiler_errors = 0;

	return f_name;
}


/* Install on symbol table */
BOOLEAN install_global_symbol(ST_ID id, TYPE type, STORAGE_CLASS sc) {
	ST_DR st_dr = stdr_alloc();
	st_dr->tag = GDECL;
	st_dr->u.decl.type = type;
	st_dr->u.decl.sc = sc;
	if (st_install(id, st_dr) == FALSE) {
		error("duplicate declaration for %s", st_get_id_str(id));
		error("duplicate definition of `%s'", st_get_id_str(id));
		return FALSE;
	}
	return TRUE;
}

/* Install function into symbol table */
BOOLEAN install_func(ST_ID id, TYPE type) 
{
	int block;
	ST_DR rec = st_lookup(id, &block);

	if (rec == NULL){
		ST_DR st_dr = stdr_alloc();
		st_dr->tag = FDECL;
		st_dr->u.decl.type = type;
		st_dr->u.decl.sc = NO_SC;
		if (st_install(id, st_dr) == FALSE) {
			error("duplicate declaration for %s", st_get_id_str(id));
			error("duplicate definition of `%s'", st_get_id_str(id));
			return FALSE;
		}
		return TRUE;
	}
	else{
		if (rec->tag != FDECL){
			//not declare as a function
			if(ty_query(rec->u.decl.type)!=TYFUNC){
				error("duplicate or incompatible function declaration `%s'", st_get_id_str(id));
				compiler_errors = 0;//wait check
			}
			ST_DR st_dr = stdr_alloc();
			st_dr->tag = FDECL;
			st_dr->u.decl.type = type;
			st_dr->u.decl.sc = NO_SC;
			if (st_replace(id, st_dr) == FALSE) {
				error("duplicate or incompatible function declaration `%s'", st_get_id_str(id));
				compiler_errors = 0;//wait check
				return FALSE;
			}
		}
		else{
			error("duplicate or incompatible function declaration `%s'", st_get_id_str(id));
			compiler_errors = 0;//wait check 
			return FALSE;
		}
	}
}


/*******************************************************
The following functions help construct PARAM_LIST
********************************************************/

/* Make param list */
PARAM_LIST make_param(BUCKET_PTR bucket, DECL_ND_PTR head)
{
    TYPE type = mk_type(bucket, head);
    ST_ID id = get_id_from_tree(head);
    PARAM_LIST param = plist_alloc();
    param->id = id;
    param->type = type;
    param->next = NULL;
    param->prev = NULL;
    param->is_ref = is_ref(head);
    tr_free_tree(head);
    return param;
}

/* Add a param to a param list, need return the head node instead of the last one */
PARAM_LIST add_param_to_list(PARAM_LIST pre_pl, PARAM_LIST new_pl)
{
	PARAM_LIST temp = pre_pl;
	if (temp->id == new_pl->id) {
		error("duplicate parameter declaration for `%s'", st_get_id_str(new_pl->id));
	}
	while (temp->next != NULL){
		if ((temp->next)->id == new_pl->id) {
			error("duplicate parameter declaration for `%s'", st_get_id_str(new_pl->id));
		}
		temp = temp->next;
	}
	temp->next = new_pl;
	new_pl->prev = temp;
	return pre_pl;
}


/*******************************************************
The following functions help install the initializer
********************************************************/

/* 1. Make type 2. Install in symbol table 3. Allocate memory for assembly code
   Do not assing value for this func */ 
TYPE initializer_install(BUCKET_PTR bucket, DECL_ND_PTR head) {
	ST_ID id = get_id_from_tree(head);
	//make type
	TYPE type = mk_type(bucket, head);
	STORAGE_CLASS sc = get_class(bucket);
	TYPE ret = type;
	TYPETAG tag = ty_query(type);
	TYPETAG finalTag = tag;
	DIMFLAG dimflag;
	unsigned int total_dim = 1;

	//function is not leagal in an left side of assignment
	if (tag == TYFUNC) {
			error("cannot assign value to a function");
			return ret;
	}
	//check if an array declarator is leagal
	TYPE temp = type;
	while (tag == TYARRAY) {
		unsigned int dim;
		temp = ty_query_array(temp, &dimflag, &dim);
		total_dim *= dim;
		//value smaller than 1 is not accepted
		if (dim < 1) {
			total_dim = 0;
			break;
		}
		tag = ty_query(temp);
		//array follow by a func is not accepted
		if (tag == TYFUNC) {
			error("cannot have array of functions");
			return ret;
		}
	}

	if (total_dim < 1) {
		error("illegal array dimension\n");
		return ret;
	}
	if (install_global_symbol(id, ret, sc) == FALSE) {
		return ret;
	}

	//gen assembly code only if no error
	if (compiler_errors == 0) {
		code_alloc(id, tag, total_dim);
	}
	compiler_errors = 0; //essential for missing error line
	return ret;
}

/*Get the dimension from type, and check TYPETAG*/
unsigned int get_dim(TYPE type)
{	
	TYPETAG tag = ty_query(type);
	if (tag != TYARRAY){
		error("initializer list for non-array type");
		return 0;
	}

	//get the dimension and type
	DIMFLAG dimflag;
	unsigned int dim;
	type = ty_query_array(type, &dimflag, &dim);
	return dim;
}

/*Get the type from TYPETAG of a TYARRAY*/
TYPE get_ar_type(TYPE type)
{	
	TYPETAG tag = ty_query(type);

	if (tag == TYARRAY){
		DIMFLAG dimflag;
		unsigned int dim;
		return ty_query_array(type, &dimflag, &dim);
	}
	return type;
}

void ar_init_reduce(unsigned int dim, TYPE type, int cnt)
{	
	TYPETAG tag = ty_query(type);
    DIMFLAG dimflag;
    if (dim == 0){
    	return;
    }

	if (dim-1 < cnt){
		error("too many items in initializer");
		return;
	}
	if ((dim-1-cnt) > 0){
		//skip space for unassigned values
		partial_assign_skip(type, dim-1-cnt);
		compiler_errors = 0;
	}
	return;
}


TN check_lval(TN tree)
{
	if (tree == NULL){
		return NULL;//this mean the identifier is not defined
	}
	//find the leaf node for the possible unary_expr, e.g,--d, -d, ++d, ...
	TN temp_tree = tree;
	while (temp_tree->tag == UNOP){
		if (temp_tree->u.unop_node.op == STAR){
			return tree;
		}
		temp_tree = temp_tree->u.unop_node.link;
	}
	if (temp_tree->tag != VAR){
		//e.g, 3 = 1, 1.2 = 2,...are invalid lhs expressions
		error("left side of assignment is not an l-value");
		return NULL;
	}
	//check if the identifier is a function, funcs are invalid
	int block;
	ST_DR st_dr;
	TYPETAG tag;
    st_dr = st_lookup(temp_tree->u.id, &block);
    TYPETAG temp_tag = ty_query(st_dr->u.decl.type);
    if (st_dr->tag == FDECL){
    	error("left side of assignment is not an l-value");
    	return NULL;
    }
    else{
    	if (temp_tag == TYFUNC){
	    	error("left side of assignment is not an l-value");
	    	return NULL;	
    	}
    }
	return tree;//valid l-val must be a VAR node and has a ST_DR that is not a TYFUNC
}

/*******************************************************
The following functions supports statments (proj3)
********************************************************/

char* if_cond(TN tree)
{
	en_eval_tn(tree);
	if(tree->tag == VAR){
		b_deref(ty_query(tree->type));
	}
	char * label = new_symbol();
	TYPETAG tag = ty_query(tree->type);
	PARAMSTYLE paramstyle;
	PARAM_LIST params;
	TYPE temp_type;
	if (tag == TYFUNC){
		temp_type = ty_query_func(tree->type, &paramstyle, &params);
		tag = ty_query(temp_type);
	}
	b_cond_jump(tag, B_ZERO, label);
	return label;
}

char* while_cond1()
{
	char * start = new_symbol();
	b_label(start);
	return start;
}

char* while_cond2(TN tree)
{
	TYPETAG tag = ty_query(tree->type);
	en_eval_tn(tree);
	char * exit = new_symbol();
	b_cond_jump(tag, B_ZERO, exit);
	push(WHILELOOP, exit);
	return exit;
}

void while_reduce(char* start, char* exit)
{
	b_jump(start);
	b_label(exit); 
	//clear the stack
	if (has_break == FALSE){
		pop();
	}
	else{
		has_break = FALSE;
	}
	
} 

void ret_eval(TN tree)
{
	TYPETAG ret = ty_query(tree->type);
	if (func_ret != ret){
		en_eval_tn(tree);
		b_convert(ret,func_ret);
		b_encode_return(func_ret);
	}
	else{
		en_eval_tn(tree);
		b_encode_return(func_ret);
	}
}

static void push(STACKTAG sktag, char* label)
{
	SR sk_rec = (SR) malloc (sizeof(STACK_REC));
	sk_rec->sktag = sktag;
	sk_rec->label = label;
	sk_rec->next = NULL;
	if (stack == NULL){
		stack = sk_rec;
	}
	else{
		sk_rec->next = stack;
		stack = sk_rec;
	}
}

static char* pop()
{
	SR temp = stack;
	char* label;
	if (stack == NULL){
		return NULL;
	}
	else{
		label = stack->label;
		stack = stack->next;
		return label;
	}
}

void break_act()
{
	if (stack == NULL){
		error("break not inside switch or loop");
		return;
	}
	else if (stack->sktag == SWITCHCASE) {
		b_jump(stack->label);
		return;	
	}
	else {
		b_jump(pop());
		return;
	}
}

char* for_cond1(TN init)
{
	if (init != NULL){
		en_eval_expr(init);
	}
	char* test = new_symbol();
	b_label(test);
	return test;
}

char* for_cond2(TN test)
{
	char* exit = new_symbol();
	push(FORLOOP, exit);
	if (test != NULL){
		en_eval_tn(test);
		TYPETAG tag = ty_query(test->type);
		b_cond_jump(tag, B_ZERO, exit);	
	}
	return exit;

}

void for_reduce(TN tree, char* test, char* exit)
{
	if (tree != NULL){
		en_eval_expr(tree);
	}
	b_jump(test);
	b_label(exit);
	//clear the stack
	if (has_break == FALSE){
		pop();
	}
	else{
		has_break = FALSE;
	}

}


char* switch_cond(TN tree)
{
	char* exit = new_symbol();
	push(SWITCHCASE, exit);
	if(tree == NULL){
		error("No switch expression");
		return exit;
	}
	TYPETAG tag = ty_query(tree->type); 
	TYPE temp_type;
	PARAMSTYLE paramstyle;
	PARAM_LIST params;
	if (tag == TYFUNC){
		temp_type = ty_query_func(tree->type, &paramstyle, &params);
		tag = ty_query(temp_type);
	}	
	if (tag != TYSIGNEDINT && tag != TYSIGNEDCHAR){
		error("switch expression not of integral type");
		return exit;
	}
	en_eval_tn(tree);
	if(tag == TYSIGNEDCHAR){
		b_convert(TYSIGNEDCHAR,TYSIGNEDINT);
	}
	b_jump(exit);
	rhs = FALSE;
	return exit;
}


void case_act(TN tree)
{
	if (ty_query(tree->type) != TYSIGNEDINT){
		error("switch expression not of integral type");
		return;
	}
	char* case_label = new_symbol();
	CR cr = (CR) malloc(sizeof(CASE_REC));
	cr->val = tree->u.int_val;
	cr->label = case_label;
	cr->next = NULL;
	SR temp_sr = stack;
	CR temp_cr;
	b_label(case_label);
	if (temp_sr == NULL){
		error("case label not inside switch");
		return;
	}
	else{
		while(temp_sr->sktag != SWITCHCASE){
			temp_sr = temp_sr->next;
			if (temp_sr == NULL){
				error("case label not inside switch");
				return;
			}
		}
		if (temp_sr->cr == NULL){
			temp_sr->cr = cr;
			return;
		}
		else{
			//check duplicate
			temp_cr = temp_sr->cr;
			while(temp_cr != NULL){
				if (temp_cr->val == tree->u.int_val){
					error("duplicate value in case label: %d",tree->u.int_val);
					return;
				}
				temp_cr = temp_cr->next;
			}
		}
		cr->next = temp_sr->cr;
		temp_sr->cr = cr;
	}
	
}

void switch_reduce(char* sw_label)
{
	char* label = new_symbol();
	b_jump(label);
	
	SR sr;
	while(stack != NULL){
		if(stack->sktag == SWITCHCASE){
			sr = stack;
			if (sr->default_on == TRUE){
				has_default = TRUE;
			}
			else{
				has_default = FALSE;
			}
			pop();
			break;
		}
		pop();
	}

	CR cr = sr->cr;
	while(cr != NULL){
		b_dispatch (B_EQ, TYSIGNEDINT, cr->val, cr->label, TRUE);
		cr = cr->next;
	}
	b_pop();
	if ( has_default == TRUE){
		b_jump(sw_label);
	}
	b_label(label);
	has_default = FALSE;
	compiler_errors = 0;
}

void def_reduce()
{
	SR temp_sr;
	if (stack == NULL){
		error("default label not inside switch");
		return;
	}
	else{
		temp_sr = stack;
		while(temp_sr->sktag != SWITCHCASE){
			temp_sr = temp_sr->next;
			if (temp_sr == NULL){
				error("default label not inside switch");
				return;
			}
		}
		if (temp_sr->default_on != TRUE){
			temp_sr->default_on = TRUE;
			has_default = TRUE;
			return;
		}
		else{
			error("duplicate default label inside switch");
		}
	}
}

