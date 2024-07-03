----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 02.07.2024 12:55:59
-- Design Name: bitcoin_miner_fsm
-- Module Name: bitcoin_miner_fsm - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: the finite state machine of the bitcoin miner
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

entity bitcoin_miner_fsm is
    Port (
        clk : in std_logic;
        res : in std_logic; -- active low
        
        -- Datapath Control Signals out
        load_first_block : out std_logic;
        load_second_block_stem : out std_logic;
        load_start_nonce : out std_logic;
        load_difficulty : out std_logic;
        
        nonce_count_en : out std_logic;
        reset_nonce : out std_logic;
        
        update_mid_H : out std_logic;
        update_inner_hash : out std_logic;
        use_mid_H : out std_logic;
        use_inner_block : out std_logic;
        use_second_block : out std_logic;
        
        start_block_routine : out std_logic; -- when it goes to 1 the machine exits the wait state
        
        -- Datapath Control Signals in
        busy_block_routine : in std_logic; -- 1 when machine is computing
        valid_block_routine : in std_logic; -- 1 when the output hash is valid
        
        nonce_tc : in std_logic;
        you_won : in std_logic;
        
        -- Status Signals
        start : in std_logic; -- when it goes to 1 the machine exits the wait-like states
        cancel : in std_logic; -- synchronous reset, active high
        
        busy : out std_logic; -- 1 when the machine is computing
        nonce_found : out std_logic; -- 1 when a valid nonce is found
        nonce_overflow : out std_logic; -- 1 when the counter reach terminal count, i.e. there's no valid nonce
        error : out std_logic -- 1 when some error happened
    );
end bitcoin_miner_fsm;

architecture Behavioral of bitcoin_miner_fsm is
    -- States Definition
    type state is (
        wait_s, load_s, start_first_s, routine_first_s,
        next_count_s, update_midh_s, start_second_s, routine_second_s,
        update_inner_s, start_third_s, routine_third_s,
        error_s, found_final_s, overflow_final_s
    );
    signal present_state : state;
    signal next_state : state;
