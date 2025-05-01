----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2025 09:56:07 AM
-- Design Name: 
-- Module Name: double_dabble_tb - Behavioral
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

entity double_dabble_tb is
--  Port ( );
end double_dabble_tb;

architecture Behavioral of double_dabble_tb is

component double_dabble is
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
end component;

--

constant CLK_PERIOD: time := 10ns;

--
signal clk, reset: std_logic;

signal input: std_logic_vector(13 downto 0);

signal tens, ones, tenths, hundreths: std_logic_vector(3 downto 0); 

begin

dut: double_dabble
    port map(
        clk         => clk,
        reset       => reset,
        input       => input,
        tens        => tens,
        ones        => ones,
        tenths      => tenths,
        hundreths   => hundreths
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
        input <= "10011100001111";
        wait for CLK_PERIOD;
        reset <= '0';
        wait;
    end process;

end Behavioral;
