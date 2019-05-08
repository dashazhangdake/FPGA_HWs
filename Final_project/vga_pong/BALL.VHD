-- Interactive Ball game 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

-- This design is based on lab3 problem2, we add additional collision detectors. A "60x60 virtual paddle" is defined around the center of mass for each colored object. 
-- Then we get a "Wii-like" green vs red pong game prototype 


ENTITY ball IS


   PORT(pixel_row, pixel_column		: IN std_logic_vector(9 DOWNTO 0);
		  object_row, object_column : IN std_logic_vector(9 DOWNTO 0);
		  object_rowg, object_columng : IN std_logic_vector(9 DOWNTO 0);
        ball_on 				: OUT std_logic;
        Vert_sync	: IN std_logic;
		  clk: in std_logic);
       
		
		
END ball;

architecture behavior of ball is

			-- Video Display Signals   
SIGNAL  Direction			: std_logic;
SIGNAL Size, pad_sizey, pad_sizeX, speed, speed_bar						: std_logic_vector(9 DOWNTO 0);  
SIGNAL Ball_X_motion 				: std_logic_vector(9 DOWNTO 0);
SIGNAL Ball_Y_motion 				: std_logic_vector(9 DOWNTO 0);
SIGNAL Ball_Y_pos, Ball_X_pos		: std_logic_vector(9 DOWNTO 0);


BEGIN           

Size <= CONV_STD_LOGIC_VECTOR(8,10);
pad_sizey <= CONV_STD_LOGIC_VECTOR(30,10);
pad_sizeX <= CONV_STD_LOGIC_VECTOR(30,10);
speed <= CONV_STD_LOGIC_VECTOR(2,10);
speed_bar <= CONV_STD_LOGIC_VECTOR(-2,10);

RGB_Display: Process (Ball_X_pos, Ball_Y_pos, pixel_column, pixel_row, Size)
BEGIN
			-- Set Ball_on ='1' to display ball
 IF ('0' & Ball_X_pos <= pixel_column + Size) AND
 			-- compare positive numbers only
 	(Ball_X_pos + Size >= '0' & pixel_column) AND
 	('0' & Ball_Y_pos <= pixel_row + Size) AND
 	(Ball_Y_pos + Size >= '0' & pixel_row ) THEN
 		Ball_on <= '1';
 	ELSE
 		Ball_on <= '0';
END IF;
END process RGB_Display;


Move_Ball: process
BEGIN

	WAIT UNTIL vert_sync'event and vert_sync = '1';

			
			-- Compute next ball X/Y position
			   Ball_X_pos <= Ball_X_pos + Ball_X_motion;
				Ball_Y_pos <= Ball_Y_pos + Ball_Y_motion;
				
					-- Screen boundary check --
	-- Move ball once every vertical sync: Y direction
			-- Bounce off top or bottom of screen
			IF ('0' & Ball_Y_pos) >= 240 - Size THEN
				Ball_Y_motion <= CONV_STD_LOGIC_VECTOR(-2,10);
			ELSIF Ball_Y_pos <= Size THEN
				Ball_Y_motion <= CONV_STD_LOGIC_VECTOR(2,10);
			elsif	('0' & Ball_Y_pos) >= object_row - pad_sizey and ('0' & Ball_Y_pos) <= object_row + pad_sizey and ('0' & Ball_X_pos) >= object_column - pad_sizex and ('0' & Ball_x_pos) <= object_column + pad_sizex and Ball_Y_motion = speed THEN
				Ball_Y_motion <= CONV_STD_LOGIC_VECTOR(-2,10);
			elsif	('0' & Ball_Y_pos) >= object_row - pad_sizey and ('0' & Ball_Y_pos) <= object_row + pad_sizey and ('0' & Ball_X_pos) >= object_column - pad_sizex and ('0' & Ball_x_pos) <= object_column + pad_sizex and Ball_Y_motion = speed_bar THEN
				Ball_Y_motion <= CONV_STD_LOGIC_VECTOR(2,10);
			elsif	('0' & Ball_Y_pos) >= object_rowg - pad_sizey and ('0' & Ball_Y_pos) <= object_rowg + pad_sizey and ('0' & Ball_X_pos) >= object_columng - pad_sizex and ('0' & Ball_x_pos) <= object_columng + pad_sizex and Ball_Y_motion = speed THEN
				Ball_Y_motion <= CONV_STD_LOGIC_VECTOR(-2,10);
			elsif	('0' & Ball_Y_pos) >= object_rowg - pad_sizey and ('0' & Ball_Y_pos) <= object_rowg + pad_sizey and ('0' & Ball_X_pos) >= object_columng - pad_sizex and ('0' & Ball_x_pos) <= object_columng + pad_sizex and Ball_Y_motion = speed_bar THEN
				Ball_Y_motion <= CONV_STD_LOGIC_VECTOR(2,10);

			END IF;

	-- Move ball once every vertical sync: X direction
			-- Bounce off leftmost or rightmost of screen
			IF ('0' & Ball_X_pos) >= 320 - Size THEN
				Ball_X_motion <= CONV_STD_LOGIC_VECTOR(-2,10);
			ELSIF Ball_X_pos <= Size THEN
				Ball_X_motion <= CONV_STD_LOGIC_VECTOR(2,10);
			-- Assume the paddle size is 20, Vx turns negative when hits the paddle (a wall on y direction)
			elsif	('0' & Ball_Y_pos) >= object_row - pad_sizey and ('0' & Ball_Y_pos) <= object_row + pad_sizey and ('0' & Ball_X_pos) >= object_column - pad_sizex and ('0' & Ball_x_pos) <= object_column + pad_sizex and Ball_X_motion = speed  THEN
				Ball_X_motion <= CONV_STD_LOGIC_VECTOR(-2,10);
			elsif	('0' & Ball_Y_pos) >= object_rowg - pad_sizey and ('0' & Ball_Y_pos) <= object_rowg + pad_sizey and ('0' & Ball_X_pos) >= object_columng - pad_sizex and ('0' & Ball_x_pos) <= object_columng + pad_sizex and Ball_X_motion = speed_bar THEN
				Ball_X_motion <= CONV_STD_LOGIC_VECTOR(2,10);

			END IF;

				
--	-- Collision with object check --
--			IF ('0' & Ball_X_pos) >= object_column - Size THEN
--				Ball_Y_motion <= CONV_STD_LOGIC_VECTOR(-2,10);
--			ELSIF Ball_Y_pos <= object_row +Size THEN
--				Ball_Y_motion <= CONV_STD_LOGIC_VECTOR(2,10);
--			END IF;

				
END process Move_Ball;

END behavior;

