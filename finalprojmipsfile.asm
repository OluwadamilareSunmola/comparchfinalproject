.data
    # Game state storage
    score:      .word 0     # Current score
    moves:      .word 0     # Number of moves taken
    remaining:  .word 8     # Number of remaining pairs
    pair_map:   .word 0:16  # Map to track which answers match which problems
    
    # Title and interface messages
    welcome:    .asciiz "********** Math-Memorization Game **********\nWelcome! Test your memory and your math skills all in one game!\n\n"
    newline:    .asciiz "\n"
    divider:    .asciiz "\n********** Display Cards **********\n"
    status_div: .asciiz "\n----------------------------------------\n"
    
    current_score: .word 0
    current_moves: .word 0
    remaining_pairs: .word 8
    
    
    # Input prompts
    check_prompt1: .asciiz "\nEnter position from first grid (1-16): "
    check_prompt2: .asciiz "Enter corresponding position from second grid (1-16): "
    continue_msg:  .asciiz "\nWould you like to continue? (1 for yes, 0 for no): "
    
    # Game feedback messages
    match_msg:     .asciiz "\nMatch found!"
    no_match_msg:  .asciiz "\nNo match. Try again!"
    already_matched_msg: .asciiz "\nThis position is already matched! Try another position."
    same_pos_msg:  .asciiz "\nCan't use the same position twice! Try different positions."
    invalid_msg:   .asciiz "\nInvalid input! Please enter a number between 1 and 16."
    
    # Grid display elements
    hline:      .asciiz "+--------+--------+--------+--------+\n"
    vline:      .asciiz "|     "  # 5 spaces after |
    hidden:     .asciiz "*    "   # Hidden value with padding
    
    # Status messages
    score_msg:     .asciiz "\nCurrent Score: "
    moves_msg:     .asciiz "\nMoves taken: "
    pairs_left:    .asciiz "\nPairs remaining: "
    game_complete: .asciiz "\nCongratulations! You've found all matches!"
    final_score:   .asciiz "\nFinal Score: "
    final_moves:   .asciiz "\nTotal Moves: "
    show_match_msg: .asciiz "The matching values are: Problem: "
    and_answer:    .asciiz " Answer: "
    
    # Debug messages (can be removed for production)
    debug_comparing: .asciiz "\nDEBUG - Comparing: "
    debug_with:      .asciiz " with answer: "
    debug_calc:      .asciiz "\nDEBUG - Calculated value: "
    debug_target:    .asciiz "\nDEBUG - Target answer: "
    
    # Game arrays (aligned for word access)
    .align 2
    grid1_arr:    .word   0:16    # Problem grid storage
    grid2_arr:    .word   0:16    # Answer grid storage
    matched_arr:  .word   0:16    # Matched position tracking
    
    # Problem definitions (all padded to 5 chars with spaces)
    prob1:      .asciiz "4x3  "
    prob2:      .asciiz "5x2  "
    prob3:      .asciiz "3x6  "
    prob4:      .asciiz "4x4  "
    prob5:      .asciiz "2x8  "
    prob6:      .asciiz "7x2  "
    prob7:      .asciiz "3x3  "
    prob8:      .asciiz "6x2  "
    prob9:      .asciiz "9    "
    prob10:     .asciiz "4    "
    prob11:     .asciiz "8x1  "
    prob12:     .asciiz "2x5  "
    prob13:     .asciiz "16   "
    prob14:     .asciiz "7    "
    prob15:     .asciiz "3x4  "
    prob16:     .asciiz "5x3  "
    
    # Answer definitions (all padded to 5 chars)
    ans1:       .asciiz "12   "  # 4x3
    ans2:       .asciiz "10   "  # 5x2
    ans3:       .asciiz "18   "  # 3x6
    ans4:       .asciiz "16   "  # 4x4
    ans5:       .asciiz "16   "  # 2x8
    ans6:       .asciiz "14   "  # 7x2
    ans7:       .asciiz "9    "  # 3x3
    ans8:       .asciiz "12   "  # 6x2
    ans9:       .asciiz "9    "  # 9
    ans10:      .asciiz "4    "  # 4
    ans11:      .asciiz "8    "  # 8x1
    ans12:      .asciiz "10   "  # 2x5
    ans13:      .asciiz "16   "  # 16
    ans14:      .asciiz "7    "  # 7
    ans15:      .asciiz "12   "  # 3x4
    ans16:      .asciiz "15   "  # 5x3
    
    # Answer mapping (to track which answer goes with which problem)
    .align 2
    answer_map: .word 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
    

.text
.globl main

main:


    li $s7, 0          # Score in $s7
    li $s6, 0          # Moves in $s6
    li $s5, 8          # Remaining pairs in $s5
    # Initialize game state
    sw $zero, score
    sw $zero, moves
    li $t0, 8
    sw $t0, remaining
    
    # Print welcome message
    li $v0, 4
    la $a0, welcome
    syscall
    
    # Initialize game state and arrays
    jal init_game_state
    
    # Enter main game loop
    j main_loop

