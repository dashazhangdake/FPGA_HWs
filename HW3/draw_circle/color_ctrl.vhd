LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;
	

ENTITY color_ctrl IS
--the module can be setup to display a ring
   PORT(clk	: IN std_logic;
	--EN1EN0<=>[bck_en,circle_en]
			enables: in std_logic_vector (1 downto 0);
		color_bck,color_circle	: out integer range 0 to 7);    
END color_ctrl;

architecture behavior of color_ctrl is
signal color_bcki,color_circlei	: integer range 0 to 7;
begin

	--push key to start color cycling, otherwise color will be constant
		process(clk,enables)
			begin 
			--color starts from black
 color_bcki<=0;
 color_circlei<=7;
				if (rising_edge(CLK)) then
					case enables is
						when "11"=>
							color_bcki<=color_bcki+1;
							color_circlei<=color_circlei+1;
						when "10"=>
							color_bcki<=color_bcki+1;
							color_circlei<=color_circlei;
						when "01"=>
							color_bcki<=color_bcki;
							color_circlei<=color_circlei+1;
						when "00"=>
							color_bcki<=color_bcki;
							color_circlei<=color_circlei;
					end case;
				else
						color_bcki<=color_bcki;
						color_circlei<=color_circlei;
				end if;
			end process;
color_bck<=color_bcki;
color_circle<=color_circlei;
end architecture behavior;