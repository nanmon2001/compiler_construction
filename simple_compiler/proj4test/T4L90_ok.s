 #    2
 #    3
 #    4
 #    5
				# b_global_decl (i, alignment = 4, size = 4)
.globl i
	.data
	.align	4
	.type	i, @object
	.size	i, 4
i:
	.zero	4
				# b_global_decl (j, alignment = 4, size = 4)
.globl j
	.align	4
	.type	j, @object
	.size	j, 4
j:
	.zero	4
				# b_global_decl (pi, alignment = 4, size = 4)
.globl pi
	.align	4
	.type	pi, @object
	.size	pi, 4
pi:
	.zero	4
				# b_global_decl (ppi, alignment = 4, size = 4)
.globl ppi
	.align	4
	.type	ppi, @object
	.size	ppi, 4
ppi:
	.zero	4
 #    6
 #    7
				# b_global_decl (f, alignment = 4, size = 4)
.globl f
	.align	4
	.type	f, @object
	.size	f, 4
f:
	.zero	4
				# b_global_decl (pf, alignment = 4, size = 4)
.globl pf
	.align	4
	.type	pf, @object
	.size	pf, 4
pf:
	.zero	4
 #    8
 #    9
				# b_global_decl (c, alignment = 1, size = 1)
.globl c
	.align	1
	.type	c, @object
	.size	c, 1
c:
	.zero	1
				# b_global_decl (s1, alignment = 4, size = 4)
.globl s1
	.align	4
	.type	s1, @object
	.size	s1, 4
s1:
	.zero	4
				# b_global_decl (s2, alignment = 4, size = 4)
.globl s2
	.align	4
	.type	s2, @object
	.size	s2, 4
s2:
	.zero	4
 #   10
 #   11
				# b_global_decl (pppi, alignment = 4, size = 4)
.globl pppi
	.align	4
	.type	pppi, @object
	.size	pppi, 4
pppi:
	.zero	4
 #   12
 #   13
				# b_global_decl (ai, alignment = 4, size = 40)
.globl ai
	.align	4
	.type	ai, @object
	.size	ai, 40
ai:
	.zero	40
				# b_global_decl (aai, alignment = 4, size = 400)
.globl aai
	.align	4
	.type	aai, @object
	.size	aai, 400
aai:
	.zero	400
				# b_global_decl (aaai, alignment = 4, size = 4000)
.globl aaai
	.align	4
	.type	aaai, @object
	.size	aaai, 4000
aaai:
	.zero	4000
 #   14
				# b_global_decl (af, alignment = 4, size = 40)
.globl af
	.align	4
	.type	af, @object
	.size	af, 40
af:
	.zero	40
 #   15
				# b_global_decl (as, alignment = 1, size = 10)
.globl as
	.align	1
	.type	as, @object
	.size	as, 10
as:
	.zero	10
 #   16
				# b_global_decl (ad, alignment = 8, size = 104)
.globl ad
	.align	8
	.type	ad, @object
	.size	ad, 104
ad:
	.zero	104
				# b_global_decl (dp, alignment = 4, size = 4)
.globl dp
	.align	4
	.type	dp, @object
	.size	dp, 4
dp:
	.zero	4
 #   17
 #   18
				# b_global_decl (x, alignment = 4, size = 40)
.globl x
	.align	4
	.type	x, @object
	.size	x, 40
x:
	.zero	40
 #   19
 #   20
 #   21
 #   22
 #   23
 #   24
				# b_func_prologue (main)
	.text
.global main
	.type	main, @function
