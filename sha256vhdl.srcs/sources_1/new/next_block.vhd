----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 18.04.2024 14:32:51
-- Design Name: next_block
-- Module Name: next_block - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: the function that computes the current block to analyze during each round.
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD.ALL, work.ripple_carry_adder, work.compressor_3_2
-- work.low_sigma_0, work.low_sigma_1
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

entity next_block is
    generic ( word_size : natural := 32);
    Port (
        w_previous_2, w_previous_7, w_previous_15, w_previous_16 : in unsigned (word_size-1 downto 0);
        w_actual : out unsigned (word_size-1 downto 0)
    );
end next_block;

architecture Behavioral of next_block is
    signal sig_1_w2 : unsigned (word_size-1 downto 0);
    signal sig_0_w15 : unsigned (word_size-1 downto 0);
    
    signal w_2715_ps : unsigned (word_size-1 downto 0); -- sig_1_w2 + w_previous_7 + sig_0_w15, partial sum
    signal w_2715_uc : unsigned (word_size-1 downto 0); -- sig_1_w2 + w_previous_7 + sig_0_w15, unshifted carries
    signal w_2715_sc : unsigned (word_size-1 downto 0); -- sig_1_w2 + w_previous_7 + sig_0_w15, shifted carries
    signal w_actual_ps : unsigned (word_size-1 downto 0); -- sig_1_w2 + w_previous_7 + sig_0_w15 + w_previous_16, partial sum
    signal w_actual_uc : unsigned (word_size-1 downto 0); -- sig_1_w2 + w_previous_7 + sig_0_w15 + w_previous_16, unshifted carries
    signal w_actual_sc : unsigned (word_size-1 downto 0); -- sig_1_w2 + w_previous_7 + sig_0_w15 + w_previous_16, shifted carries
begin
    low_sigma_1 : entity work.low_sigma_1 generic map (dim => word_size) port map( x=>w_previous_2, sigma=>sig_1_w2 );
    low_sigma_0 : entity work.low_sigma_0 generic map (dim => word_size) port map( x=>w_previous_15, sigma=>sig_0_w15 );
    
    w_2715_compressor : entity work.compressor_3_2 generic map (dim => word_size) port map( a=>sig_1_w2, b=>w_previous_7, c=>sig_0_w15, partial_sums=>w_2715_ps, unshifted_carries=>w_2715_uc );
    w_2715_sc <= w_2715_uc sll 1;
    w_actual_compressor : entity work.compressor_3_2 generic map (dim => word_size) port map( a=>w_2715_ps, b=>w_2715_sc, c=>w_previous_16, partial_sums=>w_actual_ps, unshifted_carries=>w_actual_uc );
    w_actual_sc <= w_actual_uc sll 1;
    w_actual_adder : entity work.ripple_carry_adder generic map (dim => word_size) port map( a=>w_actual_ps, b=>w_actual_sc, cin=>'0', s=>w_actual ); -- no need for cout
    
    -- w_actual: sig_1(w_previous_2) + w_previous_7 + sig_0(w_previous_15) + w_previous_16
end Behavioral;
