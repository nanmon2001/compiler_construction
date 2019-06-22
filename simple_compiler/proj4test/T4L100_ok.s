 #    2
 #    3
 #    4
 #    5
				# b_global_decl (fp, alignment = 4, size = 4)
.globl fp
	.data
	.align	4
	.type	fp, @object
	.size	fp, 4
fp:
	.zero	4
				# b_global_decl (fq, alignment = 4, size = 4)
.globl fq
	.align	4
	.type	fq, @object
	.size	fq, 4
fq:
	.zero	4
 #    6
				# b_global_decl (afp, alignment = 4, size = 40)
.globl afp
	.align	4
	.type	afp, @object
	.size	afp, 40
afp:
	.zero	40
 #    7
 #    8
 #    9
 #   10
 #   11
				# b_func_prologue (f1)
	.text
.global f1
	.type	f1, @function
f1:
	pushl	%ebp
	movl	%esp, %ebp
 #   12
				# b_alloc_arglist (0 bytes)
	movl	%esp, %eax
	subl	$4, %esp
	andl	$-16, %esp
	movl	%eax, (%esp)
	subl	$0, %esp
				# b_funcall_by_name (print1, signed int)
	call	print1
	addl	$0, %esp
	movl	(%esp), %ecx
	movl	%ecx, %esp
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   13
.LC0:
				# b_func_epilogue (f1)
	leave
	ret
	.size	f1, .-f1
 #   14
 #   15
 #   16
				# b_func_prologue (f2)
.global f2
	.type	f2, @function
f2:
	pushl	%ebp
	movl	%esp, %ebp
 #   17
				# b_alloc_arglist (0 bytes)
	movl	%esp, %eax
	subl	$4, %esp
	andl	$-16, %esp
	movl	%eax, (%esp)
	subl	$0, %esp
				# b_funcall_by_name (print2, signed int)
	call	print2
	addl	$0, %esp
	movl	(%esp), %ecx
	movl	%ecx, %esp
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   18
.LC1:
				# b_func_epilogue (f2)
	leave
	ret
	.size	f2, .-f2
 #   19
 #   20
 #   21
				# b_func_prologue (main)
.global main
	.type	main, @function
main:
	pushl	%ebp
	movl	%esp, %ebp
	andl	$-16, %esp
 #   22
				# b_push_ext_addr (fp)
	subl	$8, %esp
	movl	$fp, (%esp)
				# b_push_ext_addr (f1)
	subl	$8, %esp
	movl	$f1, (%esp)
				# b_assign (pointer)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   23
				# b_alloc_arglist (0 bytes)
	movl	%esp, %eax
	subl	$4, %esp
	andl	$-16, %esp
	movl	%eax, (%esp)
	subl	$0, %esp
				# b_push_ext_addr (fp)
	subl	$8, %esp
	movl	$fp, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_funcall_by_ptr (signed int)
	movl	(%esp), %eax
	addl	$8, %esp
	call	*%eax
	addl	$0, %esp
	movl	(%esp), %ecx
	movl	%ecx, %esp
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   24
				# b_push_ext_addr (fp)
	subl	$8, %esp
	movl	$fp, (%esp)
				# b_push_ext_addr (f2)
	subl	$8, %esp
	movl	$f2, (%esp)
				# b_assign (pointer)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   25
				# b_alloc_arglist (0 bytes)
	movl	%esp, %eax
	subl	$4, %esp
	andl	$-16, %esp
	movl	%eax, (%esp)
	subl	$0, %esp
				# b_push_ext_addr (fp)
	subl	$8, %esp
	movl	$fp, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_funcall_by_ptr (signed int)
	movl	(%esp), %eax
	addl	$8, %esp
	call	*%eax
	addl	$0, %esp
	movl	(%esp), %ecx
	movl	%ecx, %esp
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   26
				# b_push_ext_addr (fq)
	subl	$8, %esp
	movl	$fq, (%esp)
				# b_push_ext_addr (fp)
	subl	$8, %esp
	movl	$fp, (%esp)
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
 #   27
				# b_alloc_arglist (0 bytes)
	movl	%esp, %eax
	subl	$4, %esp
	andl	$-16, %esp
	movl	%eax, (%esp)
	subl	$0, %esp
				# b_push_ext_addr (fq)
	subl	$8, %esp
	movl	$fq, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_funcall_by_ptr (signed int)
	movl	(%esp), %eax
	addl	$8, %esp
	call	*%eax
	addl	$0, %esp
	movl	(%esp), %ecx
	movl	%ecx, %esp
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   28
				# b_push_ext_addr (afp)
	subl	$8, %esp
	movl	$afp, (%esp)
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
				# b_push_ext_addr (f1)
	subl	$8, %esp
	movl	$f1, (%esp)
				# b_assign (pointer)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   29
				# b_alloc_arglist (0 bytes)
	movl	%esp, %eax
	subl	$4, %esp
	andl	$-16, %esp
	movl	%eax, (%esp)
	subl	$0, %esp
				# b_push_ext_addr (afp)
	subl	$8, %esp
	movl	$afp, (%esp)
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
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_funcall_by_ptr (signed int)
	movl	(%esp), %eax
	addl	$8, %esp
	call	*%eax
	addl	$0, %esp
	movl	(%esp), %ecx
	movl	%ecx, %esp
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   30
 #   31
				# b_push_ext_addr (fp)
	subl	$8, %esp
	movl	$fp, (%esp)
				# b_push_ext_addr (f1)
	subl	$8, %esp
	movl	$f1, (%esp)
				# b_assign (pointer)
	movl	(%esp), %edx
	addl	$8, %esp
	movl	(%esp), %eax
	movl	%edx, (%eax)
	movl	%edx, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   32
				# b_alloc_arglist (0 bytes)
	movl	%esp, %eax
	subl	$4, %esp
	andl	$-16, %esp
	movl	%eax, (%esp)
	subl	$0, %esp
				# b_push_ext_addr (fp)
	subl	$8, %esp
	movl	$fp, (%esp)
				# b_deref (pointer)
	movl	(%esp), %eax
	movl	(%eax), %edx
	movl	%edx, (%esp)
				# b_funcall_by_ptr (signed int)
	movl	(%esp), %eax
	addl	$8, %esp
	call	*%eax
	addl	$0, %esp
	movl	(%esp), %ecx
	movl	%ecx, %esp
	subl	$8, %esp
	movl	%eax, (%esp)
				# b_pop ()
	addl	$8, %esp
 #   33
.LC2:
				# b_func_epilogue (main)
	leave
	ret
	.size	main, .-main
 #   34
