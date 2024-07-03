----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 24.05.2024 16:06:10
-- Design Name: word_shift_register
-- Module Name: word_shift_register - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: a register file that can perform word-wise shift
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

entity word_shift_register is
    generic (
        word_size : natural := 32;
        word_number : natural := 8
    );
    Port (
        clk : in std_logic;
        res : in std_logic; -- active low
        parallel_en : in std_logic; -- active high
        shift_en : in std_logic; -- active high
        
        parallel_in : in unsigned ( (word_size * word_number)-1 downto 0);
        parallel_out : out unsigned ( (word_size * word_number)-1 downto 0);
        serial_in : in unsigned ( word_size-1 downto 0);
        serial_out : out unsigned ( word_size-1 downto 0)
    );
end word_shift_register;

architecture Behavioral of word_shift_register is
    signal data : unsigned ( (word_size * word_number)-1 downto 0);
begin
    process (clk, res) is begin
        if res = '0' then
            data <= (others => '0');
        elsif rising_edge(clk) then
            if parallel_en = '1' then -- parallel_en shadows shift_en
                data <= parallel_in;
            elsif shift_en = '1' then
--                for i in 0 to ( word_size*(word_number-1) )-1 loop -- Right Shift
--                    data(i) <= data(i+word_size); -- Right Shift
--                end loop; -- Right Shift
--                data( (word_size * word_number)-1 downto word_size * (word_number-1) ) <= serial_in; -- Right Shift
                for i in (word_size * word_number)-1 downto word_size loop -- Left Shift
                    data(i) <= data(i-word_size); -- Left Shift
                end loop; -- Left Shift
                data(word_size-1 downto 0) <= serial_in; -- Left Shift
            end if;
        end if;
    end process;
    
    parallel_out <= data;
    --serial_out <= data(word_size-1 downto 0); -- Right Shift
    serial_out <= data( (word_size * word_number)-1 downto word_size * (word_number-1) ); -- Left Shift
end Behavioral;
