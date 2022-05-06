.data
message: .asciiz "Calling add64..... \n"
final: .asciiz "Called add64. \n\n"
overflow64: .asciiz "64 bits overflowed.\n"
no_overflow: .asciiz "64 bit addition completed without overflow.\n"

.text
main:
li $v0, 4
la $a0, message
syscall

# Test 1 - No Overflow
# Lower bits
li $t0, 4000000000
li $t2, 4000000000

# Upper bits
li $t1, 2000000000
li $t3, 2000000000

addiu $sp, $sp, -28
sw $t0, 0($sp)
sw $t1, 4($sp)
sw $t2, 8($sp)
sw $t3, 12($sp)
# Offset 16, 20 for returning 64 bit sum.
sw $ra, 24($sp)
jal add64
lw $ra, 24($sp)
lw $t4, 16($sp) # Return sum (lower word)
lw $t5, 20($sp) # Return sum (upper word)
addiu $sp, $sp, 28

li $v0, 4
la $a0, final
syscall

li $v0, 4
la $a0, message
syscall

# Test 2 - Overflow
# Lower bits
li $t0, 4000000000
li $t2, 4000000000

# Upper bits
li $t1, 4000000000
li $t3, 4000000000

addiu $sp, $sp, -28
sw $t0, 0($sp)
sw $t1, 4($sp)
sw $t2, 8($sp)
sw $t3, 12($sp)
# Offset 16, 20 for returning 64 bit sum.
sw $ra, 24($sp)
jal add64
lw $ra, 24($sp)
lw $t4, 16($sp) # Return sum (lower word)
lw $t5, 20($sp) # Return sum (upper word)
addiu $sp, $sp, 28

li $v0, 4
la $a0, final
syscall

li $v0, 10
syscall

add64:
lw $s0, 0($sp) # Lower of a1
lw $s1, 4($sp) # Upper of a1
lw $s2, 8($sp) # Lower of a2
lw $s3, 12($sp) # Upper of a2

addu $s4, $s0, $s2 # Added both lower words to sum lower word
sltu $s6, $s4, $s2 # Carried over bit from first 32-bit lower addition
addu $s5, $s5, $s6 # Adding carried bit
addu $s5, $s5, $s1
addu $s5, $s5, $s3 # Added both upper words to sum upper word

move $s7, $s5
subu $s7, $s7, $s6
sltu $s6, $s7, $s3

beqz $s6, return

li $v0, 4
la $a0, overflow64
syscall
jr $ra

return:
li $v0, 4
la $a0, no_overflow
syscall

sw $s4, 16($sp)
sw $s5, 20($sp)
jr $ra
