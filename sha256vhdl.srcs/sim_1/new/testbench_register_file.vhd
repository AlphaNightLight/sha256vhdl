----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 18.04.2024 18:59:50
-- Design Name: testbench_register_file
-- Module Name: testbench_register_file - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: testbench for the register file
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD.ALL, work.register_file
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

entity testbench_register_file is
--  Port ( );
end testbench_register_file;

architecture Behavioral of testbench_register_file is
    signal clk, res, load_en: std_logic;
    signal H_in : unsigned ( (32 * 8)-1 downto 0);
    signal H_out : unsigned ( (32 * 8)-1 downto 0);
begin
    register_file : entity work.register_file generic map (word_size=>32, word_number=>8) port map (
        clk=>clk, res=>res, load_en=>load_en, H_in=>H_in, H_out=>H_out
    );
    clk_process : process is begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;
    test : process is begin
        res <= '0';
        load_en <= '0';
        H_in <= x"0e002020_ff006100_30050017_17a9f87c_00002f20_34678000_efa8a9c3_00210342";
        wait for 20 ns;
        res <= '1';
        wait for 5 ns;
        load_en <= '1';
        wait for 50 ns;
        load_en <= '0';
        wait for 30 ns;
        H_in <= x"30050017_17a9f87c_00210342_ff006100_efa8a9c3_0e002020_00002f20_34678000";
        wait for 100 ns;
        load_en <= '1';
        wait;
    end process;
end Behavioral;
