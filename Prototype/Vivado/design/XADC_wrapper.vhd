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
use IEEE.NUMERIC_STD.ALL;

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
        selector        : out std_logic_vector (3 downto 0);  
        segments        : out std_logic_vector (7 downto 0)
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

--se�ales tens, ones, tenths y hundreds
signal tens        : std_logic_vector(3 downto 0);
signal ones        : std_logic_vector(3 downto 0);
signal tenths      : std_logic_vector(3 downto 0);
signal hundreths   : std_logic_vector(3 downto 0);

signal tens_seg        : std_logic_vector(7 downto 0);
signal ones_seg        : std_logic_vector(7 downto 0);
signal tenths_seg      : std_logic_vector(7 downto 0);
signal hundreths_seg   : std_logic_vector(7 downto 0);

--se�ales active_display 
signal act_disp: std_logic_vector(3 downto 0);

signal cnt: unsigned(24 downto 0);
signal en: std_logic;

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

--> Display Logic <--
    
-- Frequency divider 
process(clk, reset) begin
    if reset = '1' then 
        cnt <= (others => '0');
    elsif rising_edge(clk) then 
        if cnt < 125000 then 
            cnt <= cnt + 1;
        else 
            cnt <= (others => '0');
        end if;
    end if;
end process;

en <= '1' when cnt = 125000 else '0';

-- Shift register
process(clk, reset) begin
    if reset = '1' then 
        act_disp <= "0001";
    elsif rising_edge(clk) then
        if en = '1' then  
            act_disp <= act_disp(2 downto 0) & act_disp(3);
        end if;
    end if;
end process;

-- We assume common anode in the 7 segment display.
tens_seg <= "10000001" when tens = "0000" else
    "11001111" when tens = "0001" else
    "10010010" when tens = "0010" else
    "10000110" when tens = "0011" else
    "11001100" when tens = "0100" else
    "10100100" when tens = "0101" else
    "10100000" when tens = "0110" else
    "10001111" when tens = "0111" else
    "10000000" when tens = "1000" else
    "10000100" when tens = "1001" else
    "00000000";

-- This display should include the point
ones_seg <= "00000001" when ones = "0000" else
    "01001111" when ones = "0001" else
    "00010010" when ones = "0010" else
    "00000110" when ones = "0011" else
    "01001100" when ones = "0100" else
    "00100100" when ones = "0101" else
    "00100000" when ones = "0110" else
    "00001111" when ones = "0111" else
    "00000000" when ones = "1000" else
    "00000100" when ones = "1001" else
    "00000000";
    
tenths_seg <= "10000001" when tenths = "0000" else
    "11001111" when tenths = "0001" else
    "10010010" when tenths = "0010" else
    "10000110" when tenths = "0011" else
    "11001100" when tenths = "0100" else
    "10100100" when tenths = "0101" else
    "10100000" when tenths = "0110" else
    "10001111" when tenths = "0111" else
    "10000000" when tenths = "1000" else
    "10000100" when tenths = "1001" else
    "00000000";  
    
 hundreths_seg <= "10000001" when hundreths = "0000" else
    "11001111" when hundreths = "0001" else
    "10010010" when hundreths = "0010" else
    "10000110" when hundreths = "0011" else
    "11001100" when hundreths = "0100" else
    "10100100" when hundreths = "0101" else
    "10100000" when hundreths = "0110" else
    "10001111" when hundreths = "0111" else
    "10000000" when hundreths = "1000" else
    "10000100" when hundreths = "1001" else
    "00000000";
    
segments <= tens_seg when act_disp = "1000" else 
            ones_seg when act_disp = "0100" else 
            tenths_seg when act_disp = "0010" else
            hundreths_seg when act_disp = "0001" else
            "00000000";
            
selector <= act_disp;
            
end Behavioral;
