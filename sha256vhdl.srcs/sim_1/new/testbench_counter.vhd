----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 18.04.2024 20:14:33
-- Design Name: testbench_counter
-- Module Name: testbench_counter - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: testbench for the free counter
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD.ALL, work.counter
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

entity testbench_counter is
--  Port ( );
end testbench_counter;

architecture Behavioral of testbench_counter is
    signal clk, res, count_en, goto_zero: std_logic;
    signal count : unsigned ( 6-1 downto 0);
    signal tc : std_logic;
begin
    register_file : entity work.counter generic map (dim=>6) port map ( clk=>clk, res=>res, count_en=>count_en, goto_zero=>goto_zero, count=>count, tc=>tc );
    
    clk_process : process is begin
        clk <= '0';
        wait for 10 ps;
        clk <= '1';
        wait for 10 ps;
    end process;
    test : process is begin
        res <= '0';
        count_en <= '0';
        goto_zero <='0';
        wait for 20 ps;
        res <= '1';
        wait for 300 ps;
        
        count_en <= '1';
        wait for 2000 ps;
        goto_zero <= '1';
        wait for 300 ps;
        goto_zero <= '0';
        wait for 2000 ps;
        count_en <= '0';
        wait for 300 ps;
        goto_zero <= '1';
        wait for 300 ps;
        goto_zero <= '0';
        wait;
    end process;
end Behavioral;
