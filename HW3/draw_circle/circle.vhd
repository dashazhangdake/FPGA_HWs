LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;
	

ENTITY circle IS
--the module can be setup to display a ring
   PORT(pixel_row, pixel_column		: IN std_logic_vector(9 DOWNTO 0);
		  radius_outer,radius_inner : in std_logic_vector(8 DOWNTO 0);
		  circle_color, back_color: in std_logic_vector(2 downto 0);
        Red,Green,Blue 				: OUT std_logic;
        Vert_sync	: IN std_logic);    
	
END circle;

architecture behavior of circle is

-- Video Display Signals  
signal pixel_rowa, pixel_columna : integer;	
signal radius_outera, radius_innera : integer;
SIGNAL circle_on		: std_logic;
--constant center, circle in the mid of the screen
SIGNAL center_X_pos : integer :=320 ;
SIGNAL center_Y_pos : integer :=240 ;
SIGNAL circle_equation: integer ;
SIGNAL rsqr_i, rsqr_o: integer;
BEGIN

--vector to integer to simplify the circle equation calculation 
pixel_rowa <= CONV_integer (pixel_row);
pixel_columna <= CONV_INTEGER (pixel_column);
radius_outera <= CONV_INTEGER(radius_outer) ;
radius_innera <= CONV_INTEGER(radius_inner) ;
circle_equation <= pixel_columna*pixel_columna + pixel_rowa*pixel_rowa + center_X_pos*center_X_pos + center_Y_pos*center_Y_pos - 2 * pixel_columna * center_X_pos - 2 * pixel_rowa * center_Y_pos; 
rsqr_o <= radius_outera*radius_outera;
rsqr_i <= radius_innera*radius_innera;

Circle_ctrl: Process (circle_equation, rsqr_i,rsqr_o)
BEGIN
 IF circle_equation <= rsqr_o and circle_equation >= rsqr_i THEN
 		circle_on <= '1';
 	ELSE
 		circle_on <= '0';
END IF;
END process Circle_ctrl;

RGB_display: process (circle_on,back_color,circle_color)
begin
	if circle_on = '1' then
		Red <= circle_color(2);
		Green <= circle_color(1);
		Blue <= circle_color(0);
	else 
		Red <= back_color(2);
		Green <= back_color(1);
		Blue <= back_color(0);
	end if;
end process RGB_display;


END behavior;