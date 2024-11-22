.data
    brain_art: .asciiz "                       _____\n                   .d88888888bo.\n                 .d8888888888888b.\n                 8888888888888888b\n                 888888888888888888\n                 888888888888888888\n                  Y8888888888888888\n            ,od888888888888888888P\n         .'`Y8P'```'Y8888888888P'\n       .'_   `  _     'Y88888888b\n      /  _`    _ `      Y88888888b   ____\n   _  | /  \\  /  \\      8888888888.d888888b.\n  d8b | | /|  | /|      8888888888d8888888888b\n 8888_\\ \\_|/  \\_|/      d888888888888888888888b\n .Y8P  `'-.            d88888888888888888888888\n/          `          `      `Y8888888888888888\n|                        __    888888888888888P\n \\                       / `   dPY8888888888P'\n  '._                  .'     .'  `Y888888P`\n     `\"'-.,__    ___.-'    .-'\n         `-._````  __..--'`\n                 ``````\n"
    brain_title: .asciiz "\n?????????????????????????????????????????????????\n?   ? Welcome to MATH MEMORY MASTER! ?       ?\n?      Test Your Memory & Math Skills!          ?\n?????????????????????????????????????????????????\n"
    display_cards: .asciiz "\n\n\n??????????? ;)Game Board ? ???????????\n?   Can you match all the pairs?           ?\n?   Remember: Numbers & Equations Match!    ?\n????????????????????????????????????????????\n"

    # Game state variables
    buffer: .space 100
    pairs_remaining: .word 8
    matched_arr: .word 0:16
    score: .word 0
    move_start_time_low: .word 0
    show_header: .word 1
    matches_found: .word 0
    
    invalid_char: .asciiz "\nPlease enter only numbers!\n"


    # Messages and UI elements
    move_time_msg: .asciiz "\n\nTime Elapsed Between Your Inputs:  "
    time_format: .asciiz ":"
    time_zero: .asciiz "0"
    restart_prompt: .asciiz "\n\n\n\nWould you like to play again? (1 for yes, 0 for no): "
    invalid_restart: .asciiz "\nPlease enter 0 or 1 only.\n"
    goodbye_msg: .asciiz "\n\nThanks for playing! Goodbye!\n"
    
    # Timer variables
    start_time_low: .word 0
    start_time_high: .word 0
    time_msg: .asciiz "Total Time elapsed: "
    colon: .asciiz ":"
    zero: .asciiz "0"
    
    # Display elements
    divider: .asciiz "\n----------------------------------------\n"
    newline: .asciiz "\n"
    card_separator: .asciiz " | "
    hidden_card: .asciiz "*    "
    
    # Card display frames
    card_top: .asciiz "???????\n"
    card_bottom: .asciiz "???????\n"
    

    
    no_match_msg1: .asciiz "\n    ¯\\_(?)_/¯ Try Again!\n"
    no_match_msg2: .asciiz "\n    (•_•) Not Quite...\n"
    no_match_msg3: .asciiz "\n    (???) Almost...\n"
    no_match_msg4: .asciiz "\n    (._.) Keep Going!\n"

    # Game messages
    prompt1: .asciiz "\nSelect first card (1-16): "
    prompt2: .asciiz "\nSelect second card (1-16): "
    match_found: .asciiz "\nMatch found! +10 points\n\n\\(^o^)// Fantastic!\n"
    no_match: .asciiz "\nNo match. Try again!\n"
    invalid_input: .asciiz "\nPlease enter a number between 1 and 16\n"
    already_matched: .asciiz "\nThis card is already matched! Try another.\n"
    same_card: .asciiz "\nCannot select the same card! Try again.\n"
    pairs_msg: .asciiz "\nPairs remaining: "
    score_msg: .asciiz "Score: "
    game_over: .asciiz "\nCongratulations! You've found all pairs!\n\n      .;*;;.\n.;;*;;'' '*;.\n          .;'\n          '*.\n          .;*'\n     *.---';:.-----..* \n   / .-```  *;.``--..  \\ \n   \\ '._   .;*'    _.' / \n    '-._``--.._.--'_.-'| \n    |   ``--------'   .| \n    |   .'______    .' | \n    | .' |_    _| .'   | \n    |'    .'_  '.'    .| \n    |   .|.' '._|   .' | \n    | .' /`-.'    .'   | \n    |'   _'. \\  .'    .| \n    |   .\\--'.'    .' | \n    | .'  _______ .'   | \n    |'   |       |    .| \n    |   .| o v.o |  .' | \n    | .' '..'''..'.'   | \n    |'    .---. .'    .| \n    |   .( ( ).)    .' | \n    | .'  '---'   .'   | \n    |'    .---. .'    .| \n    |   .( ( ) )    .' | \n    | .'  '---'   .'   | \n    |'    _______'    .| \n    |   .`---. _.`  .' | \n    | .'  __< _>. .'   | \n    |'   `-------`     | LGB \n    '---...______...---'"
    


    # Card values
    val1: .asciiz "2x3  "
    val9: .asciiz "6    "
    val2: .asciiz "4x2  "
    val10: .asciiz "8    "
    val3: .asciiz "3x3  "
    val7: .asciiz "9    "
    val4: .asciiz "200  "
    val6: .asciiz "200   "
    val5: .asciiz "5x3  "
    val11: .asciiz "15   "
    val8: .asciiz "9x10  "
    val14: .asciiz "90   "
    val13: .asciiz "4x5  "
    val15: .asciiz "20   "
    val12: .asciiz "25  "
    val16: .asciiz "25   "

    # Arrays for messages
    .align 2
    grid1: .word 0:16
    no_match_msgs: .word no_match_msg1, no_match_msg2, no_match_msg3, no_match_msg4

    # Sound settings
    success_duration: .word 1200
    failure_duration: .word 1600
    success_pitch: .word 100
    failure_pitch: .word 290
    success_volume: .word 250
    failure_volume: .word 250
    success_instrument: .word 9
    failure_instrument: .word 114