# Initialize full game state
init_game_state:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Clear matched array
    la $t0, matched_arr
    li $t1, 16         # Counter
    li $t2, 0          # Clear value
clear_matched:
    sw $t2, ($t0)
    addi $t0, $t0, 4
    addi $t1, $t1, -1
    bnez $t1, clear_matched
    
    # Initialize both grids
    jal init_grid1
    jal init_grid2
    
    # Shuffle both grids together
    jal shuffle_grids
    
    # Print initial state
    jal print_grids
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Main game loop
main_loop:
    # Load current game state
    lw $s7, score
    lw $s6, moves
    
    # Get player moves and check match
    jal check_match
    
    # Update game state
    sw $s7, score
    sw $s6, moves
    
    # Print current state
    jal print_status
    
    # Check if game complete
    jal check_game_complete
    bnez $v0, game_end
    
    # Ask to continue
    li $v0, 4
    la $a0, continue_msg
    syscall
    
    li $v0, 5
    syscall
    beqz $v0, game_end     # Exit if 0
    j main_loop

# Shuffle both grids together maintaining pairs
shuffle_grids:
    li $t0, 15          # i = size - 1
    la $t1, grid1_arr   # base address of grid1
    la $t4, grid2_arr   # base address of grid2
    
shuffle_loop:
    beqz $t0, shuffle_done
    
    # Generate random number from 0 to i
    li $v0, 42          # random int syscall
    move $a1, $t0       # upper bound
    syscall             # random number in $a0
    
    # Calculate offsets
    sll $t2, $t0, 2     # i * 4
    sll $t3, $a0, 2     # j * 4
    
    # Swap elements in both grids
    # Grid 1
    add $t5, $t1, $t2   # address i in grid1
    add $t6, $t1, $t3   # address j in grid1
    lw $t7, ($t5)       # Load values
    lw $t8, ($t6)
    sw $t8, ($t5)       # Swap
    sw $t7, ($t6)
    
    # Grid 2 (same positions)
    add $t5, $t4, $t2   # address i in grid2
    add $t6, $t4, $t3   # address j in grid2
    lw $t7, ($t5)       # Load values
    lw $t8, ($t6)
    sw $t8, ($t5)       # Swap
    sw $t7, ($t6)
    
    addi $t0, $t0, -1   # Decrement counter
    j shuffle_loop
    
shuffle_done:
    jr $ra

# Check if positions match
# Check if positions match
check_match:
    # Save registers
    addi $sp, $sp, -20
    sw $ra, 16($sp)
    sw $s0, 12($sp)
    sw $s1, 8($sp)
    sw $s4, 4($sp)
    sw $s5, 0($sp)
    
    # Get first position
    li $v0, 4
    la $a0, check_prompt1
    syscall
    li $v0, 5
    syscall
    
    # Validate first input
    li $t0, 1
    li $t1, 16
    blt $v0, $t0, input_error
    bgt $v0, $t1, input_error
    
    addi $t0, $v0, -1      # Convert to 0-based index
    move $s4, $t0          # Save original position 1
    
    # Get second position
    li $v0, 4
    la $a0, check_prompt2
    syscall
    li $v0, 5
    syscall
    
    # Validate second input
    li $t0, 1
    li $t1, 16
    blt $v0, $t0, input_error
    bgt $v0, $t1, input_error
    
    addi $t1, $v0, -1      # Convert to 0-based index
    move $s5, $t1          # Save original position 2
    
    # Check if same position
    beq $s4, $s5, same_position
    
    addi $s6, $s6, 1    # Increment moves
    sw $s6, current_moves
    
    
    # Check if positions already matched
    la $t2, matched_arr
    sll $t3, $s4, 2
    add $t3, $t2, $t3
    lw $t4, ($t3)
    bnez $t4, already_matched
    
    sll $t3, $s5, 2
    add $t3, $t2, $t3
    lw $t4, ($t3)
    bnez $t4, already_matched
    
    # Increment moves counter for valid move
    lw $t0, moves
    addi $t0, $t0, 1
    sw $t0, moves
    
    # Get values from grids
    la $t2, grid1_arr
    la $t3, grid2_arr
    sll $t0, $s4, 2
    sll $t1, $s5, 2
    add $t2, $t2, $t0
    add $t3, $t3, $t1
    
    lw $s0, ($t2)      # Load problem string
    lw $s1, ($t3)      # Load answer string
    
    # Print debug info
    li $v0, 4
    la $a0, debug_comparing
    syscall
    move $a0, $s0
    syscall
    la $a0, debug_with
    syscall
    move $a0, $s1
    syscall
    
    # Call evaluate_match
    move $a0, $s0
    move $a1, $s1
    jal evaluate_match
    
    # Check result
    beqz $v0, no_match
    
    # Match found - handle match
    jal handle_match
    
    # Print updated grids and status
    jal print_grids
    
    j check_done

