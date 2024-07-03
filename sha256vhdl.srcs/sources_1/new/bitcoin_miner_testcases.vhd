----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 03.07.2024 16:12:54
-- Design Name: bitcoin_miner_testcases
-- Module Name: bitcoin_miner_testcases - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: a component to select the proper testcase in bitcoin_miner_top_level
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD.ALL
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

entity bitcoin_miner_testcases is
    Port (
        select_input : in std_logic_vector ( 1 downto 0);
        
        version : out unsigned ( 32-1 downto 0);
        previous_block_hash : out unsigned ( 256-1 downto 0);
        merkle_root : out unsigned ( 256-1 downto 0);
        timestamp : out unsigned ( 32-1 downto 0);
        bits : out unsigned ( 32-1 downto 0);
        start_nonce : out unsigned ( 32-1 downto 0)
    );
end bitcoin_miner_testcases;

architecture Behavioral of bitcoin_miner_testcases is
    -- Testcase 1, up button
    constant tc1_version : unsigned ( 32-1 downto 0) := x"00000002";
    constant tc1_previous_block_hash : unsigned ( 256-1 downto 0) :=
        x"00000000_00000001_17c80378_b8da0e33_559b5997_f2ad55e2_f7d18ec1_975b9717";
    constant tc1_merkle_root : unsigned ( 256-1 downto 0) :=
        x"871714dc_bae6c819_3a2bb9b2_a69fe1c0_440399f3_8d94b3a0_f1b44727_5a29978a";
    constant tc1_timestamp : unsigned ( 32-1 downto 0) := x"53058b35";
    constant tc1_bits : unsigned ( 32-1 downto 0) := x"19015f53";
    constant tc1_start_nonce : unsigned ( 32-1 downto 0) := x"33080000"; -- winning nonce is 0x33087548
    
    -- Testcase 2, right button
    constant tc2_version : unsigned ( 32-1 downto 0) := x"00000002";
    constant tc2_previous_block_hash : unsigned ( 256-1 downto 0) :=
        x"00000000_00000000_0cca48eb_4b330d91_e8d946d3_44ca302a_86a28016_1b0bffb6";
    constant tc2_merkle_root : unsigned ( 256-1 downto 0) :=
        x"7114b3aa_8a049bbc_12cdde10_08a2dd70_e2ed045f_698593ca_869394ee_52aa109d";
    constant tc2_timestamp : unsigned ( 32-1 downto 0) := x"545ad924";
    constant tc2_bits : unsigned ( 32-1 downto 0) := x"181bc330";
    constant tc2_start_nonce : unsigned ( 32-1 downto 0) := x"64080000"; -- winning nonce is 0x64089ffe
    
    -- Testcase 3, down button
    constant tc3_version : unsigned ( 32-1 downto 0) := x"00000001";
    constant tc3_previous_block_hash : unsigned ( 256-1 downto 0) :=
        x"00000000_0019d668_9c085ae1_65831e93_4ff763ae_46a2a6c1_72b3f1b6_0a8ce26f";
    constant tc3_merkle_root : unsigned ( 256-1 downto 0) :=
        x"0e3e2357_e806b6cd_b1f70b54_c3a3a17b_6714ee1f_0e68bebb_44a74b1e_fd512098";
    constant tc3_timestamp : unsigned ( 32-1 downto 0) := x"4966bc61";
    constant tc3_bits : unsigned ( 32-1 downto 0) := x"1d00ffff";
    constant tc3_start_nonce : unsigned ( 32-1 downto 0) := x"99620000"; -- winning nonce is 0x9962e301
    
    -- Testcase 4, left button
    constant tc4_version : unsigned ( 32-1 downto 0) := x"20000000";
    constant tc4_previous_block_hash : unsigned ( 256-1 downto 0) :=
        x"00000000_00000000_0006f9d2_93318f62_c877a818_3c2d127d_f51cf623_76757358";
    constant tc4_merkle_root : unsigned ( 256-1 downto 0) :=
        x"919e4fde_731369e7_5a1177a8_075ebfd4_7fa29827_027f6491_5e00858a_676c6b5c";
    constant tc4_timestamp : unsigned ( 32-1 downto 0) := x"5f47802b";
    constant tc4_bits : unsigned ( 32-1 downto 0) := x"171007ea";
    constant tc4_start_nonce : unsigned ( 32-1 downto 0) := x"97dc0000"; -- winning nonce is 0x97dc5290
begin
    with select_input select version <=
        tc1_version when "00",
        tc2_version when "01",
        tc3_version when "10",
        tc4_version when "11",
        ( others => '0' ) when others;
        
    with select_input select previous_block_hash <=
        tc1_previous_block_hash when "00",
        tc2_previous_block_hash when "01",
        tc3_previous_block_hash when "10",
        tc4_previous_block_hash when "11",
        ( others => '0' ) when others;
        
    with select_input select merkle_root <=
        tc1_merkle_root when "00",
        tc2_merkle_root when "01",
        tc3_merkle_root when "10",
        tc4_merkle_root when "11",
        ( others => '0' ) when others;
        
    with select_input select timestamp <=
        tc1_timestamp when "00",
        tc2_timestamp when "01",
        tc3_timestamp when "10",
        tc4_timestamp when "11",
        ( others => '0' ) when others;
        
    with select_input select bits <=
        tc1_bits when "00",
        tc2_bits when "01",
        tc3_bits when "10",
        tc4_bits when "11",
        ( others => '0' ) when others;
        
    with select_input select start_nonce <=
        tc1_start_nonce when "00",
        tc2_start_nonce when "01",
        tc3_start_nonce when "10",
        tc4_start_nonce when "11",
        ( others => '0' ) when others;
        
end Behavioral;
