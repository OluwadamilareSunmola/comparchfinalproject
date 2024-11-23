# data.asm - Data segment for Math Memory Master game
.data
    # ASCII Art
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
    
    # Error messages
    invalid_char: .asciiz "\nPlease enter only numbers!\n"

    # Timer and game messages
    move_time_msg: .asciiz "\n\nTime Elapsed Between Your Inputs:  "
    time_format: .asciiz ":"
    time_zero: .asciiz "0"
    restart_prompt: .asciiz "\n\n\n\nWould you like to play again? (1 for yes, 0 for no): "
    invalid_restart: .asciiz "\nPlease enter 0 or 1 only.\n"
    goodbye_msg: .asciiz "\n\nThanks for playing! Goodbye!\n"
    
    # Timer variables
    time_msg: .asciiz "Total Time elapsed: "
    colon: .asciiz ":"
    zero: .asciiz "0"
    
    # UI elements
    divider: .asciiz "\n----------------------------------------\n"
    newline: .asciiz "\n"
    card_separator: .asciiz " | "
    hidden_card: .asciiz "*    "
    card_top: .asciiz "???????\n"
    card_bottom: .asciiz "???????\n"
    
    # No match messages
    no_match_msg1: .asciiz "\n    ¯\\_(?)_/¯ Try Again!\n"
    no_match_msg2: .asciiz "\n    (•_•) Not Quite...\n"
    no_match_msg3: .asciiz "\n    (???) Almost...\n"
    no_match_msg4: .asciiz "\n    (._.) Keep Going!\n"

    # Game prompts and messages
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

    # Card values - equations and their answers
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

    # Arrays
    .align 2
    grid1: .word 0:16
    no_match_msgs: .word no_match_msg1, no_match_msg2, no_match_msg3, no_match_msg4

    # Sound effect settings
    success_duration: .word 1200
    failure_duration: .word 1600
    success_pitch: .word 100
    failure_pitch: .word 290
    success_volume: .word 250
    failure_volume: .word 250
    success_instrument: .word 9
    failure_instrument: .word 114
