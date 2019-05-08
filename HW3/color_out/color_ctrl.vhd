library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity color_ctrl is
	port (color_sel: in std_logic_vector(2 downto 0);
			color_intensity: in std_logic_vector (7 downto 0);
			color_out_r,color_out_g,color_out_b: out std_logic_vector (7 downto 0)
			);
end color_ctrl;


architecture behavior of color_ctrl is

begin
	process(color_sel,color_intensity)
	--color_sel vector: B2B1B0<=>RGB	
	begin
		case color_sel is
			when "001"=>
				color_out_r <= "00000000";
				color_out_g <= "00000000";
				color_out_b <= color_intensity;
			when "010"=>
				color_out_r <= "00000000";
				color_out_g <= color_intensity;
				color_out_b <= "00000000";
			when "100"=>
				color_out_r <= color_intensity;
				color_out_g <= "00000000";
				color_out_b <= "00000000";
			--illegal color selection will result in a black screen
			when others=>
				color_out_r <= "00000000";
				color_out_g <= "00000000";
				color_out_b <= "00000000";
		end case;
	end process;
end architecture behavior; 