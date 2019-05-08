			-- Bouncing Ball Video 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;
			-- Bouncing Ball Video 


ENTITY ball_controlled IS


   PORT(pixel_row, pixel_column		: IN std_logic_vector(9 DOWNTO 0);
		  MOV_LEFT, MOV_RIGHT, MOV_PAUSE: std_logic;
        Red,Green,Blue 				: OUT std_logic;
        Vert_sync	: IN std_logic);
       
		
		
END ball_controlled;

architecture behavior of ball_controlled is

			-- Video Display Signals   
SIGNAL Ball_on			: std_logic;
SIGNAL Size 						: std_logic_vector(9 DOWNTO 0);  
SIGNAL Ball_X_motion 				: std_logic_vector(9 DOWNTO 0);
SIGNAL Ball_Y_motion 				: std_logic_vector(9 DOWNTO 0);
SIGNAL Ball_Y_pos	: std_logic_vector(9 DOWNTO 0);
SIGNAL Ball_X_pos : std_logic_vector(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(320,10);

BEGIN           

Size <= CONV_STD_LOGIC_VECTOR(8,10);
Ball_Y_pos <= CONV_STD_LOGIC_VECTOR(240,10);
		-- Colors for pixel data on video signal
Red <=  '1';
		-- Turn off Green and Blue when displaying ball
Green <= NOT Ball_on;
Blue <=  NOT Ball_on;

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
	-- Move ball once every vertical sync: X direction based on controlling signals
	-- Boundary check applied, stop if reached the boundary
	if ('0' & Ball_X_pos) <= Size  then 
		Ball_X_motion <= CONV_STD_LOGIC_VECTOR(2,10);
	elsif ('0' & Ball_X_pos) >= 640 - Size then
		Ball_X_motion <= CONV_STD_LOGIC_VECTOR(-2,10);
			ELSIF (MOV_LEFT='0') and ('0' & Ball_X_pos) >= Size THEN
				Ball_X_motion <= CONV_STD_LOGIC_VECTOR(-2,10);
			ELSIF (MOV_RIGHT='0')  and ('0' & Ball_X_pos) <= 640 - Size then
				Ball_X_motion <= CONV_STD_LOGIC_VECTOR(2,10);
			ELSIF (MOV_PAUSE='0') then
				Ball_X_motion <= CONV_STD_LOGIC_VECTOR(0,10);
			END IF;
			-- Compute next ball Y position
				Ball_X_pos <= Ball_X_pos + Ball_X_motion;
				
END process Move_Ball;

END behavior;