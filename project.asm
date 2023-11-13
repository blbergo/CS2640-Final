.data
	msgIntro: .asciiz "Welcome to tic tac toe"
	Play1: .asciiz "Player 1's turn: (Choose a number between 1-9) "
	Play2: .asciiz "Player 2's turn: (Choose a number between 1-9) "
	
	DRAW: .asciiz "Draw."
	row1: .asciiz "1 2 3"
	row2: .asciiz "4 5 6"
	row3: .asciiz "7 8 9"
	rule: .asciiz "Enter the location[1-9] to play the games."
	rule1: .asciiz "Each number on the board can NOT be repeated more than once." 
	rule2: .asciiz "Player 1: X and Player 2: O"
	grid: .space 9  # We use grid to store the array of tic-tac-toe 3x3 (9 bytes)
	player1win: .asciiz "Player 1 has won!"
	player2win: .asciiz "Player 2 has won!"
	turn_tracker: .word 0  # Initialize the turn tracker to 0 (Player 1's turn)

.text

#display the main and guide the player to play the games
main:
	li $s4, 0 # Initialize the move counter
	j displaysample # Jump to displaysample

displaysample:
	la $a0, msgIntro   # Display intro message 
	li $v0, 4
	syscall
	jal newline

	la $a0, row1
	li $v0, 4
	syscall

	jal newline

	la $a0, row2
	li $v0, 4
	syscall

	jal newline

	la $a0, row3
	li $v0, 4
	syscall

	jal newline

	la $a0, rule
	li $v0, 4
	syscall

	jal newline

	la $a0, rule1
	li $v0, 4
	syscall

	jal newline

	la $a0, rule2
	li $v0, 4
	syscall

	jal turn # Start with Player 1's turn


turn:
    jal newline
    lw $t0, turn_tracker  # Load the current turn tracker value
    beq $t0, 0, play1  # If it's Player 1's turn (0), go to play1
    beq $t0, 1, play2  # If it's Player 2's turn (1), go to play2


play1:
    la $a0, Play1
    li $v0, 4
    syscall
    
    jal play
    
    li $t0, 1  # Set the turn tracker to 1 (Player 2's turn)
    sw $t0, turn_tracker
    jal newline
  
play2:
    la $a0, Play2
    li $v0, 4
    syscall

    li $t0, 0  # Set the turn tracker to 0 (Player 1's turn)
    sw $t0, turn_tracker
    jal newline
    jal play


play:
    jal newline

    beq $s4, 9, draw   # If $s4 is equal to 9, draw the board

    jal getinput
    jal checkinput
    j storeinput

draw:
	jal newline
	la $a0, DRAW
	li $v0, 4
	syscall
	j exit

#get input from user
getinput:
	li $v0, 5 # Read the location from the player
	syscall
	
	li $s2, 0 # Load 0 into register $s2
	add $s2, $s2, $v0 # Add the location and save to $s2
	
	jr $ra # Return to the previous function

#check the input is it within the range of [1-9] or not
checkinput:
	la $t1, grid  # Load the grid address
	add $t1, $t1, $s2 # Add $s2 to $t1 to get the exact location
	lb $t2, ($t1) # Load the value at $t1 into $t2
	bne $t2, 0, turn # If $t2 != 0, jump to play
	bge $s2, 10, turn # If $s2 >= 10, jump to play
	ble $s2, 0, turn # If $s2 <= 0, jump to play
	jr $ra # Return to function 

#store the input into grid	
storeinput:
    addi $s4, $s4, 1 # Increment $s4 for every turn
    beq $s3, 0, storex # If player 1's turn jump to storex
    beq $s3, 1, storeo
    
    
storex:
    
    la $t1, grid #load the grid
    add $t1, $t1, $s2 #add $s2 location to $t1 to get the exact location
    
    li $t2, 1  #Set t2 = 1
    
    sb $t2, ($t1) #store $t1 to $t2
    li $s3, 1 #change the turn to player 2
    j display #jump to display

storeo:
    
    la $t1, grid  
    add $t1, $t1, $s2
    
    li $t2, 2
    
    sb $t2, ($t1)
    li $s3, 0 #change the turn to player 1
    j display

#initial display
display:
    li $s0, 0 # Initialize $s0 to 0
    li $s1, 0 # Initialize $s1 to 0
    j displayline  # Jump to displayline

#to display newline for displaying the grid
displayline:
    addi $s1, $s1, 3 # Add 3 to $s1 to ensure every 3 outputs make a new line
    jal newline
    j displaygrid  # Jump to display grid



