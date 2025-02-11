                                    
#	 ,----.                             
#	'  .-./    ,--,--.,--,--,--. ,---.  
#	|  | .---.' ,-.  ||        || .-. : 
#	'  '--'  |\ '-'  ||  |  |  |\   --. 
#	 `------'  `--`--'`--`--`--' `----' 
#	 	          ,---.                       
#		   ,---. /  .-'                       
#		  | .-. ||  `-,                       
#		  ' '-' '|  .-'                       
#		   `---' `--'                         
#	     ,--.   ,--. ,---.                   
#	     |  |   `--'/  .-' ,---.             
#	     |  |   ,--.|  `-,| .-. :            
#	     |  '--.|  ||  .-'\   --.            
#	     `-----'`--'`--'   `----'   

# 	Victor Paiva Torres 	<vpaivatorres@gmail.com>
#	February 23, 2015	Natal, RN - Brazil
#	MIPS Assembly		Mars Simulator 4.5

############################################################
#							   #
#	Display Array & Auxiliar Array			   #
#							   #
############################################################
#							   #
#	64 columns 	width pixels			   #
#	64 rows 	height pixels			   #
#							   #
#	Space needed: 64 * 64 * 4 bytes (32 bits)	   #
#							   #
#	Base address: 0x10010000 (static data)	 	   #
#							   #
############################################################

.data

	displayArray:
		.space 0x4000
	
	auxiliarArray:
		.space 0x4000

############################################################
#							   #
#	Populate Auxiliar Array 			   #
#							   #
############################################################

.text

main:
# player_setup: Initializes the board to all dead cells and
#sets up the highlighted cell for the player to move and toggle cells
player_setup:
	# Clear both arrays so that all 4096 cells are dead
	jal	clear_arrays
	
	# Initialize highlighted cell position
	# $s0 = current column(x) and $s1 = current row(y)
	li	$s0, 0		
	li	$s1, 0		
	
	jal	draw_board
	
player_setup_loop:
	# Read a character from the keyboard (syscall 12)
	li	$v0, 12		# syscall code for read char
	syscall
	move	$t0, $v0	# store input character in $t0
	
	# If Enter(10) is pressed, start simulation
	li	$t1, 10
	beq	$t0, $t1, start_simulation
	
	# If Space(32) is pressed, toggle cell state
	li	$t1, 32
	beq	$t0, $t1, toggle_and_redraw
	
	# Check WASD keys for movement:
	# w(119) = up
	li	$t1, 119
	beq	$t0, $t1, move_up
	# s(115) = down
	li	$t1, 115
	beq	$t0, $t1, move_down
	# a(97) = left
	li	$t1, 97
	beq	$t0, $t1, move_left
	# d(100) = right
	li	$t1, 100
	beq	$t0, $t1, move_right
	
player_setup_redraw:
	jal	draw_board
	j	player_setup_loop

# move_up: If not at the top edge, decrement row (y).
move_up:
	# Check if row > 0
	bgtz	$s1, decrement_y
	j	player_setup_redraw
decrement_y:
	addi	$s1, $s1, -1
	j	player_setup_redraw

# move_down: If not at the bottom edge (row 63), increment row.
move_down:
	li	$t1, 63
	bge	$s1, $t1, player_setup_redraw
	addi	$s1, $s1, 1
	j	player_setup_redraw

# move_left: If not at the left edge, decrement column (x).
move_left:
	bgtz	$s0, decrement_x
	j	player_setup_redraw
decrement_x:
	addi	$s0, $s0, -1
	j	player_setup_redraw

# move_right: If not at the right edge (column 63), increment column.
move_right:
	li	$t1, 63
	bge	$s0, $t1, player_setup_redraw
	addi	$s0, $s0, 1
	j	player_setup_redraw

# toggle_and_redraw: Toggles the state of the highlighted cell,
#then redraws the board.
toggle_and_redraw:
	jal	toggle_cell
	j	player_setup_redraw

# start_simulation: Called when the user presses Enter.
#Jumps to the simulation routine using the current board.
start_simulation:
	j	display

