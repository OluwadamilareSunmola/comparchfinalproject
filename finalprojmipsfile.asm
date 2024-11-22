.data
    brain_art: .asciiz "                       _____\n                   .d88888888bo.\n                 .d8888888888888b.\n                 8888888888888888b\n                 888888888888888888\n                 888888888888888888\n                  Y8888888888888888\n            ,od888888888888888888P\n         .'`Y8P'```'Y8888888888P'\n       .'_   `  _     'Y88888888b\n      /  _`    _ `      Y88888888b   ____\n   _  | /  \\  /  \\      8888888888.d888888b.\n  d8b | | /|  | /|      8888888888d8888888888b\n 8888_\\ \\_|/  \\_|/      d888888888888888888888b\n .Y8P  `'-.            d88888888888888888888888\n/          `          `      `Y8888888888888888\n|                        __    888888888888888P\n \\                       / `   dPY8888888888P'\n  '._                  .'     .'  `Y888888P`\n     `\"'-.,__    ___.-'    .-'\n         `-._````  __..--'`\n                 ``````\n"
brain_title:    .asciiz "\n╔═══════════════════════════════════════════════╗\n║   🧮 Welcome to MATH MEMORY MASTER! 🧮       ║\n║      Test Your Memory & Math Skills!          ║\n╚═══════════════════════════════════════════════╝\n"

