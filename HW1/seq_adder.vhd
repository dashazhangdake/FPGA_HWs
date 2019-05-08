library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use IEEE.std_logic_arith.all;
use IEEE.numeric_bit.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_unsigned.all;
use IEEE.math_real.all;
use IEEE.math_complex.all;
--in: A;B;RESET;CLK, WIDTH=1
--out: S, WIDTH=1
entity seq_adder is
	port(A,B,CLK,RESET: in bit;
		  S: out bit;
		  stateval: out integer range 0 to 2
		  );
end seq_adder;

architecture add_process of seq_adder is
signal state, next_state: integer range 0 to 3 :=2;
--one hot encoding, i.e, two bits rather than one bit for state vector
--STATE G=10=2; STATE H=01=1
begin
	sync: process (CLK)
		begin 
			if rising_edge(CLK) then					
				if RESET='1' then state<=2; 
					else 
						state<=next_state;
				end if;
			end if;
		stateval <= state;
	end process;
	
	next_state_proc: process (state,A,B)
		begin
			case (state) is
					when 2 =>
						S <= A xor B;
						if (A='1' and B='1') then next_state <= 1;
						else next_state <= 2;
						end if;
					when 1 =>
						S <=A xor B xor '1';
						if (A='0' and B='0') then next_state <= 2;
						else next_state <= 1;
						end if;
					when 0 =>
						next_state <= 2;
					when 3 =>
						next_state <= 2;
				end case;			
		end process;
end add_process;

					
				

