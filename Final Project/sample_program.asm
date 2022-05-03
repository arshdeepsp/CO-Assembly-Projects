# Arsh Parmar
# CS221 Final Project

# This sample program utilises several functions from the string library. 
# It is a simple user registration program
# It uses concat, strcmp and empty from string_lib1
# It uses all functions from string_lib2

# Prompts and program memory
.data
first_name: .space 30
last_name: .space 30
full_name: .space 60
password: .space 30
confirm_password: .space 30
phone_number: .space 15
age: .space 5

user_welcome: .asciiz "----- User Registration -----\n\n"
boundary: .asciiz "----------------------------------------------------------\n\n"
blank: .asciiz " "
linebreak: .asciiz "\n\n"
fname_prompt: .asciiz "Please enter your first name (only letters): "
lname_prompt: .asciiz "Please enter your last name (only letters): "
pw_prompt: .asciiz "Please enter a new password (alphanumeric, min 6, max 20 characters): "
cpw_prompt: .asciiz "Please exactly confirm the password: "
phone_prompt: .asciiz "Please enter your phone number (10 digits only): "
age_prompt: .asciiz "Please enter your age (1-99): "

# Registration completed
reg_success1: .asciiz "Congratulations, "
reg_success2: .asciiz ", you have been registered!\n\n"

# Main function call
.text
main:
li $v0, 4
la $a0, user_welcome
syscall

# Input first name
fname_loop:
    li $v0, 4
    la $a0, fname_prompt
    syscall

    # Emptying address
    addiu $sp, $sp, -8
    la $a0, first_name
    sw $a0, 0($sp)
    sw $ra, 4($sp)
    jal empty
    lw $ra, 4($sp)
    addiu $sp, $sp, 8

    li $v0, 4
    la $a0, first_name
    syscall

    li $v0, 8
    la $a0, first_name
    li $a1, 30
    syscall

    addiu $sp, $sp, -12
    la $a0, first_name
    sw $a0, 0($sp)
    sw $ra, 8($sp)
    jal isalpha
    lw $ra, 8($sp)
    lw $t0, 4($sp)
    addiu $sp, $sp, 12

    li $v0, 4
    la $a0, linebreak
    syscall

    beq $t0, 1, lname_loop

    b fname_loop

# Input last name
lname_loop:
    li $v0, 4
    la $a0, lname_prompt
    syscall

    # Emptying address
    addiu $sp, $sp, -8
    la $a0, last_name
    sw $a0, 0($sp)
    sw $ra, 4($sp)
    jal empty
    lw $ra, 4($sp)
    addiu $sp, $sp, 8

    li $v0, 8
    la $a0, last_name
    li $a1, 30
    syscall

    addiu $sp, $sp, -12
    la $a0, last_name
    sw $a0, 0($sp)
    sw $ra, 8($sp)
    jal isalpha
    lw $ra, 8($sp)
    lw $t0, 4($sp)
    addiu $sp, $sp, 12

    li $v0, 4
    la $a0, linebreak
    syscall

    beq $t0, 1, process_name

    b lname_loop

process_name:
# Concatenation of both names
addiu $sp, $sp, -16
la $a0, first_name
sw $a0, 0($sp)
la $a0, blank
sw $a0, 4($sp)
la $a0, full_name
sw $a0, 8($sp)
sw $ra, 12($sp)
jal concat
lw $ra, 12($sp)
addiu $sp, $sp, 16

addiu $sp, $sp, -16
la $a0, full_name
sw $a0, 0($sp)
la $a0, last_name
sw $a0, 4($sp)
la $a0, full_name
sw $a0, 8($sp)
sw $ra, 12($sp)
jal concat # Calling concat to join both names
lw $ra, 12($sp)
addiu $sp, $sp, 16

