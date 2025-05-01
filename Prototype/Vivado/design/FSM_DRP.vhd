----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2025 12:51:26 PM
-- Design Name: 
-- Module Name: FSM_DRP - Behavioral
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

entity FSM_DRP is
    generic (
        C_CHANNEL_ADDR : std_logic_vector(6 downto 0) := "0010001"
    );
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
end FSM_DRP;

architecture Behavioral of FSM_DRP is

type statetype is (S0, S1);
signal state, nextstate: statetype;
---
signal q: std_logic_vector(11 downto 0);

begin

-- FSM (Moore FSM)
-- Outputs depend only on the current state machine

-- state register
process(clk, reset) begin
    if reset = '1' then   state <= S0;
    elsif rising_edge(clk) then state <= nextstate;
    end if;
end process;  

-- next state logic
process(drdy, state) begin 
    case state is 
        when S0 => 
            nextstate <= S1;
        when S1 => 
            if drdy = '1' then nextstate <= S0;
            else               nextstate <= S1;
            end if;
        when others =>
            nextstate <= S0;
    end case;
end process;

-- register
process(clk) begin
    if rising_edge(clk) then
        if reset = '1' then q <= (others => '0');
        elsif drdy ='1' then
            q <= do(15 downto 4);
        end if;
    end if;
end process;

-- combinational logic
daddr <= C_CHANNEL_ADDR;
den   <= '1' when state = S0 else '0';
dwe   <= '0';
output <= q;

end Behavioral;
