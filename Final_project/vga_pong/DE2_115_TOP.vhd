-- DE2-115 top-level module (entity declaration)
--
-- Hao Qiu, Vanderbilt University
-- The DE2-115 top-level module is modified to fit Hao's group's project
--
-- William H. Robinson, Vanderbilt University University
--   william.h.robinson@vanderbilt.edu
--
-- Updated from the DE2 top-level module created by 
-- Stephen A. Edwards, Columbia University, sedwards@cs.columbia.edu


-- Hao's Intro on this final project design for demonstration--
-- A simple colored object detection system, could be configured to detect a single object (color varies), real-time 320x240x12 (RGB444) video captured by ov7670 is used as the real-time-test-sequence
-- a red/green circle will be displayed as the marker--
-- SW[17:16] controls the video output modes. SW[5] determines whether we play the game. 
-- The harris corner detection VHDL "code" is placed in still-image prototype design, not included here.

-- Main Reference List --
-- [1] OV7670 camera controller: http://www.dejazzer.com/eigenpi/digital_camera/digital_camera.html, acutally the controller designs here also took the reference from other guys.
-- [2] Implementation methods for spatial filter and some advanced computer vision - hardware designs, for example: https://people.ece.cornell.edu/land/courses/ece5760/
-- [3] HW design of Harris Corner detector: T. L. Chao and K. H. Wong, "An efficient FPGA implementation of the Harris corner feature detector," 2015 14th IAPR International Conference on Machine Vision Applications (MVA), Tokyo, 2015, pp. 89-93.
-- [4] Other resources related to Computer Vision and relevant hardware designs: Including but not limited to Matlab help, Wikipedia, IEEE xplorer, ACM etc.
-- [5] Vanderbilt EE277 course resources such as DE2-115-TOP, VGA_SYNC.
-- [6] The experience earend from Hao's Master Thesis research.

-- Note: When I "code" a new entity, I may copy-and-paste the other entities as the skeleon. Therefore you may see some really weird notes after the declarement of signals

-------------------- 


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
    AUD_XCK 		: out std_logic;               -- Chip Clock
	 
	 -- Adding GPIO in/out pins to DE2-115
	 -- GPIO for OV7670 camera connection, we got the jumper from Prof Holman, really appreciate it 
	 -- My camera connections: D[7:0] <=> GPIO[7:0]; MCLK=GPIO[11] PCLK=GPIO[10]; HS=GPIO[16] VS=GPIO[17]; SCL=GPIO[14] SDA=GPIO[15]; RESET=GPIO[13] PWRD=GPIO[12]
	 GPIO: inout std_logic_vector (35 downto 0)
    
    );
  
end DE2_115_TOP;


-- Architecture body 
-- 		Describes the functionality or internal implementation of the entity

ARCHITECTURE structural OF DE2_115_TOP IS

--ADJUSTED VANDY VGA (24bit RGB, 640x480) AND BUILT-IN PLL, PIXEL CLK IS 25.2MHZ--
COMPONENT VGA_SYNC_module

	PORT(	clock_50Mhz		: IN	STD_LOGIC;
			red, green, blue	:IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			red_out, green_out, blue_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); 
			horiz_sync_out, vert_sync_out, video_on, pixel_clock: OUT	STD_LOGIC;
			pixel_row, pixel_column: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));

END COMPONENT;

-------------------------------------------------------------------------------------------
---- LIST OT COMPONENTS 
-------------------------------------------------------------------------------------------
--OV7670 Interface FROM ONLINE RESOURCES: http://www.dejazzer.com/eigenpi/digital_camera/digital_camera.html--
--The architecture of OV7670 implementation is modified to fit VANDY VGA--
--Camera is configured to be 320x240, 60fps, RGB444, frame buffer(storing 2 frames) implemented with two SRAM (on-chip memory), address generator is adjusted to make sure the pixel position is correct--
COMPONENT ov7670_controller
  PORT(
    clk : IN std_logic;
    resend : IN std_logic;    
    siod : INOUT std_logic;      
    config_finished : OUT std_logic;
    sioc : OUT std_logic;
    reset : OUT std_logic;
    pwdn : OUT std_logic;
    xclk : OUT std_logic
    );
  END COMPONENT;

