----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 24.06.2024 16:55:56
-- Design Name: block_routine_fsm
-- Module Name: block_routine_fsm - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: the finite state machine part of the 64-cycles routine each block will encounter.
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD.ALL, work.counter
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

entity block_routine_fsm is
    generic ( clock_dim : natural := 6 );
    Port (
        clk : in std_logic;
        res : in std_logic; -- active low
        
        -- Datapath Control Signals
        load_external_H : out std_logic;
        load_external_abcdefgh : out std_logic;
        update_abcdefgh : out std_logic;
        
        reset_k : out std_logic;
        shift_k : out std_logic;
        
        load_external_m_block : out std_logic;
        shift_w : out std_logic;
        
        -- Status Signals
        start : in std_logic; -- when it goes to 1 the machine exits the wait state
        cancel : in std_logic; -- synchronous reset, active high
        busy : out std_logic; -- 1 when machine is computing
        valid : out std_logic -- 1 when the output hash is valid
    );
end block_routine_fsm;

architecture Behavioral of block_routine_fsm is
    -- States Definition
    type state is (wait_s, start_s, run_s, final_s);
    signal present_state : state;
    signal next_state : state;
    
    -- Counter Control Signals
    signal count_en : std_logic;
    signal reser_counter : std_logic;
    signal countetr_tc : std_logic;
begin
    counter : entity work.counter generic map (dim=>clock_dim) port map( clk=>clk, res=>res, count_en=>count_en, goto_zero=>reser_counter, tc=>countetr_tc ); -- no need for count
    
    seq : process (clk, res) is begin
        if res = '0' then
            present_state <= wait_s;
        elsif rising_edge(clk) then
            if cancel = '1' then
                present_state <= wait_s;
            else
                present_state <= next_state;
            end if;
        end if;
    end process;
    
    future : process (present_state, start, countetr_tc) is begin
        case present_state is
        when wait_s =>
            if start = '1' then next_state <= start_s;
            else next_state <= wait_s;
            end if;
        when start_s =>
            next_state <= run_s;
        when run_s =>
            if countetr_tc = '1' then next_state <= final_s;
            else next_state <= run_s;
            end if;
        when final_s =>
            if start = '1' then next_state <= start_s;
            else next_state <= final_s;
            end if;
        when others => -- There should be no other state,
        -- but in case of errors we simply return in wait_s
            next_state <= wait_s;
        end case;
    end process;
    
    outputs : process (present_state) is begin -- It's a Moore machine
        case present_state is
        when wait_s =>
            load_external_H <= '0';
            load_external_abcdefgh <= '0';
            update_abcdefgh <= '0';
            
            reset_k <= '0';
            shift_k <= '0';
            load_external_m_block <= '0';
            shift_w <= '0';
            
            count_en <= '0';
            reser_counter <= '0';
            
            busy <= '0';
            valid <= '0';
        
        when start_s =>
            load_external_H <= '1';
            load_external_abcdefgh <= '1';
            update_abcdefgh <= '1';
            
            reset_k <= '1';
            shift_k <= '0';
            load_external_m_block <= '1';
            shift_w <= '0';
            
            count_en <= '0';
            reser_counter <= '1';
            
            busy <= '1';
            valid <= '0';
        
        when run_s =>
            load_external_H <= '0';
            load_external_abcdefgh <= '0';
            update_abcdefgh <= '1';
            
            reset_k <= '0';
            shift_k <= '1';
            load_external_m_block <= '0';
            shift_w <= '1';
            
            count_en <= '1';
            reser_counter <= '0';
            
            busy <= '1';
            valid <= '0';
        
        when final_s =>
            load_external_H <= '0';
            load_external_abcdefgh <= '0';
            update_abcdefgh <= '0';
            
            reset_k <= '0';
            shift_k <= '0';
            load_external_m_block <= '0';
            shift_w <= '0';
            
            count_en <= '0';
            reser_counter <= '0';
            
            busy <= '0';
            valid <= '1';
        
        when others => -- There should be no other state,
        -- but in case of errors we simply freeze evertything like in wait_s
            load_external_H <= '0';
            load_external_abcdefgh <= '0';
            update_abcdefgh <= '0';
            
            reset_k <= '0';
            shift_k <= '0';
            load_external_m_block <= '0';
            shift_w <= '0';
            
            count_en <= '0';
            reser_counter <= '0';
            
            busy <= '0';
            valid <= '0';
        
        end case;
    end process;
    
end Behavioral;
