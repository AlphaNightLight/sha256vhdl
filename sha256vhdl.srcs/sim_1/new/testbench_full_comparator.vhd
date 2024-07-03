----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 27.06.2024 17:24:23
-- Design Name: testbench_full_comparator
-- Module Name: testbench_full_comparator - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description:testbench for the full comparator
-- 
-- Dependencies: STD_LOGIC_1164, work.full_comparator
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity testbench_full_comparator is
--  Port ( );
end testbench_full_comparator;

architecture Behavioral of testbench_full_comparator is
    signal a, b, dec_in, agtb_in : std_logic;
    signal dec_out, agtb_out : std_logic;
begin
    full_comparator : entity work.full_comparator port map( a=>a, b=>b, dec_in=>dec_in, agtb_in=>agtb_in, dec_out=>dec_out, agtb_out=>agtb_out );
    
    test : process is begin
        a <= '0';
        b <= '0';
        dec_in <= '0';
        agtb_in <= '0';
        wait for 20 ns;
        a <= '1';
        b <= '1';
        dec_in <= '0';
        agtb_in <= '0';
        wait for 20 ns;
        a <= '1';
        b <= '0';
        dec_in <= '0';
        agtb_in <= '0';
        wait for 20 ns;
        a <= '0';
        b <= '1';
        dec_in <= '0';
        agtb_in <= '0';
        
        wait for 20 ns;
        a <= '0';
        b <= '0';
        dec_in <= '1';
        agtb_in <= '0';
        wait for 20 ns;
        a <= '1';
        b <= '1';
        dec_in <= '1';
        agtb_in <= '0';
        wait for 20 ns;
        a <= '1';
        b <= '0';
        dec_in <= '1';
        agtb_in <= '0';
        wait for 20 ns;
        a <= '0';
        b <= '1';
        dec_in <= '1';
        agtb_in <= '0';
        
        wait for 20 ns;
        a <= '0';
        b <= '0';
        dec_in <= '1';
        agtb_in <= '1';
        wait for 20 ns;
        a <= '1';
        b <= '1';
        dec_in <= '1';
        agtb_in <= '1';
        wait for 20 ns;
        a <= '1';
        b <= '0';
        dec_in <= '1';
        agtb_in <= '1';
        wait for 20 ns;
        a <= '0';
        b <= '1';
        dec_in <= '1';
        agtb_in <= '1';
        
        wait;
    end process;
    
end Behavioral;
