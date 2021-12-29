.data
octal: .space 8
prompt: .asciiz "\nPlease enter octal values (max 7 digits): "
promptEnd: .asciiz "\nYour input is not octal."

.globl start
.text	
start:
	# ask prompt
	la $a0, prompt
	li $v0, 4
	syscall
	
	la $a0, octal
	li $a1, 21 # max 21 bytes to read 
	li $v0, 8 # read octal number as string
	sw $a0, octal
	syscall
	
	# load the address
	la $a0, octal
	
	# Converts user input str (octal) to dec
	jal convertToDec
	
	# print the decimal value
	move $a0, $v0
	li $v0, 1
	syscall
	
	j start
	
exit:
	li $v0, 4
	la $a0, promptEnd 
	syscall 

	li $v0, 10
	syscall

convertToDec:
	allocate:
		subi $sp, $sp, 20
		sw $s0, 16($sp) 	
		sw $s1, 12($sp)
		sw $s2, 8($sp)
		sw $s3, 4($sp)
		sw $ra, 0($sp)
	# find end of the string
	# s0 contains address of the last char after stringEnd
	endOfString:
		move $s0, $a0 # s0: address of the string
		nextChar:
			lb $s1, 0($s0) # s1: current char
			blt $s1, 10, foundEnd # "enter" (ASCII : 10)"
			addi $s0, $s0, 1 # goto next char
			j nextChar
		foundEnd:
				subi $s0, $s0, 2 # excluding enter (ASCII: 10)
	li $s2, 1 # go from lsd(least sig digit) to msd(most sig digit)
	li $s3, 8
	li $v0, 0 # will contain the result
	calcDec:
		# check beginning of string reached or not
		blt $s0, $a0, finish
		lb $s1, 0($s0) # load the octal character
		bgt $s1, 55, notOctal # digit > 7 (not valid octal value)
		blt $s1, 48, notOctal # digit < 0 (not valid octal value)
		asciiToDec:
			subi $s1, $s1, 48 # get the decimal value
			mul $s1, $s2, $s1 # adjust 
		# add to the result
		add $v0, $v0, $s1
		# decrement the address go to the next char in string
		subi $s0, $s0, 1
		mul $s2, $s2, $s3 # 8**(digit)
		j calcDec
	notOctal:
		# jump exit
		j exit
	finish:
		# obtained the result in v0
	deallocate: # deallocate the stack space
		lw $ra, 0($sp)
	 	lw $s3, 4($sp)
	 	lw $s2, 8($sp)
	 	lw $s1, 12($sp)
	 	lw $s0, 16($sp)
	 	addi $sp, $sp, 20
	jr $ra # return main
