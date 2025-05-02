----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2025 12:33:48 PM
-- Design Name: 
-- Module Name: XADC_wrapper - Behavioral
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

entity XADC_wrapper is
    Port (
        clk:  in std_logic;
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
end XADC_wrapper;

architecture Behavioral of XADC_wrapper is

component xadc_wiz_0
  Port (
    di_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    daddr_in : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    den_in : IN STD_LOGIC;
    dwe_in : IN STD_LOGIC;
    drdy_out : OUT STD_LOGIC;
    do_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    dclk_in : IN STD_LOGIC;
    reset_in : IN STD_LOGIC;
    vp_in : IN STD_LOGIC;
    vn_in : IN STD_LOGIC;
    vauxp1 : IN STD_LOGIC;
    vauxn1 : IN STD_LOGIC;
    channel_out : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    eoc_out : OUT STD_LOGIC;
    alarm_out : OUT STD_LOGIC;
    eos_out : OUT STD_LOGIC;
    busy_out : OUT STD_LOGIC 
  );
end component;

---

component FSM_DRP
  Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        ---
        output : out std_logic_vector(11 downto 0); 
        -- DRP interface
        den : out STD_LOGIC;
        daddr : out STD_LOGIC_VECTOR (6 downto 0);
        di : out STD_LOGIC_VECTOR (15 downto 0);
        do : in STD_LOGIC_VECTOR (15 downto 0);
        drdy : in STD_LOGIC;
        dwe : out STD_LOGIC
  );
end component;

---

component Frequency_counter
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
end component;

--- 

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

--- 

signal di: std_logic_vector(15 downto 0);
signal daddr: std_logic_vector(6 downto 0);
signal den: std_logic; 
signal dwe: std_logic;
signal drdy: std_logic; 
signal do: std_logic_vector(15 downto 0);

signal dig: std_logic_vector(11 downto 0); 

signal bin: std_logic_vector(13 downto 0);

begin

XADC_inst : xadc_wiz_0
  PORT MAP (
    di_in => di,
    daddr_in => daddr,
    den_in => den,
    dwe_in => dwe,
    drdy_out => drdy,
    do_out => do,
    dclk_in => clk,
    reset_in => reset,
    vp_in => '0',
    vn_in => '0',
    vauxp1 => vauxp1,
    vauxn1 => vauxn1,
    channel_out => open,
    eoc_out => open,
    alarm_out => open,
    eos_out => open,
    busy_out => open
  );
  
controller_inst : FSM_DRP
    PORT MAP (
        clk => clk, 
        reset => reset,
        output => dig,
        den => den,
        daddr => daddr,
        di => di,
        do => do,
        drdy => drdy,
        dwe => dwe
    ); 
    
frequency_counter_inst : Frequency_counter
    PORT MAP (
        clk => clk, 
        reset => reset,
        input => dig,
        output => bin
    ); 
    
bin2bcd: double_dabble
    PORT MAP (
        clk => clk, 
        reset => reset,
        input => bin,
        tens  => tens,
        ones  => ones,
        tenths => tenths,
        hundreths   => hundreths     
    );
      
    
end Behavioral;
