.extern local 4


display_game_state:
    addi $sp, $sp, -32
    sw $ra, 28($sp)
    sw $s0, 24($sp)
    sw $s1, 20($sp)
    sw $s2, 16($sp)
    sw $s3, 12($sp)
    sw $s4, 8($sp)
    sw $s5, 4($sp)
    sw $s6, 0($sp)

    la $s0, grid1
    la $s1, matched_arr
    li $s2, 0
    li $s3, 4

    # Show header if needed
    lw $t0, show_header
    beqz $t0, grid_display

    li $v0, 4
    la $a0, brain_art
    syscall
    la $a0, brain_title
    syscall
    la $a0, display_cards
    syscall
    
    sw $zero, show_header

grid_display:
    div $s2, $s3
    mfhi $t0
    bnez $t0, skip_newline

    li $v0, 4
    la $a0, newline
    syscall
    la $a0, divider
    syscall

skip_newline:
    li $v0, 4
    la $a0, card_separator
    syscall

    sll $t0, $s2, 2
    add $t1, $s1, $t0
    lw $t2, ($t1)

    beqz $t2, print_hidden

    add $t1, $s0, $t0
    lw $t2, ($t1)
    li $v0, 4
    move $a0, $t2
    syscall
    j after_print

print_hidden:
    li $v0, 4
    la $a0, hidden_card
    syscall

after_print:
    addi $s2, $s2, 1
    li $t0, 16
    bne $s2, $t0, grid_display

    # Show game status
    li $v0, 4
    la $a0, newline
    syscall
    la $a0, divider
    syscall
    la $a0, pairs_msg
    syscall

    li $v0, 1
    lw $a0, pairs_remaining
    syscall

    li $v0, 4
    la $a0, newline
    syscall
    la $a0, score_msg
    syscall

    li $v0, 1
    lw $a0, score
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    lw $s6, 0($sp)
    lw $s5, 4($sp)
    lw $s4, 8($sp)
    lw $s3, 12($sp)
    lw $s2, 16($sp)
    lw $s1, 20($sp)
    lw $s0, 24($sp)
    lw $ra, 28($sp)
    addi $sp, $sp, 32
    jr $ra
    
display_final_results:
    addi $sp, $sp, -24
    sw $ra, 20($sp)
    sw $s0, 16($sp)
    sw $s1, 12($sp)
    sw $s2, 8($sp)
    sw $s3, 4($sp)
    sw $s4, 0($sp)

    li $v0, 30
    syscall
    
    lw $s3, start_time_low
    lw $s4, start_time_high
    subu $s0, $a0, $s3
    
    div $s0, $s0, 1000
    
    li $t0, 60
    div $s0, $t0
    mflo $s1
    mfhi $s2

    li $v0, 4
    la $a0, game_over
    syscall
    la $a0, divider
    syscall
    la $a0, score_msg
    syscall
    
    li $v0, 1
    lw $a0, score
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    la $a0, newline
    syscall
    la $a0, time_msg
    syscall

    li $v0, 1
    move $a0, $s1
    bge $s1, 10, print_minutes
    li $v0, 4
    la $a0, zero
    syscall
    li $v0, 1
    move $a0, $s1

print_minutes:
    syscall
    li $v0, 4
    la $a0, colon
    syscall

    li $v0, 1
    move $a0, $s2
    bge $s2, 10, print_seconds
    li $v0, 4
    la $a0, zero
    syscall
    li $v0, 1
    move $a0, $s2

print_seconds:
    syscall
    li $v0, 4
    la $a0, newline
    syscall

    lw $s4, 0($sp)
    lw $s3, 4($sp)
    lw $s2, 8($sp)
    lw $s1, 12($sp)
    lw $s0, 16($sp)
    lw $ra, 20($sp)
    addi $sp, $sp, 24
    jr $ra



