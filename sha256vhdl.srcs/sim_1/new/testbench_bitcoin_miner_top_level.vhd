----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 03.07.2024 18:09:39
-- Design Name: testbench_bitcoin_miner_top_level
-- Module Name: testbench_bitcoin_miner_top_level - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: tstbench for the top level of sha256vhdl project
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD.ALL, work.bitcoin_miner_top_level
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

entity testbench_bitcoin_miner_top_level is
--  Port ( );
end testbench_bitcoin_miner_top_level;

architecture Behavioral of testbench_bitcoin_miner_top_level is
        signal clk : std_logic; -- 100 MHz
        -- with this clock, it takes 3.4 us to check a nonce
        signal res : std_logic; -- active low
        
        -- buttons
        signal BTNC, BTNU, BTNL, BTNR, BTND: std_logic;
        
        -- switches and relative LEDs
        signal SW : std_logic_vector(8-1 downto 0);
        signal SW_15 : std_logic;
        signal LED : std_logic_vector(8-1 downto 0);
        signal LED_15 : std_logic;
        
        -- Signals for seven segment display
        signal CA, CB, CC, CD, CE, CF, CG, DP : std_logic;
        signal AN : std_logic_vector( 7 downto 0 );
        
        -- RGB LEDs
        signal LED16_B, LED16_G, LED16_R, LED17_B, LED17_G : std_logic;
begin
    bitcoin_miner_top_level : entity work.bitcoin_miner_top_level port map(
        clk=>clk, res=>res,
        BTNC=>BTNC, BTNU=>BTNU, BTNL=>BTNL, BTNR=>BTNR, BTND=>BTND,
        SW=>SW, SW_15=>SW_15, LED=>LED, LED_15=>LED_15,
        CA=>CA, CB=>CB, CC=>CC, CD=>CD, CE=>CE, CF=>CF, CG=>CG, DP=>DP, AN=>AN,
        LED16_B=>LED16_B, LED16_G=>LED16_G, LED16_R=>LED16_R, LED17_B=>LED17_B, LED17_G=>LED17_G
    );
    
    clk_process : process is begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process; -- 100 MHz
    
    test : process is begin
        res <= '0';
        BTNC <= '0';
        BTNU <= '0';
        BTNL <= '0';
        BTNR <= '0';
        BTND <= '0';
        SW <= "00000000";
        SW_15 <= '0';
        
        wait for 10 ns;
        res <= '1';
        
        wait for 10 us;
        BTNU <= '1';
        
        wait for 50 us;
        BTNU <= '0';
        
        wait for 100 us;
        SW_15 <= '1';
        
        wait;
    end process;
    
end Behavioral;