display_cards:  .asciiz "\n\n\n╭────────── ;)Game Board 🎴 ──────────╮\n│   Can you match all the pairs?           │\n│   Remember: Numbers & Equations Match!    │\n╰──────────────────────────────────────────╯\n"
    # Game state variables
    pairs_remaining: .word 8          # Start with 8 pairs (16 cards)
    matched_arr:     .word 0:16       # Track revealed cards (0=hidden, 1=revealed)
    score:          .word 0           # Player's score

    restart_prompt:  .asciiz "\n\n\n\nuld you like to play again? (1 for yes, 0 for no): "
    invalid_restart: .asciiz "\nPlease enter 0 or 1 only.\n"
    goodbye_msg:     .asciiz "\n\nThanks for playing! Goodbye!\n"
    
    # Timer variables
    start_time_low:  .word 0          # Low word of start time
    start_time_high: .word 0          # High word of start time
    time_msg:       .asciiz "Time elapsed: "
    colon:          .asciiz ":"
    zero:           .asciiz "0"
    
    matches_found: .word 0
    
    
    # Basic display elements
    divider:        .asciiz "\n----------------------------------------\n"
    newline:        .asciiz "\n"
    card_separator: .asciiz " | "     # Separates values in grid
    hidden_card:    .asciiz "*    "   # Hidden card display (5 chars)
    
    # Card frame elements
    card_top:       .asciiz "┌─────┐\n"
    card_bottom:    .asciiz "└─────┘\n"

    # Stat display frames
    stats_top:      .asciiz "\n    ┏━━━━━━━━━━━━┓\n"
    stats_middle:   .asciiz "    ┃ "
    stats_end:      .asciiz "  ┃\n"
    stats_bottom:   .asciiz "    ┗━━━━━━━━━━━━┛\n"

    # Progress and victory displays
    half_way:       .asciiz "\n    ╔═══════════════╗\n    ║ HALFWAY THERE!║\n    ╚═══════════════╝\n"
    victory_banner: .asciiz "\n    🎉 CONGRATULATIONS! 🎉\n    ┏━━━━━━━━━━━━━━━━━┓\n    ┃  YOU DID IT!!!  ┃\n    ┗━━━━━━━━━━━━━━━━━┛\n"

    # Match messages (rotating)
    match_msg1:     .asciiz "\n    \\(^o^)// Fantastic!\n"
    match_msg2:     .asciiz "\n    (ﾉ◕ヮ◕)ﾉ*:･ﾟ✧ Amazing!\n"
    match_msg3:     .asciiz "\n    (╯°□°)╯ Great Job!\n"
    match_msg4:     .asciiz "\n    ٩(◕‿◕｡)۶ Perfect!\n"
    
    # No match messages (rotating)
    no_match_msg1:  .asciiz "\n    ¯\\_(ツ)_/¯ Try Again!\n"
    no_match_msg2:  .asciiz "\n    (•_•) Not Quite...\n"
    no_match_msg3:  .asciiz "\n    (︶︹︺) Almost...\n"
    no_match_msg4:  .asciiz "\n    (._.) Keep Going!\n"

    # Input prompts and status messages
    prompt1:        .asciiz "\nSelect first card (1-16): "
    prompt2:        .asciiz "\nSelect second card (1-16): "
    match_found:    .asciiz "\nMatch found! +10 points\n"
    no_match:       .asciiz "\nNo match. Try again!\n"
    invalid_input:  .asciiz "\nPlease enter a number between 1 and 16\n"
    already_matched: .asciiz "\nThis card is already matched! Try another.\n"
    same_card:      .asciiz "\nCannot select the same card! Try again.\n"
    pairs_msg:      .asciiz "\nPairs remaining: "
    score_msg:      .asciiz "Score: "

    game_over:      .asciiz "\nCongratulations! You've found all pairs!\n"

    # Card values (all padded to 5 chars)
    val1:           .asciiz "2x3  "  # 2 × 3 = 6
    val9:           .asciiz "6    "  # Direct value 6
    val2:           .asciiz "4x2  "  # 4 × 2 = 8
    val10:          .asciiz "8    "  # Direct value 8
    val3:           .asciiz "3x3  "  # 3 × 3 = 9
    val7:           .asciiz "9    "  # Direct value 9
    val4:           .asciiz "200  "  # 3 × 4 = 12
    val6:           .asciiz "200   " # Direct value 12
    val5:           .asciiz "5x3  "  # 5 × 3 = 15
    val11:          .asciiz "15   "  # Direct value 15
    val8:           .asciiz "9x10  " # 4 × 4 = 16
    val14:          .asciiz "90   "  # Direct value 16
    val13:          .asciiz "4x5  "  # 4 × 5 = 20
    val15:          .asciiz "20   "  # Direct value 20
    val12:          .asciiz "25  "   # 5 × 5 = 25
    val16:          .asciiz "25   "  # Direct value 25

    # Message arrays for random selection (must be aligned)
    .align 2
    grid1:          .word 0:16        # Main grid with all values
    match_msgs:     .word match_msg1, match_msg2, match_msg3, match_msg4
    no_match_msgs:  .word no_match_msg1, no_match_msg2, no_match_msg3, no_match_msg4
    
    
        # Card display art
    card_frame_top:     .asciiz "┌───────┐"
    card_frame_bottom:  .asciiz "└───────┘"
    card_frame_side:    .asciiz "│"
    card_frame_empty:   .asciiz "│   *   │"  # For hidden cards
    card_matched:       .asciiz "✓ "         # Checkmark for matched pairs
    card_selected:      .asciiz "→ "         # Arrow for selected card
    
    # Celebration art for matches
    celebration_art1:   .asciiz "\n  🌟 ⭐ 🌟\n"
    celebration_art2:   .asciiz "\n  ✨ ⚡ ✨\n"
    
    # Game progress art
    progress_bar_start: .asciiz "["
    progress_bar_end:   .asciiz "]"
    progress_fill:      .asciiz "■"
    progress_empty:     .asciiz "□"
    
    # Score display art
    score_frame_top:    .asciiz "╔════════╗\n"
    score_frame_mid:    .asciiz "║"
    score_frame_bottom: .asciiz "╚════════╝\n"

    # Timer art
    timer_art:          .asciiz "⏱️ "

    score_art:          .asciiz "🏆 "

    success_duration: .word 1200    # Duration in milliseconds
    failure_duration: .word 1000     # Duration in milliseconds
    success_pitch:    .word 100      # High C note
    failure_pitch:    .word 290      # Lower note
    success_volume:   .word 250    # Maximum volume
    failure_volume:   .word 127     # Slightly lower volume
    success_instrument: .word 9     # Glockenspiel (bright, happy sound)
    failure_instrument: .word 114   # Steel Drums (distinctive sound)
.text
.globl main

main:
    # Initialize game state
    j game_start


game_start:
    jal init_game
game_loop:
        # Display current state
    jal display_game_state
        
        # Get and process player moves
    jal get_player_move
        
        # Check if game is over
    jal check_game_over
    beq $v0, $zero, game_loop    # If not over, continue loop
        
    # Game over, display results
    jal display_final_results
    li $v0, 4
    la $a0, restart_prompt
    syscall
    
    # Read player choice
    li $v0, 5
    syscall
    
    # Check input validity
    beqz $v0, end_game          # If input is 0, end game
    li $t0, 1
    beq $v0, $t0, game_start    # If input is 1, restart game
    
    # Invalid input, display error and loop back
    li $v0, 4
    la $a0, invalid_restart
    syscall
    j game_loop                 # Loop back for another try
