----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 27.06.2024 16:52:55
-- Design Name: hierarchical_comparator
-- Module Name: hierarchical_comparator - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: a simple hierarchical comparator
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD.ALL, work.full_comparator
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

entity hierarchical_comparator is
    generic ( dim : natural := 256);
    Port (
        a, b : in unsigned (dim-1 downto 0);
        
        agtb : out std_logic; -- 1 if a > b, greater than
        altb : out std_logic; -- 1 if a < b, less than
        ageb : out std_logic; -- 1 if a >= b, greater equal
        aleb : out std_logic; -- 1 if a <= b, less equal
        aeqb : out std_logic; -- 1 if a = b, equal
        aneb : out std_logic -- 1 if a != b, not equal
    );
end hierarchical_comparator;

architecture Behavioral of hierarchical_comparator is
    signal dec_propagator : std_logic_vector (dim-1 downto 0);
    signal agtb_propagator : std_logic_vector (dim-1 downto 0);
begin
    comparators : for i in dim-1 downto 0 generate
    
        first_case : if i=dim-1 generate
            first_full_comparator : entity work.full_comparator port map( a=>a(i), b=>b(i), dec_in=>'0', agtb_in=>'0', dec_out=>dec_propagator(i), agtb_out=>agtb_propagator(i) );
        end generate first_case;
        
        case_x : if i<dim-1 generate
            x_full_comparator : entity work.full_comparator port map( a=>a(i), b=>b(i), dec_in=>dec_propagator(i+1), agtb_in=>agtb_propagator(i+1), dec_out=>dec_propagator(i), agtb_out=>agtb_propagator(i) );
        end generate case_x;
        
    end generate comparators;
    
    agtb <= dec_propagator(0) AND agtb_propagator(0);
    altb <= dec_propagator(0) AND NOT( agtb_propagator(0) );
    
    ageb <= NOT( dec_propagator(0) AND NOT(agtb_propagator(0)) );
    aleb <= NOT( dec_propagator(0) AND agtb_propagator(0) );
    
    aeqb <= NOT dec_propagator(0);
    aneb <= dec_propagator(0);
    
end Behavioral;
