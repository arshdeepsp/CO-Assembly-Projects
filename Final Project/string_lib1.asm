# Arsh Parmar
# CS221 Final Project

# Local data
.data
local_rstrip: .space 30
local_rstrip2: .space 30
local_strip: .space 60
stub: .asciiz "Stub"
# String Library 1
# Function definitions - Functions handling 2+ string addresses (as arguments or results)
.text
.globl concat, issubstr, strcmp, strslice, strcpy, strrev, toupper, tolower, lstrip, rstrip, strip, empty
# -- Concatenate two strings --
# Arguments - 2 strings, 1 empty string
# Adds second argument string to the end of the first string
# Inserts joined string to empty string whose address is given as an argument.
concat:
lw $a0, 0($sp)
lw $t0, 8($sp)
first: # Adding first string to empty string
	lb $t1, ($a0) # Load from first string
	beqz $t1, continue # Check if null
	beq $t1, 10, continue # Check if newline
	sb $t1, ($t0) # Store in memory+offset
	# Increment addresses (first string and empty string)
	addi $a0, $a0, 1
	addi $t0, $t0, 1
	b first

continue: # Load second string
lw $a0, 4($sp)

second: # Adding second string to end of the first
	lb $t1, ($a0) # Load from second string
	beqz $t1, return # Check if null
	beq $t1, 10, return # Check if newline
	sb $t1, ($t0) # Store in memory+offset
	# Increment addresses (first string and empty string)
	addi $a0, $a0, 1
	addi $t0, $t0, 1
	b second

# No return values, as empty address provided
# has been modified with the new string
return:
jr $ra


# -- Substring search --
# Arguments - 2 strings
# Searches for the second string argument in the first string argument.
# Returns index of first matching character if match found.
# Returns -1 if no matching substring is found or if second
# string is larger than the first.
issubstr:
# Loading arguments
lw $s0, 0($sp)
lw $s1, 4($sp)
li $s2, 0 # Initial index of substring

outer: # To move over the first string
	lb $t0, ($s0) # Load larger string char
	beqz $t1, fail
	beq $t0, 10, fail # Larger string ended, test failed
	move $s3, $s0 # For inner loop 

	inner: # To move over the first/second strings
		lb $t0, ($s1) # Load smaller string char
		beqz $t0, pass
		beq $t0, 10, pass # Smaller string ended, test passed
		lb $t1, ($s3) # Load corresponding substring string char
		beqz $t1, fail
		beq $t1, 10, fail # Larger string ended, test failed
		bne $t0, $t1, next # Characters not equal
		addi $s1, $s1, 1 # Increment smaller string
		addi $s3, $s3, 1 # Increment substring
		b inner

	next: # If smaller string does not match with a substring
	lw $s1, 4($sp)
	# Increment larger string and substring index
	addi $s0, $s0, 1
	addi $s2, $s2, 1 
	b outer
		
fail: # Matching substring not found
li $t0, -1 # Return -1
sw $t0, 8($sp)
jr $ra

pass: # Substring found, returning its starting index
sw $s2, 8($sp) # Return index of substring
jr $ra


# -- Compare strings --
# Arguments - 2 strings
# Compares strings char-by-char (similar to C-strcmp).
# Returns integer > 0 if first non-equal character is greater in string 1 than string 2.
# Returns 0 if string 1 and string 2 are the same.
# Returns integer < 0 if first non-equal character is greater in string 2 than string 1.
strcmp:
# Loading strings from call stack
lw $s0, 0($sp)
lw $s1, 4($sp)

# Loading bytes from each string to compare.
cmploop:
	lb $t0, ($s0)
	lb $t1, ($s1)
	beqz $t0, diff # If sirst string reaches null first
	beqz $t1, diff # If second string reaches null first
	bne $t0, $t1, diff # First time different characters occur
	addi $s0, $s0, 1
	addi $s1, $s1, 1
	b cmploop

diff:
sub $t0, $t0, $t1 # Register the difference between characters
sw $t0, 8($sp) # Store it
jr $ra