# Initialize game state and grid
init_game:
    # Prologue
    li $v0, 30             # System time in milliseconds
    syscall                # Time in $a0 (low) and $a1 (high)
    sw $a0, start_time_low     # Store low word
    sw $a1, start_time_high    # Store high word

    addi $sp, $sp, -20    # Allocate stack space for 5 registers
    sw $ra, 16($sp)       # Save return address at top of frame
    sw $s0, 12($sp)       # Save preserved registers
    sw $s1, 8($sp)
    sw $s2, 4($sp)
    sw $s3, 0($sp)

    # Display brain ASCII art with dramatic effect
    li $v0, 4
    la $a0, brain_art     # Display the brain art
    syscall
    
    # Short pause for dramatic effect
    li $v0, 32            # Sleep syscall
    li $a0, 500           # Sleep for 0.5 seconds
    syscall

    # Display welcome title
    li $v0, 4
    la $a0, brain_title
    syscall
    
    # Add visual separator
    la $a0, divider
    syscall

    # Initialize game state variables
    li $t0, 8
    sw $t0, pairs_remaining
    sw $zero, score


    # Load base addresses into saved registers
    la $s0, matched_arr   # $s0 = base address of matched_arr
    la $s1, grid1         # $s1 = base address of grid1
    li $s2, 16           # $s2 = counter for loop
    li $s3, 0            # $s3 = current offset/index

init_matched_loop:
    # Initialize matched_arr to all zeros
    add $t0, $s0, $s3    # Calculate current address
    sw $zero, ($t0)      # Store 0 (hidden)
    addi $s3, $s3, 4     # Increment offset
    addi $s2, $s2, -1    # Decrement counter
    bnez $s2, init_matched_loop

    # Initialize grid1 with card values
    la $t0, val1
    sw $t0, 0($s1)      # grid1[0] = &val1
    
    la $t0, val2
    sw $t0, 4($s1)      # grid1[1] = &val2
    
    la $t0, val3
    sw $t0, 8($s1)      # grid1[2] = &val3
    
    la $t0, val4
    sw $t0, 12($s1)     # grid1[3] = &val4
    
    la $t0, val5
    sw $t0, 16($s1)     # grid1[4] = &val5
    
    la $t0, val6
    sw $t0, 20($s1)     # grid1[5] = &val6
    
    la $t0, val7
    sw $t0, 24($s1)     # grid1[6] = &val7
    
    la $t0, val8
    sw $t0, 28($s1)     # grid1[7] = &val8
    
    la $t0, val9
    sw $t0, 32($s1)     # grid1[8] = &val9
    
    la $t0, val10
    sw $t0, 36($s1)     # grid1[9] = &val10
    
    la $t0, val11
    sw $t0, 40($s1)     # grid1[10] = &val11
    
    la $t0, val12
    sw $t0, 44($s1)     # grid1[11] = &val12
    
    la $t0, val13
    sw $t0, 48($s1)     # grid1[12] = &val13
    
    la $t0, val14
    sw $t0, 52($s1)     # grid1[13] = &val14
    
    la $t0, val15
    sw $t0, 56($s1)     # grid1[14] = &val15
    
    la $t0, val16
    sw $t0, 60($s1)     # grid1[15] = &val16

    # Shuffle the grid
    jal shuffle_grid

    # Epilogue
    lw $s3, 0($sp)       # Restore preserved registers in reverse order
    lw $s2, 4($sp)
    lw $s1, 8($sp)
    lw $s0, 12($sp)
    lw $ra, 16($sp)      # Restore return address last
    addi $sp, $sp, 20    # Deallocate stack space

    jr $ra               # Return to caller
