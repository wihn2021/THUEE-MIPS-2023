.text
# i -> $s0, j -> $s1, temp -> $s2

#  scanf("%d", &i); scanf("%d", &j);
li $v0, 5
syscall
move $s0, $v0

li $v0, 5
syscall
move $s1, $v0

# i = -i;
subu $s0, $zero, $s0

# if(j < 0) j = -j;
bge $s1, $zero, after_minus_j
subu $s1, $zero, $s1
after_minus_j:

# for(temp = 0; temp < j; ++temp) i += 1;
move $s2, $zero
for1:
bge $s2, $s1, after_for
addiu $s0, $s0, 1
addiu $s2, $s2, 1
j for1
after_for:

# printf("%d",i);
move $a0, $s0
li $v0, 1
syscall

move $v0, $s0
