.extern local 4


compare_strings:
    addi $sp, $sp, -20
    sw $ra, 16($sp)
    sw $s0, 12($sp)
    sw $s1, 8($sp)
    sw $s2, 4($sp)
    sw $s3, 0($sp)

    move $s0, $a0
    move $s1, $a1

    move $a0, $s0
    jal string_to_value
    move $s2, $v0

    move $a0, $s1
    jal string_to_value
    move $s3, $v0

    seq $v0, $s2, $s3

    lw $s3, 0($sp)
    lw $s2, 4($sp)
    lw $s1, 8($sp)
    lw $s0, 12($sp)
    lw $ra, 16($sp)
    addi $sp, $sp, 20
    jr $ra
    
string_to_value:
    addi $sp, $sp, -16
    sw $ra, 12($sp)
    sw $s0, 8($sp)
    sw $s1, 4($sp)
    sw $s2, 0($sp)

    move $s0, $a0
    li $s1, 0

    li $t2, 0
    move $t3, $s0
  
