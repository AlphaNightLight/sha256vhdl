----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 16.04.2024 16:14:20
-- Design Name: ripple_carry_adder
-- Module Name: ripple_carry_adder - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: a simple ripple carry adder
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD.ALL, work.full_adder
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

entity ripple_carry_adder is
    generic ( dim : natural := 32);
    Port (
        a, b : in unsigned (dim-1 downto 0);
        cin : in std_logic;
        s : out unsigned (dim-1 downto 0);
        cout : out std_logic
    );
end ripple_carry_adder;

architecture Behavioral of ripple_carry_adder is
    signal carry_propagator : std_logic_vector (dim-1 downto 0);
begin
    adders : for i in 0 to dim-1 generate
    
        case_0 : if i=0 generate
            first_full_adder : entity work.full_adder port map( a=>a(i), b=>b(i), cin=>cin, s=>s(i), cout=>carry_propagator(i) );
        end generate case_0;
        
        case_x : if i>0 generate
            x_full_adder : entity work.full_adder port map( a=>a(i), b=>b(i), cin=>carry_propagator(i-1), s=>s(i), cout=>carry_propagator(i) );
        end generate case_x;
        
    end generate adders;
    
    cout <= carry_propagator(dim-1);
    
end Behavioral;