# Input password loop
pw_loop:
    li $v0, 4
    la $a0, pw_prompt
    syscall

    # Emptying address
    addiu $sp, $sp, -8
    la $a0, password
    sw $a0, 0($sp)
    sw $ra, 4($sp)
    jal empty
    lw $ra, 4($sp)
    addiu $sp, $sp, 8

    li $v0, 8
    la $a0, password
    li $a1, 30
    syscall

    addiu $sp, $sp, -12
    la $a0, password
    sw $a0, 0($sp)
    sw $ra, 8($sp)
    jal isalphanum
    lw $ra, 8($sp)
    lw $t0, 4($sp)
    addiu $sp, $sp, 12

    beq $t0, 1, pw_len_check

    li $v0, 4
    la $a0, linebreak
    syscall

    b pw_loop

    pw_len_check:
    addiu $sp, $sp, -12
    la $a0, password
    sw $a0, 0($sp)
    sw $ra, 8($sp)
    jal strlen
    lw $ra, 8($sp)
    lw $t0, 4($sp)
    addiu $sp, $sp, 12

    li $v0, 4
    la $a0, linebreak
    syscall

    ble $t0, 20, min_check
    b pw_loop
    min_check:
    bge $t0, 6, cpw_loop
    b pw_loop

cpw_loop:
    li $v0, 4
    la $a0, cpw_prompt
    syscall

    # Emptying address
    addiu $sp, $sp, -8
    la $a0, confirm_password
    sw $a0, 0($sp)
    sw $ra, 4($sp)
    jal empty
    lw $ra, 4($sp)
    addiu $sp, $sp, 8

    li $v0, 8
    la $a0, confirm_password
    li $a1, 30
    syscall
    
    # Password confirmation checking
    addiu $sp, $sp, -16
    la $a0, password
    sw $a0, 0($sp)
    la $a0, confirm_password
    sw $a0, 4($sp)
    sw $ra, 12($sp)
    jal strcmp
    lw $ra, 12($sp)
    lw $t0, 8($sp)
    addiu $sp, $sp, 16

    li $v0, 4
    la $a0, linebreak
    syscall

    beqz $t0, phone_loop

    b cpw_loop

phone_loop:
    li $v0, 4
    la $a0, phone_prompt
    syscall

    # Emptying address
    addiu $sp, $sp, -8
    la $a0, phone_number
    sw $a0, 0($sp)
    sw $ra, 4($sp)
    jal empty
    lw $ra, 4($sp)
    addiu $sp, $sp, 8

    li $v0, 8
    la $a0, phone_number
    li $a1, 15
    syscall

    addiu $sp, $sp, -12
    la $a0, phone_number
    sw $a0, 0($sp)
    sw $ra, 8($sp)
    jal isnumber
    lw $ra, 8($sp)
    lw $t0, 4($sp)
    addiu $sp, $sp, 12

    beq $t0, 1, phone_len_check
    
    li $v0, 4   
    la $a0, linebreak
    syscall

    b phone_loop

    phone_len_check:
    addiu $sp, $sp, -12
    la $a0, phone_number
    sw $a0, 0($sp)
    sw $ra, 8($sp)
    jal strlen
    lw $ra, 8($sp)
    lw $t0, 4($sp)
    addiu $sp, $sp, 12

    li $v0, 4
    la $a0, linebreak
    syscall

    beq $t0, 10, age_loop

    b phone_loop

age_loop:
    li $v0, 4
    la $a0, age_prompt
    syscall

    # Emptying address
    addiu $sp, $sp, -8
    la $a0, age
    sw $a0, 0($sp)
    sw $ra, 4($sp)
    jal empty
    lw $ra, 4($sp)
    addiu $sp, $sp, 8

    li $v0, 8
    la $a0, age
    li $a1, 5
    syscall

    addiu $sp, $sp, -12
    la $a0, age
    sw $a0, 0($sp)
    sw $ra, 8($sp)
    jal isnumber
    lw $ra, 8($sp)
    lw $t0, 4($sp)
    addiu $sp, $sp, 12

    beq $t0, 1, age_len_check

    li $v0, 4
    la $a0, linebreak
    syscall

    b age_loop

    age_len_check:
    addiu $sp, $sp, -12
    la $a0, age
    sw $a0, 0($sp)
    sw $ra, 8($sp)
    jal strlen
    lw $ra, 8($sp)
    lw $t0, 4($sp)
    addiu $sp, $sp, 12

    li $v0, 4
    la $a0, linebreak
    syscall

    ble $t0, 2, age_min_check
    b age_loop
    age_min_check:
    bgt $t0, 0, reg_done
    b age_loop

reg_done:
li $v0, 4
la $a0, boundary
syscall

li $v0, 4
la $a0, reg_success1
syscall

li $v0, 4
la $a0, full_name
syscall

li $v0, 4
la $a0, reg_success2
syscall

li $v0, 4
la $a0, boundary
syscall

li $v0, 10
syscall
