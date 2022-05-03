# Arsh Parmar
# CS221 Final Project

# Local data
.data
result: .asciiz "Result: "
linebreak: .asciiz "\n"
linebreak2: .asciiz "\n\n"
# Data for concatenation test
concat_text: .asciiz "--- Testing concatenation ---\n\n"
prompt1: .asciiz "Enter first string: "
prompt2: .asciiz "Enter second string: "
string1: .space 30
string2: .space 30
concat_string: .space 60

# Data for substring test
substr_text: .asciiz "--- Testing substring find ---\n\n"
prompt3: .asciiz "Enter main string: "
prompt4: .asciiz "Enter string to match for substring: "
str: .space 30
substr: .space 30

# Data for string compare test
strcmp_text: .asciiz "--- Testing string comparison ---\n\n"
# Using same prompts as concatentaion
strcmp1: .space 30
strcmp2: .space 30
cmp_equal: .asciiz "The two strings are the same"
cmp_notequal: .asciiz "The two strings are different"

# Data for string slice test
strslice_text: .asciiz "--- Testing string slicing ---\n\n"
prompt5: .asciiz "Enter a string: "
prompt_starting: .asciiz "Enter a starting index: "
prompt_ending: .asciiz "Enter a ending index: "
str_to_slice: .space 30
sliced: .space 30
.align 2
start_index: .space 4
.align 2
end_index: .space 4

# Data for string copy test
strcpy_text: .asciiz "--- Testing string copy ---\n\n"
# Same prompt as slice test
str_to_copy: .space 30
copy: .space 30

# Data for string reverse test
strrev_text: .asciiz "--- Testing string reverse ---\n\n"
# Same prompt as slice test
str_to_reverse: .space 30
reverse: .space 30

# Data for toupper test
toupper_text: .asciiz "--- Testing toupper ---\n\n"
# Same prompt as slice test
convert_upper: .space 30
str_toupper: .space 30

# Data for tolower test
tolower_text: .asciiz "--- Testing tolower ---\n\n"
# Same prompt as slice test
convert_lower: .space 30
str_tolower: .space 30

# Data for strip test
strip_text: .asciiz "--- Testing strip ---\n\n"
# Same prompt as slice test
str_to_strip: .asciiz "    Hello World    "
strip_test_str: .asciiz ", Welcome To My Program."
stripped: .space 50

# ----------

# Testing string library 1 functions
.text
main:
# Calling concat
li $v0, 4
la $a0, concat_text
syscall

# Inputs
li $v0, 4
la $a0, prompt1
syscall

li $v0, 8
la $a0, string1
li $a1, 30
syscall

li $v0, 4
la $a0, prompt2
syscall

li $v0, 8
la $a0, string2
li $a1, 30
syscall

# Function call
addiu $sp, $sp, -16
la $a0, string1 # Argument 1
sw $a0, 0($sp)
la $a0, string2 # Argument 2
sw $a0, 4($sp)
la $a0, concat_string # Concatenated string address
sw $a0, 8($sp)
sw $ra, 12($sp) # Store return address
jal concat
lw $ra, 12($sp) # Retrieve return address
addiu $sp, $sp, 16

li $v0, 4
la $a0, result
syscall

# Printing out modified 3rd string
li $v0, 4
la $a0, concat_string
syscall

li $v0, 4
la $a0, linebreak2
syscall
#######


# Calling issubstr
li $v0, 4
la $a0, substr_text
syscall

# Inputs
li $v0, 4
la $a0, prompt3
syscall

li $v0, 8
la $a0, str
li $a1, 30
syscall

li $v0, 4
la $a0, prompt4
syscall

li $v0, 8
la $a0, substr
li $a1, 30
syscall

# Function call
addiu $sp, $sp, -16
la $a0, str # Argument 1
sw $a0, 0($sp)
la $a0, substr # Argument 2
sw $a0, 4($sp)
# 8th offset for return value
sw $ra, 12($sp) # Store return address
jal issubstr
lw $ra, 12($sp) # Retrieve return address
lw $t0, 8($sp) # Retrieve return value
addiu $sp, $sp, 16

li $v0, 4
la $a0, result
syscall

# Printing out return value
li $v0, 1
move $a0, $t0
syscall

li $v0, 4
la $a0, linebreak2
syscall
#######


# Calling strcmp
li $v0, 4
la $a0, strcmp_text
syscall

# Inputs
li $v0, 4
la $a0, prompt1
syscall

li $v0, 8
la $a0, strcmp1
li $a1, 30
syscall

li $v0, 4
la $a0, prompt2
syscall

li $v0, 8
la $a0, strcmp2
li $a1, 30
syscall

# Function call
addiu $sp, $sp, -16
la $a0, strcmp1 # Argument 1
sw $a0, 0($sp)
la $a0, strcmp2 # Argument 2
sw $a0, 4($sp)
# 8th offset for return value
sw $ra, 12($sp) # Store return address
jal strcmp
lw $ra, 12($sp) # Retrieve return address
lw $t0, 8($sp) # Retrieve return value
addiu $sp, $sp, 16