main:
	pushl	%ebp
	movl	%esp, %ebp
	andl	$-16, %esp
 #   25
				# b_push_ext_addr (i)
	subl	$8, %esp
	movl	$i, (%esp)
				# b_push_const_int (13)
	movl	$13, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_assign (signed int)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   26
				# b_push_ext_addr (j)
	subl	$8, %esp
	movl	$j, (%esp)
				# b_push_const_int (19)
	movl	$19, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_assign (signed int)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   27
				# b_push_ext_addr (pi)
	subl	$8, %esp
	movl	$pi, (%esp)
				# b_push_ext_addr (i)
	subl	$8, %esp
	movl	$i, (%esp)
				# b_assign (pointer)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   28
				# b_push_ext_addr (ppi)
	subl	$8, %esp
	movl	$ppi, (%esp)
				# b_push_ext_addr (pi)
	subl	$8, %esp
	movl	$pi, (%esp)
				# b_assign (pointer)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   29
				# b_push_ext_addr (c)
	subl	$8, %esp
	movl	$c, (%esp)
				# b_push_const_int (97)
	movl	$97, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_assign (signed char)
	movzbl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movb	%dl, (%eax)
	movb	%dl, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   30
 #   31
				# b_push_ext_addr (s1)
	subl	$8, %esp
	movl	$s1, (%esp)
				# b_push_ext_addr (as)
	subl	$8, %esp
	movl	$as, (%esp)
				# b_push_const_int (5)
	movl	$5, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 1)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$1, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_assign (pointer)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   32
				# b_push_ext_addr (s2)
	subl	$8, %esp
	movl	$s2, (%esp)
				# b_push_ext_addr (as)
	subl	$8, %esp
	movl	$as, (%esp)
				# b_push_const_int (9)
	movl	$9, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 1)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$1, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_assign (pointer)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   33
				# b_push_ext_addr (i)
	subl	$8, %esp
	movl	$i, (%esp)
				# b_push_ext_addr (s2)
	subl	$8, %esp
	movl	$s2, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_ext_addr (s1)
	subl	$8, %esp
	movl	$s1, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_ptr_arith_op ( - , pointer, size = 1)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	subl	%edx, %eax
	movl	%eax, (%esp)
				# b_assign (signed int)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   34
				# b_alloc_arglist (0 bytes)
	movl	%esp, %eax
	subl	$4, %esp
	andl	$-16, %esp
	movl	%eax, (%esp)
	subl	$0, %esp
				# b_funcall_by_name (print_ints, signed int)
	call	print_ints
	addl	$0, %esp
	movl	(%esp), %ecx
	movl	%ecx, %esp
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   35
 #   36
				# b_push_ext_addr (i)
	subl	$8, %esp
	movl	$i, (%esp)
				# b_push_ext_addr (as)
	subl	$8, %esp
	movl	$as, (%esp)
				# b_push_ext_addr (j)
	subl	$8, %esp
	movl	$j, (%esp)
				# b_deref (signed int)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 1)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$1, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_push_ext_addr (s1)
	subl	$8, %esp
	movl	$s1, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_ptr_arith_op ( - , pointer, size = 1)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	subl	%edx, %eax
	movl	%eax, (%esp)
				# b_assign (signed int)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   37
				# b_alloc_arglist (0 bytes)
	movl	%esp, %eax
	subl	$4, %esp
	andl	$-16, %esp
	movl	%eax, (%esp)
	subl	$0, %esp
				# b_funcall_by_name (print_ints, signed int)
	call	print_ints
	addl	$0, %esp
	movl	(%esp), %ecx
	movl	%ecx, %esp
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   38
 #   39
				# b_push_ext_addr (s1)
	subl	$8, %esp
	movl	$s1, (%esp)
				# b_push_ext_addr (s1)
	subl	$8, %esp
	movl	$s1, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_const_int (1)
	movl	$1, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 1)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$1, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_assign (pointer)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   40
				# b_push_ext_addr (s2)
	subl	$8, %esp
	movl	$s2, (%esp)
				# b_push_ext_addr (s2)
	subl	$8, %esp
	movl	$s2, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_const_int (3)
	movl	$3, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_ptr_arith_op ( - , signed int, size = 1)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$1, %edx, %edx
	negl	%edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_assign (pointer)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   41
				# b_alloc_arglist (0 bytes)
	movl	%esp, %eax
	subl	$4, %esp
	andl	$-16, %esp
	movl	%eax, (%esp)
	subl	$0, %esp
				# b_funcall_by_name (print_chars, signed int)
	call	print_chars
	addl	$0, %esp
	movl	(%esp), %ecx
	movl	%ecx, %esp
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   42
 #   43
				# b_push_ext_addr (dp)
	subl	$8, %esp
	movl	$dp, (%esp)
				# b_push_ext_addr (ad)
	subl	$8, %esp
	movl	$ad, (%esp)
				# b_push_const_int (4)
	movl	$4, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 8)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$8, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_assign (pointer)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   44
				# b_alloc_arglist (0 bytes)
	movl	%esp, %eax
	subl	$4, %esp
	andl	$-16, %esp
	movl	%eax, (%esp)
	subl	$0, %esp
				# b_funcall_by_name (print_dp, signed int)
	call	print_dp
	addl	$0, %esp
	movl	(%esp), %ecx
	movl	%ecx, %esp
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   45
				# b_push_ext_addr (dp)
	subl	$8, %esp
	movl	$dp, (%esp)
				# b_push_ext_addr (dp)
	subl	$8, %esp
	movl	$dp, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_const_int (1)
	movl	$1, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 8)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$8, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_assign (pointer)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   46
				# b_alloc_arglist (0 bytes)
	movl	%esp, %eax
	subl	$4, %esp
	andl	$-16, %esp
	movl	%eax, (%esp)
	subl	$0, %esp
				# b_funcall_by_name (print_dp, signed int)
	call	print_dp
	addl	$0, %esp
	movl	(%esp), %ecx
	movl	%ecx, %esp
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   47
 #   48
				# b_push_ext_addr (ppi)
	subl	$8, %esp
	movl	$ppi, (%esp)
				# b_push_ext_addr (ppi)
	subl	$8, %esp
	movl	$ppi, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_const_int (2)
	movl	$2, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 4)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$4, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_assign (pointer)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   49
				# b_alloc_arglist (0 bytes)
	movl	%esp, %eax
	subl	$4, %esp
	andl	$-16, %esp
	movl	%eax, (%esp)
	subl	$0, %esp
				# b_funcall_by_name (print_ints, signed int)
	call	print_ints
	addl	$0, %esp
	movl	(%esp), %ecx
	movl	%ecx, %esp
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   50
 #   51
				# b_push_ext_addr (j)
	subl	$8, %esp
	movl	$j, (%esp)
				# b_push_const_int (0)
	movl	$0, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_assign (signed int)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   52
				# b_push_ext_addr (pi)
	subl	$8, %esp
	movl	$pi, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_ext_addr (j)
	subl	$8, %esp
	movl	$j, (%esp)
				# b_deref (signed int)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 4)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$4, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_push_ext_addr (pi)
	subl	$8, %esp
	movl	$pi, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_ext_addr (j)
	subl	$8, %esp
	movl	$j, (%esp)
				# b_deref (signed int)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 4)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$4, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_deref (signed int)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_const_int (4)
	movl	$4, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_arith_rel_op ( * , signed int)
	movl	(%esp), %ecx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	%ecx, %eax
	movl	%eax, (%esp)
				# b_assign (signed int)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   53
				# b_alloc_arglist (0 bytes)
	movl	%esp, %eax
	subl	$4, %esp
	andl	$-16, %esp
	movl	%eax, (%esp)
	subl	$0, %esp
				# b_funcall_by_name (print_ints, signed int)
	call	print_ints
	addl	$0, %esp
	movl	(%esp), %ecx
	movl	%ecx, %esp
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   54
 #   55
				# b_push_ext_addr (i)
	subl	$8, %esp
	movl	$i, (%esp)
				# b_push_const_int (0)
	movl	$0, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_assign (signed int)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   56