# -- Slice string --
# Arguments - 1 string, 1 empty string, 1 starting index, 1 ending index
# Extracts substring from argument string, starting from element at 
# (arguments) starting index to ending index entered (not including character at ending index).
# Inserts extracted string to empty string whose address is given as an argument.
strslice:
# Loading arguments and address to modify
lw $s0, 0($sp)
lw $s1, 0($sp)
lw $s2, 4($sp)
lw $s3, 8($sp)
lw $s4, 12($sp)
# Loading input indices.
lw $t0, ($s2)
lw $t1, ($s3)

# Initial offset (To begin and end extraction of substring)
add $s0, $s0, $t0
add $s1, $s1, $t1

slice_loop:
	lb $t0, ($s0)
	beqz $t0, slice_done # End if null reached
	beq $t0, 10, slice_done # End if EOL reached
	beq $s0, $s1, slice_done # End if fetch addresses become equal
	sb $t0, ($s4) # Store character if both conditions skipped
	# Increment fetch and store addresses
	addi $s4, $s4, 1
	addi $s0, $s0, 1
	b slice_loop

slice_done:
jr $ra


# -- Copy string --
# Arguments - 1 string, 1 empty string
# Copies string to provided empty address.
strcpy:
# Loading arguments
lw $s0, 0($sp)
lw $s1, 4($sp)

copy_loop:
	lb $t0, ($s0) # Loading byte to copy
	beqz $t0, copy_done 
	beq $t0, 10, copy_done # End of string reached
	sb $t0, ($s1) # Store
	addi $s0, $s0, 1
	addi $s1, $s1, 1 # Increment addresses
	b copy_loop

copy_done:
jr $ra


# -- Reverse string --
# Arguments - 1 string, 1 empty string
# Reverses given string.
# Inserts reversed string to empty string whose address is given as an argument.
strrev:
# Loading arguments
lw $s0, 0($sp)
lw $s1, 0($sp)
lw $s2, 4($sp)
lw $t1, 0($sp)

# Loop to move pointer to end of the first string
rev_loop:
	lb $t0, ($s0) # Loading byte to copy
	beqz $t0, set_pointer
	beq $t0, 10, set_pointer # Checking for end of string
	addi $s0, $s0, 1
	addi $t1, $t1, 1 # Incrementing addresses
	b rev_loop

# Move pointer one back ready to load
set_pointer:
addi $s0, $s0, -1
	
# To copy elements into address in reverse order
input_loop:
	lb $t0, ($s0) 
	sb $t0, ($s2) # Storing character in reverse order
	addi $s2, $s2, 1 # Incrementing output address
	beq $s0, $s1, rev_done # Checking if reached first element in first string
	addi $s0, $s0, -1 # Decrementing input string
	b input_loop
	
# Reverse done
rev_done:
lb $t0, ($t1)
beq $t0, 10, add_eol # To add EOL to reversed string if it was in the first
jr $ra

# Add EOL
add_eol:
li $t0, 10
sb $t0, ($s2)
jr $ra

# -- Convert lowercase characters to uppercase in string --
# Arguments - 1 string, 1 empty string
# Replaces all lowercase alphabets in string to uppercase.
# Inserts resuting string to empty string whose address is given as an argument.
toupper:
# Load addresses of strings
lw $s0, 0($sp)
lw $s1, 4($sp)

upper_loop:
	lb $t0, ($s0) # Load byte to check
	beqz $t0, finish_upper # Null check
	beq $t0, 10, finish_upper # EOL check
	bgt $t0, 122, insert_char 
	blt $t0, 97, insert_char # Checking ASCII range of (a-z)
	# Skip if non alphabetic or uppercase
	subi $t0, $t0, 32 # For inserting uppercase alphabet
	insert_char:
	sb $t0, ($s1) # Load byte into empty string
	addi $s0, $s0, 1
	addi $s1, $s1, 1 # Increment addresses
	b upper_loop

finish_upper:
jr $ra


# -- Convert uppercase characters to lowercase in string --
# Arguments - 1 string, 1 empty string
# Replaces all uppercase alphabets in string to lowercase.
# Inserts resuting string to empty string whose address is given as an argument.
tolower:
# Load addresses of strings
lw $s0, 0($sp)
lw $s1, 4($sp)