display_game_state:
   # Prologue
   addi $sp, $sp, -32        # Space for 8 registers
   sw $ra, 28($sp)           # Save return address
   sw $s0, 24($sp)           # Save s0-s6 (need several for grid traversal)
   sw $s1, 20($sp)
   sw $s2, 16($sp)
   sw $s3, 12($sp)
   sw $s4, 8($sp)
   sw $s5, 4($sp)
   sw $s6, 0($sp)

   # Load addresses and initialize counters
   la $s0, grid1             # $s0 = base of grid1
   la $s1, matched_arr       # $s1 = base of matched array
   li $s2, 0                 # $s2 = current position (0-15)
   li $s3, 4                 # $s3 = items per row
   li $s4, 0                 # $s4 = current row
   
   # Display grid header
   li $v0, 4
   la $a0, display_cards
   syscall
   
   # First Grid Display (all values visible)
first_grid_loop:
   # Check if we need a new row
   div $s2, $s3              # divide position by 4
   mfhi $t0                  # get remainder
   bnez $t0, skip_newline1   # if not start of row, skip newline
   
   # Print newline and divider at start of row
   li $v0, 4
   la $a0, newline
   syscall
   la $a0, divider
   syscall
   
skip_newline1:
   # Print separator
   li $v0, 4
   la $a0, card_separator
   syscall
   
   # Load and print current value
   sll $t0, $s2, 2          # multiply position by 4 for offset
   add $t0, $s0, $t0        # add to base address
   lw $t1, ($t0)            # load address of string
   li $v0, 4
   move $a0, $t1
   syscall
   
   # Increment position and check if done
   addi $s2, $s2, 1         # increment position
   li $t0, 16
   bne $s2, $t0, first_grid_loop
   
   # Print final newline and divider
   li $v0, 4
   la $a0, newline
   syscall
   la $a0, divider
   syscall
   
   # Reset for second grid
   li $s2, 0                # reset position counter
   
   # Display second grid (with hidden cards)
second_grid_loop:
   # Check if we need a new row
   div $s2, $s3             # divide position by 4
   mfhi $t0                 # get remainder
   bnez $t0, skip_newline2  # if not start of row, skip newline
   
   # Print newline and divider at start of row
   li $v0, 4
   la $a0, newline
   syscall
   la $a0, divider
   syscall

skip_newline2:
   # Print separator
   li $v0, 4
   la $a0, card_separator
   syscall
   
   # Check if card is revealed
   sll $t0, $s2, 2          # multiply position by 4 for offset
   add $t1, $s1, $t0        # add to matched_arr base
   lw $t2, ($t1)            # load matched status
   
   beqz $t2, print_hidden   # if not matched, print hidden
   
   # Card is revealed, print value from grid1
   add $t1, $s0, $t0        # get grid1 address using original offset
   lw $t2, ($t1)            # load string address
   li $v0, 4
   move $a0, $t2
   syscall
   j after_print
   
print_hidden:
   # Print hidden card symbol
   li $v0, 4
   la $a0, hidden_card
   syscall
   
after_print:
   # Increment position and check if done
   addi $s2, $s2, 1         # increment position
   li $t0, 16
   bne $s2, $t0, second_grid_loop
   
   # Print final newline and divider
   li $v0, 4
   la $a0, newline
   syscall
   la $a0, divider
   syscall
   
   # Display game status
   li $v0, 4
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

   


   # Epilogue
   lw $s6, 0($sp)           # Restore all saved registers
   lw $s5, 4($sp)
   lw $s4, 8($sp)
   lw $s3, 12($sp)
   lw $s2, 16($sp)
   lw $s1, 20($sp)
   lw $s0, 24($sp)
   lw $ra, 28($sp)
   addi $sp, $sp, 32        # Restore stack pointer
   
   jr $ra                   # Return to caller


# Shuffle the grid contents
# Shuffle the grid contents
shuffle_grid:
    # Prologue
    addi $sp, $sp, -28       # Space for 7 registers
    sw $ra, 24($sp)
    sw $s0, 20($sp)          # For grid1 base address
    sw $s1, 16($sp)          # For loop counter
    sw $s2, 12($sp)          # For current position
    sw $s3, 8($sp)           # For random position
    sw $s4, 4($sp)           # For temp storage
    sw $s5, 0($sp)           # For swapped value

    # Initialize
    la $s0, grid1            # Load grid base address
    li $s1, 15               # Start with n-1 (15 for 16 positions)