.LC1:
				# b_push_ext_addr (i)
	subl	$8, %esp
	movl	$i, (%esp)
				# b_deref (signed int)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_const_int (10)
	movl	$10, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_arith_rel_op ( < , signed int)
	movl	(%esp), %ecx
	addl	$8, %esp
	movl	(%esp), %eax
	cmpl	%ecx, %eax
	setl	%al
	movzbl	%al, %eax
	movl	%eax, (%esp)
				# b_cond_jump (signed int, ZERO,
				#              .LC2)
	movl	(%esp), %eax
	addl	$8, %esp
	testl	%eax, %eax
	je	.LC2
 #   57
				# b_push_ext_addr (ai)
	subl	$8, %esp
	movl	$ai, (%esp)
				# b_push_ext_addr (i)
	subl	$8, %esp
	movl	$i, (%esp)
				# b_deref (signed int)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_ext_addr (j)
	subl	$8, %esp
	movl	$j, (%esp)
				# b_deref (signed int)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_arith_rel_op ( + , signed int)
	movl	(%esp), %ecx
	addl	$8, %esp
	movl	(%esp), %eax
	addl	%ecx, %eax
	movl	%eax, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 4)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$4, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_push_ext_addr (i)
	subl	$8, %esp
	movl	$i, (%esp)
				# b_deref (signed int)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_ext_addr (i)
	subl	$8, %esp
	movl	$i, (%esp)
				# b_deref (signed int)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_arith_rel_op ( * , signed int)
	movl	(%esp), %ecx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	%ecx, %eax
	movl	%eax, (%esp)
				# b_assign (signed int)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   58
				# b_push_ext_addr (i)
	subl	$8, %esp
	movl	$i, (%esp)
				# b_push_ext_addr (i)
	subl	$8, %esp
	movl	$i, (%esp)
				# b_deref (signed int)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_const_int (1)
	movl	$1, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_arith_rel_op ( + , signed int)
	movl	(%esp), %ecx
	addl	$8, %esp
	movl	(%esp), %eax
	addl	%ecx, %eax
	movl	%eax, (%esp)
				# b_assign (signed int)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   59
				# b_jump ( destination = .LC1 )
	jmp	.LC1
