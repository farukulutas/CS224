.data
mainInstrCount: .asciiz "Main's instruction counts for R-type and I-tpye are:\n"
functInstrCount: .asciiz "\nSubprogram's instruction counts for R-type and I-type are:\n"
countI: .asciiz "Number of I-type instructions is: "
countR: .asciiz "\nNumber of R-type instructions is: "

.text
.globl main
	
main:
	# Load addresses of the first and last instructions of main
	la $a0, main
	la $a1, mainEnd
	
	# Perform the function for the main
	jal countRI

	# Store I and R counts in t registers
	add $t0, $a0, $0 
	add $t1, $a1, $0 
	
	#add $t7, $t1, $t2
	addi $t7, $t1, 5
	
	# Display message for main instructions counts
	la $a0, mainInstrCount
	li $v0, 4
	syscall
	
	# Display addi count for main
	la $a0, countI
	li $v0, 4
	syscall
	move $a0, $t0
	li $v0, 1
	syscall
	
	# Display add count for main
	la $a0, countR
	li $v0, 4
	syscall
	move $a0, $t1
	li $v0, 1
	syscall
	
	# Load addresses of the first and last instructions of the countRI function
	la $a0, countRI
	la $a1, functionEnd
	
	# Perform the function for the countRI function
	jal countRI 
	
	# Store add and lw counts in t registers
	add $t0, $a0, $0
	add $t1, $a1, $0 
	
	# Display message for countRI function instructions counts
	la $a0, functInstrCount
	li $v0, 4
	syscall
	
	# Display lw count for countRI function
	la $a0, countI
	li $v0, 4
	syscall
	move $a0, $t0
	li $v0, 1
	syscall
	
	# Display lw count for countRI function
	la $a0, countR
	li $v0, 4
	syscall
	move $a0, $t1
	li $v0, 1
	syscall
	
	# Exits the program
	li $v0, 10
	syscall
mainEnd:

countRI:	
	# Allocate the stack space
	addi $sp, $sp, -32 
	sw $s0, 28($sp) 
	sw $s1, 24($sp) 
	sw $s2, 20($sp) 
	sw $s3, 16($sp) 
	sw $s4, 12($sp) 
	sw $s5, 8($sp) 
	sw $s6, 4($sp)
	sw $s7, 0($sp) 
	
	# Load first and last instructions to s registers using add
	add $s2, $s2, $a0 
	add $s3, $s3, $a1 
	
	# Load 0 to counters using add
	add $s5, $s5, $0 
	add $s6, $s6, $0 
	add $s7, $s7, $0 
	
	
loop:
	# Function is completed if the first address is greater than the last address
	sgt $s5, $s2, $s3
	bne $s5, $0, done
	
	# Load the value of the address to another register and go to the next address
	lw $s0, ($s2)
	li $s5, 4
	add $s2, $s2, $s5
	
	# Load R-Type's opcode to $s5 (add)
	li $s5, 0

	# Compare the current adressess' opcode with add's opcode
	srl $s1, $s0, 26
	sne $s5, $s1, $0 
	beq $s5, $0, incrementR 
	
	# Load I-Type's opcode to $s5 (addi)
	li $s5, 2
	
	# Compare the current adressess' opcode with lw's opcode, increment lw counter if equal
	srl $s1, $s0, 26 
	sne $s4, $s1, $s5
	
	addi $s5, $s5, 1
	sne  $s1, $s1, $s5
	  
	and $s1, $s1, $s4
	beq $s1, 1, incrementI
	
	j loop
	
incrementI:
	# Increment lw counter
	addi $s6, $s6, 1
	j loop 
	
incrementR:
	# Increment add counter
	addi $s7, $s7, 1
	j loop 
done:
	# Move the results back to a registers
	move $a0, $s6
	move $a1, $s7 
	
	# Deallocate the stack space
	lw $s7, 0($sp) 
	lw $s6, 4($sp) 
	lw $s5, 8($sp)
	lw $s4, 12($sp) 
	lw $s3, 16($sp) 
	lw $s2, 20($sp) 
	lw $s1, 24($sp)
	lw $s0, 28($sp) 
	addi $sp, $sp, 32 
	
	# Return to main
	jr $ra 
functionEnd:
