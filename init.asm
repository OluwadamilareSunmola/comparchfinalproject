.extern local 4


init_game:
    addi $sp, $sp, -20
    sw $ra, 16($sp)
    sw $s0, 12($sp)
    sw $s1, 8($sp)
    sw $s2, 4($sp)
    sw $s3, 0($sp)
    
    # Get start time
    li $v0, 30
    syscall
    sw $a0, start_time_low
    sw $a1, start_time_high

    # Reset game state
    li $t0, 1
    sw $t0, show_header
    li $t0, 8
    sw $t0, pairs_remaining
    sw $zero, score
    sw $zero, matches_found

    # Initialize matched array
    la $s0, matched_arr
    la $s1, grid1
    li $s2, 16
    li $s3, 0

init_matched_loop:
    add $t0, $s0, $s3
    sw $zero, ($t0)
    addi $s3, $s3, 4
    addi $s2, $s2, -1
    bnez $s2, init_matched_loop

    # Set up card values
    la $t0, val1
    sw $t0, 0($s1)
    la $t0, val2
    sw $t0, 4($s1)
    la $t0, val3
    sw $t0, 8($s1)
    la $t0, val4
    sw $t0, 12($s1)
    la $t0, val5
    sw $t0, 16($s1)
    la $t0, val6
    sw $t0, 20($s1)
    la $t0, val7
    sw $t0, 24($s1)
    la $t0, val8
    sw $t0, 28($s1)
    la $t0, val9
    sw $t0, 32($s1)
    la $t0, val10
    sw $t0, 36($s1)
    la $t0, val11
    sw $t0, 40($s1)
    la $t0, val12
    sw $t0, 44($s1)
    la $t0, val13
    sw $t0, 48($s1)
    la $t0, val14
    sw $t0, 52($s1)
    la $t0, val15
    sw $t0, 56($s1)
    la $t0, val16
    sw $t0, 60($s1)

    jal shuffle_grid

    lw $s3, 0($sp)
    lw $s2, 4($sp)
    lw $s1, 8($sp)
    lw $s0, 12($sp)
    lw $ra, 16($sp)
    addi $sp, $sp, 20
    jr $ra

shuffle_grid:
    addi $sp, $sp, -28
    sw $ra, 24($sp)
    sw $s0, 20($sp)
    sw $s1, 16($sp)
    sw $s2, 12($sp)
    sw $s3, 8($sp)
    sw $s4, 4($sp)
    sw $s5, 0($sp)

    la $s0, grid1
    li $s1, 15

shuffle_loop:
    bltz $s1, shuffle_done

    li $v0, 42
    li $a0, 0
    addi $a1, $s1, 1
    syscall
    move $s3, $a0

    sll $t0, $s1, 2
    sll $t1, $s3, 2
    add $t0, $s0, $t0
    add $t1, $s0, $t1

    lw $s4, ($t0)
    lw $s5, ($t1)
    sw $s5, ($t0)
    sw $s4, ($t1)

    addi $s1, $s1, -1
    j shuffle_loop

shuffle_done:
    lw $s5, 0($sp)
    lw $s4, 4($sp)
    lw $s3, 8($sp)
    lw $s2, 12($sp)
    lw $s1, 16($sp)
    lw $s0, 20($sp)
    lw $ra, 24($sp)
    addi $sp, $sp, 28
    jr $ra
