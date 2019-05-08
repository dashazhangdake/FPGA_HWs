-- Simply calculate the average location of all red or green pixels for each frame --
-- Timing should be arranged carefully, otherwise it will be a chaos --
-- V_SYNC is a good approach, perhaps there might be better options --
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity center_average_g is
  Port ( 
    clk,vsync : in  STD_LOGIC; 
	 pixel_row, pixel_column : in STD_LOGIC_VECTOR(9 DOWNTO 0); --H/V counter for active region  
    din   : in  STD_LOGIC_VECTOR (11 downto 0);  -- thresholded video in 
	 coordxo, coordyo : out STD_LOGIC_VECTOR(9 DOWNTO 0) --H/V counter for active region  
  );      
end center_average_g;

architecture Behavioral of center_average_g is

  signal coordx,coordy, coordxoi,coordyoi: integer; 
  signal sumx, sumy,countx, county: integer :=0; 
  
begin
  coordx <=CONV_INTEGER (pixel_column);
  coordy <= CONV_INTEGER(pixel_row);
  process(clk, coordx, coordy)
    begin
	 if rising_edge (clk) then
		if coordx<=320 and coordx>=0 and coordy <= 240 and coordy >= 0 then
			if din="000000111111" then
				sumx <= sumx + coordx;
				countx <= countx + 1;
				sumy <= sumy + coordy;
				county <= county + 1;
			else
				sumx <= sumx;
				countx <= countx;
				sumy <= sumy;
				county <= county;
        end if;
			if coordy = 240 then
				coordxoi <= sumx/countx;
				coordyoi <= sumy/county;
			 end if;
      end if;
	 end if;
	 if vsync = '0' then
	 			sumx <= 0;
				countx <= 0;
				sumy <= 0;
				county <= 0;
	end if;
    end process;
	coordxo <= CONV_STD_LOGIC_VECTOR(coordxoi,10);
	coordyo <= CONV_STD_LOGIC_VECTOR(coordyoi,10);
end Behavioral;