begin
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
    
    
    
    future : process (present_state, start, busy_block_routine, valid_block_routine, nonce_tc, you_won) is begin
        case present_state is
        when wait_s =>
            if start = '1' then next_state <= load_s;
            else next_state <= wait_s;
            end if;
        when load_s =>
            next_state <= start_first_s;
        when start_first_s =>
            if busy_block_routine = '1' then next_state <= routine_first_s;
            else next_state <= start_first_s;
            end if;
        when routine_first_s =>
            if busy_block_routine = '1' then next_state <= routine_first_s;
            elsif valid_block_routine = '1' then next_state <= update_midh_s;
            else next_state <= error_s;
            end if;
            
        when next_count_s =>
            next_state <= start_second_s;
        when update_midh_s =>
            next_state <= start_second_s;
        when start_second_s =>
            if busy_block_routine = '1' then next_state <= routine_second_s;
            else next_state <= start_second_s;
            end if;
        when routine_second_s =>
            if busy_block_routine = '1' then next_state <= routine_second_s;
            elsif valid_block_routine = '1' then next_state <= update_inner_s;
            else next_state <= error_s;
            end if;
            
        when update_inner_s =>
            next_state <= start_third_s;
        when start_third_s =>
            if busy_block_routine = '1' then next_state <= routine_third_s;
            else next_state <= start_third_s;
            end if;
        when routine_third_s =>
            if busy_block_routine = '1' then next_state <= routine_third_s;
            elsif valid_block_routine = '0' then next_state <= error_s;
            elsif you_won = '1' then next_state <= found_final_s;
            elsif nonce_tc = '1' then next_state <= overflow_final_s;
            else next_state <= next_count_s;
            end if;
            
        when error_s =>
            if start = '1' then next_state <= load_s;
            else next_state <= error_s;
            end if;
        when found_final_s =>
            if start = '1' then next_state <= load_s;
            else next_state <= found_final_s;
            end if;
        when overflow_final_s =>
            if start = '1' then next_state <= load_s;
            else next_state <= overflow_final_s;
            end if;
            
        when others => -- There should be no other state,
        -- but in case of errors we simply go in error_s
            next_state <= error_s;
        end case;
    end process;
    
    
    
    outputs : process (present_state) is begin -- It's a Moore machine
        case present_state is
        when wait_s =>
            load_first_block <= '0';
            load_second_block_stem <= '0';
            load_start_nonce <= '0';
            load_difficulty <= '0';
            
            nonce_count_en <= '0';
            reset_nonce <= '0';
            
            update_mid_H <= '0';
            update_inner_hash <= '0';
            use_mid_H <= '0';
            use_inner_block <= '0';
            use_second_block <= '0';
            
            start_block_routine <= '0';
            busy <= '0';
            nonce_found <= '0';
            nonce_overflow <= '0';
            error <= '0';
            
        when load_s =>
            load_first_block <= '1';
            load_second_block_stem <= '1';
            load_start_nonce <= '1';
            load_difficulty <= '1';
            
            nonce_count_en <= '0';
            reset_nonce <= '0';
            
            update_mid_H <= '0';
            update_inner_hash <= '0';
            use_mid_H <= '0';
            use_inner_block <= '0';
            use_second_block <= '0';
            
            start_block_routine <= '0';
            busy <= '1';
            nonce_found <= '0';
            nonce_overflow <= '0';
            error <= '0';
            
        when start_first_s =>
            load_first_block <= '0';
            load_second_block_stem <= '0';
            load_start_nonce <= '0';
            load_difficulty <= '0';
            
            nonce_count_en <= '0';
            reset_nonce <= '0';
            
            update_mid_H <= '0';
            update_inner_hash <= '0';
            use_mid_H <= '0';
            use_inner_block <= '0';
            use_second_block <= '0';
            
            start_block_routine <= '1';
            busy <= '1';
            nonce_found <= '0';
            nonce_overflow <= '0';
            error <= '0';
            
        when routine_first_s =>
            load_first_block <= '0';
            load_second_block_stem <= '0';
            load_start_nonce <= '0';
            load_difficulty <= '0';
            
            nonce_count_en <= '0';
            reset_nonce <= '0';
            
            update_mid_H <= '0';
            update_inner_hash <= '0';
            use_mid_H <= '0';
            use_inner_block <= '0';
            use_second_block <= '0';
            
            start_block_routine <= '0';
            busy <= '1';
            nonce_found <= '0';
            nonce_overflow <= '0';
            error <= '0';
            
            
            
        when next_count_s =>
            load_first_block <= '0';
            load_second_block_stem <= '0';
            load_start_nonce <= '0';
            load_difficulty <= '0';
            
            nonce_count_en <= '1';
            reset_nonce <= '0';
            
            update_mid_H <= '0';
            update_inner_hash <= '0';
            use_mid_H <= '0';
            use_inner_block <= '0';
            use_second_block <= '0';
            
            start_block_routine <= '0';
            busy <= '1';
            nonce_found <= '0';
            nonce_overflow <= '0';
            error <= '0';
            
        when update_midh_s =>
            load_first_block <= '0';
            load_second_block_stem <= '0';
            load_start_nonce <= '0';
            load_difficulty <= '0';
            
            nonce_count_en <= '0';
            reset_nonce <= '1';
            
            update_mid_H <= '1';
            update_inner_hash <= '0';
            use_mid_H <= '0';
            use_inner_block <= '0';
            use_second_block <= '0';
            
            start_block_routine <= '0';
            busy <= '1';
            nonce_found <= '0';
            nonce_overflow <= '0';
            error <= '0';
            
        when start_second_s =>
            load_first_block <= '0';
            load_second_block_stem <= '0';
            load_start_nonce <= '0';
            load_difficulty <= '0';
            
            nonce_count_en <= '0';
            reset_nonce <= '0';
            
            update_mid_H <= '0';
            update_inner_hash <= '0';
            use_mid_H <= '1';
            use_inner_block <= '0';
            use_second_block <= '1';
            
            start_block_routine <= '1';
            busy <= '1';
            nonce_found <= '0';
            nonce_overflow <= '0';
            error <= '0';
            
        when routine_second_s =>
            load_first_block <= '0';
            load_second_block_stem <= '0';
            load_start_nonce <= '0';
            load_difficulty <= '0';
            
            nonce_count_en <= '0';
            reset_nonce <= '0';
            
            update_mid_H <= '0';
            update_inner_hash <= '0';
            use_mid_H <= '1';
            use_inner_block <= '0';
            use_second_block <= '1';
            
            start_block_routine <= '0';
            busy <= '1';
            nonce_found <= '0';
            nonce_overflow <= '0';
            error <= '0';
            
            
            
        when update_inner_s =>
            load_first_block <= '0';
            load_second_block_stem <= '0';
            load_start_nonce <= '0';
            load_difficulty <= '0';
            
            nonce_count_en <= '0';
            reset_nonce <= '0';
            
            update_mid_H <= '0';
            update_inner_hash <= '1';
            use_mid_H <= '0';
            use_inner_block <= '0';
            use_second_block <= '0';
            
            start_block_routine <= '0';
            busy <= '1';
            nonce_found <= '0';
            nonce_overflow <= '0';
            error <= '0';
            
        when start_third_s =>
            load_first_block <= '0';
            load_second_block_stem <= '0';
            load_start_nonce <= '0';
            load_difficulty <= '0';
            
            nonce_count_en <= '0';
            reset_nonce <= '0';
            
            update_mid_H <= '0';
            update_inner_hash <= '0';
            use_mid_H <= '0';
            use_inner_block <= '1';
            use_second_block <= '0';
            
            start_block_routine <= '1';
            busy <= '1';
            nonce_found <= '0';
            nonce_overflow <= '0';
            error <= '0';
            
        when routine_third_s =>
            load_first_block <= '0';
            load_second_block_stem <= '0';
            load_start_nonce <= '0';
            load_difficulty <= '0';
            
            nonce_count_en <= '0';
            reset_nonce <= '0';
            
            update_mid_H <= '0';
            update_inner_hash <= '0';
            use_mid_H <= '0';
            use_inner_block <= '1';
            use_second_block <= '0';
            
            start_block_routine <= '0';
            busy <= '1';
            nonce_found <= '0';
            nonce_overflow <= '0';
            error <= '0';
            
            
            
        when error_s =>
            load_first_block <= '0';
            load_second_block_stem <= '0';
            load_start_nonce <= '0';
            load_difficulty <= '0';
            
            nonce_count_en <= '0';
            reset_nonce <= '0';
            
            update_mid_H <= '0';
            update_inner_hash <= '0';
            use_mid_H <= '0';
            use_inner_block <= '0';
            use_second_block <= '0';
            
            start_block_routine <= '0';
            busy <= '0';
            nonce_found <= '0';
            nonce_overflow <= '0';
            error <= '1';
            
        when found_final_s =>
            load_first_block <= '0';
            load_second_block_stem <= '0';
            load_start_nonce <= '0';
            load_difficulty <= '0';
            
            nonce_count_en <= '0';
            reset_nonce <= '0';
            
            update_mid_H <= '0';
            update_inner_hash <= '0';
            use_mid_H <= '0';
            use_inner_block <= '0';
            use_second_block <= '0';
            
            start_block_routine <= '0';
            busy <= '0';
            nonce_found <= '1';
            nonce_overflow <= '0';
            error <= '0';
            
        when overflow_final_s =>
            load_first_block <= '0';
            load_second_block_stem <= '0';
            load_start_nonce <= '0';
            load_difficulty <= '0';
            
            nonce_count_en <= '0';
            reset_nonce <= '0';
            
            update_mid_H <= '0';
            update_inner_hash <= '0';
            use_mid_H <= '0';
            use_inner_block <= '0';
            use_second_block <= '0';
            
            start_block_routine <= '0';
            busy <= '0';
            nonce_found <= '0';
            nonce_overflow <= '1';
            error <= '0';
            
            
            
        when others => -- There should be no other state,
        -- but in case of errors we simply replicate the outpus of error_s
            load_first_block <= '0';
            load_second_block_stem <= '0';
            load_start_nonce <= '0';
            load_difficulty <= '0';
            
            nonce_count_en <= '0';
            reset_nonce <= '0';
            
            update_mid_H <= '0';
            update_inner_hash <= '0';
            use_mid_H <= '0';
            use_inner_block <= '0';
            use_second_block <= '0';
            
            start_block_routine <= '0';
            busy <= '0';
            nonce_found <= '0';
            nonce_overflow <= '0';
            error <= '1';
            
        end case;
    end process;
    
end Behavioral;