li $v0, 4
la $a0, result
syscall

bnez $t0, not_equal
li $v0, 4
la $a0, cmp_equal
syscall
b next

not_equal:
li $v0, 4
la $a0, cmp_notequal
syscall

next:
li $v0, 4
la $a0, linebreak2
syscall
#######


# Calling strslice
li $v0, 4
la $a0, strslice_text
syscall

# Inputs
li $v0, 4
la $a0, prompt5
syscall

li $v0, 8
la $a0, str_to_slice
li $a1, 30
syscall

li $v0, 4
la $a0, prompt_starting
syscall

li $v0, 5
syscall
la $a0, start_index
sw $v0, ($a0)

li $v0, 4
la $a0, prompt_ending
syscall

li $v0, 5
syscall
la $a0, end_index
sw $v0, ($a0)

# Function call
addiu $sp, $sp, -20
la $a0, str_to_slice
sw $a0, 0($sp) # Argument 1
la $a0, start_index
sw $a0, 4($sp) # Argument 2
la $a0, end_index
sw $a0, 8($sp) # Argument 3
la $a0, sliced
sw $a0, 12($sp) # Space for sliced string
sw $ra, 16($sp)
jal strslice
lw $ra, 16($sp)
addiu $sp, $sp, 20

li $v0, 4
la $a0, result
syscall

li $v0, 4
la $a0, sliced
syscall

li $v0, 4
la $a0, linebreak2
syscall
#######


# Calling strrev
li $v0, 4
la $a0, strcpy_text
syscall

# Input
li $v0, 4
la $a0, prompt5
syscall

li $v0, 8
la $a0, str_to_copy
li $a1, 30
syscall

# Function call
addiu $sp, $sp, -12
la $a0, str_to_copy
sw $a0, 0($sp) # Argument string
la $a0, copy
sw $a0, 4($sp) # Address for copying
sw $ra, 8($sp)
jal strcpy
lw $ra, 8($sp)
addiu $sp, $sp, 12

li $v0, 4
la $a0, result
syscall

li $v0, 4
la $a0, copy
syscall

li $v0, 4
la $a0, linebreak2
syscall
#######


# Calling strcpy
li $v0, 4
la $a0, strrev_text
syscall

# Input
li $v0, 4
la $a0, prompt5
syscall

li $v0, 8
la $a0, str_to_reverse
li $a1, 30
syscall

# Function call
addiu $sp, $sp, -12
la $a0, str_to_reverse
sw $a0, 0($sp) # Argument string
la $a0, reverse
sw $a0, 4($sp) # Address for copying
sw $ra, 8($sp)
jal strrev
lw $ra, 8($sp)
addiu $sp, $sp, 12

li $v0, 4
la $a0, result
syscall

li $v0, 4
la $a0, reverse
syscall

li $v0, 4
la $a0, linebreak2
syscall
#######


# Calling toupper
li $v0, 4
la $a0, toupper_text
syscall

# Input
li $v0, 4
la $a0, prompt5
syscall

li $v0, 8
la $a0, convert_upper
li $a1, 30
syscall

# Function call
addiu $sp, $sp, -12
la $a0, convert_upper
sw $a0, 0($sp) # Argument string
la $a0, str_toupper
sw $a0, 4($sp) # Empty string to fill
sw $ra, 8($sp)
jal toupper
lw $ra, 8($sp)
addiu $sp, $sp, 12

li $v0, 4
la $a0, result
syscall

li $v0, 4
la $a0, str_toupper
syscall

li $v0, 4
la $a0, linebreak2
syscall
#######


# Calling tolower
li $v0, 4
la $a0, tolower_text
syscall

# Input
li $v0, 4
la $a0, prompt5
syscall

li $v0, 8
la $a0, convert_lower
li $a1, 30
syscall

# Function call
addiu $sp, $sp, -12
la $a0, convert_lower
sw $a0, 0($sp) # Argument string
la $a0, str_tolower
sw $a0, 4($sp) # Empty string to fill
sw $ra, 8($sp)
jal tolower
lw $ra, 8($sp)
addiu $sp, $sp, 12

li $v0, 4
la $a0, result
syscall

li $v0, 4
la $a0, str_tolower
syscall

li $v0, 4
la $a0, linebreak2
syscall
#######


# Calling strip
li $v0, 4
la $a0, strip_text
syscall

# Function call
addiu $sp, $sp, -12
la $a0, str_to_strip
sw $a0, 0($sp) # Argument string
la $a0, stripped
sw $a0, 4($sp) # Empty string to fill
sw $ra, 8($sp)
jal strip
lw $ra, 8($sp)
addiu $sp, $sp, 12

li $v0, 4
la $a0, result
syscall

li $v0, 4
la $a0, stripped
syscall

li $v0, 4
la $a0, strip_test_str
syscall

li $v0, 4
la $a0, linebreak2
syscall
#######

li $v0, 10
syscall



