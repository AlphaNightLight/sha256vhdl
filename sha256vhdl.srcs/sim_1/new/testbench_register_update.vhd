----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 18.04.2024 15:08:12
-- Design Name: testbench_register_update
-- Module Name: testbench_register_update - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: testbench for the register_update function
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD, work.register_update
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

entity testbench_register_update is
--  Port ( );
end testbench_register_update;

architecture Behavioral of testbench_register_update is
    signal a_in, b_in, c_in, d_in, e_in, f_in, g_in, h_in : unsigned (31 downto 0);
    signal w, k : unsigned (31 downto 0);
    signal a_out, b_out, c_out, d_out, e_out, f_out, g_out, h_out : unsigned (31 downto 0);
begin
    next_block : entity work.register_update generic map (word_size=>32) port map (
        a_in=>a_in, b_in=>b_in, c_in=>c_in, d_in=>d_in, e_in=>e_in, f_in=>f_in, g_in=>g_in, h_in=>h_in,
        w=>w, k=>k,
        a_out=>a_out, b_out=>b_out, c_out=>c_out, d_out=>d_out, e_out=>e_out, f_out=>f_out, g_out=>g_out, h_out=>h_out
    );
    test : process is begin
        a_in <= x"0e002020";
        b_in <= x"ff006100";
        c_in <= x"30050017";
        d_in <= x"17a9f87c";
        e_in <= x"00002f20";
        f_in <= x"34678000";
        g_in <= x"efa8a9c3";
        h_in <= x"00210342";
        w <= x"10001000";
        k <= x"7583914d";
        wait for 20 ns;
        a_in <= x"09472aca";
        b_in <= x"1a3d8c3e";
        c_in <= x"8e23a673";
        d_in <= x"38029883";
        wait;
    end process;
end Behavioral;
