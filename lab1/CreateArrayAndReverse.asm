.data
	array: .space 80 # up to 20 elements, 80 bytes
	size: .word 0 # int user input, 4 bytes
	askPromptSize: .asciiz "Please specify the amount of numbers you want to enter. (1 <= size <= 20) \n"
	askPromptValues: .asciiz "Enter the numbers. \n"
	comma: .asciiz ", "
	displayMsg: .asciiz "\nDisplay array contents.\n"
	displayMsgReversed: .asciiz "\nDisplay reversed array contents.\n"

.globl start
.text
# Function main		
start:
	# prompt user to enter size of the array
	li $v0, 4
	la $a0, askPromptSize
	syscall
	
	# read the user input
	li $v0, 5
	syscall
	sw $v0, size
	jal createArray
	jal displayItems
	addi $t4, $0, 0
	
	# $t0 points to the address of the last element, load as an argument to reverseArray
	la $a0, 0($t0)
	jal reverseArray
	jal displayItems
	
	# exit the program
	li $v0, 10	
	syscall

# Function creates and init arrays
createArray:
	lw $t1, size # $t1 = size
	la $t0, array # $t0 = array[0]
	addi $t2, $0, 0 # $t2 = 0 (index)
	
	# prompt user to enter the values
	la $a0, askPromptValues
	li $v0, 4
	syscall
	
	readInput:
		li $v0, 5 # user input (int)
		syscall
		sw $v0, 0($t0) # array[i] = $v0
		addi $t0, $t0, 4 # $t0 = $t0 + 1 (4-bytes) (array[i])
		addi $t2, $t2, 1 # $t2 = $t2 + 1 (index++)
		blt $t2, $t1, readInput # continue to loop if $t2 < $t1 (index < size)
	
	jr $ra # return
	
# Function reverses array items 
reverseArray:
	# $t0 already have the address of the last element in the array
	la $t1, array # load the base address into the t1
	# swap elements if  ($t1 > $t0)
	swapItems:
		# load items into the registers
		lw $t3, 0($t0)
		lw $t4,	0($t1)
		# swap and store items
		sw $t3, 0($t1)
		sw $t4,	0($t0)
		# increment address of $t1 by 1 word (4 byte)
		addi $t1, $t1, 4
		# decrement address of $t0 by 1 word (4 byte)
		subi $t0, $t0, 4
		# check condition
		bgt $t0, $t1, swapItems
		
	addi $t4, $t4, 1	
	jr $ra # return
	
# Function displays the array msg and content
displayItems:
	lw $t1, size # $t1 = size
	la $t0, array # $t0 = array(0)
	addi $t2, $0, 0 # $t2 = 0 (index)
	
	bne $t4, $0, reversedMsg # $t4 != 0, reversedMsg
	
	# display message
	li $v0, 4
	la $a0, displayMsg
	syscall
	j display
	
	reversedMsg:
		# display message reversed
		li $v0, 4
		la $a0, displayMsgReversed
		syscall
	
	display:
		# read data from the memory
		lw $a0, 0($t0)
		# increment array index by one position (4 bytes)
		addi $t0, $t0, 4 # array[i]
		# print item
		li $v0, 1
		syscall
		# if not the last element add seperator in between
		addi $t4, $t2, 1
		
		bgt $t1, $t4, seperate # if (index + 1) < size seperate
		ble $t1, $t4, done	# else done
		seperate:
			la $a0, comma
			li $v0, 4
			syscall
		done:
		# increment the index
		addi $t2, $t2, 1	# i += 1
		# continue if i < size
		blt $t2, $t1, display
	# set $t0 adress to the last element
	subi $t0, $t0, 4
	jr $ra # go to the next instruction	