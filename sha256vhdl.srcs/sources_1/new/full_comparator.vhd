----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 27.06.2024 16:50:53
-- Design Name: full_comparator
-- Module Name: full_comparator - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: a simple full comparator
-- 
-- Dependencies: IEEE.STD_LOGIC_1164
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity full_comparator is
    Port (
        a, b, dec_in, agtb_in : in std_logic;
        dec_out, agtb_out : out std_logic
    );
end full_comparator;

architecture Behavioral of full_comparator is
begin
    dec_out <= dec_in OR ( a and NOT(b) ) OR ( NOT(a) AND b); -- 1 if we have decided
    agtb_out <= agtb_in OR ( NOT(dec_in) AND a AND NOT(B) ); -- 1 if a is greater than b
    -- [dec_out, agtb_out] = 
    -- 00 : not decided yet
    -- 10 : a < b
    -- 11 : a > b
    -- 01 : invalid case, don't care
end Behavioral;
