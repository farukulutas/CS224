.data
qs: .asciiz "Try your program with the following expression x = (a * b) / (a + b)"
aMsg: .asciiz "\nPlease enter value A:"
bMsg: .asciiz "\nPlease enter value B:"
xMsg: .asciiz "\nValue of X is "
A: .word  0 # int size(4 bytes)
B: .word  0 # int size(4 bytes)
X: .word  0 # int size(4 bytes)

.globl start
.text
start:
	# prompt the program task on screen
	li $v0, 4
	la $a0, qs
	syscall
	
	# Ask prompt A
	li $v0, 4
	la $a0, aMsg
	syscall
	
	# read the user input
	li $v0, 5
	syscall
	sw $v0, A
	
	# Ask prompt B
	li $v0, 4
	la $a0, bMsg
	syscall
	
	# read the user input
	li $v0, 5
	syscall
	sw $v0, B
	
	jal calculate
	
	# print aMsg
	li $v0, 4
	la $a0, xMsg
	syscall
	
	# print X
	li $v0, 1
	lw $a0, X
	syscall
	
	# exit the program
	li $v0, 10	
	syscall

# Calculates value A according to formula, returns value in v0 register
calculate:
	lw $t0, A
	lw $t1, B
	lw $t2, X
	
	# formula: x = (a * b) / (a + b)
	#mul $t3, $t0, $t1 # t3 contains (a*b)
	#add $t4, $t0, $t1 # t4 contains (a+b)
	#div $t2, $t3, $t4 # t2 contains (a * b) / (a + b)
	#sw $v0, X

	# formula (a*b)/c ))% 2
	#mul $t4, $t0, $t1 #t4 contains ( a*b)
	#div $t5, $t4, $t3 #t5 contains (a*b)/c
	
	#loop:
		#blt $t5, $t3, done
		#sub $t5, $t5, $t3
		#j loop
		
	#done:
	
	# formula ( a % b ) * ( a - b )
	rem $t3, $t0, $t1 #t4 contians ( a % b )
	sub $t4, $t0, $t1 #t5 a-b
	mul $t2, $t3, $t4
	
	sw $t2, X 

	jr $ra