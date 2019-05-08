library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity sobel_operator is
  Port ( 
	 clock: in std_logic;
	 active_region: in std_logic;
	 --gray scale input "matrix" --
	 p11,p12,p13: in STD_LOGIC_VECTOR (7 DOWNTO 0);
	 p21,p22,p23: in STD_LOGIC_VECTOR (7 DOWNTO 0);
	 p31,p32,p33: in STD_LOGIC_VECTOR (7 DOWNTO 0);
		--	 Filtered pixel--
	 pixel_sobel: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
  );      
end sobel_operator;


architecture Behavioral of sobel_operator is

signal p11i,p12i,p13i,p21i,p22i,p23i,p31i,p32i,p33i: integer range 0 to 600;
signal gx,gy, pixel_sobel_i : integer range 0 to 255;	

begin
p11i <= CONV_INTEGER(p11);
p12i <= CONV_INTEGER(p12);
p13i <= CONV_INTEGER(p13);
p21i <= CONV_INTEGER(p21);
p22i <= CONV_INTEGER(p22);
p23i <= CONV_INTEGER(p23);
p31i <= CONV_INTEGER(p31);
p32i <= CONV_INTEGER(p32);
p33i <= CONV_INTEGER(p33);
process(active_region,clock)
begin 
if rising_edge (clock) then
	if active_region='1' then
		gx <= abs(p11i + p12i*2 + p13i - p31i - 2*p32i - p33i);
		gy <= abs(p13i+ p23i*2 + p33i - p11i - 2*p21i - p31i);
		pixel_sobel_i <= gx + gy;
	end if;
end if;
end process;
pixel_sobel <= CONV_STD_LOGIC_VECTOR(pixel_sobel_i,8);
end Behavioral;