shuffle_loop:
    # Check if we should continue
    bltz $s1, shuffle_done   # If counter < 0, we're done

    # Generate random number from 0 to current position ($s1)
    li $v0, 42               # Random int syscall
    li $a0, 0               # Random generator ID
    addi $a1, $s1, 1        # Upper bound + 1 (make it inclusive and positive)
    syscall                  # Random number stored in $a0
    move $s3, $a0            # Save random position

    # Calculate addresses for current and random positions
    sll $t0, $s1, 2         # Current pos * 4
    sll $t1, $s3, 2         # Random pos * 4
    add $t0, $s0, $t0       # Address of current position
    add $t1, $s0, $t1       # Address of random position

    # Swap values
    lw $s4, ($t0)           # Load current value
    lw $s5, ($t1)           # Load random value
    sw $s5, ($t0)           # Store random value in current position
    sw $s4, ($t1)           # Store current value in random position

    # Decrement counter
    addi $s1, $s1, -1       # Decrement counter
    j shuffle_loop          # Continue shuffling

shuffle_done:
    # Epilogue
    lw $s5, 0($sp)
    lw $s4, 4($sp)
    lw $s3, 8($sp)
    lw $s2, 12($sp)
    lw $s1, 16($sp)
    lw $s0, 20($sp)
    lw $ra, 24($sp)
    addi $sp, $sp, 28

    jr $ra

get_player_move:
    # Prologue
    addi $sp, $sp, -28        # Space for 7 registers
    sw $ra, 24($sp)           # Save return address
    sw $s0, 20($sp)           # For first card selection
    sw $s1, 16($sp)           # For second card selection
    sw $s2, 12($sp)           # For grid1 base address
    sw $s3, 8($sp)           # For matched_arr base address
    sw $s4, 4($sp)           # For first card value
    sw $s5, 0($sp)           # For second card value

    # Load addresses
    la $s2, grid1            # Load grid base address
    la $s3, matched_arr      # Load matched array base address
    
    

get_first_card:
    # Prompt for first card
    li $v0, 4
    la $a0, prompt1
    syscall

    # Read input
    li $v0, 5
    syscall
    move $s0, $v0            # Save first selection

    # Validate input (1-16)
    li $t0, 1
    li $t1, 16
    blt $s0, $t0, invalid_input1
    bgt $s0, $t1, invalid_input1

    # Adjust to 0-based index
    addi $s0, $s0, -1

    # Check if already matched
    sll $t0, $s0, 2          # Multiply by 4 for offset
    add $t0, $s3, $t0
    lw $t1, ($t0)            # Load matched status
    bnez $t1, already_matched1

    # Temporarily reveal first card
    li $t1, 2                # Use 2 to indicate temporarily revealed
    sw $t1, ($t0)            # Mark card as temporarily revealed
    
    # Display current state with first card revealed
    jal display_game_state

get_second_card:
    # Prompt for second card
    li $v0, 4
    la $a0, prompt2
    syscall

    # Read input
    li $v0, 5
    syscall
    move $s1, $v0            # Save second selection

    # Validate input (1-16)
    li $t0, 1
    li $t1, 16
    blt $s1, $t0, invalid_input2
    bgt $s1, $t1, invalid_input2

    # Adjust to 0-based index
    addi $s1, $s1, -1

    # Check if same as first card
    beq $s1, $s0, same_card_error

    # Check if already matched
    sll $t0, $s1, 2          # Multiply by 4 for offset
    add $t0, $s3, $t0
    lw $t1, ($t0)            # Load matched status
    bnez $t1, already_matched2

    # Get values and compare
    sll $t0, $s0, 2          # First card offset 
    sll $t1, $s1, 2          # Second card offset
    add $t0, $s2, $t0        # First card address in grid1
    add $t1, $s2, $t1        # Second card address in grid1
    lw $s4, ($t0)            # Load first card string address
    lw $s5, ($t1)            # Load second card string address

    # Save temporary reveal status for second card
    sll $t0, $s1, 2
    add $t0, $s3, $t0
    li $t1, 2                # Temporarily reveal second card
    sw $t1, ($t0)
    
    # Display both cards
    jal display_game_state

    # Compare cards
    move $a0, $s4            # First string address
    move $a1, $s5            # Second string address
    jal compare_strings      # Call string comparison function
    
    # If no match found
    beqz $v0, no_match_found

    # It's a match! Update matched status and score
    sll $t0, $s0, 2
    sll $t1, $s1, 2
    add $t0, $s3, $t0
    add $t1, $s3, $t1
    li $t2, 1                # 1 for permanent match
    sw $t2, ($t0)            # Mark first card as matched
    sw $t2, ($t1)            # Mark second card as matched

    # Play success sound
    lw $a0, success_pitch
    lw $a1, success_duration
    lw $a2, success_instrument
    lw $a3, success_volume
    jal play_sound

    # Show celebration art (alternate between the two)
    lw $t0, matches_found
    addi $t0, $t0, 1        # Increment matches found
    sw $t0, matches_found
    andi $t1, $t0, 1        # Get last bit to alternate
    beqz $t1, show_cele1

    # Show celebration art 2
    li $v0, 4
    la $a0, celebration_art2
    syscall
    j after_cele