.LC2:
 #   60
				# b_alloc_arglist (0 bytes)
	movl	%esp, %eax
	subl	$4, %esp
	andl	$-16, %esp
	movl	%eax, (%esp)
	subl	$0, %esp
				# b_funcall_by_name (print_ai, signed int)
	call	print_ai
	addl	$0, %esp
	movl	(%esp), %ecx
	movl	%ecx, %esp
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   61
 #   62
				# b_push_ext_addr (j)
	subl	$8, %esp
	movl	$j, (%esp)
				# b_push_const_int (0)
	movl	$0, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_assign (signed int)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   63
				# b_push_ext_addr (i)
	subl	$8, %esp
	movl	$i, (%esp)
				# b_push_const_int (0)
	movl	$0, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_assign (signed int)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   64
.LC3:
				# b_push_ext_addr (i)
	subl	$8, %esp
	movl	$i, (%esp)
				# b_deref (signed int)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_const_int (10)
	movl	$10, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_arith_rel_op ( < , signed int)
	movl	(%esp), %ecx
	addl	$8, %esp
	movl	(%esp), %eax
	cmpl	%ecx, %eax
	setl	%al
	movzbl	%al, %eax
	movl	%eax, (%esp)
				# b_cond_jump (signed int, ZERO,
				#              .LC4)
	movl	(%esp), %eax
	addl	$8, %esp
	testl	%eax, %eax
	je	.LC4
 #   65
				# b_push_ext_addr (ai)
	subl	$8, %esp
	movl	$ai, (%esp)
				# b_push_ext_addr (i)
	subl	$8, %esp
	movl	$i, (%esp)
				# b_deref (signed int)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 4)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$4, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_push_ext_addr (ai)
	subl	$8, %esp
	movl	$ai, (%esp)
				# b_push_ext_addr (i)
	subl	$8, %esp
	movl	$i, (%esp)
				# b_deref (signed int)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 4)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$4, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_deref (signed int)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_ext_addr (ai)
	subl	$8, %esp
	movl	$ai, (%esp)
				# b_push_const_int (10)
	movl	$10, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_push_ext_addr (i)
	subl	$8, %esp
	movl	$i, (%esp)
				# b_deref (signed int)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_arith_rel_op ( - , signed int)
	movl	(%esp), %ecx
	addl	$8, %esp
	movl	(%esp), %eax
	subl	%ecx, %eax
	movl	%eax, (%esp)
				# b_push_const_int (1)
	movl	$1, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_arith_rel_op ( - , signed int)
	movl	(%esp), %ecx
	addl	$8, %esp
	movl	(%esp), %eax
	subl	%ecx, %eax
	movl	%eax, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 4)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$4, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_deref (signed int)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_arith_rel_op ( + , signed int)
	movl	(%esp), %ecx
	addl	$8, %esp
	movl	(%esp), %eax
	addl	%ecx, %eax
	movl	%eax, (%esp)
				# b_assign (signed int)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   66
				# b_push_ext_addr (i)
	subl	$8, %esp
	movl	$i, (%esp)
				# b_push_ext_addr (i)
	subl	$8, %esp
	movl	$i, (%esp)
				# b_deref (signed int)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_const_int (1)
	movl	$1, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_arith_rel_op ( + , signed int)
	movl	(%esp), %ecx
	addl	$8, %esp
	movl	(%esp), %eax
	addl	%ecx, %eax
	movl	%eax, (%esp)
				# b_assign (signed int)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   67
				# b_jump ( destination = .LC3 )
	jmp	.LC3
