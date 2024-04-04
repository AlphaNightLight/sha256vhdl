----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 04.04.2024 18:28:24
-- Design Name: testbench_sigmas
-- Module Name: testbench_sigmas - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: testbench for SIG_0, SIG_1, sig_0 and sig_1  functions
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD, work.cap_sigma_0, work.cap_sigma_1, work.low_sigma_0, work.low_sigma_1
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

entity testbench_sigmas is
--  Port ( );
end testbench_sigmas;

architecture Behavioral of testbench_sigmas is
    signal x_cap_sigma_0, x_cap_sigma_1, x_low_sigma_0, x_low_sigma_1 : unsigned (31 downto 0);
    signal out_cap_sigma_0, out_cap_sigma_1, out_low_sigma_0, out_low_sigma_1 : unsigned (31 downto 0);
begin
    cap_sigma_0 : entity work.cap_sigma_0 generic map (dim => 32) port map( x=>x_cap_sigma_0, sigma=>out_cap_sigma_0 );
    cap_sigma_1 : entity work.cap_sigma_1 generic map (dim => 32) port map( x=>x_cap_sigma_1, sigma=>out_cap_sigma_1 );
    low_sigma_0 : entity work.low_sigma_0 generic map (dim => 32) port map( x=>x_low_sigma_0, sigma=>out_low_sigma_0 );
    low_sigma_1 : entity work.low_sigma_1 generic map (dim => 32) port map( x=>x_low_sigma_1, sigma=>out_low_sigma_1 );
    test : process is begin
        x_cap_sigma_0 <= x"00000000";
        x_cap_sigma_1 <= x"00000000";
        x_low_sigma_0 <= x"00000000";
        x_low_sigma_1 <= x"00000000";
        wait for 20 ns;
        x_cap_sigma_0 <= x"0e002020";
        x_cap_sigma_1 <= x"ff006100";
        x_low_sigma_0 <= x"003a0001";
        x_low_sigma_1 <= x"30050017";
        wait;
    end process;
end Behavioral;
