----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 16.04.2024 22:46:48
-- Design Name: register_update
-- Module Name: register_update - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: the function that will be called at any clock cycle during the main round.
-- It updates the core registers a, b, c, d, e, f, g, h.
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD.ALL, work.ripple_carry_adder, work.compressor_3_2
-- work.cap_sigma_0, work.cap_sigma_1, work.ch, work.maj
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

entity register_update is
    generic ( word_size : natural := 32);
    Port (
        a_in, b_in, c_in, d_in, e_in, f_in, g_in, h_in : in unsigned (word_size-1 downto 0);
        w, k : in unsigned (word_size-1 downto 0);
        a_out, b_out, c_out, d_out, e_out, f_out, g_out, h_out : out unsigned (word_size-1 downto 0)
    );
end register_update;

architecture Behavioral of register_update is
    signal sig_1_e : unsigned (word_size-1 downto 0);
    signal ch_efg : unsigned (word_size-1 downto 0);
    signal sig_0_a : unsigned (word_size-1 downto 0);
    signal maj_abc : unsigned (word_size-1 downto 0);
    
    signal hkw_ps : unsigned (word_size-1 downto 0); -- h + k + w, partial sum
    signal hkw_uc : unsigned (word_size-1 downto 0); -- h + k + w, unshifted carries
    signal hkw_sc : unsigned (word_size-1 downto 0); -- h + k + w, shifted carries
    signal hkws1_ps : unsigned (word_size-1 downto 0); -- h + k + w + sig_1_e, partial sum
    signal hkws1_uc : unsigned (word_size-1 downto 0); -- h + k + w + sig_1_e, unshifted carries
    signal hkws1_sc : unsigned (word_size-1 downto 0); -- h + k + w + sig_1_e, shifted carries
    signal shared_ps : unsigned (word_size-1 downto 0); -- h + k + w + sig_1_e + ch_efg, partial sum
    signal shared_uc : unsigned (word_size-1 downto 0); -- h + k + w + sig_1_e + ch_efg, unshifted carries
    signal shared_sc : unsigned (word_size-1 downto 0); -- h + k + w + sig_1_e + ch_efg, shifted carries
    
    signal e_out_ps : unsigned (word_size-1 downto 0); -- e_out, partial sum
    signal e_out_uc : unsigned (word_size-1 downto 0); -- e_out, unshifted carries
    signal e_out_sc : unsigned (word_size-1 downto 0); -- e_out, shifted carries
    
    signal shs0_ps : unsigned (word_size-1 downto 0); -- shared sum + sig_0_a, partial sum
    signal shs0_uc : unsigned (word_size-1 downto 0); -- shared sum + sig_0_a, unshifted carries
    signal shs0_sc : unsigned (word_size-1 downto 0); -- shared sum + sig_0_a, shifted carries
    signal a_out_ps : unsigned (word_size-1 downto 0); -- a_out, partial sum
    signal a_out_uc : unsigned (word_size-1 downto 0); -- a_out, unshifted carries
    signal a_out_sc : unsigned (word_size-1 downto 0); -- a_out, shifted carries
begin
    -- results of functions:
    cap_sigma_1 : entity work.cap_sigma_1 generic map (dim => word_size) port map( x=>e_in, sigma=>sig_1_e );
    ch : entity work.ch generic map (dim => word_size) port map( x=>e_in, y=>f_in, z=>g_in, ch_out=>ch_efg );
    cap_sigma_0 : entity work.cap_sigma_0 generic map (dim => word_size) port map( x=>a_in, sigma=>sig_0_a );
    maj : entity work.maj generic map (dim => word_size) port map( x=>a_in, y=>b_in, z=>c_in, maj_out=>maj_abc );
    
    -- sum shared between e_out and a_out:
    hkw_compressor : entity work.compressor_3_2 generic map (dim => word_size) port map( a=>h_in, b=>k, c=>w, partial_sums=>hkw_ps, unshifted_carries=>hkw_uc );
    hkw_sc <= hkw_uc sll 1;
    hkws1_compressor : entity work.compressor_3_2 generic map (dim => word_size) port map( a=>hkw_ps, b=>hkw_sc, c=>sig_1_e, partial_sums=>hkws1_ps, unshifted_carries=>hkws1_uc );
    hkws1_sc <= hkws1_uc sll 1;
    shared_compressor : entity work.compressor_3_2 generic map (dim => word_size) port map( a=>hkws1_ps, b=>hkws1_sc, c=>ch_efg, partial_sums=>shared_ps, unshifted_carries=>shared_uc );
    shared_sc <= shared_uc sll 1;
    
    -- sum for e_out:
    e_out_compressor : entity work.compressor_3_2 generic map (dim => word_size) port map( a=>shared_ps, b=>shared_sc, c=>d_in, partial_sums=>e_out_ps, unshifted_carries=>e_out_uc );
    e_out_sc <= e_out_uc sll 1;
    e_out_adder : entity work.ripple_carry_adder generic map (dim => word_size) port map( a=>e_out_ps, b=>e_out_sc, cin=>'0', s=>e_out ); -- no need for cout
    
    -- sum for a_out:
    shs0_compressor : entity work.compressor_3_2 generic map (dim => word_size) port map( a=>shared_ps, b=>shared_sc, c=>sig_0_a, partial_sums=>shs0_ps, unshifted_carries=>shs0_uc );
    shs0_sc <= shs0_uc sll 1;
    a_out_compressor : entity work.compressor_3_2 generic map (dim => word_size) port map( a=>shs0_ps, b=>shs0_sc, c=>maj_abc, partial_sums=>a_out_ps, unshifted_carries=>a_out_uc );
    a_out_sc <= a_out_uc sll 1;
    a_out_adder : entity work.ripple_carry_adder generic map (dim => word_size) port map( a=>a_out_ps, b=>a_out_sc, cin=>'0', s=>a_out ); -- no need for cout
    
    -- shift of other registers:
    h_out <= g_in;
    g_out <= f_in;
    f_out <= e_in;
    -- e_out: d_in + (h + SIG_1(e) + ch(e, f, g) + k + w)
    d_out <= c_in;
    c_out <= b_in;
    b_out <= a_in;
    -- a_out: (SIG_0(a) + maj(a, b, c) + (h + SIG_1(e) + ch(e, f, g) + k + w)
end Behavioral;
