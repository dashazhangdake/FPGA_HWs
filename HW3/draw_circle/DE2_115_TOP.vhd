--
-- DE2-115 top-level module (entity declaration)
--
-- William H. Robinson, Vanderbilt University University
--   william.h.robinson@vanderbilt.edu
--
-- Updated from the DE2 top-level module created by 
-- Stephen A. Edwards, Columbia University, sedwards@cs.columbia.edu
--

-- Using a modified top level to fit revised VGA controller, hao--

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

entity DE2_115_TOP is

  port (
    -- Clocks
    
    CLOCK_50 	: in std_logic;                     -- 50 MHz
    CLOCK2_50 	: in std_logic;                     -- 50 MHz
    CLOCK3_50 	: in std_logic;                     -- 50 MHz
    SMA_CLKIN  : in std_logic;                     -- External Clock Input
    SMA_CLKOUT : out std_logic;                    -- External Clock Output

    -- Buttons and switches
    
    KEY : in std_logic_vector(3 downto 0);         -- Push buttons
    SW  : in std_logic_vector(17 downto 0);        -- DPDT switches

    -- LED displays

    HEX0 : out std_logic_vector(6 downto 0);       -- 7-segment display (active low)
    HEX1 : out std_logic_vector(6 downto 0);       -- 7-segment display (active low)
    HEX2 : out std_logic_vector(6 downto 0);       -- 7-segment display (active low)
    HEX3 : out std_logic_vector(6 downto 0);       -- 7-segment display (active low)
    HEX4 : out std_logic_vector(6 downto 0);       -- 7-segment display (active low)
    HEX5 : out std_logic_vector(6 downto 0);       -- 7-segment display (active low)
    HEX6 : out std_logic_vector(6 downto 0);       -- 7-segment display (active low)
    HEX7 : out std_logic_vector(6 downto 0);       -- 7-segment display (active low)
    LEDG : out std_logic_vector(8 downto 0);       -- Green LEDs (active high)
    LEDR : out std_logic_vector(17 downto 0);      -- Red LEDs (active high)

    -- RS-232 interface

    UART_CTS : out std_logic;                      -- UART Clear to Send   
    UART_RTS : in std_logic;                       -- UART Request to Send   
    UART_RXD : in std_logic;                       -- UART Receiver
    UART_TXD : out std_logic;                      -- UART Transmitter   

    -- 16 X 2 LCD Module
    
    LCD_BLON : out std_logic;      							-- Back Light ON/OFF
    LCD_EN   : out std_logic;      							-- Enable
    LCD_ON   : out std_logic;      							-- Power ON/OFF
    LCD_RS   : out std_logic;	   							-- Command/Data Select, 0 = Command, 1 = Data
    LCD_RW   : out std_logic; 	   						-- Read/Write Select, 0 = Write, 1 = Read
    LCD_DATA : inout std_logic_vector(7 downto 0); 	-- Data bus 8 bits

    -- PS/2 ports

    PS2_CLK : inout std_logic;     -- Clock
    PS2_DAT : inout std_logic;     -- Data

    PS2_CLK2 : inout std_logic;    -- Clock
    PS2_DAT2 : inout std_logic;    -- Data

    -- VGA output
    
    VGA_BLANK_N : out std_logic;            -- BLANK
    VGA_CLK 	 : out std_logic;            -- Clock
    VGA_HS 		 : out std_logic;            -- H_SYNC
    VGA_SYNC_N  : out std_logic;            -- SYNC
    VGA_VS 		 : out std_logic;            -- V_SYNC
    VGA_R 		 : out std_logic_vector (7 downto 0); -- Red[9:0]
    VGA_G 		 : out std_logic_vector (7 downto 0); -- Green[9:0]
    VGA_B 		 : out std_logic_vector (7 downto 0); -- Blue[9:0]

    -- SRAM
    
    SRAM_ADDR : out unsigned(19 downto 0);         -- Address bus 20 Bits
    SRAM_DQ   : inout unsigned(15 downto 0);       -- Data bus 16 Bits
    SRAM_CE_N : out std_logic;                     -- Chip Enable
    SRAM_LB_N : out std_logic;                     -- Low-byte Data Mask 
    SRAM_OE_N : out std_logic;                     -- Output Enable
    SRAM_UB_N : out std_logic;                     -- High-byte Data Mask 
    SRAM_WE_N : out std_logic;                     -- Write Enable

    -- Audio CODEC
    
    AUD_ADCDAT 	: in std_logic;               -- ADC Data
    AUD_ADCLRCK 	: inout std_logic;            -- ADC LR Clock
    AUD_BCLK 		: inout std_logic;            -- Bit-Stream Clock
    AUD_DACDAT 	: out std_logic;              -- DAC Data
    AUD_DACLRCK 	: inout std_logic;            -- DAC LR Clock
    AUD_XCK 		: out std_logic               -- Chip Clock
    
    );
  
