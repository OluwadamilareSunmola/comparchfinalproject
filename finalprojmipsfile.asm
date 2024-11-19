.data
    # Title and messages
    welcome:    .asciiz "********** Math-Memorization Game **********\nWelcome! Test your memory and your math skills all in one game!\n\n"
    newline:    .asciiz "\n"
    divider:    .asciiz "\n********** Display Cards **********\n"
    check_prompt1: .asciiz "\nEnter position from first grid (1-16): "
    check_prompt2: .asciiz "Enter corresponding position from second grid (1-16): "
    match_msg:    .asciiz "Match found!\n"
    no_match_msg: .asciiz "No match. Try again!\n"
    already_matched_msg: .asciiz "\nThis position is already matched! Try another position.\n"
    hline:      .asciiz "+--------+--------+--------+--------+\n"
    vline:      .asciiz "|     "  # Added 5 spaces after |
    hidden:     .asciiz "*    "   # Hidden value representation
    continue_msg: .asciiz "\nWould you like to continue? (1 for yes, 0 for no): "
    show_match_msg: .asciiz "The matching values are: Problem: "
    and_answer:    .asciiz " Answer: "
    
    # Score and game status messages
    score_msg:     .asciiz "\nCurrent Score: "
    moves_msg:     .asciiz "\nMoves taken: "
    pairs_left:    .asciiz "\nPairs remaining: "
    game_complete: .asciiz "\nCongratulations! You've found all matches!\n"
    final_score:   .asciiz "\nFinal Score: "
    final_moves:   .asciiz "\nTotal Moves: "
    
    # Debug messages
    debug_comparing: .asciiz "\nDEBUG - Comparing: "
    debug_with: .asciiz " with answer: "
    debug_calc: .asciiz "\nDEBUG - Calculated value: "
    debug_target: .asciiz "\nDEBUG - Target answer: "
    
    # Arrays
    grid1_arr:    .word   0:16    # Array for problem grid layout
    grid2_arr:    .word   0:16    # Array for answer grid layout
    matched_arr:  .word   0:16    # Array to track matched positions (0=unmatched, 1=matched)
    
    # Hardcoded problems (16 problems)
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
    
    # Hardcoded answers (16 answers)
    ans1:       .asciiz "12   "
    ans2:       .asciiz "10   "
    ans3:       .asciiz "18   "
    ans4:       .asciiz "16   "
    ans5:       .asciiz "16   "
    ans6:       .asciiz "14   "
    ans7:       .asciiz "9    "
    ans8:       .asciiz "12   "
    ans9:       .asciiz "9    "
    ans10:      .asciiz "4    "
    ans11:      .asciiz "8    "
    ans12:      .asciiz "10   "
    ans13:      .asciiz "16   "
    ans14:      .asciiz "7    "
    ans15:      .asciiz "12   "
    ans16:      .asciiz "15   "

.text
.globl main

main:
    # Initialize score and moves counter
    li $s7, 0          # Use $s7 to store score
    li $s6, 0          # Use $s6 to store moves
    
    # Initialize matched array to zeros
    la $t0, matched_arr
    li $t1, 16         # Counter
    li $t2, 0          # Value to store
init_matched:
    sw $t2, ($t0)
    addi $t0, $t0, 4
    addi $t1, $t1, -1
    bnez $t1, init_matched
    
    # Print welcome message
    li $v0, 4
    la $a0, welcome
    syscall
    
    # Initialize both grids
    jal init_grid1
    jal init_grid2
    
    # Shuffle both grids together
    jal shuffle_grid1
    
    # Print initial grids
    jal print_grids
    
main_loop:
    # Call check_match function
    jal check_match
    
    # Print moves
    li $v0, 4
    la $a0, moves_msg
    syscall
    li $v0, 1
    move $a0, $s6
    syscall
    
    # Ask if user wants to continue
    li $v0, 4
    la $a0, continue_msg
    syscall
    
    # Read response
    li $v0, 5
    syscall
    
    # If response is 1, continue
    beq $v0, 1, main_loop
    
    # Exit program
    li $v0, 10
    syscall

