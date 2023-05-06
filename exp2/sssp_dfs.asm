.data
filename: .asciiz "test.dat"
.align 4
buffer:   .space  4100
##### You may add more code HERE if necessary #####
dist:	.space	128
visited:	.space	128
.text
main:
# Open file
la   $a0, filename  # load filename
li   $a1, 0         # flag
li   $a2, 0         # mode
li   $v0, 13        # open file syscall index
syscall

# Read file
move $a0, $v0       # load file description to $a0
la   $a1, buffer    # buffer address
li   $a2, 4100      # buffer size
li   $v0, 14        # read file syscall index
syscall

# Close file
li   $v0, 16        # close file syscall index
syscall

# Parameters
la   $t0, buffer
lw   $s0, 0($t0)    # set $s0 to n
move $a0, $s0       # set $a0 to n
addi $a1, $t0, 4    # set $a1 to &graph

# Call DFS
jal  dfs_sssp

# Print results
li   $t0, 1
la   $t1, dist
print_entry:
addi $t1, $t1, 4
lw   $a0, 0($t1)
li   $v0, 1         # print int syscall index
syscall
li   $a0, ' '
li   $v0, 11        # print char syscall index
syscall
addi $t0, $t0, 1
blt  $t0, $s0, print_entry

# Return 0
li   $a0, 0
li   $v0, 17
syscall

dfs_sssp:
##### YOUR CODE HERE #####

# save reg
addi $sp, $sp, -4
sw $ra, ($sp)
# end save reg
la $t0, dist
la $t1, visited
sw $zero, ($t0)
sw $zero, ($t1)

li $t2, 1
for0:
bge $t2, $a0, for0_after

sll $t3, $t2, 2
add $t4, $t0, $t3
add $t5, $t1, $t3
li $t6, -1
sw $t6, ($t4)
sw $zero, ($t5)

addi $t2, $t2, 1
j for0
for0_after:

li $a2, 0
li $a3, 0
jal dfs

lw $ra, ($sp)
addi $sp, $sp, 4

jr $ra

dfs:

addi $sp, $sp, -16
sw $a2, ($sp)
sw $a3, 4($sp)
sw $s3, 8($sp)
sw $ra, 12($sp)

la $t4, dist
la $t9, visited

sll $t8, $a2, 2 # u * 4
addu $t2, $t8, $t9 # visited[u]
li $t0, 1
sw $t0, ($t2)

addu $t7, $t8, $t4 # dist[u]
lw $t1, ($t7)

beq $t1, -1, l53
bgt $t1, $a3, l53
j l54
l53:
sw $a3, ($t7)
l54:

move $s3, $zero
for:
bge $s3, $a0, after_for # $s4 -> v

sll $t6, $s3, 2 # $t6 = 4 * v
addu $t5, $t6, $t9
lw $t5, ($t5) # visited[v]
bnez $t5, continue

sll $t5, $a2, 7
addu $t5, $t6, $t5
addu $t5, $t5, $a1
lw $t5, ($t5)
beq $t5, -1, continue

move $a2, $s3
addu $a3, $a3, $t5
jal dfs
lw $a2, ($sp)
lw $a3, 4($sp)
continue:
addu $s3, $s3, 1
j for
after_for:

sll $t8, $a2, 2 # u * 4
addu $t2, $t8, $t9 # visited[u]
sw $zero, ($t2)

lw $a2, ($sp)
lw $a3, 4($sp)
lw $s3, 8($sp)
lw $ra, 12($sp)

addi $sp, $sp, 16

jr $ra