.text
.globl main

main:
    j game_start

game_start:
    jal init_game
game_loop:
    jal display_game_state
    jal get_player_move
    jal check_game_over
    beq $v0, $zero, game_loop
    
    jal display_final_results
    li $v0, 4
    la $a0, restart_prompt
    syscall
    
    li $v0, 5
    syscall
    
    beqz $v0, end_game
    li $t0, 1
    beq $v0, $t0, game_start
    
    li $v0, 4
    la $a0, invalid_restart
    syscall
    j game_loop
    
# Initialize game state and grid
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

# Modified display_game_state to show single grid
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
    
# Shuffle grid contents
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
# String comparison and value conversion
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

find_x:
    lb $t0, ($t3)
    beqz $t0, convert_direct
    beq $t0, 32, convert_direct
    li $t1, 'x'
    beq $t0, $t1, handle_multiplication
    addi $t2, $t2, 1
    addi $t3, $t3, 1
    j find_x

convert_direct:
    move $t3, $s0
convert_loop:
    lb $t0, ($t3)
    beq $t0, 32, convert_end
    beqz $t0, convert_end
    bltu $t0, '0', convert_end
    bgtu $t0, '9', convert_end
    
    addi $t0, $t0, -48
    li $t1, 10
    mul $s1, $s1, $t1
    add $s1, $s1, $t0
    
    addi $t3, $t3, 1
    j convert_loop

handle_multiplication:
    li $t4, 0
    move $t3, $s0

first_number_loop:
    lb $t0, ($t3)
    li $t1, 'x'
    beq $t0, $t1, handle_second_number
    addi $t0, $t0, -48
    li $t1, 10
    mul $t4, $t4, $t1
    add $t4, $t4, $t0
    addi $t3, $t3, 1
    j first_number_loop

handle_second_number:
    addi $t3, $t3, 1
    li $t5, 0

second_number_loop:
    lb $t0, ($t3)
    beq $t0, 32, multiply_numbers
    beqz $t0, multiply_numbers
    addi $t0, $t0, -48
    li $t1, 10
    mul $t5, $t5, $t1
    add $t5, $t5, $t0
    addi $t3, $t3, 1
    j second_number_loop

multiply_numbers:
    mul $s1, $t4, $t5

convert_end:
    move $v0, $s1

    lw $s2, 0($sp)
    lw $s1, 4($sp)
    lw $s0, 8($sp)
    lw $ra, 12($sp)
    addi $sp, $sp, 16
    jr $ra

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
    li $v0, 1
    move $a0, $t4
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

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

check_game_over:
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $s0, 0($sp)

    lw $s0, pairs_remaining
    beqz $s0, game_is_over
    li $v0, 0
    j check_done

game_is_over:
    li $v0, 1

check_done:
    lw $s0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
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

end_game:
    li $v0, 4
    la $a0, goodbye_msg
    syscall
    li $v0, 10
    syscall
