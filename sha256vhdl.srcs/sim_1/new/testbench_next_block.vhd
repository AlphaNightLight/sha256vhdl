----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 18.04.2024 15:08:50
-- Design Name: testbench_next_block
-- Module Name: testbench_next_block - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: testbench for the newxt_block function
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD, work.next_block
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

entity testbench_next_block is
--  Port ( );
end testbench_next_block;

architecture Behavioral of testbench_next_block is
    signal w_previous_2, w_previous_7, w_previous_15, w_previous_16, w_actual : unsigned (31 downto 0);
begin
    next_block : entity work.next_block generic map (word_size=>32) port map( w_previous_2=>w_previous_2, w_previous_7=>w_previous_7, w_previous_15=>w_previous_15, w_previous_16=>w_previous_16, w_actual=>w_actual );
    test : process is begin
        w_previous_2 <= x"0e002020";
        w_previous_7 <= x"ff006100";
        w_previous_15 <= x"30050017";
        w_previous_16 <= x"17a9f87c";
        wait for 20 ns;
        w_previous_2 <= x"00002f20";
        w_previous_7 <= x"34678000";
        w_previous_15 <= x"efa8a9c3";
        w_previous_16 <= x"00210342";
        wait for 20 ns;
        w_previous_2 <= x"10001000";
        w_previous_7 <= x"7583914d";
        w_previous_15 <= x"09472aca";
        w_previous_16 <= x"1a3d8c3e";
        wait;
    end process;
end Behavioral;