show_cele1:
    li $v0, 4
    la $a0, celebration_art1
    syscall

after_cele:
    # Show random match message
    li $v0, 42              # Random int syscall
    li $a0, 0              # Generator 0
    li $a1, 4              # Upper bound (0-3)
    syscall
    
    sll $t0, $a0, 2        # Multiply by 4 to get offset
    la $t1, match_msgs     # Load base of messages array
    add $t1, $t1, $t0      # Add offset
    lw $a0, ($t1)          # Load message address
    li $v0, 4
    syscall

    # Update score and pairs remaining
    lw $t0, score
    addi $t0, $t0, 10      # Add 10 points
    sw $t0, score

    lw $t0, pairs_remaining
    addi $t0, $t0, -1      # Decrease pairs remaining
    sw $t0, pairs_remaining

    # Check if halfway
    li $t1, 4
    bne $t0, $t1, skip_halfway
    
    # Show halfway message
    li $v0, 4
    la $a0, half_way
    syscall

skip_halfway:
    # Display match message
    li $v0, 4
    la $a0, match_found
    syscall
    j move_complete
play_sound:
    # Parameters:
    # $a0 = pitch (0-127)
    # $a1 = duration (ms)
    # $a2 = instrument (0-127)
    # $a3 = volume (0-127)
    
    # Prologue - save ALL registers that could be affected
    addi $sp, $sp, -16
    sw $ra, 12($sp)
    sw $t0, 8($sp)
    sw $v0, 4($sp)     # Important: save $v0 as it contains syscall values
    sw $a0, 0($sp)     # Save original pitch
    
    # First set the instrument
    move $a0, $a2          # Move instrument to $a0 for syscall
    li $v0, 35             # MIDI set instrument syscall
    syscall
    
    # Restore pitch and play the note
    lw $a0, 0($sp)         # Restore original pitch
    li $v0, 31             # MIDI play note syscall
    syscall
    
    # Add a small delay for the sound to play
    move $t0, $a1          # Save duration
    li $v0, 32             # Sleep syscall
    move $a0, $t0          # Move duration to $a0
    syscall
    
    # Epilogue - restore all saved registers
    lw $a0, 0($sp)
    lw $v0, 4($sp)
    lw $t0, 8($sp)
    lw $ra, 12($sp)
    addi $sp, $sp, 16
    jr $ra
    
no_match_found:
    # Save registers that might be affected
    addi $sp, $sp, -8
    sw $v0, 4($sp)
    sw $ra, 0($sp)
    
    # Clear the temporary reveals
    sll $t0, $s0, 2
    add $t0, $s3, $t0
    sw $zero, ($t0)          # Hide first card
    
    sll $t0, $s1, 2
    add $t0, $s3, $t0
    sw $zero, ($t0)          # Hide second card
   
    # Show random no-match message
    li $v0, 42              # Random int syscall
    li $a0, 0              # Generator 0
    li $a1, 4              # Upper bound (0-3)
    syscall
    
    sll $t0, $a0, 2        # Multiply by 4 to get offset
    la $t1, no_match_msgs  # Load base of messages array
    add $t1, $t1, $t0      # Add offset
    lw $a0, ($t1)          # Load message address
    li $v0, 4
    syscall
    
    # Display standard no match message
    li $v0, 4
    la $a0, no_match
    syscall
    
    # Play failure sound
    lw $a0, failure_pitch
    lw $a1, failure_duration
    lw $a2, failure_instrument
    lw $a3, failure_volume
    jal play_sound
    
    # Restore registers
    lw $ra, 0($sp)
    lw $v0, 4($sp)
    addi $sp, $sp, 8
    
    j move_complete
