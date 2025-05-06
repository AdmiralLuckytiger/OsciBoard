----------------------------------------------------------------------------------
-- Company: UPM Student group
-- Engineer: Eduardo Palou de Comasema Jaume
-- 
-- Create Date: 04/27/2025 12:53:07 PM
-- Design Name: 
-- Module Name: Frequency_counter - Behavioral
-- Project Name: 
-- Target Devices: Pynq Z2
-- Tool Versions: 
-- Description: 
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

entity Frequency_counter is
    Port (
        -- 
        -- If we are measuring the frecuency (~10kHz) with a resolution of two decimal
        -- we will use a 10Hz clock signal. (Frequency counter - logic)
        clk: in std_logic; 
        reset: in std_logic;
        --
        input: in std_logic_vector(15 downto 4);
        --
        output: out std_logic_vector(13 downto 0)
        );
end Frequency_counter;

architecture Behavioral of Frequency_counter is

signal sqr_in: std_logic;

signal cnt_f: unsigned(13 downto 0);
signal cnt_r: std_logic;

signal cnt: unsigned(24 downto 0);

signal reg: std_logic_vector(13 downto 0);
signal en: std_logic;

signal q: std_logic;
signal r_edge: std_logic;

begin

-- For generating a frequency counter we 
-- generate a square signal
 
-- Comparator
sqr_in <= '1' when (input > "011111111111") else '0';

-- Counter
process(clk, reset) begin
    if reset = '1' then                         
        cnt_f <= (others => '0');
    elsif rising_edge(clk) then  
        if cnt_r = '1' then 
            cnt_f <= (others => '0');
        elsif r_edge = '1' then            
            cnt_f <= cnt_f + 1;
        end if;
    end if;
end process;

-- Rising edge detector
process(clk, reset) begin
    if reset = '1' then 
        q <= '0';
    elsif rising_edge(clk) then 
        q <= sqr_in;
    end if;
end process;

r_edge <= '1' when q /= sqr_in and q = '0' else '0';

-- Register
process(clk, reset) begin
    if reset = '1' then 
        reg <= (others => '0');
    elsif rising_edge(clk) then 
        if en = '1' then
            reg <= std_logic_vector(cnt_f);
        end if;
    end if;
end process;

-- Frequency divider (counter)
process(clk, reset) begin
    if reset = '1' then 
        cnt <= (others => '0');
    elsif rising_edge(clk) then 
        if cnt < 12500000 then 
            cnt <= cnt + 1;
        else 
            cnt <= (others => '0');
        end if;
    end if;
end process;

en <= '1' when cnt = 12500000 else '0';
cnt_r <= en;

-- Combinational logic
output <= reg;
 
end Behavioral;
