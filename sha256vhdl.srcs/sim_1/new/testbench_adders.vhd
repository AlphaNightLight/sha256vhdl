----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 16.04.2024 21:43:16
-- Design Name: testbench_adders
-- Module Name: testbench_adders - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: testbench for full adder, ripple carry adder and 3 to 2 compressor
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD, work.full_adder, work.ripple_carry_adder, work.compressor_3_2
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

entity testbench_adders is
--  Port ( );
end testbench_adders;

architecture Behavioral of testbench_adders is
    signal a_full_adder, b_full_adder, cin_full_adder, s_full_adder, cout_full_adder: std_logic;
    signal a, b, c, s, partial_sums, unshifted_carries, triple_sum : unsigned (31 downto 0);
    signal cin, cout : std_logic;
begin
    full_adder : entity work.full_adder port map( a=>a_full_adder, b=>b_full_adder, cin=>cin_full_adder, s=>s_full_adder, cout=>cout_full_adder );
    ripple_carry_adder : entity work.ripple_carry_adder generic map (dim => 32) port map( a=>a, b=>b, cin=>cin, s=>s, cout=>cout );
    compressor_3_2 : entity work.compressor_3_2 generic map (dim => 32) port map( a=>a, b=>b, c=>c, partial_sums=>partial_sums, unshifted_carries=>unshifted_carries );
    triple_sum <= partial_sums + (unshifted_carries sll 1); -- to have a fast check of the compressor
    test : process is begin
        a_full_adder <= '0';
        b_full_adder <= '0';
        cin_full_adder <= '0';
        a <= x"0e002020";
        b <= x"ff006100";
        c <= x"30050017";
        cin <= '0';
        wait for 20 ns;
        a_full_adder <= '1';
        b_full_adder <= '0';
        cin_full_adder <= '0';
        wait for 20 ns;
        a_full_adder <= '1';
        b_full_adder <= '1';
        cin_full_adder <= '0';
        wait for 20 ns;
        a_full_adder <= '1';
        b_full_adder <= '1';
        cin_full_adder <= '1';
        wait for 20 ns;
        a_full_adder <= '1';
        b_full_adder <= '0';
        cin_full_adder <= '1';
        a <= x"8e00ac02";
        b <= x"f46d108e";
        c <= x"6ab50907";
        wait;
    end process;
end Behavioral;
