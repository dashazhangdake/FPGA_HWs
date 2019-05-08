-- Due to the poor graphic quality of the cheap camera, I set the level of color threshold to be only 5 (16 levels in total) --
-- However, we still need really good lighting to make sure our design work--------------
 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity color_detector is
  Port ( 
  pixel_row, pixel_column		: IN std_logic_vector(9 DOWNTO 0);
    din   : in  STD_LOGIC_VECTOR (11 downto 0);  -- RGB444 color format
	 dout   : out  STD_LOGIC_VECTOR (11 downto 0);
	 object_row, object_column		: out std_logic_vector(9 DOWNTO 0)
  );      
end color_detector;

architecture Behavioral of color_detector is
signal dini: STD_LOGIC_VECTOR (11 downto 0);
signal douti: STD_LOGIC_VECTOR (11 downto 0);
begin
process(din)
begin
	if din(11 downto 8) >= 5 and din(7 downto 4) <= 2 and din(3 downto 0) <= 2 then
		  douti <= "111111111111";
		  object_row <= pixel_row;
		  object_column <=pixel_column;
	elsif din(11 downto 8) <= 2 and din(7 downto 4) >= 5 and din(3 downto 0) <= 2 then
		  douti <= "000000111111";
	else
		  douti <= "000000000000";
	end if;
end process;
dout<=douti;
end Behavioral;
