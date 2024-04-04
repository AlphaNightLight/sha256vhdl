----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 04.04.2024 18:04:28
-- Design Name: low_sigma_0
-- Module Name: low_sigma_0 - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: lowcase sig_0 function for SHA256 hash algorithm
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

entity low_sigma_0 is
    generic ( dim : natural := 32);
    Port (
        x : in unsigned (dim-1 downto 0);
        sigma : out unsigned (dim-1 downto 0)
    );
end low_sigma_0;

architecture Behavioral of low_sigma_0 is
begin
    sigma <= (x ror 7) XOR (x ror 18) XOR (x srl 3);
end Behavioral;
