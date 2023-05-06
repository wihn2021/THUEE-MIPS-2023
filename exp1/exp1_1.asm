.data 
input_file: .asciiz "a.in"
output_file: .asciiz "a.out"

.text 

# buffer = new int[2];  
li $a0, 8
li $v0, 9
syscall
move $s0, $v0

# infile = fopen("a.in", "rb");  
la $a0, input_file
li $a1, 0
li $a2, 0
li $v0, 13
syscall
move $s1, $v0

# fread(buffer, 4, 2, infile);  
move $a0, $s1
move $a1, $s0
li $a2, 8
li $v0, 14
syscall

# fclose(infile);  
move $a0, $s1
li $v0, 16
syscall

# outfile = fopen("a.out", "wb");  
la $a0, output_file
li $a1, 1
li $a2, 0
li $v0, 13
syscall
move $s1, $v0

# fwrite(buffer, 4, 2, outfile);  
move $a0, $s1
move $a1, $s0
li $a2, 8
li $v0, 15
syscall

# fclose(outfile);  
move $a0, $s1
li $v0, 16
syscall

# scanf("%d", &i);  
li $v0, 5
syscall
move $s1, $v0

# i = i + 10;
addiu $s1, $s1, 10

# printf("%d", i);  
move $a0, $s1
li $v0, 1
syscall