.LC4:
 #   68
				# b_alloc_arglist (0 bytes)
	movl	%esp, %eax
	subl	$4, %esp
	andl	$-16, %esp
	movl	%eax, (%esp)
	subl	$0, %esp
				# b_funcall_by_name (print_ai, signed int)
	call	print_ai
	addl	$0, %esp
	movl	(%esp), %ecx
	movl	%ecx, %esp
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   69
 #   70
				# b_push_ext_addr (ai)
	subl	$8, %esp
	movl	$ai, (%esp)
				# b_push_const_int (5)
	movl	$5, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 4)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$4, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_push_const_int (5)
	movl	$5, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_assign (signed int)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   71
				# b_push_ext_addr (aai)
	subl	$8, %esp
	movl	$aai, (%esp)
				# b_push_ext_addr (ai)
	subl	$8, %esp
	movl	$ai, (%esp)
				# b_push_const_int (5)
	movl	$5, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 4)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$4, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_deref (signed int)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 40)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$40, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_push_ext_addr (i)
	subl	$8, %esp
	movl	$i, (%esp)
				# b_deref (signed int)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_const_int (3)
	movl	$3, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_arith_rel_op ( - , signed int)
	movl	(%esp), %ecx
	addl	$8, %esp
	movl	(%esp), %eax
	subl	%ecx, %eax
	movl	%eax, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 4)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$4, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_push_const_int (199)
	movl	$199, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_assign (signed int)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   72
				# b_push_ext_addr (aaai)
	subl	$8, %esp
	movl	$aaai, (%esp)
				# b_push_ext_addr (ai)
	subl	$8, %esp
	movl	$ai, (%esp)
				# b_push_const_int (5)
	movl	$5, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 4)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$4, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_deref (signed int)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 400)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$400, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_push_ext_addr (i)
	subl	$8, %esp
	movl	$i, (%esp)
				# b_deref (signed int)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_const_int (6)
	movl	$6, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_arith_rel_op ( - , signed int)
	movl	(%esp), %ecx
	addl	$8, %esp
	movl	(%esp), %eax
	subl	%ecx, %eax
	movl	%eax, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 40)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$40, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_push_const_int (2)
	movl	$2, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 4)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$4, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_push_const_int (299)
	movl	$299, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_assign (signed int)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   73
				# b_push_ext_addr (af)
	subl	$8, %esp
	movl	$af, (%esp)
				# b_push_const_int (4)
	movl	$4, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 4)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$4, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_push_const_int (399)
	movl	$399, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_convert (signed int -> float)
	fildl	(%esp)
	fstps	(%esp)
				# b_assign (float)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   74
				# b_push_ext_addr (ad)
	subl	$8, %esp
	movl	$ad, (%esp)
				# b_push_const_int (12)
	movl	$12, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 8)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$8, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_push_const_double (4.9900000000000000e+02)
	.section	.rodata
	.align	8