# clear_arrays: Clears all cells in both arrays.
clear_arrays:
	# Clear auxiliarArray first
	li	$t0, 0x4000	# total number of bytes in the array
	li	$t1, 0		# offset 
	la	$t2, auxiliarArray
clear_aux_loop:
	bge	$t1, $t0, clear_display_loop
	sw	$zero, 0($t2)	# store 0 in current cell
	addi	$t2, $t2, 4
	addi	$t1, $t1, 4
	j	clear_aux_loop

clear_display_loop:
	# Clear displayArray
	li	$t0, 0x4000
	li	$t1, 0
	la	$t2, displayArray
clear_disp_loop:
	bge	$t1, $t0, clear_end
	sw	$zero, 0($t2)
	addi	$t2, $t2, 4
	addi	$t1, $t1, 4
	j	clear_disp_loop
clear_end:
	jr	$ra

# draw_board: Copies the auxiliar array into the display array,
#then turns the currently highlighted cell with white.
draw_board:
	# Copy auxiliarArray into displayArray
	li	$t0, 0x4000	# total bytes to copy
	li	$t1, 0		# offset
	la	$t2, displayArray
	la	$t3, auxiliarArray
draw_loop:
	bge	$t1, $t0, highlight_cell
	add	$t4, $t3, $t1
	lw	$t5, 0($t4)
	add	$t6, $t2, $t1
	sw	$t5, 0($t6)
	addi	$t1, $t1, 4
	j	draw_loop
# turn highlighted cell white
highlight_cell:
	# offset = (y * 64 + x) * 4
	li	$t7, 64
	mul	$t8, $s1, $t7	# t8 = y * 64
	add	$t8, $t8, $s0	# t8 = (y * 64 + x)
	sll	$t8, $t8, 2	# *4 to get byte offset
	la	$t9, displayArray
	add	$t9, $t9, $t8
	li	$s7, 0xffffffff	# white
	sw	$s7, 0($t9)
	jr	$ra

# toggle_cell: changes the state of the highlighted cell
toggle_cell:
	# offset = (y * 64 + x) * 4
	li	$t7, 64
	mul	$t8, $s1, $t7
	add	$t8, $t8, $s0
	sll	$t8, $t8, 2
	la	$t9, auxiliarArray
	add	$t9, $t9, $t8
	lw	$t0, 0($t9)
	# If cell is dead then make it live, otherwise kill it.
	beq	$t0, $zero, make_live
	li	$t0, 0
	j	store_cell
make_live:
	li	$t0, 0xffffffff
store_cell:
	sw	$t0, 0($t9)
	# update displayArray
	la	$t9, displayArray
	add	$t9, $t9, $t8
	sw	$t0, 0($t9)
	jr	$ra

# Original Populate Auxiliary Array code (generates random game)
	
	#random_number:
	#sw	$a0,	0($s0)
	#li	$a1,	2
	#li 	$v0,	42
	#syscall
	#jr	$ra
	
	#populate:
	#li	$t0,	0x4000
	#addi	$t1,	$zero, 	0
	#la	$t2,	auxiliarArray
	#addi	$t3,	$zero, 	-1
	
	#populate_loop:
	#bgt	$t1,	$t0,	display
	#jal	random_number
	#mul	$a0, 	$a0, 	$t3
	#add	$t4,	$t2, 	$t1
	#sw	$a0,	0($t4)
	#addiu	$t1, 	$t1, 	4
	#j	populate_loop	
	
############################################################
#							   #
#	Populate Display Array 				   #
#							   #
############################################################

	display:
	li	$t0,	0x4000
	addi	$t1,	$zero, 	0
	la	$t2,	displayArray
	la	$t3,	auxiliarArray
	
	display_loop:
	bgt	$t1, 	$t0, 	update
	add	$t4,	$t3, 	$t1
	lw	$t5,	0($t4)
	add	$t4,	$t2, 	$t1
	sw	$t5,	0($t4)
	addiu	$t1,	$t1, 	4
	j	display_loop
	
