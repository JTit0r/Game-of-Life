
	 ,----.                             
	'  .-./    ,--,--.,--,--,--. ,---.  
	|  | .---.' ,-.  ||        || .-. : 
	'  '--'  |\ '-'  ||  |  |  |\   --. 
	 `------'  `--`--'`--`--`--' `----' 
	 		          ,---.                       
			   ,---. /  .-'                       
			  | .-. ||  `-,                       
			  ' '-' '|  .-'                       
			   `---' `--'                         
	    ,--.   ,--. ,---.                   
	    |  |   `--'/  .-' ,---.             
	    |  |   ,--.|  `-,| .-. :            
	    |  '--.|  ||  .-'\   --.            
	    `-----'`--'`--'   `----'   

 	-----------------------------------------------------
 	
 	Victor Paiva Torres 	<vpaivatorres@gmail.com>
	February 23, 2015		Natal, RN - Brazil
 
 	Davi Komori Araujo 	<davi.komori@unifesp.br>
 	Gabriela C. M. dos Santos 	<gabriela.moreira@unifesp.br>
 	João V. G. Dantas 	<dantas.joao@unifesp.br>
 	Laura da S. Morgado 	<laura.morgado@unifesp.br>
	February 18, 2025	São José dos Campos, SP - Brazil
 
	MIPS Assembly			Mars Simulator 4.5
	
	-----------------------------------------------------
	
		The Game of Life, also known simply as Life, 
	is a cellular automaton devised by the British 
	mathematician John Horton Conway in 1970.

		The "game" is a zero-player game, meaning 
	that its evolution is determined by its initial 
	state, requiring no further input. One interacts 
	with the Game of Life by creating an initial 
	configuration and observing how it evolves or, 
	for advanced players, by creating patterns with 
	particular properties.
	
	See more: http://en.wikipedia.org/wiki/Conway's_Game_of_Life
	
	-----------------------------------------------------
	
	- Any live cell with fewer than 		   
	  two live neighbours dies, as 			   
	  if caused by under-population.		   
							   
	- Any live cell with two or three 		   
	  live neighbours lives on to the 		   
	  next generation.			  	   
							   
	- Any live cell with more than three 		   
	  live neighbours dies, as if by 		   
	  overcrowding.					   
							   
	- Any dead cell with exactly three 		   
	  live neighbours becomes a live 		   
	  cell, as if by reproduction.	
	
	-----------------------------------------------------
			CONTROLS
 
 	- Press 1 to choose player-setup mode,
  	  allowing for setup of initial conditions for
     	  the simulation.
	
	- Press 2 to generate a random board and run the
 	  simulation.
    
	- When in player-setup mode, use WASD to move a
 	  cursor across the display and choose a desired
    	  cell to change.
       
        - Press Space to toggle the chosen cell´s state.
	
	- When in player-setup mode, press Enter to run
 	  the simulation.
 	-----------------------------------------------------

	64 columns 	width pixels			   
	64 rows 	height pixels
	
	Space needed: 64 * 64 * 4 bytes (32 bits)
	
	Base address: 0x10010000 (static data)
	
