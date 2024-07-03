----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 24.05.2024 16:06:27
-- Design Name: testbench_word_shift_register
-- Module Name: testbench_word_shift_register - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: testbench for the word shift level register
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD.ALL, work.word_shift_register
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

entity testbench_word_shift_register is
--  Port ( );
end testbench_word_shift_register;

architecture Behavioral of testbench_word_shift_register is
    signal clk, res, parallel_en, shift_en : std_logic;
    signal parallel_in : unsigned ( (32 * 8)-1 downto 0);
    signal parallel_out : unsigned ( (32 * 8)-1 downto 0);
    signal serial_in : unsigned ( 32-1 downto 0);
    signal serial_out : unsigned ( 32-1 downto 0);
begin
    word_shift_register : entity work.word_shift_register generic map (word_size=>32, word_number=>8) port map (
        clk=>clk, res=>res, parallel_en=>parallel_en, shift_en=>shift_en,
        parallel_in=>parallel_in, parallel_out=>parallel_out, serial_in=>serial_in, serial_out=>serial_out
    );
    
    clk_process : process is begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;
    
    test : process is begin
        res <= '0';
        parallel_en <= '0';
        shift_en <= '0';
        parallel_in <= x"0e002020_ff006100_30050017_17a9f87c_00002f20_34678000_efa8a9c3_00210342";
        serial_in <= x"eeeeeeee";
        wait for 20 ns;
        res <= '1';
        wait for 5 ns;
        parallel_en <= '1';
        wait for 30 ns;
        shift_en <= '1';
        wait for 50 ns;
        parallel_en <= '0';
        wait for 30 ns;
        serial_in <= x"ffffffff";
        wait for 30 ns;
        serial_in <= x"00000000";
        parallel_in <= x"30050017_17a9f87c_00210342_ff006100_efa8a9c3_0e002020_00002f20_34678000";
        wait for 30 ns;
        parallel_en <= '1';
        shift_en <= '0';
        wait for 100 ns;
        parallel_en <= '0';
        wait;
    end process;
end Behavioral;
