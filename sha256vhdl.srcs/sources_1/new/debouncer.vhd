----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 03.07.2024 12:16:41
-- Design Name: debouncer
-- Module Name: debouncer - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: a debouncer, used to convert bouncy signals into pulses
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

entity debouncer is
    generic (
        counter_size : natural := 12
        -- with 100 MHz clk, counter=12 means the signal must be stable 40 us to be detected
    );
    port (
        clk : in std_logic;
        res : in std_logic;
        
        bouncy  : in std_logic;
        pulse : out std_logic
    );
end debouncer;

architecture Behavioral of debouncer is
    signal counter : unsigned( counter_size-1 downto 0 );
    
    signal stable_value : std_logic; -- what is considered the level of the signal
    signal candidate_value : std_logic; -- what level of the signal we're measurung lengh
    -- If the counter reaches zero, candidate_value becomes the new stable_value
    signal delayed_stable_value : std_logic; -- the stable_value of the previous cycle
begin
    -- Measure the lenghr of bouncy's levels, to find and update stable_value
    seq : process ( clk, res ) is begin
        if res = '0' then
            counter <= ( others => '1' );
            stable_value <= '0';
            candidate_value <= '0';
        elsif rising_edge(clk) then
            if bouncy = candidate_value then
                if counter = 0 then stable_value <= candidate_value;
                else counter <= counter-1;
                end if;
            else
                candidate_value <= bouncy;
                counter <= (others=>'1'); 
            end if;
        end if;
    end process;
    
    -- Remember past stable value
    delay_stable : process ( clk, res ) is begin
        if res = '0' then
            delayed_stable_value <= '0';
        elsif rising_edge(clk) then
            delayed_stable_value <= stable_value;
        end if;
    end process;
    
    -- Create the pulse
    pulse <= '1' when (stable_value = '1' AND delayed_stable_value = '0') else '0';
    
end Behavioral;