COMPONENT frame_buffer
  PORT(
    data : IN std_logic_vector(11 downto 0);
    rdaddress : IN std_logic_vector(16 downto 0);
    rdclock : IN std_logic;
    wraddress : IN std_logic_vector(16 downto 0);
    wrclock : IN std_logic;
    wren : IN std_logic;          
    q : OUT std_logic_vector(11 downto 0)
    );
  END COMPONENT;

COMPONENT ov7670_capture
  PORT(
    pclk : IN std_logic;
    vsync : IN std_logic;
    href : IN std_logic;
    d : IN std_logic_vector(7 downto 0);          
    addr : OUT std_logic_vector(16 downto 0);
    dout : OUT std_logic_vector(11 downto 0);
    we : OUT std_logic
    );
  END COMPONENT;
  
COMPONENT Address_Generator
  PORT(
    CLK25       : IN  std_logic;
	 rstn : in std_logic;
	 pixel_row, pixel_column : in STD_LOGIC_VECTOR(9 DOWNTO 0); --H/V counter for active region 
    enable      : IN  std_logic;       
    vsync       : in  STD_LOGIC;
    address     : OUT std_logic_vector(16 downto 0)
    );
  END COMPONENT;
--------------------------------------------------------------------
--END OF OV7670 Interface--  
-------------------------------------------------------------------

-------------------------------------------------------------------
--Simple Color Detector, and image preprocessing components--
------------------------------------------------------------------
-- Image preprocessing --

component rgb2gray is
  Port ( 
	 clock : in std_logic;
    Din   : in  STD_LOGIC_VECTOR (11 downto 0);  -- RGB444 color format
	 dout: out std_logic_vector(7 downto 0) --8bit grayscale intensity
  );      
end component;

component data_feeder_33 is
  Port ( 
    Din   : in  STD_LOGIC_VECTOR (7 downto 0);  -- 8bit grayscale intensity
	 clock: in std_logic;
	 p11,p12,p13: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
	 p21,p22,p23: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
	 p31,p32,p33: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
  );      
end component;

component sobel_operator is
  Port ( 
	 clock: in std_logic;
	 active_region: in std_logic;
	 --gray scale input "matrix" --
	 p11,p12,p13: in STD_LOGIC_VECTOR (7 DOWNTO 0);
	 p21,p22,p23: in STD_LOGIC_VECTOR (7 DOWNTO 0);
	 p31,p32,p33: in STD_LOGIC_VECTOR (7 DOWNTO 0);
	 --Filtered pixel--
	 pixel_sobel: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
  );      
end component;
-- End of image preprocessing --

-- Color detector and center calculation --
component color_detector is
  port ( 
    din   : in  STD_LOGIC_VECTOR (11 downto 0);  -- RGB444 color format
	 dout   : out  STD_LOGIC_VECTOR (11 downto 0)
  );      
end component;

-- center for red --
component center_average is
  Port ( 
    clk,vsync : in  STD_LOGIC; 
	 pixel_row, pixel_column : in STD_LOGIC_VECTOR(9 DOWNTO 0); --H/V counter for active region  
    din   : in  STD_LOGIC_VECTOR (11 downto 0);  -- thresholded video in 
	 coordxo, coordyo : out STD_LOGIC_VECTOR(9 DOWNTO 0) --H/V counter for active region  
  );      
end component;

-- center for green --
component center_average_g is
  Port ( 
    clk,vsync : in  STD_LOGIC;  
	 pixel_row, pixel_column : in STD_LOGIC_VECTOR(9 DOWNTO 0); --H/V counter for active region  
    din   : in  STD_LOGIC_VECTOR (11 downto 0);  -- thresholded video in 
	 coordxo, coordyo : out STD_LOGIC_VECTOR(9 DOWNTO 0) --H/V counter for active region  
  );      
end component;


--Ball game logic --
component ball IS
   PORT(pixel_row, pixel_column		: IN std_logic_vector(9 DOWNTO 0);
		  object_row, object_column : IN std_logic_vector(9 DOWNTO 0);
		  object_rowg, object_columng : IN std_logic_vector(9 DOWNTO 0);
        ball_on 				: OUT std_logic;
        Vert_sync	: IN std_logic;
		   clk: in std_logic);      
END component;

----------------------------------------------------------------------------
--End of detection and ball movement logic
----------------------------------------------------------------------------------------

-- IMAGE Drawing --
-- Primitive GPU --
component frame_drawer1 is
  Port ( 
   clock: in std_logic;
	 sel_input: in std_logic_vector(1 downto 0);
	 sobel_din: in std_logic_vector(7 downto 0);
	 gray_din: in std_logic_vector (7 downto 0); 
	 color_detect: in std_logic_vector(11 downto 0);
	 game_on, ball_on: in std_logic;
    Din   : in  STD_LOGIC_VECTOR (11 downto 0);  -- RGB444 color format
	 pixel_row, pixel_column : in STD_LOGIC_VECTOR(9 DOWNTO 0); --H/V counter for active region  
    object_x: in std_logic_vector(9 downto 0) ;
	 object_y: in std_logic_vector(9 downto 0) ;
	 object_x_g: in std_logic_vector(9 downto 0) ;
	 object_y_g: in std_logic_vector(9 downto 0) ;
    R,G,B   : out  STD_LOGIC_VECTOR (7 downto 0); -- R/G/B && 1111
	 active_region: out std_logic
  );      
end component;
--END OF "GPU"--
------------------------------------------------------------------------------------------
--End of component list--
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------

-----------List of intermediate signals---------------------
----------RGB/pixel location------------------------------
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

------------------OV7670 controlling signals--------------------
signal wren       : std_logic;
signal resend     : std_logic;
signal nBlank     : std_logic;
signal vSync      : std_logic;

------------------Detector Datapath sigals--------------------
signal wraddress  : std_logic_vector(16 downto 0);
signal wrdata     : std_logic_vector(11 downto 0);   
signal rdaddress  : std_logic_vector(16 downto 0);
signal rddata     : std_logic_vector(11 downto 0);
signal detect_data: std_logic_vector(11 downto 0);
signal red,green,blue : std_logic_vector(7 downto 0);
signal gray_img, sobel_img: std_logic_vector(7 downto 0);
signal activeArea : std_logic;
signal coordx, coordy: STD_LOGIC_VECTOR(9 DOWNTO 0);
signal coordxg, coordyg: STD_LOGIC_VECTOR(9 DOWNTO 0);

----------------Pixel matrix signals------------------
signal p11,p12,p13: STD_LOGIC_VECTOR (7 DOWNTO 0);
signal p21,p22,p23: STD_LOGIC_VECTOR (7 DOWNTO 0);
signal p31,p32,p33: STD_LOGIC_VECTOR (7 DOWNTO 0);

----------------Ball game logic inputs ----------------------
SIGNAL object_row_int :STD_LOGIC_VECTOR(9 DOWNTO 0); 
SIGNAL object_column_int :STD_LOGIC_VECTOR(9 DOWNTO 0); 
signal ball_on: std_logic;

BEGIN

-------VGA controlling signals ---------------------
	VGA_HS <= horiz_sync_int;
	VGA_VS <= vert_sync_int;
	VGA_CLK <= pixel_clock_int;
	
