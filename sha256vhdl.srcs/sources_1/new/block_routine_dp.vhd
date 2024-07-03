----------------------------------------------------------------------------------
-- Company: University of Trento
-- Engineer: Alex Pegoraro
-- 
-- Create Date: 24.05.2024 14:29:32
-- Design Name: block_routine_dp
-- Module Name: block_routine_dp - Behavioral
-- Project Name: sha256vhdl
-- Target Devices: FPGA
-- Tool Versions: 
-- Description: the datapath part of the 64-cycles routine each block will encounter.
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD.ALL, work.register_file, work.register_update,
-- work.ripple_carry_adder, work.word_shift_register, work.next_block
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

entity block_routine_dp is
    generic ( word_size : natural := 32 );
    Port (
        -- Control Signals
        clk : in std_logic;
        res : in std_logic; -- active low
        
        load_external_H : in std_logic;
        load_external_abcdefgh : in std_logic;
        update_abcdefgh : in std_logic;
        
        reset_k : in std_logic;
        shift_k : in std_logic;
        
        load_external_m_block : in std_logic;
        shift_w : in std_logic;
        
        -- Data Inputs:
        H_input : in unsigned ( (word_size * 8)-1 downto 0); -- (word_size * H_number)-1 downto 0
        m_block : in unsigned ( (word_size * 16)-1 downto 0); -- (word_size * w_number)-1 downto 0
        
        -- Output:
        H_output : out unsigned ( (word_size * 8)-1 downto 0) -- (word_size * H_number)-1 downto 0
    );
end block_routine_dp;

architecture Behavioral of block_routine_dp is
    -- Constants
    constant H_number : natural := 8;
    constant k_number : natural := 64;
    constant w_number : natural := 16;
    constant full_k : unsigned ( (word_size * k_number)-1 downto 0 ) :=
        x"428a2f98" & x"71374491" & x"b5c0fbcf" & x"e9b5dba5" & x"3956c25b" & x"59f111f1" & x"923f82a4" & x"ab1c5ed5" &
        x"d807aa98" & x"12835b01" & x"243185be" & x"550c7dc3" & x"72be5d74" & x"80deb1fe" & x"9bdc06a7" & x"c19bf174" &
        x"e49b69c1" & x"efbe4786" & x"0fc19dc6" & x"240ca1cc" & x"2de92c6f" & x"4a7484aa" & x"5cb0a9dc" & x"76f988da" &
        x"983e5152" & x"a831c66d" & x"b00327c8" & x"bf597fc7" & x"c6e00bf3" & x"d5a79147" & x"06ca6351" & x"14292967" &
        x"27b70a85" & x"2e1b2138" & x"4d2c6dfc" & x"53380d13" & x"650a7354" & x"766a0abb" & x"81c2c92e" & x"92722c85" &
        x"a2bfe8a1" & x"a81a664b" & x"c24b8b70" & x"c76c51a3" & x"d192e819" & x"d6990624" & x"f40e3585" & x"106aa070" &
        x"19a4c116" & x"1e376c08" & x"2748774c" & x"34b0bcb5" & x"391c0cb3" & x"4ed8aa4a" & x"5b9cca4f" & x"682e6ff3" &
        x"748f82ee" & x"78a5636f" & x"84c87814" & x"8cc70208" & x"90befffa" & x"a4506ceb" & x"bef9a3f7" & x"c67178f2"
    ; -- K[0] is x"428a2f98", while K[63] is x"c67178f2
--    constant reverse_full_k : unsigned ( (word_size * k_number)-1 downto 0 ) :=
--        x"c67178f2" & x"bef9a3f7" & x"a4506ceb" & x"90befffa" & x"8cc70208" & x"84c87814" & x"78a5636f" & x"748f82ee" &
--        x"682e6ff3" & x"5b9cca4f" & x"4ed8aa4a" & x"391c0cb3" & x"34b0bcb5" & x"2748774c" & x"1e376c08" & x"19a4c116" &
--        x"106aa070" & x"f40e3585" & x"d6990624" & x"d192e819" & x"c76c51a3" & x"c24b8b70" & x"a81a664b" & x"a2bfe8a1" &
--        x"92722c85" & x"81c2c92e" & x"766a0abb" & x"650a7354" & x"53380d13" & x"4d2c6dfc" & x"2e1b2138" & x"27b70a85" &
--        x"14292967" & x"06ca6351" & x"d5a79147" & x"c6e00bf3" & x"bf597fc7" & x"b00327c8" & x"a831c66d" & x"983e5152" &
--        x"76f988da" & x"5cb0a9dc" & x"4a7484aa" & x"2de92c6f" & x"240ca1cc" & x"0fc19dc6" & x"efbe4786" & x"e49b69c1" &
--        x"c19bf174" & x"9bdc06a7" & x"80deb1fe" & x"72be5d74" & x"550c7dc3" & x"243185be" & x"12835b01" & x"d807aa98" &
--        x"ab1c5ed5" & x"923f82a4" & x"59f111f1" & x"3956c25b" & x"e9b5dba5" & x"b5c0fbcf" & x"71374491" & x"428a2f98"
--    ; -- K[0] is x"428a2f98", while K[63] is x"c67178f2"
    
    -- Connection Signals
    signal buffered_H_input : unsigned ( (word_size * H_number)-1 downto 0);
    signal abcdefgh : unsigned ( (word_size * H_number)-1 downto 0);
    signal input_abcdefgh : unsigned ( (word_size * H_number)-1 downto 0);
    signal next_abcdefgh : unsigned ( (word_size * H_number)-1 downto 0);
    signal actual_w : unsigned (word_size-1 downto 0);
    signal actual_k : unsigned (word_size-1 downto 0);
    
    signal w_previous_2 : unsigned (word_size-1 downto 0);
    signal w_previous_7 : unsigned (word_size-1 downto 0);
    signal w_previous_15 : unsigned (word_size-1 downto 0);
    signal w_previous_16 : unsigned (word_size-1 downto 0);
    signal full_w : unsigned ( (word_size * w_number)-1 downto 0);
    signal next_w : unsigned (word_size-1 downto 0);
    
