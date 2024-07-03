----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 03.07.2024 15:17:05
-- Design Name: bitcoin_miner_top_level
-- Module Name: bitcoin_miner_top_level - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: the top level of sha256vhdl project, it instantiates the bitcoin miner, with the debouncer
-- and the 7 segment display, to use it on a real FPGA.
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD.ALL, work.bitcoin_miner, work.debouncer, work.seven_segment_driver
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bitcoin_miner_top_level is
    Port (
        clk : in std_logic; -- 100 MHz
        -- with this clock, it takes 3.4 us to check a nonce
        res : in std_logic; -- active low
        
        -- buttons
        BTNC, BTNU, BTNL, BTNR, BTND: in std_logic;
        
        -- switches and relative LEDs
        SW : in std_logic_vector(8-1 downto 0);
        SW_15 : in std_logic;
        LED : out std_logic_vector(8-1 downto 0);
        LED_15 : out std_logic;
        
        -- Signals for seven segment display
        CA, CB, CC, CD, CE, CF, CG, DP : out std_logic;
        AN : out std_logic_vector( 7 downto 0 );
        
        -- RGB LEDs
        LED16_B, LED16_G, LED16_R, LED17_B, LED17_G : out std_logic
    );
end bitcoin_miner_top_level;

architecture Behavioral of bitcoin_miner_top_level is
    -- Debounced buttons
    signal button_center, button_up, button_right, button_down, button_left : std_logic;
    
    -- Signal to select the testcase
    signal select_input : std_logic_vector ( 1 downto 0);
    
    -- Bitcoin miner's inputs
    signal version : unsigned ( 32-1 downto 0);
    signal previous_block_hash : unsigned ( 256-1 downto 0);
    signal merkle_root : unsigned ( 256-1 downto 0);
    signal timestamp : unsigned ( 32-1 downto 0);
    signal bits : unsigned ( 32-1 downto 0);
    signal start_nonce : unsigned ( 32-1 downto 0);
    
    signal start : std_logic;
    signal cancel : std_logic;
    
    -- Bitcoin miner's outputs
    signal header_hash : unsigned ( 256-1 downto 0);
    signal winning_nonce : unsigned ( 32-1 downto 0);
    
    signal busy : std_logic;
    signal nonce_found : std_logic;
    signal nonce_overflow : std_logic;
    signal error : std_logic;
    
    -- signals to display on the seven segment
    signal screen : unsigned (32-1 downto 0);
    signal digit0, digit1, digit2, digit3, digit4, digit5, digit6, digit7 : std_logic_vector (3 downto 0);
begin
    -- Debounce the buttons
    
    debounce_center : entity work.debouncer port map( clk=>clk, res=>res, bouncy=>BTNC, pulse=>button_center );
    debounce_up : entity work.debouncer port map( clk=>clk, res=>res, bouncy=>BTNU, pulse=>button_up );
    debounce_right : entity work.debouncer port map( clk=>clk, res=>res, bouncy=>BTNR, pulse=>button_right );
    debounce_down : entity work.debouncer port map( clk=>clk, res=>res, bouncy=>BTND, pulse=>button_down );
    debounce_left : entity work.debouncer port map( clk=>clk, res=>res, bouncy=>BTNL, pulse=>button_left );
    
    -- Drive the bitcoin miner
    
    select_input <= "00" when button_up='1' else
                    "01" when button_right='1' else
                    "10" when button_down='1' else
                    "11" when button_left='1' else
                    "00"; -- for any other case, included all buttons at '0'.
                    
    cancel <= button_center;
    start <= button_up OR button_right OR button_down OR button_left;
    
    select_testcases : entity work.bitcoin_miner_testcases port map(
        select_input=>select_input, version=>version, previous_block_hash=>previous_block_hash,
        merkle_root=>merkle_root, timestamp=>timestamp, bits=>bits, start_nonce=>start_nonce
    );
    
    bitcoin_miner : entity work.bitcoin_miner port map(
        clk=>clk, res=>res,
        version=>version, previous_block_hash=>previous_block_hash, merkle_root=>merkle_root,
        timestamp=>timestamp, bits=>bits, start_nonce=>start_nonce,
        header_hash=>header_hash, winning_nonce=>winning_nonce, -- header has been neglected
        start=>start, cancel=>cancel, busy=>busy, nonce_found=>nonce_found, nonce_overflow=>nonce_overflow, error=>error
    );
    
    -- Display results
    
    screen <= winning_nonce when SW_15='1' else
              header_hash( 255 downto 256-32            ) when SW(7)='1' else
              header_hash( 255-32 downto 256-(32*2)     ) when SW(6)='1' else
              header_hash( 255-(32*2) downto 256-(32*3) ) when SW(5)='1' else
              header_hash( 255-(32*3) downto 256-(32*4) ) when SW(4)='1' else
              header_hash( 255-(32*4) downto 256-(32*5) ) when SW(3)='1' else
              header_hash( 255-(32*5) downto 256-(32*6) ) when SW(2)='1' else
              header_hash( 255-(32*6) downto 256-(32*7) ) when SW(1)='1' else
              header_hash( 255-(32*7) downto 0          ) when SW(0)='1' else
              ( others => '0' );
    
    digit0 <= std_logic_vector( screen( 3 downto 0) );
    digit1 <= std_logic_vector( screen( 7 downto 4) );
    digit2 <= std_logic_vector( screen( 11 downto 8) );
    digit3 <= std_logic_vector( screen( 15 downto 12) );
    digit4 <= std_logic_vector( screen( 19 downto 16) );
    digit5 <= std_logic_vector( screen( 23 downto 20) );
    digit6 <= std_logic_vector( screen( 27 downto 24) );
    digit7 <= std_logic_vector( screen( 31 downto 28) );
    
    seven_segment : entity work.seven_segment_driver generic map ( size=>20 ) port map(
        clock=>clk, reset=>res,
        digit0=>digit0, digit1=>digit1, digit2=>digit2, digit3=>digit3,
        digit4=>digit4, digit5=>digit5, digit6=>digit6, digit7=>digit7,
        CA=>CA, CB=>CB, CC=>CC, CD=>CD, CE=>CE, CF=>CF, CG=>CG, DP=>DP, AN=>AN
    );
    
    LED <= SW;
    LED_15 <= SW_15;
    
    -- Display the status
    
    LED16_B <= nonce_overflow;
    LED16_G <= nonce_found;
    LED16_R <= error;
    LED17_B <= busy;
    LED17_G <= NOT busy;
    
end Behavioral;
