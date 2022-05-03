# Arsh Parmar
# CS221 Final Project

# Local data
.data
.align 2
add_sub: .word 5
add_space: .space 30
sub_space: .space 30

# String Library 3
# Function definitions
# Simple string encoding/decoding, reverse string and subtract 5 from each character (opposite for decoding).
.text
# add_char, sub_char --> encoding/decoding purpose
.globl add_char, sub_char, encode, decode

# -- Increment characters in a string --
# Arguments - 1 string, 1 integer
add_char: # To be called by decode
lw $s0, 0($sp) # string
lw $s1, 4($sp) # Empty string
lw $s2, 8($sp) # Integer to add

add_loop:
    lb $t0, ($s0) 
    beqz $t0, return_add
    beq $t0, 10, return_add
    add $t0, $t0, $s2 # Add to character
    sb $t0, ($s1) # Store modified char
    addi $s0, $s0, 1
    addi $s1, $s1, 1
    b add_loop

return_add:
jr $ra

# -- Decrement characters in a string --
# Arguments - 1 string, 1 integer
sub_char: # To be called by encode
lw $s0, 0($sp) # string
lw $s1, 4($sp) # Empty string
lw $s2, 8($sp) # Integer to subtract

sub_loop:
    lb $t0, ($s0)
    beqz $t0, return_sub
    beq $t0, 10, return_sub
    sub $t0, $t0, $s2 # Subtract from char
    sb $t0, ($s1) # Store modified char
    addi $s0, $s0, 1
    addi $s1, $s1, 1
    b sub_loop

return_sub:
jr $ra

# -- Encode string --
# Arguments - 1 string, 1 empty string
# Encodes the string
# Places an encoded copy in empty address
encode:
# Load arguments
lw $s0, 0($sp)
la $s1, sub_space
la $a0, add_sub
lw $s2, ($a0)

# Calling sub_char
addiu $sp, $sp, -16
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $ra, 12($sp)
jal sub_char
lw $ra, 12($sp)
addiu $sp, $sp, 16

la $s1, sub_space
lw $s2, 4($sp)

# Calling strrev
addiu $sp, $sp, -12
sw $s1, 0($sp)
sw $s2, 4($sp)
sw $ra, 8($sp)
jal strrev
lw $ra, 8($sp)
addiu $sp, $sp, 12

jr $ra

# -- Decode string --
# Arguments - 1 (encoded) string, 1 empty string
# Decodes the string
# Places a decoded copy in empty address
decode:
lw $s0, 0($sp)
la $s1, add_space
la $a0, add_sub
lw $s2, ($a0)

addiu $sp, $sp, -16
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $ra, 12($sp)
jal add_char
lw $ra, 12($sp)
addiu $sp, $sp, 16

la $s1, add_space
lw $s2, 4($sp)

addiu $sp, $sp, -12
sw $s1, 0($sp)
sw $s2, 4($sp)
sw $ra, 8($sp)
jal strrev
lw $ra, 8($sp)
addiu $sp, $sp, 12
jr $ra
