----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: , 24.06.2024 16:44:08
-- Design Name: testbench_block_routine
-- Module Name: testbench_block_routine - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: testbench for the block routine
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD, work.block_routine
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

entity testbench_block_routine is
--  Port ( );
end testbench_block_routine;

architecture Behavioral of testbench_block_routine is
    signal clk : std_logic;
    signal res : std_logic; -- active low
    
    -- Data
    signal m_block : unsigned ( (32 * 16)-1 downto 0); -- (word_size * w_number)-1 downto 0
    signal H_input : unsigned ( (32 * 8)-1 downto 0); -- (word_size * H_number)-1 downto 0
    signal H_output : unsigned ( (32 * 8)-1 downto 0); -- (word_size * H_number)-1 downto 0
    
    -- Status Signals
    signal start : std_logic; -- when it goes to 1 the machine exits the wait state
    signal cancel : std_logic; -- synchronous reset, active high
    signal busy : std_logic; -- 1 when machine is computing
    signal valid : std_logic; -- 1 when the output hash is valid
begin
    block_routine: entity work.block_routine generic map (word_size=>32, clock_dim=>6) port map(
        clk=>clk, res=>res,
        m_block=>m_block, H_input=>H_input, H_output=>H_output,
        start=>start, cancel=>cancel, busy=>busy, valid=>valid
    );
    
    clk_process : process is begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;
    
    test : process is begin
        res <= '0';
        start <= '1';
        cancel <= '1';
        H_input <= x"0e002020_ff006100_30050017_17a9f87c_00002f20_34678000_efa8a9c3_00210342";
        m_block <= x"30050017_17a9f87c_00210342_ff006100_efa8a9c3_0e002020_00002f20_34678000"
            & x"30050017_17a9f87c_00210342_ff006100_efa8a9c3_0e002020_00002f20_34678000";
        
        wait for 20 ns;
        res <= '1';
        
        wait for 5 ns;
        start <= '0';
        cancel <= '0';
        
        wait for 100 ns;
        start <= '1';
        cancel <= '0';
        
        wait for 50 ns;
        start <= '1';
        cancel <= '1';
        
        wait for 20 ns;
        start <= '0';
        cancel <= '1';
        
        wait for 50 ns;
        start <= '0';
        cancel <= '0';
        
        wait for 200 ns;
        start <= '1';
        cancel <= '0';
        
        wait for 50 ns;
        start <= '0';
        cancel <= '0';
        
        wait for 200 ns;
        start <= '1';
        cancel <= '0';
        
        wait for 1000 ns;
        -- encoding of empty string
        H_input <= x"6a09e667_bb67ae85_3c6ef372_a54ff53a_510e527f_9b05688c_1f83d9ab_5be0cd19";
        m_block <= ( (32 * 16)-1 => '1', others => '0');
        
        wait for 1000 ns;
        start <= '0';
        cancel <= '0';
        
        wait;
    end process;
end Behavioral;
