----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 02.07.2024 18:02:13
-- Design Name: bitcoin_miner
-- Module Name: bitcoin_miner - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: the bitcoin miner, composed by a datapath and a finite state machine
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD.ALL, work.bitcoin_miner_dp, work.bitcoin_miner_fsm
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

entity bitcoin_miner is
    Port (
        clk : in std_logic;
        res : in std_logic; -- active low
        
        -- Input Data
        version : in unsigned ( 32-1 downto 0); -- word_size-1 downto 0
        previous_block_hash : in unsigned ( 256-1 downto 0); -- H_size-1 downto 0
        merkle_root : in unsigned ( 256-1 downto 0); -- H_size-1 downto 0
        timestamp : in unsigned ( 32-1 downto 0); -- word_size-1 downto 0
        bits : in unsigned ( 32-1 downto 0); -- word_size-1 downto 0
        start_nonce : in unsigned ( 32-1 downto 0); -- word_size-1 downto 0
        
        -- Output Data
        header : out unsigned ( 640-1 downto 0); -- ( word_size+H_size+H_size+word_size+word_size+word_size - 1) downto 0
        header_hash : out unsigned ( 256-1 downto 0); -- H_size-1 downto 0
        winning_nonce : out unsigned ( 32-1 downto 0); -- word_size-1 downto 0
        
        -- Input Status Signals
        start : in std_logic; -- when it goes to 1 the machine exits the wait-like states
        cancel : in std_logic; -- synchronous reset, active high
        
        -- Output Status Signals
        busy : out std_logic; -- 1 when the machine is computing
        nonce_found : out std_logic; -- 1 when a valid nonce is found
        nonce_overflow : out std_logic; -- 1 when the counter reach terminal count, i.e. there's no valid nonce
        error : out std_logic -- 1 when some error happened
    );
end bitcoin_miner;

architecture Behavioral of bitcoin_miner is
    -- Control Signals
    signal load_first_block, load_second_block_stem, load_start_nonce, load_difficulty : std_logic;
    signal nonce_count_en, reset_nonce : std_logic;
    signal update_mid_H, update_inner_hash, use_mid_H, use_inner_block, use_second_block : std_logic;
    signal start_block_routine : std_logic;
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
        start_block_routine=>start_block_routine, cancel_block_routine=>cancel,
        busy_block_routine=>busy_block_routine, valid_block_routine=>valid_block_routine,
        nonce_tc=>nonce_tc, you_won=>you_won
    );
    
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
    
end Behavioral;