move_complete:
    # Update moves counter
    #lw $t0, moves
    #addi $t0, $t0, 1
    #sw $t0, moves           # Save updated moves count

    # Display updated game state
    jal display_game_state  # This will show moves in the regular display

    # Epilogue
    lw $s5, 0($sp)
    lw $s4, 4($sp)
    lw $s3, 8($sp)
    lw $s2, 12($sp)
    lw $s1, 16($sp)
    lw $s0, 20($sp)
    lw $ra, 24($sp)
    addi $sp, $sp, 28
    jr $ra

# Error handlers
invalid_input1:
    li $v0, 4
    la $a0, invalid_input
    syscall
    j get_first_card

invalid_input2:
    # Clear temporary reveal of first card
    sll $t0, $s0, 2
    add $t0, $s3, $t0
    sw $zero, ($t0)          # Hide first card
   
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
    # Clear temporary reveal of first card
    sll $t0, $s0, 2
    add $t0, $s3, $t0
    sw $zero, ($t0)          # Hide first card
   
    li $v0, 4
    la $a0, already_matched
    syscall
    j get_second_card

same_card_error:
    # Clear temporary reveal of first card
    sll $t0, $s0, 2
    add $t0, $s3, $t0
    sw $zero, ($t0)          # Hide first card
   
    li $v0, 4
    la $a0, same_card
    syscall
    j get_second_card

# Convert string to value
string_to_value:
    # Prologue
    addi $sp, $sp, -16
    sw $ra, 12($sp)
    sw $s0, 8($sp)          # String address
    sw $s1, 4($sp)          # Result
    sw $s2, 0($sp)          # Temp storage

    move $s0, $a0           # Save string address
    li $s1, 0              # Initialize result

    # First, try to find multiplication 'x'
    li $t2, 0              # Position counter
    move $t3, $s0          # Working copy of string address

find_x:
    lb $t0, ($t3)          # Load character
    beqz $t0, convert_direct # End of string, must be direct number
    beq $t0, 32, convert_direct # Space found, must be direct number
    li $t1, 'x'
    beq $t0, $t1, handle_multiplication # 'x' found
    addi $t2, $t2, 1       # Increment position counter
    addi $t3, $t3, 1       # Move to next character
    j find_x

convert_direct:
    # Convert direct number
    move $t3, $s0          # Reset to start of string
convert_loop:
    lb $t0, ($t3)          # Load character
    beq $t0, 32, convert_end   # Check for space
    beqz $t0, convert_end      # Check for null
    bltu $t0, '0', convert_end # Check if not a number
    bgtu $t0, '9', convert_end
    
    addi $t0, $t0, -48     # Convert ASCII to number
    li $t1, 10
    mul $s1, $s1, $t1      # Multiply current result by 10
    add $s1, $s1, $t0      # Add new digit
    
    addi $t3, $t3, 1       # Move to next character
    j convert_loop

handle_multiplication:
    # Get first number (before 'x')
    li $t4, 0              # First number
    move $t3, $s0          # Reset to start of string

first_number_loop:
    lb $t0, ($t3)          # Load character
    li $t1, 'x'
    beq $t0, $t1, handle_second_number  # Found 'x'
    addi $t0, $t0, -48     # Convert ASCII to number
    li $t1, 10
    mul $t4, $t4, $t1      # Multiply current by 10
    add $t4, $t4, $t0      # Add new digit
    addi $t3, $t3, 1       # Move to next character
    j first_number_loop

handle_second_number:
    addi $t3, $t3, 1       # Skip past 'x'
    li $t5, 0              # Second number

second_number_loop:
    lb $t0, ($t3)          # Load character
    beq $t0, 32, multiply_numbers   # Space found
    beqz $t0, multiply_numbers      # End of string
    addi $t0, $t0, -48     # Convert ASCII to number
    li $t1, 10
    mul $t5, $t5, $t1      # Multiply current by 10
    add $t5, $t5, $t0      # Add new digit
    addi $t3, $t3, 1       # Move to next character
    j second_number_loop

multiply_numbers:
    mul $s1, $t4, $t5      # Multiply the two numbers

convert_end:
    move $v0, $s1          # Return result

    # Epilogue
    lw $s2, 0($sp)
    lw $s1, 4($sp)
    lw $s0, 8($sp)
    lw $ra, 12($sp)
    addi $sp, $sp, 16
    jr $ra

    

