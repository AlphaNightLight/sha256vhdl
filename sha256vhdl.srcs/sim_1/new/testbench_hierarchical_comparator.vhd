----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 27.06.2024 18:13:34
-- Design Name: testbench_hierarchical_comparator
-- Module Name: testbench_hierarchical_comparator - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: testbench for hierarchical comparator
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD, work.hierarchical_comparator
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

entity testbench_hierarchical_comparator is
--  Port ( );
end testbench_hierarchical_comparator;

architecture Behavioral of testbench_hierarchical_comparator is
    signal a, b : unsigned (31 downto 0);
    signal agtb, altb, ageb, aleb, aeqb, aneb : std_logic;
begin
    hierarchical_comparator : entity work.hierarchical_comparator generic map (dim => 32) port map( a=>a, b=>b, agtb=>agtb, altb=>altb, ageb=>ageb, aleb=>aleb, aeqb=>aeqb, aneb=>aneb );
    
    test : process is begin
        a <= x"00000000";
        b <= x"00000000";
        wait for 20 ns;
        a <= x"ffffffff";
        b <= x"ffffffff";
        wait for 20 ns;
        a <= x"0e002020";
        b <= x"0e002020";
        
        wait for 20 ns;
        a <= x"8e002020";
        b <= x"0e002020";
        wait for 20 ns;
        a <= x"0e002021";
        b <= x"0e002020";
        wait for 20 ns;
        a <= x"0e012020";
        b <= x"0e002020";
        wait for 20 ns;
        a <= x"0eff0c61";
        b <= x"0e002020";
        
        wait for 20 ns;
        a <= x"0e002020";
        b <= x"8e002020";
        wait for 20 ns;
        a <= x"0e002020";
        b <= x"0e002021";
        wait for 20 ns;
        a <= x"0e002020";
        b <= x"0e012020";
        wait for 20 ns;
        a <= x"0e002020";
        b <= x"0eff0c61";
        
        wait;
    end process;
    
end Behavioral;
