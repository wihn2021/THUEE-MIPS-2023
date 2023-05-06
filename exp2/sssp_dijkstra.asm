.data
filename: .asciiz "test.dat"
.align 4
buffer:   .space  4100
##### You may add more code HERE if necessary #####
.align 4
dist:	.space	128
.align 4
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

# Call Dijkstra
jal  dijkstra

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

dijkstra:
##### YOUR CODE HERE #####

la $t9, dist
la $t8, visited
sw $zero, ($t9)
li $t0, 1
sw $t0, ($t8)
for1:
bge $t0, $a0, for1_after
sll $t1, $t0, 2
addu $t2, $t1, $t9 # dist + i
addu $t3, $t1, $a1 # graph + i
addu $t4, $t1, $t8 # visited + i
lw $t5, ($t3)
sw $t5, ($t2)
sw $zero, ($t4)
addiu $t0, $t0, 1
j for1
for1_after:
li $t0, 1
for2:
bge $t0, $a0, for2_after
li $t1, -1 # u = -1
li $t2, -1 # min_dist = -1
li $t3, 1 # v = 1
for3:
bge $t3, $a0, for3_after
sll $t4, $t3, 2
addu $t5, $t4, $t9
lw $t5, ($t5) # dist[v]
beq $t5, -1, for3_continue
addu $t6, $t4, $t8
lw $t6, ($t6) #visited[v]
bne $t6, 0, for3_continue
beq $t2, -1, update_min_dist
blt $t5, $t2, update_min_dist
j for3_continue
update_min_dist:
move $t2, $t5
move $t1, $t3
for3_continue:
addiu $t3, $t3, 1
j for3
for3_after:
beq $t2, -1, ret
# free: t3, t4, t5
sll $t3, $t1, 2
addu $t3, $t3, $t8
li $t4, 1
sw $t4, ($t3)
li $t3, 1
for4:
bge $t3, $a0, for4_after
sll $t4, $t3, 2
addu $t5, $t4, $t8
lw $t5, ($t5) # visited[v]
bnez $t5, for4_continue
sll $t5, $t1, 7
addu $t5, $t5, $t4 # addr * 4
addu $t5, $t5, $a1
lw $t5, ($t5) # graph[addr]
beq $t5, -1, for4_continue
addu $t7, $t9, $t4
lw $t6, ($t7) # dist[v]
addu $t5, $t5, $t2 # min_dist + graph[addr]
bgt $t6, $t5, update_dist_v
beq $t6, -1, update_dist_v
j for4_continue
update_dist_v:
sw $t5, ($t7)
for4_continue:
addiu $t3, $t3, 1
j for4
for4_after:
for2_continue:
addiu $t0, $t0, 1
j for2
for2_after:
ret:

jr $ra
