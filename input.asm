.extern local 4


# Handle player moves
get_player_move:
    addi $sp, $sp, -28
    sw $ra, 24($sp)
    sw $s0, 20($sp)
    sw $s1, 16($sp)
    sw $s2, 12($sp)
    sw $s3, 8($sp)
    sw $s4, 4($sp)
    sw $s5, 0($sp)

    la $s2, grid1
    la $s3, matched_arr
    
    li $v0, 30
    syscall
    sw $a0, move_start_time_low

get_first_card:
    li $v0, 4
    la $a0, prompt1
    syscall

    li $v0, 8           # Read string input
    la $a0, buffer
    li $a1, 100
    syscall

    # Validate input is a number
    la $t0, buffer      # Load buffer address
validate_first:
    lb $t1, ($t0)      # Load character
    beq $t1, 10, invalid_char_error  # Newline
    beq $t1, 0, invalid_char_error   # Null
    blt $t1, '0', invalid_char_error # Not a number
    bgt $t1, '9', invalid_char_error

    # Convert to number
    addi $t1, $t1, -48  # ASCII to number
    move $s0, $t1
    
    # Check second character
    addi $t0, $t0, 1
    lb $t1, ($t0)
    beq $t1, 10, check_first_value  # Single digit
    beq $t1, 0, check_first_value
    blt $t1, '0', invalid_char_error
    bgt $t1, '9', invalid_char_error
    
    # Process second digit
    addi $t1, $t1, -48
    mul $s0, $s0, 10
    add $s0, $s0, $t1

check_first_value:
    li $t0, 1
    li $t1, 16
    blt $s0, $t0, invalid_input1
    bgt $s0, $t1, invalid_input1

    # Process valid input
    addi $s0, $s0, -1
    sll $t0, $s0, 2
    add $t0, $s3, $t0
    lw $t1, ($t0)
    bnez $t1, already_matched1

    li $t1, 2
    sw $t1, ($t0)
    jal display_game_state

get_second_card:
    li $v0, 4
    la $a0, prompt2
    syscall

    li $v0, 8
    la $a0, buffer
    li $a1, 100
    syscall

validate_second:
    la $t0, buffer
    lb $t1, ($t0)
    beq $t1, 10, invalid_char_error2
    beq $t1, 0, invalid_char_error2
    blt $t1, '0', invalid_char_error2
    bgt $t1, '9', invalid_char_error2

    addi $t1, $t1, -48
    move $s1, $t1
    
    addi $t0, $t0, 1
    lb $t1, ($t0)
    beq $t1, 10, check_second_value
    beq $t1, 0, check_second_value
    blt $t1, '0', invalid_char_error2
    bgt $t1, '9', invalid_char_error2
    
    addi $t1, $t1, -48
    mul $s1, $s1, 10
    add $s1, $s1, $t1

check_second_value:
    li $t0, 1
    li $t1, 16
    blt $s1, $t0, invalid_input2
    bgt $s1, $t1, invalid_input2

    addi $s1, $s1, -1
    beq $s1, $s0, same_card_error

    sll $t0, $s1, 2
    add $t0, $s3, $t0
    lw $t1, ($t0)
    bnez $t1, already_matched2

    # Compare cards
    sll $t0, $s0, 2
    sll $t1, $s1, 2
    add $t0, $s2, $t0
    add $t1, $s2, $t1
    lw $s4, ($t0)
    lw $s5, ($t1)

    sll $t0, $s1, 2
    add $t0, $s3, $t0
    li $t1, 2
    sw $t1, ($t0)
    
    jal display_game_state

    move $a0, $s4
    move $a1, $s5
    jal compare_strings
    
    beqz $v0, no_match_found

    # Handle match found
    sll $t0, $s0, 2
    sll $t1, $s1, 2
    add $t0, $s3, $t0
    add $t1, $s3, $t1
    li $t2, 1
    sw $t2, ($t0)
    sw $t2, ($t1)

    # Success effects
    lw $a0, success_pitch
    lw $a1, success_duration
    lw $a2, success_instrument
    lw $a3, success_volume
    jal play_sound

    # Update game state
    lw $t0, matches_found
    addi $t0, $t0, 1
    sw $t0, matches_found

    lw $t0, score
    addi $t0, $t0, 10
    sw $t0, score

    lw $t0, pairs_remaining
    addi $t0, $t0, -1
    sw $t0, pairs_remaining

    li $t1, 4
    bne $t0, $t1, skip_halfway
    

    syscall

skip_halfway:
    li $v0, 4
    la $a0, match_found
    syscall
    jal calculate_move_time
    j move_complete

# Error handlers
invalid_char_error:
    li $v0, 4
    la $a0, invalid_char
    syscall
    j get_first_card

invalid_char_error2:
    li $v0, 4
    la $a0, invalid_char
    syscall
    j get_second_card

invalid_input1:
    li $v0, 4
    la $a0, invalid_input
    syscall
    j get_first_card

invalid_input2:
    sll $t0, $s0, 2
    add $t0, $s3, $t0
    sw $zero, ($t0)
    li $v0, 4
    la $a0, invalid_input
    syscall
    j get_second_card

already_matched1:
    li $v0, 4
    la $a0, already_matched
    syscall
    j get_first_card

already_matched2:
    sll $t0, $s0, 2
    add $t0, $s3, $t0
    sw $zero, ($t0)
    li $v0, 4
    la $a0, already_matched
    syscall
    j get_second_card

same_card_error:
    sll $t0, $s0, 2
    add $t0, $s3, $t0
    sw $zero, ($t0)
    li $v0, 4
    la $a0, same_card
    syscall
    j get_second_card

no_match_found:
    addi $sp, $sp, -8
    sw $v0, 4($sp)
    sw $ra, 0($sp)
    
    # Hide cards
    sll $t0, $s0, 2
    add $t0, $s3, $t0
    sw $zero, ($t0)
    sll $t0, $s1, 2
    add $t0, $s3, $t0
    sw $zero, ($t0)
   
    # Show random message
    li $v0, 42
    li $a0, 0
    li $a1, 4
    syscall
    
    sll $t0, $a0, 2
    la $t1, no_match_msgs
    add $t1, $t1, $t0
    lw $a0, ($t1)
    li $v0, 4
    syscall
    
    la $a0, no_match
    syscall
    
    # Play failure sound
    lw $a0, failure_pitch
    lw $a1, failure_duration
    lw $a2, failure_instrument
    lw $a3, failure_volume
    jal play_sound
    
    lw $ra, 0($sp)
    lw $v0, 4($sp)
    addi $sp, $sp, 8
    
    jal calculate_move_time
    j move_complete

move_complete:
    jal display_game_state

    lw $s5, 0($sp)
    lw $s4, 4($sp)
    lw $s3, 8($sp)
    lw $s2, 12($sp)
    lw $s1, 16($sp)
    lw $s0, 20($sp)
    lw $ra, 24($sp)
    addi $sp, $sp, 28
    jr $ra