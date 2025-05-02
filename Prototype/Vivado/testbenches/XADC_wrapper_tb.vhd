----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2025 12:34:14 PM
-- Design Name: 
-- Module Name: XADC_wrapper_tb - Behavioral
-- Project Name: 
-- Target Devices: 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity XADC_wrapper_tb is
--  Port ( );
end XADC_wrapper_tb;

architecture Behavioral of XADC_wrapper_tb is

component XADC_wrapper
    Port (
        clk: in std_logic;
        reset: in std_logic;
        ---
        vauxp1: in std_logic;
        vauxn1: in std_logic;
        ---
        tens: out std_logic_vector(3 downto 0);
        ones: out std_logic_vector(3 downto 0);
        tenths: out std_logic_vector(3 downto 0);
        hundreths: out std_logic_vector(3 downto 0)
     );
end component;

---

constant CLK_PERIOD : time := 8 ns;

signal clk, reset, vauxp1, vauxn1: std_logic;

signal tens, ones, tenths, hundreths: std_logic_vector(3 downto 0);

begin

dut: XADC_wrapper
    Port Map (
        clk => clk,
        reset => reset,
        vauxp1 => vauxp1,
        vauxn1 => vauxn1,
        tens => tens,
        ones => ones,
        tenths => tenths,
        hundreths => hundreths
     );
    
clk_stimuli : process
    begin
        clk <= '1';
        wait for CLK_PERIOD/2;
        clk <= '0';
        wait for CLK_PERIOD/2;
    end process;


dut_stimuli : process
    begin
        reset <= '1';
        vauxp1 <= '0';
        vauxn1 <= '0';
        wait for CLK_PERIOD;
        
        reset <= '0';
        wait;
    end process;
end Behavioral;
