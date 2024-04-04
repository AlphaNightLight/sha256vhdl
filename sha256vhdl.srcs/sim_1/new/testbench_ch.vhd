----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 04.04.2024 16:35:18
-- Design Name: testbench_ch
-- Module Name: testbench_ch - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: testbench for CH function
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD, work.ch
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

entity testbench_ch is
--  Port ( );
end testbench_ch;

architecture Behavioral of testbench_ch is
    signal x, y, z, ch_out : unsigned (31 downto 0);
begin
    ch : entity work.ch generic map (dim => 32) port map( x=>x, y=>y, z=>z, ch_out=>ch_out );
    test : process is begin
        x <= x"0e002020";
        y <= x"ff006100";
        z <= x"003a0001";
        wait for 20 ns;
        z <= x"103a0001";
        wait;
    end process;
end Behavioral;