############################################################
#							   #
#	Update Auxiliar Array				   #
#							   #
############################################################
#							   #
#	- Any live cell with fewer than 		   #
#	  two live neighbours dies, as 			   #
#	  if caused by under-population.		   #
#							   #
#	- Any live cell with two or three 		   #
#	  live neighbours lives on to the 		   #
#	  next generation.			  	   #
#							   #
#	- Any live cell with more than three 		   #
#	  live neighbours dies, as if by 		   #
#	  overcrowding.					   #
#							   #
#	- Any dead cell with exactly three 		   #
#	  live neighbours becomes a live 		   #
#	  cell, as if by reproduction.			   #
#							   #
############################################################
	
	verify:
	lw	$a1,	0($a0)
	addi	$a2,	$zero, 	0
	la	$s4,	displayArray
	la	$s5,	auxiliarArray
	addi	$s5,	$s5,	-0x4
	
	verify_1:
	li	$s2,	0xffffffff
	addi	$a3,	$a0,	-0x104
	blt	$a3,	$s4,	verify_2
	lw	$s1,	0($a3)
	seq	$s2,	$s1,	$s2
	add	$a2,	$a2,	$s2
	
	verify_2:
	li	$s2,	0xffffffff
	addi	$a3,	$a0,	-0x100	# Correct offset -0xd8 -> -0x100 (256 bytes up)
	blt	$a3,	$s4,	verify_3
	lw	$s1,	0($a3)
	seq	$s2,	$s1,	$s2
	add	$a2,	$a2,	$s2
	
	verify_3:
	li	$s2,	0xffffffff
	addi	$a3,	$a0,	-0xfc
	blt	$a3,	$s4,	verify_4
	lw	$s1,	0($a3)
	seq	$s2,	$s1,	$s2
	add	$a2,	$a2,	$s2
	
	verify_4:
	li	$s2,	0xffffffff
	addi	$a3,	$a0,	-0x4
	blt	$a3,	$s4,	verify_5
	lw	$s1,	0($a3)
	seq	$s2,	$s1,	$s2
	add	$a2,	$a2,	$s2
	
	verify_5:
	li	$s2,	0xffffffff
	addi	$a3,	$a0,	0x4
	bgt	$a3,	$s5,	verify_6
	lw	$s1,	0($a3)
	seq	$s2,	$s1,	$s2
	add	$a2,	$a2,	$s2
	
	verify_6:
	li	$s2,	0xffffffff
	addi	$a3,	$a0,	0xfc
	bgt	$a3,	$s5,	verify_7
	lw	$s1,	0($a3)
	seq	$s2,	$s1,	$s2
	add	$a2,	$a2,	$s2
	
	verify_7:
	li	$s2,	0xffffffff
	addi	$a3,	$a0,	0x100	# Correct offset 0xd8 -> 0x100 (256 bytes down)
	bgt	$a3,	$s5,	verify_8
	lw	$s1,	0($a3)
	seq	$s2,	$s1,	$s2
	add	$a2,	$a2,	$s2
	
	verify_8:
	li	$s2,	0xffffffff
	addi	$a3,	$a0,	0x104
	bgt	$a3,	$s5,	verify_condition
	lw	$s1,	0($a3)
	seq	$s2,	$s1,	$s2
	add	$a2,	$a2,	$s2
	
	verify_condition:	
	beq	$a1,	$zero,	verify_false
	j	verify_true
	
	verify_true:
	blt	$a2,	2,	verify_dies
	blt	$a2,	4,	verify_lives
	j	verify_dies
	
	verify_false:
	beq	$a2,	3,	verify_lives
	j	verify_dies
	
	verify_lives:
	addi	$s1,	$a0,	0x4000
	li	$s2,	0xffffffff
	sw	$s2,	0($s1)
	j	verify_end
	
	verify_dies:
	addi	$s1,	$a0,	0x4000
	li	$s2,	0x0
	sw	$s2,	0($s1)
	j	verify_end
	
	verify_end:
	jr	$ra

	update:
	li	$t0,	0x4000
	addi	$t1,	$zero, 	0
	la	$t2,	displayArray
	la	$t3,	auxiliarArray
	li	$t4,	0
	
	update_loop:
	bgt	$t1, 	$t0, 	display
	add	$a0, 	$t2,	$t1
	jal	verify
	addiu	$t1,	$t1, 	4
	j	update_loop
