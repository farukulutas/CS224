.data
	aMsg: .asciiz "Please enter a value: "
	bMsg: .asciiz "\nPlease enter b value: "
	cMsg: .asciiz "\nPlease enter c value: "
	xMsg: .asciiz "\nValue of x is "
	a: .word  0 # a value type(int) size(4 bytes)
	b: .word  0 # b value type(int) size(4 bytes)
	c: .word  0 # c value type(int) size(4 bytes)
	x: .word  0 # x value type(int) size(4 bytes)
	
.globl start
.text
start:	
	# prompt user to enter a
	li $v0, 4
	la $a0, aMsg
	syscall
	# read the user input
	li $v0, 5
	syscall
	sw $v0, a
	
	# prompt user to enter b
	li $v0, 4
	la $a0, bMsg
	syscall
	# read the user input
	li $v0, 5
	syscall
	sw $v0, b
	
	# prompt user to enter c
	li $v0, 4
	la $a0, cMsg
	syscall
	# read the user input
	li $v0, 5
	syscall
	sw $v0, c
	
	# call the function to evaluate expression
	lw $a0, a
	lw $a1, b
	lw $a2, c
	jal evaluate
	
	# print x
	li $v0, 4
	la $a0, xMsg
	syscall
	# print remainder
	li $v0, 1
	lw $a0, x
	syscall

	# exit the program
	li $v0, 10	
	syscall

## x = (a x (b - c)) % 8
## Inputs: [$a0: a; $a1: b, $a2: c} 
## Outputs: {$v0: x}
evaluate:
	move $t0, $a0 # t0 holds a
	move $t1, $a1 # t1 holds b
	move $t2, $a2 # t1 holds c
	sub $t1, $t1, $t2 # t1 holds (b-c)
	mul $t1, $t1, $t0 # t1 holds a x (b-c)
	blt $t1, $0, makePositive
	bge $t1, $0, eval
	makePositive:
		#mul $t2, $t2, -1 # if (b-c) < 0 do -1 * (b-c)
		addi $t1,$t1, 8 # consecutively add 16 to make (c-d) positive
		blt $t1, 0, makePositive
	eval:
		addi $t3, $0, 1 # int i = 1 (index)
		addi $t4, $0, 0 # int product = 0 
		while:
			mul $t4, $t3, 8 # product = 8 * i
			addi $t3, $t3, 1 # i += 1
			ble $t4, $t1, while
		# evaluate x
		# x  = (c-d) - (product - 16)
		subi $t4, $t4, 8  # (product - 16)
		sub $v0, $t1, $t4 # x  = (c-d) - (product - 16)
		sw $v0, x
	jr $ra