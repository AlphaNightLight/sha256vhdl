----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 24.05.2024 14:30:21
-- Design Name: testbench_block_routine_dp
-- Module Name: testbench_block_routine_dp - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: testbench for the datapath part of the 64-cycles routine
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD.ALL, work.block_routine_dp
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

entity testbench_block_routine_dp is
--  Port ( );
end testbench_block_routine_dp;

architecture Behavioral of testbench_block_routine_dp is
        -- Control Signals
        signal clk : std_logic;
        signal res : std_logic; -- active low
        
        signal load_external_H : std_logic;
        signal load_external_abcdefgh : std_logic;
        signal update_abcdefgh : std_logic;
        signal reset_k : std_logic;
        signal shift_k : std_logic;
        signal load_external_m_block : std_logic;
        signal shift_w : std_logic;
        
        -- Data Inputs:
        signal H_input : unsigned ( (32 * 8)-1 downto 0); -- (word_size * H_number)-1 downto 0
        signal m_block : unsigned ( (32 * 16)-1 downto 0); -- (word_size * w_number)-1 downto 0
        
        -- Output:
        signal H_output : unsigned ( (32 * 8)-1 downto 0); -- (word_size * H_number)-1 downto 0
begin
    block_routine_dp : entity work.block_routine_dp generic map (word_size=>32) port map(
        clk=>clk, res=>res,
        load_external_H=>load_external_H, load_external_abcdefgh=>load_external_abcdefgh, update_abcdefgh=>update_abcdefgh,
        reset_k=>reset_k, shift_k=>shift_k, load_external_m_block=>load_external_m_block, shift_w=>shift_w,
        H_input=>H_input, m_block=>m_block, H_output=>H_output
    );
    
    clk_process : process is begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;
    
    test : process is begin
        res <= '0';
        
        load_external_H <= '1';
        load_external_abcdefgh <= '1';
        update_abcdefgh <= '1';
        reset_k <= '1';
        shift_k <= '1';
        load_external_m_block <= '1';
        shift_w <= '1';
        
        H_input <= x"0e002020_ff006100_30050017_17a9f87c_00002f20_34678000_efa8a9c3_00210342";
        m_block <= x"30050017_17a9f87c_00210342_ff006100_efa8a9c3_0e002020_00002f20_34678000"
            & x"30050017_17a9f87c_00210342_ff006100_efa8a9c3_0e002020_00002f20_34678000";
        
        wait for 20 ns;
        res <= '1';
        
        -- Wait state
        wait for 5 ns;
        load_external_H <= '0';
        load_external_abcdefgh <= '0';
        update_abcdefgh <= '0';
        reset_k <= '0';
        shift_k <= '0';
        load_external_m_block <= '0';
        shift_w <= '0';
        
        -- Start state
        wait for 100 ns;
        load_external_H <= '1';
        load_external_abcdefgh <= '1';
        update_abcdefgh <= '1';
        reset_k <= '1';
        shift_k <= '0';
        load_external_m_block <= '1';
        shift_w <= '0';
        
        -- Freeze
        wait for 100 ns;
        load_external_H <= '0';
        load_external_abcdefgh <= '0';
        update_abcdefgh <= '0';
        reset_k <= '0';
        shift_k <= '0';
        load_external_m_block <= '0';
        shift_w <= '0';
        
        -- Run state
        wait for 100 ns;
        load_external_H <= '0';
        load_external_abcdefgh <= '0';
        update_abcdefgh <= '1';
        reset_k <= '0';
        shift_k <= '1';
        load_external_m_block <= '0';
        shift_w <= '1';
        
        -- Freeze
        wait for 500 ns;
        load_external_H <= '0';
        load_external_abcdefgh <= '0';
        update_abcdefgh <= '0';
        reset_k <= '0';
        shift_k <= '0';
        load_external_m_block <= '0';
        shift_w <= '0';
        
        wait;
    end process;
    
end Behavioral;
