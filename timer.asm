.extern local 4



# Function to calculate the move time
calculate_move_time:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    li $v0, 30
    syscall
    
    lw $t0, move_start_time_low
    subu $t1, $a0, $t0
    
    li $t2, 1000
    div $t1, $t2
    mflo $t1
    
    li $t2, 60
    div $t1, $t2
    mflo $t3
    mfhi $t4
    
    li $v0, 4
    la $a0, move_time_msg
    syscall
    
    la $a0, time_zero
    syscall
    li $v0, 1
    move $a0, $t3
    syscall
    
    li $v0, 4
    la $a0, time_format
    syscall
    
    la $a0, time_zero
    syscall

    # Check if the game is over
check_game_over:
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $s0, 0($sp)

    lw $s0, pairs_remaining
    beqz $s0, game_is_over  # If pairs_remaining is 0, the game is over
    li $v0, 0               # Game is not over
    j check_done

game_is_over:
    li $v0, 1  # Game is over

check_done:
    lw $s0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra

