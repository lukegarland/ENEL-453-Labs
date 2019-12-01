library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Synchronize_inputs is
    Port ( 	
			clk                        	: in std_logic;
			reset                      	: in std_logic;
			AM_FM_Select				: in std_logic;	
		
			reset_sync                 	: inout std_logic;
			AM_FM_Select_sync			: out std_logic

         );
           
end Synchronize_inputs;


architecture Behaviour of Synchronize_inputs is 


component sync_registers is 
	generic(bits : integer := 1;
			num_of_registers: integer := 2);
	Port (
			clk      : in  std_logic;
			reset    : in  std_logic;
			enable   : in  std_logic;
			d_input  : in  std_logic_vector(bits-1 downto 0);
			q_output : out std_logic_vector(bits-1 downto 0)	
	);

end component;





begin


sync_reset: sync_registers
	generic map(bits => 1,
				num_of_registers=>2)
	port map (
		 clk      	=> clk,
		 reset    	=> reset,
		 enable   	=> '1',
		 d_input(0)	=> reset,
		 q_output(0) 	=> reset_sync
);

sync_amp_freq_select: sync_registers
	generic map(bits => 1,
				num_of_registers=>2)
	port map (
		 clk   	   		=> clk,
		 reset  		=> reset_sync,
		 enable   		=> '1',
		 d_input(0)		=> AM_FM_Select,
		 q_output(0)	=> AM_FM_Select_sync
);



end Behaviour;