# Check if two positions match
check_match:
    # Save return address and s registers
    addi $sp, $sp, -20
    sw $ra, 16($sp)
    sw $s0, 12($sp)
    sw $s1, 8($sp)
    sw $s4, 4($sp)     # For original position 1
    sw $s5, 0($sp)     # For original position 2
    
    # Print first prompt
    li $v0, 4
    la $a0, check_prompt1
    syscall
    
    # Read first position
    li $v0, 5
    syscall
    addi $t0, $v0, -1      # Subtract 1 for 0-based indexing
    move $s4, $t0          # Save original position 1
    
    # Print second prompt
    li $v0, 4
    la $a0, check_prompt2
    syscall
    
    # Read second position
    li $v0, 5
    syscall
    addi $t1, $v0, -1      # Subtract 1 for 0-based indexing
    move $s5, $t1          # Save original position 2
    
    # Increment moves counter
    addi $s6, $s6, 1
    
    # Validate input ranges
    li $t2, 16
    bltz $s4, input_error
    bge $s4, $t2, input_error
    bltz $s5, input_error
    bge $s5, $t2, input_error
    
    # Check if positions are already matched
    la $t2, matched_arr
    sll $t3, $s4, 2
    add $t3, $t2, $t3
    lw $t4, ($t3)
    bnez $t4, already_matched
    
    sll $t3, $s5, 2
    add $t3, $t2, $t3
    lw $t4, ($t3)
    bnez $t4, already_matched
    
    # Calculate addresses for grid lookup
    la $t2, grid1_arr
    la $t3, grid2_arr
    sll $t0, $s4, 2    # Multiply original position by 4
    sll $t1, $s5, 2
    add $t2, $t2, $t0  # Add offset to base addresses
    add $t3, $t3, $t1
    
    # Load the problem and answer strings
    lw $s0, ($t2)      # Load address of problem string
    lw $s1, ($t3)      # Load address of answer string
    
    # Print debug info - what we're comparing
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
    move $a0, $s0      # Problem string
    move $a1, $s1      # Answer string
    jal evaluate_match
    
    # Check result
    beqz $v0, no_match
    
    # Match found - mark positions as matched
    la $t2, matched_arr
    sll $t3, $s4, 2    # Use original positions
    add $t3, $t2, $t3
    li $t4, 1
    sw $t4, ($t3)      # Mark first position
    
    sll $t3, $s5, 2    # Use original positions
    add $t3, $t2, $t3
    sw $t4, ($t3)      # Mark second position
    
    # Increment score
    addi $s7, $s7, 10  # Add 10 points for each match
    
    # Print match found and score
    li $v0, 4
    la $a0, match_msg
    syscall
    la $a0, score_msg
    syscall
    li $v0, 1
    move $a0, $s7
    syscall
    
    # Check if game is complete
    jal check_game_complete
    
    j check_done

no_match:
    li $v0, 4
    la $a0, no_match_msg
    syscall
    j check_done

already_matched:
    li $v0, 4
    la $a0, already_matched_msg
    syscall
    addi $s6, $s6, -1  # Don't count this as a move
    j check_done
    
input_error:
    li $v0, 4
    la $a0, no_match_msg
    syscall
    addi $s6, $s6, -1  # Don't count this as a move
    j check_done

check_done:
    # Restore all saved registers
    lw $ra, 16($sp)
    lw $s0, 12($sp)
    lw $s1, 8($sp)
    lw $s4, 4($sp)
    lw $s5, 0($sp)
    addi $sp, $sp, 20
    jr $ra

# Function to check if game is complete
check_game_complete:
    la $t0, matched_arr
    li $t1, 16         # Counter
    li $t2, 0         # Count of matched pairs
check_loop:
    lw $t3, ($t0)
    add $t2, $t2, $t3
    addi $t0, $t0, 4
    addi $t1, $t1, -1
    bnez $t1, check_loop
    
    # If all pairs found (t2 = 16)
    li $t3, 16
    bne $t2, $t3, not_complete
    
    # Game complete! Print final stats
    li $v0, 4
    la $a0, game_complete
    syscall
    la $a0, final_score
    syscall
    li $v0, 1
    move $a0, $s7
    syscall
    li $v0, 4
    la $a0, final_moves
    syscall
    li $v0, 1
    move $a0, $s6
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    
    # Exit program
    li $v0, 10
    syscall
    
not_complete:
    # Print remaining pairs
    li $v0, 4
    la $a0, pairs_left
    syscall
    li $v0, 1
    li $t3, 16
    sub $a0, $t3, $t2
    srl $a0, $a0, 1    # Divide by 2 for pairs
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    jr $ra

