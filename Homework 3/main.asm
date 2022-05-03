# Arsh Parmar
# jk2680
# Function testing

.data
show_length1: .asciiz "The length of the string is (with null terminator): "
show_length2: .asciiz "The length of the string is (with newline): "
linebreak: .asciiz "\n"
string: .asciiz "Arshdeep Parmar"
string2: .ascii "Onkar Singh\n"
show_merged: .asciiz "The merged array is: "
array1: .word 3, 7, 9, 11, 15, 21, 23, 25
array2: .word 1, 4, 6, 14, 18, 19, 22, 28
length: .word 8
merged: .space 64
delimiter: .asciiz ", "

.text
.globl main
# Main function
main:
	# First call strlen
	addiu $sp, $sp, -12
	la $a0, string
	sw $a0, 0($sp) # String as argument
	# Offset 4 for return value (length)
	sw $ra, 8($sp) # Storing return address to current scope
	jal strlen # Jump to function
	lw $ra, 8($sp) # Retrieve return address for current scope
	lw $t1, 4($sp) # Return value 
	addiu $sp, $sp, 12
	# Display length
	li $v0, 4
	la $a0, show_length1
	syscall
	li $v0, 1
	move $a0, $t1
	syscall
	li $v0, 4
	la $a0, linebreak
	syscall
	# Reset register
	move $t1, $zero
	
	# Second call strlen
	addiu $sp, $sp, -12
	la $a0, string2
	sw $a0, 0($sp) # String as argument
	# Offset 4 for return value (length)
	sw $ra, 8($sp) # Storing return address to current scope
	jal strlen # Jump to function
	lw $ra, 8($sp) # Retrieve return address for current scope
	lw $t1, 4($sp) # Return value 
	addiu $sp, $sp, 12
	# Display length
	li $v0, 4
	la $a0, show_length2
	syscall
	li $v0, 1
	move $a0, $t1
	syscall
	li $v0, 4
	la $a0, linebreak
	syscall
	# Reset register
	move $t1, $zero
	
	# Calling merge
	addiu $sp, $sp, -20
	# Store address of array1
	la $a0, array1
	sw $a0, 0($sp)
	# Store address of array2
	la $a0, array2
	sw $a0, 4($sp)
	# Store length of arrays
	la $a0, merged
	sw $a0, 8($sp)
	# Store address to store merged array
	lw $t1, length
	sw $t1, 12($sp)
	# Store return address
	sw $ra, 16($sp)
	jal merge
	# Retrieve return address
	lw $ra, 16($sp)
	# Reset stack pointer
	addiu $sp, $sp, 20
	lw $t1, length
	# Set up loop controller
	add $t1, $t1, $t1
	# Set up array pointer
	li $t2, 0
	# Print array loop
	li $v0, 4
	la $a0, show_merged
	syscall
	print_loop:
		li $v0, 1
		lw $a0, merged($t2)
		syscall
		
		addi $t2, $t2, 4
		addi $t1, $t1, -1
		
		beqz $t1, continue
		
		li $v0, 4
		la $a0, delimiter
		syscall
		
		b print_loop
		
	continue:
	# Reset temps
	move $t1, $zero
	move $t2, $zero
	# Finish program
	li $v0, 10
	syscall

	
	
	
	
	
	
