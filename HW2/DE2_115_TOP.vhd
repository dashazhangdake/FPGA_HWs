--
-- DE2-115 top-level module (entity declaration)
--
-- William H. Robinson, Vanderbilt University University
--   william.h.robinson@vanderbilt.edu
--
-- Updated from the DE2 top-level module created by 
-- Stephen A. Edwards, Columbia University, sedwards@cs.columbia.edu
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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
    VGA_R 		 : out unsigned(7 downto 0); -- Red[9:0]
    VGA_G 		 : out unsigned(7 downto 0); -- Green[9:0]
    VGA_B 		 : out unsigned(7 downto 0); -- Blue[9:0]

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

---------------------------------------------------
---------------------------------------------------
----------Problem 1 HQ-----------------------------
---------------------------------------------------
---------------------------------------------------

--architecture hex_display_switches of DE2_115_TOP is
--	component hex_display 
--		port (data_in: in std_logic_vector (3 downto 0);
--			data_segs: out std_logic_vector (6 downto 0));
--	end component;
--	
--begin
--	hex_display1: hex_display PORT MAP(data_in => SW(3 downto 0), data_segs => HEX0(6 downto 0));
--	
--end hex_display_switches;



---------------------------------------------------
---------------------------------------------------
----------Problem 2 HQ-----------------------------
---------------------------------------------------
---------------------------------------------------

architecture seq_adder_illu of DE2_115_TOP is

	signal sum: std_logic;
	signal sum_vec: std_logic_vector (3 downto 0);
	component seq_adder 
		port(A,B,CLK,RESET: in std_logic;
		  S: out std_logic;
		  state_vec: out std_logic_vector (1 downto 0)
		  );
	end component;
	component hex_display 
		port (data_in: in std_logic_vector (3 downto 0);
			data_segs: out std_logic_vector (6 downto 0));
	end component;
	
begin
	seq_adder1: seq_adder PORT MAP(A=>SW(2),B=>SW(1), CLK=>KEY(0), RESET=>SW(0) ,S=>sum, state_vec(1)=>LEDR(0),state_vec(0)=>LEDG(0));
	hex_display1: hex_display PORT MAP(data_in =>sum_vec , data_segs => HEX0(6 downto 0));
	sum_vec <= '0'&'0'&'0'&sum;	
end seq_adder_illu;



---------------------------------------------------
---------------------------------------------------
----------Problem 3 HQ-----------------------------
---------------------------------------------------
---------------------------------------------------
--architecture scroll_display of DE2_115_TOP is
--	component scroll_display
--		port (CLK,RSTN: in std_logic;
--			D7,D6,D5,D4,D3,D2,D1,D0: out std_logic_vector (6 downto 0));
--	end component;
--	
--begin
--	scroll_display1: scroll_display PORT MAP(CLK=>KEY(0),RSTN=>SW(0), 
--	D7 => HEX7(6 downto 0),
--	D6 => HEX6(6 downto 0),
--	D5 => HEX5(6 downto 0),
--	D4 => HEX4(6 downto 0),
--	D3 => HEX3(6 downto 0),
--	D2 => HEX2(6 downto 0),
--	D1 => HEX1(6 downto 0),
--	D0 => HEX0(6 downto 0));
--	
--end scroll_display;



-------------------------------------------------
-------------------------------------------------
--------Problem 4 HQ-----------------------------
-------------------------------------------------
-------------------------------------------------
--architecture hundred_cnt_final of DE2_115_TOP is
--
--signal clk_1: std_logic;
--signal CNT_H,CNT_T,CNT_U: std_logic_vector (3 downto 0);


-------------------involved entities---------------
--component clock_div is
--	port (CLK, RSTN: in std_logic;
--			CLK_1s: out std_logic);
--end component;
--component hundred_cnt is
--	port (CLK, RSTN: in std_logic;
--			CNT_HO,CNT_TO,CNT_UO: out std_logic_vector (3 downto 0));
--end component;
--component hex_display is
--	port (data_in: in std_logic_vector (3 downto 0);
--			data_segs: out std_logic_vector (6 downto 0));
--end component;

---------------------------------------------------
------------------instantiations-------------------

--begin
--	clkdiv_1: clock_div PORT MAP(CLK=>CLOCK_50,RSTN=>SW(0),CLK_1s=>clk_1);
--	hundred_cnt1: hundred_cnt PORT MAP (CLK=>clk_1,RSTN=>SW(0),CNT_HO=>CNT_H,CNT_TO=>CNT_T,CNT_UO=>CNT_U);
--	hex_display1: hex_display PORT MAP(data_in => CNT_H, data_segs => HEX2(6 downto 0));
--	hex_display2: hex_display PORT MAP(data_in => CNT_T, data_segs => HEX1(6 downto 0));
--	hex_display3: hex_display PORT MAP(data_in => CNT_U, data_segs => HEX0(6 downto 0));
--	
--	--------------set the remaining SEG_DISPLAY off--------------------------- 
--	HEX3(6 downto 0)<="1111111";
--	HEX4(6 downto 0)<="1111111";
--	HEX5(6 downto 0)<="1111111";
--	HEX6(6 downto 0)<="1111111";
--	HEX7(6 downto 0)<="1111111";
--end hundred_cnt_final;
--
