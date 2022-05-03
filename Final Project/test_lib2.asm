# Arsh Parmar
# CS221 Final Project

# Local data
.data
result: .asciiz "Result: "
linebreak: .asciiz "\n"
linebreak2: .asciiz "\n\n"
# Data for string length test
strlen_text: .asciiz "--- Testing strlen ---\n\n"
prompt1: .asciiz "Enter string: "
strlen_input: .space 30
positive_test: .asciiz "The string is "
negative_test: .asciiz "The string is not "

# Data for isalpha test
isalpha_text: .asciiz "--- Testing isalpha ---\n\n"
isalpha_input: .space 30
alphabetic: .asciiz "alphabetic." 

# Data for isnumber test
isnumber_text: .asciiz "--- Testing isnumber ---\n\n"
isnumber_input: .space 30
numeric: .asciiz "numeric." 

# Data for isalphanum test
isalphanum_text: .asciiz "--- Testing isalphanum ---\n\n"
isalphanum_input: .space 30
alphanumeric: .asciiz "alphanumeric." 

# Data for palindrome test
palin_text: .asciiz "--- Testing palindrome ---\n\n"
palin_input: .space 30
is_palin: .asciiz "The string is a palindrome\n"
not_palin: .asciiz "The string is not a palindrome\n"

# Testing string library 2 functions
.text
main:
# Calling strlen
li $v0, 4
la $a0, strlen_text
syscall

# Inputs
li $v0, 4
la $a0, prompt1
syscall

li $v0, 8
la $a0, strlen_input
li $a1, 30
syscall

# Function call
addiu $sp, $sp, -12
la $a0, strlen_input
sw $a0, 0($sp) # Argument string
# 4th offset for return (length)
sw $ra, 8($sp)
jal strlen
lw $ra, 8($sp)
lw $t0, 4($sp)
addiu $sp, $sp, 12

li $v0, 4
la $a0, result
syscall

li $v0, 1
move $a0, $t0
syscall

li $v0, 4
la $a0, linebreak2
syscall
#######


# Calling isalpha
li $v0, 4
la $a0, isalpha_text
syscall

# Inputs
li $v0, 4
la $a0, prompt1
syscall

li $v0, 8
la $a0, isalpha_input
li $a1, 30
syscall

# Function call
addiu $sp, $sp, -12
la $a0, isalpha_input
sw $a0, 0($sp) # Argument string
# 4th offset for return (length)
sw $ra, 8($sp)
jal isalpha
lw $ra, 8($sp)
lw $t0, 4($sp)
addiu $sp, $sp, 12

li $v0, 4
la $a0, result
syscall

beq $t0, 1, confirm_alpha

li $v0, 4
la $a0, negative_test
syscall
li $v0, 4
la $a0, alphabetic
syscall
b end_alpha

confirm_alpha:
li $v0, 4
la $a0, positive_test
syscall
li $v0, 4
la $a0, alphabetic
syscall

end_alpha:

li $v0, 4
la $a0, linebreak2
syscall
#######


# Calling isnum
li $v0, 4
la $a0, isnumber_text
syscall

# Inputs
li $v0, 4
la $a0, prompt1
syscall

li $v0, 8
la $a0, isnumber_input
li $a1, 30
syscall

# Function call
addiu $sp, $sp, -12
la $a0, isnumber_input
sw $a0, 0($sp) # Argument string
# 4th offset for return (length)
sw $ra, 8($sp)
jal isnumber
lw $ra, 8($sp)
lw $t0, 4($sp)
addiu $sp, $sp, 12

li $v0, 4
la $a0, result
syscall

beq $t0, 1, confirm_num

li $v0, 4
la $a0, negative_test
syscall
li $v0, 4
la $a0, numeric
syscall
b end_num

confirm_num:
li $v0, 4
la $a0, positive_test
syscall
li $v0, 4
la $a0, numeric
syscall

end_num:

li $v0, 4
la $a0, linebreak2
syscall
#######


# Calling isalphanum
li $v0, 4
la $a0, isalphanum_text
syscall

# Inputs
li $v0, 4
la $a0, prompt1
syscall

li $v0, 8
la $a0, isalphanum_input
li $a1, 30
syscall

# Function call
addiu $sp, $sp, -12
la $a0, isalphanum_input
sw $a0, 0($sp) # Argument string
# 4th offset for return (length)
sw $ra, 8($sp)
jal isalphanum
lw $ra, 8($sp)
lw $t0, 4($sp)
addiu $sp, $sp, 12

li $v0, 4
la $a0, result
syscall

beq $t0, 1, confirm_alphanum

li $v0, 4
la $a0, negative_test
syscall
li $v0, 4
la $a0, alphanumeric
syscall
b end_alphanum

confirm_alphanum:
li $v0, 4
la $a0, positive_test
syscall
li $v0, 4
la $a0, alphanumeric
syscall

end_alphanum:
li $v0, 4
la $a0, linebreak2
syscall
#######


# Calling palindrome
li $v0, 4
la $a0, palin_text
syscall

# Inputs
li $v0, 4
la $a0, prompt1
syscall

li $v0, 8
la $a0, palin_input
li $a1, 30
syscall

# Function call
addiu $sp, $sp, -12
la $a0, palin_input
sw $a0, 0($sp) # Argument string
sw $ra, 8($sp)
jal palindrome
lw $ra, 8($sp)
lw $t0, 4($sp)
addiu $sp, $sp, 12

li $v0, 4
la $a0, result
syscall

beq $t0, 1, confirm_palin

li $v0, 4
la $a0, not_palin
syscall
b palin_done

confirm_palin:
li $v0, 4
la $a0, is_palin
syscall

palin_done:
li $v0, 4
la $a0, linebreak2
syscall
#######


li $v0, 10
syscall
#######

