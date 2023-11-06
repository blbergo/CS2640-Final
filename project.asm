###############
# Psuedo Code #
###############

# display welcome and tutorial messages
# turn loop:
# 	display who's turn it currently is
#	ask them for input 
#	check if that input is valid 
#	check if the game is over


#####################
# Variable Trackers #
#####################

# $s0 -> turn tracker p1 = 0, p2 = 1
# $s1 -> victory tracker, default = -1, p1 = 0, p2 = 1
# $s2 -> input tracker

# $t0 -> turn tracker indexed at 1
# $t1 -> base address of array 
# $t2 -> current index of array 
.data
	welcome_msg: .asciiz "Welcome to Tic-Tac-Toe!\n"
	tutorial_msg: .asciiz "On your turn, enter [1-9] to a corresponding empty space on the board.\n"
	current_turn: .asciiz "Current player: "
	move_input: .asciiz "\nYour move:"
	grid: .word -1,-1,-1,-1,-1,-1,-1,-1,-1 # -1 = empty space, 0 = Os, 1 = Xs
	
.text
	main:
		#################################
		# Display introduction messages #
		#################################
		
		# display the welcome message
		la $a0, welcome_msg
		li $v0, 4 # 4 is the code to pring out a message
		syscall
		
		# display the tutorial message
		la $a0, tutorial_msg
		li $v0, 4
		syscall
		
		# initiate the turn tracker
		move $s0, $zero
		
		# start the game
		li $s1, -1
		j game_loop
		
	game_loop:
		# TODO: display grid here
		
		# print the current player message
		la $a0, current_turn
		li $v0, 4
		syscall
		
		# print the current player tracker
		move $t0, $s0 # set $t0 to the current player counter
		addi $t0, $t0, 1 # add 1 for 1-based indexing
		
		# print out the 1-index player tracker
		li $v0, 1
		move $a0, $t0
		syscall
		
		# print out the message asking the user for their move
		la $a0, move_input
		li $v0, 4
		syscall
		
		# read the player input
		li $v0, 5
		syscall
		move $a0, $s2
		
		addi $s2, $s2, -1 # adjust for 1-indexing
		
		# TODO: validate user input here using the grid array
		
		# TODO: check the board for win conditions
		
		# swap turns and jump to the top of the loop
		beq $s0, 0, set_turn_2
		beq $s0, 1, set_turn_1		

	set_turn_2:
		li $s0, 1
		beq $s1, -1, game_loop # return to the top of the game loop
		j exit
		
	set_turn_1:
		li $s0, 0
		beq $s1, -1, game_loop # return to the top of the game loop
		j exit
		
	exit:
		li $v0, 10 # 10 is the code to exit
		syscall