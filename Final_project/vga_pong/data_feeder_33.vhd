------As mentioned in the communication with Dr. Sieraski, I believe the tap distance of line buffer should be 800 in this work  --

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity data_feeder_33 is
  Port ( 
    Din   : in  STD_LOGIC_VECTOR (7 downto 0);  -- RGB444 color format
	 clock: in std_logic;
	 p11,p12,p13: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
	 p21,p22,p23: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
	 p31,p32,p33: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
  );      
end data_feeder_33;



architecture Behavioral of data_feeder_33 is

--Inst list: just a line buffer--
component pixel_33array IS
	PORT
	(
		clock		: IN STD_LOGIC ;
		shiftin		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		shiftout		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		taps0x		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		taps1x		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		taps2x		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END component;

signal shift_p1,shift_p2,shift_p3: STD_LOGIC_VECTOR(7 downto 0);
signal shift_p12,shift_p13: STD_LOGIC_VECTOR(7 downto 0);
signal shift_p22,shift_p23: STD_LOGIC_VECTOR(7 downto 0);
signal shift_p32,shift_p33: STD_LOGIC_VECTOR(7 downto 0);


begin

p11 <= shift_p1;
p12 <= shift_p12;
p13 <= shift_p13;

p21 <= shift_p2;
p22 <= shift_p22;
p23 <= shift_p23;

p31 <= shift_p3;
p32 <= shift_p32;
p33 <= shift_p33;

Inst_pixel_33array: pixel_33array port map
	(
		clock	=> clock,
		shiftin => Din,
		taps0x => shift_p1,
		taps1x => shift_p2,
		taps2x => shift_p3	
	);
	
process (clock)
begin
	if rising_edge (clock) then
				shift_p12<=shift_p1;
				shift_p13<=shift_p12;
				shift_p22<=shift_p2;
				shift_p23<=shift_p22;
				shift_p32<=shift_p3;
				shift_p33<=shift_p32;
	end if;
end process;
end Behavioral;
