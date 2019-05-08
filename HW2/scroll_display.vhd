library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity scroll_display is 
	port (CLK, RSTN: in std_logic;
			D7,D6,D5,D4,D3,D2,D1,D0: out std_logic_vector (6 downto 0));
				--Seg display dictionary
	shared variable H: std_logic_vector (6 downto 0) :="0001001";
	shared variable E: std_logic_vector (6 downto 0) :="0000110";
	shared variable L: std_logic_vector (6 downto 0) :="1000111";
	shared variable O: std_logic_vector (6 downto 0) :="1000000";
	shared variable comma: std_logic_vector (6 downto 0) :="1111011";
end entity;


	
architecture fsm of scroll_display is
	type state_type is (insert,scroll);
	signal state: state_type;
	signal cnt: integer:= -1;
	signal d7i,d6i,d5i,d4i,d3i,d2i,d1i,d0i: std_logic_vector (6 downto 0);
	
begin
	syn: process (CLK,RSTN) begin
		if RSTN='0' then
			cnt <= -1;
			state <= insert;
			
		elsif (rising_edge(CLK)) then
			cnt <= cnt + 1;
			case state is
				when insert =>
					if cnt < 7 then state <= insert;
					else state <= scroll;
					end if;
				when scroll =>
					state <= scroll;
			end case;
		end if;
	end process;
	
	next_state_output_logic: process (state,cnt) begin
	if (rising_edge(CLK)) then
		case state is
		when insert =>
			case cnt is
				when 0 =>
					d0i <= H;
					d1i <= "1111111";
					d2i <= "1111111";
					d3i <= "1111111";
					d4i <= "1111111";
					d5i <= "1111111";
					d6i <= "1111111";
					d7i <= "1111111";
				when 1 =>
					d0i <= E;
					d1i <= H;
					d2i <= "1111111";
					d3i <= "1111111";
					d4i <= "1111111";
					d5i <= "1111111";
					d6i <= "1111111";
					d7i <= "1111111";
				when 2 =>
					d0i <= L;
					d1i <= E;
					d2i <= H;
					d3i <= "1111111";
					d4i <= "1111111";
					d5i <= "1111111";
					d6i <= "1111111";
					d7i <= "1111111";
				when 3 =>
					d0i <= L;
					d1i <= L;
					d2i <= E;
					d3i <= H;
					d4i <= "1111111";
					d5i <= "1111111";
					d6i <= "1111111";
					d7i <= "1111111";
				when 4 =>
					d0i <= O;
					d1i <= L;
					d2i <= L;
					d3i <= E;
					d4i <= H;
					d5i <= "1111111";
					d6i <= "1111111";
					d7i <= "1111111";
				when 5 =>
					d0i <= comma;
					d1i <= O;
					d2i <= L;
					d3i <= L;
					d4i <= E;
					d5i <= H;
					d6i <= "1111111";
					d7i <= "1111111";
				when 6 =>
					d0i <= comma;
					d1i <= comma;
					d2i<= O;
					d3i <= L;
					d4i <= L;
					d5i<= E;
					d6i <= H;
					d7i <= "1111111";
				when 7 =>
					d0i <= comma;
					d1i <= comma;
					d2i <= comma;
					d3i <= O;
					d4i <= L;
					d5i <= L;
					d6i <= E;
					d7i <= H;
				when others =>
					d0i <= "1111111";
					d1i <= "1111111";
					d2i <= "1111111";
					d3i <= "1111111";
					d4i <= "1111111";
					d5i <= "1111111";
					d6i <= "1111111";
					d7i <= "1111111";
			end case;
		when scroll=>
					d0i <= d7i;
					d1i <= d0i;
					d2i <= d1i;
					d3i <= d2i;
					d4i <= d3i;
					d5i <= d4i;
					d6i <= d5i;
					d7i <= d6i;
	end case;
	end if;
end process;
					D0 <= d0i;
					D1 <= d1i;
					D2 <= d2i;
					D3 <= d3i;
					D4 <= d4i;
					D5 <= d5i;
					D6 <= d6i;
					D7 <= d7i;
end architecture fsm;