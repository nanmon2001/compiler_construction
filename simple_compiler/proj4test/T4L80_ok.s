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
 #   14
 #   15
 #   16
				# b_func_prologue (main)
	.text
.global main
	.type	main, @function
main:
	pushl	%ebp
	movl	%esp, %ebp
	andl	$-16, %esp
 #   17
				# b_push_ext_addr (i)
	subl	$8, %esp
	movl	$i, (%esp)
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
 #   18
				# b_push_ext_addr (j)
	subl	$8, %esp
	movl	$j, (%esp)
				# b_push_const_int (28)
	movl	$28, %eax
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
 #   19
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
 #   20
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
 #   21
				# b_push_ext_addr (j)
	subl	$8, %esp
	movl	$j, (%esp)
				# b_push_ext_addr (i)
	subl	$8, %esp
	movl	$i, (%esp)
				# b_deref (signed int)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_ext_addr (pi)
	subl	$8, %esp
	movl	$pi, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
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
 #   22
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
 #   23
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
				# b_assign (signed int)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   24
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
 #   25
				# b_push_ext_addr (j)
	subl	$8, %esp
	movl	$j, (%esp)
				# b_push_ext_addr (pi)
	subl	$8, %esp
	movl	$pi, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_deref (signed int)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_ext_addr (ppi)
	subl	$8, %esp
	movl	$ppi, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
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
 #   26
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
 #   27
 #   28
				# b_push_ext_addr (f)
	subl	$8, %esp
	movl	$f, (%esp)
				# b_push_const_int (199)
	movl	$199, %eax
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
 #   29
				# b_push_ext_addr (pf)
	subl	$8, %esp
	movl	$pf, (%esp)
				# b_push_ext_addr (f)
	subl	$8, %esp
	movl	$f, (%esp)
				# b_assign (pointer)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   30
				# b_push_ext_addr (pf)
	subl	$8, %esp
	movl	$pf, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_ext_addr (pf)
	subl	$8, %esp
	movl	$pf, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_deref (float)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_convert (float -> double)
	flds	(%esp)
	fstpl	(%esp)
				# b_push_ext_addr (pf)
	subl	$8, %esp
	movl	$pf, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_deref (float)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_convert (float -> double)
	flds	(%esp)
	fstpl	(%esp)
				# b_push_const_int (1)
	movl	$1, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_convert (signed int -> double)
	fildl	(%esp)
	fstpl	(%esp)
				# b_arith_rel_op ( + , double)
	fldl	8(%esp)
	fldl	(%esp)
	addl	$8, %esp
	faddp	%st, %st(1)
	fstpl	(%esp)
				# b_arith_rel_op ( / , double)
	fldl	8(%esp)
	fldl	(%esp)
	addl	$8, %esp
	fdivrp	%st, %st(1)
	fstpl	(%esp)
				# b_convert (double -> float)
	fldl	(%esp)
	fstps	(%esp)
				# b_assign (float)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   31
				# b_alloc_arglist (0 bytes)
	movl	%esp, %eax
	subl	$4, %esp
	andl	$-16, %esp
	movl	%eax, (%esp)
	subl	$0, %esp
				# b_funcall_by_name (print_floats, signed int)
	call	print_floats
	addl	$0, %esp
	movl	(%esp), %ecx
	movl	%ecx, %esp
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   32
 #   33
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
 #   37
				# b_push_ext_addr (s1)
	subl	$8, %esp
	movl	$s1, (%esp)
				# b_push_ext_addr (c)
	subl	$8, %esp
	movl	$c, (%esp)
				# b_assign (pointer)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   38
				# b_push_ext_addr (s2)
	subl	$8, %esp
	movl	$s2, (%esp)
				# b_push_ext_addr (s1)
	subl	$8, %esp
	movl	$s1, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_assign (pointer)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   39
				# b_push_ext_addr (i)
	subl	$8, %esp
	movl	$i, (%esp)
				# b_push_ext_addr (s1)
	subl	$8, %esp
	movl	$s1, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_deref (signed char)
	movl	(%esp), %eax
	movsbl	(%eax), %edx
	movb	%dl, (%esp)
				# b_convert (signed char -> signed int)
	movzbl	(%esp), %eax
	movsbl	%al, %eax
	movl	%eax, (%esp)
				# b_push_ext_addr (s2)
	subl	$8, %esp
	movl	$s2, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_deref (signed char)
	movl	(%esp), %eax
	movsbl	(%eax), %edx
	movb	%dl, (%esp)
				# b_convert (signed char -> signed int)
	movzbl	(%esp), %eax
	movsbl	%al, %eax
	movl	%eax, (%esp)
				# b_arith_rel_op ( + , signed int)
	movl	(%esp), %ecx
	addl	$8, %esp
	movl	(%esp), %eax
	addl	%ecx, %eax
	movl	%eax, (%esp)
				# b_push_ext_addr (pi)
	subl	$8, %esp
	movl	$pi, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
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
 #   40
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
 #   41
 #   42
				# b_push_ext_addr (s1)
	subl	$8, %esp
	movl	$s1, (%esp)
				# b_push_const_int (0)
	movl	$0, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_convert (signed int -> pointer)
				# b_assign (pointer)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   43
				# b_push_ext_addr (i)
	subl	$8, %esp
	movl	$i, (%esp)
				# b_push_ext_addr (s1)
	subl	$8, %esp
	movl	$s1, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_ext_addr (s2)
	subl	$8, %esp
	movl	$s2, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_arith_rel_op ( > , pointer)
	movl	(%esp), %ecx
	addl	$8, %esp
	movl	(%esp), %eax
	cmpl	%ecx, %eax
	seta	%al
	movzbl	%al, %eax
	movl	%eax, (%esp)
				# b_assign (signed int)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   44
				# b_push_ext_addr (j)
	subl	$8, %esp
	movl	$j, (%esp)
				# b_push_ext_addr (s1)
	subl	$8, %esp
	movl	$s1, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_ext_addr (s2)
	subl	$8, %esp
	movl	$s2, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_arith_rel_op ( < , pointer)
	movl	(%esp), %ecx
	addl	$8, %esp
	movl	(%esp), %eax
	cmpl	%ecx, %eax
	setb	%al
	movzbl	%al, %eax
	movl	%eax, (%esp)
				# b_assign (signed int)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   45
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
 #   46
 #   47
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
				# b_push_const_int (0)
	movl	$0, %eax
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_convert (signed int -> pointer)
				# b_arith_rel_op ( == , pointer)
	movl	(%esp), %ecx
	addl	$8, %esp
	movl	(%esp), %eax
	cmpl	%ecx, %eax
	sete	%al
	movzbl	%al, %eax
	movl	%eax, (%esp)
				# b_assign (signed int)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   48
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
 #   49
 #   50
				# b_push_ext_addr (ppi)
	subl	$8, %esp
	movl	$ppi, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_const_int (123)
	movl	$123, %eax
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
 #   51
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
 #   52
 #   53
				# b_push_ext_addr (pppi)
	subl	$8, %esp
	movl	$pppi, (%esp)
				# b_push_ext_addr (ppi)
	subl	$8, %esp
	movl	$ppi, (%esp)
				# b_assign (pointer)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   54
				# b_push_ext_addr (pppi)
	subl	$8, %esp
	movl	$pppi, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_push_const_int (257)
	movl	$257, %eax
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
 #   55
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
 #   56
.LC0:
				# b_func_epilogue (main)
	leave
	ret
	.size	main, .-main
 #   57