#displaying all the information in grid
displaygrid:
    beq $s0, 9, DIAG
    beq $s0, $s1, displayline
    addi $s0, $s0, 1  # Increment $s0
    la $t2, grid  # Load the current grid address
    add $t2, $t2, $s0  # Add $s0 to the address to access the current grid element
    lb $t3, ($t2)  # Load the byte at the grid location
    jal addspace  # Add space
    beq $t3, 0, displayspace  # If the value at $t3 is 0, jump to displayspace
    beq $t3, 1, displayx  # If $t3 is 1, jump to displayx (for 'X')
    beq $t3, 2, displayo  # If $t3 is 2, jump to displayo (for 'O')
#to display 1 to x
displayx:
	li $a0, 88 #load x
	li $v0, 11 #print x
	syscall
	j displaygrid

#to display 2 to O
displayo:
	li $a0, 79 #load O
	li $v0, 11 #print O
	syscall
	j displaygrid
	
#to display ? if the value in grid is 0
displayspace:
    la $t1, grid  # Load the grid address
    add $t1, $t1, $s0  # Add $s0 to $t1 to get the current grid position
    lb $t2, ($t1)  # Load the value at the current grid position
    beq $t2, 0, displayempty  # If the value at $t2 is 0, jump to displayempty
    j displaygrid  # Otherwise, jump back to display grid

#to display empty space (modify as needed)
displayempty:
    li $a0, 63  # Load '?' (ASCII code) into $a0 (you can replace 63 with the ASCII code for the character you want)
    li $v0, 11  # Print character
    syscall
    j displaygrid  # Jump back to display grid

# use jal DIAG to link current address and then jump to label, use jr $ra to jump back to where label was called
DIAG:
    la $t0, grid   # load address of the board
    lb $t1, 0($t0) # load the 1st square, position 1
    lb $t2, 4($t0) # load the 2nd square, position 5
    lb $t3, 8($t0) # load the 3rd square, position 9
    bne $t1, $t2, DIAG2 # check if square 1 and 2 are equal
    bne $t1, $t3, DIAG2 # check if square 1 and 3 are equal
    j WINNER   # there is a winner
DIAG2:
    lb $t1, 2($t0) # load the 1st square, position 3
    lb $t2, 4($t0) # load the 2nd square, position 5
    lb $t3, 6($t0) # load the 3rd square, position 7
    bne $t1, $t2, DIAGN # check if square 1 and 2 are equal
    bne $t1, $t3, DIAGN # check if square 1 and 3 are equal
    j WINNER   # there is a winner
DIAGN:
    jr $ra   # jump to where the label was called
WINNER:
    beq $t1, 1, player1wins
    beq $t1, 2, player2wins
player1wins:
			la $a0, player1win
			li $v0, 4
			syscall
			j exit
			
player2wins:
			la $a0, player2win
			li $v0, 4
			syscall
			j exit
		
		j exit

# use jal ROW to link current address and then jump to label, use jr $ra to jump back to where label was called
ROW:
    la $t0, grid   # load address of the board
    lb $t1, 0($t0) # load the 1st square, position 1
    lb $t2, 1($t0) # load the 2nd square, position 2
    lb $t3, 2($t0) # load the 3rd square, position 3
    bne $t1, $t2, ROW2 # check if square 1 and 2 are equal
    bne $t1, $t3, ROW2 # check if square 1 and 3 are equal
    j WINNER   # there is a winner
ROW2:
    lb $t1, 3($t0) # load the 1st square, position 4
    lb $t2, 4($t0) # load the 2nd square, position 5
    lb $t3, 5($t0) # load the 3rd square, position 6
    bne $t1, $t2, ROW3 # check if square 1 and 2 are equal
    bne $t1, $t3, ROW3 # check if square 1 and 3 are equal
    j WINNER   # there is a winner
ROW3:
    lb $t1, 6($t0) # load the 1st square, position 7
    lb $t2, 7($t0) # load the 2nd square, position 8
    lb $t3, 8($t0) # load the 3rd square, position 9
    bne $t1, $t2, WIN  # check if square 1 and 2 are equal
    bne $t1, $t3, WIN  # check if square 1 and 3 are equal
    j WINNER   # there is a winner
WIN:
    jr $ra   # jump to where the label was called
#to make new line	
newline:
	li $a0, 10 #load line
	li $v0, 11 #print line
	syscall
	jr $ra

#to make space
addspace:
	li $a0, 32 #load space
	li $v0, 11 #print space
	syscall
	jr $ra
	
	
#exit the program
exit:
	li $v0, 10
	syscall