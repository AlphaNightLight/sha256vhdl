----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 27.06.2024 21:06:40
-- Design Name: bitcoin_miner_dp
-- Module Name: bitcoin_miner_dp - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: the datapath of the bitcoin miner
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD.ALL, work.block_routine, work.register_file,
-- work.ripple_carry_adder, work.hierarchical_comparator, work.difficulty_decoder, work.counter
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

entity bitcoin_miner_dp is
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
        
        
        
        -- Control Signals
        load_first_block : in std_logic;
        load_second_block_stem : in std_logic;
        load_start_nonce : in std_logic;
        load_difficulty : in std_logic;
        
        nonce_count_en : in std_logic;
        reset_nonce : in std_logic;
        
        update_mid_H : in std_logic;
        update_inner_hash : in std_logic;
        use_mid_H : in std_logic;
        use_inner_block : in std_logic;
        use_second_block : in std_logic;
        
        start_block_routine : in std_logic; -- when it goes to 1 the machine exits the wait state
        cancel_block_routine : in std_logic; -- synchronous reset, active high
        
        busy_block_routine : out std_logic; -- 1 when machine is computing
        valid_block_routine : out std_logic; -- 1 when the output hash is valid
        
        nonce_tc : out std_logic;
        you_won : out std_logic
    );
end bitcoin_miner_dp;

architecture Behavioral of bitcoin_miner_dp is
    -- Constants
    constant word_size : natural := 32;
    constant H_size : natural := 256;
    constant block_size : natural := 512;
    
    constant start_H : unsigned ( H_size-1 downto 0 ) :=
        x"6a09e667" & x"bb67ae85" & x"3c6ef372" & x"a54ff53a" & x"510e527f" & x"9b05688c" & x"1f83d9ab" & x"5be0cd19"
    ;
    
    -- Connection Signals
    signal reversed_previous_block_hash : unsigned ( H_size-1 downto 0 );
    signal reversed_merkle_root : unsigned ( H_size-1 downto 0 );
    signal version_little_endian : unsigned ( word_size-1 downto 0);
    signal timestamp_little_endian : unsigned ( word_size-1 downto 0);
    signal bits_little_endian : unsigned ( word_size-1 downto 0);
    
    signal first_block : unsigned ( block_size-1 downto 0 );
    signal buffered_first_block : unsigned ( block_size-1 downto 0 );
    
    signal second_block_stem : unsigned ( block_size-1 downto 0 );
    signal buffered_stem : unsigned ( block_size-1 downto 0 );
    signal second_block : unsigned ( block_size-1 downto 0 );
    
    signal buffered_start_nonce : unsigned ( word_size-1 downto 0 );
    signal nonce_count : unsigned ( word_size-1 downto 0 );
    signal nonce : unsigned ( word_size-1 downto 0 );
    signal nonce_little_endian : unsigned ( word_size-1 downto 0 );
    
    signal buffered_inner_hash : unsigned ( H_size-1 downto 0 );
    signal inner_block : unsigned ( block_size-1 downto 0 );
    signal first_or_inner : unsigned ( block_size-1 downto 0 );
    
    signal difficulty : unsigned ( H_size-1 downto 0 );
    signal buffered_difficulty : unsigned ( H_size-1 downto 0 );
    
    signal mid_H : unsigned ( H_size-1 downto 0 );
    signal H_input : unsigned ( H_size-1 downto 0 );
    signal m_block : unsigned ( block_size-1 downto 0 );
    signal output_hash : unsigned ( H_size-1 downto 0 );
    signal reversed_output_hash : unsigned ( H_size-1 downto 0 );