end_game:
    # Display goodbye message
    li $v0, 4
    la $a0, goodbye_msg
    syscall
    
    # Exit program
    li $v0, 10
    syscall
# Compare strings by evaluating their values
compare_strings:
    # Prologue
    addi $sp, $sp, -20
    sw $ra, 16($sp)
    sw $s0, 12($sp)        # First string
    sw $s1, 8($sp)         # Second string
    sw $s2, 4($sp)         # First value
    sw $s3, 0($sp)         # Second value

    # Save string addresses
    move $s0, $a0
    move $s1, $a1

    # Convert first string to value
    move $a0, $s0
    jal string_to_value
    move $s2, $v0          # Save first value

    # Convert second string to value
    move $a0, $s1
    jal string_to_value
    move $s3, $v0          # Save second value

    # Compare values
    seq $v0, $s2, $s3      # Set $v0 to 1 if values are equal

    # Epilogue
    lw $s3, 0($sp)
    lw $s2, 4($sp)
    lw $s1, 8($sp)
    lw $s0, 12($sp)
    lw $ra, 16($sp)
    addi $sp, $sp, 20
    jr $ra

# Check if game is over
check_game_over:
    # Prologue
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $s0, 0($sp)

    # Load pairs remaining
    lw $s0, pairs_remaining
    
    # Check if all pairs found
    beqz $s0, game_is_over
    
    # Game not over
    li $v0, 0
    j check_done

game_is_over:
    # Display game over message
    li $v0, 4
    la $a0, game_over
    syscall
    
    # Game is over
    li $v0, 1

check_done:
    # Epilogue
    lw $s0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra

# Display final results
display_final_results:
    # Prologue
    addi $sp, $sp, -24       # Space for 6 registers
    sw $ra, 20($sp)
    sw $s0, 16($sp)         # For calculations
    sw $s1, 12($sp)         # For minutes
    sw $s2, 8($sp)          # For seconds
    sw $s3, 4($sp)          # For start time low
    sw $s4, 0($sp)          # For start time high

    # Get end time
    li $v0, 30              # System time in milliseconds
    syscall                 # Time in $a0 (low) and $a1 (high)
    
    # Load start time
    lw $s3, start_time_low      # Load low word
    lw $s4, start_time_high    # Load high word
    
    # Calculate elapsed time in milliseconds
    subu $s0, $a0, $s3      # Subtract low words
    
    # Convert to seconds
    div $s0, $s0, 1000      # Convert milliseconds to seconds
    mflo $s0                # Get seconds result
    
    # Calculate minutes and seconds
    li $t0, 60
    div $s0, $t0            # Divide total seconds by 60
    mflo $s1                # Minutes in $s1
    mfhi $s2                # Seconds in $s2

    # Print game over message
    li $v0, 4
    la $a0, game_over
    syscall
    
    # Print divider
    la $a0, divider
    syscall

    # Display final score
    la $a0, score_msg
    syscall
    li $v0, 1
    lw $a0, score
    syscall
    
    # Print newline
    li $v0, 4
    la $a0, newline
    syscall

    # Print newline
    li $v0, 4
    la $a0, newline
    syscall
    
    # Display elapsed time
    la $a0, time_msg
    syscall
    
    # Print minutes with leading zero if needed
    li $v0, 1
    move $a0, $s1
    bge $s1, 10, print_minutes
    
    # Print leading zero for minutes
    li $v0, 4
    la $a0, zero
    syscall
    li $v0, 1
    move $a0, $s1
    
print_minutes:
    syscall
    
    # Print colon
    li $v0, 4
    la $a0, colon
    syscall
    
    # Print seconds with leading zero if needed
    li $v0, 1
    move $a0, $s2
    bge $s2, 10, print_seconds
    
    # Print leading zero for seconds
    li $v0, 4
    la $a0, zero
    syscall
    li $v0, 1
    move $a0, $s2
    
print_seconds:
    syscall
    
    # Print final newline
    li $v0, 4
    la $a0, newline
    syscall

    # Epilogue
    lw $s4, 0($sp)
    lw $s3, 4($sp)
    lw $s2, 8($sp)
    lw $s1, 12($sp)
    lw $s0, 16($sp)
    lw $ra, 20($sp)
    addi $sp, $sp, 24
    jr $ra

