.data
	promptSize: .asciiz "\nPlease enter size n of the array (n >= 1): "
	promptValues: .asciiz "\nPlease enter values: "
	promptMenu: .asciiz "\n--MENU--\na-monitor\nb-bubbleSort\nc-medianMax\nd-Quit\n"
	promptWarning: .asciiz "\nInvalid input!"
	promptMedian: .asciiz "\nMedian value is: "
	promptMax: .asciiz "\nMax value is: "
	displayMsg: .asciiz "\nSorted array is: "
	comma: .asciiz ", "
	size: .word 0

.globl main
.text

main:
	# ask prompt
	li $v0, 4
	la $a0, promptSize
	syscall
	
	# read n from console
	li $v0, 5
	syscall
	
	#la sss, size
	sw $v0, size	
	#la $s1, size
	#lw $s2, ($s1)
	lw $s1, size
	
	# allocate dynamic memory
	sll $a0, $v0, 2 # sll performs $a0 = $v0 x 2^2
	li $v0, 9 # 9 is the system code for service(sbrk)    
	syscall # to allocate dynamic memory
	move $s0, $v0 # $s0 head addr of array
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
			move $a0, $s0
			jal monitor
			j menu
		callB:
		   	move $a0, $s0
		   	move $a1, $s1
			jal bubbleSort
			j menu
		callC:
		   	move $a0, $s0
		   	move $a1, $s1
			jal medianMax
			j menu
		
	quit:
		
	# exit the program
	li $v0, 10
	syscall
	
monitor:
	# allocate stack space
	addi $sp, $sp, -32
	sw $s0, 8($sp)
	sw $s1, 12($sp)
	sw $s2, 16($sp)
	sw $s3, 20($sp)
	sw $s4, 24($sp)
	sw $s5, 28($sp)
	
	lw $s1, size # load size
	move $s3, $a0
	
	la $a0, promptValues
	li $v0, 4
	syscall
	
	li $s2, 0 # i = 0 (index)
	# a0(baseAddress), $s0(size)
	
	readItems:
		li $v0, 5 # user input (int)
		syscall
		
		# write to current index
		sw $v0, 0($s3)
		# increment array pos
		addi $s3, $s3, 4 # addressArray += 4
		# increment the index
		addi $s2, $s2, 1 # i += 1
		# check size is full
		blt $s2, $s1, readItems
    	
    	#restore from stack
	lw $s5, 28($sp)
	lw $s4, 24($sp)
	lw $s3, 20($sp)
	lw $s2, 16($sp)
	lw $s1, 12($sp)
	lw $s0, 8($sp)
	addi $sp, $sp, 32
	
	jr $ra
    	
# beginning address of the array in $a0, and the array size in $a1
bubbleSort:
	addi $sp, $sp, -32
	sw $s0, 8($sp)
	sw $s1, 12($sp)
	sw $s2, 16($sp)
	sw $s3, 20($sp)
	sw $s4, 24($sp)
	sw $s5, 28($sp)
	
	addi $s0, $zero, 0 # int i = 0
	subi $s2, $a1, 1 # n - 1
	move $s3, $a0 # index[a] for array
	
	forOuter:
		ble $a1, $s0, done
		addi $s1, $zero, 0 # int j = 0
		sub $v0, $s2, $s0 # n - i - 1
		addi $s0, $s0, 1 # i++
		
	forInner:
		ble $v0, $s1, forOuter
		lw $s4, 0($s3) # arr(j)
		lw $s5, 4($s3) # arr(j+1)
		addi $s1, $s1, 1 # j++
		blt $s5, $s4, swap  # t2>t1 go label
		addi $s3, $s3, 4 # array traverse index++
		j forInner	
	
	swap:
		sw $s4, 4($s3) 
		sw $s5, 0($s3)
		addi $s3, $s3, 4
		j forInner
	
	done:
	
	#restore from stack
	lw $s5, 28($sp)
	lw $s4, 24($sp)
	lw $s3, 20($sp)
	lw $s2, 16($sp)
	lw $s1, 12($sp)
	lw $s0, 8($sp)
	addi $sp, $sp, 32
	
	jr $ra # return
	
medianMax:
	addi $sp, $sp, -32
	sw $s0, 8($sp)
	sw $s1, 12($sp)
	sw $s2, 16($sp)
	sw $s3, 20($sp)
	sw $s4, 24($sp)
	sw $s5, 28($sp)
	
	# TODO:median baseAddr + ( size*2 )
	move $s0, $a0 #base addr
	div $s1, $a1, 2
	mul $s1, $s1, 4
	add $s1, $s1, $s0 #last addr
	lw $s2, ($s1)
	
	la $a0, promptMedian
	li $v0, 4
	syscall
	li $v0, 1
	move $a0, $s2
	syscall
	
	# TODO: max baseAddr + (size-1 )*4
	subi $s3, $a1, 1
	mul $s3, $s3, 4
	add $s3, $s3, $s0 # median addr
	lw $s4, ($s3)
	
	la $a0, promptMax
	li $v0, 4
	syscall
	li $v0, 1
	move $a0, $s4
	syscall
			
	#restore from stack
	lw $s5, 28($sp)
	lw $s4, 24($sp)
	lw $s3, 20($sp)
	lw $s2, 16($sp)
	lw $s1, 12($sp)
	lw $s0, 8($sp)
	addi $sp, $sp, 32

	jr $ra # return