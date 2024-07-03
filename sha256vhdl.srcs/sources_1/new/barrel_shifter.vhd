----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 27.06.2024 14:11:50
-- Design Name: barrel_shifter
-- Module Name: barrel_shifter - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: a simple barrel shifter
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

entity barrel_shifter is
    generic (
        input_dim : natural := 256;
        shift_dim : natural := 8
    );
    Port (
        data_in : in unsigned (input_dim-1 downto 0);
        shift_amount : in unsigned (shift_dim-1 downto 0);
        
        data_out : out unsigned (input_dim-1 downto 0)
    );
end barrel_shifter;

architecture Behavioral of barrel_shifter is
    type connections_t is array (0 to shift_dim) of unsigned(input_dim-1 downto 0);
    signal connections : connections_t;
begin
    shifters : for i in 0 to shift_dim-1 generate
    
        case_0 : if i=0 generate
            connections(i) <= (data_in sll 1) when shift_amount(i) = '1' else data_in;
        end generate case_0;
        
        case_x : if i>0 generate
            connections(i) <= (connections(i-1) sll 2**i) when shift_amount(i) = '1' else connections(i-1);
        end generate case_x;
        
    end generate shifters;
    
    data_out <= connections(shift_dim-1);
end Behavioral;
