----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 18.04.2024 19:33:08
-- Design Name: counter
-- Module Name: counter - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: a generic free counter
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD.ALL, work.ripple_carry_adder
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

entity counter is
    generic (
        dim : natural := 32
    );
    Port (
        clk : in std_logic;
        res : in std_logic; -- active low
        count_en : in std_logic; -- active high
        goto_zero : in std_logic; -- active high
        
        count : out unsigned ( dim-1 downto 0);
        tc : out std_logic
    );
end counter;

architecture Behavioral of counter is
    signal internal_count : unsigned ( dim-1 downto 0);
    signal next_count : unsigned ( dim-1 downto 0);
    signal cout : std_logic;
begin
    adder : entity work.ripple_carry_adder generic map (dim => dim) port map( a=>internal_count, b=>(others => '0'), cin=>count_en, s=>next_count, cout=>cout );
    
    process (clk, res) is begin
        if res = '0' then
            internal_count <= (others => '0');
            --tc <= '0'; -- to show tc when count rolls back to zero
        elsif rising_edge(clk) then
            if goto_zero = '1' then
                internal_count <= (others => '0');
                --tc <= '0'; -- to show tc when count rolls back to zero
            else
                internal_count <= next_count;
                --tc <= cout; -- to show tc when count rolls back to zero
            end if;
        end if;
    end process;
    
    tc <= cout AND count_en; -- to show tc when count is on last digit
    count <= internal_count;
end Behavioral;
