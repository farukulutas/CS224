.data
	array: .space 400
	size: .word 0
	sum: .word 0
	sumEven: .word 0
	sumOdd: .word 0
	occurrenceDiv: .word 0
	input: .word 0
	promptSize: .asciiz "Please enter the size:"
	promptValues: .asciiz "Please enter the values\n"
	promptMenu: .asciiz "\n---MENU---\na. Sum of numbers in the array => (n>a)\nb. Sum of even, odd\nc. Number of occurences div by a input\nd. Quit\nEnter an option (a,b,c,d)\n"
	promptInput: .asciiz "\nPlease enter the input value:"
	promptWarning: .asciiz "\nPlease enter a valid input"
	promptResult: .asciiz "\nResult is "
	promptResultOdd: .asciiz "\nThe summation of odd numbers: "
	promptResultEven: .asciiz "\nThe summation of even numbers: "
	promptResultDiv: .asciiz "\nThe summation of divisible numbers to input: "

.globl start
.text

start:
	# size ask prompt
	li $v0, 4
	la $a0, promptSize
	syscall
	
	# get size value
	li $v0, 5
	syscall
	sw $v0, size
	
	jal createArray
	
	menu:
		li $v0, 4
		la $a0, promptMenu
		syscall

		# load character options into the registers
		li $t0, 'a'
		li $t1, 'b'
		li $t2, 'c'
		li $t3, 'd'
		
		li $v0, 12 # char read
		syscall
		
		# call the option
		beq $v0, $t0, callA
		beq $v0, $t1, callB
		beq $v0, $t2, callC
		beq $v0, $t3, quit
		
		# invalid input warning
		li $v0, 4
		la $a0, promptWarning
		syscall
		j menu
		
		callA:
			li $v0, 4
			la $a0, promptInput
			syscall
			li $v0, 5
			syscall
			sw $v0, input
			jal sumGreaterThanInput
			j menu
		callB:
			jal sumOfEvenOdd
			j menu
		callC:
			li $v0, 4
			la $a0, promptInput
			syscall
			li $v0, 5
			syscall
			sw $v0, input
			jal noOccurrencesDivByInput
			j menu
		
	quit:
	
	# exit the program
	li $v0, 10	
	syscall
	
createArray:
	lw $t0, size # $t0 = size
	la $t1, array # $t1 = base addr of array
	add $t2, $0, $0 # index = 0
	
	# ask prompt for values
	li $v0, 4
	la $a0, promptValues
	syscall
	
	getInput:
		li $v0, 5
		syscall
		
		sw $v0, 0($t1) # $t1 = new element
		addi $t1, $t1, 4 # byte update +4
		addi $t2, $t2, 1
		blt $t2, $t0, getInput
	jr $ra
	
sumGreaterThanInput:
	sw $0, sum # sum = 0
	addi $s1, $0, 0 # i = 0
	la $s0, array
	lw $t2, size
	lw $t3, input
	
	loop:
		slt $t0, $s1, $t2
		beq $t0, $0, done
		sll $t0, $s1, 2
		add $t0, $t0, $s0
		lw $t1, 0($t0)
		bgt $t1, $t3, summation
		addi $s1, $s1, 1
		j loop
		
	summation:
		lw $t4, sum
		add $t4, $t4, $t1
		sw $t4, sum
		addi $s1, $s1, 1
		j loop	
		
	done:
		la $a0, promptResult
		li $v0, 4
		syscall
		li $v0, 1
		lw $a0, sum
		syscall
	
	jr $ra

sumOfEvenOdd:
	sw $0, sumEven # sumEven = 0
	sw $0, sumOdd # sumOdd = 0
	addi $s1, $0, 0 # i = 0
	la $s0, array
	lw $t2, size
	
	loopEvenOdd:
		slt $t0, $s1, $t2
		beq $t0, $0, doneEvenOdd
		sll $t0, $s1, 2
		add $t0, $t0, $s0
		lw $t1, 0($t0)
		rem $t5, $t1, 2
		beq $t5, 0, summationEven
		j summationOdd
		addi $s1, $s1, 1
		j loopEvenOdd
		
	summationEven:
		lw $t4, sumEven
		add $t4, $t4, $t1
		sw $t4, sumEven
		addi $s1, $s1, 1
		j loopEvenOdd
			
	summationOdd:
		lw $t4, sumOdd
		add $t4, $t4, $t1
		sw $t4, sumOdd
		addi $s1, $s1, 1
		j loopEvenOdd
		
	doneEvenOdd:
		la $a0, promptResultEven
		li $v0, 4
		syscall
		li $v0, 1
		lw $a0, sumEven
		syscall
		
		la $a0, promptResultOdd
		li $v0, 4
		syscall
		li $v0, 1
		lw $a0, sumOdd
		syscall
	
	jr $ra

noOccurrencesDivByInput:
	sw $0, occurrenceDiv # sumEven = 0
	addi $s1, $0, 0 # i = 0
	la $s0, array
	lw $t2, size
	lw $t3, input
	
	loopDiv:
		slt $t0, $s1, $t2
		beq $t0, $0, doneDiv
		sll $t0, $s1, 2
		add $t0, $t0, $s0
		lw $t1, 0($t0)
		rem $t5, $t1, $t3
		beq $t5, 0, summationDiv
		addi $s1, $s1, 1
		j loopDiv
		
	summationDiv:
		lw $t4, occurrenceDiv
		addi $t4, $t4, 1
		sw $t4, occurrenceDiv
		addi $s1, $s1, 1
		j loopDiv

	doneDiv:
		la $a0, promptResultDiv
		li $v0, 4
		syscall
		li $v0, 1
		lw $a0, occurrenceDiv
		syscall
	
	jr $ra
