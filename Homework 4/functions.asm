# Arsh Parmar
# Functions

.data
prompt1: .asciiz "String to print: (printed on MMIO console)"
prompt2: .asciiz "Enter a positive integer to print: "
integer: .space 11

.text
.globl print_line, read_int

# FUNCTION 1: Print line
print_line:
li $v0, 4
la $a0, prompt1
syscall

# Fetching address stored in stack pointer offset 0
lw $s0, 0($sp)

# Setting register to terminal address
li $a3, 0xFFFF0000
outer_loop:
	# Loading the character from address + offset
	lb $t0, 0($s0)
	beq $t0, $zero, loop_done # Null terminator check
	
	# Output ready check
	ready_check:
		lw $t1, 8($a3)
		andi $t1, $t1, 1
		beqz $t1, ready_check
		# Store byte for output
		sw $t0, 12($a3)
	
	# Increment address
	addi $s0, $s0, 1
	b outer_loop
	
loop_done:
# Print newline
li $v0, 11
li $a0, 10
syscall

# Clear registers and return
move $t0, $zero
move $t1, $zero
move $s0, $zero

jr $ra

####

# FUNCTION 2: Read integer
read_int:
li $v0, 4
la $a0, prompt2
syscall

la $a0, integer

# Setting register to terminal address
li $a3, 0xFFFF0000
outer_loop2:
	input_ready:
		lw $t1, 0($a3)
		andi $t1, $t1, 1
		beqz $t1, input_ready
	lw $t0, 4($a3)
	beq $t0, 10, input_done
	beq $t0, 13, input_done
	sb $t0, ($a0)
	addi $a0, $a0, 1
	b outer_loop2
	
input_done:
sb $zero, ($a0)
la $a1, integer
move $t0, $zero
li $v0, 11
li $a0, 10
syscall
la $a1, integer

# Invalid characters check
invalid_loop:
	lb $t0, ($a1)
	beqz $t0, overflow
	bgt $t0, 57, invalid_input
	blt $t0, 48, invalid_input
	addi $a1, $a1, 1
	b invalid_loop
	
# Overflow/Underflow check
overflow:
la $a1, integer
li $t1, 0
li $t2, 10
convert:
	lb $t0, ($a1)
	beqz $t0, check_overflow
	subiu $t0, $t0, 48 
	add $t1, $t1, $t0
	mult $t1, $t2
	mflo $t1
	addi $a1, $a1, 1
	b convert

check_overflow:
div $t1, $t2
mflo $t1
#bgt $t1, $t2, invalid_input
sw $t1, 0($sp)
jr $ra
	
# Negative result
invalid_input:
li $t1, -1
sw $t1, 0($sp)
jr $ra