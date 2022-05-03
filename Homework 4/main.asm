# Arsh Parmar
# Main (testing functions)

.data
demo1: .asciiz "Demo function 1:\n"
demo2: .asciiz "\nDemo function 2:\n"
string: .asciiz "Hello World"
result: .asciiz "Result: "

.text
.globl main # For assembler

main:
# Function 1: Print line
li $v0, 4
la $a0, demo1
syscall
# Set up call stack
addiu $sp, $sp, -8
la $a0, string
sw $a0, 0($sp)
sw $ra, 4($sp)
jal print_line
lw $ra, 4($sp)
# Reset stack pointer
addiu $sp, $sp, 8

# Function 1: Print line
li $v0, 4
la $a0, demo2
syscall

li $t1, -1

# Set up call stack
addiu $sp, $sp, -8
sw $ra, 4($sp)
jal read_int
lw $ra, 4($sp)
lw $t0, 0($sp)
# Reset stack pointer
addiu $sp, $sp, 8

# Print integer
li $v0, 4
la $a0, result
syscall
li $v0, 1
move $a0, $t1
syscall

# Terminate
li $v0, 10
syscall


