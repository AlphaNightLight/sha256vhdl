----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 16.04.2024 16:46:26
-- Design Name: compressor_3_2
-- Module Name: compressor_3_2 - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: a simple 3 to 2 compressor
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD.ALL, work.full_adder
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

entity compressor_3_2 is
    generic ( dim : natural := 32);
    Port (
        a, b, c : in unsigned (dim-1 downto 0);
        partial_sums, unshifted_carries : out unsigned (dim-1 downto 0)
    );
end compressor_3_2;

architecture Behavioral of compressor_3_2 is
begin
    adders : for i in 0 to dim-1 generate
        full_adder : entity work.full_adder port map( a=>a(i), b=>b(i), cin=>c(i), s=>partial_sums(i), cout=>unshifted_carries(i) );
    end generate adders;
end Behavioral;
