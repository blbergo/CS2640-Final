#data that initialized
.data
	msgIntro: .asciiz "Welcome to tic tac toe"
	p1: .asciiz "Player 1's turn: (Choose a number between 1-9) "
	p2: .asciiz "Player 2's turn: (Choose a number between 1-9) "
	win1: .asciiz "Player 1 win."
	win2: .asciiz "Player 2 win."
	lastdraw: .asciiz "Draw."
	line1: .asciiz "1 2 3"
	line2: .asciiz "4 5 6"
	line3: .asciiz "7 8 9"
	guide: .asciiz "Enter the location[1-9] to play the games."
	guide1: .asciiz "Each number on the board can NOT be repeated more than once." 
	guide2: .asciiz "Player 1: X and Player 2: O"
	grid: .asciiz  #we use grid to store the array of tic-tac-toe 3x3
	
.text

#display the main and guide the player to play the games
main:
	li $s3, 0
	li $s4, 0
	la $a0, msgIntro
	li $v0, 4
	syscall
	jal newline
	
	j displaysample #jump to displaysample

#to determine the turn of player 1 and player 2
turn:
	jal newline
	beq $s3, 0, play1 #0 for player 1
	beq $s3, 1, play2 #1 for player 2

#manage player 1's turn	
play1:
	la $a0, p1 #Display message for player 1's turn 
	li $v0, 4
	syscall
	
	jal newline
	j play #jump to play

#manage player 2's turn	
play2:
	la $a0, p2  #Display message for player 2's turn 
	li $v0, 4
	syscall
	
	jal newline
	j play #jump to play

#manage the game. this function will jumep to three function: getinput, checkinput and storeinput
play:
	jal newline
	
	beq $s4, 9, draw   # if $s4 is equal to 9, draw the board 
	
	jal getinput  #Get player's input
	jal checkinput #make sure the player's input is valid
	j storeinput 

draw:
	jal newline
	la $a0, lastdraw
	li $v0, 4
	syscall
	j end

#display the initial sample(location of the tic-tac-toe[1-9])
#load and display line1, line2, line3, line4
displaysample:
	la $a0, line1  #Display first line of the initial board
	li $v0, 4
	syscall
	
	jal newline
	
	la $a0, line2  #Display second line of the initial board
	li $v0, 4
	syscall
	
	jal newline
	
	la $a0, line3	#Display third line of the initial board
	li $v0, 4
	syscall
	
	jal newline
	
	la $a0, guide #Display rule0
	li $v0, 4
	syscall
	
	jal newline
	
	la $a0, guide1	#Display rule1
	li $v0, 4
	syscall
	
	jal newline
	
	la $a0, guide2	#Display rule2
	li $v0, 4
	syscall
	
	j turn #jump to turn 
	
#initial display
display:
	li $s0, 0 #set $s0 to 0
	li $s1, 0 #set $s1 to 1
	j displayline #jump to displayline

#to display newline for displaying grid
displayline:
	addi $s1, $s1, 3 #add $s1 + 3 to make sure every 3 output make a new line
	
	jal newline
	j displaygrid #jump to disply grid

#displaying all the information in grid
displaygrid:
	
	beq $s0, $s1, displayline
	addi $s0, $s0, 1 #increment $s0
	la $t2, grid #load the current grid address
	add $t2, $t2, $s0  #add the address with $s0
	lb $t3, ($t2) #load byte of $t2 to $t3
	jal addspace #to make space
	beq $t3, 0, displayspace #if the value in $t3==0 jump to displayspace
	beq $t3, 1, displayx #if $t3==1 jump to displayx
	beq $t3, 2, displayo #if $t3==2 jump to displayo

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
    li $a0, 63  # Load '?' (ASCII code) into $a0
    li $v0, 11  # Print character
    syscall
    j displaygrid  # Jump back to display grid	


#get input from user
getinput:
	li $v0, 5 #read the location from player
	syscall
	li $s2, 0 #loads the value of 0 into register 2
	add $s2, $s2, $v0 #add the location to and save to $s2
	jr $ra #return to previous function

#check the input is it within the range of [1-9] or not
checkinput:
	la $t1, grid  #load the grid address
	add $t1, $t1, $s2 #add the $s2 to $t1 to get the exact location
	lb $t2, ($t1) #load the $t1 into $t2
	bne $t2, 0, turn # check if $t2!=0 jump to turn
	bge $s2, 10, turn # check if $s2 >= 10, jump to turn
	ble $s2, 0, turn # check if $s2 <= 0, jump to turn
	jr $ra #return to previous function

#store the input into grid	
storeinput:
	addi $s4, $s4, 1 #increment $s4 for every turn
	beq $s3, 0, storex #if player 1's turn jump to storex
	beq $s3, 1, storeo #if player 2's turn jump to storeo

#to store the player 1's turn
storex:
	la $t1, grid #load the grid
	add $t1, $t1, $s2 #add $s2 location to $t1 to get the exact location of player 1s element in the grid
	li $t2, 1 #loads value 2 into register 2
	sb $t2, ($t1) #store $t1 to $t2
	li $s3, 1 #change the turn to player 2
	j display #jump to display
	
#to store the player 2's turn
storeo:
	la $t1, grid #loading address of an array/grid to $t1
	add $t1, $t1, $s2 #adds the value stored in register $s2 to the address stored in register $t1. calculates the address of an element in the "grid" that correspons to player 2s turn 
	li $t2, 2 #loads value 2 into register 2
	sb $t2, ($t1)#store $t1 to $t2
	li $s3, 0 #change the turn to player 1
	j display #jump to display



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
end:
	li $v0, 10
	syscall