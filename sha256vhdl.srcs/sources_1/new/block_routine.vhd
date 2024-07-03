----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 24.06.2024 16:43:12
-- Design Name: block_routine
-- Module Name: block_routine - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: the 64-cycles routine each block will encounter, composed by a datapath and a finite state machine.
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD.ALL, work.block_routine_dp, work.block_routine_fsm
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

entity block_routine is
    generic (
        word_size : natural := 32;
        clock_dim : natural := 6
    );
    Port (
        clk : in std_logic;
        res : in std_logic; -- active low
        
        -- Data
        m_block : in unsigned ( (word_size * 16)-1 downto 0); -- (word_size * w_number)-1 downto 0
        H_input : in unsigned ( (word_size * 8)-1 downto 0); -- (word_size * H_number)-1 downto 0
        H_output : out unsigned ( (word_size * 8)-1 downto 0); -- (word_size * H_number)-1 downto 0
        
        -- Status Signals
        start : in std_logic; -- when it goes to 1 the machine exits the wait state
        cancel : in std_logic; -- synchronous reset, active high
        busy : out std_logic; -- 1 when machine is computing
        valid : out std_logic -- 1 when the output hash is valid
    );
end block_routine;

architecture Behavioral of block_routine is
    -- Control Signals
    signal load_external_H : std_logic;
    signal load_external_abcdefgh : std_logic;
    signal update_abcdefgh : std_logic;
    
    signal reset_k : std_logic;
    signal shift_k : std_logic;
    
    signal load_external_m_block : std_logic;
    signal shift_w : std_logic;
begin
    datapath : entity work.block_routine_dp generic map (word_size=>word_size) port map(
        clk=>clk, res=>res,
        load_external_H=>load_external_H, load_external_abcdefgh=>load_external_abcdefgh, update_abcdefgh=>update_abcdefgh,
        reset_k=>reset_k, shift_k=>shift_k, load_external_m_block=>load_external_m_block, shift_w=>shift_w,
        H_input=>H_input, m_block=>m_block, H_output=>H_output
    );
    
    finite_state_machine : entity work.block_routine_fsm generic map (clock_dim=>clock_dim) port map(
        clk=>clk, res=>res,
        load_external_H=>load_external_H, load_external_abcdefgh=>load_external_abcdefgh, update_abcdefgh=>update_abcdefgh,
        reset_k=>reset_k, shift_k=>shift_k, load_external_m_block=>load_external_m_block, shift_w=>shift_w,
        start=>start, cancel=>cancel, busy=>busy, valid=>valid
    );
    
end Behavioral;
