----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 28.06.2024 17:59:37
-- Design Name: testbench_bitcoin_miner_dp
-- Module Name: testbench_bitcoin_miner_dp - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: testbench for the datapath part of the bitcoin miner
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD.ALL, work.bitcoin_miner_dp
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

entity testbench_bitcoin_miner_dp is
--  Port ( );
end testbench_bitcoin_miner_dp;

architecture Behavioral of testbench_bitcoin_miner_dp is
    signal clk : std_logic;
    signal res : std_logic; -- active low
    
    -- Input Data
    signal version : unsigned ( 32-1 downto 0); -- word_size-1 downto 0
    signal previous_block_hash : unsigned ( 256-1 downto 0); -- H_size-1 downto 0
    signal merkle_root : unsigned ( 256-1 downto 0); -- H_size-1 downto 0
    signal timestamp : unsigned ( 32-1 downto 0); -- word_size-1 downto 0
    signal bits : unsigned ( 32-1 downto 0); -- word_size-1 downto 0
    signal start_nonce : unsigned ( 32-1 downto 0); -- word_size-1 downto 0
    
    -- Output Data
    signal header : unsigned ( 640-1 downto 0); -- ( word_size+H_size+H_size+word_size+word_size+word_size - 1) downto 0
    signal header_hash : unsigned ( 256-1 downto 0); -- H_size-1 downto 0
    signal winning_nonce : unsigned ( 32-1 downto 0); -- word_size-1 downto 0
    
    -- Control Signals
    signal load_first_block, load_second_block_stem, load_start_nonce, load_difficulty : std_logic;
    signal nonce_count_en, reset_nonce : std_logic;
    signal update_mid_H, update_inner_hash, use_mid_H, use_inner_block, use_second_block : std_logic;
    signal start_block_routine, cancel_block_routine : std_logic;
    signal busy_block_routine, valid_block_routine : std_logic;
    signal nonce_tc, you_won : std_logic;
begin
    bitcoin_miner_dp : entity work.bitcoin_miner_dp port map(
        clk=>clk, res=>res,
        version=>version, previous_block_hash=>previous_block_hash, merkle_root=>merkle_root,
        timestamp=>timestamp, bits=>bits, start_nonce=>start_nonce,
        header=>header, header_hash=>header_hash, winning_nonce=>winning_nonce,
        
        load_first_block=>load_first_block, load_second_block_stem=>load_second_block_stem,
        load_start_nonce=>load_start_nonce, load_difficulty=>load_difficulty, nonce_count_en=>nonce_count_en,
        reset_nonce=>reset_nonce, update_mid_H=>update_mid_H, update_inner_hash=>update_inner_hash, use_mid_H=>use_mid_H,
        use_second_block=>use_second_block, use_inner_block=>use_inner_block,
        start_block_routine=>start_block_routine, cancel_block_routine=>cancel_block_routine,
        busy_block_routine=>busy_block_routine, valid_block_routine=>valid_block_routine,
        nonce_tc=>nonce_tc, you_won=>you_won
    );
    
    clk_process : process is begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;
    
    test : process is begin
        res <= '0';
        
        version <= x"00000002";
        previous_block_hash <= x"00000000_00000001_17c80378_b8da0e33_559b5997_f2ad55e2_f7d18ec1_975b9717";
        merkle_root <= x"871714dc_bae6c819_3a2bb9b2_a69fe1c0_440399f3_8d94b3a0_f1b44727_5a29978a";
        timestamp <= x"53058b35";
        bits <= x"19015f53";
        start_nonce <= x"33087548";
        
        load_first_block <= '0';
        load_second_block_stem <= '0';
        load_start_nonce <= '0';
        load_difficulty <= '0';
        
        nonce_count_en <= '0';
        reset_nonce <= '0';
        
        update_mid_H <= '0';
        update_inner_hash <= '0';
        use_mid_H <= '0';
        use_inner_block <= '0';
        use_second_block <= '0';
        
        start_block_routine <= '0';
        cancel_block_routine <= '0';
        
        wait for 20 ns;
        res <= '1';
        
        wait for 20 ns;
        load_first_block <= '1';
        load_second_block_stem <= '1';
        load_start_nonce <= '1';
        load_difficulty <= '1';
        
        nonce_count_en <= '0';
        reset_nonce <= '0';
        
        update_mid_H <= '0';
        update_inner_hash <= '0';
        use_mid_H <= '0';
        use_inner_block <= '0';
        use_second_block <= '0';
        
        start_block_routine <= '0';
        cancel_block_routine <= '0';
        
        wait for 20 ns;
        load_first_block <= '0';
        load_second_block_stem <= '0';
        load_start_nonce <= '0';
        load_difficulty <= '0';
        
        nonce_count_en <= '0';
        reset_nonce <= '0';
        
        update_mid_H <= '0';
        update_inner_hash <= '0';
        use_mid_H <= '0';
        use_inner_block <= '0';
        use_second_block <= '0';
        
        start_block_routine <= '0';
        cancel_block_routine <= '0';
        
        wait;
    end process;
    
end Behavioral;
