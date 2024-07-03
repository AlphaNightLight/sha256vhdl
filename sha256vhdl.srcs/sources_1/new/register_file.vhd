----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 18.04.2024 18:18:54
-- Design Name: register_file
-- Module Name: register_file - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: a generic register file
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD.ALL
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

entity register_file is
    generic (
        word_size : natural := 32;
        word_number : natural := 8
    );
    Port (
        clk : in std_logic;
        res : in std_logic; -- active low
        load_en : in std_logic; -- active high
        
        H_in : in unsigned ( (word_size * word_number)-1 downto 0);
        H_out : out unsigned ( (word_size * word_number)-1 downto 0)
    );
end register_file;

architecture Behavioral of register_file is
begin
    process (clk, res) is begin
        if res = '0' then
            H_out <= (others => '0');
        elsif rising_edge(clk) then
            if load_en = '1' then
                H_out <= H_in;
            end if;
        end if;
    end process;
end Behavioral;
