library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--in: A;B;RESET;CLK, WIDTH=1
--out: S, WIDTH=1
entity seq_adder is
	port(A,B,CLK,RESET: in std_logic;
		  s: out std_logic;
		  state_vec: out std_logic_vector (1 downto 0)
		  );
end seq_adder;

architecture add_process of seq_adder is
type state_type is (G,H);
signal state, next_state: state_type;
--one hot encoding, i.e, two bits rather than one bit for state vector
--STATE G=10; STATE H=01
begin
	sync: process (CLK)
		begin 
			if rising_edge(CLK) then					
				if RESET='1' then state<=G; 
					else 
						state<=next_state;
				end if;
			end if;
	end process;
	
	next_state_proc: process (state,A,B)
		begin
			case (state) is
					when G =>
						S <= A xor B;
						state_vec <= "01";
						if (A='1' and B='1') then next_state <= H;
						else next_state <= G;
						end if;
					when H =>
						state_vec <= "10";
						S <=A xor B xor '1';
						if (A='0' and B='0') then next_state <= G;
						else next_state <= H;
						end if;
				end case;			
		end process;
end add_process;

					
				

