----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 04.04.2024 17:33:12
-- Design Name: maj
-- Module Name: maj - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: MAJ function for SHA256 hash algorithm
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD
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

entity maj is
    generic ( dim : natural := 32);
    Port (
        x, y, z : in unsigned (dim-1 downto 0);
        maj_out : out unsigned (dim-1 downto 0)
    );
end maj;

architecture Behavioral of maj is
begin
    maj_out <= (x AND y) XOR (x AND z) XOR (y AND z);
end Behavioral;
