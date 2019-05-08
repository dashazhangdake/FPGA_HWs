library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hundred_cnt is
	port (CLK, RSTN: in std_logic;
			CNT_HO,CNT_TO,CNT_UO: out std_logic_vector (3 downto 0));
end entity;

architecture behavior of hundred_cnt is
signal CNT_H,CNT_T,CNT_U: unsigned (3 downto 0);
begin
	u_b: process (CLK,RSTN) begin
		if RSTN='0' then
			CNT_H <= "0000";
			CNT_T <= "0000";
			CNT_U <= "0000";	
		elsif (rising_edge(CLK)) then
			if CNT_U = "1001" then
				CNT_U <= "0000";
				CNT_T <= CNT_T+"0001";
					if CNT_T="1001" then 
						CNT_T <= "0000";
						CNT_H <= CNT_H+"0001";
						end if;
							if CNT_H="1001" then 
								CNT_H <= "0000";
								CNT_T <= "0000";
								CNT_U <= "0000";
							end if;	
				else
					CNT_U <= CNT_U+"0001";
			end if;
		end if;
	end process;
	CNT_Ho<=std_logic_vector(CNT_H);
	CNT_TO<=std_logic_vector(CNT_T);
	CNT_UO<=std_logic_vector(CNT_U);
end architecture behavior ;