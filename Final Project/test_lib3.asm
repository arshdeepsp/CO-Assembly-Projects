# Arsh Parmar
# CS221 Final Project

# Local data
.data
result: .asciiz "Result: "
linebreak: .asciiz "\n"
linebreak2: .asciiz "\n\n"
prompt: .asciiz "Enter a string: "

# Data for encoding test
encode_text: .asciiz "--- Testing encoding ---\n\n"
str_encode: .space 30
encoded: .space 30

# Data for decoding test
decode_text: .asciiz "--- Testing decoding ---\n\n"
str_decode: .space 30
decoded: .space 30

# Testing string library 3 functions
.text
main:
# Calling encode
li $v0, 4
la $a0, encode_text
syscall

# Inputs
li $v0, 4
la $a0, prompt
syscall

li $v0, 8
la $a0, str_encode
li $a1, 30
syscall

# Function call
addiu $sp, $sp, -12
la $a0, str_encode # Argument 1 - string to encode
sw $a0, 0($sp)
la $a0, encoded # Argument 2 - encoded string space
sw $a0, 4($sp)
sw $ra, 8($sp) # Store return address
jal encode
lw $ra, 8($sp) # Retrieve return address
addiu $sp, $sp, 12

li $v0, 4
la $a0, result
syscall

# Printing out modified 3rd string
li $v0, 4
la $a0, encoded
syscall

li $v0, 4
la $a0, linebreak2
syscall
#######


# Calling decode
li $v0, 4
la $a0, decode_text
syscall

# Inputs
li $v0, 4
la $a0, prompt
syscall

li $v0, 8
la $a0, str_decode
li $a1, 30
syscall

# Function call
addiu $sp, $sp, -12
la $a0, str_decode # Argument 1 - string to decode
sw $a0, 0($sp)
la $a0, decoded # Argument 2 - decoded string space
sw $a0, 4($sp)
sw $ra, 8($sp) # Store return address
jal decode
lw $ra, 8($sp) # Retrieve return address
addiu $sp, $sp, 12

li $v0, 4
la $a0, result
syscall

# Printing out modified 3rd string
li $v0, 4
la $a0, decoded
syscall

li $v0, 4
la $a0, linebreak2
syscall
#######

li $v0, 10
syscall

