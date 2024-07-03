----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 02.07.2024 12:56:31
-- Design Name: testbench_bitcoin_miner_fsm
-- Module Name: testbench_bitcoin_miner_fsm - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: testbench for the finite state machine part of the bitcoin miner
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD.ALL, work.bitcoin_miner_fsm
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

entity testbench_bitcoin_miner_fsm is
--  Port ( );
end testbench_bitcoin_miner_fsm;

architecture Behavioral of testbench_bitcoin_miner_fsm is
    signal clk : std_logic;
    signal res : std_logic; -- active low
    
    -- Datapath Control Signals out
    signal load_first_block, load_second_block_stem, load_start_nonce, load_difficulty : std_logic;
    signal nonce_count_en, reset_nonce : std_logic;
    signal update_mid_H, update_inner_hash, use_mid_H, use_inner_block, use_second_block : std_logic;
    signal start_block_routine : std_logic;
    
    -- Datapath Control Signals in
    signal busy_block_routine, valid_block_routine : std_logic;
    signal nonce_tc, you_won : std_logic;
    
    -- Status Signals
    signal start, cancel : std_logic;
    signal busy, nonce_found, nonce_overflow, error : std_logic;
begin
    bitcoin_miner_fsm : entity work.bitcoin_miner_fsm port map(
        clk=>clk, res=>res,
        load_first_block=>load_first_block, load_second_block_stem=>load_second_block_stem,
        load_start_nonce=>load_start_nonce, load_difficulty=>load_difficulty, nonce_count_en=>nonce_count_en,
        reset_nonce=>reset_nonce, update_mid_H=>update_mid_H, update_inner_hash=>update_inner_hash, use_mid_H=>use_mid_H,
        use_inner_block=>use_inner_block, use_second_block=>use_second_block,
        start_block_routine=>start_block_routine,
        
        busy_block_routine=>busy_block_routine, valid_block_routine=>valid_block_routine,
        nonce_tc=>nonce_tc, you_won=>you_won,
        start=>start, cancel=>cancel, busy=>busy, nonce_found=>nonce_found, nonce_overflow=>nonce_overflow, error=>error
    );
    
    clk_process : process is begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;
    
    test : process is begin
        res <= '0';
        busy_block_routine <= '0';
        valid_block_routine <= '0';
        nonce_tc <= '0';
        you_won <= '0';
        start <= '1';
        cancel <= '1';
        
        wait for 20 ns;
        res <= '1';
        
        
        
        -- Path for cancel
        wait for 5 ns; -- wait_s
        busy_block_routine <= '0';
        valid_block_routine <= '0';
        nonce_tc <= '0';
        you_won <= '0';
        start <= '0';
        cancel <= '0';
        
        wait for 100 ns; -- wait_s
        busy_block_routine <= '0';
        valid_block_routine <= '0';
        nonce_tc <= '0';
        you_won <= '0';
        start <= '1';
        cancel <= '0';
        
        wait for 50 ns; -- load_s
        busy_block_routine <= '0';
        valid_block_routine <= '0';
        nonce_tc <= '0';
        you_won <= '0';
        start <= '1';
        cancel <= '1';
        
        wait for 20 ns; -- wait_s
        busy_block_routine <= '0';
        valid_block_routine <= '0';
        nonce_tc <= '0';
        you_won <= '0';
        start <= '0';
        cancel <= '1';
        
        wait for 50 ns; -- wait_s
        busy_block_routine <= '0';
        valid_block_routine <= '0';
        nonce_tc <= '0';
        you_won <= '0';
        start <= '0';
        cancel <= '0';
        
        
        
        -- Path for next_count_s, then found_final_s
        wait for 200 ns; -- wait_s
        busy_block_routine <= '0';
        valid_block_routine <= '0';
        nonce_tc <= '0';
        you_won <= '0';
        start <= '1';
        cancel <= '0';
        
        wait for 50 ns; -- load_s, start_first_s
        busy_block_routine <= '1';
        valid_block_routine <= '0';
        nonce_tc <= '0';
        you_won <= '0';
        start <= '0';
        cancel <= '0';
        
        wait for 200 ns; -- routine_first_s
        busy_block_routine <= '0';
        valid_block_routine <= '1';
        nonce_tc <= '0';
        you_won <= '0';
        start <= '0';
        cancel <= '0';
        
        wait for 40 ns; -- update_midh_s, start_second_s
        busy_block_routine <= '1';
        valid_block_routine <= '0';
        nonce_tc <= '0';
        you_won <= '0';
        start <= '0';
        cancel <= '0';
        
        wait for 200 ns; -- routine_second_s
        busy_block_routine <= '0';
        valid_block_routine <= '1';
        nonce_tc <= '0';
        you_won <= '0';
        start <= '0';
        cancel <= '0';
        
        wait for 40 ns; -- update_inner_s, start_third_s
        busy_block_routine <= '1';
        valid_block_routine <= '0';
        nonce_tc <= '0';
        you_won <= '0';
        start <= '0';
        cancel <= '0';
        
        wait for 200 ns; -- routine_third_s
        busy_block_routine <= '0';
        valid_block_routine <= '1';
        nonce_tc <= '0';
        you_won <= '0';
        start <= '0';
        cancel <= '0';
        
        wait for 20 ns; -- next_count_s, start_second_s
        busy_block_routine <= '1';
        valid_block_routine <= '0';
        nonce_tc <= '0';
        you_won <= '0';
        start <= '0';
        cancel <= '0';
        
        wait for 200 ns; -- routine_second_s
        busy_block_routine <= '0';
        valid_block_routine <= '1';
        nonce_tc <= '0';
        you_won <= '0';
        start <= '0';
        cancel <= '0';
        
        wait for 40 ns; -- update_inner_s, start_third_s
        busy_block_routine <= '1';
        valid_block_routine <= '0';
        nonce_tc <= '0';
        you_won <= '0';
        start <= '0';
        cancel <= '0';
        
        wait for 200 ns; -- routine_third_s
        busy_block_routine <= '0';
        valid_block_routine <= '1';
        nonce_tc <= '0';
        you_won <= '1';
        start <= '0';
        cancel <= '0';
        -- found_final_s
        
        
        
        -- Path for overflow_final_s
        wait for 200 ns; -- found_final_s
        busy_block_routine <= '0';
        valid_block_routine <= '0';
        nonce_tc <= '0';
        you_won <= '0';
        start <= '1';
        cancel <= '0';
        
        wait for 50 ns; -- load_s, start_first_s
        busy_block_routine <= '1';
        valid_block_routine <= '0';
        nonce_tc <= '0';
        you_won <= '0';
        start <= '0';
        cancel <= '0';
        
        wait for 200 ns; -- routine_first_s
        busy_block_routine <= '0';
        valid_block_routine <= '1';
        nonce_tc <= '0';
        you_won <= '0';
        start <= '0';
        cancel <= '0';
        
        wait for 40 ns; -- update_midh_s, start_second_s
        busy_block_routine <= '1';
        valid_block_routine <= '0';
        nonce_tc <= '0';
        you_won <= '0';
        start <= '0';
        cancel <= '0';
        
        wait for 200 ns; -- routine_second_s
        busy_block_routine <= '0';
        valid_block_routine <= '1';
        nonce_tc <= '0';
        you_won <= '0';
        start <= '0';
        cancel <= '0';
        
        wait for 40 ns; -- update_inner_s, start_third_s
        busy_block_routine <= '1';
        valid_block_routine <= '0';
        nonce_tc <= '0';
        you_won <= '0';
        start <= '0';
        cancel <= '0';
        
        wait for 200 ns; -- routine_third_s
        busy_block_routine <= '0';
        valid_block_routine <= '1';
        nonce_tc <= '1';
        you_won <= '0';
        start <= '0';
        cancel <= '0';
        -- overflow_final_s
        
        
        
        -- Path for error_s
        wait for 200 ns; -- overflow_final_s
        busy_block_routine <= '0';
        valid_block_routine <= '0';
        nonce_tc <= '0';
        you_won <= '0';
        start <= '1';
        cancel <= '0';
        
        wait for 50 ns; -- load_s, start_first_s
        busy_block_routine <= '1';
        valid_block_routine <= '0';
        nonce_tc <= '0';
        you_won <= '0';
        start <= '0';
        cancel <= '0';
        
        wait for 200 ns; -- routine_first_s
        busy_block_routine <= '0';
        valid_block_routine <= '1';
        nonce_tc <= '0';
        you_won <= '0';
        start <= '0';
        cancel <= '0';
        
        wait for 40 ns; -- update_midh_s, start_second_s
        busy_block_routine <= '1';
        valid_block_routine <= '0';
        nonce_tc <= '0';
        you_won <= '0';
        start <= '0';
        cancel <= '0';
        
        wait for 200 ns; -- routine_second_s
        busy_block_routine <= '0';
        valid_block_routine <= '1';
        nonce_tc <= '0';
        you_won <= '0';
        start <= '0';
        cancel <= '0';
        
        wait for 40 ns; -- update_inner_s, start_third_s
        busy_block_routine <= '1';
        valid_block_routine <= '0';
        nonce_tc <= '0';
        you_won <= '0';
        start <= '0';
        cancel <= '0';
        
        wait for 200 ns; -- routine_third_s
        busy_block_routine <= '0';
        valid_block_routine <= '0';
        nonce_tc <= '1';
        you_won <= '1';
        start <= '0';
        cancel <= '0';
        -- error_s
        
        wait;
    end process;
    
end Behavioral;