# Handle successful match
handle_match:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Mark positions as matched
    la $t2, matched_arr
    sll $t3, $s4, 2
    add $t3, $t2, $t3
    li $t4, 1
    sw $t4, ($t3)
    
    sll $t3, $s5, 2
    add $t3, $t2, $t3
    sw $t4, ($t3)
    
    # Update score atomically
    lw $t0, score
    addi $t0, $t0, 10
    sw $t0, score
    
    addi $s7, $s7, 10    # Add 10 points
    sw $s7, current_score
    addi $s5, $s5, -1    # Decrease remaining pairs
    sw $s5, remaining_pairs
    
    # Update remaining pairs atomically
    lw $t0, remaining
    addi $t0, $t0, -1
    sw $t0, remaining
    
    # Print match message and current score
    li $v0, 4
    la $a0, match_msg
    syscall
    la $a0, score_msg
    syscall
    li $v0, 1
    lw $a0, score
    syscall
    
    # Print newline
    li $v0, 4
    la $a0, newline
    syscall
    
    # Restore return address
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Error handlers
no_match:
    li $v0, 4
    la $a0, no_match_msg
    syscall
    j check_done

same_position:
    li $v0, 4
    la $a0, same_pos_msg
    syscall
    j check_done

already_matched:
    li $v0, 4
    la $a0, already_matched_msg
    syscall
    j check_done

input_error:
    li $v0, 4
    la $a0, invalid_msg
    syscall
    j check_done

check_done:
    # Restore registers
    lw $ra, 16($sp)
    lw $s0, 12($sp)
    lw $s1, 8($sp)
    lw $s4, 4($sp)
    lw $s5, 0($sp)
    addi $sp, $sp, 20
    jr $ra
# Evaluate if values match
evaluate_match:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Save strings
    move $t0, $a0      # Problem string
    move $t7, $a1      # Answer string
    
    # First calculate problem result
    lb $t1, ($t0)      # Load first digit
    addi $t1, $t1, -48 # Convert ASCII to number
    
    # Check if it's multiplication (has 'x')
    lb $t2, 1($t0)     # Load second character
    li $t3, 0x78       # ASCII for 'x'
    bne $t2, $t3, single_number
    
    # Handle multiplication
    lb $t2, 2($t0)     # Load digit after 'x'
    addi $t2, $t2, -48 # Convert to number
    mul $t4, $t1, $t2  # Multiply numbers
    
    # Debug - print calculated value
    li $v0, 4
    la $a0, debug_calc
    syscall
    li $v0, 1
    move $a0, $t4
    syscall
    j get_answer
    
single_number:
    move $t4, $t1      # Just use the single number
    # Debug - print single number
    li $v0, 4
    la $a0, debug_calc
    syscall
    li $v0, 1
    move $a0, $t4
    syscall
    
get_answer:
    # Get answer number
    lb $t5, ($t7)      # First digit
    addi $t5, $t5, -48
    
    # Check for second digit
    lb $t6, 1($t7)
    blt $t6, 0x30, single_digit  # Not a number
    bgt $t6, 0x39, single_digit  # Not a number
    # Handle two-digit number
    addi $t6, $t6, -48
    li $t8, 10
    mul $t5, $t5, $t8
    add $t5, $t5, $t6
    
single_digit:
    # Debug - print target answer
    li $v0, 4
    la $a0, debug_target
    syscall
    li $v0, 1
    move $a0, $t5
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    
    # Compare results
    seq $v0, $t4, $t5  # Set to 1 if equal, 0 if not
    
    # Restore return address
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Initialize grid1
init_grid1:
    la $t0, grid1_arr
    
    # Store problem addresses
    la $t2, prob1
    sw $t2, 0($t0)
    la $t2, prob2
    sw $t2, 4($t0)
    la $t2, prob3
    sw $t2, 8($t0)
    la $t2, prob4
    sw $t2, 12($t0)
    la $t2, prob5
    sw $t2, 16($t0)
    la $t2, prob6
    sw $t2, 20($t0)
    la $t2, prob7
    sw $t2, 24($t0)
    la $t2, prob8
    sw $t2, 28($t0)
    la $t2, prob9
    sw $t2, 32($t0)
    la $t2, prob10
    sw $t2, 36($t0)
    la $t2, prob11
    sw $t2, 40($t0)
    la $t2, prob12
    sw $t2, 44($t0)
    la $t2, prob13
    sw $t2, 48($t0)
    la $t2, prob14
    sw $t2, 52($t0)
    la $t2, prob15
    sw $t2, 56($t0)
    la $t2, prob16
    sw $t2, 60($t0)
    
    jr $ra

