# Arsh Parmar
# CS221 Final Project

# Local data
.data
local_palin: .space 30
# String Library 2
# Function definitions - String properties
.text
.globl strlen, isalpha, isnumber, isalphanum, palindrome

# -- Find string length --
# Arguments - 1 string
# Finds length of string excluding null terminator.
# Returns length
strlen:
lw $s0, 0($sp) # Load address of string
li $t1, 0 # Counter

strlen_loop:
    lb $t0, ($s0) # Load byte from string
    beqz $t0, return_len # Check null
    beq $t0, 10, return_len # Check EOL
    addi $s0, $s0, 1 
    addi $t1, $t1, 1 # Increase address and counter
    b strlen_loop

return_len:
sw $t1, 4($sp) # Store length in return address
jr $ra


# -- Check if only alphabetic --
# Arguments - 1 string
# Returns 0 if string is alphabetical
# Returns -1 if string is not alphabetical.
isalpha:
lw $s0, 0($sp) # Load address of string
li $t1, 1 # Initial return value

isalpha_loop:
    lb $t0, ($s0) # Load byte from string
    beqz $t0, return_isalpha # Check null
    beq $t0, 10, return_isalpha # Check EOL
    ble $t0, 122, check_lowercase
    li $t1, -1
    b return_isalpha
    check_lowercase:
    bge $t0, 97, is_alpha

    ble $t0, 90, check_uppercase
    li $t1, -1
    b return_isalpha
    check_uppercase:
    bge $t0, 65, is_alpha
    li $t1, -1
    b return_isalpha

    is_alpha:
    addi $s0, $s0, 1
    b isalpha_loop

return_isalpha:
sw $t1, 4($sp) # Store return value
jr $ra


# -- Check if only numeric --
# Arguments - 1 string
# Returns 0 if string is numeric
# Returns -1 if string is not numeric.
isnumber:
lw $s0, 0($sp) # Load address of string
li $t1, 1 # Initial return value

isnum_loop:
    lb $t0, ($s0) # Load byte from string
    beqz $t0, return_isnum # Check null
    beq $t0, 10, return_isnum # Check EOL
    ble	$t0, 57, check_num # if $t0 >= $t1 then target
    li $t1, -1 # Change return value to 0 (Found non-alpha char)
    b return_isnum
    check_num:
    bge	$t0, 48, is_num # if $t0 != $t1 then target
    li $t1, -1 # Change return value to 0 (Found non-alpha char)
    b return_isnum
    is_num:
    addi $s0, $s0, 1
    b isnum_loop

return_isnum:
sw $t1, 4($sp) # Store return value
jr $ra

# -- Check if alphanumeric --
# Arguments - 1 string
# Returns 1 if string is alphanumeric
# Returns -1 if string is not alphanumeric.
isalphanum:
lw $s0, 0($sp) # Load address of string
li $t1, 1 # Initial return value

isalphanum_loop:
    lb $t0, ($s0) # Load byte from string
    beqz $t0, return_isalphanum # Check null
    beq $t0, 10, return_isalphanum # Check EOL
    ble $t0, 122, check_lowercase2
    li $t1, -1
    b return_isalphanum
    check_lowercase2:
    bge $t0, 97, is_alphanum
    ble $t0, 90, check_uppercase2
    li $t1, -1
    b return_isalphanum
    check_uppercase2:
    bge $t0, 65, is_alphanum
    ble	$t0, 57, check_num2 # if $t0 >= $t1 then target
    li $t1, -1 # Change return value to 0 (Found non-alpha char)
    b return_isalphanum
    check_num2:
    bge	$t0, 48, is_alphanum # if $t0 != $t1 then target
    li $t1, -1 # Change return value to 0 (Found non-alpha char)
    b return_isalphanum
    is_alphanum:
    addi $s0, $s0, 1
    b isalphanum_loop

return_isalphanum:
sw $t1, 4($sp) # Store return value
jr $ra


# -- Check for palindrome --
# Arguments - 1 string
# Checks if a string is a palindrome
# Returns 1 if yes, -1 if no
# Reverses string, checks if it is equal (strrev & strcmp)
palindrome:
lw $s0, 0($sp) # String address
la $s1, local_palin # Empty address to use

# Function call -- reverse string
addiu $sp, $sp, -12
sw $s0, 0($sp) # Argument string
sw $s1, 4($sp) # Address for reverse storage
sw $ra, 8($sp)
jal strrev
lw $ra, 8($sp)
addiu $sp, $sp, 12

lw $s0, 0($sp)
la $s1, local_palin

# Function call -- string comparison
addiu $sp, $sp, -16
sw $s0, 0($sp)
sw $s1, 4($sp)
# 8th offset for return value
sw $ra, 12($sp) # Store return address
jal strcmp
lw $ra, 12($sp) # Retrieve return address
lw $t0, 8($sp) # Retrieve return value
addiu $sp, $sp, 16

bnez $t0, not_equal
li $t0, 1 # Strings match
sw $t0, 4($sp)
jr $ra

not_equal: # Strings do not match
li $t0, -1
sw $t0, 4($sp)
jr $ra


