-- Frame buffer entity borrowed from http://www.dejazzer.com/eigenpi/digital_camera/digital_camera.html, I fully understand this implementation --
-- It's a simple design of the frame buffers, I have designed a Verilog module which is similiar to this design. It contains two interleavingly write/read RAMs. Though the W/R timing should be carefully arranged HQ--

-- create a buffer to store pixels data for a frame of 320x240 pixels;
-- data for each pixel is 12 bits;
-- that is 76800 pixels; hence, address is represented on 17 bits 
-- (2^17 = 131072 > 76800);
-- Notes: 
-- 1) If we wanted to work with 640x480 pixels, that would require
-- an amount of embedded RAM that is not available on the Cyclone IV E of DE2-115;
-- 2) We create the buffer with 76800 by stacking-up two blocks
-- of 2^16 = 65536 addresses; 

LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- It's an interlacing W/R frame buffer storing only two frames temperally, when one of the RAM is read by VGA modules, camera capture will write another one--
-- Then VGA could display frames continuously -- 
ENTITY frame_buffer IS
  PORT
  (
    data     : IN STD_LOGIC_VECTOR (11 DOWNTO 0);
    rdaddress : IN STD_LOGIC_VECTOR (16 DOWNTO 0);
    rdclock   : IN STD_LOGIC;
    wraddress : IN STD_LOGIC_VECTOR (16 DOWNTO 0);
    wrclock   : IN STD_LOGIC;
    wren     : IN STD_LOGIC;
    q        : OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
  );
END frame_buffer;


ARCHITECTURE SYN OF frame_buffer IS

  --RAM-2port--
  COMPONENT my_frame_buffer_15to0 IS
  PORT
  (
    data    : IN STD_LOGIC_VECTOR (11 DOWNTO 0);
    rdaddress    : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
    rdclock    : IN STD_LOGIC ;
    wraddress    : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
    wrclock    : IN STD_LOGIC  := '1';
    wren    : IN STD_LOGIC  := '0';
    q    : OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
  );
  END COMPONENT;

  
  -- read signals
  signal q_top : STD_LOGIC_VECTOR (11 DOWNTO 0);
  signal q_bottom : STD_LOGIC_VECTOR (11 DOWNTO 0);
  -- write signals
  signal wren_top : STD_LOGIC;
  signal wren_bottom : STD_LOGIC;
  
BEGIN
 -- RAM 1st frame--
  Inst_buffer_top : my_frame_buffer_15to0
    PORT MAP (
      data => data(11 downto 0),
      rdaddress => rdaddress(15 downto 0),
      rdclock => rdclock,
      wraddress => wraddress(15 downto 0),
      wrclock => wrclock,
      wren => wren_top,
      q => q_top
    );
 -- RAM 2nd frame--
  Inst_buffer_bottom : my_frame_buffer_15to0
    PORT MAP (
      data => data(11 downto 0),
      rdaddress => rdaddress(15 downto 0),
      rdclock => rdclock,
      wraddress => wraddress(15 downto 0),
      wrclock => wrclock,
      wren => wren_bottom,
      q => q_bottom
    );  
  
  -- Write enable is the MSB of wraddress, configured for interlacing W/R for two RAMs, which is synchornized with camera capture side --
  process (wraddress(16), wren)
  begin
    case wraddress(16) is 
      when '0' =>
        wren_top <= wren; wren_bottom <= '0';
      when '1' =>
        wren_top <= '0'; wren_bottom <= wren;  
      when others =>
        wren_top <= '0'; wren_bottom <= '0';
    end case;
  end process;
  
  -- Read part is simpler, address is synchornized with VGA controller, when RAM is not being written, VGA reads data from the RAM --  
  process (rdaddress(16), q_top, q_bottom)
  begin
    case rdaddress(16) is 
      when '0' =>
        q <= q_top;
      when '1' =>
        q <= q_bottom;
      when others =>
        q <= "000000000000";
    end case;
  end process;
    
END SYN;
