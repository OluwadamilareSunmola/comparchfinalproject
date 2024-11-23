.include "init.asm"        # Contains the initialization functions
.include "display.asm"     # Contains display-related functions
.include "input.asm"       # Contains functions to handle input
.include "utility.asm"     # Contains utility functions like shuffle, compare, etc.
.include "sound.asm"
.include "timer.asm"
.include "data.asm"

.extern local 4

.text
.globl main

main:
    jal game_start           # Jump and link to game_start (this is the correct way)

game_start:
    jal init_game            # Call init_game to initialize the game
    
game_loop:
    jal display_game_state   # Display the current game state
    jal get_player_move      # Handle player input
    jal check_game_over      # Check if the game is over
    beq $v0, $zero, game_loop # If the game is not over, loop again

end_game:
    li $v0, 4                # Print the goodbye message
    la $a0, goodbye_msg      # Load the address of the goodbye message
    syscall                  # System call to print the message
    li $v0, 10               # Exit system call
    syscall                  # Exit the program
