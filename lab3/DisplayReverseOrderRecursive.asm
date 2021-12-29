.data
line: .asciiz "\n --------------------------------------"
newLine: .asciiz "\n"
promptNodeNumber: .asciiz "\n Node No.: "
promptAddrOfCurrentNode: .asciiz "\n Address of Current Node: "
promptAddrOfNextNode: .asciiz	"\n Address of Next Node: "
promptCurrentNode: .asciiz "\n Data Value of Current Node: "
promptDuplicated: .asciiz "\nDuplicated linked list: "
promptValues: .asciiz "Please enter a value:\n"
promptSize: .asciiz "Please enter the size:\n"
promptReverse: .asciiz "\nReverse Display of the linked list:\n"
promptDisplay: .asciiz "\nDisplay of the linked list:\n"

.text
.globl main
	
main:
	# ask prompt for values
	li $v0, 4
	la $a0, promptSize
	syscall
	
	li $v0, 5
	syscall

	#create a linked list with 10 nodes
	move	$a0, $v0	
	jal	createLinkedList
	
	# Linked list is pointed by $v0
	move	$a0, $v0	# Pass the linked list address in $a0
	move	$t0, $v0 # Stores the list head in $t1 for later use
	jal 	printLinkedList
	
	la	$a0, newLine
	li	$v0, 4
	syscall
	la	$a0, promptReverse
	li	$v0, 4
	syscall
	
	# Display the linked list in reverse order
	move	$a0, $t0 # Passes the list head to $a0
	jal displayInReverse
	
	# Exit the program 
	li	$v0, 10
	syscall
	
createLinkedList:
# $a0: No. of nodes to be created ($a0 >= 1)
# $v0: returns list head
	addi	$sp, $sp, -24
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3, 8($sp)
	sw	$s4, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram
	
	move	$s0, $a0	# $s0: no. of nodes to be created.
	li	$s1, 1		# $s1: Node counter
# Create the first node: header.
# Each node is 8 bytes: link field then data field.
	li	$a0, 8
	li	$v0, 9
	syscall
	
# OK now we have the list head. Save list head pointer 
	move	$s2, $v0	# $s2 points to the first and last node of the linked list.
	move	$s3, $v0	# $s3 now points to the list head.
	
	# ask prompt for values
	li $v0, 4
	la $a0, promptValues
	syscall
	
	li $v0, 5
	syscall
	sw	$v0, 4($s2)	# Store the data value.
	
addNode:
# Are we done?
# No. of nodes created compared with the number of nodes to be created.
	beq	$s1, $s0, finished
	addi	$s1, $s1, 1	# Increment node counter.
	li	$a0, 8 		# Remember: Node size is 8 bytes.
	li	$v0, 9
	syscall
# Connect the this node to the lst node pointed by $s2.
	sw	$v0, 0($s2)
# Now make $s2 pointing to the newly created node.
	move	$s2, $v0	# $s2 now points to the new node.
	
	# ask prompt for values
	li $v0, 4
	la $a0, promptValues
	syscall
	
	li $v0, 5
	syscall	
	
# sll: So that node 1 data value will be 4, node i data value will be 4*i
	sw	$v0, 4($s2)	# Store the data value.
	j	addNode
	
finished:
# Make sure that the link field of the last node cotains 0.
# The last node is pointed by $s2.
	sw	$zero, 0($s2)
	move	$v0, $s3	# Now $v0 points to the list head ($s3).
	
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s4, 4($sp)
	lw	$s3, 8($sp)
	lw	$s2, 12($sp)
	lw	$s1, 16($sp)
	lw	$s0, 20($sp)
	addi	$sp, $sp, 24
	
	jr	$ra

printLinkedList:
# Save $s registers used
	addi	$sp, $sp, -20
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram

# $a0: points to the linked list.
# $s0: Address of current
# s1: Address of next
# $2: Data of current
# $s3: Node counter: 1, 2, ...
	move $s0, $a0	# $s0: points to the current node.
	li   $s3, 0
	
	li $v0, 4
	la $a0, promptDisplay
	syscall
	
printNextNode:
	beq	$s0, $zero, printedAll
	lw	$s1, 0($s0)
	lw	$s2, 4($s0)
	addi	$s3, $s3, 1

# $s2: data field value of current node: print in decimal.		
	move	$a0, $s2	# $s2: Data of current node
	li	$v0, 1		
	syscall
	
	# Print space
	li $a0, 32
	li $v0, 11
	syscall

# Now consider next node.
	move	$s0, $s1	# Consider next node.
	j	printNextNode
	
printedAll:
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra
	
displayInReverse:
	# Allocate the stack space
	addi $sp, $sp, -12
	sw $s0, 8($sp) 
	sw $a0, 4($sp) 
	sw $ra, 0($sp)
	
	bne $a0, $0, displayInReverseLoop # Check if head is equal to null or the list has reached the end
	
	# Deallocate the stack space
	lw $ra, 0($sp) 
	lw $a0, 4($sp) 
	lw $s0, 8($sp) 
	addi $sp, $sp, 12 

	# Return
	jr $ra 

displayInReverseLoop:
	# Go to next node
	lw $a0, 0($a0) 
	
	# Recursive call
	jal displayInReverse 
	
	# Print the node value
	lw $a0, 4($sp) 
	lw $a0, 4($a0) 
	li $v0, 1
	syscall
	
	# Print space
	li $a0, 32
	li $v0, 11
	syscall
	
	# Deallocate the stack space
	lw $ra, 0($sp)
	lw $a0, 4($sp) 
	lw $s0, 8($sp) 
	addi $sp, $sp, 12 
	
	# Return
	jr $ra