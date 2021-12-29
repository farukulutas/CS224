.data

prompt: .asciiz "\nEnter the decimal number to convert and shift: "
promptQuit: .asciiz "\nAre you sure you want to exit? (1-yes, 0-no)"
resultInput: .asciiz "\nHexadecimal equivalent: 0x"
resultOutput: .asciiz "\nHexadecimal equivalent of shifted one: 0x"
result: .space 8

.text
.globl main

main:
	la $a0, prompt
	li $v0, 4
	syscall

	li $v0, 5
	syscall

	move $t2, $v0

	la $a0, resultInput
	li $v0, 4
	syscall

	li $t0, 8 # counter
	la $t3, result # where answer will be stored

Loop:

	beqz $t0, Exit	# branch to exit if counter is equal to zero
	rol $t2, $t2, 4	# rotate 4 bits to the left
	and $t4, $t2, 0xf # mask with 1111
	ble $t4, 9, Sum	# if less than or equal to nine, branch to sum
	addi $t4, $t4, 55 # if greater than nine, add 55

	b End

	Sum:
		addi $t4, $t4, 48 # add 48 to result

End:

	sb $t4, 0($t3)	# store hex digit into result
	addi $t3, $t3, 1 # increment address counter
	addi $t0, $t0, -1 # decrement loop counter

j Loop

shiftNibbles:
	andi $s0, $t2, 15
	andi $s1, $t2, 240
	andi $s2, $t2, 3840
	andi $s3, $t2, 61440
	andi $s4, $t2, 983040
	andi $s5, $t2, 15728640
	andi $s6, $t2, 251658240
	andi $s7, $t2, 4026531840
	
	sll $s0, $s0, 1
	sll $s2, $s2, 1
	sll $s4, $s4, 1
	sll $s6, $s6, 1
	
	srl $s1, $s1, 1
	srl $s3, $s3, 1	
	srl $s5, $s5, 1	
	srl $s7, $s7, 1	
	
	add $s6, $s6, $s7
	add $s6, $s6, $s4
	add $s6, $s6, $s5
	add $s6, $s6, $s2
	add $s6, $s6, $s3
	add $s6, $s6, $s0
	add $s6, $s6, $s1
	
	la $a0, resultOutput
	li $v0, 4
	syscall
	
	move $a0, $s6
	li $v0, 1
	syscall
	
	jr $ra

Exit:

	la $a0, result
	li $v0, 4
	syscall
	
	jal shiftNibbles

	la $a0, promptQuit
	li $v0, 4
	syscall

	li $v0, 5
	syscall

	beq $v0, 0, main
	
	la $v0, 10
	syscall
