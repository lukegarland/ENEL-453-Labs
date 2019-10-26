library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Lab4_Wave_Gen is
    Port ( 	
			clk                           	: in  std_logic;
			reset                         	: in  std_logic;
			DAC_1_Out						: out std_logic;
			DAC_2_Out						: out std_logic
         );
           
end Lab4_Wave_Gen;


architecture Behaviour of Lab4_Wave_Gen is 

	component voltmeter is 
	Port ( 	
			clk                           	: in  STD_LOGIC;
			reset                         	: in  STD_LOGIC;
			value_output                   	: out STD_LOGIC_VECTOR (11 downto 0);
			HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 	: out STD_LOGIC_VECTOR (7 downto 0);
			voltage_mode							: in STD_LOGIC;
			shortEnable								: in STD_LOGIC
         );
           
	end component;
	


begin 



Distance_Measurer: 	voltmeter
					port map(
							clk				=>	clk,
							reset           =>	reset,             
							value_output    =>	open,             
							HEX0			=>	open,
							HEX1			=>	open,
							HEX2			=>	open,
							HEX3			=>	open,
							HEX4			=>	open,
							HEX5			=>	open,
							voltage_mode	=>	'1',			
							shortEnable		=>	'0'			
						
					);



end Behaviour;