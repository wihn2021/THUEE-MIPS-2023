.text
# int *a, n, i, t;
# a -> $s0
# n -> $s1
# i -> $s2
# t -> $s3

li $v0, 5
syscall
move $s1, $v0

# 4*n new
mul $a0, $s1, 4
li $v0, 9
syscall
move $s0, $v0

move $s2, $zero
for1_judge:
bge $s2, $s1, for1_after
# generate 4i
sll $s4, $s2, 2
addu $s4, $s0, $s4
# $s4 is where a[i]
li $v0, 5
syscall
sw $v0, ($s4)
addu $s2, $s2, 1
j for1_judge
for1_after:

move $s2, $zero
srl $s5, $s1, 1
for2_judge:
bge $s2, $s5, for2_after
# generate 4i -> $s4
sll $s4, $s2, 2
# $s6 is a[i]
addu $s6, $s0, $s4
#generate n - i - 1 -> $s7
subu $s7, $s1, $s2
subu $s7, $s7, 1
sll $s7, $s7, 2
addu $s7, $s0, $s7

lw $s3, ($s6)
addu $s3, $s3, 1
lw $t8, ($s7)
addu $t8, $t8, 1

sw $s3, ($s7)
sw $t8, ($s6)

addu $s2, $s2, 1
j for2_judge
for2_after:

move $s2, $zero
for3_judge:
bge $s2, $s1, for3_after
# generate 4i
sll $s4, $s2, 2
addu $s4, $s0, $s4
# $s4 is where a[i]
lw $a0, ($s4)
li $v0, 1
syscall
li $a0, 32
li $v0, 11
syscall
addu $s2, $s2, 1
j for3_judge
for3_after:

