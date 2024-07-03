----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 27.06.2024 16:21:50
-- Design Name: testbench_difficulty_decoder
-- Module Name: testbench_difficulty_decoder - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: testbench for the difficulty decoder
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD.ALL, work.difficulty_decoder
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

entity testbench_difficulty_decoder is
--  Port ( );
end testbench_difficulty_decoder;

architecture Behavioral of testbench_difficulty_decoder is
    signal bits : unsigned (32-1 downto 0);
    signal difficulty : unsigned (256-1 downto 0);
begin
    difficulty_decoder : entity work.difficulty_decoder port map( bits=>bits, difficulty=>difficulty );
    
    test : process is begin
        bits <= x"1b0404cb";
        wait for 20 ns;
        bits <= x"ffffffff";
        wait for 20 ns;
        bits <= x"1effffff";
        wait for 20 ns;
        bits <= x"1fffffff";
        wait for 20 ns;
        bits <= x"1d00ffff";
        wait for 20 ns;
        bits <= x"535f0119";
        wait for 20 ns;
        bits <= x"19015f53";
        wait;
    end process;
    
end Behavioral;
