# Arsh Parmar
# jk2680
# Functions

.data
linebreak: .ascii "\n"

.text
.globl strlen, merge

# Function 1: String length
strlen:
lw $s0, 0($sp)
li $s1, 0
# Loading in newline character
la $t0, linebreak
lb $t0, 0($t0)
# Counting loop
len_loop:
	# Loading char
	lb $s2, 0($s0)
	# Testing for null or newline
	beq $s2, $zero, end_loop
	beq $s2, $t0, end_loop
	
	# Increasing char counter array pointer
	addi $s1, $s1, 1
	addi $s0, $s0, 1
	
	b len_loop

end_loop:
# Store length
sw $s1, 4($sp)
# Reset temps
move $s0, $zero
move $s1, $zero
move $s2, $zero
move $t0, $zero
jr $ra

# Function 2: Merge sorted arrays
merge:
lw $s0, 0($sp) # First array
lw $s1, 4($sp) # Second array
lw $s2, 8($sp) # Merged array
lw $s3, 12($sp) # Storing length
lw $s4, 12($sp)
lw $t0, 12($sp) # Sub-Counter
add $t1, $t0, $t0 # Main counter
merge_loop:
	# Border case test
	beqz $t1, end_loop2
	beqz $s3, finish_first
	beqz $s4, finish_second
	# Loading array elements
	lw $t2, 0($s0)
	lw $t3, 0($s1)
	# Main comparison
	bge $t2, $t3, second
	# First array element lesser
	sw $t2, 0($s2)
	# Increasing array1 pointer
	addi $s2, $s2, 4
	addi $s0, $s0, 4
	# Decreasing counters
	addi $t1, $t1, -1
	addi $s3, $s3, -1
	
	b merge_loop
	
	second:
	# First array element lesser
	sw $t3, 0($s2)
	# Increasing array2 pointer
	addi $s2, $s2, 4
	addi $s1, $s1, 4
	# Decreasing counters
	addi $t1, $t1, -1
	addi $s4, $s4, -1
	b merge_loop
	
	# First array exhausted
	finish_first:
	lw $t3, 0($s1)
	sw $t3, 0($s2)
	addi $s2, $s2, 4
	addi $s1, $s1, 4
	addi $t1, $t1, -1
	b merge_loop
	
	# Second array exhausted
	finish_second:
	lw $t2, 0($s0)
	sw $t2, 0($s2)
	addi $s2, $s2, 4
	addi $s0, $s0, 4
	addi $t1, $t1, -1
	b merge_loop
	
end_loop2:
# Reset temps
move $s0, $zero
move $s1, $zero
move $s2, $zero
move $s3, $zero
move $s4, $zero
move $t0, $zero
move $t1, $zero
move $t2, $zero
move $t3, $zero
jr $ra
