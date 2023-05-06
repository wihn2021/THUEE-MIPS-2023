.data
filename: .asciiz "test.dat"
.align 4
buffer:   .space  4100
##### You may add more code HERE if necessary #####
.align 4
dist:	.space	128
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

# Call Bellman-Ford
jal  bellman_ford

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

bellman_ford:
##### YOUR CODE HERE #####
la $t9, dist
sw $zero, ($t9)

li $t8, 1
li $t0, -1
for0:
bge $t8, $a0, for0_after

sll $t7, $t8, 2
add $t6, $t9, $t7
sw $t0, ($t6)

addi $t8, $t8, 1
j for0
for0_after:

li $t8, 1
for1:
bge $t8, $a0, for1_after # i

move $t7, $zero
for2:
bge $t7, $a0, for2_after # u

move $t6, $zero
for3:
bge $t6, $a0, for3_after # v

sll $t0, $t7, 5
add $t0, $t0, $t6 # $t0 is addr
sll $t0, $t0, 2
add $t0, $t0, $a1 # graph + addr
lw $t5, ($t0) # graph[addr]

sll $t1, $t7, 2
add $t1, $t1, $t9 
lw $t1, ($t1) # dist[u]

beq $t1, -1, for3_continue
beq $t5, -1, for3_continue

sll $t2, $t6, 2
add $t2, $t2, $t9 # dist + v
lw $t3, ($t2) # dist[v]

add $t4, $t1, $t5 # dist[u] + graph[addr]
beq $t3, -1, update_dist_v
bgt $t3, $t4, update_dist_v

j for3_continue

update_dist_v:
sw $t4, ($t2)

for3_continue:
addi $t6, $t6, 1
j for3
for3_after:
addi $t7, $t7, 1
j for2
for2_after:
addi $t8, $t8, 1
j for1
for1_after:

jr $ra