begin
    -- First block construction
    
    reverse_signals : for i in 0 to (H_size/8)-1 generate
        reversed_previous_block_hash( ((i+1)*8)-1 downto i*8 ) <= previous_block_hash( H_size-(i*8)-1 downto H_size-((i+1)*8) );
        reversed_merkle_root( ((i+1)*8)-1 downto i*8 ) <= merkle_root( H_size-(i*8)-1 downto H_size-((i+1)*8) );
    end generate reverse_signals; -- Reverse the endiannity
    
    reverse_endiannity : for i in 0 to (word_size/8)-1 generate
        version_little_endian( ((i+1)*8)-1 downto i*8 ) <= version( word_size-(i*8)-1 downto word_size-((i+1)*8) );
        timestamp_little_endian( ((i+1)*8)-1 downto i*8 ) <= timestamp( word_size-(i*8)-1 downto word_size-((i+1)*8) );
        bits_little_endian( ((i+1)*8)-1 downto i*8 ) <= bits( word_size-(i*8)-1 downto word_size-((i+1)*8) );
        nonce_little_endian( ((i+1)*8)-1 downto i*8 ) <= nonce( word_size-(i*8)-1 downto word_size-((i+1)*8) );
    end generate reverse_endiannity; -- Reverse the endiannity
    
    first_block( block_size-1 downto block_size-word_size ) <= version_little_endian;
    first_block( (block_size-word_size)-1 downto (block_size-word_size-H_size) ) <= reversed_previous_block_hash;
    first_block( (block_size-word_size-H_size)-1 downto 0 ) <= reversed_merkle_root( H_size-1 downto word_size );
    
    reg_first_block : entity work.register_file generic map (word_size=>block_size, word_number=>1) port map(
        clk=>clk, res=>res, load_en=>load_first_block, H_in=>first_block, H_out=>buffered_first_block
    );
    
    -- Second block's stem construction
    
    second_block_stem( block_size-1 downto block_size-word_size ) <= reversed_merkle_root( word_size-1 downto 0 );
    second_block_stem( (block_size-word_size)-1 downto ( block_size-(2*word_size) ) ) <= timestamp_little_endian;
    second_block_stem( ( block_size-(2*word_size) )-1 downto ( block_size-(3*word_size) ) ) <= bits_little_endian;
    second_block_stem( ( block_size-(3*word_size) )-1 downto ( block_size-(4*word_size) ) ) <= x"00000000"; -- placeholder for nonce
    second_block_stem( ( block_size-(4*word_size) )-1 ) <= '1';
    second_block_stem( ( block_size-(4*word_size) )-2 downto 64) <= (others => '0');
    second_block_stem( 64-1 downto 0) <= x"00000000_00000280"; -- 640, the size of the header
    
    reg_second_block_stem : entity work.register_file generic map (word_size=>block_size, word_number=>1) port map(
        clk=>clk, res=>res, load_en=>load_second_block_stem, H_in=>second_block_stem, H_out=>buffered_stem
    );
    
    -- Nonce management
    
    reg_start_nonce : entity work.register_file generic map (word_size=>word_size, word_number=>1) port map(
        clk=>clk, res=>res, load_en=>load_start_nonce, H_in=>start_nonce, H_out=>buffered_start_nonce
    );
    
    nonce_counter : entity work.counter generic map (dim=>word_size) port map(
        clk=>clk, res=>res, count_en=>nonce_count_en, goto_zero=>reset_nonce, count=>nonce_count, tc=>nonce_tc
    );
    
    adder : entity work.ripple_carry_adder generic map (dim=>word_size) port map(
        a=>buffered_start_nonce, b=>nonce_count, cin=>'0', s=>nonce -- no need for cout
    );
    
    winning_nonce <= nonce;
    
    -- Second block and header construction
    
    second_block( block_size-1 downto block_size-(3*word_size) ) <= buffered_stem( block_size-1 downto block_size-(3*word_size) );
    second_block( ( block_size-(3*word_size) )-1 downto ( block_size-(4*word_size) ) ) <= nonce_little_endian;
    second_block( ( block_size-(4*word_size) )-1 downto 0 ) <= buffered_stem( ( block_size-(4*word_size) )-1 downto 0 );
    
    header( 640-1 downto (640-block_size) ) <= buffered_first_block;
    header( (640-block_size)-1 downto 0 ) <= second_block( block_size-1 downto (block_size-4*(word_size)) );
    
    -- Inner block construction
    
    reg_inner_hash : entity work.register_file generic map (word_size=>H_size, word_number=>1) port map(
        clk=>clk, res=>res, load_en=>update_inner_hash, H_in=>output_hash, H_out=>buffered_inner_hash
    );
    
    inner_block( block_size-1 downto block_size-H_size ) <= buffered_inner_hash;
    inner_block( block_size-H_size-1 ) <= '1';
    inner_block( block_size-H_size-2 downto 64 ) <= (others => '0');
    inner_block( 64-1 downto 0 ) <= x"00000000_00000100";
    
    -- Manage difficulty
    
    difficulty_decoder : entity work.difficulty_decoder port map(
        bits=>bits, difficulty=>difficulty
    );
    
    reg_difficulty : entity work.register_file generic map (word_size=>H_size, word_number=>1) port map(
        clk=>clk, res=>res, load_en=>load_difficulty, H_in=>difficulty, H_out=>buffered_difficulty
    );
    
    -- Decide the input to the hash
    
    reg_mid_H : entity work.register_file generic map (word_size=>H_size, word_number=>1) port map(
        clk=>clk, res=>res, load_en=>update_mid_H, H_in=>output_hash, H_out=>mid_H
    );
    
    H_input <= start_H when use_mid_H = '0' else mid_H;
    
    first_or_inner <= buffered_first_block when use_inner_block = '0' else inner_block;
    m_block <= first_or_inner when use_second_block = '0' else second_block;
    
    -- Create the hash and verify if it meets the difficulty
    
    block_routine : entity work.block_routine generic map (word_size=>32, clock_dim=>6) port map(
        clk=>clk, res=>res, m_block=>m_block, H_input=>H_input, H_output=>output_hash,
        start=>start_block_routine, cancel=>cancel_block_routine, busy=>busy_block_routine, valid=>valid_block_routine
    );
    
    reverse_output_hash : for i in 0 to (H_size/8)-1 generate
        reversed_output_hash( ((i+1)*8)-1 downto i*8 ) <= output_hash( H_size-(i*8)-1 downto H_size-((i+1)*8) );
    end generate reverse_output_hash; -- Reverse the endiannity
    
    header_hash <= reversed_output_hash;
    
    hierarchical_comparator : entity work.hierarchical_comparator generic map (dim=>H_size) port map(
        a=>reversed_output_hash, b=>buffered_difficulty, aleb=>you_won -- no need for other outputs
    );
    
end Behavioral;