------------Instantiations based on the description on component list------------------------
	
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
		 pixel_clock		=>	pixel_clock_int,
		 pixel_row			=>	pixel_row_int,
		 pixel_column		=>	pixel_column_int
		);


  Inst_ov7670_controller: ov7670_controller PORT MAP(
    clk             => CLOCK_50,
    resend          => not KEY(0),
    config_finished => LEDR(0),
    sioc            => GPIO(14),
    siod            => GPIO(15),
    reset           => GPIO(13),
    pwdn            => GPIO(12),
    xclk            => GPIO(11)
  );
   
  Inst_ov7670_capture: ov7670_capture PORT MAP(
    pclk  => GPIO(10),
    vsync => GPIO(17),
    href  => GPIO(16),
    d     => GPIO(7 DOWNTO 0),
    addr  => wraddress,
    dout  => wrdata,
    we    => wren
  );

  Inst_frame_buffer: frame_buffer PORT MAP(
    rdaddress => rdaddress,
    rdclock   => pixel_clock_int,
    q         => rddata,      
    wrclock   => GPIO(10),
    wraddress => wraddress(16 downto 0),
    data      => wrdata,
    wren      => wren
  );
  
Inst_rgb2gray: rgb2gray Port map ( 
	 clock => pixel_clock_int,
    Din => rddata,
	dout => gray_img
  );      

	Inst_data_feeder_33: data_feeder_33 Port map( 
    Din => gray_img,
	 clock => pixel_clock_int,
	 p11 => p11,p12 => p12,p13 => p13,
	 p21 => p21,p22 => p22,p23 => p23,
	 p31 => p31,p32 => p32,p33 => p33
   );      

 Inst_sobel_operator: sobel_operator Port map (
	active_region => activearea,
	clock => pixel_clock_int,
	 p11 => p11,p12 => p12,p13 => p13,
	 p21 => p21,p22 => p22,p23 => p23,
	 p31 => p31,p32 => p32,p33 => p33,
	 pixel_sobel => sobel_img
  );     
  
 Inst_color_detector: color_detector
  port map(  
    din => rddata,  -- RGB444 color format  
	 dout => detect_data
  );      
  
  Inst_center_Average: center_average
  Port map( 
    clk=>pixel_clock_int,vsync=>vert_sync_int,
	 pixel_row => pixel_row_int, 
	 pixel_column=> pixel_column_int, 
    din  => detect_data,
	 coordxo => coordx, coordyo=>coordy
  );      
  
   Inst_center_Average_g: center_average_g
  Port map( 
    clk=>pixel_clock_int,vsync=>vert_sync_int,
	 pixel_row => pixel_row_int, 
	 pixel_column=> pixel_column_int, 
    din  => detect_data,
	 coordxo => coordxg, coordyo=>coordyg
  );      
  
  
  
  Inst_frame_drawer: frame_drawer1 Port map( 
   clock => pixel_clock_int,
	 sel_input => SW(17 DOWNTO 16),
	 sobel_din => sobel_img,
	 gray_din => gray_img, 
	 color_detect => detect_data,
	 game_on => SW(5), 
	 ball_on => ball_on,
    Din=> rddata,
	 pixel_row => pixel_row_int, 
	 pixel_column=> pixel_column_int,  
    object_x=> coordx,
	 object_y=>coordy, 
	 object_x_g=>coordxg,
	 object_y_g=>coordyg,
    R=>red_int,
	 G=>green_int,
	 B=>blue_int,
	 active_region => activearea
  );      
  
 Inst_Address_Generator: Address_Generator PORT MAP(
    CLK25 => pixel_clock_int,
    enable => activeArea,
	 rstn => Key(1),
	 	 pixel_row => pixel_row_int, 
	 pixel_column=> pixel_column_int,   
    vsync => vert_sync_int,
    address => rdaddress
  );
  
  Inst_ball: ball PORT map (
    	 pixel_row => pixel_row_int, 
	 pixel_column=> pixel_column_int, 
		  	 object_row => coordy, 
	 object_column=> coordx,
	 	 object_columng=>coordxg,
	 object_rowg=>coordyg,
        ball_on=>ball_on,
        Vert_sync	=> vert_sync_int,
		   clk=> pixel_clock_int);      
		


END structural;


