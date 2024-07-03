----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 02.07.2024 18:02:41
-- Design Name: testbench_bitcoin_miner
-- Module Name: testbench_bitcoin_miner - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: testbench for the bitcoin miner
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD.ALL, work.bitcoin_miner
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

entity testbench_bitcoin_miner is
--  Port ( );
end testbench_bitcoin_miner;

architecture Behavioral of testbench_bitcoin_miner is
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
    
    -- Input Status Signals
    signal start : std_logic; -- when it goes to 1 the machine exits the wait-like states
    signal cancel : std_logic; -- synchronous reset, active high
    
    -- Output Status Signals
    signal busy : std_logic; -- 1 when the machine is computing
    signal nonce_found : std_logic; -- 1 when a valid nonce is found
    signal nonce_overflow : std_logic; -- 1 when the counter reach terminal count, i.e. there's no valid nonce
    signal error : std_logic; -- 1 when some error happened
begin
    bitcoin_miner : entity work.bitcoin_miner port map(
        clk=>clk, res=>res,
        version=>version, previous_block_hash=>previous_block_hash, merkle_root=>merkle_root,
        timestamp=>timestamp, bits=>bits, start_nonce=>start_nonce,
        header=>header, header_hash=>header_hash, winning_nonce=>winning_nonce,
        
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
        
        version <= x"00000002";
        previous_block_hash <= x"00000000_00000001_17c80378_b8da0e33_559b5997_f2ad55e2_f7d18ec1_975b9717";
        merkle_root <= x"871714dc_bae6c819_3a2bb9b2_a69fe1c0_440399f3_8d94b3a0_f1b44727_5a29978a";
        timestamp <= x"53058b35";
        bits <= x"19015f53";
        start_nonce <= x"33087547"; -- the winning nonce is 0x33087548,
        -- so we start from its predecessor to see two iterations.
        
        
        
--        version <= x"00000002";
--        previous_block_hash <= x"00000000_00000000_0cca48eb_4b330d91_e8d946d3_44ca302a_86a28016_1b0bffb6";
--        merkle_root <= x"7114b3aa_8a049bbc_12cdde10_08a2dd70_e2ed045f_698593ca_869394ee_52aa109d";
--        timestamp <= x"545ad924";
--        bits <= x"181bc330";
--        start_nonce <= x"64089ffe"; -- this is the winning nonce
        
        
        
        -- this is block 01 of the real blockchain:
        -- 01000000 6fe28c0ab6f1b372c1a6a246ae63f74f931e8365e15a089c68d6190000000000
        -- 982051fd1e4ba744bbbe680e1fee14677ba1a3c3540bf7b1cdb606e857233e0e 61bc6649
        -- ffff001d 01e36299 01 0100000001000000000000000000000000000000000000000000
        -- 0000000000000000000000ffffffff0704ffff001d0104ffffffff0100f2052a010000004
        -- 3410496b538e853519c726a2c91e61ec11600ae1390813a627c66fb8be7947be63c52da75
        -- 89379515d4e0a604f8141781e62294721166bf621e73a82cbf2342c858eeac00000000
--        version <= x"00000001";
--        previous_block_hash <= x"00000000_0019d668_9c085ae1_65831e93_4ff763ae_46a2a6c1_72b3f1b6_0a8ce26f";
--        merkle_root <= x"0e3e2357_e806b6cd_b1f70b54_c3a3a17b_6714ee1f_0e68bebb_44a74b1e_fd512098";
--        timestamp <= x"4966bc61";
--        bits <= x"1d00ffff";
--        start_nonce <= x"9962e301"; -- this is the winning nonce
        
        
        
--        version <= x"20000000";
--        previous_block_hash <= x"00000000_00000000_0006f9d2_93318f62_c877a818_3c2d127d_f51cf623_76757358";
--        merkle_root <= x"919e4fde_731369e7_5a1177a8_075ebfd4_7fa29827_027f6491_5e00858a_676c6b5c";
--        timestamp <= x"5f47802b";
--        bits <= x"171007ea";
--        start_nonce <= x"97dc5290"; -- this is the winning nonce
        
        
        
        start <= '0';
        cancel <= '0';
        
        wait for 20 ns;
        res <= '1';
        
        -- Test for cancel
        wait for 25 ns;
        start <= '1';
        cancel <= '0';
        
        wait for 20 ns;
        start <= '0';
        cancel <= '0';
        
        wait for 200 ns;
        start <= '0';
        cancel <= '1';
        
        wait for 20 ns;
        start <= '0';
        cancel <= '0';
        
        -- Test for two iterations (we used winning_nounce-1 as start_nonce)
        wait for 1000 ns;
        start <= '1';
        cancel <= '0';
        
        wait for 20 ns;
        start <= '0';
        cancel <= '0';
        
        wait;
    end process;
    
end Behavioral;
