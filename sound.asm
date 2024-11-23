.extern local 4



play_sound:
    addi $sp, $sp, -16
    sw $ra, 12($sp)
    sw $t0, 8($sp)
    sw $v0, 4($sp)
    sw $a0, 0($sp)
    
    move $a0, $a2
    li $v0, 35
    syscall
    
    lw $a0, 0($sp)
    li $v0, 31
    syscall
    
    move $t0, $a1
    li $v0, 32
    move $a0, $t0
    syscall
    
    lw $a0, 0($sp)
    lw $v0, 4($sp)
    lw $t0, 8($sp)
    lw $ra, 12($sp)
    addi $sp, $sp, 16
    jr $ra