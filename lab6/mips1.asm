# Course No.: CS224, Lab No. 6, Section No. 1, Ahmet Faruk Ulutaþ, 21803717
.data
options: .asciiz "\nPlease choose an option by its number.\n1. Ask the user the matrix size in terms of its dimensions (N)\n2. Allocate an array with proper size using syscall code 9\n3. Display desired elements of the matrix by specifying its row and column member\n5. Obtain summation of matrix elements row-major (row by row) summation\n6. Obtain summation of matrix elements column-major (column by column) summation\n"
promptSize: .asciiz "Please enter the size of the matrix: "
promptRowNo: .asciiz "Enter the row number of the number you want to read: "
promptColNo: .asciiz "Enter the col number of the number you want to read: "
promptResult: .asciiz "Result is: "

.text 
.globl menu
	
menu:
	# Ask user to enter option
	li $v0, 4 
	la $a0, options
	syscall
	#user option selection
	li $v0, 5 # v0 read integer
	syscall
	# Call sub programs according to options
	beq $v0, 1, option1
	beq $v0, 2, option2
	beq $v0, 3, option3
	beq $v0, 5, option5
	beq $v0, 6, option6
	option1:
		li $v0, 4 
		la $a0, promptSize
		syscall
		li $v0, 5
		syscall
		
		move $s0, $v0 # Store size in  -> $s0
		j menu
	option2:
		mul $s2, $s0, $s0 # Elements in NxN array -> $s2
		mul $a0, $s2, 4 # bytes to allocate
		li $v0, 9 # dynamic memory allocation
		syscall # base address -> $v0
		move $s1, $v0 # base address matrix -> $s1
		# call sub program fill matrix with consecutive elements
		jal fillMatrixInorder
		j menu
	option3:
		jal findElement
		j menu
	option5:
		# obtain row by row summation
		jal rowMajor
		j menu
	option6:
 		# obtain col by col summation
		jal colMajor
		j menu
li $v0, 10 # exit the program
syscall

fillMatrixInorder:
	addi $sp, $sp, -12 # matrix base and return address saved
	sw $ra, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	# start filling from 1
	li $t1, 1 # item value -> $t1
	fill:
		sw $t1, 0($s1) # write to the array
		addi $s1, $s1, 4 # next item of the matrix address
		addi $t1, $t1, 1 # increment element
		sle  $t3, $t1, $s2
		beq $t3, 1, fill
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	jr $ra # goto
	
findElement:
	# takes row and column and displays the element
	li $v0, 4 # request to read row  ([i], j)
	la $a0, promptRowNo
	syscall 
	li $v0, 5 # read row i
	syscall
	move $t0, $v0 # row -> $t0
	li $v0, 4 # request to read col (i, [j])
	la $a0, promptColNo
	syscall 
	li $v0, 5 # read col j
	syscall
	move $t1, $v0 # col -> $t1
	# calculate the position
	addi $t1, $t1, -1 # (j - 1) -> $t1
	mul $t1, $t1, 4 # (j - 1) * 4 -> $t1
	addi $t0, $t0, -1 # (i - 1) -> $t0
	mul $t0, $t0, $s0 # (i - 1) * N -> $t0
	mul $t0, $t0, 4 # (i - 1) * N * 4 -> $t0
	add $t0, $t0, $t1 # (i - 1) * N * 4 + (j - 1) * 4 -> $t0
	add $t2, $t0, $s1 # effective address of the position
	# display result prompt
	li $v0, 4 
	la $a0, promptResult # result
	syscall
	# display the item
	lw $a0, 0($t2)
	li $v0, 1
	syscall
	jr $ra

colMajor:
	addi $sp, $sp, -12 # malloc
	sw $ra, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)

	mul $t3, $s0, 4 # row offset -> $t3
	li $t0, 0 # sum -> $t0 
	li $t1, 0 # (col - 1) -> $t1
	nextRow:
		mul $t4, $t1, 4 # col offset -> $t4
		move $t2, $0 # row - 1 -> $t2  
		add $t5, $s1, $t4 # effective memory address -> $t5
		lw $t7, 0($t5) # current item -> $t7
		add $t0, $t7, $t0 # recalculate sum
		nextCol:
			add $t5, $t3, $t5 # effective memory address -> $t5
			lw $t7, 0($t5) # current item -> $t7
			add $t0, $t7, $t0 # recalculate sum
			subi $t2, $t2, -1 # row++
			blt $t2, $s0, nextCol # row < N keep continue
		subi $t1, $t1, -1 # col++
		blt $t1, $s0, nextRow

	li $v0, 4 # result message
	la $a0, promptResult 
	syscall
	# print the result
	addi $a0, $t0, 0
	li $v0, 1
	syscall 

	# dealloc
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	jr $ra # goto

rowMajor:
	addi $sp, $sp, -12 # alloc
	sw $ra, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	li $t0, 0 # sum -> $t0
	move $t2, $s2 # Counter for items
	sumRows:
		lw $t1, 0($s1) # current item -> $t1
		addi $s1, $s1, 4 #iterate over the matrix 
		add $t0, $t0, $t1 # sum -> $t0
		subi $t2, $t2, 1
		bgt $t2, $0, sumRows
	li $v0, 4 # result message
	la $a0, promptResult 
	syscall
	# print the result
	addi $a0, $t0, 0
	li $v0, 1
	syscall 

	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	jr $ra # goto
