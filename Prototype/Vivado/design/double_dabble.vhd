----------------------------------------------------------------------------------
-- Company: UPM student group
-- Engineer: Eduardo Palou de Comasema Jaume
-- 
-- Create Date: 04/28/2025 09:55:42 AM
-- Design Name: double_dabble_circuit
-- Module Name: double_dabble - Behavioral
-- Project Name: Double Dabble circuit
-- Target Devices: Pynq-Z2
-- Tool Versions: 2023.1
-- Description: 
-- Circuit that performs BCD conversion to binary signal.
-- 
-- Dependencies: 
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

entity double_dabble is
  Port (
    clk         : in std_logic; 
    reset       : in std_logic;
    --
    input       : in std_logic_vector(13 downto 0);
    --
    tens        : out std_logic_vector(3 downto 0);
    ones        : out std_logic_vector(3 downto 0);
    tenths      : out std_logic_vector(3 downto 0);
    hundreths   : out std_logic_vector(3 downto 0)  
   );
end double_dabble;

architecture Behavioral of double_dabble is

signal syn_d2, syn_q: std_logic_vector(13 downto 0);

signal reg0_q: std_logic_vector(29 downto 0);
signal reg0_en: std_logic;

signal mux0_s: std_logic;

signal shift_reg_d, shift_reg_q: std_logic_vector(29 downto 0);
signal shift_reg_load, shift_reg_en: std_logic;  

signal add3_tens, add3_ones, add3_tenths, add3_hundreths: std_logic;

signal add_y_tens: unsigned(3 downto 0);
signal add_y_ones: unsigned(3 downto 0);
signal add_y_tenths: unsigned(3 downto 0);
signal add_y_hundreths: unsigned(3 downto 0);
signal add_y: std_logic_vector(29 downto 0);

signal mux1_s, mux2_s, mux3_s, mux4_s: std_logic;

signal reg1_q: std_logic_vector(29 downto 0);
signal reg1_en: std_logic;

signal reg2_q: std_logic_vector(29 downto 0);
signal reg2_en: std_logic;

signal cnt: unsigned(3 downto 0); -- We need to perform 14 shifts
signal cnt_en: std_logic;

signal ready: std_logic;

type statetype is (S0, S1, S2, S3, S4, S5);
signal state, nextstate: statetype; 

-- 

signal shift_reg_tens, shift_reg_ones, shift_reg_tenths, shift_reg_hundreths: std_logic_vector(3 downto 0);

signal dbg_y_tens, dbg_y_ones, dbg_y_tenths, dbg_y_hundreths: std_logic_vector(3 downto 0);

begin

-- Notes: All registers are reset asynchronous

-- Synchronizer
process(clk, reset) begin
    if reset = '1' then 
        syn_d2 <= (others => '0');
        syn_q <= (others => '0');
    elsif rising_edge(clk) then 
        syn_d2 <= input;
        syn_q <= syn_d2;
    end if;
end process;

-- Register 0 
process(clk, reset) begin 
    if reset = '1' then
        reg0_q <= (others => '0');
    elsif rising_edge(clk) then 
        if reg0_en = '1' then 
            reg0_q <= (29 downto 14 => '0') & syn_q;
        end if;
    end if;
end process;

-- Multiplexer 0 
with mux0_s select shift_reg_d <=
    reg0_q          when '1',
    reg1_q          when others;
     
-- Shift register with parallel load
process(clk, reset) begin
    if reset = '1' then 
        shift_reg_q <= (others => '0');
    elsif rising_edge(clk) then
        if shift_reg_en = '1' then  
            if shift_reg_load = '1' then 
                shift_reg_q <= shift_reg_d;
            else 
                if ready = '0' then
                    shift_reg_q <= shift_reg_q(28 downto 0) & '0';
                end if;
            end if;
        end if;
    end if;
end process;

-- Rename signals
shift_reg_tens      <= shift_reg_q(29 downto 26);
shift_reg_ones      <= shift_reg_q(25 downto 22);
shift_reg_tenths    <= shift_reg_q(21 downto 18);
shift_reg_hundreths <= shift_reg_q(17 downto 14);