# Initialize grid2
init_grid2:
    la $t0, grid2_arr
    
    # Store answer addresses
    la $t2, ans1
    sw $t2, 0($t0)
    la $t2, ans2
    sw $t2, 4($t0)
    la $t2, ans3
    sw $t2, 8($t0)
    la $t2, ans4
    sw $t2, 12($t0)
    la $t2, ans5
    sw $t2, 16($t0)
    la $t2, ans6
    sw $t2, 20($t0)
    la $t2, ans7
    sw $t2, 24($t0)
    la $t2, ans8
    sw $t2, 28($t0)
    la $t2, ans9
    sw $t2, 32($t0)
    la $t2, ans10
    sw $t2, 36($t0)
    la $t2, ans11
    sw $t2, 40($t0)
    la $t2, ans12
    sw $t2, 44($t0)
    la $t2, ans13
    sw $t2, 48($t0)
    la $t2, ans14
    sw $t2, 52($t0)
    la $t2, ans15
    sw $t2, 56($t0)
    la $t2, ans16
    sw $t2, 60($t0)
    
    jr $ra
# Print both grids
print_grids:
    # Save return address and $s3
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $s3, 0($sp)
    
    # Print grid1 (problems)
    li $s3, 0              # Flag: 0 for problems (show actual values)
    la $t0, grid1_arr
    jal print_single_grid
    
    # Print divider
    li $v0, 4
    la $a0, divider
    syscall
    
    # Print grid2 (answers) with asterisks for unmatched
    li $s3, 1              # Flag: 1 for answers (show asterisks)
    la $t0, grid2_arr
    jal print_single_grid
    
    # Restore and return
    lw $s3, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra

# Print a single 4x4 grid
print_single_grid:
    # Save registers
    addi $sp, $sp, -16
    sw $ra, 12($sp)
    sw $s0, 8($sp)
    sw $s1, 4($sp)
    sw $s2, 0($sp)
    
    move $s1, $t0       # Save grid base address
    li $s2, 0          # Counter
    
    # Print top border
    li $v0, 4
    la $a0, hline
    syscall
    
print_loop:
    li $t2, 16
    beq $s2, $t2, print_done   # if printed all elements, done
    
    # Print vertical line with spacing
    li $v0, 4
    la $a0, vline
    syscall
    
    # Check if showing value or asterisk
    beqz $s3, print_value    # If grid1, show value
    
    # For grid2, check if position is matched
    move $t0, $s2
    la $t1, matched_arr
    sll $t0, $t0, 2
    add $t1, $t1, $t0
    lw $t2, ($t1)
    bnez $t2, print_value
    
    # Print asterisk for unmatched answers
    li $v0, 4
    la $a0, hidden
    j after_print
    
print_value:
    # Print actual value
    lw $a0, ($s1)
    li $v0, 4
    
after_print:
    syscall
    
    # Check for end of row
    addi $t3, $s2, 1
    rem $t3, $t3, 4
    bnez $t3, continue_print
    
    # End of row - print closing
    li $v0, 4
    la $a0, vline      
    syscall
    la $a0, newline
    syscall
    la $a0, hline
    syscall
    
continue_print:
    addi $s1, $s1, 4   # Next element
    addi $s2, $s2, 1   # Increment counter
    j print_loop
    
print_done:
    # Restore registers
    lw $s2, 0($sp)
    lw $s1, 4($sp)
    lw $s0, 8($sp)
    lw $ra, 12($sp)
    addi $sp, $sp, 16
    jr $ra

# Print current game status
print_status:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Print score
    li $v0, 4
    la $a0, score_msg
    syscall
    li $v0, 1
    lw $a0, score
    syscall
    
    # Print moves
    li $v0, 4
    la $a0, moves_msg
    syscall
    li $v0, 1
    lw $a0, moves
    syscall
    
    # Print remaining pairs
    li $v0, 4
    la $a0, pairs_left
    syscall
    li $v0, 1
    lw $a0, remaining
    syscall
    
    # Print newline
    li $v0, 4
    la $a0, newline
    syscall
    
    # Restore and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Check if game is complete
check_game_complete:
    # Return 1 if complete, 0 if not
    lw $t0, remaining
    seq $v0, $t0, $zero
    
    # If not complete, return
    beqz $v0, check_complete_done
    
    # Game is complete - print final messages
    li $v0, 4
    la $a0, game_complete
    syscall
    
    la $a0, final_score
    syscall
    li $v0, 1
    lw $a0, score
    syscall
    
    li $v0, 4
    la $a0, final_moves
    syscall
    li $v0, 1
    lw $a0, moves
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
check_complete_done:
    jr $ra

# Game end handling
game_end:
    # Print final stats
    jal print_status
    
    # Exit program
    li $v0, 10
    syscall