end DE2_115_TOP;


-- Architecture body 
-- 		Describes the functionality or internal implementation of the entity

ARCHITECTURE structural OF DE2_115_TOP IS
--------------------ENTITY LIST------------------------------
--revised vga
COMPONENT VGA_SYNC_module

	PORT(	clock_50Mhz		: IN	STD_LOGIC;
			red, green, blue	:IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			red_out, green_out, blue_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); 
			horiz_sync_out, vert_sync_out, video_on, pixel_clock: OUT	STD_LOGIC;
			pixel_row, pixel_column: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));

END COMPONENT;

--color cycling ctrl
COMPONENT color_ctrl
		PORT(clk: IN std_logic;
			enables: in std_logic_vector (1 downto 0);
		color_bck,color_circle	: out integer range 0 to 7);
end COMPONENT;

--clock divider reconfigured to 0.5s period
component clock_div is
	port (CLK, RSTN: in std_logic;
			CLK_1s: out std_logic);
end component;

--circle drwaing
--radius inner let us draw a ring, if we need to stick on circle, just make radius inner "00000000"
component circle IS
   PORT(pixel_row, pixel_column		: IN std_logic_vector(9 DOWNTO 0);
		  radius_outer,radius_inner : in std_logic_vector(8 DOWNTO 0);
		  circle_color, back_color: in std_logic_vector(2 downto 0);
        Red,Green,Blue 				: OUT std_logic;
        Vert_sync	: IN std_logic);

END COMPONENT;
---------------------------------------------------------------------------

SIGNAL red_int : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL green_int : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL blue_int : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL red_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL green_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL blue_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL video_on_int : STD_LOGIC;
SIGNAL vert_sync_int : STD_LOGIC;
SIGNAL horiz_sync_int : STD_LOGIC; 
SIGNAL pixel_clock_int : STD_LOGIC;
SIGNAL pixel_row_int :STD_LOGIC_VECTOR(9 DOWNTO 0); 
SIGNAL pixel_column_int :STD_LOGIC_VECTOR(9 DOWNTO 0); 
SIGNAL color_bck_i: integer range 0 to 7;
SIGNAL color_circle_i: integer range 0 to 7;
SIGNAL clk_1: std_logic;

BEGIN

	VGA_HS <= horiz_sync_int;
	VGA_VS <= vert_sync_int;

--vga_ctrl--
	U1: VGA_SYNC_module PORT MAP
		(clock_50Mhz		=>	CLOCK_50,
		 red					=>	red_int,
		 green				=>	green_int,	
		 blue					=>	blue_int,
		 red_out				=>	VGA_R,
		 green_out			=>	VGA_G,
		 blue_out			=>	VGA_B,
		 horiz_sync_out	=>	horiz_sync_int,
		 vert_sync_out		=>	vert_sync_int,
		 video_on			=>	VGA_BLANK_N,
		 pixel_clock		=>	VGA_CLK,
		 pixel_row			=>	pixel_row_int,
		 pixel_column		=>	pixel_column_int
		);
		
--clock gen--
	u2: clock_div PORT MAP(CLK=>CLOCK_50,RSTN=>KEY(3),CLK_1s=>clk_1); 
	
--color ctrl--
--push key buttons to cycle thru the colors, push key 0 and key 1 simultaneously will cyle bck and circle at the same time.
--if we do noting to the board keys, display will be "constant" 
	U3: color_ctrl port map (clk=>clk_1, enables=>not KEY(1)& not KEY(0), color_bck=>color_bck_i,color_circle=>color_circle_i);

--circle drawing
	U4: circle PORT MAP
		(pixel_row => pixel_row_int,
		pixel_column=> pixel_column_int,
		  radius_outer => sw(17 DOWNTO 9),
		  radius_inner =>sw(8 DOWNTO 0),
		  circle_color => CONV_STD_LOGIC_VECTOR(color_circle_i,3),
		  back_color => CONV_STD_LOGIC_VECTOR(color_bck_i,3),
		 Red				=> red_int(7),
		 Green			=> green_int(7),
		 Blue				=> blue_int(7),
		 Vert_sync		=> vert_sync_int);
END structural;