lower_loop:
	lb $t0, ($s0) # Load byte to check
	beqz $t0, finish_lower # Null check
	beq $t0, 10, finish_lower # EOL check
	bgt $t0, 90, insert_char2
	blt $t0, 65, insert_char2 # Checking ASCII range of (A-Z)
	# Skip if non alphabetic or lowercase
	addi $t0, $t0, 32 # For inserting lowercase alphabet
	insert_char2:
	sb $t0, ($s1) # Load byte into empty string
	addi $s0, $s0, 1
	addi $s1, $s1, 1 # Increment addresses
	b lower_loop

finish_lower:
jr $ra


# -- Strip left whitespaces --
# Arguments - 1 string, 1 empty string
# Inserts left-stripped string into empty string
lstrip:
# Load addresses of strings
lw $s0, 0($sp)
lw $s1, 4($sp)
li $t1, 0

lstrip_loop:
	lb $t0, ($s0) # Load byte for checking
	beqz $t0, end_lstrip_loop # Check for null
	bnez $t1, mode2 # Check loop switcher, 
	mode1:
	bne $t0, 32, change_mode # On occurence of first non-space character, change loop mode
	addi $s0, $s0, 1 # Skip if space
	b lstrip_loop
	change_mode:
	li $t1, 1 # Change loop switcher to 1
	mode2:
	sb $t0, ($s1) # Load non-leftspace characters
	addi $s0, $s0, 1
	addi $s1, $s1, 1 # Increment addresses
	b lstrip_loop

end_lstrip_loop:
jr $ra


# -- Strip right whitespaces --
# Arguments - 1 string, 1 empty string
# Removes right sided whitespaces
# Inserts right-stripped string into empty string
rstrip:
# Load address of string
lw $s0, 0($sp)

# Function call -- reverse string
addiu $sp, $sp, -12
sw $s0, 0($sp) # Argument string
la $a0, local_rstrip
sw $a0, 4($sp) # Address for reverse storage
sw $ra, 8($sp)
jal strrev
lw $ra, 8($sp)
addiu $sp, $sp, 12

# Function call -- lstrip reversed string
addiu $sp, $sp, -12
la $a0, local_rstrip
sw $a0, 0($sp) # Argument string
la $a0, local_rstrip2
sw $a0, 4($sp) # Address for reversed lstrip
sw $ra, 8($sp)
jal lstrip
lw $ra, 8($sp)
addiu $sp, $sp, 12

lw $s1, 4($sp)
# Function call -- reverse lstripped string
addiu $sp, $sp, -12
la $a0, local_rstrip2
sw $a0, 0($sp) # Argument string
sw $s1, 4($sp) # Address for reverse storage
sw $ra, 8($sp)
jal strrev
lw $ra, 8($sp)
addiu $sp, $sp, 12

jr $ra


# -- Strip all whitespaces --
# Arguments - 1 string, 1 empty string
# Inserts stripped string into empty string
# Uses both lstrip and rstrip
strip:
lw $s0, 0($sp)

# Function call -- lstrip string
addiu $sp, $sp, -12
sw $s0, 0($sp) # Argument string
la $a0, local_strip
sw $a0, 4($sp) # Address for lstripped
sw $ra, 8($sp)
jal lstrip
lw $ra, 8($sp)
addiu $sp, $sp, 12

lw $s1, 4($sp)
# Function call -- rstrip string
addiu $sp, $sp, -12
la $a0, local_strip
sw $a0, 0($sp) # Argument string
sw $s1, 4($sp) # Address for stripped
sw $ra, 8($sp)
jal rstrip
lw $ra, 8($sp)
addiu $sp, $sp, 12

jr $ra


# -- Empty string --
# Arguments - 1 string
# Resets all bytes in a string
empty:
lw $s0, 0($sp)

empty_loop:
	lb $t0, ($s0)
	beqz $t0, end_empty_loop
	sb $zero, ($s0)
	addi $s0, $s0, 1
	b empty_loop
end_empty_loop:
jr $ra
