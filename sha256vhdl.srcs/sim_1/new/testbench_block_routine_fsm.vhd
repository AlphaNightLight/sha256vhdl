----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 24.06.2024 16:55:18
-- Design Name: testbench_block_routine_fsm
-- Module Name: testbench_block_routine_fsm - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: testbench for the finite state machine part of the 64-cycles routine.
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD.ALL, work.block_routine_fsm
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

entity testbench_block_routine_fsm is
--  Port ( );
end testbench_block_routine_fsm;

architecture Behavioral of testbench_block_routine_fsm is
    -- Datapath Control Signals
    signal clk : std_logic;
    signal res : std_logic; -- active low
    
    signal load_external_H : std_logic;
    signal load_external_abcdefgh : std_logic;
    signal update_abcdefgh : std_logic;
    signal reset_k : std_logic;
    signal shift_k : std_logic;
    signal load_external_m_block : std_logic;
    signal shift_w : std_logic;
    
    -- Status Signals
    signal start : std_logic; -- when it goes to 1 the machine exits the wait state
    signal cancel : std_logic; -- synchronous reset, active high
    signal busy : std_logic; -- 1 when machine is computing
    signal valid : std_logic; -- 1 when the output hash is valid
begin
    block_routine_fsm: entity work.block_routine_fsm generic map (clock_dim=>6) port map(
        clk=>clk, res=>res,
        load_external_H=>load_external_H, load_external_abcdefgh=>load_external_abcdefgh, update_abcdefgh=>update_abcdefgh,
        reset_k=>reset_k, shift_k=>shift_k, load_external_m_block=>load_external_m_block, shift_w=>shift_w,
        start=>start, cancel=>cancel, busy=>busy, valid=>valid
    );
    
    clk_process : process is begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;
    
    test : process is begin
        res <= '0';
        start <= '1';
        cancel <= '1';
        
        wait for 20 ns;
        res <= '1';
        
        wait for 5 ns;
        start <= '0';
        cancel <= '0';
        
        wait for 100 ns;
        start <= '1';
        cancel <= '0';
        
        wait for 50 ns;
        start <= '1';
        cancel <= '1';
        
        wait for 20 ns;
        start <= '0';
        cancel <= '1';
        
        wait for 50 ns;
        start <= '0';
        cancel <= '0';
        
        wait for 200 ns;
        start <= '1';
        cancel <= '0';
        
        wait for 50 ns;
        start <= '0';
        cancel <= '0';
        
        wait for 200 ns;
        start <= '1';
        cancel <= '0';
        
        wait for 2000 ns;
        start <= '0';
        cancel <= '0';
        
        wait;
    end process;
    
end Behavioral;