-- Comparators
add3_tens      <= '1' when shift_reg_tens       >= "0101" else '0';
add3_ones      <= '1' when shift_reg_ones       >= "0101" else '0';
add3_tenths    <= '1' when shift_reg_tenths     >= "0101" else '0';
add3_hundreths <= '1' when shift_reg_hundreths  >= "0101" else '0';

mux1_s <= add3_tens;
mux2_s <= add3_ones;
mux3_s <= add3_tenths;
mux4_s <= add3_hundreths;

-- Adder
add_y_tens <= unsigned(shift_reg_tens) + 3;
add_y_ones <= unsigned(shift_reg_ones) + 3;
add_y_tenths <= unsigned(shift_reg_tenths) + 3;
add_y_hundreths <= unsigned(shift_reg_hundreths) + 3;

-- Multiplexers (1-4)
with mux1_s select add_y(29 downto 26) <=
    std_logic_vector(add_y_tens)               when '1',
    shift_reg_tens                             when others; 

with mux2_s select add_y(25 downto 22) <=
    std_logic_vector(add_y_ones)               when '1',
    shift_reg_ones                             when others; 
    
with mux3_s select add_y(21 downto 18) <=
    std_logic_vector(add_y_tenths)             when '1',
    shift_reg_tenths                           when others; 
    
with mux4_s select add_y(17 downto 14) <=
    std_logic_vector(add_y_hundreths)          when '1',
    shift_reg_hundreths                        when others; 

add_y(13 downto 0) <= shift_reg_q(13 downto 0);

-- Rename signals
dbg_y_tens      <= add_y(29 downto 26);
dbg_y_ones      <= add_y(25 downto 22);
dbg_y_tenths    <= add_y(21 downto 18);
dbg_y_hundreths <= add_y(17 downto 14);

-- Register 1
process(clk, reset) begin 
    if reset = '1' then 
        reg1_q <= (others => '0');
    elsif rising_edge(clk) then
        if reg1_en = '1' then   
            reg1_q <= add_y;
        end if;
    end if;
end process;

-- Register 2
process(clk, reset) begin
    if reset = '1' then 
        reg2_q <= (others => '0');
    elsif rising_edge(clk) then
        if reg2_en = '1' then 
            reg2_q <= shift_reg_q(29 downto 0);
        end if; 
    end if;
end process;

-- output
tens        <= reg2_q(29 downto 26);
ones        <= reg2_q(25 downto 22);
tenths      <= reg2_q(21 downto 18);
hundreths   <= reg2_q(17 downto 14);

-- Counter
process(clk, reset) begin
    if reset = '1' then 
        cnt <= (others => '0');
    elsif rising_edge(clk) then 
        if cnt_en = '1' then 
            if cnt < 14 then 
                cnt <= cnt + 1;
            else 
                cnt <= (others => '0');
            end if;
        end if;
    end if;
end process; 

ready <= '1' when cnt = 14 else '0';

--- Double Dabble FSM (Moore FSM)

-- state register
process(clk, reset) begin
    if reset = '1' then 
        state <= S0;
    elsif rising_edge(clk) then 
        state <= nextstate;
    end if;    
end process;

-- next state logic
process(state) begin
    case state is
        when S0 =>
            nextstate <= S1;        
        when S1 =>
            nextstate <= S2;
        when S2 => 
            if ready = '0' then
                nextstate <= S3;
            else 
                nextstate <= S5;
            end if;
        when S3 => 
            nextstate <= S4;
        when S4 =>
                nextstate <= S2;
        when S5 => 
            nextstate <= S0; 
        when others =>
            nextstate <= S0;
    end case;
end process;

-- output logic (Combinational logic)
reg0_en         <= '1' when state = S0 else '0';
mux0_s          <= '1' when state = S1 else '0';
shift_reg_load  <= '1' when (state = S1 or state = S4) and ready = '0' else '0';
shift_reg_en    <= '1' when state = S1 or state = S2 or state = S4 else '0';
cnt_en          <= '1' when state = S2 else '0';
reg1_en         <= '1' when state = S3 else '0';
reg2_en         <= '1' when state = S5 else '0';

end Behavioral;