# Evaluate if problem matches answer
evaluate_match:
    # Input: $a0 = problem string, $a1 = answer string
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
    
    # It's multiplication - get second number
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
    # Now get answer number
    lb $t5, ($t7)      # First digit
    addi $t5, $t5, -48
    
    # Check if answer has second digit
    lb $t6, 1($t7)
    blt $t6, 0x30, single_digit  # Not a number
    bgt $t6, 0x39, single_digit  # Not a number
    # Two digit number
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
# Rest of the helper functions (init_grid1, init_grid2, shuffle_grid1, print_grids)
# [Previous implementation remains the same]
init_grid1:
    la $t0, grid1_arr   # Load base address of grid1
    
    # Initialize grid1
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

init_grid2:
    la $t0, grid2_arr   # Load base address of grid2
    
    # Initialize grid2
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

shuffle_grid1:
    li $t0, 15          # i = size - 1
    la $t1, grid1_arr   # base address of grid1
    la $t4, grid2_arr   # base address of grid2
    
shuffle_loop:
    beqz $t0, shuffle_done    # if i == 0, done
    
    # Generate random number from 0 to i
    li $v0, 42          # random int syscall
    move $a1, $t0       # upper bound
    syscall             # random number in $a0
    
    # Calculate offsets
    sll $t2, $t0, 2     # i * 4
    sll $t3, $a0, 2     # j * 4
    
    # Swap elements in grid1
    add $t5, $t1, $t2   # address of element i in grid1
    add $t6, $t1, $t3   # address of element j in grid1
    lw $t7, ($t5)       # Load grid1 values
    lw $t8, ($t6)
    sw $t8, ($t5)       # Swap grid1 values
    sw $t7, ($t6)
    
    # Swap elements in grid2
    add $t5, $t4, $t2   # address of element i in grid2
    add $t6, $t4, $t3   # address of element j in grid2
    lw $t7, ($t5)       # Load grid2 values
    lw $t8, ($t6)
    sw $t8, ($t5)       # Swap grid2 values
    sw $t7, ($t6)
    
    addi $t0, $t0, -1   # i--
    j shuffle_loop
    
shuffle_done:
    jr $ra

print_grids:
    # Save return address on stack
    addi $sp, $sp, -4      # Allocate space on stack
    sw $ra, 0($sp)         # Save return address
    
    # Print grid1 (problems)
    li $s3, 0              # Flag: 0 for problems (show actual values)
    la $t0, grid1_arr      # Load grid1 address
    jal print_single_grid
    
    # Print divider
    li $v0, 4
    la $a0, divider
    syscall
    
    # Print grid2 (answers) with asterisks
    li $s3, 1              # Flag: 1 for answers (show asterisks)
    la $t0, grid2_arr      # Load grid2 address
    jal print_single_grid
    
    # Restore return address and return
    lw $ra, 0($sp)         # Restore return address
    addi $sp, $sp, 4       # Deallocate stack space
    jr $ra
# Print a single 4x4 grid
print_single_grid:
    # Save return address and s registers
    addi $sp, $sp, -16     # Make space for 4 words
    sw $ra, 12($sp)        # Save return address
    sw $s0, 8($sp)         # Save s0
    sw $s1, 4($sp)         # Save s1
    sw $s2, 0($sp)         # Save s2
    
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
    
    # Check if we should print actual value or asterisk
    beqz $s3, print_value    # If grid1, print actual value
    
    # Print asterisk for answers
    li $v0, 4
    la $a0, hidden
    j after_print
    
print_value:
    # Print actual value
    lw $a0, ($s1)      # load address of value
    li $v0, 4
    
after_print:
    syscall
    
    # Check if we need a newline (after every 4 elements)
    addi $t3, $s2, 1
    rem $t3, $t3, 4
    bnez $t3, continue_print
    
    # Print final vertical line for row
    li $v0, 4
    la $a0, vline      
    syscall
    
    # Print newline
    li $v0, 4
    la $a0, newline
    syscall
    
    # Print horizontal line after each row
    li $v0, 4
    la $a0, hline
    syscall
    
continue_print:
    addi $s1, $s1, 4   # move to next element
    addi $s2, $s2, 1   # increment counter
    j print_loop
    
print_done:
    # Restore s registers and return address
    lw $s2, 0($sp)
    lw $s1, 4($sp)
    lw $s0, 8($sp)
    lw $ra, 12($sp)
    addi $sp, $sp, 16
    jr $ra