.LC5:
	.long	0
	.long	1082077184
	.text
	fldl	.LC5
	subl	$8, %esp
	fstpl	(%esp)
				# b_assign (double)
	fldl	(%esp)
	addl	$8, %esp
	movl	(%esp), %eax
	fstpl	(%eax)
	fstpl	(%esp)
				# b_pop ()
	addl	$8, %esp
 #   75
				# b_alloc_arglist (0 bytes)
	movl	%esp, %eax
	subl	$4, %esp
	andl	$-16, %esp
	movl	%eax, (%esp)
	subl	$0, %esp
				# b_funcall_by_name (print_spec, signed int)
	call	print_spec
	addl	$0, %esp
	movl	(%esp), %ecx
	movl	%ecx, %esp
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   76
 #   77
				# b_push_ext_addr (s1)
	subl	$8, %esp
	movl	$s1, (%esp)
				# b_push_ext_addr (as)
	subl	$8, %esp
	movl	$as, (%esp)
				# b_assign (pointer)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   78
				# b_push_ext_addr (s1)
	subl	$8, %esp
	movl	$s1, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_const_int (98)
	movl	$98, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_assign (signed char)
	movzbl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movb	%dl, (%eax)
	movb	%dl, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   79
				# b_push_ext_addr (s1)
	subl	$8, %esp
	movl	$s1, (%esp)
				# b_push_ext_addr (s1)
	subl	$8, %esp
	movl	$s1, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_const_int (1)
	movl	$1, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 1)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$1, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_assign (pointer)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   80
				# b_push_ext_addr (s1)
	subl	$8, %esp
	movl	$s1, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_const_int (108)
	movl	$108, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_assign (signed char)
	movzbl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movb	%dl, (%eax)
	movb	%dl, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   81
				# b_push_ext_addr (s1)
	subl	$8, %esp
	movl	$s1, (%esp)
				# b_push_ext_addr (s1)
	subl	$8, %esp
	movl	$s1, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_const_int (1)
	movl	$1, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 1)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$1, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_assign (pointer)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   82
				# b_push_ext_addr (s1)
	subl	$8, %esp
	movl	$s1, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_const_int (97)
	movl	$97, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_assign (signed char)
	movzbl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movb	%dl, (%eax)
	movb	%dl, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   83
				# b_push_ext_addr (s1)
	subl	$8, %esp
	movl	$s1, (%esp)
				# b_push_ext_addr (s1)
	subl	$8, %esp
	movl	$s1, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_const_int (1)
	movl	$1, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 1)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$1, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_assign (pointer)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   84
				# b_push_ext_addr (s1)
	subl	$8, %esp
	movl	$s1, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_const_int (104)
	movl	$104, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_assign (signed char)
	movzbl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movb	%dl, (%eax)
	movb	%dl, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   85
				# b_push_ext_addr (s1)
	subl	$8, %esp
	movl	$s1, (%esp)
				# b_push_ext_addr (s1)
	subl	$8, %esp
	movl	$s1, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_const_int (1)
	movl	$1, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 1)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$1, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_assign (pointer)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   86
				# b_push_ext_addr (s1)
	subl	$8, %esp
	movl	$s1, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_const_int (0)
	movl	$0, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_assign (signed char)
	movzbl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movb	%dl, (%eax)
	movb	%dl, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   87
				# b_alloc_arglist (0 bytes)
	movl	%esp, %eax
	subl	$4, %esp
	andl	$-16, %esp
	movl	%eax, (%esp)
	subl	$0, %esp
				# b_funcall_by_name (print_as, signed int)
	call	print_as
	addl	$0, %esp
	movl	(%esp), %ecx
	movl	%ecx, %esp
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   88
 #   89
				# b_push_ext_addr (j)
	subl	$8, %esp
	movl	$j, (%esp)
				# b_push_ext_addr (j)
	subl	$8, %esp
	movl	$j, (%esp)
				# b_deref (signed int)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_const_int (1)
	movl	$1, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_arith_rel_op ( - , signed int)
	movl	(%esp), %ecx
	addl	$8, %esp
	movl	(%esp), %eax
	subl	%ecx, %eax
	movl	%eax, (%esp)
				# b_assign (signed int)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   90
				# b_push_ext_addr (s1)
	subl	$8, %esp
	movl	$s1, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_ext_addr (j)
	subl	$8, %esp
	movl	$j, (%esp)
				# b_deref (signed int)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 1)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$1, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_push_const_int (103)
	movl	$103, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_assign (signed char)
	movzbl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movb	%dl, (%eax)
	movb	%dl, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   91
				# b_push_ext_addr (as)
	subl	$8, %esp
	movl	$as, (%esp)
				# b_push_const_int (102)
	movl	$102, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_assign (signed char)
	movzbl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movb	%dl, (%eax)
	movb	%dl, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   92
				# b_alloc_arglist (0 bytes)
	movl	%esp, %eax
	subl	$4, %esp
	andl	$-16, %esp
	movl	%eax, (%esp)
	subl	$0, %esp
				# b_funcall_by_name (print_as, signed int)
	call	print_as
	addl	$0, %esp
	movl	(%esp), %ecx
	movl	%ecx, %esp
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   93
 #   94
				# b_push_ext_addr (x)
	subl	$8, %esp
	movl	$x, (%esp)
				# b_push_const_int (3)
	movl	$3, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 4)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$4, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_push_ext_addr (i)
	subl	$8, %esp
	movl	$i, (%esp)
				# b_assign (pointer)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   95
				# b_push_ext_addr (x)
	subl	$8, %esp
	movl	$x, (%esp)
				# b_push_const_int (3)
	movl	$3, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 4)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$4, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_const_int (77)
	movl	$77, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_assign (signed int)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   96
				# b_alloc_arglist (0 bytes)
	movl	%esp, %eax
	subl	$4, %esp
	andl	$-16, %esp
	movl	%eax, (%esp)
	subl	$0, %esp
				# b_funcall_by_name (print_ints, signed int)
	call	print_ints
	addl	$0, %esp
	movl	(%esp), %ecx
	movl	%ecx, %esp
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   97
 #   98
 #   99
				# b_push_ext_addr (j)
	subl	$8, %esp
	movl	$j, (%esp)
				# b_push_ext_addr (aaai)
	subl	$8, %esp
	movl	$aaai, (%esp)
				# b_push_const_int (4)
	movl	$4, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 400)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$400, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_push_const_int (3)
	movl	$3, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 40)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$40, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_push_ext_addr (aaai)
	subl	$8, %esp
	movl	$aaai, (%esp)
				# b_push_const_int (1)
	movl	$1, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 400)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$400, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_push_const_int (8)
	movl	$8, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 40)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$40, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_ptr_arith_op ( - , pointer, size = 4)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	subl	%edx, %eax
	sarl	$2, %eax
	movl	%eax, (%esp)
				# b_assign (signed int)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #  100
				# b_alloc_arglist (0 bytes)
	movl	%esp, %eax
	subl	$4, %esp
	andl	$-16, %esp
	movl	%eax, (%esp)
	subl	$0, %esp
				# b_funcall_by_name (print_ints, signed int)
	call	print_ints
	addl	$0, %esp
	movl	(%esp), %ecx
	movl	%ecx, %esp
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_pop ()
	addl	$8, %esp
 #  101
 #  102
				# b_push_ext_addr (j)
	subl	$8, %esp
	movl	$j, (%esp)
				# b_push_ext_addr (aaai)
	subl	$8, %esp
	movl	$aaai, (%esp)
				# b_push_const_int (6)
	movl	$6, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 400)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$400, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_push_ext_addr (aaai)
	subl	$8, %esp
	movl	$aaai, (%esp)
				# b_push_const_int (1)
	movl	$1, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_ptr_arith_op ( + , signed int, size = 400)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	imull	$400, %edx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
				# b_ptr_arith_op ( - , pointer, size = 40)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	subl	%edx, %eax
	sarl	$3, %eax
	imull	$-858993459, %eax, %eax
	movl	%eax, (%esp)
				# b_assign (signed int)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #  103
				# b_alloc_arglist (0 bytes)
	movl	%esp, %eax
	subl	$4, %esp
	andl	$-16, %esp
	movl	%eax, (%esp)
	subl	$0, %esp
				# b_funcall_by_name (print_ints, signed int)
	call	print_ints
	addl	$0, %esp
	movl	(%esp), %ecx
	movl	%ecx, %esp
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_pop ()
	addl	$8, %esp
 #  104
.LC0:
				# b_func_epilogue (main)
	leave
	ret
	.size	main, .-main
 #  105
