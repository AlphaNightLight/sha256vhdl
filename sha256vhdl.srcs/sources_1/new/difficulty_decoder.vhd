----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 27.06.2024 15:47:02
-- Design Name: difficulty_decoder
-- Module Name: difficulty_decoder - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: the decoder to convert "bitcoin bits" int "bitcoin difficulty"
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD.ALL, work.barrel_shifter
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

entity difficulty_decoder is
    Port (
        bits : in unsigned (32-1 downto 0);
        difficulty : out unsigned (256-1 downto 0)
    );
end difficulty_decoder;

architecture Behavioral of difficulty_decoder is
    signal mantissa : unsigned (256-1 downto 0);
    
    signal compressed_exponent : unsigned (8-1 downto 0);
    signal compressed_exponent_decreased : unsigned (8-1 downto 0);
    signal full_exponent : unsigned (8-1 downto 0);
    
    constant const_decrease : unsigned (8-1 downto 0) := "11111100"; -- NOT(3)
begin
    mantissa(24-1 downto 0) <= bits(24-1 downto 0);
    mantissa(256-1 downto 24) <= (others => '0');
    
    compressed_exponent <= bits(32-1 downto 24);
    
    adder: entity work.ripple_carry_adder generic map (dim=>8) port map(
        a=>compressed_exponent, b=>const_decrease, cin=>'1', s =>compressed_exponent_decreased -- no need for cout
    ); -- compressed_exponent_decreased <= compressed_exponent - 3;
    
    full_exponent <= compressed_exponent_decreased sll 3;
    
    shifter: entity work.barrel_shifter generic map (input_dim=>256, shift_dim=>8) port map(
        data_in=>mantissa, shift_amount=>full_exponent, data_out=>difficulty
    );
    -- difficulty = mantissa << ( (compressed_exponent-3) << 3 );
end Behavioral;
