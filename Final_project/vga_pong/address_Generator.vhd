-- I believe my addr_gen design is more straight forward than the one provided in open-source camera controller.
-- I am 100% sure that the address generated is exactly the same as what should be.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Address_Generator is
  Port (   
    CLK25,enable,rstn : in  STD_LOGIC;  
	 pixel_row, pixel_column : in STD_LOGIC_VECTOR(9 DOWNTO 0); --H/V counter for active region  
    vsync        : in  STD_LOGIC;
    address      : out STD_LOGIC_VECTOR (16 downto 0) 
  );  
end Address_Generator;


architecture Behavioral of Address_Generator is

  signal location,coordx,coordy: integer; 
  
begin
  coordx <=CONV_INTEGER (pixel_column);
  coordy <= CONV_INTEGER(pixel_row);
  address <= CONV_STD_LOGIC_VECTOR(location, 17);

  process(CLK25,rstn)
    begin
	 if rstn='0' then
		location <= 0;
      elsif rising_edge(CLK25) then
      
        if (enable='1') then          
          if coordx<=320 and coordy<=240 then        
            location <= coordx + 320 * coordy;
          end if;
        end if;
        
        if vsync = '0' then 
           location <= 0;
        end if;
      end if;  
    end process;

end Behavioral;
