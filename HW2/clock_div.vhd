library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock_div is
	port (CLK, RSTN: in std_logic;
			CLK_1s: out std_logic);
end entity;

architecture clk_1s of Clock_div is
	signal cnt: integer range 0 to 49999999;
	begin
	 process (CLK,RSTN) begin
		if RSTN='0' then
			cnt <= 0;
			CLK_1s <= '0';
			
		elsif (rising_edge(CLK)) then
			if cnt = 49999999 then 
			CLK_1s <= '1';
			cnt <=0;
			else
			CLK_1s <= '0';
			cnt <= cnt+1;
			end if;
		end if;
	end process;
end architecture clk_1s ;
