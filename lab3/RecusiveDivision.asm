.data
promptInput: .asciiz "\nPlease enter positive values for divident and divisor:\n"
promptOutput: .asciiz "The answer is: "

.text
.globl main

main:
	# Display input message
	li $v0, 4
	la $a0, promptInput
	syscall
	
	# Get the divident from the user and put it in a0
	li $v0, 5
	syscall
	add $a0, $v0, 0
	
	# Get the divisor from the user and put it in a1
	li $v0, 5
	syscall
	add $a1, $v0, 0
	
	beq $a0, 0, exit
	beq $a1, 0, exit
	
	# Perform the division subprogram
	jal division
	
exit:
	#end program
	li $v0, 10
	syscall

division:
	# Allocate the stack space
	addi $sp, $sp, -20
	sw $s0, 16($sp)
	sw $s1, 12($sp)
	sw $s2, 8($sp)
	sw $s3, 4($sp)
	sw $s4, 0($sp)
	
	# Load necessary values
	move $s0, $a0
	move $s1, $a1
	move $s2, $0
	
	# Perform division loop
	j divisionLoop
	
	divisionLoop:
		# Stop divisionLoop if dividend cannot be subtracted anymore
		slt $s3, $s0, $s1
		bne $s3, $0, done
		
		# Dividend minus divisor
		sub $s0, $s0, $s1
		# Increment counter = quotient
		addi $s2, $s2, 1 
		
		j divisionLoop
		
	done:
		# Display answer
		li $v0, 4
		la $a0, promptOutput
		syscall
		move $a0, $s2
		li $v0, 1
		syscall
		
		# Deallocates the stack space
		lw $s4, 0($sp)
		lw $s3, 4($sp)
		lw $s2, 8($sp)
		lw $s1, 12($sp)
		lw $s0, 16($sp)
		addi $sp, $sp, 20
		
		# Return to main
		j main