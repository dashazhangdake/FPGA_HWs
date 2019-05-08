LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

entity rgb2gray is
  Port ( 
	 clock : in std_logic;
    Din   : in  STD_LOGIC_VECTOR (11 downto 0);  -- RGB444 color format
	 dout: out std_logic_vector(7 downto 0)
  );      
end rgb2gray;

architecture Behavioral of rgb2gray is
signal r,g,b: std_logic_vector (7 downto 0);	
signal ri,gi,bi,doutI: integer;	

begin
r <= Din(11 downto 8) & "1111";
g <= Din(7 downto 4) & "1111";
b <= Din(3 downto 0) & "1111";
ri <=  CONV_INTEGER ("00" & r(7 downto 2)) + CONV_INTEGER ("00000" & r(7 downto 5));
gi <=  CONV_INTEGER ("0" & g(7 downto 1)) + CONV_INTEGER ("0000" & g(7 downto 4));
bi <=  CONV_INTEGER ("0000" & b(7 downto 4)) + CONV_INTEGER ("00000" & b(7 downto 5));
process (clock)
begin
if rising_edge (clock) then
douti <= ri + gi + bi; 
end if;
end process;
dout <= CONV_STD_LOGIC_VECTOR(douti,8);
end Behavioral;
