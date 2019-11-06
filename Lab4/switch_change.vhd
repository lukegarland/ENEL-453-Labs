library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity switch_change is
    Port ( 	
			clk                        : in std_logic;
			reset                      : in std_logic;
			freq_up							: in std_logic;
			freq_dn							: in std_logic;
			amp_up							: in std_logic;
			amp_dn							: in std_logic;
			freq_up_pulse					: out std_logic;
			freq_dn_pulse					: out std_logic;
			amp_up_pulse					: out std_logic;
			amp_dn_pulse					: out std_logic
         );
           
end switch_change;
		   
architecture Behaviour of switch_change is 

signal amp_up_1 : std_logic;
signal amp_up_2 : std_logic;
signal amp_dn_1 : std_logic;
signal amp_dn_2 : std_logic;
signal freq_up_1 : std_logic;
signal freq_up_2 : std_logic;
signal freq_dn_1 : std_logic;
signal freq_dn_2 : std_logic;

begin


edge_and_level_detector : process(clk, reset)
begin
  if(reset='1') then
    amp_up_1        <= '0';
    amp_up_2        <= '0';
	amp_dn_1		<= '0';
	amp_dn_2		<= '0';
	freq_up_1        <= '0';
    freq_up_2        <= '0';
	freq_dn_1		<= '0';
	freq_dn_2		<= '0';
	
  elsif(rising_edge(clk)) then
	-- shift values 
    amp_up_1           <= amp_up;
    amp_up_2           <= amp_up_1;
	amp_dn_1           <= amp_dn;
    amp_dn_2           <= amp_dn_1;
    freq_up_1          <= freq_up;
    freq_up_2          <= freq_up_1;
	freq_dn_1          <= freq_dn;
    freq_dn_2          <= freq_dn_1;


end if;
  
end process edge_and_level_detector;

-- pulse 1 if most recent value is 1 and second most recent is 0 (detect rising edge)
amp_up_pulse        <= (not amp_up_2) and amp_up_1; 
amp_dn_pulse        <= (not amp_dn_2) and amp_dn_1; 

-- pulse 1 if most recent value is different to second most recent (detect change)
freq_up_pulse		<= freq_up_2 xor freq_up_1;
freq_dn_pulse		<= freq_dn_2 xor freq_dn_1;



end Behaviour;