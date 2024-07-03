----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 03.07.2024 12:42:48
-- Design Name: testbench_debouncer
-- Module Name: testbench_debouncer - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: testbench for the debouncer
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD.ALL, work.debouncer
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

entity testbench_debouncer is
--  Port ( );
end testbench_debouncer;

architecture Behavioral of testbench_debouncer is
    signal clk : std_logic;
    signal res : std_logic;
    signal bouncy  : std_logic;
    signal pulse : std_logic;
begin
    debouncer : entity work.debouncer generic map ( counter_size=>12 ) port map(
        clk=>clk, res=>res, bouncy=>bouncy, pulse=>pulse
    );
    
    clk_process : process is begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process; -- 100 MHz
    
    test : process is begin
        res <= '0';
        bouncy <= '0';
        wait for 10 ns;
        res <= '1';
        
        wait for 2 ns;
        bouncy <= '0';
        wait for 10 ns;
        bouncy <= '1';
        wait for 10 ns;
        bouncy <= '0';
        wait for 10 ns;
        bouncy <= '1';
        wait for 15 us;
        bouncy <= '0';
        wait for 10 ns;
        bouncy <= '1'; 
        wait for 45 us;
        bouncy <= '0';
        wait for 100 ns;
        bouncy <= '1';
        wait for 400 ns;
        bouncy <= '0';
        
        wait;
    end process;
    
end Behavioral;
