.text

# scanf n
li $v0, 5
syscall
move $a0, $v0
jal fib
move $a0, $v0
li $v0, 1
syscall
jal exit

fib:
bnez $a0, fib_nez
move $v0, $zero
jr $ra
fib_nez:
bne $a0, 1, fib_nez_ne1
li $v0, 1
jr $ra
fib_nez_ne1:
addi $sp, $sp, -12
sw $a0, 0($sp)
sw $ra, 4($sp)
sw $a1, 8($sp)
subi $a0, $a0, 1
jal fib
move $a1, $v0
subi $a0, $a0, 1
jal fib
add $v0, $v0, $a1
lw $a0, 0($sp)
lw $ra, 4($sp)
lw $a1, 8($sp)
addi $sp, $sp, 12
jr $ra

exit: