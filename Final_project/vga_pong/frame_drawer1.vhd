-------------"GPU"------------------------
-------------It is much simpler than expected----------------------

library IEEE;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity frame_drawer1 is
  Port ( 
   clock: in std_logic;
	 sel_input: in std_logic_vector(1 downto 0);
	 sobel_din: in std_logic_vector(7 downto 0);
	 gray_din: in std_logic_vector (7 downto 0); 
	 color_detect: in std_logic_vector(11 downto 0);
	 game_on, ball_on: in std_logic;
    Din   : in  STD_LOGIC_VECTOR (11 downto 0);  -- RGB444 color format
	 pixel_row, pixel_column : in STD_LOGIC_VECTOR(9 DOWNTO 0); --H/V counter for active region  
    object_x: in std_logic_vector(9 downto 0) ;
	 object_y: in std_logic_vector(9 downto 0) ;
	 object_x_g: in std_logic_vector(9 downto 0) ;
	 object_y_g: in std_logic_vector(9 downto 0) ;
    R,G,B   : out  STD_LOGIC_VECTOR (7 downto 0); -- R/G/B && 1111
	 active_region: out std_logic
  );      
end frame_drawer1;

architecture Behavioral of frame_drawer1 is
signal pixel_rowa, pixel_columna : integer;	
signal object_xa,object_ya: integer;
signal object_xag,object_yag: integer;
SIGNAL circle_equation: integer ;
SIGNAL circle_equationg: integer ;
SIGNAL rsqr_i, rsqr_o: integer;
begin
--overlapping marker--
pixel_rowa <= CONV_integer (pixel_row);
pixel_columna <= CONV_INTEGER (pixel_column);
object_ya <= CONV_integer (object_y);
object_xa <= CONV_INTEGER (object_x);
object_yag <= CONV_integer (object_y_g);
object_xag <= CONV_INTEGER (object_x_g);
circle_equation <= pixel_columna*pixel_columna + pixel_rowa*pixel_rowa + object_xa*object_xa + object_ya*object_ya - 2 * pixel_columna * object_xa - 2 * pixel_rowa * object_ya;
circle_equationg <= pixel_columna*pixel_columna + pixel_rowa*pixel_rowa + object_xag*object_xag + object_yag*object_yag - 2 * pixel_columna * object_xag - 2 * pixel_rowa * object_yag;
--a ring, used to mark the object-- 
rsqr_o <= 49;
rsqr_i <= 25;


ACT_region_RGB: process (clock,pixel_row,pixel_column,Din,gray_din)
begin
	if rising_edge (clock) then
	if ball_on = '1' and game_on ='1' then
		  R <= "11111111";
		  G <= "11111111";
        B <= "00000000";
		  active_region <= '1';
	elsiF circle_equation <= rsqr_o and circle_equation >= rsqr_i THEN
		  R <= "11111111";
		  G <= "00000000";
        B <= "00000000";
		  active_region <= '1';
	elsif circle_equationg <= rsqr_o and circle_equationg >= rsqr_i THEN
		  R <= "00000000";
		  G <= "11111111";
        B <= "00000000";
		  active_region <= '1';
	elsif pixel_row <= 239 and pixel_column <= 319 and pixel_row >= 0 and pixel_column >= 0 then
		active_region <= '1';
		case sel_input is
			when "11" =>
				R <= color_detect(11 downto 8)& "1111";
				G <= color_detect(7 downto 4)& "1111";
				B <= color_detect(3 downto 0)& "1111";
			when "10" =>
				R <= gray_din;
				G <= gray_din;
				B <= gray_din;
			when "01" =>
				R <= sobel_din;
				G <= sobel_din;
				B <= sobel_din;
			when "00" =>
				R <= Din(11 downto 8) & "1111";
				G <= Din(7 downto 4)  & "1111";
				B <= Din(3 downto 0)  & "1111";
			when others =>
				R <= Din(11 downto 8) & "1111";
				G <= Din(7 downto 4)  & "1111";
				B <= Din(3 downto 0)  & "1111";
		end case;
	else 
		  R <= "00000000";
		  G <= "00000000";
        B <= "00000000";
		  active_region <= '0';
	end if;
	end if;
end process;

end Behavioral;