begin
    -- Management of abcdefgh and H
    
    reg_H : entity work.register_file generic map (word_size=>word_size, word_number=>H_number) port map( clk=>clk, res=>res, load_en=>load_external_H, H_in=>H_input, H_out=>buffered_H_input );
    
    input_abcdefgh <= next_abcdefgh when load_external_abcdefgh = '0' else H_input;
    
    reg_abcdefgh : entity work.register_file generic map (word_size=>word_size, word_number=>H_number) port map( clk=>clk, res=>res, load_en=>update_abcdefgh, H_in=>input_abcdefgh, H_out=>abcdefgh );
    
    register_update : entity work.register_update generic map (word_size=>word_size) port map(
        a_in=>abcdefgh( (word_size*8)-1 downto (word_size*7) ), b_in=>abcdefgh( (word_size*7)-1 downto (word_size*6) ),
        c_in=>abcdefgh( (word_size*6)-1 downto (word_size*5) ), d_in=>abcdefgh( (word_size*5)-1 downto (word_size*4) ),
        e_in=>abcdefgh( (word_size*4)-1 downto (word_size*3) ), f_in=>abcdefgh( (word_size*3)-1 downto (word_size*2) ),
        g_in=>abcdefgh( (word_size*2)-1 downto word_size ), h_in=>abcdefgh( word_size - 1 downto 0 ),
        w=>actual_w, k=>actual_k,
        a_out=>next_abcdefgh( (word_size*8)-1 downto (word_size*7) ), b_out=>next_abcdefgh( (word_size*7)-1 downto (word_size*6) ),
        c_out=>next_abcdefgh( (word_size*6)-1 downto (word_size*5) ), d_out=>next_abcdefgh( (word_size*5)-1 downto (word_size*4) ),
        e_out=>next_abcdefgh( (word_size*4)-1 downto (word_size*3) ), f_out=>next_abcdefgh( (word_size*3)-1 downto (word_size*2) ),
        g_out=>next_abcdefgh( (word_size*2)-1 downto word_size ), h_out=>next_abcdefgh( word_size - 1 downto 0 )
    );
    
    output_adders : for i in 0 to H_number-1 generate
        adder : entity work.ripple_carry_adder generic map (dim=>word_size) port map( a=>buffered_H_input( ( word_size*(i+1) )-1 downto word_size*i ), b=>abcdefgh( ( word_size*(i+1) )-1 downto word_size*i ), cin=>'0', s=>H_output( ( word_size*(i+1) )-1 downto word_size*i) ); -- no need for cout
    end generate output_adders;
    
    -- Management of K
    
    reg_k : entity work.word_shift_register generic map (word_size=>word_size, word_number=>k_number) port map( clk=>clk, res=>res, parallel_en=>reset_k, shift_en=>shift_k, serial_in=>actual_k, serial_out=>actual_k, parallel_in=>full_k ); -- no need for parallel_out
    
    -- Management of W
    
    reg_w : entity work.word_shift_register generic map (word_size=>word_size, word_number=>w_number) port map( clk=>clk, res=>res, parallel_en=>load_external_m_block, shift_en=>shift_w, serial_in=>next_w, serial_out=>actual_w, parallel_in=>m_block, parallel_out=>full_w );
    -- If word_shift_register shifts right
--    w_previous_2 <= full_w( ( (14+1)*word_size )-1 downto 14*word_size ); -- the w previous 2 respect to next one (17th in the reg_w) is 15th in reg_w, i.e. the one in index 14.
--    w_previous_7 <= full_w( ( (9+1)*word_size )-1 downto 9*word_size ); -- the w previous 7 respect to next one (17th in the reg_w) is 10th in reg_w, i.e. the one in index 9.
--    w_previous_15 <= full_w( ( (1+1)*word_size )-1 downto 1*word_size ); -- the w previous 15 respect to next one (17th in the reg_w) is 2nd in reg_w, i.e. the one in index 1.
--    w_previous_16 <= full_w( word_size-1 downto 0 ); -- the w previous 16 respect to next one (17th in the reg_w) is 1st in reg_w, i.e. the one in index 0.
    -- If word_shift_register shifts left
    w_previous_2 <= full_w( ( (1+1)*word_size )-1 downto 1*word_size ); -- the w previous 2 respect to next one (0th in the reg_w) is 2nd in reg_w, i.e. the one in index 1.
    w_previous_7 <= full_w( ( (6+1)*word_size )-1 downto 6*word_size ); -- the w previous 7 respect to next one (0th in the reg_w) is 7th in reg_w, i.e. the one in index 6.
    w_previous_15 <= full_w( ( (14+1)*word_size )-1 downto 14*word_size ); -- the w previous 15 respect to next one (0th in the reg_w) is 15th in reg_w, i.e. the one in index 14.
    w_previous_16 <= full_w( ( (15+1)*word_size )-1 downto 15*word_size ); -- the w previous 16 respect to next one (0th in the reg_w) is 16th in reg_w, i.e. the one in index 15.
    
    next_block : entity work.next_block generic map (word_size=>word_size) port map( w_previous_2=>w_previous_2, w_previous_7=>w_previous_7, w_previous_15=>w_previous_15, w_previous_16=>w_previous_16, w_actual=>next_w );
    -- note: what is actual w from this block's perspective is the next one for the global perspective.
    
end Behavioral;
