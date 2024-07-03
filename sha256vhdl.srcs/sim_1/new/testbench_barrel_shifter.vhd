----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 27.06.2024 14:49:25
-- Design Name: testbench_barrel_shifter
-- Module Name: testbench_barrel_shifter - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: testbench for the barrel shifter
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD.ALL, work.barrel_shifter
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

entity testbench_barrel_shifter is
--  Port ( );
end testbench_barrel_shifter;

architecture Behavioral of testbench_barrel_shifter is
    signal data_in : unsigned (256-1 downto 0);
    signal shift_amount : unsigned (8-1 downto 0);
    
    signal data_out : unsigned (256-1 downto 0);
begin
    shifter : entity work.barrel_shifter generic map (input_dim=>256, shift_dim=>8) port map(
        data_in=>data_in, shift_amount=>shift_amount, data_out=>data_out
    );
    
    test : process is begin
        data_in <= x"0e002020_ff006100_30050017_17a9f87c_00002f20_34678000_efa8a9c3_00210342";
        shift_amount <= x"01";
        wait for 20 ns;
        data_in <= x"30050017_17a9f87c_00210342_ff006100_efa8a9c3_0e002020_00002f20_34678000";
        shift_amount <= x"03";
        wait for 20 ns;
        shift_amount <= x"08";
        wait for 20 ns;
        data_in <= x"00000000_00000000_00000000_00000000_00000000_00000000_00000000_000404cb";
        shift_amount <= ((x"1b" - 3) sll 3);
        wait for 20 ns;
        data_in <= x"00000000_00000000_00000000_00000000_00000000_00000000_00000000_00ffffff";
        shift_amount <= ((x"ff" - 3) sll 3);
        wait for 20 ns;
        shift_amount <= ((x"1e" - 3) sll 3);
        wait for 20 ns;
        shift_amount <= ((x"1f" - 3) sll 3);
        wait for 20 ns;
        data_in <= x"00000000_00000000_00000000_00000000_00000000_00000000_00000000_0000ffff";
        shift_amount <= ((x"1d" - 3) sll 3);
        wait;
    end process;
    
end Behavioral;
