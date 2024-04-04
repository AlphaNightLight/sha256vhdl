----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 04.04.2024 18:00:13
-- Design Name: cap_sigma_1
-- Module Name: cap_sigma_1 - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: capital SIG_1 function for SHA256 hash algorithm
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

entity cap_sigma_1 is
    generic ( dim : natural := 32);
    Port (
        x : in unsigned (dim-1 downto 0);
        sigma : out unsigned (dim-1 downto 0)
    );
end cap_sigma_1;

architecture Behavioral of cap_sigma_1 is
begin
    sigma <= (x ror 6) XOR (x ror 11) XOR (x ror 25);
end Behavioral;
