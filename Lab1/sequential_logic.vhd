-- --- from lab instructions from pages 8 and 9
-- --- from lab instructions from pages 8 and 9
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity switch_logic is
    Port ( 
           switches_inputs : in STD_LOGIC_VECTOR (2 downto 0);
           outputs : out STD_LOGIC_VECTOR (2 downto 0);
           clk : in STD_LOGIC;
           reset : in STD_LOGIC
           );
end switch_logic;

architecture Behavioral of switch_logic is
  -- Internal signals: 
  signal W_int: std_logic; 
  signal W, V, V_del: std_logic; 
  signal A, B, C: std_logic;

begin
  -- Combinational logic! Note that "<=" is an assignment operator
  W_int <= ((not B) and A) or ((not A) and B); -- models XOR
  
  
  -- ADD logic for signals (W and V)
  W <= W_int;
  V <= C and W_int;
  
  -- Assign the outputs. We only have one signal for now 
  outputs(0) <= W;
  outputs(1) <= W_int;
  outputs(2) <= V_del; -- We will connect this later
  
  
  -- Get the inputs from the slide switches on the FPGA board 
  A <= switches_inputs(0);
  B <= switches_inputs(1);
  C <= switches_inputs(2);
  
	logic_of_switches: process(clk, reset) -- sensitivity list
	begin 
	
    if (reset='1') then
	 -- Resets V_del to a known state
		V <= '0';
		V_del<='0';
		
    elsif (rising_edge(clk)) then
	 -- Assign logic to V_del here
		V <= W_int and C;
		V_del <= V;
    end if;
	 
	end process;
end Behavioral;
